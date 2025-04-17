unit GlobalVariables;

interface


const
 SERVICE_NAME               :string = 'update_dashboard';
 SERVICE_DESCRIPTION        :string = '������ ���������� ������� ����������';

 // exe ��������
 DASHBOARD_EXE    :string = 'dashboard.exe';
 CHAT_EXE         :string = 'chat.exe';
 REPORT_EXE       :string = 'report.exe';
 SMS_EXE          :string = 'sms.exe';
 UPDATE_EXE       :string = 'update.exe';
 INSTALL_EXE      :string = 'install.exe';

 UPDATE_BAT       :string = 'update.bat';

 // ���� � �����������
 SETTINGS_XML     :string = 'settings.xml';

 //  mysql connector
 CONNECTOR_INSTALL_X32    :string ='mysql-connector-odbc-5.3.2-win32.msi';
 CONNECTOR_INSTALL_X64    :string ='mysql-connector-odbc-5.3.2-win64.msi';

 // ����� ��� ����������
 FOLDER_INSTALL   :string = 'install';

 // ����� ���������
 INSTALL_DASHBOARD :string = 'C:\Program Files\dashboard';

 // �������� ��� ���� ��� ���� ������
 IS_ERROR:Boolean = True;

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
  function GetUpdateNameFolder:PChar; stdcall; external 'core.dll';       // // ����� � update (������������)
  function GetRemoteVersionDashboard(var _errorDescriptions:string):PChar; stdcall;external 'core.dll';        // ������� ������ �������� (��)
  function KillTask(ExeFileName:string):integer;  stdcall; external 'core.dll';        // ������� ��������� exe
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // �������� �� 2�� ���������� �����
  function GetTask(ExeFileName:string):Boolean;  stdcall; external 'core.dll';         // �������� ������� �� �������

   // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // ������
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // ����� ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // �����
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // ������

implementation

uses
  SysUtils;

initialization  // �������������
  FOLDERPATH:=ExtractFilePath(ParamStr(0));




finalization
  // ������������ ������


end.
