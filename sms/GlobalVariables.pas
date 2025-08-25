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
  TMessageGeneratorSMSUnit,
  TPacientsListUnit;


  type   // ��� ��������
   enumSendingOptions = (options_Manual,    // ������ ��������
                         options_Sending,   // ��������
                         options_Find);     // ����� �������

  type  // ��� ����������\�������� ���
  enumFormShowingLog = (log_show,           // ��� ����������
                        log_hide);          // ��� ��������


  type  // ��� ��������� �������� ���������
  enumTemplateMessage = (template_my,       // ��� �������
                         template_global);  // ���������� �������                  

var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  SMS_EXE           :string = 'sms.exe';

  // ���� � �����������
  SETTINGS_XML      :string = 'settings.xml';

  // ��� ������� �����
  SharedMainLog     :TLoggingFile;

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
  MAX_COUNT_THREAD_SENDIND :Word = 20;

  // ������ ��� ��� ��������
  SharedPacientsList            : TPacients;
  SharedPacientsListNotSending  : TPacients;

  // ���-�� ������� �� �������� ������� ��������� ��������������
  MAX_COUNT_PHONE_SENDING_WARNING :Word = 1000;

  // ��������������� ��������� �� �������� ����������
  SharedGenerateMessage         : TMessageGeneratorSMS;

  // ������ � �������� ��� ��� ������ ��������� ��������
  SharedSendindPhoneManualSMS   : TStringList;

  // ���������� � ���������� ������
  ISGLOBAL_MESSAGE:Boolean = True;

  // ��������� SMS ���������, ����������� � ������   // TODO %�_�������  ������� ����� �������� �� ��� � �������!
  REMEMBER_MESSAGE        :string='%FIO_Pacienta %�������(�) %�_������� %FIO_Doctora � %Time %Data � ������� �� ������ %Address.'+
                                  ' ���� � ��� ���� �������, ������ �� ��� ��������, ����� ���. ��� ����� (8442)220-220 ��� (8443)450-450';

  // ��������� ����� �� ��������� excel ����
  EXCEL_FILE_NOT_LOADED:string ='�� ��������';

implementation




initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedPacientsList           :=TPacients.Create;
 SharedPacientsListNotSending :=TPacients.Create;

 SharedMainLog                :=TLoggingFile.Create('sms');   // ��� ������ �����
 SharedSendindPhoneManualSMS  :=TStringList.Create;

 finalization

end.
