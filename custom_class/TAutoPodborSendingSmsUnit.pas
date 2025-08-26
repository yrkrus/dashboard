 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         Класс для описания поиска статуса отправленной SMS                ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TAutoPodborSendingSmsUnit;

interface

uses
  System.Classes, System.SysUtils,
  Data.Win.ADODB, Data.DB, System.Variants,
  TCustomTypeUnit, System.DateUtils;


 // class TStructSending

  type
      TStructSending = class
      public
      m_idBase          :Integer;
      m_dateTime        :string;
      m_code            :enumStatusCodeSms;
      m_status          :string;

      constructor Create;    overload;
      constructor Create(_id:Integer; _date:string; _code:enumStatusCodeSms; _status:string);    overload;
      procedure Clear;

      end;

 // class TStructSending

 // class TAutoPodborSendingSms
  type
      TAutoPodborSendingSms = class
      private
      m_phone       :string;
      m_count       :Integer;
      m_list        :TArray<TStructSending>;

      procedure Init;  // инициализация и поиск данных когда отправляли SMS сообщени
      procedure FindData(_count:Integer);     // поиск когда отправляли SMS сообщения
      procedure Add(const _sending:TStructSending);
      function GetStatusSending(_id:Integer):string;

      public
      constructor Create(_phone:string);    overload;

      destructor Destroy;                    override; // Объявление деструктора

      property Count:Integer read m_count;
      property Status[_id:Integer]:string read GetStatusSending;default;


      end;
 // class TAutoPodborSendingSms END

implementation

uses
  GlobalVariablesLinkDLL;

constructor TStructSending.Create;
begin
  Clear;
end;

constructor TStructSending.Create(_id:Integer; _date:string; _code:enumStatusCodeSms; _status:string);
begin
  m_idBase:=_id;
  m_dateTime:=_date;
  m_code:=eStatusCodeSmsUnknown;
  m_status:=_status;
end;



procedure TStructSending.Clear;
begin
  m_idBase:=0;
  m_dateTime:='';
  m_code:=eStatusCodeSmsUnknown;
  m_status:='';
end;

constructor TAutoPodborSendingSms.Create(_phone:string);
begin
 inherited Create;

 m_count:=0;
 SetLength(m_list,m_count);

 m_phone:=_phone;

 // инициализация
 Init;
end;



destructor TAutoPodborSendingSms.Destroy; // Реализация деструктора
var
 i:Integer;
begin
  for i:=0 to High(m_list) do m_list[i].Free;
  SetLength(m_list,0);
  m_count:=0;
  m_phone:='';

  inherited Destroy;
end;


procedure TAutoPodborSendingSms.Init;
var
 countSMS:Integer;
 i:Integer;
begin
  countSMS:=GetCountSmsSendingMessageInPhone(m_phone);
  FindData(countSMS);
end;


procedure TAutoPodborSendingSms.Add(const _sending:TStructSending);
var
 newSending:TStructSending;
begin
  SetLength(m_list, Length(m_list) + 1);

  newSending:=TStructSending.Create(_sending.m_idBase,
                                    _sending.m_dateTime,
                                    _sending.m_code,
                                    _sending.m_status );

  m_list[High(m_list)] := newSending;
  Inc(m_count);
end;

function TAutoPodborSendingSms.GetStatusSending(_id:Integer):string;
const
 cTAB:string = '      ';
var
 tab:string;
begin
  tab:=cTAB;
  if Length(m_list[_id].m_dateTime) <> 19 then tab:= tab+'  ';

  Result:=m_list[_id].m_dateTime + tab + m_list[_id].m_status;
end;


procedure TAutoPodborSendingSms.FindData(_count:Integer);     // поиск когда отправляли SMS сообщения
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  request:TStringBuilder;
  i:Integer;
  t:string;
  sendingSMS:TStructSending;
begin
  ado := TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  request:=TStringBuilder.Create;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;

       with request do begin
        Clear;
        Append('select id, date_time,status ');
        Append('from '+EnumReportTableSMSToString(eTableHistorySMS));
        Append(' where phone = '+#39+m_phone+#39);
        Append(' UNION ');
        Append('select id, date_time,status ');
        Append('from '+EnumReportTableSMSToString(eTableSMS));
        Append(' where phone = '+#39+m_phone+#39);
        Append(' order by date_time DESC');
       end;

       t:=request.ToString;

      SQL.Add(request.ToString);
      Active:= True;

      sendingSMS:=TStructSending.Create;

      for i:=0 to _count-1 do begin
       sendingSMS.Clear;
       sendingSMS.m_idBase:=StrToInt(VarToStr(Fields[0].Value));
       sendingSMS.m_dateTime:=VarToStr(Fields[1].Value);
       sendingSMS.m_code:= StringToEnumStatusCodeSms((VarToStr(Fields[2].Value)));
       sendingSMS.m_status:=GetStatusSms(sendingSMS.m_code);

       Add(sendingSMS);
       ado.Next;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then
    begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


end.