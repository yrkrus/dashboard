unit FormSipPhoneListUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, TSipPhoneListUnit;

type
  TFormSipPhoneList = class(TForm)
    panel_sip: TPanel;
    list_sip: TListView;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    st_NoSip: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure list_sipMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
    procedure list_sipCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
  m_sipList:  TSipPhoneList;
  SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента

  procedure ShowData;
  procedure ClearListView(var p_ListView:TListView);
  procedure AddListItem(var p_ListView: TListView; const _sipList:TSipPhoneList);


  public
    { Public declarations }
  procedure NeedUpdateData; // нужно обновить данные по sip

  end;

var
  FormSipPhoneList: TFormSipPhoneList;

implementation

uses
  FormSipPhoneListAddUnit, TCustomTypeUnit, GlobalVariables;


{$R *.dfm}


procedure TFormSipPhoneList.AddListItem(var p_ListView: TListView; const _sipList:TSipPhoneList);
var
  ListItem: TListItem;
  i:Integer;
begin
  for i:=0 to _sipList.Count-1 do begin
    ListItem := p_ListView.Items.Add;

    ListItem.Caption := IntToStr(_sipList.Items[i].m_id);         // id
    ListItem.SubItems.Add(IntToStr(_sipList.Items[i].m_sip));     // sip

    if _sipList.Items[i].m_userId <> -1 then begin
      ListItem.SubItems.Add(_sipList.Items[i].m_fio);     // за кем закреплен
    end
    else ListItem.SubItems.Add('свободный');
  end;
end;


// очищаем все данные
procedure TFormSipPhoneList.btnAddClick(Sender: TObject);
begin
  FormSipPhoneListAdd.ShowModal;
end;

procedure TFormSipPhoneList.btnDeleteClick(Sender: TObject);
var
 sip:string;
 error:string;
 resultatDel:Word;
begin
  // Проверяем, был ли выбран элемент
  if Assigned(SelectedItemPopMenu) then
  begin
    sip:=SelectedItemPopMenu.SubItems[0];

    resultatDel:=MessageBox(Handle,PChar('Точно удалить SIP '+sip+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
    if resultatDel=mrNo then Exit;

    // проверим что sip пустой
    if m_sipList.IsUsed[sip] then begin
     MessageBox(Handle,PChar('SIP '+sip+' закреплен за оператором'+#13+'Перед удаленем необходимо сначало открепить'),PChar('Ошибка'),MB_OK+MB_ICONSTOP);
     Exit;
    end;

    if not m_sipList.Delete(sip,error) then MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR)
    else begin
      MessageBox(Handle,PChar('SIP '+sip+' удален'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
      NeedUpdateData;
    end;
  end
  else
  begin
   MessageBox(Handle,PChar('Не выбран SIP номер'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;
end;

// нужно обновить данные по sip
procedure TFormSipPhoneList.NeedUpdateData;
begin
  ShowData;
end;

procedure TFormSipPhoneList.ClearListView(var p_ListView:TListView);
const
 cWidth_default       :Word = 330;
 cWidth_sip           :Word = 30;
 cWidth_fio           :Word = 64;
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
      Caption:='SIP';
      Width:=Round((cWidth_default*cWidth_sip)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' За кем закреплен ';
      Width:=Round((cWidth_default*cWidth_fio)/100);
      Alignment:=taCenter;
    end;
 end;
end;

procedure TFormSipPhoneList.ShowData;
begin
  // очищаем все данные
  ClearListView(list_sip);

  if not Assigned(m_sipList) then m_sipList:=TSipPhoneList.Create
  else m_sipList.UpdateData;

  Caption:='Список SIP номеров операторов ['+IntToStr(m_sipList.Count)+']';

  if m_sipList.Count>0 then st_NoSip.Visible:=False
  else st_NoSip.Visible:=True;


  AddListItem(list_sip,m_sipList);
end;


procedure TFormSipPhoneList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  btnDelete.Enabled:=False;
end;

procedure TFormSipPhoneList.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  ShowData;

  Screen.Cursor:=crDefault;
end;

procedure TFormSipPhoneList.list_sipCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
   if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 2 then // Проверяем, что есть достаточно SubItems
    begin

      if Item.SubItems.Strings[1] = 'свободный' then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
        Exit;
      end;

    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('TFormSipPhoneList.list_sipCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;
end;

procedure TFormSipPhoneList.list_sipMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedItemPopMenu := list_sip.GetItemAt(X, Y);

  // выбор варианта на прослушку\скачивание
  if Button = mbLeft then begin
   btnDelete.Enabled:=True;
  end;
end;

end.
