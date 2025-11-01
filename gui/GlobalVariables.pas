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
  Forms,
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB, Data.DB, SysUtils, Windows, TLogFileUnit,
  TIVRUnit, TCustomTypeUnit, TFontSizeUnit, TQueueStatisticsUnit, TStatusUnit,
  TDebugCountResponseUnit, GlobalVariablesLinkDLL, TCheckBoxUIUnit;

 type // ���������� �������� ���� �������������������� ����������
  TGlobalExeption = class
  public
    procedure HandleGlobalException(Sender: TObject; E: Exception);
    procedure Setup;
  end;


var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  // ������� ���������� ������ ��������� *.exe
  FOLDERPATH        :string;

  // ����� � �����������
  FOLDERUPDATE      :string;

  // ������� ������ GUID   ctrl+shift+G (GUID)
  GUID_VERSION      :string = 'A427F0B5';

  // exe ��������
  DASHBOARD_EXE     :string = 'dashboard.exe';

  // ���� � �����������
  SETTINGS_XML      :string = 'settings.xml';

  ///////////////////// MODULE /////////////////////
  CHAT_EXE          :string = 'chat.exe';         // ���
  REPORT_EXE        :string = 'report.exe';       // ������
  SMS_EXE           :string = 'sms.exe';          // sms
  SERVICE_EXE       :string = 'service.exe';      // �������� �����
  OUTGOING_EXE      :string = 'outgoing.exe';     // ��������
  REG_PHONE_EXE     :string = 'reg_phone.exe';    // ����������� ��������
  ///////////////////// MODULE /////////////////////

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
  SharedMainLog             :TLoggingFile;         // ��� ������� �����
  SharedCurrentUserLogon    :TUser;                // ������� ����������� ������������ � �������
  SharedActiveSipOperators  :TActiveSIP;           // ������ � �������� ��������� �����������
  SharedIVR                 :TIVR;                 // ������ � ������� IVR ��� ������ �� �����
  SharedQueueStatistics     :TQueueStatistics;     // ������ � ������� ����������� ������� �� ����
  SharedFontSize            :TFontSize;            // ������� ������� �� ��������
  SharedCountResponseThread :TDebugCountResponse;  // ������ ��� ������������ ������� ������ � �������
  SharedStatus              :TStatus;              // ����� �������� ������� ���������
  SharedCheckBoxUI          :TCheckBoxUI;          // ������ � ��������� ����������
 ///////////////////// CLASSES /////////////////////


  // �������� ��� ���� ��� ���� ������
  IS_ERROR:Boolean = True;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  GlobalExceptions        :TGlobalExeption;


implementation



procedure TGlobalExeption.HandleGlobalException(Sender: TObject; E: Exception);
begin
   SharedMainLog.Save('Global Exception: ' + E.ClassName + ': ' + E.Message, IS_ERROR);
end;

procedure TGlobalExeption.Setup;
begin
  Application.OnException:=HandleGlobalException;
end;

initialization  // �������������

  FOLDERPATH      :=ExtractFilePath(ParamStr(0));
  FOLDERUPDATE    :=FOLDERPATH+GetUpdateNameFolder;

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedQueueStatistics     := TQueueStatistics.Create(True);
  SharedMainLog             := TLoggingFile.Create('main');   // ��� ������ main �����
  SharedFontSize            := TFontSize.Create;
  SharedCountResponseThread := TDebugCountResponse.Create(SharedMainLog);
  SharedStatus              := TStatus.Create(True);
  SharedCheckBoxUI          := TCheckBoxUI.Create;

  begin
    GlobalExceptions        := TGlobalExeption.Create;
    GlobalExceptions.Setup;
  end;


finalization

  // ������������ ������
  GlobalExceptions.Free;
  SharedIVR.Free;
  SharedQueueStatistics.Free;
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  SharedCountResponseThread.Free;
  SharedStatus.Free;
  SharedCheckBoxUI.Free;

end.
