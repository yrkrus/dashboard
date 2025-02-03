unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls;


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


// class TUser
  type
      TUser = class(TObject)
      private
      userName                                  : string;
      IP                                        : string;
      userPC                                    : string;

      constructor Create;                          overload;
      constructor Create(username,IP,PC:string);   overload;

      procedure setUserName(username:string);
      procedure setIP(IP:string);
      procedure setUserPC(namePC:string);

      public
      function getUserName                      : string;
      function getIP                            : string;
      function getUserPC                        : string;

      end;
 // class TUser END

type
  TFormHome = class(TForm)
    GroupBox1: TGroupBox;
    edtLogin: TEdit;
    lblLogin: TLabel;
    edtPwd: TEdit;
    lblPwd: TLabel;
    btnSendSMS: TButton;
    GroupBox2: TGroupBox;
    chkboxShowLog: TCheckBox;
    chkboxLog: TCheckBox;
    OpenDialog: TOpenDialog;
    ProgressBar: TGauge;
    lblProgressBar: TLabel;
    STViewPwd: TStaticText;
    PageType: TPageControl;
    TabPerenos: TTabSheet;
    TabRassilka: TTabSheet;
    GBView: TGroupBox;
    edtExcelSMS: TEdit;
    btnLoadFile: TButton;
    GroupBox3: TGroupBox;
    edtExcelSMS2: TEdit;
    btnLoadFile2: TButton;
    GroupBox4: TGroupBox;
    btnMsgPerenos: TButton;
    reNumberPhoneList: TRichEdit;
    Button1: TButton;
    STEnterSend: TStaticText;
    chkEnter: TCheckBox;
    TabStatus: TTabSheet;
    edtNumbeFromStatus: TEdit;
    Label3: TLabel;
    lblMsgStatusInfo: TLabel;
    RELog: TRichEdit;
    PanelAuthEdit: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSendSMSClick(Sender: TObject);
    procedure STViewPwdClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure PageTypeChange(Sender: TObject);
    procedure btnMsgPerenosClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chkEnterClick(Sender: TObject);
    procedure STEnterSendClick(Sender: TObject);
    procedure reNumberPhoneListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNumbeFromStatusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PanelAuthEditClick(Sender: TObject);
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
  ParsingDirectory:string;
  FileExcelSMS:string;

  SLSMS:TStringList; // ���� � ��������� �� exel

  currentUser:TUser;

  type   // ��� ������
   TSmsStyle = (ManualSend,
                Rassilka,
                MsgStatus);


const
// TRUE - ���. | ��� ������ ������ ������� ������ ������ �� ����������!! ������ �� ������ �.�. �� ������ ����!!
/////////////////////////////////
global_DEBUG:Boolean = True;  //
/////////////////////////////////

VERSION:string='v 2.4 build.20240603';
cWIDTHSHow:Integer=877;
cWIDTHStart:Integer=333;
cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';

cAUTHconf:string='auth.conf';

cAGELIMIT18:Integer=86400*365*18; // ������� ����� 18 ��� (� �����)

CustomHeaders0='Connection:Keep-alive';
CustomUserAgent='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
CustomHeaders2='Content-Type:application/x-www-form-urlencoded';
CustomHeaders3='Accept-Charset:utf-8';
CustomHeaders4='Accept:application/json, text/javascript, */*; q=0.01';
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
  FunctionUnit, FormMsgPerenosUnit;

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

 // class TUser START
 constructor TUser.Create;
 begin
   inherited;

   // ������� ��������
   begin
     Self.IP:=GetLocalIP;
     Self.userPC:=GetComputerNetName;
     Self.userName:=GetCurrentUserName;
   end;
 end;

 constructor TUser.Create(username,IP,PC:string);
 begin
   Self.userName:=userName;
   Self.IP:=IP;
   Self.userPC:=PC;
 end;

 function TUser.getUserName:string;
 begin
    Result:=userName;
 end;

 function TUser.getIP:string;
 begin
    Result:=IP;
 end;

 function TUser.getUserPC:string;
 begin
    Result:=userPC;
 end;

 procedure TUser.setUserName(username: string);
 begin
   Self.userName:=username;
 end;

 procedure TUser.setIP(IP:string);
 begin
  Self.IP:=IP;
 end;

 procedure TUser.setUserPC(namePC: string);
 begin
  Self.userPC:=namePC;
 end;

 // class TUser END


procedure TFormHome.btnLoadFile2Click(Sender: TObject);
var
  TypeReport:Word;
begin
  if edtExcelSMS.Text<>'' then begin
   MessageBox(Handle,PChar('�� ������ ������ �������� ���� � ��������� (���)'+#13#13+
                           '�������� ���� "���" ���� ���������� ��������� ���� � ��������� (���������) '),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

   with OpenDialog do begin
     Title:='�������� �����';
     DefaultExt:='';
     Filter:='OpenOffice | *.ods';
     FilterIndex:=1;
     InitialDir:=ParsingDirectory;

      if Execute then
      begin
         FileExcelSMS:=FileName;
         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
         edtExcelSMS2.Text:=FileExcelSMS;

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

procedure TFormHome.btnLoadFileClick(Sender: TObject);
var
 TypeReport:Word;
begin
  if edtExcelSMS2.Text<>'' then begin
   MessageBox(Handle,PChar('�� ������ ������ �������� ���� � ��������� (���������)'+#13#13+
                           '�������� ���� "���������" ���� ���������� ��������� ���� � ��������� (���) '),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;


  with OpenDialog do begin
     Title:='�������� �����';
     DefaultExt:='xlsx';
     Filter:='Excel 2003 � ������ | *.xls|Excel 2007 � �����| *.xlsx';
     FilterIndex:=2;
     InitialDir:=ParsingDirectory;

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

procedure TFormHome.btnMsgPerenosClick(Sender: TObject);
begin
   FormMsgPerenos.ShowModal;
end;

procedure TFormHome.btnSendSMSClick(Sender: TObject);
var
 TypeReport:Word;
 resultat:Word;
 sresult:string;
 SMSResult:string;
 i:Integer;
 MessageSMS:string;
begin

  case PageType.ActivePage.PageIndex of
   0:begin                              // �������� ������� ���������
     sresult:=GetCheckAuth(MsgStatus);
   end;
   1:begin                              // ������ ��������
     sresult:=GetCheckAuth(ManualSend);
   end;
   2:begin                              // ��������
    sresult:=GetCheckAuth(Rassilka)
   end;
  end;

   if AnsiPos('������',sresult) <> 0 then begin
     MessageBox(Handle,PChar(sresult),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;


  case PageType.ActivePage.PageIndex of
   0:begin                 // �������� ������� ���������
      try
        SMSResult:=GetSMSStatusID(edtNumbeFromStatus.Text);

        if AnsiPos('������',SMSResult) <> 0 then begin
          MessageBox(Handle,PChar(sresult),PChar('������'),MB_OK+MB_ICONERROR);
          Exit;
        end;
      except on E:Exception do
          begin
            CurrentPostAddColoredLine('������! �� ������� ��������� ������ ��� �� ����� "'+reNumberPhoneList.Lines[i]+'" , '+e.ClassName+': '+e.Message,clRed);
            Exit;
          end;
      end;

    edtNumbeFromStatus.Text:='';
   end;
   1:begin                 // ������ ��������

      // ������ ���������
      MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');

      if Length(MessageSMS) <= cMINIMALMESSAGESIZE then begin

        resultat:=MessageBox(FormHome.Handle,PChar('������ ������������� ��������� ������ ��������������� ����������� ����� ('+IntToStr(cMINIMALMESSAGESIZE)+' ��������)'+#13#13+
                                                   '�������� ��� ������, ����� ��������� ���������?'+#13#13#13+
                                                   '����� ���������� ��������� ���������:'+#13+
                                                    MessageSMS),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
        if resultat=mrNo then begin
           Exit;
        end;
      end;


      for i:=0 to reNumberPhoneList.Lines.Count-1 do begin

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
      end;

     // ������� ������
     reNumberPhoneList.Lines.Clear;
     ProgressBar.Progress:=0;
     lblProgressBar.Caption:='������ ��������';
   end;
   2:begin                            // ��������
    if edtExcelSMS.Text<>'' then TypeReport:=1  { ���� � ��������� (���) }
    else TypeReport:=2;                         { ���� � ��������� (���������) }

       //���������� ���
       if SLSMS.Count<>0 then ParsingSMSandSend(SLSMS,TypeReport)
       else begin
        CurrentPostAddColoredLine('������ ��������! � ������ ��� ������ ��� ��������',clRed);

        MessageBox(Handle,PChar('� ������ ��� ������ ��� ��������'+#13+
                                '����������� ����� ��� ��� '),PChar('������'),MB_OK+MB_ICONERROR);
        Exit;
       end;

      // ������� ������
      ProgressBar.Progress:=0;
      lblProgressBar.Caption:='������ ��������';

      // ���� ������
      if ParsingError then begin
        SLParsingError.SaveToFile(ParsingDirectory+'ErrorSend.log');

        resultat:=MessageBox(FormHome.Handle,PChar('� �������� �������� ��������, �������� ������ ('+inttostr(SLParsingError.Count)+')'+#13+
                                                   '����������� ����� ErrorSend.log'+#13#13+
                                                   '������� �����?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
        SLParsingError.Clear;
        if resultat=mrYes then begin
           ShellExecute(Handle, 'Open', PChar(ParsingDirectory+'ErrorSend.log'),nil,nil,SW_SHOWNORMAL);
        end;
      end;
   end;
  end;

end;

procedure TFormHome.Button1Click(Sender: TObject);
var
 test:TStringList;
begin

 // test:=TStringList.Create;
//  test.LoadFromFile('1.log');

 // ParsingResultStatusSMS(test.Text,'89093858545');
end;

procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
 if chkboxShowLog.Checked then FormHome.Width:=cWIDTHSHow
 else FormHome.Width:=cWIDTHStart;
end;

procedure TFormHome.chkEnterClick(Sender: TObject);
begin
  if chkEnter.Checked then SaveSettingEnterSend(True)
  else SaveSettingEnterSend(False);
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

procedure TFormHome.FormCreate(Sender: TObject);
begin
  // ������� �������� �������
  currentUser:=TUser.Create();

  with FormHome do begin
  Caption:=Caption+' '+VERSION+' | '+currentUser.getUserName+' ('+currentUser.getUserPC+' - '+currentUser.getIP+')';

  if global_DEBUG then Caption:='     ### DEBUG ###      '+Caption;

  Width:=cWIDTHStart;
 end;

  ParsingDirectory:=ExtractFilePath(ParamStr(0));
  ProgressBar.Progress:=0;

  SLSMS:=TStringList.Create;
  SLParsingError:=TStringList.Create;

  // �������� ���������� �����������
  LoadAuthotization;

  // ������� �������� (�� ���������)
  PageType.ActivePageIndex:=2;

  // ���������� ��� (�� ���������)
  chkboxShowLog.Checked:=True;


  // ���������� enterom
  LoadSettingEnterSend;
end;




procedure TFormHome.PageTypeChange(Sender: TObject);
begin

  case PageType.ActivePage.PageIndex of
   0:begin                 // �������� ������� ���������
    ClearTabs(ManualSend);
    ClearTabs(Rassilka);

    SmsTypeStyle(MsgStatus);
   end;
   1:begin                 // ������ ��������
    ClearTabs(MsgStatus);
    ClearTabs(Rassilka);

    SmsTypeStyle(ManualSend);
   end;
   2:begin                  // ��������
    ClearTabs(MsgStatus);
    ClearTabs(ManualSend);

    SmsTypeStyle(Rassilka);
   end;
  end;

end;

procedure TFormHome.PanelAuthEditClick(Sender: TObject);
begin
 PanelAuthEdit.Visible:=False;
 lblLogin.Visible:=True;
 lblPwd.Visible:=True;
end;

procedure TFormHome.reNumberPhoneListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if SettingsLoadString(cAUTHconf,'core','send_enter','true')='true' then begin
    if (Key=VK_RETURN) then begin
        btnSendSMS.Click;
    end;
  end;
end;

procedure TFormHome.STEnterSendClick(Sender: TObject);
begin
  if chkEnter.Checked then chkEnter.Checked:=False
  else chkEnter.Checked:=True;
end;

procedure TFormHome.STViewPwdClick(Sender: TObject);
begin
  if edtPwd.PasswordChar=#42 then begin
   edtPwd.PasswordChar:=#0;
   STViewPwd.Caption:='������';
  end
  else begin
   edtPwd.PasswordChar:=#42;
   STViewPwd.Caption:='��������';
  end;
end;

end.
