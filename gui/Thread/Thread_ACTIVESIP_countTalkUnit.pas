unit Thread_ACTIVESIP_countTalkUnit;

interface

uses
    System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, TLogFileUnit;

type
  Thread_ACTIVESIP_countTalk = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_ActiveSipOperators:TActiveSIP);
    procedure CriticalError;
  private
   Log:TLoggingFile;
    { Private declarations }
  end;

implementation

uses
  FunctionUnit, FormHome, GlobalVariables, TCustomTypeUnit, TDebugStructUnit;


procedure Thread_ACTIVESIP_countTalk.CriticalError;
begin
   // записываем в лог
   Log.Save(messclass+':'+mess,IS_ERROR);
end;

procedure Thread_ACTIVESIP_countTalk.show(var p_ActiveSipOperators:TActiveSIP);
begin
  if not CONNECT_BD_ERROR then begin
    p_ActiveSipOperators.updateCountTalk;
  end;
end;

procedure Thread_ACTIVESIP_countTalk.Execute;
 const
 SLEEP_TIME:Word = 500;
 NAME_THREAD:string = 'Thread_ActiveSip_countTalk';
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


  while not Terminated do
  begin

    if UpdateACTIVESIPcountTalk then  begin
     try
        StartTime:=GetTickCount;

        show(SharedActiveSipOperators);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;

        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
     except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.