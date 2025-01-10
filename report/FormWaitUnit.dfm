object FormWait: TFormWait
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #1057#1090#1072#1090#1091#1089': null'
  ClientHeight = 29
  ClientWidth = 515
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object ProgressBar: TGauge
    Left = 0
    Top = 0
    Width = 515
    Height = 29
    Align = alClient
    ForeColor = clGradientInactiveCaption
    Progress = 50
    ShowText = False
    ExplicitWidth = 795
    ExplicitHeight = 33
  end
  object ProgressStatusText: TStaticText
    Left = 6
    Top = 7
    Width = 51
    Height = 17
    Caption = #1057#1090#1072#1090#1091#1089': '
    Color = clGradientInactiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object STEsc: TStaticText
    Left = 441
    Top = 7
    Width = 70
    Height = 17
    Cursor = crHandPoint
    Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
    Caption = #1086#1090#1084#1077#1085#1072' (ESC)'
    Color = clGradientInactiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = STEscClick
  end
end
