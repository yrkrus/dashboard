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
  SysUtils, Windows, TOnlineUsersUint,TOnlineChatUnit, CustomTypeUnit;



var
 // режим разработки
  DEBUG:Boolean = true;

  CHAT_EXE         :string = 'chat.exe';

  // текущая директория откуда запускаем chat.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл чат
  USER_STARTED_CHAT_ID    :Integer;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean =  False;

  // сообщение об ошибке при отправке сообщения
  SENDING_MESSAGE_ERROR :string;

  // максимальное кол-во знаков в сообщений
  // после которого остаток сообщения будет перекинут на следующую строчкц
  MAX_LENGHT_LINES_ONE_FILEDS : Word = 100;

  // дефолтный url адрес
  DEFAULT_URL : string = 'about:blank';

  // текущие онлайн пользователи
  SharedOnlineUsers:  TOnlineUsers;

  // текущий общий чат
  SharedLocalMainChat: TOnlineChat;


  // загрузка DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection;             stdcall;    external 'core.dll';          // Создание подключения к серверу
  function GetCopyright:Pchar;                                stdcall;    external 'core.dll';          // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;    external 'core.dll';          // полчуение имени пользователя из его UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;  stdcall;    external 'core.dll';          // есть ли доступ у пользователя к локальному чату
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;   stdcall; external 'core.dll'; // текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;   stdcall; external 'core.dll'; // текущее начала дня с минутами 00:00:00
  function GetCurrentTime:PChar;                              stdcall;    external 'core.dll';          // текущее время  yyyymmdd
  function GetLocalChatNameFolder:PChar;                      stdcall;    external 'core.dll';          // папка с локальным чатом
  function GetExtensionLog:PChar;                             stdcall;    external 'core.dll';          // расширение чата
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // проверка на 2ую запущенную копию
  procedure KillProcessNow;                                   stdcall;    external 'core.dll';          // немедленное звершение работы

  // --- connect_to_server.dll ---
  function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // адрес ftp
  function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // логин
  function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // пароль


implementation


uses
  HomeForm, Functions;




initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 // кто в онлайн
 SharedOnlineUsers:=TOnlineUsers.Create;

 // локальный общий чат
 SharedLocalMainChat:=TOnlineChat.Create(eChatMain,ePublic);



 finalization
 SharedOnlineUsers.Free;

end.
