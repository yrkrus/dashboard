unit FormHome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus,Data.Win.ADODB, Data.DB, Vcl.Imaging.jpeg,System.SyncObjs,
  TActiveSIPUnit,TUserUnit, Vcl.Imaging.pngimage, ShellAPI, TLogFileUnit,
  System.Zip, Vcl.WinXCtrls, Vcl.Samples.Gauges, TCustomTypeUnit;


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
    menu_missed_calls: TMenuItem;
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
    menu_ChangePassword: TMenuItem;
    Label23: TLabel;
    Label24: TLabel;
    menu_About_Version: TMenuItem;
    N1: TMenuItem;
    menu_About_Debug: TMenuItem;
    ListViewIVR: TListView;
    ListViewQueue: TListView;
    Panel_SIP: TPanel;
    ListViewSIP: TListView;
    img_statistics_IVR: TImage;
    lblCount_ACTIVESIP: TLabel;
    ST_SL: TStaticText;
    STlist_ACTIVESIP_NO_Rings: TStaticText;
    popMenu_ActionOperators: TPopupMenu;
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
    btnStatus_callback: TButton;
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
    popMenu_ActionOperators_HistoryCallOperator: TMenuItem;
    img_DownFont_ActiveSIP: TImage;
    img_UpFont_ActiveSIP: TImage;
    img_UpFont_IVR: TImage;
    img_DownFont_IVR: TImage;
    img_UpFont_Queue: TImage;
    img_DownFont_Queue: TImage;
    Button1: TButton;
    popMenu_ActionOperators_HistoryStatusOPerators: TMenuItem;
    N19: TMenuItem;
    menu_service: TMenuItem;
    y1: TMenuItem;
    N3: TMenuItem;
    J1: TMenuItem;
    N4: TMenuItem;
    popMenu_ActionOperators_DelQueue: TMenuItem;
    popMenu_ActionOperators_AddQueue5050: TMenuItem;
    popMenu_ActionOperators_AddQueue5000_5050: TMenuItem;
    popMenu_ActionOperators_AddQueue5000: TMenuItem;
    StaticText1: TStaticText;
    procedure START_THREAD_ALLlClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer_Thread_StartTimer(Sender: TObject);
    procedure menu_missed_callsClick(Sender: TObject);
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
    procedure popMenu_ActionOperators_HistoryCallOperatorClick(Sender: TObject);
    procedure img_UpFont_ActiveSIPClick(Sender: TObject);
    procedure img_DownFont_ActiveSIPClick(Sender: TObject);
    procedure img_UpFont_IVRClick(Sender: TObject);
    procedure img_DownFont_IVRClick(Sender: TObject);
    procedure img_UpFont_QueueClick(Sender: TObject);
    procedure img_DownFont_QueueClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PanelStatusINMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelStatusINMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelStatusINMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListViewSIPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popMenu_ActionOperators_HistoryStatusOPeratorsClick(
      Sender: TObject);
    procedure menu_serviceClick(Sender: TObject);
    procedure btnStatus_callbackClick(Sender: TObject);
    procedure lblStstatisc_Queue5000_No_AnsweredClick(Sender: TObject);
    procedure lblStstatisc_Queue5050_No_AnsweredClick(Sender: TObject);
    procedure lblStstatisc_Queue5000_No_AnsweredMouseLeave(Sender: TObject);
    procedure lblStstatisc_Queue5000_No_AnsweredMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblStstatisc_Queue5050_No_AnsweredMouseLeave(Sender: TObject);
    procedure lblStstatisc_Queue5050_No_AnsweredMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure popMenu_ActionOperators_DelQueueClick(Sender: TObject);
    procedure popMenu_ActionOperators_AddQueue5000Click(Sender: TObject);
    procedure popMenu_ActionOperators_AddQueue5050Click(Sender: TObject);
    procedure popMenu_ActionOperators_AddQueue5000_5050Click(Sender: TObject);

  private
    { Private declarations }
   FDragging: Boolean;      // ��������� ��� ������ �� ��������� ���������� ������������
   FMouseOffset: TPoint;
   SelectedItemPopMenu: TListItem; // ���������� ��� �������� ���������� ��������(��� popmenu_ActionOPerators)

   procedure WndProc(var Msg: TMessage); override;   // ��������� ������ ������ �� ���������  Ctrl + ��������

   procedure ViewLabel(IsBold,IsUnderline:Boolean; var p_label:TLabel); // ���������� ��������� ��� ��������� ��������� ����
   function SendCommand(_command:enumLogging;_userID:Integer):Boolean;     // �������� ��������� �������
   procedure AddQueuePopMenu(_command:enumLogging;_userSip:Integer); // ���������� � ������� �� popmenu



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

  const
  FLASHW_STOP = $00000000; // ���������� ��������
  FLASHW_CAPTION = $00000001; // �������� ��������� ����
  FLASHW_TRAY = $00000002; // �������� ������ � ����
  FLASHW_ALL = FLASHW_CAPTION or FLASHW_TRAY; // �������� �����
  FLASHW_TIMER = $00000004; // ������������ ������ ��� ��������
  FLASHW_TIMERNOFG = $00000008; // ������������ ������, ���� ���� ���� �� �������


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



 const
  // ������ ������ "������� ����������"
  cPanelStatusHeight_default:Word   = 72;
  cPanelStatusHeight_showqueue:Word = 110;

implementation

uses
    DMUnit, FunctionUnit, FormPropushennieUnit, FormSettingsUnit, Thread_StatisticsUnit, Thread_IVRUnit,
    Thread_QUEUEUnit, FormAboutUnit, FormOperatorStatusUnit, FormServerIKCheckUnit, FormAuthUnit,
    FormActiveSessionUnit, FormRePasswordUnit, Thread_AnsweredQueueUnit, ReportsUnit, Thread_ACTIVESIP_updatetalkUnit,
    FormDEBUGUnit, FormErrorUnit,GlobalVariables, FormUsersUnit, FormServersIKUnit, FormSettingsGlobalUnit,
    FormTrunkUnit, TFTPUnit, TXmlUnit, FormStatisticsChartUnit, TForecastCallsUnit, FormStatusInfoUnit,
    FormHistoryCallOperatorUnit, FormChatNewMessageUnit, TDebugStructUnit, FormHistoryStatusOperatorUnit, GlobalVariablesLinkDLL;


{$R *.dfm}

function FlashWindowEx(var pwfi: TFlashWindowInfo): BOOL; stdcall; external user32 name 'FlashWindowEx';

procedure OnDevelop;
begin
  MessageBox(HomeForm.Handle,PChar('������ ���������� � ����������!'),PChar('� ����������'),MB_OK+MB_ICONINFORMATION);
end;



procedure THomeForm.btnStatus_add_queue5000Click(Sender: TObject);
begin
 // ���������� � ������� 5000
 SendCommand(eLog_add_queue_5000,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_add_queue5000_5050Click(Sender: TObject);
begin
 // ���������� � ������� 5000 � 5050
  SendCommand(eLog_add_queue_5000_5050,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_add_queue5050Click(Sender: TObject);
begin
 // ���������� � ������� 5050
 SendCommand(eLog_add_queue_5050,SharedCurrentUserLogon.GetID);
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
  SendCommand(eLog_break,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_callbackClick(Sender: TObject);
begin
  // callback
 if SendCommand(eLog_callback,SharedCurrentUserLogon.GetID) then begin
   with FormPropushennie do begin
     SetQueue(queue_5000_5050,eMissed_no_return);
     SetCallbak;

     ShowModal;
   end;
 end;
end;

procedure THomeForm.btnStatus_del_queue_allClick(Sender: TObject);
begin
  // ����� �� ���� �������� �� 5000 � 5050
  SendCommand(eLog_del_queue_5000_5050,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_dinnerClick(Sender: TObject);
begin
   // ����
  SendCommand(eLog_dinner,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_exodusClick(Sender: TObject);
begin
 // �����
  SendCommand(eLog_exodus,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_homeClick(Sender: TObject);
begin
 // �����
  SendCommand(eLog_home,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_ITClick(Sender: TObject);
begin
  // ��
   SendCommand(eLog_IT,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_postvyzovClick(Sender: TObject);
begin
 // ���������
  SendCommand(eLog_postvyzov,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_reserveClick(Sender: TObject);
begin
 // ��������
  SendCommand(eLog_reserve,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_studiesClick(Sender: TObject);
begin
 // �����
   SendCommand(eLog_studies,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.btnStatus_transferClick(Sender: TObject);
begin
// ��������
 SendCommand(eLog_transfer,SharedCurrentUserLogon.GetID);
end;

procedure THomeForm.Button1Click(Sender: TObject);
var
  ScreenRect: TRect;
  TaskbarHeight: Integer;

  FlashInfo: TFlashWindowInfo;

  test: TDebugStruct;

begin
//  // �������� ������� �������� ����� � ������ ������ �����
//  SystemParametersInfo(SPI_GETWORKAREA, 0, @ScreenRect, 0);
//
//  // ������������� ������� �����
//  FormChatNewMessage.Left := ScreenRect.Right - FormChatNewMessage.Width - 10; // 10 - ������ �� ���� ������
//  FormChatNewMessage.Top := ScreenRect.Bottom - FormChatNewMessage.Height - 10; // 10 - ������ �� ���� ������
//
//  // ���������� �����
//
//
//  FormChatNewMessage.Show;
//
//
//
//
//  FlashInfo.cbSize := SizeOf(TFlashWindowInfo);
//  FlashInfo.hwnd := Handle; // ��������� ���������� ����
//  FlashInfo.dwFlags := FLASHW_ALL; // �������� ����� ����
//  FlashInfo.uCount := 999999999; // ���������� ��������
//  FlashInfo.dwTimeout := 0; // �������� ����� ���������� (0 - �����������)
//
//  FlashWindowEx(FlashInfo);

  // test:=TDebugStruct.Create('Thread_test');
  // SharedCountResponseThread.Add(test);
  // SharedCountResponseThread.SetCurrentResponse('Thread_test',100);

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
    CanClose:= Application.MessageBox(PChar('�� ������ ����� �� �������'), '������ ��� ������', MB_OK + MB_ICONERROR) = IDNO;
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

  // ������ ������ "������� ����������" �� default
  PanelStatusIN.Height:=cPanelStatusHeight_default;
  FDragging:=False;
end;


procedure THomeForm.FormResize(Sender: TObject);
var
 XML:TXML;
begin
 // �������� ������ �����
 // �������� ���������
  clearList_SIP(Width - DEFAULT_SIZE_PANEL_ACTIVESIP, SharedFontSize.GetSize(eActiveSip));

  if Assigned(SharedCurrentUserLogon) then begin
    if SharedCurrentUserLogon.GetIsOperator then begin
      // �������� ������ �������� ���������
      ResizeCentrePanelStatusOperators(Width - DEFAULT_SIZE_PANEL_ACTIVESIP);
    end;
  end;

  // ��������� ������ ������� �����
  begin
    XML:=TXML.Create;
    case WindowState of
      wsNormal:     XML.SetWindowState('wsNormal');
      wsMaximized:  XML.SetWindowState('wsMaximized');
    end;
    XML.Free;
  end;
end;

procedure THomeForm.FormShow(Sender: TObject);
var
 i:Integer;
 error:string;
begin
 try
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
  if DEBUG then Caption:='    ===== DEBUG =====    ' + Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')'
  else Caption:=Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')';



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

  // �������� ���� ����� debug info � ����� ��� �������� ���������� ������ �������
  SharedCountResponseThread.SetAddForm(FormDEBUG);

  // ������� ��� ���� �����
  clearAllLists;

   // ������ ������� ����� ������
  WindowStateInit;

  Screen.Cursor:=crDefault;

  // ����+����� ������
  PROGRAM_STARTED:=Now;

  // ������� ��� ������ (������ ������ ���������� ������������������!!)
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

procedure THomeForm.PanelStatusINMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FDragging:= True;
    // ��������� �������� ���� ������������ ������
    FMouseOffset:= Point(X, Y);
  end;
end;

procedure THomeForm.PanelStatusINMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
  begin
    // ���������� ������, �������� �������� ����
    PanelStatus.Left := PanelStatus.Left + (Mouse.CursorPos.X - PanelStatus.Left - FMouseOffset.X);
    PanelStatus.Top := PanelStatus.Top + (Mouse.CursorPos.Y - PanelStatus.Top - FMouseOffset.Y);
    Screen.Cursor:=crHandPoint;
  end;
end;

procedure THomeForm.PanelStatusINMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FDragging:= False;
    Screen.Cursor:=crDefault;
  end;
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5000Click(Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
 resultat:Word;
 id:Integer;
begin
  // ���������, ��� �� ������ �������
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // � ������� �� ��������� ��������
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.GetListOperators_Queue(id) = queue_5000 then begin
    MessageBox(Handle,PChar('�������� � ��� � ���� �������'),PChar('������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  user_id:=getUserID(id_sip);

  AddQueuePopMenu(eLog_add_queue_5000, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5000_5050Click(
  Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
 resultat:Word;
 id:Integer;
begin
  // ���������, ��� �� ������ �������
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // � ������� �� ��������� ��������
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.GetListOperators_Queue(id) = queue_5000_5050 then begin
    MessageBox(Handle,PChar('�������� � ��� � ���� �������'),PChar('������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  user_id:=getUserID(id_sip);

  AddQueuePopMenu(eLog_add_queue_5000_5050, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5050Click(Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
 resultat:Word;
 id:Integer;
begin
  // ���������, ��� �� ������ �������
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // � ������� �� ��������� ��������
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.GetListOperators_Queue(id) = queue_5050 then begin
    MessageBox(Handle,PChar('�������� � ��� � ���� �������'),PChar('������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  user_id:=getUserID(id_sip);

  AddQueuePopMenu(eLog_add_queue_5050, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_DelQueueClick(Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
 resultat:Word;
begin
  // ���������, ��� �� ������ �������
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // � ������� �� ��������� ��������
  if not SharedActiveSipOperators.isExistOperatorInQueue(IntToStr(id_sip)) then begin
    MessageBox(Handle,PChar('�������� �� � �������'),PChar('������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  // ������ id � ��������� ��� ������
  user_id:=getUserID(id_sip);

  resultat:=MessageBox(0,PChar('����� ������� �� �������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrNo then begin
    Exit;
  end;

  // ����� �� ���� �������� �� 5000 � 5050
  SendCommand(eLog_home,user_id);

  // ������� �������
  UpdateOperatorStatus(eUnknown,user_id);

  LoggingRemote(eLog_home,user_id);
end;

procedure THomeForm.popMenu_ActionOperators_HistoryCallOperatorClick(
  Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
begin
  // ���������, ��� �� ������ �������
  if Assigned(SelectedItemPopMenu) then
  begin
    id_sip:=StrToInt(SelectedItemPopMenu.Caption);

    // ������ id � ��������� ��� ������
    user_id:=getUserID(id_sip);
    FormHistoryCallOperator.SetID(user_id);
    FormHistoryCallOperator.SetSip(id_sip);

    FormHistoryCallOperator.ShowModal;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

procedure THomeForm.popMenu_ActionOperators_HistoryStatusOPeratorsClick(
  Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
begin
  // ���������, ��� �� ������ �������
  if Assigned(SelectedItemPopMenu) then
  begin
    id_sip:=StrToInt(SelectedItemPopMenu.Caption);

    // ������ id � ��������� ��� ������
    user_id:=getUserID(id_sip);
    FormHistoryStatusOperator.SetID(user_id);
    FormHistoryStatusOperator.SetSip(id_sip);

    FormHistoryStatusOperator.ShowModal;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������ ��������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
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

procedure THomeForm.img_DownFont_ActiveSIPClick(Sender: TObject);
begin
   ChangeFontSize(eFontDonw,eActiveSip);
end;

procedure THomeForm.img_DownFont_IVRClick(Sender: TObject);
begin
 ChangeFontSize(eFontDonw,eIvr);
end;

procedure THomeForm.img_DownFont_QueueClick(Sender: TObject);
begin
 ChangeFontSize(eFontDonw,eQueue);
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

procedure THomeForm.img_UpFont_ActiveSIPClick(Sender: TObject);
begin
 ChangeFontSize(eFontUP,eActiveSip);
end;

procedure THomeForm.img_UpFont_IVRClick(Sender: TObject);
begin
 ChangeFontSize(eFontUP,eIvr);
end;

procedure THomeForm.img_UpFont_QueueClick(Sender: TObject);
begin
  ChangeFontSize(eFontUP,eQueue);
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveClick(Sender: TObject);
begin
  FormServerIKCheck.Show;
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveMouseLeave(Sender: TObject);
begin
  lblCheckInfocilinikaServerAlive.Font.Style:=[];
end;

procedure THomeForm.lblCheckInfocilinikaServerAliveMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 lblCheckInfocilinikaServerAlive.Font.Style:=[fsUnderline];
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

procedure THomeForm.lblStstatisc_Queue5000_No_AnsweredClick(Sender: TObject);
var
 error:string;
begin
 // ���� �� ������ � �����������
  if not OpenMissedCalls(error, queue_5000, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // ����� �� ���� 5000
   Show;
  end;
end;

procedure THomeForm.lblStstatisc_Queue5000_No_AnsweredMouseLeave(
  Sender: TObject);
begin
  ViewLabel(False,False, lblStstatisc_Queue5000_No_Answered);
end;

procedure THomeForm.lblStstatisc_Queue5000_No_AnsweredMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 ViewLabel(False,True, lblStstatisc_Queue5000_No_Answered);
end;

procedure THomeForm.lblStstatisc_Queue5050_No_AnsweredClick(Sender: TObject);
var
 error:string;
begin
 // ���� �� ������ � �����������
  if not OpenMissedCalls(error, queue_5050, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // ����� �� ���� 5050
   Show;
  end;
end;

procedure THomeForm.lblStstatisc_Queue5050_No_AnsweredMouseLeave(
  Sender: TObject);
begin
 ViewLabel(False,False, lblStstatisc_Queue5050_No_Answered);
end;

procedure THomeForm.lblStstatisc_Queue5050_No_AnsweredMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ViewLabel(False,True, lblStstatisc_Queue5050_No_Answered);
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

    if Item.SubItems.Count = 8 then // ���������, ��� ���� ���������� SubItems
    begin

      if Item.SubItems.Strings[1] = '��������' then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
        Exit;
      end;

      if Item.SubItems.Strings[5] <> '---' then begin
        test:=Item.SubItems.Strings[5];

        time_talk:=GetTimeAnsweredToSeconds(Item.SubItems.Strings[5],True);

        if (time_talk >= 180) and (time_talk <= 600)  then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
         Exit;
        end else if (time_talk > 600) and (time_talk <= 900)  then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Bad);
         Exit;
        end else if time_talk >= 900 then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Very_Bad);
         Exit;
        end;

      end
      else if AnsiPos('���������',Item.SubItems.Strings[1])<> 0 then begin
        longtalk:=Item.SubItems.Strings[1];
        System.Delete(longtalk, 1, AnsiPos('(',longtalk));
        System.Delete(longtalk, AnsiPos(')',longtalk),Length(longtalk));

        time_talk:=GetTimeAnsweredToSeconds(longtalk);

        if time_talk >= 180 then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
         Exit;
        end;
      end;

      if (AnsiPos('����',Item.SubItems.Strings[1]) <> 0) or
         (AnsiPos('�������',Item.SubItems.Strings[1]) <> 0) then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Break);
        Exit;
      end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('THomeForm.ListViewSIPCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;
end;

procedure THomeForm.ListViewSIPMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ���������, ��� �� ���� ������ ������� ����
  if Button = mbRight then
  begin
    // �������� �������, �� ������� ��������
    SelectedItemPopMenu := ListViewSIP.GetItemAt(X, Y);
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

procedure THomeForm.menu_missed_callsClick(Sender: TObject);
var
 error:string;
begin
  // ���� �� ������ � �����������
  if not OpenMissedCalls(error, queue_5000, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // ����� �� ���� 5000+5050
   Show;
  end;
end;

procedure THomeForm.menu_ServersIKClick(Sender: TObject);
begin
  FormServersIK.ShowModal;
end;

procedure THomeForm.menu_serviceClick(Sender: TObject);
begin
 OpenService;
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


// ��������� ������ ������ �� ���������  Ctrl + ��������
procedure THomeForm.WndProc(var Msg: TMessage);
var
  Shift: TShiftState;
  WheelDelta: Integer;
begin
  inherited WndProc(Msg);

  if Msg.Msg = WM_MOUSEWHEEL then
  begin
    // �������� �������� ���������
    WheelDelta := Smallint(HIWORD(Msg.WParam));

    // ����������, ��������� �� ������ ��� ListView
    if PtInRect(ListViewSIP.ClientRect, ListViewSIP.ScreenToClient(Mouse.CursorPos)) then
    begin
      // �������� ��������� ������
      Shift := KeyDataToShiftState(Msg.WParam);

      if (Shift * [ssCtrl] <> []) then
      begin
        if WheelDelta > 0 then
        begin
          // Ctrl + �������� �����
           ChangeFontSize(eFontUP,eActiveSip);
        end
        else
        begin
          // Ctrl + �������� ����
          ChangeFontSize(eFontDonw,eActiveSip);
        end;
        Msg.Result := 1; // ��������, ��� ������� ����������
      end
      else Msg.Result := 1; // ��������, ��� ������� ����������
    end;
  end;
end;


// ���������� ��������� ��� ��������� ��������� ����
procedure THomeForm.ViewLabel(IsBold,IsUnderline:Boolean; var p_label:TLabel);
begin
  if not (IsBold) and not (IsUnderline) then p_label.Font.Style:=[];
  if (IsBold) and (IsUnderline) then p_label.Font.Style:=[fsBold,fsUnderline];

  if not (IsBold) and (IsUnderline) then p_label.Font.Style:=[fsUnderline];
  if (IsBold) and not (IsUnderline) then p_label.Font.Style:=[fsBold];
end;

 // �������� ��������� �������
function THomeForm.SendCommand(_command:enumLogging;_userID:Integer):Boolean;
var
 error:string;
begin
 Result:=False;

 if isExistRemoteCommand(_command,_userID) then begin
   MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
   Exit;
 end;

 if not remoteCommand_addQueue(_command,_userID, error) then begin
   MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
  Exit;
 end;

 Result:=True;
end;


// ���������� � ������� �� popmenu
procedure THomeForm.AddQueuePopMenu(_command:enumLogging;_userSip:Integer);
var
 user_id:Integer;
begin
  // ������ id
  user_id:=getUserID(_userSip);

 if not SendCommand(_command,user_id) then begin
  // todo � SendCommand messagebox � �������� ����
  Exit;
 end;

  // ������� �������
  UpdateOperatorStatus(eAvailable,user_id);
  LoggingRemote(eLog_available,user_id);
end;


end.
