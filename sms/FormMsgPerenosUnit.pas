unit FormMsgPerenosUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids;

type
  TFormMsgPerenos = class(TForm)
    lblMsg: TLabel;
    reMsg: TRichEdit;
    GBLastMEssage: TGroupBox;
    SG: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMsgPerenos: TFormMsgPerenos;

  msg_old:string;

implementation

uses
  FunctionUnit, FormHomeUnit;

{$R *.dfm}

procedure TFormMsgPerenos.FormClose(Sender: TObject; var Action: TCloseAction);
 var
  resultat:Word;
begin
  if msg_old<>reMsg.Text then begin
   // ��������� �����
     resultat:=MessageBox(FormHome.Handle,PChar('��������� ���������� ����� ���������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);

    if resultat=mrYes then begin
       SettingsSaveString(cAUTHconf,'core','msg_perenos',reMsg.Text);
    end;
  end;
end;

procedure TFormMsgPerenos.FormCreate(Sender: TObject);
begin
  GBLastMEssage.Caption:=' ��������� '+IntToStr(cMAXCOUNTMESSAGEOLD)+' ������������ ��������� (����� ������) ';
end;

procedure TFormMsgPerenos.FormShow(Sender: TObject);
begin
   reMsg.Text:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');

   // ��� �������� �������� �� ����� ����� ��������
   msg_old:=reMsg.Text;

   // ��������� ��������� ���������
   LoadMsgMessageOld(cMAXCOUNTMESSAGEOLD);
end;

procedure TFormMsgPerenos.SGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);

  var
  newmsg:string;
begin
    newmsg:=SG.Cells[ACol,ARow];
    if newmsg<>'' then begin
     reMsg.Clear;
     reMsg.Text:=newmsg;
    end;
end;

end.
