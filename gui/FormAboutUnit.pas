unit FormAboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TFormAbout = class(TForm)
    imgAbout: TImage;
    Label1: TLabel;
    lblVersion: TLabel;
    lblDevelop: TLabel;
    label3: TLabel;
    REHistory: TRichEdit;
    TimerStartPashalka1: TTimer;
    ImgNewYear: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgAboutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerStartPashalka1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  procedure SetRandomFontColor(lbl: TLabel);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;
  Pashalka:Word;


implementation

uses
  FunctionUnit, GlobalVariables;

{$R *.dfm}

procedure TFormAbout.SetRandomFontColor(lbl: TLabel);
var
  RandomColor: TColor;
begin
  // ���������� ��������� �������� ��� RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // ������������� ��������� ���� ������ ��� �����
  lbl.Font.Color := RandomColor;
end;


procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerStartPashalka1.Enabled:=False;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  lblVersion.Caption:=getVersion(GUID_VESRION);
  Pashalka:=0;

  // ����������� ������� ������
  showVersionAbout;

  lblDevelop.Caption:=GetCopyright;

  Screen.Cursor:=crDefault;

  TimerStartPashalka1.Enabled:=True;
end;

procedure TFormAbout.imgAboutClick(Sender: TObject);
begin
 Inc(Pashalka);

 if Pashalka=10 then begin
   MessageBox(Handle,PChar('��� ���� ������ ���� ����� �� ��������, �� ��� �� ���� ������ =)'),PChar('� ���� ��� ����� ������� ��� � ������ �� ��� ������'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=50 then begin
   MessageBox(Handle,PChar('� �� ������ ��� ���� ���� ������ ��������, �� ���, �� ��� ���'),PChar('��� ��� �� �������� � ���������'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=100 then begin
   MessageBox(Handle,PChar('������, ���������, ����������� �������� �� ������� ��� ������� ��������!!!'),PChar('�������� �������� � ��� ��� ��������'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=200 then begin
   MessageBox(Handle,PChar('�� ������, �������� ������ ���� �������������, ������ ��� � �������� @yrkrus ������� ����� "���� ���������" � � ����� ���� ������� ����������'+#13+'�����, � ���� ������� �� ��������!!!'),PChar('����... ��� �� ���� �������� � ����������'),MB_OK+MB_ICONERROR);
 end;

end;

procedure TFormAbout.TimerStartPashalka1Timer(Sender: TObject);
begin
  SetRandomFontColor(lblDevelop);
end;

end.
