unit FormPropushennieShowPeopleUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, TAutoPodborPeopleUnit;

type
  TFormPropushennieShowPeople = class(TForm)
    Label1: TLabel;
    list_pacients: TListBox;
    procedure FormShow(Sender: TObject);
 private
    { Private declarations }
  listPacients:TAutoPodborPeople;

  procedure LoadData;  // подгрузка данных

  public
    { Public declarations }
  procedure SetListPacients(const _people:TAutoPodborPeople);
  end;

var
  FormPropushennieShowPeople: TFormPropushennieShowPeople;

implementation


{$R *.dfm}

procedure TFormPropushennieShowPeople.SetListPacients(const _people:TAutoPodborPeople);
begin
 listPacients:=_people;
end;


procedure TFormPropushennieShowPeople.FormShow(Sender: TObject);
begin
 LoadData;
end;

procedure TFormPropushennieShowPeople.LoadData;
var
 i:Integer;
begin
 list_pacients.Clear;
 for i:=0 to listPacients.Count-1 do begin
   list_pacients.Items.Add(listPacients.GetFIO(i));
 end;

end;

end.
