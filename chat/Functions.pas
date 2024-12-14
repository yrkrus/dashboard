unit Functions;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TlHelp32, IdBaseComponent, IdComponent, ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,StrUtils,WinSvc,System.Win.ComObj, IdText, Data.Win.ADODB,
  Data.DB, IdException, RegularExpressions,SHDocVw,CustomTypeUnit;

  procedure KillProcess;                                                     // �������������� ���������� ������
  procedure createCopyright;                                                 // �������� Copyright
  procedure createThread;                                                    // �������� �������
  function SendMessage(InChannel: enumChannel;
                     InSender, InRecipient: Integer;
                     InTag:string;
                     InMessage: string):Boolean;                             // �������� ���������


  function GetLastIDMessageFileLog(InChannel,InFileName:string):Integer;     // ���������� ���������� ID ��������� � ����
  procedure MessageSending(var MessageForms: TRichEdit;                          // �������� � �������������� ������� ���������
                           InChannel: enumChannel;
                           InSender: Integer);
  function ReplaceMessageToHTMLFormat(SendingMEssage: TRichEdit):string;   // ������� ��������� ����� ��������� � HTML ������

  procedure AddTagUserMessage(var MessageForms:TRichEdit;
                                  InSelStart:Integer;
                                  InUserFIO:string); // ���������� ���� � ���������

  procedure HideAllBrowser;                                                  // ������� ���� ������� �� ���� ���������
  procedure HideAllTabSheetChat;                                             // �������� ��� ������� � ������� ������
  function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;     // enumActiveBrowser -> string
  function IntegerToEnumActiveBrowser(ID:Integer):enumActiveBrowser;           // enumActiveBrowser -> integer
  function EnumChannelChatIDToString(InChatID:enumChatID):string;             // enumChatID -> string
  function EnumChannelToString(InChannel:enumChannel):string;                 //enumChannel -> string
  function GetActiveChannel:enumChannel;                                      // ����� ������ ����� �������
  function EnumActiveBrowserToInteger(InActiveBrowser:enumActiveBrowser):Integer;    // enumActiveBrowser -> integer

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
     Users_thread:=ThreadUsers.Create(SharedOnlineUsers);
     Users_thread.Priority:=tpNormal;
     UpdateThreadUsers:=True;
    end
    else UpdateThreadUsers:=True;

    // MessageMain_thread
    if MessageMain_thread=nil then
    begin
     FreeAndNil(MessageMain_thread);
     MessageMain_thread:=ThreadMessageMain.Create(SharedLocalMainChat);
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
function SendMessage(InChannel: enumChannel;
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
                         InChannel: enumChannel;
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

  if InChannel=ePublic then recipient:=0
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


// ������� ���� ��������� �� ���� ���������
procedure HideAllBrowser;
var
 i:Integer;
 FoundComponent:TComponent;
begin
  with FormHome do begin
    for i:=0 to ComponentCount-1 do
    begin
      FoundComponent:=Components[i];

      // ���������, �������� �� ��������� TWebBrowser
      if (FoundComponent is TWebBrowser) and (Pos('chat_', FoundComponent.Name) > 0) then
      begin
        TControl(FoundComponent).Visible:=False;
      end;
    end;
  end;
end;


// �������� ��� ������� � ������� ������
procedure HideAllTabSheetChat;
var
 i,j:Integer;
 SheetID:Integer;
 FoundComponent:TComponent;
begin
  with FormHome do begin
    for i:=0 to ComponentCount-1 do
    begin
      FoundComponent:=Components[i];

      // ���������, �������� �� ��������� TWebBrowser
      if (FoundComponent is TTabSheet) and (Pos('sheet_', FoundComponent.Name) > 0) then
      begin
        if FoundComponent.Name <> 'sheet_main' then begin

          // ������ ID �������
           for j:=0 to PageChannel.PageCount-1 do begin
              if SameText(PageChannel.Pages[j].Name, FoundComponent.Name) then begin
               PageChannel.Pages[j].TabVisible:=False;

               Break;
              end;
           end;

        end;
      end;
    end;
  end;
end;


// enumActiveBrowser -> string
function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;
begin
  case InActiveBrowser of
    eNone   :Result:='none';
    eMaster :Result:='master';
    eSlave  :Result:='slave';
  end;
end;

// enumActiveBrowser -> integer
function IntegerToEnumActiveBrowser(ID:Integer):enumActiveBrowser;
begin
  case ID of
   -1: Result:=eNone;
    0: Result:=eMaster;
    1: Result:=eSlave;
  end;
end;


// enumActiveBrowser -> integer
function EnumActiveBrowserToInteger(InActiveBrowser:enumActiveBrowser):Integer;
begin
  case InActiveBrowser of
    eNone:    Result:=  -1;
    eMaster:  Result:=   0;
    eSlave:   Result:=   1;
  end;
end;

// enumChatID -> string
function EnumChannelChatIDToString(InChatID:enumChatID):string;
begin
  case InChatID of
    eChatMain:  Result:='main';
    eChatID0:   Result:='0';
    eChatID1:   Result:='1';
    eChatID2:   Result:='2';
    eChatID3:   Result:='3';
    eChatID4:   Result:='4';
    eChatID5:   Result:='5';
    eChatID6:   Result:='6';
    eChatID7:   Result:='7';
    eChatID8:   Result:='8';
    eChatID9:   Result:='9';
  end;
end;

//enumChannel -> string
function EnumChannelToString(InChannel:enumChannel):string;
begin
   case InChannel of
     ePublic:   Result:='public';
     ePrivate:  Result:='private';
   end;
end;

// ����� ������ ����� �������
function GetActiveChannel:enumChannel;
begin
  with FormHome do begin
    if PageChannel.ActivePage.Name = 'sheet_main' then Result:=ePublic
    else Result:=ePrivate;
  end;
end;


end.
