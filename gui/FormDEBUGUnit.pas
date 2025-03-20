unit FormDEBUGUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormDEBUG = class(TForm)
    Label1: TLabel;
    Label12: TLabel;
    Label23: TLabel;
    Label34: TLabel;
    panel: TPanel;
    Label2: TLabel;
    lblThread_ACTIVESIP: TLabel;
    Label13: TLabel;
    Label24: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDEBUG: TFormDEBUG;

implementation

uses
  GlobalVariables;

{$R *.dfm}

procedure TFormDEBUG.FormCreate(Sender: TObject);
begin
  SetWindowLong(0, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormDEBUG.FormShow(Sender: TObject);
begin
  if not SharedCountResponseThread.CreatedForm then SharedCountResponseThread.CreateForm;

  SharedCountResponseThread.ShowDebug;
end;

end.
