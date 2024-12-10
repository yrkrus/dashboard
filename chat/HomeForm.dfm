object FormHome: TFormHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1051#1086#1082#1072#1083#1100#1085#1099#1081' '#1063#1072#1090
  ClientHeight = 559
  ClientWidth = 901
  Color = clWindow
  DefaultMonitor = dmDesktop
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
  object StatusBar: TStatusBar
    Left = 0
    Top = 540
    Width = 901
    Height = 19
    Panels = <
      item
        Text = '0000-00-00 00:00:00'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Text = 'copyright'
        Width = 50
      end>
  end
  object PanelSend: TPanel
    Left = 0
    Top = 431
    Width = 901
    Height = 109
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblerr: TLabel
      Left = 25
      Top = 0
      Width = 24
      Height = 13
      Caption = 'lblerr'
    end
    object btnSend: TButton
      Left = 733
      Top = 35
      Width = 146
      Height = 41
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnSendClick
    end
    object PanelSendMessage: TPanel
      Left = 4
      Top = 20
      Width = 693
      Height = 82
      BevelInner = bvLowered
      TabOrder = 1
      object reMessage: TRichEdit
        Left = 5
        Top = 11
        Width = 680
        Height = 64
        Align = alCustom
        BorderStyle = bsNone
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
      end
    end
    object ST_StatusPanel: TStaticText
      Left = 16
      Top = 12
      Width = 122
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      Left = 739
      Top = 76
      Width = 133
      Height = 17
      Caption = #1086#1090#1087#1088#1072#1074#1082#1072' '#1095#1077#1088#1077#1079' Enter'
      Enabled = False
      TabOrder = 3
    end
  end
  object PanelMessage: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 431
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object PageChannel: TPageControl
      Left = 0
      Top = 0
      Width = 697
      Height = 431
      ActivePage = sheet_main
      Align = alClient
      TabOrder = 0
      object sheet_main: TTabSheet
        Caption = '   '#1054#1073#1097#1080#1081' '#1095#1072#1090'   '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        object WVWindowParent1: TWVWindowParent
          Left = 12
          Top = 72
          Width = 661
          Height = 289
          TabOrder = 1
          Browser = WVBrowser1
        end
        object WebBrowser1: TWebBrowser
          Left = 0
          Top = 0
          Width = 689
          Height = 403
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 120
          ExplicitTop = 224
          ExplicitWidth = 385
          ExplicitHeight = 150
          ControlData = {
            4C00000036470000A72900000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        ImageIndex = 1
      end
    end
  end
  object PanelUsers: TPanel
    Left = 697
    Top = 0
    Width = 204
    Height = 431
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PanelUsersOnline: TPanel
      Left = 1
      Top = 20
      Width = 195
      Height = 410
      BevelInner = bvLowered
      TabOrder = 1
      object ListBoxOnlineUsers: TListBox
        Left = 7
        Top = 15
        Width = 185
        Height = 385
        Style = lbOwnerDrawVariable
        Align = alCustom
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnClick = ListBoxOnlineUsersClick
      end
    end
    object STUsersOnline: TStaticText
      Left = 38
      Top = 13
      Width = 122
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1054#1085#1083#1072#1081#1085
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object WVBrowser1: TWVBrowser
    TargetCompatibleBrowserVersion = '131.0.2903.40'
    AllowSingleSignOnUsingOSPrimaryAccount = False
    Left = 220
    Top = 88
  end
end
