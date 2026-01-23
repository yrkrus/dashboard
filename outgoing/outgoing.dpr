program outgoing;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  FunctionUnit in 'FunctionUnit.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas',
  TCallbackCallUnit in '..\custom_class\TCallbackCallUnit.pas',
  TThreadDispatcherUnit in '..\custom_class\TThreadDispatcherUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.HintHidePause:=60000;
  Application.HintPause:=100;

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
