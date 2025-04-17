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
  TIVRUnit, TCustomTypeUnit, TFontSizeUnit,
  TDebugCountResponseUnit, GlobalVariablesLinkDLL;


var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  // ������� ���������� ������ ��������� *.exe
  FOLDERPATH        :string;

  // ����� � �����������
  FOLDERUPDATE      :string;

  // ������� ������ GUID   ctrl+shift+G (GUID)
  GUID_VERSION      :string = '425D7DB4';

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
  // �������� �����
  SERVICE_EXE       :string = 'service.exe';


  USER_ID_PARAM     :string = '--USER_ID';
  USER_ACCESS_PARAM :string = '--ACCESS';

  // �� ��������� nullptr ����� ��������
  USER_STARTED_SMS_ID :Integer;

  // ������ ����������
  UPDATE_EXE        : string = 'update.exe';
  UPDATE_SERVICES   : string = 'update_dashboard';
  UPDATE_BAT        : string = 'update.bat'; // ����������

  // ������ ������� ���������� ����� ��� ������� ������� �� �����������
  FREE_SPACE_COUNT        :Integer = 100;

  // ������� ����� ����������� �������� ���� 1470 - 1094(����� �� ��������� ����)
  DEFAULT_SIZE_PANEL_ACTIVESIP :Word = 383;

  // uptime
  PROGRAMM_UPTIME:Int64 = 0;
  PROGRAM_STARTED:TDateTime;

  ///////////////////// CLASSES /////////////////////

  // ��� ������� �����
  SharedMainLog:TLoggingFile;

  // ������� ����������� ������������ � �������
  SharedCurrentUserLogon: TUser;

  // ������ � �������� ��������� �����������
  SharedActiveSipOperators: TActiveSIP;

  // ������ � ������� IVR ��� ������ �� �����
  SharedIVR: TIVR;

  // ������� ������� �� ��������
  SharedFontSize: TFontSize;

  // ������ ��� ������������ ������� ������ � �������
  SharedCountResponseThread:TDebugCountResponse;


 ///////////////////// CLASSES /////////////////////


  // �������� ��� ���� ��� ���� ������
  IS_ERROR:Boolean = True;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;



implementation



initialization  // �������������
  FOLDERPATH      :=ExtractFilePath(ParamStr(0));
  FOLDERUPDATE    :=FOLDERPATH+GetUpdateNameFolder;

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedMainLog             := TLoggingFile.Create('main');   // ��� ������ main �����
  SharedFontSize            := TFontSize.Create;
  SharedCountResponseThread := TDebugCountResponse.Create(SharedMainLog);

finalization
  // ������������ ������
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
