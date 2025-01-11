program report;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  FunctionUnit in 'FunctionUnit.pas',
  FormReportCountRingsOperatorsUnit in 'FormReportCountRingsOperatorsUnit.pas' {FormReportCountRingsOperators},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  TAbstractReportUnit in 'include\TAbstractReportUnit.pas',
  TReportCountOperatorsUnit in 'classes\TReportCountOperatorsUnit.pas',
  TQueueHistoryUnit in 'classes\TQueueHistoryUnit.pas',
  TCustomTypeUnit in '..\gui\TCustomTypeUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormReportCountRingsOperators, FormReportCountRingsOperators);
  Application.CreateForm(TFormWait, FormWait);
  Application.Run;
end.
