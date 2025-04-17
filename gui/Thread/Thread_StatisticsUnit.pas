unit Thread_StatisticsUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TLogFileUnit;

type
  Thread_Statistics = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show;
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
  Log.Save(messclass+'.'+mess,IS_ERROR);
end;

procedure Thread_Statistics.show;
//var
// val:Double;
begin
  if not CONNECT_BD_ERROR then begin
    with HomeForm do begin
      if StrToInt(GetStatistics_day(stat_summa))<>0 then begin

          lblStstatisc_Queue5000_Summa.Caption:=GetStatistics_queue(queue_5000,all_answered);
          lblStstatisc_Queue5050_Summa.Caption:=GetStatistics_queue(queue_5050,all_answered);

          lblStstatisc_Queue5000_Answered.Caption:=GetStatistics_queue(queue_5000,answered);
          lblStstatisc_Queue5000_No_Answered.Caption:=GetStatistics_queue(queue_5000,no_answered) + ' ('+GetStatistics_queue(queue_5000,no_answered_return)+')';

          lblStstatisc_Queue5050_Answered.Caption:=GetStatistics_queue(queue_5050,answered);
          lblStstatisc_Queue5050_No_Answered.Caption:=GetStatistics_queue(queue_5050,no_answered) + ' ('+GetStatistics_queue(queue_5050,no_answered_return)+')';


          lblStstistisc_Day_Summa.Caption:=GetStatistics_day(stat_summa);
          lblStstistisc_Day_Answered.Caption:=GetStatistics_day(stat_answered);
          lblStstistisc_Day_No_Answered.Caption:=GetStatistics_day(stat_no_answered) + ' ('+GetStatistics_day(stat_no_answered_return)+')';
          lblStstistisc_Day_Procent.Caption:=GetStatistics_day(stat_procent_no_answered) + '% ('+GetStatistics_day(stat_procent_no_answered_return)+'%)';

      end else begin
        lblStstatisc_Queue5000_Summa.Caption:='0';
        lblStstatisc_Queue5050_Summa.Caption:='0';

        lblStstatisc_Queue5000_Answered.Caption:='0';
        lblStstatisc_Queue5000_No_Answered.Caption:='0';

        lblStstatisc_Queue5050_Answered.Caption:='0';
        lblStstatisc_Queue5050_No_Answered.Caption:='0';


        lblStstistisc_Day_Summa.Caption:='0';
        lblStstistisc_Day_Answered.Caption:='0';
        lblStstistisc_Day_No_Answered.Caption:='0';
        lblStstistisc_Day_Procent.Caption:='0%';
      end;
    end;
  end;
end;


procedure Thread_Statistics.Execute;
 const
 SLEEP_TIME:Word = 2000;
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

  while not Terminated do
  begin

    if UpdateStatistiscSTOP then begin

      try
        StartTime:=GetTickCount;

        show;

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
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
