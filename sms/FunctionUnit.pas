unit FunctionUnit;

interface

uses
FormHomeUnit,
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
  IdSSL,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,System.IniFiles,
  Winapi.WinSock,  Vcl.ComCtrls, GlobalVariables;


procedure LoadData(InTypeReport:Word);                                                        // �������� excel
procedure Log(InText:string;InError:Boolean);                                                 // ������ � ���
procedure CurrentPostAddColoredLine(AText:string;AColor: TColor);
procedure ParsingSMSandSend(InSMSList:TStringList;InTypeReport:Word);                         // ������ � �������� ���   { InTypeReport=1 - ����� ��� | InTypeReport=2 - ����� ��������  }
function GetSMS(inPacientPhone:string):string; overload;                                      // �������� ��� v2
function GetSMS(inPacientPhone,inPacientIO,inPacientBirthday,
                inPacientPol,inDataPriema,inTimePriema,inFIOVracha,
                inNapravlenie,inAddress:string):string; overload;                             // �������� ���
function SettingsLoadString(INFILE,INSection,INValue,INValueDefault:string):string;           // �������� ����������
procedure SettingsSaveString(INFILE,INSection,INValue,INValueDefault:string);                 // ���������� ����������
procedure ErrorParsingLog(InPhoneNumber,InTypeParsing,InFullStackSMSParsing:string);          // ����������� ������ � ����
procedure PreLoadData(inTypeReport:Word);                                                     // ���� �������� ������ �� ��������
function GetTimeDiff(InCurrentSec:Integer):string;                                            // ����� ������������ ���������� �������
function GetSMSStatusID(inPacientPhone:string):string;                                        // �������� ��� �������
procedure LoadMsgMessageOld(InMaxCount:Integer);                                              // ��������� ��������� �������� ���������
function GetExistSaveMessage(InMEssage:string):Boolean;                                       // �������� ���� �� ��� ����� ����������� ���������
procedure AddSaveMessageOld(InMessage:string);                                                // ���������� ���������

procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);                         // ������� � �������� ����� ���� ������� ���������
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;                             // ���-�� ��� ������� ���� ����������
procedure ShowInfoMessage(arrMsg: array of TSMSMessage; arrCount:Integer);                    // ����������� ���� �� ��������


// �����������
procedure OptionsStyle(InOptionsType:enumSendingOptions);                                     // ����� ���� ������������� ���
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;      // �������� ������������ ������ �������� ��� �����
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean; // �������� ������ ����� ���������
function CreateSMSMessage(var InMessage:TRichEdit):string;                                            // ������ ��������� ����� ��� ���� � 1 ������
function SendingMessage(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean; // �������� ���������
procedure ClearParamsForm(InOptionsType:enumSendingOptions);                                     // ������� ����� �����
procedure ShowOrHideLog(InOptions:enumFormShowingLog); // ����������� ��� �������� ���



implementation

uses
  FormMyTemplateUnit, TSendSMSUint;




// �������� ������������ ������ �������� ��� �����
function isCorrectNumberPhone(InNumberPhone:string; var _errorDescription:string):Boolean;
var
 telefon:string;
begin
  Result:=False;
  _errorDEscription:='';

  telefon:=InNumberPhone;

   if telefon='' then begin
    _errorDescription:='������ ����� ��������';
    Exit;
   end;

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

   Result:=True;
end;

// �������� ������ ����� ���������
function CheckParamsBeforeSending(InOptionsType:enumSendingOptions; var _errorDescription:string):Boolean;
var
 t:Integer;
begin
  Result:=False;
  _errorDescription:='';

  // ��� ������ ���������
   with FormHome do begin
      case InOptionsType of
        options_Manual:begin  // ������ ��������

         // �������
         if not isCorrectNumberPhone(edtManualSMS.Text,_errorDescription) then begin
            Exit;
         end;

         // ���������
         if Length(re_ManualSMS.Text)=0 then begin
           _errorDescription:='������ ���������';
           Exit;
         end;

        end;
        options_Sending:begin // ��������
           // TODO �������
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
begin
  Result:=False;
  _errorDescription:='';

  case InOptionsType of
    options_Manual:begin  // ������ ��������
      SMS:=TSendSMS.Create;
      if not SMS.isExistAuth then begin
        _errorDescription:='����������� ��������������� ������ ��� �������� SMS';
        Exit;
      end;

      // ��������� ��������� ����� ��� ���� � ���� �������
      SMSMessage:=CreateSMSMessage(FormHome.re_ManualSMS);

      // �������
      phone:=FormHome.edtManualSMS.Text;

      if not SMS.SendSMS(SMSMessage,phone,_errorDescription) then begin
       Exit;
      end;

    end;
    options_Sending:begin  // ��������
        // TODO �������
    end;
  end;

  Result:=True;
end;

 // ������� ����� �����
procedure ClearParamsForm(InOptionsType:enumSendingOptions);
begin
  with FormHome do begin
   case InOptionsType of
      options_Manual:begin  // ������ ��������
         edtManualSMS.Text:='';
         re_ManualSMS.Clear;
      end;
      options_Sending:begin // ��������
            // TODO �������
      end;
    end;
  end;
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


// ���� �������� ������ �� ��������
procedure PreLoadData(inTypeReport:Word);
var
 FormPleaseWait:TForm;
 lblPlease:TLabel;
begin

    // ������������ �����
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='�������� ������';
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

   with FormHome do begin
       SLSMS.Clear;
       // ��������� ���� � ���������
       LoadData(inTypeReport);
   end;

    FormPleaseWait.Free;
end;

// ����� ���� ������������� ���
procedure OptionsStyle(InOptionsType:enumSendingOptions);
begin
  with FormHome do begin
   case InOptionsType of
      options_Manual: begin
       btnSendSMS.Caption:=' &��������� SMS';
      end;
      options_Sending: begin
       btnSendSMS.Caption:=' &��������� SMS ��������';
      end;
   end;
  end;
end;


// ���������� ����������
procedure SettingsSaveString(INFILE,INSection,INValue,INValueDefault:string);
var
SettingsConf:TIniFile;
begin
 try
   SettingsConf:=TIniFile.Create(FOLDERPATH+'/'+INFILE);
   SettingsConf.WriteString(INSection,INValue,INValueDefault);
 finally
   if SettingsConf<>nil then FreeAndNil(SettingsConf);
 end;

end;

// �������� ����������
function SettingsLoadString(INFILE,INSection,INValue,INValueDefault:string):string;
var
  SettingsConf: TIniFile;
begin
   SettingsConf:=TIniFile.Create(FOLDERPATH+'/'+INFILE);
    with SettingsConf do begin
       Result:=ReadString(INSection,INValue,INValueDefault);
       Free;
    end;
end;


procedure CurrentPostAddColoredLine(AText:string;AColor: TColor);
 var
 Error:Boolean;
begin
  with FormHome.RELog do
  begin
    SelStart:= Length(Text);
    SelAttributes.Color:=AColor;
    SelAttributes.Size:=10;
    SelAttributes.Name:='Times New Roman';
    Lines.Add(DateTimeToStr(Now)+' '+AText);
    Perform(EM_LINESCROLL,0,Lines.Count-1);
    SetFocus;
  end;


  // ���� ��� ��� ������
  if AColor=clRed then Log(AText,True)
  else Log(AText,False);
end;

  // �������� �����
procedure LoadData(InTypeReport:Word);  { InTypeReport=1 - ����� ��� | InTypeReport=2 - ����� ��������  }
var
 WorkSheet,Excel:OLEVariant;
 Rows, Cols, i:integer;
 FData: OLEVariant;


 stopRows:string;

 RowsAdd:Boolean; // ���������� ������

 PacientPhone,PacientIO,PacientBirthday,PacientPol,DataPriema,TimePriema,
 FIOVracha,Napravlenie,Address:string;

 tmpOstatok:string;

begin
    CurrentPostAddColoredLine('�������� ������',clBlack);

    RowsAdd:=False;

    Excel:=CreateOleObject('Excel.Application');
    Excel.displayAlerts:=False;
    Excel.workbooks.add;

      //��������� �����
    Excel.Workbooks.Open(FileExcelSMS);
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
              MessageBox(FormHome.Handle,PChar('������! �� ������� ��������� ���� � ������'+#13#13+
                                               e.ClassName+': '+e.Message),PChar('������'),MB_OK+MB_ICONERROR);

              Excel.quit;
              Exit;
            end;
    end;


   with FormHome do begin
      // �������� ����� �� ������

     case InTypeReport of
      1:begin
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
        then RowsAdd:=True
        else RowsAdd:=False;


        if RowsAdd=False then begin
           Excel.quit;

           CurrentPostAddColoredLine('������ ��������! ������������ ������ ������',clRed);

           Application.ProcessMessages;

           MessageBox(Handle,PChar('������������ ������ ������'+#13#13+
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
                                   '12.F_SHORTADDR'),PChar('������'),MB_OK+MB_ICONERROR);
           // ������� ������ � �������
          FileExcelSMS:='';
          edtExcelSMS.Text:='';

          SLSMS.Clear;
          Exit;
        end;
      end;
      2:begin
        if (FData[1,1]='PCODE')         and
           (FData[1,2]='PHONE1')        and
           (FData[1,3]='PHONE2')        and
           (FData[1,4]='PHONE3')        and
           (FData[1,5]='LASTNAME')      and
           (FData[1,6]='IO')            and
           (FData[1,7]='BDATE')         and
           (FData[1,8]='POL')           and
           (FData[1,9]='WORKDATE')      and
           (FData[1,10]='TIMES')        and
           (FData[1,11]='DNAME')        and
           (FData[1,12]='DEPNAME')      and
           (FData[1,13]='F_FILID')      and
           (FData[1,14]='F_SHORTADDR')  and
           (FData[1,15]='DOPINFO')      and
           (FData[1,16]='PHONE')
        then RowsAdd:=True
        else RowsAdd:=False;


        if RowsAdd=False then begin
           Excel.quit;

           CurrentPostAddColoredLine('������ ��������! ������������ ������ ������',clRed);

           Application.ProcessMessages;

           MessageBox(Handle,PChar('������������ ������ ������'+#13#13+
                                   '������ ������ �������� ��������� �������:'+#13+
                                   '1. PCODE'+#13+
                                   '2. PHONE1'+#13+
                                   '3. PHONE2'+#13+
                                   '4. PHONE3'+#13+
                                   '5. LASTNAME'+#13+
                                   '6. IO'+#13+
                                   '7. POL'+#13+
                                   '8. TIMES'+#13+
                                   '9. WORKDATE'+#13+
                                   '10.TIMES'+#13+
                                   '11.DNAME'+#13+
                                   '12.DEPNAME'+#13+
                                   '13.F_FILID'+#13+
                                   '14.F_SHORTADDR'+#13+
                                   '15.DOPINFO'+#13+
                                   '16.PHONE'),PChar('������'),MB_OK+MB_ICONERROR);
           // ������� ������ � �������
          FileExcelSMS:='';
          edtExcelSMS.Text:='';

          SLSMS.Clear;
          Exit;
        end;

      end;
     end;



    //������� ������ � �������
     RowsAdd:=False;
     for i:=1 to Rows do
     begin

       // ����� ������ �����
       case InTypeReport of
        1: begin
          if RowsAdd=False then begin
            if (FData[i,1]='PCODE')     and
               (FData[i,2]='PHONE')     and
               (FData[i,3]='LASTNAME')  and
               (FData[i,4]='IO') then
            begin
             RowsAdd:=True;
             Continue;
            end;
          end;

         PacientPhone:=FData[i,2];
         PacientIO:=FData[i,4];
         PacientBirthday:=FData[i,5];
         PacientPol:=FData[i,6];
         DataPriema:=FData[i,7];
         TimePriema:=FData[i,8];
         FIOVracha:=FData[i,9];
         Napravlenie:=FData[i,10];
         Address:=FData[i,12];


        end;
        2:begin
          if RowsAdd=False then begin
            if (FData[i,1]='PCODE')     and
               (FData[i,2]='PHONE1')    and
               (FData[i,3]='PHONE2')    and
               (FData[i,4]='PHONE3')    and
               (FData[i,5]='LASTNAME')  and
               (FData[i,9]='WORKDATE')  and
               (FData[i,14]='F_SHORTADDR') then
            begin
             RowsAdd:=True;
             Continue;
            end;
          end;


         PacientPhone:=FData[i,16];
         PacientIO:=FData[i,6];
         PacientBirthday:=FData[i,7];
         PacientPol:=FData[i,8];
         DataPriema:=FData[i,9];
         TimePriema:=FData[i,10];
         FIOVracha:=FData[i,11];
         Napravlenie:=FData[i,12];
         Address:=FData[i,14];
        end;
       end;

      begin
        // ������� � ������
        SLSMS.Add(PacientPhone+';'+
                  PacientIO+';'+
                  PacientBirthday+';'+
                  PacientPol+';'+
                  DataPriema+';'+
                  TimePriema+';'+
                  FIOVracha+';'+
                  Napravlenie+';'+
                  Address);
      end;

     end;
   end;

  Excel.quit;
  CurrentPostAddColoredLine('����� ��������',clBlack);
  CurrentPostAddColoredLine('���-�� ��������� �� ��������: '+IntToStr(SLSMS.Count), clGreen);
  CurrentPostAddColoredLine('��������� ����� �� �������� ���� ���: '+GetTimeDiff(SLSMS.Count), clRed);


  Application.ProcessMessages;
end;


// ������ � ���
procedure Log(InText:string;InError:Boolean);
var
 SLSave:TStringList;
 CurrentDateTime,DateTimeNow:string;
 TextStyle,TextColor,TextFont,TextSize:string;

 Color: TColor;
 R,G,B: Byte;
 i:Integer;

 user:string;
begin
 SLSave:=TStringList.Create;
 CurrentDateTime:=FormatDateTime('ddmmyyyy',Now);
 DateTimeNow:=DateTimeToStr(Now);

 TextFont:='Times New Roman';

 TextSize:='3';
 if InError=False then TextColor:='0'
 else TextColor:='262331';
 Color:=ColorToRGB(StrToInt(TextColor));

 //user:='['+currentUser.getUserName+' | '+currentUser.getIP+'] ';

 // ��������� � HEX
 TextColor:=IntToHex(GetRValue(Color),2)+IntToHex(GetGValue(Color),2)+IntToHex(GetBValue(Color),2);

 if not DirectoryExists(FOLDERPATH+'log') then CreateDir(FOLDERPATH+'log');

 if not FileExists(FOLDERPATH+'log\'+CurrentDateTime+cLOG_EXTENSION) then begin
  if InText<>'<hr>' then SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+user+DateTimeNow+' '+InText+'</font><br>')
  else SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+InText+'</font><br>');


  try
    SLSave.SaveToFile(FOLDERPATH+'log\'+CurrentDateTime+cLOG_EXTENSION);
  finally
    // ������ �� ������ ����������
  end;
 end
 else begin
  SLSave.LoadFromFile(FOLDERPATH+'log\'+CurrentDateTime+cLOG_EXTENSION);

  if InText<>'<hr>' then SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+user+DateTimeNow+' '+InText+'</font><br>')
  else SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+InText+'</font><br>');


  try
   SLSave.SaveToFile(FOLDERPATH+'log\'+CurrentDateTime+cLOG_EXTENSION);
  finally
   // ������ �� ������ ����������
  end;
 end;

 if SLSave<>nil then FreeAndNil(SLSave);
end;


// �������� ���
function GetSMS(inPacientPhone,inPacientIO,inPacientBirthday,inPacientPol,
                inDataPriema,inTimePriema,inFIOVracha,inNapravlenie,inAddress:string):string; overload;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;

 Age:int64;

 MessageSMS:string;
 HTTPGet:string;
begin

 // �������� �����

 // ��� �������� ������� ��� ��������
  begin
   MessageSMS:=cMESSAGE;

   MessageSMS:=StringReplace(MessageSMS,'%FIO_Pacienta',inPacientIO,[rfReplaceAll]);
   if inPacientPol='�' then MessageSMS:=StringReplace(MessageSMS,'%�������(�)','�������',[rfReplaceAll])
   else MessageSMS:=StringReplace(MessageSMS,'%�������(�)','��������',[rfReplaceAll]);

   MessageSMS:=StringReplace(MessageSMS,'%FIO_Doctora',inFIOVracha,[rfReplaceAll]);
  // MessageSMS:=StringReplace(MessageSMS,'%Napravlenie',inNapravlenie,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Data',inDataPriema,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Time',inTimePriema,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Address',inAddress,[rfReplaceAll]);
  end;


  // ��������� ������ �� ��������
  begin
   HTTPGet:=cWebApiSMS;
    {
   cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
   }

   with FormHome do begin
   // HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
   // HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', EncodeURL(AnsiToUtf8(MessageSMS)),[rfReplaceAll]);
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
       else} ServerOtvet:='OK';
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
    Log(MessageSMS,False);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;
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

 MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');

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
    Log(MessageSMS,False);

    // ��������� ��������� ������������ ��������� ��� ������� � ���� ��� ������������ �������� ���������
    AddSaveMessageOld(MessageSMS);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   Sleep(500);
end;


// ����������� ���� �� ��������
procedure ShowInfoMessage(arrMsg: array of TSMSMessage; arrCount:Integer);
var
  SLMsg:TStringList;
  i:Integer;
begin

  SLMsg:=TStringList.Create;

  for i:=0 to arrCount-1 do begin
    SLMsg.Add('�����: '+DateToStr(arrMsg[i].getDate)+' '+TimeToStr(arrMsg[i].getTime));
    SLMsg.Add('����� ��������: '+arrMsg[i].getPhone);
    SLMsg.Add('������ ���������: '+arrMsg[i].getCode+' ('+arrMsg[i].getStatus+')');
    SLMsg.Add('');
    SLMsg.Add('����� ���������: '+arrMsg[i].getMsg);
    SLMsg.Add(' ================================================================= ');
    SLMsg.Add('');
    SLMsg.Add('');
  end;

  ShowMessage(SLMsg.Text);

  if SLMsg<> nil then FreeAndNil(SLMsg);
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
  listMsg:array of TSMSMessage;
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

 SetLength(listMsg,numberPhoneCount);
 for i:=0 to numberPhoneCount-1 do listMsg[i]:=TSMSMessage.Create;
 i:=0;

 oldLenghtResult:=Length(ResultServer);

 // ������ ��� ������������ �������� ������������ �����
 while(AnsiPos(MSGSTOP,ResultServer))<> 0 do begin

   FormHome.ProgressBar.Progress:=100-(Round(100*Length(ResultServer)/oldLenghtResult));
   Application.ProcessMessages;

   tmp:=ResultServer;

   // ������ ������ � ����� ���������
   System.Delete(tmp,1,AnsiPos(MSGSTART,tmp)+Length(MSGSTART));
   System.Delete(tmp,AnsiPos(MSGSTOP,tmp),Length(tmp));

   // ���������
   if AnsiPos(inPacientPhone,tmp)<>0 then begin

      if i<numberPhoneCount then listMsg[i].Phone:=inPacientPhone;

      //ShowMessage(IntToStr(100-(Round(100*Length(ResultServer)/oldLenghtResult))));

      SMS_ID:=tmp;
      System.Delete(SMS_ID,1,AnsiPos('"',SMS_ID));
      System.Delete(SMS_ID,AnsiPos('"',SMS_ID),Length(SMS_ID));
      if i<numberPhoneCount then listMsg[i].SMS_ID:=SMS_ID;

      CreatDate:=tmp;
      System.Delete(CreatDate,1,AnsiPos('<CREATED>',CreatDate)+Length('<CREATED>')-1);
      System.Delete(CreatDate,AnsiPos(' ',CreatDate),Length(CreatDate));
      if i<numberPhoneCount then listMsg[i].CreatDate:=StrToDate(CreatDate);

      CreatTime:=tmp;
      System.Delete(CreatTime,1,AnsiPos('<CREATED>',CreatTime)+Length('<CREATED>')-1);
      System.Delete(CreatTime,1,AnsiPos(' ',CreatTime));
      System.Delete(CreatTime,AnsiPos('<',CreatTime),Length(CreatTime));
      if i<numberPhoneCount then listMsg[i].CreatTime:=StrToTime(CreatTime);

      MsgText:=tmp;
      System.Delete(MsgText,1,AnsiPos('[CDATA[',MsgText)+Length('[CDATA[')-1);
      System.Delete(MsgText,AnsiPos(']]></SMS_TEXT>',MsgText),Length(MsgText));
      if i<numberPhoneCount then listMsg[i].MsgText:=MsgText;

      Code:=tmp;
      System.Delete(Code,1,AnsiPos('<SMSSTC_CODE>',Code)+Length('<SMSSTC_CODE>')-1);
      System.Delete(Code,AnsiPos('</SMSSTC_CODE>',Code),Length(Code));
      if i<numberPhoneCount then listMsg[i].Code:=Code;

      Status:=tmp;
      System.Delete(Status,1,AnsiPos('<SMS_STATUS>',Status)+Length('<SMS_STATUS>')-1);
      System.Delete(Status,AnsiPos('</SMS_STATUS>',Status),Length(Status));
      if i<numberPhoneCount then listMsg[i].Status:=Status;

      Inc(i);
   end;

   // ��������� ������
    System.Delete(ResultServer,1,AnsiPos(MSGSTOP,ResultServer));

   Dec(nowbreak,1);
   if nowbreak=0 then begin
    // FormPleaseWait.Free;
     MessageBox(FormHome.Handle,PChar('��������� ����� ���������� ��� ������� �������'),PChar('Runtime Error'),MB_OK+MB_ICONERROR);
     Exit;
   end;

 end;

  FormHome.ProgressBar.Progress:=0;

  //���������� ���������
  if numberPhoneCount<>0 then ShowInfoMessage(listMsg,numberPhoneCount);


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

// ������ � �������� ���
procedure ParsingSMSandSend(InSMSList:TStringList;InTypeReport:Word);   { InTypeReport=1 - ����� ��� | InTypeReport=2 - ����� ��������  }
var
 i,j:Integer;

 PacientPhonetmp:string;
 PacientPhone,PacientIO,PacientBirthday,PacientPol,DataPriema,TimePriema,
 FIOVracha,Napravlenie,Address:string;

 SMSResult:string;

begin
  for i:=0 to InSMSList.Count-1 do begin
    PacientPhone:='';
    PacientIO:='';
    PacientBirthday:='';
    PacientPol:='';
    DataPriema:='';
    TimePriema:='';
    FIOVracha:='';
    Napravlenie:='';
    Address:='';

    with FormHome do begin
     ProgressBar.Progress:=Round(100*i/InSMSList.Count-1);
     lblProgressBar.Caption:=IntToStr(i+1)+' �� '+IntToStr(InSMSList.Count);
     Application.ProcessMessages;
    end;

    // ���������
    PacientPhone:=InSMSList[i];
    System.Delete(PacientPhone,AnsiPos(';',PacientPhone),Length(PacientPhone));
    PacientPhonetmp:=PacientPhone;

    // �������� ����� ������� ������ �� ���� (PacientPhone)
    begin
     if AnsiPos(' ',PacientPhone)<>0 then begin
      // ������������ ������
      CurrentPostAddColoredLine('������� ������! � ������ �������� "'+PacientPhone+'" ������������ ������',clRed);
      PacientPhone:=StringReplace(PacientPhone,' ','',[rfReplaceAll]);
     end;

     // �������� ����� ����� �������� ��� ������ �������
     case InTypeReport of
      1:begin
       if AnsiPos('(9',PacientPhone)=0 then begin
        // ����� �������� �� �������
        CurrentPostAddColoredLine('������� ������! ����� �������� "'+PacientPhone+'" �� ���������, ������� ������ ������',clRed);

        // ������� ������ ������ � ������
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('����� �������� �� ��������� >> '+InSMSList[i]);
        end;

        Continue;
       end;

       // �������� �� ��������� ������ ��� ������� ))
       PacientPhone:=StringReplace(PacientPhone,'(','',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,')','',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,'+7','8',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,'-','',[rfReplaceAll]);

      end;
      2:begin
       if (PacientPhone[1]<>'7') and (PacientPhone[2]<>'9') then begin
        // ����� �������� �� �������
        CurrentPostAddColoredLine('������� ������! ����� �������� "'+PacientPhone+'" �� ���������, ������� ������ ������',clRed);

        // ������� ������ ������ � ������
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('����� �������� �� ��������� >> '+InSMSList[i]);
        end;

        Continue;
       end;
       // �������� �� ��������� ������ ��� ������� ))
       PacientPhone[1]:='8';
      end;
     end;


     // ��������� ��������, ����� ������ ����� �� ������ � �� ������ 11 ��������
     if Length(PacientPhone)<>11  then begin
      CurrentPostAddColoredLine('������� ������! �� ������� ��������� ���������� ����� �������� "'+PacientPhonetmp+'", ������� ������ ������',clRed);

       with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add('����� �������� �� ��������� >> '+InSMSList[i]);
       end;

       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (PacientIO)
    begin
      PacientIO:=InSMSList[i];
      for j:=1 to 1 do System.Delete(PacientIO,1,AnsiPos(';',PacientIO));
      System.Delete(PacientIO,AnsiPos(';',PacientIO),Length(PacientIO));

      if PacientIO='' then begin
       ErrorParsingLog(PacientPhone,'��� ��������',InSMSList[i]);
       Continue;
      end;

    end;

    // �������� ����� ������� ������ �� ���� (PacientBirthday)
    begin
      PacientBirthday:=InSMSList[i];
      for j:=1 to 2 do System.Delete(PacientBirthday,1,AnsiPos(';',PacientBirthday));
      System.Delete(PacientBirthday,AnsiPos(';',PacientBirthday),Length(PacientBirthday));

      if PacientBirthday='' then begin
       ErrorParsingLog(PacientPhone,'���� ��������',InSMSList[i]);
       Continue;
      end;

    end;


    // �������� ����� ������� ������ �� ���� (PacientPol)
    begin
      PacientPol:=InSMSList[i];
      for j:=1 to 3 do System.Delete(PacientPol,1,AnsiPos(';',PacientPol));
      System.Delete(PacientPol,AnsiPos(';',PacientPol),Length(PacientPol));

     if PacientPol='' then begin
       ErrorParsingLog(PacientPhone,'���',InSMSList[i]);
       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (DataPriema)
    begin
      DataPriema:=InSMSList[i];
      for j:=1 to 4 do System.Delete(DataPriema,1,AnsiPos(';',DataPriema));
      System.Delete(DataPriema,AnsiPos(';',DataPriema),Length(DataPriema));

     if DataPriema='' then begin
       ErrorParsingLog(PacientPhone,'���� ������',InSMSList[i]);
       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (TimePriema)
    begin
      TimePriema:=InSMSList[i];
      for j:=1 to 5 do System.Delete(TimePriema,1,AnsiPos(';',TimePriema));
      System.Delete(TimePriema,AnsiPos(';',TimePriema),Length(TimePriema));

     if TimePriema='' then begin
       ErrorParsingLog(PacientPhone,'����� ������',InSMSList[i]);
       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (FIOVracha)
    begin
      FIOVracha:=InSMSList[i];
      for j:=1 to 6 do System.Delete(FIOVracha,1,AnsiPos(';',FIOVracha));
      System.Delete(FIOVracha,AnsiPos(';',FIOVracha),Length(FIOVracha));

     if FIOVracha='' then begin
       ErrorParsingLog(PacientPhone,'��� �����',InSMSList[i]);
       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (Napravlenie)
    begin
      Napravlenie:=InSMSList[i];
      for j:=1 to 7 do System.Delete(Napravlenie,1,AnsiPos(';',Napravlenie));
      System.Delete(Napravlenie,AnsiPos(';',Napravlenie),Length(Napravlenie));
      // ��������� � ������������ ���, ����� ��� ���� �� ������
     Napravlenie:=AnsiLowerCase(Napravlenie);

     if Napravlenie='' then begin
       ErrorParsingLog(PacientPhone,'�����������',InSMSList[i]);
       Continue;
     end;
    end;

    // �������� ����� ������� ������ �� ���� (Address)
    begin
      Address:=InSMSList[i];
      for j:=1 to 8 do System.Delete(Address,1,AnsiPos(';',Address));

     // if Address='' then Address:=cTempAddrClinika;

     if Address='' then begin
        CurrentPostAddColoredLine('������� ������! ����� ������� "������", ������� ������ ������',clRed);

        // ������� ������ ������ � ������
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('������ ����� ������� >> '+InSMSList[i]);
        end;

        Continue;
     end;

     // �������� ���� �� � ������ �.
     if (AnsiPos('�.',Address)=0) then Address:='�. '+Address;
    end;


    // ���������� ���
   try
    SMSResult:=GetSMS(PacientPhone,
                      PacientIO,
                      PacientBirthday,
                      PacientPol,
                      DataPriema,
                      TimePriema,
                      FIOVracha,
                      Napravlenie,
                      Address);

   except on E:Exception do
    begin
       CurrentPostAddColoredLine('������! �� ������� ��������� ��� �� ����� "'+PacientPhonetmp+'" , '+e.ClassName+': '+e.Message,clRed);

       with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add(InSMSList[i]);
       end;

      SMSResult:=SMSResult+' '+e.Message;
      Continue;
    end;
   end;

   if SMSResult='OK' then begin
      {if global_DEBUG=False then} CurrentPostAddColoredLine('���������� ��� �� ����� "'+PacientPhonetmp+'"',clGreen)
     { else CurrentPostAddColoredLine('DEBUG. ���������� ���������� ��� �� ����� "'+PacientPhonetmp+'"',clGreen)}
   end
   else begin
     CurrentPostAddColoredLine(SMSResult+'. ����� �������� �� ������� �� ������� ��������� ��� "'+PacientPhonetmp+'"',clRed);

      with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add(InSMSList[i]);
      end;
   end;

   Sleep(cSLEEPNEXTSMS);
  end;

//  ShowMessage(FormHome.SLParsingError.Text);
end;



// ����������� ������ � ����
procedure ErrorParsingLog(InPhoneNumber,InTypeParsing,InFullStackSMSParsing:string);
var
 TextError:string;
begin
  TextError:='�� ��������� ������ ' +InTypeParsing;

  CurrentPostAddColoredLine('������! �� ������� ��������� ��� �� ����� "'+InPhoneNumber+'" , ������� ������: '+TextError,clRed);

   with FormHome do begin
    ParsingError:=True;
    SLParsingError.Add(InFullStackSMSParsing);
   end;
end;


// ����� ������������ ���������� �������
function GetTimeDiff(InCurrentSec:Integer):string;
var
 WorkingHours:string;
 days,hour,min,sec:Integer;
 hourtmp,mintmp,sectmp:string;
 CurrentSec:Integer;
begin
  // InType=0 - ���������� ������ X� XX��� XX��� XX���
  // InType=1 - ���������� ������ 1� 00:00:00

   CurrentSec:=InCurrentSec;

  days:=Trunc(CurrentSec/(24*3600));
  dec(CurrentSec,days * 24*3600);

  hour:=Trunc(CurrentSec/3600);
  hourtmp:=IntToStr(hour);
  if Length(hourtmp)=1 then hourtmp:='0'+hourtmp;
  dec(CurrentSec,hour * 3600);


  min:=Trunc(CurrentSec/60);
  mintmp:=IntToStr(min);
  if Length(mintmp)=1 then mintmp:='0'+mintmp;
  dec(CurrentSec,min * 60);

  sec:=CurrentSec;
  sectmp:=IntToStr(sec);
  if Length(sectmp)=1 then sectmp:='0'+sectmp;

  if days<>0 then WorkingHours:=IntToStr(days)+' �� '+IntToStr(hour)+' ��� '+IntToStr(min)+' ��� '+IntToStr(sec)+' ���'
  else
  begin
   if hour<>0 then WorkingHours:=IntToStr(hour)+' ��� '+IntToStr(min)+' ��� '+IntToStr(sec)+' ���'
   else
   begin
    if min<>0 then WorkingHours:=IntToStr(min)+' ��� '+IntToStr(sec)+' ���'
    else
    begin
     WorkingHours:=IntToStr(sec)+' ���';
     if WorkingHours='0 ���' then WorkingHours:='0.5 ���';
    end;
   end;
  end;

  result:=WorkingHours;
end;


// ���������� ���������
procedure AddSaveMessageOld(InMessage:string);
var
 lastIDmsg:Integer;
begin
 // �������� ���� �� ��������� �����
 if GetExistSaveMessage(InMessage) then Exit;

 // ��������
 lastIDmsg:=StrToInt(SettingsLoadString(cAUTHconf,'msg','lastID','0'));

 if lastIDmsg>=cMAXCOUNTMESSAGEOLD-1 then lastIDmsg:=0; // �������� ID

  SettingsSaveString(cAUTHconf,'msg','msg'+IntToStr(lastIDmsg),InMessage);
  SettingsSaveString(cAUTHconf,'msg','lastID',IntToStr(lastIDmsg+1));
end;


// �������� ���� �� ��� ����� ����������� ���������
function GetExistSaveMessage(InMEssage:string):Boolean;
var
 i:Integer;
 isExist:Boolean;
begin
   isExist:=False;

   for i:=0 to cMAXCOUNTMESSAGEOLD-1 do begin
     if InMEssage=SettingsLoadString(cAUTHconf,'msg','msg'+IntToStr(i),'') then isExist:=True;
   end;

   result:=isExist;
end;



// ��������� ��������� �������� ���������
procedure LoadMsgMessageOld(InMaxCount:Integer);
const
  DefColWidth:Integer = 427;   // ����������� ����� ��� ������� ����� ������������� ����
  Koeff:Double        = 6.27;  // ����������� ���������� ����
var
 i,j:Integer;
 msg:string;

 LastID:Integer;

 maxLenghMsg:Integer; // ������������ ������ ���������

 SLMsg:TStringList;

begin

//  with FormMsgPerenos.SG do begin
//    LastID:=StrToInt(SettingsLoadString(cAUTHconf,'msg','lastID','0'));
//    if LastID=0 then  Inc(LastID);
//
//    DefaultColWidth:=DefColWidth;
//    RowCount:=LastID;
//
//    // ������� ������
//    for i:=0 to RowCount do begin
//      for j:=0 to ColCount do begin
//         Cells[i,j]:='';
//      end;
//    end;
//
//    maxLenghMsg:=0;
//    SLMsg:=TStringList.Create;
//
//    // ���������� �� ������
//    for i:=cMAXCOUNTMESSAGEOLD-1 downto 0 do begin
//      msg:=SettingsLoadString(cAUTHconf,'msg','msg'+IntToStr(i),'');
//
//      if Length(msg)>maxLenghMsg then maxLenghMsg:=Length(msg);
//      if msg<>'' then  SLMsg.Add(msg);
//    end;
//
//    for i:=0 to SLMsg.Count-1 do  Cells[0,i]:=SLMsg[i];
//
//    // �������� ������
//    if maxLenghMsg*Koeff > DefColWidth  then  DefaultColWidth:=Round(maxLenghMsg*Koeff);
//  end;
end;

end.
