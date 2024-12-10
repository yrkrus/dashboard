unit FormSettingsGlobalUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,FunctionUnit, Data.Win.ADODB, Data.DB, IdException;

type
  TFormSettingsGlobal = class(TForm)
    PanelSettings: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    btnAddServer: TBitBtn;
    btnEditUser: TBitBtn;
    lblQueue_5000: TLabel;
    lblQueue_5050: TLabel;
    PageSettings: TPageControl;
    Sheet_Queue: TTabSheet;
    Sheet_PasswordFirebird: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edtLogin_Firebird: TEdit;
    edtPassword_Firebird: TEdit;
    btnSaveFirebirdSettings: TBitBtn;
    btnCheckFirebirdSettings: TBitBtn;
    STFirebird_viewPwd: TStaticText;
    lblInfoCheckIKServerFirebird: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure LoadSettings;
    procedure btnEditUserClick(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure STFirebird_viewPwdClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCheckFirebirdSettingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

   procedure SetFirebirdAuth;
   procedure SetButtonCheckFirebirdServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettingsGlobal: TFormSettingsGlobal;

implementation

uses
  FormSettingsGlobal_addIVRUnit, FormSettingsGlobal_listIVRUnit, FormGlobalSettingCheckFirebirdConnectUnit, TCustomTypeUnit, GlobalVariables;

{$R *.dfm}


// проверка можно ли активировать кнопку проверки соединения с БД
procedure TFormSettingsGlobal.SetButtonCheckFirebirdServer;
var
 isAuth,isServers:Boolean;
begin
  isAuth:=False;
  isServers:=False;

  // есть ли логин\пасс
  if (edtLogin_Firebird.Text<>'') and (edtPassword_Firebird.Text<>'') then isAuth:=True;

  // кол-во серверров ИК
  if GetCountServersIK<>0 then isServers:=True;

  if isAuth and isServers then begin
    btnCheckFirebirdSettings.Enabled:=True;

    // инфо
    lblInfoCheckIKServerFirebird.Visible:=False;
  end;

end;

procedure TFormSettingsGlobal.SetFirebirdAuth;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 isNewAuth:Boolean;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    if (GetFirbirdAuth(firebird_login)='null') and (GetFirbirdAuth(firebird_pwd)='null') then begin
      SQL.Add('insert into server_ik_fb (firebird_login,firebird_pwd) values ('+#39+edtLogin_Firebird.Text+#39+','+#39+edtPassword_Firebird.Text+#39+')');
      isNewAuth:=True;
    end
    else begin
      SQL.Add('update server_ik_fb set firebird_login = '+#39+edtLogin_Firebird.Text+#39+', firebird_pwd = '+#39+edtPassword_Firebird.Text+#39);
      isNewAuth:=False;
    end;

    try
        ExecSQL;
    except
        on E:EIdException do begin
           Screen.Cursor:=crDefault;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
  Screen.Cursor:=crDefault;

  if isNewAuth then MessageBox(Handle,PChar('Учетные данные подключения к Firebird сохранены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('Учетные данные подключения к Firebird обновлены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
end;


procedure TFormSettingsGlobal.STFirebird_viewPwdClick(Sender: TObject);
begin
  if STFirebird_viewPwd.Caption='показать' then begin
    edtPassword_Firebird.PasswordChar:=#0;
    STFirebird_viewPwd.Caption:='скрыть';
  end
  else
  begin
    edtPassword_Firebird.PasswordChar:='*';
    STFirebird_viewPwd.Caption:='показать';
  end;
end;

// прогрузка текущих параметров
procedure TFormSettingsGlobal.LoadSettings;
begin
   // корректировка времени
   lblQueue_5000.Caption:=IntToStr(getIVRTimeQueue(queue_5000));
   lblQueue_5050.Caption:=IntToStr(getIVRTimeQueue(queue_5050));

   //подключение к firebird
   if (GetFirbirdAuth(firebird_login)<>'null') and (GetFirbirdAuth(firebird_pwd)<>'null') then begin
    edtLogin_Firebird.Text:=GetFirbirdAuth(firebird_login);
    edtPassword_Firebird.Text:=GetFirbirdAuth(firebird_pwd);
   end;

   // проверка можно ли включить кнопку проверка подключения к серверу
   SetButtonCheckFirebirdServer;
end;


procedure TFormSettingsGlobal.btnAddServerClick(Sender: TObject);
begin
 FormSettingsGlobal_addIVR.ShowModal;
end;

procedure TFormSettingsGlobal.btnCheckFirebirdSettingsClick(Sender: TObject);
begin
  FormGlobalSettingCheckFirebirdConnect.ShowModal;
end;

procedure TFormSettingsGlobal.btnEditUserClick(Sender: TObject);
begin
  FormSettingsGlobal_listIVR.ShowModal;
end;

procedure TFormSettingsGlobal.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
   if edtLogin_Firebird.Text='' then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Логин"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   if edtPassword_Firebird.Text='' then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Пароль"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   // записываем данные
   SetFirebirdAuth;

end;

procedure TFormSettingsGlobal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  // panel connect_firbird
  begin
    STFirebird_viewPwd.Caption:='показать';
    edtPassword_Firebird.PasswordChar:='*';

    btnCheckFirebirdSettings.Enabled:=False;
    lblInfoCheckIKServerFirebird.Visible:=False;
  end;

end;

procedure TFormSettingsGlobal.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormSettingsGlobal.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  // загружаем параметры
  LoadSettings;

  Screen.Cursor:=crDefault;
end;

end.
