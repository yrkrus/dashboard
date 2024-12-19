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
  FormHome, FunctionUnit, FormDEBUGUnit, GlobalVariables;

{ Thread_AnsweredQueue }

procedure Thread_AnsweredQueue.CriticalError;
begin
   HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_AnsweredQueue.'+messclass+'.'+mess;
end;

 procedure Thread_AnsweredQueue.show(var p_AnsweredQueue: TAnsweredQueue);
begin
  if (CONNECT_BD_ERROR=False) then begin
    // проверяем вдруг надо обновить всю статистку
    // такое случается если изменить настроки корреткировки ожидания в очереди
   with p_AnsweredQueue do begin
      if StrToInt(GetStatistics_day(stat_summa))<>0 then begin
          if updateAnsweredNow then begin
             clear;
          end;

          if isExistNewAnswered then begin
             updateAnswered;
             showAnswered;
          end;
      end
      else begin
         updateAnsweredNow:=True;
         clear;
      end;
   end;
  end;
end;

procedure Thread_AnsweredQueue.Execute;
const
 SLEEP_TIME:Word = 3000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  AnsweredQueue:TAnsweredQueue;
begin
   inherited;
   CoInitialize(Nil);

   Log:=TLoggingFile.Create('Thread_AnsweredQueue');

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
        FormDEBUG.lblThread_AnsweredQueue.Caption:=IntToStr(Duration);

        // переход в новый день
        if getCountAnsweredCallAll = 0 then AnsweredQueue.Clear;

      except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         TimeLastError:=Now;

         // записываем в лог
         Log.Save(messclass+'.'+mess,IS_ERROR);

         if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
