object FormHistoryCallOperator: TFormHistoryCallOperator
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1079#1074#1086#1085#1082#1086#1074' (operatorID)'
  ClientHeight = 677
  ClientWidth = 682
  Color = clWindow
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
  object Label2: TLabel
    Left = 158
    Top = 74
    Width = 130
    Height = 16
    Alignment = taRightJustify
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object img_play_or_downloads: TImage
    Left = 652
    Top = 75
    Width = 16
    Height = 16
    Cursor = crHandPoint
    Enabled = False
    Picture.Data = {
      0A544A504547496D616765B4030000FFD8FFE000104A46494600010101007800
      780000FFE100584578696600004D4D002A000000080004013100020000001100
      00003E5110000100000001010000005111000400000001000000765112000400
      00000100000076000000007777772E696E6B73636170652E6F72670000FFDB00
      4300020101020101020202020202020203050303030303060404030507060707
      0706070708090B0908080A0807070A0D0A0A0B0C0C0C0C07090E0F0D0C0E0B0C
      0C0CFFDB004301020202030303060303060C0807080C0C0C0C0C0C0C0C0C0C0C
      0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
      0C0C0C0C0C0C0CFFC00011080010001003012200021101031101FFC4001F0000
      010501010101010100000000000000000102030405060708090A0BFFC400B510
      0002010303020403050504040000017D01020300041105122131410613516107
      227114328191A1082342B1C11552D1F02433627282090A161718191A25262728
      292A3435363738393A434445464748494A535455565758595A63646566676869
      6A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7
      A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2
      E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301010101010101
      01010000000000000102030405060708090A0BFFC400B5110002010204040304
      0705040400010277000102031104052131061241510761711322328108144291
      A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738
      393A434445464748494A535455565758595A636465666768696A737475767778
      797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4
      B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9
      EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00FB1BF6A2D33E20FF
      00C11BBE34F8CBE27DADDF8CFE257EC93F15AFE7BCF887A28D42E6EB5CF86779
      7476CDABD84C1FCF366C5B322230688E1948C02327F641FDA8F5CFF825378E7C
      0BF0F3C65E2CBCF8ABFB23FC5C9E08BE0FFC55331BC97C3AF73836FA36A928EB
      130204139C00060E1032DBEAFED43AA7C40FF82C8FC69F197C31B6B5F19FC35F
      D927E14DFCF69F10F5A1A7DCDAEB9F132F2D0969B48B084279E2CD4AE247452D
      29C2A83900E4FEC7FF00B2EEB9FF00055BF1CF813E2278CBC2779F0AFF00647F
      8493DBCBF07FE15184D9C9E227B6C0B6D6B548874894006080E4107272859AE0
      03FFD9}
    Stretch = True
  end
  object Label4: TLabel
    Left = 358
    Top = 74
    Width = 289
    Height = 19
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = #1055#1088#1086#1089#1083#1091#1096#1072#1090#1100' '#1080#1083#1080' '#1089#1082#1072#1095#1072#1090#1100' ('#1074' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1077')'
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object panel_History: TPanel
    Left = 8
    Top = 100
    Width = 664
    Height = 572
    BevelInner = bvLowered
    ShowCaption = False
    TabOrder = 2
    object list_History: TListView
      Left = 2
      Top = 2
      Width = 660
      Height = 568
      Align = alClient
      BorderStyle = bsNone
      Columns = <>
      DoubleBuffered = True
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      FlatScrollBars = True
      ReadOnly = True
      RowSelect = True
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnCustomDrawItem = list_HistoryCustomDrawItem
    end
    object st_NoCalls: TStaticText
      Left = 3
      Top = 268
      Width = 648
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = #1058#1091#1090' '#1087#1086#1082#1072' '#1087#1091#1089#1090#1086
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object panel_program: TPanel
    Left = 8
    Top = 5
    Width = 664
    Height = 61
    BevelInner = bvLowered
    TabOrder = 0
    object Label5: TLabel
      Left = 16
      Top = 7
      Width = 37
      Height = 16
      Caption = #1042#1093#1086#1076':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProgramStarted: TLabel
      Left = 59
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
    object Label1: TLabel
      Left = 429
      Top = 7
      Width = 61
      Height = 16
      Caption = #1047#1074#1086#1085#1082#1086#1074':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCountCall: TLabel
      Left = 495
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
    object Label3: TLabel
      Left = 527
      Top = 7
      Width = 87
      Height = 16
      Caption = #1047#1074#1086#1085#1082#1086#1074'(%):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCountCallProcent: TLabel
      Left = 620
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
    object Label6: TLabel
      Left = 185
      Top = 35
      Width = 90
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1086#1090' 3-10 '#1084#1080#1085':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_3_10: TLabel
      Left = 283
      Top = 36
      Width = 15
      Height = 16
      Caption = '---'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label8: TLabel
      Left = 350
      Top = 35
      Width = 91
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1086#1090' 10-15 '#1084#1080#1085':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_10_15: TLabel
      Left = 449
      Top = 35
      Width = 15
      Height = 16
      Caption = '---'
      Color = 138
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label10: TLabel
      Left = 503
      Top = 35
      Width = 90
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1086#1090' 15 '#1084#1080#1085':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_15: TLabel
      Left = 601
      Top = 36
      Width = 15
      Height = 16
      Caption = '---'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label12: TLabel
      Left = 26
      Top = 35
      Width = 90
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1076#1086' 3 '#1084#1080#1085':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_3: TLabel
      Left = 124
      Top = 36
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
  object combox_TimeFilter: TComboBox
    Left = 11
    Top = 71
    Width = 138
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = combox_TimeFilterChange
  end
end
