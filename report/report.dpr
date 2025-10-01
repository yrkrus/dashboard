program report;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  FunctionUnit in 'FunctionUnit.pas',
  FormReportCountRingsOperatorsUnit in 'FormReportCountRingsOperatorsUnit.pas' {FormReportCountRingsOperators},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TWorkTimeCallCenterUnit in '..\custom_class\TWorkTimeCallCenterUnit.pas',
  FormReportShowRingsAfterWorkTimeUnit in 'FormReportShowRingsAfterWorkTimeUnit.pas' {FormReportShowRingsAfterWorkTime},
  TAbstractReportUnit in '..\custom_class\from_report\TAbstractReportUnit.pas',
  TCountRingsOperatorsUnit in '..\custom_class\from_report\TCountRingsOperatorsUnit.pas',
  TReportCountOperatorsUnit in '..\custom_class\from_report\TReportCountOperatorsUnit.pas',
  TReportShowRingsAfterWorkTimeUnit in '..\custom_class\from_report\TReportShowRingsAfterWorkTimeUnit.pas',
  TQueueHistoryUnit in '..\custom_class\from_report\TQueueHistoryUnit.pas',
  TIVRHistoryUnit in '..\custom_class\from_report\TIVRHistoryUnit.pas',
  FormReportShowStatusOperatorsUnit in 'FormReportShowStatusOperatorsUnit.pas' {FormReportShowStatusOperators},
  TAutoPodborPeopleUnit in '..\custom_class\TAutoPodborPeopleUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  TDisableOperatorUnit in '..\custom_class\from_report\TDisableOperatorUnit.pas',
  GlobalImageDestination in '..\custom_global\GlobalImageDestination.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas';

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
