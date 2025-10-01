unit FormSipPhoneListAddUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, TSipPhoneListUnit;

type
  TFormSipPhoneListAdd = class(TForm)
    btnAction: TBitBtn;
    Label1: TLabel;
    edt_Sip: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt_SipKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
  private
    { Private declarations }
  m_sipList:TSipPhoneList;

  public
    { Public declarations }


  end;

var
  FormSipPhoneListAdd: TFormSipPhoneListAdd;

implementation

uses
  FormSipPhoneListUnit;



{$R *.dfm}



procedure TFormSipPhoneListAdd.btnActionClick(Sender: TObject);
var
 error:string;
begin
  if Length(edt_Sip.Text) = 0  then begin
    MessageBox(Handle,PChar('ОШИБКА! Не заполнено поле "SIP номер"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if not m_sipList.Add(edt_Sip.Text,error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end
  else MessageBox(Handle,PChar('Новый SIP номер добавлен'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);

  edt_Sip.Text:='';

  // обновим данные на форме
  FormSipPhoneList.NeedUpdateData;
end;

procedure TFormSipPhoneListAdd.edt_SipKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnAction.Click;
  end;

  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
end;

procedure TFormSipPhoneListAdd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edt_Sip.Text:='';
end;

procedure TFormSipPhoneListAdd.FormShow(Sender: TObject);
begin
   m_sipList:=TSipPhoneList.Create;
end;

end.
