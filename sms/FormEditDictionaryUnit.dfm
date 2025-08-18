object FormEditDictionary: TFormEditDictionary
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1083#1086#1074#1072
  ClientHeight = 73
  ClientWidth = 344
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TLabel
    Left = 9
    Top = 10
    Width = 322
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1083#1086#1074#1086' '#1089#1086#1093#1088#1072#1085#1080#1090#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1089#1083#1077' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1086#1082#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object re_Edit: TRichEdit
    Left = 8
    Top = 38
    Width = 322
    Height = 24
    Align = alCustom
    BevelInner = bvLowered
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
    OnChange = re_EditChange
    OnKeyDown = re_EditKeyDown
    OnKeyPress = re_EditKeyPress
  end
end
