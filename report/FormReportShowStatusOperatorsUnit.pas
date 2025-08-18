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
     procedure LoadingListOperators(InShowDisableUsers:Boolean = False); // прогрузка операторов в список
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
        MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
  end;
end;


// прогрузка текущих пользователей
procedure TFormReportShowStatusOperators.LoadingListOperators(InShowDisableUsers:Boolean = False);
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
           listOperators.Items.Add(Fields[0].Value+' '+Fields[1].Value + '('+getUserSIP(Fields[2].Value)+')');
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


procedure TFormReportShowStatusOperators.FormShowOperators;
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
    MessageBox(Handle,PChar(_errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  chkboxOnlyCurrentDay.Caption:='текущий день ('+DateToStr(now)+')';

  btnGenerate.SetFocus;
end;

end.
