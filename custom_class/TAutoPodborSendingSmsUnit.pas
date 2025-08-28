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
  System.Classes, System.SysUtils, Data.Win.ADODB, Data.DB, System.Variants,
  TCustomTypeUnit, System.DateUtils;


 // class TStructSending

  type
      TStructSending = class
      public
      m_idBase          :Integer;
      m_idSms           :string;
      m_dateTime        :string;
      m_code            :enumStatusCodeSms;
      m_status          :string;
      m_timeStatus      :string;
      m_message         :string;  // само сообщение
      m_userSending     :Integer; // пользователь который отправил сообщение
      m_userLogin       :string;  // логин входа пользователя

      constructor Create;    overload;
      constructor Create(_id:Integer;
                         _idSms:string;
                         _date:string;
                         _code:enumStatusCodeSms;
                         _status:string;
                         _timeStatus:string;
                         _message:string;
                         _userSending:Integer;
                         _userLogin:string);    overload;
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
      function GetStatusString(_id:Integer):string;

      function GetSmsID(_id:Integer):string;
      function GetSendingDate(_id:Integer):string;
      function GetCodeStatusString(_id:Integer):string;
      function GetCodeStatusEnum(_id:Integer):enumStatusCodeSms;
      function GetStatusTime(_id:Integer):string;
      function GetMessageSMS(_id:Integer):string;
      function GetUserFIO(_id:Integer):string;
      function GetUserLogin(_id:Integer):string;

      public
      constructor Create(_phone:string);    overload;
      constructor Create(_sendingSMS:TAutoPodborSendingSms);    overload;

      destructor Destroy;                    override; // Объявление деструктора

      property Count:Integer read m_count;

      property Phone:string read m_phone;
      property Status[_id:Integer]:string read GetStatusSending;default;
      property StatusDecrypt[_id:Integer]:string read GetStatusString;
      property CodeStatusString[_id:Integer]:string read GetCodeStatusString;
      property CodeStatusEnum[_id:Integer]:enumStatusCodeSms read GetCodeStatusEnum;
      property SmsID[_id:Integer]:string read GetSmsID;
      property SendingDate[_id:Integer]:string read GetSendingDate;
      property TimeStatus[_id:Integer]:string read GetStatusTime;
      property MessageSMS[_id:Integer]:string read GetMessageSMS;
      property UserFIOSending[_id:Integer]:string read GetUserFIO;
      property UserLogin[_id:Integer]:string read GetUserLogin;


      end;
 // class TAutoPodborSendingSms END

implementation

uses
  GlobalVariablesLinkDLL;

constructor TStructSending.Create;
begin
  Clear;
end;

constructor TStructSending.Create(_id:Integer;
                                  _idSms:string;
                                  _date:string;
                                  _code:enumStatusCodeSms;
                                  _status:string;
                                  _timeStatus:string;
                                  _message:string;
                                  _userSending:Integer;
                                  _userLogin:string);
begin
  m_idBase:=_id;
  m_idSms:=_idSms;
  m_dateTime:=_date;
  m_code:=_code;
  m_status:=_status;
  m_timeStatus:=_timeStatus;
  m_message:=_message;
  m_userSending:=_userSending;
  m_userLogin:=_userLogin;
end;



procedure TStructSending.Clear;
begin
  m_idBase:=0;
  m_idSms:='0';
  m_dateTime:='';
  m_code:=eStatusCodeSmsUnknown;
  m_status:='';
  m_timeStatus:='';
  m_message:='';
  m_userSending:=-1;
  m_userLogin:='';
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


constructor TAutoPodborSendingSms.Create(_sendingSMS:TAutoPodborSendingSms);
var
  i: Integer;
  src, dst: TStructSending;
begin
  inherited Create;

  m_phone := _sendingSMS.m_phone;

  m_count := _sendingSMS.m_count;
  SetLength(m_list, m_count);


  for i := 0 to m_count - 1 do
  begin
    src:= _sendingSMS.m_list[i];
    dst:= TStructSending.Create(src.m_idBase,
                                src.m_idSms,
                                src.m_dateTime,
                                src.m_code,
                                src.m_status,
                                src.m_timeStatus,
                                src.m_message,
                                src.m_userSending,
                                src.m_userLogin);
    m_list[i]:=dst;
  end;
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
                                    _sending.m_idSms,
                                    _sending.m_dateTime,
                                    _sending.m_code,
                                    _sending.m_status,
                                    _sending.m_timeStatus,
                                    _sending.m_message,
                                    _sending.m_userSending,
                                    _sending.m_userLogin);

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


function TAutoPodborSendingSms.GetStatusString(_id:Integer):string;
begin
 Result:=m_list[_id].m_status;
end;

function TAutoPodborSendingSms.GetSmsID(_id:Integer):string;
begin
  Result:=m_list[_id].m_idSms;
end;


function TAutoPodborSendingSms.GetSendingDate(_id:Integer):string;
begin
  Result:=m_list[_id].m_dateTime;
end;

function TAutoPodborSendingSms.GetCodeStatusString(_id:Integer):string;
begin
 Result:=EnumStatusCodeSmsToString(m_list[_id].m_code);
end;

function TAutoPodborSendingSms.GetCodeStatusEnum(_id:Integer):enumStatusCodeSms;
begin
 Result:=m_list[_id].m_code;
end;


function TAutoPodborSendingSms.GetStatusTime(_id:Integer):string;
begin
  Result:=m_list[_id].m_timeStatus;
end;

function TAutoPodborSendingSms.GetMessageSMS(_id:Integer):string;
begin
  Result:=m_list[_id].m_message;
end;

function TAutoPodborSendingSms.GetUserFIO(_id:Integer):string;
begin
 Result:=GetUserNameFIO(m_list[_id].m_userSending);
end;

function TAutoPodborSendingSms.GetUserLogin(_id:Integer):string;
begin
 Result:=m_list[_id].m_userLogin;
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
        Append('select id,sms_id,date_time,status,status_date,message,user_id,user_login_pc ');
        Append('from '+EnumReportTableSMSToString(eTableHistorySMS));
        Append(' where phone = '+#39+m_phone+#39);
        Append(' UNION ');
        Append('select id,sms_id,date_time,status,status_date,message,user_id,user_login_pc ');
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
       sendingSMS.m_idSms:=VarToStr(Fields[1].Value);
       sendingSMS.m_dateTime:=VarToStr(Fields[2].Value);
       sendingSMS.m_code:= StringToEnumStatusCodeSms((VarToStr(Fields[3].Value)));
       sendingSMS.m_status:=GetStatusSms(sendingSMS.m_code);
       sendingSMS.m_timeStatus:=VarToStr(Fields[4].Value);
       sendingSMS.m_message:=VarToStr(Fields[5].Value);
       sendingSMS.m_userSending:=StrToInt(VarToStr(Fields[6].Value));
       sendingSMS.m_userLogin:=VarToStr(Fields[7].Value);

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