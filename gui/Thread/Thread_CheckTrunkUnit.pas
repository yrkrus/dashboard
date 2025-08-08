unit Thread_CheckTrunkUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TCheckSipTrunkUnit, TCustomTypeUnit, TLogFileUnit;

type
  Thread_CheckTrunks = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_listTrunks: TCheckSipTrunk);
    procedure CriticalError;
 private
  Log:TLoggingFile;

  end;

implementation

uses
  FunctionUnit, FormHome, GlobalVariables, TDebugStructUnit, FormServerIKCheckUnit, FormTrunkSipUnit;


procedure Thread_CheckTrunks.CriticalError;
begin
 // записываем в лог
 Log.Save(messclass+':'+mess,IS_ERROR);
end;


procedure Thread_CheckTrunks.show(var p_listTrunks: TCheckSipTrunk);
begin
 if not CONNECT_BD_ERROR then p_listTrunks.CheckSipTrunk;
end;


procedure Thread_CheckTrunks.Execute;
const
 SLEEP_TIME:Word = 10000;
 NAME_THREAD:string = 'Thread_CheckSipTrunk';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  listTrunks:TCheckSipTrunk;

  debugInfo: TDebugStruct;
begin
  inherited;
  CoInitialize(Nil);

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

  try
   listTrunks:=TCheckSipTrunk.Create(Log, HomeForm.lblCheckSipTrunkAlive, FormTrunkSip);
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
    if UpdateCheckSipTrunksStop then begin

      try
        StartTime:=GetTickCount;

        show(listTrunks);

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
