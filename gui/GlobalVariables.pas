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
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB, Data.DB, SysUtils, Windows;

var
  // ������� ������ GUID   ctrl+shift+G (GUID)
  GUID_VESRION    :string = '11FC1DF8';

  // ���� � �����������
  SETTINGS_XML    :string = 'settings.xml';

  // ���
  CHAT_EXE         :string = 'chat.exe';
  CHAT_PARAM       :string = '--USER_ID';

  // ������ � �������� ��������� �����������
  SharedActiveSipOperators: TActiveSIP;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;

  // ������� ����������� ������������ � �������
  SharedCurrentUserLogon: TUser;

  // �������� DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // �������� ����������� � �������
  function GetCopyright:string;                   stdcall;    external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;   stdcall;     external 'core.dll';       // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;   stdcall;     external 'core.dll';       // ���� �� ������ � ������������ � ���������� ����
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00




  // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // ������
  // --- xml.dll ---
 type
   TXMLSettings = Pointer; // ��������� �� ����� TXMLSettings
  function CreateXMLSettings(SettingsFileName, GUIDVersion: PChar): TXMLSettings; stdcall; external 'xml.dll';
  function CreateXMLSettingsSingle(SettingsFileName: PChar): TXMLSettings;        stdcall; external 'xml.dll';
  procedure FreeXMLSettings(TXML: TXMLSettings);                                  stdcall; external 'xml.dll';
  procedure UpdateXMLLocalVersion(TXML: TXMLSettings; GUIDVersion: PChar);        stdcall; external 'xml.dll';
  function GetLocalXMLVersion(TXML: TXMLSettings): PChar;                         stdcall; external 'xml.dll';
  procedure UpdateXMLLastOnline(TXML: TXMLSettings);                              stdcall; external 'xml.dll';
  procedure UpdateXMLRemoteVersion(TXML: TXMLSettings; GUIDVersion: PChar);       stdcall; external 'xml.dll';  // ��� ������ ���������� (��� �� ������������)
  function GetRemoteXMLVersion(TXML: TXMLSettings): PChar;                        stdcall; external 'xml.dll';  // ��� ������ ���������� (��� �� ������������)
  function GetXMLLastOnline(TXML: TXMLSettings): TDateTime;                       stdcall; external 'xml.dll';  // ��� ������ ���������� (��� �� ������������)


implementation

initialization  // �������������
  SharedActiveSipOperators := TActiveSIP.Create;


finalization
  // ������������ ������
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;

end.
