 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///       Класс для описания сгенерированного сообщения для смс               ///
///                  в зависимости от типа сообщения                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TMessageGeneratorSMSUnit;

interface

uses
  System.Classes, System.SysUtils, FormGenerateSMSUnit, TWorkingTimeClinicUnit,
  Vcl.ComCtrls, Data.Win.ADODB, Data.DB, IdException, TCustomTypeUnit, System.Variants,
  System.DateUtils;


 // class TMessageGeneratorSMS
   type
      TMessageGeneratorSMS = class
      private
      m_form                      :TFormGenerateSMS;
      m_generetedMessage          :string;   // сгенерированное сообщение


      procedure GenerateMessageFIO(var _stroka:string; _gender:enumGender;
                                   _name:string; _otchestvo:string);  // создание сгенерированного сообощения (ФИО обращение)
      procedure GenerateMessageDate(var _stroka:string);              // создание сгенерированного сообощения (дата)
      procedure GenerateMessageTime(var _stroka:string);              // создание сгенерированного сообощения (время)
      procedure GenerateMessageAddressClinic(var _stroka:string);     // создание сгенерированного сообощения (клиника)
      procedure GenerateMessagePol(var _stroka:string; _gender:enumGender);       // создание сгенерированного сообощения (пол записан-на)
      procedure GenerateMessageServiceCount(var _stroka:string; const _serviceChoise:TStringList);        // создание сгенерированного сообощения (кол-во услуг)
      procedure GenerateMessagePrichina(var _stroka:string; const _prichina:string);        // создание сгенерированного сообощения (причина)
      procedure GenerateMessageClinicTimeWorking(var _stroka:string;
                                                 const p_workingTime:TWorkingTimeClinic);     // создание сгенерированного сообощения (время работы клиники)
      procedure GenerateMessageMoney(var _stroka:string; _money:string);       // создание сгенерированного сообощения (сумма денег)
      procedure GenerateMessageServiceList(var _stroka:string;
                                           const p_service:TStringList);       // создание сгенерированного сообощения (лист с улугами)


      function CheckParamsSpelling(const p_text:TRichEdit; var _errorDescription:string):Boolean;      // проверка орфографии
      function CheckParamsName(var _errorDescription:string):Boolean;           // проверка параметров(имя)
      function CheckParamsOtchestvo(var _errorDescription:string):Boolean;      // проверка параметров(отчетсво)
      function CheckParamsPol(var _errorDescription:string):Boolean;            // проверка параметров(пол)
      function CheckParamsAddressClinic(var _errorDescription:string):Boolean;  // проверка параметров(адрес клиники)
      function CheckParamsDateOfPriem(var _errorDescription:string):Boolean;    // проверка параметров(дата и время приема)
      function CheckParamsServiceCount(const p_service:TStringList; var _errorDescription:string):Boolean;   // проверка параметров(кол-во услуг)
      function CheckParamsMoney(var _errorDescription:string):Boolean;          // проверка параметров(сумма)
      function CheckParamsReason(var _errorDescription:string):Boolean;         // проверка параметров(причина)

      function IsExistMessage:Boolean; // сгенерировали ли сообщение

      public
      constructor Create(var p_Form:TFormGenerateSMS);                   overload;

      procedure Clear;
      function CheckParams(_generate:enumReasonSmsMessage;
                           const p_service:TStringList;
                           isAutoPodbor:Boolean;
                           var _errorDescription:string):Boolean;  // проверка параметров
      procedure CreateMessage(_genereate:enumReasonSmsMessage;
                              _gender:enumGender;
                              _name:string; _otchestvo:string;
                              const _serviceCount:TStringList;
                              _money:string;
                              const _prichina:string);       // создание сгенерированного собощения

      function GetExampleMessage(_messageType:enumReasonSmsMessage):string; // пример сообщения (берется из бд history_sms_sending)
      procedure ClearMessage;     // очистка сообщения

      property IsGeneretedMessage:Boolean read IsExistMessage;
      property GeneretedMessage:string read m_generetedMessage;


      end;
 // class TMessageGeneratorSMS END

implementation

uses
  GlobalVariablesLinkDLL, FunctionUnit, TSpellingUnit;



constructor TMessageGeneratorSMS.Create(var p_Form:TFormGenerateSMS);
 begin
  // inherited;

   m_form:=p_Form;
   m_generetedMessage:='';
 end;


procedure TMessageGeneratorSMS.Clear;
begin
  m_generetedMessage:='';
end;


// создание сгенерированного сообощения (ФИО обращение)
procedure TMessageGeneratorSMS.GenerateMessageFIO(var _stroka:string; _gender:enumGender; _name:string; _otchestvo:string);
begin

  case _gender of
   gender_male:begin
     _stroka:=StringReplace(_stroka,'%uvazaemii%','Уважаемый',[rfReplaceAll]);
   end;
   gender_female:begin
     _stroka:=StringReplace(_stroka,'%uvazaemii%','Уважаемая',[rfReplaceAll]);
   end;
  end;

  _stroka:=StringReplace(_stroka,'%name%',_name,[rfReplaceAll]);
  _stroka:=StringReplace(_stroka,'%otchestvo%',_otchestvo,[rfReplaceAll]);
end;



// создание сгенерированного сообощения (дата)
procedure TMessageGeneratorSMS.GenerateMessageDate(var _stroka:string);
var
  date:TDate;
begin
  date:=m_form.dateShow.Date;
 _stroka:=StringReplace(_stroka,'%date%',DateToStr(date),[rfReplaceAll]);
end;

// создание сгенерированного сообощения (время)
procedure TMessageGeneratorSMS.GenerateMessageTime(var _stroka:string);
var
  time:TTime;
begin
   time:=m_form.timeShow.Time;
  _stroka := StringReplace(_stroka, '%time%', FormatDateTime('hh:nn', time), [rfReplaceAll]);
end;


// создание сгенерированного сообощения (клиника)
procedure TMessageGeneratorSMS.GenerateMessageAddressClinic(var _stroka:string);
var
 clinicAddress:string;
begin
   clinicAddress:=m_form.combox_AddressClinic.Items[m_form.combox_AddressClinic.ItemIndex];
   _stroka:=StringReplace(_stroka,'%address%',clinicAddress,[rfReplaceAll]);
end;

// создание сгенерированного сообощения (пол записан-на)
procedure TMessageGeneratorSMS.GenerateMessagePol(var _stroka:string; _gender:enumGender);
begin
 case _gender of
   gender_male:begin
     _stroka:=StringReplace(_stroka,'%pol%','записан',[rfReplaceAll]);
   end;
   gender_female:begin
     _stroka:=StringReplace(_stroka,'%pol%','записана',[rfReplaceAll]);
   end;
  end;
end;

// создание сгенерированного сообощения (кол-во услуг)
procedure TMessageGeneratorSMS.GenerateMessageServiceCount(var _stroka:string; const _serviceChoise:TStringList);
begin
  if _serviceChoise.Count = 1 then begin
   _stroka:=StringReplace(_stroka,'%labs%','лабораторное',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%study%','исследование',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%maybe%','может',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%done%','выполнено',[rfReplaceAll]);
  end
  else begin
   _stroka:=StringReplace(_stroka,'%labs%','лабораторные',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%study%','исследования',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%maybe%','могут',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%done%','выполнены',[rfReplaceAll]);
  end;
end;


// создание сгенерированного сообощения (причина)
procedure TMessageGeneratorSMS.GenerateMessagePrichina(var _stroka:string; const _prichina:string);
var
 tmp:string;
begin
  tmp:=AnsiLowerCase(_prichina); // все с маленькой строки
  _stroka:=StringReplace(_stroka,'%prichina%',tmp,[rfReplaceAll]);
end;


// создание сгенерированного сообощения (время работы клиники)
procedure TMessageGeneratorSMS.GenerateMessageClinicTimeWorking(var _stroka:string; const p_workingTime:TWorkingTimeClinic);
begin
  _stroka:=StringReplace(_stroka,'%time_clinic%',p_workingTime.GetWorking,[rfReplaceAll]);
end;

// создание сгенерированного сообощения (сумма денег)
procedure TMessageGeneratorSMS.GenerateMessageMoney(var _stroka:string; _money:string);
begin
  _stroka:=StringReplace(_stroka,'%money%',_money,[rfReplaceAll]);
end;


// создание сгенерированного сообощения (лист с улугами)
procedure TMessageGeneratorSMS.GenerateMessageServiceList(var _stroka:string; const p_service:TStringList);
var
 i:Integer;
 tmp:string;
begin
  tmp:='';
  if p_service.Count > 1 then tmp:='услуги "'
  else tmp:='услугу "';

  for i:=0 to p_service.Count-1 do begin
    if i=0 then tmp:=tmp+p_service[i]
    else tmp:=tmp+', '+p_service[i];
  end;

  tmp:=tmp+'"';

  _stroka:=StringReplace(_stroka,'%list_service%',tmp,[rfReplaceAll]);
end;



// проверка орфографии
function TMessageGeneratorSMS.CheckParamsSpelling(const p_text:TRichEdit; var _errorDescription:string):Boolean;
var
 Spelling:TSpelling;
begin
  Result:=False;

  if (IsPunctuationOrDigit( p_text.Text[1])) or
      (p_text.Text[1] = ' ') then begin
      _errorDescription:='Поле "'+p_text.Hint+'" не должно начинаться со знака препинания, пробела или цифры';
      Exit;
  end;

  if (IsPunctuationOrDigit(p_text.Text[Length(p_text.Text)], True)) then begin
      _errorDescription:='Поле "'+p_text.Hint+'" не должно заканчиваться знаком препинания';
      Exit;
  end;

  if isExistSpaceWithLine(p_text.Text) then begin
      _errorDescription:='Поле "'+p_text.Hint+'" не должно заканчиваться пробелом';
      Exit;
  end;

  // проверка чтобы собощение было с заглавной буквы
  if not IsFirstCharUpperCyrillic(p_text.Text) then begin
     _errorDescription:='Поле "'+p_text.Hint+'" должно начинаться с заглавной буквы';
      Exit;
  end;

  // проверка орфографии
  Spelling:=TSpelling.Create(p_text, True);
  if Spelling.isExistErrorSpelling then begin
    _errorDescription:='Поле "'+p_text.Hint+'" присутствуют орфографические ошибки!'+#13+
                       'Если ошибки нет, добавьте слово в словарь'+#13+
                       'ВАЖНО! Не нужно бездумно все слова добавлять'+#13#13#13+
                       'Выберите слово, нажмите пр.кл.мыши и выбрите "добавить в словарь"';
    Exit;
  end;

  Result:=True;
end;


// проверка параметров(имя)
function TMessageGeneratorSMS.CheckParamsName(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if Length(m_form.reName.Text) = 0 then begin
   _errorDescription:='Не заполнено поле "Имя"';
   Exit;
  end;

  // проверяем на орфорграфические ошибки
  if not CheckParamsSpelling(m_form.reName, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;


// проверка параметров(отчетсво)
function TMessageGeneratorSMS.CheckParamsOtchestvo(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if Length(m_form.reOtchestvo.Text) = 0 then begin
   _errorDescription:='Не заполнено поле "Отчество"';
   Exit;
  end;

  // проверяем на орфорграфические ошибки
  if not CheckParamsSpelling(m_form.reOtchestvo, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;

// проверка параметров(пол)
function TMessageGeneratorSMS.CheckParamsPol(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if m_form.combox_Pol.ItemIndex = -1 then begin
   _errorDescription:='Не выбрано поле "Пол"';
   Exit;
  end;

  Result:=True;
end;

// проверка параметров(адрес клиники)
function TMessageGeneratorSMS.CheckParamsAddressClinic(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if m_form.combox_AddressClinic.ItemIndex = -1 then begin
   _errorDescription:='Не выбрано поле "Клиника"';
   Exit;
  end;

  Result:=True;
end;

// проверка параметров(дата и время приема)
function TMessageGeneratorSMS.CheckParamsDateOfPriem(var _errorDescription:string):Boolean;
const
 cINTERVAL:Word = 1800; // 30 мин
var
 currentTime:int64;
 messageTime:Int64;
 messageDateTime:TDateTime;
begin
  Result:=False;
  _errorDescription:='';

  currentTime:=DateTimeToUnix(now);

  messageDateTime:=DateOf(m_form.dateShow.DateTime) + TimeOf(m_form.timeShow.DateTime);
  messageTime:=DateTimeToUnix(messageDateTime);

  if messageTime < currentTime then begin
   _errorDescription:='Время в смс сообщении будет из прошлого! Установите правильное время';
   Exit;
  end;

   if currentTime+cINTERVAL > messageTime then begin
   _errorDescription:='Смс отправляем за 30 мин до начала приема? Что то мало вероятно. Установите правильное время';
   Exit;
  end;

  Result:=True;
end;

// проверка параметров(кол-во услуг)
function TMessageGeneratorSMS.CheckParamsServiceCount(const p_service:TStringList; var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if p_service.Count = 0 then begin
    _errorDescription:='Не выбраны улуги';
   Exit;
  end;

  Result:=True;
end;

// проверка параметров(сумма)
function TMessageGeneratorSMS.CheckParamsMoney(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if Length(m_form.edtSumma.Text) = 0 then begin
   _errorDescription:='Не заполнено поле "Сумма"';
   Exit;
  end;

  Result:=True;
end;

// проверка параметров(причина)
function TMessageGeneratorSMS.CheckParamsReason(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // проверяем заполнено ли имя
  if Length(m_form.reReason.Text) = 0 then begin
   _errorDescription:='Не заполнено поле "Причина"';
   Exit;
  end;

  // проверяем на орфорграфические ошибки
  if not CheckParamsSpelling(m_form.reReason, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;

// сгенерировали ли сообщение
function TMessageGeneratorSMS.IsExistMessage:Boolean;
begin
  Result:=False;
  if Length(m_generetedMessage) <> 0 then Result:=True;
end;


// проверка параметров
function TMessageGeneratorSMS.CheckParams(_generate:enumReasonSmsMessage;
                                          const p_service:TStringList;
                                          isAutoPodbor:Boolean;
                                          var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // имя + отчетсво + пол проверяется глобально (не проверяем если через автоподбор зашли)
  if not isAutoPodbor then begin
    begin
      if not CheckParamsName(_errorDescription) then begin
        Exit;
      end;

      if not CheckParamsOtchestvo(_errorDescription) then begin
        Exit;
      end;

      if not CheckParamsPol(_errorDescription) then begin
        Exit;
      end;
    end;
  end;


  case _generate of
   reason_OtmenaPriema: begin                       // Отмена приема врача, перенос
     // ничего не проверяется уже все проверили
   end;
   reason_NapominanieOPrieme:begin                  // Напоминание о приеме
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // время
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_NapominanieOPrieme_do15:begin             // Напоминание о приеме (до 15 лет)
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // время
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_NapominanieOPrieme_OMS:begin              // Напоминание о приеме (ОМС)
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // время
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // Истекает срок годности биоматериала
    // время
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_AnalizNaPereustanovke:begin               // Анализ на переустановке
    // ничего не проверяется уже все проверили
   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // Увеличился срок выполнения лабораторных исследований по тех. причинам
    // ничего не проверяется уже все проверили
   end;
   reason_Perezabor:begin                           // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)

    // проверка параметров(кол-во услуг)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;

    // проверка параметров(причина)
    if not CheckParamsReason(_errorDescription) then Exit;

   end;
   reason_Critical:begin                            // Получено письмо из лаборатории о критических значениях
      // ничего не проверяется уже все проверили
   end;
   reason_ReadyDiagnostic:begin                     // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)
     // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReadyNalog:begin                          // Готова справка в налоговую
     // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReadyDocuments:begin                      // Готова копия мед. документации, выписка, справка
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_NeedDocumentsLVN:begin                    // Необходимо предоставить данные для открытия ЛВН (СНИЛС)
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_NeedDocumentsDMS:begin                    // Проинформировать о согласовании услуг по ДМС (когда обещали)
    // ничего не проверяется уже все проверили
   end;
   reason_VneplanoviiPriem:begin                    // Согласован внеплановый прием (обозначить время)
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReturnMoney:begin                         // Пригласить за возвратом ДС
    // проверка параметров(кол-во услуг)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // проверка параметров(сумма)
    if not CheckParamsMoney(_errorDescription) then Exit;

    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReturnMoneyInfo:begin                     // Проинформировать об осуществлении возврата ДС

    // проверка параметров(кол-во услуг)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // проверка параметров(сумма)
    if not CheckParamsMoney(_errorDescription) then Exit;

   end;
   reason_ReturnDiagnostic:begin                    // Пригласить за гистологическим (цитологическим) материалом
    // адрес клиники
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
  end;

  Result:=True;
end;


// создание сгенерированного собощения
procedure TMessageGeneratorSMS.CreateMessage(_genereate:enumReasonSmsMessage;
                                             _gender:enumGender;
                                             _name:string; _otchestvo:string;
                                             const _serviceCount:TStringList;
                                             _money:string;
                                             const _prichina:string);
var
 template:TStringBuilder;
 tmp:string;
 workingTimeClinic:TWorkingTimeClinic;
 clinicId:Integer;
begin
  m_generetedMessage:='';

  template:=EnumReasonSmsMessageTemplateToString(EnumReasonSmsMessageToEnumReasonSmsMessageTemplate(_genereate));
  tmp:=template.ToString;

  // создание обращения (Уважаемый(-ая) ИО)
  GenerateMessageFIO(tmp, _gender, _name, _otchestvo);

  // время работы клиники
  if m_form.combox_AddressClinic.ItemIndex <> -1 then begin
    clinicId:=GetClinicId(m_form.combox_AddressClinic.Items[m_form.combox_AddressClinic.ItemIndex]);
    if clinicId <> -1 then begin
      workingTimeClinic:=TWorkingTimeClinic.Create(clinicId);
    end;
  end;

  case _genereate of
   reason_OtmenaPriema: begin                       // Отмена приема врача, перенос
     // тут нет ничего, т.к. уже сформировали в GenerateMessageFIO

   end;
   reason_NapominanieOPrieme:begin                  // Напоминание о приеме

     // дата
     GenerateMessageDate(tmp);

     // время
     GenerateMessageTime(tmp);

      // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NapominanieOPrieme_do15:begin             // Напоминание о приеме (до 15 лет)

      // записан(-на)
     GenerateMessagePol(tmp, _gender);

      // дата
     GenerateMessageDate(tmp);

     // время
     GenerateMessageTime(tmp);

      // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NapominanieOPrieme_OMS:begin              // Напоминание о приеме (ОМС)

      // дата
     GenerateMessageDate(tmp);

     // время
     GenerateMessageTime(tmp);

      // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // Истекает срок годности биоматериала
        // дата
     GenerateMessageDate(tmp);

     // время
     GenerateMessageTime(tmp);

   end;
   reason_AnalizNaPereustanovke:begin               // Анализ на переустановке
      // тут нет ничего, т.к. уже сформировали в GenerateMessageFIO

   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // Увеличился срок выполнения лабораторных исследований по тех. причинам

      // дата
     GenerateMessageDate(tmp);

   end;
   reason_Perezabor:begin                           // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)

      // кол-во услуг
     GenerateMessageServiceCount(tmp,_serviceCount);

     // причина
     GenerateMessagePrichina(tmp, _prichina);

      // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_Critical:begin                            // Получено письмо из лаборатории о критических значениях
     // тут нет ничего, т.к. уже сформировали в GenerateMessageFIO

   end;
   reason_ReadyDiagnostic:begin                     // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)

     // время работы клиники
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReadyNalog:begin                          // Готова справка в налоговую

     // время работы клиники
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReadyDocuments:begin                      // Готова копия мед. документации, выписка, справка

     // время работы клиники
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NeedDocumentsLVN:begin                    // Необходимо предоставить данные для открытия ЛВН (СНИЛС)

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NeedDocumentsDMS:begin                    // Проинформировать о согласовании услуг по ДМС (когда обещали)
     // тут нет ничего, т.к. уже сформировали в GenerateMessageFIO

   end;
   reason_VneplanoviiPriem:begin                    // Согласован внеплановый прием (обозначить время)

     // время
     GenerateMessageTime(tmp);

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReturnMoney:begin                         // Пригласить за возвратом ДС

    // лист с улугами
    GenerateMessageServiceList(tmp, _serviceCount);

    // сумма денег
    GenerateMessageMoney(tmp, _money);

    // адрес клиники
    GenerateMessageAddressClinic(tmp);

   end;
   reason_ReturnMoneyInfo:begin                     // Проинформировать об осуществлении возврата ДС

     // дата
     GenerateMessageDate(tmp);

     // лист с улугами
    GenerateMessageServiceList(tmp, _serviceCount);

    // сумма денег
    GenerateMessageMoney(tmp, _money);

   end;
   reason_ReturnDiagnostic:begin                    // Пригласить за гистологическим (цитологическим) материалом

     // время работы клиники
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // адрес клиники
     GenerateMessageAddressClinic(tmp);

   end;
  end;

  m_generetedMessage:=tmp;
end;

// пример сообщения (берется из бд history_sms_sending)
function TMessageGeneratorSMS.GetExampleMessage(_messageType:enumReasonSmsMessage):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countTemplate:Integer;
begin

  if _messageType = reason_Empty then begin
    Result:='Не выбран "Тип сообщения"';
    Exit;
  end;

  Result:='Примеров пока нет';

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
      SQL.Add('select message from history_sms_sending where sms_type = '+#39+inttostr(EnumReasonSmsMessageToInteger(_messageType)) +#39+' order by date_time DESC limit 1');

      Active:=True;

      if Fields[0].Value <> Null then begin
        if Length(VarToStr(Fields[0].Value)) > 0 then begin
          Result:=VarToStr(Fields[0].Value);
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

// очистка сообщения
procedure TMessageGeneratorSMS.ClearMessage;
begin
  m_generetedMessage:='';
end;

end.