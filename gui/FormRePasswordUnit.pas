unit FormRePasswordUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormRePassword = class(TForm)
    lblFooter: TLabel;
    btnRePwd: TButton;
    Panel: TPanel;
    lblPwd_show: TLabel;
    edtPwdNew: TEdit;
    lblPwd2_show: TLabel;
    edtPwd2New: TEdit;
    procedure btnRePwdClick(Sender: TObject);
    procedure edtPwd2NewKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  changePasswordManual:Boolean; // параметр указывающй на смену своего пароля

  end;

var
  FormRePassword: TFormRePassword;

implementation

uses
  FormHome, FunctionUnit, GlobalVariables;

{$R *.dfm}

procedure TFormRePassword.btnRePwdClick(Sender: TObject);
const
 sSIZE_PWD:Word = 4;
var
  resultat:string;
  pwd:Integer;
begin
   // проверки
    if edtPwdNew.Text='' then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Пароль"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;

    if edtPwd2New.Text='' then begin
     MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "Подтверждение"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;

    if edtPwdNew.Text <> edtPwd2New.Text then begin
     MessageBox(Handle,PChar('ОШИБКА! Пароли не совпадают'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;

    if Length(edtPwdNew.Text)<=3 then begin
     MessageBox(Handle,PChar('ОШИБКА! Длина пароля слишком короткая'+#13#13+'Минимальная длина пароля: '+IntToStr(sSIZE_PWD)+' символа'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;


    // меняем пароль
   pwd:=getHashPwd(edtPwdNew.Text);

   resultat:=updateUserPassword(SharedCurrentUserLogon.GetID,pwd);

   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   Close;
end;

procedure TFormRePassword.edtPwd2NewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnRePwd.Click;
  end;
end;

procedure TFormRePassword.FormShow(Sender: TObject);
begin
  if changePasswordManual then begin
    Caption:='Смена текущего пароля';
    lblFooter.Visible:=False;
    Panel.Top:=20;
    BorderIcons:=[biSystemMenu];
  end
  else begin
    Caption:='Требуется сменить текущий пароль';
    BorderIcons:=[];

    lblFooter.Caption:='Необходимо сменить текущий пароль';
    lblFooter.Visible:=True;
    lblFooter.Top:=9;

    Panel.Top:=30;
  end;
end;

end.
