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
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB, Data.DB, SysUtils, Windows;

var
  // Текущая версия GUID   ctrl+shift+G (GUID)
  GUID_VESRION    :string = '11FC1DF8';

  // файл с настройками
  SETTINGS_XML    :string = 'settings.xml';

  // чат
  CHAT_EXE         :string = 'chat.exe';
  CHAT_PARAM       :string = '--USER_ID';

  // список с текущими активными операторами
  SharedActiveSipOperators: TActiveSIP;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean =  False;

  // текущий залогиненый пользователь в системе
  SharedCurrentUserLogon: TUser;

  // загрузка DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // Создание подключения к серверу
  function GetCopyright:string;                   stdcall;    external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;   stdcall;     external 'core.dll';       // полчуение имени пользователя из его UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // есть ли доступ у пользователя к локальному чату
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00




  // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // пароль
  // --- xml.dll ---
 type
   TXMLSettings = Pointer; // Указатель на класс TXMLSettings
  function CreateXMLSettings(SettingsFileName, GUIDVersion: PChar): TXMLSettings; stdcall; external 'xml.dll';
  function CreateXMLSettingsSingle(SettingsFileName: PChar): TXMLSettings;        stdcall; external 'xml.dll';
  procedure FreeXMLSettings(TXML: TXMLSettings);                                  stdcall; external 'xml.dll';
  procedure UpdateXMLLocalVersion(TXML: TXMLSettings; GUIDVersion: PChar);        stdcall; external 'xml.dll';
  function GetLocalXMLVersion(TXML: TXMLSettings): PChar;                         stdcall; external 'xml.dll';
  procedure UpdateXMLLastOnline(TXML: TXMLSettings);                              stdcall; external 'xml.dll';
  procedure UpdateXMLRemoteVersion(TXML: TXMLSettings; GUIDVersion: PChar);       stdcall; external 'xml.dll';  // для службы обновления (тут не используется)
  function GetRemoteXMLVersion(TXML: TXMLSettings): PChar;                        stdcall; external 'xml.dll';  // для службы обновления (тут не используется)
  function GetXMLLastOnline(TXML: TXMLSettings): TDateTime;                       stdcall; external 'xml.dll';  // для службы обновления (тут не используется)


implementation

initialization  // Инициализация
  SharedActiveSipOperators := TActiveSIP.Create;


finalization
  // Освобождение памяти
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;

end.
