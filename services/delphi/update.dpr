program update;

uses
  Vcl.SvcMgr,
  dashboard_update in 'dashboard_update.pas' {Service1: TService},
  GlobalVariables in 'GlobalVariables.pas',
  TXmlUnit in '..\..\gui\TXmlUnit.pas',
  TLogFileUnit in '..\..\gui\TLogFileUnit.pas' {$R *.RES},
  TFTPUnit in '..\..\gui\TFTPUnit.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //

  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(Tupdate_dashboard, update_dashboard);
  Application.Run;

//  SvcMgr.Application.Initialize;
//  SvcMgr.Application.CreateForm(Tupdate_dashboard, update_dashboard);
//  SvcMgr.Application.Run;
//  // this isn't a service application, and we've creating the MainForm to debug
//  // But if application runned by Windows Service manager, don't create anything
//  if (not Service1.SrvcRunning) then begin
//    Forms.Application.Initialize;
//    Forms.Application.CreateForm(TMainForm, MainForm);
//    MainForm.Show;
//    MainForm.Update;
//    Service1.OnExecute(Service1);
//  end;


end.
