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
  function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;           stdcall;  external 'core.dll';      // ����� ������� ���������� �������� �� �������� ������ � �������
  function StringToTQueue(InQueueSTR:string):enumQueueCurrent;          stdcall;  external 'core.dll';      // ��������� �� string � TQueue
  function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;           stdcall;  external 'core.dll';      // ��������� �� TQueue � string
  function GetUserNameOperators(InSip:string):PChar;                    stdcall;  external 'core.dll';      // ��������� ����� ������������ �� ��� SIP ������
  function GetCurrentUserNamePC:PChar;                                  stdcall;  external 'core.dll';      // ��������� ����� ������������ ������������ (�� �������)
  function GetCountSendingSMSToday:Integer;                             stdcall;  external 'core.dll';      // ���-�� ������������ �� ������� ���
  function Ping(InIp:string):Boolean;                                   stdcall;  external 'core.dll';      // �������� ping
  function IsServerIkExistWorkingTime(_id:Integer):Boolean;             stdcall;  external 'core.dll';      // �������� �� ����� ������ � ������� ��
  function GetClinicId(_nameClinic:string):Integer;                     stdcall;  external 'core.dll';      // id �������


  // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // ������
 function GetFTPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // ����� ftp
 function GetFTPServerUser:string;      stdcall;   external 'connect_to_server.dll'; // �����
 function GetFTPServerPassword:string;  stdcall;   external 'connect_to_server.dll'; // ������

implementation

end.
