object FormWait: TFormWait
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #1057#1090#1072#1090#1091#1089': null'
  ClientHeight = 58
  ClientWidth = 512
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object panel: TPanel
    Left = 0
    Top = 0
    Width = 511
    Height = 57
    BevelInner = bvLowered
    TabOrder = 0
    object ProgressBar: TGauge
      Left = 10
      Top = 22
      Width = 495
      Height = 29
      Align = alCustom
      BorderStyle = bsNone
      ForeColor = clGradientActiveCaption
      Progress = 50
      ShowText = False
    end
    object ProgressStatusText: TStaticText
      Left = 13
      Top = 5
      Width = 51
      Height = 17
      Caption = #1057#1090#1072#1090#1091#1089': '
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object STEsc: TStaticText
      Left = 425
      Top = 5
      Width = 80
      Height = 17
      Cursor = crHandPoint
      Caption = #1086#1090#1084#1077#1085#1072' (ESC)'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      OnClick = STEscClick
    end
  end
end
