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
  TAnsweredQueueUnit in 'TAnsweredQueueUnit.pas',
  Thread_AnsweredQueueUnit in 'Thread_AnsweredQueueUnit.pas',
  ReportsUnit in 'ReportsUnit.pas' {FormReports},
  FormUsersUnit in 'FormUsersUnit.pas' {FormUsers},
  TTranslirtUnit in 'TTranslirtUnit.pas',
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
  TActiveSessionUnit in 'TActiveSessionUnit.pas',
  FormTrunkUnit in 'FormTrunkUnit.pas' {FormTrunk},
  TIVRUnit in 'TIVRUnit.pas',
  TQueueUnit in 'TQueueUnit.pas',
  TActiveSIPUnit in 'TActiveSIPUnit.pas',
  FormTrunkEditUnit in 'FormTrunkEditUnit.pas' {FormTrunkEdit},
  TCheckServersUnit in 'TCheckServersUnit.pas',
  FormGlobalSettingCheckFirebirdConnectUnit in 'FormGlobalSettingCheckFirebirdConnectUnit.pas' {FormGlobalSettingCheckFirebirdConnect},
  TUserUnit in 'TUserUnit.pas',
  TCustomTypeUnit in 'TCustomTypeUnit.pas',
  GlobalVariables in 'GlobalVariables.pas',
  TOnlineChat in 'TOnlineChat.pas',
  TXmlUnit in 'TXmlUnit.pas',
  Thread_ChatUnit in 'Thread_ChatUnit.pas',
  TLogFileUnit in 'TLogFileUnit.pas';

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
  Application.Run;
end.
