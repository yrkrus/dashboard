 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                ����� ��� �������� �������� ����������                     ///
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

      function isExistErrorSpelling:Boolean;         // true ���� ������ ? false ��� ������ ������ �������

      private
      m_text              :TRichEdit;

      function isExistSpelling:Boolean;  // ���� �� ������

      end;
 // class TSpelling END

implementation


constructor TSpelling.Create(p_Text:TRichEdit);
 begin
   m_text:=p_Text;
 end;

// ���� �� ������
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
  Result:=False; // �� ���������� ������� ��� ��� ������

  OriginalText := m_text.Text;

  // ������� ��������� Word
  WordApp := CoWordApplication.Create;
  try
    WordApp.Visible := False;
    Doc := WordApp.Documents.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    Doc.Content.Text := OriginalText;

    // ��������� ������������
    MisspelledWords := Doc.SpellingErrors;

    // ������� ���������� ��� �������� ������ � RichEdit
    m_text.SelectAll;
    m_text.SelAttributes.Color := clBlack; // ���� ������ �� ���������
    m_text.SelAttributes.Style := []; // ������� ��� �����

    // �������� �� ������ ������
    for i := 1 to MisspelledWords.Count do
    begin
      ErrorWord := MisspelledWords.Item(i).Text;
      StartPos := Pos(ErrorWord, OriginalText);
      while StartPos > 0 do
      begin
        // ������������� ��������� �� �������� �����
        m_text.SelStart := StartPos - 1; // ������� � TRichEdit
        m_text.SelLength := Length(ErrorWord);

        // ������������ � ������ ���� ������
        m_text.SelAttributes.Color := clRed; // ���� ������
        m_text.SelAttributes.Style := [fsBold]; // ����� �������� ����� ��� ���������

        // ���� ��������� ��������� ��������� �����
        StartPos := Pos(ErrorWord, OriginalText, StartPos + Length(ErrorWord));
      end;

      Result:=True; // ���� ���� ���� �� ���� ������, ���������� True
    end;

    // ��������� ��������
    Doc.Close(False, EmptyParam, EmptyParam);
  finally
    // ��������� ���������� Word
    WordApp.Quit(False, EmptyParam, EmptyParam);
  end;
end;

// true ���� ������ ? false ��� ������ ������ �������
function TSpelling.isExistErrorSpelling;
begin
  Result:=isExistSpelling;
end;

end.