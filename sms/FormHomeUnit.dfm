object FormHome: TFormHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' SMS'
  ClientHeight = 403
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object ProgressBar: TGauge
    Left = 190
    Top = 318
    Width = 141
    Height = 19
    ForeColor = clMoneyGreen
    Progress = 50
  end
  object lblProgressBar: TLabel
    Left = 4
    Top = 319
    Width = 179
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1090#1072#1090#1091#1089' '#1086#1090#1087#1088#1072#1074#1082#1080
  end
  object RELog: TRichEdit
    Left = 343
    Top = 12
    Width = 518
    Height = 382
    ScrollBars = ssVertical
    TabOrder = 1
    Zoom = 100
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 5
    Width = 331
    Height = 85
    Caption = ' '#1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' '
    TabOrder = 0
    object lblPwd: TLabel
      Left = 14
      Top = 53
      Width = 41
      Height = 15
      Caption = #1055#1072#1088#1086#1083#1100
      Visible = False
    end
    object lblLogin: TLabel
      Left = 20
      Top = 21
      Width = 35
      Height = 15
      Caption = #1051#1086#1075#1080#1085
      Visible = False
    end
    object edtLogin: TEdit
      Left = 64
      Top = 18
      Width = 258
      Height = 23
      TabOrder = 1
    end
    object edtPwd: TEdit
      Left = 64
      Top = 50
      Width = 258
      Height = 23
      PasswordChar = '*'
      TabOrder = 2
    end
    object STViewPwd: TStaticText
      Left = 260
      Top = 53
      Width = 56
      Height = 17
      Cursor = crHandPoint
      Alignment = taCenter
      AutoSize = False
      BevelInner = bvNone
      BevelOuter = bvNone
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 3
      Transparent = False
      OnClick = STViewPwdClick
    end
    object PanelAuthEdit: TPanel
      Left = 2
      Top = 17
      Width = 327
      Height = 66
      Cursor = crHandPoint
      Hint = #1050#1083#1080#1082#1085#1091#1090#1100' '#1084#1099#1096#1082#1086#1081' '#1076#1083#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080
      Align = alClient
      BevelOuter = bvNone
      Caption = #1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = PanelAuthEditClick
    end
  end
  object btnSendSMS: TButton
    Left = 4
    Top = 346
    Width = 327
    Height = 50
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' SMS '#1088#1072#1089#1089#1099#1083#1082#1091
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnSendSMSClick
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 269
    Width = 327
    Height = 44
    Caption = ' '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086'   '
    TabOrder = 3
    object chkboxShowLog: TCheckBox
      Left = 11
      Top = 20
      Width = 164
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1093#1086#1076' '#1086#1090#1087#1088#1072#1074#1082#1080
      TabOrder = 0
      OnClick = chkboxShowLogClick
    end
    object chkboxLog: TCheckBox
      Left = 185
      Top = 20
      Width = 118
      Height = 17
      Caption = #1047#1072#1087#1080#1089#1099#1074#1072#1090#1100' '#1074' '#1083#1086#1075
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 1
    end
  end
  object PageType: TPageControl
    Left = 4
    Top = 95
    Width = 331
    Height = 169
    ActivePage = TabRassilka
    TabOrder = 2
    OnChange = PageTypeChange
    object TabStatus: TTabSheet
      Caption = #1057#1090#1072#1090#1091#1089' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        AlignWithMargins = True
        Left = 57
        Top = 59
        Width = 170
        Height = 15
        Alignment = taCenter
        Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1088#1082#1080
      end
      object lblMsgStatusInfo: TLabel
        Left = 15
        Top = 10
        Width = 279
        Height = 30
        Alignment = taCenter
        Caption = 
          #1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1089#1086#1089#1090#1072#1074#1083#1103#1077#1090' 4 '#1076#1085#1103' '#1089' %current_date '#1087#1086 +
          ' %now_date'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMaroon
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object edtNumbeFromStatus: TEdit
        Left = 57
        Top = 76
        Width = 209
        Height = 23
        TabOrder = 0
        OnKeyDown = edtNumbeFromStatusKeyDown
      end
    end
    object TabPerenos: TTabSheet
      Caption = #1056#1091#1095#1085#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox4: TGroupBox
        Left = 4
        Top = 7
        Width = 313
        Height = 91
        Caption = ' '#1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072' (-'#1086#1074') '
        TabOrder = 0
        object reNumberPhoneList: TRichEdit
          Left = 6
          Top = 17
          Width = 304
          Height = 72
          BorderStyle = bsNone
          ScrollBars = ssVertical
          TabOrder = 2
          Zoom = 100
          OnKeyDown = reNumberPhoneListKeyDown
        end
        object STEnterSend: TStaticText
          Left = 152
          Top = -1
          Width = 137
          Height = 19
          Cursor = crHandPoint
          Caption = #1086#1090#1087#1088#1072#1074#1082#1072' '#1095#1077#1088#1077#1079' '#1082#1083'. Enter'
          TabOrder = 0
          OnClick = STEnterSendClick
        end
        object chkEnter: TCheckBox
          Left = 287
          Top = -1
          Width = 16
          Height = 17
          TabOrder = 1
          OnClick = chkEnterClick
        end
      end
      object btnMsgPerenos: TButton
        Left = 20
        Top = 104
        Width = 281
        Height = 31
        Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        TabOrder = 1
        OnClick = btnMsgPerenosClick
      end
    end
    object TabRassilka: TTabSheet
      Caption = #1056#1072#1089#1089#1099#1083#1082#1072
      ImageIndex = 1
      object GBView: TGroupBox
        Left = 4
        Top = 8
        Width = 313
        Height = 61
        Caption = ' '#1060#1072#1081#1083' '#1089' '#1088#1072#1089#1089#1099#1083#1082#1086#1081' ('#1089#1084#1089')  '
        TabOrder = 0
        object edtExcelSMS: TEdit
          Left = 16
          Top = 24
          Width = 209
          Height = 23
          TabOrder = 1
        end
        object btnLoadFile: TButton
          Left = 231
          Top = 23
          Width = 75
          Height = 25
          Caption = #1054#1073#1079#1086#1088
          TabOrder = 0
          OnClick = btnLoadFileClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 71
        Width = 313
        Height = 61
        Caption = ' '#1060#1072#1081#1083' '#1089' '#1088#1072#1089#1089#1099#1083#1082#1086#1081' ('#1086#1090#1082#1072#1079#1085#1080#1082#1080')  '
        TabOrder = 1
        object edtExcelSMS2: TEdit
          Left = 16
          Top = 24
          Width = 209
          Height = 23
          TabOrder = 1
        end
        object btnLoadFile2: TButton
          Left = 231
          Top = 23
          Width = 75
          Height = 25
          Caption = #1054#1073#1079#1086#1088
          TabOrder = 0
          OnClick = btnLoadFile2Click
        end
      end
    end
  end
  object Button1: TButton
    Left = 80
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 5
    OnClick = Button1Click
  end
  object OpenDialog: TOpenDialog
    Left = 973
    Top = 63
  end
end
