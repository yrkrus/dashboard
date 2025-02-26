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
  FunctionUnit, FormHome, FormDEBUGUnit,GlobalVariables,TCustomTypeUnit;


procedure Thread_Chat.CriticalError;
begin
   // ���������� � ���
 Log.Save(messclass+'.'+mess,IS_ERROR);
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
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(1000);

  Log:=TLoggingFile.Create('Thread_OnlineChat');

  LocalChat:=TChat.Create(eChatMain,ePublic);

  while not Terminated do
  begin

    if UpdateOnlineChatStop then  begin
     try
        StartTime:=GetTickCount;

        show;

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_Chat.Caption:=IntToStr(Duration);
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
