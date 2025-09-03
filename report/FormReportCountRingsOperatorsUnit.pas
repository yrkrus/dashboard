unit FormReportCountRingsOperatorsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.Buttons, Vcl.ExtCtrls, Data.Win.ADODB, Data.DB,  ActiveX, ComObj;

type
  TFormReportCountRingsOperators = class(TForm)
    GroupBox1: TGroupBox;
    dateStart: TDateTimePicker;
    lblS: TLabel;
    lblPo: TLabel;
    dateStop: TDateTimePicker;
    chkboxShowOperators: TCheckBox;
    btnGenerate: TBitBtn;
    PanelOperators: TPanel;
    GroupBox2: TGroupBox;
    listOperators: TCheckListBox;
    chkboxShowAll: TCheckBox;
    chkboxUvolennie: TCheckBox;
    chkboxOnlyCurrentDay: TCheckBox;
    chkboxFindFIO: TCheckBox;
    chkboxStatisticsEveryDay: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure chkboxShowOperatorsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkboxShowAllClick(Sender: TObject);
    procedure chkboxUvolennieClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure chkboxOnlyCurrentDayClick(Sender: TObject);
    procedure SetDetailed(AValue:Boolean);
  private
    { Private declarations }
    m_detailed:Boolean;    // ��������� �����
    procedure FormDefault;
    procedure FormShowOperators;
    procedure FormCenter;

    procedure FinalizationClose;
    function GetCheckValue(var _errorDescription:string):Boolean;   // �������� ��������
    procedure CheckedListOperatorsSip(const _listSipChecked:TStringList); overload; // �� ������ ���� �� ������� �������� "������� ����������"
    procedure CheckedListOperatorsSip; overload;

  public

    { Public declarations }
  end;

const
  ShowOperatorsHeight:Word  = 462;
  ShowOperatorsWidth:Word   = 313;
  ShowOperatorsLeft:Word    = 8;
  ShowOperatorsTop:Word     = 380;

  HideOperatorsButtonTop:Word   = 131;
  HideOperatorsWidth:Word       = 312;
  HideOperatorsHeight:Word      = 215;

var
  FormReportCountRingsOperators: TFormReportCountRingsOperators;

implementation

uses
  GlobalVariables, FunctionUnit, FormWaitUnit, TReportCountOperatorsUnit, TAbstractReportUnit, GlobalVariablesLinkDLL;

{$R *.dfm}


function TFormReportCountRingsOperators.GetCheckValue(var _errorDescription: string):Boolean;
var
 i:Integer;
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
    if (dateStop.Date >= Trunc(Now)  ) then begin
     _errorDescription:='� ���������� ��� ����� ������� ����, ��� ����������� ������ �� �������� ��� ���� ��������� �������� "������ ������� ����"';
     Result:=False;
     Exit;
    end;
  end;

  // �������� �� ������ �� ���������� �����
  if chkboxShowOperators.Checked then begin
    for i:=0 to listOperators.Items.Count-1 do begin
      if listOperators.Checked[i] then begin
         Exit;
      end;
    end;
    _errorDescription:='���������� �������� "������� ����������", �� �� ���� �� ������';
    Result:=False;
  end;

end;

// �� ������ ���� �� ������� �������� "������� ����������"
procedure TFormReportCountRingsOperators.CheckedListOperatorsSip(const _listSipChecked:TStringList);
var
 i,j:Integer;
 sip:string;
begin
  // ������� �� ������ ������ listBox
  for i:=0 to listOperators.Count-1 do begin
    if listOperators.Checked[i] then listOperators.Checked[i]:=False;
  end;

  for i:=0 to listOperators.Count-1 do begin
    for j:=0 to _listSipChecked.Count-1 do begin

      sip:=listOperators.Items[i];
      System.Delete(sip,1,AnsiPos('(',sip));
      System.Delete(sip,AnsiPos(')',sip),Length(sip));

      if _listSipChecked[j] = sip then  begin
        listOperators.Checked[i]:=True;
        Break;
      end;
    end;
  end;
end;


// �� ������ ���� �� ������� �������� "������� ����������"
procedure TFormReportCountRingsOperators.CheckedListOperatorsSip;
var
 i:Integer;
begin
  for i:=0 to listOperators.Count-1 do begin
    if not listOperators.Checked[i] then listOperators.Checked[i]:=True;
  end;
end;


procedure TFormReportCountRingsOperators.FinalizationClose;
begin
 chkboxShowOperators.Checked:=False;
 chkboxUvolennie.Checked:=False;
 chkboxShowAll.Checked:=False;
 chkboxOnlyCurrentDay.Checked:=False;
 chkboxFindFIO.Checked:=False;
end;



procedure TFormReportCountRingsOperators.FormCenter;
begin
  Left:=(Screen.Width - Width) div 2;
  Top:=(Screen.Height - Height) div 2;
end;


procedure TFormReportCountRingsOperators.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 FinalizationClose;
end;

procedure TFormReportCountRingsOperators.FormShowOperators;
begin
  // ���������� ����������
  LoadingListOperatorsForm(listOperators);

  PanelOperators.Visible:=True;
  btnGenerate.Top:=ShowOperatorsTop;
  Width:=ShowOperatorsWidth;
  Height:=ShowOperatorsHeight;

  // ���������� ����
  FormCenter;
end;


procedure TFormReportCountRingsOperators.FormDefault;
const
 cLEFT:Word = 10;
begin
  PanelOperators.Visible:=False;
  btnGenerate.Top:=HideOperatorsButtonTop;
  Width:=HideOperatorsWidth;
  Height:=HideOperatorsHeight;
  chkboxFindFIO.Checked:=False;
  chkboxStatisticsEveryDay.Checked:=False;

  // ��������� �����
  if m_detailed then begin
   // ������������� ������ �� ������ ��������
   chkboxFindFIO.Visible:=True;
   chkboxFindFIO.Left:=cLEFT;

   // ������� ������ �� ����
   chkboxStatisticsEveryDay.Visible:=False;
  end
  else begin
   // ������� ������ �� ����
   chkboxStatisticsEveryDay.Visible:=True;
   chkboxStatisticsEveryDay.Left:=cLEFT;

   // ������������� ������ �� ������ ��������
   chkboxFindFIO.Visible:=False;
  end;

  chkboxShowAll.Checked:=False;

    // ���������� ����
  FormCenter;
end;



procedure TFormReportCountRingsOperators.btnGenerateClick(Sender: TObject);
var
 report:TReportCountOperators;
 error:string;
 onlyCurrentDay:Boolean;
 findFIO:Boolean;
 statEveryDay:Boolean;
 listSip:TStringList;
begin
  onlyCurrentDay:=False;
  findFIO:=False;
  statEveryDay:=False;

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

  // ����� ���
  if chkboxFindFIO.Checked then findFIO:=True;

   // ������� ��������� �� ������� �� ������ ����
  if chkboxStatisticsEveryDay.Checked then statEveryDay:=True;

  // ������� �����
  report:=TReportCountOperators.Create('����� �� ���������� ������� �����������',
                                       dateStart,
                                       dateStop,
                                       onlyCurrentDay,
                                       m_detailed,
                                       findFIO,
                                       statEveryDay);


  report.ShowProgress; //���������� �������� ���
  report.SetProgressStatusText('�������� ������ � �������');

  // �� ������ ���� �� ������� ������� "������� ����������"
  if not chkboxShowOperators.Checked then begin
   // ������� ������ sip ������� ������������� �� ������ ���
   listSip:=TStringList.Create;

   LoadingListOperatorsForm(listOperators); // ���������� ����������

   if not onlyCurrentDay then begin
     FindSipCallOperators(listSip,dateStart.Date,dateStop.Date);
     // ������� ������ sip
     CheckedListOperatorsSip(listSip);
   end
   else CheckedListOperatorsSip;
  end;

  report.CreateReportExcel(listOperators);

  report.CloseProgress;   // ��������� �������� ���
  report.ShowExcel;       // ����������� ������
end;

procedure TFormReportCountRingsOperators.chkboxOnlyCurrentDayClick(
  Sender: TObject);
var
 _errorDescription:string;
begin
  if chkboxOnlyCurrentDay.Checked then begin
    lblS.Enabled:=False;
    dateStart.Enabled:=False;
    lblPo.Enabled:=False;
    dateStop.Enabled:=False;

    dateStart.Date:=Now;
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

// ��������� ���������� (������ ������� ���-�� �������)
procedure TFormReportCountRingsOperators.SetDetailed(AValue:Boolean);
begin
  m_detailed:=AValue;
end;

procedure TFormReportCountRingsOperators.chkboxShowAllClick(Sender: TObject);
var
 i:Integer;
begin
  if chkboxShowAll.Checked then begin
   CheckedListOperatorsSip;
  end
  else begin
   for i:=0 to listOperators.Count-1 do begin
     if listOperators.Checked[i] then listOperators.Checked[i]:=False;
   end;
  end;
end;

procedure TFormReportCountRingsOperators.chkboxShowOperatorsClick(
  Sender: TObject);
begin
  if chkboxShowOperators.Checked then FormShowOperators
  else FormDefault;
end;

procedure TFormReportCountRingsOperators.chkboxUvolennieClick(Sender: TObject);
begin
  if chkboxUvolennie.Checked then LoadingListOperatorsForm(listOperators,True)
  else LoadingListOperatorsForm(listOperators);
end;

procedure TFormReportCountRingsOperators.FormShow(Sender: TObject);
var
 _errorDescription:string;
begin
  FormDefault;

  // ������������� ����
  if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
    MessageBox(Handle,PChar(_errorDescription),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  chkboxOnlyCurrentDay.Caption:='������� ���� ('+DateToStr(now)+')';

  btnGenerate.SetFocus;
end;

end.
