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
  SysUtils, Windows, TOnlineUsersUint;

var
  // ����������� ������������ ������� ������ ���
  USER_STARTED_CHAT_ID    :Integer;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;

  // ��������� �� ������ ��� �������� ���������
  SENDING_MESSAGE_ERROR :string;

  // ���������� ����� � ������
  CHAT_FOLDER             :string = 'chat_history';

  // ������� ������ ������������
  SharedOnlineUsers:  TOnlineUsers;




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



implementation




initialization  // �������������
 SharedOnlineUsers:=TOnlineUsers.Create;

finalization
 SharedOnlineUsers.Free;

end.
