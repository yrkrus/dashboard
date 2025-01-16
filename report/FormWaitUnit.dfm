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
    ExplicitLeft = -1
  end
  object ProgressStatusText: TStaticText
    Left = 33
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
    TabOrder = 1
  end
  object STEsc: TStaticText
    Left = 430
    Top = 7
    Width = 80
    Height = 17
    Cursor = crHandPoint
    Caption = #1086#1090#1084#1077#1085#1072' (ESC)'
    Color = clGradientInactiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnClick = STEscClick
  end
  object ActivityIndicator: TActivityIndicator
    Left = 4
    Top = 2
    Animate = True
    IndicatorSize = aisSmall
    IndicatorType = aitRotatingSector
  end
end
