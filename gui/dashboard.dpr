program dashboard;

uses
  Vcl.Forms,
  FormHome in 'FormHome.pas' {HomeForm},
  DMUnit in 'DMUnit.pas' {DM: TDataModule},
  FunctionUnit in 'FunctionUnit.pas',
  FormPropushennieUnit in 'FormPropushennieUnit.pas' {FormPropushennie},
  FormSettingsUnit in 'FormSettingsUnit.pas' {FormSettings},
  Thread_StatisticsUnit in 'Thread_StatisticsUnit.pas',
  Thread_IVRUnit in 'Thread_IVRUnit.pas',
  Thread_QUEUEUnit in 'Thread_QUEUEUnit.pas',
  Thread_ACTIVESIPUnit in 'Thread_ACTIVESIPUnit.pas',
  FormAboutUnit in 'FormAboutUnit.pas' {FormAbout},
  FormOperatorStatusUnit in 'FormOperatorStatusUnit.pas' {FormOperatorStatus},
  FormServerIKCheckUnit in 'FormServerIKCheckUnit.pas' {FormServerIKCheck},
  Thread_CHECKSERVERSUnit in 'Thread_CHECKSERVERSUnit.pas',
  FormAuthUnit in 'FormAuthUnit.pas' {FormAuth},
  FormActiveSessionUnit in 'FormActiveSessionUnit.pas' {FormActiveSession},
  FormAddNewUsersUnit in 'FormAddNewUsersUnit.pas' {FormAddNewUsers},
  FormRePasswordUnit in 'FormRePasswordUnit.pas' {FormRePassword},
  FormErrorUnit in 'FormErrorUnit.pas' {FormError},
  FormWaitUnit in 'FormWaitUnit.pas' {FormWait},
  Thread_AnsweredQueueUnit in 'Thread_AnsweredQueueUnit.pas',
  ReportsUnit in 'ReportsUnit.pas' {FormReports},
  FormUsersUnit in 'FormUsersUnit.pas' {FormUsers},
  FormServersIKUnit in 'FormServersIKUnit.pas' {FormServersIK},
  FormServerIKEditUnit in 'FormServerIKEditUnit.pas' {FormServerIKEdit},
  Thread_ACTIVESIP_updatetalkUnit in 'Thread_ACTIVESIP_updatetalkUnit.pas',
  FormDEBUGUnit in 'FormDEBUGUnit.pas' {FormDEBUG},
  Thread_ACTIVESIP_updatePhoneTalkUnit in 'Thread_ACTIVESIP_updatePhoneTalkUnit.pas',
  Thread_ACTIVESIP_countTalkUnit in 'Thread_ACTIVESIP_countTalkUnit.pas',
  Thread_ACTIVESIP_QueueUnit in 'Thread_ACTIVESIP_QueueUnit.pas',
  FormSettingsGlobalUnit in 'FormSettingsGlobalUnit.pas' {FormSettingsGlobal},
  FormSettingsGlobal_addIVRUnit in 'FormSettingsGlobal_addIVRUnit.pas' {FormSettingsGlobal_addIVR},
  FormSettingsGlobal_listIVRUnit in 'FormSettingsGlobal_listIVRUnit.pas' {FormSettingsGlobal_listIVR},
  FormTrunkUnit in 'FormTrunkUnit.pas' {FormTrunk},
  FormTrunkEditUnit in 'FormTrunkEditUnit.pas' {FormTrunkEdit},
  FormGlobalSettingCheckFirebirdConnectUnit in 'FormGlobalSettingCheckFirebirdConnectUnit.pas' {FormGlobalSettingCheckFirebirdConnect},
  GlobalVariables in 'GlobalVariables.pas',
  Thread_ChatUnit in 'Thread_ChatUnit.pas',
  FormStatisticsChartUnit in 'FormStatisticsChartUnit.pas' {FormStatisticsChart},
  TActiveSessionUnit in '..\custom_class\TActiveSessionUnit.pas',
  TActiveSIPUnit in '..\custom_class\TActiveSIPUnit.pas',
  TAnsweredQueueUnit in '..\custom_class\TAnsweredQueueUnit.pas',
  TCheckServersUnit in '..\custom_class\TCheckServersUnit.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TFTPUnit in '..\custom_class\TFTPUnit.pas',
  TIVRUnit in '..\custom_class\TIVRUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  TOnlineChat in '..\custom_class\TOnlineChat.pas',
  TQueueUnit in '..\custom_class\TQueueUnit.pas',
  TTranslirtUnit in '..\custom_class\TTranslirtUnit.pas',
  TUserUnit in '..\custom_class\TUserUnit.pas',
  TXmlUnit in '..\custom_class\TXmlUnit.pas';

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
  Application.CreateForm(TDM, DM);
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
  Application.Run;
end.
