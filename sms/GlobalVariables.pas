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
  SysUtils,
  Windows,
  TCustomTypeUnit;


  type   // ��� ��������
   enumSendingOptions = (options_Manual,  // ������ ��������
                         options_Sending); // ��������

  type  // ��� ����������\�������� ���
  enumFormShowingLog = (log_show,     // ��� ����������
                        log_hide);    // ��� ��������


var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  SMS_EXE :string = 'sms.exe';

  // ������� ���������� ������ ��������� sms.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ sms
  USER_STARTED_SMS_ID    :Integer;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;



  // �������� DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection;             stdcall;    external 'core.dll';        // �������� ����������� � �������
  function GetCopyright:Pchar;                                stdcall;    external 'core.dll';        // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;    external 'core.dll';        // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessSMS(InUserID:Integer):Boolean;        stdcall;    external 'core.dll';         // ���� �� ������ � ������������ � SMS �������
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;   stdcall; external 'core.dll';// ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;   stdcall; external 'core.dll';// ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar;                              stdcall;    external 'core.dll';           // ������� �����  yyyymmdd
  procedure KillProcessNow;                                   stdcall;    external 'core.dll';          // ����������� ��������� ������
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // �������� �� 2�� ���������� �����
  function KillTask(ExeFileName:string):integer;              stdcall;    external 'core.dll';          // ������� ��������� exe
  function GetTask(ExeFileName:string):Boolean;               stdcall;    external 'core.dll';          // �������� ������� �� �������
  function GetDateToDateBD(InDateTime:string):PChar;          stdcall;    external 'core.dll';          // ������� ���� � ������� � ������������ ��� ��� BD
  //function GetTimeAnsweredToSeconds(InTimeAnswered:string):Integer; stdcall;  external 'core.dll';    // ������� ������� ��������� ��������� ���� 00:00:00 � �������
  //function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;  external 'core.dll'; // ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
 // function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;  stdcall;  external 'core.dll';    // ����� ������� ���������� �������� �� �������� ������ � �������
  //function StringToTQueue(InQueueSTR:string):enumQueueCurrent; stdcall;  external 'core.dll';      // ��������� �� string � TQueue
 // function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;  stdcall;  external 'core.dll';      // ��������� �� TQueue � string
 // function GetUserNameOperators(InSip:string):PChar;           stdcall;  external 'core.dll';      // ��������� ����� ������������ �� ��� SIP ������


  // --- connect_to_server.dll ---
  // �� ������������!


implementation



initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
