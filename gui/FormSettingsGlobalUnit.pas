unit FormSettingsGlobalUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,FunctionUnit, Data.Win.ADODB, Data.DB, IdException,
  System.ImageList, Vcl.ImgList, TCustomTypeUnit, TWorkTimeCallCenterUnit;



type
  TFormSettingsGlobal = class(TForm)
    panel_queue: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    lblQueue_5000: TLabel;
    lblQueue_5050: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    btnAddServer: TBitBtn;
    btnEditUser: TBitBtn;
    panel_footer: TPanel;
    panel_firebird: TPanel;
    btnSaveFirebirdSettings: TBitBtn;
    btnCheckFirebirdSettings: TBitBtn;
    panel_sms: TPanel;
    Label5: TLabel;
    reSmsURL: TRichEdit;
    Label6: TLabel;
    edtLogin_SMS: TEdit;
    Label7: TLabel;
    edtPassword_SMS: TEdit;
    STSMS_viewPwd: TStaticText;
    Label8: TLabel;
    edtSmsSign: TEdit;
    btnSaveSMSSettings: TBitBtn;
    btnCheckSMSSettings: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblInfoCheckIKServerFirebird: TLabel;
    edtLogin_Firebird: TEdit;
    edtPassword_Firebird: TEdit;
    STFirebird_viewPwd: TStaticText;
    panel_access: TPanel;
    btnEditAccessMenu: TBitBtn;
    group_tree: TGroupBox;
    tree_menu: TTreeView;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    lblWorkTimeCallCenterStart: TLabel;
    Label10: TLabel;
    lblWorkTimeCallCenterStop: TLabel;
    btnEditWorkingTimeCallCentre: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure LoadSettings;
    procedure btnEditUserClick(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure STFirebird_viewPwdClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCheckFirebirdSettingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveSMSSettingsClick(Sender: TObject);
    procedure STSMS_viewPwdClick(Sender: TObject);
    procedure tree_menuClick(Sender: TObject);
    procedure btnEditAccessMenuClick(Sender: TObject);
    procedure btnEditWorkingTimeCallCentreClick(Sender: TObject);
  private

   m_workTimeCallCenter:TWorkTimeCallCenter;  // время работы коллцентра

   procedure SetFirebirdAuth;
   procedure SetButtonCheckFirebirdServer;
   procedure SetSMSAuth;
   procedure AddNode(const AText: string);
   procedure CreateTree;                      // создание дерева настроек
   procedure ShowPanel(_tree:enumTreeSettings); // отображение панели


    { Private declarations }
  public
    { Public declarations }
   procedure ShowWorkTimeCallCenter;
  end;

const
  // позиционирование выбранной панели
  cLEFT_panel :Word = 192;
  cTOP_panel  :Word = 39;

var
  FormSettingsGlobal: TFormSettingsGlobal;

implementation

uses
  FormSettingsGlobal_addIVRUnit, FormSettingsGlobal_listIVRUnit,
  FormGlobalSettingCheckFirebirdConnectUnit, GlobalVariables,
  GlobalVariablesLinkDLL, TSendSMSUint, FormMenuAccessUnit, FormWorkTimeCallCenterUnit;

{$R *.dfm}

// отображение панели
procedure  TFormSettingsGlobal.ShowPanel(_tree:enumTreeSettings);
var
  currentPanel:TPanel;
begin
   panel_queue.Visible:=False;
   panel_firebird.Visible:=False;
   panel_sms.Visible:=False;
   panel_access.Visible:=False;

   case _tree  of
    tree_queue: begin
     currentPanel:=panel_queue;
    end;
    tree_firebird: begin
     currentPanel:=panel_firebird;
    end;
    tree_sms: begin
     currentPanel:=panel_sms;
    end;
    tree_access:begin
      currentPanel:=panel_access;
    end;
   end;

   // название панели
   panel_footer.Caption:=EnumTreeSettingsToString(_tree);

   currentPanel.Visible:=True;
   currentPanel.Left:=cLEFT_panel;
   currentPanel.Top:=cTOP_panel;
end;

procedure TFormSettingsGlobal.AddNode(const AText: string);
begin
  // Добавляем новый корневой узел
  tree_menu.Items.Add(nil, AText);
end;


// создание дерева настроек
procedure TFormSettingsGlobal.CreateTree;
var
 i:Integer;
 enumName:enumTreeSettings;
begin
  tree_menu.Items.Clear;

  for i:=Ord(Low(enumTreeSettings)) to Ord(High(enumTreeSettings)) do
  begin
    enumName:=enumTreeSettings(i);
    AddNode(EnumTreeSettingsToString(enumName));
  end;
end;


// проверка можно ли активировать кнопку проверки соединения с БД
procedure TFormSettingsGlobal.SetButtonCheckFirebirdServer;
var
 isAuth,isServers:Boolean;
begin
  isAuth:=False;
  isServers:=False;

  // есть ли логин\пасс
  if (edtLogin_Firebird.Text<>'') and (edtPassword_Firebird.Text<>'') then isAuth:=True;

  // кол-во серверов ИК
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
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'TFormSettingsGlobal.SetFirebirdAuth');
     FreeAndNil(ado);
     Exit;
  end;

  try
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
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
            Exit;
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

  Screen.Cursor:=crDefault;

  if isNewAuth then MessageBox(Handle,PChar('Учетные данные подключения к Firebird сохранены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('Учетные данные подключения к Firebird обновлены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
end;



procedure TFormSettingsGlobal.SetSMSAuth;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 isNewAuth:Boolean;
 error:string;

 SMS:TSendSMS;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'TFormSettingsGlobal.SetSMSAuth');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SMS:=TSendSMS.Create(DEBUG);

      if (SMS.GetAuthData(sms_server_addr)='null') and
         (SMS.GetAuthData(sms_login)='null') and
         (SMS.GetAuthData(sms_pwd)='null') and
         (SMS.GetAuthData(sms_sign)='null')
      then begin
        SQL.Add('insert into sms_settings (url,sms_login,sms_pwd,sign) values ('+#39+reSmsURL.Text+#39+','+#39+edtLogin_SMS.Text+#39+','+#39+edtPassword_SMS.Text+#39+','+#39+edtSmsSign.Text+#39')');
        isNewAuth:=True;
      end
      else begin
        SQL.Add('update sms_settings set url = '+#39+reSmsURL.Text+#39+', sms_login = '+#39+edtLogin_SMS.Text+#39+', sms_pwd = '+#39+edtPassword_SMS.Text+#39+', sign = '+#39+edtSmsSign.Text+#39);
        isNewAuth:=False;
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
            Screen.Cursor:=crDefault;
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
            Exit;
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

  Screen.Cursor:=crDefault;

  if isNewAuth then MessageBox(Handle,PChar('Учетные данные подключения к SMS серверу сохранены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('Учетные данные подключения к SMS серверу обновлены'),PChar('Успех'),MB_OK+MB_ICONINFORMATION)
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

procedure TFormSettingsGlobal.STSMS_viewPwdClick(Sender: TObject);
begin
   if STSMS_viewPwd.Caption='показать' then begin
    edtPassword_SMS.PasswordChar:=#0;
    STSMS_viewPwd.Caption:='скрыть';
  end
  else
  begin
    edtPassword_SMS.PasswordChar:='*';
    STSMS_viewPwd.Caption:='показать';
  end;
end;

procedure TFormSettingsGlobal.tree_menuClick(Sender: TObject);
var
 treeString:string;
begin
  treeString:=tree_menu.Selected.Text;
  ShowPanel(StringToEnumTreeSettings(treeString));
end;


// отображение времени работы колл центра
procedure TFormSettingsGlobal.ShowWorkTimeCallCenter;
begin
  if not Assigned(m_workTimeCallCenter) then begin
   m_workTimeCallCenter:=TWorkTimeCallCenter.Create;
  end
  else m_workTimeCallCenter.UpdateTime;

  lblWorkTimeCallCenterStart.Caption:=m_workTimeCallCenter.StartTimeStr;
  lblWorkTimeCallCenterStop.Caption:=m_workTimeCallCenter.StopTimeStr;
end;


// прогрузка текущих параметров
procedure TFormSettingsGlobal.LoadSettings;
var
 SMS:TSendSMS;
begin
   // панель по умолчанию
   ShowPanel(tree_queue);

   // корректировка времени
   lblQueue_5000.Caption:=IntToStr(GetIVRTimeQueue(queue_5000));
   lblQueue_5050.Caption:=IntToStr(GetIVRTimeQueue(queue_5050));

   // время работы коллцентра
   ShowWorkTimeCallCenter;

   //подключение к firebird
   if (GetFirbirdAuth(firebird_login)<>'null') and (GetFirbirdAuth(firebird_pwd)<>'null') then begin
    edtLogin_Firebird.Text:=GetFirbirdAuth(firebird_login);
    edtPassword_Firebird.Text:=GetFirbirdAuth(firebird_pwd);
   end;

   // проверка можно ли включить кнопку проверка подключения к серверу
   SetButtonCheckFirebirdServer;

   SMS:=TSendSMS.Create(DEBUG);

   // подключение к SMS рассылке
   if (SMS.GetAuthData(sms_server_addr)<>'null')  and
      (SMS.GetAuthData(sms_login)<>'null') and
      (SMS.GetAuthData(sms_pwd)<>'null')  and
      (SMS.GetAuthData(sms_sign)<>'null')
   then begin
     reSmsURL.Text:=SMS.GetAuthData(sms_server_addr);
     edtLogin_SMS.Text:=SMS.GetAuthData(sms_login);
     edtPassword_SMS.Text:=SMS.GetAuthData(sms_pwd);
     edtSmsSign.Text:=SMS.GetAuthData(sms_sign);

     btnCheckSMSSettings.Enabled:=True;
   end;
end;


procedure TFormSettingsGlobal.btnAddServerClick(Sender: TObject);
begin
 FormSettingsGlobal_addIVR.ShowModal;
end;

procedure TFormSettingsGlobal.btnCheckFirebirdSettingsClick(Sender: TObject);
begin
  FormGlobalSettingCheckFirebirdConnect.ShowModal;
end;

procedure TFormSettingsGlobal.btnEditAccessMenuClick(Sender: TObject);
begin
  FormMenuAccess.ShowModal;
end;

procedure TFormSettingsGlobal.btnEditUserClick(Sender: TObject);
begin
  FormSettingsGlobal_listIVR.ShowModal;
end;

procedure TFormSettingsGlobal.btnEditWorkingTimeCallCentreClick(
  Sender: TObject);
begin
 FormWorkTimeCallCenter.ShowModal;
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

procedure TFormSettingsGlobal.btnSaveSMSSettingsClick(Sender: TObject);
begin
  if reSmsURL.Lines.Count=0 then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнена "Строка подключения"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
  end;

  if edtLogin_SMS.Text='' then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Логин"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
  end;

  if edtPassword_SMS.Text='' then begin
    MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Пароль"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if edtSmsSign.Text='' then begin
    MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Подпись в конце SMS"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

   // записываем данные
   SetSMSAuth;
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
const
 cWidth:Word  = 648;
 cHeight:Word = 317;
begin
  Screen.Cursor:=crHourGlass;

  // default value
  Height:=cHeight;
  Width:=cWidth;

  // дерево настроек
  CreateTree;

  // загружаем параметры
  LoadSettings;

  Screen.Cursor:=crDefault;
end;

end.
