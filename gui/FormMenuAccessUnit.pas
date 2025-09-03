unit FormMenuAccessUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.Win.ADODB, Data.DB, IdException,
  TUserAccessUnit, TCustomTypeUnit;

// ==============================================================================


  type
   TStructAccess = class

   public
   m_accesslist           :enumAccessList;
   m_name_component       :string;
   m_status               :Boolean;

   constructor Create(_access:enumAccessList);                  overload;
   end;


  type
   TRoleAccess = class
   public
   m_role     :enumRole;
   m_count    :Integer;
   m_chkList  :TArray<TStructAccess>;

   constructor Create(_role:enumRole);                     overload;
   procedure SetData(_access:enumAccessList; _name:string; _param:Boolean);

   function GetStatusAccess(_access:enumAccessList):Boolean;   // получение статуса в зависимости от доступа
   procedure SetStatusAccess(_access:enumAccessList; _value:Boolean); //изменение статуса
   function GetNameAccess(_access:enumAccessList):string;      // получение названия компонента

   property Count:Integer read m_count;
   property Role:enumRole read m_role;

   end;



  type  // класс в котором храниться список с параметрами названий компонентов
    TFormAccessList = class
    private
    m_count   :Integer;

    public
    m_list    :TArray<TRoleAccess>;

    constructor Create;                     overload;
    procedure SetAccess(_role:enumRole; _access:enumAccessList;  var _chkbox:TCheckBox);

    property Count:Integer read m_count;

    end;

// ==============================================================================


type
  TFormMenuAccess = class(TForm)
    group: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    CheckBox7: TCheckBox;
    Label11: TLabel;
    CheckBox8: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  list_access     :TArray<TUserAccess>;
  m_count         :Integer; // кол-во элементов

  list_form       :TFormAccessList;

  isCreateForm:Boolean;     // флаг того что уже создвали данные на форме

  procedure Show;
  procedure CreateListAccess;        // текущий список доступов
  procedure Clear;
  procedure CreateDataForm;          // создание элементов на форме

  procedure UpdateAccess;            //обновление данных по доступу
  // сохранение текущих параметров в кэш
  procedure SetFormCache(_role:enumRole; _access:enumAccessList; var _chk:TCheckBox);

  // отправка данных в БД
  function GetResponceBD(_role:enumRole;
                         _access:enumAccessList;
                         _value:enumStatus;
                         var _errorDescription:string):Boolean;


  public
    { Public declarations }
  end;

var
  FormMenuAccess: TFormMenuAccess;

implementation

uses
  GlobalVariablesLinkDLL;

{$R *.dfm}
// ======================== TFormAccessList =====================================

constructor TStructAccess.Create(_access:enumAccessList);
begin
  //inherited;
  m_accesslist:=_access;

  m_name_component:='';
  m_status:=False;
end;



constructor TRoleAccess.Create(_role:enumRole);
var
 i:Integer;
begin
 //inherited;
 m_role:=_role;
 m_count:=Ord(High(enumAccessList)) + 1;

 SetLength(m_chkList, m_count);

 for i:=0 to m_count - 1 do  m_chkList[i]:=TStructAccess.Create(enumAccessList(i));
end;


procedure TRoleAccess.SetData(_access:enumAccessList; _name:string; _param:Boolean);
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    if m_chkList[i].m_accesslist = _access then begin
      m_chkList[i].m_name_component:=_name;
      m_chkList[i].m_status:=_param;
    end;
  end;
end;

 // получение статуса в зависимости от доступа
function TRoleAccess.GetStatusAccess(_access:enumAccessList):Boolean;
var
 i:Integer;
begin
 for i:=0 to m_count - 1 do begin
   if  m_chkList[i].m_accesslist = _access then
   begin
      Result:=m_chkList[i].m_status;
      Exit;
   end;
 end;
end;

//изменение статуса
procedure TRoleAccess.SetStatusAccess(_access:enumAccessList; _value:Boolean);
var
 i:Integer;
begin
 for i:=0 to m_count - 1 do begin
   if  m_chkList[i].m_accesslist = _access then
   begin
      m_chkList[i].m_status:=_value;
      Exit;
   end;
 end;
end;

 // получение названия компонента
function TRoleAccess.GetNameAccess(_access:enumAccessList):string;
var
 i:Integer;
begin
  for i:=0 to m_count - 1 do begin
   if  m_chkList[i].m_accesslist = _access then
   begin
      Result:=m_chkList[i].m_name_component;
      Exit;
   end;
 end;
end;

constructor TFormAccessList.Create;
var
 i,count_role:Integer;
begin
 //inherited;
  count_role:= Ord(High(enumRole)) + 1;  // для корректности размерности
  m_count:=count_role;

 SetLength(m_list,m_count);

 for i:=0 to m_count - 1 do m_list[i]:=TRoleAccess.Create(enumRole(i));

end;


 procedure TFormAccessList.SetAccess(_role:enumRole; _access:enumAccessList; var _chkbox:TCheckBox);
 var
  i,j:Integer;
 begin
   for i:=0 to m_count -  1 do begin
     if m_list[i].m_role = _role then begin
        m_list[i].SetData(_access, _chkbox.Name, _chkbox.Checked);
     end;
   end;
 end;

// ======================== TFormAccessList END =================================


// отправка данных в БД
function TFormMenuAccess.GetResponceBD(_role:enumRole;
                                       _access:enumAccessList;
                                       _value:enumStatus;
                                       var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 status:Integer;
 base_filed:string;
begin
  Screen.Cursor:=crHourGlass;
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     FreeAndNil(ado);
     Exit;
  end;

  // какой статус нам  прилетел
  status:=EnumStatusToInteger(_value);
  base_filed:=EnumAccessListToStringBaseName(_access);

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update access_panel set '+base_filed+' = '+#39+IntToStr(status)+#39
                                                     +' where role = '+#39+IntToStr(GetRoleID(EnumRoleToString(_role)))+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
            Screen.Cursor:=crDefault;
            _errorDescription:=e.ClassName+': '+e.Message;
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
  Result:=True;
end;



 //обновление данных по доступу
procedure TFormMenuAccess.UpdateAccess;
var
 i,j,k:Integer;
 Control:TControl;
 GroupBox: TGroupBox;
 CheckBox: TCheckBox;
 role:enumRole;
 status:Boolean;
 component_name:string;

 isErrorUpdate:Boolean;
 list_error:TStringList;
 error:string;
begin

  isErrorUpdate:=False; // в процессе обновления возникли ошибки
  list_error:=TStringList.Create;
  list_error.Add('В процессе обновления возникли ошибки: ');
  list_error.Add('');


  // найлем сначало компонент TGroupBox
  for i:=0 to Self.ControlCount - 1 do
  begin
    Control:= Self.Controls[i];

    // Проверяем, является ли контрол TGroupBox
    if Control is TGroupBox then
    begin
      GroupBox:= TGroupBox(Control); // Приводим Control к TGroupBox
    end;
  end;

  if not Assigned(GroupBox) then Exit;

  for i:=0 to list_form.Count - 1 do begin
     role:=list_form.m_list[i].Role;

     for j:=0 to Ord(High(enumAccessList)) do begin
       status:=list_form.m_list[i].GetStatusAccess(enumAccessList(j));
       component_name:=list_form.m_list[i].GetNameAccess(enumAccessList(j));

       // сверяемся были ли изменения на форме
       begin
          CheckBox := TCheckBox(GroupBox.FindComponent(component_name));

          if not Assigned(CheckBox) then Continue;
          if status = CheckBox.Checked then Continue;

          // есть изменения зафиксируем их
          begin
            if not GetResponceBD(role, enumAccessList(j), BooleanToEnumStatus(CheckBox.Checked), error) then begin
              list_error.Add(component_name + ': '+BooleanToString(status) +' -> '+ BooleanToString(CheckBox.Checked));
              isErrorUpdate:=True;

            end else begin
             list_form.m_list[i].SetStatusAccess(enumAccessList(j),CheckBox.Checked);
            end;
          end;
       end;
     end;
  end;

  if isErrorUpdate then begin
   MessageBox(Handle,PChar(list_error.Text),PChar('Ошибка обновления данных'),MB_OK+MB_ICONERROR);
  end;

  if Assigned(list_error) then FreeAndNil(list_error);
end;



// сохранение текущих параметров в кэш
procedure TFormMenuAccess.SetFormCache(_role:enumRole; _access:enumAccessList; var _chk:TCheckBox);
begin
  list_form.SetAccess(_role, _access, _chk);
end;


procedure TFormMenuAccess.CreateDataForm;
const
  cTOPSTART=40;
  cSTEP:Word = 25;
var
 lblNameRole                        :array of TLabel;
 chkbox_menu_settings_users         :array of TCheckBox;
 chkbox_menu_settings_serversik     :array of TCheckBox;
 chkbox_menu_settings_siptrunk      :array of TCheckBox;
 chkbox_menu_settings_global        :array of TCheckBox;
 chkbox_menu_active_session         :array of TCheckBox;
 chkbox_menu_service                :array of TCheckBox;
 chkbox_menu_missed_calls           :array of TCheckBox;
 chkbox_menu_clear_status_operator  :array of TCheckBox;

 i:Integer;
 nameRole:string;
begin
  // выставляем размерность
  SetLength(lblNameRole,m_count);
  SetLength(chkbox_menu_settings_users,m_count);
  SetLength(chkbox_menu_settings_serversik,m_count);
  SetLength(chkbox_menu_settings_siptrunk,m_count);
  SetLength(chkbox_menu_settings_global,m_count);
  SetLength(chkbox_menu_active_session,m_count);
  SetLength(chkbox_menu_service,m_count);
  SetLength(chkbox_menu_missed_calls,m_count);
  SetLength(chkbox_menu_clear_status_operator,m_count);

  for i:=0 to m_count-1 do begin
    nameRole:= EnumRoleToStringName(list_access[i].Role);

    // названи группы роли
    begin
        lblNameRole[i]:=TLabel.Create(FormMenuAccess.group);
        lblNameRole[i].Name:='lbl_'+nameRole;
        lblNameRole[i].Tag:=1;
        lblNameRole[i].Caption:=EnumRoleToString(list_access[i].Role);
        lblNameRole[i].Left:=7;

        if i=0 then lblNameRole[i].Top:=cTOPSTART
        else lblNameRole[i].Top:=cTOPSTART+(cSTEP * i);

        lblNameRole[i].Font.Name:='Tahoma';
        lblNameRole[i].Font.Size:=10;
        lblNameRole[i].AutoSize:=False;
        lblNameRole[i].Width:=196;
        lblNameRole[i].Height:=16;
        lblNameRole[i].Alignment:=taCenter;
        lblNameRole[i].Parent:=FormMenuAccess.group;
    end;

    // глобальные настройки
    begin
        chkbox_menu_settings_global[i]:=TCheckBox.Create(FormMenuAccess.group);
        chkbox_menu_settings_global[i].Name:='chk_global_'+nameRole;
        chkbox_menu_settings_global[i].Tag:=1;
        chkbox_menu_settings_global[i].Caption:='';
        chkbox_menu_settings_global[i].Left:=295;

        if i=0 then chkbox_menu_settings_global[i].Top:=cTOPSTART
        else chkbox_menu_settings_global[i].Top:=cTOPSTART+(cSTEP * i);

        chkbox_menu_settings_global[i].Font.Name:='Tahoma';
        chkbox_menu_settings_global[i].Font.Size:=12;
        chkbox_menu_settings_global[i].Width:=16;
        chkbox_menu_settings_global[i].Height:=17;
        chkbox_menu_settings_global[i].Parent:=FormMenuAccess.group;

        if list_access[i].menu_settings_global then chkbox_menu_settings_global[i].Checked:=True;

        // чтобы случайно себе в ногу е выстрелить
        if (list_access[i].Role = role_administrator) or (list_access[i].Role = role_operator_no_dash) then begin
          chkbox_menu_settings_global[i].Enabled:=False;
        end;

        // сохраним текущие данные в кзш
        SetFormCache(list_access[i].Role, menu_settings_global, chkbox_menu_settings_global[i]);
    end;

    // пользователи
    begin
      chkbox_menu_settings_users[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_settings_users[i].Name:='chk_users_'+nameRole;
      chkbox_menu_settings_users[i].Tag:=1;
      chkbox_menu_settings_users[i].Caption:='';
      chkbox_menu_settings_users[i].Left:=432;

      if i=0 then chkbox_menu_settings_users[i].Top:=cTOPSTART
      else chkbox_menu_settings_users[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_settings_users[i].Font.Name:='Tahoma';
      chkbox_menu_settings_users[i].Font.Size:=12;
      chkbox_menu_settings_users[i].Width:=16;
      chkbox_menu_settings_users[i].Height:=17;
      chkbox_menu_settings_users[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_settings_users then chkbox_menu_settings_users[i].Checked:=True;


      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_settings_users[i].Enabled:=False;
      end;

       // сохраним текущие данные в кзш
       SetFormCache(list_access[i].Role, menu_settings_users, chkbox_menu_settings_users[i]);

    end;


    // сервера ИК
    begin
      chkbox_menu_settings_serversik[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_settings_serversik[i].Name:='chk_serversik_'+nameRole;
      chkbox_menu_settings_serversik[i].Tag:=1;
      chkbox_menu_settings_serversik[i].Caption:='';
      chkbox_menu_settings_serversik[i].Left:=521;

      if i=0 then chkbox_menu_settings_serversik[i].Top:=cTOPSTART
      else chkbox_menu_settings_serversik[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_settings_serversik[i].Font.Name:='Tahoma';
      chkbox_menu_settings_serversik[i].Font.Size:=12;
      chkbox_menu_settings_serversik[i].Width:=16;
      chkbox_menu_settings_serversik[i].Height:=17;
      chkbox_menu_settings_serversik[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_settings_serversik then chkbox_menu_settings_serversik[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_settings_serversik[i].Enabled:=False;
      end;

       // сохраним текущие данные в кзш
       SetFormCache(list_access[i].Role, menu_settings_serversik, chkbox_menu_settings_serversik[i]);
    end;

    // SIP транки
    begin
      chkbox_menu_settings_siptrunk[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_settings_siptrunk[i].Name:='chk_siptrunk_'+nameRole;
      chkbox_menu_settings_siptrunk[i].Tag:=1;
      chkbox_menu_settings_siptrunk[i].Caption:='';
      chkbox_menu_settings_siptrunk[i].Left:=602;

      if i=0 then chkbox_menu_settings_siptrunk[i].Top:=cTOPSTART
      else chkbox_menu_settings_siptrunk[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_settings_siptrunk[i].Font.Name:='Tahoma';
      chkbox_menu_settings_siptrunk[i].Font.Size:=12;
      chkbox_menu_settings_siptrunk[i].Width:=16;
      chkbox_menu_settings_siptrunk[i].Height:=17;
      chkbox_menu_settings_siptrunk[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_settings_siptrunk then chkbox_menu_settings_siptrunk[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_settings_siptrunk[i].Enabled:=False;
      end;

        // сохраним текущие данные в кзш
       SetFormCache(list_access[i].Role, menu_settings_siptrunk, chkbox_menu_settings_siptrunk[i]);

    end;


    // услуги
    begin
      chkbox_menu_service[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_service[i].Name:='chk_service_'+nameRole;
      chkbox_menu_service[i].Tag:=1;
      chkbox_menu_service[i].Caption:='';
      chkbox_menu_service[i].Left:=671;

      if i=0 then chkbox_menu_service[i].Top:=cTOPSTART
      else chkbox_menu_service[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_service[i].Font.Name:='Tahoma';
      chkbox_menu_service[i].Font.Size:=12;
      chkbox_menu_service[i].Width:=16;
      chkbox_menu_service[i].Height:=17;
      chkbox_menu_service[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_service then chkbox_menu_service[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_service[i].Enabled:=False;
      end;

      // сохраним текущие данные в кзш
      SetFormCache(list_access[i].Role, menu_service, chkbox_menu_service[i]);

    end;


    // пропущенные звонки
    begin
      chkbox_menu_missed_calls[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_missed_calls[i].Name:='chk_missed_calls_'+nameRole;
      chkbox_menu_missed_calls[i].Tag:=1;
      chkbox_menu_missed_calls[i].Caption:='';
      chkbox_menu_missed_calls[i].Left:=782;

      if i=0 then chkbox_menu_missed_calls[i].Top:=cTOPSTART
      else chkbox_menu_missed_calls[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_missed_calls[i].Font.Name:='Tahoma';
      chkbox_menu_missed_calls[i].Font.Size:=12;
      chkbox_menu_missed_calls[i].Width:=16;
      chkbox_menu_missed_calls[i].Height:=17;
      chkbox_menu_missed_calls[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_missed_calls then chkbox_menu_missed_calls[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_missed_calls[i].Enabled:=False;
      end;

      // сохраним текущие данные в кзш
      SetFormCache(list_access[i].Role, menu_missed_calls, chkbox_menu_missed_calls[i]);

    end;

     // активные сесии
    begin
      chkbox_menu_active_session[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_active_session[i].Name:='chk_active_session_'+nameRole;
      chkbox_menu_active_session[i].Tag:=1;
      chkbox_menu_active_session[i].Caption:='';
      chkbox_menu_active_session[i].Left:=927;

      if i=0 then chkbox_menu_active_session[i].Top:=cTOPSTART
      else chkbox_menu_active_session[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_active_session[i].Font.Name:='Tahoma';
      chkbox_menu_active_session[i].Font.Size:=12;
      chkbox_menu_active_session[i].Width:=16;
      chkbox_menu_active_session[i].Height:=17;
      chkbox_menu_active_session[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_active_session then chkbox_menu_active_session[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_active_session[i].Enabled:=False;
      end;

      // сохраним текущие данные в кзш
      SetFormCache(list_access[i].Role, menu_active_session, chkbox_menu_active_session[i]);

    end;


    // сброс панели статусов
    begin
      chkbox_menu_clear_status_operator[i]:=TCheckBox.Create(FormMenuAccess.group);
      chkbox_menu_clear_status_operator[i].Name:='chk_clear_status_operator_'+nameRole;
      chkbox_menu_clear_status_operator[i].Tag:=1;
      chkbox_menu_clear_status_operator[i].Caption:='';
      chkbox_menu_clear_status_operator[i].Left:=1053;

      if i=0 then chkbox_menu_clear_status_operator[i].Top:=cTOPSTART
      else chkbox_menu_clear_status_operator[i].Top:=cTOPSTART+(cSTEP * i);

      chkbox_menu_clear_status_operator[i].Font.Name:='Tahoma';
      chkbox_menu_clear_status_operator[i].Font.Size:=12;
      chkbox_menu_clear_status_operator[i].Width:=16;
      chkbox_menu_clear_status_operator[i].Height:=17;
      chkbox_menu_clear_status_operator[i].Parent:=FormMenuAccess.group;

      if list_access[i].menu_clear_status_operator then chkbox_menu_clear_status_operator[i].Checked:=True;

      // оператор без дашборда нет смысла ему права даже включать
      if list_access[i].Role = role_operator_no_dash then begin
        chkbox_menu_clear_status_operator[i].Enabled:=False;
      end;

      // сохраним текущие данные в кзш
      SetFormCache(list_access[i].Role, menu_clear_status_operator, chkbox_menu_clear_status_operator[i]);

    end;

  end;

  isCreateForm:=True;
end;


procedure TFormMenuAccess.Clear;
begin

end;

// создание массива доступов
procedure  TFormMenuAccess.CreateListAccess;
var
 i:Integer;
 role:enumRole;
 count_role:Integer;
begin
  count_role:= Ord(High(enumRole));
  m_count:=count_role;

  SetLength(list_access,count_role);

  for i:=Ord(Low(enumRole)) to Ord(High(enumRole)) do
  begin
    role:=enumRole(i);
    list_access[i-1]:=TUserAccess.Create(role);   // TODO i-1 т.к. по БД id начинается с 1
  end;
end;


procedure  TFormMenuAccess.Show;
begin
  // создадим текущий список доступов
  CreateListAccess;

  // список с данными формы
  if not Assigned(list_form) then list_form:=TFormAccessList.Create;

  // создадим форму
  if not isCreateForm then CreateDataForm;

end;

procedure TFormMenuAccess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UpdateAccess;
end;


procedure TFormMenuAccess.FormCreate(Sender: TObject);
begin
   SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormMenuAccess.FormShow(Sender: TObject);
begin
  Show;
end;

end.
