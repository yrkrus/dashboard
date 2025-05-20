 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             ����� ��� �������� ���������� ������� �����                   ///
///     �������� � ��������� ������ � ��� �� ������ � �����������             ///
///                     �� ������ ����������                                  ///
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
      m_timerPeriod     :Integer;       // ����� � �������� ��� ������� ��� �� ������ � Execute ������������ (���� �����������)
      Log               :TLoggingFile;
      FTask             :TProc;         // ������� ��� ���������� ������
      m_running         :boolean;       // ���� ��� ������������ ��������� ������
      m_taskName        :string;        // �������� ������


      protected
      procedure TaskRun;
      procedure Execute; override;
      procedure CriticalError;


      public
      constructor Create(_nameLog:string; _timeperiod:Integer; _task: TProc);                   overload;
      destructor  Destroy; override;

      procedure StartThread; // ����� ��� ������� ������
      procedure StopThread; // ����� ��� ��������� ������

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

   FTask:=_task; // ��������� ���������� ������
 end;


destructor TThreadDispatcher.Destroy;
begin
  // �������� ����������� � ���
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
    if m_running then // ���������, ������� �� �����
    begin
      try
        if Assigned(FTask) then begin
          Log.Save('Executed task: '+m_taskName);
          Queue(TaskRun);   // ��������� ���������� ������
        end;
      except
        on E:Exception do
        begin
         messclass    :=e.ClassName;
         mess         :=e.Message;

         Synchronize(CriticalError);
        end;
      end;
      Sleep(m_timerPeriod); // ����� ����� ��������� �����������
    end
    else
    begin
      Sleep(1000); // ���� ����� �� �������, ���� ������� ����� ��������� ���������
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
    m_running := True; // ������������� ���� � true
  end;
end;


procedure TThreadDispatcher.StopThread;
begin
  Log.Save('Task: ' + m_taskName + ' is stopped');
  m_running := False; // ������������� ���� � false

 // Terminate; // ������������� ���� ���������� ������
end;

procedure TThreadDispatcher.CriticalError;
const
 IS_ERROR:Boolean = True;
begin
  // ���������� � ���
  Log.Save(messclass+':'+mess, IS_ERROR);
end;

end.