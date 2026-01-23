unit FormHome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus,Data.Win.ADODB, Data.DB, Vcl.Imaging.jpeg,System.SyncObjs,
  TActiveSIPUnit,TUserUnit, Vcl.Imaging.pngimage, ShellAPI, TLogFileUnit,
  System.Zip, Vcl.WinXCtrls, Vcl.Samples.Gauges, TCustomTypeUnit, Vcl.Buttons,
  Thread_ACTIVESIPUnit, Thread_StatisticsUnit,Thread_IVRUnit,Thread_AnsweredQueueUnit,
  Thread_QUEUEUnit, Thread_ACTIVESIP_QueueUnit, Thread_ACTIVESIP_updatetalkUnit,
  Thread_ACTIVESIP_updatePhoneTalkUnit, Thread_ACTIVESIP_countTalkUnit,
  Thread_CheckTrunkUnit, Thread_InternalProcessUnit, Thread_LISAUnit,
  TThreadDispatcherUnit,TXmlUnit, System.Generics.Collections;


type
  THomeForm = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    lblCount_QUEUE: TLabel;
    Label20: TLabel;
    lblStstistisc_Day_Answered: TLabel;
    lblStstistisc_Day_No_Answered: TLabel;
    lblStstistisc_Day_Procent: TLabel;
    lblCount_IVR: TLabel;
    panel_IVR: TPanel;
    STlist_IVR_NO_Rings: TStaticText;
    Panel_Queue: TPanel;
    STlist_QUEUE_NO_Rings: TStaticText;
    StatusBar: TStatusBar;
    FooterMenu: TMainMenu;
    menu: TMenuItem;
    menu_missed_calls: TMenuItem;
    menu_About: TMenuItem;
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
    lblCheckSipTrunkAlive: TLabel;
    menu_About_Version: TMenuItem;
    N1: TMenuItem;
    menu_About_Debug: TMenuItem;
    ListViewIVR: TListView;
    ListViewQueue: TListView;
    Panel_SIP: TPanel;
    ListViewSIP: TListView;
    lblCount_ACTIVESIP: TLabel;
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
    ST_StatusPanel: TStaticText;
    img_goHome_YES: TImage;
    img_goHome_NO: TImage;
    chkboxGoHome: TCheckBox;
    ImgNewYear: TImage;
    ST_operatorsHideCount: TStaticText;
    menu_Chat: TMenuItem;
    lblNewMessageLocalChat: TLabel;
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
    menu_SMS: TMenuItem;
    ST_HelpStatusInfo: TStaticText;
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
    menu_Outgoing: TMenuItem;
    N3: TMenuItem;
    J1: TMenuItem;
    N4: TMenuItem;
    popMenu_ActionOperators_DelQueue: TMenuItem;
    popMenu_ActionOperators_AddQueue5050: TMenuItem;
    popMenu_ActionOperators_AddQueue5911: TMenuItem;
    popMenu_ActionOperators_AddQueue5000: TMenuItem;
    btnStatus_available: TBitBtn;
    btnStatus_exodus: TBitBtn;
    btnStatus_break: TBitBtn;
    btnStatus_dinner: TBitBtn;
    btnStatus_postvyzov: TBitBtn;
    btnStatus_studies: TBitBtn;
    btnStatus_IT: TBitBtn;
    btnStatus_transfer: TBitBtn;
    ST_SL: TStaticText;
    btnStatus_reserve: TBitBtn;
    btnStatus_callback: TBitBtn;
    btnStatus_home: TBitBtn;
    btnStatus_add_queue5000: TBitBtn;
    btnStatus_add_queue5050: TBitBtn;
    btnStatus_add_queue5911: TBitBtn;
    btnStatus_del_queue_all: TBitBtn;
    menu_clear_status_operator: TMenuItem;
    ST_AR: TStaticText;
    menu_UserSettings: TMenuItem;
    panel_QueueStatistics: TPanel;
    lblStatistics_Queue5000: TLabel;
    lblStatistics_Queue5050: TLabel;
    lblStatistics_Queue5911: TLabel;
    lblStstatisc_Queue5000_Summa: TLabel;
    lblStstatisc_Queue5050_Summa: TLabel;
    lblStstatisc_Queue5911_Summa: TLabel;
    lblStstatisc_Queue5000_Answered: TLabel;
    lblStstatisc_Queue5050_Answered: TLabel;
    lblStstatisc_Queue5911_Answered: TLabel;
    lblStstatisc_Queue5000_No_Answered: TLabel;
    lblStstatisc_Queue5050_No_Answered: TLabel;
    lblStstatisc_Queue5911_No_Answered: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    panel_RegisterPhone: TPanel;
    btnRegPhone: TBitBtn;
    menu_register_phone: TMenuItem;
    chkbox_users_OperatorRegisterAllQueue: TLabel;
    img_users_OperatorRegisterAllQueue: TImage;
    BitBtn1: TBitBtn;
    Panel_Lisa: TPanel;
    lblCount_LISA: TLabel;
    img_UpFont_Lisa: TImage;
    img_DownFont_Lisa: TImage;
    ListViewLisa: TListView;
    STlist_LISA_NO_Rings: TStaticText;
    img_statistics_LISA: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menu_missed_callsClick(Sender: TObject);
    procedure lblCheckInfocilinikaServerAliveClick(Sender: TObject);
    procedure menu_activeSessionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStatus_availableClick(Sender: TObject);
    procedure btnStatus_add_queue5000Click(Sender: TObject);
    procedure btnStatus_add_queue5050Click(Sender: TObject);
    procedure btnStatus_add_queue5911Click(Sender: TObject);
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
    procedure ListViewSIPCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure popMenu_ActionOperators_HistoryCallOperatorClick(Sender: TObject);
    procedure img_UpFont_ActiveSIPClick(Sender: TObject);
    procedure img_DownFont_ActiveSIPClick(Sender: TObject);
    procedure img_UpFont_IVRClick(Sender: TObject);
    procedure img_DownFont_IVRClick(Sender: TObject);
    procedure img_UpFont_QueueClick(Sender: TObject);
    procedure img_DownFont_QueueClick(Sender: TObject);
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
    procedure popMenu_ActionOperators_AddQueue5911Click(Sender: TObject);
    procedure lblCheckSipTrunkAliveMouseLeave(Sender: TObject);
    procedure lblCheckSipTrunkAliveMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblCheckSipTrunkAliveClick(Sender: TObject);
    procedure menu_clear_status_operatorClick(Sender: TObject);
    procedure menu_OutgoingClick(Sender: TObject);
    procedure lblStstatisc_Queue5911_No_AnsweredClick(Sender: TObject);
    procedure lblStstatisc_Queue5911_No_AnsweredMouseLeave(Sender: TObject);
    procedure lblStstatisc_Queue5911_No_AnsweredMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRegPhoneClick(Sender: TObject);
    procedure menu_register_phoneClick(Sender: TObject);
    procedure chkbox_users_OperatorRegisterAllQueueClick(Sender: TObject);
    procedure img_users_OperatorRegisterAllQueueClick(Sender: TObject);
    procedure img_UpFont_LisaClick(Sender: TObject);
    procedure img_DownFont_LisaClick(Sender: TObject);


  private
    { Private declarations }
   m_dispatcherCreateThreadDashboard                :TThreadDispatcher;   // планировщик
   m_dispatcherCreateThreadWaitForRegisterPhone     :TThreadDispatcher;   // планировщик

   m_init:Boolean;    // полностью инициализировали главную форму

   FDragging: Boolean;      // состояние что панель со статусами операторов перемещается
   FMouseOffset: TPoint;
   SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента(для popmenu_ActionOPerators)

   procedure WndProc(var Msg: TMessage); override;   // изменение размер шрифта по сочетанию  Ctrl + колесико

   procedure ViewLabel(IsBold,IsUnderline:Boolean; var p_label:TLabel); // визуальная подсветка при наведении указателя мыши
   function SendCommand(_command:enumLogging;  _delay:enumStatus; _paused:Boolean; var _errorDescriptions:string):boolean; overload;    // отправка удаленной команды
   procedure SendCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; isMultyCommand:Boolean);  overload;
   procedure AddQueuePopMenu(_command:enumLogging;_userSip:Integer); // добавление в очередь из popmenu

   procedure DashboardCreateThread; // создание потоков
   procedure WaitForRegisteredPhone; // ожидание пока будет решистрация в телефоне



  public
    { Public declarations }

  Log:TLoggingFile;

  ///////// ПОТОКИ ////////////
  STATISTICS_thread                 :Thread_Statistics;
  IVR_thread                        :Thread_IVR;
  QUEUE_thread                      :Thread_QUEUE;
  LISA_thread                       :Thread_LISA;
  ACTIVESIP_thread                  :Thread_ACTIVESIP;
  ACTIVESIP_Queue_thread            :Thread_ACTIVESIP_Queue;
  ACTIVESIP_updateTalk_thread       :Thread_ACTIVESIP_updatetalk;
  ACTIVESIP_updateTalkPhone_thread  :Thread_ACTIVESIP_updatePhoneTalk;
  ACTIVESIP_countTalk_thread        :Thread_ACTIVESIP_countTalk;
  CHECKSERVERS_thread               :TThread;     // TODO этот поток уедет потом в core
  CHECKSIPTRUNKS_thread             :Thread_CheckTrunks;
  ANSWEREDQUEUE_thread              :Thread_AnsweredQueue;
  ONLINECHAT_thread                 :TThread;
  FORECAST_thread                   :TThread;
  INTERNALPROCESS_thread            :Thread_InternalProcess;
  ///////// ПОТОКИ ////////////

  property IsInit:Boolean read m_init;  // инициализирована ли главная форма

  end;



  const
  FLASHW_STOP = $00000000; // Остановить мерцание
  FLASHW_CAPTION = $00000001; // Мерцание заголовка окна
  FLASHW_TRAY = $00000002; // Мерцание иконки в трее
  FLASHW_ALL = FLASHW_CAPTION or FLASHW_TRAY; // Мерцание всего
  FLASHW_TIMER = $00000004; // Использовать таймер для мерцания
  FLASHW_TIMERNOFG = $00000008; // Использовать таймер, даже если окно не активно


var
  HomeForm: THomeForm;


  // **************** Thread Update ****************
  UpdateStatistiscSTOP:Boolean;                            // остановка обновления статичтики
  UpdateIVRSTOP:Boolean;                                   // остановка обновления IVR
  UpdateQUEUESTOP:Boolean;                                 // остановка обновления QUEUE
  UpdateLISASTOP:Boolean;                                  // остановка обновления LISA
  UpdateACTIVESIPSTOP:Boolean;                             // остановка обновления ACTIVESIP
  UpdateACTIVESIPQueue:Boolean;                            // остановка обновления ACTIVESIP_Queue
  UpdateACTIVESIPtalkTime:Boolean;                         // остановка обновления ACTIVESIP_updateTalk
  UpdateACTIVESIPtalkTimePhone:Boolean;                    // остановка обновления ACTIVESIP_updateTalkPhone
  UpdateACTIVESIPcountTalk:Boolean;                        // остановка обновления ACTIVESIP_countTalk_thread
  UpdateCHECKSERVERSSTOP:Boolean;                          // остановка обновления CHECKSERVERSSTOP
  UpdateCheckSipTrunksStop:Boolean;                        // остановка обновления CheckSipTrunks
  UpdateAnsweredStop:Boolean;                              // остановка обновления AnsweredQueue
  UpdateOnlineChatStop:Boolean;                            // остановка обновления OnlineChat
  UpdateForecast:Boolean;                                  // остановка обновления Forecast
  // **************** Thread Update ****************



 const
  // Размер панели "Статусы операторов"
  cPanelStatusHeight_default:Word   = 72;
  cPanelStatusHeight_showqueue:Word = 110;

implementation

uses
    FunctionUnit, FormPropushennieUnit, FormAboutUnit, FormServerIKCheckUnit,
    FormAuthUnit, FormActiveSessionUnit, FormRePasswordUnit, FormDEBUGUnit, FormErrorUnit,
    GlobalVariables, FormUsersUnit, FormServersIKUnit, FormSettingsGlobalUnit,
    FormTrunkUnit, TFTPUnit, TForecastCallsUnit, FormStatusInfoUnit,
    FormHistoryCallOperatorUnit, TDebugStructUnit, FormHistoryStatusOperatorUnit,
    GlobalVariablesLinkDLL, TStatusUnit, FormTrunkSipUnit, TLdapUnit, FormHomeInit,
    TPhoneListUnit, FormHomeCloseQuery, FormStatisticsLisaUnit;


{$R *.dfm}

function FlashWindowEx(var pwfi: TFlashWindowInfo): BOOL; stdcall; external user32 name 'FlashWindowEx';

procedure THomeForm.DashboardCreateThread; // создание потоков
var
 error:string;
begin
 if not CreateThreadDashboard(error) then begin
   ShowFormErrorMessage(error,SharedMainLog,'THomeForm.FormShow');
 end;
end;


// ожидание пока будет решистрация в телефоне
procedure THomeForm.WaitForRegisteredPhone;
var
 ip:string;
 sip:Integer;
begin
  sip:=_dll_GetOperatorSIP(SharedCurrentUserLogon.ID);
  if sip = -1 then Exit;

  if GetStatusRegisteredSipPhone(sip,ip) then begin
    ShowStatusOperator(True,False);
    m_dispatcherCreateThreadWaitForRegisterPhone.StopThread;
  end;
end;

procedure OnDevelop;
begin
  MessageBox(HomeForm.Handle,PChar('Данный функционал в разработке!'),PChar('В разработке'),MB_OK+MB_ICONINFORMATION);
end;


procedure THomeForm.SendCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; isMultyCommand:Boolean);
var
 error:string;
 i:Integer;
 command:enumLogging;
begin

  case isMultyCommand of
   False:begin
    if not SendCommand(_command, _delay, _paused, error) then begin
       MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
       Exit;
    end;
   end;
   True:begin  // регистарция в нескольких очередях одновроеменно
    for i:=0 to  SharedCurrentUserLogon.QueueList.Count-1 do begin
      command:=EnumQueueToEnumLogging(SharedCurrentUserLogon.QueueList[i]);
      SendCommand(command, _delay, _paused, False);
    end;
   end;
  end;

end;


procedure THomeForm.btnRegPhoneClick(Sender: TObject);
begin
  OpenRegPhone(eManualRunning);
end;

procedure THomeForm.btnStatus_add_queue5000Click(Sender: TObject);
var
 delay:enumStatus;
 multyCommand:Boolean;
begin
  delay:=eNO;
  multyCommand:=SharedCheckBoxUI.Checked['OperatorRegisterAllQueue'];

 // добавление в очередь 5000
 SendCommand(eLog_add_queue_5000, delay, False, multyCommand);
end;

procedure THomeForm.btnStatus_add_queue5911Click(Sender: TObject);
var
 delay:enumStatus;
 multyCommand:Boolean;
begin
  delay:=eNO;
  multyCommand:=SharedCheckBoxUI.Checked['OperatorRegisterAllQueue'];

 // добавление в очередь 5911
  SendCommand(eLog_add_queue_5911, delay, False, multyCommand);
end;

procedure THomeForm.btnStatus_add_queue5050Click(Sender: TObject);
var
 delay:enumStatus;
 multyCommand:Boolean;
begin
 delay:=eNO;
 multyCommand:=SharedCheckBoxUI.Checked['OperatorRegisterAllQueue'];
 // добавление в очередь 5050
 SendCommand(eLog_add_queue_5050, delay, False, multyCommand);
end;

procedure THomeForm.btnStatus_availableClick(Sender: TObject);
var
 curr_queue:enumQueue;
 queueList:TList<enumQueue>;
 i:Integer;
 paused:Boolean;
 delay:enumStatus;
 multyCommand:Boolean;
begin

   if PanelStatusIN.Height=cPanelStatusHeight_showqueue then begin
    PanelStatusIN.Height:=cPanelStatusHeight_default;
    Exit;
   end;

   Screen.Cursor:=crHourGlass;

   // проверяем в какой очереди находится оператор
   queueList:=GetCurrentQueueOperator(_dll_GetOperatorSIP(SharedCurrentUserLogon.ID));

   // проверим не в pause ли находится оператор
   if queueList.Count > 0 then begin
     paused:=GetCurrentQueuePausedOperator(_dll_GetOperatorSIP(SharedCurrentUserLogon.ID));
     if paused then begin
       // снимаем паузу
        begin
         delay:=eNO;
         multyCommand:=False;
         SendCommand(eLog_available, delay, False, multyCommand);
        end;

       Screen.Cursor:=crDefault;
       Exit;
     end;
   end;

   PanelStatusIN.Height:=cPanelStatusHeight_showqueue;

   if queueList.Count > 0 then begin
     for i:=0 to queueList.Count-1 do begin
        case queueList[i] of
          queue_5000:begin
            btnStatus_add_queue5000.Enabled:=False;
          end;
          queue_5050:begin
            btnStatus_add_queue5050.Enabled:=False;
          end;
          queue_5911:begin
            btnStatus_add_queue5911.Enabled:=False;
          end;
        end;

        btnStatus_del_queue_all.Enabled:=True;
     end;
   end
   else begin
     // значит не в очереди находится
     btnStatus_add_queue5000.Enabled:=True;
     btnStatus_add_queue5050.Enabled:=True;
     btnStatus_add_queue5911.Enabled:=True;
     btnStatus_del_queue_all.Enabled:=False;
   end;

  Screen.Cursor:=crDefault;
end;

procedure THomeForm.btnStatus_breakClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
   // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

  // перерыв
  SendCommand(eLog_break,delay, paused, False);
end;

procedure THomeForm.btnStatus_callbackClick(Sender: TObject);
//var
// error:string;
// delay:Boolean;
begin
  // callback
// if SendCommand(eLog_callback,error) then begin
//   with FormPropushennie do begin
//     SetQueue(queue_5000,eMissed_no_return);
//     SetCallbak;
//
//     ShowModal;
//   end;
// end;
end;

procedure THomeForm.btnStatus_del_queue_allClick(Sender: TObject);
var
 sip:Integer;
 delay:enumStatus;
begin
  // проверим разговариавет ли оператор
  sip:=_dll_GetOperatorSIP(SharedCurrentUserLogon.ID);
  if SharedActiveSipOperators.IsTalkOperator(sip) = eYES then begin
    MessageBox(Handle,PChar('При разговоре выходить из очереди нельзя'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // выход из всех очередей из 5000 и 5050
  delay:=eNO;
  SendCommand(eLog_del_queue_5000_5050, delay, False, False);
end;


procedure THomeForm.btnStatus_dinnerClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
  // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

   // обед
  SendCommand(eLog_dinner, delay, paused, False);
end;

procedure THomeForm.btnStatus_exodusClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
  // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  //delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  delay:=eYES;
  paused:=True;

 // исход
  SendCommand(eLog_exodus, delay, paused, False);
end;


procedure THomeForm.btnStatus_homeClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

 // домой
  SendCommand(eLog_home, delay, paused, False);
end;

procedure THomeForm.btnStatus_ITClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
  // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

  // ИТ
   SendCommand(eLog_IT,delay, paused, False);
end;

procedure THomeForm.btnStatus_postvyzovClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
   // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

 // поствызов
  SendCommand(eLog_postvyzov, delay, paused, False);
end;

procedure THomeForm.btnStatus_reserveClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
   // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

 // переносы
  SendCommand(eLog_reserve,delay, paused, False);
end;

procedure THomeForm.btnStatus_studiesClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
  // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

 // учеба
   SendCommand(eLog_studies,delay, paused, False);
end;

procedure THomeForm.btnStatus_transferClick(Sender: TObject);
var
 delay:enumStatus;
 error:string;
 paused:Boolean;
begin
   // нужно чтобы оператор обязательно находился в очереди
  if not IsOpearorExistAnyQueue(SharedCurrentUserLogon.ID,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  // проверка есть ли сейчас отложенный статус
  if not IsAllowChangeStatusOperators(SharedCurrentUserLogon.ID,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  delay:=SendCommandStatusDelay(SharedCurrentUserLogon.ID);
  paused:=True;

// переносы
 SendCommand(eLog_transfer,delay, paused, False);
end;



procedure THomeForm.chkbox_users_OperatorRegisterAllQueueClick(Sender: TObject);
begin
 SharedCheckBoxUI.ChangeStatusCheckBox('OperatorRegisterAllQueue');
end;

procedure THomeForm.ST_HelpStatusInfoClick(Sender: TObject);
begin
 FormStatusInfo.Show;
end;

procedure THomeForm.ST_HelpStatusInfoMouseLeave(Sender: TObject);
begin
  ST_HelpStatusInfo.Font.Style:=[];
end;

procedure THomeForm.ST_HelpStatusInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ST_HelpStatusInfo.Font.Style:=[fsUnderline];
end;

procedure THomeForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FormHomeCloseQuery._CLOSEQUERY(Sender,CanClose);
end;

procedure THomeForm.FormCreate(Sender: TObject);
var
 FolderDll:string;
begin
  FolderDll:= FOLDERPATH + 'dll';

  // Проверка на существование папки
  if DirectoryExists(FolderDll) then begin
    // путь к папке с DLL
    SetDllDirectory(PChar(FolderDll));
  end
  else begin
    MessageBox(Handle,PChar('Не найдена папка с dll библиотеками'+#13#13+FolderDll),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    KillProcess; // Завершаем выполнение процедуры, чтобы не продолжать дальше
  end;

  // размер панели "Статусы операторов" по default
  PanelStatusIN.Height:=cPanelStatusHeight_default;
  FDragging:=False;
end;


procedure THomeForm.FormResize(Sender: TObject);
var
 XML:TXML;
begin
 // изсеняем размер формы
 // активные операторы
  clearList_SIP(Width - DEFAULT_SIZE_PANEL_ACTIVESIP, SharedFontSize.GetSize(eActiveSip));

  if Assigned(SharedCurrentUserLogon) then begin
    if SharedCurrentUserLogon.IsOperator then begin
      // подгонем размер статусов оператора
      XML:=TXML.Create;
      if not XML.IsExistStatusOperatorPosition then begin
        ResizeCentrePanelStatusOperators(Width - DEFAULT_SIZE_PANEL_ACTIVESIP);
      end;
      XML.Free;
    end;
  end;

  // сохраняем размер главной формы
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
 error:string;
begin
 try
  FormHomeInit._CHECK;
  Screen.Cursor:=crHourGlass;

   // текущий залогиненый пользователь
  SharedCurrentUserLogon:=TUser.Create;


 ////////////////////////////////////
  // авторизация
  FormAuth.ShowModal;

  // нужно ли сменить пароль (если локальной вход)
  if SharedCurrentUserLogon.Auth = eAuthLocal then begin
    if SharedCurrentUserLogon.RePassword = eYES  then begin
      Screen.Cursor:=crDefault;
      FormRePassword.ShowModal;
    end;
  end;
  ////////////////////////////////

  Screen.Cursor:=crHourGlass;

  FormHomeInit._INIT;

  m_init:=True;  // иницилизировали главную форму
  Screen.Cursor:=crDefault;

   // создаем все потоки (ВСЕГДА ДОЛЖНЫ ПОСЛЕДНИМИ ИНИЦИАЛИЗИРОВАТЬСЯ!!)
   begin
     if not Assigned(m_dispatcherCreateThreadDashboard) then begin
      m_dispatcherCreateThreadDashboard:=TThreadDispatcher.Create('CreateThreadDashboard',3,True,DashboardCreateThread);
     end;
     m_dispatcherCreateThreadDashboard.StartThread;


     if SharedCurrentUserLogon.IsOperator then begin
       // регистрация в обычном телефоне
       if not SharedCurrentUserLogon.IsZoiperSip then begin
         if not Assigned(m_dispatcherCreateThreadWaitForRegisterPhone) then begin
          m_dispatcherCreateThreadWaitForRegisterPhone:=TThreadDispatcher.Create('WaitForRegisteredPhone',1,False,WaitForRegisteredPhone);
         end;
         m_dispatcherCreateThreadWaitForRegisterPhone.StartThread;
       end
       else begin
         ShowStatusOperator(True,False);
       end;
     end;
   end;


  except
  on E: Exception do begin
    m_init:=False; // не иницилизировали главную форму

    error:='Этой надписи никогда не должно было быть!'+#13+
           'Критическая ошибка!'+#13+
           'Код ошибки: '+E.ClassName+#13+E.Message;
    ShowFormErrorMessage(error, SharedMainLog, 'THomeForm.FormShow');
  end;
 end;
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
    FDragging := True;
    // X,Y – локальные координаты курсора внутри панели
    FMouseOffset := Point(X, Y);
  end;
end;

procedure THomeForm.PanelStatusINMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  ptParent: TPoint;
  XML: TXML;
begin
  if not FDragging then Exit;

  // конвертируем экранные координаты в координаты родителя (обычно форма)
  ptParent := PanelStatus.Parent.ScreenToClient(Mouse.CursorPos);

  // двигаем панель так, чтобы курсор FMouseOffset оставался на том же месте
  PanelStatus.Left := ptParent.X - FMouseOffset.X;
  PanelStatus.Top  := ptParent.Y - FMouseOffset.Y;

  XML := TXML.Create;
  try
    XML.SetStatusOperatorPosition(PanelStatus.Left, PanelStatus.Top);
  finally
    XML.Free;
  end;
end;

procedure THomeForm.PanelStatusINMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging:= False;
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5000Click(Sender: TObject);
var
 id_sip:Integer;
 //user_id:Integer;
 id:Integer;
begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // в очереди ли находится оператор
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.QueueListExist[id, queue_5000] then begin
    MessageBox(Handle,PChar('Оператор и так в этой очереди'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  //user_id:=getUserID(id_sip);

  AddQueuePopMenu(eLog_add_queue_5000, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5911Click(
  Sender: TObject);
var
 id_sip:Integer;
 //user_id:Integer;
 id:Integer;
begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // в очереди ли находится оператор
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.QueueListExist[id, queue_5911] then begin
    MessageBox(Handle,PChar('Оператор и так в этой очереди'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;


  AddQueuePopMenu(eLog_add_queue_5911, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_AddQueue5050Click(Sender: TObject);
var
 id_sip:Integer;
 //user_id:Integer;
 id:Integer;
begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // в очереди ли находится оператор
  id:=SharedActiveSipOperators.GetListOperators_ID(id_sip);

  if SharedActiveSipOperators.QueueListExist[id, queue_5050] then begin
    MessageBox(Handle,PChar('Оператор и так в этой очереди'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  //user_id:=getUserID(id_sip);

  AddQueuePopMenu(eLog_add_queue_5050, id_sip);
end;

procedure THomeForm.popMenu_ActionOperators_DelQueueClick(Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
 resultat:Word;

begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  id_sip:=StrToInt(SelectedItemPopMenu.Caption);

  // в очереди ли находится оператор
  if not SharedActiveSipOperators.isExistOperatorInQueue(id_sip) then begin
    MessageBox(Handle,PChar('Оператор не в очереди'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  // найдем id и передадим его дальше
  user_id:=GetUserID(id_sip);

  resultat:=MessageBox(0,PChar('Точно удалить из очереди?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrNo then begin
    Exit;
  end;

  // выход из всех очередей
  ForceExitOperatorAllQueue(user_id);
end;

procedure THomeForm.popMenu_ActionOperators_HistoryCallOperatorClick(
  Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
begin
  // Проверяем, был ли выбран элемент
  if Assigned(SelectedItemPopMenu) then
  begin
    id_sip:=StrToInt(SelectedItemPopMenu.Caption);

    // найдем id и передадим его дальше
    user_id:=GetUserID(id_sip);
    FormHistoryCallOperator.SetID(user_id);
    FormHistoryCallOperator.SetSip(id_sip);

    FormHistoryCallOperator.ShowModal;
  end
  else
  begin
   MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;

procedure THomeForm.popMenu_ActionOperators_HistoryStatusOPeratorsClick(
  Sender: TObject);
var
 id_sip:Integer;
 user_id:Integer;
begin
  // Проверяем, был ли выбран элемент
  if Assigned(SelectedItemPopMenu) then
  begin
    id_sip:=StrToInt(SelectedItemPopMenu.Caption);

    // найдем id и передадим его дальше
    user_id:=GetUserID(id_sip);
    FormHistoryStatusOperator.SetID(user_id);
    FormHistoryStatusOperator.SetSip(id_sip);

    FormHistoryStatusOperator.ShowModal;
  end
  else
  begin
   MessageBox(Handle,PChar('Не выбран оператор'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
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

procedure THomeForm.img_DownFont_LisaClick(Sender: TObject);
begin
 ChangeFontSize(eFontDonw,eLisa);
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
var
 mouse_coordinate:TPoint;
begin
  GetCursorPos(mouse_coordinate);
  FormStatisticsLisa.Left:=mouse_coordinate.x;
  FormStatisticsLisa.Top:=mouse_coordinate.Y;
  FormStatisticsLisa.Show;
end;


procedure THomeForm.img_statistics_list_QUEUEClick(Sender: TObject);
begin
 OnDevelop;
end;

procedure THomeForm.img_statistics_QUEUEClick(Sender: TObject);
begin
 // FormStatisticsChart.Show;
end;

procedure THomeForm.img_UpFont_ActiveSIPClick(Sender: TObject);
begin
 ChangeFontSize(eFontUP,eActiveSip);
end;

procedure THomeForm.img_UpFont_IVRClick(Sender: TObject);
begin
 ChangeFontSize(eFontUP,eIvr);
end;

procedure THomeForm.img_UpFont_LisaClick(Sender: TObject);
begin
 ChangeFontSize(eFontUP,eLisa);
end;

procedure THomeForm.img_UpFont_QueueClick(Sender: TObject);
begin
  ChangeFontSize(eFontUP,eQueue);
end;

procedure THomeForm.img_users_OperatorRegisterAllQueueClick(Sender: TObject);
begin
 SharedCheckBoxUI.ChangeStatusCheckBox('OperatorRegisterAllQueue');
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

procedure THomeForm.lblCheckSipTrunkAliveClick(Sender: TObject);
begin
 FormTrunkSip.Show;
end;

procedure THomeForm.lblCheckSipTrunkAliveMouseLeave(Sender: TObject);
begin
  lblCheckSipTrunkAlive.Font.Style:=[];
end;

procedure THomeForm.lblCheckSipTrunkAliveMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 lblCheckSipTrunkAlive.Font.Style:=[fsUnderline];
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


procedure THomeForm.lblStstatisc_Queue5000_No_AnsweredClick(Sender: TObject);
var
 error:string;
begin
 // есть ли доступ к пропущенным
  if not OpenMissedCalls(error, queue_5000, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('Отсутствует доступ'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // берем по всем 5000
   SetManualShow(true);
   ShowModal;
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
 // есть ли доступ к пропущенным
  if not OpenMissedCalls(error, queue_5050, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('Отсутствует доступ'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // берем по всем 5050
   SetManualShow(true);
   ShowModal;
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

procedure THomeForm.lblStstatisc_Queue5911_No_AnsweredClick(Sender: TObject);
var
 error:string;
begin
 // есть ли доступ к пропущенным
  if not OpenMissedCalls(error, queue_5911, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('Отсутствует доступ'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // берем по всем
   SetManualShow(true);
   ShowModal;
  end;
end;

procedure THomeForm.lblStstatisc_Queue5911_No_AnsweredMouseLeave(
  Sender: TObject);
begin
  ViewLabel(False,False, lblStstatisc_Queue5911_No_Answered);
end;

procedure THomeForm.lblStstatisc_Queue5911_No_AnsweredMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ViewLabel(False,True, lblStstatisc_Queue5911_No_Answered);
end;

procedure THomeForm.ListViewSIPCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 time_talk:Integer;
 err:Boolean;
 longtalk:string;
begin
  if not Assigned(Item) then Exit;
  err:=False;

  try
    if Item.SubItems.Count = 8 then // Проверяем, что есть достаточно SubItems
    begin

      try
        if Item.SubItems.Strings[1] = 'доступен' then
        begin
          Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
          Exit;
        end;
      except
          on E:Exception do
          begin
           SharedMainLog.Save('THomeForm.ListViewSIPCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
           err:=True;
          end;
      end;

      if err then Exit;

      if (AnsiPos('OnHold',Item.SubItems.Strings[1]) <> 0) then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_OnHold);
        Exit;
      end;

      if Item.SubItems.Strings[5] <> '---' then begin
       // test:=Item.SubItems.Strings[5];

        try
          time_talk:=GetTimeAnsweredToSeconds(Item.SubItems.Strings[5],True);
        except
          on E:Exception do
          begin
           SharedMainLog.Save('THomeForm.ListViewSIPCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
           time_talk:=-1;
          end;
        end;

        if time_talk = -1 then Exit;

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
      else if AnsiPos('поствызов',Item.SubItems.Strings[1])<> 0 then begin
        longtalk:=Item.SubItems.Strings[1];
        System.Delete(longtalk, 1, AnsiPos('(',longtalk));
        System.Delete(longtalk, AnsiPos(')',longtalk),Length(longtalk));

        time_talk:=GetTimeAnsweredToSeconds(longtalk, True);

        if time_talk >= 180 then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
         Exit;
        end;
      end;

      if (AnsiPos('обед',Item.SubItems.Strings[1]) <> 0) or
         (AnsiPos('перерыв',Item.SubItems.Strings[1]) <> 0) then
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
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    // Получаем элемент, на который кликнули
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

procedure THomeForm.menu_clear_status_operatorClick(Sender: TObject);
var
 resultat:word;
begin
  resultat:=MessageBox(0,PChar('Сброс панели приведет к закрытию программы, сбрасываем?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrNo then begin
    Exit;
  end;

  // сброс панели статусов на дефолтное значение
  ResetPanelStatusOperator;

  KillProcess;
end;


procedure THomeForm.menu_missed_callsClick(Sender: TObject);
var
 error:string;
begin
  // есть ли доступ к пропущенным
  if not OpenMissedCalls(error, queue_5000, eMissed_no_return) then begin
    MessageBox(HomeForm.Handle,PChar(error),PChar('Отсутствует доступ'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  with FormPropushennie do begin
    // берем по 5000
   SetManualShow(true);
   ShowModal;
  end;
end;

procedure THomeForm.menu_OutgoingClick(Sender: TObject);
begin
  OpenOutgoing;
end;

procedure THomeForm.menu_register_phoneClick(Sender: TObject);
begin
  OpenRegPhone(eManualWithOutParam);
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


procedure THomeForm.menu_GlobalSettingsClick(Sender: TObject);
begin
 FormSettingsGlobal.ShowModal;
end;

procedure THomeForm.menu_ReportsClick(Sender: TObject);
begin
  OpenReports;
end;


// изменение размер шрифта по сочетанию  Ctrl + колесико
procedure THomeForm.WndProc(var Msg: TMessage);
var
  Shift: TShiftState;
  WheelDelta: Integer;
begin
  inherited WndProc(Msg);

  if Msg.Msg = WM_MOUSEWHEEL then
  begin
    // Получаем значение прокрутки
    WheelDelta := Smallint(HIWORD(Msg.WParam));

    // Определяем, находится ли курсор над ListView
    if PtInRect(ListViewSIP.ClientRect, ListViewSIP.ScreenToClient(Mouse.CursorPos)) then
    begin
      // Получаем состояние клавиш
      Shift := KeyDataToShiftState(Msg.WParam);

      if (Shift * [ssCtrl] <> []) then
      begin
        if WheelDelta > 0 then
        begin
          // Ctrl + колесико вверх
           ChangeFontSize(eFontUP,eActiveSip);
        end
        else
        begin
          // Ctrl + колесико вниз
          ChangeFontSize(eFontDonw,eActiveSip);
        end;
        Msg.Result := 1; // Отметить, что событие обработано
      end
      else Msg.Result := 1; // Отметить, что событие обработано
    end;
  end;
end;


// визуальная подсветка при наведении указателя мыши
procedure THomeForm.ViewLabel(IsBold,IsUnderline:Boolean; var p_label:TLabel);
begin
  if not (IsBold) and not (IsUnderline) then p_label.Font.Style:=[];
  if (IsBold) and (IsUnderline) then p_label.Font.Style:=[fsBold,fsUnderline];

  if not (IsBold) and (IsUnderline) then p_label.Font.Style:=[fsUnderline];
  if (IsBold) and not (IsUnderline) then p_label.Font.Style:=[fsBold];
end;

 // отправка удаленной команды
function THomeForm.SendCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; var _errorDescriptions:string):boolean;
begin
  Result:=SharedStatus.SendCommand(_command,_delay, _paused, _errorDescriptions);
end;


// добавление в очередь из popmenu
procedure THomeForm.AddQueuePopMenu(_command:enumLogging;_userSip:Integer);
var
 user_id:Integer;
 status:TStatus;
 error:string;
 delay:enumStatus;
begin
  // найдем id
  user_id:=GetUserID(_userSip);

  status:=TStatus.Create(user_id,SharedCurrentUserLogon.GetUserData, True);
  delay:=eNO;


  if not status.SendCommand(_command, delay, False, error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  // очистка статуса
  UpdateOperatorStatus(eAvailable,user_id);
  LoggingRemote(eLog_available,user_id);
end;




end.
