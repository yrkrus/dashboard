unit Thread_CHECKSERVERSUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TCheckServersUnit, TCustomTypeUnit;

type
  Thread_CHECKSERVERS = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_listServers: TCheckServersIK);
    procedure CriticalError;
  end;

implementation

uses
  FunctionUnit, FormHome, FormDEBUGUnit,GlobalVariables;


procedure Thread_CHECKSERVERS.CriticalError;
begin
  HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_CHECKSERVERS.'+messclass+'.'+mess;
end;


procedure Thread_CHECKSERVERS.show(var p_listServers: TCheckServersIK);
begin
 if (CONNECT_BD_ERROR=False) then p_listServers.CheckServerFirebird;
end;


procedure Thread_CHECKSERVERS.Execute;
const
 SLEEP_TIME:Word = 5000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  listServers:TCheckServersIK;

begin
  inherited;
  CoInitialize(Nil);

  listServers:=TCheckServersIK.Create;

  while not Terminated do
  begin

      if UpdateCHECKSERVERSSTOP then begin

        try
          StartTime:=GetTickCount;

          show(listServers);

          EndTime:= GetTickCount;
          Duration:= EndTime - StartTime;
          FormDEBUG.lblThread_CHECKSERVERS.Caption:=IntToStr(Duration);
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
