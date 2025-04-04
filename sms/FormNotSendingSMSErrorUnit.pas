unit FormNotSendingSMSErrorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.ExtCtrls,IdException;

type
  TFormNotSendingSMSError = class(TForm)
    panel_Error: TPanel;
    re_LogError: TRichEdit;
    btnLoadFile: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
  private
    { Private declarations }

  procedure CreateLogAddColoredLine(var p_Log: TRichEdit;
                                    InMessageError: string; InColorError: TColor;
                                    InMessage: string; InColor: TColor);

  procedure ShowError;
  function SaveFile(var _errorDescription:string):Boolean;

  public
    { Public declarations }
  end;

var
  FormNotSendingSMSError: TFormNotSendingSMSError;

implementation

uses
  GlobalVariables, FunctionUnit;

{$R *.dfm}


// ����������� ���� � �������� ��������
procedure TFormNotSendingSMSError.btnLoadFileClick(Sender: TObject);
var
 error:string;
begin
  if re_LogError.Lines.Count = 0 then Exit;

  if not SaveFile(error) then begin
   MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  if error<>'' then begin
    MessageBox(Handle,PChar(error),PChar('�����'),MB_OK+MB_ICONINFORMATION);
    Close;
  end;
end;

procedure TFormNotSendingSMSError.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShowError;
  Caption:='������ ('+IntToStr(SharedPacientsListNotSending.Count)+')';

  Screen.Cursor:=crDefault;
end;


procedure TFormNotSendingSMSError.CreateLogAddColoredLine(var p_Log: TRichEdit;
                                  InMessageError: string; InColorError: TColor;
                                  InMessage: string; InColor: TColor);
begin
 with p_Log do
  begin
    // ������������� ������ � ����� ������
    SelStart := Length(Text);

    // ��������� ������ ��������� � ������ ������
    SelAttributes.Color := InColorError;
    SelAttributes.Size := 10;
    SelAttributes.Name := 'Tahoma';
    SelText := InMessageError; // ���������� SelText ��� ���������� ������

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



procedure TFormNotSendingSMSError.ShowError;
var
 i:Integer;
begin
  // ������� ������, ����� ��� ��� ����� ���������
  re_LogError.Clear;

  for i:=0 to SharedPacientsListNotSending.Count-1 do begin
    CreateLogAddColoredLine(re_LogError,
                            SharedPacientsListNotSending.GetErrorDescriptions(i),clRed,
                            SharedPacientsListNotSending.ShowPacientInfo(i),clBlack);
  end;

  re_LogError.SelStart:=0;
end;

// ���������� �����
function TFormNotSendingSMSError.SaveFile(var _errorDescription:string):Boolean;
var
  SaveDialog: TSaveDialog;
  FileName: string;
begin
  Result:=False;
  _errorDescription:='';

  SaveDialog := TSaveDialog.Create(nil);
  try
      // ������������� ������ ��� ����� ������
      SaveDialog.Filter := 'Rich Text Format (*.rtf)|*.rtf';
      SaveDialog.DefaultExt := 'rtf'; // ������������� ���������� �� ���������
      SaveDialog.Title := '��������� � ���� ... ';

      // ���������� ������ � ���������, ��� �� ������ ����
      if SaveDialog.Execute then
      begin
        try
          re_LogError.Lines.SaveToFile(SaveDialog.FileName);
        except on E: EIdException do
          begin

           _errorDescription:='�� ������� ��������� � ����'+#13#10+SaveDialog.FileName+#13#13+
                              e.ClassName+': '+E.Message;
           SaveDialog.Free;
           Exit;
          end;
       end;
      end;
  finally
    if SaveDialog.FileName<>'' then _errorDescription:='��������� � '+#13+SaveDialog.FileName;
    SaveDialog.Free;
  end;

  Result:=True;
end;
end.
