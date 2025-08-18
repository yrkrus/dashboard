unit GlobalVariablesLinkDLL;

interface

uses
  TCustomTypeUnit;

 // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ”казатель на TADOConnection
  function createServerConnect: p_TADOConnection; overload;             stdcall;  external 'core.dll';       // —оздание подключени€ к серверу
  function createServerConnectWithError(var _errorDescriptions: string): p_TADOConnection; overload;             stdcall;  external 'core.dll';       // —оздание подключени€ к серверу
  function GetDefaultDataBase:PChar;                                    stdcall;  external 'core.dll';       // текущий адрес базы данных к которому идет подключений
  function GetCopyright:Pchar;                                          stdcall;  external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;                      stdcall;  external 'core.dll';       // полчуение имени пользовател€ из его UserID
  function GetRoleID(InRole:string):Integer;                            stdcall;  external 'core.dll';       // получение ID TRole
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;            stdcall;  external 'core.dll';       // есть ли доступ у пользовател€ к локальному чату
  function GetUserAccessReports(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // есть ли доступ у пользовател€ к отчетам
  function GetUserAccessSMS(InUserID:Integer):Boolean;                  stdcall;  external 'core.dll';       // есть ли доступ у пользовател€ к SMS отправке
  function GetUserAccessService(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // есть ли доступ у пользовател€ к услугам
   //function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload; stdcall; external 'core.dll';       // текущее начала дн€ минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload; stdcall; external 'core.dll';       // текущее начала дн€ с минутами 00:00:00
  function GetCurrentTime:PChar;                                        stdcall;  external 'core.dll';       // текущее врем€
  function GetLocalChatNameFolder:PChar;                                stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetExtensionLog:PChar;                                       stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetLogNameFolder:PChar;                                      stdcall;  external 'core.dll';       // папка с логом
  function GetUpdateNameFolder:PChar;                                   stdcall;  external 'core.dll';       // папка с update (обновлени€ем)
  function GetRemoteVersionDashboard(var _errorDescriptions:string):PChar;    stdcall;  external 'core.dll';       // текуща€ верси€ дашборда (Ѕƒ)
  function KillTask(ExeFileName:string):integer;                        stdcall;  external 'core.dll';       // функци€ остановки exe
  procedure KillProcessNow;                                             stdcall;  external 'core.dll';       // немедленное звершение работы
  function GetTask(ExeFileName:string):Boolean;                         stdcall;  external 'core.dll';       // проверка запущен ли процесс
  function GetCloneRun(InExeName:Pchar):Boolean;                        stdcall;  external 'core.dll';       // проверка на 2ую запущенную копию
  function GetDateTimeToDateBD(InDateTime:string):PChar;                stdcall;  external 'core.dll';       // перевод даты и времени в ненормальный вид дл€ BD
  function GetDateToDateBD(InDateTime:string):PChar;                    stdcall;  external 'core.dll';       // перевод даты в ненормальный вид дл€ BD
  function GetTimeAnsweredToSeconds(InTimeAnswered:string; isReducedTime:Boolean = False):Integer; stdcall;  external 'core.dll'; // перевод времени разговора оператора типа 00:00:00 в секунды
  function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar;                  stdcall;  external 'core.dll'; // перевод времени разговора оператора типа из секунд в 00:00:00
  function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;           stdcall;  external 'core.dll';      // врем€ которое необходимо отнимать от текущего звонка в очереди
  function StringToTQueue(InQueueSTR:string):enumQueueCurrent;          stdcall;  external 'core.dll';      // конвертер из string в TQueue
  function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;           stdcall;  external 'core.dll';      // конвертер из TQueue в string
  function GetUserNameOperators(InSip:string):PChar;                    stdcall;  external 'core.dll';      // полчуение имени пользовател€ из его SIP номера
  function GetCurrentUserNamePC:PChar;                                  stdcall;  external 'core.dll';      // получение имени залогиненого пользовател€ (из системы)
  function GetCountSendingSMSToday:Integer;                             stdcall;  external 'core.dll';      // кол-во отправленных за сегодн€ смс
  function Ping(InIp:string):Boolean;                                   stdcall;  external 'core.dll';      // проверка ping
  function IsServerIkExistWorkingTime(_id:Integer):Boolean;             stdcall;  external 'core.dll';      // настроен ли врем€ работы в сервере » 
  function GetClinicId(_nameClinic:string):Integer;                     stdcall;  external 'core.dll';      // id клиники
  function GetAliveCoreDashboard:Boolean;                               stdcall;  external 'core.dll';      // живое ли €дро дашборда



  // --- connect_to_server.dll ---  (по сути этот тут не нужно, но пусть будет)
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerNameTest:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы(тестовой)
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // пароль
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // адрес ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // логин
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // пароль
 function GetTCPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // адрес tcp server core_dashboard
 function GetTCPServerPort:Word;        stdcall;   external 'connect_to_server.dll'; // port tcp server core_dashboard



implementation

end.
