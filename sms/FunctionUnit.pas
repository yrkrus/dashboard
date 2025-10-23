unit FunctionUnit;

interface

uses
    FormHomeUnit, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
    Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
    IdSSL,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,System.IniFiles,
    Winapi.WinSock,  Vcl.ComCtrls, GlobalVariables, Vcl.Grids, Data.Win.ADODB,
    Data.DB, IdException, TPacientsListUnit, Vcl.Menus, System.SyncObjs,
    TCustomTypeUnit, Word_TLB, ActiveX, FormGenerateSMSUnit, Winapi.RichEdit,
    Vcl.Imaging.Jpeg, System.IOUtils, Vcl.ExtCtrls;


function GetSMS(inPacientPhone:string):string; overload;                                      // отправка смс v2
function GetSMSStatusID(inPacientPhone:string):string;                                        // проверка смс статуса
procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);                         // парсинг и создание формы инфо статуса сообщения
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;                             // кол-во смс которые были отправлены



// проверенные
function LoadData(InFileExcel:string; var _errorDescription:string;
                  var p_Status:TStaticText;
                  var p_CountSending:TLabel;
                  var p_CountNotSending:TLabel):Boolean;                                      // загрузка excel
procedure OptionsStyle(InOptionsType:enumSendingOptions);                                     // выбор типа отправляемого смс
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;    // проверка корректности номера телефона при вводе
procedure ClearManagerSymbolsPhoneMessage(var p_list:TStringList);                            // очитска номера телефона от управляющих символов
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions;
                                  _isEditMessage:Boolean;
                                  var _errorDescription:string):Boolean; // проверка данных перед отправкой
function IsPunctuationOrDigit(ch: Char;
                              InCheckOnlyPunctuation:Boolean = False;
                              InCheckMinimalPunctuation:Boolean=False): Boolean;      // проверка на знак припенания или цифру
function IsOnlyNumber(ch: Char): Boolean;                                                     // проверка только на цифру цифру
function IsLetter(ch: Char): Boolean;                                                         // проверка только на букву
function IsLetterENG(ch: Char): Boolean;                                                      // проверка только на букву (ENG)
function IsFirstCharUpperCyrillic(const S: string): Boolean;                                  // проверка что первая буква это заглавная буква
function isExistSpaceWithLine(const S: string): Boolean;                                      // проверка на пробел в конце строки
function isWordExistPunctuation(var _stroka:TRichEdit; var _errorDescription:string):Boolean; // проверка чтобы не было типа таких слов (Алексеевна,добрый | ,Огуречников | г.Волжском)
function CreateSMSMessage(var InMessage:TRichEdit):string;                                    // правка сообщения чтобы оно было в 1 строку
function SendingMessage(InOptionsType:enumSendingOptions;
                        _reasonSMS:enumReasonSmsMessage;
                        var _errorDescription:string):Boolean; // отправка сообщения
procedure ClearParamsForm(InOptionsType:enumSendingOptions);                                  // очистка полей формы
procedure ShowOrHideLog(InOptions:enumFormShowingLog);                                        // ототбражать или скрывать лог
function isExistExcel(var _errorDescriptions:string):Boolean;                                 // проверка установлен ли excel
procedure CreateCopyright;                                                                    // создание Copyright
procedure ShowCountTodaySmsSending;                                                           // подсчет сколько за сегодня отправлено смс было
procedure ShowSaveTemplateMessage(var p_PageControl:TPageControl;
                                  var p_ListView:TListView;
                                  InTemplate:enumTemplateMessage;
                                  var p_NoMessageInfo:TStaticText);                           // очистка шаблонов сообщений
procedure ClearListView(var p_ListView:TListView);                                            // очистка StringGrid
procedure SaveMyTemplateMesaage(InMessage:string; IsGlobal:Boolean = False);                  // запись в шалблоны отправленного сообщения
function isExistMyTemplateMessage(InMessage:string; isGlobal:Boolean = False):Boolean;        // есть ли такое сообщение уже в шаблонах сообщений
function isValidPacientFields(var Pacient:TListPacients):Boolean;                             // проверка на корректность записи из excel файла
procedure ClearTabs(InOptionsType:enumSendingOptions);                                        // очистка окон после отправки
procedure AddMessageFromTemplate(InMessage:string);                                           // добавление сообщения на отправку из шаблонов сообщений
procedure SaveMyTemplateMessage(id:Integer; InNewMessage:string; IsDelete:Boolean = False);   // редактирование сообщения в сохраненных шаблонов
procedure SendingRemember(isShowLog:Boolean; var _executeTime:Cardinal);                      // отправка рассылки sms о напоминании приема
procedure SignSMS;                                                                            // есть ли возможность вставлять подпись в СМС сообщение
procedure CreatePopMenuAddressClinic(var p_PopMenu:TPopupMenu; var p_Message:TRichEdit);      // создание списка с адресами клиник для быстрого доступа к ним
procedure ShowSendingManualPhone(InSendingType:enumManualSMS);                                // выбор типа при ручной отправки SMS (1 SMS или списком)
procedure showWait(Status:enumShow_wait);                                                     // отображение\сркытие окна запроса на сервер
function IsExistSpellingColor(var _MaybeDictionaryWord:string; var p_text:TRichEdit):Boolean; // проверка можно ли показать меню на добавление слова в словарь
function SaveWord(_id:Integer;
                    InNewMessage:string;
                    var _errorDescription:string;
                    IsDelete:Boolean = False):Boolean;  // редактирование слова
function IsExistSignInMessage(const _message:string):Boolean;                                 // проверка есть ли подпись в отправляемом сообщении
function ParsePhoneNumber(const PhoneNumber: string):string;                                  // пасинг номера тлф при вствке в поле номер телефона
function GetUserSIP(_idUser:integer):string;                                                 // отображение SIP пользвоателя
procedure SetRandomFontColor(var p_label: TLabel);                                            // изменение цвета надписи
function SetFindDate(var _startDate:TDateTimePicker;
                     var _stopDate:TDateTimePicker;
                     var _errorDescriptions:string):Boolean;                                 // установка дата начала и конца времени отбора
function SaveResultSendingSMS(var _panel:TPanel; _path:string;
                              var _errorDescription:string):Boolean;                             // сохранение результата отправки на диске в jpg
procedure AddCustomCheckBoxUI;                                                               // подгрузка своих красивых чекбоксов

implementation

uses
  FormMyTemplateUnit, TSendSMSUint, TAddressClinicPopMenuUnit, TThreadSendSMSUnit, TSpellingUnit, GlobalVariablesLinkDLL, FormWaitUnit, DMUnit, GlobalImageDestination, FormManualPodborUnit;



// проверка корректности номера телефона при вводе
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;
var
 telefon:string;
 i:Integer;
begin
  Result:=False;
  _errorDEscription:='';

  telefon:=InNumberPhone;

   // номер должен начинаться с 8
   if telefon[1]<>'8' then begin
    _errorDescription:='Номер телефона "'+telefon+'" должен начинаться с 8';
    Exit;
   end;

   // длина
   if (Length(telefon)<>11) then begin
    _errorDescription:='Некорректный номер телефона "'+telefon+'"'+#13#13+
                       'Длина номера телефона должна быть 11 символов'+#13+'сейчас длина '+IntToStr(Length(telefon))+' символов';
     Exit;
   end;

   // проверка что бы были только цифры
   for i:=1 to Length(telefon) do begin
     if not IsOnlyNumber(telefon[i]) then begin
       _errorDescription:='Номер телефона "'+telefon+'" должен содержать только цифры';
        Exit;
     end;
   end;


   Result:=True;
end;


// проверка на знак припенания или цифру
function IsPunctuationOrDigit(ch: Char; InCheckOnlyPunctuation:Boolean = False; InCheckMinimalPunctuation:Boolean=False): Boolean;
begin
  if InCheckOnlyPunctuation then begin
     if not InCheckMinimalPunctuation then Result := (ch in [',', '.', '!', '?', ';', ':', '-', '(', ')', '[', ']', '{', '}', '''', '"', '<', '>'])
     else Result := (ch in [',', '.', '!', '?']);
  end
  else begin
    Result := (ch in [',', '.', '!', '?', ';', ':', '-', '(', ')', '[', ']', '{', '}', '''', '"', '<', '>']) or
              (ch >= '0') and (ch <= '9');
  end;
end;

// проверка на пробел в конце строки
function isExistSpaceWithLine(const S: string): Boolean;
begin
  Result := EndsStr(' ', S);
end;

// проверка только на цифру цифру
function IsOnlyNumber(ch: Char): Boolean;
begin
  Result := (ch in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']);
end;


// проверка только на букву
function IsLetter(ch: Char): Boolean;
var
  code: Integer;
begin
  code:=Ord(ch);     // А-1040  Я-1071   а-1072   я-1103
  Result:=((code >= 1040) or (code <= 1103));
  //Result := ((code >= 1040) and (code <= 1071)) or ((code >= 1072) and (code <= 1106));

end;


// проверка только на букву (ENG)
function IsLetterENG(ch: Char): Boolean;
var
  code: Integer;
begin
  code:=Ord(ch);     // А-65  Z-90   а-97   z-122
  Result := ((code >= 65) and (code <= 90)) or ((code >= 97) and (code <= 122));
end;

// проверка что первая буква это заглавная буква
function IsFirstCharUpperCyrillic(const S: string): Boolean;
var
  FirstChar:Char;
begin
  Result:=False;

  if Length(S) = 0 then Exit;
  FirstChar:=S[1];

  if (ord(FirstChar) >= 1040) and
     (ord(FirstChar) <= 1071) then Result:=True;

end;


function GetWordAtPosition(const S: string; pos: Integer): string;
var
  countPos: Integer;
  startPosition:Integer;
begin
  // Проверяем, что позиция находится в пределах строки
  if (pos < 1) or (pos > Length(S)) then
  begin
    Result := '';
    Exit;
  end;

  // Находим конец слова
  countPos := 0;
  startPosition:=pos;
  while IsLetter(S[startPosition]) and not isExistSpaceWithLine(S[startPosition]) do begin
   Inc(countPos);
   Inc(startPosition);
  end;

  // Извлекаем слово
  Result := Copy(S, pos+1, countPos-1);
end;

// проверка чтобы не было типа таких слов (Алексеевна,добрый | ,Огуречников | г.Волжском)
function isWordExistPunctuation(var _stroka:TRichEdit; var _errorDescription:string):Boolean;
var
  i,startPos: Integer;
  message_tmp,word: string;
begin
  Result := True;  // По умолчанию считаем, что есть ошибки
  _errorDescription := '';

  // Подправим сообщение, чтобы оно было в одну строчку
  message_tmp := CreateSMSMessage(_stroka);

  // Проверка на пустую строку
  if Trim(message_tmp) = '' then
  begin
    _errorDescription := 'Сообщение не должно быть пустым';
    Exit;
  end;

   // Сначала сбрасываем все атрибуты текста в RichEdit
  _stroka.SelectAll;
  _stroka.SelAttributes.Color := clBlack; // Цвет текста по умолчанию
  _stroka.SelAttributes.Style := [];      // Убираем все стили


  for i := 1 to Length(message_tmp) do
  begin
     if isExistSpaceWithLine(message_tmp[i]) then Continue;

    // Проверяем, если текущий символ — буква
    begin
      // Проверяем, если следующий символ — не пробел, а за ним знак препинания
      if (i < Length(message_tmp)) then
      begin
         // если след. символ это цифра то пропускаем
        if i+1 < Length(message_tmp) then begin
          if IsOnlyNumber(message_tmp[i+1]) then Continue;
        end;

        // пропускаем если это латинские буквы
        if i+1 < Length(message_tmp) then begin
          if IsLetterENG(message_tmp[i+1]) then Continue;
        end;

        if (not isExistSpaceWithLine(message_tmp[i+1])) and
           IsPunctuationOrDigit(message_tmp[i],True,True) then
        begin

          // Извлекаем словосочетание
           word := GetWordAtPosition(message_tmp, i);
          _errorDescription := Format('Между словом "%s" и знаком препинания "%s" должен быть пробел',
                                      [word, message_tmp[i]]);

          // Подкрашиваем слово
          startPos := i - 1; // чтобы захватить и знак препинания   // Позиция начала слова
          _stroka.SelStart := startPos;           // Устанавливаем начало выделения
          _stroka.SelLength := Length(word)+1;      // Устанавливаем длину выделения
          _stroka.SelAttributes.Color := clBlue;  // Устанавливаем цвет слова
          _stroka.SelAttributes.Style := [fsBold];

          Exit;
        end;
      end;
    end;

    // Проверка на конец сообщения
    if (i = Length(message_tmp)) then
    begin
      if IsPunctuationOrDigit(message_tmp[i], True) then
      begin
        _errorDescription := 'Сообщение не должно заканчиваться знаком препинания';
        Exit;
      end;
    end;
  end;

  Result := False; // Если ошибок не найдено, возвращаем False
end;


// очитска номера телефона от управляющих символов
procedure ClearManagerSymbolsPhoneMessage(var p_list:TStringList);
var
 i:Integer;
begin
  for i:=0 to p_list.Count-1 do begin
    p_list[i] := StringReplace(p_list[i], #$D, '', [rfReplaceAll]);
    p_list[i] := StringReplace(p_list[i], #$A, '', [rfReplaceAll]);
  end;
end;


// проверка данных перед отправкой
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions; _isEditMessage:Boolean;  var _errorDescription:string):Boolean;
var
 i:Integer;
 temp_message:string;
 SMS:TSendSMS;
 Spelling:TSpelling;
 resultat:Word;
begin
  Result:=False;
  _errorDescription:='';

  // что именно проверяем
   with FormHome do begin
      case InOptionsType of
        options_Manual:begin  // ручная отправка

         // телефон
         if SharedSendindPhoneManualSMS.Count = 0 then begin
            _errorDescription:='Пустой номер телефона';
            Exit;
         end;

          // проверим длинну сообщения чтобы была не очень длинное
          SMS:=TSendSMS.Create(DEBUG);
          if SMS.IsMessageToLong(re_ManualSMS.Text) then begin
            _errorDescription:='Кто ты воин!?'+#13+
                               'Программа обалдела от такого длинного сообщения!'+#13#13+
                               'крч, надо уменьшить длину сообщения до 670 символов именно столько максимально она может переварить';
            Exit;
          end;

         // очищаем от управляющих сиволов (вдруг тупо скопировали номер тлф)
         ClearManagerSymbolsPhoneMessage(SharedSendindPhoneManualSMS);

         // сообщение не редактируемое значит оно пришло из генератора или из шаблона, пропускаем все проверки остальные
         if not _isEditMessage then begin
           Result:=True;
           Exit;
         end;


         for i:=0 to SharedSendindPhoneManualSMS.Count-1 do begin
          if not isCorrectNumberPhone(SharedSendindPhoneManualSMS[i],_errorDescription) then begin
            Exit;
          end;
         end;

         if (IsPunctuationOrDigit(re_ManualSMS.Text[1])) or
            (re_ManualSMS.Text[1] = ' ') then begin
            _errorDescription:='Сообщение не должно начинаться со знака препинания, пробела или цифры';
            Exit;
         end;

         if (IsPunctuationOrDigit(re_ManualSMS.Text[Length(re_ManualSMS.Text)], True)) then begin
            _errorDescription:='Сообщение не должно заканчиваться знаком препинания';
            Exit;
         end;

         if isExistSpaceWithLine(re_ManualSMS.Text) then begin
            _errorDescription:='Сообщение не должно заканчиваться пробелом';
            Exit;
         end;

         // проверка чтобы собощение было с заглавной буквы
         if not IsFirstCharUpperCyrillic(re_ManualSMS.Text) then begin
           _errorDescription:='Сообщение должно начинаться с заглавной буквы';
            Exit;
         end;

         // проверка чтобы не было типа таких соощений (Алексеевна,добрый | ,Огуречников | г.Волжском)
         if isWordExistPunctuation(re_ManualSMS, _errorDescription) then begin
           Exit;
         end;

         if not SharedCheckBox.Checked['SignSMS'] then begin
           resultat:=MessageBox(Handle,PChar('Не установлена галка "вставить подпись в конце SMS"'+#13#13+
                                             'Это так и задумано?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);

           if resultat = mrNo then begin
             _errorDescription:='Действие отменено';
             Exit;
           end;
         end
         else begin
           // проверим чтобы в тексте не было подписи уже
           if IsExistSignInMessage(re_ManualSMS.Text) then begin
            _errorDescription:='В тексте сообщения присутствует подпись,'+#13+
                               'уберите подпись или снимите галку "вставить подпись в конце SMS"';
             Exit;
           end;
         end;

          // проверка орфографии
          Spelling:=TSpelling.Create(re_ManualSMS, True);
          if Spelling.isExistErrorSpelling then begin
            _errorDescription:='В тексте сообщения присутствуют орфографические ошибки!'+#13+
                               'Если ошибки нет, добавьте слово в словарь'+#13+
                               'ВАЖНО! Не нужно бездумно все слова добавлять'+#13#13#13+
                               'Выберите слово, нажмите пр.кл.мыши и выбрите "добавить в словарь"';
            Exit;
          end;


        end;
        options_Sending:begin // рассылка
           if SharedPacientsList.Count = 0 then begin
             _errorDescription:='Не загружен excel файл с рассылкой';
             Exit;
           end;
        end;
        options_Find:begin // поиск статуса сообщения
         // телефон
         if SharedStatusSendingSMS.Count = 0 then begin
            _errorDescription:='Пустой номер телефона';
            Exit;
         end;

         // очищаем от управляющих сиволов (вдруг тупо скопировали номер тлф)
         ClearManagerSymbolsPhoneMessage(SharedStatusSendingSMS);

         if not isCorrectNumberPhone(SharedStatusSendingSMS[0],_errorDescription) then begin
           Exit;
         end;
        end;
      end;
   end;

  Result:=True;
end;

// правка сообщения чтобы оно было в 1 строку
function CreateSMSMessage(var InMessage:TRichEdit):string;
var
 i:Integer;
 tmp:string;
begin
  tmp:='';
  for i:=0 to InMessage.Lines.Count-1 do begin
    if tmp='' then tmp:=InMessage.Lines[i]
    else tmp:=tmp + InMessage.Lines[i];
  end;

  tmp := StringReplace(tmp, #$D, '', [rfReplaceAll]);
  tmp := StringReplace(tmp, #$A, '', [rfReplaceAll]);

  Result:=tmp;
end;

// отправка сообщения
function SendingMessage(InOptionsType:enumSendingOptions; _reasonSMS:enumReasonSmsMessage; var _errorDescription:string):Boolean;
var
 SMS:TSendSMS;
 SMSMessage:string;
 phone:string;
 addSign:Boolean;
 showLog:Boolean;
 sendindManualReportError:TStringList;
 i:Integer;
 isExistError:Boolean;
 executionTime:Cardinal;
begin
  Result:=False;
  _errorDescription:='';

  case InOptionsType of
    options_Manual:begin  // ручная отправка
      SMS:=TSendSMS.Create(DEBUG);
      if not SMS.isExistAuth then begin
        _errorDescription:='Отсутствуют авторизационные данные для отправки SMS';
        Exit;
      end;

      // подправим сообщение чтобы оно было в одну строчку
      SMSMessage:=CreateSMSMessage(FormHome.re_ManualSMS);
      if SMSMessage.Length = 0 then begin
        _errorDescription:='Пустое сообщение';
        Exit;
      end;


      sendindManualReportError:=TStringList.Create;
      isExistError:=False;

      for i:=0 to SharedSendindPhoneManualSMS.Count-1 do begin
        // телефон
        phone:=SharedSendindPhoneManualSMS[i];

        if SharedCheckBox.Checked['SignSMS'] then addSign:=True
        else addSign:=False;

        if not SMS.SendSMS(SMSMessage, phone, _reasonSMS, _errorDescription, addSign) then begin

         if not isExistError then begin
          sendindManualReportError.Add('Не удалось отправить SMS');
          isExistError:=True;
         end;
         sendindManualReportError.Add(phone+' '+_errorDescription);
         SharedMainLog.Save('Не удалось отправить SMS на номер ('+phone+') : '+SMSMessage+'. ОШИБКА : '+_errorDescription, True);
        end else begin
          SharedMainLog.Save('Отправлено SMS на номер ('+phone+') : '+SMSMessage);
        end;
      end;

      if sendindManualReportError.Count <> 0 then
      begin
        _errorDescription:='Не удалось отправить сообщение на номера:'+#13#13;
        for i:=0 to sendindManualReportError.Count-1 do begin
          _errorDescription:=_errorDescription+sendindManualReportError[i]+#13;
        end;

        Exit;
      end;
    end;
    options_Sending:begin  // рассылка
      SMS:=TSendSMS.Create(DEBUG);
      if not SMS.isExistAuth then begin
        _errorDescription:='Отсутствуют авторизационные данные для отправки SMS';
        Exit;
      end;

      // отправляем смс  (в потоке = MAX_COUNT_THREAD_SENDIND)
      showLog:=SharedCheckBox.Checked['ShowLog'];
      SendingRemember(showLog,executionTime);
      executionTime:= Round(executionTime/1000);
      _errorDescription:='Отправлено за '+IntToStr(executionTime)+' сек';
    end;
  end;

  Result:=True;
end;

 // очистка полей формы
procedure ClearParamsForm(InOptionsType:enumSendingOptions);
begin
  ClearTabs(InOptionsType);
end;

// ототбражать или скрывать лог
procedure ShowOrHideLog(InOptions:enumFormShowingLog);
var
  ScreenWidth, ScreenHeight: Integer;
  FormWidth, FormHeight: Integer;
  NewLeft, NewTop: Integer;
begin
  with FormHome do begin
    case InOptions of
      log_show:begin
        Width:=cWIDTH_SHOWLOG;
      end;
      log_hide:begin
       Width:=cWIDTH_HIDELOG;
      end;
    end;
   // Получаем размеры экрана
    ScreenWidth := Screen.Width;
    ScreenHeight := Screen.Height;

    // Получаем размеры формы
    FormWidth := Width;
    FormHeight := Height;

    // Вычисляем новые координаты для центрирования формы
    NewLeft := (ScreenWidth - FormWidth) div 2;
    NewTop := (ScreenHeight - FormHeight) div 2;

    // Устанавливаем новое положение формы
    Left := NewLeft;
    Top := NewTop;
  end;
end;



// выбор типа отправляемого смс
procedure OptionsStyle(InOptionsType:enumSendingOptions);
var
 errorDescription:string;
begin
  with FormHome do begin
   case InOptionsType of
      options_Manual: begin
       btnAction.Caption:=' &Отправить SMS';

       edtManualSMS.Text:='';                 // номер телефона
       //st_PhoneInfo.Visible:=True;            // инфо что телдефон должен начинаться с 8
       re_ManualSMS.Clear;                    // сообщение

       SharedCheckBox.Checked['SignSMS']:=True;          // подпись в конце SMS
       SharedCheckBox.Checked['SaveMyTemplate']:=False;  // сохранить сообщение в мои шаблоны
       SharedCheckBox.Checked['SaveGlobalTemplate']:=False; // сохранить сообщение в глобальные шаблоны

       st_ShowInfoAddAddressClinic.Visible:=True; // справка как добавить адрес клиники

       SharedSendindPhoneManualSMS.Clear;
       lblManualSMS_List.Caption:='списком';


       // кнопки выбора по умолчанию
       btnGenerateMessage.Visible:=True;
       btnManualMessage.Visible:=True;
       panel_message_group.Visible:=False;
       lblOpenGenerateMessage.Visible:=False;

       // скрываем инфо (сообщение не редактируемое)
       lblinfoEditMessage.Visible:=False;

       // тип смс сообщения
       SetReasonSMSType(reason_Empty);
      end;
      options_Sending: begin
       btnAction.Caption:=' &Запустить SMS рассылку';

       lblNameExcelFile.Caption:=EXCEL_FILE_NOT_LOADED;   // excel файл
       lblNameExcelFile.Hint:='';
       lblNameExcelFile.Font.Color:=clRed;

       lblCountSendingSMS.Caption:='-';          // кол-во смс на отправку
       st_ShowSendingSMS.Visible:=False;      // показ списка с данными которые могут быть отправены в смс

       lblCountNotSendingSMS.Caption:='-';       // кол-во смс с ошибкой на отправку
       st_ShowNotSendingSMS.Visible:=False;      // показ списка с данными которые не могут быть отправены в смс


       st_ShowInfoAddAddressClinic.Visible:=False; // справка как добавить адрес клиники

       ProgressStatusText.Caption:='Статус : Файл не загружен в память';


       //chkboxShowLog.Checked:=False;          // показывать лог отправки

       // очистка памяти по отправке смс
       SharedPacientsList.Clear;
       SharedPacientsListNotSending.Clear;
      end;
      options_Find:begin
       btnAction.Caption:=' &Проверить статус сообщения';

       edtFindSMS.Text:='';
       st_PhoneInfo2.Visible:=True;
      end;
   end;
  end;
end;


// добавление сообщения на отправку из шаблонов сообщений
procedure AddMessageFromTemplate(InMessage:string);
var
 tmp:string;
begin
  with FormHome do begin
    re_ManualSMS.Clear;
    re_ManualSMS.Text:=InMessage;
  end;
end;


// редактирование сообщения в сохраненных шаблонов
procedure SaveMyTemplateMessage(id:Integer; InNewMessage:string; IsDelete:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
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
      if not IsDelete then begin
       SQL.Add('update sms_template set template = '+#39+InNewMessage+#39+' where id = '+#39+IntToStr(id)+#39);
      end
      else begin
        SQL.Add('delete from sms_template where id = '+#39+IntToStr(id)+#39);
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
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
end;

// отправка рассылки sms о напоминании приема
procedure SendingRemember(isShowLog:Boolean; var _executeTime:Cardinal);
var
 i:Integer;
 error:string;
 StartTime, EndTime: Cardinal;

 StartValue, EndValue: Integer;
 BaseValue: Integer;
 Remainder: Integer;

 Threads: array of TThreadSendSMS;

 isSending: array of Boolean;
 sending_end:Boolean;      // закончилась ли отправка
begin
    // Вычисляем базовое значение для каждого потока
    BaseValue := SharedPacientsList.Count div MAX_COUNT_THREAD_SENDIND;
    Remainder := SharedPacientsList.Count mod MAX_COUNT_THREAD_SENDIND;

    SetLength(Threads, MAX_COUNT_THREAD_SENDIND);
    SetLength(isSending,MAX_COUNT_THREAD_SENDIND);

    // Перебираем потоки
    StartValue := 0;
    for i := 0 to MAX_COUNT_THREAD_SENDIND - 1 do
    begin
      // Определяем конечное значение для потока
      EndValue := StartValue + BaseValue - 1;

      // Если это последний поток, добавляем остаток
      if i = MAX_COUNT_THREAD_SENDIND - 1 then EndValue:= EndValue + Remainder;


      // Создаем поток
      Threads[i]:= TThreadSendSMS.Create(i + 1, StartValue, EndValue, SharedPacientsList, FormHome.RELog, isShowLog);
      Threads[i].Start;
      isSending[i]:=False;

      // Обновляем начальное значение для следующего потока
      StartValue:= EndValue + 1;
    end;

  // Ожидаем завершения всех потоков и освобождаем их
  try
    StartTime:=GetTickCount;

    while not sending_end do begin
      Application.ProcessMessages;

      for i:=0 to MAX_COUNT_THREAD_SENDIND - 1 do  begin

        if Assigned(Threads[i]) then begin
          try
           if Threads[i].FThreadFinished.WaitFor(0) = wrSignaled then
            begin
              Threads[i].Free; // Освобождаем поток только после его завершения
              Threads[i]:=nil;
              isSending[i]:=True;
            end;
           except on E: EIdException do
              begin
                 ShowMessage(e.ClassName+': '+E.Message);
              end;
           end;
        end;
      end;

      // добавляем проверку статуса потоков
      sending_end := True; // Предположим, что все потоки завершены
      for i:= 0 to MAX_COUNT_THREAD_SENDIND - 1 do
      begin
        if Assigned(Threads[i]) and not isSending[i] then
        begin
          sending_end := False; // Если хотя бы один поток еще работает
          //Break;
        end;
      end;

      Sleep(1000);
    end;

    EndTime:= GetTickCount;
    _executeTime:= EndTime - StartTime;
  except on E: EIdException do
      begin
         ShowMessage(e.ClassName+': '+E.Message);
      end;
   end;


end;


// загрузка excel файла о напоминании о приеме
function LoadData(InFileExcel:string;
                  var _errorDescription:string;
                  var p_Status:TStaticText;
                  var p_CountSending:TLabel;
                  var p_CountNotSending:TLabel):Boolean;
var
 WorkSheet,Excel:OLEVariant;
 Rows, Cols, i:integer;
 FData: OLEVariant;


 stopRows:string;

 checkRows:Boolean;

 PacientPCode,PacientPhone,PacientFamiliya,PacientIO,PacientBirthday,PacientPol,
 PacientDataPriema,PacientTimePriema, PacientFIOVracha, Napravlenie,Address:string;

 NewPacient:TListPacients;

 progress:Integer;

begin
  Screen.Cursor:=crHourGlass;

  if DEBUG then begin
    while (GetTask('EXCEL.EXE')) do KillTask('EXCEL.EXE');
  end;

   // очищаем память на всякий случай
   if SharedPacientsList.Count <> 0 then SharedPacientsList.Clear;
   if SharedPacientsListNotSending.Count <> 0 then SharedPacientsListNotSending.Clear;

    Result:=False;
    _errorDescription:='';
    p_Status.Caption:='Статус : Загрузка в память';
    Application.ProcessMessages;

   // CurrentPostAddColoredLine('Загрузка отчета',clBlack);

    checkRows:=False;

    Excel:=CreateOleObject('Excel.Application');
    Excel.displayAlerts:=False;
    Excel.workbooks.add;

      //открываем книгу
    Excel.Workbooks.Open(InFileExcel);
    //получаем активный лист
    WorkSheet:=Excel.ActiveWorkbook.ActiveSheet;
    //определяем количество строк и столбцов таблицы
    Rows:=WorkSheet.UsedRange.Rows.Count;
    Cols:=WorkSheet.UsedRange.Columns.Count;

    //считываем данные всего диапазона
    try
     FData:=WorkSheet.UsedRange.Value;
    except on E:Exception do
        begin
          Screen.Cursor:=crDefault;

          _errorDescription:='Не удалось загрузить файл в память'+#13#13+e.ClassName+': '+e.Message;
          p_Status.Caption:='Статус : Ошибка при загрузке в память!';
          Application.ProcessMessages;
          Excel.quit;
          Exit;
        end;
    end;


   with FormHome do begin
      // смотримм нужны ли формат

      if (FData[1,1]='PCODE')       and
         (FData[1,2]='PHONE')       and
         (FData[1,3]='LASTNAME')    and
         (FData[1,4]='IO')          and
         (FData[1,5]='BDATE')       and
         (FData[1,6]='POL')         and
         (FData[1,7]='WORKDATE')    and
         (FData[1,8]='TIMES')       and
         (FData[1,9]='DNAME')       and
         (FData[1,10]='DEPNAME')    and
         (FData[1,11]='F_FILID')    and
         (FData[1,12]='F_SHORTADDR')
      then checkRows:=True
      else checkRows:=False;


      if checkRows=False then begin
         Screen.Cursor:=crDefault;

         Excel.quit;

        // CurrentPostAddColoredLine('Некорректный формат отчета',clRed);

         Application.ProcessMessages;

         _errorDescription:='Некорректный формат отчета'+#13#13+
                             'Формат должен включать следуюшие столбцы:'+#13+
                             '1. PCODE'+#13+
                             '2. PHONE'+#13+
                             '3. LASTNAME'+#13+
                             '4. IO'+#13+
                             '5. BDATE'+#13+
                             '6. POL'+#13+
                             '7. WORKDATE'+#13+
                             '8. TIMES'+#13+
                             '9. DNAME'+#13+
                             '10.DEPNAME'+#13+
                             '11.F_FILID'+#13+
                             '12.F_SHORTADDR';

        p_Status.Caption:='Статус : Ошибка, некорректный формат файла!';
        Application.ProcessMessages;
        lblNameExcelFile.Caption:=EXCEL_FILE_NOT_LOADED;
        lblNameExcelFile.Hint:='';
        lblNameExcelFile.Font.Color:=clRed;

        SharedPacientsList.Clear;
        SharedPacientsListNotSending.Clear;
        Exit;
      end;


     checkRows:=False;
     NewPacient:= TListPacients.Create;
     progress:=0;

     for i:=1 to Rows do
     begin
      p_Status.Caption:='Статус : Загрузка в память ['+IntToStr(progress)+'%]';

        if checkRows=False then begin
          if (FData[i,1]='PCODE')     and
             (FData[i,2]='PHONE')     and
             (FData[i,3]='LASTNAME')  and
             (FData[i,4]='IO') then
          begin
           checkRows:=True;
           Continue;
          end;
        end;

       PacientPCode:=FData[i,1];
       PacientPhone:=FData[i,2];
       PacientFamiliya:=FData[i,3];
       PacientIO:=FData[i,4];
       PacientBirthday:=FData[i,5];
       PacientPol:=FData[i,6];
       PacientDataPriema:=FData[i,7];
       PacientTimePriema:=FData[i,8];
       PacientFIOVracha:=FData[i,9];
       Napravlenie:=FData[i,10];
       Address:=FData[i,12];


      begin
        // заносим в память
        with NewPacient do begin
           PCODE:=StrToInt(PacientPCode);
           Phone:=PacientPhone;
           Familiya:=PacientFamiliya;
           IO:=PacientIO;
           Birthday:=StrToDate(PacientBirthday);
           Pol:=PacientPol;
           DataPriema:=StrToDate(PacientDataPriema);
           TimePriema:=StrToTime(PacientTimePriema);
           FIOVracha:=PacientFIOVracha;
           ServiceNapravlenie:=Napravlenie;
           ClinicAddress:=Address;
        end;

        if isValidPacientFields(NewPacient) then SharedPacientsList.Add(NewPacient)
        else SharedPacientsListNotSending.Add(NewPacient, True);
      end;

      NewPacient.Clear;

      progress:=100-Round(Rows / (i*100));
      Application.ProcessMessages;
     end;
   end;

  Excel.quit;

  p_Status.Caption:='Статус : Загружено, готово к отправке';
  p_CountSending.Caption:=IntToStr(SharedPacientsList.Count);
  p_CountNotSending.Caption:=IntToStr(SharedPacientsListNotSending.Count);
  if SharedPacientsList.Count>0 then FormHome.st_ShowSendingSMS.Visible:=True;
  if SharedPacientsListNotSending.Count>0 then FormHome.st_ShowNotSendingSMS.Visible:=True;


  Result:=True;

  Application.ProcessMessages;
  Screen.Cursor:=crDefault;
end;



// отправка смс v2
function GetSMS(inPacientPhone:string):string; overload;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;

 MessageSMS:string;
 HTTPGet:string;
begin

 //if global_DEBUG then inPacientPhone:='89275052333';

 //MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');

  // формируем ссылку на отправку
  begin
   HTTPGet:=cWebApiSMS;
    {
   cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
   }

   with FormHome do begin
   // HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', MessageSMS,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', EncodeURL(AnsiToUtf8(MessageSMS)),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%PHONENUMBER',inPacientPhone,[rfReplaceAll]);
   end;
  end;

   http:=TIdHTTP.Create(nil);

    begin
     ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
     ssl.SSLOptions.Method:=sslvTLSv1_2;
     ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
    end;

  with http do begin
    IOHandler:=ssl;
//    Request.CustomHeaders.Add(CustomHeaders0);
//    Request.UserAgent:=CustomUserAgent;
//    Request.CustomHeaders.Add(CustomHeaders2);
//    Request.CustomHeaders.Add(CustomHeaders3);
//    Request.CustomHeaders.Add(CustomHeaders4);

     try
      { if global_DEBUG=False then ServerOtvet:=Get(HTTPGet)
       else }ServerOtvet:='OK';
     except on E: EIdHTTPProtocolException do
        begin
         Result:='ОШИБКА ОТПРАВКИ! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    Result:='OK';
   // Log(MessageSMS,False);

    // сохраняем последнее отправленное сообщение для истории и типа для формирования шаблонов сообщений
    //AddSaveMessageOld(MessageSMS);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   Sleep(500);
end;


// кол-во смс которые были отправлены
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;
var
  count: integer;
  sCount:Integer;
begin
  count:=0;
  sCount:=0;

  count:=PosEx(inPacientPhone, ResultServer, 1);
   while count<>0 do
   begin
      inc(sCount);
      count:=PosEx(inPacientPhone, ResultServer, count+length(inPacientPhone));
   end;

   Result:=sCount;
end;


// парсинг и создание формы инфо статуса сообщения
procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);
const
  MSGSTART:string = '<MESSAGES>';
  MSGSTOP:string  = '</MESSAGE>';

  var
  numberPhoneCount:Integer;
  //listMsg:array of TSMSMessage;
  i:Integer;
  tmp:string;

  oldLenghtResult:Integer;

  FormPleaseWait:TForm;
  lblPlease:TLabel;

  // разобранное сообщение
  SMS_ID: string;     // ID sms
  CreatDate: string;    // дата когда было создано сообщение
  CreatTime: string;    // время когда было создано сообщение
  MsgText: string;     // текст сообщения
  Code: string;        // код смс
  Status: string;      // статус смс

  nowbreak:Int64;

begin
  (*
   // динамическая форма
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='Разбор запроса';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' Подождите ...';
     lblPlease.Left:=4;
     lblPlease.Top:=5;
     lblPlease.Width:=ClientWidth-10;
     lblPlease.Height:=25;
     lblPlease.Visible:=True;
     lblPlease.Layout:=tlCenter;
     lblPlease.Font.Size:=12;
     lblPlease.Font.Name:='Times New Roman';
     lblPlease.Parent:=FormPleaseWait;
     Show;
     Application.ProcessMessages;
   end;
    *)

 // поменяем 8 -> 7
 inPacientPhone[1]:='7';
 numberPhoneCount:=GetMsgCount(ResultServer,inPacientPhone);

 nowbreak:=Length(ResultServer);

 // создадтим динамический массивчик сообщений
 if numberPhoneCount=0 then begin
  // FormPleaseWait.Free;

   MessageBox(FormHome.Handle,PChar('За период с '+DateToStr(Now-4)+' по '+DateToStr(Now)+' отсутствуют отправленные SMS'),PChar('Информация'),MB_OK+MB_ICONSTOP);
   Exit;
 end;

// SetLength(listMsg,numberPhoneCount);
// for i:=0 to numberPhoneCount-1 do listMsg[i]:=TSMSMessage.Create;
// i:=0;

 oldLenghtResult:=Length(ResultServer);

 // парсим для последующего создания человеческой формы
 while(AnsiPos(MSGSTOP,ResultServer))<> 0 do begin

   //FormHome.ProgressBar.Progress:=100-(Round(100*Length(ResultServer)/oldLenghtResult));
   Application.ProcessMessages;

   tmp:=ResultServer;

   // найдем начало и конец сообщения
   System.Delete(tmp,1,AnsiPos(MSGSTART,tmp)+Length(MSGSTART));
   System.Delete(tmp,AnsiPos(MSGSTOP,tmp),Length(tmp));

   // разбираем
//   if AnsiPos(inPacientPhone,tmp)<>0 then begin
//
//      if i<numberPhoneCount then listMsg[i].Phone:=inPacientPhone;
//
//      //ShowMessage(IntToStr(100-(Round(100*Length(ResultServer)/oldLenghtResult))));
//
//      SMS_ID:=tmp;
//      System.Delete(SMS_ID,1,AnsiPos('"',SMS_ID));
//      System.Delete(SMS_ID,AnsiPos('"',SMS_ID),Length(SMS_ID));
//      if i<numberPhoneCount then listMsg[i].SMS_ID:=SMS_ID;
//
//      CreatDate:=tmp;
//      System.Delete(CreatDate,1,AnsiPos('<CREATED>',CreatDate)+Length('<CREATED>')-1);
//      System.Delete(CreatDate,AnsiPos(' ',CreatDate),Length(CreatDate));
//      if i<numberPhoneCount then listMsg[i].CreatDate:=StrToDate(CreatDate);
//
//      CreatTime:=tmp;
//      System.Delete(CreatTime,1,AnsiPos('<CREATED>',CreatTime)+Length('<CREATED>')-1);
//      System.Delete(CreatTime,1,AnsiPos(' ',CreatTime));
//      System.Delete(CreatTime,AnsiPos('<',CreatTime),Length(CreatTime));
//      if i<numberPhoneCount then listMsg[i].CreatTime:=StrToTime(CreatTime);
//
//      MsgText:=tmp;
//      System.Delete(MsgText,1,AnsiPos('[CDATA[',MsgText)+Length('[CDATA[')-1);
//      System.Delete(MsgText,AnsiPos(']]></SMS_TEXT>',MsgText),Length(MsgText));
//      if i<numberPhoneCount then listMsg[i].MsgText:=MsgText;
//
//      Code:=tmp;
//      System.Delete(Code,1,AnsiPos('<SMSSTC_CODE>',Code)+Length('<SMSSTC_CODE>')-1);
//      System.Delete(Code,AnsiPos('</SMSSTC_CODE>',Code),Length(Code));
//      if i<numberPhoneCount then listMsg[i].Code:=Code;
//
//      Status:=tmp;
//      System.Delete(Status,1,AnsiPos('<SMS_STATUS>',Status)+Length('<SMS_STATUS>')-1);
//      System.Delete(Status,AnsiPos('</SMS_STATUS>',Status),Length(Status));
//      if i<numberPhoneCount then listMsg[i].Status:=Status;
//
//      Inc(i);
//   end;

   // следующий разбор
    System.Delete(ResultServer,1,AnsiPos(MSGSTOP,ResultServer));

   Dec(nowbreak,1);
   if nowbreak=0 then begin
    // FormPleaseWait.Free;
     MessageBox(FormHome.Handle,PChar('Превышено время отведенное для разбора запроса'),PChar('Runtime Error'),MB_OK+MB_ICONERROR);
     Exit;
   end;

 end;

  //FormHome.ProgressBar.Progress:=0;

  //отображаем найденное



  //FormPleaseWait.Free;
end;

// проверка смс статуса
function GetSMSStatusID(inPacientPhone:string):string;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet:string;

 FormPleaseWait:TForm;
 lblPlease:TLabel;
begin

   // динамическая форма
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='Отправка запроса';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' Подождите ...';
     lblPlease.Left:=4;
     lblPlease.Top:=5;
     lblPlease.Width:=ClientWidth-10;
     lblPlease.Height:=25;
     lblPlease.Visible:=True;
     lblPlease.Layout:=tlCenter;
     lblPlease.Font.Size:=12;
     lblPlease.Font.Name:='Times New Roman';
     lblPlease.Parent:=FormPleaseWait;
     Show;
     Application.ProcessMessages;
   end;


  // формируем ссылку на отправку
  begin
   HTTPGet:=cWebApiSMSstatusID;

   with FormHome do begin
  //  HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%DATE_START',DateToStr(Now-4),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%DATE_STOP',DateToStr(Now),[rfReplaceAll]);
   end;
  end;

   http:=TIdHTTP.Create(nil);

    begin
     ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
     ssl.SSLOptions.Method:=sslvTLSv1_2;
     ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
    end;

  with http do begin
    IOHandler:=ssl;
//    Request.CustomHeaders.Add(CustomHeaders0);
//    Request.UserAgent:=CustomUserAgent;
//    Request.CustomHeaders.Add(CustomHeaders2);
//    Request.CustomHeaders.Add(CustomHeaders3);
//    Request.CustomHeaders.Add(CustomHeaders4);

     try
       ServerOtvet:=Get(HTTPGet);
     except on E: EIdHTTPProtocolException do
        begin
         FormPleaseWait.Free;

         Result:='ОШИБКА ОТПРАВКИ! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   FormPleaseWait.Free;

  // парсим и создаем форму
  ParsingResultStatusSMS(ServerOtvet,inPacientPhone);
end;

// проверка на корректность записи из excel файла
function isValidPacientFields(var Pacient:TListPacients):Boolean;
const
 cPHONE_ERROR       :string  = 'Некорректный номер телефона';
 cPACIENT_ERROR     :string  = 'Отсутствует Имя Отчеcтво у пациента';
 cPACIENT_ERROR2    :string  = 'Отсутствует Отчеcтво у пациента';
 cFIOVRACHA_ERROR   :string  = 'Не задана услуга или ФИО врача';
var
 i,j:Integer;
 tmp:string;
 exist_space:Boolean;

begin
  Result:=False;

 // проверим чтобы лишнего ничего не было (Phone)
  begin
   if AnsiPos(' ',Pacient.Phone)<>0 then begin
    // присутствует пробел
    Pacient.Phone:=StringReplace(Pacient.Phone,' ','',[rfReplaceAll]);
   end;

   // проверим чтобы номер телефона был только сотовым
   if AnsiPos('(9',Pacient.Phone)=0 then begin
      Pacient._errorDescriptions:=cPHONE_ERROR;
      Exit;
   end;

     // разберем до состояния привет как охуенно ))
   Pacient.Phone:=StringReplace(Pacient.Phone,'(','',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,')','',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,'+7','8',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,'-','',[rfReplaceAll]);


   // последняя проверка, чтобы длинна былав не меньше и не больше 11 символов
   if Length(Pacient.Phone)<>11  then begin
    Pacient._errorDescriptions:=cPHONE_ERROR;
    Exit;
   end;

   // и напоследок поиск самого долбанутого номера
   if Pacient.Phone = '89999999999' then begin
    Pacient._errorDescriptions:=cPHONE_ERROR;
    Exit;
   end;

  end;

  if Pacient.IO = '' then begin
    Pacient._errorDescriptions:=cPACIENT_ERROR;
    Exit;
  end;

  // проверка чтобы был пробел
  begin
    exist_space:=False;
    for i:=1 to Length(Pacient.IO)-1 do begin
      tmp:=Pacient.IO[i];
      if tmp = ' ' then begin
        exist_space:=True;
      end;
    end;

    if not exist_space then begin
     Pacient._errorDescriptions:=cPACIENT_ERROR2;
     Exit;
    end;
  end;


  // проверка корректности ФИО\услуги (были случаи когда писали МЕДСИ)
  tmp:=AnsiLowerCase(Pacient.FIOVracha);
  if AnsiPos('медси',tmp)<>0 then begin
   Pacient._errorDescriptions:=cFIOVRACHA_ERROR;
   Exit;
  end;


  // проверим есть ли в строке буковка г.
  if (AnsiPos('г.',Pacient.ClinicAddress)=0) then Pacient.ClinicAddress:='г. '+Pacient.ClinicAddress;

  Result:=True;
end;

// очистка окон после отправки
procedure ClearTabs(InOptionsType:enumSendingOptions);
begin
   OptionsStyle(InOptionsType);
end;


// проверка установлен ли excel
function isExistExcel(var _errorDescriptions:string):Boolean;
var
  Excel:OleVariant;
begin
  Result:=False;
  _errorDescriptions:='';

  try
    Excel:=CreateOleObject('Excel.Application');
    Excel:=Unassigned; // Освобождаем объект

    Result:=True; // Если объект создан, значит Excel установлен
  except
    on E: Exception do begin
      _errorDescriptions:=e.ClassName+#13+E.Message;
    end;
  end;
end;

// создание Copyright
procedure CreateCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[1].Text:=GetCopyright;
  end;
end;


// подсчет сколько за сегодня отправлено смс было
procedure ShowCountTodaySmsSending;
begin
   with FormHome.StatusBar do begin
    Panels[0].Text:='  За сегодня отправлено: '+IntToStr(GetCountSendingSMSToday);
  end;
end;


// очистка шаблонов сообщений
procedure ClearListView(var p_ListView:TListView);
const
 cWidth_default         :Word = 792;
begin
  p_ListView.Items.Clear;
  p_ListView.Columns.Clear;

 with p_ListView do begin
   ViewStyle:= vsReport;

   Items.Clear;
   Columns.Clear;
   ViewStyle:= vsReport;

    with Columns.Add do
    begin
      Caption:='ID';
      Width:=0;
    end;

    with Columns.Add do
    begin
      Caption:=' Шаблон сообщения';
      Width:=cWidth_default;
      Alignment:=taLeftJustify;
    end;
 end;
end;



// прогрузка шаблорнов сообщений
procedure ShowSaveTemplateMessage(var p_PageControl:TPageControl;
                                  var p_ListView:TListView;
                                  InTemplate:enumTemplateMessage;
                                  var p_NoMessageInfo:TStaticText);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countTemplate:Integer;
 i:Integer;
 ListItem: TListItem;
begin
  //очистка stringgrid
  ClearListView(p_ListView);


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
      case InTemplate of
        template_my:begin
          SQL.Add('select count(template) from sms_template where user_id = '+#39+inttostr(USER_STARTED_SMS_ID) +#39+' and is_global = ''0'' ');
        end;
        template_global:begin
          SQL.Add('select count(template) from sms_template where is_global = ''1'' ');
        end;
      end;

      Active:=True;
      countTemplate:=Fields[0].Value;

      if countTemplate=0 then begin
        // надпись что нет данных
        case InTemplate of
          template_my:begin
           FormMyTemplate.st_NoMessage_MyTemplate.Visible:=True;
           p_PageControl.Pages[0].Caption:='Сохраненные шаблоны ('+IntToStr(countTemplate)+')';
          end;
          template_global:begin
           FormMyTemplate.st_NoMessage_GlobalTemplate.Visible:=True;
           p_PageControl.Pages[1].Caption:='Глобальные шаблоны ('+IntToStr(countTemplate)+')';
          end;
        end;

        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        p_NoMessageInfo.Visible:=True;

        //убираем меню
        p_ListView.PopupMenu:=nil;

        Exit;
      end;

      // скрываем надпись что нет данных
      p_NoMessageInfo.Visible:=False;
      ////////////////////////////////////////////////////////////////

      SQL.Clear;
      case InTemplate of
        template_my:begin
          SQL.Add('select id,template from sms_template where user_id = '+#39+inttostr(USER_STARTED_SMS_ID) +#39+' and is_global = ''0'' ');
          p_PageControl.Pages[0].Caption:='Сохраненные шаблоны ('+IntToStr(countTemplate)+')';
        end;
        template_global:begin
          SQL.Add('select id,template from sms_template where is_global = ''1'' ');
          p_PageControl.Pages[1].Caption:='Глобальные шаблоны ('+IntToStr(countTemplate)+')';
        end;
      end;
      Active:=True;

      for i:=0 to countTemplate-1 do
      begin
        // Элемент не найден, добавляем новый
        ListItem := p_ListView.Items.Add;
        ListItem.Caption := VarToStr(Fields[0].Value);  // id
        ListItem.SubItems.Add(Fields[1].Value);         // шаблон ранее сохраненного сообщения

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


// есть ли такое сообщение уже в шаблонах сообщений
function isExistMyTemplateMessage(InMessage:string; isGlobal:Boolean = False):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countTemplate:Integer;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    Result:=True;  // считаем что сообщение есть, в случае ошибки
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      if not isGlobal then SQL.Add('select count(id) from sms_template where user_id = '+#39+inttostr(USER_STARTED_SMS_ID) +#39+' and is_global = ''0'' and template = '+#39+InMessage+#39)
      else SQL.Add('select count(id) from sms_template where is_global = ''1'' and template = '+#39+InMessage+#39);

      Active:=True;
      countTemplate:=Fields[0].Value;

      if countTemplate > 0 then Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// запись в шалблоны отправленного сообщения
procedure SaveMyTemplateMesaage(InMessage:string; IsGlobal:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 response:string;
begin
  if isExistMyTemplateMessage(InMessage, IsGlobal) then Exit;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  if not IsGlobal then begin
     response:='insert into sms_template (user_id,template) values ('+#39+IntToStr(USER_STARTED_SMS_ID)+#39+','
                                                                    +#39+InMessage+#39+')';
  end
  else begin
   response:='insert into sms_template (user_id,template,is_global) values ('+#39+IntToStr(USER_STARTED_SMS_ID)+#39+','
                                                                             +#39+InMessage+#39+','
                                                                             +#39+'1'+#39+')';
  end;


   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(response);

        try
            ExecSQL;
        except
            on E:EIdException do begin
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
end;

// есть ли возможность вставлять подпись в СМС сообщение
procedure SignSMS;
 var
  sms:TSendSMS;
begin
  sms:=TSendSMS.Create(DEBUG);
  with FormHome do begin
    if not sms.isExistAuth then begin
      chkbox_SignSMS.Enabled:=False;
      SharedCheckBox.Checked['SignSMS']:=False;

      Exit;
    end;

    if sms.GetSignSMS = 'null' then begin
      chkbox_SignSMS.Enabled:=False;
      SharedCheckBox.Checked['SignSMS']:=False;

      Exit;
    end;

   with chkbox_SignSMS do begin
     Hint:='К отправляемому SMS будет подставляться подпись'+#13+#10+'"'+sms.GetSignSMS+'"';
     ShowHint:=True;

     SharedCheckBox.Checked['SignSMS']:=True;
     Enabled:=True;
   end;
  end;
end;

// создание списка с адресами клиник для быстрого доступа к ним
procedure CreatePopMenuAddressClinic(var p_PopMenu:TPopupMenu; var p_Message:TRichEdit);
 var
  address_clinic:TAddressClinicPopMenu;
begin
  address_clinic:=TAddressClinicPopMenu.Create(p_PopMenu, p_Message);
end;

// выбор типа при ручной отправки SMS (1 SMS или списком)
procedure ShowSendingManualPhone(InSendingType:enumManualSMS);
begin
  with FormHome do begin
    case InSendingType of
      sending_one: begin
        lblManualSMS_One.Visible:=False;

        edtManualSMS.Left:=13;
        edtManualSMS.Visible:=True;

        st_PhoneInfo.Left:=77;
        st_PhoneInfo.Visible:=True;

        lblManualSMS_List.Font.Size:=8;
        lblManualSMS_List.left:=155;
        lblManualSMS_List.top:=22;

        lblManualPodbor.Visible:=True;
      end;
      sending_list: begin

          {
              lblManualSMS_List.left:=129
              lblManualSMS_List.top:=42;
              lblManualSMS_List.Font.Size:=10;

          }

      end;
    end;
  end;
end;


// отображение\сркытие окна запроса на сервер
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;



// проверка можно ли показать меню на добавление слова в словарь
function IsExistSpellingColor(var _MaybeDictionaryWord:string; var p_text:TRichEdit):Boolean;
var
  CursorPos: Integer;
  StartPos, EndPos: Integer;
  Word: string;
  i: Integer;
  IsRed: Boolean;
  CharColor: TColor;
begin
 _MaybeDictionaryWord:='';
 Result:=False;

 // Получаем позицию курсора
  CursorPos := p_text.SelStart;

  // Находим границы слова под курсором
  StartPos := SendMessage(p_text.Handle, EM_FINDWORDBREAK, WB_LEFT, CursorPos);
  EndPos := SendMessage(p_text.Handle, EM_FINDWORDBREAK, WB_RIGHT, CursorPos);

  // Извлекаем слово
  Word := Copy(p_text.Text, StartPos + 1, EndPos - StartPos);

  if Word = '' then begin
    Exit;
  end;

  // Проверяем, не пустое ли слово
  begin
    IsRed := False; // Предполагаем, что слово не с ошибкой
    for i := StartPos to EndPos - 1 do
    begin
      // Получаем цвет символа
      SendMessage(p_text.Handle, EM_SETSEL, i, i + 1);
      CharColor := p_text.SelAttributes.Color;

      // Проверяем, является ли цвет символа красным
      if CharColor = clRed then
      begin
        IsRed := True;
       // Break;
      end;
    end;

    if IsRed then begin
       Word:=StringReplace(Word,' ','',[rfReplaceAll]);    // убираем пробел
       Word:=StringReplace(Word, #13, '', [rfReplaceAll]); // убираем enter

      _MaybeDictionaryWord:=Word;
      Result:=True;
    end;
  end;
end;

// удаление слова из БД
function SaveWord(_id:Integer;
                  InNewMessage:string;
                  var _errorDescription:string;
                  IsDelete:Boolean = False):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

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
      if not IsDelete then begin
       SQL.Add('update sms_dictionary set word = '+#39+InNewMessage+#39+' where id = '+#39+IntToStr(_id)+#39);
      end
      else begin
        SQL.Add('delete from sms_dictionary where id = '+#39+IntToStr(_id)+#39);
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
              _errorDescription:=e.ClassName+': '+e.Message;
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

   Result:=True;
end;


// проверка есть ли подпись в отправляемом сообщении
function IsExistSignInMessage(const _message:string):Boolean;
var
 SMS:TSendSMS;
begin
  Result:=False;

  SMS:=TSendSMS.Create(DEBUG);
  if AnsiPos(SMS.GetSignSMS, _message)<>0 then Result:=True;
end;


// пасинг номера тлф при вствке в поле номер телефона
function ParsePhoneNumber(const PhoneNumber: string): string;
var
  CleanedNumber: string;
  i: Integer;
begin
  CleanedNumber := '';

  // Проходим по каждому символу в исходной строке
  for i := 1 to Length(PhoneNumber) do
  begin
    // Проверяем, является ли символ цифрой
    if PhoneNumber[i] in ['0'..'9'] then
    begin
      // Добавляем цифру в очищенный номер
      CleanedNumber := CleanedNumber + PhoneNumber[i];
    end;
  end;

  // Проверяем, если номер начинается с "7" и добавляем "8" в начале
  if (Length(CleanedNumber) > 0) and (CleanedNumber[1] = '7') then
  begin
    CleanedNumber := '8' + Copy(CleanedNumber, 2, Length(CleanedNumber) - 1);
  end;

  Result := CleanedNumber;
end;


// отображение SIP пользвоателя
function GetUserSIP(_idUser:integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

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
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(_idUser)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value);
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// изменение цвета надписи
procedure SetRandomFontColor(var p_label: TLabel);
var
  RandomColor: TColor;
begin
  // Генерируем случайные значения для RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // Устанавливаем случайный цвет шрифта для метки
  p_label.Font.Color := RandomColor;
end;


// установка дата начала и конца времени отбора
function SetFindDate(var _startDate:TDateTimePicker;
                     var _stopDate:TDateTimePicker;
                     var _errorDescriptions:string):Boolean;
var
  CurrentDate: TDateTime;
  FirstDayOfPreviousMonth: TDateTime;
  LastDayOfPreviousMonth: TDateTime;
begin
 Result:=False;
 _errorDescriptions:='';

   try
      // Получаем текущую дату
      CurrentDate := Now;

     _startDate.DateTime := StartOfTheMonth(CurrentDate);
     _stopDate.DateTime  := EndOfTheMonth(CurrentDate);

      Result:=True;
   except
      on E: Exception do begin
        _errorDescriptions:=e.ClassName+#13+E.Message;
      end;
   end;
end;


// сохранение результата отправки на диске в jpg
function SaveResultSendingSMS(var _panel:TPanel; _path:string; var _errorDescription:string):Boolean;
var
  PanelRect: TRect;
  ScreenshotBmp: TBitmap;
  JpegImg: TJPEGImage;
  WindowDC: HDC;
begin
  Result := False;
  _errorDescription := '';

  // Проверяем путь
  if Length(_path) = 0 then
  begin
    _errorDescription := 'Не указан путь куда сохранить файл';
    Exit;
  end;

  // Получаем клиентские размеры панели
  GetClientRect(_panel.Handle, PanelRect);

  ScreenshotBmp := TBitmap.Create;
  try
    ScreenshotBmp.PixelFormat := pf24bit;
    ScreenshotBmp.Width := PanelRect.Right - PanelRect.Left;
    ScreenshotBmp.Height := PanelRect.Bottom - PanelRect.Top;

    // Рисуем содержимое панели в Bitmap
    WindowDC := GetDC(_panel.Handle);
    try
      BitBlt(ScreenshotBmp.Canvas.Handle,
             0, 0, ScreenshotBmp.Width, ScreenshotBmp.Height,
             WindowDC,
             0, 0,
             SRCCOPY);
    finally
      ReleaseDC(_panel.Handle, WindowDC);
    end;

    // Конвертируем в JPEG и сохраняем файл
    JpegImg := TJPEGImage.Create;
    try
      JpegImg.CompressionQuality := EnsureRange(100, 1, 100); // Качество сжатия JPEG
      JpegImg.Assign(ScreenshotBmp);
      JpegImg.SaveToFile(_path);
      Result := True;
    except
      on E: Exception do
        _errorDescription := 'Ошибка при сохранении JPEG: ' + E.Message;
    end;
  finally
    ScreenshotBmp.Free;
    JpegImg.Free;
  end;
end;


// подгрузка своих красивых чекбоксов
procedure AddCustomCheckBoxUI;
begin
  with FormHome do begin
    // вставить подпись в конце SMS (chkbox_SignSMS)
    SharedCheckBox.Add('SignSMS', chkbox_SignSMS, img_SignSMS, paramStatus_ENABLED);

    // сохранить сообщение в "Мои шаблоны сообщений" (SaveMyTemplate)
    SharedCheckBox.Add('SaveMyTemplate', chkbox_SaveMyTemplate, img_SaveMyTemplate, paramStatus_DISABLED);

    // сохранить сообщение в "Глобальные шаблоны" (SaveGlobalTemplate)
    SharedCheckBox.Add('SaveGlobalTemplate', chkbox_SaveGlobalTemplate, img_SaveGlobalTemplate, paramStatus_DISABLED);

    // отображать лог рассылки (chkbox_ShowLog)
    SharedCheckBox.Add('ShowLog', chkbox_ShowLog, img_ShowLog, paramStatus_DISABLED);
  end;

  with FormManualPodbor do begin
    // только свои звонки (MyCalls)
    SharedCheckBox.Add('MyCalls', chkbox_MyCalls, img_MyCalls, paramStatus_DISABLED);
  end;
end;



end.
