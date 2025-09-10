unit FormWaitUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls,
  Vcl.WinXCtrls;

type
  TFormWait = class(TForm)
    panel: TPanel;
    indicator: TActivityIndicator;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWait: TFormWait;

implementation

uses
  FunctionUnit;

{$R *.dfm}

procedure TFormWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  indicator.Animate:=False;
end;

procedure TFormWait.FormShow(Sender: TObject);
begin
  if not indicator.Animate then indicator.Animate:=True;

  SetRandomFontColor(Label1);
  Application.ProcessMessages;
end;

end.
