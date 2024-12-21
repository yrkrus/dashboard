unit dashboard_update;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr,
  Vcl.Dialogs,Registry, Vcl.ExtCtrls;

type
  Tupdate_dashboard = class(TService)
    TimerMonitoring: TTimer;
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure TimerMonitoringTimer(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  update_dashboard: Tupdate_dashboard;

implementation

uses
  GlobalVariables, TXmlUnit, TLogFileUnit;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  update_dashboard.Controller(CtrlCode);
end;

function Tupdate_dashboard.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure Tupdate_dashboard.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
  ServiceName,path,path2 : string;
begin
  ServiceName:=SERVICE_NAME;
  path:='\SYSTEM\CurrentControlSet\services\Eventlog\Application\';
  path2:='\SYSTEM\CurrentControlSet\services\';

  reg:=TRegistry.Create(KEY_ALL_ACCESS);
 with reg do begin
  try
    RootKey:=HKEY_LOCAL_MACHINE;
    OpenKey(path+ServiceName, True);
    WriteString('EventMessageFile',ParamStr(0));
    WriteInteger('TypesSupported',7);

    // записываем описание
    OpenKey(path2+ServiceName,False);
    WriteString('Description',SERVICE_DESCRIPTION);
   finally
    FreeAndNil(reg);
  end;
 end;
end;

procedure Tupdate_dashboard.ServiceAfterUninstall(Sender: TService);
var
  reg: TRegistry;
  ServiceName,path,path2 : string;
begin
  ServiceName:=SERVICE_NAME;
  path:='\SYSTEM\CurrentControlSet\services\Eventlog\Application\';
  path2:='\SYSTEM\CurrentControlSet\services\';

  reg:=TRegistry.Create(KEY_ALL_ACCESS);
  try
   reg.RootKey:=HKEY_LOCAL_MACHINE;
   reg.OpenKey(path+ServiceName,False);
   reg.DeleteValue('TypesSupported');
   reg.DeleteValue('EventMessageFile');
   reg.DeleteKey(path+ServiceName);
   finally
    FreeAndNil(reg);
  end;
end;

procedure Tupdate_dashboard.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  Continued:=True;
end;

procedure Tupdate_dashboard.ServiceExecute(Sender: TService);
begin
 while not terminated do
 begin
   Sleep(1000);
   ServiceThread.ProcessRequests(False);
 end;
end;

procedure Tupdate_dashboard.ServicePause(Sender: TService; var Paused: Boolean);
begin
    Paused:=True;
end;

procedure Tupdate_dashboard.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  TimerMonitoring.Enabled:=True;
end;

procedure Tupdate_dashboard.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
 TimerMonitoring.Enabled:=False;
 Stopped:=True;
end;

procedure Tupdate_dashboard.TimerMonitoringTimer(Sender: TObject);
var
 XML:TXML;

 Log:TLoggingFile;

 test:TStringList;
begin
test:=TStringList.Create;

  test.Add('1');
  test.SaveToFile('C:\Users\home0\Desktop\DASHBOARD\develop\services\delphi\Win64\Debug\test.log');

  Log:=TLoggingFile.Create(PChar('update'));


  test.Add('2');
  test.SaveToFile('C:\Users\home0\Desktop\DASHBOARD\develop\services\delphi\Win64\Debug\test.log');

 //Log.Save('Запуск процесса проверки обновления');

 // тут че то делаем
 // XML:=TXML.Create;
 // XML.UpdateRemoteVersion('999999');
 // XML.Free;

//Log.Free;
end;

end.
