unit FormUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons;

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

  public

    { Public declarations }
  end;

var
  FormUsers: TFormUsers;

implementation

uses
  FunctionUnit, FormAddNewUsersUnit, GlobalVariables;

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

 resultat:=MessageBox(Handle,PChar('Точно отключить '+getUserNameFIO(id)+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
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
