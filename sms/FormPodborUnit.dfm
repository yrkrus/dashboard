object FormPodbor: TFormPodbor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1086#1076#1073#1086#1088
  ClientHeight = 188
  ClientWidth = 430
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
  object lblHeader: TLabel
    Left = 4
    Top = 7
    Width = 418
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1087#1072#1094#1080#1077#1085#1090#1099' '#1087#1086' '#1085#1086#1084#1077#1088#1091' '#1090#1077#1083#1077#1092#1086#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblFooter: TLabel
    Left = 4
    Top = 168
    Width = 418
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 
      #1076#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1085#1091#1078#1085#1086#1075#1086' '#1087#1072#1094#1080#1077#1085#1090#1072' '#1085#1091#1078#1085#1086' '#1076#1074#1072' '#1088#1072#1079' '#1082#1083#1080#1082#1085#1091#1090#1100' '#1083#1077#1074#1086#1081' '#1082#1083'.'#1084#1099#1096#1080 +
      ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object list_podpor: TListBox
    Left = 4
    Top = 34
    Width = 418
    Height = 127
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnDblClick = list_podporDblClick
  end
end
