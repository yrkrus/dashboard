unit FormHistoryCallOperatorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TFormHistoryCallOperator = class(TForm)
    panel_History: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

  procedure Show;
  public
    { Public declarations }
  end;

var
  FormHistoryCallOperator: TFormHistoryCallOperator;

implementation

{$R *.dfm}

procedure TFormHistoryCallOperator.Show;
begin

end;

procedure TFormHistoryCallOperator.FormShow(Sender: TObject);
begin
  Show;
end;

end.
