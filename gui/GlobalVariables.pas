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
  TIVRUnit;

var
  // текущая директория откуда запускаем chat.exe
  FOLDERPATH:string;

  // Текущая версия GUID   ctrl+shift+G (GUID)
  GUID_VESRION    :string = '11FC1DF8';

  // файл с настройками
  SETTINGS_XML    :string = 'settings.xml';

  // чат
  CHAT_EXE         :string = 'chat.exe';
  CHAT_PARAM       :string = '--USER_ID';

  // служба обновления
  UPDATE_EXE        : string = 'update_dashboard.exe';

  // список с текущими активными операторами
  SharedActiveSipOperators: TActiveSIP;

  // список с текущим IVR кто звонит на линию
  SharedIVR: TIVR;

  // параметр для лога что есть ошибка
  IS_ERROR:Boolean = True;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;

  // текущий залогиненый пользователь в системе
  SharedCurrentUserLogon: TUser;

  // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // Создание подключения к серверу
  function GetCopyright:Pchar;                   stdcall;    external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;   stdcall;     external 'core.dll';       // полчуение имени пользователя из его UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // есть ли доступ у пользователя к локальному чату
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00
  function GetCurrentTime:PChar; stdcall; external 'core.dll';       // текущее время
  function GetLocalChatNameFolder:PChar; stdcall; external 'core.dll';       // // папка с локальным чатом
  function GetExtensionLog:PChar; stdcall; external 'core.dll';       // // папка с локальным чатом
  function GetLogNameFolder:PChar; stdcall; external 'core.dll';       // // папка с логом
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // функция остановки exe
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // проверка запущен ли процесс


  // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // пароль


implementation



initialization  // Инициализация
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedActiveSipOperators := TActiveSIP.Create;
  SharedIVR := TIVR.Create;

  //SharedLoggingFile := TLoggingFile.Create;

finalization
  // Освобождение памяти
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
