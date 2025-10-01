unit GlobalVariablesLinkDLL;

interface

uses
  TCustomTypeUnit;

 // �������� DLL
  // --- core.dll ---
 type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection; overload;             stdcall;  external 'core.dll';       // �������� ����������� � �������
  function createServerConnectWithError(var _errorDescriptions: string): p_TADOConnection; overload;             stdcall;  external 'core.dll';       // �������� ����������� � �������
  function GetDefaultDataBase:PChar;                                    stdcall;  external 'core.dll';       // ������� ����� ���� ������ � �������� ���� �����������
  function GetCopyright:Pchar;                                          stdcall;  external 'core.dll';       // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;                      stdcall;  external 'core.dll';       // ��������� ����� ������������ �� ��� UserID
  function GetRoleID(InRole:string):Integer;                            stdcall;  external 'core.dll';       // ��������� ID TRole
  function GetUserAccessLocalChat(InUserID:Integer):Boolean;            stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � ���������� ����
  function GetUserAccessReports(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � �������
  function GetUserAccessSMS(InUserID:Integer):Boolean;                  stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � SMS ��������
  function GetUserAccessService(InUserID:Integer):Boolean;              stdcall;  external 'core.dll';       // ���� �� ������ � ������������ � �������
   //function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload; stdcall; external 'core.dll';       // ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload; stdcall; external 'core.dll';       // ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar;                                        stdcall;  external 'core.dll';       // ������� �����
  function GetLocalChatNameFolder:PChar;                                stdcall;  external 'core.dll';       // ����� � ��������� �����
  function GetExtensionLog:PChar;                                       stdcall;  external 'core.dll';       // ����� � ��������� �����
  function GetLogNameFolder:PChar;                                      stdcall;  external 'core.dll';       // ����� � �����
  function GetUpdateNameFolder:PChar;                                   stdcall;  external 'core.dll';       // ����� � update (������������)
  function GetRemoteVersionDashboard(var _errorDescriptions:string):PChar;    stdcall;  external 'core.dll';       // ������� ������ �������� (��)
  function KillTask(ExeFileName:string):integer;                        stdcall;  external 'core.dll';       // ������� ��������� exe
  procedure KillProcessNow;                                             stdcall;  external 'core.dll';       // ����������� ��������� ������
  function GetTask(ExeFileName:string):Boolean;                         stdcall;  external 'core.dll';       // �������� ������� �� �������
  function GetCloneRun(InExeName:Pchar):Boolean;                        stdcall;  external 'core.dll';       // �������� �� 2�� ���������� �����
  function GetDateTimeToDateBD(InDateTime:string):PChar;                stdcall;  external 'core.dll';       // ������� ���� � ������� � ������������ ��� ��� BD
  function GetDateToDateBD(InDateTime:string):PChar;                    stdcall;  external 'core.dll';       // ������� ���� � ������������ ��� ��� BD
  function GetTimeAnsweredToSeconds(InTimeAnswered:string; isReducedTime:Boolean = False):Integer; stdcall;  external 'core.dll'; // ������� ������� ��������� ��������� ���� 00:00:00 � �������
  function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar;                  stdcall;  external 'core.dll'; // ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
  function GetIVRTimeQueue(InQueue:enumQueue):Integer;           stdcall;  external 'core.dll';      // ����� ������� ���������� �������� �� �������� ������ � �������
  function StringToTQueue(InQueueSTR:string):enumQueue;          stdcall;  external 'core.dll';      // ��������� �� string � TQueue
  function TQueueToString(InQueueSTR:enumQueue):PChar;           stdcall;  external 'core.dll';      // ��������� �� TQueue � string
  function GetUserNameOperators(InSip:string):PChar;                    stdcall;  external 'core.dll';      // ��������� ����� ������������ �� ��� SIP ������
  function GetCurrentUserNamePC:PChar;                                  stdcall;  external 'core.dll';      // ��������� ����� ������������ ������������ (�� �������)
  function GetCountSendingSMSToday:Integer;                             stdcall;  external 'core.dll';      // ���-�� ������������ �� ������� ���
  function Ping(InIp:string):Boolean;                                   stdcall;  external 'core.dll';      // �������� ping
  function IsServerIkExistWorkingTime(_id:Integer):Boolean;             stdcall;  external 'core.dll';      // �������� �� ����� ������ � ������� ��
  function GetClinicId(_nameClinic:string):Integer;                     stdcall;  external 'core.dll';      // id �������
  function GetAliveCoreDashboard:Boolean;                               stdcall;  external 'core.dll';      // ���� �� ����������� � ���� �������� �� tcp:12345 �����
  function GetPhoneTrunkQueue(_table:enumReportTableIVR; _phone:string;_call_id:string):PChar; stdcall;  external 'core.dll';   // ���������� �� ����� ����� ������ ����� ������� ���� � �������
  function GetPhoneOperatorQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):PChar; stdcall;  external 'core.dll'; // ���������� � ������ ��������� ��������������� �������
  function GetPhoneRegionQueue(_table:enumReportTableIVR; _phone:string;_timecall:string):PChar; stdcall;  external 'core.dll'; // ���������� � � ����� ������� ��������������� �������
  function GetCodeStatusSms(_idSMS:Integer; _table:enumReportTableSMSStatus):enumStatusCodeSms; stdcall;  external 'core.dll';      // ���������� ������� SMS ���������
  function GetStatusSms(_code:enumStatusCodeSms):Pchar;                 stdcall;  external 'core.dll';      // ���������� ������� ���������
  function GetCountSmsSendingMessageInPhone(_phone:string):Integer;     stdcall;  external 'core.dll';      // ���-�� ������������ SMS ��������� �� ������

  // --- connect_to_server.dll ---  (�� ���� ���� ��� �� �����, �� ����� �����)
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerNameTest:string;     stdcall;   external 'connect_to_server.dll'; // ����� ����(��������)
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // ������
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // ����� ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // �����
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // ������
 function GetTCPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // ����� tcp server core_dashboard
 function GetTCPServerPort:Word;        stdcall;   external 'connect_to_server.dll'; // port tcp server core_dashboard

 // --- ldap.dll ---
 function LdapAuth(_user,_pwd:string):Boolean;      stdcall;   external 'ldap.dll';  // �������� ����������� �� ldap

implementation

end.
