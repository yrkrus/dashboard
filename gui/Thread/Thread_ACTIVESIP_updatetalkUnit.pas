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
    m_initThread: TEvent;  // ������� ��� ����� ������� ���������
    Log:TLoggingFile;
    { Private declarations }
  public
  constructor Create;
  destructor Destroy; override;
  function WaitForInit(_timeout:Cardinal): Boolean;
  end;

implementation

uses
  FormHome, FunctionUnit, TCustomTypeUnit, TDebugStructUnit;

{ Thread_ACTIVESIP_updateTalk }


constructor Thread_ACTIVESIP_updateTalk.Create;
begin
  inherited Create(True);               // Suspended=true
  FreeOnTerminate := False;
  m_initThread:=TEvent.Create(nil, False, False, '');
end;


destructor Thread_ACTIVESIP_updateTalk.Destroy;
begin
  m_initThread.Free;
  inherited;
end;


function Thread_ACTIVESIP_updateTalk.WaitForInit(_timeout:Cardinal): Boolean;
begin
  if Terminated then Exit(False);
  Result:=(m_initThread.WaitFor(_timeout) = wrSignaled);
end;

procedure Thread_ACTIVESIP_updateTalk.CriticalError;
begin
   // ���������� � ���
   Log.Save(messclass+':'+mess,IS_ERROR);
end;

procedure Thread_ACTIVESIP_updateTalk.show(var p_ActiveSipOperators:TActiveSIP);
begin
  if not CONNECT_BD_ERROR then begin
    with p_ActiveSipOperators do begin
      updateTalkTime;
      updateTalkTimeAll;
    end;
  end;
end;

procedure Thread_ACTIVESIP_updateTalk.Execute;
const
 SLEEP_TIME:Word = 500;
 NAME_THREAD:string = 'Thread_ActiveSip_updateTalk';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

  debugInfo: TDebugStruct;
begin
   inherited;
   CoInitialize(Nil);
  // Sleep(1000);

  Log:=TLoggingFile.Create(NAME_THREAD);

  // ����� debug info
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

  // ������� ��� �����������
  m_initThread.SetEvent;

  while not Terminated do
  begin

    if UpdateACTIVESIPtalkTime then begin
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
