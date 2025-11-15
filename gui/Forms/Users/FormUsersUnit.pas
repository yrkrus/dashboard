unit FormUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, TUsersAllUnit, TUserUnit, System.DateUtils,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

//type  // поиск по
// enumFind = ( eFindFamiliya,  // фамилия
//              eFindName       // имя
//            );

type
  TFormUsers = class(TForm)
    btnShowUsers: TBitBtn;
    btnDisabled: TBitBtn;
    btnEditUser: TBitBtn;
    btnEnable: TBitBtn;
    panel_Users: TPanel;
    list_Users: TListView;
    editFindMessage: TEdit;
    btn_Find: TBitBtn;
    StaticText1: TStaticText;
    combox_find: TComboBox;
    chkbox_users_NoEnterProgramm: TLabel;
    img_users_NoEnterProgramm: TImage;
    chkbox_users_ShowDisabled: TLabel;
    img_users_ShowDisabled: TImage;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnShowUsersClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure btnDisabledClick(Sender: TObject);
    procedure btnEnableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chkbox_users_NoEnterProgrammClick(Sender: TObject);
    procedure img_users_NoEnterProgrammClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure list_UsersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure list_UsersCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);

  private
    { Private declarations }
   m_usersAll: TUsersAll;
   SelectedItemPopMenu: TListItem;  // Переменная для хранения выбранного элемента


  procedure LoadData;
  procedure ClearListView(var p_ListView:TListView);
  procedure AddListItem(const _user:TUser; var p_ListView: TListView);
  function ShowLastActiveTime(_datetime:TDateTime):string;
  procedure ShowHideUsersNotEntered; // показать\скрыть пользователей не входивших ни разу


  public  { Public declarations }
  procedure UpdateUsersAfterAddOrEdit; // обновление данных после добавения\редактирования пользователя

  end;

var
  FormUsers: TFormUsers;

implementation

uses
  FunctionUnit, FormAddNewUsersUnit, GlobalVariables, GlobalVariablesLinkDLL, TCustomTypeUnit;

{$R *.dfm}

// === NO CLASS ===
// START


function PluralDays(Days: Int64): string;
var
  d100, d10: Integer;
begin
  // проверяем исключения для 11…14
  d100 := Days mod 100;
  if (d100 >= 11) and (d100 <= 14) then
    Exit(Format('%d дней', [Days]));

  // смотрим последнюю цифру
  d10 := Days mod 10;
  case d10 of
    1: Result := Format('%d день', [Days]);
    2, 3, 4: Result := Format('%d дня', [Days]);
  else
    Result := Format('%d дней', [Days]);
  end;
end;
// END
// === NO CLASS ===


// показать\скрыть пользователей не входивших ни разу
procedure TFormUsers.ShowHideUsersNotEntered;
var
 i:Integer;
 countUsers:Integer;
begin
  Screen.Cursor:=crHourGlass;

  // меняем статус
  SharedCheckBoxUI.ChangeStatusCheckBox('users_NoEnterProgramm');
  ClearListView(list_Users);
  countUsers:=0;

  for i:=0 to m_usersAll.Count-1 do begin
    if m_usersAll.Items[i].IsNotActiveAccount then Continue;

    if SharedCheckBoxUI.Checked['users_NoEnterProgramm'] then begin
       if m_usersAll.Items[i].LastActive = 0 then Continue;
    end;

    AddListItem(m_usersAll.Items[i], list_Users);
    Inc(countUsers);
  end;

  Caption:='Пользователи ['+IntToStr(countUsers)+']';

  Screen.Cursor:=crDefault;
end;



// время активности
function TFormUsers.ShowLastActiveTime(_datetime:TDateTime):string;
const
 cDayTime:Cardinal = 86400;
var
 diff:Int64;
 unixTime,unixCurrentTime:Int64;
 days: Int64;
begin
  unixCurrentTime:=DateTimeToUnix(_datetime);
  unixTime:=DateTimeToUnix(Now);

  diff := unixTime - unixCurrentTime;
  if diff <= cDayTime then begin
    Result:=' (сегодня)';
    Exit;
  end
  else begin
    days := diff div cDayTime;
    if days = 1 then begin
     Result:=' (вчера)';
    end
    else Result := Format(' (%s назад)', [PluralDays(days)]);
  end;
end;



procedure TFormUsers.LoadData;
var
 i:Integer;
 countUsers:Integer;
begin
   showWait(show_open);

   if not Assigned(m_usersAll) then m_usersAll:=TUsersAll.Create(SharedCurrentUserLogon.Role)
   else m_usersAll.Update;

   ClearListView(list_Users);
   countUsers:=0;

   for i:=0 to m_usersAll.Count-1 do begin
     if m_usersAll.Items[i].IsNotActiveAccount then Continue;

     AddListItem(m_usersAll.Items[i], list_Users);
     Inc(countUsers);
   end;


   Caption:='Пользователи ['+IntToStr(countUsers)+']';
   showWait(show_close);

end;

procedure TFormUsers.ClearListView(var p_ListView:TListView);
const
 cWidth_default       :Word = 1210;
 cWidth_id            :Word = 3;
 cWidth_auth          :Word = 8;
 cWidth_fio           :Word = 19;
 cWidth_group         :Word = 15;
 cWidth_sip           :Word = 5;
 cWidth_queue         :Word = 10;
 cWidth_access_report :Word = 5;
 cWidth_access_chat   :Word = 4;
 cWidth_access_sms    :Word = 4;
 cWidth_access_call   :Word = 5;
 cWidth_last_enter    :Word = 20;
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
      Caption:='Фамилия Имя';
      Width:=Round((cWidth_default*cWidth_fio)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Группа';
      Width:=Round((cWidth_default*cWidth_group)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Sip';
      Width:=Round((cWidth_default*cWidth_sip)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Очереди';
      Width:=Round((cWidth_default*cWidth_queue)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Отчеты';
      Width:=Round((cWidth_default*cWidth_access_report)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:='Чат';
      Width:=Round((cWidth_default*cWidth_access_chat)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='SMS';
      Width:=Round((cWidth_default*cWidth_access_sms)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Звонки';
      Width:=Round((cWidth_default*cWidth_access_call)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:='Активность';
      Width:=Round((cWidth_default*cWidth_last_enter)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormUsers.AddListItem(const _user:TUser;
                                 var p_ListView: TListView);
var
  ListItem: TListItem;
  time_talk: Integer;
  sip:Integer;
begin
  ListItem := p_ListView.Items.Add;
  ListItem.Caption := IntToStr(_user.ID);      // id
  ListItem.SubItems.Add(EnumAuthToString(_user.Auth));          // авторизация
  ListItem.SubItems.Add(_user.Familiya+' '+_user.Name);         // фаимилия и имя
  ListItem.SubItems.Add(EnumRoleToString(_user.Role));          // группа

  // sip
  if _user.IsOperator then begin
   sip:=_dll_GetOperatorSIP(_user.ID);
   if sip <> -1 then ListItem.SubItems.Add(IntToStr(sip))
   else  ListItem.SubItems.Add('---');
  end
  else  ListItem.SubItems.Add('---');

  // очереди
  ListItem.SubItems.Add(_user.CommonQueueSTR);

  // доступы
  begin
    // отчеты
    if _user.IsAccessReports then ListItem.SubItems.Add('X')
    else ListItem.SubItems.Add('---');

    // чат
    if _user.IsAccessLocalChat then ListItem.SubItems.Add('X')
    else ListItem.SubItems.Add('---');

    // sms
    if _user.IsAccessSMS then ListItem.SubItems.Add('X')
    else ListItem.SubItems.Add('---');

    // звонки
    if _user.IsAccessCalls then ListItem.SubItems.Add('X')
    else ListItem.SubItems.Add('---');
  end;

  // активность
  if _user.LastActive <> 0 then begin
    ListItem.SubItems.Add(DateTimeToStr(_user.LastActive) + ShowLastActiveTime(_user.LastActive))
  end
  else ListItem.SubItems.Add('никогда');

end;

procedure TFormUsers.btnDisabledClick(Sender: TObject);
var
 userId:Integer;
 resultat:Word;
 errorDescription:string;
begin
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  userId:=StrToInt(SelectedItemPopMenu.Caption);

  if userId=1 then begin
    MessageBox(Handle,PChar('Разработчика не получится удалить'),PChar('Низя'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  resultat:=MessageBox(Handle,PChar('Точно удалить '+GetUserNameFIO(userId)+'?'+#13#13+
                                    'ВНИМАНИЕ! Восстановить удаленную учетную запись не получиться' ),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrNo then Exit;

  resultat:=MessageBox(Handle,PChar('ВНИМАНИЕ! ВОССТАНОВИТЬ НЕ ПОЛУЧИТСЯ!!!'+#13#13+'Точно удаляем?' ),PChar('Последнее предупреждение'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrNo then Exit;

  // отключаем
  if not DisableUser(userId, errorDescription) then begin
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // загружаем новые данные
  LoadData;

  MessageBox(Handle,PChar('Пользователь удален'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);

end;


{

var
 userId:string;
begin






  with FormAddNewUsers do begin
    IsEdit:=True;
    IsEditID:=StrToInt(userId);
    ShowModal;
  end;

end;

}


procedure TFormUsers.btnEditUserClick(Sender: TObject);
var
 userId:string;
begin
  if not Assigned(SelectedItemPopMenu) then begin
    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  userId:=SelectedItemPopMenu.Caption;

  if userId='1' then begin
    if SharedCurrentUserLogon.ID <> 1 then begin
     MessageBox(Handle,PChar('Разработчика не получится отредактировать'),PChar('Низя'),MB_OK+MB_ICONERROR);
     Exit;
    end;
  end;

  with FormAddNewUsers do begin
    IsEdit:=True;
    IsEditID:=StrToInt(userId);
    ShowModal;
  end;

end;

procedure TFormUsers.btnEnableClick(Sender: TObject);
var
  resultat:Word;
  id:Integer;
  error:string;
begin
// if currentEditUserId='' then begin
//    MessageBox(Handle,PChar('Не выбран пользователь'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
//    Exit;
// end;
//
// id:=StrToInt(currentEditUserId);
//
// resultat:=MessageBox(Handle,PChar('Точно включить '+getUserNameFIO(id)+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
// if resultat=mrNo then Exit;
//
//
//  // включаем
//  if not EnableUser(id,error) then begin
//    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
//    Exit;
//  end;
//
////  // загружаем новые данные
////  LoadSettings;
////  LoadSettingsLogic;
//
//  MessageBox(Handle,PChar('Пользователь включен'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormUsers.btnShowUsersClick(Sender: TObject);
begin
 FormAddNewUsers.ShowModal;
end;

procedure TFormUsers.Button1Click(Sender: TObject);
var
 txt:string;
 i:Integer;
begin
  with list_Users do begin

   txt:='';
   for i:=0 to 10 do begin
      if txt='' then txt:=Column[i].Caption+' : '+IntToStr(Column[i].Width)
      else  txt:=txt+#13+Column[i].Caption+' : '+IntToStr(Column[i].Width)
   end;

   ShowMessage(txt);

  end;
end;


procedure TFormUsers.chkbox_users_NoEnterProgrammClick(Sender: TObject);
begin
 ShowHideUsersNotEntered;
end;

procedure TFormUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SharedCheckBoxUI.ChangeStatusCheckBox('users_NoEnterProgramm', paramStatus_DISABLED);

   btnEditUser.Enabled:=False;
   btnDisabled.Enabled:=False;
end;

procedure TFormUsers.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormUsers.FormShow(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;

  // текущий выбранный пользак
 // currentEditUserId:='';


  LoadData;



  Screen.Cursor:=crDefault;
end;

procedure TFormUsers.img_users_NoEnterProgrammClick(Sender: TObject);
begin
 ShowHideUsersNotEntered;
end;



procedure TFormUsers.list_UsersCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 time_talk:Integer;
 test:string;
 longtalk:string;
begin
  if not Assigned(Item) then Exit;

  try
    if Item.SubItems.Count = 10 then // Проверяем, что есть достаточно SubItems
    begin
      if Item.SubItems.Strings[0] = EnumAuthToString(eAuthLdap) then
      begin
        Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Good);
        Exit;
      end;
    end;

   Sender.Canvas.Font.Color := EnumColorStatusToTColor(color_Default);
  except
    on E:Exception do
    begin
     SharedMainLog.Save('TFormUsers.list_UsersCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;
end;

procedure TFormUsers.list_UsersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectedItemPopMenu := list_Users.GetItemAt(X, Y);

  if Button = mbLeft then begin
   btnEditUser.Enabled:=True;
   btnDisabled.Enabled:=True;
  end;
end;

// обновление данных после добавения\редактирования пользователя
procedure TFormUsers.UpdateUsersAfterAddOrEdit;
begin

   LoadData;

//   m_usersAll.Update;
//
//   ClearListView(list_Users);
//   countUsers:=0;
//
//   for i:=0 to m_usersAll.Count-1 do begin
//     if m_usersAll.Items[i].IsNotActiveAccount then Continue;
//
//     AddListItem(m_usersAll.Items[i], list_Users);
//     Inc(countUsers);
//   end;
//
//   Caption:='Пользователи ['+IntToStr(countUsers)+']';

end;


end.
