unit FormHome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus,Data.Win.ADODB, Data.DB, Vcl.Imaging.jpeg,System.SyncObjs,
  TActiveSIPUnit,TUserUnit, Vcl.Imaging.pngimage, ShellAPI, TLogFileUnit,
  System.Zip, Vcl.WinXCtrls, Vcl.Samples.Gauges;


type
  THomeForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    lblStstatisc_Queue5000_Answered: TLabel;
    lblStstatisc_Queue5000_No_Answered: TLabel;
    Label13: TLabel;
    lblStstatisc_Queue5050_Answered: TLabel;
    lblStstatisc_Queue5050_No_Answered: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    lblCount_QUEUE: TLabel;
    START_THREAD_ALLl: TButton;
    Label20: TLabel;
    lblStstistisc_Day_Answered: TLabel;
    lblStstistisc_Day_No_Answered: TLabel;
    lblStstistisc_Day_Procent: TLabel;
    lblCount_IVR: TLabel;
    panel_IVR: TPanel;
    STlist_IVR_NO_Rings: TStaticText;
    Timer_Thread_Start: TTimer;
    Panel_Queue: TPanel;
    STlist_QUEUE_NO_Rings: TStaticText;
    StatusBar: TStatusBar;
    FooterMenu: TMainMenu;
    menu: TMenuItem;
    menu_FormPropushennie: TMenuItem;
    menu_About: TMenuItem;
    Label6: TLabel;
    lblStstatisc_Queue5000_Summa: TLabel;
    lblStstatisc_Queue5050_Summa: TLabel;
    Label7: TLabel;
    lblStstistisc_Day_Summa: TLabel;
    Label9: TLabel;
    lblCheckInfocilinikaServerAlive: TLabel;
    N2: TMenuItem;
    menu_activeSession: TMenuItem;
    menu_Reports: TMenuItem;
    ImageLogo: TImage;
    Label11: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    PanelShadowRight: TPanel;
    imgRight: TImage;
    lblShadownRight: TLabel;
    menu_ChangePassword: TMenuItem;
    Label23: TLabel;
    Label24: TLabel;
    menu_About_Version: TMenuItem;
    N1: TMenuItem;
    menu_About_Debug: TMenuItem;
    img_statistics_QUEUE: TImage;
    ListViewIVR: TListView;
    ListViewQueue: TListView;
    Panel_SIP: TPanel;
    ListViewSIP: TListView;
    img_statistics_IVR: TImage;
    lblCount_ACTIVESIP: TLabel;
    ST_SL: TStaticText;
    STlist_ACTIVESIP_NO_Rings: TStaticText;
    popMenu_ActionOperators: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    menu_Users: TMenuItem;
    menu_ServersIK: TMenuItem;
    menu_SIPtrunk: TMenuItem;
    menu_GlobalSettings: TMenuItem;
    N16: TMenuItem;
    PanelStatus: TPanel;
    PanelStatusIN: TPanel;
    Label22: TLabel;
    lblCurrentStatus: TLabel;
    Label10: TLabel;
    btnStatus_available: TButton;
    btnStatus_exodus: TButton;
    btnStatus_break: TButton;
    btnStatus_dinner: TButton;
    btnStatus_postvyzov: TButton;
    btnStatus_studies: TButton;
    btnStatus_IT: TButton;
    btnStatus_transfer: TButton;
    btnStatus_home: TButton;
    btnStatus_add_queue5000: TButton;
    btnStatus_add_queue5050: TButton;
    btnStatus_add_queue5000_5050: TButton;
    btnStatus_del_queue_all: TButton;
    btnStatus_reserve: TButton;
    Button2: TButton;
    ST_StatusPanel: TStaticText;
    img_goHome_YES: TImage;
    img_goHome_NO: TImage;
    chkboxGoHome: TCheckBox;
    ImgNewYear: TImage;
    ST_operatorsHideCount: TStaticText;
    menu_Chat: TMenuItem;
    lblNewMessageLocalChat: TLabel;
    lblNewVersionDashboard: TLabel;
    PanelStatisticsQueue_Numbers: TPanel;
    PanelStatisticsQueue_Graph: TPanel;
    Label12: TLabel;
    lblStatistics_Answered30: TLabel;
    Label14: TLabel;
    lblStatistics_Answered60: TLabel;
    Label15: TLabel;
    lblStatistics_Answered120: TLabel;
    Label16: TLabel;
    lblStatistics_Answered121: TLabel;
    StatisticsQueue_Answered30_Graph: TGauge;
    StatisticsQueue_Answered60_Graph: TGauge;
    StatisticsQueue_Answered120_Graph: TGauge;
    StatisticsQueue_Answered121_Graph: TGauge;
    lblStatistics_Answered30_Graph: TLabel;
    lblStatistics_Answered60_Graph: TLabel;
    lblStatistics_Answered120_Graph: TLabel;
    lblStatistics_Answered121_Graph: TLabel;
    img_StatisticsQueue_Graph: TImage;
    img_StatisticsQueue_Numbers: TImage;
    Label25: TLabel;
    STForecastCount: TStaticText;
    img_SL_History_Graph: TImage;
    menu_SMS: TMenuItem;
    ST_HelpStatusInfo: TStaticText;
    img_ShowOperatorStatus: TImage;
    st_Forecast_Tomorrow: TStaticText;
    st_Forecast_AfterTomorrow: TStaticText;
    Img8Mart: TImage;
    procedure START_THREAD_ALLlClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer_Thread_StartTimer(Sender: TObject);
    procedure menu_FormPropushennieClick(Sender: TObject);
    procedure lblCheckInfocilinikaServerAliveClick(Sender: TObject);
    procedure menu_activeSessionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStatus_availableClick(Sender: TObject);
    procedure btnStatus_add_queue5000Click(Sender: TObject);
    procedure btnStatus_add_queue5050Click(Sender: TObject);
    procedure btnStatus_add_queue5000_5050Click(Sender: TObject);
    procedure btnStatus_del_queue_allClick(Sender: TObject);
    procedure btnStatus_exodusClick(Sender: TObject);
    procedure btnStatus_breakClick(Sender: TObject);
    procedure btnStatus_dinnerClick(Sender: TObject);
    procedure btnStatus_postvyzovClick(Sender: TObject);
    procedure btnStatus_studiesClick(Sender: TObject);
    procedure btnStatus_ITClick(Sender: TObject);
    procedure btnStatus_transferClick(Sender: TObject);
    procedure btnStatus_homeClick(Sender: TObject);
    procedure btnStatus_reserveClick(Sender: TObject);
    procedure menu_ChangePasswordClick(Sender: TObject);
    procedure menu_About_VersionClick(Sender: TObject);
    procedure menu_About_DebugClick(Sender: TObject);
    procedure img_statistics_IVRClick(Sender: TObject);
    procedure img_statistics_list_QUEUEClick(Sender: TObject);
    procedure img_statistics_current_QUEUEClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menu_UsersClick(Sender: TObject);
    procedure menu_ServersIKClick(Sender: TObject);
    procedure menu_GlobalSettingsClick(Sender: TObject);
    procedure menu_SIPtrunkClick(Sender: TObject);
    procedure ST_StatusPanelWindowClick(Sender: TObject);
    procedure img_goHome_YESClick(Sender: TObject);
    procedure img_goHome_NOClick(Sender: TObject);
    procedure menu_ChatClick(Sender: TObject);
    procedure lblNewMessageLocalChatClick(Sender: TObject);
    procedure img_statistics_QUEUEClick(Sender: TObject);
    procedure menu_ReportsClick(Sender: TObject);
    procedure lblNewMessageLocalChatMouseLeave(Sender: TObject);
    procedure lblNewMessageLocalChatMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblCheckInfocilinikaServerAliveMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblCheckInfocilinikaServerAliveMouseLeave(Sender: TObject);
    procedure lblNewVersionDashboardClick(Sender: TObject);
    procedure img_StatisticsQueue_GraphClick(Sender: TObject);
    procedure img_StatisticsQueue_NumbersClick(Sender: TObject);
    procedure img_SL_History_GraphClick(Sender: TObject);
//    procedure ListViewSIPData(Sender: TCustomListView;
//  ItemIndex: Integer; var ItemData: Pointer);
    procedure menu_SMSClick(Sender: TObject);
    procedure ST_HelpStatusInfoMouseLeave(Sender: TObject);
    procedure ST_HelpStatusInfoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ST_HelpStatusInfoClick(Sender: TObject);
    procedure img_ShowOperatorStatusClick(Sender: TObject);
    procedure ListViewSIPCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);

  private
    { Private declarations }



  public
    { Public declarations }

  Log:TLoggingFile;

  ///////// ������ ////////////
  STATISTICS_thread                 :TThread;
  IVR_thread                        :TThread;
  QUEUE_thread                      :TThread;
  ACTIVESIP_thread                  :TThread;
  ACTIVESIP_Queue_thread            :TThread;
  ACTIVESIP_updateTalk_thread       :TThread;
  ACTIVESIP_updateTalkPhone_thread  :TThread;
  ACTIVESIP_countTalk_thread        :TThread;
  CHECKSERVERS_thread               :TThread;
  ANSWEREDQUEUE_thread              :TThread;
  ONLINECHAT_thread                 :TThread;
  FORECAST_thread                   :TThread;
  INTERNALPROCESS_thread            :TThread;
  ///////// ������ ////////////
  ///
  end;

  ///   asterisk -rx "queue add member Local/�����_��������@from-queue/n to �����_������� penalty 0 as �����_��������� state_interface hint:�����_���������@ext-local"
  ///   asterisk -rx "queue remove member Local/�����_��������@from-queue/n from �����_�������"


var
  HomeForm: THomeForm;


  // **************** Thread Update ****************
  UpdateStatistiscSTOP:Boolean;                            // ��������� ���������� ����������
  UpdateIVRSTOP:Boolean;                                   // ��������� ���������� IVR
  UpdateQUEUESTOP:Boolean;                                 // ��������� ���������� QUEUE
  UpdateACTIVESIPSTOP:Boolean;                             // ��������� ���������� ACTIVESIP
  UpdateACTIVESIPQueue:Boolean;                            // ��������� ���������� ACTIVESIP_Queue
  UpdateACTIVESIPtalkTime:Boolean;                         // ��������� ���������� ACTIVESIP_updateTalk
  UpdateACTIVESIPtalkTimePhone:Boolean;                    // ��������� ���������� ACTIVESIP_updateTalkPhone
  UpdateACTIVESIPcountTalk:Boolean;                        // ��������� ���������� ACTIVESIP_countTalk_thread
  UpdateCHECKSERVERSSTOP:Boolean;                          // ��������� ���������� CHECKSERVERSSTOP
  UpdateAnsweredStop:Boolean;                              // ��������� ���������� AnsweredQueue
  UpdateOnlineChatStop:Boolean;                            // ��������� ���������� OnlineChat
  UpdateForecast:Boolean;                                  // ��������� ���������� Forecast
  UpdateInternalProcess:Boolean;                           // ��������� ���������� InternalProcess
  // **************** Thread Update ****************



  LastKernelTime: Int64 = 0;
  LastUserTime: Int64 = 0;
  LastCheckTime: Int64 = 0;


 const
  // ������ ������ "������� ����������"
  cPanelStatusHeight_default:Word   = 72;
  cPanelStatusHeight_showqueue:Word = 110;

implementation

uses
    DMUnit,
    FunctionUnit,
    FormPropushennieUnit,
    FormSettingsUnit,
    Thread_StatisticsUnit,
    Thread_IVRUnit,
    Thread_QUEUEUnit,
    FormAboutUnit,
    FormOperatorStatusUnit,
    FormServerIKCheckUnit,
    FormAuthUnit,
    FormActiveSessionUnit,
    FormRePasswordUnit,
    Thread_AnsweredQueueUnit,
    ReportsUnit,
    Thread_ACTIVESIP_updatetalkUnit,
    FormDEBUGUnit,
    FormErrorUnit,
    TCustomTypeUnit,
    GlobalVariables,
    FormUsersUnit,
    FormServersIKUnit,
    FormSettingsGlobalUnit,
    FormTrunkUnit,
    TFTPUnit,
    TXmlUnit,
    FormStatisticsChartUnit,
    TForecastCallsUnit, FormStatusInfoUnit;


{$R *.dfm}

procedure OnDevelop;
begin
  MessageBox(HomeForm.Handle,PChar('������ ���������� � ����������!'),PChar('� ����������'),MB_OK+MB_ICONINFORMATION);
end;



procedure THomeForm.btnStatus_add_queue5000Click(Sender: TObject);
begin
 // ���������� � ������� 5000
 if not isExistRemoteCommand(eLog_add_queue_5000) then remoteCommand_addQueue(eLog_add_queue_5000)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_add_queue5000_5050Click(Sender: TObject);
begin
 // ���������� � ������� 5000 � 5050
 if not isExistRemoteCommand(eLog_add_queue_5000_5050) then remoteCommand_addQueue(eLog_add_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_add_queue5050Click(Sender: TObject);
begin
 // ���������� � ������� 5050
 if not isExistRemoteCommand(eLog_add_queue_5050) then remoteCommand_addQueue(eLog_add_queue_5050)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_availableClick(Sender: TObject);
var
 curr_queue:enumQueueCurrent;
begin

   if PanelStatusIN.Height=cPanelStatusHeight_showqueue then begin
    PanelStatusIN.Height:=cPanelStatusHeight_default;
    Exit;
   end;

   Screen.Cursor:=crHourGlass;

    PanelStatusIN.Height:=cPanelStatusHeight_showqueue;

    // ��������� � ����� ������� ��������� ��������
    curr_queue:=getCurrentQueueOperator(getUserSIP(SharedCurrentUserLogon.GetID));

    case curr_queue of
      queue_5000:begin
        btnStatus_add_queue5000.Enabled:=False;
        btnStatus_add_queue5050.Enabled:=True;
        btnStatus_add_queue5000_5050.Enabled:=False;
        btnStatus_del_queue_all.Enabled:=True;
      end;
      queue_5050:begin
        btnStatus_add_queue5000.Enabled:=True;
        btnStatus_add_queue5050.Enabled:=False;
        btnStatus_add_queue5000_5050.Enabled:=False;
        btnStatus_del_queue_all.Enabled:=True;
      end;
      queue_5000_5050:begin
        btnStatus_add_queue5000.Enabled:=False;
        btnStatus_add_queue5050.Enabled:=False;
        btnStatus_add_queue5000_5050.Enabled:=False;
        btnStatus_del_queue_all.Enabled:=True;
      end;
      queue_null:begin
        btnStatus_add_queue5000.Enabled:=True;
        btnStatus_add_queue5050.Enabled:=True;
        btnStatus_add_queue5000_5050.Enabled:=True;
        btnStatus_del_queue_all.Enabled:=False;
      end;
    end;

  Screen.Cursor:=crDefault;
end;

procedure THomeForm.btnStatus_breakClick(Sender: TObject);
begin
 // �������
 if not isExistRemoteCommand(eLog_break) then remoteCommand_addQueue(eLog_break)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_del_queue_allClick(Sender: TObject);
begin
  // ����� �� ���� �������� �� 5000 � 5050
 if not isExistRemoteCommand(eLog_del_queue_5000_5050) then remoteCommand_addQueue(eLog_del_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_dinnerClick(Sender: TObject);
begin
   // ����
 if not isExistRemoteCommand(eLog_dinner) then remoteCommand_addQueue(eLog_dinner)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_exodusClick(Sender: TObject);
begin
 // �����
 if not isExistRemoteCommand(eLog_exodus) then remoteCommand_addQueue(eLog_exodus)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_homeClick(Sender: TObject);
begin
 // �����
 if not isExistRemoteCommand(eLog_home) then remoteCommand_addQueue(eLog_home)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_ITClick(Sender: TObject);
begin
  // ��
 if not isExistRemoteCommand(eLog_IT) then remoteCommand_addQueue(eLog_IT)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_postvyzovClick(Sender: TObject);
begin
 // ���������
 if not isExistRemoteCommand(eLog_postvyzov) then remoteCommand_addQueue(eLog_postvyzov)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_reserveClick(Sender: TObject);
begin
 // ��������
 if not isExistRemoteCommand(eLog_reserve) then remoteCommand_addQueue(eLog_reserve)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_studiesClick(Sender: TObject);
begin
 // �����
 if not isExistRemoteCommand(eLog_studies) then remoteCommand_addQueue(eLog_studies)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_transferClick(Sender: TObject);
begin
// ��������
 if not isExistRemoteCommand(eLog_transfer) then remoteCommand_addQueue(eLog_transfer)
 else begin
    MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.START_THREAD_ALLlClick(Sender: TObject);
begin
  Timer_Thread_Start.Enabled:=True;
end;


procedure THomeForm.ST_HelpStatusInfoClick(Sender: TObject);
begin
 FormStatusInfo.Show;
end;

procedure THomeForm.ST_HelpStatusInfoMouseLeave(Sender: TObject);
begin
  ST_HelpStatusInfo.Font.Style:=[fsBold];
end;

procedure THomeForm.ST_HelpStatusInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ST_HelpStatusInfo.Font.Style:=[fsUnderline,fsBold];
end;

procedure THomeForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  DialogResult: Integer;
begin
  if DEBUG then KillProcess;  

  // �������� ����� ���� ��������� � �� �� ����� �� �����
  if getIsExitOperatorCurrentQueue(SharedCurrentUserLogon.GetRole, SharedCurrentUserLogon.GetID) then begin
    CanClose:= Application.MessageBox(PChar(getUserNameBD(SharedCurrentUserLogon.GetID) + ', �� ������ ����� �� �������'), '������ ��� ������', MB_OK + MB_ICONERROR) = IDNO;
  end
  else begin
    // ��������� ��������� �� �������� ����� ����� �������
    if getIsExitOperatorCurrentGoHome(SharedCurrentUserLogon.GetRole, SharedCurrentUserLogon.GetID) then begin
      CanClose:= Application.MessageBox(PChar('������ ��� �������, ���������� ������� ������ "�����"'), '������ ��� ������', MB_OK + MB_ICONERROR) = IDNO;
    end
    else begin
      if getStatusIndividualSettingsUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit) = paramStatus_DISABLED then begin

        AMsgDialog := CreateMessageDialog('�� ������������� ������ ��������� ������?', mtConfirmation, [mbYes, mbNo]);
        ACheckBox := TCheckBox.Create(AMsgDialog);

        with AMsgDialog do
        try
          Caption:= '��������� ������';
          Height:= 150;
          (FindComponent('Yes') as TButton).Caption := '��';
          (FindComponent('No')  as TButton).Caption := '���';

          with ACheckBox do begin
            Parent:= AMsgDialog;
            Caption:= '�� ���������� ������ ��� ���������';
            Top:= 100;
            Left:= 8;
            Width:= AMsgDialog.Width;
          end;

          DialogResult:= ShowModal; // ��������� ��������� � ����������

          if DialogResult = ID_YES then
          begin
            if ACheckBox.Checked then begin
              // ��������� �������� ����� ������ �� ���������� ��� ����
              saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit,paramStatus_ENABLED);
            end;

            KillProcess;
          end
          else if DialogResult = ID_NO then
          begin
            Abort; // ������ ������
          end else Abort;

        finally
          FreeAndNil(ACheckBox);
          Free;
        end;
      end;
       KillProcess;
    end;
  end;
end;

procedure THomeForm.FormCreate(Sender: TObject);
var
 FolderDll:string;
begin
  FolderDll:= FOLDERPATH + 'dll';

  // �������� �� ������������� �����
  if DirectoryExists(FolderDll) then begin
    // ���� � ����� � DLL
    SetDllDirectory(PChar(FolderDll));
  end
  else begin
    MessageBox(Handle,PChar('�� ������� ����� � dll ������������'+#13#13+FolderDll),PChar('������'),MB_OK+MB_ICONERROR);
    KillProcess; // ��������� ���������� ���������, ����� �� ���������� ������
  end;
  // ������� ��� ���� �����
  clearAllLists;

  // ������ ������ "������� ����������" �� default
  PanelStatusIN.Height:=cPanelStatusHeight_default;
end;


procedure THomeForm.FormResize(Sender: TObject);
const
 cDefault_Panel_SIP:Word = 383; // ������� ����� ����������� �������� ���� 1400 - 1017(����� �� ��������� ����)
begin
 // �������� ������ �����
 // �������� ���������
  clearList_SIP(Width - cDefault_Panel_SIP);

  if Assigned(SharedCurrentUserLogon) then begin
    if SharedCurrentUserLogon.GetIsOperator then begin
      // �������� ������ �������� ���������
      ResizeCentrePanelStatusOperators(Width - cDefault_Panel_SIP);
    end;
  end;

end;

procedure THomeForm.FormShow(Sender: TObject);
var
 i:Integer;
 error:string;
begin
 try
  Height:=900; //1011
  ClientWidth:=1410;

  // ������� ���������� ����� �� �����
  if not isExistFreeSpaceDrive(error) then begin
    ShowFormErrorMessage(error,SharedMainLog,'THomeForm.FormShow');
  end;

  // �������� ���������� �� MySQL Connector
  if not isExistMySQLConnector then begin
    error:='�� ���������� MySQL Connector';
    ShowFormErrorMessage(error,SharedMainLog,'THomeForm.FormShow');
  end;

  // ����������� ������� ������  ctrl+shift+G (GUID) - �� ����� ID ������� ������������ ���
  Caption:=Caption+' '+getVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')';

  // �������� �� ������ ������
  CheckCurrentVersion;

  // ������� �� ��������� ������ ����� ��������������
  ClearAfterUpdate;

   // �������� �� 2�� ����� ��������
  if GetCloneRun(PChar(DASHBOARD_EXE)) then begin
    MessageBox(HomeForm.Handle,PChar('��������� ������ 2�� ����� ���������'+#13#13+
                                     '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
    KillProcess;
  end;


  Screen.Cursor:=crHourGlass;

   // ������� ����������� ������������
  SharedCurrentUserLogon:=TUser.Create;


 ////////////////////////////////////
  // �����������
  FormAuth.ShowModal;

  // ����� �� ������� ������
  if SharedCurrentUserLogon.GetRePassword then begin
    Screen.Cursor:=crDefault;
    FormRePassword.ShowModal;
  end;
  ////////////////////////////////

  Screen.Cursor:=crHourGlass;

   // �������� ���
   with StatusBar do begin
    Panels[2].Text:=SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName;
    Panels[3].Text:=getUserRoleSTR(SharedCurrentUserLogon.GetID);
    Panels[4].Text:=GetCopyright;
   end;

   // ��������� ������ � ������� �����
   CreateCurrentActiveSession(SharedCurrentUserLogon.GetID);


  // �������� ������ �������� ��� �������� �����������
  createCheckServersInfoclinika;


  // ��������� �������������� �������� ������������
  LoadIndividualSettingUser(SharedCurrentUserLogon.GetID);


  // ����������� ���� �������
  accessRights(SharedCurrentUserLogon);

  // ��������
   Egg;

  Screen.Cursor:=crDefault;

  // ������� ��� ������
  START_THREAD_ALLl.Click;
  except
  on E: Exception do begin
    error:='���� ������� ������� �� ������ ���� ����!'+#13+
           '�������� ����������� ������'+#13#13+
           '��� ������: '+E.ClassName+#13+E.Message;
    ShowFormErrorMessage(error, SharedMainLog, 'THomeForm.FormShow');
  end;
 end;
end;

procedure THomeForm.img_ShowOperatorStatusClick(Sender: TObject);
begin
  ShowOperatorsStatus;
end;

procedure THomeForm.menu_UsersClick(Sender: TObject);
begin
  FormUsers.Show;
end;

procedure THomeForm.ST_StatusPanelWindowClick(Sender: TObject);
begin
  ShowOperatorsStatus;
end;

procedure THomeForm.img_goHome_YESClick(Sender: TObject);
begin
  VisibleIconOperatorsGoHome(goHome_Hide, True);
end;

procedure THomeForm.img_SL_History_GraphClick(Sender: TObject);
begin
  OnDevelop;
end;

procedure THomeForm.img_StatisticsQueue_GraphClick(Sender: TObject);
begin
 ShowStatisticsCallsDay(eGraph, True);
end;

procedure THomeForm.img_StatisticsQueue_NumbersClick(Sender: TObject);
begin
  ShowStatisticsCallsDay(eNumbers, True);
end;

procedure THomeForm.img_goHome_NOClick(Sender: TObject);
begin
  VisibleIconOperatorsGoHome(goHome_Show, True);
end;

procedure THomeForm.img_statistics_current_QUEUEClick(Sender: TObject);
begin
  OnDevelop;
end;

procedure THomeForm.img_statistics_IVRClick(Sender: TObject);
begin
  OnDevelop;
end;

procedure THomeForm.img_statistics_list_QUEUEClick(Sender: TObject);
begin
 OnDevelop;
end;

procedure THomeForm.img_statistics_QUEUEClick(Sender: TObject);
begin
  FormStatisticsChart.Show;
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveClick(Sender: TObject);
begin
  FormServerIKCheck.Show;
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveMouseLeave(Sender: TObject);
begin
  lblCheckInfocilinikaServerAlive.Font.Style:=[fsBold];
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 lblCheckInfocilinikaServerAlive.Font.Style:=[fsUnderline,fsBold];
end;

procedure THomeForm.lblNewMessageLocalChatClick(Sender: TObject);
begin
  lblNewMessageLocalChat.Visible:=False;
  OpenLocalChat;
end;

procedure THomeForm.lblNewMessageLocalChatMouseLeave(Sender: TObject);
begin
   lblNewMessageLocalChat.Font.Style:=[fsBold];
end;

procedure THomeForm.lblNewMessageLocalChatMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblNewMessageLocalChat.Font.Style:=[fsUnderline,fsBold];
end;

procedure THomeForm.lblNewVersionDashboardClick(Sender: TObject);
begin
  MessageBox(Handle,PChar('��� ���������� ���������� �������� ���������'+#13+'� ��������� ����� 30 ���'),PChar('����������'),MB_OK+MB_ICONINFORMATION);
end;

procedure THomeForm.ListViewSIPCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 counts:Integer;
 time_talk:Integer;
 test:string;
 longtalk:string;
begin
  if not Assigned(Item) then Exit;

  try
    counts:=Item.SubItems.Count; // TODO ��� �������� ��� ����� ��� ��������

    if Item.SubItems.Count = 7 then // ���������, ��� ���� ���������� SubItems
    begin

      if Item.SubItems.Strings[1] = '��������' then
      begin
        Sender.Canvas.Font.Color := clGreen;
        Exit;
      end;

      if Item.SubItems.Strings[4] <> '---' then begin
        test:=Item.SubItems.Strings[4];

        time_talk:=GetTimeAnsweredToSeconds(Item.SubItems.Strings[4],True);

        if (time_talk >= 180) and (time_talk <= 600)  then begin
         Sender.Canvas.Font.Color := clRed;
         Exit;
        end else if (time_talk > 600) and (time_talk <= 900)  then begin
         Sender.Canvas.Font.Color := $0000008A;
         Exit;
        end else if time_talk >= 900 then begin
         Sender.Canvas.Font.Color := clBlue;
         Exit;
        end;

      end
      else if AnsiPos('���������',Item.SubItems.Strings[1])<> 0 then begin
        longtalk:=Item.SubItems.Strings[1];
        System.Delete(longtalk, 1, AnsiPos('(',longtalk));
        System.Delete(longtalk, AnsiPos(')',longtalk),Length(longtalk));

        time_talk:=GetTimeAnsweredToSeconds(longtalk);

        if time_talk >= 180 then begin
         Sender.Canvas.Font.Color := clRed;
         Exit;
        end;
      end;

      if (AnsiPos('����',Item.SubItems.Strings[1]) <> 0) or
         (AnsiPos('�������',Item.SubItems.Strings[1]) <> 0) then
      begin
        Sender.Canvas.Font.Color := $00DDB897;
        Exit;
      end;
    end;

   Sender.Canvas.Font.Color := clBlack;
  except
    on E:Exception do
    begin
     SharedMainLog.Save('THomeForm.ListViewSIPCustomDrawItem. '+e.ClassName+' : '+e.Message, IS_ERROR);
    end;
  end;
end;

procedure THomeForm.menu_About_DebugClick(Sender: TObject);
begin
   FormDEBUG.Show;
end;

procedure THomeForm.menu_About_VersionClick(Sender: TObject);
begin
 FormAbout.ShowModal;
end;

procedure THomeForm.menu_activeSessionClick(Sender: TObject);
begin
  FormActiveSession.ShowModal;
end;

procedure THomeForm.menu_ChangePasswordClick(Sender: TObject);
begin
   with FormRePassword do begin
    changePasswordManual:=True;
    ShowModal;
   end;
end;

procedure THomeForm.menu_ChatClick(Sender: TObject);
begin
  OpenLocalChat;
end;

procedure THomeForm.menu_FormPropushennieClick(Sender: TObject);
begin
  FormPropushennie.ShowModal;
end;

procedure THomeForm.menu_ServersIKClick(Sender: TObject);
begin
  FormServersIK.ShowModal;
end;

procedure THomeForm.menu_SIPtrunkClick(Sender: TObject);
begin
   FormTrunk.ShowModal;
end;

procedure THomeForm.menu_SMSClick(Sender: TObject);
begin
 OpenSMS;
end;

procedure THomeForm.Timer_Thread_StartTimer(Sender: TObject);
begin
  // �������� ������� + ������
  createThreadDashboard;

  Timer_Thread_Start.Enabled:=False;
end;

procedure THomeForm.menu_GlobalSettingsClick(Sender: TObject);
begin
 FormSettingsGlobal.ShowModal;
end;

procedure THomeForm.menu_ReportsClick(Sender: TObject);
begin
  OpenReports;
end;



end.
