object FormListSendingSMS: TFormListSendingSMS
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1085#1086#1084#1077#1088#1086#1074
  ClientHeight = 320
  ClientWidth = 205
  Color = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TLabel
    Left = 8
    Top = 5
    Width = 183
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = #1053#1086#1074#1099#1081' '#1085#1086#1084#1077#1088' '#1089' '#1085#1086#1074#1086#1081' '#1089#1090#1088#1086#1082#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object panel_ListSMS: TPanel
    Left = 6
    Top = 33
    Width = 190
    Height = 275
    BevelInner = bvLowered
    BevelOuter = bvSpace
    TabOrder = 1
    object re_ListSendingSMS: TRichEdit
      Left = 7
      Top = 13
      Width = 173
      Height = 254
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
      OnKeyDown = re_ListSendingSMSKeyDown
      OnKeyPress = re_ListSendingSMSKeyPress
    end
  end
  object ST_StatusPanel: TStaticText
    Left = 21
    Top = 25
    Width = 112
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1087#1080#1089#1086#1082' '#1085#1086#1084#1077#1088#1086#1074
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
