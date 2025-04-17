unit FormGenerateSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFormGenerateSMS = class(TForm)
    Label1: TLabel;
    comboxReasonSmsMessage: TComboBox;
    group_generate: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Label7: TLabel;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  procedure Clear;
  procedure CreateReasonBox;

  public
    { Public declarations }
  end;

var
  FormGenerateSMS: TFormGenerateSMS;

implementation

uses
  TCustomTypeUnit;

{$R *.dfm}

procedure TFormGenerateSMS.CreateReasonBox;
var
 i:Integer;
 reason:enumReasonSmsMessage;
begin
  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    reason:=enumReasonSmsMessage(i);
    comboxReasonSmsMessage.Items.Add(EnumReasonSmsMessageToString(reason));
  end;
end;

procedure TFormGenerateSMS.Clear;
begin
  comboxReasonSmsMessage.Clear;
end;

procedure TFormGenerateSMS.FormShow(Sender: TObject);
begin
  Clear;

  // создадим выбор вариантов сообщений
  CreateReasonBox;


end;

end.
