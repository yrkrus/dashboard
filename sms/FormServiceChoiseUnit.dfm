object FormServiceChoise: TFormServiceChoise
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1059#1089#1083#1091#1075#1080
  ClientHeight = 650
  ClientWidth = 1058
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
  object Label1: TLabel
    Left = 245
    Top = 11
    Width = 277
    Height = 13
    Caption = #1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1085#1091#1078#1085#1086' 2 '#1088#1072#1079#1072' '#1082#1083#1080#1082#1085#1091#1090#1100' '#1085#1072' '#1085#1091#1078#1085#1091#1102' '#1091#1089#1083#1091#1075#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblChoiseCount: TLabel
    Left = 733
    Top = 9
    Width = 105
    Height = 16
    Alignment = taRightJustify
    Caption = #1074#1099#1073#1088#1072#1085#1086' '#1091#1089#1083#1091#1075' : 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object editFind: TEdit
    Left = 8
    Top = 6
    Width = 223
    Height = 24
    TabOrder = 0
    OnChange = editFindChange
    OnClick = editFindClick
  end
  object st_FindMessage: TStaticText
    Left = 114
    Top = 11
    Width = 116
    Height = 17
    Caption = #1055#1086#1080#1089#1082' ('#1084#1080#1085' 3 '#1089#1080#1084#1074#1086#1083#1072')'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object group_tree: TGroupBox
    Left = 6
    Top = 34
    Width = 1044
    Height = 608
    TabOrder = 3
    object tree_menu: TTreeView
      Left = 2
      Top = 18
      Width = 1040
      Height = 588
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnDblClick = tree_menuDblClick
    end
  end
  object btnShowChoise: TButton
    Left = 848
    Top = 6
    Width = 201
    Height = 25
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' \ '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 1
    OnClick = btnShowChoiseClick
  end
end
