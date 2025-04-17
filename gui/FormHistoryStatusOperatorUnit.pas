unit FormHistoryStatusOperatorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, THistoryStatusOperatorsUnit;

type
  TFormHistoryStatusOperator = class(TForm)
    panel_status: TPanel;
    Label1: TLabel;
    lbl_available: TLabel;
    Label2: TLabel;
    lbl_exodus: TLabel;
    Label4: TLabel;
    lbl_break: TLabel;
    Label6: TLabel;
    lbl_dinner: TLabel;
    Label8: TLabel;
    lbl_postvyzov: TLabel;
    Label10: TLabel;
    lbl_studies: TLabel;
    Label12: TLabel;
    lbl_IT: TLabel;
    lbl_transfer: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lbl_reserve: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lbl_home: TLabel;
    panel_History: TPanel;
    list_History: TListView;
    st_NoStatus: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
   m_id:Integer;  // id пользовател€
   m_sip:Integer; // sip пользовател€

   operatorStatus:THistoryStatusOperators;

    procedure ClearListView(var p_ListView:TListView);
    procedure ClearData(isClearUserID:Boolean = True);
    procedure AddCountData;
    procedure LoadData(var p_ListView:TListView);
    procedure Show;
  public
    { Public declarations }

  procedure SetID(_id:Integer);
  procedure SetSip(_sip:Integer);

  end;

var
  FormHistoryStatusOperator: TFormHistoryStatusOperator;

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, TCustomTypeUnit;



{$R *.dfm}

procedure TFormHistoryStatusOperator.SetID(_id:Integer);
begin
   m_id:=_id;
end;

procedure TFormHistoryStatusOperator.SetSip(_sip:Integer);
begin
  m_sip:=_sip
end;


procedure TFormHistoryStatusOperator.ClearData(isClearUserID:Boolean = True);
begin
  if isClearUserID then begin
    m_id:=0;
    m_sip:=0;
  end;

  lbl_available.Caption:='---';
  lbl_exodus.Caption:='---';
  lbl_break.Caption:='---';
  lbl_dinner.Caption:='---';
  lbl_postvyzov.Caption:='---';
  lbl_studies.Caption:='---';
  lbl_IT.Caption:='---';
  lbl_transfer.Caption:='---';
  lbl_reserve.Caption:='---';
  lbl_home.Caption:='---';

  if Assigned(operatorStatus) then FreeAndNil(operatorStatus);
end;



procedure TFormHistoryStatusOperator.ClearListView(var p_ListView:TListView);
const
 cWidth_default        :Word = 496;
 cWidth_status         :Word = 24;
 cWidth_date_start     :Word = 24;
 cWidth_date_stop      :Word = 24;
 cWidth_diff           :Word = 24;
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
      Caption:=' —татус ';
      Width:=Round((cWidth_default*cWidth_status)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Ќачало ';
      Width:=Round((cWidth_default*cWidth_date_start)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ќкончание';
      Width:=Round((cWidth_default*cWidth_date_stop)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' ƒлительность';
      Width:=Round((cWidth_default*cWidth_diff)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormHistoryStatusOperator.AddCountData;
begin
  lbl_available.Caption := operatorStatus.GetCountTimeLogging(eLog_available); // доступен
  lbl_exodus.Caption    := operatorStatus.GetCountTimeLogging(eLog_exodus);    // исход
  lbl_break.Caption     := operatorStatus.GetCountTimeLogging(eLog_break);     // перерыв
  lbl_dinner.Caption    := operatorStatus.GetCountTimeLogging(eLog_dinner);    // обед
  lbl_postvyzov.Caption := operatorStatus.GetCountTimeLogging(eLog_postvyzov); // поствызов
  lbl_studies.Caption   := operatorStatus.GetCountTimeLogging(eLog_studies);   // учеба
  lbl_IT.Caption        := operatorStatus.GetCountTimeLogging(eLog_IT);        // »“
  lbl_transfer.Caption  := operatorStatus.GetCountTimeLogging(eLog_transfer);  // переносы
  lbl_reserve.Caption   := operatorStatus.GetCountTimeLogging(eLog_reserve);   // резерв
  lbl_home.Caption      := operatorStatus.GetCountTimeLogging(eLog_home);      // домой
end;


procedure TFormHistoryStatusOperator.LoadData(var p_ListView:TListView);
var
 i:Integer;
 ListItem: TListItem;
 status:enumLogging;
 timeStop:Double;
 duration:Cardinal;
begin
  // подгрузим данные
  operatorStatus:=THistoryStatusOperators.Create(m_id,m_sip);
  if operatorStatus.Count>0 then st_NoStatus.Visible:=False
  else begin
    st_NoStatus.Visible:=True;
    Exit;
  end;

  // заполним данными (общее кол-во времени)
  AddCountData;

  // заполним данными (истори€)
  for i:= operatorStatus.Count - 1 downto 0 do begin
    ListItem:= p_ListView.Items.Add;
    ListItem.Caption := IntToStr(i);      // id

    // замена "добавление в очередь" на "доступен"
    status:=operatorStatus.GetStatus(i);
    if status in [eLog_add_queue_5000 .. eLog_add_queue_5000_5050] then begin
      status:=eLog_available;
    end;

    ListItem.SubItems.Add(EnumLoggingToString(status));                           // статус
    ListItem.SubItems.Add(TimeToStr(operatorStatus.GetDateStart(i)));             // дата начала

    // дата окончани€
    timeStop:=operatorStatus.GetDateStop(i);
    if timeStop <> 0 then ListItem.SubItems.Add(TimeToStr(timeStop))
    else ListItem.SubItems.Add('---');

    // длительность
    duration:=operatorStatus.GetDuration(i);
    if duration > 0 then ListItem.SubItems.Add(GetTimeAnsweredSecondsToString(duration))
    else ListItem.SubItems.Add('---');
  end;
end;

procedure TFormHistoryStatusOperator.Show;
begin
  Screen.Cursor:=crHourGlass;
  Caption := '»стори€ статусов: ' + GetUserNameOperators(IntToStr(m_sip));

  // обнулим все данные (кроме id пользовател€)
  ClearData(False);

  ClearListView(list_History);
  LoadData(list_History);
//  LoadComboxFilterValue(_timeFilter);

  Screen.Cursor:=crDefault;
end;


procedure TFormHistoryStatusOperator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClearData;
end;

procedure TFormHistoryStatusOperator.FormShow(Sender: TObject);
begin
  Show;
end;

procedure TFormHistoryStatusOperator.list_HistoryCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 counts:Integer;
 time_talk:Integer;
 tmp_time:string;

begin
  if not Assigned(Item) then Exit;

  try
    counts:=Item.SubItems.Count; // TODO еще подумать как можно это улучшить

    if Item.SubItems.Count = 4 then // ѕровер€ем, что есть достаточно SubItems
    begin
      // доступен
      if Item.SubItems.Strings[0] = EnumLoggingToString(eLog_available) then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
        Exit;
      end;

      // перерыв или обед
      if (Item.SubItems.Strings[0] = EnumLoggingToString(eLog_break)) or
         (Item.SubItems.Strings[0] = EnumLoggingToString(eLog_dinner)) then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Break);
        Exit;
      end;

       // поствызов
      if (Item.SubItems.Strings[0] = EnumLoggingToString(eLog_postvyzov)) then
      begin
        tmp_time:=Item.SubItems.Strings[3];
        if tmp_time <> '---'  then begin
          time_talk:=GetTimeAnsweredToSeconds(tmp_time,False);
          if time_talk >=180 then begin
           Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_NotBad);
           Exit;
          end;
        end;
      end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('THomeForm.TFormHistoryStatusOperator. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;
end;

end.
