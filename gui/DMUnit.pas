unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TDM = class(TDataModule)
    ImageListIcon_onOff: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
