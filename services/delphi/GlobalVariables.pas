unit GlobalVariables;

interface


const
 SERVICE_NAME               :string = 'update_dashboard';
 SERVICE_DESCRIPTION        :string = 'Служба обновления Дашборд КоллЦентра';

 // файл с настройками
 SETTINGS_XML    :string = 'settings.xml';

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
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // функция остановки exe
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // проверка запущен ли процесс

   // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // пароль


implementation

uses
  SysUtils;

initialization  // Инициализация
  FOLDERPATH:=ExtractFilePath(ParamStr(0));




finalization
  // Освобождение памяти


end.
