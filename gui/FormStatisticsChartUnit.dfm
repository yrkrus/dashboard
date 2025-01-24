object FormStatisticsChart: TFormStatisticsChart
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
  ClientHeight = 591
  ClientWidth = 1029
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
  PixelsPerInch = 96
  TextHeight = 13
  object OrderHistoryChart: TChart
    Left = 0
    Top = 0
    Width = 1029
    Height = 591
    AllowPanning = pmNone
    BackImage.Inside = True
    Legend.Visible = False
    Title.Font.Color = clBlack
    Title.Font.Height = -13
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      #1055#1088#1086#1092#1080#1090)
    BottomAxis.LabelsSeparation = 0
    BottomAxis.Title.Font.Name = 'Times New Roman'
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.LabelsSeparation = 0
    LeftAxis.Maximum = 255.000000000000000000
    LeftAxis.Title.Caption = 'RUB'
    LeftAxis.Title.Font.Name = 'Times New Roman'
    LeftAxis.Items = {
      1500000001045465787406033230300556616C75650500000000000000C80640
      0001045465787406033139300556616C75650500000000000000BE0640000104
      5465787406033138300556616C75650500000000000000B40640000104546578
      7406033137300556616C75650500000000000000AA0640000104546578740603
      3136300556616C75650500000000000000A00640000104546578740603313530
      0556616C75650500000000000000960640000104546578740603313430055661
      6C756505000000000000008C06400001045465787406033133300556616C7565
      05000000000000008206400001045465787406033132300556616C7565050000
      0000000000F005400001045465787406033131300556616C7565050000000000
      0000DC05400001045465787406033130300556616C75650500000000000000C8
      054000010454657874060239300556616C75650500000000000000B405400001
      0454657874060238300556616C75650500000000000000A00540000104546578
      74060237300556616C756505000000000000008C054000010454657874060236
      300556616C75650500000000000000F004400001045465787406023530055661
      6C75650500000000000000C8044000010454657874060234300556616C756505
      00000000000000A0044000010454657874060233300556616C75650500000000
      000000F0034000010454657874060232300556616C75650500000000000000A0
      034000010454657874060231300556616C75650500000000000000A002400001
      045465787406013000}
    Panning.MouseWheel = pmwNone
    TopAxis.Automatic = False
    TopAxis.AutomaticMaximum = False
    TopAxis.AutomaticMinimum = False
    TopAxis.Labels = False
    TopAxis.LabelsFormat.Visible = False
    TopAxis.LabelsSeparation = 0
    View3D = False
    View3DOptions.Orthogonal = False
    Zoom.Allow = False
    Zoom.Pen.Visible = False
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    ExplicitLeft = 132
    ExplicitTop = 128
    ExplicitWidth = 685
    ExplicitHeight = 385
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      24
      15
      24)
    ColorPaletteIndex = 13
    object Series1: TFastLineSeries
      SeriesColor = 4227072
      LinePen.Color = 4227072
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
end
