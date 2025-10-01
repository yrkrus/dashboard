unit FormSettingsGlobal_checkLdapUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFormSettingsGlobal_checkLdap = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edt_user: TEdit;
    edt_pwd: TEdit;
    Label3: TLabel;
    btnSaveFirebirdSettings: TBitBtn;
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  m_ldapHost:string;
  m_ldapPort:Integer;

  public
    { Public declarations }
  procedure SetLdap(_host:string;_port:Integer);

  end;

var
  FormSettingsGlobal_checkLdap: TFormSettingsGlobal_checkLdap;

implementation

uses
  TLdapUnit;

{$R *.dfm}


procedure TFormSettingsGlobal_checkLdap.btnSaveFirebirdSettingsClick(
  Sender: TObject);
var
 ldap:TLdap;
 user:string;
 pwd:string;
begin
  user:=edt_user.Text;
  pwd:=edt_pwd.Text;

  if Length(user) = 0 then begin
   MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Пользователь"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  if Length(pwd) = 0 then begin
   MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Пароль"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  ldap:=TLdap.Create(m_ldapHost,m_ldapPort);
  if not ldap.LdapIsInit then begin
   MessageBox(Handle,PChar('ОШИБКА! Не удалось создать объект класса Ldap'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  if ldap.CheckAuth(user,pwd) then begin
   MessageBox(Handle,PChar('Успешная авторизация на '+m_ldapHost),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
  end
  else begin
   MessageBox(Handle,PChar('ОШИБКА! Не удалось авторизоваться на '+m_ldapHost),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;

procedure TFormSettingsGlobal_checkLdap.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edt_user.Text:='';
  edt_pwd.Text:='';
end;

procedure TFormSettingsGlobal_checkLdap.SetLdap(_host:string;_port:Integer);
begin
  m_ldapHost:=_host;
  m_ldapPort:=_port;
end;


end.
