unit Functions;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TlHelp32, IdBaseComponent, IdComponent, ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,StrUtils,WinSvc,System.Win.ComObj, IdText, Data.Win.ADODB,
  Data.DB, IdException;

  procedure KillProcess;                                                     // принудительное завершение работы
  procedure createCopyright;                                                 // создание Copyright
  procedure createThread;                                                    // создание потоков
  function GetChannel:string;                                                // поиск текущего канала в какой отправляем сообщение
  function SendMessage(InChannel: string;
                     InSender, InRecipient: Integer;
                     InTag:string;
                     InMessage: string):Boolean;                              // отправка сообщения


  function GetCreateFileLocalChat(InChannel,InFileName:string):Boolean;                // создание локального файла с чатом

implementation



uses
  GlobalVariables, HomeForm, Thread_Users, TSendMessageUnit, Thread_MessageMain;


 //принудительное завершение работы
procedure KillProcess;
begin
  TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
end;

// создание Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[1].Text:=GetCopyright;

  end;
end;

// создание потоков
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



    // запуск потоков
    Users_thread.Resume;
    MessageMain_thread.Resume;

  end;
end;


// отправка сообщения
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


// поиск текущего канала в какой отправляем сообщение
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

 // создание локального файла с чатом
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
