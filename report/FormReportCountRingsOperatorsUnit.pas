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
    m_detailed:Boolean;    // детальный отчет
    procedure FormDefault;
    procedure FormShowOperators;
    procedure FormCenter;
    procedure LoadingListOperators(InShowDisableUsers:Boolean = False); // прогрузка операторов в список

    procedure FinalizationClose;
    function GetCheckValue(var _errorDescription:string):Boolean;  // проверка значений
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
  FormReportCountRingsOperators: TFormReportCountRingsOperators;

implementation

uses
  GlobalVariables, FunctionUnit, FormWaitUnit, TReportCountOperatorsUnit, TAbstractReportUnit;

{$R *.dfm}


function TFormReportCountRingsOperators.GetCheckValue(var _errorDescription: string):Boolean;
var
 i:Integer;
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
    if (dateStop.Date >= Trunc(Now)  ) then begin
     _errorDescription:='В промежутке дат стоит текущий день, для отображения данных по текущему дню надо поставить параметр "только текущий день"';
     Result:=False;
     Exit;
    end;
  end;

  // проверим не забыли ли споставить галки
  if chkboxShowOperators.Checked then begin
    for i:=0 to listOperators.Items.Count-1 do begin
      if listOperators.Checked[i] then begin
         Exit;
      end;
    end;
    _errorDescription:='Установлен параметр "Выбрать операторов", но не один не выбран';
    Result:=False;
  end;

end;

// на случай если не выбрали параметр "выбрать операторов"
procedure TFormReportCountRingsOperators.AllCheckedListOperatorsSip;
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
end;

// прогрузка текущих пользователей
procedure TFormReportCountRingsOperators.LoadingListOperators(InShowDisableUsers:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 only_operators_roleID:TStringList;
 id_operators:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      begin
        only_operators_roleID:=GetOnlyOperatorsRoleID;
        for i:=0 to only_operators_roleID.Count-1 do begin
          if id_operators='' then id_operators:=#39+only_operators_roleID[i]+#39
          else id_operators:=id_operators+','#39+only_operators_roleID[i]+#39;
        end;

        if InShowDisableUsers=False then SQL.Add('select count(id) from users where disabled =''0'' and role IN('+id_operators+') ')
        else SQL.Add('select count(id) from users where disabled =''1'' and role IN('+id_operators+') ');
       if only_operators_roleID<>nil then FreeAndNil(only_operators_roleID);
      end;

      Active:=True;

      countUsers:=Fields[0].Value;
    end;

    listOperators.Clear;

      with ado do begin
        SQL.Clear;
        begin
         if InShowDisableUsers=False then SQL.Add('select familiya,name,id from users where disabled = ''0'' and role IN('+id_operators+') order by familiya ASC')
         else SQL.Add('select familiya,name,id from users where disabled = ''1'' and role IN('+id_operators+') order by familiya ASC');
        end;

        Active:=True;

         for i:=0 to countUsers-1 do begin
           listOperators.Items.Add(getUserSIP(Fields[2].Value)+DELIMITER+ Fields[0].Value+' '+Fields[1].Value);
           ado.Next;
         end;
      end;

  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;

    Screen.Cursor:=crDefault;
  end;
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
  // подгружаем операторов
  LoadingListOperators;

  PanelOperators.Visible:=True;
  btnGenerate.Top:=ShowOperatorsTop;
  Width:=ShowOperatorsWidth;
  Height:=ShowOperatorsHeight;

  // центрируем окно
  FormCenter;
end;


procedure TFormReportCountRingsOperators.FormDefault;
begin
  PanelOperators.Visible:=False;
  btnGenerate.Top:=HideOperatorsButtonTop;
  Width:=HideOperatorsWidth;
  Height:=HideOperatorsHeight;

    // центрируем окно
  FormCenter;
end;



procedure TFormReportCountRingsOperators.btnGenerateClick(Sender: TObject);
var
 report:TReportCountOperators;
 error:string;
 onlyCurrentDay:Boolean;
begin
  onlyCurrentDay:=False;

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


  // создаем отчет
  report:=TReportCountOperators.Create('Отчет по количеству звонков операторами',dateStart,dateStop,onlyCurrentDay,m_detailed);
  report.ShowProgress; //показываем прогресс бар
  report.SetProgressStatusText('Загрузка данных с сервера ...');

  // на случай если не выбрали парметр "выбрать операторов"
  if not chkboxShowOperators.Checked then begin
   LoadingListOperators;
   AllCheckedListOperatorsSip;
  end;


  report.CreateReportExcel(listOperators);

  report.CloseProgress;   // закрываем прогресс бар
  report.ShowExcel;       // ототбражаем данные
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

    // устанавливаем даты
      if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
        MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
  end;
end;

// установка переменной (только подсчет кол-ва звонков)
procedure TFormReportCountRingsOperators.SetDetailed(AValue:Boolean);
begin
  m_detailed:=AValue;
end;

procedure TFormReportCountRingsOperators.chkboxShowAllClick(Sender: TObject);
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

procedure TFormReportCountRingsOperators.chkboxShowOperatorsClick(
  Sender: TObject);
begin
  if chkboxShowOperators.Checked then FormShowOperators
  else FormDefault;
end;

procedure TFormReportCountRingsOperators.chkboxUvolennieClick(Sender: TObject);
begin
  if chkboxUvolennie.Checked then LoadingListOperators(True)
  else LoadingListOperators;
end;

procedure TFormReportCountRingsOperators.FormShow(Sender: TObject);
var
 _errorDescription:string;
begin
  FormDefault;

  // устанавливаем даты
  if not SetFindDate(dateStart,dateStop,_errorDescription) then begin
    MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  btnGenerate.SetFocus;
end;

end.
