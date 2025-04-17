unit FormMenuAccessUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormMenuAccess = class(TForm)
    group: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

  procedure Show;


  public
    { Public declarations }
  end;

var
  FormMenuAccess: TFormMenuAccess;

implementation

{$R *.dfm}

procedure  TFormMenuAccess.Show;
begin

end;

procedure TFormMenuAccess.FormShow(Sender: TObject);
begin
  Show;
end;

end.
