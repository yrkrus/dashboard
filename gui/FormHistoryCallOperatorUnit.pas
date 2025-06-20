unit FormHistoryCallOperatorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Data.DB, Data.Win.ADODB, IdException, System.ImageList, Vcl.ImgList,
  Vcl.Imaging.jpeg;

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
    img_play_or_downloads: TImage;
    lblDownloadCall: TLabel;
    Image1: TImage;
    Image2: TImage;
    lblPlayCall: TLabel;
    Label4: TLabel;
    lblProgramExit: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure combox_TimeFilterChange(Sender: TObject);
    procedure lblDownloadCallClick(Sender: TObject);
    procedure lblPlayCallClick(Sender: TObject);
  private
    { Private declarations }
  m_id:Integer;  // id ������������
  m_sip:Integer; // sip ������������

  // ���-�� ������� ����������
  m_count3,
  m_count3_10,
  m_count10_15,
  m_count15 :Integer;

  procedure Show(_timeFilter:enumFilterTime);
  procedure LoadCountCalls(isShowAllCalls:Boolean);

  procedure ClearListView(var p_ListView:TListView);
  procedure LoadComboxFilterValue(_timeFilter:enumFilterTime);
  procedure LoadData(var p_ListView:TListView;
                     isReducedTime:Boolean;
                     _filterTime:enumFilterTime);



  procedure ClearData(isClearUserID:Boolean = True);      // ������� ������
  procedure AddListItem(const id, dateTime, trunk, phone, numberQueue, talkTime: string;
                      isReducedTime: Boolean;
                      var p_ListView: TListView;
                      var m_count3, m_count3_10, m_count10_15, m_count15: Integer);

  procedure ZAGLUSHKA;
  public
    { Public declarations }

  procedure SetID(_id:Integer);
  procedure SetSip(_sip:Integer);

  end;

var
  FormHistoryCallOperator: TFormHistoryCallOperator;

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, FunctionUnit, TCustomTypeUnit;

{$R *.dfm}


procedure TFormHistoryCallOperator.ZAGLUSHKA;
begin
 MessageBox(0,PChar('���������� � ���������� ... '),PChar('��������'),MB_OK+MB_ICONINFORMATION);
end;

function EnumFilterTimeToString(_time:enumFilterTime):string;
begin
  case _time of
   time_all:    Result:='��� �������';
   time_3:      Result:='�� 3 ���';
   time_3_10:   Result:='�� 3 �� 10 ���';
   time_10_15:  Result:='�� 10 �� 15 ���';
   time_15:     Result:='�� 15 ���';
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
end;


procedure TFormHistoryCallOperator.ClearListView(var p_ListView:TListView);
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
      Caption:=' ���� ';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ����� ';
      Width:=Round((cWidth_default*cWidth_trunk)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ����� ��������';
      Width:=Round((cWidth_default*cWidth_phone)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' �������';
      Width:=Round((cWidth_default*cWidth_queue)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ����� ���������';
      Width:=Round((cWidth_default*cWidth_time)/100);
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


procedure TFormHistoryCallOperator.AddListItem(const id, dateTime, trunk, phone, numberQueue, talkTime: string;
                      isReducedTime: Boolean;
                      var p_ListView: TListView;
                      var m_count3, m_count3_10, m_count10_15, m_count15: Integer);
var
  ListItem: TListItem;
  time_talk: Integer;
  bitmap: TBitmap;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := id;      // id
  ListItem.SubItems.Add(dateTime); // ���� �����
  ListItem.SubItems.Add(trunk);     // �����
  ListItem.SubItems.Add(phone);   // ����� ��������
  ListItem.SubItems.Add(numberQueue); // �������


  // �������� ����� ���������
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

  // ����������� �������� � ����������� �� ������� ���������
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
  time_talk: Integer;
  program_started: TDateTime;
  program_exit: TDateTime;
  id, dateTime, trunk, phone, numberQueue, talkTime:string;
  filteringCount:Integer;
begin
  Caption := '������� �������: ' + GetUserNameOperators(IntToStr(m_sip));
  filteringCount:=0;

  // ��������� �������
  if _filterTime = time_all then LoadCountCalls(True)
  else LoadCountCalls(False);

  // �����
  begin
     // �����
    program_started := GetProgrammStarted(m_id);
    if program_started <> 0 then lblProgramStarted.Caption := DateTimeToStr(program_started);

    // ������
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
      SQL.Add('select count(id) from queue where sip = ' + QuotedStr(IntToStr(m_sip)) + ' and hash is not NULL');
      Active := True;
      countCalls := Fields[0].Value;

      if countCalls = 0 then
      begin
        // ������� ��� ��� ������
        st_NoCalls.Visible := True;

        Exit;
      end;

      // �������� ������� ��� ��� ������
      st_NoCalls.Visible := False;

      SQL.Clear;
      SQL.Add('select id, date_time, phone, number_queue, talk_time from queue where sip = ' + QuotedStr(IntToStr(m_sip)) + ' and hash is not NULL order by date_time DESC');
      Active := True;

      for i := 0 to countCalls - 1 do
      begin

        id          :=VarToStr(Fields[0].Value);
        dateTime    :=VarToStr(Fields[1].Value);
        phone       :=VarToStr(Fields[2].Value);
        numberQueue :=VarToStr(Fields[3].Value);
        talkTime    :=VarToStr(Fields[4].Value);

        trunk:=GetPhoneTrunkQueue(phone,dateTime);

        if _filterTime = time_all then
        begin
          // ������� �� ������, ��������� �����
          AddListItem(id, dateTime,trunk, phone, numberQueue, talkTime,
                      isReducedTime,
                      p_ListView,
                      m_count3, m_count3_10, m_count10_15, m_count15);
        end
        else
        begin
          // ������ ����� �������
          ProcessTimeTalk(talkTime, isReducedTime, time_talk);

          // �������� ����������� �������
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
          AddListItem(id, dateTime,trunk, phone, numberQueue, talkTime,
                      isReducedTime,
                      p_ListView,
                      m_count3, m_count3_10, m_count10_15, m_count15);

        end;

        ado.Next;
      end;

      // ���������� ������� ��� ��� ������ ��� ��� ��� ����������
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


procedure TFormHistoryCallOperator.Show(_timeFilter:enumFilterTime);
const
 cReducedTime:Boolean = True;
begin
  Screen.Cursor:=crHourGlass;

  // ������� ��� ������ (����� id ������������)
  ClearData(False);

  ClearListView(list_History);
  LoadData(list_History,cReducedTime,_timeFilter);
  LoadComboxFilterValue(_timeFilter);

  // ������ �������������� �� �������
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
 counts:Integer;
 time_talk:Integer;
 test:string;

begin
  if not Assigned(Item) then Exit;

  try
    counts:=Item.SubItems.Count; // TODO ��� �������� ��� ����� ��� ��������

    if Item.SubItems.Count = 5 then // ���������, ��� ���� ���������� SubItems
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

procedure TFormHistoryCallOperator.SetID(_id: Integer);
begin
  m_id:=_id;
end;

procedure TFormHistoryCallOperator.SetSip(_sip:Integer);
begin
 m_sip:=_sip;
end;

end.
