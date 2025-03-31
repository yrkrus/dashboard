unit Thread_InternalProcessUnit;

interface

uses
    System.Classes,
    System.DateUtils,
    SysUtils,
    ActiveX,
    TLogFileUnit,
    TInternalProcessUnit,
    FormHome;

type
  Thread_InternalProcess = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_InternalProcess: TInternalProcess);
    procedure CriticalError;
  private
    Log:TLoggingFile;
    m_userLogonID:Integer;  // id залогиненного пользователя

    { Private declarations }
  public
  constructor Create(InUserID: Integer); reintroduce; // добавляем конструктор

 // procedure AddLogonUserID(InUserID:Integer);

  end;

implementation

uses
  GlobalVariables, TDebugStructUnit;


constructor Thread_InternalProcess.Create(InUserID: Integer);
begin
  inherited Create(True); // Создаем поток в приостановленном состоянии
  m_userLogonID := InUserID; // инициализируем m_userLogonID
end;


procedure Thread_InternalProcess.CriticalError;
begin
  // записываем в лог
  Log.Save(messclass+'.'+mess,IS_ERROR);
end;


procedure Thread_InternalProcess.show(var p_InternalProcess: TInternalProcess);
begin
  // текущее время обоновляем постоянно не зависимо от того есть ли коннект с БД или нет
   p_InternalProcess.UpdateTimeDashboard;

  if not CONNECT_BD_ERROR then begin
    p_InternalProcess.CheckForceActiveSessionClosed;              // нужно ли немедленно закрыть сессию
    p_InternalProcess.UpdateTimeActiveSession(PROGRAMM_UPTIME);   // обновление времени ондайна в БД
    p_InternalProcess.CheckStatusUpdateService;                   // проверка запущена ли служба обновления
    p_InternalProcess.XMLUpdateLastOnline;                        // обновление времемни в settings.xml
  end;

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
  Sleep(1000);

  Log:=TLoggingFile.Create(NAME_THREAD);
  // вывод debug info
  debugInfo:=TDebugStruct.Create(NAME_THREAD,Log);
  SharedCountResponseThread.Add(debugInfo);


  InternalProcess:=TInternalProcess.Create(m_userLogonID,PROGRAM_STARTED);
  // время запуска программы
  InternalProcess.UpdateProgramStarted;


  while not Terminated do
  begin

    if UpdateInternalProcess then  begin
     try
        StartTime:=GetTickCount;

        show(InternalProcess);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;

        Inc(PROGRAMM_UPTIME);

        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
     except
        on E:Exception do
        begin
         //INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
        // INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;
end.