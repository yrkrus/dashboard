unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormHome = class(TForm)
    GroupEnabledReports: TGroupBox;
    lblReportShowRingsOperators: TLabel;
    StatusBar: TStatusBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    STDEBUG: TStaticText;
    lblReportCountRingsOperators: TLabel;
    Label7: TLabel;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation


uses
GlobalVariables, FunctionUnit, FormReportCountRingsOperatorsUnit;


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
  if DEBUG then STDEBUG.Visible:=True;

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
 lblReportCountRingsOperators.Font.Style:=[fsBold];
end;

procedure TFormHome.lblReportCountRingsOperatorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 lblReportCountRingsOperators.Font.Style:=[fsUnderline,fsBold];
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
  lblReportShowRingsOperators.Font.Style:=[fsBold];
end;

procedure TFormHome.lblReportShowRingsOperatorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblReportShowRingsOperators.Font.Style:=[fsUnderline,fsBold];
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
