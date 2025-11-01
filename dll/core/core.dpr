library core;

uses
  System.ShareMem, System.SysUtils, System.Classes,
  Winapi.Windows, Data.Win.ADODB, Data.DB, Variants,
  System.DateUtils, Winapi.TlHelp32,  IdIcmpClient,
  IdTCPClient,
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\..\custom_class\TCustomTypeUnit.pas';

{$R *.res}

// ======== ����� ������ ���� ������ =========
function _DefaultDataBase:string;
begin
  Result:=GetServerName;
 //  Result:=GetServerNameTest;
end;
// ======== ����� ������ ���� ������ =========

function _dll_GetDefaultDataBase:PChar; stdcall; export;
begin
  Result:=PChar(_DefaultDataBase);
end;


// �������� ����������� � �������
function createServerConnect: Pointer; stdcall; overload; // ���������� ���������
begin
  Result:= Pointer(TADOConnection.Create(nil)); // ������� ������ � ���������� ���������

  with TADOConnection(Result) do
  begin
    DefaultDatabase := _DefaultDataBase;
    Provider := 'MSDASQL.1';
    ConnectionString := 'Provider=' + Provider +
                        ';Password=' + GetServerPassword +
                        ';Persist Security Info=True;User ID=' + GetServerUser +
                        ';Extended Properties="Driver=MySQL ODBC 5.3 Unicode Driver;SERVER=' + GetServerAddress +
                        ';UID=' + GetServerUser +
                        ';PWD=' + GetServerPassword +
                        ';DATABASE=' + DefaultDatabase +
                        ';PORT=3306;COLUMN_SIZE_S32=1";Initial Catalog=' + DefaultDatabase;

    LoginPrompt := False;  // ��� ������� �� ����� �����\������

    try
      Connected := True;
      Open;
    except
      on E: Exception do
      begin
        Free; // ����������� ������ � ������ ������
        Result:=nil;
        //raise; // ����� ������� ����������, ����� �������� �� ������
      end;
    end;
  end;
end;

function createServerConnectWithError(var _errorDescriptions:string): Pointer; stdcall; export; // ���������� ���������
begin
  Result:= Pointer(TADOConnection.Create(nil)); // ������� ������ � ���������� ���������

  _errorDescriptions:='';

  with TADOConnection(Result) do
  begin
    DefaultDatabase := _DefaultDataBase;
    Provider := 'MSDASQL.1';
    ConnectionString := 'Provider=' + Provider +
                        ';Password=' + GetServerPassword +
                        ';Persist Security Info=True;User ID=' + GetServerUser +
                        ';Extended Properties="Driver=MySQL ODBC 5.3 Unicode Driver;SERVER=' + GetServerAddress +
                        ';UID=' + GetServerUser +
                        ';PWD=' + GetServerPassword +
                        ';DATABASE=' + DefaultDatabase +
                        ';PORT=3306;COLUMN_SIZE_S32=1";Initial Catalog=' + DefaultDatabase;

    LoginPrompt := False;  // ��� ������� �� ����� �����\������

    try
      Connected := True;
      Open;
    except
      on E: Exception do
      begin
        _errorDescriptions:=PChar(e.ClassName+ ' '+ e.Message);

        Free; // ����������� ������ � ������ ������
        Result:=nil;

       // raise; // ����� ������� ����������, ����� �������� �� ������
      end;
    end;
  end;
end;



function GetCopyright:PChar;stdcall;export;
const
 cSTART_YEAR:string = '2024';
var
  CurrentYear: string;
begin
  CurrentYear:=FormatDateTime('yyyy', Now);
  if CurrentYear = cSTART_YEAR then Result:=PChar('developer by Petrov Yuri � '+CurrentYear+'       ')
  else Result:=PChar('developer by Petrov Yuri � '+cSTART_YEAR+'-'+CurrentYear+'       ');
end;


// ��������� ����� ������������ �� ��� UserID
function GetUserFIO(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select familiya,name from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;

      Result:=VarToStr(Fields[0].Value)+' '+VarToStr(Fields[1].Value);
    end;
  finally
    FreeAndNil(ado);
    serverConnect.Close;
    if Assigned(serverConnect) then FreeAndNil(serverConnect);
  end;
end;



// ��������� ID TRole
function GetRoleID(InRole:string):Integer; stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select id from role where name_role = '+#39+InRole+#39);

      Active:=True;
      Result:=StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
    end;
  end;
end;

// ���� �� ������ � ������������ � ���������� ����
function GetUserAccessLocalChat(InUserID:Integer):Boolean;stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select chat from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;
      if StrToInt(VarToStr(Fields[0].Value)) = 1  then  Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���� �� ������ � ������������ � �������
function GetUserAccessReports(InUserID:Integer):Boolean;stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select reports from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;
      if StrToInt(VarToStr(Fields[0].Value)) = 1  then  Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���� �� ������ � ������������ � �������
function GetUserAccessService(InUserID:Integer):Boolean;stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select reports from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;
      if StrToInt(VarToStr(Fields[0].Value)) = 1  then  Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���� �� ������ � ������������ � SMS ��������
function GetUserAccessSMS(InUserID:Integer):Boolean;stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select sms from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;
      if StrToInt(VarToStr(Fields[0].Value)) = 1  then  Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ������� ������ �������� (��)
function GetRemoteVersionDashboard(var _errorDescriptions:string):PChar; stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=Pchar('null');
  _errorDescriptions:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescriptions);
 if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
 end;

  try
   with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select id from version_current');
      Active:=True;

      Result:=Pchar(VarToStr(Fields[0].Value));
   end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

 // �������� �� ����� exe
function GetCloneRun(InExeName:Pchar):Boolean; stdcall; export;
var
 m_mutex:Cardinal;
begin
  Result:=False;
  // �������� �� ���������� �����
   m_mutex:= CreateMutex(nil, True, PChar(InExeName));
   if GetLastError = ERROR_ALREADY_EXISTS then Result:=True;
end;


 //�������������� ���������� ������
procedure KillProcessNow; stdcall; export;
begin
  TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
end;

function GetUserNameFIO(InUserID:Integer):PChar; stdcall; export;
begin
  Result:=PChar(GetUserFIO(InUserID));
end;


// ������� ����� ������ ���
function getNowDateTime:string;
begin
  Result:= FormatDateTime('yyyy-mm-dd 00:00:00', Now);
end;


function GetCurrentStartDateTime:PChar; stdcall; export;
begin
 Result:= PChar(getNowDateTime);
end;

// ������� ����� ������ ��� (����� ������)
function getNowDateTimeDec(DecMinutes:Integer):string;
var
  AdjustedTime: TDateTime;
begin
  AdjustedTime := IncMinute(Now, -DecMinutes);
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', AdjustedTime);
end;


function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; stdcall; export;
begin
  Result:=PChar(getNowDateTimeDec(DecMinutes));
end;


// ������ ������� ����
function getCurrentNowTime:string;
begin
  Result:= FormatDateTime('yyyymmdd', Now);
end;

function GetCurrentTime:PChar; stdcall; export;
begin
  Result:=PChar(getCurrentNowTime);
end;

// ����� � ��������� �����
function GetLocalChatNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('chat_history');
end;

// ���������� �����
function GetExtensionLog:PChar; stdcall; export;
begin
 Result:= PChar('.html');
end;

// ����� � �����
function GetLogNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('log');
end;

// ����� � update
function GetUpdateNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('update');
end;


// ������� ��������� exe
function KillTask(ExeFileName: string): integer;stdcall;export;
 const
  PROCESS_TERMINATE=$0001;
 var ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
        or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)))
    then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
                                                     FProcessEntry32.th32ProcessID), 0));
      ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// �������� ������� �� �������
function GetTask(ExeFileName: string): Boolean;stdcall;export;
 var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
 begin
  result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
   begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)))
      then Result := True;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
  CloseHandle(FSnapshotHandle);
 end;


 // ������� ���� � ������� � ������������ ��� ��� BD
function GetDateTimeToDateBD(InDateTime:string):PChar;stdcall;export;
var
 Timetmp,Datetmp:string;
begin
 Timetmp:=InDateTime;
 System.Delete(Timetmp,1,AnsiPos(' ',Timetmp));

 Datetmp:=InDateTime;
 System.Delete(Datetmp,AnsiPos(' ',Datetmp),Length(Datetmp));
 Datetmp:=Copy(Datetmp,7,4)+'-'+Copy(Datetmp,4,2)+'-'+Copy(Datetmp,1,2);

 Result:=PChar(Datetmp+' '+Timetmp);
end;

 // ������� ���� � ������������ ��� ��� BD
function GetDateToDateBD(InDateTime:string):PChar;stdcall;export;
var
 Datetmp:string;
begin
 Datetmp:=InDateTime;
 System.Delete(Datetmp,AnsiPos(' ',Datetmp),Length(Datetmp));
 Datetmp:=Copy(Datetmp,7,4)+'-'+Copy(Datetmp,4,2)+'-'+Copy(Datetmp,1,2);

 Result:=PChar(Datetmp);
end;

// ������� ������� ��������� ��������� ���� 00:00:00 ��� 00:00 � �������
function GetTimeAnsweredToSeconds(InTimeAnswered:string; isReducedTime:Boolean = False):Integer; stdcall;export;
 const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
 var
 tmp_time:TTime;
 curr_time:Integer;
 parts: TArray<string>;
 minutes: Integer;
 seconds: Integer;
begin
  if isReducedTime then
  begin
   parts:=InTimeAnswered.Split([':']);

    // ������� ����� � ������� mm:ss
    if Length(parts) = 2 then
    begin
      // ����������� ������ � ������� � ����� �����
      minutes:= StrToInt(parts[0]);
      seconds:= StrToInt(parts[1]);
      // ��������� ����� ���������� ������
      Result := minutes * SecPerMinute + seconds;
    end
    else Result := 0;
  end
  else
  begin
    // ��������� ������� � ������� ���� � �������
    tmp_time := StrToDateTime(InTimeAnswered);
    curr_time := HourOf(tmp_time) * 3600 + MinuteOf(tmp_time) * 60 + SecondOf(tmp_time);
    Result := curr_time;
  end;
end;


// ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;export;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
  ss, mm, hh, dd: word;
  hour, min, sec, days: string;
begin

  // ��������� ���������� ����
  dd := InSecondAnswered div SecPerDay;
  // ��������� ���������� ����, ������ � �������
  hh := (InSecondAnswered mod SecPerDay) div SecPerHour;
  mm := ((InSecondAnswered mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((InSecondAnswered mod SecPerDay) mod SecPerHour) mod SecPerMinute;

  // ����������� ���
  if dd > 0 then days := IntToStr(dd) + '� '
  else days := '';

  // ����������� ����, ������ � �������
  if hh <= 9 then hour := '0' + IntToStr(hh)
  else hour := IntToStr(hh);

  if mm <= 9 then min := '0' + IntToStr(mm)
  else min := IntToStr(mm);

  if ss <= 9 then sec := '0' + IntToStr(ss)
  else sec := IntToStr(ss);

  // ��������� �������� ������
  Result := PChar(days + hour + ':' + min + ':' + sec);
end;


// ����� ������� ���������� �������� �� �������� ������ � �������
function GetIVRTimeQueue(InQueue:enumQueue):Integer; stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      case InQueue of
         queue_5000:begin
           SQL.Add('select queue_5000_time from settings order by date_time desc limit 1');
         end;
         queue_5050:begin
           SQL.Add('select queue_5050_time from settings order by date_time desc limit 1');
         end;
         queue_5911:begin
           SQL.Add('select queue_5911_time from settings order by date_time desc limit 1');
         end;
      end;

      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:=0;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� �� string � TQueue
function StringToTQueue(InQueueSTR:string):enumQueue; stdcall;export;
begin
  if InQueueSTR = '5000' then Result:=queue_5000;
  if InQueueSTR = '5050' then Result:=queue_5050;
  if InQueueSTR = '5911' then Result:=queue_5911;
end;

// ��������� �� TQueue � string
function TQueueToString(InQueueSTR:enumQueue):PChar; stdcall;export;
begin
  case InQueueSTR of
    queue_5000: Result:=PChar('5000');
    queue_5050: Result:=PChar('5050');
    queue_5911: Result:=PChar('5911');
  end;
end;



// ��������� ����� ������������ �� ��� SIP ������
function GetUserNameOperators(InSip:string):PChar; stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=PChar('null');

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select familiya,name from users where id = ( select user_id from operators where sip = '+#39+InSip+#39+') and disabled = ''0''');

      Active:=True;

      if Fields[0].Value<>null then Result:=PChar(VarToStr(Fields[0].Value)+' '+VarToStr(Fields[1].Value));
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� ����� ������������ ������������
function GetCurrentUserNamePC_LOCAL:string;
 const
   cnMaxUserNameLen = 254;
 var
   sUserName: string;
   dwUserNameLen: DWORD;
begin
   dwUserNameLen := cnMaxUserNameLen - 1;
   SetLength(sUserName, cnMaxUserNameLen);
   GetUserName(PChar(sUserName), dwUserNameLen);
   SetLength(sUserName, dwUserNameLen);
   Result:= PChar(sUserName);
end;

 // ��������� ����� ������������ ������������ (������� �������)
function GetCurrentUserNamePC:PChar; stdcall; export;
begin
  Result:=PChar(GetCurrentUserNamePC_LOCAL);
end;


// ���-�� ������������ �� ������� ���
function GetCountSendingSMSToday:Integer; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from sms_sending where date_time > '+#39+getNowDateTime+#39+' and user_id <> ''0'' ');

      Active:=True;
      Result:= StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
    end;
  end;
end;


// �������� ping
function Ping(InIp:string):Boolean; stdcall; export;
const
 error:word = 0;
var
  IcmpClient: TIdIcmpClient;
begin
  IcmpClient:= TIdIcmpClient.Create;
  try
    with IcmpClient do begin
      Host:=InIp;
      Ping(InIp,4);

      if ReplyStatus.TimeToLive <> error then Result:=True
      else Result:=False;
    end;
  finally
    IcmpClient.Free;
  end;
end;

// �������� �� ����� ������ � ������� ��
function IsServerIkExistWorkingTime(_id:Integer):Boolean; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from server_ik_worktime where id = '+#39+IntToStr(_id)+#39);

      Active:=True;
      if Fields[0].Value <> 0 then Result:=True;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// id �������
function GetClinicId(_nameClinic:string):Integer; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:= -1;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select id from server_ik where address  = '+#39+_nameClinic+#39);

      Active:=True;
      if Fields[0].Value <> 0 then Result:=Fields[0].Value;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// �������� ����� �� ���� ��������
function GetAliveCoreDashboard:Boolean; stdcall; export;
var
  client: TIdTCPClient;
begin
  Result := False;
  client := TIdTCPClient.Create(nil);
  try
    client.Host := GetTCPServerAddress;
    client.Port := GetTCPServerPort;
    client.ConnectTimeout := 1000;
    client.ReadTimeout    := 1000;
    try
      client.Connect;

      Result:= client.Connected;

      client.Disconnect;
    except
      Result:=False;
    end;
  finally
    client.Free;
  end;

end;


// ���������� _call_id ������
function _dll_GetCallIDPhoneIVR(_table:enumReportTableIVR; _phone:string):PChar; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 request:TStringBuilder;
begin
  Result:=PChar('null');
  table:=EnumReportTableIVRToString(_table);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    request:=TStringBuilder.Create;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with request do begin
        Clear;
        Append('select call_id, date_time from '+table);
        Append(' where phone = '+#39+_phone+#39);
        Append(' order by date_time desc limit 1');
      end;

      SQL.Add(request.ToString);

      Active:=True;
      if Fields[0].Value<>null then begin
        Result:=PChar(VarToStr(Fields[0].Value));
      end;

    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;


// ���������� �� ����� ����� ������ ����� ������� ���� � �������
function _dll_GetPhoneTrunkQueue(_table:enumReportTableIVR; _phone:string;_call_id:string):PChar; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 request:TStringBuilder;
begin
  Result:=PChar('null');
  table:=EnumReportTableIVRToString(_table);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    request:=TStringBuilder.Create;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with request do begin
        Clear;
        Append('select trunk from '+table);
        Append(' where phone = '+#39+_phone+#39);
        Append(' and call_id = '+#39+_call_id+#39+' and to_queue = 1 limit 1');
      end;

      SQL.Add(request.ToString);

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=PChar(VarToStr(Fields[0].Value));
      end
      else Result:=PChar('LISA');
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;


// ���������� id_ivr ����� ������� �� ����� ����� ������ ����� ������� ���� � �������
//function GetQueuePhoneCallIdIvr()


// ���������� � ������ ��������� ��������������� �������
function GetPhoneOperatorQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):PChar; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
begin
  Result:=PChar('null');
  table:=EnumReportTableIVRToString(_table);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select operator from '+table+' where phone = '+#39+_phone+#39+' and date_time < '+#39+GetDateTimeToDateBD(_timecall)+#39+' and to_queue = 1 limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=PChar(VarToStr(Fields[0].Value));
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

// ���������� � � ����� ������� ��������������� �������
function GetPhoneRegionQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):PChar; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
begin
  Result:=PChar('null');
  table:=EnumReportTableIVRToString(_table);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select region from '+table+' where phone = '+#39+_phone+#39+' and date_time < '+#39+GetDateTimeToDateBD(_timecall)+#39+' and to_queue = 1 limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=PChar(VarToStr(Fields[0].Value));
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


// ���������� ������� SMS ���������
function GetCodeStatusSms(_idSMS:Integer; _table:enumReportTableSMSStatus):enumStatusCodeSms; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
begin
  Result:=eStatusCodeSmsUnknown; // �� �� ��� unknown
  table:=EnumReportTableSMSToString(_table);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select status from '+table+' where id = '+#39+IntToStr(_idSMS)+#39);

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=StringToEnumStatusCodeSms((VarToStr(Fields[0].Value)));
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


// ���������� ������� ���������
function GetStatusSms(_code:enumStatusCodeSms):PChar; stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
begin
  Result:=PChar(EnumStatusCodeSmsToString(eStatusCodeSmsUnknown));

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select code_value from sms_code where id = '+#39+EnumStatusCodeSmsToString(_code)+#39);

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=PChar(VarToStr(Fields[0].Value));
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


// ���-�� ������������ SMS ��������� �� ������
function GetCountSmsSendingMessageInPhone(_phone:string):Integer;  stdcall; export;
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  countSMS:Integer;
  request:TStringBuilder;
begin
  Result:=0;

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
        Append('select ');
        Append('(select count(*) ');
        Append('from '+EnumReportTableSMSToString(eTableHistorySMS));
        Append(' where phone = '+#39+_phone+#39);
        Append(')');
        Append(' +');
        Append(' (select count(*) ');
        Append('from '+EnumReportTableSMSToString(eTableSMS));
        Append(' where phone = '+#39+_phone+#39);
        Append(')');
        Append(' AS total_count');
       end;

      SQL.Add(request.ToString);
      Active:= True;

      Result:=StrToInt(VarToStr(Fields[0].Value));
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


function _dll_GetAllowCommonQueueList:TStringList; stdcall; export;
const
 queue5000:string = '5000';
 queue5050:string = '5050';
 queue5911:string = '5911';
begin
  Result:=TStringList.Create;
  Result.Add(queue5000);
  Result.Add(queue5050);
  Result.Add(queue5911);
end;


// ����������� SIP ������������
function _dll_GetOperatorSIP(_userId:integer):integer;  stdcall; export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=-1;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(_userId)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:= StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;



exports
  _dll_GetDefaultDataBase,
  createServerConnect,
  createServerConnectWithError,
  GetCopyright,
  GetUserNameFIO,
  GetRoleID,
  GetUserAccessLocalChat,
  GetUserAccessReports,
  GetUserAccessSMS,
  GetRemoteVersionDashboard,
  GetCloneRun,
  KillProcessNow,
  GetCurrentStartDateTime,
  GetCurrentDateTimeDec,
  GetCurrentTime,
  GetLocalChatNameFolder,
  GetExtensionLog,
  GetLogNameFolder,
  GetUpdateNameFolder,
  KillTask,
  GetTask,
  GetDateTimeToDateBD,
  GetDateToDateBD,
  GetTimeAnsweredToSeconds,
  GetTimeAnsweredSecondsToString,
  GetIVRTimeQueue,
  StringToTQueue,
  TQueueToString,
  GetUserNameOperators,
  GetCurrentUserNamePC,
  GetCountSendingSMSToday,
  Ping,
  IsServerIkExistWorkingTime,
  GetClinicId,
  GetAliveCoreDashboard,
  _dll_GetPhoneTrunkQueue,
  _dll_GetCallIDPhoneIVR,
  GetPhoneOperatorQueue,
  GetPhoneRegionQueue,
  GetCodeStatusSms,
  GetStatusSms,
  GetCountSmsSendingMessageInPhone,
  _dll_GetAllowCommonQueueList,
  _dll_GetOperatorSIP;

begin
end.
