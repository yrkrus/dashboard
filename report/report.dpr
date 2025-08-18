program report;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  FunctionUnit in 'FunctionUnit.pas',
  FormReportCountRingsOperatorsUnit in 'FormReportCountRingsOperatorsUnit.pas' {FormReportCountRingsOperators},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  GlobalVariablesLinkDLL in '..\gui\GlobalVariablesLinkDLL.pas',
  TWorkTimeCallCenterUnit in '..\custom_class\TWorkTimeCallCenterUnit.pas',
  FormReportShowRingsAfterWorkTimeUnit in 'FormReportShowRingsAfterWorkTimeUnit.pas' {FormReportShowRingsAfterWorkTime},
  TAbstractReportUnit in '..\custom_class\from_report\TAbstractReportUnit.pas',
  TCountRingsOperatorsUnit in '..\custom_class\from_report\TCountRingsOperatorsUnit.pas',
  TReportCountOperatorsUnit in '..\custom_class\from_report\TReportCountOperatorsUnit.pas',
  TReportShowRingsAfterWorkTimeUnit in '..\custom_class\from_report\TReportShowRingsAfterWorkTimeUnit.pas',
  TQueueHistoryUnit in '..\custom_class\from_report\TQueueHistoryUnit.pas',
  TIVRHistoryUnit in '..\custom_class\from_report\TIVRHistoryUnit.pas',
  FormReportShowStatusOperatorsUnit in 'FormReportShowStatusOperatorsUnit.pas' {FormReportShowStatusOperators};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause:=60000;
  Application.HintPause:=100;

  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormReportCountRingsOperators, FormReportCountRingsOperators);
  Application.CreateForm(TFormWait, FormWait);
  Application.CreateForm(TFormReportShowRingsAfterWorkTime, FormReportShowRingsAfterWorkTime);
  Application.CreateForm(TFormReportShowStatusOperators, FormReportShowStatusOperators);
  Application.Run;
end.
