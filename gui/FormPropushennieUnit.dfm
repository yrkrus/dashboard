object FormPropushennie: TFormPropushennie
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1087#1091#1097#1077#1085#1085#1099#1077' '#1079#1074#1086#1085#1082#1080
  ClientHeight = 603
  ClientWidth = 673
  Color = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object listSG_Propushennie: TStringGrid
    Left = 0
    Top = 0
    Width = 673
    Height = 603
    Align = alClient
    BorderStyle = bsNone
    ColCount = 4
    FixedColor = clWindow
    FixedCols = 0
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    ColWidths = (
      225
      161
      179
      100)
    RowHeights = (
      24
      24)
  end
end
