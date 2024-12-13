unit Thread_MessageMain;

interface

uses
  System.Classes, ActiveX, System.DateUtils,System.SysUtils,
  TOnlineUsersUint, Vcl.ComCtrls,TOnlineChatUnit, System.Variants,
  Vcl.OleCtrls,SHDocVw,MSHTML;

type
  ThreadMessageMain = class(TThread)
    messclass,mess: string;
   procedure Execute; override;
   procedure Show(var p_Message:TOnlineChat);
   procedure CriticalError;

  end;

implementation

uses
  Functions, GlobalVariables, HomeForm;


{ Thread_MessageMain }


procedure ThreadMessageMain.CriticalError;
begin
   FormHome.lblerr.Caption:=GetCurrentTime+' ThreadMessageMain.'+messclass+'.'+mess;
end;



procedure ThreadMessageMain.Show(var p_Message:TOnlineChat);
var
  last_id:Integer;
  Doc: IHTMLDocument2;
  HTMLContent:string;

    v: Variant;
  HTMLDocument: IHTMLDocument2;

begin
  // проверяем есть ли но новые сообщения



  last_id:=GetLastIDMessageFileLog(p_Message.GetChannel,p_Message.GetPathToLogName);


  if not p_Message.isExistNewMessage(last_id) then Exit;

  // подгрузим новые сообщения
  p_Message.LoadingMessageMain(enumMessage.eMessage_update);
  last_id:=GetLastIDMessageFileLog(p_Message.GetChannel,p_Message.GetPathToLogName);



  with FormHome do begin
// есть новые сообщения, надо их показать
  p_Message.ShowChat;
 end;
end;


procedure ThreadMessageMain.Execute;
const
 SLEEP_TIME:Word = 1000;
 CHANNEL:string = 'main';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  MessageMain:TOnlineChat; // текущие собощение в общем чате

  FolderPath:string;

begin
   inherited;
   CoInitialize(Nil);
   Sleep(100);
   FolderPath:= ExtractFilePath(ParamStr(0)) + GetLocalChatNameFolder;

   MessageMain:=TOnlineChat.Create(CHANNEL,FolderPath,GetCurrentTime,GetExtensionLog);

  // подгрузим сообщения
{  with FormHome do begin
   // есть новые сообщения, надо их показать
   message_main.Navigate(PChar(MessageMain.GetPathToNavigate+'#last_'+IntToStr(last_id)));
   while message_main.ReadyState <> READYSTATE_COMPLETE do Sleep(100);
  end;  }


  while not Terminated do
  begin

    if UpdateThreadMessageMain then begin
      try
        StartTime:=GetTickCount;

        show(MessageMain);


        // прогрузили сообщения, все ок

         { if isChatStarted then begin
            isChatStarted:=False;
            //actIndMessageMain.Animate:=False;
            //actIndMessageMain.Visible:=False;
          end; }


        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
      except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
        // TimeLastError:=Now;
         Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.

