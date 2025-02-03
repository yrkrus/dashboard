program sms_send;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  FunctionUnit in 'FunctionUnit.pas',
  FormMsgPerenosUnit in 'FormMsgPerenosUnit.pas' {FormMsgPerenos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormMsgPerenos, FormMsgPerenos);
  Application.Run;
end.
