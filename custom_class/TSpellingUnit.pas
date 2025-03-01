 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                Класс для описания проверки орфографии                     ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TSpellingUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  TCustomTypeUnit,
  Word_TLB, Winapi.ActiveX,
  RichEdit, ComCtrls, StdCtrls,
  System.Variants,
  Graphics;


 // class TSpelling
  type
      TSpelling = class
      public
      constructor Create(p_Text:TRichEdit);                   overload;

      function isExistErrorSpelling:Boolean;         // true есть ошибка ? false нет ошибки прошли успешно

      private
      m_text              :TRichEdit;

      function isExistSpelling:Boolean;  // есть ли ошибка

      end;
 // class TSpelling END

implementation


constructor TSpelling.Create(p_Text:TRichEdit);
 begin
   m_text:=p_Text;
 end;

// есть ли ошибка
function TSpelling.isExistSpelling;
var
  WordApp: _Application;
  Doc: _Document;
  i: Integer;
  MisspelledWords: OleVariant;
  ErrorWord: string;
  StartPos: Integer;
  OriginalText: string;
begin
  Result:=False; // по умолчяанию считаем что нет ошибок

  OriginalText := m_text.Text;

  // Создаем экземпляр Word
  WordApp := CoWordApplication.Create;
  try
    WordApp.Visible := False;
    Doc := WordApp.Documents.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    Doc.Content.Text := OriginalText;

    // Проверяем правописание
    MisspelledWords := Doc.SpellingErrors;

    // Сначала сбрасываем все атрибуты текста в RichEdit
    m_text.SelectAll;
    m_text.SelAttributes.Color := clBlack; // Цвет текста по умолчанию
    m_text.SelAttributes.Style := []; // Убираем все стили

    // Проходим по списку ошибок
    for i := 1 to MisspelledWords.Count do
    begin
      ErrorWord := MisspelledWords.Item(i).Text;
      StartPos := Pos(ErrorWord, OriginalText);
      while StartPos > 0 do
      begin
        // Устанавливаем выделение на неверное слово
        m_text.SelStart := StartPos - 1; // Позиция в TRichEdit
        m_text.SelLength := Length(ErrorWord);

        // Подчеркиваем и меняем цвет текста
        m_text.SelAttributes.Color := clRed; // Цвет текста
        m_text.SelAttributes.Style := [fsBold]; // Можно добавить стиль для выделения

        // Ищем следующее вхождение неверного слова
        StartPos := Pos(ErrorWord, OriginalText, StartPos + Length(ErrorWord));
      end;

      Result:=True; // Если есть хотя бы одна ошибка, возвращаем True
    end;

    // Закрываем документ
    Doc.Close(False, EmptyParam, EmptyParam);
  finally
    // Закрываем приложение Word
    WordApp.Quit(False, EmptyParam, EmptyParam);
  end;
end;

// true есть ошибка ? false нет ошибки прошли успешно
function TSpelling.isExistErrorSpelling;
begin
  Result:=isExistSpelling;
end;

end.