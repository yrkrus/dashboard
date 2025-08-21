 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             ����� ��� �������� ������� ������� + �����������              ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TQueueStatisticsUnit;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Data.Win.ADODB,
  Data.DB, Variants, TCustomTypeUnit, TAutoPodborPeopleUnit;


 // class TCalls
   type
   TCalls = class(TObject)
   private
   m_id           :Integer;
   m_dateTime     :TDateTime;
   m_phone        :string;
   m_waiting      :string;
   m_trunk        :string;

   m_addFIO       :Boolean;           // ����� �� ��������� ���
   m_fio          :TAutoPodborPeople;

   function Clone(_addFIO:Boolean):TCalls;

   public
   constructor Create(_addFIO:Boolean = False);               overload;
   destructor Destroy;

   end;
// class TCalls END


  // class TStructMissed
  type
   TStructMissed = class(TObject)

   private
   m_count_missed               :Integer;
   m_count_missed_no_return     :Integer;

   m_missed               :TArray<TCalls>;
   m_missed_no_return     :TArray<TCalls>;

   public
   constructor Create;               overload;
   destructor Destroy;

   procedure Clear;

   procedure Add(_missed:enumMissed; NewMissed:TCalls; isCheckExist:Boolean = False);  // ���������� ������ � ������
   function IsExist(_missed:enumMissed; NewMissed:TCalls):Boolean; // �������� �� ������������ ������

   // procedure Delete(_missed:enumMissed; _id:Integer);  // TODO �������



   end;
   // class TStructMissed END


  // class TStructStatistics
  type
    TStructStatistics = class(TObject)
    private
    m_all         :Integer;   // ����� �������
    m_ansvered    :Integer;   // ����� ������� ��������
    m_missed_all  :Integer;   // ����� ������� �����������
    m_missed      :Integer;   // ����� ������� ����������� (�� ��������������)

    m_listMissed  :TStructMissed;  // ������ � ������������ ��������

    public
    constructor Create;                   overload;
    destructor Destroy;                   override;

    procedure Clear;      // ������� ������

    procedure AddListMissed(_missed:enumMissed; NewMissed:TCalls);  // ���������� ������ � �����������

    property All:Integer read m_all;
    property Ansvered:Integer read m_ansvered;
    property MissedAll:Integer read m_missed_all;
    property Missed:Integer read m_missed;

    end;

 // class TStructStatistics




 // class TStructQueueStatistics
  type
      TStructQueueStatistics = class(TObject)
      private
      m_queue       :enumQueue;
      m_statistics  :TStructStatistics;

      // ������ �� TLabel �� �����
      m_label_all         :TLabel;
      m_label_ansvered    :TLabel;
      m_label_missed      :TLabel;

      public
      constructor Create(_queue:enumQueue);    overload;
      destructor Destroy;                             override;

      function isExistDiffMissedCalls(_missed:enumMissed):Boolean; // ���� ��������� � �����������

      end;
 // class TStructQueueStatistics END


 // class TStructQueueStatisticsDay
 type
  TStructQueueStatisticsDay = class(TStructQueueStatistics)
  private
    m_label_procent: TLabel;
    m_statistics_procent  :string;

  public
    constructor Create(_queue: enumQueue); reintroduce;
    destructor Destroy;                           override;
  end;

 // class TStructQueueStatisticsDay END


 // class TQueueStatistics
  type
      TQueueStatistics = class(TObject)
      private
      m_count   :Integer;
      m_list    :TArray<TStructQueueStatistics>;
      m_listDay :TStructQueueStatisticsDay;

      isExistStatDay:Boolean;

      procedure SetStatistics(_queue:enumQueue); overload; // ��������� ���������� ����������
      procedure SetStatistics; overload;                          // ��������� ���������� ����������
      procedure ShowQueue(_queue:enumQueue);               // ���������� ������ � ������� �������
      procedure ShowDay;                                          // ���������� ������ � ������� �������� ���
      procedure UpdateQueue(_queue:enumQueue);             // ��������� ������ �� ��������
      procedure UpdateDay;                                        // ��������� ������ �� ������� ����


      function GetMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay;
                              var _countCalls:Integer):TArray<TCalls>;  // ��������� ������� ����������� �������

      procedure UpdateMissedCalls(_queue:enumQueue;
                                  _stat:enumStatistiscDay;
                                  _beforeClear:enumStatus); //���������� ������������� � ����������� �������




      public
      constructor Create(isCreateStatDay:Boolean = False);                   overload;
      destructor Destroy; override;

      function GetCallsAll(_queue:enumQueue):Integer;          // ��� ������
      function GetCallsAnswered(_queue:enumQueue):Integer;     // ����������
      function GetCallsMissedAll(_queue:enumQueue):Integer;    // ����������� ���
      function GetCallsMissed(_queue:enumQueue):Integer;       // ����������� �� �������������

      procedure Update;  // ���������� ������
      procedure Show; // ����� ������

      procedure SetLinkLabel(_queue:enumQueue;
                             var _label_all,_label_ansvered,_label_missed : TLabel); //������� TLabel (������ ��� ������ ������)


      procedure SetLinkLabelStatDay(var _label_all,_label_ansvered,_label_missed,_label_procent : TLabel); //������� TLabel (������ ��� ������ ������)



      // ================ ������� TCalls ====================
      function GetMissedCount(_queue:enumQueue; _missed:enumMissed):Integer;  // ��������� ���-�� �����������
      function GetCalls_ID(_queue:enumQueue; _missed:enumMissed; _id:Integer):Integer;           // m_id
      function GetCalls_DateTime(_queue:enumQueue; _missed:enumMissed; _id:Integer):TDateTime;   // m_datetime
      function GetCalls_Phone(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;         // m_phone
      function GetCalls_FIO(_queue:enumQueue; _missed:enumMissed; _id:Integer; var _count:Integer):string;           // m_fio
      function GetCalls_Trunk(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;         // m_trunk
      function GetCalls_Waiting(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;       // m_waiting



      // ================ ������� TCalls END ================

      property Count:Integer read m_count;
      property ExistStatDay:Boolean read isExistStatDay;

      end;
 // class TQueueStatistics END

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, FormHome, GlobalVariables;


// =============================================
// TCalls

constructor TCalls.Create(_addFIO:Boolean = False);
begin
   m_id           :=0;
   m_dateTime     :=0;
   m_phone        :='';
   m_waiting      :='';
   m_trunk        :='';

   m_addFIO:=_addFIO;
   m_fio:=nil;
end;

destructor TCalls.Destroy;
begin
  if Assigned(m_fio) then m_fio.Free;
  inherited;
end;


function TCalls.Clone(_addFIO:Boolean): TCalls;
var
 phone:string;
begin
  Result:=TCalls.Create(_addFIO);

  Result.m_id := Self.m_id;
  Result.m_dateTime := Self.m_dateTime;
  Result.m_phone := Self.m_phone;
  Result.m_waiting := Self.m_waiting;
  Result.m_trunk := Self.m_trunk;

  if _addFIO then begin
    phone:=Self.m_phone;
    phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);
    Result.m_fio:=TAutoPodborPeople.Create(phone);
  end;
end;


// TCalls END
// =============================================





// =============================================
// TStructStatistics

constructor TStructMissed.Create;
begin
  Clear;
end;

destructor TStructMissed.Destroy;
begin
  Clear;
  inherited;
end;


procedure TStructMissed.Clear;
var
  i: Integer;
begin
  // ����������� ������ m_missed
  if Length(m_missed) > 0 then begin
    for i := 0 to High(m_missed) do begin
      FreeAndNil(m_missed[i]); // ����������� ������ ������
    end;
    SetLength(m_missed, 0); // ������������� ����� ������� � 0
    m_count_missed := 0; // ���������� �������
  end;

  // ����������� ������ m_missed_no_return
  if Length(m_missed_no_return) > 0 then begin
    for i := 0 to High(m_missed_no_return) do begin
      FreeAndNil(m_missed_no_return[i]); // ����������� ������ ������
    end;
    SetLength(m_missed_no_return, 0); // ������������� ����� ������� � 0
    m_count_missed_no_return := 0; // ���������� �������
  end;
end;

// �������� �� ������������ ������
function TStructMissed.IsExist(_missed:enumMissed; NewMissed:TCalls):Boolean;
var
 i:Integer;
 m_array: TArray<TCalls>;
 counts:Integer;
begin
  Result:=False;
  counts:=0;

  case _missed of
    eMissed: begin
       m_array:=m_missed;
       counts:=m_count_missed;
    end;
    eMissed_no_return: begin
      m_array:=m_missed_no_return;
      counts:=m_count_missed_no_return;
    end;
  end;

  for i:=0 to counts-1 do begin
    if m_array[i].m_id = NewMissed.m_id then begin
      Result:=True;
      Exit;
    end;
  end;
end;

// ���������� ������ � ������
procedure TStructMissed.Add(_missed:enumMissed; NewMissed:TCalls; isCheckExist:Boolean = False);
var
  CallCopy: TCalls;
  addFIO:Boolean;  // ����� �� ��������� ����������� ���������� � ������ (��� �� ���)
begin
 //  �������� �� ����� ������
  if isCheckExist then begin
    if IsExist(_missed, NewMissed) then Exit;
  end;

  // ����� �� ��������� ����������� ���������� � ������ (��� �� ���)
  case _missed of
    eMissed:            addFIO :=False;
    eMissed_no_return:  addFIO :=True;
  end;

  // ������� ����� �������
  CallCopy := NewMissed.Clone(addFIO);

  if not Assigned(CallCopy) then Exit;

  case _missed of
    eMissed:begin
      SetLength(m_missed, Length(m_missed) + 1);
      m_missed[High(m_missed)]:= CallCopy; // ��������� ����� � ������
      Inc(m_count_missed);
    end;
    eMissed_no_return:begin
      SetLength(m_missed_no_return, Length(m_missed_no_return) + 1);
      m_missed_no_return[High(m_missed_no_return)]:= CallCopy; // ��������� ����� � ������

      Inc(m_count_missed_no_return);
    end;
  end;

end;

// TStructStatistics END
// =============================================



// =============================================
// TStructStatistics

constructor TStructStatistics.Create;
begin
 m_listMissed:=TStructMissed.Create;
 Clear;
end;

destructor TStructStatistics.Destroy;
begin
  m_listMissed.Free;
  inherited;
end;

// ������� ������
procedure TStructStatistics.Clear;
begin
   m_all        :=0;
   m_ansvered   :=0;
   m_missed_all :=0;
   m_missed     :=0;

   m_listMissed.Clear;
end;

// ���������� ������ � �����������
procedure TStructStatistics.AddListMissed(_missed:enumMissed; NewMissed:TCalls);
begin
  m_listMissed.Add(_missed,NewMissed,True);
end;


// TStructStatistics END
// =============================================


// =============================================
// TStructQueueStatistics

constructor TStructQueueStatistics.Create(_queue:enumQueue);
begin
  // inherited;
  m_queue:=_queue;
  m_statistics:=TStructStatistics.Create;

//  m_label_all         :=TLabel.Create(nil);
//  m_label_ansvered    :=TLabel.Create(nil);
//  m_label_missed      :=TLabel.Create(nil);

  m_label_all         :=nil;
  m_label_ansvered    :=nil;
  m_label_missed      :=nil;
end;

destructor TStructQueueStatistics.Destroy;
begin
  if Assigned(m_label_all) then m_label_all.Free;
  if Assigned(m_label_ansvered) then m_label_ansvered.Free;
  if Assigned(m_label_missed) then m_label_missed.Free;
  if Assigned(m_statistics) then m_statistics.Free;

  inherited;
end;


// ���� ��������� � �����������
function TStructQueueStatistics.isExistDiffMissedCalls(_missed:enumMissed):Boolean;
var
 i:Integer;
 count_missed_stat, count_missed_list:Integer;
begin
  Result:=False;

  case _missed of
   eMissed: begin
      count_missed_stat:=m_statistics.m_missed_all;
      count_missed_list:=m_statistics.m_listMissed.m_count_missed;
   end;
   eMissed_no_return:begin
     count_missed_stat:=m_statistics.m_missed;
     count_missed_list:=m_statistics.m_listMissed.m_count_missed_no_return;
   end;
  end;

  Result:=not (count_missed_stat = count_missed_list);
end;


// TStructQueueStatistics END
// =============================================


// =============================================
// TStructQueueStatisticsDay

// ���������� ������������
constructor TStructQueueStatisticsDay.Create(_queue: enumQueue);
begin
  inherited Create(_queue); // ����� ������������ ������������� ������
  //m_label_procent := TLabel.Create(nil);
  m_label_procent := nil;
  m_statistics_procent:='0';
end;

destructor TStructQueueStatisticsDay.Destroy;
begin
 if Assigned(m_label_procent) then m_label_procent.Free;
  inherited;
end;


// TStructQueueStatisticsDay END
// =============================================

// =============================================
// TQueueStatistics
                                    // ����� �� ��������� ����� ��� ���������� �� ����
constructor TQueueStatistics.Create(isCreateStatDay:Boolean = False);
var
 i:Integer;
begin
  inherited Create;

   //inherited;
  m_count:=Ord(High(enumQueue))-1;  // TODO ����� ������ 5000 � 5050 �������

   // �������� ������
  SetLength(m_list,m_count);
  for i:=0 to m_count do m_list[i]:=TStructQueueStatistics.Create(enumQueue(i));


  // ����� �� ��������� ����� ��� ���������� �� ����
  if isCreateStatDay then begin
    m_listDay:=TStructQueueStatisticsDay.Create(queue_5000_5050);   // TODO ����� �������� 5000 + 5050
    isExistStatDay:=True;
  end;

end;


destructor TQueueStatistics.Destroy;
var
  i: Integer;
begin
  // ������� �������� ��������
  for i := 0 to High(m_list) do m_list[i].Free;
  SetLength(m_list, 0);

  // ����� ���������� �� ����
  if isExistStatDay then  m_listDay.Free;

  inherited;
end;

// ��������� ���������� ����������
procedure TQueueStatistics.SetStatistics(_queue:enumQueue);
 var
  i,j:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_queue = _queue then begin

      if StrToInt(GetStatistics_day(stat_summa,_queue)) = 0 then begin
       m_list[i].m_statistics.Clear;
       UpdateMissedCalls(_queue, stat_no_answered, eYES);
       UpdateMissedCalls(_queue, stat_no_answered_return, eYES);
       Exit;
      end;

      m_list[i].m_statistics.m_all:=StrToInt(GetStatistics_queue(_queue,all_answered));
      m_list[i].m_statistics.m_ansvered:=StrToInt(GetStatistics_queue(_queue,answered));
      m_list[i].m_statistics.m_missed_all:=StrToInt(GetStatistics_queue(_queue,no_answered));
      m_list[i].m_statistics.m_missed:=StrToInt(GetStatistics_queue(_queue,no_answered_return));


      // ��������� ���� �� ��������� (��������� ��������� ������ �� �����������)
      if m_list[i].isExistDiffMissedCalls(eMissed)            then UpdateMissedCalls(_queue, stat_no_answered, eNO);
      if m_list[i].isExistDiffMissedCalls(eMissed_no_return)  then UpdateMissedCalls(_queue, stat_no_answered_return, eNO);
    end;
  end;
end;

// ��������� ���������� ����������
procedure TQueueStatistics.SetStatistics;
begin
   m_listDay.m_statistics.m_all:=StrToInt(GetStatistics_day(stat_summa));
   m_listDay.m_statistics.m_ansvered:=StrToInt(GetStatistics_day(stat_answered));
   m_listDay.m_statistics.m_missed_all:=StrToInt(GetStatistics_day(stat_no_answered));
   m_listDay.m_statistics.m_missed:=StrToInt(GetStatistics_day(stat_no_answered_return));

   m_listDay.m_statistics_procent:=GetStatistics_day(stat_procent_no_answered) + '% ('+GetStatistics_day(stat_procent_no_answered_return)+'%)';
end;

 // ���������� ������ � ������� �������
procedure TQueueStatistics.ShowQueue(_queue:enumQueue);
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    if m_list[i].m_queue = _queue then begin
       // ����� �������
       m_list[i].m_label_all.Caption:=IntToStr(GetCallsAll(_queue));
       // ��������
       m_list[i].m_label_ansvered.Caption:=IntToStr(GetCallsAnswered(_queue));
       // ���������
       m_list[i].m_label_missed.Caption:=IntToStr(GetCallsMissedAll(_queue))+' ('+IntToStr(GetCallsMissed(_queue))+')';
    end;
  end;
end;

// ���������� ������ � ������� �������� ���
procedure TQueueStatistics.ShowDay;
begin
  m_listDay.m_label_all.Caption:=IntToStr(m_listDay.m_statistics.m_all);
  m_listDay.m_label_ansvered.Caption:=IntToStr(m_listDay.m_statistics.m_ansvered);
  m_listDay.m_label_missed.Caption:=IntToStr(m_listDay.m_statistics.m_missed_all)+' ('+IntToStr(m_listDay.m_statistics.m_missed)+')';
  m_listDay.m_label_procent.Caption:=m_listDay.m_statistics_procent;
end;


procedure TQueueStatistics.SetLinkLabel(_queue:enumQueue;
                           var _label_all,_label_ansvered,_label_missed : TLabel); //������� TLabel (������ ��� ������ ������)

var
 i:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_queue = _queue then begin
      m_list[i].m_label_all:=_label_all;
      m_list[i].m_label_ansvered:=_label_ansvered;
      m_list[i].m_label_missed:=_label_missed;

     Exit;
    end;
  end;
end;


//������� TLabel (������ ��� ������ ������)
procedure TQueueStatistics.SetLinkLabelStatDay(var _label_all,_label_ansvered,_label_missed,_label_procent : TLabel);
begin
  if not isExistStatDay then Exit;

  m_listDay.m_label_all:=_label_all;
  m_listDay.m_label_ansvered:=_label_ansvered;
  m_listDay.m_label_missed:=_label_missed;
  m_listDay.m_label_procent:=_label_procent;
end;


// ��������� ���-�� �����������
function TQueueStatistics.GetMissedCount(_queue:enumQueue; _missed:enumMissed):Integer;
var
 i:Integer;
 queue_summa:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed: begin
          Result:=m_list[i].m_statistics.m_listMissed.m_count_missed;
          Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_count_missed_no_return;
         Exit;
        end;
        eMissed_all:begin
          Result:=m_list[i].m_statistics.m_listMissed.m_count_missed;
          Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  queue_summa:=0;
  for i:=0 to m_count-1 do begin
    case _missed of
      eMissed: begin
        queue_summa:= queue_summa + m_list[i].m_statistics.m_listMissed.m_count_missed;
      end;
      eMissed_no_return:begin
       queue_summa:= queue_summa + m_list[i].m_statistics.m_listMissed.m_count_missed_no_return;
      end;
      eMissed_all:begin
        queue_summa:= queue_summa + (m_list[i].m_statistics.m_listMissed.m_count_missed + m_list[i].m_statistics.m_listMissed.m_count_missed_no_return);;
      end;
    end;
  end;

  Result:=queue_summa;
end;

// TCalls -> m_id
function TQueueStatistics.GetCalls_ID(_queue:enumQueue; _missed:enumMissed; _id:Integer):Integer;
var
 i:Integer;
begin
  for i:=0 to m_count - 1do begin
  if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_id;
         Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_id;
         Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  // ��������� ������ ��������
  for i:=0 to m_count - 1 do begin
    Result:=GetCalls_ID(enumQueue(i),_missed, _id);
    if Result > 0 then begin
      Exit;
    end;
  end;
end;

// TCalls -> m_datetime
function TQueueStatistics.GetCalls_DateTime(_queue:enumQueue; _missed:enumMissed; _id:Integer):TDateTime;
var
 i:Integer;
begin
  for i:=0 to m_count - 1do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_dateTime;
         Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_dateTime;
         Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  // ��������� ������ ��������
  for i:=0 to m_count - 1 do begin
    Result:=GetCalls_DateTime(enumQueue(i),_missed, _id);
    if Result > 0 then begin
      Exit;
    end;
  end;
end;


// TCalls -> m_phone
function  TQueueStatistics.GetCalls_Phone(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin
  for i:=0 to m_count - 1 do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_phone;
         Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_phone;
         Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  // ��������� ������ ��������
  for i:=0 to m_count - 1 do begin
    Result:=GetCalls_Phone(enumQueue(i),_missed, _id);
    if Result <>'' then begin
      Exit;
    end;
  end;
end;


// TCalls -> m_fio
function TQueueStatistics.GetCalls_FIO(_queue:enumQueue; _missed:enumMissed; _id:Integer; var _count:Integer):string;
var
 i:Integer;
 countFIO:Integer;
begin
 countFIO:=0;

 try
  for i:=0 to m_count - 1 do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         countFIO:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_fio.Count;

           case countFIO of
            0:begin
              Result:='����� �����';
            end;
            1:begin
              Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_fio.GetFIO(0);
            end;
            else begin
              Result:='��������� ��������� ('+IntToStr(countFIO)+')';
            end;
           end;

         Exit;
        end;
        eMissed_no_return:begin
          countFIO:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_fio.Count;

           case countFIO of
            0:begin
              Result:='����� �����';
            end;
            1:begin
              Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_fio.GetFIO(0);
            end;
            else begin
              Result:='��������� ��������� ('+IntToStr(countFIO)+')';
            end;
           end;

         Exit;
        end;
      end;
    end;
  end;
 finally
   _count:=countFIO;
 end;


//  // ������ �� ����� ������ ��� 5000 � 5050
//  // ��������� ������ ��������
//  for i:=0 to m_count - 1 do begin
//    Result:=GetCalls_Phone(enumQueueCurrent(i),_missed, _id);
//    if Result <>'' then begin
//      Exit;
//    end;
//  end;
end;


// TCalls -> m_trunk
function TQueueStatistics.GetCalls_Trunk(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin
  for i:=0 to m_count - 1 do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_trunk;
         Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_trunk;
         Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  // ��������� ������ ��������
  for i:=0 to m_count - 1 do begin
    Result:=GetCalls_Trunk(enumQueue(i),_missed, _id);
    if Result <> 'null' then begin
      Exit;
    end;
  end;

end;

// TCalls -> m_waiting
function TQueueStatistics.GetCalls_Waiting(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin
  for i:=0 to m_count - 1 do begin
    if m_list[i].m_queue = _queue then begin
      case _missed of
        eMissed:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_waiting;
         Exit;
        end;
        eMissed_no_return:begin
         Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_waiting;
         Exit;
        end;
      end;
    end;
  end;

  // ������ �� ����� ������ ��� 5000 � 5050
  // ��������� ������ ��������
  for i:=0 to m_count - 1 do begin
    Result:=GetCalls_Waiting(enumQueue(i),_missed, _id);
    if Result <> '' then begin
      Exit;
    end;
  end;
end;


// ��� ������
function TQueueStatistics.GetCallsAll(_queue:enumQueue):Integer;
var
 i:Integer;
begin
   for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_all;
       Exit;
     end;
   end;
end;

// ����������
function TQueueStatistics.GetCallsAnswered(_queue:enumQueue):Integer;
var
 i:Integer;
begin
   for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_ansvered;
       Exit;
     end;
   end;
end;


// ����������� ���
function TQueueStatistics.GetCallsMissedAll(_queue:enumQueue):Integer;
var
 i:Integer;
begin
    for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_missed_all;
       Exit;
     end;
   end;
end;


// ����������� �� �������������
function TQueueStatistics.GetCallsMissed(_queue:enumQueue):Integer;
var
 i:Integer;
begin
    for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_missed;
       Exit;
     end;
   end;
end;


// ��������� ������ �� 5000 �������
procedure TQueueStatistics.UpdateQueue(_queue:enumQueue);
begin
  SetStatistics(_queue);
end;

// ��������� ������ �� ������� ����
procedure TQueueStatistics.UpdateDay;
begin
  SetStatistics;
end;


// ��������� ������� ����������� �������
function TQueueStatistics.GetMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay;
                                         var _countCalls:Integer):TArray<TCalls>;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  call:TCalls;
  i,count:Integer;
  SQL_text:string;
  correct_time:string;
begin
 _countCalls:=0;
 SetLength(Result,0);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  count:=StrToInt(GetStatistics_day(_stat,_queue));
  if count=0 then
  begin
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
   Exit;
  end;

  // ��������� ������
  _countCalls:=count;

  case _stat of
   stat_no_answered:begin
    SQL_text:='select id,phone,waiting_time,date_time from queue where number_queue = '+#39+TQueueToString(_queue)+#39+' and fail = ''1'' and date_time > '+#39+GetNowDateTime+#39;
   end;
   stat_no_answered_return:begin
    SQL_text:='select id,phone,waiting_time,date_time from queue where number_queue='+#39+TQueueToString(_queue)+#39+
                                                                ' and fail =''1'' and date_time >'+#39+GetNowDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue ='+#39+TQueueToString(_queue)+#39+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetNowDateTime+#39+')';
   end;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(SQL_text);
      Active:=True;

      SetLength(Result, _countCalls);

      for i:=0 to count-1 do begin
       call:=TCalls.Create;
       call.m_id        :=StrToInt(VarToStr(Fields[0].Value));
       call.m_phone     :=VarToStr(Fields[1].Value);

       // ������������� �����
       correct_time:=correctTimeQueue(_queue,VarToStr(Fields[2].Value));
       call.m_waiting   := correct_time;

       call.m_dateTime  :=StrToDateTime(VarToStr(Fields[3].Value));
       call.m_trunk     :=GetPhoneTrunkQueue(eTableIVR, call.m_phone, DateTimeToStr(call.m_dateTime));


       Result[i]:=call;
       ado.Next;
      end;

    end;
  finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
  end;
end;


//���������� ������������� � ����������� �������
procedure TQueueStatistics.UpdateMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay; _beforeClear:enumStatus);
var
  list_calls: TArray<TCalls>;
  count_calls: Integer;
  i,j: Integer;
  missedType: enumMissed;
begin
  count_calls:= 0;

  // ���������� ��� ����������� �������
  case _stat of
    stat_no_answered: missedType := eMissed;
    stat_no_answered_return: missedType := eMissed_no_return;
  else
    Exit; // ���� ���������� �� �������������, ������� �� ���������
  end;

  // ������� ������, ���� ��� ����������
  if _beforeClear = eYES then
  begin
    for i:=0 to m_count - 1 do
    begin
      if m_list[i].m_queue = _queue then
      begin
        m_list[i].m_statistics.m_listMissed.Clear;
      end;
    end;
  end;

  // �������� ������ ����������� �������
  list_calls:=GetMissedCalls(_queue, _stat, count_calls);

  // ���� ���� ����������� ������, ��������� �� � ����������
  if count_calls > 0 then
  begin
    for i := 0 to m_count - 1 do
    begin
      if m_list[i].m_queue = _queue then
      begin
        for j := 0 to count_calls - 1 do
        begin
          m_list[i].m_statistics.AddListMissed(missedType, list_calls[j]);
        end;
      end;
    end;
  end;

  // ����������� ������
  if Length(list_calls)>0 then
  begin
    for i := 0 to High(list_calls) do FreeAndNil(list_calls[i]);
    SetLength(list_calls, 0);
  end;
end;

// ���������� ������
procedure TQueueStatistics.Update;
var
 i:Integer;
begin
  // ������� ������ � ������
  for i:=0 to m_count-1 do begin
   UpdateQueue(enumQueue(i));
  end;

  // ���������� ������ �� ������� ����
  if isExistStatDay then begin
    UpdateDay;
  end;
end;


// ����� ������
procedure TQueueStatistics.Show;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
   ShowQueue(enumQueue(i));
  end;

  // ���������� ������ �� ������� ����
  if isExistStatDay then begin
    ShowDay;
  end;
end;


// TQueueStatistics END
// =============================================


end.