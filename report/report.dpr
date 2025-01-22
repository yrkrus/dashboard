program report;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  FunctionUnit in 'FunctionUnit.pas',
  FormReportCountRingsOperatorsUnit in 'FormReportCountRingsOperatorsUnit.pas' {FormReportCountRingsOperators},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  TAbstractReportUnit in '..\custom_class\TAbstractReportUnit.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TQueueHistoryUnit in '..\custom_class\TQueueHistoryUnit.pas',
  TReportCountOperatorsUnit in '..\custom_class\TReportCountOperatorsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormReportCountRingsOperators, FormReportCountRingsOperators);
  Application.CreateForm(TFormWait, FormWait);
  Application.Run;
end.
