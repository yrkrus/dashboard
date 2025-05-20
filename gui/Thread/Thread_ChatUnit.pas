unit Thread_ChatUnit;


interface

uses
    System.Classes, System.DateUtils, SysUtils, ActiveX, TOnlineChat, TLogFileUnit;

type
  Thread_Chat = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show;
    procedure CriticalError;
  private
   LocalChat:TChat;
   Log:TLoggingFile;
    { Private declarations }
  end;

implementation

uses
  FunctionUnit, FormHome, GlobalVariables,TCustomTypeUnit, TDebugStructUnit;


procedure Thread_Chat.CriticalError;
begin
   // записываем в лог
 Log.Save(messclass+':'+mess,IS_ERROR);
end;


procedure Thread_Chat.show;
begin
  if not CONNECT_BD_ERROR then begin
    LocalChat.CheckNewMessage;
  end;
end;

procedure Thread_Chat.Execute;
 const
 SLEEP_TIME:Word = 500;
 NAME_THREAD:string = 'Thread_OnlineChat';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

  debugInfo: TDebugStruct;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(1000);

  Log:=TLoggingFile.Create(NAME_THREAD);

  // вывод debug info
  try
     debugInfo:=TDebugStruct.Create(NAME_THREAD,Log);
     SharedCountResponseThread.Add(debugInfo);
  except
    on E:Exception do
    begin
     messclass:=e.ClassName;
     mess:=e.Message;
     Synchronize(CriticalError);
    end;
  end;

  LocalChat:=TChat.Create(eChatMain,ePublic);

  while not Terminated do
  begin

    if UpdateOnlineChatStop then  begin
     try
        StartTime:=GetTickCount;

        show;

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
     except
        on E:Exception do
        begin
         //INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
         //INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
