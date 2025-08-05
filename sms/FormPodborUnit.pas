unit FormPodborUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  TAutoPodborPeopleUnit;

type
  TFormPodbor = class(TForm)
    Label1: TLabel;
    list_pacients: TListBox;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure list_pacientsDblClick(Sender: TObject);
  private
    { Private declarations }
  listPacients:TAutoPodborPeople;

  procedure LoadData;  // подгрузка данных

  public
    { Public declarations }
  procedure SetListPacients(const _people:TAutoPodborPeople);

  end;

var
  FormPodbor: TFormPodbor;

implementation

uses
  FormGenerateSMSUnit;

{$R *.dfm}


procedure TFormPodbor.SetListPacients(const _people:TAutoPodborPeople);
begin
 listPacients:=_people;
end;

procedure TFormPodbor.FormShow(Sender: TObject);
begin
  LoadData;
end;

procedure TFormPodbor.list_pacientsDblClick(Sender: TObject);
var
 id:Integer;
begin
  id:=list_pacients.ItemIndex;
  if id = -1 then begin
    MessageBox(Handle,PChar('Не выбран пациент'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  FormGenerateSMS.SetAutoPodborValue(listPacients.FirstName(id), listPacients.MidName(id), listPacients.Gender(id));
  Close;
end;

procedure TFormPodbor.LoadData;
var
 i:Integer;
begin
 list_pacients.Clear;
 for i:=0 to listPacients.Count-1 do begin
   list_pacients.Items.Add(listPacients.GetFIO(i));
 end;

end;

end.
