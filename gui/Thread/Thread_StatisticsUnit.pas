unit Thread_StatisticsUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TLogFileUnit,TQueueStatisticsUnit;

type
  Thread_Statistics = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_SharedQueueStatistics:TQueueStatistics);
    procedure CriticalError;

  private
    Log:TLoggingFile;

  end;

implementation

uses
  DMUnit, FormHome, FunctionUnit, TCustomTypeUnit, GlobalVariables, TDebugStructUnit;



{ Thread_Statistics }


procedure  Thread_Statistics.CriticalError;
begin
  // записываем в лог
  Log.Save(messclass+':'+mess,IS_ERROR);
end;

procedure Thread_Statistics.show;
//var
// val:Double;
begin
  if not CONNECT_BD_ERROR then begin

    // обновляем даынне
    p_SharedQueueStatistics.Update;

    // отображаем данные
    p_SharedQueueStatistics.Show;
  end;
end;


procedure Thread_Statistics.Execute;
 const
 SLEEP_TIME:Word = 5000;
 NAME_THREAD:string = 'Thread_Statistics';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

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

  with HomeForm do begin
   // линковка label при первом запуске
   SharedQueueStatistics.SetLinkLabel(queue_5000, lblStstatisc_Queue5000_Summa, lblStstatisc_Queue5000_Answered, lblStstatisc_Queue5000_No_Answered);
   SharedQueueStatistics.SetLinkLabel(queue_5050, lblStstatisc_Queue5050_Summa, lblStstatisc_Queue5050_Answered, lblStstatisc_Queue5050_No_Answered);

   // + линковка для статистики за день
   if SharedQueueStatistics.ExistStatDay then begin
    SharedQueueStatistics.SetLinkLabelStatDay(lblStstistisc_Day_Summa, lblStstistisc_Day_Answered, lblStstistisc_Day_No_Answered, lblStstistisc_Day_Procent);
   end;
  end;

  while not Terminated do
  begin
    if UpdateStatistiscSTOP then begin

      try
        StartTime:=GetTickCount;

        show(SharedQueueStatistics);

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
