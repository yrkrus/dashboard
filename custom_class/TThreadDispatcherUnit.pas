 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             Класс для описания диспетчера который будет                   ///
///     работать в отдельном потоке и что то делать в зависимости             ///
///                     от класса наследника                                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TThreadDispatcherUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  TLogFileUnit,
  TCustomTypeUnit;


 // class TThreadDispatcher
  type
      TThreadDispatcher = class(TThread)
       messclass,mess: string;

      private
      m_timerPeriod     :Integer;       // время в секундах при котором что то делаем в Execute периодически (типа планировщик)
      Log               :TLoggingFile;
      FTask             :TProc;         // Делегат для выполнения задачи
      m_running         :boolean;       // Флаг для отслеживания состояния потока
      m_taskName        :string;        // название задачи


      protected
      procedure TaskRun;
      procedure Execute; override;
      procedure CriticalError;


      public
      constructor Create(_nameLog:string; _timeperiod:Integer; _task: TProc);                   overload;
      destructor  Destroy; override;

      procedure StartThread; // Метод для запуска потока
      procedure StopThread; // Метод для остановки потока

      end;
 // class TThreadDispatcher END

implementation


constructor TThreadDispatcher.Create(_nameLog:string; _timeperiod:Integer;  _task: TProc);
 begin
   inherited Create(False);
   messclass:='';
   mess:='';

   Log:=TLoggingFile.Create('Thread_dispather_'+_nameLog);
   m_timerPeriod:=_timeperiod * 1000;

   m_taskName:=_nameLog;

   FTask:=_task; // Сохраняем переданную задачу
 end;


destructor TThreadDispatcher.Destroy;
begin
  // сигналим завершиться и ждём
  if not Terminated then
  begin
    Terminate;
    WaitFor;
  end;
  if Assigned(Log) then FreeAndNil(Log);

  inherited;
end;

procedure TThreadDispatcher.TaskRun;
begin
  FTask();
end;


procedure TThreadDispatcher.Execute;
begin
  while not Terminated do
  begin
    if m_running then // Проверяем, запущен ли поток
    begin
      try
        if Assigned(FTask) then begin
          Log.Save('Executed task: '+m_taskName);
          Queue(TaskRun);   // Выполняем переданную задачу
        end;
      except
        on E:Exception do
        begin
         messclass    :=e.ClassName;
         mess         :=e.Message;

         Synchronize(CriticalError);
        end;
      end;
      Sleep(m_timerPeriod); // Пауза перед следующим выполнением
    end
    else
    begin
      Sleep(1000); // Если поток не запущен, ждем немного перед проверкой состояния
    end;
  end;
end;


procedure TThreadDispatcher.StartThread;
begin
  if Terminated then begin
    Start;
  end;

  if not m_running then
  begin
    Log.Save('Task: ' + m_taskName + ' is started');
    m_running := True; // Устанавливаем флаг в true
  end;
end;


procedure TThreadDispatcher.StopThread;
begin
  Log.Save('Task: ' + m_taskName + ' is stopped');
  m_running := False; // Устанавливаем флаг в false

 // Terminate; // Устанавливаем флаг завершения потока
end;

procedure TThreadDispatcher.CriticalError;
const
 IS_ERROR:Boolean = True;
begin
  // записываем в лог
  Log.Save(messclass+':'+mess, IS_ERROR);
end;

end.