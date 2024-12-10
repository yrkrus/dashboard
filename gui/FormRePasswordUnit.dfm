object FormRePassword: TFormRePassword
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1058#1088#1077#1073#1091#1077#1090#1089#1103' '#1089#1084#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1072#1088#1086#1083#1100
  ClientHeight = 210
  ClientWidth = 267
  Color = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lblFooter: TLabel
    Left = 17
    Top = 9
    Width = 223
    Height = 16
    Alignment = taCenter
    Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1089#1084#1077#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1072#1088#1086#1083#1100
  end
  object btnRePwd: TButton
    Left = 17
    Top = 151
    Width = 230
    Height = 41
    Caption = '&'#1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnRePwdClick
  end
  object Panel: TPanel
    Left = 7
    Top = 30
    Width = 249
    Height = 113
    BevelOuter = bvNone
    TabOrder = 0
    object lblPwd_show: TLabel
      Left = 9
      Top = 6
      Width = 95
      Height = 16
      Caption = #1053#1086#1074#1099#1081' '#1088#1072#1088#1086#1083#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPwd2_show: TLabel
      Left = 9
      Top = 55
      Width = 111
      Height = 16
      Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtPwdNew: TEdit
      Left = 9
      Top = 25
      Width = 230
      Height = 24
      PasswordChar = '*'
      TabOrder = 0
    end
    object edtPwd2New: TEdit
      Left = 9
      Top = 77
      Width = 230
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = edtPwd2NewKeyPress
    end
  end
end
