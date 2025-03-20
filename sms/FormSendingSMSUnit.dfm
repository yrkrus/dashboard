object FormSendingSMS: TFormSendingSMS
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103' '#1085#1072' '#1086#1090#1087#1088#1072#1074#1082#1091
  ClientHeight = 475
  ClientWidth = 1149
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panel: TPanel
    Left = 7
    Top = 7
    Width = 1132
    Height = 460
    BevelInner = bvLowered
    TabOrder = 0
    object re_LogSending: TRichEdit
      Left = 10
      Top = 9
      Width = 1113
      Height = 443
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
end
