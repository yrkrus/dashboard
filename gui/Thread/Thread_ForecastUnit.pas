unit Thread_ForecastUnit;

interface

uses
    System.Classes,
    System.DateUtils,
    SysUtils,
    ActiveX,
    TLogFileUnit,
    TForecastCallsUnit,
    FormHome;

type
  Thread_Forecast = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show;
    procedure CriticalError;
  private
    Log:TLoggingFile;
    { Private declarations }
  end;

implementation

uses
  GlobalVariables;


procedure Thread_Forecast.CriticalError;
begin
  // записываем в лог
  Log.Save(messclass+'.'+mess,IS_ERROR);
end;


procedure Thread_Forecast.show;
var
forecast:TForecastCalls;
begin
  if not CONNECT_BD_ERROR then begin
   forecast:=TForecastCalls.Create(HomeForm.STForecastCount);
   forecast.ShowForecastCount(HomeForm.STForecastCount);
  end;
end;

procedure Thread_Forecast.Execute;
 const
 SLEEP_TIME:Word = 500;
// var
//  StartTime, EndTime: Cardinal;
//  Duration: Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(500);

  Log:=TLoggingFile.Create('Thread_Forecast');

  while not Terminated do
  begin

    if UpdateForecast then  begin
     try
       // StartTime:=GetTickCount;

        show;
        UpdateForecast:=False;

       // EndTime:= GetTickCount;
       // Duration:= EndTime - StartTime;
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

    // if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.