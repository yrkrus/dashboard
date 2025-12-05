unit Thread_InternalProcessUnit;

interface

uses
    System.Classes, System.DateUtils, SysUtils, ActiveX, TLogFileUnit,
    TInternalProcessUnit, System.SyncObjs;

type
  Thread_InternalProcess = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure ShowExecute(var p_InternalProcess: TInternalProcess);
    procedure CriticalError;
  private
    m_initThread: TEvent;  // событие что поток успешно стартовал

    Log:TLoggingFile;
    m_userLogonID:Integer;  // id залогиненного пользователя

    { Private declarations }
  public
  constructor Create(InUserID: Integer); reintroduce; // добавляем конструктор
  destructor Destroy; override;
  function WaitForInit(_timeout:Cardinal): Boolean;

 // procedure AddLogonUserID(InUserID:Integer);

  end;

implementation

uses
  GlobalVariables, TDebugStructUnit;


constructor Thread_InternalProcess.Create(InUserID: Integer);
begin
  inherited Create(True);  // Suspended=true
  m_userLogonID := InUserID; // инициализируем m_userLogonID

  FreeOnTerminate:= False;
  m_initThread:=TEvent.Create(nil, False, False, '');
end;


destructor Thread_InternalProcess.Destroy;
begin
  m_initThread.Free;
  inherited;
end;


function Thread_InternalProcess.WaitForInit(_timeout:Cardinal): Boolean;
begin
  if Terminated then Exit(False);
  Result:=(m_initThread.WaitFor(_timeout) = wrSignaled);
end;


procedure Thread_InternalProcess.CriticalError;
begin
  // записываем в лог
  Log.Save(messclass+':'+mess,IS_ERROR);
end;


procedure Thread_InternalProcess.ShowExecute(var p_InternalProcess: TInternalProcess);
begin
  // текущее время обоновляем постоянно не зависимо от того есть ли коннект с БД или нет
   p_InternalProcess.UpdateTimeDashboard;


   p_InternalProcess.CheckForceActiveSessionClosed;              // нужно ли немедленно закрыть сессию
   p_InternalProcess.UpdateTimeActiveSession(PROGRAMM_UPTIME);   // обновление времени ондайна в БД
   Synchronize(p_InternalProcess.CheckStatusUpdateService);                   // проверка запущена ли служба обновления
   Synchronize(p_InternalProcess.CheckStatusRegisteredSipPhone);              // проверка зарегестрирован ли sip на телефоне
   // p_InternalProcess.XMLUpdateLastOnline;                     // обновление времемни в settings.xml
   p_InternalProcess.UpdateMemory;                               // обновление загрузки по памяти
   Synchronize(p_InternalProcess.ActiveCallsLisaTalk);           // сколько сейчас разговаривает с лизой

end;

procedure Thread_InternalProcess.Execute;
 const
 SLEEP_TIME:Word = 1000;
  NAME_THREAD:string = 'Thread_InternalProcess';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  InternalProcess: TInternalProcess;

  debugInfo: TDebugStruct;
begin
  inherited;
  CoInitialize(Nil);
 // Sleep(1000);

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

  InternalProcess:=TInternalProcess.Create(m_userLogonID,PROGRAM_STARTED);
  // время запуска программы
  InternalProcess.UpdateProgramStarted;

  // событие что запустились
  m_initThread.SetEvent;

  while not Terminated do
  begin
   try
      StartTime:=GetTickCount;

      if not CONNECT_BD_ERROR then begin
        ShowExecute(InternalProcess);
      end;


      EndTime:= GetTickCount;
      Duration:= EndTime - StartTime;

      Inc(PROGRAMM_UPTIME);

      SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
   except
      on E:Exception do
      begin
       messclass:=e.ClassName;
       mess:=e.Message;
       Synchronize(CriticalError);
      end;
   end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;
end.