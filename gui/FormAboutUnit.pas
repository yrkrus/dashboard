unit FormAboutUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TFormAbout = class(TForm)
    imgAbout: TImage;
    lblDevelop: TLabel;
    TimerStartPashalka1: TTimer;
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
    procedure FormShow(Sender: TObject);
    procedure imgAboutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerStartPashalka1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowVersion;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;
  Pashalka:Word;


implementation

uses
  FunctionUnit, GlobalVariables, TCustomTypeUnit;

{$R *.dfm}

procedure TFormAbout.ShowVersion;
begin
  showVersionAbout(eGUI);
  showVersionAbout(eCHAT);
  showVersionAbout(eREPORT);
end;

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerStartPashalka1.Enabled:=False;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  Pashalka:=0;

  // отображение истории версий
  ShowVersion;

  lblDevelop.Caption:=GetCopyright;

  Screen.Cursor:=crDefault;

  TimerStartPashalka1.Enabled:=True;
end;

procedure TFormAbout.imgAboutClick(Sender: TObject);
begin
 Inc(Pashalka);

 if Pashalka=10 then begin
   MessageBox(Handle,PChar('Тут типа должна быть какая то пасхалка, но мне ее лень делать =)'),PChar('У меня так много времени что я кликаю на все подряд'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=50 then begin
   MessageBox(Handle,PChar('Я же говорю мне лень было делать пасхалку, не ищи, ее тут нет'),PChar('Вот это ты ворвался с кликаньем'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=100 then begin
   MessageBox(Handle,PChar('Слашай, прекращай, разработчик серьезно не оставил тут никакой пасхалки!!!'),PChar('Упорство Упорство и еще раз Упорство'),MB_OK+MB_ICONEXCLAMATION);
 end;

 if Pashalka=200 then begin
   MessageBox(Handle,PChar('Ну хорошо, упортсво должны быть вознаграждено, напиши мне в телеграм @yrkrus кодовое слово "хочу мороженку" и я угощю тебя вкусной мороженкой'+#13+'Шутка, с меня конечно же вискарик!!!'),PChar('Мммм... мне бы твое терпение и упоротость'),MB_OK+MB_ICONERROR);
 end;

end;

procedure TFormAbout.TimerStartPashalka1Timer(Sender: TObject);
begin
  SetRandomFontColor(lblDevelop);
end;

end.
