unit Thread_CHECKSERVERSUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TCheckServersUnit, TCustomTypeUnit, TLogFileUnit;

type
  Thread_CHECKSERVERS = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure ShowExecute(var p_listServers: TCheckServersIK);
    procedure CriticalError;
 private
  Log:TLoggingFile;

  end;

implementation

uses
  FunctionUnit, FormHome, GlobalVariables, TDebugStructUnit, FormServerIKCheckUnit;


procedure Thread_CHECKSERVERS.CriticalError;
begin
 // записываем в лог
 Log.Save(messclass+':'+mess,IS_ERROR);
end;


procedure Thread_CHECKSERVERS.ShowExecute(var p_listServers: TCheckServersIK);
begin
   p_listServers.CheckServerFirebird;
end;


procedure Thread_CHECKSERVERS.Execute;
const
 SLEEP_TIME:Word = 5000;
 NAME_THREAD:string = 'Thread_CheckServersIK';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  listServers:TCheckServersIK;

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
   listServers:=TCheckServersIK.Create(Log, HomeForm.lblCheckInfocilinikaServerAlive, FormServerIKCheck);
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
    if UpdateCHECKSERVERSSTOP then begin

      try
        StartTime:=GetTickCount;

         if not CONNECT_BD_ERROR then begin
           ShowExecute(listServers);
         end;


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
