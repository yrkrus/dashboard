unit FormManualPodborUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB, IdException;

type
  TFormManualPodbor = class(TForm)
    panel_History: TPanel;
    list_History: TListView;
    st_NoCalls: TStaticText;
    chkbox_MyCalls: TCheckBox;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure chkbox_MyCallsClick(Sender: TObject);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure list_HistoryDblClick(Sender: TObject);
  private
    { Private declarations }
  procedure LoadData(_idUser:Integer);
  procedure ClearListView(var p_ListView:TListView);
  procedure ShowCalls(var p_ListView:TListView;  isReducedTime: Boolean; _idUser:Integer);                // прогрузка номеров тлф
  procedure AddListItem(const id, dateTime, sip, phone, numberQueue, talkTime: string;
                        isReducedTime: Boolean;
                        var p_ListView: TListView);

  public
    { Public declarations }
  end;

var
  FormManualPodbor: TFormManualPodbor;

implementation

uses
  GlobalVariablesLinkDLL, FunctionUnit, GlobalVariables, TCustomTypeUnit, FormHomeUnit;

{$R *.dfm}




procedure TFormManualPodbor.AddListItem(const id, dateTime, sip, phone, numberQueue, talkTime: string;
                                        isReducedTime: Boolean;
                                        var p_ListView: TListView);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := id;      // id
  ListItem.SubItems.Add(dateTime); // дата время
  ListItem.SubItems.Add(sip);     // sip
  ListItem.SubItems.Add(phone);   // номер телефона
  ListItem.SubItems.Add(numberQueue); // очередь


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

end;


// прогрузка номеров тлф
procedure TFormManualPodbor.ShowCalls(var p_ListView:TListView;
                                      isReducedTime: Boolean;
                                      _idUser:Integer);
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



procedure TFormManualPodbor.chkbox_MyCallsClick(Sender: TObject);
begin
  showWait(show_open);

  if chkbox_MyCalls.Checked then LoadData(USER_STARTED_SMS_ID)
  else LoadData(-1);

  showWait(show_close);
end;

procedure TFormManualPodbor.ClearListView(var p_ListView:TListView);
const
 cWidth_default        :Word = 660;
 cWidth_date           :Word = 21;
 cWidth_trunk          :Word = 18;
 cWidth_phone          :Word = 19;
 cWidth_queue          :Word = 19;
 cWidth_time           :Word = 20;
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
      Caption:=' Дата ';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' SIP ';
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

 end;
end;


procedure TFormManualPodbor.LoadData(_idUser:Integer);
begin
  Screen.Cursor:=crHourGlass;

  // очитска листа
  ClearListView(list_History);

   // прогружаем номера
   ShowCalls(list_History,True,_idUser);

  Screen.Cursor:=crDefault;
end;

procedure TFormManualPodbor.FormShow(Sender: TObject);
begin
  showWait(show_open);
  LoadData(-1);
  showWait(show_close);
end;

procedure TFormManualPodbor.list_HistoryCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 counts:Integer;
 time_talk:Integer;
 test:string;

begin
  if not Assigned(Item) then Exit;

  try
    counts:=Item.SubItems.Count; // TODO еще подумать как можно это улучшить

    if Item.SubItems.Count = 5 then // Проверяем, что есть достаточно SubItems
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
     SharedMainLog.Save('TFormManualPodbor.TFormManualPodbor. '+e.ClassName+': '+e.Message, True);
    end;
  end;
end;

procedure TFormManualPodbor.list_HistoryDblClick(Sender: TObject);
var
  SelectedItem: TListItem;
  phone:string;
begin
  // Получаем выбранный элемент
  SelectedItem := list_History.Selected;

  // Проверяем, выбран ли элемент
  if Assigned(SelectedItem) then
  begin
     phone:=SelectedItem.SubItems[2];
     phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);

     FormHome.SetPhoneNumberPodbor(phone);
     Close;
  end
  else
  begin
    MessageBox(Handle,PChar('Не выбран номер телефона'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;

end.
