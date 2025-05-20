 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///        ����� ��� �������� ������� ��������� �������� ���������            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit THistoryStatusOperatorsUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB, Data.Win.ADODB, IdException,System.Variants,
  TCustomTypeUnit;

 // class TStatusDuration
 type
    TStatusDuration = class

  public
  m_available   :Cardinal;     // ��������
  m_exodus      :Cardinal;     // �����
  m_break       :Cardinal;     // �������
  m_dinner      :Cardinal;     // ����
  m_postvyzov   :Cardinal;     // ���������
  m_studies     :Cardinal;     // �����
  m_IT          :Cardinal;     // ��
  m_transfer    :Cardinal;     // ��������
  m_reserve     :Cardinal;     // ������
  m_callback    :Cardinal;     // callback
  m_home        :Cardinal;     // �����

  constructor Create      overload;

 end;

 // class TStatusDuration END



// class THistoryStruct
 type
  THistoryStruct = class

  public
  m_status          :enumLogging;  // ��� ����
  m_dateStart       :TDateTime;    // ���� ������
  m_dateStop        :TDateTime;    // ���� ����������
  m_duration        :Cardinal;     // ������������ �������

  constructor Create      overload;


  end;
// class THistoryStruct END


 // class THistoryStatusOperators
  type
      THistoryStatusOperators = class
      private
      m_id                    :Integer;
      m_sip                   :Integer;

      m_history               :TArray<THistoryStruct>;
      m_countHistory          :Cardinal;

      m_status                :TStatusDuration;

      procedure CreateArrayHistory;         // �������� � ���������� ������� ������� ��������
      procedure AddCountStatusLogging(_log:enumLogging; _count:Cardinal); // ���������� ����������� ���-�� ���������� � �������



      public
      constructor Create(_id,_sip:Integer);               overload;
      destructor Destroy;                                 override;

      function GetStatus(_id:Cardinal):enumLogging;
      function GetDateStart(_id:Cardinal):TDateTime;
      function GetDateStop(_id:Cardinal):TDateTime;
      function GetDuration(_id:Cardinal):Cardinal;

      function GetCountTimeLogging(_log:enumLogging):string; // ����� ����� ���������� � ��������



      property Count:Cardinal read m_countHistory;

      end;
 // class THistoryStatusOperators END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL;


constructor TStatusDuration.Create;
 begin
   inherited;
  m_available   :=0;
  m_exodus      :=0;
  m_break       :=0;
  m_dinner      :=0;
  m_postvyzov   :=0;
  m_studies     :=0;
  m_IT          :=0;
  m_transfer    :=0;
  m_reserve     :=0;
  m_callback    :=0;
  m_home        :=0;
 end;



constructor THistoryStruct.Create;
 begin
   inherited;

   m_status:=eLog_unknown;
   m_dateStart:=0;
   m_dateStop:=0;
   m_duration:=0;
 end;



constructor THistoryStatusOperators.Create(_id,_sip:Integer);
begin
 // inherited;
  m_id:=_id;
  m_sip:=_sip;

  m_status:=TStatusDuration.Create;

  // ��������� �������
  CreateArrayHistory;

end;


 destructor THistoryStatusOperators.Destroy;
 var
  i:Integer;
 begin
    // ������������ ������� �������� �������
  for i:= Low(m_history) to High(m_history) do m_history[i].Free; // ����������� ������ ������
  // ������� �������
  SetLength(m_history, 0); // ������� ������ �� �������

  inherited Destroy; // ����� ����������� ������������� ������
 end;


function THistoryStatusOperators.GetStatus(_id:Cardinal):enumLogging;
begin
 Result:=m_history[_id].m_status;
end;

function THistoryStatusOperators.GetDateStart(_id:Cardinal):TDateTime;
begin
  Result:=m_history[_id].m_dateStart;
end;

function THistoryStatusOperators.GetDateStop(_id:Cardinal):TDateTime;
begin
   Result:=m_history[_id].m_dateStop;
end;

function THistoryStatusOperators.GetDuration(_id:Cardinal):Cardinal;
begin
  Result:=m_history[_id].m_duration;
end;

// ����� ����� ���������� � ��������
function THistoryStatusOperators.GetCountTimeLogging(_log:enumLogging):string;
var
 countTime:Cardinal;
begin
  Result:='---';

  case _log of
   eLog_available     :countTime := m_status.m_available;        // ��������
   eLog_home          :countTime := m_status.m_home;             // �����
   eLog_exodus        :countTime := m_status.m_exodus;           // �����
   eLog_break         :countTime := m_status.m_break;            // �������
   eLog_dinner        :countTime := m_status.m_dinner;           // ����
   eLog_postvyzov     :countTime := m_status.m_postvyzov;        // ���������
   eLog_studies       :countTime := m_status.m_studies;          // �����
   eLog_IT            :countTime := m_status.m_IT;               // ��
   eLog_transfer      :countTime := m_status.m_transfer;         // ��������
   eLog_reserve       :countTime := m_status.m_reserve;          // ������
   eLog_callback      :countTime := m_status.m_callback;         // callback
  else
    Exit;
  end;

  Result:= GetTimeAnsweredSecondsToString(countTime);

end;

// �������� � ���������� ������� ������� ��������
procedure THistoryStatusOperators.CreateArrayHistory;
const
  SecsPerDay = 24 * 60 * 60; // 86400 ������ � ������
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  i:Integer;
  action:enumLogging;
  actionTime:TDateTime;
begin
  ado := TADOQuery.Create(nil);
  serverConnect := createServerConnect;

  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from logging where user_id = '+#39+IntToStr(m_id)+#39);
      Active := True;
      m_countHistory := Fields[0].Value;

      if m_countHistory = 0 then
      begin
        Exit;
      end;

      SetLength(m_history,m_countHistory);
      for i:=0 to m_countHistory-1 do begin
        m_history[i]:=THistoryStruct.Create;
      end;

      SQL.Clear;
      SQL.Add('select action,date_time from logging where user_id = '+#39+IntToStr(m_id)+#39+' order by date_time ASC');
      Active := True;

      for i := 0 to m_countHistory - 1 do
      begin
        action       :=IntegerToEnumLogging(StrToInt(VarToStr(Fields[0].Value)));
        actionTime   :=StrToDateTime(VarToStr(Fields[1].Value));

        m_history[i].m_status:=action;
        m_history[i].m_dateStart:=actionTime;

        // �� ��������� ������
        if not (action in [eLog_add_queue_5000 .. eLog_callback]) then begin
          ado.Next;
          Continue;
        end;

        // ������� �����
        ado.Next;
        if i < m_countHistory - 1 then begin
         actionTime   :=StrToDateTime(VarToStr(Fields[1].Value));
         m_history[i].m_dateStop:=actionTime;
         m_history[i].m_duration:=Cardinal(Round((m_history[i].m_dateStop - m_history[i].m_dateStart) * SecsPerDay));

         // ������������ ����� ����� ���������� � ��������
          AddCountStatusLogging(action,m_history[i].m_duration);
        end;
      end;

      {
        enumLogging = (  eLog_unknown              = -1,        // ����������� ������
                    eLog_enter                = 0,         // ����
                    eLog_exit                 = 1,         // �����
                    eLog_auth_error           = 2,         // �� �������� �����������
                    eLog_exit_force           = 3,         // ����� (����� ������� force_closed)
                    eLog_add_queue_5000       = 4,         // ���������� � ������� 5000
                    eLog_add_queue_5050       = 5,         // ���������� � ������� 5050
                    eLog_add_queue_5000_5050  = 6,         // ���������� � ������� 5000 � 5050
                    eLog_del_queue_5000       = 7,         // �������� �� ������� 5000
                    eLog_del_queue_5050       = 8,         // �������� �� ������� 5050
                    eLog_del_queue_5000_5050  = 9,         // �������� �� ������� 5000 � 5050
                    eLog_available            = 10,        // ��������
                    eLog_home                 = 11,        // �����
                    eLog_exodus               = 12,        // �����
                    eLog_break                = 13,        // �������
                    eLog_dinner               = 14,        // ����
                    eLog_postvyzov            = 15,        // ���������
                    eLog_studies              = 16,        // �����
                    eLog_IT                   = 17,        // ��
                    eLog_transfer             = 18,        // ��������
                    eLog_reserve              = 19,        // ������
                    eLog_create_new_user      = 20,        // �������� ������ ������������
                    eLog_edit_user            = 21         // �������������� ������������
                );
      }
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

// ���������� ����������� ���-�� ���������� � �������
procedure THistoryStatusOperators.AddCountStatusLogging(_log:enumLogging; _count:Cardinal);
begin
  case _log of
    eLog_enter                :Exit;       // ����������� ������ (�� �������)
    eLog_exit                 :Exit;       // ����� (�� �������)
    eLog_auth_error           :Exit;       // �� �������� �����������  (�� �������)
    eLog_exit_force           :Exit;       // ����� (����� ������� force_closed)  (�� �������)
    eLog_add_queue_5000       :m_status.m_available := m_status.m_available + _count;         // ���������� � ������� 5000
    eLog_add_queue_5050       :m_status.m_available := m_status.m_available + _count;         // ���������� � ������� 5050
    eLog_add_queue_5000_5050  :m_status.m_available := m_status.m_available + _count;         // ���������� � ������� 5000 � 5050
    eLog_del_queue_5000       :Exit;         // �������� �� ������� 5000  (�� �������)
    eLog_del_queue_5050       :Exit;         // �������� �� ������� 5050  (�� �������)
    eLog_del_queue_5000_5050  :Exit;         // �������� �� ������� 5000 � 5050(�� �������)
    eLog_available            :m_status.m_available := m_status.m_available + _count;         // ��������
    eLog_home                 :m_status.m_home      := m_status.m_home + _count;              // �����
    eLog_exodus               :m_status.m_exodus    := m_status.m_exodus + _count;            // �����
    eLog_break                :m_status.m_break     := m_status.m_break + _count;             // �������
    eLog_dinner               :m_status.m_dinner    := m_status.m_dinner + _count;            // ����
    eLog_postvyzov            :m_status.m_postvyzov := m_status.m_postvyzov + _count;         // ���������
    eLog_studies              :m_status.m_studies   := m_status.m_studies + _count;           // �����
    eLog_IT                   :m_status.m_IT        := m_status.m_IT + _count;                // ��
    eLog_transfer             :m_status.m_transfer  := m_status.m_transfer + _count;          // ��������
    eLog_reserve              :m_status.m_reserve   := m_status.m_reserve + _count;           // ������
    eLog_callback             :m_status.m_callback  := m_status.m_callback + _count;          // callback
    eLog_create_new_user      :Exit;         // �������� ������ ������������  (�� �������)
    eLog_edit_user            :Exit;         // �������������� ������������  (�� �������)
  end;
end;
end.