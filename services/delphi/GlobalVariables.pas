unit GlobalVariables;

interface


const
 SERVICE_NAME               :string = 'update_dashboard';
 SERVICE_DESCRIPTION        :string = '������ ���������� ������� ����������';

 // ���� � �����������
 SETTINGS_XML    :string = 'settings.xml';

var
  FOLDERPATH:string;

   // �������� DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection; stdcall;    external 'core.dll';       // �������� ����������� � �������

  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar; overload;  stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar; stdcall; external 'core.dll';       // ������� �����
  function GetExtensionLog:PChar; stdcall; external 'core.dll';       // // ��� ����
  function GetLogNameFolder:PChar; stdcall; external 'core.dll';       // // ����� � �����
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // ������� ��������� exe
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // �������� ������� �� �������

   // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // ������


implementation

uses
  SysUtils;

initialization  // �������������
  FOLDERPATH:=ExtractFilePath(ParamStr(0));




finalization
  // ������������ ������


end.
