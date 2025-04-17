object update_dashboard: Tupdate_dashboard
  OldCreateOrder = False
  DisplayName = #1089#1083#1091#1078#1073#1072' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103' '#1044#1072#1096#1073#1086#1088#1076' '#1050#1086#1083#1083#1062#1077#1085#1090#1088#1072
  ErrorSeverity = esCritical
  StartType = stSystem
  AfterInstall = ServiceAfterInstall
  AfterUninstall = ServiceAfterUninstall
  OnContinue = ServiceContinue
  OnExecute = ServiceExecute
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 121
  Width = 175
  object TimerMonitoring: TTimer
    Enabled = False
    OnTimer = TimerMonitoringTimer
    Left = 48
    Top = 8
  end
end
