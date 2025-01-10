unit FormWaitUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Gauges;

type
  TFormWait = class(TForm)
    ProgressBar: TGauge;
    ProgressStatusText: TStaticText;
    STEsc: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure STEscClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  isAboutGenerate:Boolean;   // отмена формирования отчета

  end;

var
  FormWait: TFormWait;

implementation

{$R *.dfm}

procedure TFormWait.FormCreate(Sender: TObject);
begin
   FormStyle:=fsStayOnTop;
end;

procedure TFormWait.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    isAboutGenerate:=True;
  end;
end;

procedure TFormWait.FormShow(Sender: TObject);
begin
  isAboutGenerate:=False;
end;

procedure TFormWait.STEscClick(Sender: TObject);
begin
 isAboutGenerate:=True;
end;

end.
