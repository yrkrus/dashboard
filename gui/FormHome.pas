unit FormHome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus,Data.Win.ADODB, Data.DB, Vcl.Imaging.jpeg,System.SyncObjs,
  TActiveSIPUnit,TUserUnit, Vcl.Imaging.pngimage, ShellAPI, TLogFileUnit,
  System.Zip, Vcl.WinXCtrls;


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
    Button1: TButton;
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
    PanelWaitingQueue: TPanel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblStatistics_Answered30: TLabel;
    lblStatistics_Answered60: TLabel;
    lblStatistics_Answered120: TLabel;
    lblStatistics_Answered121: TLabel;
    Panel_SIP: TPanel;
    ListViewSIP: TListView;
    img_statistics_IVR: TImage;
    lblCount_ACTIVESIP: TLabel;
    ST_SL: TStaticText;
    STlist_ACTIVESIP_NO_Rings: TStaticText;
    popMenu_ActionOperators: TPopupMenu;
    B1: TMenuItem;
    N3: TMenuItem;
    B2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
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
    ST_StatusPanelWindow: TStaticText;
    img_goHome_YES: TImage;
    img_goHome_NO: TImage;
    chkboxGoHome: TCheckBox;
    ImgNewYear: TImage;
    ST_operatorsHideCount: TStaticText;
    Button3: TButton;
    menu_Chat: TMenuItem;
    lblNewMessageLocalChat: TLabel;
    lblNewVersionDashboard: TLabel;
    procedure Button1Click(Sender: TObject);
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
    procedure listSG_ACTIVESIPDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
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




  private
    { Private declarations }
  public
    { Public declarations }

  Log:TLoggingFile;

  ///////// ������ ////////////
  Statistics_thread:TThread;
  IVR_thread:TThread;
  QUEUE_thread:TThread;
  ACTIVESIP_thread:TThread;
  ACTIVESIP_Queue_thread:TThread;
  ACTIVESIP_updateTalk_thread:TThread;
  ACTIVESIP_updateTalkPhone_thread:TThread;
  ACTIVESIP_countTalk_thread:TThread;
  CHECKSERVERS_thread:TThread;
  ANSWEREDQUEUE_thread:TThread;
  ONLINECHAT_thread:TThread;

  end;

    {
    FTP ��� ������� ����������!!!



    ��� � ����� ����� zip ����������� � ��������

    }

   ///   asterisk -rx "queue add member Local/�����_��������@from-queue/n to �����_������� penalty 0 as �����_��������� state_interface hint:�����_���������@ext-local"
  ///    asterisk -rx "queue remove member Local/�����_��������@from-queue/n from �����_�������"

{
��� ������������� � ���������

  �����������\�������������� � sip �������� ����� �������
  ����� ����������� �������

  !! ����� ��� ���������� ������� ��� ��������, + ������ � �� ����� ������ ����
  ����� ������ �������� ����������... "������" - �.�. ������ �� ������ ����� ��������� ������ �� �������.. ����� ����� ����� ��������� � �������� �� � ������� ����� ������� ��������� �� � ���


  ������������� ���� �������
  �������� �� �������, ���� ������ ����� �� ���
  ������� ����� ��� ��������� �������� ���� �������� ��� � �������� ���������� ��� �� ��������
  ������ (��. ���� ����� ����� �����)
     - ����� � ��� �� ����� ������� (�� ����� �� ��� ��� )



  �� ���������� � ������ ������ �� IVR ������� ����������

    (�� ������) ��� �������� ����� �� ���������� ���� ��������� ����� �� ����������
   (�� ������)      onhold �� ����������� ���� � ����������





  ����������
function disableUser(InUserID:Integer):string;
function enableUser(InUserID:Integer):string;
function updateUserPassword(InUserID,InUserNewPassword:Integer):string;
function getActiveSessionUser(InUserID:Integer):Integer;
function remoteCommand_Responce(InStroka:string):string;
function TFormServerIKEdit.getResponseBD(InTypePanel_Server:TypeResponse_Server;InIP,InAddr,InAlias:string):string;
function getCheckFileds:string;
function getResponseBD(InQueue5000,InQueue5050:string; InEditTime:Boolean = False):string;
function getDeleteList(InID:string):string;
function TFormTrunkEdit.getResponseBD(InTypePanel_Server:TypeResponse_Server;InAlias,InLogin:string; InStatus:enumMonitoringTrunk):string;

function getCheckFileds:string;



}





var
  HomeForm: THomeForm;


  // thread
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

 const
  // ������ ������ "������� ����������"
  cPanelStatusHeight_default:Word   = 72;
  cPanelStatusHeight_showqueue:Word = 110;

implementation

uses
DMUnit, FunctionUnit, FormPropushennieUnit, FormSettingsUnit, Thread_StatisticsUnit,
  Thread_IVRUnit, Thread_QUEUEUnit, FormAboutUnit, FormOperatorStatusUnit, FormServerIKCheckUnit,
  FormAuthUnit, FormActiveSessionUnit, FormRePasswordUnit, Thread_AnsweredQueueUnit,
  ReportsUnit, Thread_ACTIVESIP_updatetalkUnit, FormDEBUGUnit, FormErrorUnit, TCustomTypeUnit,
  GlobalVariables, FormUsersUnit, FormServersIKUnit, FormSettingsGlobalUnit,
  FormTrunkUnit, TFTPUnit, TXmlUnit, FormStatisticsChartUnit;


{$R *.dfm}

procedure OnDevelop;
begin
  MessageBox(HomeForm.Handle,PChar('������ ���������� � ����������!'+#13#13+'����� � 2025�'),PChar('� ����������'),MB_OK+MB_ICONINFORMATION);
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

procedure THomeForm.Button1Click(Sender: TObject);
begin
  Timer_Thread_Start.Enabled:=True;
end;



// ������������ zip �����
procedure UnPack(InFileName:string; var p_Log:TLoggingFile; var p_listUpdate:TStringList);
var
 ZipFile:TZipFile;
 i:Integer;
 FileName:string;
 folderDest:string;
begin
   p_Log.Save('���������� ������ <b>'+InFileName+'</b>');
   folderDest:=FOLDERPATH+GetUpdateNameFolder;

   try
     ZipFile:=TZipFile.Create;
     ZipFile.Open(folderDest+'\'+InFileName, zmRead);

     try
        // ���������� ��� ����� � ������
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // �������� ��� �����
          // ��������� ����
          ZipFile.Extract(I, PChar(folderDest));
          // ����������� ����������
          p_Log.Save('�������� ����: <b>'+FileName+'</b>');
          p_listUpdate.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         p_Log.Save('�� ������� ������� ����: <b>'+FileName+'</b> | '+e.Message,IS_ERROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(folderDest+'\'+InFileName);
   end;
end;


// �������� �����������
procedure CreateCMD(var p_XML:TXML; var p_listUpdate:TStringList);
var
  Bat:TStringList;
  i:Integer;
begin
  Bat:=TStringList.Create;
   with Bat do begin
     Add('@echo off');
     Add('set DirectoryUpdate='+FOLDERPATH+GetUpdateNameFolder+'\');
     Add('set Directory='+FOLDERPATH);
     Add('::');
     Add('echo                      AutoUpdate Dashboard ');
     Add('echo                  upgrade '+p_XML.GetCurrentVersion+' to '+p_XML.GetRemoteVersion);
     Add('echo                    started after 10 sec ...');
     Add('echo.');
     Add('ping -n 10 localhost>Nul');
     Add('::');

      // ��������� exe
     Add('taskkill /F /IM '+DASHBOARD_EXE);
     Add('taskkill /F /IM '+CHAT_EXE);
     Add('::');

     // ��������� ����������
     Add('net stop '+UPDATE_SERVICES);


      // �������� ����� �����
      for i:=0 to p_listUpdate.Count-1 do begin
       Add('echo F | xcopy "%DirectoryUpdate%\'+p_listUpdate[i]+'"'+' "%Directory%'+p_listUpdate[i]+'" /Y /C');
      end;
      Add('::');

    // ��������� ����������
    Add('net start '+UPDATE_SERVICES);
    Add('exit')
   end;
   Bat.SaveToFile(FOLDERPATH+'update.bat');
end;


procedure THomeForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  DialogResult: Integer;
begin
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
      if getStatusIndividualSettingsUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit) = settingUsersStatus_DISABLED then begin

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
              saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit,settingUsersStatus_ENABLED);
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
begin
 try
  Height:=861;

  // ����������� ������� ������  ctrl+shift+G (GUID) - �� ����� ID ������� ������������ ���
  Caption:=Caption+' '+getVersion(GUID_VESRION,eGUI) + ' | '+'('+GUID_VESRION+')';

  // �������� �� ������ ������
  CheckCurrentVersion;

  // ������� �� ��������� ������ ����� ��������������
  ClearAfterUpdate;

   // �������� �� 2�� ����� ��������
  if GetCloneRun(PChar(DASHBOARD_EXE)) then begin
    MessageBox(HomeForm.Handle,PChar('��������� ������ 2�� ����� ��������'+#13#13+
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
   createCurrentActiveSession(SharedCurrentUserLogon.GetID);


  // �������� ������ �������� ��� �������� �����������
  createCheckServersInfoclinika;


  // ��������� �������������� �������� ������������
  LoadIndividualSettingUser(SharedCurrentUserLogon.GetID);


  // ����������� ���� �������
  accessRights(SharedCurrentUserLogon);

  // ��������
   HappyNewYear;

  Screen.Cursor:=crDefault;
  Button1.Click;
  except
  on E: Exception do begin
    MessageBox(Handle,PChar('���� ������� ������� �� ������ ���� ����!'+#13+
                            '���� �� �� ������ �������� ������'+#13#13+
                            '��� ������: '+E.ClassName+#13+E.Message),PChar('����������� ������'),MB_OK+MB_ICONERROR);
    KillProcess;
  end;
 end;

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
  MessageBox(Handle,PChar('������� ����������� �������������'+#13#13+'�������� ���� �������� � ��������� ����� 30 ���'),PChar('����������'),MB_OK+MB_ICONINFORMATION);
end;

procedure THomeForm.listSG_ACTIVESIPDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  { if AnsiPos('��������',listSG_ACTIVESIP.Cells[ACol, ARow])<>0 then begin
      listSG_ACTIVESIP.Canvas.Font.Color := clGreen;


      listSG_ACTIVESIP.Canvas.FillRect(Rect); // ������������ ������ ��������� ������
      //listSG_ACTIVESIP.Canvas.Font.Color := clBlack; // ���������� ����� ������
      listSG_ACTIVESIP.Canvas.TextOut(Rect.Left, Rect.Top, listSG_ACTIVESIP.Cells[ACol, ARow]);
   end; }
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
