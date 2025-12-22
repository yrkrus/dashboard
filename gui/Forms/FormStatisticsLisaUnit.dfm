object FormStatisticsLisa: TFormStatisticsLisa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
  ClientHeight = 96
  ClientWidth = 230
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 80
    Top = 10
    Width = 83
    Height = 16
    Caption = #1042#1089#1077#1075#1086' '#1079#1074#1086#1085#1082#1086#1074
  end
  object Label2: TLabel
    Left = 46
    Top = 30
    Width = 117
    Height = 16
    Caption = #1054#1090#1074#1077#1095#1077#1085#1085#1099#1077' '#1079#1074#1086#1085#1082#1080
  end
  object Label3: TLabel
    Left = 29
    Top = 50
    Width = 134
    Height = 16
    Caption = #1053#1077' '#1086#1090#1074#1077#1095#1077#1085#1085#1099#1077' '#1079#1074#1086#1085#1082#1080
  end
  object Label4: TLabel
    Left = 8
    Top = 70
    Width = 155
    Height = 16
    Caption = #1055#1077#1088#1077#1074#1077#1076#1077#1085#1086' '#1085#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
    Enabled = False
  end
  object lblAll: TLabel
    Left = 180
    Top = 10
    Width = 18
    Height = 16
    Caption = '---'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblAnswered: TLabel
    Left = 180
    Top = 30
    Width = 18
    Height = 16
    Caption = '---'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblUnAnswered: TLabel
    Left = 180
    Top = 50
    Width = 18
    Height = 16
    Caption = '---'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblToOperator: TLabel
    Left = 180
    Top = 70
    Width = 18
    Height = 16
    Caption = '---'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
end
