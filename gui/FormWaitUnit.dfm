object FormWait: TFormWait
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormWait'
  ClientHeight = 55
  ClientWidth = 491
  Color = clWindow
  TransparentColorValue = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 56
    Top = 18
    Width = 431
    Height = 16
    Align = alCustom
    Alignment = taCenter
    AutoSize = False
    Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1079#1072#1087#1088#1086#1089#1072' '#1085#1072' '#1089#1077#1088#1074#1077#1088'... '#1101#1090#1086' '#1085#1077' '#1079#1072#1081#1084#1077#1090' '#1084#1085#1086#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object indicator: TActivityIndicator
    Left = 17
    Top = 9
    FrameDelay = 20
    IndicatorType = aitSectorRing
  end
end
