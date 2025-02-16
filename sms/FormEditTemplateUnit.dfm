object FormEditTemplate: TFormEditTemplate
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
  ClientHeight = 167
  ClientWidth = 448
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
  object lblMsg: TLabel
    Left = 6
    Top = 7
    Width = 431
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = #1058#1077#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1089#1086#1093#1088#1072#1085#1080#1090#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1089#1083#1077' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1086#1082#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object panel_ManualSMS: TPanel
    Left = 8
    Top = 38
    Width = 429
    Height = 122
    BevelInner = bvLowered
    BevelOuter = bvSpace
    TabOrder = 1
    object re_EditMessage: TRichEdit
      Left = 8
      Top = 11
      Width = 413
      Height = 104
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
      OnChange = re_EditMessageChange
    end
  end
  object ST_StatusPanel: TStaticText
    Left = 23
    Top = 30
    Width = 94
    Height = 18
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
end
