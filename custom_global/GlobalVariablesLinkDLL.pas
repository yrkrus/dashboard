unit GlobalVariablesLinkDLL;

interface

uses
   System.ShareMem, TCustomTypeUnit, System.Classes;

 // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection; overload;             stdcall;  external 'core.dll';       // Создание подключения к серверу
  function createServerConnectWithError(var _errorDescriptions: string): p_TADOConnection; overload;             stdcall;  external 'core.dll';       // Создание подключения к серверу
  function _dll_GetDefaultDataBase:string;                               stdcall;  external 'core.dll';       // текущий адрес базы данных к которому идет подключений
  function GetCopyright:string;                                          stdcall;  external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):string;                      stdcall;  external 'core.dll';       // полчуение имени пользователя из его UserID
  function GetRoleID(InRole:string):Integer;                            stdcall;  external 'core.dll';       // получение ID TRole
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;            stdcall;  external 'core.dll';       // есть ли доступ у пользователя к локальному чату
  function GetUserAccessReports(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // есть ли доступ у пользователя к отчетам
  function GetUserAccessSMS(InUserID:Integer):Boolean;                  stdcall;  external 'core.dll';       // есть ли доступ у пользователя к SMS отправке
  function GetUserAccessService(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // есть ли доступ у пользователя к услугам
   //function GetCurrentDateTimeDec(DecMinutes:Integer):string;   overload; stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:string;                     overload; stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00
  function GetCurrentTime:string;                                        stdcall;  external 'core.dll';       // текущее время
  function GetLocalChatNameFolder:string;                                stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetExtensionLog:string;                                       stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetLogNameFolder:string;                                      stdcall;  external 'core.dll';       // папка с логом
  function GetUpdateNameFolder:string;                                   stdcall;  external 'core.dll';       // папка с update (обновленияем)
  function GetRemoteVersionDashboard(var _errorDescriptions:string):string;    stdcall;  external 'core.dll';       // текущая версия дашборда (БД)
  function KillTask(ExeFileName:string):integer;                        stdcall;  external 'core.dll';       // функция остановки exe
  procedure KillProcessNow;                                             stdcall;  external 'core.dll';       // немедленное звершение работы
  function GetTask(ExeFileName:string):Boolean;                         stdcall;  external 'core.dll';       // проверка запущен ли процесс
  function GetCloneRun(InExeName:Pchar):Boolean;                        stdcall;  external 'core.dll';       // проверка на 2ую запущенную копию
  function GetDateTimeToDateBD(InDateTime:string):string;                stdcall;  external 'core.dll';       // перевод даты и времени в ненормальный вид для BD
  function GetDateToDateBD(InDateTime:string):string;                    stdcall;  external 'core.dll';       // перевод даты в ненормальный вид для BD
  function GetTimeAnsweredToSeconds(InTimeAnswered:string; isReducedTime:Boolean = False):Integer; stdcall;  external 'core.dll'; // перевод времени разговора оператора типа 00:00:00 в секунды
  function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):string;                  stdcall;  external 'core.dll'; // перевод времени разговора оператора типа из секунд в 00:00:00
  function GetIVRTimeQueue(InQueue:enumQueue):Integer;           stdcall;  external 'core.dll';      // время которое необходимо отнимать от текущего звонка в очереди
  function StringToTQueue(InQueueSTR:string):enumQueue;          stdcall;  external 'core.dll';      // конвертер из string в TQueue
  function TQueueToString(InQueueSTR:enumQueue):string;           stdcall;  external 'core.dll';      // конвертер из TQueue в string
  function GetUserNameOperators(InSip:string):string;                    stdcall;  external 'core.dll';      // полчуение имени пользователя из его SIP номера
  function GetCurrentUserNamePC:string;                                  stdcall;  external 'core.dll';      // получение имени залогиненого пользователя (из системы)
  function GetCountSendingSMSToday:Integer;                             stdcall;  external 'core.dll';      // кол-во отправленных за сегодня смс
  function Ping(InIp:string):Boolean;                                   stdcall;  external 'core.dll';      // проверка ping
  function IsServerIkExistWorkingTime(_id:Integer):Boolean;             stdcall;  external 'core.dll';      // настроен ли время работы в сервере ИК
  function GetClinicId(_nameClinic:string):Integer;                     stdcall;  external 'core.dll';      // id клиники
  function GetAliveCoreDashboard:Boolean;                               stdcall;  external 'core.dll';      // есть ли подключение к ядро дашборда по tcp:12345 порту
  function _dll_GetCallIDPhoneIVR(_table:enumReportTableIVR; _phone:string):string; stdcall;  external 'core.dll'; // нахождение _callID звонка
  function _dll_GetPhoneTrunkQueue(_table:enumReportTableIVR; _phone:string;_call_id:string):string; stdcall;  external 'core.dll';   // нахождение на какой транк звонил номер который ушел в очередь
  function GetPhoneOperatorQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):string; stdcall;  external 'core.dll'; // нахождение у какого оператора зарегистрирован телефон
  function GetPhoneRegionQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):string; stdcall;  external 'core.dll'; // нахождение у в каком регионе зарегистрирован телефон
  function GetCodeStatusSms(_idSMS:Integer; _table:enumReportTableSMSStatus):enumStatusCodeSms; stdcall;  external 'core.dll';      // нахождение статуса SMS сообщения
  function GetStatusSms(_code:enumStatusCodeSms):string;                 stdcall;  external 'core.dll';      // нахождение статуса сообщения
  function GetCountSmsSendingMessageInPhone(_phone:string):Integer;     stdcall;  external 'core.dll';      // кол-во отправленных SMS сообщений на номере
  function _dll_GetAllowCommonQueueList:TStringList;                    stdcall;  external 'core.dll';      // список разрешенных очередей
  function _dll_GetOperatorSIP(_userId:integer):integer;                stdcall;  external 'core.dll';      // отображение SIP пользвоателя

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

 // --- ldap.dll ---
 function LdapAuth(_user,_pwd:string):Boolean;      stdcall;   external 'ldap.dll';  // проверка атворизации на ldap

implementation

end.
