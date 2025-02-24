unit FormListSendingSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormListSendingSMS = class(TForm)
    lblMsg: TLabel;
    ST_StatusPanel: TStaticText;
    panel_ListSMS: TPanel;
    re_ListSendingSMS: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure re_ListSendingSMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure re_ListSendingSMSKeyPress(Sender: TObject; var Key: Char);
  private
    procedure UpdateLineCount;
    { Private declarations }
  public
   m_left:Integer;
   m_top:Integer;

    { Public declarations }
  end;

var
  FormListSendingSMS: TFormListSendingSMS;

implementation

uses
  FormHomeUnit, GlobalVariables;

{$R *.dfm}

procedure TFormListSendingSMS.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i:Integer;
begin
  UpdateLineCount;

  SharedSendindPhoneManualSMS.Clear;

  for i:=0 to re_ListSendingSMS.Lines.Count-1 do begin
    SharedSendindPhoneManualSMS.Add(re_ListSendingSMS.Lines[i]);
  end;
end;

procedure TFormListSendingSMS.FormShow(Sender: TObject);
var
 i:Integer;
begin
  Left:=m_left;
  Top:=m_top;

  re_ListSendingSMS.Clear;
  if SharedSendindPhoneManualSMS.Count<>0 then begin
    for i:=0 to SharedSendindPhoneManualSMS.Count-1 do begin
      re_ListSendingSMS.Lines.Add(SharedSendindPhoneManualSMS[i]);
    end;
  end;
end;


procedure TFormListSendingSMS.re_ListSendingSMSKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    UpdateLineCount; // Обновляем количество строк
  end;
end;

procedure TFormListSendingSMS.re_ListSendingSMSKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8, #13]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
end;

procedure TFormListSendingSMS.UpdateLineCount;
var
  LineCount: Integer;
begin
  LineCount := re_ListSendingSMS.Lines.Count;
  if LineCount = 0 then begin
    FormHome.lblManualSMS_List.Caption:='списком';
    Exit;
  end;

  FormHome.lblManualSMS_List.Caption:='списком ('+IntToStr(LineCount)+')';
end;


end.
