unit GlobalVariables;

interface


const
 SERVICE_NAME               :string = 'update_dashboard';
 SERVICE_DESCRIPTION        :string = 'Служба обновления Дашборд КоллЦентра';

 // exe родителя
 DASHBOARD_EXE    :string = 'dashboard.exe';
 CHAT_EXE         :string = 'chat.exe';
 REPORT_EXE       :string = 'report.exe';
 SMS_EXE          :string = 'sms.exe';
 UPDATE_EXE       :string = 'update.exe';
 INSTALL_EXE      :string = 'install.exe';

 UPDATE_BAT       :string = 'update.bat';

 // файл с настройками
 SETTINGS_XML     :string = 'settings.xml';

 //  mysql connector
 CONNECTOR_INSTALL_X32    :string ='mysql-connector-odbc-5.3.2-win32.msi';
 CONNECTOR_INSTALL_X64    :string ='mysql-connector-odbc-5.3.2-win64.msi';

 // папка для скачивания
 FOLDER_INSTALL   :string = 'install';

 // папка установки
 INSTALL_DASHBOARD :string = 'C:\Program Files\dashboard';

 // параметр для лога что есть ошибка
 IS_ERROR:Boolean = True;

var
  FOLDERPATH:string;

   // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // Создание подключения к серверу
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00
  function GetCurrentTime:PChar; stdcall; external 'core.dll';       // текущее время
  function GetExtensionLog:PChar; stdcall; external 'core.dll';       // // тип лога
  function GetLogNameFolder:PChar; stdcall; external 'core.dll';       // // папка с логом
  function GetUpdateNameFolder:PChar; stdcall; external 'core.dll';       // // папка с update (обновленияем)
  function GetRemoteVersionDashboard(var _errorDescriptions:string):PChar; stdcall;external 'core.dll';        // текущая версия дашборда (БД)
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // функция остановки exe
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // проверка на 2ую запущенную копию
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // проверка запущен ли процесс

   // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // пароль
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // адрес ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // логин
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // пароль

implementation

uses
  SysUtils;

initialization  // Инициализация
  FOLDERPATH:=ExtractFilePath(ParamStr(0));




finalization
  // Освобождение памяти


end.
