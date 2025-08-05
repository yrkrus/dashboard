program dashboard;

uses
  Vcl.Forms,
  FormHome in 'FormHome.pas' {HomeForm},
  FunctionUnit in 'FunctionUnit.pas',
  FormPropushennieUnit in 'FormPropushennieUnit.pas' {FormPropushennie},
  FormSettingsUnit in 'FormSettingsUnit.pas' {FormSettings},
  FormAboutUnit in 'FormAboutUnit.pas' {FormAbout},
  FormOperatorStatusUnit in 'FormOperatorStatusUnit.pas' {FormOperatorStatus},
  FormServerIKCheckUnit in 'FormServerIKCheckUnit.pas' {FormServerIKCheck},
  FormAuthUnit in 'FormAuthUnit.pas' {FormAuth},
  FormActiveSessionUnit in 'FormActiveSessionUnit.pas' {FormActiveSession},
  FormAddNewUsersUnit in 'FormAddNewUsersUnit.pas' {FormAddNewUsers},
  FormRePasswordUnit in 'FormRePasswordUnit.pas' {FormRePassword},
  FormErrorUnit in 'FormErrorUnit.pas' {FormError},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  ReportsUnit in 'ReportsUnit.pas' {FormReports},
  FormUsersUnit in 'FormUsersUnit.pas' {FormUsers},
  FormServersIKUnit in 'FormServersIKUnit.pas' {FormServersIK},
  FormServerIKEditUnit in 'FormServerIKEditUnit.pas' {FormServerIKEdit},
  FormDEBUGUnit in 'FormDEBUGUnit.pas' {FormDEBUG},
  FormSettingsGlobalUnit in 'FormSettingsGlobalUnit.pas' {FormSettingsGlobal},
  FormSettingsGlobal_addIVRUnit in 'FormSettingsGlobal_addIVRUnit.pas' {FormSettingsGlobal_addIVR},
  FormSettingsGlobal_listIVRUnit in 'FormSettingsGlobal_listIVRUnit.pas' {FormSettingsGlobal_listIVR},
  FormTrunkUnit in 'FormTrunkUnit.pas' {FormTrunk},
  FormTrunkEditUnit in 'FormTrunkEditUnit.pas' {FormTrunkEdit},
  FormGlobalSettingCheckFirebirdConnectUnit in 'FormGlobalSettingCheckFirebirdConnectUnit.pas' {FormGlobalSettingCheckFirebirdConnect},
  GlobalVariables in 'GlobalVariables.pas',
  FormStatisticsChartUnit in 'FormStatisticsChartUnit.pas' {FormStatisticsChart},
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
  FormStatusInfoUnit in 'FormStatusInfoUnit.pas' {FormStatusInfo},
  TSendSMSUint in '..\custom_class\TSendSMSUint.pas',
  FormHistoryCallOperatorUnit in 'FormHistoryCallOperatorUnit.pas' {FormHistoryCallOperator},
  TFontSizeUnit in '..\custom_class\TFontSizeUnit.pas',
  FormChatNewMessageUnit in 'FormChatNewMessageUnit.pas' {FormChatNewMessage},
  TDebugCountResponseUnit in '..\custom_class\debug_info\TDebugCountResponseUnit.pas',
  TDebugStructUnit in '..\custom_class\debug_info\TDebugStructUnit.pas',
  FormHistoryStatusOperatorUnit in 'FormHistoryStatusOperatorUnit.pas' {FormHistoryStatusOperator},
  THistoryStatusOperatorsUnit in '..\custom_class\THistoryStatusOperatorsUnit.pas',
  GlobalImageDestination in 'GlobalImageDestination.pas',
  FormServerIKWorkingTimeUnit in 'FormServerIKWorkingTimeUnit.pas' {FormServerIKWorkingTime},
  TWorkingTimeClinicUnit in '..\custom_class\TWorkingTimeClinicUnit.pas',
  FormMenuAccessUnit in 'FormMenuAccessUnit.pas' {FormMenuAccess},
  TUserAccessUnit in '..\custom_class\TUserAccessUnit.pas',
  GlobalVariablesLinkDLL in 'GlobalVariablesLinkDLL.pas',
  TQueueStatisticsUnit in '..\custom_class\TQueueStatisticsUnit.pas',
  TThreadDispatcherUnit in '..\custom_class\TThreadDispatcherUnit.pas',
  TAutoPodborPeopleUnit in '..\custom_class\TAutoPodborPeopleUnit.pas',
  FormPropushennieShowPeopleUnit in 'FormPropushennieShowPeopleUnit.pas' {FormPropushennieShowPeople},
  TStatusUnit in '..\custom_class\TStatusUnit.pas';

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
  Application.CreateForm(TFormDEBUG, FormDEBUG);
  Application.CreateForm(TFormError, FormError);
  Application.CreateForm(TFormPropushennie, FormPropushennie);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormOperatorStatus, FormOperatorStatus);
  Application.CreateForm(TFormServerIKCheck, FormServerIKCheck);
  Application.CreateForm(TFormAuth, FormAuth);
  Application.CreateForm(TFormActiveSession, FormActiveSession);
  Application.CreateForm(TFormAddNewUsers, FormAddNewUsers);
  Application.CreateForm(TFormRePassword, FormRePassword);
  Application.CreateForm(TFormWait, FormWait);
  Application.CreateForm(TFormReports, FormReports);
  Application.CreateForm(TFormUsers, FormUsers);
  Application.CreateForm(TFormServersIK, FormServersIK);
  Application.CreateForm(TFormServerIKEdit, FormServerIKEdit);
  Application.CreateForm(TFormSettingsGlobal, FormSettingsGlobal);
  Application.CreateForm(TFormSettingsGlobal_addIVR, FormSettingsGlobal_addIVR);
  Application.CreateForm(TFormSettingsGlobal_listIVR, FormSettingsGlobal_listIVR);
  Application.CreateForm(TFormTrunk, FormTrunk);
  Application.CreateForm(TFormTrunkEdit, FormTrunkEdit);
  Application.CreateForm(TFormGlobalSettingCheckFirebirdConnect, FormGlobalSettingCheckFirebirdConnect);
  Application.CreateForm(TFormStatisticsChart, FormStatisticsChart);
  Application.CreateForm(TFormStatusInfo, FormStatusInfo);
  Application.CreateForm(TFormHistoryCallOperator, FormHistoryCallOperator);
  Application.CreateForm(TFormChatNewMessage, FormChatNewMessage);
  Application.CreateForm(TFormHistoryStatusOperator, FormHistoryStatusOperator);
  Application.CreateForm(TFormServerIKWorkingTime, FormServerIKWorkingTime);
  Application.CreateForm(TFormMenuAccess, FormMenuAccess);
  Application.CreateForm(TFormPropushennieShowPeople, FormPropushennieShowPeople);
  Application.Run;
end.
