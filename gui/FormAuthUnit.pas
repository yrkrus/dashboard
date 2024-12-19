unit FormAuthUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Imaging.jpeg,TUserUnit,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage;

type
  TFormAuth = class(TForm)
    PanelAuth: TPanel;
    ѕользователь: TLabel;
    Label1: TLabel;
    Image1: TImage;
    lblVersion: TLabel;
    edtPassword: TEdit;
    comboxUser: TComboBox;
    Button1: TButton;
    btnAuth: TBitBtn;
    btnClose: TBitBtn;
    img_eay_open: TImage;
    img_eay_close: TImage;
    ImageLogo: TImage;
    ImgNewYear: TImage;
    lblInfoError: TLabel;
    lblInfoUpdateService: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAuthClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure img_eay_openClick(Sender: TObject);
    procedure img_eay_closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DefaultFormSize;
    procedure FormSizeWithError(InStrokaError:string);
    procedure comboxUserChange(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;




var
  FormAuth: TFormAuth;

implementation

uses
  FunctionUnit, DMUnit, FormHome, FormWaitUnit, TTranslirtUnit, TCustomTypeUnit, GlobalVariables;

{$R *.dfm}


procedure TFormAuth.DefaultFormSize;
const
  WidthDefaultForm:Word=338;
  HeightDefaultForm:Word=251;
  WidthDefaulPanel:Word=337;
  HeightDefaultPanel:Word=249;
  btnDefaultTop:Word=192;
begin
   // сама форма
   Width:=WidthDefaultForm;
   Height:=HeightDefaultForm;

   // панель
   PanelAuth.Width:=WidthDefaulPanel;
   PanelAuth.Height:=HeightDefaultPanel;

   // кнопки
   btnAuth.Top:=btnDefaultTop;
   btnClose.Top:=btnDefaultTop;

   // ошибка
   lblInfoError.Visible:=False;
end;


procedure TFormAuth.FormSizeWithError(InStrokaError:string);
const
  WidthDefaultForm:Word=338;
  HeightDefaultForm:Word=276;
  WidthDefaulPanel:Word=337;
  HeightDefaultPanel:Word=275;
  btnDefaultTop:Word=220;
begin
   // сама форма
   Width:=WidthDefaultForm;
   Height:=HeightDefaultForm;

   // панель
   PanelAuth.Width:=WidthDefaulPanel;
   PanelAuth.Height:=HeightDefaultPanel;

   // кнопки
   btnAuth.Top:=btnDefaultTop;
   btnClose.Top:=btnDefaultTop;

   // ошибка
   lblInfoError.Caption:=InStrokaError;
   lblInfoError.Visible:=True;
end;


procedure TFormAuth.btnAuthClick(Sender: TObject);
var
 i:Integer;
 current_user:string;
 current_pwd:string;
 pwd:Integer;
 successEnter:Boolean;
 user_name,user_familiya:string;
 user_pwd:Integer;
 currentUser:TUserList;
 activeSession:string;
begin

  successEnter:=False;

    begin
      if comboxUser.ItemIndex = -1 then begin
        FormSizeWithError('Ќе выбран пользователь');
        Exit;
      end;
      current_user:=comboxUser.Items[comboxUser.ItemIndex];


      current_pwd:=edtPassword.Text;
      if current_pwd = '' then begin
        FormSizeWithError('ѕустой пароль');
        Exit;
      end;
    end;

   Screen.Cursor:=crHourGlass;

   // найдем пользака
  user_name:=current_user;
  System.Delete(user_name,1,AnsiPos(' ',user_name));
  user_familiya:=current_user;
  System.Delete(user_familiya, AnsiPos(' ',user_familiya),Length(user_familiya));

  // проверим есть ли уже активна€ сесси€
  if GetExistActiveSession(getUserID(user_name,user_familiya),activeSession) then begin
    Screen.Cursor:=crDefault;
    FormSizeWithError('јктивна друга€ сесси€ '+#13+activeSession);
    Exit;
  end;

  pwd:=getHashPwd(current_pwd);
  user_pwd:=getUserPwd(getUserID(user_name,user_familiya));

  if user_pwd = pwd then successEnter:=True
  else successEnter:=False;

  // глобальные паарметры пользака
   begin
     currentUser:=TUserList.Create;
     with currentUser do begin
      name          := user_name;
      familiya      := user_familiya;
      id            := getUserID(user_name,user_familiya);
      login         := getUserLogin(id);
      group_role    := StrToTRole(getUserRoleSTR(id));
      re_password   := getUserRePassword(id);
      ip            := getLocalIP;
      pc            := getComputerPCName;
      user_login_pc := getCurrentUserNamePC;
     end;

     SharedCurrentUserLogon.UpdateParams(currentUser);

     currentUser.Free;
   end;


  if successEnter then begin
    // логирование (авторизаци€)
    LoggingRemote(eLog_enter);
    Screen.Cursor:=crDefault;
    Close;
  end
  else begin

    // логирование (не успешна€ авторизаци€)
   LoggingRemote(eLog_auth_error);
   Screen.Cursor:=crDefault;

   FormSizeWithError('ќшибка авторизации, не верный пароль');
   Exit;
  end;

end;

procedure TFormAuth.btnCloseClick(Sender: TObject);
begin
   KillProcess;
end;



procedure TFormAuth.Button1Click(Sender: TObject);
begin
  //Close;
 // FormWait.Show;

  // getTranslate('“естовое сообщение');
end;

procedure TFormAuth.comboxUserChange(Sender: TObject);
begin
   DefaultFormSize;
end;

procedure TFormAuth.edtPasswordChange(Sender: TObject);
begin
  DefaultFormSize;
end;

procedure TFormAuth.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnAuth.Click;
  end;

  if Key = #27 then
  begin
    KillProcess;
  end;
end;


procedure createIconPassword;
begin
  with FormAuth do begin
    // показать пароль (иконка с перечеркнутым глазиком)
     img_eay_open.Parent:=edtPassword;
     img_eay_open.Transparent := False;
     img_eay_open.Visible:=True;
     img_eay_open.Left := 270;
     img_eay_open.Top := -2;

     // показать пароль (иконка с глазиком)
     img_eay_close.Parent:=edtPassword;
     img_eay_close.Transparent := False;
     img_eay_close.Visible:=False;
     img_eay_close.Left := 270;
     img_eay_close.Top := -2;
  end;
end;

procedure TFormAuth.FormCreate(Sender: TObject);
begin
   SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormAuth.FormShow(Sender: TObject);
var
 i:Integer;
begin
  // размер окна по умолчанию
  DefaultFormSize;

  createIconPassword;

  // прогружаем пользователей
  LoadUsersAuthForm;

  // отображение ранее входивщего пользовател€ в выборе вариантов пользователей
  showUserNameAuthForm;

  // верси€
  lblVersion.Caption:=getVersion(GUID_VESRION,eGUI);

  // пасхалки
  HappyNewYear;

  // проверка запущена ли служба обновлени€
  if not GetStatusUpdateService then lblInfoUpdateService.Visible:=True;
end;

procedure TFormAuth.img_eay_closeClick(Sender: TObject);
begin
  edtPassword.PasswordChar:='*';
  img_eay_open.Visible:=True;

  img_eay_close.Visible:=False;
end;

procedure TFormAuth.img_eay_openClick(Sender: TObject);
begin
  edtPassword.PasswordChar:=#0;
  img_eay_open.Visible:=False;

  img_eay_close.Visible:=True;

end;

end.
