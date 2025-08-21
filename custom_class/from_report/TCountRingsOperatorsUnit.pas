 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            ����� ��� �������� ���-�� ������� ����������                   ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TCountRingsOperatorsUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, TAbstractReportUnit,
  Data.Win.ADODB, Data.DB, System.DateUtils;

   // class TStructInfo
  type
    TStructInfo = class
     public
       m_date_time   : string;   // ����
       m_callsCount  : Integer;  // ���-�� ������� �� ����
       m_ohHold      : Integer;  // ����� � �����

    constructor Create(_date:string); overload;
    constructor Create(_dateTime:string; _callsCount:Integer; _onHold:Integer); overload;

  end;
 // class TStructInfo END

   // class TStructCount
  type
      TStructCount = class

      private
      m_dateStart   : string;     // ���� ������
      m_dateStop    : string;     // ���� ���������
      m_count       : Integer;    // ������� ������ ���� � ���������

      m_data        : TArray<TStructInfo>;

      function GetData(_index:Integer):TStructInfo;

      function Size:Integer; // ������ �������

      public
      m_sip         : Integer;    // ��� sip �����

      constructor Create(_sip:Integer; _dateStart:string; _dateStop:string);
      destructor Destroy;            override;

      procedure Add(_data:TStructInfo);

      function IsExistData:Boolean;
      property Count:Integer read m_count;
      property ItemData[_index:integer]: TStructInfo read GetData; default;


      end;
 // class TStructCount END


 // class TCountRingsOperators
  type
      TCountRingsOperators = class(TAbstractReport)
      private
      m_count       : Integer;                              // ���-�� �������� � m_listData
      m_listData    : TArray<TStructCount>;
      m_table       : enumReportTableCountCallsOperator;    // � ����� ������� ������� ������
      m_tableOnHold : enumReportTableCountCallsOperatorOnHold;  // � ����� ������� ������� ������ onHold
      m_sipListStr  : string;                               // ������ sip ������� � ������� 'number','number'
      m_onlyCurrentDay : Boolean;                           // ������� ������ ������� ���� ��� ������ ����


      function GetSipAll:TStringList;   // �������� ������ sip �� ������� ����� ����� ������
      function GetDateStart(_sip:Integer):string;
      function GetDateStop(_sip:Integer):string;

      function GetData(_index:Integer):TStructCount;

      public

      constructor Create(_sipList:TStringList;
                         _dateStart:string; _dateStop:string;
                         _table: enumReportTableCountCallsOperator;
                         _tableOhHold: enumReportTableCountCallsOperatorOnHold;
                         _sipListString:string);
      destructor Destroy;            override;


      function FillingData:Boolean;   // ���������� �������

      procedure SetCountCalls(_sip:Integer; _data:TStructInfo); // ��������� ���-�� ������� � ���������� ����

      function IsExistData:Boolean;   // ���� �� ����� �� ������
      property Items[Index: Integer]: TStructCount read GetData; default;
      property Count:Integer read m_count;


      end;
 // class TCountRingsOperators END

implementation

uses
  GlobalVariablesLinkDLL, FunctionUnit;


constructor TStructInfo.Create(_date:string);
 begin
  Inherited Create;

  m_date_time:=_date;
  m_callsCount:=0;
  m_ohHold:=0;
 end;


constructor TStructInfo.Create(_dateTime:string; _callsCount:Integer; _onHold:Integer);
begin
  Inherited Create;

  m_date_time:=_dateTime;
  m_callsCount:=_callsCount;
  m_ohHold:=_onHold;
end;


constructor TStructCount.Create(_sip:Integer; _dateStart:string; _dateStop:string);
 begin
   Inherited Create;

   m_sip:=_sip;
   m_dateStart:=_dateStart;
   m_dateStop:=_dateStop;
   m_count:=0;

   SetLength(m_data,0);
 end;

 destructor TStructCount.Destroy;
 var
 i:Integer;
begin
  if Assigned(m_data) then begin
    for i:=Low(m_data) to High(m_data) do FreeAndNil(m_data[i]);
  end;
  SetLength(m_data, 0);

  inherited Destroy;
end;


// ������ �������
function TStructCount.Size:Integer;
begin
  Result:=Length(m_data);
end;

function TStructCount.GetData(_index:Integer):TStructInfo;
begin
  Result:=m_data[_index];
end;

procedure TStructCount.Add(_data:TStructInfo);
var
 index:Integer;
begin
  index:=Size;
  SetLength(m_data,index+1);

  m_data[index]:=_data;
  Inc(m_count);
end;


function TStructCount.IsExistData:Boolean;
begin
  Result:= (Size > 0);
end;


constructor TCountRingsOperators.Create(_sipList:TStringList;
                                        _dateStart:string; _dateStop:string;
                                        _table: enumReportTableCountCallsOperator;
                                        _tableOhHold: enumReportTableCountCallsOperatorOnHold;
                                        _sipListString:string);
 var
  i:Integer;
 begin
   Inherited Create;

   SetLength(m_listData,_sipList.Count);

   for i:=0 to _sipList.Count-1 do begin
    m_listData[i]:=TStructCount.Create(StrToInt(_sipList[i]), _dateStart, _dateStop);
   end;

   // ������� ������ ������� ���� ��� ������ ����
   if _dateStart = _dateStop then m_onlyCurrentDay:=True
   else m_onlyCurrentDay:=False;

   m_count:=_sipList.Count;
   m_table:=_table;
   m_tableOnHold:=_tableOhHold;
   m_sipListStr:=_sipListString;
 end;


destructor TCountRingsOperators.Destroy;
 var
 i:Integer;
begin
  if Assigned(m_listData) then begin
    for i:=Low(m_listData) to High(m_listData) do FreeAndNil(m_listData[i]);
  end;

  SetLength(m_listData, 0);

  inherited Destroy;
end;


// ���������� �������
function TCountRingsOperators.FillingData:Boolean;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 procentLoad:Integer;
 sipList:TStringList; // ������ � sip ������� ����� ������
 currentDay:TDate;
 newData:TStructInfo;
 onHoldCount:Integer;
 aboutNow:Boolean;
begin
  Result:=False;
  aboutNow:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  sipList:=GetSipAll;
  if sipList.Count = 0 then begin
   // ������ ��� �� ���� �� ������ �� ���� ��
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      // ����������� �� ������ sip
      for i:=0 to sipList.Count-1 do begin
        SQL.Clear;
        SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorToString(m_table)+' where sip IN ('+sipList[i]+') and answered = ''1''');
        if not m_onlyCurrentDay then SQL.Add(' and date_time >='+#39+GetDateToDateBD(GetDateStart(StrToInt(sipList[i])))+' 00:00:00'+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStop(StrToInt(sipList[i])))+' 23:59:59'+#39+' order by date_time ASC');

        Active:=True;
        countData:=Fields[0].Value;
        if countData=0 then begin
          Continue;
        end;

        // ������� ���-�� � ������� �������
        currentDay:=StrToDate(GetDateStart(StrToInt(sipList[i])));
        while currentDay <= StrToDate(GetDateStop(StrToInt(sipList[i]))) do  begin

            procentLoad:=Trunc(i*100/sipList.Count-1);
            if procentLoad < 0 then procentLoad:=0;

            SetProgressStatusText('�������� ������ � ������� ['+IntToStr(procentLoad)+'%] ...');
            SetProgressBar(procentLoad);

            SQL.Clear;
            SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorToString(m_table)+' where sip IN ('+sipList[i]+') and answered = ''1'''+
                    ' and date_time >='+#39+GetDateToDateBD(DateToStr(currentDay))+' 00:00:00'+#39+
                    ' and date_time <='+#39+GetDateToDateBD(DateToStr(currentDay))+' 23:59:59'+#39+
                    ' order by date_time ASC');

            Active:=True;
            countData:=Fields[0].Value;
            if countData = 0 then begin
               currentDay := IncDay(currentDay,1);
               // �������� ����� �������� ��������
              aboutNow:=GetAbout;
              if aboutNow then break;

              Continue;
            end;

            // ������� ���-�� ������� � onhold
            onHoldCount:=CountOnHoldPhoneAll(sipList[i],currentDay,m_tableOnHold);


            newData:=TStructInfo.Create(DateToStr(currentDay), countData, onHoldCount);

            // ������� ������ �� ������� � ���������� ����
            SetCountCalls(StrToInt(sipList[i]),newData);

            currentDay := IncDay(currentDay,1);

            // �������� ����� �������� ��������
            aboutNow:=GetAbout;
            if aboutNow then break;

        end;

        if aboutNow then Break;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Result:=IsExistData;
end;


// ��������� ���-�� ������� � ���������� ����
procedure TCountRingsOperators.SetCountCalls(_sip:Integer; _data:TStructInfo);
var
 i:Integer;
begin
   for i:=0 to m_count-1 do begin
      if m_listData[i].m_sip = _sip then begin
        m_listData[i].Add(_data);
        Exit;
      end;
   end;
end;

// ���� �� ����� �� ������
function TCountRingsOperators.IsExistData:Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_count-1 do begin
      if m_listData[i].IsExistData then begin
        Result:=True;
        Exit;
      end;
  end;
end;



// �������� ������ sip �� ������� ����� ����� ������
function TCountRingsOperators.GetSipAll:TStringList;
var
 i:Integer;
begin
 Result:=TStringList.Create;

 for i:=0 to m_count-1 do begin
  Result.Add(IntToStr(m_listData[i].m_sip));
 end;

end;


function TCountRingsOperators.GetDateStart(_sip:Integer):string;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    if m_listData[i].m_sip = _sip then begin
      Result:=m_listData[i].m_dateStart;
      Exit;
    end;
  end;
end;

function TCountRingsOperators.GetDateStop(_sip:Integer):string;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    if m_listData[i].m_sip = _sip then begin
      Result:=m_listData[i].m_dateStop;
      Exit;
    end;
  end;
end;

function TCountRingsOperators.GetData(_index:Integer):TStructCount;
begin
  Result:= m_listData[_index];
end;

end.