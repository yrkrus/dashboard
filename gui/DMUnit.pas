unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB, IdBaseComponent,
  IdComponent, IdRawBase, IdRawClient, IdIcmpClient, FIBDatabase, pFIBDatabase;

type
  TDM = class(TDataModule)
    ADOQuerySelect_Stat_queue_5000: TADOQuery;
    ADOQuerySelect_Stat_queue_5050: TADOQuery;
    ADOQuerySelect_Stat_Day_Answered: TADOQuery;
    ADOQuerySelect_Stat_Day_No_Answered: TADOQuery;
    ADOQuerySelect_Propushennie: TADOQuery;
    pFIBDatabase1: TpFIBDatabase;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  FunctionUnit, FormHome;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
