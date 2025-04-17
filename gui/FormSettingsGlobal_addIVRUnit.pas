unit FormSettingsGlobal_addIVRUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus,
  Vcl.Mask, System.DateUtils;

type
  TFormSettingsGlobal_addIVR = class(TForm)
    btnAdd: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    edt5000: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    edt5050: TEdit;
    Label4: TLabel;
    chkboxMyTime: TCheckBox;
    DateQueue: TDateTimePicker;
    TimeQueue: TDateTimePicker;
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt5000KeyPress(Sender: TObject; var Key: Char);
    procedure edt5050KeyPress(Sender: TObject; var Key: Char);
    procedure chkboxMyTimeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettingsGlobal_addIVR: TFormSettingsGlobal_addIVR;

implementation

uses
  FunctionUnit, FormSettingsGlobalUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}

function getResponseBD(InQueue5000,InQueue5050:string; InEditTime:Boolean = False):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
    Screen.Cursor:=crDefault;
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      if not InEditTime then SQL.Add('insert into settings (queue_5000_time,queue_5050_time) values ('+#39+InQueue5000+#39
                                                                                                      +','+#39+InQueue5050+#39+')')
      else begin

       SQL.Add('insert into settings (queue_5000_time,queue_5050_time,date_time) values ('+#39+InQueue5000+#39
                                                                                              +','+#39+InQueue5050+#39
                                                                                              +','+#39+GetDateTimeToDateBD(DateToStr(FormSettingsGlobal_addIVR.DateQueue.Date)+' '+TimeToStr(FormSettingsGlobal_addIVR.TimeQueue.Time))+#39+')');
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             CodOshibki:=e.Message;
             Result:='ОШИБКА! '+CodOshibki;
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Screen.Cursor:=crDefault;
  Result:='OK';
end;


procedure Clear;
begin
  with FormSettingsGlobal_addIVR do begin
    edt5000.Text:='';
    edt5050.Text:='';
  end;
end;

function getCheckFields:string;
var
 DateNachalo,CurrentTime:TDateTime;
begin
  Result:='OK';

  with FormSettingsGlobal_addIVR do begin
    if edt5000.Text='' then begin
       Result:='ОШИБКА! Не заполнено время очереди "5000"';
       Exit;
    end;

    if edt5050.Text='' then begin
       Result:='ОШИБКА! Не заполнено время очереди "5050"';
       Exit;
    end;


    // проверка даты
    if chkboxMyTime.Checked then begin
      DateNachalo:=DateQueue.Date;
      CurrentTime:=Now;

      if DateNachalo>CurrentTime then begin
       Result:='ОШИБКА! Дата не может быть из будущего';
       Exit;

      end;
    end;
  end;
end;


procedure TFormSettingsGlobal_addIVR.btnAddClick(Sender: TObject);
var
  resultat:string;
begin
   resultat:=getCheckFields;
   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;


   // добавляем  
  if not chkboxMyTime.Checked then resultat:=getResponseBD(edt5000.Text,edt5050.Text)
  else resultat:=getResponseBD(edt5000.Text,edt5050.Text,True);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;       

  // обновляем данные в окне настроек
  FormSettingsGlobal.LoadSettings;
  
  Close;
end;

procedure TFormSettingsGlobal_addIVR.chkboxMyTimeClick(Sender: TObject);
begin
 if chkboxMyTime.Checked then begin
  DateQueue.Enabled:=True;
  TimeQueue.Enabled:=True;
 end
 else begin
  DateQueue.Enabled:=False;
  TimeQueue.Enabled:=False;
 end;

end;

procedure TFormSettingsGlobal_addIVR.edt5000KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Not (Key in ['0'..'9'])then Key:=#0;
end;

procedure TFormSettingsGlobal_addIVR.edt5050KeyPress(Sender: TObject;
  var Key: Char);
begin
   if Not (Key in ['0'..'9'])then Key:=#0;
end;

procedure TFormSettingsGlobal_addIVR.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 chkboxMyTime.Checked:=False;
 DateQueue.Enabled:=False;
 TimeQueue.Enabled:=False;
end;

procedure TFormSettingsGlobal_addIVR.FormShow(Sender: TObject);
var
 DateNachalo:TDate;
begin

  //DateNachalo:=EncodeDateTime(YearOf(Now),MonthOf(Now),1, 00,00,01,000);
  //FormatDateTime('yyyy-mm-dd hh:nn:ss',DateNachalo);
  //DateTimeQueue.Value:=DateNachalo;

  //DateTimePicker1.showTime:=True;
  DateQueue.Date:=Now;

  Clear;
end;

end.
