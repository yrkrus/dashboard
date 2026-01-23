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
  TThreadSendSMSUnit in '..\custom_class\TThreadSendSMSUnit.pas',
  FormListSendingSMSUnit in 'FormListSendingSMSUnit.pas' {FormListSendingSMS},
  TXmlUnit in '..\custom_class\TXmlUnit.pas',
  TSpellingUnit in '..\custom_class\TSpellingUnit.pas',
  FormSendingSMSUnit in 'FormSendingSMSUnit.pas' {FormSendingSMS},
  FormDictionaryUnit in 'FormDictionaryUnit.pas' {FormDictionary},
  FormGenerateSMSUnit in 'FormGenerateSMSUnit.pas' {FormGenerateSMS},
  TShowMessageSMSUnit in '..\custom_class\TShowMessageSMSUnit.pas',
  TCheckServersUnit in '..\custom_class\TCheckServersUnit.pas',
  TMessageGeneratorSMSUnit in '..\custom_class\TMessageGeneratorSMSUnit.pas',
  FormServiceChoiseUnit in 'FormServiceChoiseUnit.pas' {FormServiceChoise},
  TServiceUnit in '..\custom_class\TServiceUnit.pas',
  FormServiceChoiseListUnit in 'FormServiceChoiseListUnit.pas' {FormServiceChoiseList},
  TWorkingTimeClinicUnit in '..\custom_class\TWorkingTimeClinicUnit.pas',
  DMUnit in 'DMUnit.pas' {DM: TDataModule},
  FormEditDictionaryUnit in 'FormEditDictionaryUnit.pas' {FormEditDictionary},
  TAutoPodborPeopleUnit in '..\custom_class\TAutoPodborPeopleUnit.pas',
  FormPodborUnit in 'FormPodborUnit.pas' {FormPodbor},
  FormManualPodborUnit in 'FormManualPodborUnit.pas' {FormManualPodbor},
  TSMSCallTalkInfoUnit in '..\custom_class\TSMSCallTalkInfoUnit.pas',
  FormManualPodborStatusUnit in 'FormManualPodborStatusUnit.pas' {FormManualPodborStatus},
  FormStatusSendingSMSUnit in 'FormStatusSendingSMSUnit.pas' {FormStatusSendingSMS},
  TAutoPodborSendingSmsUnit in '..\custom_class\TAutoPodborSendingSmsUnit.pas',
  GlobalImageDestination in '..\custom_global\GlobalImageDestination.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas',
  FormServerIKCheckUnit in '..\gui\Forms\FooterSubMenu\FormServerIKCheckUnit.pas' {FormServerIKCheck},
  FormWaitUnit in '..\gui\FormSystem\FormWaitUnit.pas' {FormWait},
  TCheckBoxUIUnit in '..\custom_class\TCheckBoxUIUnit.pas',
  TUserCommonQueueUnit in '..\custom_class\TUserCommonQueueUnit.pas',
  TThreadDispatcherUnit in '..\custom_class\TThreadDispatcherUnit.pas',
  FormPropushennieShowPeopleUnit in '..\gui\Forms\MisseedCall\FormPropushennieShowPeopleUnit.pas' {FormPropushennieShowPeople};

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
  Application.CreateForm(TFormListSendingSMS, FormListSendingSMS);
  Application.CreateForm(TFormSendingSMS, FormSendingSMS);
  Application.CreateForm(TFormDictionary, FormDictionary);
  Application.CreateForm(TFormGenerateSMS, FormGenerateSMS);
  Application.CreateForm(TFormServiceChoise, FormServiceChoise);
  Application.CreateForm(TFormServiceChoiseList, FormServiceChoiseList);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormEditDictionary, FormEditDictionary);
  Application.CreateForm(TFormPodbor, FormPodbor);
  Application.CreateForm(TFormManualPodbor, FormManualPodbor);
  Application.CreateForm(TFormManualPodborStatus, FormManualPodborStatus);
  Application.CreateForm(TFormStatusSendingSMS, FormStatusSendingSMS);
  Application.CreateForm(TFormServerIKCheck, FormServerIKCheck);
  Application.CreateForm(TFormWait, FormWait);
  Application.CreateForm(TFormPropushennieShowPeople, FormPropushennieShowPeople);
  Application.Run;
end.
