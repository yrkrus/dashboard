unit HomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ButtonGroup, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  Vcl.OleCtrls, SHDocVw, uWVBrowserBase, uWVBrowser, uWVWinControl,
  uWVWindowParent, uWVFMXBrowser,
  ActiveX, MSHTML, ComObj, Vcl.WinXCtrls;

type
  TFormHome = class(TForm)
    StatusBar: TStatusBar;
    PanelSend: TPanel;
    PanelMessage: TPanel;
    PanelUsers: TPanel;
    btnSend: TButton;
    ST_StatusPanel: TStaticText;
    PanelSendMessage: TPanel;
    reMessage: TRichEdit;
    PageChannel: TPageControl;
    sheet_main: TTabSheet;
    PanelUsersOnline: TPanel;
    STUsersOnline: TStaticText;
    CheckBox1: TCheckBox;
    ListBoxOnlineUsers: TListBox;
    TabSheet1: TTabSheet;
    lblerr: TLabel;
    WVWindowParent1: TWVWindowParent;
    WVBrowser1: TWVBrowser;
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    actIndMessageMain: TActivityIndicator;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure ListBoxOnlineUsersClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
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
  GlobalVariables, Functions, Thread_MessageMain, TOnlineUsersUint, TSendMessageUnit, TOnlineChatUnit;

{$R *.dfm}

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


procedure TFormHome.btnSendClick(Sender: TObject);
var
 channel:string;
 recipient:Integer;
 msg:string;
 call:string;
begin
  if reMessage.Text = '' then Exit;

  // в какой канал отправляем
  channel:=GetChannel;
  if channel='main' then recipient:=0
  else begin
   // TODO тут написать!

  end;

  msg:=reMessage.Text;

  // TODO тут написать когда тэгаем пользователя
     // tag
     call:='44';

  if not SendMessage(channel,
                     USER_STARTED_CHAT_ID,
                     recipient,
                     call,
                     msg ) then begin
    MessageBox(Handle,PChar('Ошибка отправки сообщения:'+#13#13+SENDING_MESSAGE_ERROR),PChar('Ошибка отправки'),MB_OK+MB_ICONERROR);
  end;

  reMessage.Clear;
  //Button1.Click;
end;

procedure TFormHome.Button1Click(Sender: TObject);
var
 filehtml:string;
 Doc: IHTMLDocument2;
 Window: IHTMLWindow2;
 MessageMain:TOnlineChat; // текущие собощение в общем чате
begin
 if not GetCreateFileLocalChat('main',GetCurrentTime+'.html') then ShowMessage('err');

  filehtml:=ExtractFilePath(ParamStr(0))+'test.html';

  MessageMain:=TOnlineChat.Create('main');
  MessageMain.CreateFile(filehtml);

  WebBrowser1.Navigate(filehtml);
 // while WebBrowser1.ReadyState<>READYSTATE_COMPLETE do Sleep(100);

  //HTMLContent:=WideString('<html><head><title>Test</title></head><body>'+'teststt'+'</body></html>');

  if Supports(WebBrowser1.Document, IHTMLDocument2, Window) then
  begin
    // Прокрутите страницу вниз с помощью JavaScript
     Window.scroll(0, 100);
  end
  else
  begin
    ShowMessage('Документ не поддерживает IHTMLDocument2');
  end;

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

  // создадим потоки
  createThread;
end;

// TODO заглушка на будущее
procedure TFormHome.ListBoxOnlineUsersClick(Sender: TObject);
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
