unit FormServiceChoiseListUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst;

type
  TFormServiceChoiseList = class(TForm)
    chklist_choise: TCheckListBox;
    btnDelete: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure chklist_choiseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  procedure LoadChoise;
  procedure ShowButtonCaptionCount(_count:Integer = 0);
  function CountsChoiseDelete:Integer;

  public
    { Public declarations }
  end;

var
  FormServiceChoiseList: TFormServiceChoiseList;

implementation

uses
  FormGenerateSMSUnit, FormServiceChoiseUnit;

{$R *.dfm}


procedure TFormServiceChoiseList.ShowButtonCaptionCount(_count:Integer = 0);
var
 count:string;
begin
  if _count = 0  then count:=''
  else count:=' ('+IntToStr(_count)+')';

  btnDelete.Caption:=' &������� ���������'+count;
end;


procedure TFormServiceChoiseList.LoadChoise;
var
 i:Integer;
begin
  chklist_choise.Items.Clear;

  for i:=0 to FormGenerateSMS.GetCountServiceChoise - 1 do begin
    chklist_choise.Items.Add(FormGenerateSMS.GetServiceChoise(i));
  end;
end;

// ���-�� �� ��������
function TFormServiceChoiseList.CountsChoiseDelete:Integer;
var
 i:Integer;
 counts:Integer;
begin
  counts:=0;
  for i:=0 to chklist_choise.Items.Count-1 do begin
    if chklist_choise.Checked[i] then Inc(counts);
  end;

  Result:=counts;
end;

procedure TFormServiceChoiseList.btnDeleteClick(Sender: TObject);
var
 i:Integer;
begin
   if CountsChoiseDelete = 0 then begin
     MessageBox(Handle,PChar('�� ������� ������ ��� ��������'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   for i:=chklist_choise.Items.Count-1 downto 0 do begin
     if chklist_choise.Checked[i] then begin

      // ������ �� ������
      FormGenerateSMS.DelServiceChoise(chklist_choise.Items[i]);
      chklist_choise.Items.Delete(i);
     end;
   end;

   ShowButtonCaptionCount;
end;

procedure TFormServiceChoiseList.chklist_choiseClick(Sender: TObject);
begin
  ShowButtonCaptionCount(CountsChoiseDelete);
end;

procedure TFormServiceChoiseList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // ������� ���-�� ��������� ���� ����� ��� �� �������
  FormServiceChoise.lblChoiseCount.Caption:='������� ����� : '+IntToStr(FormGenerateSMS.GetCountServiceChoise);
end;

procedure TFormServiceChoiseList.FormShow(Sender: TObject);
begin
   // ���������� ���������
   LoadChoise;

   // ���-�� �� ��������
   ShowButtonCaptionCount;
end;

end.
