object FormMsgPerenos: TFormMsgPerenos
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FormMsgPerenos'
  ClientHeight = 532
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lblMsg: TLabel
    Left = 6
    Top = 6
    Width = 431
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = #1058#1077#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1089#1086#1093#1088#1072#1085#1080#1090#1089#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1086#1089#1083#1077' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1086#1082#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object reMsg: TRichEdit
    Left = 6
    Top = 29
    Width = 430
    Height = 112
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
  end
  object GBLastMEssage: TGroupBox
    Left = 6
    Top = 148
    Width = 431
    Height = 378
    Caption = ' '#1055#1086#1089#1083#1077#1076#1085#1080#1077' %COUNT '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' ('#1085#1086#1074#1099#1077' '#1074#1074#1077#1088#1093#1091') '
    TabOrder = 1
    object SG: TStringGrid
      Left = 2
      Top = 17
      Width = 427
      Height = 359
      Align = alClient
      BorderStyle = bsNone
      ColCount = 1
      DefaultColWidth = 427
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 0
      OnSelectCell = SGSelectCell
      ColWidths = (
        427)
      RowHeights = (
        24)
    end
  end
end
