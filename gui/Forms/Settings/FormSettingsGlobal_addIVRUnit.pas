unit FormSettingsGlobal_addIVRUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus,
  Vcl.Mask, System.DateUtils, TIVRTimeUnit;

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
    DateQueue: TDateTimePicker;
    TimeQueue: TDateTimePicker;
    Label1: TLabel;
    edt5911: TEdit;
    StaticText3: TStaticText;
    lbl_checkbox_MyTime: TLabel;
    img_MyTime: TImage;
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt5000KeyPress(Sender: TObject; var Key: Char);
    procedure edt5050KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt5911KeyPress(Sender: TObject; var Key: Char);
    procedure lbl_checkbox_MyTimeClick(Sender: TObject);
    procedure img_MyTimeClick(Sender: TObject);
  private
    { Private declarations }
  m_ivrTime:TIVRTime;
  function GetCheckFields(var _errorDescription:string):Boolean;
  function Insert(_anyTime:Boolean; var _errorDescription:string):Boolean;

  procedure ChangeMyTime;

  public
    { Public declarations }
  end;

var
  FormSettingsGlobal_addIVR: TFormSettingsGlobal_addIVR;

implementation

uses
  FunctionUnit, FormSettingsGlobalUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}


procedure Clear;
begin
  with FormSettingsGlobal_addIVR do begin
    edt5000.Text:='';
    edt5050.Text:='';
    edt5911.Text:='';
  end;
end;

function TFormSettingsGlobal_addIVR.GetCheckFields(var _errorDescription:string):Boolean;
var
 dtPicker: TDateTimePicker; // Kind = dtkDate
 tmPicker: TDateTimePicker; // Kind = dtkTime
 combined: TDateTime;
 unixTime,unixCurrentTime:Int64;
begin
  Result:=false;
  _errorDescription:='';

  begin
    if edt5000.Text='' then begin
       _errorDescription:='ОШИБКА! Не заполнено время очереди "5000"';
       Exit;
    end;

    if edt5050.Text='' then begin
       _errorDescription:='ОШИБКА! Не заполнено время очереди "5050"';
       Exit;
    end;

    if edt5911.Text='' then begin
       _errorDescription:='ОШИБКА! Не заполнено время очереди "5911"';
       Exit;
    end;
  end;

  // проверка даты
  if SharedCheckBoxUI.Checked['MyTime'] then begin
    combined := Trunc(DateQueue.DateTime)        // только «дата» в виде целого
              + Frac(TimeQueue.DateTime);        // только время в виде дробной части

    unixTime:=DateTimeToUnix(combined);
    unixCurrentTime:=DateTimeToUnix(Now);

    if unixTime>unixCurrentTime then begin
     _errorDescription:='ОШИБКА! Дата не может быть из будущего';
     Exit;
    end;
  end;

  Result:=True;
end;

procedure TFormSettingsGlobal_addIVR.img_MyTimeClick(Sender: TObject);
begin
  ChangeMyTime;
end;

procedure TFormSettingsGlobal_addIVR.ChangeMyTime;
begin
 SharedCheckBoxUI.ChangeStatusCheckBox('MyTime');

 if SharedCheckBoxUI.Checked['MyTime'] then begin
  DateQueue.Enabled:=True;
  TimeQueue.Enabled:=True;
 end
 else begin
  DateQueue.Enabled:=False;
  TimeQueue.Enabled:=False;
 end;
end;


function TFormSettingsGlobal_addIVR.Insert(_anyTime:Boolean; var _errorDescription:string):Boolean;
var
 dateTime:string;
begin
  Screen.Cursor:=crHourGlass;
  Result:=False;
  _errorDescription:='';

  if not _anyTime then Result:=m_ivrTime.Insert(edt5000.Text,edt5050.Text,edt5911.Text,_errorDescription)
  else begin
   with FormSettingsGlobal_addIVR do begin
     dateTime:=GetDateTimeToDateBD(DateToStr(DateQueue.Date)+' '+TimeToStr(TimeQueue.Time));
   end;
   Result:=m_ivrTime.Insert(edt5000.Text,edt5050.Text,edt5911.Text,dateTime,_errorDescription);
  end;

  Screen.Cursor:=crDefault;
end;


procedure TFormSettingsGlobal_addIVR.lbl_checkbox_MyTimeClick(Sender: TObject);
begin
  ChangeMyTime;
end;

procedure TFormSettingsGlobal_addIVR.btnAddClick(Sender: TObject);
var
  error:string;
  anyTime:Boolean;
begin
   if not GetCheckFields(error) then begin
     MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   // добавляем
  anyTime:=SharedCheckBoxUI.Checked['MyTime'];

  if not (Insert(anyTime,error)) then begin
    // не удалось добавить
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  // обновляем данные в окне настроек
  FormSettingsGlobal.LoadSettings;
  
  Close;
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

procedure TFormSettingsGlobal_addIVR.edt5911KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Not (Key in ['0'..'9'])then Key:=#0;
end;

procedure TFormSettingsGlobal_addIVR.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SharedCheckBoxUI.Checked['MyTime']:=False;
 DateQueue.Enabled:=False;
 TimeQueue.Enabled:=False;
end;

procedure TFormSettingsGlobal_addIVR.FormShow(Sender: TObject);
var
 DateNachalo:TDate;
begin

  if not Assigned(m_ivrTime) then m_ivrTime:=TIVRTime.Create
  else m_ivrTime.UpdateTime;

  DateQueue.Date:=Now;

  Clear;
end;

end.
