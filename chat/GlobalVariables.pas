/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ���������� ����������                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils, Windows, TOnlineUsersUint,TOnlineChatUnit, CustomTypeUnit;



var
 // ����� ����������
  DEBUG:Boolean = true;


  // ������� ���������� ������ ��������� chat.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ ���
  USER_STARTED_CHAT_ID    :Integer;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;

  // ��������� �� ������ ��� �������� ���������
  SENDING_MESSAGE_ERROR :string;

  // ������������ ���-�� ������ � ���������
  // ����� �������� ������� ��������� ����� ��������� �� ��������� �������
  MAX_LENGHT_LINES_ONE_FILEDS : Word = 100;

  // ��������� url �����
  DEFAULT_URL : string = 'about:blank';

  // ������� ������ ������������
  SharedOnlineUsers:  TOnlineUsers;

  // ������� ����� ���
  SharedLocalMainChat: TOnlineChat;


  // �������� DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection;     stdcall;    external 'core.dll';     // �������� ����������� � �������
  function GetCopyright:string;                       stdcall;    external 'core.dll';     // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;    stdcall;    external 'core.dll'; // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // ���� �� ������ � ������������ � ���������� ����
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar; stdcall; external 'core.dll';       // ������� �����  yyyymmdd
  function GetLocalChatNameFolder:PChar; stdcall; external 'core.dll';       // // ����� � ��������� �����
  function GetExtensionLog:PChar; stdcall; external 'core.dll';       // // ����� � ��������� �����

implementation


uses
  HomeForm, Functions;




initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 // ��� � ������
 SharedOnlineUsers:=TOnlineUsers.Create;

 // ��������� ����� ���
 SharedLocalMainChat:=TOnlineChat.Create(eChatMain,ePublic);



 finalization
 SharedOnlineUsers.Free;

end.
