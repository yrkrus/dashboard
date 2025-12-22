object FormDEBUG: TFormDEBUG
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DEBUG '#1048#1085#1092#1086
  ClientHeight = 366
  ClientWidth = 686
  Color = clWindow
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 19
    Top = 54
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
    Left = 256
    Top = 54
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
    Left = 362
    Top = 54
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
    Left = 465
    Top = 54
    Width = 210
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
    Left = 11
    Top = 74
    Width = 664
    Height = 282
    BevelInner = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 6
      Width = 214
      Height = 16
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1090#1086#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThread_ACTIVESIP: TLabel
      Left = 243
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
      Visible = False
    end
    object Label13: TLabel
      Left = 349
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
      Visible = False
    end
    object Label24: TLabel
      Left = 452
      Top = 6
      Width = 210
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
      Visible = False
    end
    object Label3: TLabel
      Left = 8
      Top = 26
      Width = 214
      Height = 16
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1090#1086#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
  end
  object panel_program: TPanel
    Left = 11
    Top = 4
    Width = 661
    Height = 33
    BevelInner = bvLowered
    TabOrder = 0
    object Label4: TLabel
      Left = 23
      Top = 7
      Width = 49
      Height = 16
      Caption = 'Uptime:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUptime: TLabel
      Left = 78
      Top = 8
      Width = 15
      Height = 16
      Caption = '---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 372
      Top = 7
      Width = 125
      Height = 16
      Caption = 'Programm Started:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProgramStarted: TLabel
      Left = 505
      Top = 8
      Width = 15
      Height = 16
      Caption = '---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
end
