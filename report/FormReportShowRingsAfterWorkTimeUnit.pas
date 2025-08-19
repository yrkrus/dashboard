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
  function GetCheckValue(var _errorDescription:string):Boolean;  // �������� ��������
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


// �������� ��������
function TFormReportShowRingsAfterWorkTime.GetCheckValue(var _errorDescription:string):Boolean;
begin
  Result:=True;
  _errorDescription:='';

  // �������� ����� ���� ������ ���� �� ������ ���� ���������
  if dateStart.Date > dateStop.Date then begin
    _errorDescription:='��� �� ��� �� ����� � �������� �� ��������! '+#13#13+'���� ������ ������ ���� ���������';
     Result:=False;
     Exit;
  end;

  // �������� ���� �� �������� ������� ����
  if not chkboxOnlyCurrentDay.Checked then begin
    // �������� ���� �� � ����������� ��� ������� ����
    if (dateStop.Date >= Trunc(Now)) then begin
     _errorDescription:='� ���������� ��� ����� ������� ����, ��� ����������� ������ �� �������� ��� ���� ��������� �������� "������ ������� ����"';
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

  // ��������
  if not GetCheckValue(error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ����� ������ ������� ���
  if chkboxOnlyCurrentDay.Checked then onlyCurrentDay:=True;

  // ����� ��� �� ������ ��������
  if chkboxFindFIO.Checked then findFIO:=True;


  // ������� �����
  report:=TReportShowRingsAfterWorkTime.Create('����� �� ������� ����� �������� �������',dateStart,dateStop,onlyCurrentDay,findFIO);
  report.ShowProgress; //���������� �������� ���
  report.SetProgressStatusText('�������� ������ � ������� ...');

  report.CreateReportExcel;

  report.CloseProgress;   // ��������� �������� ���
  report.ShowExcel;       // ����������� ������
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

    // ������������� ����
      if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
        MessageBox(Handle,PChar(_errorDescription),PChar('������'),MB_OK+MB_ICONERROR);
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
 // ������������� ����
  if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
    MessageBox(Handle,PChar(_errorDescription),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  chkboxOnlyCurrentDay.Caption:='������� ���� ('+DateToStr(now-1)+' � '+DateToStr(now)+')';

  btnGenerate.SetFocus;
end;

end.
