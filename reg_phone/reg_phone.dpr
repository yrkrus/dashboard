program reg_phone;

uses
  Vcl.Forms,
  FormHomeUnit in 'FormHomeUnit.pas' {FormHome},
  Vcl.Themes,
  Vcl.Styles,
  GlobalVariables in 'GlobalVariables.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas',
  FunctionUnit in 'FunctionUnit.pas',
  TCheckBoxUIUnit in '..\custom_class\TCheckBoxUIUnit.pas',
  GlobalImageDestination in '..\custom_global\GlobalImageDestination.pas',
  TPhoneListUnit in '..\custom_class\TPhoneListUnit.pas',
  TRegisterPhoneUnit in '..\custom_class\TRegisterPhoneUnit.pas',
  TSipPhoneListUnit in '..\custom_class\TSipPhoneListUnit.pas',
  TIndividualSettingUserUnit in '..\custom_class\TIndividualSettingUserUnit.pas',
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormWait, FormWait);
  Application.Run;
end.
