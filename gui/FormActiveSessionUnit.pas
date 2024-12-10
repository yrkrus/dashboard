unit FormActiveSessionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormActiveSession = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TButton;
    Label8: TLabel;
    PanelActive: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormActiveSession: TFormActiveSession;

implementation

uses
  FunctionUnit, TActiveSessionUnit;

{$R *.dfm}

procedure TFormActiveSession.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormActiveSession.FormShow(Sender: TObject);
var
 test: TActiveSession;
begin

 test:=TActiveSession.Create;



  createFormActiveSession;
end;

end.
