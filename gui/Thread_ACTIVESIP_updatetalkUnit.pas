unit Thread_ACTIVESIP_updatetalkUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, System.SyncObjs,TActiveSIPUnit,GlobalVariables, TLogFileUnit;

type
  Thread_ACTIVESIP_updateTalk = class(TThread)
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
  FormHome, FunctionUnit, FormDEBUGUnit, TCustomTypeUnit;

{ Thread_ACTIVESIP_updateTalk }

procedure Thread_ACTIVESIP_updateTalk.CriticalError;
begin
   HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_ACTIVESIP_updateTalk.'+messclass+'.'+mess;
end;

procedure Thread_ACTIVESIP_updateTalk.show(var p_ActiveSipOperators:TActiveSIP);
begin
  if (CONNECT_BD_ERROR=False) then begin
    with p_ActiveSipOperators do begin
      updateTalkTime;
      updateTalkTimeAll;
    end;
  end;
end;

procedure Thread_ACTIVESIP_updateTalk.Execute;
const
 SLEEP_TIME:Word = 500;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
   inherited;
   CoInitialize(Nil);
   Sleep(1000);

   Log:=TLoggingFile.Create('Thread_ActiveSip_updateTalk');

  while not Terminated do
  begin

    if UpdateACTIVESIPtalkTime then begin
      try
        StartTime:=GetTickCount;

        show(SharedActiveSipOperators);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_ACTIVESIP_updateTalk.Caption:=IntToStr(Duration);
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
