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
  Classes,
  TCustomTypeUnit,
  TLogFileUnit,
  TPacientsListUnit;


  type   // ��� ��������
   enumSendingOptions = (options_Manual,  // ������ ��������
                         options_Sending); // ��������

  type  // ��� ����������\�������� ���
  enumFormShowingLog = (log_show,     // ��� ����������
                        log_hide);    // ��� ��������


  type  // ��� ��������� �������� ���������
  enumTemplateMessage = (template_my,       // ��� �������
                         template_global);  // ���������� �������                  

var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  SMS_EXE :string = 'sms.exe';

  // ��� ������� �����
  SharedMainLog:TLoggingFile;

  // ������� ���������� ������ ��������� sms.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ sms
  USER_STARTED_SMS_ID    :Integer;

  // ���� �� ������ � �������� �������� ����������� � ������
  USER_ACCESS_SENDING_LIST  :Boolean;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean = False;

  // ���-�� ������������� ������� ��� �������� �������� SMS
  MAX_COUNT_THREAD_SENDIND :Word = 10;

  // ������ ��� ��� ��������
  SharedPacientsList            : TPacients;
  SharedPacientsListNotSending  : TPacients;

  // ������ � �������� ��� ��� ������ ��������� ��������
  SharedSendindPhoneManualSMS   : TStringList;

  // ���������� � ���������� ������
  ISGLOBAL_MESSAGE:Boolean = True;

  // ��������� SMS ���������, ����������� � ������   // TODO %�_�������  ������� ����� �������� �� ��� � �������!
  REMEMBER_MESSAGE        :string='%FIO_Pacienta %�������(�) %�_������� %FIO_Doctora � %Time %Data � ������� �� ������ %Address.'+
                                  ' ���� � ��� ���� �������, ������ �� ��� ��������, ����� ���. ��� ����� (8442)220-220 ��� (8443)450-450';

   // ��������� ����� �� ��������� excel ����
   EXCEL_FILE_NOT_LOADED:string ='�� ��������';

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
  function GetExtensionLog:PChar;                             stdcall;    external 'core.dll';       // ����� � ��������� �����
  function GetLogNameFolder:PChar;                            stdcall;    external 'core.dll';       // ����� � �����

  // --- connect_to_server.dll ---
  // �� ������������!


implementation




initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedPacientsList           :=TPacients.Create;
 SharedPacientsListNotSending :=TPacients.Create;

 SharedMainLog                :=TLoggingFile.Create('sms');   // ��� ������ �����
 SharedSendindPhoneManualSMS  :=TStringList.Create;


 finalization

end.
