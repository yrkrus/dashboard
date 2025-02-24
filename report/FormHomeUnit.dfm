object FormHome: TFormHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054#1090#1095#1077#1090#1099
  ClientHeight = 386
  ClientWidth = 430
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupEnabledReports: TGroupBox
    Left = 7
    Top = 4
    Width = 410
    Height = 71
    Caption = ' '#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1086#1090#1095#1077#1090#1099' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblReportShowRingsOperators: TLabel
      Left = 16
      Top = 44
      Width = 383
      Height = 16
      Cursor = crHandPoint
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1091' '#1079#1074#1086#1085#1082#1086#1074' '#1086#1087#1077#1088#1072#1090#1086#1088#1072#1084#1080' ('#1087#1086#1076#1088#1086#1073#1085#1099#1081')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblReportShowRingsOperatorsClick
      OnMouseMove = lblReportShowRingsOperatorsMouseMove
      OnMouseLeave = lblReportShowRingsOperatorsMouseLeave
    end
    object lblReportCountRingsOperators: TLabel
      Left = 16
      Top = 24
      Width = 292
      Height = 16
      Cursor = crHandPoint
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1091' '#1079#1074#1086#1085#1082#1086#1074' '#1086#1087#1077#1088#1072#1090#1086#1088#1072#1084#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblReportCountRingsOperatorsClick
      OnMouseMove = lblReportCountRingsOperatorsMouseMove
      OnMouseLeave = lblReportCountRingsOperatorsMouseLeave
    end
    object STDEBUG: TStaticText
      Left = 312
      Top = 1
      Width = 92
      Height = 20
      Caption = ' DEBUG MODE '
      Color = clWindow
      DoubleBuffered = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      Transparent = False
      Visible = False
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 367
    Width = 430
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Text = 'copyright'
        Width = 50
      end>
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 85
    Width = 410
    Height = 270
    Caption = ' '#1053#1077' '#1076#1086#1089#1090#1091#1087#1085#1099#1077' '#1086#1090#1095#1077#1090#1099' ('#1074' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1077') '
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 377
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1091' '#1086#1090#1074#1077#1095#1077#1085#1085#1099#1093' '#1079#1074#1086#1085#1082#1086#1074' '#1086#1087#1077#1088#1072#1090#1086#1088#1072#1084#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 16
      Top = 164
      Width = 296
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1087#1091#1097#1077#1085#1085#1099#1084' '#1085#1086#1084#1077#1088#1072#1084' '#1074' '#1086#1095#1077#1088#1077#1076#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 16
      Top = 184
      Width = 263
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1087#1091#1097#1077#1085#1085#1099#1084' '#1085#1086#1084#1077#1088#1072#1084' '#1074' IVR'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 16
      Top = 204
      Width = 274
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1074#1090#1086#1088#1085#1086#1084#1091' '#1079#1074#1086#1085#1082#1091' '#1087#1072#1094#1080#1077#1085#1090#1086#1074' '
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 16
      Top = 224
      Width = 334
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1088#1077#1076#1085#1077#1084#1091' '#1074#1088#1077#1084#1077#1085#1080' '#1086#1078#1080#1076#1072#1085#1080#1103' '#1074' '#1086#1095#1077#1088#1077#1076#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 64
      Width = 208
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1090#1072#1090#1091#1089#1072#1084' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1074
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 84
      Width = 331
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1085#1072#1093#1086#1078#1076#1077#1085#1080#1103' '#1079#1074#1086#1085#1082#1072' '#1074' '#1086#1095#1077#1088#1077#1076#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 44
      Width = 355
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1088#1077#1076#1085#1077#1084#1091' '#1074#1088#1077#1084#1077#1085#1080' '#1088#1072#1079#1075#1086#1074#1086#1088#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072#1084#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 16
      Top = 104
      Width = 130
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1095#1077#1088#1077#1076#1103#1084
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 16
      Top = 124
      Width = 191
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1072#1075#1088#1091#1079#1082#1077' '#1085#1072' '#1083#1080#1085#1080#1102
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 16
      Top = 144
      Width = 361
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1085#1072#1093#1086#1078#1076#1077#1085#1080#1103' '#1086#1087#1077#1088#1072#1090#1086#1088#1072#1084#1080' '#1074' OnHold'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 16
      Top = 244
      Width = 195
      Height = 16
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1084' SMS'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
