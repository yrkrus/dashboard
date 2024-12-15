unit HomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ButtonGroup, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  Vcl.OleCtrls, SHDocVw, ActiveX, MSHTML, ComObj, Vcl.WinXCtrls,
  Vcl.Imaging.jpeg;


  type enumMessageInfo = ( eShow, // отображаем инфо
                           eHide  // скрываем инфо
                          );

type
  TFormHome = class(TForm)
    StatusBar: TStatusBar;
    PanelSend: TPanel;
    PanelMessage: TPanel;
    PanelUsers: TPanel;
    PanelSendMessage: TPanel;
    reMessage: TRichEdit;
    PageChannel: TPageControl;
    PanelUsersOnline: TPanel;
    STUsersOnline: TStaticText;
    ListBoxOnlineUsers: TListBox;
    lblerr: TLabel;
    Button1: TButton;
    ImgAddFile: TImage;
    ImgSmile: TImage;
    STMessageInfo1: TStaticText;
    STMessageInfo2: TStaticText;
    popMenuTagUser: TPopupMenu;
    STMessageInfo3: TStaticText;
    N1: TMenuItem;
    N11: TMenuItem;
    ImgFormatText: TImage;
    sheet_main: TTabSheet;
    sheet_0: TTabSheet;
    sheet_2: TTabSheet;
    sheet_3: TTabSheet;
    sheet_4: TTabSheet;
    sheet_5: TTabSheet;
    sheet_6: TTabSheet;
    sheet_7: TTabSheet;
    sheet_8: TTabSheet;
    sheet_9: TTabSheet;
    sheet_1: TTabSheet;
    chat_main_master: TWebBrowser;
    chat_main_slave: TWebBrowser;
    chat_0_master: TWebBrowser;
    chat_0_slave: TWebBrowser;
    chat_1_master: TWebBrowser;
    chat_1_slave: TWebBrowser;
    chat_2_slave: TWebBrowser;
    chat_2_master: TWebBrowser;
    chat_3_master: TWebBrowser;
    chat_3_slave: TWebBrowser;
    chat_4_slave: TWebBrowser;
    chat_4_master: TWebBrowser;
    chat_5_master: TWebBrowser;
    chat_5_slave: TWebBrowser;
    chat_6_slave: TWebBrowser;
    chat_6_master: TWebBrowser;
    chat_7_master: TWebBrowser;
    chat_7_slave: TWebBrowser;
    chat_8_slave: TWebBrowser;
    chat_8_master: TWebBrowser;
    chat_9_master: TWebBrowser;
    chat_9_slave: TWebBrowser;
    ImgSendMessage: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure btnSendClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure reMessageKeyPress(Sender: TObject; var Key: Char);
    procedure ImgAddFileClick(Sender: TObject);
    procedure ImgSmileClick(Sender: TObject);
    procedure ImgSendMessageClick(Sender: TObject);
    procedure reMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure reMessageClick(Sender: TObject);
    procedure reMessageChange(Sender: TObject);
    procedure ListBoxOnlineUsersDblClick(Sender: TObject);
    procedure ListBoxOnlineUsersClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    procedure SendingClick;
    procedure ShowMessageInfo(InType: enumMessageInfo);

  public
    { Public declarations }

  ///////// ПОТОКИ ////////////
  Users_thread:TThread;
  MessageMain_thread:TThread;

  end;

var
  FormHome: TFormHome;


  // thread
  UpdateThreadUsers:Boolean;                         // остановка обновления ThreadUsers
  UpdateThreadMessageMain:Boolean;                   // остановка обновления ThreadMessageMain


implementation

uses
  GlobalVariables, Functions, Thread_MessageMain, TOnlineUsersUint, TSendMessageUnit, TOnlineChatUnit, CustomTypeUnit;

{$R *.dfm}

procedure Develop;
begin
  MessageBox(FormHome.Handle,PChar('Пока не доступно, в разработке...'),PChar('Заглушка на будущее'),MB_OK+MB_ICONASTERISK);
end;

procedure TFormHome.ShowMessageInfo(InType: enumMessageInfo);
begin
  case InType of
    eShow:begin   // отобрадаем инфо
     STMessageInfo1.Visible:=True;
     STMessageInfo2.Visible:=True;
     STMessageInfo3.Visible:=True;
    end;
    eHide:begin  // скрываем инфо
     STMessageInfo1.Visible:=False;
     STMessageInfo2.Visible:=False;
     STMessageInfo3.Visible:=False;
    end;
  end;
end;

procedure TFormHome.SendingClick;
var
 channel:string;
 recipient:Integer;
 call:string;
 msg_temp:string;
begin
  // проверки
  begin
    if reMessage.Text = '' then Exit;
    if Length(reMessage.Text)=0 then Exit;

    msg_temp:=ReplaceMessageToHTMLFormat(reMessage);
    if msg_temp='' then begin
      reMessage.Clear;
      ShowMessageInfo(eShow);
      Exit;
    end;
  end;

  MessageSending(reMessage,
                GetActiveChannel,
                USER_STARTED_CHAT_ID);

  // отображаем инфо
  ShowMessageInfo(eShow);
end;

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_CHAT_ID:=1;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('Локальный чат можно запустить только из дашборда'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcess;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_CHAT_ID:= StrToInt(ParamStr(i + 1));
        if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcess;
      end;
    end;
  end;
end;




procedure TFormHome.reMessageChange(Sender: TObject);
begin
 if reMessage.Text<>'' then ShowMessageInfo(eHide);
end;

procedure TFormHome.reMessageClick(Sender: TObject);
begin
  ShowMessageInfo(eHide);
end;

procedure TFormHome.reMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    // Если только Enter, отправляем сообщение
    if Shift = [] then
    begin
      // Здесь код для отправки сообщения
      SendingClick;
      Key := 0; // Отменяем стандартное поведение
    end
    // Если нажаты Ctrl + Enter или Shift + Enter, переходим на новую строку
    else if (Shift = [ssCtrl]) or (Shift = [ssShift]) then
    begin
      // Добавляем новую строку
      reMessage.Lines.Add('');
      Key := 0; // Отменяем стандартное поведение
    end;
  end;
end;

procedure TFormHome.reMessageKeyPress(Sender: TObject; var Key: Char);
var
  CurrentLine: string;
begin
  if Key = #13 then
  begin
    SendingClick;
  end;

  // Получаем текущую строку, в которой находится курсор
  CurrentLine := reMessage.Lines[reMessage.Perform(EM_LINEFROMCHAR, reMessage.SelStart, 0)];

  // Проверяем длину текущей строки
  if (Length(CurrentLine) >= MAX_LENGHT_LINES_ONE_FILEDS) and (Key <> #13) then
  begin
    // Если длина строки больше 100 символов и нажатая клавиша не Enter
    // добавляем новую строку
    reMessage.Lines.Add(''); // Добавляем новую строку
    // Перемещаем курсор в конец новой строки
    reMessage.SelStart := reMessage.GetTextLen; // Перемещаем курсор в конец
  end;
end;



procedure TFormHome.btnSendClick(Sender: TObject);
var
 channel:string;
 recipient:Integer;
 call:string;
begin
  if reMessage.Text = '' then Exit;
  MessageSending(reMessage,
                GetActiveChannel,
                USER_STARTED_CHAT_ID);
end;

procedure TFormHome.Button1Click(Sender: TObject);
var
  m_browser:TWebBrowser;
begin

  m_browser:=FindComponent('chatmainmaster') as TWebBrowser;
   m_browser.Navigate('file:///C:/Users/home0/Desktop/DASHBOARD/develop/chat/Win64/Debug/chat_history/main/20241213.html');
   // m_browser:=FormHome.PageChannel.FindComponent('chatmainmaster');

    {
    WebBrowser        := TWebBrowser.Create(PageChannel.Pages[0]);
    TWinControl(WebBrowser).Name   := 'WebBrowser';
    TWinControl(WebBrowser).Parent := PageChannel.Pages[0]; //set parent...can be panel, tabs etc
    WebBrowser.Silent := true;  //don't show JS errors
    WebBrowser.Visible:= true;  //visible...by default true
    WebBrowser.Align:= alClient;  //visible...by default true
    WebBrowser.Navigate('file:///C:/Users/home0/Desktop/DASHBOARD/develop/chat/Win64/Debug/chat_history/main/20241213.html');
     }

   //  chat_main_slave.Show;
end;



procedure TFormHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  KillProcess;
end;

procedure TFormHome.FormCreate(Sender: TObject);
const
 DEBUG:Boolean = true;
begin
  ProcessCommandLineParams(DEBUG);

end;

procedure TFormHome.FormShow(Sender: TObject);
begin
  // создатим copyright
  createCopyright;

  // очистка UsersOnline
  ListBoxOnlineUsers.Clear;


  // скриываем первоночально все браузеры из поля видимости
  HideAllBrowser;

  // скрываем все вкладки с личными чатами
  HideAllTabSheetChat;

  // создадим потоки
  createThread;
end;

procedure TFormHome.ImgAddFileClick(Sender: TObject);
begin
 Develop;
end;

procedure TFormHome.ImgSendMessageClick(Sender: TObject);
begin
  SendingClick;
end;

procedure TFormHome.ImgSmileClick(Sender: TObject);
begin
 Develop;
end;

// TODO заглушка на будущее
procedure TFormHome.ListBoxOnlineUsersClick(Sender: TObject);
var
 SelectedItems:Integer;
 userFIO:string;
begin
  SelectedItems:=ListBoxOnlineUsers.ItemIndex;

  if SelectedItems = -1 then Exit;
  userFIO:= ListBoxOnlineUsers.Items[SelectedItems];

  // добавляем тэг пользователя
  AddTagUserMessage(reMessage,reMessage.SelStart,userFIO);
end;

procedure TFormHome.ListBoxOnlineUsersDblClick(Sender: TObject);
var
 SelectedItems:Integer;
 userFIO:string;
begin
  SelectedItems := ListBoxOnlineUsers.ItemIndex;

  if SelectedItems = -1 then Exit;
  userFIO:= ListBoxOnlineUsers.Items[SelectedItems];

  MessageBox(Handle,PChar('Тут должно было открытся окно с личным чатом, но оно еще в разработке, скоро будет сделано'),PChar('Заглушка на будущее'),MB_OK+MB_ICONASTERISK);
end;

end.
