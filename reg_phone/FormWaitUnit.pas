unit FormWaitUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls,
  Vcl.WinXCtrls, TCustomTypeUnit;

type
  TFormWait = class(TForm)
    panel: TPanel;
    indicator: TActivityIndicator;
    lblInfo: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  procedure SetInfo(_type:enumTypeSipRegPhone);

  end;

var
  FormWait: TFormWait;

implementation

uses
  FunctionUnit;

{$R *.dfm}

procedure TFormWait.SetInfo(_type:enumTypeSipRegPhone);
begin
  case _type of
   eDeRegisterPhone:begin
     lblInfo.Caption:='Разрегистрация телефона';
   end;
   eRegisterPhone:begin
     lblInfo.Caption:='Регистрация телефона';
   end;
  end;
end;

procedure TFormWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  indicator.Animate:=False;
end;

procedure TFormWait.FormShow(Sender: TObject);
begin
  if not indicator.Animate then indicator.Animate:=True;

  SetRandomFontColor(lblInfo);
  //Application.ProcessMessages;
end;

end.
