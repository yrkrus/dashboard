object FormGenerateSMS: TFormGenerateSMS
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088
  ClientHeight = 555
  ClientWidth = 1072
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 28
    Top = 16
    Width = 92
    Height = 16
    Caption = #1058#1080#1087' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
  end
  object comboxReasonSmsMessage: TComboBox
    Left = 126
    Top = 12
    Width = 491
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object group_generate: TGroupBox
    Left = 144
    Top = 92
    Width = 686
    Height = 305
    Caption = '  '#1043#1077#1085#1077#1088#1072#1090#1086#1088' '#1089#1086#1086#1073#1097#1077#1085#1080#1103'   '
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 23
      Height = 16
      Caption = #1048#1084#1103
    end
    object Label3: TLabel
      Left = 197
      Top = 24
      Width = 55
      Height = 16
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086
    end
    object Label4: TLabel
      Left = 507
      Top = 19
      Width = 29
      Height = 16
      Caption = #1044#1072#1090#1072
    end
    object Label5: TLabel
      Left = 609
      Top = 25
      Width = 36
      Height = 16
      Caption = #1042#1088#1077#1084#1103
    end
    object Label6: TLabel
      Left = 17
      Top = 81
      Width = 86
      Height = 16
      Caption = #1040#1076#1088#1077#1089' '#1082#1083#1080#1085#1080#1082#1080
    end
    object Label7: TLabel
      Left = 351
      Top = 24
      Width = 22
      Height = 16
      Caption = #1055#1086#1083
    end
    object Edit1: TEdit
      Left = 16
      Top = 41
      Width = 144
      Height = 24
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 194
      Top = 41
      Width = 144
      Height = 24
      TabOrder = 1
      Text = 'Edit1'
    end
    object DateTimePicker1: TDateTimePicker
      Left = 507
      Top = 41
      Width = 89
      Height = 24
      Date = 45764.534038182870000000
      Time = 45764.534038182870000000
      TabOrder = 3
    end
    object DateTimePicker2: TDateTimePicker
      Left = 607
      Top = 41
      Width = 56
      Height = 24
      Date = 45764.534038182870000000
      Time = 45764.534038182870000000
      Kind = dtkTime
      TabOrder = 4
    end
    object ComboBox1: TComboBox
      Left = 118
      Top = 78
      Width = 360
      Height = 24
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object ComboBox2: TComboBox
      Left = 351
      Top = 41
      Width = 59
      Height = 24
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 420
      Top = 45
      Width = 73
      Height = 17
      Caption = #1076#1086' 15 '#1083#1077#1090
      TabOrder = 5
    end
  end
end
