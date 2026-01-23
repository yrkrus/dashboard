unit FormManualPodborStatusUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, TCustomTypeUnit, Data.DB, Data.Win.ADODB, Vcl.Menus;

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
    btnStatus_available: TBitBtn;
    popmenu_FindStatus: TPopupMenu;
    popmenu_ActionShowStatus: TMenuItem;
    img_ShowErrorSendindSMS: TImage;
    chkbox_ShowErrorSendindSMS: TLabel;
    menu_FIO: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnStatus_availableClick(Sender: TObject);
    procedure list_HistoryDblClick(Sender: TObject);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure popmenu_ActionShowStatusClick(Sender: TObject);
    procedure list_HistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkbox_ShowErrorSendindSMSClick(Sender: TObject);
    procedure img_ShowErrorSendindSMSClick(Sender: TObject);
    procedure menu_FIOClick(Sender: TObject);
  private
    { Private declarations }
   SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента(для popmenu_ActionShowStatus)

   procedure ShowLoading(_showOnlyError:Boolean);
   procedure FormDefault;
   procedure ClearListView(var p_ListView:TListView);
   procedure LoadData(_startDate:TDate;
                     _stopDate:TDate;
                     _table:enumReportTableSMSStatus;
                     _onlyError:Boolean); // прогрузка данных
   procedure ShowSMS(var p_ListView:TListView;
                    _startDate:TDate;
                    _stopDate:TDate;
                    _table:enumReportTableSMSStatus;
                    _onlyError:Boolean);       // прогрузка отправленных смс
   procedure AddListItem(const _id, _dateTime, _phone, _code, _userId: string;
                         var p_ListView: TListView);

   function Check(var _errorDescription:string):Boolean;  // проверка

   procedure ShowErrorSending;  // показ только смс с ошибками

  public
    { Public declarations }
  end;

var
  FormManualPodborStatus: TFormManualPodborStatus;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, FormHomeUnit, GlobalVariables, FormStatusSendingSMSUnit, TAutoPodborPeopleUnit,
  FormPropushennieShowPeopleUnit;

{$R *.dfm}

procedure TFormManualPodborStatus.ShowLoading(_showOnlyError:Boolean);
var
 errorDescription:string;
begin
  FormDefault;

  // прогружаем данные по умолчанию сегодняшний день
  LoadData(Now, Now, eTableSMS, _showOnlyError);
end;



procedure TFormManualPodborStatus.AddListItem(const _id, _dateTime, _phone, _code, _userId: string;
                                              var p_ListView: TListView);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := _id;          // id
  ListItem.SubItems.Add(_dateTime); // дата время
  ListItem.SubItems.Add(_phone);    // номер телефона
  ListItem.SubItems.Add(_code);     // код статуса
  ListItem.SubItems.Add(GetUserNameFIO(StrToInt(_userId))); // кто отправил
end;

// проверка
function TFormManualPodborStatus.Check(var _errorDescription:string):Boolean;
begin
  Result:=False;
  // проверка чтобы дата начала была не больше даты окночания
  if dateStart.Date > dateStop.Date then begin
    _errorDescription:='Что то как то дебет с кредитом не сходится! '+#13#13+'Дата начала больше даты окончания';
    Exit;
  end;

  Result:=True;
end;

procedure TFormManualPodborStatus.chkbox_ShowErrorSendindSMSClick(
  Sender: TObject);
begin
  ShowErrorSending;
end;

// показ только смс с ошибками
procedure TFormManualPodborStatus.ShowErrorSending;
var
 showError:Boolean;
begin
  SharedCheckBox.ChangeStatusCheckBox('ShowErrorSendindSMS');
  showError:=SharedCheckBox.Checked['ShowErrorSendindSMS'];

  showWait(show_open);
  ShowLoading(showError);
  showWait(show_close);
end;


procedure TFormManualPodborStatus.ClearListView(var p_ListView:TListView);
const
 cWidth_default    :Word = 540;
 cWidth_date       :Word = 28;
 cWidth_phone      :Word = 22;
 cWidth_code       :Word = 17;
 cWidth_user       :Word = 30;
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
      Caption:=' Код статуса ';
      Width:=Round((cWidth_default*cWidth_code)/100);
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

procedure TFormManualPodborStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // выключаем параметр
  SharedCheckBox.ChangeStatusCheckBox('ShowErrorSendindSMS',paramStatus_DISABLED);
end;

procedure TFormManualPodborStatus.FormDefault;
var
 errorDescription:string;
begin
  // устанавливаем даты
  if not SetFindDate(dateStart,dateStop,errorDescription) then begin
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
end;

// прогрузка данных
procedure TFormManualPodborStatus.LoadData(_startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus;
                                          _onlyError:Boolean);
begin
  Screen.Cursor:=crHourGlass;

  // очитска листа
  ClearListView(list_History);

  // прогружаем номера
  ShowSMS(list_History,_startDate,_stopDate, _table, _onlyError);

  Screen.Cursor:=crDefault;
end;


procedure TFormManualPodborStatus.menu_FIOClick(Sender: TObject);
var
 people:TAutoPodborPeople;
 phonePodbor:string;
begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран номер'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  phonePodbor:= SelectedItemPopMenu.SubItems[1];
  phonePodbor:=StringReplace(phonePodbor,'+7','8',[rfReplaceAll]);

  ShowWait(show_open);
  people:=TAutoPodborPeople.Create(phonePodbor, False);

  FormPropushennieShowPeople.SetListPacients(people);
  ShowWait(show_close);

  FormPropushennieShowPeople.ShowModal;
end;

procedure TFormManualPodborStatus.popmenu_ActionShowStatusClick(
  Sender: TObject);
var
  phone:string;
begin
  // Проверяем, был ли выбран элемент
  if Assigned(SelectedItemPopMenu) then
  begin
     phone:=SelectedItemPopMenu.SubItems[1];

     SharedStatusSendingSMS.Clear;
     SharedStatusSendingSMS.Add(phone);

      with FormStatusSendingSMS do begin
        SetSmsInfo(SharedStatusSendingSMS[0]);
        ShowModal;
      end;
  end
  else
  begin
   MessageBox(Handle,PChar('Не выбран номер телефона'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;



// прогрузка отправленных смс
procedure TFormManualPodborStatus.ShowSMS(var p_ListView:TListView;
                                          _startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus;
                                          _onlyError:Boolean);
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  countSMS:Integer;
  i:Integer;
  id,dateTime,phone,codeStatus,userID:string;
  table:string;
  response:TStringBuilder;
begin
  ado := TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  table:=EnumReportTableSMSToString(_table);
  response:=TStringBuilder.Create;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;
      with response do begin
        Append('select count(id) from '+table);
        Append(' where date_time >='+#39+GetDateToDateBD(DateToStr(_startDate))+' 00:00:00'+#39);
        Append(' and date_time <='+#39+GetDateToDateBD(DateToStr(_stopDate))+' 23:59:59'+#39);
        Append(' and user_id not IN (''-1'',''0'') ');
        if _onlyError then begin
          Append(' and status not IN (''3'') ');
        end;
      end;

      SQL.Add(response.ToString);
      Active := True;

      countSMS := Fields[0].Value;

      if countSMS = 0 then
      begin
        // надпись что нет данных
        st_NoSMS.Visible:=True;

        Exit;
      end;

      // скрываем надпись что нет данных
      st_NoSMS.Visible:=False;

      SQL.Clear;
      with response do begin
        Clear;
        Append('select id,date_time,phone,status,user_id from '+table);
        Append(' where date_time >='+#39+GetDateToDateBD(DateToStr(_startDate))+' 00:00:00'+#39);
        Append(' and date_time <='+#39+GetDateToDateBD(DateToStr(_stopDate))+' 23:59:59'+#39);
        Append(' and user_id not IN (''-1'',''0'')');
        if _onlyError then begin
          Append(' and status not IN (''3'') ');
        end;
        Append(' order by date_time DESC');
      end;

      SQL.Add(response.ToString);
      Active:=True;

      for i:= 0 to countSMS - 1 do
      begin

        id:=VarToStr(Fields[0].Value);
        dateTime:=VarToStr(Fields[1].Value);
        phone:=VarToStr(Fields[2].Value);
        codeStatus:=VarToStr(Fields[3].Value);
        userID:=VarToStr(Fields[4].Value);

        // Элемент не найден, добавляем новый
        AddListItem(id, dateTime, phone, codeStatus, userID,
                    p_ListView);

        ado.Next;
      end;

      if countSMS = 0 then Caption:='Подбор номера телефона'
      else Caption:='Подбор номера телефона ['+IntToStr(countSMS)+']';

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


procedure TFormManualPodborStatus.btnStatus_availableClick(Sender: TObject);
var
 errorDescription:string;
 onlyError:Boolean;
begin
  if not Check(errorDescription)  then begin
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  onlyError:=SharedCheckBox.Checked['ShowErrorSendindSMS'];

  showWait(show_open);
  LoadData(dateStart.Date, dateStop.Date, eTableHistorySMS, onlyError);
  showWait(show_close);
end;


procedure TFormManualPodborStatus.FormShow(Sender: TObject);
var
 onlyError:Boolean;
begin
  onlyError:=SharedCheckBox.Checked['ShowErrorSendindSMS'];

  showWait(show_open);
  ShowLoading(onlyError);
  showWait(show_close);
end;

procedure TFormManualPodborStatus.img_ShowErrorSendindSMSClick(Sender: TObject);
begin
  ShowErrorSending;
end;

procedure TFormManualPodborStatus.list_HistoryCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 status:string;
begin
  if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 4 then // Проверяем, что есть достаточно SubItems
    begin
      status:=Item.SubItems.Strings[2];

      if status = '3' then begin
       Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
       Exit;
      end
      else begin
       Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Bad);
       Exit;
      end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('TFormManualPodborStatus '+e.ClassName+': '+e.Message, True);
    end;
  end;
end;

procedure TFormManualPodborStatus.list_HistoryDblClick(Sender: TObject);
var
  SelectedItem: TListItem;
  phone:string;
begin
  // Получаем выбранный элемент
  SelectedItem := list_History.Selected;

  // Проверяем, выбран ли элемент
  if Assigned(SelectedItem) then
  begin
     phone:=SelectedItem.SubItems[1];
     phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);

     FormHome.SetPhoneNumberFindStatusSMS(phone);
     Close;
  end
  else
  begin
    MessageBox(Handle,PChar('Не выбран номер телефона'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;

procedure TFormManualPodborStatus.list_HistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    // Получаем элемент, на который кликнули
    SelectedItemPopMenu := list_History.GetItemAt(X, Y);
  end;
end;
end.
