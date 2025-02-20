program sms;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  FunctionUnit in 'FunctionUnit.pas',
  GlobalVariables in 'GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TSendSMSUint in '..\custom_class\TSendSMSUint.pas',
  FormMyTemplateUnit in 'FormMyTemplateUnit.pas' {FormMyTemplate},
  TPacientsListUnit in '..\custom_class\TPacientsListUnit.pas',
  FormNotSendingSMSErrorUnit in 'FormNotSendingSMSErrorUnit.pas' {FormNotSendingSMSError},
  FormEditTemplateUnit in 'FormEditTemplateUnit.pas' {FormEditTemplate},
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  TAddressClinicPopMenuUnit in '..\custom_class\TAddressClinicPopMenuUnit.pas',
  TThreadSendSMSUnit in '..\custom_class\TThreadSendSMSUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause:=60000;
  Application.HintPause:=100;

  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormMyTemplate, FormMyTemplate);
  Application.CreateForm(TFormNotSendingSMSError, FormNotSendingSMSError);
  Application.CreateForm(TFormEditTemplate, FormEditTemplate);
  Application.Run;
end.
