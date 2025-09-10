program service;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  FunctionUnit in 'FunctionUnit.pas',
  TXmlUnit in '..\custom_class\TXmlUnit.pas',
  TServiceUnit in '..\custom_class\TServiceUnit.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas',
  FormWaitUnit in '..\gui\FormSystem\FormWaitUnit.pas' {FormWait};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormWait, FormWait);
  Application.Run;
end.
