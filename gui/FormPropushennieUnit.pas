unit FormPropushennieUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids;

type
  TFormPropushennie = class(TForm)
    listSG_Propushennie: TStringGrid;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPropushennie: TFormPropushennie;

implementation

uses
  DMUnit, FunctionUnit;

{$R *.dfm}

procedure TFormPropushennie.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  clearList_Propushennie;

  // обновление данных по пропущенным звонкам из очереди
  updatePropushennie;

  Screen.Cursor:=crDefault;
end;

end.
