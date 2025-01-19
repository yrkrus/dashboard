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

  ///////// ПОТОКИ ////////////
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
    FTP для будущих обновлений!!!



    там в корне будут zip создаваться с версиями

    }

   ///   asterisk -rx "queue add member Local/НОМЕР_ОПЕРАОРА@from-queue/n to НОМЕР_ОЧЕРЕДИ penalty 0 as НОМЕР_ОПЕРАТОРА state_interface hint:НОМЕР_ОПЕРАТОРА@ext-local"
  ///    asterisk -rx "queue remove member Local/НОМЕР_ОПЕРАОРА@from-queue/n from НОМЕР_ОЧЕРЕДИ"

{
что запланировано в доработку

  регистрация\разрегистрация в sip телефоне через дашборд
  отчет позвонившие впервые

  !! НУЖЕН для операторов которые без дашборда, + писать в БД когда звонок идет
  новый статус придумал отображать... "звонок" - т.е. сейчас на данный номер поступает звонок из очереди.. потом можно будет проверить в холостую ли в очереди сидят которые находятся не в цов


  разграничение прав доступа
  удаление из очереди, если забыли выйти из нее
  сделать чтобы при уделенном закрытии если оператор был в очнереди выкидывать его из очнереди
  отчеты (хз. пока какие нужны будут)
     - вчера в это же время звонков (хз нужно ли или нет )



  не отображать в списке номера из IVR которые сбросились

    (не готово) при активной галке не опказывать омой операторы новые не появляются
   (не готово)      onhold не фиксируется если у помогатора





  переписать
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
  UpdateStatistiscSTOP:Boolean;                            // остановка обновления статичтики
  UpdateIVRSTOP:Boolean;                                   // остановка обновления IVR
  UpdateQUEUESTOP:Boolean;                                 // остановка обновления QUEUE
  UpdateACTIVESIPSTOP:Boolean;                             // остановка обновления ACTIVESIP
  UpdateACTIVESIPQueue:Boolean;                            // остановка обновления ACTIVESIP_Queue
  UpdateACTIVESIPtalkTime:Boolean;                         // остановка обновления ACTIVESIP_updateTalk
  UpdateACTIVESIPtalkTimePhone:Boolean;                    // остановка обновления ACTIVESIP_updateTalkPhone
  UpdateACTIVESIPcountTalk:Boolean;                        // остановка обновления ACTIVESIP_countTalk_thread
  UpdateCHECKSERVERSSTOP:Boolean;                          // остановка обновления CHECKSERVERSSTOP
  UpdateAnsweredStop:Boolean;                              // остановка обновления AnsweredQueue
  UpdateOnlineChatStop:Boolean;                            // остановка обновления OnlineChat

 const
  // Размер панели "Статусы операторов"
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
  MessageBox(HomeForm.Handle,PChar('Данный функционал в разработке!'+#13#13+'Релиз в 2025г'),PChar('В разработке'),MB_OK+MB_ICONINFORMATION);
end;



procedure THomeForm.btnStatus_add_queue5000Click(Sender: TObject);
begin
 // добавление в очередь 5000
 if not isExistRemoteCommand(eLog_add_queue_5000) then remoteCommand_addQueue(eLog_add_queue_5000)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_add_queue5000_5050Click(Sender: TObject);
begin
 // добавление в очередь 5000 и 5050
 if not isExistRemoteCommand(eLog_add_queue_5000_5050) then remoteCommand_addQueue(eLog_add_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_add_queue5050Click(Sender: TObject);
begin
 // добавление в очередь 5050
 if not isExistRemoteCommand(eLog_add_queue_5050) then remoteCommand_addQueue(eLog_add_queue_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
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

    // проверяем в какой очереди находится оператор
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
 // перерыв
 if not isExistRemoteCommand(eLog_break) then remoteCommand_addQueue(eLog_break)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_del_queue_allClick(Sender: TObject);
begin
  // выход из всех очередей из 5000 и 5050
 if not isExistRemoteCommand(eLog_del_queue_5000_5050) then remoteCommand_addQueue(eLog_del_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_dinnerClick(Sender: TObject);
begin
   // обед
 if not isExistRemoteCommand(eLog_dinner) then remoteCommand_addQueue(eLog_dinner)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_exodusClick(Sender: TObject);
begin
 // исход
 if not isExistRemoteCommand(eLog_exodus) then remoteCommand_addQueue(eLog_exodus)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_homeClick(Sender: TObject);
begin
 // домой
 if not isExistRemoteCommand(eLog_home) then remoteCommand_addQueue(eLog_home)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_ITClick(Sender: TObject);
begin
  // ИТ
 if not isExistRemoteCommand(eLog_IT) then remoteCommand_addQueue(eLog_IT)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_postvyzovClick(Sender: TObject);
begin
 // поствызов
 if not isExistRemoteCommand(eLog_postvyzov) then remoteCommand_addQueue(eLog_postvyzov)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_reserveClick(Sender: TObject);
begin
 // переносы
 if not isExistRemoteCommand(eLog_reserve) then remoteCommand_addQueue(eLog_reserve)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_studiesClick(Sender: TObject);
begin
 // учеба
 if not isExistRemoteCommand(eLog_studies) then remoteCommand_addQueue(eLog_studies)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.btnStatus_transferClick(Sender: TObject);
begin
// переносы
 if not isExistRemoteCommand(eLog_transfer) then remoteCommand_addQueue(eLog_transfer)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure THomeForm.Button1Click(Sender: TObject);
begin
  Timer_Thread_Start.Enabled:=True;
end;



// распаковывем zip архив
procedure UnPack(InFileName:string; var p_Log:TLoggingFile; var p_listUpdate:TStringList);
var
 ZipFile:TZipFile;
 i:Integer;
 FileName:string;
 folderDest:string;
begin
   p_Log.Save('Распаковка архива <b>'+InFileName+'</b>');
   folderDest:=FOLDERPATH+GetUpdateNameFolder;

   try
     ZipFile:=TZipFile.Create;
     ZipFile.Open(folderDest+'\'+InFileName, zmRead);

     try
        // Перебираем все файлы в архиве
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // Получаем имя файла
          // Извлекаем файл
          ZipFile.Extract(I, PChar(folderDest));
          // Отслеживаем извлечение
          p_Log.Save('Извлечен файл: <b>'+FileName+'</b>');
          p_listUpdate.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         p_Log.Save('Не удалось извлечь файл: <b>'+FileName+'</b> | '+e.Message,IS_ERROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(folderDest+'\'+InFileName);
   end;
end;


// создание установщика
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

      // закрываем exe
     Add('taskkill /F /IM '+DASHBOARD_EXE);
     Add('taskkill /F /IM '+CHAT_EXE);
     Add('::');

     // закрываем обновлялку
     Add('net stop '+UPDATE_SERVICES);


      // копируем новые файлы
      for i:=0 to p_listUpdate.Count-1 do begin
       Add('echo F | xcopy "%DirectoryUpdate%\'+p_listUpdate[i]+'"'+' "%Directory%'+p_listUpdate[i]+'" /Y /C');
      end;
      Add('::');

    // запускаем обновлялку
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
  // проверка вдруг роль оператора и он не вышел из линии
  if getIsExitOperatorCurrentQueue(SharedCurrentUserLogon.GetRole, SharedCurrentUserLogon.GetID) then begin
    CanClose:= Application.MessageBox(PChar(getUserNameBD(SharedCurrentUserLogon.GetID) + ', Вы забыли выйти из очереди'), 'Ошибка при выходе', MB_OK + MB_ICONERROR) = IDNO;
  end
  else begin
    // проверяем правильно ли оператор вышел через команду
    if getIsExitOperatorCurrentGoHome(SharedCurrentUserLogon.GetRole, SharedCurrentUserLogon.GetID) then begin
      CanClose:= Application.MessageBox(PChar('Прежде чем закрыть, необходимо выбрать статус "Домой"'), 'Ошибка при выходе', MB_OK + MB_ICONERROR) = IDNO;
    end
    else begin
      if getStatusIndividualSettingsUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit) = settingUsersStatus_DISABLED then begin

        AMsgDialog := CreateMessageDialog('Вы действительно хотите завершить работу?', mtConfirmation, [mbYes, mbNo]);
        ACheckBox := TCheckBox.Create(AMsgDialog);

        with AMsgDialog do
        try
          Caption:= 'Уточнение выхода';
          Height:= 150;
          (FindComponent('Yes') as TButton).Caption := 'Да';
          (FindComponent('No')  as TButton).Caption := 'Нет';

          with ACheckBox do begin
            Parent:= AMsgDialog;
            Caption:= 'Не показывать больше это сообщение';
            Top:= 100;
            Left:= 8;
            Width:= AMsgDialog.Width;
          end;

          DialogResult:= ShowModal; // Сохраняем результат в переменной

          if DialogResult = ID_YES then
          begin
            if ACheckBox.Checked then begin
              // созраняем параметр чтобы больше не показывать это окно
              saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_noConfirmExit,settingUsersStatus_ENABLED);
            end;

            KillProcess;
          end
          else if DialogResult = ID_NO then
          begin
            Abort; // Отмена выхода
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

  // Проверка на существование папки
  if DirectoryExists(FolderDll) then begin
    // путь к папке с DLL
    SetDllDirectory(PChar(FolderDll));
  end
  else begin
    MessageBox(Handle,PChar('Не найдена папка с dll библиотеками'+#13#13+FolderDll),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    KillProcess; // Завершаем выполнение процедуры, чтобы не продолжать дальше
  end;
  // очищаем все лист боксы
  clearAllLists;

  // размер панели "Статусы операторов" по default
  PanelStatusIN.Height:=cPanelStatusHeight_default;
end;


procedure THomeForm.FormResize(Sender: TObject);
const
 cDefault_Panel_SIP:Word = 383; // разница между стандартным размером окна 1400 - 1017(форма на стартовом окне)
begin
 // изсеняем размер формы
 // активные операторы
  clearList_SIP(Width - cDefault_Panel_SIP);

  if Assigned(SharedCurrentUserLogon) then begin
    if SharedCurrentUserLogon.GetIsOperator then begin
      // подгонем размер статусов оператора
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

  // отображение текущей версии  ctrl+shift+G (GUID) - от этого ID зависит актуальность еще
  Caption:=Caption+' '+getVersion(GUID_VESRION,eGUI) + ' | '+'('+GUID_VESRION+')';

  // проверка на ткущую версию
  CheckCurrentVersion;

  // очистка от временных файлов после автообновления
  ClearAfterUpdate;

   // проверка на 2ую копию дошборда
  if GetCloneRun(PChar(DASHBOARD_EXE)) then begin
    MessageBox(HomeForm.Handle,PChar('Обнаружен запуск 2ой копии дашборда'+#13#13+
                                     'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcess;
  end;


  Screen.Cursor:=crHourGlass;

   // текущий залогиненый пользователь
  SharedCurrentUserLogon:=TUser.Create;


 ////////////////////////////////////
  // авторизация
  FormAuth.ShowModal;

  // нужно ли сменить пароль
  if SharedCurrentUserLogon.GetRePassword then begin
    Screen.Cursor:=crDefault;
    FormRePassword.ShowModal;
  end;
  ////////////////////////////////

  Screen.Cursor:=crHourGlass;

   // стататус бар
   with StatusBar do begin
    Panels[2].Text:=SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName;
    Panels[3].Text:=getUserRoleSTR(SharedCurrentUserLogon.GetID);
    Panels[4].Text:=GetCopyright;
   end;

   // заведение данных о текущей сесии
   createCurrentActiveSession(SharedCurrentUserLogon.GetID);


  // создание списка серверов для проверки доступности
  createCheckServersInfoclinika;


  // прогрузка индивидуальных настроек пользователя
  LoadIndividualSettingUser(SharedCurrentUserLogon.GetID);


  // выставление прав доступа
  accessRights(SharedCurrentUserLogon);

  // пасхалки
   HappyNewYear;

  Screen.Cursor:=crDefault;
  Button1.Click;
  except
  on E: Exception do begin
    MessageBox(Handle,PChar('Этой надписи никогда не должно было быть!'+#13+
                            'Если вы ее видите возникла ошибка'+#13#13+
                            'Код ошибки: '+E.ClassName+#13+E.Message),PChar('Неизвестная ошибка'),MB_OK+MB_ICONERROR);
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
  MessageBox(Handle,PChar('Дашборд обновляется автоматически'+#13#13+'Закройте окно дашборда и подождите около 30 сек'),PChar('Информация'),MB_OK+MB_ICONINFORMATION);
end;

procedure THomeForm.listSG_ACTIVESIPDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  { if AnsiPos('доступен',listSG_ACTIVESIP.Cells[ACol, ARow])<>0 then begin
      listSG_ACTIVESIP.Canvas.Font.Color := clGreen;


      listSG_ACTIVESIP.Canvas.FillRect(Rect); // закрашивание ячейки выбранным цветом
      //listSG_ACTIVESIP.Canvas.Font.Color := clBlack; // назначение цвета шрифта
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
  // создание потоков + запуск
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
