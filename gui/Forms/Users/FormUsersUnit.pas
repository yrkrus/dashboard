unit FormUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TFormUsers = class(TForm)
    PageControl: TPageControl;
    UsersAll: TTabSheet;
    OnlyOPerators: TTabSheet;
    listSG_Users_Footer: TStringGrid;
    listSG_Users: TStringGrid;
    btnShowUsers: TBitBtn;
    btnDisable: TBitBtn;
    btnEditUser: TBitBtn;
    listSG_Operators: TStringGrid;
    listSG_Operators_Footer: TStringGrid;
    chkboxViewDisabled: TCheckBox;
    btnEnable: TBitBtn;
    panel_Users: TPanel;
    list_Users: TListView;
    st_NoUsers: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure btnShowUsersClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure chkboxViewDisabledClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure listSG_UsersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure listSG_OperatorsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnDisableClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEnableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
   currentEditUserId:string;

  procedure LoadData;
  procedure ClearListView(var p_ListView:TListView);
  procedure AddListItem(const id, dateTime, sip, phone, numberQueue, talkTime: string;
                                isReducedTime: Boolean;
                                var p_ListView: TListView);


  public

    { Public declarations }
  end;

var
  FormUsers: TFormUsers;

implementation

uses
  FunctionUnit, FormAddNewUsersUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}

procedure LoadSettingsLogic;
begin
 with FormUsers do begin
   chkboxViewDisabled.Checked:=False;
   chkboxViewDisabled.Visible:=True;
   PageControl.ActivePageIndex:=0;
 end;
end;

procedure LoadSettings;
begin
  with FormUsers do begin

    // вкладка все пользователи
    with listSG_Users_Footer do begin
     RowCount:=1;
     Cells[0,0]:='ID';
     Cells[1,0]:='Фамилия Имя';
     Cells[2,0]:='Логин';
     Cells[3,0]:='Группа прав';
     Cells[4,0]:='Состояние';
    end;

     // вкладка операторы
    with listSG_Operators_Footer do begin
      RowCount:=1;
      Cells[0,0]:='ID';
      Cells[1,0]:='Фамилия Имя';
      Cells[2,0]:='Sip';
      Cells[3,0]:='IP телефон';
      Cells[4,0]:='Группа прав';
    end;


   // прогрузка списка пользователей (False - не показывать отключенных пользователей)
   loadPanel_Users(SharedCurrentUserLogon.GetRole);

   // прогрузка списка пользователей (операторы) (False - не показывать отключенных пользователей)
   loadPanel_Operators;

  end;
end;

procedure TFormUsers.LoadData;
begin
   Screen.Cursor:=crHourGlass;
   ClearListView(list_Users);





   Screen.Cursor:=crDefault;

end;

procedure TFormUsers.ClearListView(var p_ListView:TListView);
const
 cWidth_default       :Word = 950;
 cWidth_id            :Word = 3;
 cWidth_auth          :Word = 10;
 cWidth_fio           :Word = 10;
 cWidth_group         :Word = 10;
 cWidth_access_report :Word = 10;
 cWidth_access_chat   :Word = 10;
 cWidth_access_sms    :Word = 10;
 cWidth_access_call   :Word = 10;
 cWidth_last_enter    :Word = 10;
begin
 with p_ListView do begin

    Items.Clear;
    Columns.Clear;
    ViewStyle:= vsReport;

    with Columns.Add do
    begin
      Caption:='ID';
      Width:=Round((cWidth_default*cWidth_id)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Авторизация';
      Width:=Round((cWidth_default*cWidth_auth)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Фамилия Имя ';
      Width:=Round((cWidth_default*cWidth_fio)/100);
      Alignment:=taCenter;
    end;



    with Columns.Add do
    begin
      Caption:=' Группа ';
      Width:=Round((cWidth_default*cWidth_group)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Отчеты ';
      Width:=Round((cWidth_default*cWidth_access_report)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' Чат ';
      Width:=Round((cWidth_default*cWidth_access_chat)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' SMS ';
      Width:=Round((cWidth_default*cWidth_access_sms)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Звонки ';
      Width:=Round((cWidth_default*cWidth_access_call)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Активность ';
      Width:=Round((cWidth_default*cWidth_last_enter)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormUsers.AddListItem(const id, dateTime, sip, phone, numberQueue, talkTime: string;
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

procedure TFormUsers.btnDisableClick(Sender: TObject);
var
resultat:Word;
id:Integer;
error:string;
begin
 if currentEditUserId='1' then begin
    MessageBox(Handle,PChar('Разработчика нельзя отключить!'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 if currentEditUserId='' then begin
    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 id:=StrToInt(currentEditUserId);

 // проверим операторская ли учетка
 if not IsUserOperator(id) then begin
   resultat:=MessageBox(Handle,PChar('Точно отключить '+getUserNameFIO(id)+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
 end
 else begin
   resultat:=MessageBox(Handle,PChar('Точно отключить '+getUserNameFIO(id)+'?'+#13#13+
                                     'ВАЖНО! Отключенную учетную запись оператора не получится обратно восстановить' ),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
 end;

 if resultat=mrNo then Exit;

  // отключаем
  if not DisableUser(id, error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  // загружаем новые данные
    LoadSettings;

  MessageBox(Handle,PChar('Пользователь отключен'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION);

end;

procedure TFormUsers.btnEditUserClick(Sender: TObject);
begin
  if currentEditUserId='1' then begin
    MessageBox(Handle,PChar('Разработчика нельзя отредактировать!'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if currentEditUserId='' then begin
    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  with FormAddNewUsers do begin
    currentEditUsers:=True;
    currentEditUsersID:=StrToInt64(currentEditUserId);

    // сбрасываем что идет редактирование
    currentEditUserId:='';

    ShowModal;
  end;

end;

procedure TFormUsers.btnEnableClick(Sender: TObject);
var
  resultat:Word;
  id:Integer;
  error:string;
begin
 if currentEditUserId='' then begin
    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 id:=StrToInt(currentEditUserId);

 resultat:=MessageBox(Handle,PChar('Точно включить '+getUserNameFIO(id)+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
 if resultat=mrNo then Exit;


  // включаем
  if not EnableUser(id,error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // загружаем новые данные
  LoadSettings;
  LoadSettingsLogic;

  MessageBox(Handle,PChar('Пользователь включен'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormUsers.btnShowUsersClick(Sender: TObject);
begin
 FormAddNewUsers.ShowModal;
end;

procedure TFormUsers.chkboxViewDisabledClick(Sender: TObject);
begin
  if chkboxViewDisabled.Checked then begin
   loadPanel_Users(SharedCurrentUserLogon.GetRole,True);
   btnDisable.Visible:=False;

   btnEditUser.Enabled:=False;


   btnEnable.Visible:=True;
   btnEnable.Top:=btnDisable.Top;
   btnEnable.Left:=btnDisable.Left;
  end
  else begin
   loadPanel_Users(SharedCurrentUserLogon.GetRole);

   btnEditUser.Enabled:=True;

   btnDisable.Visible:=True;
   btnEnable.Visible:=False;
  end;

end;

procedure TFormUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LoadSettingsLogic;
end;

procedure TFormUsers.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormUsers.FormShow(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;

  // текущий выбранный пользак
  currentEditUserId:='';


  LoadData;

//
  LoadSettings;
  LoadSettingsLogic;

  Screen.Cursor:=crDefault;
end;

procedure TFormUsers.listSG_OperatorsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
  var
   id:Integer;
begin
  // получаем id из sip
  if listSG_Operators.Cells[2,ARow]<>'' then begin
    id:=getUserID(StrToInt(listSG_Operators.Cells[2,ARow]));

    currentEditUserId:=IntToStr(id);
  end;

end;

procedure TFormUsers.listSG_UsersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if listSG_Users.Cells[0,ARow]<>'' then begin
    currentEditUserId:=listSG_Users.Cells[0,ARow];
  end;
end;

procedure TFormUsers.PageControlChange(Sender: TObject);
begin
   currentEditUserId:='';

   if PageControl.ActivePage.Caption='Все пользователи' then begin
    chkboxViewDisabled.Visible:=True;
    btnDisable.Enabled:=True;

    if chkboxViewDisabled.Checked then begin
     btnEnable.Enabled:=True;
    end;

   end
   else begin
     chkboxViewDisabled.Visible:=False;
     btnDisable.Enabled:=False;

     btnEnable.Enabled:=False;
   end;

end;

end.
