object FormManualPodbor: TFormManualPodbor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1086#1076#1073#1086#1088' '#1085#1086#1084#1077#1088#1072' '#1090#1077#1083#1077#1092#1086#1085#1072
  ClientHeight = 685
  ClientWidth = 677
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
    Left = 303
    Top = 8
    Width = 366
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1085#1091#1078#1085#1086#1075#1086' '#1085#1086#1084#1077#1088#1072' '#1085#1091#1078#1085#1086' '#1076#1074#1072' '#1088#1072#1079' '#1082#1083#1080#1082#1085#1091#1090#1100' '#1083#1077#1074#1086#1081' '#1082#1083'.'#1084#1099#1096#1080' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object panel_History: TPanel
    Left = 6
    Top = 59
    Width = 664
    Height = 619
    BevelInner = bvLowered
    ShowCaption = False
    TabOrder = 3
    object list_History: TListView
      Left = 2
      Top = 2
      Width = 660
      Height = 615
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
      OnDblClick = list_HistoryDblClick
    end
    object st_NoCalls: TStaticText
      Left = 6
      Top = 319
      Width = 645
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
  object chkbox_MyCalls: TCheckBox
    Left = 8
    Top = 7
    Width = 136
    Height = 17
    Caption = #1090#1086#1083#1100#1082#1086' '#1089#1074#1086#1080' '#1079#1074#1086#1085#1082#1080
    TabOrder = 0
    OnClick = chkbox_MyCallsClick
  end
  object editFindMessage: TEdit
    Left = 8
    Top = 30
    Width = 223
    Height = 24
    TabOrder = 1
    OnClick = editFindMessageClick
    OnKeyPress = editFindMessageKeyPress
  end
  object st_FindPhone: TStaticText
    Left = 85
    Top = 34
    Width = 141
    Height = 17
    Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1086#1084#1077#1088#1091' '#1090#1077#1083#1077#1092#1086#1085#1072
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
