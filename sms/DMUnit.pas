unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Menus,
  Winapi.Windows, Vcl.Controls, Vcl.ComCtrls;

type
  TDM = class(TDataModule)
    popmenu_AddSpellnig: TPopupMenu;
    menu_AddSpelling: TMenuItem;
    menu_Dictionary: TMenuItem;
    N1: TMenuItem;
    menu_Copy: TMenuItem;
    menu_Paste: TMenuItem;
    procedure menu_AddSpellingClick(Sender: TObject);
    procedure menu_DictionaryClick(Sender: TObject);
  private
    { Private declarations }
  FRichEdit: TRichEdit; // ���� ��� �������� ������ �� TRichEdit

  public
    { Public declarations }
  maybeDictionary:string; // ����� ������� ����� ����� � �������
  property RichEdit: TRichEdit read FRichEdit write FRichEdit; // �������� ��� ������� � TRichEdit


  end;

var
  DM: TDM;

implementation

uses
  TSpellingUnit, FormDictionaryUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.menu_AddSpellingClick(Sender: TObject);
var
  resultat:Word;
  Spelling:TSpelling;
  error:string;
begin
  resultat:=MessageBox(0,PChar('����� �������� ����� "'+maybeDictionary+'" � �������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrYes then begin
    Spelling:=TSpelling.Create(FRichEdit, True);

    if not Spelling.AddWordToDictionary(maybeDictionary, error) then begin
      MessageBox(0,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
      Exit;
    end
    else MessageBox(0,PChar(error),PChar('�����'),MB_OK+MB_ICONINFORMATION);
  end;
end;

procedure TDM.menu_DictionaryClick(Sender: TObject);
begin
  FormDictionary.ShowModal;
end;

end.
