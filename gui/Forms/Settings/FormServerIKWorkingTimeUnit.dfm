object FormServerIKWorkingTime: TFormServerIKWorkingTime
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 263
  ClientWidth = 382
  Color = clWindow
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
  object lblAddress: TLabel
    Left = 12
    Top = 6
    Width = 354
    Height = 16
    AutoSize = False
    Caption = #1040#1076#1088#1077#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 28
    Width = 361
    Height = 225
    TabOrder = 0
    object lbl_mon: TLabel
      Left = 17
      Top = 12
      Width = 77
      Height = 16
      Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    end
    object lbl_tue: TLabel
      Left = 47
      Top = 42
      Width = 47
      Height = 16
      Caption = #1042#1090#1086#1088#1085#1080#1082
    end
    object lbl_delimiter_mon: TLabel
      Left = 176
      Top = 12
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_delimiter_tue: TLabel
      Left = 176
      Top = 42
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_delimiter_wed: TLabel
      Left = 176
      Top = 72
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_wed: TLabel
      Left = 58
      Top = 72
      Width = 36
      Height = 16
      Caption = #1057#1088#1077#1076#1072
    end
    object lbl_thu: TLabel
      Left = 47
      Top = 102
      Width = 47
      Height = 16
      Caption = #1063#1077#1090#1074#1077#1088#1075
    end
    object lbl_fri: TLabel
      Left = 45
      Top = 132
      Width = 49
      Height = 16
      Caption = #1055#1103#1090#1085#1080#1094#1072
    end
    object lbl_sat: TLabel
      Left = 47
      Top = 162
      Width = 48
      Height = 16
      Caption = #1057#1091#1073#1073#1086#1090#1072
    end
    object lbl_sun: TLabel
      Left = 20
      Top = 192
      Width = 74
      Height = 16
      Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
    end
    object lbl_delimiter_thu: TLabel
      Left = 176
      Top = 102
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_delimiter_fri: TLabel
      Left = 176
      Top = 132
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_delimiter_sat: TLabel
      Left = 176
      Top = 162
      Width = 15
      Height = 16
      Caption = '---'
    end
    object lbl_delimiter_sun: TLabel
      Left = 176
      Top = 192
      Width = 15
      Height = 16
      Caption = '---'
    end
    object TimeStart_mon: TDateTimePicker
      Left = 112
      Top = 10
      Width = 55
      Height = 24
      Date = 45762.003472222220000000
      Time = 45762.003472222220000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 0
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_mon: TDateTimePicker
      Left = 200
      Top = 10
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 1
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_mon: TCheckBox
      Left = 264
      Top = 13
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 2
      OnClick = chkbox_monClick
    end
    object TimeStart_tue: TDateTimePicker
      Left = 112
      Top = 40
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 3
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_tue: TDateTimePicker
      Left = 200
      Top = 40
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 4
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_tue: TCheckBox
      Left = 264
      Top = 43
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 5
      OnClick = chkbox_tueClick
    end
    object TimeStart_wed: TDateTimePicker
      Left = 112
      Top = 70
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 6
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_wed: TDateTimePicker
      Left = 200
      Top = 70
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 7
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_wed: TCheckBox
      Left = 264
      Top = 73
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 8
      OnClick = chkbox_wedClick
    end
    object TimeStart_thu: TDateTimePicker
      Left = 112
      Top = 100
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 9
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_thu: TDateTimePicker
      Left = 200
      Top = 100
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 10
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_thu: TCheckBox
      Left = 264
      Top = 103
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 11
      OnClick = chkbox_thuClick
    end
    object TimeStart_fri: TDateTimePicker
      Left = 112
      Top = 130
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 12
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_fri: TDateTimePicker
      Left = 200
      Top = 130
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 13
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_fri: TCheckBox
      Left = 264
      Top = 133
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 14
      OnClick = chkbox_friClick
    end
    object TimeStart_sat: TDateTimePicker
      Left = 112
      Top = 160
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 15
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_sat: TDateTimePicker
      Left = 200
      Top = 160
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 16
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_sat: TCheckBox
      Left = 264
      Top = 163
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 17
      OnClick = chkbox_satClick
    end
    object TimeStart_sun: TDateTimePicker
      Left = 112
      Top = 190
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 18
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object TimeStop_sun: TDateTimePicker
      Left = 200
      Top = 190
      Width = 55
      Height = 24
      Date = 45762.000000000000000000
      Time = 45762.000000000000000000
      ImeMode = imClose
      Kind = dtkTime
      TabOrder = 19
      OnClick = IsEditData
      OnChange = IsEditData
    end
    object chkbox_sun: TCheckBox
      Left = 264
      Top = 193
      Width = 81
      Height = 17
      Caption = #1074#1099#1093#1086#1076#1085#1086#1081
      TabOrder = 20
      OnClick = chkbox_sunClick
    end
  end
end
