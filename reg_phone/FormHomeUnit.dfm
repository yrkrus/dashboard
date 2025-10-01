object FormHome: TFormHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103' '#1090#1077#1083#1077#1092#1086#1085#1072
  ClientHeight = 355
  ClientWidth = 843
  Color = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 66
    Top = 12
    Width = 67
    Height = 16
    Caption = 'SIP '#1085#1086#1084#1077#1088
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 17
    Top = 41
    Width = 117
    Height = 16
    Caption = 'IP\DNS '#1090#1077#1083#1077#1092#1086#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object chkboxRegister: TCheckBox
    Left = 13
    Top = 71
    Width = 145
    Height = 17
    Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100#1089#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = chkboxRegisterClick
  end
  object chkboxUnRegister: TCheckBox
    Left = 13
    Top = 98
    Width = 139
    Height = 17
    Caption = #1056#1072#1079#1088#1077#1075#1080#1089#1090#1080#1088#1086#1074#1072#1090#1100#1089#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = chkboxUnRegisterClick
  end
  object edtSIP: TEdit
    Left = 137
    Top = 9
    Width = 163
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object edtPhone: TEdit
    Left = 137
    Top = 38
    Width = 163
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnActive: TButton
    Left = 19
    Top = 125
    Width = 277
    Height = 49
    Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = btnActiveClick
  end
  object Button1: TButton
    Left = 376
    Top = 40
    Width = 153
    Height = 25
    Caption = #1042#1093#1086#1076' '#1074' '#1083#1080#1085#1080#1102
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 376
    Top = 71
    Width = 153
    Height = 25
    Caption = #1042#1099#1093#1086#1076' '#1080#1079' '#1083#1080#1085#1080#1080
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 568
    Top = 16
    Width = 75
    Height = 25
    Caption = #1089#1090#1091#1090#1089' '#1093#1086#1083#1076
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 376
    Top = 102
    Width = 153
    Height = 25
    Caption = #1089#1090#1072#1090#1091#1089' '#1090#1077#1083#1077#1092#1086#1085#1072
    TabOrder = 7
    OnClick = Button4Click
  end
end
