unit FunctionUnit;

interface

uses
FormHomeUnit,
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
 System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
 Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
 IdSSL,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,System.IniFiles,
 Winapi.WinSock,  Vcl.ComCtrls, GlobalVariables, Vcl.Grids, Data.Win.ADODB,
 Data.DB, IdException, TPacientsListUnit, Vcl.Menus, System.SyncObjs,
 TCustomTypeUnit, Word_TLB, ActiveX;


function GetSMS(inPacientPhone:string):string; overload;                                      // �������� ��� v2
function GetSMSStatusID(inPacientPhone:string):string;                                        // �������� ��� �������
procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);                         // ������� � �������� ����� ���� ������� ���������
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;                             // ���-�� ��� ������� ���� ����������



// �����������
function LoadData(InFileExcel:string; var _errorDescription:string;
                  var p_Status:TStaticText;
                  var p_CountSending:TLabel;
                  var p_CountNotSending:TLabel):Boolean;                                      // �������� excel
procedure OptionsStyle(InOptionsType:enumSendingOptions);                                     // ����� ���� ������������� ���
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;    // �������� ������������ ������ �������� ��� �����
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean; // �������� ������ ����� ���������
function IsPunctuationOrDigit(ch: Char;
                              InCheckOnlyPunctuation:Boolean = False;
                              InCheckMinimalPunctuation:Boolean=False): Boolean;      // �������� �� ���� ���������� ��� �����
function IsOnlyNumber(ch: Char): Boolean;                                                     // �������� ������ �� ����� �����
function IsLetter(ch: Char): Boolean;                                                         // �������� ������ �� �����
function IsFirstCharUpperCyrillic(const S: string): Boolean;                                  // �������� ��� ������ ����� ��� ��������� �����
function isExistSpaceWithLine(const S: string): Boolean;                                      // �������� �� ������ � ����� ������
function isWordExistPunctuation(var _stroka:TRichEdit; var _errorDescription:string):Boolean; // �������� ����� �� ���� ���� ����� ���� (����������,������ | ,����������� | �.��������)
function CreateSMSMessage(var InMessage:TRichEdit):string;                                    // ������ ��������� ����� ��� ���� � 1 ������
function SendingMessage(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean; // �������� ���������
procedure ClearParamsForm(InOptionsType:enumSendingOptions);                                  // ������� ����� �����
procedure ShowOrHideLog(InOptions:enumFormShowingLog);                                        // ����������� ��� �������� ���
function isExistExcel(var _errorDescriptions:string):Boolean;                                 // �������� ���������� �� excel
procedure CreateCopyright;                                                                    // �������� Copyright
procedure ShowCountTodaySmsSending;                                                           // ������� ������� �� ������� ���������� ��� ����
procedure ShowSaveTemplateMessage(var p_PageControl:TPageControl;
                                  var p_ListView:TListView;
                                  InTemplate:enumTemplateMessage;
                                  var p_NoMessageInfo:TStaticText);                           // ������� �������� ���������
procedure ClearListView(var p_ListView:TListView);                                            // ������� StringGrid
procedure SaveMyTemplateMesaage(InMessage:string; IsGlobal:Boolean = False);                  // ������ � �������� ������������� ���������
function isExistMyTemplateMessage(InMessage:string; isGlobal:Boolean = False):Boolean;        // ���� �� ����� ��������� ��� � �������� ���������
function isValidPacientFields(var Pacient:TListPacients):Boolean;                             // �������� �� ������������ ������ �� excel �����
procedure ClearTabs(InOptionsType:enumSendingOptions);                                        // ������� ���� ����� ��������
procedure AddMessageFromTemplate(InMessage:string);                                           // ���������� ��������� �� �������� �� �������� ���������
procedure SaveMyTemplateMessage(id:Integer; InNewMessage:string; IsDelete:Boolean = False);   // �������������� ��������� � ����������� ��������
procedure SendingRemember(isShowLog:Boolean; var _executeTime:Cardinal);                      // �������� �������� sms � ����������� ������
procedure SignSMS;                                                                            // ���� �� ����������� ��������� ������� � ��� ���������
procedure CreatePopMenuAddressClinic(var p_PopMenu:TPopupMenu; var p_Message:TRichEdit);      // �������� ������ � �������� ������ ��� �������� ������� � ���
procedure ShowSendingManualPhone(InSendingType:enumManualSMS);                                // ����� ���� ��� ������ �������� SMS (1 SMS ��� �������)
function GetCountSendingSMSToday:Integer;                                                     // ���-�� ������������ �� ������� ���


implementation

uses
  FormMyTemplateUnit, TSendSMSUint, TAddressClinicPopMenuUnit, TThreadSendSMSUnit, TSpellingUnit;



// �������� ������������ ������ �������� ��� �����
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;
var
 telefon:string;
 i:Integer;
begin
  Result:=False;
  _errorDEscription:='';

  telefon:=InNumberPhone;

   // ����� ������ ���������� � 8
   if telefon[1]<>'8' then begin
    _errorDescription:='����� �������� "'+telefon+'" ������ ���������� � 8';
    Exit;
   end;

   // �����
   if (Length(telefon)<>11) then begin
    _errorDescription:='������������ ����� �������� "'+telefon+'"'+#13#13+
                       '����� ������ �������� ������ ���� 11 ��������'+#13+'������ ����� '+IntToStr(Length(telefon))+' ��������';
     Exit;
   end;

   // �������� ��� �� ���� ������ �����
   for i:=1 to Length(telefon) do begin
     if not IsOnlyNumber(telefon[i]) then begin
       _errorDescription:='����� �������� "'+telefon+'" ������ ��������� ������ �����';
        Exit;
     end;
   end;


   Result:=True;
end;


// �������� �� ���� ���������� ��� �����
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

// �������� �� ������ � ����� ������
function isExistSpaceWithLine(const S: string): Boolean;
begin
  Result := EndsStr(' ', S);
end;

// �������� ������ �� ����� �����
function IsOnlyNumber(ch: Char): Boolean;
begin
  Result := (ch in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']);
end;


// �������� ������ �� �����
function IsLetter(ch: Char): Boolean;
var
  code: Integer;
begin
  code:=Ord(ch);     // �-1040  �-1071   �-1072   �-1103
  Result:=((code >= 1040) or (code <= 1103));
end;


// �������� ��� ������ ����� ��� ��������� �����
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
  // ���������, ��� ������� ��������� � �������� ������
  if (pos < 1) or (pos > Length(S)) then
  begin
    Result := '';
    Exit;
  end;

  // ������� ����� �����
  countPos := 0;
  startPosition:=pos;
  while IsLetter(S[startPosition]) and not isExistSpaceWithLine(S[startPosition]) do begin
   Inc(countPos);
   Inc(startPosition);
  end;

  // ��������� �����
  Result := Copy(S, pos+1, countPos-1);
end;

// �������� ����� �� ���� ���� ����� ���� (����������,������ | ,����������� | �.��������)
function isWordExistPunctuation(var _stroka:TRichEdit; var _errorDescription:string):Boolean;
var
  i,startPos: Integer;
  message_tmp,word: string;
begin
  Result := True;  // �� ��������� �������, ��� ���� ������
  _errorDescription := '';

  // ��������� ���������, ����� ��� ���� � ���� �������
  message_tmp := CreateSMSMessage(_stroka);

  // �������� �� ������ ������
  if Trim(message_tmp) = '' then
  begin
    _errorDescription := '��������� �� ������ ���� ������';
    Exit;
  end;

   // ������� ���������� ��� �������� ������ � RichEdit
  _stroka.SelectAll;
  _stroka.SelAttributes.Color := clBlack; // ���� ������ �� ���������
  _stroka.SelAttributes.Style := [];      // ������� ��� �����

  // ��������� �������� �� ����� ������ �� ��� ��� ��������
  if FormHome.isMedsiLinkTelegramBot then begin
    // ���������� ��� ���������
    Result := False;
    Exit;
  end;

  for i := 1 to Length(message_tmp) do
  begin
     if isExistSpaceWithLine(message_tmp[i]) then Continue;

    // ���������, ���� ������� ������ � �����
    if IsLetter(message_tmp[i]) then
    begin
      // ���������, ���� ��������� ������ � �� ������, � �� ��� ���� ����������
      if (i < Length(message_tmp)) then
      begin
        if (not isExistSpaceWithLine(message_tmp[i+1])) and
           IsPunctuationOrDigit(message_tmp[i],True,True) then
        begin
          // ��������� ��������������
           word :=  GetWordAtPosition(message_tmp, i);
          _errorDescription := Format('����� ������ "%s" � ������ ���������� "%s" ������ ���� ������',
                                      [word, message_tmp[i]]);

          // ������������ �����
          startPos := i - 1; // ����� ��������� � ���� ����������   // ������� ������ �����
          _stroka.SelStart := startPos;           // ������������� ������ ���������
          _stroka.SelLength := Length(word)+1;      // ������������� ����� ���������
          _stroka.SelAttributes.Color := clBlue;  // ������������� ���� �����
          _stroka.SelAttributes.Style := [fsBold];

          Exit;
        end;
      end;
    end;

    // �������� �� ����� ���������
    if (i = Length(message_tmp)) then
    begin
      if IsPunctuationOrDigit(message_tmp[i], True) then
      begin
        _errorDescription := '��������� �� ������ ������������� ������ ����������';
        Exit;
      end;
    end;
  end;

  Result := False; // ���� ������ �� �������, ���������� False
end;



// �������� ������ ����� ���������
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean;
var
 i:Integer;
 temp_message:string;
 SMS:TSendSMS;
 Spelling:TSpelling;
 resultat:Word;
begin
  Result:=False;
  _errorDescription:='';

  // ��� ������ ���������
   with FormHome do begin
      case InOptionsType of
        options_Manual:begin  // ������ ��������

         // �������
         if SharedSendindPhoneManualSMS.Count = 0 then begin
            _errorDescription:='������ ����� ��������';
            Exit;
         end;

         for i:=0 to SharedSendindPhoneManualSMS.Count-1 do begin
          if not isCorrectNumberPhone(SharedSendindPhoneManualSMS[i],_errorDescription) then begin
            Exit;
          end;
         end;

         if (IsPunctuationOrDigit(re_ManualSMS.Text[1])) or
            (re_ManualSMS.Text[1] = ' ') then begin
            _errorDescription:='��������� �� ������ ���������� �� ����� ����������, ������� ��� �����';
            Exit;
         end;

         if (IsPunctuationOrDigit(re_ManualSMS.Text[Length(re_ManualSMS.Text)], True)) then begin
            _errorDescription:='��������� �� ������ ������������� ������ ����������';
            Exit;
         end;

         if isExistSpaceWithLine(re_ManualSMS.Text) then begin
            _errorDescription:='��������� �� ������ ������������� ��������';
            Exit;
         end;

         // �������� ����� ��������� ���� � ��������� �����
         if not IsFirstCharUpperCyrillic(re_ManualSMS.Text) then begin
           _errorDescription:='��������� ������ ���������� � ��������� �����';
            Exit;
         end;

         // �������� ����� �� ��������� ������ �� �������� ��� ��������� �� �� �������
         if not isMedsiLinkTelegramBot then begin
           temp_message:=AnsiLowerCase(re_ManualSMS.Text);
           if AnsiPos(MEDSI_CHAT_BOT_TELEGRAM,temp_message)<>0 then begin
              _errorDescription:='������ �� ��� ��� ������ �������� �����-������� ����� ���������� ����� ���������� �������';
              Exit;
           end;
         end;

         // �������� ����� �� ���� ���� ����� �������� (����������,������ | ,����������� | �.��������)
         if isWordExistPunctuation(re_ManualSMS, _errorDescription) then begin
           Exit;
         end;

         if not chkbox_SignSMS.Checked then begin
           resultat:=MessageBox(Handle,PChar('�� ����������� ����� "�������� ������� � ����� SMS"'+#13#13+
                                             '��� ��� � ��������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);

           if resultat = mrNo then begin
             _errorDescription:='�������� ��������';
             Exit;
           end;
         end;

         // �������� ��������� ����� �� ��������� � ���������
         if chkbox_SignSMS.Checked then begin
           temp_message:=AnsiLowerCase(re_ManualSMS.Text);
           if AnsiPos('���������',temp_message)<>0 then begin
              _errorDescription:='��������� �������� ������� (� ���������)'+#13+
                                 '������� ������� ��� ������� ����� "�������� ������� � ����� SMS"';
              Exit;
           end;
         end;

         // �������� ����� �� ����������� ����� �����
         if chkbox_SignSMS.Checked then begin
           if not isMedsiLinkTelegramBot then begin // �������� ����� ������������ ������ �� ��������
             if AnsiPos('�����',temp_message)<>0 then begin
                _errorDescription:='��������� �������� �������� �������� "�����"'+#13+
                                   '��� ���� ����������� ����� "�������� ������� � ����� SMS"'+#13+
                                   '��� �������� � ����������� ������ � ���������'+#13#13+
                                   '������� �������� ��� ������� ����� "�������� ������� � ����� SMS"';
                Exit;
             end;
           end;
         end;

          // �������� ����������
          Spelling:=TSpelling.Create(re_ManualSMS, True);
          if Spelling.isExistErrorSpelling then begin
            _errorDescription:='� ������ ��������� ������������ ��������������� ������!'+#13+
                               '���� ������ ���, �������� ����� � �������'+#13+
                               '�����! �� ����� �������� ��� ����� ���������'+#13#13#13+
                               '�������� �����, ������� ��.��.���� � ������� "�������� � �������"';
            Exit;
          end;


          // �� � �� �������� �������� ������ ��������� ����� ���� �� ����� �������
          SMS:=TSendSMS.Create(DEBUG);
          if SMS.IsMessageToLong(re_ManualSMS.Text) then begin
            _errorDescription:='��� �� ����!?'+#13+
                               '��������� �������� �� ������ �������� ���������!'+#13#13+
                               '���, ���� ��������� ����� ��������� �� 670 �������� ������ ������� ����������� ��� ����� ����������';
            Exit;
          end;

        end;
        options_Sending:begin // ��������
           if SharedPacientsList.Count = 0 then begin
             _errorDescription:='�� �������� excel ���� � ���������';
             Exit;
           end;
        end;
      end;
   end;

  Result:=True;
end;

// ������ ��������� ����� ��� ���� � 1 ������
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

  Result:=tmp;
end;

// �������� ���������
function SendingMessage(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean;
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
    options_Manual:begin  // ������ ��������
      SMS:=TSendSMS.Create(DEBUG);
      if not SMS.isExistAuth then begin
        _errorDescription:='����������� ��������������� ������ ��� �������� SMS';
        Exit;
      end;

      // ��������� ��������� ����� ��� ���� � ���� �������
      SMSMessage:=CreateSMSMessage(FormHome.re_ManualSMS);

      sendindManualReportError:=TStringList.Create;
      isExistError:=False;

      for i:=0 to SharedSendindPhoneManualSMS.Count-1 do begin
        // �������
        phone:=SharedSendindPhoneManualSMS[i];

        if FormHome.chkbox_SignSMS.Checked then addSign:=True
        else addSign:=False;

        if not SMS.SendSMS(SMSMessage,phone,_errorDescription,addSign) then begin

         if not isExistError then begin
          sendindManualReportError.Add('�� ������� ��������� SMS');
          isExistError:=True;
         end;
         sendindManualReportError.Add(phone+' '+_errorDescription);
         SharedMainLog.Save('�� ������� ��������� SMS �� ����� ('+phone+') : '+SMSMessage+'. ������ : '+_errorDescription, True);
        end else begin
          SharedMainLog.Save('���������� SMS �� ����� ('+phone+') : '+SMSMessage);
        end;
      end;

      if sendindManualReportError.Count <> 0 then
      begin
        _errorDescription:='�� ������� ��������� ��������� �� ������:'+#13#13;
        for i:=0 to sendindManualReportError.Count-1 do begin
         _errorDescription:=_errorDescription+sendindManualReportError[i]+#13;
        end;

        Exit;
      end;
    end;
    options_Sending:begin  // ��������
      SMS:=TSendSMS.Create(DEBUG);
      if not SMS.isExistAuth then begin
        _errorDescription:='����������� ��������������� ������ ��� �������� SMS';
        Exit;
      end;

      // ���������� ���  (� ������ = MAX_COUNT_THREAD_SENDIND)
      showLog:=FormHome.chkboxShowLog.Checked;
      SendingRemember(showLog,executionTime);
      executionTime:= Round(executionTime/1000);
      _errorDescription:='���������� �� '+IntToStr(executionTime)+' ���';
    end;
  end;

  Result:=True;
end;

 // ������� ����� �����
procedure ClearParamsForm(InOptionsType:enumSendingOptions);
begin
  ClearTabs(InOptionsType);
end;

// ����������� ��� �������� ���
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
   // �������� ������� ������
    ScreenWidth := Screen.Width;
    ScreenHeight := Screen.Height;

    // �������� ������� �����
    FormWidth := Width;
    FormHeight := Height;

    // ��������� ����� ���������� ��� ������������� �����
    NewLeft := (ScreenWidth - FormWidth) div 2;
    NewTop := (ScreenHeight - FormHeight) div 2;

    // ������������� ����� ��������� �����
    Left := NewLeft;
    Top := NewTop;
  end;
end;



// ����� ���� ������������� ���
procedure OptionsStyle(InOptionsType:enumSendingOptions);
begin
  with FormHome do begin
   case InOptionsType of
      options_Manual: begin
       btnSendSMS.Caption:=' &��������� SMS';

       edtManualSMS.Text:='';                 // ����� ��������
       //st_PhoneInfo.Visible:=True;            // ���� ��� �������� ������ ���������� � 8
       re_ManualSMS.Clear;                    // ���������

       //chkbox_SignSMS.Checked:=True;          // ������� � ����� SMS
       chkbox_SaveMyTemplate.Checked:=False;  // ��������� ��������� � ��� �������
       chkbox_SaveGlobalTemplate.Checked:=False;  // ��������� ��������� � ���������� �������

       st_ShowInfoAddAddressClinic.Visible:=True; // ������� ��� �������� ����� �������

       SharedSendindPhoneManualSMS.Clear;
       lblManualSMS_List.Caption:='�������';

       isMedsiLinkTelegramBot:=False;
      end;
      options_Sending: begin
       btnSendSMS.Caption:=' &��������� SMS ��������';

       lblNameExcelFile.Caption:=EXCEL_FILE_NOT_LOADED;   // excel ����
       lblNameExcelFile.Hint:='';
       lblNameExcelFile.Font.Color:=clRed;

       lblCountSendingSMS.Caption:='-';          // ���-�� ��� �� ��������
       st_ShowSendingSMS.Visible:=False;      // ����� ������ � ������� ������� ����� ���� ��������� � ���

       lblCountNotSendingSMS.Caption:='-';       // ���-�� ��� � ������� �� ��������
       st_ShowNotSendingSMS.Visible:=False;      // ����� ������ � ������� ������� �� ����� ���� ��������� � ���


       st_ShowInfoAddAddressClinic.Visible:=False; // ������� ��� �������� ����� �������

       ProgressStatusText.Caption:='������ : ���� �� �������� � ������';


       //chkboxShowLog.Checked:=False;          // ���������� ��� ��������

       // ������� ������ �� �������� ���
       SharedPacientsList.Clear;
       SharedPacientsListNotSending.Clear;
      end;
   end;
  end;
end;


// ���������� ��������� �� �������� �� �������� ���������
procedure AddMessageFromTemplate(InMessage:string);
var
 tmp:string;
begin
  with FormHome do begin
    // �������� ������� ������ �� ��� ��� ����� ��������
    begin
      tmp:=AnsiLowerCase(InMessage);
      if AnsiPos(MEDSI_CHAT_BOT_TELEGRAM,tmp)<>0 then isMedsiLinkTelegramBot:=True;
    end;

    re_ManualSMS.Clear;
    re_ManualSMS.Text:=InMessage;
  end;
end;


// �������������� ��������� � ����������� ��������
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

// �������� �������� sms � ����������� ������
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
 sending_end:Boolean;      // ����������� �� ��������
begin
    // ��������� ������� �������� ��� ������� ������
    BaseValue := SharedPacientsList.Count div MAX_COUNT_THREAD_SENDIND;
    Remainder := SharedPacientsList.Count mod MAX_COUNT_THREAD_SENDIND;

    SetLength(Threads, MAX_COUNT_THREAD_SENDIND);
    SetLength(isSending,MAX_COUNT_THREAD_SENDIND);

    // ���������� ������
    StartValue := 0;
    for i := 0 to MAX_COUNT_THREAD_SENDIND - 1 do
    begin
      // ���������� �������� �������� ��� ������
      EndValue := StartValue + BaseValue - 1;

      // ���� ��� ��������� �����, ��������� �������
      if i = MAX_COUNT_THREAD_SENDIND - 1 then EndValue:= EndValue + Remainder;


      // ������� �����
      Threads[i]:= TThreadSendSMS.Create(i + 1, StartValue, EndValue, SharedPacientsList, FormHome.RELog, isShowLog);
      Threads[i].Start;
      isSending[i]:=False;

      // ��������� ��������� �������� ��� ���������� ������
      StartValue:= EndValue + 1;
    end;

  // ������� ���������� ���� ������� � ����������� ��
  try
    StartTime:=GetTickCount;

    while not sending_end do begin
      Application.ProcessMessages;

      for i:=0 to MAX_COUNT_THREAD_SENDIND - 1 do  begin

        if Assigned(Threads[i]) then begin
          try
           if Threads[i].FThreadFinished.WaitFor(0) = wrSignaled then
            begin
              Threads[i].Free; // ����������� ����� ������ ����� ��� ����������
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

      // ��������� �������� ������� �������
      sending_end := True; // �����������, ��� ��� ������ ���������
      for i:= 0 to MAX_COUNT_THREAD_SENDIND - 1 do
      begin
        if Assigned(Threads[i]) and not isSending[i] then
        begin
          sending_end := False; // ���� ���� �� ���� ����� ��� ��������
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


// �������� excel ����� � ����������� � ������
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

   // ������� ������ �� ������ ������
   if SharedPacientsList.Count <> 0 then SharedPacientsList.Clear;
   if SharedPacientsListNotSending.Count <> 0 then SharedPacientsListNotSending.Clear;

    Result:=False;
    _errorDescription:='';
    p_Status.Caption:='������ : �������� � ������';
    Application.ProcessMessages;

   // CurrentPostAddColoredLine('�������� ������',clBlack);

    checkRows:=False;

    Excel:=CreateOleObject('Excel.Application');
    Excel.displayAlerts:=False;
    Excel.workbooks.add;

      //��������� �����
    Excel.Workbooks.Open(InFileExcel);
    //�������� �������� ����
    WorkSheet:=Excel.ActiveWorkbook.ActiveSheet;
    //���������� ���������� ����� � �������� �������
    Rows:=WorkSheet.UsedRange.Rows.Count;
    Cols:=WorkSheet.UsedRange.Columns.Count;

    //��������� ������ ����� ���������
    try
     FData:=WorkSheet.UsedRange.Value;
    except on E:Exception do
        begin
          Screen.Cursor:=crDefault;

          _errorDescription:='�� ������� ��������� ���� � ������'+#13#13+e.ClassName+': '+e.Message;
          p_Status.Caption:='������ : ������ ��� �������� � ������!';
          Application.ProcessMessages;
          Excel.quit;
          Exit;
        end;
    end;


   with FormHome do begin
      // �������� ����� �� ������

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

        // CurrentPostAddColoredLine('������������ ������ ������',clRed);

         Application.ProcessMessages;

         _errorDescription:='������������ ������ ������'+#13#13+
                             '������ ������ �������� ��������� �������:'+#13+
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

        p_Status.Caption:='������ : ������, ������������ ������ �����!';
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
      p_Status.Caption:='������ : �������� � ������ ['+IntToStr(progress)+'%]';

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
        // ������� � ������
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

  p_Status.Caption:='������ : ���������, ������ � ��������';
  p_CountSending.Caption:=IntToStr(SharedPacientsList.Count);
  p_CountNotSending.Caption:=IntToStr(SharedPacientsListNotSending.Count);
  if SharedPacientsList.Count>0 then FormHome.st_ShowSendingSMS.Visible:=True;
  if SharedPacientsListNotSending.Count>0 then FormHome.st_ShowNotSendingSMS.Visible:=True;


  Result:=True;

  Application.ProcessMessages;
  Screen.Cursor:=crDefault;
end;



// �������� ��� v2
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

  // ��������� ������ �� ��������
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
         Result:='������ ��������! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    Result:='OK';
   // Log(MessageSMS,False);

    // ��������� ��������� ������������ ��������� ��� ������� � ���� ��� ������������ �������� ���������
    //AddSaveMessageOld(MessageSMS);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   Sleep(500);
end;


// ���-�� ��� ������� ���� ����������
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


// ������� � �������� ����� ���� ������� ���������
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

  // ����������� ���������
  SMS_ID: string;     // ID sms
  CreatDate: string;    // ���� ����� ���� ������� ���������
  CreatTime: string;    // ����� ����� ���� ������� ���������
  MsgText: string;     // ����� ���������
  Code: string;        // ��� ���
  Status: string;      // ������ ���

  nowbreak:Int64;

begin
  (*
   // ������������ �����
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='������ �������';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' ��������� ...';
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

 // �������� 8 -> 7
 inPacientPhone[1]:='7';
 numberPhoneCount:=GetMsgCount(ResultServer,inPacientPhone);

 nowbreak:=Length(ResultServer);

 // ��������� ������������ ��������� ���������
 if numberPhoneCount=0 then begin
  // FormPleaseWait.Free;

   MessageBox(FormHome.Handle,PChar('�� ������ � '+DateToStr(Now-4)+' �� '+DateToStr(Now)+' ����������� ������������ SMS'),PChar('����������'),MB_OK+MB_ICONSTOP);
   Exit;
 end;

// SetLength(listMsg,numberPhoneCount);
// for i:=0 to numberPhoneCount-1 do listMsg[i]:=TSMSMessage.Create;
// i:=0;

 oldLenghtResult:=Length(ResultServer);

 // ������ ��� ������������ �������� ������������ �����
 while(AnsiPos(MSGSTOP,ResultServer))<> 0 do begin

   //FormHome.ProgressBar.Progress:=100-(Round(100*Length(ResultServer)/oldLenghtResult));
   Application.ProcessMessages;

   tmp:=ResultServer;

   // ������ ������ � ����� ���������
   System.Delete(tmp,1,AnsiPos(MSGSTART,tmp)+Length(MSGSTART));
   System.Delete(tmp,AnsiPos(MSGSTOP,tmp),Length(tmp));

   // ���������
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

   // ��������� ������
    System.Delete(ResultServer,1,AnsiPos(MSGSTOP,ResultServer));

   Dec(nowbreak,1);
   if nowbreak=0 then begin
    // FormPleaseWait.Free;
     MessageBox(FormHome.Handle,PChar('��������� ����� ���������� ��� ������� �������'),PChar('Runtime Error'),MB_OK+MB_ICONERROR);
     Exit;
   end;

 end;

  //FormHome.ProgressBar.Progress:=0;

  //���������� ���������



  //FormPleaseWait.Free;
end;

// �������� ��� �������
function GetSMSStatusID(inPacientPhone:string):string;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet:string;

 FormPleaseWait:TForm;
 lblPlease:TLabel;
begin

   // ������������ �����
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='�������� �������';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' ��������� ...';
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


  // ��������� ������ �� ��������
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

         Result:='������ ��������! '+e.Message+' / '+e.ErrorMessage;
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

  // ������ � ������� �����
  ParsingResultStatusSMS(ServerOtvet,inPacientPhone);
end;

// �������� �� ������������ ������ �� excel �����
function isValidPacientFields(var Pacient:TListPacients):Boolean;
const
 cPHONE_ERROR       :string  = '������������ ����� ��������';
 cPACIENT_ERROR     :string  = '����������� ��� ����c��� � ��������';
 cPACIENT_ERROR2    :string  = '����������� ����c��� � ��������';
 cFIOVRACHA_ERROR   :string  = '�� ������ ������ ��� ��� �����';
var
 i,j:Integer;
 tmp:string;
 exist_space:Boolean;

begin
  Result:=False;

 // �������� ����� ������� ������ �� ���� (Phone)
  begin
   if AnsiPos(' ',Pacient.Phone)<>0 then begin
    // ������������ ������
    Pacient.Phone:=StringReplace(Pacient.Phone,' ','',[rfReplaceAll]);
   end;

   // �������� ����� ����� �������� ��� ������ �������
   if AnsiPos('(9',Pacient.Phone)=0 then begin
      Pacient._errorDescriptions:=cPHONE_ERROR;
      Exit;
   end;

     // �������� �� ��������� ������ ��� ������� ))
   Pacient.Phone:=StringReplace(Pacient.Phone,'(','',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,')','',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,'+7','8',[rfReplaceAll]);
   Pacient.Phone:=StringReplace(Pacient.Phone,'-','',[rfReplaceAll]);


   // ��������� ��������, ����� ������ ����� �� ������ � �� ������ 11 ��������
   if Length(Pacient.Phone)<>11  then begin
    Pacient._errorDescriptions:=cPHONE_ERROR;
    Exit;
   end;

   // � ���������� ����� ������ ����������� ������
   if Pacient.Phone = '89999999999' then begin
    Pacient._errorDescriptions:=cPHONE_ERROR;
    Exit;
   end;

  end;

  if Pacient.IO = '' then begin
    Pacient._errorDescriptions:=cPACIENT_ERROR;
    Exit;
  end;

  // �������� ����� ��� ������
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


  // �������� ������������ ���\������ (���� ������ ����� ������ �����)
  tmp:=AnsiLowerCase(Pacient.FIOVracha);
  if AnsiPos('�����',tmp)<>0 then begin
   Pacient._errorDescriptions:=cFIOVRACHA_ERROR;
   Exit;
  end;


  // �������� ���� �� � ������ ������� �.
  if (AnsiPos('�.',Pacient.ClinicAddress)=0) then Pacient.ClinicAddress:='�. '+Pacient.ClinicAddress;

  Result:=True;
end;

// ������� ���� ����� ��������
procedure ClearTabs(InOptionsType:enumSendingOptions);
begin
   OptionsStyle(InOptionsType);
end;


// �������� ���������� �� excel
function isExistExcel(var _errorDescriptions:string):Boolean;
var
  Excel:OleVariant;
begin
  Result:=False;
  _errorDescriptions:='';

  try
    Excel:=CreateOleObject('Excel.Application');
    Excel:=Unassigned; // ����������� ������

    Result:=True; // ���� ������ ������, ������ Excel ����������
  except
    on E: Exception do begin
      _errorDescriptions:=e.ClassName+#13+E.Message;
    end;
  end;
end;

// �������� Copyright
procedure CreateCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[1].Text:=GetCopyright;
  end;
end;


// ������� ������� �� ������� ���������� ��� ����
procedure ShowCountTodaySmsSending;
begin
   with FormHome.StatusBar do begin
    Panels[0].Text:='  �� ������� ����������: '+IntToStr(GetCountSendingSMSToday);
  end;
end;


// ������� �������� ���������
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
      Caption:=' ������ ���������';
      Width:=cWidth_default;
      Alignment:=taLeftJustify;
    end;
 end;
end;



// ��������� ��������� ���������
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
  //������� stringgrid
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
        // ������� ��� ��� ������
        case InTemplate of
          template_my:begin
           FormMyTemplate.st_NoMessage_MyTemplate.Visible:=True;
           p_PageControl.Pages[0].Caption:='��� ����������� ������� ('+IntToStr(countTemplate)+')';
          end;
          template_global:begin
           FormMyTemplate.st_NoMessage_GlobalTemplate.Visible:=True;
           p_PageControl.Pages[1].Caption:='���������� ������� ('+IntToStr(countTemplate)+')';
          end;
        end;

        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        p_NoMessageInfo.Visible:=True;

        //������� ����
        p_ListView.PopupMenu:=nil;

        Exit;
      end;

      // �������� ������� ��� ��� ������
      p_NoMessageInfo.Visible:=False;
      ////////////////////////////////////////////////////////////////

      SQL.Clear;
      case InTemplate of
        template_my:begin
          SQL.Add('select id,template from sms_template where user_id = '+#39+inttostr(USER_STARTED_SMS_ID) +#39+' and is_global = ''0'' ');
          p_PageControl.Pages[0].Caption:='��� ����������� ������� ('+IntToStr(countTemplate)+')';
        end;
        template_global:begin
          SQL.Add('select id,template from sms_template where is_global = ''1'' ');
          p_PageControl.Pages[1].Caption:='���������� ������� ('+IntToStr(countTemplate)+')';
        end;
      end;
      Active:=True;

      for i:=0 to countTemplate-1 do
      begin
        // ������� �� ������, ��������� �����
        ListItem := p_ListView.Items.Add;
        ListItem.Caption := VarToStr(Fields[0].Value);  // id
        ListItem.SubItems.Add(Fields[1].Value);         // ������ ����� ������������ ���������

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


// ���� �� ����� ��������� ��� � �������� ���������
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
    Result:=True;  // ������� ��� ��������� ����, � ������ ������
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


// ������ � �������� ������������� ���������
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

// ���� �� ����������� ��������� ������� � ��� ���������
procedure SignSMS;
 var
  sms:TSendSMS;
begin
  sms:=TSendSMS.Create(DEBUG);
  with FormHome do begin
    if not sms.isExistAuth then begin
      chkbox_SignSMS.Enabled:=False;
      chkbox_SignSMS.Checked:=False;

      Exit;
    end;

    if sms.GetSignSMS = 'null' then begin
      chkbox_SignSMS.Enabled:=False;
      chkbox_SignSMS.Checked:=False;

      Exit;
    end;

   with chkbox_SignSMS do begin
     Hint:='� ������������� SMS ����� ������������� �������'+#13+#10+'"'+sms.GetSignSMS+'"';
     Checked:=True;
     Enabled:=True;
   end;
  end;
end;

// �������� ������ � �������� ������ ��� �������� ������� � ���
procedure CreatePopMenuAddressClinic(var p_PopMenu:TPopupMenu; var p_Message:TRichEdit);
 var
  address_clinic:TAddressClinicPopMenu;
begin
  address_clinic:=TAddressClinicPopMenu.Create(p_PopMenu, p_Message);
end;

// ����� ���� ��� ������ �������� SMS (1 SMS ��� �������)
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


// ���-�� ������������ �� ������� ���
function GetCountSendingSMSToday:Integer;
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
      SQL.Add('select count(id) from sms_sending where date_time > '+#39+GetCurrentStartDateTime+#39);

      Active:=True;
      Result:= StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
    end;
  end;
end;


end.
