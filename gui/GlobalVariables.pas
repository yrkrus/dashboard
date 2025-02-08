/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB,
  Data.DB, SysUtils, Windows, TLogFileUnit,
  TIVRUnit, TCustomTypeUnit;

var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  // текущая директория откуда запускаем *.exe
  FOLDERPATH        :string;

  // Текущая версия GUID   ctrl+shift+G (GUID)
  GUID_VESRION      :string = 'EB11A1B9';

  // exe родителя
  DASHBOARD_EXE     :string = 'dashboard.exe';

  // файл с настройками
  SETTINGS_XML      :string = 'settings.xml';

  // чат
  CHAT_EXE          :string = 'chat.exe';
  // отчеты
  REPORT_EXE        :string = 'report.exe';
  // sms рассылка
  SMS_EXE           :string = 'sms.exe';

  USER_ID_PARAM     :string = '--USER_ID';


  // служба обновления
  UPDATE_EXE        : string = 'update.exe';
  UPDATE_SERVICES   : string = 'update_dashboard';
  UPDATE_BAT        : string = 'update.bat'; // обновлялка

  // иконка авторизации
  ICON_AUTH_USER          : string = 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    : string = 'user_icon_auth_admin.png';

  ///////////////////// CLASSES /////////////////////

  // лог главной формы
  SharedMainLog:TLoggingFile;

  // текущий залогиненый пользователь в системе
  SharedCurrentUserLogon: TUser;

  // список с текущими активными операторами
  SharedActiveSipOperators: TActiveSIP;

  // список с текущим IVR кто звонит на линию
  SharedIVR: TIVR;

  // внутренние процессы дашборда
 // SharedInternalProcess:TInternalProcess;

 ///////////////////// CLASSES /////////////////////


  // параметр для лога что есть ошибка
  IS_ERROR:Boolean = True;

  // глобальная ошибка при подключении к БД
  CONNECT_BD_ERROR        :Boolean = False;



  // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection; overload;             stdcall;  external 'core.dll';       // Создание подключения к серверу
  function createServerConnectWithError(var _errorDescriptions: string): p_TADOConnection; overload;             stdcall;  external 'core.dll';       // Создание подключения к серверу
  function GetCopyright:Pchar;                                stdcall;  external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;  external 'core.dll';       // полчуение имени пользователя из его UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;  stdcall;  external 'core.dll';       // есть ли доступ у пользователя к локальному чату
  function GetUserAccessReports(InUserID:Integer):Boolean;    stdcall;  external 'core.dll';       // есть ли доступ у пользователя к отчетам
  function GetUserAccessSMS(InUserID:Integer):Boolean;        stdcall;  external 'core.dll';       // есть ли доступ у пользователя к SMS отправке
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload; stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload; stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00
  function GetCurrentTime:PChar;                              stdcall;  external 'core.dll';       // текущее время
  function GetLocalChatNameFolder:PChar;                      stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetExtensionLog:PChar;                             stdcall;  external 'core.dll';       // папка с локальным чатом
  function GetLogNameFolder:PChar;                            stdcall;  external 'core.dll';       // папка с логом
  function GetUpdateNameFolder:PChar;                         stdcall;  external 'core.dll';       // папка с update (обновленияем)
  function GetRemoteVersionDashboard:PChar;                   stdcall;  external 'core.dll';       // текущая версия дашборда (БД)
  function KillTask(ExeFileName:string):integer;              stdcall;  external 'core.dll';       // функция остановки exe
  procedure KillProcessNow;                                   stdcall;  external 'core.dll';       // немедленное звершение работы
  function GetTask(ExeFileName:string):Boolean;               stdcall;  external 'core.dll';       // проверка запущен ли процесс
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;  external 'core.dll';       // проверка на 2ую запущенную копию
  function GetDateTimeToDateBD(InDateTime:string):PChar;      stdcall;  external 'core.dll';       // перевод даты и времени в ненормальный вид для BD
  function GetDateToDateBD(InDateTime:string):PChar;          stdcall;  external 'core.dll';       // перевод даты в ненормальный вид для BD
  function GetTimeAnsweredToSeconds(InTimeAnswered:string):Integer; stdcall;  external 'core.dll'; // перевод времени разговора оператора типа 00:00:00 в секунды
  function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;  external 'core.dll'; // перевод времени разговора оператора типа из секунд в 00:00:00
  function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;  stdcall;  external 'core.dll';      // время которое необходимо отнимать от текущего звонка в очереди
  function StringToTQueue(InQueueSTR:string):enumQueueCurrent; stdcall;  external 'core.dll';      // конвертер из string в TQueue
  function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;  stdcall;  external 'core.dll';      // конвертер из TQueue в string
  function GetUserNameOperators(InSip:string):PChar;           stdcall;  external 'core.dll';      // полчуение имени пользователя из его SIP номера



  // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // пароль
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // адрес ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // логин
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // пароль


implementation


initialization  // Инициализация
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedMainLog             := TLoggingFile.Create('main');   // лог работы main формы

finalization
  // Освобождение памяти
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
