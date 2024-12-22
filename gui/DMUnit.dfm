object DM: TDM
  OldCreateOrder = False
  Height = 432
  Width = 498
  object ADOQuerySelect_Stat_queue_5000: TADOQuery
    Parameters = <>
    Left = 88
    Top = 90
  end
  object ADOQuerySelect_Stat_queue_5050: TADOQuery
    Parameters = <>
    Left = 88
    Top = 154
  end
  object ADOQuerySelect_Stat_Day_Answered: TADOQuery
    Parameters = <>
    Left = 88
    Top = 210
  end
  object ADOQuerySelect_Stat_Day_No_Answered: TADOQuery
    Parameters = <>
    Left = 90
    Top = 268
  end
  object ADOQuerySelect_Propushennie: TADOQuery
    Parameters = <>
    Left = 85
    Top = 15
  end
  object pFIBDatabase1: TpFIBDatabase
    DBName = '10.34.222.88/3050:'
    DBParams.Strings = (
      'password=PDNTP'
      'user_name=CHEA'
      'lc_ctype=WIN1251')
    SQLDialect = 3
    Timeout = 0
    AliasName = 'A_MAIN_034_0018'
    WaitForRestoreConnect = 0
    SaveAliasParamsAfterConnect = False
    Left = 288
    Top = 64
  end
end
