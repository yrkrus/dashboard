unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Buttons;


 // class TSMSMessage
type
    TSMSMessage = class(TObject)

    public
    SMS_ID                                      : string;     // ID sms
    CreatDate                                   : TDate;       // ���� ����� ���� ������� ���������
    CreatTime                                   : TTime;       // ����� ����� ���� ������� ���������
    MsgText                                     : string;      // ����� ���������
    Code                                        : string;      // ��� ���
    Status                                      : string;      // ������ ���
    Phone                                       : string;      // ����� ��������

    constructor Create;                          overload;

    function getID                              : string;
    function getDate                            : TDate;
    function getTime                            : TTime;
    function getMsg                             : string;
    function getCode                            : string;
    function getStatus                          : string;
    function getPhone                           : string;
  end;

  //class TSMSMessage END


type
  TFormHome = class(TForm)
    GroupBox2: TGroupBox;
    chkboxLog: TCheckBox;
    OpenDialog: TOpenDialog;
    page_TypesSMS: TPageControl;
    sheet_ManualSMS: TTabSheet;
    sheet_SendingSMS: TTabSheet;
    Button1: TButton;
    StatusBar: TStatusBar;
    btnSendSMS: TBitBtn;
    group_ManualSMS: TGroupBox;
    Label1: TLabel;
    edtManualSMS: TEdit;
    btnSaveFirebirdSettings: TBitBtn;
    panel_ManualSMS: TPanel;
    re_ManualSMS: TRichEdit;
    ST_StatusPanel: TStaticText;
    CheckBox1: TCheckBox;
    group_SendingSMS: TGroupBox;
    Label2: TLabel;
    edtExcelSMS: TEdit;
    btnLoadFile: TBitBtn;
    lblProgressBar: TLabel;
    ProgressBar: TGauge;
    chkboxShowLog: TCheckBox;
    GroupBox1: TGroupBox;
    RELog: TRichEdit;
    STDEBUG: TStaticText;
    lblCountSendingSMS: TLabel;
    Label3: TLabel;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSendSMSClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtNumbeFromStatusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
      procedure Button2Click(Sender: TObject);
    procedure page_TypesSMSChange(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  ParsingError:Boolean; // ��� ������� ����� ���������� ������ ��� ������� �� ���� ���������� ��� ����������
  SLParsingError:TStringList; // ������ � ��������

  //SLPArsingErorr:array of TErrorFileList;

  end;


var
  FormHome: TFormHome;
  FileExcelSMS:string;

  SLSMS:TStringList; // ���� � ��������� �� exel

  //currentUser:TUser;


const
cWIDTH_SHOWLOG:Integer=1128;
cWIDTH_HIDELOG:Integer=440;

cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';

cAUTHconf:string='auth.conf';

//CustomHeaders0='Connection:Keep-alive';
//CustomUserAgent='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
//CustomHeaders2='Content-Type:application/x-www-form-urlencoded';
//CustomHeaders3='Accept-Charset:utf-8';
//CustomHeaders4='Accept:application/json, text/javascript, */*; q=0.01';
//CustomHeaders4='Content-Encoding: gzip';


cSLEEPNEXTSMS:Integer=150; // ����� �������� ����� ��������� ��������� ���

cMINIMALMESSAGESIZE:Word = 70; // ����������� ���-�� �������� � ������������ ���������

//cMESSAGEBefor18:string='%FIO_Pacienta �� �������� � ������� %FIO_Doctora (%Napravlenie) �� %Data � %Time, %Address. ��� ���� ���������� ����� ������� � �����';
//cMESSAGEAfter18:string='%FIO_Pacienta %�������(�) � ������� %FIO_Doctora (%Napravlenie) �� %Data � %Time, %Address. ����� �������� � ����������� ��������� ������������� �������';

//cMESSAGEBefor18:string='%FIO_Pacienta �� �������� � ������� %FIO_Doctora �� %Data � %Time, %Address. ��� ���� ���������� ����� ������� � �����';
//cMESSAGEAfter18:string='%FIO_Pacienta %�������(�) � ������� %FIO_Doctora �� %Data � %Time, %Address. ����� �������� � ����������� ��������� ������������� �������';

cMESSAGE:string='%FIO_Pacienta %�������(�) � ������� %FIO_Doctora � %Time %Data � ������� �� ������ %Address. ���� � ��� ���� �������, ������ �� ��� ��������, ����� ���. ��� ����� (8442)220-220 ��� (8443)450-450';

cTempAddrClinika:string='��. 40 ��� �����, 55�';

cMAXCOUNTMESSAGEOLD:Word = 50; //���-�� ��������� ������� ���������� � ������� � ������ ��� �������� ���������

implementation

uses
  FunctionUnit, GlobalVariables, TSendSMSUint, FormMyTemplateUnit;

 {$R *.dfm}


// class TSMSMessage START
 constructor TSMSMessage.Create;
 begin
   inherited;
 end;

 function TSMSMessage.getID:string;
 begin
    Result:=SMS_ID;
 end;

 function TSMSMessage.getDate:TDate;
 begin
    Result:=CreatDate;
 end;

 function TSMSMessage.getTime:TTime;
 begin
    Result:=CreatTime;
 end;

 function TSMSMessage.getMsg:string;
 begin
    Result:=MsgText;
 end;

 function TSMSMessage.getCode:string;
 begin
    Result:=Code;
 end;

 function TSMSMessage.getStatus:string;
 begin
    Result:=Status;
 end;

  function TSMSMessage.getPhone:string;
 begin
    Result:=Phone;
 end;

 // class TSMSMessage END


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
begin

  with OpenDialog do begin
     Title:='�������� �����';
     DefaultExt:='xls';
     Filter:='Excel 2003 � ������ | *.xls|Excel 2007 � �����| *.xlsx';
     FilterIndex:=1;
     InitialDir:=FOLDERPATH;

      if Execute then
      begin
         FileExcelSMS:=FileName;
         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
         edtExcelSMS.Text:=FileExcelSMS;

         FileExcelSMS:=FileName;
      end;
  end;

   // ���������� � ������
   if FileExcelSMS<>'' then
   begin
     if edtExcelSMS.Text<>'' then TypeReport:=1  { ���� � ��������� (���) }
     else TypeReport:=2;                         { ���� � ��������� (���������) }

     // ��������� ������
     PreLoadData(TypeReport);
   end;

end;

procedure TFormHome.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
  FormMyTemplate.ShowModal;
end;

procedure TFormHome.btnSendSMSClick(Sender: TObject);
var
// TypeReport:Word;
// resultat:Word;
// sresult:string;
// SMSResult:string;
// i:Integer;
// MessageSMS:string;
 currentOptions:enumSendingOptions;
 error:string;
 SendindMessage:string;
begin
  // ��������
  begin
    case page_TypesSMS.ActivePage.PageIndex of
     0:begin                 // ������ ��������
      currentOptions:=options_Manual;
     end;
     1:begin                  // ��������
      currentOptions:=options_Sending;
     end;
    end;

    if not CheckParamsBeforeSending(currentOptions,error) then begin
     MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
    end;
  end;


   // ���������� ���������
   case currentOptions of
    options_Manual: begin
      if not SendingMessage(currentOptions, error) then  MessageBox(Handle,PChar(error),PChar('������ ��������'),MB_OK+MB_ICONERROR)
      else MessageBox(Handle,PChar('��������� ����������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
    end;
    options_Sending:begin

    end;
   end;

   // ������� ������ �����
   ClearParamsForm(currentOptions);


//  case PageType.ActivePage.PageIndex of
//   0:begin                 // �������� ������� ���������
//      try
//       // SMSResult:=GetSMSStatusID(edtNumbeFromStatus.Text);
//
//        if AnsiPos('������',SMSResult) <> 0 then begin
//          MessageBox(Handle,PChar(sresult),PChar('������'),MB_OK+MB_ICONERROR);
//          Exit;
//        end;
//      except on E:Exception do
//          begin
//           // CurrentPostAddColoredLine('������! �� ������� ��������� ������ ��� �� ����� "'+reNumberPhoneList.Lines[i]+'" , '+e.ClassName+': '+e.Message,clRed);
//            Exit;
//          end;
//      end;
//
//   end;
//   1:begin                 // ������ ��������
//
//      // ������ ���������
//      MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');
//
//      if Length(MessageSMS) <= cMINIMALMESSAGESIZE then begin
//
//        resultat:=MessageBox(FormHome.Handle,PChar('������ ������������� ��������� ������ ��������������� ����������� ����� ('+IntToStr(cMINIMALMESSAGESIZE)+' ��������)'+#13#13+
//                                                   '�������� ��� ������, ����� ��������� ���������?'+#13#13#13+
//                                                   '����� ���������� ��������� ���������:'+#13+
//                                                    MessageSMS),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
//        if resultat=mrNo then begin
//           Exit;
//        end;
//      end;


      {for i:=0 to reNumberPhoneList.Lines.Count-1 do begin

        begin
         ProgressBar.Progress:=Round(100*i/reNumberPhoneList.Lines.Count-1);
         lblProgressBar.Caption:=IntToStr(i+1)+' �� '+IntToStr(reNumberPhoneList.Lines.Count);
         Application.ProcessMessages;
        end;

         try
          SMSResult:=GetSMS(reNumberPhoneList.Lines[i]);

         except on E:Exception do
          begin
            CurrentPostAddColoredLine('������! �� ������� ��������� ��� �� ����� "'+reNumberPhoneList.Lines[i]+'" , '+e.ClassName+': '+e.Message,clRed);
            Exit;
          end;
         end;

         if SMSResult='OK' then begin
           CurrentPostAddColoredLine('���������� ��� �� ����� "'+reNumberPhoneList.Lines[i]+'"',clGreen);
         end
         else begin
           CurrentPostAddColoredLine(SMSResult+'. ����� �������� �� ������� �� ������� ��������� ��� "'+reNumberPhoneList.Lines[i]+'"',clRed);
         end;
      end; }

//     // ������� ������
//     reNumberPhoneList.Lines.Clear;
//     ProgressBar.Progress:=0;
//     lblProgressBar.Caption:='������ ��������';
//   end;
//   2:begin                            // ��������
//    if edtExcelSMS.Text<>'' then TypeReport:=1  { ���� � ��������� (���) }
//    else TypeReport:=2;                         { ���� � ��������� (���������) }
//
//       //���������� ���
//       if SLSMS.Count<>0 then ParsingSMSandSend(SLSMS,TypeReport)
//       else begin
//        CurrentPostAddColoredLine('������ ��������! � ������ ��� ������ ��� ��������',clRed);
//
//        MessageBox(Handle,PChar('� ������ ��� ������ ��� ��������'+#13+
//                                '����������� ����� ��� ��� '),PChar('������'),MB_OK+MB_ICONERROR);
//        Exit;
//       end;
//
//      // ������� ������
//      ProgressBar.Progress:=0;
//      lblProgressBar.Caption:='������ ��������';
//
//      // ���� ������
//      if ParsingError then begin
//        SLParsingError.SaveToFile(ParsingDirectory+'ErrorSend.log');
//
//        resultat:=MessageBox(FormHome.Handle,PChar('� �������� �������� ��������, �������� ������ ('+inttostr(SLParsingError.Count)+')'+#13+
//                                                   '����������� ����� ErrorSend.log'+#13#13+
//                                                   '������� �����?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
//        SLParsingError.Clear;
//        if resultat=mrYes then begin
//           ShellExecute(Handle, 'Open', PChar(ParsingDirectory+'ErrorSend.log'),nil,nil,SW_SHOWNORMAL);
//        end;
//      end;
//   end;
//  end;

end;

procedure TFormHome.Button1Click(Sender: TObject);
var
 test:TStringList;
begin

 // test:=TStringList.Create;
//  test.LoadFromFile('1.log');

 // ParsingResultStatusSMS(test.Text,'89093858545');
end;

procedure TFormHome.Button2Click(Sender: TObject);
var
 SMS:TSendSMS;
 error:string;

begin
  SMS:=TSendSMS.Create;

  if not SMS.SendSMS('����� ����� �� ���������� '+DateTimeToStr(now),'89093858545',error) then begin
    ShowMessage(error);
    Exit;
  end;

  ShowMessage('��������� ����������');

end;



procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
  if chkboxShowLog.Checked then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;

procedure TFormHome.edtNumbeFromStatusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if SettingsLoadString(cAUTHconf,'core','send_enter','true')='true' then begin
    if (Key=VK_RETURN) then begin
        btnSendSMS.Click;
    end;
 end;
end;


procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_SMS_ID:=1;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('SMS �������� ����� ��������� ������ �� ��������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
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
  end;
end;


procedure TFormHome.FormCreate(Sender: TObject);
begin

  // �������� �� ������� 2�� ����
  if GetCloneRun(Pchar(SMS_EXE)) then begin
    MessageBox(Handle,PChar('��������� ������ 2�� ����� sms ��������'+#13#13+
                            '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);

  // debug node
  if DEBUG then STDEBUG.Visible:=True;


  // ������ ����
  FormHome.Width:=cWIDTH_HIDELOG;



  // ������� �������� �������
 {

  with FormHome do begin

  if global_DEBUG then Caption:='     ### DEBUG ###      '+Caption;

  Width:=cWIDTHStart;
 end;

  ParsingDirectory:=ExtractFilePath(ParamStr(0));
  ProgressBar.Progress:=0;

  SLSMS:=TStringList.Create;
  SLParsingError:=TStringList.Create;


  // ������� �������� (�� ���������)
  PageType.ActivePageIndex:=2;

  // ���������� ��� (�� ���������)
  chkboxShowLog.Checked:=True; }


end;




procedure TFormHome.page_TypesSMSChange(Sender: TObject);
begin
  case page_TypesSMS.ActivePage.PageIndex of

   0:begin                 // ������ ��������
    //ClearTabs(MsgStatus);
   // ClearTabs(Rassilka);

    OptionsStyle(options_Manual);
   end;
   1:begin                  // ��������
   // ClearTabs(MsgStatus);
   // ClearTabs(ManualSend);

    OptionsStyle(options_Sending);
   end;
  end;
end;

end.
