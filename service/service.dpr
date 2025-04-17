program service;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
