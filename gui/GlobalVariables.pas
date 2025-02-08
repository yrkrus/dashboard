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
  TIVRUnit, TCustomTypeUnit;

var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  // ������� ���������� ������ ��������� *.exe
  FOLDERPATH        :string;

  // ������� ������ GUID   ctrl+shift+G (GUID)
  GUID_VESRION      :string = 'EB11A1B9';

  // exe ��������
  DASHBOARD_EXE     :string = 'dashboard.exe';

  // ���� � �����������
  SETTINGS_XML      :string = 'settings.xml';

  // ���
  CHAT_EXE          :string = 'chat.exe';
  // ������
  REPORT_EXE        :string = 'report.exe';
  // sms ��������
  SMS_EXE           :string = 'sms.exe';

  USER_ID_PARAM     :string = '--USER_ID';


  // ������ ����������
  UPDATE_EXE        : string = 'update.exe';
  UPDATE_SERVICES   : string = 'update_dashboard';
  UPDATE_BAT        : string = 'update.bat'; // ����������

  // ������ �����������
  ICON_AUTH_USER          : string = 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    : string = 'user_icon_auth_admin.png';

  ///////////////////// CLASSES /////////////////////

  // ��� ������� �����
  SharedMainLog:TLoggingFile;

  // ������� ����������� ������������ � �������
  SharedCurrentUserLogon: TUser;

  // ������ � �������� ��������� �����������
  SharedActiveSipOperators: TActiveSIP;

  // ������ � ������� IVR ��� ������ �� �����
  SharedIVR: TIVR;

  // ���������� �������� ��������
 // SharedInternalProcess:TInternalProcess;

 ///////////////////// CLASSES /////////////////////


  // �������� ��� ���� ��� ���� ������
  IS_ERROR:Boolean = True;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;



  // �������� DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection; overload;             stdcall;  external 'core.dll';       // �������� ����������� � �������
  function createServerConnectWithError(var _errorDescriptions: string): p_TADOConnection; overload;             stdcall;  external 'core.dll';       // �������� ����������� � �������
  function GetCopyright:Pchar;                                stdcall;  external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;  external 'core.dll';       // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;  stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � ���������� ����
  function GetUserAccessReports(InUserID:Integer):Boolean;    stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � �������
  function GetUserAccessSMS(InUserID:Integer):Boolean;        stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � SMS ��������
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload; stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload; stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar;                              stdcall;  external 'core.dll';       // ������� �����
  function GetLocalChatNameFolder:PChar;                      stdcall;  external 'core.dll';       // ����� � ��������� �����
  function GetExtensionLog:PChar;                             stdcall;  external 'core.dll';       // ����� � ��������� �����
  function GetLogNameFolder:PChar;                            stdcall;  external 'core.dll';       // ����� � �����
  function GetUpdateNameFolder:PChar;                         stdcall;  external 'core.dll';       // ����� � update (������������)
  function GetRemoteVersionDashboard:PChar;                   stdcall;  external 'core.dll';       // ������� ������ �������� (��)
  function KillTask(ExeFileName:string):integer;              stdcall;  external 'core.dll';       // ������� ��������� exe
  procedure KillProcessNow;                                   stdcall;  external 'core.dll';       // ����������� ��������� ������
  function GetTask(ExeFileName:string):Boolean;               stdcall;  external 'core.dll';       // �������� ������� �� �������
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;  external 'core.dll';       // �������� �� 2�� ���������� �����
  function GetDateTimeToDateBD(InDateTime:string):PChar;      stdcall;  external 'core.dll';       // ������� ���� � ������� � ������������ ��� ��� BD
  function GetDateToDateBD(InDateTime:string):PChar;          stdcall;  external 'core.dll';       // ������� ���� � ������������ ��� ��� BD
  function GetTimeAnsweredToSeconds(InTimeAnswered:string):Integer; stdcall;  external 'core.dll'; // ������� ������� ��������� ��������� ���� 00:00:00 � �������
  function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;  external 'core.dll'; // ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
  function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;  stdcall;  external 'core.dll';      // ����� ������� ���������� �������� �� �������� ������ � �������
  function StringToTQueue(InQueueSTR:string):enumQueueCurrent; stdcall;  external 'core.dll';      // ��������� �� string � TQueue
  function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;  stdcall;  external 'core.dll';      // ��������� �� TQueue � string
  function GetUserNameOperators(InSip:string):PChar;           stdcall;  external 'core.dll';      // ��������� ����� ������������ �� ��� SIP ������



  // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // ������
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // ����� ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // �����
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // ������


implementation


initialization  // �������������
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedMainLog             := TLoggingFile.Create('main');   // ��� ������ main �����

finalization
  // ������������ ������
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
