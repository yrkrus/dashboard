program outgoing;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  GlobalVariablesLinkDLL in '..\gui\GlobalVariablesLinkDLL.pas',
  FunctionUnit in 'FunctionUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
