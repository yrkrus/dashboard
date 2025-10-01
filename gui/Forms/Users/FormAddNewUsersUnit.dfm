object FormAddNewUsers: TFormAddNewUsers
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 564
  ClientWidth = 1060
  Color = clWindow
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label6: TLabel
    Left = 494
    Top = 197
    Width = 106
    Height = 16
    Caption = #1043#1088#1091#1087#1087#1072' '#1076#1086#1089#1090#1091#1087#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPwd_show: TLabel
    Left = 792
    Top = 381
    Width = 50
    Height = 16
    Caption = #1055#1072#1088#1086#1083#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblInfoNewPwd: TLabel
    Left = 226
    Top = 335
    Width = 156
    Height = 32
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1076#1083#1103' '#1085#1086#1074#1099#1093' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' '#1087#1072#1088#1086#1083#1100' "1"'
    WordWrap = True
  end
  object lblPwd2_show: TLabel
    Left = 792
    Top = 421
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
  object lblLogin: TLabel
    Left = 223
    Top = 278
    Width = 39
    Height = 16
    Caption = #1051#1086#1075#1080#1085
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object comboxUserGroup: TComboBox
    Left = 492
    Top = 214
    Width = 232
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = comboxUserGroupChange
  end
  object edtPwdNew: TEdit
    Left = 792
    Top = 399
    Width = 230
    Height = 24
    PasswordChar = '*'
    TabOrder = 9
  end
  object chkboxmyPwd: TCheckBox
    Left = 226
    Top = 369
    Width = 226
    Height = 17
    Caption = #1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1088#1091#1075#1086#1081' '#1087#1072#1088#1086#1083#1100
    TabOrder = 5
    OnClick = chkboxmyPwdClick
  end
  object edtPwd2New: TEdit
    Left = 792
    Top = 439
    Width = 230
    Height = 24
    PasswordChar = '*'
    TabOrder = 10
  end
  object edtNewLogin: TEdit
    Left = 223
    Top = 295
    Width = 230
    Height = 24
    Color = cl3DLight
    Enabled = False
    TabOrder = 4
    OnChange = edtNewLoginChange
  end
  object btnAddNewUser: TBitBtn
    Left = 40
    Top = 480
    Width = 461
    Height = 47
    Caption = '   &'#1044#1086#1073#1072#1074#1080#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Glyph.Data = {
      36080000424D3608000000000000360400002800000020000000200000000100
      0800000000000004000074120000741200000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFFFFFFFFFFFF07494907FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF49000049FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF074900000000
      0000000000000000000000000000000000000000000000004907490000000000
      0000000000000000000000000000000000000000000000000049490000000000
      0000000000000000000000000000000000000000000000000049074900000000
      0000000000000000000000000000000000000000000000004907FFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF49000049FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFF07494907FFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 11
    WordWrap = True
    OnClick = btnAddNewUserClick
  end
  object chkboxAllowLocalChat: TCheckBox
    Left = 594
    Top = 383
    Width = 47
    Height = 17
    Caption = #1063#1072#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object PanelOperators: TPanel
    Left = 494
    Top = 246
    Width = 225
    Height = 128
    BevelInner = bvLowered
    TabOrder = 3
    object lblOperatorSetting_SIP_show: TLabel
      Left = 20
      Top = 7
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
    object lblOperatorSetting_Tel_show: TLabel
      Left = 20
      Top = 52
      Width = 76
      Height = 16
      Caption = 'IP '#1090#1077#1083#1077#1092#1086#1085
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtOperatorSetting_SIP_show: TEdit
      Left = 13
      Top = 25
      Width = 199
      Height = 24
      TabOrder = 0
      OnChange = edtOperatorSetting_SIP_showChange
    end
    object edtOperatorSetting_Tel_show: TEdit
      Left = 13
      Top = 70
      Width = 199
      Height = 24
      TabOrder = 1
    end
    object chkboxZoiper: TCheckBox
      Left = 13
      Top = 102
      Width = 156
      Height = 17
      Caption = #1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' Zoiper'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = chkboxZoiperClick
    end
  end
  object chkboxAllowReports: TCheckBox
    Left = 494
    Top = 383
    Width = 69
    Height = 17
    Caption = #1054#1090#1095#1077#1090#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
  object chkboxAllowSMS: TCheckBox
    Left = 671
    Top = 383
    Width = 48
    Height = 17
    Caption = 'SMS'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object GroupBox1: TGroupBox
    Left = 22
    Top = 8
    Width = 395
    Height = 198
    Caption = '  '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103'  '
    TabOrder = 0
    object Label8: TLabel
      Left = 47
      Top = 23
      Width = 53
      Height = 16
      Caption = #1060#1072#1084#1080#1083#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 77
      Top = 51
      Width = 23
      Height = 16
      Caption = #1048#1084#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 10
      Top = 75
      Width = 90
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1058#1080#1087' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 65
      Top = 116
      Width = 35
      Height = 16
      Caption = #1051#1086#1075#1080#1085
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtNewFamiliya: TEdit
      Left = 113
      Top = 20
      Width = 143
      Height = 24
      TabOrder = 0
      OnChange = edtNewFamiliyaChange
    end
    object edtNewName: TEdit
      Left = 113
      Top = 48
      Width = 143
      Height = 24
      TabOrder = 1
    end
    object ComboBox1: TComboBox
      Left = 113
      Top = 79
      Width = 143
      Height = 24
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = comboxUserGroupChange
    end
    object Edit1: TEdit
      Left = 113
      Top = 113
      Width = 143
      Height = 24
      TabOrder = 3
      OnChange = edtNewFamiliyaChange
    end
    object chkboxManualLogin: TCheckBox
      Left = 167
      Top = 115
      Width = 83
      Height = 17
      Alignment = taLeftJustify
      Caption = #1091#1082#1072#1079#1072#1090#1100' '#1089#1074#1086#1081
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = chkboxManualLoginClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 594
    Top = 56
    Width = 185
    Height = 105
    Caption = 'GroupBox2'
    TabOrder = 1
  end
end
