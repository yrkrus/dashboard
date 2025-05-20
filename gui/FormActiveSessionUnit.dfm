object FormActiveSession: TFormActiveSession
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1040#1082#1090#1080#1074#1085#1099#1077' '#1089#1077#1089#1089#1080#1080
  ClientHeight = 142
  ClientWidth = 1361
  Color = clWindow
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object group: TGroupBox
    Left = 7
    Top = 35
    Width = 1343
    Height = 100
    TabOrder = 2
    object Label3: TLabel
      Left = 126
      Top = 3
      Width = 65
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 215
      Top = 3
      Width = 175
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1056#1086#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 393
      Top = 3
      Width = 175
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 579
      Top = 3
      Width = 100
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1050
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 675
      Top = 3
      Width = 140
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'IP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 819
      Top = 3
      Width = 130
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Uptime'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 21
      Top = 3
      Width = 90
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1057#1090#1072#1090#1091#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 956
      Top = 2
      Width = 146
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 1143
      Top = 2
      Width = 146
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1072#1082#1090#1080#1074#1085#1086#1089#1090#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object scroll: TScrollBox
      Left = 5
      Top = 22
      Width = 1328
      Height = 70
      Align = alCustom
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      OnMouseWheelDown = scrollMouseWheelDown
      OnMouseWheelUp = scrollMouseWheelUp
      object panel: TPanel
        Left = -6
        Top = -1
        Width = 1319
        Height = 60
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        object Label10: TLabel
          Left = 392
          Top = 5
          Width = 175
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label7: TLabel
          Left = 20
          Top = 5
          Width = 90
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1089#1090#1072#1090#1091#1089
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label8: TLabel
          Left = 125
          Top = 5
          Width = 65
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = 'id'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label9: TLabel
          Left = 214
          Top = 5
          Width = 175
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1088#1086#1083#1100
          Color = 611092
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Visible = False
        end
        object Label13: TLabel
          Left = 674
          Top = 5
          Width = 140
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = 'ip'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label14: TLabel
          Left = 578
          Top = 5
          Width = 100
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1087#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label15: TLabel
          Left = 818
          Top = 5
          Width = 130
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = 'uptime'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label17: TLabel
          Left = 20
          Top = 33
          Width = 90
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1089#1090#1072#1090#1091#1089
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label18: TLabel
          Left = 1142
          Top = 5
          Width = 146
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = #1087#1077#1088#1080#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object BitBtn2: TBitBtn
          Left = 956
          Top = 2
          Width = 144
          Height = 26
          Caption = '&'#1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1077#1089#1089#1080#1102
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000074120000741200000001000000000000000000000000
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
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA452525252A4FFFFFFFFFFFFFFFFFFFF52
            0000000052FFFFFFFFFFFFFFFFFFFF5B00F7F7005BFFFFFFFFFFFFFFF7000000
            00F7F700000000F7FFFFFFFF070000F7F70000F7F7000007FFFFFFFFF70052FF
            FF5252FFFF5200F7FFFFFFFF490000FFFF0000FFFF000049FFFFFFFF00000000
            0000000000000000FFFFFFFF000000000000000000000000FFFFFFFF49000000
            0000000000000049FFFFFFFFF700000000000000000000F7FFFFFFFFFF520000
            00000000000052FFFFFFFFFFFFFF5B0000000000005BFFFFFFFFFFFFFFFFFFF6
            A45252A4F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          Visible = False
          WordWrap = True
        end
        object BitBtn1: TBitBtn
          Left = 956
          Top = 30
          Width = 144
          Height = 26
          Caption = '&'#1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1077#1089#1089#1080#1102
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000074120000741200000001000000000000000000000000
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
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA452525252A4FFFFFFFFFFFFFFFFFFFF52
            0000000052FFFFFFFFFFFFFFFFFFFF5B00F7F7005BFFFFFFFFFFFFFFF7000000
            00F7F700000000F7FFFFFFFF070000F7F70000F7F7000007FFFFFFFFF70052FF
            FF5252FFFF5200F7FFFFFFFF490000FFFF0000FFFF000049FFFFFFFF00000000
            0000000000000000FFFFFFFF000000000000000000000000FFFFFFFF49000000
            0000000000000049FFFFFFFFF700000000000000000000F7FFFFFFFFFF520000
            00000000000052FFFFFFFFFFFFFF5B0000000000005BFFFFFFFFFFFFFFFFFFF6
            A45252A4F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          Visible = False
          WordWrap = True
        end
        object ST_Loading: TStaticText
          Left = 17
          Top = 28
          Width = 1308
          Height = 20
          Alignment = taCenter
          AutoSize = False
          Caption = #1047#1072#1075#1088#1091#1079#1082#1072' ... '#1101#1090#1086' '#1085#1077' '#1079#1072#1081#1084#1077#1090' '#1084#1085#1086#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
          Color = clWindow
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object btnCloseAllSession: TBitBtn
    Left = 10
    Top = 4
    Width = 266
    Height = 26
    Caption = '&'#1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1074#1089#1077' '#1085#1077' '#1072#1082#1090#1080#1074#1085#1099#1077' '#1089#1077#1089#1089#1080#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      0800000000000001000074120000741200000001000000000000000000000000
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
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA452525252A4FFFFFFFFFFFFFFFFFFFF52
      0000000052FFFFFFFFFFFFFFFFFFFF5B00F7F7005BFFFFFFFFFFFFFFF7000000
      00F7F700000000F7FFFFFFFF070000F7F70000F7F7000007FFFFFFFFF70052FF
      FF5252FFFF5200F7FFFFFFFF490000FFFF0000FFFF000049FFFFFFFF00000000
      0000000000000000FFFFFFFF000000000000000000000000FFFFFFFF49000000
      0000000000000049FFFFFFFFF700000000000000000000F7FFFFFFFFFF520000
      00000000000052FFFFFFFFFFFFFF5B0000000000005BFFFFFFFFFFFFFFFFFFF6
      A45252A4F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    WordWrap = True
    OnClick = btnCloseAllSessionClick
  end
  object chkbox_ConfirmKillSession: TCheckBox
    Left = 1024
    Top = 8
    Width = 319
    Height = 17
    Alignment = taLeftJustify
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1072#1090#1100' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1086#1090#1082#1088#1099#1090#1086#1081' '#1089#1077#1089#1089#1080#1080
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    State = cbChecked
    TabOrder = 1
    OnClick = chkbox_ConfirmKillSessionClick
  end
end
