unit FormHistoryCallOperatorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Data.DB, Data.Win.ADODB, IdException, System.ImageList, Vcl.ImgList, System.DateUtils,
  Vcl.Imaging.jpeg, Vcl.Menus, Vcl.MPlayer;

  type
    enumFilterTime = ( time_all,
                       time_3,
                       time_3_10,
                       time_10_15,
                       time_15);


type
  TFormHistoryCallOperator = class(TForm)
    panel_History: TPanel;
    list_History: TListView;
    panel_program: TPanel;
    Label5: TLabel;
    lblProgramStarted: TLabel;
    Label1: TLabel;
    lblCountCall: TLabel;
    Label3: TLabel;
    lblCountCallProcent: TLabel;
    st_NoCalls: TStaticText;
    Label6: TLabel;
    lbl_3_10: TLabel;
    Label8: TLabel;
    lbl_10_15: TLabel;
    Label10: TLabel;
    lbl_15: TLabel;
    Label12: TLabel;
    lbl_3: TLabel;
    Label2: TLabel;
    combox_TimeFilter: TComboBox;
    lblDownloadCall: TLabel;
    Image1: TImage;
    Image2: TImage;
    lblPlayCall: TLabel;
    Label4: TLabel;
    lblProgramExit: TLabel;
    popmenu_InfoCall: TPopupMenu;
    menu_FIO: TMenuItem;
    lblCallInfo: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure combox_TimeFilterChange(Sender: TObject);
    procedure lblDownloadCallClick(Sender: TObject);
    procedure lblPlayCallClick(Sender: TObject);
    procedure list_HistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menu_FIOClick(Sender: TObject);
  private
    { Private declarations }
  m_id:Integer;  // id пользователя
  m_sip:Integer; // sip пользователя

  SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента(для popmenu_InfoCalls)

  // кол-во времени разговоров
  m_count3,
  m_count3_10,
  m_count10_15,
  m_count15 :Integer;

  procedure Show(_timeFilter:enumFilterTime);
  procedure LoadCountCalls(isShowAllCalls:Boolean);
  function GetTimeOnHoldCall(_sip:Integer; _phone:string):Integer;  // время сколько номер телефона был в OnHold

  procedure ClearListView(var p_ListView:TListView);
  procedure LoadComboxFilterValue(_timeFilter:enumFilterTime);
  procedure LoadData(var p_ListView:TListView;
                     isReducedTime:Boolean;
                     _filterTime:enumFilterTime);



  procedure ClearData(isClearUserID:Boolean = True);      // очистка данных
  procedure AddListItem(const id, dateTime, trunk, phone, numberQueue, talkTime, onHoldTime: string;
                      isReducedTime: Boolean;
                      var p_ListView: TListView;
                      var m_count3, m_count3_10, m_count10_15, m_count15: Integer);

  procedure ZAGLUSHKA;
  procedure SetColorLink;
  procedure ShowCallInfo;

  public
    { Public declarations }

  procedure SetID(_id:Integer);
  procedure SetSip(_sip:Integer);

  end;

var
  FormHistoryCallOperator: TFormHistoryCallOperator;

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, FunctionUnit, TCustomTypeUnit, FormPropushennieShowPeopleUnit, TAutoPodborPeopleUnit;

{$R *.dfm}


procedure TFormHistoryCallOperator.ZAGLUSHKA;
begin
 MessageBox(0,PChar('Функционал в разработке ... '),PChar('Заглушка'),MB_OK+MB_ICONINFORMATION);
end;


procedure TFormHistoryCallOperator.SetColorLink;
begin
  SetLinkColor(lblDownloadCall);
  SetLinkColor(lblPlayCall);
end;

// отображение прослушать\скачать
procedure TFormHistoryCallOperator.ShowCallInfo;
var
 callDate,phone,timeCall:string;
begin
  if not Assigned(SelectedItemPopMenu) then Exit;

  callDate:=SelectedItemPopMenu.SubItems[0];
  phone:=SelectedItemPopMenu.SubItems[2];
  timeCall:=SelectedItemPopMenu.SubItems[4];

  lblCallInfo.Caption:=callDate+' '+phone+' ('+timeCall+')';

  lblCallInfo.Visible:=True;
  lblDownloadCall.Enabled:=True;
  lblPlayCall.Enabled:=True;
end;

function EnumFilterTimeToString(_time:enumFilterTime):string;
begin
  case _time of
   time_all:    Result:='Без фильтра';
   time_3:      Result:='до 3 мин';
   time_3_10:   Result:='от 3 до 10 мин';
   time_10_15:  Result:='от 10 до 15 мин';
   time_15:     Result:='от 15 мин';
  end;
end;

function EnumFiterTimeToInteger(_time:enumFilterTime):Integer;
begin
  case _time of
   time_all:    Result:=0;
   time_3:      Result:=1;
   time_3_10:   Result:=2;
   time_10_15:  Result:=3;
   time_15:     Result:=4;
  end;
end;

function IntegerToEnumFiterTime(_id:Integer):enumFilterTime;
begin
   case _id of
     0:Result:=time_all;
     1:Result:=time_3;
     2:Result:=time_3_10;
     3:Result:=time_10_15;
     4:Result:=time_15;
   end;
end;


procedure TFormHistoryCallOperator.ClearData(isClearUserID:Boolean = True);
begin
  if isClearUserID then begin
    m_id:=0;
    m_sip:=0;
  end;

  m_count3:=0;
  m_count3_10:=0;
  m_count10_15:=0;
  m_count15:=0;

  lblProgramStarted.Caption:='---';
  lblProgramExit.Caption:='---';
  lbl_3.Caption:='---';
  lbl_3_10.Caption:='---';
  lbl_10_15.Caption:='---';
  lbl_15.Caption:='---';

  // подменю прослушать\скачать звонок
  lblDownloadCall.Enabled:=False;
  lblPlayCall.Enabled:=False;
  lblCallInfo.Caption:='';
  lblCallInfo.Visible:=False;
end;


procedure TFormHistoryCallOperator.ClearListView(var p_ListView:TListView);
const
 cWidth_default        :Word = 680;
 cWidth_date           :Word = 20;
 cWidth_trunk          :Word = 15;
 cWidth_phone          :Word = 19;
 cWidth_queue          :Word = 13;
 cWidth_time           :Word = 17;
 cWidth_timeOnHold     :Word = 14;
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
      Caption:=' Дата\Время звонка ';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Линия ';
      Width:=Round((cWidth_default*cWidth_trunk)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Номер телефона';
      Width:=Round((cWidth_default*cWidth_phone)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' Очередь';
      Width:=Round((cWidth_default*cWidth_queue)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Время разговора';
      Width:=Round((cWidth_default*cWidth_time)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' OnHold';
      Width:=Round((cWidth_default*cWidth_timeOnHold)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormHistoryCallOperator.combox_TimeFilterChange(Sender: TObject);
begin
  Show(IntegerToEnumFiterTime(combox_TimeFilter.Items.IndexOf(combox_TimeFilter.Text)));
end;

procedure TFormHistoryCallOperator.LoadComboxFilterValue(_timeFilter:enumFilterTime);
var
 i:Integer;
 Filter:enumFilterTime;
begin
  combox_TimeFilter.Clear;

  for i:=Ord(Low(enumFilterTime)) to Ord(High(enumFilterTime)) do
  begin
    Filter:=enumFilterTime(i);
    combox_TimeFilter.Items.Add(EnumFilterTimeToString(Filter));
  end;

  combox_TimeFilter.ItemIndex:=EnumFiterTimeToInteger(_timeFilter);
end;

procedure TFormHistoryCallOperator.LoadCountCalls(isShowAllCalls:Boolean);
 var
  id:Integer;
begin
  if not isShowAllCalls then begin
   lblCountCall.Caption:='---';
   lblCountCallProcent.Caption:='---';
   Exit;
  end;

  id:=SharedActiveSipOperators.GetListOperators_ID(m_sip);

  lblCountCall.Caption:=IntToStr(SharedActiveSipOperators.GetListOperators_CountTalk(id));
  lblCountCallProcent.Caption:=SharedActiveSipOperators.GetListOperators_CountProcentTalk(id);
end;


// время сколько номер телефона был в OnHold
function TFormHistoryCallOperator.GetTimeOnHoldCall(_sip:Integer; _phone:string):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 seconds:Integer;
 secondsAll:Integer;
begin
  Result:=0;
  secondsAll:=0;

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
      SQL.Add('select count(id) from operators_ohhold where sip IN ('+IntToStr(_sip)+')'+
              ' and phone =' + #39 + _phone + #39 +' and date_time_stop is not NULL');

      Active:=True;
      countData:=Fields[0].Value;

      if countData=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

       Exit;
      end;

      SQL.Clear;
      SQL.Add('select date_time_start,date_time_stop from operators_ohhold where sip IN ('+IntToStr(_sip)+')'+
              ' and phone =' + #39 + _phone + #39 +' and date_time_stop is not NULL');

      Active:=True;
      for i:=0 to countData-1 do begin
        seconds:= SecondsBetween(StrToDateTime(Fields[0].Value), StrToDateTime(Fields[1].Value));

        //общее время
        secondsAll := secondsAll + seconds;

        ado.Next;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Result:=secondsAll;
end;


procedure TFormHistoryCallOperator.AddListItem(const id, dateTime, trunk, phone, numberQueue, talkTime, onHoldTime: string;
                      isReducedTime: Boolean;
                      var p_ListView: TListView;
                      var m_count3, m_count3_10, m_count10_15, m_count15: Integer);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := id;               // id
  ListItem.SubItems.Add(dateTime);      // дата время
  ListItem.SubItems.Add(trunk);         // транк
  ListItem.SubItems.Add(phone);         // номер телефона
  ListItem.SubItems.Add(numberQueue);   // очередь

  // Получаем время разговора
  if isReducedTime then
  begin
    ListItem.SubItems.Add(Copy(VarToStr(talkTime), 4, 5));
    time_talk := GetTimeAnsweredToSeconds(Copy(VarToStr(talkTime), 4, 5), True);
  end
  else
  begin
    ListItem.SubItems.Add(VarToStr(talkTime));
    time_talk := GetTimeAnsweredToSeconds(VarToStr(talkTime), False);
  end;

  ListItem.SubItems.Add(onHoldTime);    // время в OnHold

  // Увеличиваем счетчики в зависимости от времени разговора
  case time_talk of
    0..179:     Inc(m_count3);
    180..600:   Inc(m_count3_10);
    601..900:   Inc(m_count10_15);
    else        Inc(m_count15);
  end;
end;


procedure ProcessTimeTalk(const times: Variant; isReducedTime: Boolean; var time_talk: Integer);
begin
  if isReducedTime then
    time_talk := GetTimeAnsweredToSeconds(Copy(VarToStr(times), 4, 5), True)
  else
    time_talk := GetTimeAnsweredToSeconds(VarToStr(times), False);
end;


procedure TFormHistoryCallOperator.LoadData(var p_ListView:TListView;
                                            isReducedTime:Boolean;
                                            _filterTime:enumFilterTime);
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  i, countCalls: Integer;
  fullTimeOnHold:string;
  diffTime:Integer;
  time_talk: Integer;
  program_started: TDateTime;
  program_exit: TDateTime;
  id, dateTime, trunk, phone, numberQueue, talkTime, onHold:string;
  filteringCount:Integer;
begin
  Caption := 'История звонков: ' + GetUserNameOperators(IntToStr(m_sip));
  filteringCount:=0;

  // прогрузка звонков
  if _filterTime = time_all then LoadCountCalls(True)
  else LoadCountCalls(False);

  // время
  begin
     // входа
    program_started := GetProgrammStarted(m_id);
    if program_started <> 0 then lblProgramStarted.Caption := DateTimeToStr(program_started);

    // выхода
    program_exit :=GetProgrammExit(m_id);
    if program_exit <> 0 then lblProgramExit.Caption := DateTimeToStr(program_exit);
  end;

  ado := TADOQuery.Create(nil);
  serverConnect := createServerConnect;
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
      SQL.Add('select count(id) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = ' + QuotedStr(IntToStr(m_sip)) + ' and hash is not NULL');
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
      SQL.Add('select id, date_time, phone, number_queue, talk_time from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = ' + QuotedStr(IntToStr(m_sip)) + ' and hash is not NULL order by date_time DESC');
      Active := True;

      for i := 0 to countCalls - 1 do
      begin

        id          :=VarToStr(Fields[0].Value);
        dateTime    :=VarToStr(Fields[1].Value);
        phone       :=VarToStr(Fields[2].Value);
        numberQueue :=VarToStr(Fields[3].Value);
        talkTime    :=VarToStr(Fields[4].Value);

        // время в onHold
        begin
         diffTime:=GetTimeOnHoldCall(m_sip, phone);
         if diffTime<>0 then begin
            fullTimeOnHold:=GetTimeAnsweredSecondsToString(diffTime);
            onHold:=Copy(fullTimeOnHold, 4, 5);  // формат (mm::ss)
         end
         else begin
           onHold:='---';
         end;
        end;

         try
            trunk:=GetPhoneTrunkQueue(eTableIVR,phone,dateTime);
         except
            trunk:='null';
         end;

        if _filterTime = time_all then
        begin
          // Элемент не найден, добавляем новый
          AddListItem(id, dateTime,trunk, phone, numberQueue, talkTime, onHold,
                      isReducedTime,
                      p_ListView,
                      m_count3, m_count3_10, m_count10_15, m_count15);
        end
        else
        begin
          // Найдем время сначала
          ProcessTimeTalk(talkTime, isReducedTime, time_talk);

          // проверим соответстве времени
          case _filterTime of
            time_3:begin
              if time_talk > 180 then begin
                ado.Next;
                Continue;
              end;
            end;
            time_3_10:begin
              if (time_talk>=600) or (time_talk<=180) then begin
                ado.Next;
                Continue;
              end;
            end;
            time_10_15:begin
              if (time_talk>=900) or (time_talk<=600) then begin
                ado.Next;
                Continue;
              end;
            end;
            time_15:begin
              if time_talk < 900 then begin
                ado.Next;
                Continue;
              end;
            end;
          end;

          inc(filteringCount);
          AddListItem(id, dateTime,trunk, phone, numberQueue, talkTime, onHold,
                      isReducedTime,
                      p_ListView,
                      m_count3, m_count3_10, m_count10_15, m_count15);

        end;

        ado.Next;
      end;

      // показывать надпись что нет данных или нет для фильтрации
      if _filterTime<>time_all then begin
        if filteringCount > 0 then st_NoCalls.Visible := False
        else st_NoCalls.Visible := True;
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


procedure TFormHistoryCallOperator.menu_FIOClick(Sender: TObject);
var
 people:TAutoPodborPeople;
 phonePodbor:string;
begin
  // Проверяем, был ли выбран элемент
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран номер'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  phonePodbor:= SelectedItemPopMenu.SubItems[2];
  phonePodbor:=StringReplace(phonePodbor,'+7','8',[rfReplaceAll]);

  showWait(show_open);
  people:=TAutoPodborPeople.Create(phonePodbor);

  FormPropushennieShowPeople.SetListPacients(people);
  showWait(show_close);

  FormPropushennieShowPeople.ShowModal;
end;

procedure TFormHistoryCallOperator.Show(_timeFilter:enumFilterTime);
const
 cReducedTime:Boolean = True;
begin
  Screen.Cursor:=crHourGlass;

  // обнулим все данные (кроме id пользователя)
  ClearData(False);

  ClearListView(list_History);
  LoadData(list_History,cReducedTime,_timeFilter);
  LoadComboxFilterValue(_timeFilter);

  // звонки распределенные по времени
  if m_count3>0 then lbl_3.Caption:=IntToStr(m_count3);
  if m_count3_10>0 then lbl_3_10.Caption:=IntToStr(m_count3_10);
  if m_count10_15>0 then lbl_10_15.Caption:=IntToStr(m_count10_15);
  if m_count15>0 then lbl_15.Caption:=IntToStr(m_count15);

  Screen.Cursor:=crDefault;
end;

procedure TFormHistoryCallOperator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClearData;
end;

procedure TFormHistoryCallOperator.FormShow(Sender: TObject);
begin
  // установка цвета на ссылки
  SetColorLink;

  Show(time_all);
  list_History.SetFocus;
end;


procedure TFormHistoryCallOperator.lblDownloadCallClick(Sender: TObject);
begin
 ZAGLUSHKA;
end;

procedure TFormHistoryCallOperator.lblPlayCallClick(Sender: TObject);
begin
  ZAGLUSHKA;
end;

procedure TFormHistoryCallOperator.list_HistoryCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 time_talk:Integer;
 test:string;
begin
  if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 6 then // Проверяем, что есть достаточно SubItems
    begin
        test:=Item.SubItems.Strings[4];

        time_talk:=GetTimeAnsweredToSeconds(Item.SubItems.Strings[4],True);

        if (time_talk >= 180) and (time_talk <= 600)  then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
         Exit;
        end else if (time_talk > 600) and (time_talk <= 900)  then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Bad);
         Exit;
        end else if time_talk >= 900 then begin
         Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Very_Bad);
         Exit;
        end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('THomeForm.TFormHistoryCallOperator. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;
end;

procedure TFormHistoryCallOperator.list_HistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 SelectedItemPopMenu := list_History.GetItemAt(X, Y);

  // выбор варианта на прослушку\скачивание
  if Button = mbLeft then begin
    ShowCallInfo;
  end;
end;

procedure TFormHistoryCallOperator.SetID(_id: Integer);
begin
  m_id:=_id;
end;

procedure TFormHistoryCallOperator.SetSip(_sip:Integer);
begin
 m_sip:=_sip;
end;

end.
