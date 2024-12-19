unit Thread_ACTIVESIP_QueueUnit;

interface

uses
    System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, TLogFileUnit;

type
  Thread_ACTIVESIP_Queue = class(TThread)
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
  FunctionUnit, FormHome, FormDEBUGUnit,GlobalVariables, TCustomTypeUnit;


procedure Thread_ACTIVESIP_Queue.CriticalError;
begin
   HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_ACTIVESIP_Queue.'+messclass+'.'+mess;
end;


procedure Thread_ACTIVESIP_Queue.show(var p_ActiveSipOperators:TActiveSIP);
begin
  if (CONNECT_BD_ERROR=False) then begin
    p_ActiveSipOperators.updateQueue;
  end;
end;

procedure Thread_ACTIVESIP_Queue.Execute;
 const
 SLEEP_TIME:Word = 500;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(1000);

  Log:=TLoggingFile.Create('Thread_ActiveSip_Queue');

  while not Terminated do
  begin

    if UpdateACTIVESIPQueue then  begin
     try
        StartTime:=GetTickCount;

        show(SharedActiveSipOperators);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_ACTIVESIP_Queue.Caption:=IntToStr(Duration);
     except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         TimeLastError:=Now;

         // записываем в лог
         Log.Save(messclass+'.'+mess,IS_ERROR);

         if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.