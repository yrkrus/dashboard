unit FormSendingSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormSendingSMS = class(TForm)
    panel: TPanel;
    re_LogSending: TRichEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  procedure Show;

  procedure CreateLogAddColoredLine(var p_Log: TRichEdit;
                                    InMessagePhone: string; InColorPhone: TColor;
                                    InMessage: string; InColor: TColor);

  public
    { Public declarations }
  end;

var
  FormSendingSMS: TFormSendingSMS;

implementation

uses
  GlobalVariables;

{$R *.dfm}



procedure TFormSendingSMS.CreateLogAddColoredLine(var p_Log: TRichEdit;
                                                  InMessagePhone: string; InColorPhone: TColor;
                                                  InMessage: string; InColor: TColor);
begin
 with p_Log do
  begin
    // ������������� ������ � ����� ������
    SelStart := Length(Text);

    // ��������� ������ ��������� � ������ ������
    SelAttributes.Color := InColorPhone;
    SelAttributes.Size := 10;
    SelAttributes.Name := 'Tahoma';
    SelText := InMessagePhone; // ���������� SelText ��� ���������� ������

    // ��������� ��� �������
    SelText := '   ';

    // ��������� ������ ��������� � ������ ������
    SelAttributes.Color := InColor;
    SelText := InMessage; // ���������� SelText ��� ���������� ������

    // ��������� � ��������� ������
    Perform(EM_LINESCROLL, 0, Lines.Count - 1);
    Lines.Add('');
    SetFocus;
  end;
end;



procedure TFormSendingSMS.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  Show;

  Screen.Cursor:=crDefault;
end;

procedure TFormSendingSMS.Show;
var
 i:Integer;
begin
  // ������� ������, ����� ��� ��� ����� ���������
  re_LogSending.Clear;

  for i:=0 to SharedPacientsList.Count-1 do begin

    CreateLogAddColoredLine(re_LogSending,
                            SharedPacientsList.GetPhone(i),clGreen,
                            SharedPacientsList.CreateMessage(i, REMEMBER_MESSAGE),clBlack);
  end;

  re_LogSending.SelStart:=0;
end;

end.
