object FormHome: TFormHome
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1051#1086#1082#1072#1083#1100#1085#1099#1081' '#1063#1072#1090
  ClientHeight = 536
  ClientWidth = 927
  Color = clWindow
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 517
    Width = 927
    Height = 19
    Panels = <
      item
        Text = '0000-00-00 00:00:00'
        Width = 120
      end
      item
        Alignment = taRightJustify
        Text = 'copyright'
        Width = 50
      end>
  end
  object PanelSend: TPanel
    Left = 0
    Top = 419
    Width = 927
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      927
      98)
    object lblerr: TLabel
      Left = 65
      Top = -3
      Width = 34
      Height = 13
      Caption = 'lblError'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object ImgAddFile: TImage
      Left = 8
      Top = 18
      Width = 24
      Height = 25
      Cursor = crHandPoint
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1083#1086#1078#1077#1085#1080#1077
      ParentShowHint = False
      Picture.Data = {
        0A544A504547496D6167658E020000FFD8FFE000104A46494600010100000100
        010000FFFE001F436F6D70726573736564206279206A7065672D7265636F6D70
        72657373FFDB0084000404040404040404040406060506060807070707080C09
        090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D222A
        25252A34323444445C010404040404040404040406060506060807070707080C
        09090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D22
        2A25252A34323444445CFFC20011080018001803012200021101031101FFC400
        17000100030000000000000000000000000008060709FFDA0008010100000000
        718C9AF1ECF7635C42E537FFC400140101000000000000000000000000000000
        00FFDA00080102100000000FFFC4001401010000000000000000000000000000
        0000FFDA00080103100000000FFFC4002D100001040102020807010000000000
        00000203040506010007121308111432375261B5223653667685A2B4FFDA0008
        010100013F00BA4CAF58A65BAC6D52051789857F20901F74CDAA04A8E0BD3AC7
        559B8CF4249ED95812DD79B9F999B9AAD30B5413FC17606A1696A4EDBE5B0E40
        403201F4F555B540DDA05859EB0FFB6C4BDE6F6771CA511E3E4A8491FC0A8816
        3A88338D6EDF853B9BF89CD7F8CF501F32D483EEBD92F63535D15BC05A27ED3D
        C57D59E012B1D5EC75C557E504B45BC8F257C9874912592FEB518C25EB788269
        29D1E25A53732BD1E8C4C4CF35C71C3AA2D0392D9CA8B716031901F3E35B494D
        71B73B6D55A6BB5C1678C1B1E5C187739CE1525D4C0FA608F5FFC40014110100
        000000000000000000000000000020FFDA0008010201013F001FFFC400141101
        00000000000000000000000000000020FFDA0008010301013F001FFFD9}
      ShowHint = True
      OnClick = ImgAddFileClick
    end
    object ImgSmile: TImage
      Left = 8
      Top = 44
      Width = 24
      Height = 24
      Cursor = crHandPoint
      ParentShowHint = False
      Picture.Data = {
        0A544A504547496D61676501050000FFD8FFE000104A46494600010100000100
        010000FFFE001F436F6D70726573736564206279206A7065672D7265636F6D70
        72657373FFDB0084000404040404040404040406060506060807070707080C09
        090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D222A
        25252A34323444445C010404040404040404040406060506060807070707080C
        09090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D22
        2A25252A34323444445CFFC20011080030003003012200021101031101FFC400
        1A000003010101010000000000000000000003060702040508FFDA0008010100
        000000FBF82B596ADE251E784F67559D8B01A4F4A1F287141788C49854CBA986
        99872E8FFFC4001501010100000000000000000000000000000706FFDA000801
        0210000000831A672E9CAB4A3A48FFC400160101010100000000000000000000
        000000050604FFDA00080103100000004A8E7D84F34ED083FFC4002D10000103
        0206010206020300000000000002010304000506111221314151131410326182
        D1E1226271B1F1FFDA0008010100013F00A95323426F5BEEA00FFB5A771734DA
        92478A47FD8974D318C9AD85E8A409E45757E2A1DC224D691D8CF210F7973FE3
        E1365B50233AF170099AD4E9CF4D789E78B355E13A14F0944544550AE122DD20
        64473C953E61E893C2D5BA7B33A1332DA5FE249C768B58B9E506A3308BB19292
        FDBFF6AE97262C587AFD89245BDF9E16C605DF66C2E93775969E77C847925E92
        ADF728F7CC3D61C4B1ADEFC00B9C7277D9BE5A8DA502D3CED989722BDA55C2E1
        1EC987EFF8964DBDF9E16B8E0EFB360B49BAA65A79DF211E497A4A873E35EF0F
        D8312C5B7BF002E91CDDF66F96A36940B4F3B6625C8AF69580A4EB666C725D9B
        3131FBD3F558C995F4E33E9C01A8AFDC9FAA6264886E7AD19D56CF8CD29EB91D
        CD52594A491AB64704908765E132DA82E6E5AC96584A48FA765322441DFCE7B5
        4C9B266BAAF4A795C732CB35E92B0132ADC79B2D47670C407EC4FDD5C22373E2
        3D19DF94939F0BF4AB842916E906C481C953E52E893CA53D808E0C87E4612C47
        32C68F1A99C6001911752F62D39B0D0604726C866462CC4532F7E89A18473018
        F1752764D37B155BEDF2AEB2822C50CD57E62E847CAD5B20336E86CC569326DB
        1CB7E557B5F84EB7C29CCFA3298431EB3E517CFD16A5604615753134DB45E887
        5FE299C051C091654D71CFEA0281F9A836C876E65198AC8B41DE5CAAFD57B5F8
        7FFFC40028110001030205030403000000000000000003010206041100121331
        52051415071632D12133A1FFDA0008010201013F009B4D831608C211A1ABCC8A
        A31AFC5ADE4EC27A9B2D53EAF782CB7FD7A4DCB8864CC328090461A06B8288AF
        626CE6F26E261534F45EA1775D62916A6886D12E972664FBC2750E8DEEBF23E1
        9DE335AFD9DBF36B5B6FEDB110A9A7AD9EAD5748A45A6A37B4ABA5C5993EF133
        86064E11982440D7852C322ECE4E2EC24567DA9A2AC0DED93B9B8B3DB6F9DB3E
        21F0F0C6824294886AE3258844D9A9C5B8FFC400251100020104020103050000
        0000000000000102050003041211511322313233416191C1FFDA000801030101
        3F008F8F6CD62492B697DCD083C12BAE8DCF7B1E6A4E31F019581DAD37C5BA3D
        1A8EB4F7A24A635CD2E92DEAE8F34B8B9463BC232479F5FA9CFE7BA93B0F620F
        4CAB9BDE0CBEAECF351926D80E432EF65BE4BFD14B250617725FBF1F0DC7EBDA
        A5A59E49D55574B09F15FB93D9AFFFD9}
      Proportional = True
      ShowHint = False
      OnClick = ImgSmileClick
    end
    object ImgFormatText: TImage
      Left = 8
      Top = 68
      Width = 24
      Height = 24
      Cursor = crHandPoint
      Hint = #1060#1086#1088#1084#1072#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1077#1082#1089#1090#1072
      ParentShowHint = False
      Picture.Data = {
        0A544A504547496D61676581040000FFD8FFE000104A46494600010100000100
        010000FFFE001F436F6D70726573736564206279206A7065672D7265636F6D70
        72657373FFDB0084000404040404040404040406060506060807070707080C09
        090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D222A
        25252A34323444445C010404040404040404040406060506060807070707080C
        09090909090C130C0E0C0C0E0C131114100F1014111E171515171E221D1B1D22
        2A25252A34323444445CFFC20011080030003003012200021101031101FFC400
        1A000002030101000000000000000000000000060104050708FFDA0008010100
        000000F7CAA48362968A21BF6A197079CBC58864C4E6EF16274D08DEB4DCA803
        47FFC40017010003010000000000000000000000000000010402FFDA00080102
        10000000BD9996B19FFFC4001701000301000000000000000000000000000102
        0405FFDA0008010310000000CE52D4C854FF00FFC40032100000050203050606
        0301000000000000010203040500061121D216547492B2121335415795142223
        31589424344451FFDA0008010100013F007EFDAC5363B9747C0A197FD1111F20
        ADB88CDD9D7293556DD46EEEEB949AAB6EA377775CA4D55B751BBBBAE526AA8D
        9168FDA11D3636253643966021E4357CE51ADF8A2F41AA2A2A2D58B8F5148F6E
        6399B24631852288888942B6D61BD29BA3D98BAAB6D61BD29BA3D98BAA9A388B
        9CB7E5A412B55D451D122C404E41995BAD89530377850CFE5CF21AB20708C71C
        51BA0B57BF8637E28BD06A831C2263B8547A029E5DF69AEC5E20D2F9866AE944
        54222E3E29057B950C1814FD831B0376473C281DC9FE40C2FE930D750EAAEADA
        7362E6F16B721F17183B6C92291130EE83E90822260110FBD58F804638E28DD0
        5ABDFC31BF145E83542784C6F0A8F4053FB3AD34193C598D8D0CE9D248A8749B
        FC2B74FBD394A2254FB662E05ED503493FC7E85FDD61A2A1D2593B526C1C59CD
        6DB3FF002041A3655154AA07741F5714400311FB558FE18E38A37416AF90C235
        BF145E835444BC5A314C123C8362A80D922980CA9404A2050AD8A86F55AE7F79
        2E9AD8A86F55AE8F792E9A66DE2E12DF958F4EE97528758AB2853C83C2B85B13
        2605021472F972C82AC8F0C71C51BA0B5211AD641A19ABA2E241CF10C84043CC
        2B6163447FB0EB989A6B616377875CC4D35B0B1BBC3AE6269A0B16347FD0EB98
        9A69847B68C6E46CD89810B9E798888F98D7FFC4002211000105000006030000
        000000000000000200010304111234547393B13541A1FFDA0008010201013F00
        8E3AA154279C0CDCCC85984B3317150E9A6F232962AC758E6840C1C0C45D88B7
        751FC7D6EF49E990E7D7EE21E42CF7A3F4EA392A9D50827330703226711DDD5C
        343A99BC6CA592B0563861333733127721CCC5FFC40020110100020300010501
        0000000000000000020311000104542134357393A1FFDA0008010301013F0092
        5EA93A9C10303401568DDDE577F9517E7BC8A5EA1D31C1330CB096B64D55647F
        23D1F50C77E97FCBC5EFF97E9792C5D51F539E001E98277A4AAAB2FBFC58BF4D
        E45174BE98E6980040475A2AEEF3FFD9}
      Proportional = True
      ShowHint = True
      OnClick = ImgSmileClick
    end
    object ImgSendMessage: TImage
      Left = 867
      Top = 37
      Width = 32
      Height = 32
      Cursor = crHandPoint
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      Anchors = [akRight]
      ParentShowHint = False
      Picture.Data = {
        0A544A504547496D61676500050000FFD8FFE000104A46494600010102000200
        020000FFDB004300030202020202030202020303030304060404040404080606
        050609080A0A090809090A0C0F0C0A0B0E0B09090D110D0E0F101011100A0C12
        131210130F101010FFDB00430103030304030408040408100B090B1010101010
        1010101010101010101010101010101010101010101010101010101010101010
        10101010101010101010101010FFC00011080020002003011100021101031101
        FFC40017000101010100000000000000000000000008050307FFC4002B100002
        0102050303040301000000000000010302040700050611210812511314312232
        41422383A162FFC4001B01010100020301000000000000000000000706010203
        040508FFC4002C11000102040404060301000000000000000102050003041106
        2141811223619107223132337151C1D182FFDA000C03010002110311003F00B5
        A86EE5D8E9BEF6EB0C8B4A6A4A8F608CF2A5C72DAD25F4AE531859032848FD32
        94271DE503191F38FA229591B31533D3CEA996388A00E21928102C73D6C41C8D
        C74811A87670C3AE73A553AFCA144F09CC104DC65F47D458C286CF75D36D75E0
        4651AEA23486713DA1DF50CEEA06CBCC5DC7A7BF27660007C771C1CBE7876E0D
        D79B45CE97D3DC36D76EC22E5A31BD1575A5D572D7D7DA77D37EF09443D15485
        D4D33A0E4B6226B62E42519C48DC10470411F9C1FA92A412950B1116895050E2
        49B88D31AC6604DD5CF4AD73EE15D07EBEB759153E674D9850D38AB5FBC525A2
        A160ACF0C94411E9C17CEFE4617F04E316E6C6E1435EB292951B6448B1CF4075
        260CF15E17AE70AE3574680A040BE601B8CB5B680417351585BD1A57B8E796C3
        51A570FB9CBA09B943FB16251FF708D4B891A2B3E1A9413F8E200F636310D50C
        4E54BF2C850D891DC5C454B59D435DBB25562934EE76E397AE7BBB26CC632653
        1E791D8482B27F260627CEF8EBBC6186BC409E29E8F368B4E4AEFAEF78E76C7F
        7065570C95797549CC76D36B437ACD75B36CAE6329B23D49BE94CFDF28AA08AA
        677D2BD878016FD80049FD6623F20032C0F3EE0071690A9D4FCD9633B8F701D5
        3FB17DA1399F19D0B9112A772E61D0FA1FA3FDB6F1CC3AB9EAA6E7DBDBA0FD03
        6EB3DA7CB29B2FA1A7356CF66A734D43225879646400F4E6BE36F27147827073
        739B68AEAF4151528DB3205865A11A831E1E2BC515CDF5C6928D6120017C8137
        39EB7D0882E6A2BF57A355770CF2E7EA372E7F72575F34A8FF005ACC63FE611A
        970DB451FC34C807F3C209EE6E621AA1F5CAABE59EA3B903B0B08A96AFA79BB7
        7B6AC55E9EC95B1CBD93FE6CE73194974C0EFC913209611E20247CED8EBBC627
        6BC3E9E19EBF36884E6AEDA6F68E76B60707A571494F97552B21DF5DAF0DEB33
        D135B2B66CA6CF3526FAAF3F44A2D83EA97D94A860E415A3720907F69997C020
        4703CFD8FDC5D82A4D3F2A59CAC3DC47557E85B784E67C1942DA44D9DCC98353
        E83E87F6FB414350DA3BB1D485EDD619EE94D3751EC1F9E54A8E655A0A2952A5
        B0AE025390FAA518423BC602521E30994AF6D98559E9E4D4CC1C4100F08CD449
        173969724E66C3AC40D434B8622739D369D1E52A2388E40006C33FA1E82E6145
        67FA16B69A0FD0CDF5CC86AFCE21B4FB2A17D942A97FCA79F536E46EC241F9ED
        18397CF111C1C6F2A8F928E9EE3FEB4DBB98B968C11454369955CD5F5F68DB5D
        FB424D08452A174D4C98252A8882D6B888C6110360001C0007E307EA52964A94
        6E4C5A2521238522C234C6B198FFD9}
      Proportional = True
      ShowHint = True
      OnClick = ImgSendMessageClick
    end
    object PanelSendMessage: TPanel
      Left = 40
      Top = 7
      Width = 809
      Height = 88
      BevelOuter = bvNone
      TabOrder = 0
      object reMessage: TRichEdit
        Left = 1
        Top = 11
        Width = 801
        Height = 74
        Align = alCustom
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Zoom = 100
        OnChange = reMessageChange
        OnClick = reMessageClick
        OnKeyDown = reMessageKeyDown
        OnKeyPress = reMessageKeyPress
      end
      object STMessageInfo1: TStaticText
        Left = 15
        Top = 22
        Width = 220
        Height = 20
        Caption = 'ctrl+enter '#1087#1077#1088#1077#1093#1086#1076' '#1085#1072' '#1085#1086#1074#1091#1102' '#1089#1090#1088#1086#1095#1082#1091
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object STMessageInfo2: TStaticText
        Left = 15
        Top = 38
        Width = 495
        Height = 20
        Caption = 
          #1076#1083#1103' '#1091#1087#1086#1084#1080#1085#1072#1085#1080#1103' '#1085#1072#1087#1077#1095#1072#1090#1072#1090#1100' @ '#1080' '#1074#1099#1073#1088#1072#1090#1100' '#1085#1091#1078#1085#1086#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1074' '#1088#1072 +
          #1079#1088#1072#1073#1086#1090#1082#1077'...)'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object STMessageInfo3: TStaticText
        Left = 15
        Top = 54
        Width = 665
        Height = 20
        Caption = 
          #1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1083#1080#1095#1085#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1085#1091#1078#1085#1086' 2 '#1088#1072#1079#1072' '#1082#1083#1080#1082#1085#1091#1090#1100' '#1085#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090 +
          #1077#1083#1103' '#1080#1079' '#1089#1087#1080#1089#1082#1072' "'#1054#1085#1083#1072#1081#1085'" ('#1074' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1077'...)'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object Button1: TButton
      Left = 746
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      Visible = False
      OnClick = Button1Click
    end
  end
  object PanelMessage: TPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 419
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object PageChannel: TPageControl
      Left = 0
      Top = 0
      Width = 759
      Height = 419
      ActivePage = sheet_main
      Align = alClient
      TabOrder = 0
      object sheet_main: TTabSheet
        Caption = '  '#1054#1073#1097#1080#1081' '#1095#1072#1090'  '
        object chat_main_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 850
          ExplicitHeight = 460
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_main_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 850
          ExplicitHeight = 460
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_0: TTabSheet
        Caption = 'sheet_0'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_0_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_0_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_2: TTabSheet
        Caption = 'sheet_2'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_2_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_2_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_3: TTabSheet
        Caption = 'sheet_3'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_3_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_3_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_4: TTabSheet
        Caption = 'sheet_4'
        ImageIndex = 4
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_4_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_4_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_5: TTabSheet
        Caption = 'sheet_5'
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_5_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_5_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_6: TTabSheet
        Caption = 'sheet_6'
        ImageIndex = 6
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_6_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_6_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_7: TTabSheet
        Caption = 'sheet_7'
        ImageIndex = 7
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_7_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_7_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_8: TTabSheet
        Caption = 'sheet_8'
        ImageIndex = 8
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_8_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_8_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_9: TTabSheet
        Caption = 'sheet_9'
        ImageIndex = 9
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_9_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_9_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object sheet_1: TTabSheet
        Caption = 'sheet_1'
        ImageIndex = 10
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object chat_1_master: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 1
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object chat_1_slave: TWebBrowser
          Left = 0
          Top = 0
          Width = 751
          Height = 391
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 96
          ExplicitTop = 11
          ExplicitWidth = 850
          ExplicitHeight = 459
          ControlData = {
            4C0000009E4D0000692800000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
  object PanelUsers: TPanel
    Left = 759
    Top = 0
    Width = 168
    Height = 419
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PanelUsersOnline: TPanel
      Left = 1
      Top = 19
      Width = 163
      Height = 398
      BevelInner = bvLowered
      TabOrder = 1
      object ListBoxOnlineUsers: TListBox
        Left = 7
        Top = 15
        Width = 150
        Height = 371
        Style = lbOwnerDrawVariable
        Align = alCustom
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnClick = ListBoxOnlineUsersClick
        OnDblClick = ListBoxOnlineUsersDblClick
      end
    end
    object STUsersOnline: TStaticText
      Left = 23
      Top = 12
      Width = 122
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = #1054#1085#1083#1072#1081#1085
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
