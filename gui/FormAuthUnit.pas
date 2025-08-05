unit FormAuthUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Imaging.jpeg,TUserUnit,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList,TCustomTypeUnit;

type
  TFormAuth = class(TForm)
    PanelAuth: TPanel;
    Пользователь: TLabel;
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
    lblDEBUG: TLabel;
    ImageListIcon: TImageList;
    lblUserAuth: TLabel;
    lblChangeUser: TLabel;
    TimerNotRunUpdate: TTimer;
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
    procedure comboxUserDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lblChangeUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerNotRunUpdateTimer(Sender: TObject);


  private
    { Private declarations }
   usersListAdminRole:TStringList; // список с пользаками которые имеют админ права
   countErrorAuth:Word; // кол-во попыток ввода пароля
   isAutoUpdateNotRunning:Boolean; // не запушено автоматическое обновление


   procedure LoadUsersAuthForm;  // прогрузка пользователей в форму авторизации
   function showUserNameAuthForm:Boolean;   // отображение ранее входивщего пользователя в выборе вариантов пользователей
   function GetRoleUser(InIDCombBox:Integer):enumRole;
   procedure LoadIconListBox;    // загрузка иконок в лист бокс для последующего отображения в combobox



  public
    { Public declarations }
  end;




var
  FormAuth: TFormAuth;

implementation

uses
  FunctionUnit, DMUnit, FormHome, FormWaitUnit, TTranslirtUnit,
  GlobalVariables, GlobalVariablesLinkDLL, GlobalImageDestination;

{$R *.dfm}



function TFormAuth.GetRoleUser(InIDCombBox:Integer):enumRole;
var
  userName,userFamiliya:string;
  i:Integer;
begin
  Result:=role_operator_no_dash; // default

  userName:=comboxUser.Items[InIDCombBox];
  userName:=Copy(userName,2,Length(userName));

  System.Delete(userName,1,AnsiPos(' ',userName));

  userFamiliya:=comboxUser.Items[InIDCombBox];
  userFamiliya:=Copy(userFamiliya,2,Length(userFamiliya));
  System.Delete(userFamiliya, AnsiPos(' ',userFamiliya),Length(userFamiliya));

  if usersListAdminRole.Count=0 then Exit;

  for i:=0 to usersListAdminRole.Count-1 do begin
   if userFamiliya+' '+userName =usersListAdminRole[i] then begin
     Result:=role_administrator;
     Exit;
   end;
  end;

end;


// отображение ранее входивщего пользователя в выборе вариантов пользователей
function TFormAuth.showUserNameAuthForm:Boolean;
var
 userNameFamiliya:string;
begin
  Result:=False;

  // найдем Имя фамилию последнего успешного входа
  userNameFamiliya:=getUserFamiliyaName_LastSuccessEnter(GetCurrentUserNamePC,getComputerPCName);
  if userNameFamiliya='null' then Exit;

  // найдем нужный items
  comboxUser.ItemIndex:=comboxUser.Items.IndexOf(' '+userNameFamiliya);
  comboxUser.SetFocus;
  edtPassword.SetFocus;

  Result:=True;

end;


procedure TFormAuth.TimerNotRunUpdateTimer(Sender: TObject);
begin
   if not lblInfoUpdateService.Visible then lblInfoUpdateService.Visible:=True
   else lblInfoUpdateService.Visible:=False;
end;

// загрузка иконок в лист бокс для последующего отображения в combobox
procedure TFormAuth.LoadIconListBox;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmp: TPngImage;
 bmp: TBitmap;
begin
 // найдем список с польазками с админ правами
  usersListAdminRole:=GetListAdminRole;


 // **********************************************************
 // добавление тут + в events DrawItem самого combox
 // **********************************************************

   // изменение стиля для отображения иконок в combox
 if (not FileExists(ICON_AUTH_USER)) and (not FileExists(ICON_AUTH_USER))  then Exit;


   with FormAuth do begin
     comboxUser.Style:=csOwnerDrawFixed;

     ImageListIcon.SetSize(SIZE_ICON,SIZE_ICON);
     ImageListIcon.ColorDepth:=cd32bit;

     pngbmp:=TPngImage.Create;
     bmp:=TBitmap.Create;

     pngbmp.LoadFromFile(ICON_AUTH_USER);

      // сжимаем иконку до размера 16х16
      with bmp do begin
       Height:=SIZE_ICON;
       Width:=SIZE_ICON;
       Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmp);
      end;

      ImageListIcon.Add(bmp, nil);

      // подгрузим еще одну иконку
      pngbmp.LoadFromFile(ICON_AUTH_USER_ADMIN);
      // сжимаем иконку до размера 16х16
      with bmp do begin
       Height:=SIZE_ICON;
       Width:=SIZE_ICON;
       Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmp);
      end;
      ImageListIcon.Add(bmp, nil);

     // ShowMessage(IntToStr(ImageListIcon.Count)) ;

      if pngbmp<>nil then pngbmp.Free;
      if bmp<>nil then bmp.Free;
   end;
end;

procedure TFormAuth.DefaultFormSize;
const
  WidthDefaultForm:Word=336;
  HeightDefaultForm:Word=251;
  WidthDefaulPanel:Word=335;
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
 error:string;
begin

  successEnter:=False;

    begin
      if comboxUser.ItemIndex = -1 then begin
        FormSizeWithError('Не выбран пользователь');
        Exit;
      end;
      current_user:=comboxUser.Items[comboxUser.ItemIndex];
      current_user:=Copy(current_user,2, Length(current_user)); // т.к. в combox заносится пробел+ФИО (для удобной визуализации сделано)

      current_pwd:=edtPassword.Text;
      if current_pwd = '' then begin
        FormSizeWithError('Пустой пароль');
        Exit;
      end;
    end;

   Screen.Cursor:=crHourGlass;

   // найдем пользака
  user_name:=current_user;
  System.Delete(user_name,1,AnsiPos(' ',user_name));
  user_familiya:=current_user;
  System.Delete(user_familiya, AnsiPos(' ',user_familiya),Length(user_familiya));

  // проверим есть ли уже активная сессия
  if not DEBUG then begin
    if GetExistActiveSession(getUserID(user_name,user_familiya),activeSession) then begin
      Screen.Cursor:=crDefault;
      FormSizeWithError('Активна другая сессия '+#13+activeSession);
      Exit;
    end;
  end;


  pwd:=getHashPwd(current_pwd);
  user_pwd:=getUserPwd(getUserID(user_name,user_familiya));

  if user_pwd = pwd then successEnter:=True
  else successEnter:=False;

  // глобальные параретры пользака
   begin
     currentUser:=TUserList.Create;
     with currentUser do begin
      name          := user_name;
      familiya      := user_familiya;
      id            := getUserID(user_name,user_familiya);
      login         := getUserLogin(id);
      group_role    := StringToEnumRole(getUserRoleSTR(id));
      re_password   := getUserRePassword(id);
      ip            := getLocalIP;
      pc            := getComputerPCName;
      user_login_pc := GetCurrentUserNamePC;
     end;

     SharedCurrentUserLogon.UpdateParams(currentUser);
     USER_STARTED_SMS_ID:=SharedCurrentUserLogon.GetID;


     //////////////////////////////////////////////////
     // Смена статуса (для операторов)
     SharedStatus.SetUserID(SharedCurrentUserLogon.GetID);
     SharedStatus.SetUser(currentUser);

     currentUser.Free;
   end;



  if successEnter then begin
    if not DEBUG then begin
      if isAutoUpdateNotRunning then begin
       MessageBox(HomeForm.Handle,PChar('Служба автоматического обновления не работает'+#13#13+'Обратитесь в отдел ИТ если данное сообщение будет повторяться'),PChar('Информация'),MB_OK+MB_ICONINFORMATION);
      end;
    end;

    // логирование (авторизация)
    LoggingRemote(eLog_enter,SharedCurrentUserLogon.GetID);
    Screen.Cursor:=crDefault;
    Close;
  end
  else begin

    // логирование (не успешная авторизация)
   LoggingRemote(eLog_auth_error,SharedCurrentUserLogon.GetID);
   Screen.Cursor:=crDefault;

   FormSizeWithError('Ошибка авторизации, не верный пароль');
   Inc(countErrorAuth);

   if countErrorAuth >= 4 then begin
    error:='Превышено максимальное кол-во попыток входа';
    ShowFormErrorMessage(error,SharedMainLog,'THomeForm.TFormAuth');
   end;

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

  // getTranslate('Тестовое сообщение');
end;

procedure TFormAuth.comboxUserChange(Sender: TObject);
begin
   DefaultFormSize;
end;

procedure TFormAuth.comboxUserDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
 var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;

begin
  if ImageListIcon.Count<>0 then begin

      // проверка роли пользвоателя
      if GetRoleUser(Index)=role_administrator then IconIndex:=1
      else IconIndex:=0;

      ComboBox:=(Control as TComboBox);
      Bitmap:= TBitmap.Create;
      try
        ImageListIcon.GetBitmap(IconIndex, Bitmap);
        with ComboBox.Canvas do
        begin
          FillRect(Rect);
          if Bitmap.Handle <> 0 then
            Draw(Rect.Left + 2, Rect.Top, Bitmap);
          Rect := Bounds(
            Rect.Left + ComboBox.ItemHeight + 3,
            Rect.Top,
            Rect.Right - Rect.Left,
            Rect.Bottom - Rect.Top
          );
          DrawText(
            handle,
            PChar(ComboBox.Items[Index]),
            length(ComboBox.Items[index]),
            Rect,
            DT_VCENTER + DT_SINGLELINE
          );
        end;
      finally
        Bitmap.Free;
      end;

  end;
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


// прогрузка пользователей в форму авторизации
procedure TFormAuth.LoadUsersAuthForm;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 countUsers,i:Integer;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage('Возникла ошибка при запросе на сервер!'+#13+error, SharedMainLog, 'LoadUsersAuthForm');
     FreeAndNil(ado);
     KillProcess;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from users where disabled = ''0'' and role <> '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39);

      try
          Active:=True;
      except
          on E:EIdException do begin
             CodOshibki:=e.Message;
             MessageBox(FormAuth.Handle,PChar('Возникла ошибка при запросе на сервер!'+#13#13+CodOshibki),PChar('Ошибка'),MB_OK+MB_ICONERROR);
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;

             KillProcess;
          end;
      end;

      countUsers:=Fields[0].Value;

      SQL.Clear;
      SQL.Add('select familiya,name from users where disabled = ''0'' and role <> '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39+' order by familiya');

      try
          Active:=True;
      except
          on E:EIdException do begin
             CodOshibki:=e.Message;
             MessageBox(FormAuth.Handle,PChar('Возникла ошибка при запросе на сервер!'+#13#13+CodOshibki),PChar('Ошибка'),MB_OK+MB_ICONERROR);
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;

             KillProcess;
          end;
      end;

       with FormAuth.comboxUser do begin

        Clear;

         for i:=0 to countUsers-1 do begin
          Items.Add(' '+Fields[0].Value+' '+Fields[1].Value);
          ado.Next;
         end;
       end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
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

procedure TFormAuth.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(usersListAdminRole) then FreeAndNil(usersListAdminRole);
  if TimerNotRunUpdate.Enabled then TimerNotRunUpdate.Enabled:=False;
end;

procedure TFormAuth.FormCreate(Sender: TObject);
begin
   SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormAuth.FormShow(Sender: TObject);
var
 i:Integer;
begin
 // debug node
 begin
  if DEBUG then lblDEBUG.Visible:=True;
  // проверка запущена ли служба обновления
   if not DEBUG  then begin
     if not GetStatusUpdateService then begin
       TimerNotRunUpdate.Enabled:=True;
       isAutoUpdateNotRunning:=True;
     end else isAutoUpdateNotRunning:=False;
   end;
 end;

  // кол-во попыток ввода пароля
  countErrorAuth:=0;

  // размер окна по умолчанию
  DefaultFormSize;

  // прогрузка иконок
  LoadIconListBox;
  createIconPassword;

  // прогружаем пользователей
  LoadUsersAuthForm;

  // отображение ранее входивщего пользователя в выборе вариантов пользователей
  if showUserNameAuthForm then begin
    comboxUser.Visible:=False;

    lblUserAuth.Font.Color:=clActiveCaption;
    lblUserAuth.Caption:=comboxUser.Text;
    lblUserAuth.Visible:=True;
    lblUserAuth.Top:=99;

    lblChangeUser.Visible:=True;
    //lblChangeUser.Top:=100;
  end;

  // версия
  lblVersion.Caption:=GetVersion(GUID_VERSION,eGUI);

  // пасхалки
  Egg;
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


procedure TFormAuth.lblChangeUserClick(Sender: TObject);
begin
  edtPassword.Text:='';

  lblUserAuth.Visible:=False;
  lblChangeUser.Visible:=False;

  comboxUser.Visible:=True;
end;

end.
