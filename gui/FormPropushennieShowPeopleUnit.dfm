object FormPropushennieShowPeople: TFormPropushennieShowPeople
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1072#1094#1080#1077#1085#1090#1086#1074
  ClientHeight = 170
  ClientWidth = 429
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
  object Label1: TLabel
    Left = 4
    Top = 7
    Width = 418
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1087#1072#1094#1080#1077#1085#1090#1099' '#1087#1086' '#1085#1086#1084#1077#1088#1091' '#1090#1077#1083#1077#1092#1086#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object list_pacients: TListBox
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
  end
end
