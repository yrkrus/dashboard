unit FormSettingsGlobalUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,FunctionUnit, Data.Win.ADODB, Data.DB, IdException,
  System.ImageList, Vcl.ImgList;

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
    Sheet_SMS: TTabSheet;
    Label5: TLabel;
    reSmsURL: TRichEdit;
    edtLogin_SMS: TEdit;
    edtPassword_SMS: TEdit;
    Label7: TLabel;
    btnSaveSMSSettings: TBitBtn;
    btnCheckSMSSettings: TBitBtn;
    STSMS_viewPwd: TStaticText;
    Label6: TLabel;
    Label8: TLabel;
    edtSmsSign: TEdit;
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
  private

   procedure SetFirebirdAuth;
   procedure SetButtonCheckFirebirdServer;
   procedure SetSMSAuth;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettingsGlobal: TFormSettingsGlobal;

implementation

uses
  FormSettingsGlobal_addIVRUnit, FormSettingsGlobal_listIVRUnit,
  FormGlobalSettingCheckFirebirdConnectUnit, TCustomTypeUnit, GlobalVariables, TSendSMSUint;

{$R *.dfm}


// �������� ����� �� ������������ ������ �������� ���������� � ��
procedure TFormSettingsGlobal.SetButtonCheckFirebirdServer;
var
 isAuth,isServers:Boolean;
begin
  isAuth:=False;
  isServers:=False;

  // ���� �� �����\����
  if (edtLogin_Firebird.Text<>'') and (edtPassword_Firebird.Text<>'') then isAuth:=True;

  // ���-�� �������� ��
  if GetCountServersIK<>0 then isServers:=True;

  if isAuth and isServers then begin
    btnCheckFirebirdSettings.Enabled:=True;

    // ����
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

  if isNewAuth then MessageBox(Handle,PChar('������� ������ ����������� � Firebird ���������'),PChar('�����'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('������� ������ ����������� � Firebird ���������'),PChar('�����'),MB_OK+MB_ICONINFORMATION)
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

  if isNewAuth then MessageBox(Handle,PChar('������� ������ ����������� � SMS ������� ���������'),PChar('�����'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('������� ������ ����������� � SMS ������� ���������'),PChar('�����'),MB_OK+MB_ICONINFORMATION)
end;


procedure TFormSettingsGlobal.STFirebird_viewPwdClick(Sender: TObject);
begin
  if STFirebird_viewPwd.Caption='��������' then begin
    edtPassword_Firebird.PasswordChar:=#0;
    STFirebird_viewPwd.Caption:='������';
  end
  else
  begin
    edtPassword_Firebird.PasswordChar:='*';
    STFirebird_viewPwd.Caption:='��������';
  end;
end;

procedure TFormSettingsGlobal.STSMS_viewPwdClick(Sender: TObject);
begin
   if STSMS_viewPwd.Caption='��������' then begin
    edtPassword_SMS.PasswordChar:=#0;
    STSMS_viewPwd.Caption:='������';
  end
  else
  begin
    edtPassword_SMS.PasswordChar:='*';
    STSMS_viewPwd.Caption:='��������';
  end;
end;

// ��������� ������� ����������
procedure TFormSettingsGlobal.LoadSettings;
var
 SMS:TSendSMS;
begin
   // ������������� �������
   lblQueue_5000.Caption:=IntToStr(GetIVRTimeQueue(queue_5000));
   lblQueue_5050.Caption:=IntToStr(GetIVRTimeQueue(queue_5050));

   //����������� � firebird
   if (GetFirbirdAuth(firebird_login)<>'null') and (GetFirbirdAuth(firebird_pwd)<>'null') then begin
    edtLogin_Firebird.Text:=GetFirbirdAuth(firebird_login);
    edtPassword_Firebird.Text:=GetFirbirdAuth(firebird_pwd);
   end;

   // �������� ����� �� �������� ������ �������� ����������� � �������
   SetButtonCheckFirebirdServer;

   SMS:=TSendSMS.Create(DEBUG);

   // ����������� � SMS ��������
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

procedure TFormSettingsGlobal.btnEditUserClick(Sender: TObject);
begin
  FormSettingsGlobal_listIVR.ShowModal;
end;

procedure TFormSettingsGlobal.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
   if edtLogin_Firebird.Text='' then begin
     MessageBox(Handle,PChar('������! �� ��������� ���� "�����"'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   if edtPassword_Firebird.Text='' then begin
     MessageBox(Handle,PChar('������! �� ��������� ���� "������"'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   // ���������� ������
   SetFirebirdAuth;
end;

procedure TFormSettingsGlobal.btnSaveSMSSettingsClick(Sender: TObject);
begin
  if reSmsURL.Lines.Count=0 then begin
     MessageBox(Handle,PChar('������! �� ��������� "������ �����������"'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
  end;

  if edtLogin_SMS.Text='' then begin
     MessageBox(Handle,PChar('������! �� ��������� ���� "�����"'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
  end;

  if edtPassword_SMS.Text='' then begin
    MessageBox(Handle,PChar('������! �� ��������� ���� "������"'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if edtSmsSign.Text='' then begin
    MessageBox(Handle,PChar('������! �� ��������� ���� "������� � ����� SMS"'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

   // ���������� ������
   SetSMSAuth;
end;

procedure TFormSettingsGlobal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  // panel connect_firbird
  begin
    STFirebird_viewPwd.Caption:='��������';
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

  // ��������� ���������
  LoadSettings;

  Screen.Cursor:=crDefault;
end;

end.
