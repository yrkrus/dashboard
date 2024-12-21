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
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB,
  Data.DB, SysUtils, Windows, TLogFileUnit,
  TIVRUnit;

var
  // ������� ���������� ������ ��������� chat.exe
  FOLDERPATH:string;

  // ������� ������ GUID   ctrl+shift+G (GUID)
  GUID_VESRION    :string = '11FC1DF8';

  // ���� � �����������
  SETTINGS_XML    :string = 'settings.xml';

  // ���
  CHAT_EXE         :string = 'chat.exe';
  CHAT_PARAM       :string = '--USER_ID';

  // ������ ����������
  UPDATE_EXE        : string = 'update_dashboard.exe';

  // ������ � �������� ��������� �����������
  SharedActiveSipOperators: TActiveSIP;

  // ������ � ������� IVR ��� ������ �� �����
  SharedIVR: TIVR;

  // �������� ��� ���� ��� ���� ������
  IS_ERROR:Boolean = True;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;

  // ������� ����������� ������������ � �������
  SharedCurrentUserLogon: TUser;

  // �������� DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // �������� ����������� � �������
  function GetCopyright:Pchar;                   stdcall;    external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;   stdcall;     external 'core.dll';       // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // ���� �� ������ � ������������ � ���������� ����
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar; stdcall; external 'core.dll';       // ������� �����
  function GetLocalChatNameFolder:PChar; stdcall; external 'core.dll';       // // ����� � ��������� �����
  function GetExtensionLog:PChar; stdcall; external 'core.dll';       // // ����� � ��������� �����
  function GetLogNameFolder:PChar; stdcall; external 'core.dll';       // // ����� � �����
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // ������� ��������� exe
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // �������� ������� �� �������


  // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // ������


implementation



initialization  // �������������
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedActiveSipOperators := TActiveSIP.Create;
  SharedIVR := TIVR.Create;

  //SharedLoggingFile := TLoggingFile.Create;

finalization
  // ������������ ������
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
