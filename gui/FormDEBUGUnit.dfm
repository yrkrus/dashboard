object FormDEBUG: TFormDEBUG
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DEBUG '#1048#1085#1092#1086
  ClientHeight = 327
  ClientWidth = 591
  Color = clWindow
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 48
    Height = 16
    Caption = #1055#1086#1090#1086#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 250
    Top = 16
    Width = 100
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1058#1077#1082#1091#1097#1077#1077' (ms)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 356
    Top = 16
    Width = 100
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1088#1077#1076#1085#1077#1077' (ms)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label34: TLabel
    Left = 462
    Top = 16
    Width = 100
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1052#1072#1082#1089' (ms)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object panel: TPanel
    Left = 16
    Top = 38
    Width = 561
    Height = 275
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 0
      Top = 6
      Width = 100
      Height = 16
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1090#1086#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblThread_ACTIVESIP: TLabel
      Left = 234
      Top = 6
      Width = 100
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'ms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 340
      Top = 6
      Width = 100
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'ms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label24: TLabel
      Left = 446
      Top = 6
      Width = 100
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'ms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
end
