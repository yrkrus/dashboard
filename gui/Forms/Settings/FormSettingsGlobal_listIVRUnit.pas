unit FormSettingsGlobal_listIVRUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Data.Win.ADODB, Data.DB, Vcl.ExtCtrls, IdException, TIVRTimeUnit, TCustomTypeUnit;

type
  TFormSettingsGlobal_listIVR = class(TForm)
    btnDelete: TBitBtn;
    panel_History: TPanel;
    list_History: TListView;
    st_NoHistory: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure list_HistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  m_ivrTime:TIVRTime;
  SelectedItem: TListItem; // Переменная для хранения выбранного элемента

  procedure ClearListView(var p_ListView:TListView);
  procedure LoadData(var p_ListView:TListView; const p_ivrtime:TIVRTime);
  procedure AddListItem(var p_ListView: TListView;  const p_ivrHistory: TIVRTimeHistory);
  procedure LoadSettings;

  public
    { Public declarations }
  end;

var
  FormSettingsGlobal_listIVR: TFormSettingsGlobal_listIVR;

implementation

uses
  FunctionUnit, FormSettingsGlobalUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}


function getDeleteList(InID:string):string;
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
      SQL.Add('delete from settings where id='+#39+InID+#39);

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




procedure TFormSettingsGlobal_listIVR.ClearListView(var p_ListView:TListView);
const
 cWidth_default  :Word = 386;
 cWidth_date     :Word = 40;
 cWidth_5000     :Word = 20;
 cWidth_5050     :Word = 20;
 cWidth_5911     :Word = 20;
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
      Caption:=' 5000 ';
      Width:=Round((cWidth_default*cWidth_5000)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' 5050 ';
      Width:=Round((cWidth_default*cWidth_5050)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' 5911 ';
      Width:=Round((cWidth_default*cWidth_5911)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormSettingsGlobal_listIVR.AddListItem(var p_ListView: TListView;
                                                  const p_ivrHistory: TIVRTimeHistory);
var
  ListItem: TListItem;
  time_talk: Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := IntToStr(p_ivrHistory.m_id); // id
  ListItem.SubItems.Add(p_ivrHistory.m_date);      // дата время
  ListItem.SubItems.Add(IntToStr(p_ivrHistory.GetTime(queue_5000)));   // 5000
  ListItem.SubItems.Add(IntToStr(p_ivrHistory.GetTime(queue_5050)));   // 5050
  ListItem.SubItems.Add(IntToStr(p_ivrHistory.GetTime(queue_5911)));   // 5911
end;




procedure TFormSettingsGlobal_listIVR.LoadData(var p_ListView:TListView;
                                              const p_ivrtime:TIVRTime);
var
 i:Integer;
begin
  for i:=0 to p_ivrtime.CountHistory-1 do AddListItem(p_ListView, p_ivrtime.ItemsHistory[i]);

  if p_ivrtime.CountHistory > 0 then st_NoHistory.Visible:=False
  else st_NoHistory.Visible:=True;
end;


procedure TFormSettingsGlobal_listIVR.LoadSettings;
begin
  Screen.Cursor:=crHourGlass;

  ClearListView(list_History);

  if not Assigned(m_ivrTime) then m_ivrTime:=TIVRTime.Create(_IVR_TIME_LOAD_HYSTORY)
  else begin
    m_ivrTime.UpdateTime;
    m_ivrTime.UpdateHistory;
  end;

  LoadData(list_History, m_ivrTime);

  Screen.Cursor:=crDefault;
end;

procedure TFormSettingsGlobal_listIVR.btnDeleteClick(Sender: TObject);
var
 resultat:Word;
 error:string;
begin

   if not Assigned(SelectedItem) then begin
    MessageBox(Handle,PChar('Не выбрана строка'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
   end;

   resultat:=MessageBox(Handle,PChar('Точно удалить?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
   if resultat=mrNo then Exit;

   if not (m_ivrTime.Delete(StrToInt(SelectedItem.Caption), error)) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
   end;

  // загружаем новые данные
  LoadSettings;
  MessageBox(Handle,PChar('Строка удалена'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION);
end;



procedure TFormSettingsGlobal_listIVR.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  LoadSettings;

  Screen.Cursor:=crDefault;
end;



procedure TFormSettingsGlobal_listIVR.list_HistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Получаем элемент, на который кликнули
   SelectedItem:= list_History.GetItemAt(X, Y);
end;

end.
