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
    btnStatus_available: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnStatus_availableClick(Sender: TObject);
    procedure list_HistoryDblClick(Sender: TObject);
    procedure list_HistoryCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }

   procedure ShowLoading;
   procedure FormDefault;
   procedure ClearListView(var p_ListView:TListView);
   procedure LoadData(_startDate:TDate;
                     _stopDate:TDate;
                     _table:enumReportTableSMSStatus); // ��������� ������
   procedure ShowSMS(var p_ListView:TListView;
                    _startDate:TDate;
                    _stopDate:TDate;
                    _table:enumReportTableSMSStatus);       // ��������� ������������ ���
   procedure AddListItem(const _id, _dateTime, _phone, _code, _userId: string;
                         var p_ListView: TListView);

   function Check(var _errorDescription:string):Boolean;  // ��������

  public
    { Public declarations }
  end;

var
  FormManualPodborStatus: TFormManualPodborStatus;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, FormHomeUnit, GlobalVariables;

{$R *.dfm}

procedure TFormManualPodborStatus.ShowLoading;
var
 errorDescription:string;
begin
  FormDefault;

  // ���������� ������ �� ��������� ����������� ����
  LoadData(Now, Now, eTableSMS);
end;



procedure TFormManualPodborStatus.AddListItem(const _id, _dateTime, _phone, _code, _userId: string;
                                              var p_ListView: TListView);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := _id;      // id
  ListItem.SubItems.Add(_dateTime); // ���� �����
  ListItem.SubItems.Add(_phone);    // ����� ��������
  ListItem.SubItems.Add(_code);     // ��� �������
  ListItem.SubItems.Add(GetUserNameFIO(StrToInt(_userId))); // ��� ��������
end;

// ��������
function TFormManualPodborStatus.Check(var _errorDescription:string):Boolean;
begin
  Result:=False;
  // �������� ����� ���� ������ ���� �� ������ ���� ���������
  if dateStart.Date > dateStop.Date then begin
    _errorDescription:='��� �� ��� �� ����� � �������� �� ��������! '+#13#13+'���� ������ ������ ���� ���������';
    Exit;
  end;

  Result:=True;
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
      Caption:=' ����\����� �������� ';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ����� �������� ';
      Width:=Round((cWidth_default*cWidth_phone)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ��� ������� ';
      Width:=Round((cWidth_default*cWidth_code)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' ��� �������� ';
      Width:=Round((cWidth_default*cWidth_user)/100);
      Alignment:=taCenter;
    end;

 end;
end;

procedure TFormManualPodborStatus.FormDefault;
var
 errorDescription:string;
begin
  // ������������� ����
  if not SetFindDate(dateStart,dateStop,errorDescription) then begin
    MessageBox(Handle,PChar(errorDescription),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;
end;

// ��������� ������
procedure TFormManualPodborStatus.LoadData(_startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus);
begin
  Screen.Cursor:=crHourGlass;

  // ������� �����
  ClearListView(list_History);

  // ���������� ������
  ShowSMS(list_History,_startDate,_stopDate, _table);

  Screen.Cursor:=crDefault;
end;


// ��������� ������������ ���
procedure TFormManualPodborStatus.ShowSMS(var p_ListView:TListView;
                                          _startDate:TDate;
                                          _stopDate:TDate;
                                          _table:enumReportTableSMSStatus);
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
        Append(' and user_id <> ''-1''');
      end;

      SQL.Add(response.ToString);
      Active := True;

      countSMS := Fields[0].Value;

      if countSMS = 0 then
      begin
        // ������� ��� ��� ������
        st_NoSMS.Visible:=True;

        Exit;
      end;

      // �������� ������� ��� ��� ������
      st_NoSMS.Visible:=False;

      SQL.Clear;
      with response do begin
        Clear;
        Append('select id,date_time,phone,status,user_id from '+table);
        Append(' where date_time >='+#39+GetDateToDateBD(DateToStr(_startDate))+' 00:00:00'+#39);
        Append(' and date_time <='+#39+GetDateToDateBD(DateToStr(_stopDate))+' 23:59:59'+#39);
        Append(' and user_id <> ''-1''');
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

        // ������� �� ������, ��������� �����
        AddListItem(id, dateTime, phone, codeStatus, userID,
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


procedure TFormManualPodborStatus.btnStatus_availableClick(Sender: TObject);
var
 errorDescription:string;
begin
  if not Check(errorDescription)  then begin
    MessageBox(Handle,PChar(errorDescription),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  showWait(show_open);
  LoadData(dateStart.Date, dateStop.Date, eTableHistorySMS);
  showWait(show_close);
end;


procedure TFormManualPodborStatus.FormShow(Sender: TObject);
begin
  showWait(show_open);
  ShowLoading;
  showWait(show_close);
end;

procedure TFormManualPodborStatus.list_HistoryCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 status:string;
begin
  if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 4 then // ���������, ��� ���� ���������� SubItems
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
  // �������� ��������� �������
  SelectedItem := list_History.Selected;

  // ���������, ������ �� �������
  if Assigned(SelectedItem) then
  begin
     phone:=SelectedItem.SubItems[1];
     phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);

     FormHome.SetPhoneNumberFindStatusSMS(phone);
     Close;
  end
  else
  begin
    MessageBox(Handle,PChar('�� ������ ����� ��������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

end.
