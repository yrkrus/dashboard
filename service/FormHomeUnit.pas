unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFormHome = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation

uses
  GlobalVariables;

{$R *.dfm}

procedure TFormHome.FormCreate(Sender: TObject);
begin
  // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(SMS_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии sms рассылки'+#13#13+
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;

end.
