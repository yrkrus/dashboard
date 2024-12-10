unit Functions;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TlHelp32, IdBaseComponent, IdComponent, ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,StrUtils,WinSvc,System.Win.ComObj, IdText, Data.Win.ADODB,
  Data.DB, IdException;

  procedure KillProcess;                                                     // �������������� ���������� ������
  procedure createCopyright;                                                 // �������� Copyright
  procedure createThread;                                                    // �������� �������
  function GetChannel:string;                                                // ����� �������� ������ � ����� ���������� ���������
  function SendMessage(InChannel: string;
                     InSender, InRecipient: Integer;
                     InTag:string;
                     InMessage: string):Boolean;                              // �������� ���������


  function GetCreateFileLocalChat(InChannel,InFileName:string):Boolean;                // �������� ���������� ����� � �����

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
function GetCreateFileLocalChat(InChannel,InFileName:string):Boolean;
var
 FolderPath:string;
 EmptyFile:TfileStream;
begin
  Result:=False;


  FolderPath:= ExtractFilePath(ParamStr(0)) + CHAT_FOLDER;
  if not DirectoryExists(FolderPath) then CreateDir(Pchar(FolderPath));
  if not DirectoryExists(FolderPath+'\'+InChannel) then CreateDir(Pchar(FolderPath+'\'+InChannel));

  if not FileExists(FolderPath+'\'+InChannel+'\'+InFileName) then begin
    try
      EmptyFile:= TFileStream.Create(FolderPath+'\'+InChannel+'\'+InFileName,fmCreate);
    except
        on E:EIdException do begin
           //e.Message;

           Exit;
        end;
    end;
  end;

  Result:=True;
end;

end.
