unit FormStatisticsLisaShowUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, Data.Win.ADODB, Vcl.Menus, Vcl.Buttons;

type
  TFormStatisticsLisaShow = class(TForm)
    panel_calls: TPanel;
    list_calls: TListView;
    st_NoCalls: TStaticText;
    chkbox_ShowErrorNoAnsweredCallsLisa: TLabel;
    img_ShowErrorNoAnsweredCallsLisa: TImage;
    popmenu_InfoCall: TPopupMenu;
    menu_FIO: TMenuItem;
    btn_Find: TBitBtn;
    edtFindPhone: TEdit;
    st_PhoneFind: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure list_callsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure chkbox_ShowErrorNoAnsweredCallsLisaClick(Sender: TObject);
    procedure img_ShowErrorNoAnsweredCallsLisaClick(Sender: TObject);
    procedure menu_FIOClick(Sender: TObject);
    procedure list_callsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtFindPhoneKeyPress(Sender: TObject; var Key: Char);
    procedure btn_FindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtFindPhoneClick(Sender: TObject);
    procedure edtFindPhoneChange(Sender: TObject);
  private
    SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента(для popmenu_InfoCalls)

   procedure ShowLoading(_onlyNoAnsweredCall:Boolean); overload;
   procedure ShowLoading(_phone:string);               overload;
   procedure ClearListView(var p_ListView:TListView);
   procedure ShowCalls(var p_ListView:TListView; _onlyMissedCalls:Boolean);  overload;
   procedure ShowCalls(var p_ListView:TListView; _phone:string);             overload;
   procedure AddListItem(const _id,_dateTime,_phone,_talkTime:string;
                         const _to_queue,_answered: Boolean;
                         var p_ListView: TListView);

   procedure ShowNoAnsweredCalls;
    { Private declarations }


  public
    { Public declarations }
  end;

var
  FormStatisticsLisaShow: TFormStatisticsLisaShow;

implementation

uses
  FunctionUnit, TCustomTypeUnit, GlobalVariablesLinkDLL, GlobalVariables, TAutoPodborPeopleUnit,
  FormPropushennieShowPeopleUnit;

{$R *.dfm}



procedure TFormStatisticsLisaShow.ShowNoAnsweredCalls;
var
 showNoAnswered:Boolean;
begin
  SharedCheckBoxUI.ChangeStatusCheckBox('ShowErrorNoAnsweredCallsLisa');
  showNoAnswered:=SharedCheckBoxUI.Checked['ShowErrorNoAnsweredCallsLisa'];

  showWait(show_open);
  ShowLoading(showNoAnswered);
  showWait(show_close);
end;


procedure TFormStatisticsLisaShow.AddListItem(const _id,_dateTime,_phone,_talkTime:string;
                                              const _to_queue,_answered: Boolean;
                                              var p_ListView: TListView);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := _id;          // id
  ListItem.SubItems.Add(_dateTime); // дата время
  ListItem.SubItems.Add(_phone);    // номер телефона
  ListItem.SubItems.Add(GetTimeAnsweredSecondsToString(StrToInt(_talkTime)));  // время разговора

  if _to_queue then ListItem.SubItems.Add('X')  // ушел на оператора звонок
  else ListItem.SubItems.Add('---');
  if _answered then ListItem.SubItems.Add('X')  // отвеченный звонок
  else ListItem.SubItems.Add('---');
end;


// прогрузка данных
procedure TFormStatisticsLisaShow.ShowCalls(var p_ListView:TListView;
                                           _onlyMissedCalls:Boolean);
const
 cFILEDS:string = 'id,phone,date_time,talk_time,to_queue,answered';
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  countCalls:Integer;
  i:Integer;
  id,dateTime,phone,talkTime:string;
  to_queue,answered:Boolean;
  response:TStringBuilder;
begin
  ado := TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  response:=TStringBuilder.Create;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;
      with response do begin
        Append('select count(id) from queue_lisa');
        if _onlyMissedCalls then begin
          Append(' where answered = ''0'' ');
        end;
      end;

      SQL.Add(response.ToString);
      Active := True;

      countCalls := Fields[0].Value;

      if countCalls = 0 then
      begin
        // надпись что нет данных
        st_NoCalls.Visible:=True;
        Exit;
      end;

      // скрываем надпись что нет данных
      st_NoCalls.Visible:=False;

      SQL.Clear;
      with response do begin
        Clear;
        Append('select '+cFILEDS+' from queue_lisa');
        if _onlyMissedCalls then begin
          Append(' where answered = ''0'' ');
        end;
        Append(' order by date_time DESC');
      end;

      SQL.Add(response.ToString);
      Active:=True;

      for i:= 0 to countCalls - 1 do
      begin

        id:=VarToStr(Fields[0].Value);
        phone:=VarToStr(Fields[1].Value);
        dateTime:=VarToStr(Fields[2].Value);
        talkTime:=VarToStr(Fields[3].Value);

        if VarToStr(Fields[4].Value) = '1' then to_queue:=True
        else to_queue:=False;

        if VarToStr(Fields[5].Value) = '1' then answered:=True
        else answered:=False;


        // Элемент не найден, добавляем новый
        AddListItem(id, dateTime, phone, talkTime, to_queue, answered,
                    p_ListView);
        ado.Next;
      end;

      if countCalls = 0 then Caption:='Статистика звонков Лиза'
      else Caption:='Статистика звонков Лиза ['+IntToStr(countCalls)+']';
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

// прогрузка данных
procedure TFormStatisticsLisaShow.ShowCalls(var p_ListView:TListView;
                                           _phone:string);
const
 cFILEDS:string = 'id,phone,date_time,talk_time,to_queue,answered';
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  countCalls:Integer;
  i:Integer;
  id,dateTime,phone,talkTime:string;
  to_queue,answered:Boolean;
  response:TStringBuilder;
begin
  ado := TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  response:=TStringBuilder.Create;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;
      with response do begin
        Append('select count(id) from queue_lisa');
        Append(' where phone LIKE CONCAT(''%'','+_phone+',''%'')');
      end;

      SQL.Add(response.ToString);
      Active := True;

      countCalls := Fields[0].Value;

      if countCalls = 0 then
      begin
        // надпись что нет данных
        st_NoCalls.Visible:=True;
        Exit;
      end;

      // скрываем надпись что нет данных
      st_NoCalls.Visible:=False;

      SQL.Clear;
      with response do begin
        Clear;
        Append('select '+cFILEDS+' from queue_lisa');
        Append(' where phone LIKE CONCAT(''%'','+_phone+',''%'')');
        Append(' order by date_time DESC');
      end;

      SQL.Add(response.ToString);
      Active:=True;

      for i:= 0 to countCalls - 1 do
      begin

        id:=VarToStr(Fields[0].Value);
        phone:=VarToStr(Fields[1].Value);
        dateTime:=VarToStr(Fields[2].Value);
        talkTime:=VarToStr(Fields[3].Value);

        if VarToStr(Fields[4].Value) = '1' then to_queue:=True
        else to_queue:=False;

        if VarToStr(Fields[5].Value) = '1' then answered:=True
        else answered:=False;


        // Элемент не найден, добавляем новый
        AddListItem(id, dateTime, phone, talkTime, to_queue, answered,
                    p_ListView);
        ado.Next;
      end;

      if countCalls = 0 then Caption:='Статистика звонков Лиза'
      else Caption:='Статистика звонков Лиза ['+IntToStr(countCalls)+']';
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


procedure TFormStatisticsLisaShow.btn_FindClick(Sender: TObject);
begin
 if Length(edtFindPhone.Text) = 0 then begin
  FormShow(Sender);
  Exit;
 end;

  ShowLoading(edtFindPhone.Text);
  list_calls.SetFocus;
end;

procedure TFormStatisticsLisaShow.chkbox_ShowErrorNoAnsweredCallsLisaClick(
  Sender: TObject);
begin
  ShowNoAnsweredCalls;
end;

procedure TFormStatisticsLisaShow.ClearListView(var p_ListView:TListView);
const
 cWidth_default     :Word = 690;
 cWidth_date        :Word = 23;
 cWidth_phone       :Word = 20;
 cWidth_talTime     :Word = 12;
 cWidth_to_operator :Word = 20;
 cWidth_answered    :Word = 20;
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
      Caption:=' Номер телефона ';
      Width:=Round((cWidth_default*cWidth_phone)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Время ';
      Width:=Round((cWidth_default*cWidth_talTime)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Ушел на оператора ';
      Width:=Round((cWidth_default*cWidth_to_operator)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Отвеченный вызов ';
      Width:=Round((cWidth_default*cWidth_answered)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormStatisticsLisaShow.edtFindPhoneChange(Sender: TObject);
begin
  if Length(edtFindPhone.Text) > 0 then st_PhoneFind.Visible:=False
  else st_PhoneFind.Visible:=True;
end;

procedure TFormStatisticsLisaShow.edtFindPhoneClick(Sender: TObject);
begin
  st_PhoneFind.Visible:=False;
end;

procedure TFormStatisticsLisaShow.edtFindPhoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    btn_Find.Click;
  end;

  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
end;

procedure TFormStatisticsLisaShow.ShowLoading(_onlyNoAnsweredCall:Boolean);
begin
  // очитска листа
  ClearListView(list_calls);
  ShowCalls(list_calls, _onlyNoAnsweredCall);
end;

procedure TFormStatisticsLisaShow.ShowLoading(_phone:string);
begin
   // очитска листа
  ClearListView(list_calls);
  ShowCalls(list_calls, _phone);
end;

procedure TFormStatisticsLisaShow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SharedCheckBoxUI.ChangeStatusCheckBox('ShowErrorNoAnsweredCallsLisa', paramStatus_DISABLED);
 // поиск по номеру
 edtFindPhone.Text:='';
 st_PhoneFind.Visible:=True;
end;

procedure TFormStatisticsLisaShow.FormShow(Sender: TObject);
var
 onlyNoAnsweredCall:Boolean;
begin
  onlyNoAnsweredCall:=False;

  showWait(show_open);
  ShowLoading(onlyNoAnsweredCall);
  showWait(show_close);
end;

procedure TFormStatisticsLisaShow.img_ShowErrorNoAnsweredCallsLisaClick(
  Sender: TObject);
begin
 ShowNoAnsweredCalls;
end;

procedure TFormStatisticsLisaShow.list_callsCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 answered:string;
begin
  if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 5 then // Проверяем, что есть достаточно SubItems
    begin
      answered:=Item.SubItems.Strings[4];

      if answered = 'X' then begin
       Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
       Exit;
      end
      else begin
       Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
       Exit;
      end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('TFormStatisticsLisaShow '+e.ClassName+': '+e.Message, True);
    end;
  end;
end;

procedure TFormStatisticsLisaShow.list_callsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedItemPopMenu := list_calls.GetItemAt(X, Y);
end;

procedure TFormStatisticsLisaShow.menu_FIOClick(Sender: TObject);
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

end.
