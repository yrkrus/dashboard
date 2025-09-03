 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///       ����� ��� �������� ���������������� ��������� ��� ���               ///
///                  � ����������� �� ���� ���������                          ///
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
      m_generetedMessage          :string;   // ��������������� ���������


      procedure GenerateMessageFIO(var _stroka:string; _gender:enumGender;
                                   _name:string; _otchestvo:string);  // �������� ���������������� ���������� (��� ���������)
      procedure GenerateMessageDate(var _stroka:string);              // �������� ���������������� ���������� (����)
      procedure GenerateMessageTime(var _stroka:string);              // �������� ���������������� ���������� (�����)
      procedure GenerateMessageAddressClinic(var _stroka:string);     // �������� ���������������� ���������� (�������)
      procedure GenerateMessagePol(var _stroka:string; _gender:enumGender);       // �������� ���������������� ���������� (��� �������-��)
      procedure GenerateMessageServiceCount(var _stroka:string; const _serviceChoise:TStringList);        // �������� ���������������� ���������� (���-�� �����)
      procedure GenerateMessagePrichina(var _stroka:string; const _prichina:string);        // �������� ���������������� ���������� (�������)
      procedure GenerateMessageClinicTimeWorking(var _stroka:string;
                                                 const p_workingTime:TWorkingTimeClinic);     // �������� ���������������� ���������� (����� ������ �������)
      procedure GenerateMessageMoney(var _stroka:string; _money:string);       // �������� ���������������� ���������� (����� �����)
      procedure GenerateMessageServiceList(var _stroka:string;
                                           const p_service:TStringList);       // �������� ���������������� ���������� (���� � �������)


      function CheckParamsSpelling(const p_text:TRichEdit; var _errorDescription:string):Boolean;      // �������� ����������
      function CheckParamsName(var _errorDescription:string):Boolean;           // �������� ����������(���)
      function CheckParamsOtchestvo(var _errorDescription:string):Boolean;      // �������� ����������(��������)
      function CheckParamsPol(var _errorDescription:string):Boolean;            // �������� ����������(���)
      function CheckParamsAddressClinic(var _errorDescription:string):Boolean;  // �������� ����������(����� �������)
      function CheckParamsDateOfPriem(var _errorDescription:string):Boolean;    // �������� ����������(���� � ����� ������)
      function CheckParamsServiceCount(const p_service:TStringList; var _errorDescription:string):Boolean;   // �������� ����������(���-�� �����)
      function CheckParamsMoney(var _errorDescription:string):Boolean;          // �������� ����������(�����)
      function CheckParamsReason(var _errorDescription:string):Boolean;         // �������� ����������(�������)

      function IsExistMessage:Boolean; // ������������� �� ���������

      public
      constructor Create(var p_Form:TFormGenerateSMS);                   overload;

      procedure Clear;
      function CheckParams(_generate:enumReasonSmsMessage;
                           const p_service:TStringList;
                           isAutoPodbor:Boolean;
                           var _errorDescription:string):Boolean;  // �������� ����������
      procedure CreateMessage(_genereate:enumReasonSmsMessage;
                              _gender:enumGender;
                              _name:string; _otchestvo:string;
                              const _serviceCount:TStringList;
                              _money:string;
                              const _prichina:string);       // �������� ���������������� ���������

      function GetExampleMessage(_messageType:enumReasonSmsMessage):string; // ������ ��������� (������� �� �� history_sms_sending)
      procedure ClearMessage;     // ������� ���������

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


// �������� ���������������� ���������� (��� ���������)
procedure TMessageGeneratorSMS.GenerateMessageFIO(var _stroka:string; _gender:enumGender; _name:string; _otchestvo:string);
begin

  case _gender of
   gender_male:begin
     _stroka:=StringReplace(_stroka,'%uvazaemii%','���������',[rfReplaceAll]);
   end;
   gender_female:begin
     _stroka:=StringReplace(_stroka,'%uvazaemii%','���������',[rfReplaceAll]);
   end;
  end;

  _stroka:=StringReplace(_stroka,'%name%',_name,[rfReplaceAll]);
  _stroka:=StringReplace(_stroka,'%otchestvo%',_otchestvo,[rfReplaceAll]);
end;



// �������� ���������������� ���������� (����)
procedure TMessageGeneratorSMS.GenerateMessageDate(var _stroka:string);
var
  date:TDate;
begin
  date:=m_form.dateShow.Date;
 _stroka:=StringReplace(_stroka,'%date%',DateToStr(date),[rfReplaceAll]);
end;

// �������� ���������������� ���������� (�����)
procedure TMessageGeneratorSMS.GenerateMessageTime(var _stroka:string);
var
  time:TTime;
begin
   time:=m_form.timeShow.Time;
  _stroka := StringReplace(_stroka, '%time%', FormatDateTime('hh:nn', time), [rfReplaceAll]);
end;


// �������� ���������������� ���������� (�������)
procedure TMessageGeneratorSMS.GenerateMessageAddressClinic(var _stroka:string);
var
 clinicAddress:string;
begin
   clinicAddress:=m_form.combox_AddressClinic.Items[m_form.combox_AddressClinic.ItemIndex];
   _stroka:=StringReplace(_stroka,'%address%',clinicAddress,[rfReplaceAll]);
end;

// �������� ���������������� ���������� (��� �������-��)
procedure TMessageGeneratorSMS.GenerateMessagePol(var _stroka:string; _gender:enumGender);
begin
 case _gender of
   gender_male:begin
     _stroka:=StringReplace(_stroka,'%pol%','�������',[rfReplaceAll]);
   end;
   gender_female:begin
     _stroka:=StringReplace(_stroka,'%pol%','��������',[rfReplaceAll]);
   end;
  end;
end;

// �������� ���������������� ���������� (���-�� �����)
procedure TMessageGeneratorSMS.GenerateMessageServiceCount(var _stroka:string; const _serviceChoise:TStringList);
begin
  if _serviceChoise.Count = 1 then begin
   _stroka:=StringReplace(_stroka,'%labs%','������������',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%study%','������������',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%maybe%','�����',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%done%','���������',[rfReplaceAll]);
  end
  else begin
   _stroka:=StringReplace(_stroka,'%labs%','������������',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%study%','������������',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%maybe%','�����',[rfReplaceAll]);
   _stroka:=StringReplace(_stroka,'%done%','���������',[rfReplaceAll]);
  end;
end;


// �������� ���������������� ���������� (�������)
procedure TMessageGeneratorSMS.GenerateMessagePrichina(var _stroka:string; const _prichina:string);
var
 tmp:string;
begin
  tmp:=AnsiLowerCase(_prichina); // ��� � ��������� ������
  _stroka:=StringReplace(_stroka,'%prichina%',tmp,[rfReplaceAll]);
end;


// �������� ���������������� ���������� (����� ������ �������)
procedure TMessageGeneratorSMS.GenerateMessageClinicTimeWorking(var _stroka:string; const p_workingTime:TWorkingTimeClinic);
begin
  _stroka:=StringReplace(_stroka,'%time_clinic%',p_workingTime.GetWorking,[rfReplaceAll]);
end;

// �������� ���������������� ���������� (����� �����)
procedure TMessageGeneratorSMS.GenerateMessageMoney(var _stroka:string; _money:string);
begin
  _stroka:=StringReplace(_stroka,'%money%',_money,[rfReplaceAll]);
end;


// �������� ���������������� ���������� (���� � �������)
procedure TMessageGeneratorSMS.GenerateMessageServiceList(var _stroka:string; const p_service:TStringList);
var
 i:Integer;
 tmp:string;
begin
  tmp:='';
  if p_service.Count > 1 then tmp:='������ "'
  else tmp:='������ "';

  for i:=0 to p_service.Count-1 do begin
    if i=0 then tmp:=tmp+p_service[i]
    else tmp:=tmp+', '+p_service[i];
  end;

  tmp:=tmp+'"';

  _stroka:=StringReplace(_stroka,'%list_service%',tmp,[rfReplaceAll]);
end;



// �������� ����������
function TMessageGeneratorSMS.CheckParamsSpelling(const p_text:TRichEdit; var _errorDescription:string):Boolean;
var
 Spelling:TSpelling;
begin
  Result:=False;

  if (IsPunctuationOrDigit( p_text.Text[1])) or
      (p_text.Text[1] = ' ') then begin
      _errorDescription:='���� "'+p_text.Hint+'" �� ������ ���������� �� ����� ����������, ������� ��� �����';
      Exit;
  end;

  if (IsPunctuationOrDigit(p_text.Text[Length(p_text.Text)], True)) then begin
      _errorDescription:='���� "'+p_text.Hint+'" �� ������ ������������� ������ ����������';
      Exit;
  end;

  if isExistSpaceWithLine(p_text.Text) then begin
      _errorDescription:='���� "'+p_text.Hint+'" �� ������ ������������� ��������';
      Exit;
  end;

  // �������� ����� ��������� ���� � ��������� �����
  if not IsFirstCharUpperCyrillic(p_text.Text) then begin
     _errorDescription:='���� "'+p_text.Hint+'" ������ ���������� � ��������� �����';
      Exit;
  end;

  // �������� ����������
  Spelling:=TSpelling.Create(p_text, True);
  if Spelling.isExistErrorSpelling then begin
    _errorDescription:='���� "'+p_text.Hint+'" ������������ ��������������� ������!'+#13+
                       '���� ������ ���, �������� ����� � �������'+#13+
                       '�����! �� ����� �������� ��� ����� ���������'+#13#13#13+
                       '�������� �����, ������� ��.��.���� � ������� "�������� � �������"';
    Exit;
  end;

  Result:=True;
end;


// �������� ����������(���)
function TMessageGeneratorSMS.CheckParamsName(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if Length(m_form.reName.Text) = 0 then begin
   _errorDescription:='�� ��������� ���� "���"';
   Exit;
  end;

  // ��������� �� ���������������� ������
  if not CheckParamsSpelling(m_form.reName, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;


// �������� ����������(��������)
function TMessageGeneratorSMS.CheckParamsOtchestvo(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if Length(m_form.reOtchestvo.Text) = 0 then begin
   _errorDescription:='�� ��������� ���� "��������"';
   Exit;
  end;

  // ��������� �� ���������������� ������
  if not CheckParamsSpelling(m_form.reOtchestvo, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;

// �������� ����������(���)
function TMessageGeneratorSMS.CheckParamsPol(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if m_form.combox_Pol.ItemIndex = -1 then begin
   _errorDescription:='�� ������� ���� "���"';
   Exit;
  end;

  Result:=True;
end;

// �������� ����������(����� �������)
function TMessageGeneratorSMS.CheckParamsAddressClinic(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if m_form.combox_AddressClinic.ItemIndex = -1 then begin
   _errorDescription:='�� ������� ���� "�������"';
   Exit;
  end;

  Result:=True;
end;

// �������� ����������(���� � ����� ������)
function TMessageGeneratorSMS.CheckParamsDateOfPriem(var _errorDescription:string):Boolean;
const
 cINTERVAL:Word = 1800; // 30 ���
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
   _errorDescription:='����� � ��� ��������� ����� �� ��������! ���������� ���������� �����';
   Exit;
  end;

   if currentTime+cINTERVAL > messageTime then begin
   _errorDescription:='��� ���������� �� 30 ��� �� ������ ������? ��� �� ���� ��������. ���������� ���������� �����';
   Exit;
  end;

  Result:=True;
end;

// �������� ����������(���-�� �����)
function TMessageGeneratorSMS.CheckParamsServiceCount(const p_service:TStringList; var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if p_service.Count = 0 then begin
    _errorDescription:='�� ������� �����';
   Exit;
  end;

  Result:=True;
end;

// �������� ����������(�����)
function TMessageGeneratorSMS.CheckParamsMoney(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if Length(m_form.edtSumma.Text) = 0 then begin
   _errorDescription:='�� ��������� ���� "�����"';
   Exit;
  end;

  Result:=True;
end;

// �������� ����������(�������)
function TMessageGeneratorSMS.CheckParamsReason(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��������� ��������� �� ���
  if Length(m_form.reReason.Text) = 0 then begin
   _errorDescription:='�� ��������� ���� "�������"';
   Exit;
  end;

  // ��������� �� ���������������� ������
  if not CheckParamsSpelling(m_form.reReason, _errorDescription) then begin
    Exit;
  end;

  Result:=True;
end;

// ������������� �� ���������
function TMessageGeneratorSMS.IsExistMessage:Boolean;
begin
  Result:=False;
  if Length(m_generetedMessage) <> 0 then Result:=True;
end;


// �������� ����������
function TMessageGeneratorSMS.CheckParams(_generate:enumReasonSmsMessage;
                                          const p_service:TStringList;
                                          isAutoPodbor:Boolean;
                                          var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  // ��� + �������� + ��� ����������� ��������� (�� ��������� ���� ����� ���������� �����)
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
   reason_OtmenaPriema: begin                       // ������ ������ �����, �������
     // ������ �� ����������� ��� ��� ���������
   end;
   reason_NapominanieOPrieme:begin                  // ����������� � ������
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // �����
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_NapominanieOPrieme_do15:begin             // ����������� � ������ (�� 15 ���)
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // �����
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_NapominanieOPrieme_OMS:begin              // ����������� � ������ (���)
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
    // �����
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // �������� ���� �������� ������������
    // �����
    if not CheckParamsDateOfPriem(_errorDescription) then Exit;
   end;
   reason_AnalizNaPereustanovke:begin               // ������ �� �������������
    // ������ �� ����������� ��� ��� ���������
   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // ���������� ���� ���������� ������������ ������������ �� ���. ��������
    // ������ �� ����������� ��� ��� ���������
   end;
   reason_Perezabor:begin                           // ��������� ��������� ����� (�����, �������, ������������ ������������)

    // �������� ����������(���-�� �����)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;

    // �������� ����������(�������)
    if not CheckParamsReason(_errorDescription) then Exit;

   end;
   reason_Critical:begin                            // �������� ������ �� ����������� � ����������� ���������
      // ������ �� ����������� ��� ��� ���������
   end;
   reason_ReadyDiagnostic:begin                     // ����� ��������� ����������� (��������,  �������, �����)
     // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReadyNalog:begin                          // ������ ������� � ���������
     // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReadyDocuments:begin                      // ������ ����� ���. ������������, �������, �������
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_NeedDocumentsLVN:begin                    // ���������� ������������ ������ ��� �������� ��� (�����)
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_NeedDocumentsDMS:begin                    // ���������������� � ������������ ����� �� ��� (����� �������)
    // ������ �� ����������� ��� ��� ���������
   end;
   reason_VneplanoviiPriem:begin                    // ���������� ����������� ����� (���������� �����)
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReturnMoney:begin                         // ���������� �� ��������� ��
    // �������� ����������(���-�� �����)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // �������� ����������(�����)
    if not CheckParamsMoney(_errorDescription) then Exit;

    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
   reason_ReturnMoneyInfo:begin                     // ���������������� �� ������������� �������� ��

    // �������� ����������(���-�� �����)
    if not CheckParamsServiceCount(p_service, _errorDescription) then Exit;

    // �������� ����������(�����)
    if not CheckParamsMoney(_errorDescription) then Exit;

   end;
   reason_ReturnDiagnostic:begin                    // ���������� �� ��������������� (��������������) ����������
    // ����� �������
    if not CheckParamsAddressClinic(_errorDescription) then Exit;
   end;
  end;

  Result:=True;
end;


// �������� ���������������� ���������
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

  // �������� ��������� (���������(-��) ��)
  GenerateMessageFIO(tmp, _gender, _name, _otchestvo);

  // ����� ������ �������
  if m_form.combox_AddressClinic.ItemIndex <> -1 then begin
    clinicId:=GetClinicId(m_form.combox_AddressClinic.Items[m_form.combox_AddressClinic.ItemIndex]);
    if clinicId <> -1 then begin
      workingTimeClinic:=TWorkingTimeClinic.Create(clinicId);
    end;
  end;

  case _genereate of
   reason_OtmenaPriema: begin                       // ������ ������ �����, �������
     // ��� ��� ������, �.�. ��� ������������ � GenerateMessageFIO

   end;
   reason_NapominanieOPrieme:begin                  // ����������� � ������

     // ����
     GenerateMessageDate(tmp);

     // �����
     GenerateMessageTime(tmp);

      // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NapominanieOPrieme_do15:begin             // ����������� � ������ (�� 15 ���)

      // �������(-��)
     GenerateMessagePol(tmp, _gender);

      // ����
     GenerateMessageDate(tmp);

     // �����
     GenerateMessageTime(tmp);

      // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NapominanieOPrieme_OMS:begin              // ����������� � ������ (���)

      // ����
     GenerateMessageDate(tmp);

     // �����
     GenerateMessageTime(tmp);

      // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // �������� ���� �������� ������������
        // ����
     GenerateMessageDate(tmp);

     // �����
     GenerateMessageTime(tmp);

   end;
   reason_AnalizNaPereustanovke:begin               // ������ �� �������������
      // ��� ��� ������, �.�. ��� ������������ � GenerateMessageFIO

   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // ���������� ���� ���������� ������������ ������������ �� ���. ��������

      // ����
     GenerateMessageDate(tmp);

   end;
   reason_Perezabor:begin                           // ��������� ��������� ����� (�����, �������, ������������ ������������)

      // ���-�� �����
     GenerateMessageServiceCount(tmp,_serviceCount);

     // �������
     GenerateMessagePrichina(tmp, _prichina);

      // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_Critical:begin                            // �������� ������ �� ����������� � ����������� ���������
     // ��� ��� ������, �.�. ��� ������������ � GenerateMessageFIO

   end;
   reason_ReadyDiagnostic:begin                     // ����� ��������� ����������� (��������,  �������, �����)

     // ����� ������ �������
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReadyNalog:begin                          // ������ ������� � ���������

     // ����� ������ �������
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReadyDocuments:begin                      // ������ ����� ���. ������������, �������, �������

     // ����� ������ �������
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NeedDocumentsLVN:begin                    // ���������� ������������ ������ ��� �������� ��� (�����)

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_NeedDocumentsDMS:begin                    // ���������������� � ������������ ����� �� ��� (����� �������)
     // ��� ��� ������, �.�. ��� ������������ � GenerateMessageFIO

   end;
   reason_VneplanoviiPriem:begin                    // ���������� ����������� ����� (���������� �����)

     // �����
     GenerateMessageTime(tmp);

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
   reason_ReturnMoney:begin                         // ���������� �� ��������� ��

    // ���� � �������
    GenerateMessageServiceList(tmp, _serviceCount);

    // ����� �����
    GenerateMessageMoney(tmp, _money);

    // ����� �������
    GenerateMessageAddressClinic(tmp);

   end;
   reason_ReturnMoneyInfo:begin                     // ���������������� �� ������������� �������� ��

     // ����
     GenerateMessageDate(tmp);

     // ���� � �������
    GenerateMessageServiceList(tmp, _serviceCount);

    // ����� �����
    GenerateMessageMoney(tmp, _money);

   end;
   reason_ReturnDiagnostic:begin                    // ���������� �� ��������������� (��������������) ����������

     // ����� ������ �������
     GenerateMessageClinicTimeWorking(tmp,workingTimeClinic);

     // ����� �������
     GenerateMessageAddressClinic(tmp);

   end;
  end;

  m_generetedMessage:=tmp;
end;

// ������ ��������� (������� �� �� history_sms_sending)
function TMessageGeneratorSMS.GetExampleMessage(_messageType:enumReasonSmsMessage):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countTemplate:Integer;
begin

  if _messageType = reason_Empty then begin
    Result:='�� ������ "��� ���������"';
    Exit;
  end;

  Result:='�������� ���� ���';

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

// ������� ���������
procedure TMessageGeneratorSMS.ClearMessage;
begin
  m_generetedMessage:='';
end;

end.