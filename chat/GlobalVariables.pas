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
  SysUtils, Windows, TOnlineUsersUint;

var
  // Залогиненый польщователь который открыл чат
  USER_STARTED_CHAT_ID    :Integer;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean =  False;

  // сообщение об ошибке при отправке сообщения
  SENDING_MESSAGE_ERROR :string;

  // глобальная папка с чатами
  CHAT_FOLDER             :string = 'chat_history';

  // текущие онлайн пользователи
  SharedOnlineUsers:  TOnlineUsers;




  // загрузка DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection;     stdcall;    external 'core.dll';     // Создание подключения к серверу
  function GetCopyright:string;                       stdcall;    external 'core.dll';     // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;    stdcall;    external 'core.dll'; // полчуение имени пользователя из его UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // есть ли доступ у пользователя к локальному чату
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // текущее начала дня с минутами 00:00:00



implementation




initialization  // Инициализация
 SharedOnlineUsers:=TOnlineUsers.Create;

finalization
 SharedOnlineUsers.Free;

end.
