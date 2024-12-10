unit Thread_ACTIVESIP_updatePhoneTalkUnit;

interface

uses
  System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, GlobalVariables;

type
  Thread_ACTIVESIP_updatePhoneTalk = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_ActiveSipOperators:TActiveSIP);
    procedure CriticalError;
  private
    { Private declarations }
  end;

implementation

uses
  FunctionUnit, FormHome, FormDEBUGUnit, TCustomTypeUnit;


 procedure Thread_ACTIVESIP_updatePhoneTalk.CriticalError;
 begin
   HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_ACTIVESIP_updatePhoneTalk.'+messclass+'.'+mess;
 end;


{ Thread_ACTIVESIP }
procedure Thread_ACTIVESIP_updatePhoneTalk.show(var p_ActiveSipOperators:TActiveSIP);
begin
  if (CONNECT_BD_ERROR=False) then begin
    p_ActiveSipOperators.updatePhoneTalk;
  end;
end;

procedure Thread_ACTIVESIP_updatePhoneTalk.Execute;
 const
 SLEEP_TIME:Word = 500;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(1000);

  while not Terminated do
  begin

    if UpdateACTIVESIPtalkTimePhone then  begin
     try
        StartTime:=GetTickCount;

        show(SharedActiveSipOperators);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_ACTIVESIP_updatePhoneTalk.Caption:=IntToStr(Duration);
     except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         TimeLastError:=Now;

         if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;
     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
