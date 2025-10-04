program dashboard;

uses
  Vcl.Forms,
  FormHome in 'FormHome.pas' {HomeForm},
  FunctionUnit in 'FunctionUnit.pas',
  GlobalVariables in 'GlobalVariables.pas',
  TActiveSessionUnit in '..\custom_class\TActiveSessionUnit.pas',
  TActiveSIPUnit in '..\custom_class\TActiveSIPUnit.pas',
  TAnsweredQueueUnit in '..\custom_class\TAnsweredQueueUnit.pas',
  TCheckServersUnit in '..\custom_class\TCheckServersUnit.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TFTPUnit in '..\custom_class\TFTPUnit.pas',
  TIVRUnit in '..\custom_class\TIVRUnit.pas',
  TForecastCallsUnit in '..\custom_class\TForecastCallsUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  TOnlineChat in '..\custom_class\TOnlineChat.pas',
  TQueueUnit in '..\custom_class\TQueueUnit.pas',
  TTranslirtUnit in '..\custom_class\TTranslirtUnit.pas',
  TUserUnit in '..\custom_class\TUserUnit.pas',
  TXmlUnit in '..\custom_class\TXmlUnit.pas',
  Thread_ACTIVESIP_countTalkUnit in 'Thread\Thread_ACTIVESIP_countTalkUnit.pas',
  Thread_ACTIVESIP_QueueUnit in 'Thread\Thread_ACTIVESIP_QueueUnit.pas',
  Thread_ACTIVESIP_updatePhoneTalkUnit in 'Thread\Thread_ACTIVESIP_updatePhoneTalkUnit.pas',
  Thread_ACTIVESIP_updatetalkUnit in 'Thread\Thread_ACTIVESIP_updatetalkUnit.pas',
  Thread_ACTIVESIPUnit in 'Thread\Thread_ACTIVESIPUnit.pas',
  Thread_AnsweredQueueUnit in 'Thread\Thread_AnsweredQueueUnit.pas',
  Thread_ChatUnit in 'Thread\Thread_ChatUnit.pas',
  Thread_CHECKSERVERSUnit in 'Thread\Thread_CHECKSERVERSUnit.pas',
  Thread_IVRUnit in 'Thread\Thread_IVRUnit.pas',
  Thread_QUEUEUnit in 'Thread\Thread_QUEUEUnit.pas',
  Thread_StatisticsUnit in 'Thread\Thread_StatisticsUnit.pas',
  Thread_ForecastUnit in 'Thread\Thread_ForecastUnit.pas',
  TInternalProcessUnit in '..\custom_class\TInternalProcessUnit.pas',
  Thread_InternalProcessUnit in 'Thread\Thread_InternalProcessUnit.pas',
  TSendSMSUint in '..\custom_class\TSendSMSUint.pas',
  TFontSizeUnit in '..\custom_class\TFontSizeUnit.pas',
  TDebugCountResponseUnit in '..\custom_class\debug_info\TDebugCountResponseUnit.pas',
  TDebugStructUnit in '..\custom_class\debug_info\TDebugStructUnit.pas',
  THistoryStatusOperatorsUnit in '..\custom_class\THistoryStatusOperatorsUnit.pas',
  TWorkingTimeClinicUnit in '..\custom_class\TWorkingTimeClinicUnit.pas',
  TUserAccessUnit in '..\custom_class\TUserAccessUnit.pas',
  TQueueStatisticsUnit in '..\custom_class\TQueueStatisticsUnit.pas',
  TThreadDispatcherUnit in '..\custom_class\TThreadDispatcherUnit.pas',
  TAutoPodborPeopleUnit in '..\custom_class\TAutoPodborPeopleUnit.pas',
  TStatusUnit in '..\custom_class\TStatusUnit.pas',
  TCheckSipTrunkUnit in '..\custom_class\TCheckSipTrunkUnit.pas',
  Thread_CheckTrunkUnit in 'Thread\Thread_CheckTrunkUnit.pas',
  TWorkTimeCallCenterUnit in '..\custom_class\TWorkTimeCallCenterUnit.pas',
  FormGlobalSettingCheckFirebirdConnectUnit in 'Forms\Settings\FormGlobalSettingCheckFirebirdConnectUnit.pas' {FormGlobalSettingCheckFirebirdConnect},
  FormSettingsGlobal_addIVRUnit in 'Forms\Settings\FormSettingsGlobal_addIVRUnit.pas' {FormSettingsGlobal_addIVR},
  FormSettingsGlobal_listIVRUnit in 'Forms\Settings\FormSettingsGlobal_listIVRUnit.pas' {FormSettingsGlobal_listIVR},
  FormSettingsGlobalUnit in 'Forms\Settings\FormSettingsGlobalUnit.pas' {FormSettingsGlobal},
  FormUsersUnit in 'Forms\Users\FormUsersUnit.pas' {FormUsers},
  FormAddNewUsersUnit in 'Forms\Users\FormAddNewUsersUnit.pas' {FormAddNewUsers},
  FormHistoryCallOperatorUnit in 'Forms\PopMenu\FormHistoryCallOperatorUnit.pas' {FormHistoryCallOperator},
  FormHistoryStatusOperatorUnit in 'Forms\PopMenu\FormHistoryStatusOperatorUnit.pas' {FormHistoryStatusOperator},
  FormServerIKWorkingTimeUnit in 'Forms\Settings\FormServerIKWorkingTimeUnit.pas' {FormServerIKWorkingTime},
  FormWorkTimeCallCenterUnit in 'Forms\Settings\FormWorkTimeCallCenterUnit.pas' {FormWorkTimeCallCenter},
  FormServerIKEditUnit in 'Forms\ServerIK\FormServerIKEditUnit.pas' {FormServerIKEdit},
  FormServersIKUnit in 'Forms\ServerIK\FormServersIKUnit.pas' {FormServersIK},
  FormMenuAccessUnit in 'Forms\Settings\FormMenuAccessUnit.pas' {FormMenuAccess},
  FormTrunkUnit in 'Forms\Trunk\FormTrunkUnit.pas' {FormTrunk},
  FormTrunkEditUnit in 'Forms\Trunk\FormTrunkEditUnit.pas' {FormTrunkEdit},
  FormPropushennieShowPeopleUnit in 'Forms\MisseedCall\FormPropushennieShowPeopleUnit.pas' {FormPropushennieShowPeople},
  FormPropushennieUnit in 'Forms\MisseedCall\FormPropushennieUnit.pas' {FormPropushennie},
  FormActiveSessionUnit in 'Forms\ActiveSession\FormActiveSessionUnit.pas' {FormActiveSession},
  FormAboutUnit in 'FormSystem\FormAboutUnit.pas' {FormAbout},
  FormAuthUnit in 'FormSystem\FormAuthUnit.pas' {FormAuth},
  FormErrorUnit in 'FormSystem\FormErrorUnit.pas' {FormError},
  FormDEBUGUnit in 'FormSystem\FormDEBUGUnit.pas' {FormDEBUG},
  FormWaitUnit in 'FormSystem\FormWaitUnit.pas' {FormWait},
  FormStatusInfoUnit in 'FormSystem\FormStatusInfoUnit.pas' {FormStatusInfo},
  FormServerIKCheckUnit in 'Forms\FooterSubMenu\FormServerIKCheckUnit.pas' {FormServerIKCheck},
  FormTrunkSipUnit in 'Forms\FooterSubMenu\FormTrunkSipUnit.pas' {FormTrunkSip},
  GlobalImageDestination in '..\custom_global\GlobalImageDestination.pas',
  GlobalVariablesLinkDLL in '..\custom_global\GlobalVariablesLinkDLL.pas',
  FormRePasswordUnit in 'FormSystem\FormRePasswordUnit.pas' {FormRePassword},
  TLdapUnit in '..\custom_class\TLdapUnit.pas',
  FormSettingsGlobal_checkLdapUnit in 'Forms\Settings\FormSettingsGlobal_checkLdapUnit.pas' {FormSettingsGlobal_checkLdap},
  FormSipPhoneListUnit in 'Forms\Settings\FormSipPhoneListUnit.pas' {FormSipPhoneList},
  TSipPhoneListUnit in '..\custom_class\TSipPhoneListUnit.pas',
  FormSipPhoneListAddUnit in 'Forms\Settings\FormSipPhoneListAddUnit.pas' {FormSipPhoneListAdd},
  FormPhoneListUnit in 'Forms\Settings\FormPhoneListUnit.pas' {FormPhoneList},
  TPhoneListUnit in '..\custom_class\TPhoneListUnit.pas',
  FormPhoneListAddUnit in 'Forms\Settings\FormPhoneListAddUnit.pas' {FormPhoneListAdd},
  TIVRTimeUnit in '..\custom_class\TIVRTimeUnit.pas',
  TCheckBoxUIUnit in '..\custom_class\TCheckBoxUIUnit.pas',
  TUsersAllUnit in '..\custom_class\TUsersAllUnit.pas';

{$R *.res}

begin
  // DebugHook:= 1; // Включает отладочные хуки
 // ReportMemoryLeaksOnShutdown:= true;
  //ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause:=60000;
  Application.HintPause:=100;

  Application.CreateForm(THomeForm, HomeForm);
  Application.CreateForm(TFormUsers, FormUsers);
  Application.CreateForm(TFormSettingsGlobal, FormSettingsGlobal);
  Application.CreateForm(TFormSettingsGlobal_addIVR, FormSettingsGlobal_addIVR);
  Application.CreateForm(TFormSettingsGlobal_listIVR, FormSettingsGlobal_listIVR);
  Application.CreateForm(TFormGlobalSettingCheckFirebirdConnect, FormGlobalSettingCheckFirebirdConnect);
  Application.CreateForm(TFormAddNewUsers, FormAddNewUsers);
  Application.CreateForm(TFormHistoryCallOperator, FormHistoryCallOperator);
  Application.CreateForm(TFormHistoryStatusOperator, FormHistoryStatusOperator);
  Application.CreateForm(TFormServerIKWorkingTime, FormServerIKWorkingTime);
  Application.CreateForm(TFormWorkTimeCallCenter, FormWorkTimeCallCenter);
  Application.CreateForm(TFormServerIKEdit, FormServerIKEdit);
  Application.CreateForm(TFormServersIK, FormServersIK);
  Application.CreateForm(TFormMenuAccess, FormMenuAccess);
  Application.CreateForm(TFormTrunk, FormTrunk);
  Application.CreateForm(TFormTrunk, FormTrunk);
  Application.CreateForm(TFormTrunkEdit, FormTrunkEdit);
  Application.CreateForm(TFormPropushennieShowPeople, FormPropushennieShowPeople);
  Application.CreateForm(TFormPropushennie, FormPropushennie);
  Application.CreateForm(TFormActiveSession, FormActiveSession);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormAuth, FormAuth);
  Application.CreateForm(TFormError, FormError);
  Application.CreateForm(TFormDEBUG, FormDEBUG);
  Application.CreateForm(TFormWait, FormWait);
  Application.CreateForm(TFormStatusInfo, FormStatusInfo);
  Application.CreateForm(TFormServerIKCheck, FormServerIKCheck);
  Application.CreateForm(TFormTrunkSip, FormTrunkSip);
  Application.CreateForm(TFormRePassword, FormRePassword);
  Application.CreateForm(TFormSettingsGlobal_checkLdap, FormSettingsGlobal_checkLdap);
  Application.CreateForm(TFormSipPhoneList, FormSipPhoneList);
  Application.CreateForm(TFormSipPhoneListAdd, FormSipPhoneListAdd);
  Application.CreateForm(TFormPhoneList, FormPhoneList);
  Application.CreateForm(TFormPhoneListAdd, FormPhoneListAdd);
  Application.Run;
end.
end.
