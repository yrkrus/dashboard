library core;

uses
  System.ShareMem,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Data.Win.ADODB,
  Data.DB,
  Variants,
  System.DateUtils,
  Winapi.TlHelp32,
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\..\gui\TCustomTypeUnit.pas';

{$R *.res}

// создание подключения к серверу
function createServerConnect: Pointer; stdcall; // Возвращаем указатель
begin
  Result:= Pointer(TADOConnection.Create(nil)); // Создаем объект и возвращаем указатель

  with TADOConnection(Result) do
  begin
    DefaultDatabase := GetServerAddress;
    Provider := 'MSDASQL.1';
    ConnectionString := 'Provider=' + Provider +
                        ';Password=' + GetServerPassword +
                        ';Persist Security Info=True;User ID=' + GetServerUser +
                        ';Extended Properties="Driver=MySQL ODBC 5.3 Unicode Driver;SERVER=' + GetServerAddress +
                        ';UID=' + GetServerUser +
                        ';PWD=' + GetServerPassword +
                        ';DATABASE=' + DefaultDatabase +
                        ';PORT=3306;COLUMN_SIZE_S32=1";Initial Catalog=' + DefaultDatabase;

    LoginPrompt := False;  // без запроса на вывод логин\пароль

    try
      Connected := True;
      Open;
    except
      on E: Exception do
      begin
        Free; // Освобождаем память в случае ошибки
        Result:=nil;
        //raise; // Можно поднять исключение, чтобы сообщить об ошибке
      end;
    end;
  end;
end;

function GetCopyright:PChar;stdcall;export;
var
  CurrentYear: string;
begin
  CurrentYear:=FormatDateTime('yyyy', Now);
  if CurrentYear='2024' then Result:=PChar('developer by Petrov Yuri © '+CurrentYear+'       ')
  else Result:=PChar('developer by Petrov Yuri © 2024-'+CurrentYear+'       ');
end;


// полчуение имени пользователя из его UserID
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


// есть ли доступ у пользователя к локальному чату
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


// есть ли доступ у пользователя к отчетам
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

// текущая версия дашборда (БД)
function GetRemoteVersionDashboard:PChar; stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=Pchar('null');

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

 // проверка на копию exe
function GetCloneRun(InExeName:Pchar):Boolean; stdcall; export;
var
 m_mutex:Cardinal;
begin
  Result:=False;
  // проверка на запущенную копию
   m_mutex:= CreateMutex(nil, True, PChar(InExeName));
   if GetLastError = ERROR_ALREADY_EXISTS then Result:=True;
end;


 //принудительное завершение работы
procedure KillProcessNow; stdcall; export;
begin
  TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
end;

function GetUserNameFIO(InUserID:Integer):PChar; stdcall; export;
begin
  Result:=PChar(GetUserFIO(InUserID));
end;


// текущее время начала дня
function getNowDateTime:string;
begin
  Result:= FormatDateTime('yyyy-mm-dd 00:00:00', Now);
end;


function GetCurrentStartDateTime:PChar; stdcall; export;
begin
 Result:= PChar(getNowDateTime);
end;

// текущее время начала дня (минус минуты)
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


// только текущая дата
function getCurrentNowTime:string;
begin
  Result:= FormatDateTime('yyyymmdd', Now);
end;

function GetCurrentTime:PChar; stdcall; export;
begin
  Result:=PChar(getCurrentNowTime);
end;

// папка с локальным чатом
function GetLocalChatNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('chat_history');
end;

// расширение логов
function GetExtensionLog:PChar; stdcall; export;
begin
 Result:= PChar('.html');
end;

// папка с логом
function GetLogNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('log');
end;

// папка с update
function GetUpdateNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('update');
end;


// функция остановки exe
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

// проверка запущен ли процесс
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


 // перевод даты и времени в ненормальный вид для BD
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

 // перевод даты в ненормальный вид для BD
function GetDateToDateBD(InDateTime:string):PChar;stdcall;export;
var
 Datetmp:string;
begin
 Datetmp:=InDateTime;
 System.Delete(Datetmp,AnsiPos(' ',Datetmp),Length(Datetmp));
 Datetmp:=Copy(Datetmp,7,4)+'-'+Copy(Datetmp,4,2)+'-'+Copy(Datetmp,1,2);

 Result:=PChar(Datetmp);
end;

// перевод времени разговора оператора типа 00:00:00 в секунды
function GetTimeAnsweredToSeconds(InTimeAnswered:string):Integer; stdcall;export;
 const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
 var
 tmp_time:TTime;
 curr_time:Integer;
begin
  tmp_time:=StrToDateTime(InTimeAnswered);
  curr_time:=HourOf(tmp_time) * 3600 + MinuteOf(tmp_time) * 60 + SecondOf(tmp_time);

  Result:=curr_time;
end;


// перевод времени разговора оператора типа из секунд в 00:00:00
function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;export;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
 ss, mm, hh: word;
 hour,min,sec:string;
begin

  hh := (InSecondAnswered mod SecPerDay) div SecPerHour;
  mm := ((InSecondAnswered mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((InSecondAnswered mod SecPerDay) mod SecPerHour) mod SecPerMinute;


  if hh<=9 then hour:='0'+IntToStr(hh)
  else hour:=IntToStr(hh);
  if mm<=9 then min:='0'+IntToStr(mm)
  else min:=IntToStr(mm);
  if ss<=9 then sec:='0'+IntToStr(ss)
  else sec:=IntToStr(ss);

  Result:=PChar(hour+':'+min+':'+sec);
end;


// время которое необходимо отнимать от текущего звонка в очереди
function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer; stdcall;export;
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
           SQL.Add('select queue_5000_time from settings order by id desc limit 1');
         end;
         queue_5050:begin
           SQL.Add('select queue_5050_time from settings order by id desc limit 1');
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


// конвертер из string в TQueue
function StringToTQueue(InQueueSTR:string):enumQueueCurrent; stdcall;export;
begin
  if InQueueSTR = '5000' then Result:=queue_5000;
  if InQueueSTR = '5050' then Result:=queue_5050;
end;

// конвертер из TQueue в string
function TQueueToString(InQueueSTR:enumQueueCurrent):PChar; stdcall;export;
begin
  case InQueueSTR of
    queue_5000: Result:=PChar('5000');
    queue_5050: Result:=PChar('5050');
  end;
end;



// полчуение имени пользователя из его SIP номера
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

exports
  createServerConnect,
  GetCopyright,
  GetUserNameFIO,
  GetUserAccessLocalChat,
  GetUserAccessReports,
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
  GetUserNameOperators;

begin
end.
