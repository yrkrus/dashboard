unit Functions;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TlHelp32, IdBaseComponent, IdComponent, ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,StrUtils,WinSvc,System.Win.ComObj, IdText, Data.Win.ADODB,
  Data.DB, IdException, RegularExpressions;

  procedure KillProcess;                                                     // �������������� ���������� ������
  procedure createCopyright;                                                 // �������� Copyright
  procedure createThread;                                                    // �������� �������
  function GetChannel:string;                                                // ����� �������� ������ � ����� ���������� ���������
  function SendMessage(InChannel: string;
                     InSender, InRecipient: Integer;
                     InTag:string;
                     InMessage: string):Boolean;                             // �������� ���������


  function CreateFileLocalChat(InChannel,InFileName:string):Boolean;         // �������� ���������� ����� � �����
  function isExistFileLog(InChannel,InFileName:string):Boolean;              // ���� �� ��� ���� ������� �� �����
  function GetLastIDMessageFileLog(InChannel,InFileName:string):Integer;     // ���������� ���������� ID ��������� � ����
  procedure MessageSending(var MessageForms: TRichEdit;                          // �������� � �������������� ������� ���������
                           InChannel: string;
                           InSender: Integer);
  function ReplaceMessageToHTMLFormat(SendingMEssage: TRichEdit):string;   // ������� ��������� ����� ��������� � HTML ������

  procedure AddTagUserMessage(var MessageForms:TRichEdit;
                                  InSelStart:Integer;
                                  InUserFIO:string); // ���������� ���� � ���������


implementation



uses
  GlobalVariables, HomeForm, Thread_Users, TSendMessageUnit, Thread_MessageMain;


 //�������������� ���������� ������
procedure KillProcess;
begin
  TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
end;

// �������� Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[1].Text:=GetCopyright;

  end;
end;

// �������� �������
procedure createThread;
begin
  with FormHome do begin

    // Thread_Users
    if Users_thread=nil then
    begin
     FreeAndNil(Users_thread);
     Users_thread:=ThreadUsers.Create(True);
     Users_thread.Priority:=tpNormal;
     UpdateThreadUsers:=True;
    end
    else UpdateThreadUsers:=True;

    // MessageMain_thread
    if MessageMain_thread=nil then
    begin
     FreeAndNil(MessageMain_thread);
     MessageMain_thread:=ThreadMessageMain.Create(True);
     MessageMain_thread.Priority:=tpNormal;
     UpdateThreadMessageMain:=True;
    end
    else UpdateThreadMessageMain:=True;



    // ������ �������
    Users_thread.Resume;
    MessageMain_thread.Resume;

  end;
end;


// �������� ���������
function SendMessage(InChannel: string;
                     InSender, InRecipient: Integer;
                     InTag:string;
                     InMessage: string):Boolean;
var
 sending:TSendMessage;
begin
 sending:=TSendMessage.Create;

   try
    Result:=sending.Send(InChannel,InSender,InRecipient,InTag,InMessage);
   finally
     if Assigned(sending) then sending.Free;
   end;
end;


// ����� �������� ������ � ����� ���������� ���������
function GetChannel:string;
var
  ActiveSheet: TTabSheet;
begin
  with FormHome do begin
    ActiveSheet := PageChannel.ActivePage as TTabSheet;
    if ActiveSheet.Name = 'sheet_main' then begin
      Result:='main';
      Exit;
    end;
  end;
end;

 // �������� ���������� ����� � �����
function CreateFileLocalChat(InChannel,InFileName:string):Boolean;
var
 FolderPath:string;
 EmptyFile:TfileStream;
begin
  Result:=False;

  FolderPath:= ExtractFilePath(ParamStr(0)) + GetLocalChatNameFolder;
  if not DirectoryExists(FolderPath) then CreateDir(Pchar(FolderPath));
  if not DirectoryExists(FolderPath+'\'+InChannel) then CreateDir(Pchar(FolderPath+'\'+InChannel));

  if not FileExists(FolderPath+'\'+InChannel+'\'+InFileName) then begin
    try
      EmptyFile:= TFileStream.Create(FolderPath+'\'+InChannel+'\'+InFileName,fmCreate);
    except
        on E:EIdException do begin
           FormHome.lblerr.Caption:=e.Message;

           Exit;
        end;
    end;
  end;

  EmptyFile.Free;
  Result:=True;
end;

// ���� �� ��� ���� ������� �� �����
function isExistFileLog(InChannel,InFileName:string):Boolean;
var
 FolderPath:string;
begin
   Result:=False;
   FolderPath:= ExtractFilePath(ParamStr(0)) + GetLocalChatNameFolder;

   if not DirectoryExists(FolderPath) then Exit;
   if not DirectoryExists(FolderPath+'\'+InChannel) then Exit;
   if not FileExists(FolderPath+'\'+InChannel+'\'+InFileName) then Exit;

   Result:=True;
end;

// ���������� ���������� ID ��������� � ����
function GetLastIDMessageFileLog(InChannel,InFileName:string):Integer;
var
 SLFileLog:TStringList;
 FolderPath:string;
 Regex: TRegEx;
 Match:TMatch;

 lastStroka:string;
begin
 SLFileLog:=TStringList.Create;
 SLFileLog.LoadFromFile(InFileName);

 if SLFileLog.Count = 0 then begin
  Result:=0;
  Exit;
 end;

 lastStroka:=SLFileLog[SLFileLog.Count-1];

 Regex:= TRegEx.Create('message_id="(\d+)"', [roIgnoreCase]);
 Match:= Regex.Match(lastStroka);

 if Match.Success then Result:= StrToInt(Match.Groups[1].Value)
 else Result:=0;

 if SLFileLog<>nil then FreeAndNil(SLFileLog);

end;


// ������� ��������� ����� ��������� � HTML ������
function ReplaceMessageToHTMLFormat(SendingMessage: TRichEdit):string;
var
 SLText:TStringList;  // ��������� ���������
 i:Integer;
 text:string;
 isLongMessage:Boolean;
 test:Integer;
begin
 SLText:=TStringList.Create;
 text:='';

 try
  for i:=0 to SendingMessage.Lines.Count-1 do begin

   SLText.Add(SendingMessage.Lines[i]);
  end;
 finally
  // ������

  for i:=0 to SLText.Count-1 do begin
     // TODO ����� ������� ������ � ��������!!!


     // #9 ���������!! TODO �� ������ ��� ���

    if text='' then text:=SLText[i]
    else text:=text+'<br>'+SLText[i];
  end;
 end;

 Result:=text;

end;

// �������� � �������������� ������� ���������
procedure MessageSending(var MessageForms: TRichEdit;
                         InChannel: string;
                         InSender: Integer);
var
 msg:string;
 recipient:Integer;
 call_id:string;
begin

   msg:=ReplaceMessageToHTMLFormat(MessageForms);
   if msg='' then begin
    MessageBox(FormHome.Handle,PChar('�� ������� ���������� ���������'),PChar('������ ��������'),MB_OK+MB_ICONERROR);
    Exit;
   end;

  if InChannel='main' then recipient:=0
  else begin
   // TODO ��� ��������!

  end;

    // TODO ��� �������� ����� ������ ������������
   // tag
     call_id:='-1';

   if not SendMessage(InChannel,
                     USER_STARTED_CHAT_ID,
                     recipient,
                     call_id,
                     msg) then begin
    MessageBox(FormHome.Handle,PChar('������ �������� ���������:'+#13#13+SENDING_MESSAGE_ERROR),PChar('������ ��������'),MB_OK+MB_ICONERROR);
   end;

   MessageForms.Clear;
end;

// ���������� ���� � ���������
procedure AddTagUserMessage(var MessageForms: TRichEdit; InSelStart:Integer; InUserFIO:string);
 var
 cursorPosition:Integer;
 lineIndex:Integer;
begin
   CursorPosition := MessageForms.SelStart;
   lineIndex:= MessageForms.Perform(EM_LINEFROMCHAR, CursorPosition, 0);

   ShowMessage(Format('������ ��������� �� �������: %d, � ������: %d', [CursorPosition, LineIndex + 1]));



end;


end.
