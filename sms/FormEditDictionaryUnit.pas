unit FormEditDictionaryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormEditDictionary = class(TForm)
    lblMsg: TLabel;
    re_Edit: TRichEdit;
    procedure re_EditKeyPress(Sender: TObject; var Key: Char);
    procedure re_EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure re_EditChange(Sender: TObject);
  private
    { Private declarations }
  idWord:Integer;  // id слова по БД
  oldWord:string; // старое слово
  newWord:string; // новое слово

  procedure Clear;
  procedure MoveCursorToEndOfWord(var RichEdit: TRichEdit);

  public
    { Public declarations }
  procedure SetOldWord(_id:Integer; _word:string);

  end;

var
  FormEditDictionary: TFormEditDictionary;

implementation

uses
  FunctionUnit, FormDictionaryUnit;

{$R *.dfm}


procedure TFormEditDictionary.MoveCursorToEndOfWord(var RichEdit: TRichEdit);
begin
  RichEdit.SelStart := Length(RichEdit.Text);
end;


procedure TFormEditDictionary.Clear;
begin
  idWord:=0;
  oldWord:='';
  newWord:='';
end;

procedure TFormEditDictionary.SetOldWord(_id:Integer; _word:string);
begin
  idWord:=_id;
  oldWord:=_word;
end;


procedure TFormEditDictionary.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 error:string;
begin
  if (newWord = '') or (newWord = oldWord) then begin
    Clear;
  end
  else begin
    if not SaveWord(idWord, newWord, error, False) then begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end;
    // обновляем данные
   FormDictionary.ShowData;

   Clear;
  end;
end;

procedure TFormEditDictionary.FormShow(Sender: TObject);
begin
  re_Edit.Clear;
  re_Edit.Text:=oldWord;

  // курсор в конец слова
  MoveCursorToEndOfWord(re_Edit);
end;

procedure TFormEditDictionary.re_EditChange(Sender: TObject);
begin
 newWord:=re_Edit.Text;
end;

procedure TFormEditDictionary.re_EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 // Проверяем, является ли нажатая клавиша пробелом или Enter
  if (Key = VK_SPACE) or (Key = VK_RETURN) then
  begin
    // Если это пробел или Enter, отменяем его ввод
    Key := 0; // Устанавливаем Key в 0, чтобы игнорировать ввод
  end;
end;

procedure TFormEditDictionary.re_EditKeyPress(Sender: TObject; var Key: Char);
begin
  // Проверяем, является ли нажатая клавиша пробелом
  if (Key = ' ') or
     (Key = #13) or
     (Key = #$D) then
  begin
    // Если это пробел, отменяем его ввод
    Key := #0; // Устанавливаем Key в #0, чтобы игнорировать ввод
  end;
end;

end.
