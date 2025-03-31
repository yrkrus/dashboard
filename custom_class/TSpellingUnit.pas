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
  System.Classes, System.SysUtils, TCustomTypeUnit, Word_TLB, Winapi.ActiveX,
  RichEdit, ComCtrls, StdCtrls, System.Variants, IdException, Data.Win.ADODB,
  Data.DB, Graphics;


  // class TSpelling
  type
      TSpelling = class
      public
      constructor Create(p_Text:TRichEdit; useInternalDictionary:Boolean);                   overload;
      constructor Create(useInternalDictionary:Boolean);                                     overload;

      function isExistErrorSpelling:Boolean;         // true есть ошибка ? false нет ошибки прошли успешно
      function AddWordToDictionary(AWord: string; var _errorDescription:string):Boolean;  // Добавить слово в словарь

      private
      m_text                  :TRichEdit;
      m_listWordInDictionary  :TStringList;  // лист со словами из словаря
      m_internalDictionary    :Boolean;   // использовать ли внутренний словать

      function isExistSpelling  :Boolean;  // есть ли орфографическая ошибка
      function isExistWordInDictionary(const AWord:string):Boolean;  // есть ли слово в словаре

      function GetCountictionary:Integer;
      function GetWordToDictionary:TStringList;  // получение списка слов из словаря
      function isExistWordToDictionary(const AWord:string; var _errorDescription:string):Boolean;  // есть ли слово уже в словаре


      end;
 // class TSpelling END

implementation

uses
  GlobalVariables;

const
 MAX_LENGHT_DICTIONARY :Word = 30;


constructor TSpelling.Create(p_Text:TRichEdit; useInternalDictionary:Boolean);
 begin
   m_text:=p_Text;
   m_internalDictionary:=useInternalDictionary;
   m_listWordInDictionary:=GetWordToDictionary;
 end;

 constructor TSpelling.Create(useInternalDictionary:Boolean);
 begin
   m_internalDictionary:=useInternalDictionary;
   m_listWordInDictionary:=GetWordToDictionary;
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
    m_text.SelAttributes.Color := clBlack;  // Цвет текста по умолчанию
    m_text.SelAttributes.Style := [];       // Убираем все стили

    // Проходим по списку ошибок
    for i := 1 to MisspelledWords.Count do
    begin
      ErrorWord := MisspelledWords.Item(i).Text;

      // проверим есть ли  унас такое слово в словаре
      if m_internalDictionary then begin
        if isExistWordInDictionary(ErrorWord) then Continue;
      end;

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


function TSpelling.isExistWordInDictionary(const AWord:string):Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_listWordInDictionary.Count-1 do begin
    if m_listWordInDictionary[i] = AWord then begin
     Result:=True;
     Exit;
    end;
  end;
end;


function TSpelling.GetCountictionary:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from sms_dictionary');

      Active:=True;
      Result:=Fields[0].Value;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// получение списка слов из словаря
function TSpelling.GetWordToDictionary:TStringList;  // получение списка слов из словаря
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countDictionary:Integer;
 i:Integer;
begin
  Result:=TStringList.Create;

  countDictionary:=GetCountictionary;
  if countDictionary = 0 then Exit;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select word from sms_dictionary');

      Active:=True;

      for i:=0 to countDictionary-1 do begin
        Result.Add(VarToStr(Fields[0].Value));

        ado.Next;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// есть ли слово уже в словаре
function TSpelling.isExistWordToDictionary(const AWord:string; var _errorDescription:string):Boolean;
var
 i:Integer;
begin
  Result:=False;
  _errorDescription:='';

  if Length(AWord) = MAX_LENGHT_DICTIONARY then begin
     Result:=True;
    _errorDescription:='Слишком длинное слово';
    Exit;
  end;

  for i:=0 to m_listWordInDictionary.Count-1 do begin
    if AWord = m_listWordInDictionary[i] then begin
      Result:=True;
      _errorDescription:='Слово уже есть в словаре';
      Exit;
    end;
  end;
end;


// true есть ошибка ? false нет ошибки прошли успешно
function TSpelling.isExistErrorSpelling;
begin
   Result := False;

  // Сначала проверяем орфографию
  if isExistSpelling then  Result:= True;
end;


// Добавить слово в словарь
function TSpelling.AddWordToDictionary(AWord: string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 response:string;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем есть ли слово в словаре это конечно мало вероятно что  такое будет но на вский случай
   AWord:=StringReplace(AWord,' ','',[rfReplaceAll]);

  if isExistWordToDictionary(AWord,_errorDescription) then begin
    Exit;
  end;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  response:='insert into sms_dictionary (user_id,word) values ('+#39+IntToStr(USER_STARTED_SMS_ID)+#39+','+#39+AWord+#39+')';

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(response);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               _errorDescription:=e.ClassName+' '+e.Message;

               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;
               Exit;
            end;
        end;
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
  _errorDescription:='Слово добавлено в словарь';
  Result:=True;
end;


end.