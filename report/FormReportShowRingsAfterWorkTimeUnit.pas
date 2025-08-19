unit FormReportShowRingsAfterWorkTimeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.DateUtils;

type
  TFormReportShowRingsAfterWorkTime = class(TForm)
    GroupBox1: TGroupBox;
    lblS: TLabel;
    lblPo: TLabel;
    dateStart: TDateTimePicker;
    dateStop: TDateTimePicker;
    chkboxOnlyCurrentDay: TCheckBox;
    btnGenerate: TBitBtn;
    chkboxFindFIO: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure chkboxOnlyCurrentDayClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  function GetCheckValue(var _errorDescription:string):Boolean;  // проверка значений
  procedure FinalizationClose;


  public
    { Public declarations }
  end;

var
  FormReportShowRingsAfterWorkTime: TFormReportShowRingsAfterWorkTime;

implementation

uses
  FunctionUnit, TReportShowRingsAfterWorkTimeUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}


procedure TFormReportShowRingsAfterWorkTime.FinalizationClose;
begin
 chkboxOnlyCurrentDay.Checked:=False;
 chkboxFindFIO.Checked:=False;
end;


// проверка значений
function TFormReportShowRingsAfterWorkTime.GetCheckValue(var _errorDescription:string):Boolean;
begin
  Result:=True;
  _errorDescription:='';

  // проверка чтобы дата начала была не больше даты окночания
  if dateStart.Date > dateStop.Date then begin
    _errorDescription:='Что то как то дебет с кредитом не сходится! '+#13#13+'Дата начала больше даты окончания';
     Result:=False;
     Exit;
  end;

  // проверим есть ли параметр текущий день
  if not chkboxOnlyCurrentDay.Checked then begin
    // проверим есть ли в проимежутке дат текущий день
    if (dateStop.Date >= Trunc(Now)) then begin
     _errorDescription:='В промежутке дат стоит текущий день, для отображения данных по текущему дню надо поставить параметр "только текущий день"';
     Result:=False;
     Exit;
    end;
  end;
end;

procedure TFormReportShowRingsAfterWorkTime.btnGenerateClick(Sender: TObject);
var
 report: TReportShowRingsAfterWorkTime;
 error:string;
 onlyCurrentDay:Boolean;
 findFIO:Boolean;
begin
  onlyCurrentDay:=False;
  findFIO:=False;

  if DEBUG then begin
    while (GetTask('EXCEL.EXE')) do KillTask('EXCEL.EXE');
  end;

  // проверка
  if not GetCheckValue(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // показ только текщего дня
  if chkboxOnlyCurrentDay.Checked then onlyCurrentDay:=True;

  // поиск ФИО по номеру телефона
  if chkboxFindFIO.Checked then findFIO:=True;


  // создаем отчет
  report:=TReportShowRingsAfterWorkTime.Create('Отчет по звонкам после рабочего времени',dateStart,dateStop,onlyCurrentDay,findFIO);
  report.ShowProgress; //показываем прогресс бар
  report.SetProgressStatusText('Загрузка данных с сервера ...');

  report.CreateReportExcel;

  report.CloseProgress;   // закрываем прогресс бар
  report.ShowExcel;       // ототбражаем данные
end;

procedure TFormReportShowRingsAfterWorkTime.chkboxOnlyCurrentDayClick(
  Sender: TObject);
var
 _errorDescription:string;
begin
  if chkboxOnlyCurrentDay.Checked then begin
    lblS.Enabled:=False;
    dateStart.Enabled:=False;
    lblPo.Enabled:=False;
    dateStop.Enabled:=False;

    dateStart.Date:=Now-1;
    dateStop.Date:=Now;

  end
  else begin
    lblS.Enabled:=True;

    dateStart.Enabled:=True;
    lblPo.Enabled:=True;
    dateStop.Enabled:=True;

    // устанавливаем даты
      if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
        MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
  end;
end;

procedure TFormReportShowRingsAfterWorkTime.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 FinalizationClose;
end;


procedure TFormReportShowRingsAfterWorkTime.FormShow(Sender: TObject);
var
 _errorDescription:string;
begin
 // устанавливаем даты
  if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
    MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  chkboxOnlyCurrentDay.Caption:='текущий день ('+DateToStr(now-1)+' и '+DateToStr(now)+')';

  btnGenerate.SetFocus;
end;

end.
