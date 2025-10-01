program reg_phone;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  Vcl.Themes,
  Vcl.Styles,
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
