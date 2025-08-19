unit FormReportShowStatusOperatorsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.Buttons, Vcl.ExtCtrls, Data.Win.ADODB, Data.DB,  ActiveX, ComObj;

type
  TFormReportShowStatusOperators = class(TForm)
    GroupBox1: TGroupBox;
    lblS: TLabel;
    lblPo: TLabel;
    dateStart: TDateTimePicker;
    dateStop: TDateTimePicker;
    chkboxOnlyCurrentDay: TCheckBox;
    chkboxShowOperators: TCheckBox;
    btnGenerate: TBitBtn;
    PanelOperators: TPanel;
    GroupBox2: TGroupBox;
    listOperators: TCheckListBox;
    chkboxShowAll: TCheckBox;
    chkboxUvolennie: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure chkboxOnlyCurrentDayClick(Sender: TObject);
    procedure chkboxShowOperatorsClick(Sender: TObject);
    procedure chkboxShowAllClick(Sender: TObject);
  private
    { Private declarations }
     procedure FormDefault;
     procedure FormCenter;
     procedure FormShowOperators;
     procedure AllCheckedListOperatorsSip;   // на случай если не выбрали параметр "выбрать операторов"
  public
    { Public declarations }
  end;

  const
  ShowOperatorsHeight:Word  = 448;
  ShowOperatorsWidth:Word   = 313;
  ShowOperatorsLeft:Word    = 8;
  ShowOperatorsTop:Word     = 367;

  HideOperatorsButtonTop:Word   = 119;
  HideOperatorsWidth:Word       = 312;
  HideOperatorsHeight:Word      = 204;

var
  FormReportShowStatusOperators: TFormReportShowStatusOperators;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL;

{$R *.dfm}

procedure TFormReportShowStatusOperators.FormDefault;
begin
  PanelOperators.Visible:=False;
  btnGenerate.Top:=HideOperatorsButtonTop;
  Width:=HideOperatorsWidth;
  Height:=HideOperatorsHeight;

    // центрируем окно
  FormCenter;
end;

procedure TFormReportShowStatusOperators.chkboxOnlyCurrentDayClick(
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

    // устанавливаем даты
      if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
        MessageBox(Handle,PChar(_errorDescription),PChar('ќшибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
  end;
end;



procedure TFormReportShowStatusOperators.FormShowOperators;
begin
  // подгружаем операторов
  LoadingListOperatorsForm(listOperators);

  PanelOperators.Visible:=True;
  btnGenerate.Top:=ShowOperatorsTop;
  Width:=ShowOperatorsWidth;
  Height:=ShowOperatorsHeight;

  // центрируем окно
  FormCenter;
end;

// на случай если не выбрали параметр "выбрать операторов"
procedure TFormReportShowStatusOperators.AllCheckedListOperatorsSip;
var
 i:Integer;
begin
  for i:=0 to listOperators.Count-1 do begin
    if not listOperators.Checked[i] then listOperators.Checked[i]:=True;
  end;
end;

procedure TFormReportShowStatusOperators.chkboxShowAllClick(Sender: TObject);
var
 i:Integer;
begin
  if chkboxShowAll.Checked then begin
   AllCheckedListOperatorsSip;
  end
  else begin
   for i:=0 to listOperators.Count-1 do begin
     if listOperators.Checked[i] then listOperators.Checked[i]:=False;
   end;
  end;
end;

procedure TFormReportShowStatusOperators.chkboxShowOperatorsClick(
  Sender: TObject);
begin
  if chkboxShowOperators.Checked then FormShowOperators
  else FormDefault;
end;

procedure TFormReportShowStatusOperators.FormCenter;
begin
  Left:=(Screen.Width - Width) div 2;
  Top:=(Screen.Height - Height) div 2;
end;

procedure TFormReportShowStatusOperators.FormShow(Sender: TObject);
var
 _errorDescription:string;
begin
  FormDefault;

  // устанавливаем даты
  if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
    MessageBox(Handle,PChar(_errorDescription),PChar('ќшибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  chkboxOnlyCurrentDay.Caption:='текущий день ('+DateToStr(now)+')';

  btnGenerate.SetFocus;
end;

end.
