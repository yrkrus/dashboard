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
  // �������� �� ������� 2�� ����
  if GetCloneRun(Pchar(SMS_EXE)) then begin
    MessageBox(Handle,PChar('��������� ������ 2�� ����� sms ��������'+#13#13+
                            '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;

end.
