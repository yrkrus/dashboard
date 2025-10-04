unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Menus, ClipBrd, System.ImageList, Vcl.ImgList,RichEdit, TCustomTypeUnit;

type
  TFormHome = class(TForm)
    OpenDialog: TOpenDialog;
    page_TypesSMS: TPageControl;
    sheet_ManualSMS: TTabSheet;
    sheet_SendingSMS: TTabSheet;
    Button1: TButton;
    StatusBar: TStatusBar;
    btnAction: TBitBtn;
    group_ManualSMS: TGroupBox;
    Label1: TLabel;
    edtManualSMS: TEdit;
    btnSaveFirebirdSettings: TBitBtn;
    group_SendingSMS: TGroupBox;
    Label2: TLabel;
    btnLoadFile: TBitBtn;
    GroupBox1: TGroupBox;
    RELog: TRichEdit;
    lblCountSendingSMS: TLabel;
    Label3: TLabel;
    ProgressStatusText: TStaticText;
    Label4: TLabel;
    lblCountNotSendingSMS: TLabel;
    st_ShowNotSendingSMS: TStaticText;
    st_PhoneInfo: TStaticText;
    popmenu_AddressClinic: TPopupMenu;
    lblNameExcelFile: TLabel;
    lblManualSMS_List: TLabel;
    lblManualSMS_One: TLabel;
    ImageList1: TImageList;
    st_ShowSendingSMS: TStaticText;
    panel_message_group: TPanel;
    ST_StatusPanel: TStaticText;
    st_ShowInfoAddAddressClinic: TStaticText;
    panel_ManualSMS: TPanel;
    re_ManualSMS: TRichEdit;
    btnGenerateMessage: TBitBtn;
    btnManualMessage: TBitBtn;
    lblOpenGenerateMessage: TLabel;
    lblinfoEditMessage: TLabel;
    lblManualPodbor: TLabel;
    sheet_StatusSMS: TTabSheet;
    edtFindSMS: TEdit;
    st_PhoneInfo2: TStaticText;
    Label5: TLabel;
    lblManualPodborFindStatus: TLabel;
    ImgNewYear: TImage;
    chkbox_SignSMS: TLabel;
    img_SignSMS: TImage;
    chkbox_SaveMyTemplate: TLabel;
    img_SaveMyTemplate: TImage;
    chkbox_SaveGlobalTemplate: TLabel;
    img_SaveGlobalTemplate: TImage;
    img_ShowLog: TImage;
    chkbox_ShowLog: TLabel;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure page_TypesSMSChange(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseLeave(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure st_ShowNotSendingSMSClick(Sender: TObject);
    procedure edtManualSMSClick(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseLeave(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblManualSMS_ListClick(Sender: TObject);
    procedure lblManualSMS_OneClick(Sender: TObject);
    procedure edtManualSMSChange(Sender: TObject);
    procedure edtManualSMSKeyPress(Sender: TObject; var Key: Char);
    procedure edtManualSMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetSpelling(InValue:Boolean);
    procedure st_ShowInfoAddAddressClinicMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure re_ManualSMSMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure st_ShowSendingSMSMouseLeave(Sender: TObject);
    procedure st_ShowSendingSMSMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure st_ShowSendingSMSClick(Sender: TObject);
    procedure menu_CopyClick(Sender: TObject);
    procedure btnGenerateMessageClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure btnManualMessageClick(Sender: TObject);
    procedure lblOpenGenerateMessageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblinfoEditMessageClick(Sender: TObject);
    procedure lblinfoEditMessageMouseLeave(Sender: TObject);
    procedure lblinfoEditMessageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure lblManualPodborClick(Sender: TObject);
    procedure edtFindSMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFindSMSClick(Sender: TObject);
    procedure edtFindSMSKeyPress(Sender: TObject; var Key: Char);
    procedure lblManualPodborFindStatusClick(Sender: TObject);
    procedure edtFindSMSChange(Sender: TObject);
    procedure img_SignSMSClick(Sender: TObject);
    procedure chkbox_SignSMSClick(Sender: TObject);
    procedure chkbox_SaveMyTemplateClick(Sender: TObject);
    procedure img_SaveMyTemplateClick(Sender: TObject);
    procedure chkbox_SaveGlobalTemplateClick(Sender: TObject);
    procedure img_SaveGlobalTemplateClick(Sender: TObject);
    procedure chkbox_ShowLogClick(Sender: TObject);
    procedure img_ShowLogClick(Sender: TObject);


  private
    { Private declarations }
   isSpelling:Boolean;

   isEditMessage:Boolean;  // ���� ���� ��� ��������� ������������� � ��� ����� ��������� �� ������
   reasonSMS:enumReasonSmsMessage; // ��� ��� ������� ������������


   procedure CopySelectedTextToClipboard; // ����������� � �����
   procedure EnableOrDisableEditMessage(_status:enumParamStatus; _textStatus:string = ''); // ���������\���������� ����������� �������������� ���������
   procedure AutoPodborGenerateSMS;      // ��������� ����������� ��� ����������


  public
    { Public declarations }
  procedure ShowManualMessage;  // ����������� ���� � ������ ������
  procedure SetEditMessage(_status:enumParamStatus; _textStatus:string = '');
  procedure SetReasonSMSType(_reason:enumReasonSmsMessage);
  procedure SetPhoneNumberPodbor(_phone:string);
  procedure SetPhoneNumberFindStatusSMS(_phone:string);

  end;


var
  FormHome: TFormHome;

const
cWIDTH_SHOWLOG:Integer=1193;
cWIDTH_HIDELOG:Integer=513;
cLEFT_PANEL_MESSAGE:Integer=9;

cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';


implementation

uses
  FunctionUnit, GlobalVariables, GlobalVariablesLinkDLL, TSendSMSUint,
  FormMyTemplateUnit, FormNotSendingSMSErrorUnit, FormListSendingSMSUnit,
  TXmlUnit, TSpellingUnit, FormSendingSMSUnit, FormDictionaryUnit, FormGenerateSMSUnit, DMUnit, FormManualPodborUnit, FormManualPodborStatusUnit, FormStatusSendingSMSUnit, FormPodborUnit, TAutoPodborSendingSmsUnit;

 {$R *.dfm}

 // ����������� ���� � ������ ������
procedure TFormHome.ShowManualMessage;
begin
  panel_message_group.Left:=cLEFT_PANEL_MESSAGE;
  panel_message_group.Visible:=True;

  btnGenerateMessage.Visible:=False;
  btnManualMessage.Visible:=False;

  lblOpenGenerateMessage.Visible:=True;
end;

procedure TFormHome.SetEditMessage(_status:enumParamStatus; _textStatus:string = '');
begin
  EnableOrDisableEditMessage(_status, _textStatus);
end;


procedure TFormHome.SetReasonSMSType(_reason:enumReasonSmsMessage);
begin
  reasonSMS:=_reason;
end;

procedure TFormHome.SetPhoneNumberPodbor(_phone:string);
begin
  edtManualSMS.Clear;
  edtManualSMS.Text:=_phone;

  st_PhoneInfo.Visible:=False;
end;


procedure TFormHome.SetPhoneNumberFindStatusSMS(_phone:string);
begin
  edtFindSMS.Clear;
  edtFindSMS.Text:=_phone;

  st_PhoneInfo2.Visible:=False;
end;

// ��������� ����� ��� ���� ��������������� ������
procedure TFormHome.SetSpelling(InValue:Boolean);
begin
  isSpelling:=InValue;
end;

procedure TFormHome.StatusBarClick(Sender: TObject);
begin
 with FormSendingSMS do begin
   SetTodaySendingSms(True);
   Caption:='������������ ���������';
   ShowModal;
 end;
end;

// ����������� � �����
procedure TFormHome.CopySelectedTextToClipboard;
begin
  if re_ManualSMS.SelLength > 0 then // ���������, ���� �� ���������� �����
  begin
    re_ManualSMS.CopyToClipboard; // �������� ���������� ����� � ����� ������
  end
  else MessageBox(Handle,PChar('��� ����������� ������ ��� �����������'),PChar('������'),MB_OK+MB_ICONERROR);
end;


// ���������\���������� ����������� �������������� ���������
procedure TFormHome.EnableOrDisableEditMessage(_status:enumParamStatus; _textStatus:string = '');
begin
  case _status of
    paramStatus_ENABLED: begin
      lblinfoEditMessage.Visible:=False;
      re_ManualSMS.Enabled:=True;

      isEditMessage:=True;
    end;
    paramStatus_DISABLED: begin
      lblinfoEditMessage.Visible:=True;
      re_ManualSMS.Enabled:=False;

      isEditMessage:=False;
    end;
  end;

  if Length(_textStatus) <> 0 then lblinfoEditMessage.Caption:=_textStatus+' (�������� ��������������)';
end;


// ��������� ����������� ��� ����������
procedure TFormHome.AutoPodborGenerateSMS;
var
 phone:string;
 error:string;
begin
  error:='';

  phone:=edtManualSMS.Text;
  phone := StringReplace(phone, #$D, '', [rfReplaceAll]);
  phone := StringReplace(phone, #$A, '', [rfReplaceAll]);

  if phone='' then begin
   FormGenerateSMS.SetPhonePodbor('','������ �����');
   Exit;
  end;

  if not isCorrectNumberPhone(phone,error) then begin
    FormGenerateSMS.SetPhonePodbor('',error);
    Exit;
  end;

  FormGenerateSMS.SetPhonePodbor(phone,error);
end;


procedure TFormHome.btnGenerateMessageClick(Sender: TObject);
begin
  // ����������
  AutoPodborGenerateSMS;

  FormGenerateSMS.ShowModal;
end;

procedure TFormHome.btnLoadFile2Click(Sender: TObject);
var
  TypeReport:Word;
begin
//  if edtExcelSMS.Text<>'' then begin
//   MessageBox(Handle,PChar('�� ������ ������ �������� ���� � ��������� (���)'+#13#13+
//                           '�������� ���� "���" ���� ���������� ��������� ���� � ��������� (���������) '),PChar('������'),MB_OK+MB_ICONERROR);
//   Exit;
//  end;
//
//   with OpenDialog do begin
//     Title:='�������� �����';
//     DefaultExt:='';
//     Filter:='OpenOffice | *.ods';
//     FilterIndex:=1;
//     InitialDir:=FOLDERPATH;
//
//      if Execute then
//      begin
//         FileExcelSMS:=FileName;
//         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
//
//
//         FileExcelSMS:=FileName;
//      end;
//   end;
//
//   // ���������� � ������
//   if FileExcelSMS<>'' then
//   begin
//     if edtExcelSMS.Text<>'' then TypeReport:=1  { ���� � ��������� (���) }
//     else TypeReport:=2;                         { ���� � ��������� (���������) }
//
//     // ��������� ������
//     PreLoadData(TypeReport);
//   end;

end;

procedure TFormHome.btnLoadFileClick(Sender: TObject);
var
 TypeReport:Word;
 FileExcelSMS:string;
 error:string;
 XML:TXML;
 FindPath:string;
 FullPath:string;
begin
  // ����� ����������� ����
  XML:=TXML.Create(PChar(SETTINGS_XML));
  FindPath:=XML.GetFolderPathFindRemember;
  if FindPath = 'null' then FindPath:=FOLDERPATH;


  with OpenDialog do begin
     Title:='�������� �����';
     DefaultExt:='xls';
     Filter:='Excel 2003 � ������ | *.xls|Excel 2007 � �����| *.xlsx';
     FilterIndex:=1;
     InitialDir:=FindPath;

      if Execute then
      begin
         FileExcelSMS:=FileName;
         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
         lblNameExcelFile.Caption:=FileExcelSMS;
         lblNameExcelFile.Hint:=FileName;
         lblNameExcelFile.Font.Color:=clGreen;

         FileExcelSMS:=FileName;

         // ��������� ����
         FullPath:=ExtractFilePath(FileName);
         XML.SetFolderPathFindRemember(FullPath);
      end;
  end;

  if FileExcelSMS='' then Exit;

   // ���������� ��������� ������ � ������
  if not LoadData(FileExcelSMS, error, ProgressStatusText,
                  lblCountSendingSMS,lblCountNotSendingSMS) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;
end;

procedure TFormHome.btnManualMessageClick(Sender: TObject);
begin
  ShowManualMessage;

  isEditMessage:=True;
  re_ManualSMS.Enabled:=True;
end;

procedure TFormHome.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
  FormMyTemplate.ShowModal;
end;

procedure TFormHome.btnActionClick(Sender: TObject);
var
 currentOptions:enumSendingOptions;
 error:string;
 SendindMessage:string;
 i:Integer;
 resultat:Word;
 sendingSMS:TAutoPodborSendingSms;
 countSendindSms:Integer;
begin
  // ��������
  Screen.Cursor:=crHourGlass;

  begin
    case page_TypesSMS.ActivePage.PageIndex of
     0:begin                 // ������ ��������
      currentOptions:=options_Manual;

      // ������� ������ ��������� � ������
      SharedSendindPhoneManualSMS.Clear;
      if Length(edtManualSMS.Text) <> 0 then SharedSendindPhoneManualSMS.Add(edtManualSMS.Text)
      else begin
        for i:=0 to FormListSendingSMS.re_ListSendingSMS.Lines.Count-1 do begin
          SharedSendindPhoneManualSMS.Add(FormListSendingSMS.re_ListSendingSMS.Lines[i]);
        end;
      end;

     end;
     1:begin                  // ��������
      currentOptions:=options_Sending;
     end;
     2:begin                  // ����� ��������
       currentOptions:=options_Find;

       // ������� ����� ��������
      SharedStatusSendingSMS.Clear;
      if Length(edtFindSMS.Text) <> 0 then SharedStatusSendingSMS.Add(edtFindSMS.Text);
     end;
    end;

    if not CheckParamsBeforeSending(currentOptions,isEditMessage, error) then begin
     Screen.Cursor:=crDefault;
     MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
    end;
  end;


   // ���������� ��������� || ���������� ���� �� ������� �������� ���
   case currentOptions of
    options_Manual: begin
      if not SendingMessage(currentOptions, reasonSMS, error) then begin
       Screen.Cursor:=crDefault;
       MessageBox(Handle,PChar(error),PChar('������ ��������'),MB_OK+MB_ICONERROR);
      end
      else begin
        // ������ � �������� ������� ���������
        if  SharedCheckBox.Checked['SaveMyTemplate'] then SaveMyTemplateMesaage(re_ManualSMS.Text);
        if SharedCheckBox.Checked['SaveGlobalTemplate'] then SaveMyTemplateMesaage(re_ManualSMS.Text, ISGLOBAL_MESSAGE);


        Screen.Cursor:=crDefault;
        if SharedSendindPhoneManualSMS.Count > 1 then begin
          MessageBox(Handle,PChar('��������� ���������� �� ��� ������ �� ������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
        end
        else begin
          MessageBox(Handle,PChar('��������� ����������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
        end;
      end;
    end;
    options_Sending:begin
      // �������� ���-��
      if SharedPacientsList.Count > MAX_COUNT_PHONE_SENDING_WARNING then begin
        resultat:=MessageBox(Handle,PChar('� ������� �� �������� ������ '+IntToStr(MAX_COUNT_PHONE_SENDING_WARNING)+' �������'+#13#13+
                                          '����� ����������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
        if resultat = mrNo then Exit;
      end;

      ProgressStatusText.Caption:='������ : ��������';
      if not SendingMessage(currentOptions, reasonSMS, error) then begin
        Screen.Cursor:=crDefault;
        MessageBox(Handle,PChar(error),PChar('������ ��������'),MB_OK+MB_ICONERROR);
      end
      else begin
       Screen.Cursor:=crDefault;
       MessageBox(Handle,PChar('������ �������� �������� � �������'+#13#13+error),PChar('�����'),MB_OK+MB_ICONINFORMATION);
      end;
    end;
    options_Find:begin
      // ������� ����� � 8 �� +7
      SharedStatusSendingSMS[0]:='+7' + Copy(SharedStatusSendingSMS[0], 2, MaxInt);

      countSendindSms:=GetCountSmsSendingMessageInPhone(SharedStatusSendingSMS[0]);
      Screen.Cursor:=crDefault;

      case countSendindSms of
        0:begin  // ������ �� ���� �� ���������� ���������
          Screen.Cursor:=crDefault;
          MessageBox(Handle,PChar('�� ����� '+SharedStatusSendingSMS[0]+' ������� �� ������������ ���������'),PChar('����������'),MB_OK+MB_ICONINFORMATION);
          Exit;
        end;
        1:begin
          with FormStatusSendingSMS do begin
            FormStatusSendingSMS.SetSmsInfo(SharedStatusSendingSMS[0]);
            ShowModal;
          end;
        end;
        else begin // ���������� ���� ������ 2� ��������� �� ��� �����
          sendingSMS:=TAutoPodborSendingSms.Create(SharedStatusSendingSMS[0]);

            // ��������� ����� �������
          with FormPodbor do begin
           SetTypePodbor(eTypePodporSMS);
           SetListSendingSMS(sendingSMS);
           ShowModal;
          end;

          if not FormStatusSendingSMS.IsExistSmsInfo then begin
            MessageBox(Handle,PChar('�� ������� ����'),PChar('������'),MB_OK+MB_ICONERROR);
            Exit;
          end;

          with FormStatusSendingSMS do begin
            ShowModal;
          end;
        end;
      end;
    end;
   end;

   // ������� ������ �����
   ClearParamsForm(currentOptions);

   // ������� ������� ������� ���������� ���
   ShowCountTodaySmsSending;

   Screen.Cursor:=crDefault;
end;


procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
  if SharedCheckBox.Checked['ShowLog'] then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;


procedure TFormHome.chkbox_SaveGlobalTemplateClick(Sender: TObject);
begin
 SharedCheckBox.ChangeStatusCheckBox('SaveGlobalTemplate');
end;

procedure TFormHome.chkbox_SaveMyTemplateClick(Sender: TObject);
begin
 SharedCheckBox.ChangeStatusCheckBox('SaveMyTemplate');
end;

procedure TFormHome.chkbox_SignSMSClick(Sender: TObject);
begin
  SharedCheckBox.ChangeStatusCheckBox('SignSMS');
end;

procedure TFormHome.edtFindSMSChange(Sender: TObject);
begin
  if Length(edtFindSMS.Text) > 0 then lblManualPodborFindStatus.Visible:=False
  else lblManualPodborFindStatus.Visible:=True;
end;

procedure TFormHome.edtFindSMSClick(Sender: TObject);
begin
   if st_PhoneInfo2.Visible then st_PhoneInfo2.Visible:=False;
end;

procedure TFormHome.edtFindSMSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
  begin
    case Key of
       86: // Ctrl + V
        begin
          // ��������� ����� �� ������ ������
          edtFindSMS.Text := ParsePhoneNumber(Clipboard.AsText);
          Key := 0; // �������� ���������� ��������� �������
        end;
      88: // Ctrl + X
        begin
          // �������� ���������� ����� � ����� ������ � ������� ��� �� Edit
          Clipboard.AsText := edtFindSMS.Text; // ���� �����, ����� ����� ��� ����������
          edtFindSMS.ClearSelection; // ������� ���������
          Key := 0; // �������� ���������� ��������� �������
        end;
    end;
  end;
end;

procedure TFormHome.edtFindSMSKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnAction.Click;
  end;

  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // �������� ����, ���� ������ �� �������� ������
  end;
end;

procedure TFormHome.edtManualSMSChange(Sender: TObject);
begin
  if Length(edtManualSMS.Text) > 0 then lblManualPodbor.Visible:=False
  else lblManualPodbor.Visible:=True;

  lblManualSMS_List.Caption:='�������';
  SharedSendindPhoneManualSMS.Clear;
end;

procedure TFormHome.edtManualSMSClick(Sender: TObject);
begin
  if st_PhoneInfo.Visible then st_PhoneInfo.Visible:=False;
end;


procedure TFormHome.edtManualSMSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
  begin
    case Key of
       86: // Ctrl + V
        begin
          // ��������� ����� �� ������ ������
          edtManualSMS.Text := ParsePhoneNumber(Clipboard.AsText);
          Key := 0; // �������� ���������� ��������� �������
        end;
      88: // Ctrl + X
        begin
          // �������� ���������� ����� � ����� ������ � ������� ��� �� Edit
          Clipboard.AsText := edtManualSMS.Text; // ���� �����, ����� ����� ��� ����������
          edtManualSMS.ClearSelection; // ������� ���������
          Key := 0; // �������� ���������� ��������� �������
        end;
    end;
  end;

  // ���������, ���� �� ����� � ������ ������
//    if Clipboard.HasFormat(CF_TEXT) then
//    begin
//      ClipboardText := Clipboard.AsText;
//
//      // ��������� ������� ParsePhoneNumber � ������ �� ������
//      Edit1.Text := ParsePhoneNumber(ClipboardText);
//
//      // ������������� ������ � ����� ������
//      Edit1.SelStart := Length(Edit1.Text);
//
//      // �������� ����������� ��������� �������
//      Key := 0;
//    end;

end;

procedure TFormHome.edtManualSMSKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // �������� ����, ���� ������ �� �������� ������
  end;
end;

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_SMS_ID:=1;
   USER_ACCESS_SENDING_LIST:=True;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('SMS ���������� ����� ��������� ������ �� ��������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_SMS_ID:= StrToInt(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('������� ����� ����������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;

    if ParamStr(i) = '--ACCESS' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_ACCESS_SENDING_LIST:= StrToBoolean(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('������� ����� ����������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;


function GetWordStart(const Text: string; CursorPos: Integer): Integer;
var
 size_result:Integer;
begin

  size_result := CursorPos;
  while (size_result > 0) and (Text[size_result] <> ' ') do
    Dec(size_result);
  if (size_result < Length(Text)) and (Text[size_result] = ' ') then
    Inc(size_result); // ���������� �� ���� ������ ������, ����� �������� ������ �����

    Result:=size_result-1;
end;

function GetWordEnd(const Text: string; CursorPos: Integer): Integer;
begin
  Result := CursorPos;
  while (Result < Length(Text)) and (Text[Result + 1] <> ' ') do
    Inc(Result);
  if (Result > 1) and (Text[Result + 1] = ' ') then
    Dec(Result); // ���������� �� ���� ������ �����, ����� �������� ����� �����
end;



procedure TFormHome.re_ManualSMSMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ���������, ��� �� ���� ������ ������� ����
  if Button = mbRight then
  begin
    if IsExistSpellingColor(DM.maybeDictionary, re_ManualSMS) then begin
      DM.popmenu_AddSpellnig.Items[0].Enabled:=True;
    end
    else begin
     DM.popmenu_AddSpellnig.Items[0].Enabled:=False;
    end;
  end;
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    // ���������� ����������� ����
    popmenu_AddressClinic.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseLeave(Sender: TObject);
begin
  st_ShowInfoAddAddressClinic.Font.Style:=[];
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  st_ShowInfoAddAddressClinic.Font.Style:=[fsUnderline];
end;

procedure TFormHome.st_ShowNotSendingSMSClick(Sender: TObject);
begin
 FormNotSendingSMSError.ShowModal;
end;

procedure TFormHome.st_ShowNotSendingSMSMouseLeave(Sender: TObject);
begin
 st_ShowNotSendingSMS.Font.Style:=[];
end;

procedure TFormHome.st_ShowNotSendingSMSMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   st_ShowNotSendingSMS.Font.Style:=[fsUnderline];
end;

procedure TFormHome.st_ShowSendingSMSClick(Sender: TObject);
begin
  with FormSendingSMS do begin
   SetTodaySendingSms(False);
   Caption:='��������� �� �������� ('+IntToStr(SharedPacientsList.Count)+')';
   ShowModal;
  end;
end;

procedure TFormHome.st_ShowSendingSMSMouseLeave(Sender: TObject);
begin
   st_ShowSendingSMS.Font.Style:=[];
end;

procedure TFormHome.st_ShowSendingSMSMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 st_ShowSendingSMS.Font.Style:=[fsUnderline];
end;

procedure TFormHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  KillProcessNow;
end;

procedure TFormHome.FormCreate(Sender: TObject);
var
FolderDll:string;
begin
  // �������� �� ������� 2�� ����
  if GetCloneRun(Pchar(SMS_EXE)) then begin
    MessageBox(Handle,PChar('��������� ������ 2�� ����� sms ��������'+#13#13+
                            '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);

  // ����� ��� dll firebird
  begin
    FolderDll:= FOLDERPATH + 'dll';

    // �������� �� ������������� �����
    if DirectoryExists(FolderDll) then begin
      // ���� � ����� � DLL
      SetDllDirectory(PChar(FolderDll));
    end
    else begin
      MessageBox(Handle,PChar('�� ������� ����� � dll ������������'+#13#13+FolderDll),PChar('������'),MB_OK+MB_ICONERROR);
      KillProcessNow; // ��������� ���������� ���������, ����� �� ���������� ������
    end;
  end;

    // ������ ����
  FormHome.Width:=cWIDTH_HIDELOG;
end;

procedure TFormHome.FormShow(Sender: TObject);
var
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  // �������� ���������� �� excel
  if not isExistExcel(error) then begin
   Screen.Cursor:=crDefault;

   MessageBox(Handle,PChar('Excel �� ����������'+#13#13+error),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;


  // debug node
  if DEBUG then begin
    Caption:='    ===== DEBUG | (base:'+GetDefaultDataBase+') =====    '+Caption;
  end
  else begin
    // �� ���������� ������� ���
    page_TypesSMS.Pages[0].TabVisible:=True;
    page_TypesSMS.Pages[1].TabVisible:=True;
    page_TypesSMS.Pages[2].TabVisible:=True;

    // �������� �������� �������� ��� ������� ����������
    if not USER_ACCESS_SENDING_LIST then begin
       page_TypesSMS.Pages[1].TabVisible:=False;
       chkbox_SaveGlobalTemplate.Visible:=False;  // ��������� ��������� � ���������� �������
    end
    else begin
       chkbox_SaveGlobalTemplate.Visible:=True;  // ��������� ��������� � ���������� �������
    end;
  end;

  lblManualSMS_One.Font.Color:=clHighlight;
  lblManualSMS_List.Font.Color:=clHighlight;
  lblOpenGenerateMessage.Font.Color:=clHighlight;
  lblinfoEditMessage.Font.Color:=clHighlight;
  lblManualPodbor.Font.Color:=clHighlight;
  lblManualPodborFindStatus.Font.Color:=clHighlight;


   // �������� copyright
  CreateCopyright;

  // ������� ������� �� ������� ���������� ���
  ShowCountTodaySmsSending;

  // ����������� ������������� ��������� ������� � ��� ���������
  SignSMS;

  // ��� ��� ���������
  SetReasonSMSType(reason_Empty);

  // �������� ���� �������� ������� � ������� ������
  CreatePopMenuAddressClinic(popmenu_AddressClinic, re_ManualSMS);

  // ��������� �������
  page_TypesSMS.ActivePage:=sheet_ManualSMS;

  // ���������� ������������ ��������
  AddCustomCheckBoxUI;

  Screen.Cursor:=crDefault;
end;

procedure TFormHome.img_ShowLogClick(Sender: TObject);
begin
  SharedCheckBox.ChangeStatusCheckBox('ShowLog');

  if SharedCheckBox.Checked['ShowLog'] then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;

procedure TFormHome.img_SaveGlobalTemplateClick(Sender: TObject);
begin
 SharedCheckBox.ChangeStatusCheckBox('SaveGlobalTemplate');
end;

procedure TFormHome.img_SaveMyTemplateClick(Sender: TObject);
begin
 SharedCheckBox.ChangeStatusCheckBox('SaveMyTemplate');
end;

procedure TFormHome.img_SignSMSClick(Sender: TObject);
begin
  SharedCheckBox.ChangeStatusCheckBox('SignSMS');
end;

procedure TFormHome.chkbox_ShowLogClick(Sender: TObject);
begin
  SharedCheckBox.ChangeStatusCheckBox('ShowLog');

  if SharedCheckBox.Checked['ShowLog'] then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;

procedure TFormHome.lblinfoEditMessageClick(Sender: TObject);
begin
  EnableOrDisableEditMessage(paramStatus_ENABLED);
  re_ManualSMS.Clear;
end;

procedure TFormHome.lblinfoEditMessageMouseLeave(Sender: TObject);
begin
 lblinfoEditMessage.Font.Style:=[];
end;

procedure TFormHome.lblinfoEditMessageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblinfoEditMessage.Font.Style:=[fsUnderline];
end;

procedure TFormHome.lblManualPodborFindStatusClick(Sender: TObject);
begin
 FormManualPodborStatus.ShowModal;
end;

procedure TFormHome.lblManualPodborClick(Sender: TObject);
begin
 FormManualPodbor.ShowModal;
end;

procedure TFormHome.lblManualSMS_ListClick(Sender: TObject);
var
  MousePos: TPoint;
begin
  edtManualSMS.Text:='';

  GetCursorPos(MousePos);

  with FormListSendingSMS do begin
    m_left := MousePos.X;
    m_top := MousePos.Y;
    ShowModal;
  end;
end;

procedure TFormHome.lblManualSMS_OneClick(Sender: TObject);
begin
 ShowSendingManualPhone(sending_one);
end;

procedure TFormHome.lblOpenGenerateMessageClick(Sender: TObject);
begin
  // ����������
  AutoPodborGenerateSMS;

 FormGenerateSMS.ShowModal;
end;


procedure TFormHome.menu_CopyClick(Sender: TObject);
begin
 CopySelectedTextToClipboard;
end;


procedure TFormHome.page_TypesSMSChange(Sender: TObject);
begin
  case page_TypesSMS.ActivePage.PageIndex of
   0:begin                 // ������ ��������
    OptionsStyle(options_Manual);
   end;
   1:begin                  // ��������
    OptionsStyle(options_Sending);
   end;
   2:begin                 // ����� ������� ���������
    OptionsStyle(options_Find);
   end;
  end;
end;

end.
