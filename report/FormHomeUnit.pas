unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TFormHome = class(TForm)
    StatusBar: TStatusBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    lblReportCountRingsOperators: TLabel;
    lblReportShowRingsOperators: TLabel;
    lblReportShowRingsAfterWorkTime: TLabel;
    Image0: TImage;
    Image1: TImage;
    Image2: TImage;
    ImageLogo: TImage;
    ImgNewYear: TImage;
    lblReportShowStatusOperators: TLabel;
    Image3: TImage;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblReportShowRingsOperatorsClick(Sender: TObject);
    procedure lblReportShowRingsOperatorsMouseLeave(Sender: TObject);
    procedure lblReportShowRingsOperatorsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblReportCountRingsOperatorsClick(Sender: TObject);
    procedure lblReportCountRingsOperatorsMouseLeave(Sender: TObject);
    procedure lblReportCountRingsOperatorsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblReportShowRingsAfterWorkTimeMouseLeave(Sender: TObject);
    procedure lblReportShowRingsAfterWorkTimeMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblReportShowRingsAfterWorkTimeClick(Sender: TObject);
    procedure lblReportShowStatusOperatorsMouseLeave(Sender: TObject);
    procedure lblReportShowStatusOperatorsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblReportShowStatusOperatorsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation


uses
GlobalVariables, FunctionUnit, FormReportCountRingsOperatorsUnit, GlobalVariablesLinkDLL, TCustomTypeUnit, FormReportShowRingsAfterWorkTimeUnit, FormReportShowStatusOperatorsUnit;


{$R *.dfm}

procedure TFormHome.FormCreate(Sender: TObject);
begin
   // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(REPORT_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии отчетов'+#13#13+
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;

procedure TFormHome.FormShow(Sender: TObject);
var
 error:string;
begin
  // debug node
  if DEBUG then Caption:='    ===== DEBUG =====    '+Caption;

  // создатим copyright
  createCopyright;

  // проаерка существует ли excel
  if not isExistExcel(error) then begin
   MessageBox(Handle,PChar('Excel не установлен'+#13#13+error),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;
end;

procedure TFormHome.lblReportCountRingsOperatorsClick(Sender: TObject);
begin
  with FormReportCountRingsOperators do begin
    SetDetailed(False);
    ShowModal;
  end;
end;

procedure TFormHome.lblReportCountRingsOperatorsMouseLeave(Sender: TObject);
begin
 CursourHover(lblReportCountRingsOperators, eMouseLeave);
end;

procedure TFormHome.lblReportCountRingsOperatorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 CursourHover(lblReportCountRingsOperators, eMouseMove);
end;

procedure TFormHome.lblReportShowRingsAfterWorkTimeClick(Sender: TObject);
begin
  FormReportShowRingsAfterWorkTime.ShowModal;
end;

procedure TFormHome.lblReportShowRingsAfterWorkTimeMouseLeave(Sender: TObject);
begin
  CursourHover(lblReportShowRingsAfterWorkTime,eMouseLeave);
end;

procedure TFormHome.lblReportShowRingsAfterWorkTimeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 CursourHover(lblReportShowRingsAfterWorkTime,eMouseMove);
end;

procedure TFormHome.lblReportShowRingsOperatorsClick(Sender: TObject);
begin
   with FormReportCountRingsOperators do begin
    SetDetailed(True);
    ShowModal;
  end;
end;

procedure TFormHome.lblReportShowRingsOperatorsMouseLeave(Sender: TObject);
begin
  CursourHover(lblReportShowRingsOperators, eMouseLeave);
end;

procedure TFormHome.lblReportShowRingsOperatorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  CursourHover(lblReportShowRingsOperators, eMouseMove);
end;

procedure TFormHome.lblReportShowStatusOperatorsClick(Sender: TObject);
begin
 FormReportShowStatusOperators.ShowModal;
end;

procedure TFormHome.lblReportShowStatusOperatorsMouseLeave(Sender: TObject);
begin
 CursourHover(lblReportShowStatusOperators,eMouseLeave);
end;

procedure TFormHome.lblReportShowStatusOperatorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  CursourHover(lblReportShowStatusOperators,eMouseMove);
end;

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_REPORT_ID:=1;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('Отчеты можно запустить только из дашборда'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_REPORT_ID:= StrToInt(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;


end.
