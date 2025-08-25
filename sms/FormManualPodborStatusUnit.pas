unit FormManualPodborStatusUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, TCustomTypeUnit, Data.DB, Data.Win.ADODB;

type
  TFormManualPodborStatus = class(TForm)
    Label2: TLabel;
    panel_History: TPanel;
    list_History: TListView;
    st_NoSMS: TStaticText;
    GroupBox2: TGroupBox;
    lblS: TLabel;
    lblPo: TLabel;
    dateStart: TDateTimePicker;
    dateStop: TDateTimePicker;
    chkboxOnlyCurrentDay: TCheckBox;
    btnStatus_available: TBitBtn;
    procedure chkboxOnlyCurrentDayClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

   procedure ShowLoading;
   procedure FormDefault;
   procedure ClearListView(var p_ListView:TListView);
   procedure LoadData(_startDate:TDate;
                     _stopDate:TDate;
                     _table:enumReportTableSMSStatus); // прогрузка данных
  procedure ShowSMS(var p_ListView:TListView;
                    _startDate:TDate;
                    _stopDate:TDate;
                    _table:enumReportTableSMSStatus);       // прогрузка отправленных смс

  public
    { Public declarations }
  end;

var
  FormManualPodborStatus: TFormManualPodborStatus;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL;

{$R *.dfm}

procedure TFormManualPodborStatus.ShowLoading;
var
 errorDescription:string;
begin
  FormDefault;

  // прогружаем данные по умолчанию сегодняшний день
  LoadData(Now, Now, eTableSMS);
end;


procedure TFormManualPodborStatus.ClearListView(var p_ListView:TListView);
const
 cWidth_default    :Word = 660;
 cWidth_date       :Word = 25;
 cWidth_phone      :Word = 20;
 cWidth_user       :Word = 58;
begin
 with p_ListView do begin

    Items.Clear;
    Columns.Clear;
    ViewStyle:= vsReport;

    with Columns.Add do
    begin
      Caption:='ID';
      Width:=0;
    end;

    with Columns.Add do
    begin
      Caption:=' Дата\Время отправки ';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Номер телефона ';
      Width:=Round((cWidth_default*cWidth_phone)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Кто отправил ';
      Width:=Round((cWidth_default*cWidth_user)/100);
      Alignment:=taCenter;
    end;

 end;
end;

procedure TFormManualPodborStatus.FormDefault;
var
 errorDescription:string;
begin
  st_NoSMS.Visible:=True;

  chkboxOnlyCurrentDay.Checked:=False;
  chkboxOnlyCurrentDay.Caption:='текущий день ('+DateToStr(now)+')';

  // устанавливаем даты
  if not SetFindDate(dateStart,dateStop,errorDescription) then begin
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
end;

// прогрузка данных
procedure TFormManualPodborStatus.LoadData(_startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus);
begin
  Screen.Cursor:=crHourGlass;

  // очитска листа
  ClearListView(list_History);

  // прогружаем номера
  ShowSMS(list_History,_startDate,_stopDate, _table);

  Screen.Cursor:=crDefault;
end;


// прогрузка отправленных смс
procedure TFormManualPodborStatus.ShowSMS(var p_ListView:TListView;
                                          _startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus);
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  id, dateTime, sip, phone, numberQueue, talkTime:string;
  countCalls:Integer;
  i:Integer;
  response:string;
begin
  ado := TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;

      if _idUser = -1 then response:='select count(id) from queue where hash is not NULL'
      else response:='select count(id) from queue where sip = '+#39+GetUserSIP(_idUser)+#39+ 'and hash is not NULL';

       SQL.Add(response);
      Active := True;
      countCalls := Fields[0].Value;

      if countCalls = 0 then
      begin
        // надпись что нет данных
        st_NoCalls.Visible := True;

        Exit;
      end;

      // скрываем надпись что нет данных
      st_NoCalls.Visible := False;

      SQL.Clear;
      if _idUser = -1 then response:='select id, date_time, sip, phone, number_queue, talk_time from queue where hash is not NULL order by date_time DESC'
      else response:='select id, date_time, sip, phone, number_queue, talk_time from queue where sip = '+#39+GetUserSIP(_idUser)+#39+' and hash is not NULL order by date_time DESC';

      SQL.Add(response);
      Active := True;

      for i := 0 to countCalls - 1 do
      begin

        id          :=VarToStr(Fields[0].Value);
        dateTime    :=VarToStr(Fields[1].Value);
        sip         :=VarToStr(Fields[2].Value);
        phone       :=VarToStr(Fields[3].Value);
        numberQueue :=VarToStr(Fields[4].Value);
        talkTime    :=VarToStr(Fields[5].Value);


        // Элемент не найден, добавляем новый
        AddListItem(id, dateTime,sip, phone, numberQueue, talkTime,
                    isReducedTime,
                    p_ListView);
        ado.Next;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then
    begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


procedure TFormManualPodborStatus.chkboxOnlyCurrentDayClick(Sender: TObject);
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

procedure TFormManualPodborStatus.FormShow(Sender: TObject);
begin
  showWait(show_open);
  ShowLoading;
  showWait(show_close);
end;

end.
