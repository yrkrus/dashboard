unit FormAboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage, System.ImageList,
  Vcl.ImgList,GlobalVariablesLinkDLL;

type
  TFormAbout = class(TForm)
    lblDevelop: TLabel;
    ImgNewYear: TImage;
    PageInfo: TPageControl;
    sheetGUI: TTabSheet;
    sheetCHAT: TTabSheet;
    Panel1: TPanel;
    REHistory_GUI: TRichEdit;
    STInfoVersionGUI: TStaticText;
    Panel2: TPanel;
    REHistory_CHAT: TRichEdit;
    STInfoVersionCHAT: TStaticText;
    sheetREPORT: TTabSheet;
    STInfoVersionREPORT: TStaticText;
    Panel3: TPanel;
    REHistory_REPORT: TRichEdit;
    sheetSMS: TTabSheet;
    Panel4: TPanel;
    REHistory_SMS: TRichEdit;
    STInfoVersionSMS: TStaticText;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);


    procedure FormCreate(Sender: TObject);
    procedure ShowVersion;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;


implementation

uses
  FunctionUnit, GlobalVariables, TCustomTypeUnit;

{$R *.dfm}

procedure TFormAbout.ShowVersion;
var
 i:Integer;
 prog:enumProrgamm;
begin
  for i:=Ord(Low(enumProrgamm)) to Ord(High(enumProrgamm)) do
  begin
    prog:=enumProrgamm(i);
    showVersionAbout(prog);
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  // отображение истории версий
  ShowVersion;

  lblDevelop.Caption:=GetCopyright;

  Screen.Cursor:=crDefault;
end;



end.
