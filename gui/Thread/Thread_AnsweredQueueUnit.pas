unit Thread_AnsweredQueueUnit;

interface

uses
  System.Classes,SysUtils, ActiveX,TCustomTypeUnit, TAnsweredQueueUnit, TLogFileUnit;

type
  Thread_AnsweredQueue = class(TThread)
  private
    { Private declarations }
   messclass,mess: string;
   Log:TLoggingFile;

  protected
    procedure Execute; override;
    procedure show(var p_AnsweredQueue: TAnsweredQueue);
    procedure CriticalError;
  end;

implementation

uses
  FormHome, FunctionUnit, GlobalVariables, TDebugStructUnit;

{ Thread_AnsweredQueue }

procedure Thread_AnsweredQueue.CriticalError;
begin
   // записываем в лог
   Log.Save(messclass+'.'+mess,IS_ERROR);
end;

 procedure Thread_AnsweredQueue.show(var p_AnsweredQueue: TAnsweredQueue);
begin
  if not CONNECT_BD_ERROR then begin
    // проверяем вдруг надо обновить всю статистку
    // такое случается если изменить настроки корреткировки ожидания в очереди
   with p_AnsweredQueue do begin
      if StrToInt(GetStatistics_day(stat_summa))<>0 then begin
          if updateAnsweredNow then begin
             Clear;
          end;

          if isExistNewAnswered then begin
             updateAnswered;
             showAnswered;
          end;
      end
      else begin
         updateAnsweredNow:=True;
         Clear;
      end;
   end;
  end;
end;

procedure Thread_AnsweredQueue.Execute;
const
 SLEEP_TIME:Word = 3000;
 NAME_THREAD:string = 'Thread_AnsweredQueue';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  AnsweredQueue:TAnsweredQueue;

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

  // создание класса с данными по статистике принятых звонков из очереди
  AnsweredQueue:=TAnsweredQueue.Create;


  while not Terminated do
  begin

    if UpdateAnsweredStop then begin
      try
        StartTime:=GetTickCount;

        show(AnsweredQueue);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;

        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);

        // переход в новый день
        if getCountAnsweredCallAll = 0 then AnsweredQueue.Clear;

      except
        on E:Exception do
        begin
         //INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;

          Synchronize(CriticalError);
         //INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
