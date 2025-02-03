unit FormAddNewUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB, Data.DB, IdException,
  Vcl.Buttons, TCustomTypeUnit, Vcl.ExtCtrls;

type
  TFormAddNewUsers = class(TForm)
    Label6: TLabel;
    comboxUserGroup: TComboBox;
    Label8: TLabel;
    edtNewFamiliya: TEdit;
    Label1: TLabel;
    edtNewName: TEdit;
    lblPwd_show: TLabel;
    edtPwdNew: TEdit;
    lblInfoNewPwd: TLabel;
    chkboxmyPwd: TCheckBox;
    lblPwd2_show: TLabel;
    edtPwd2New: TEdit;
    lblLogin: TLabel;
    edtNewLogin: TEdit;
    btnAddNewUser: TBitBtn;
    chkboxManualLogin: TCheckBox;
    chkboxAllowLocalChat: TCheckBox;
    PanelOperators: TPanel;
    lblOperatorSetting_SIP_show: TLabel;
    edtOperatorSetting_SIP_show: TEdit;
    lblOperatorSetting_Tel_show: TLabel;
    edtOperatorSetting_Tel_show: TEdit;
    chkboxZoiper: TCheckBox;
    chkboxAllowReports: TCheckBox;
    procedure chkboxmyPwdClick(Sender: TObject);
    procedure comboxUserGroupChange(Sender: TObject);
    procedure btnAddNewUserClick(Sender: TObject);
    procedure chkboxZoiperClick(Sender: TObject);
    procedure edtNewFamiliyaChange(Sender: TObject);
    procedure chkboxManualLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNewLoginChange(Sender: TObject);
    procedure edtOperatorSetting_SIP_showChange(Sender: TObject);
  private
    { Private declarations }
  userEditFields_login:Boolean;       // пользователь отредактировал поле login, надо проверить
  userEditFields_loginDefault:string; // значение которое было изначально в поле логин
  UserEditFileds_sip:Boolean;         // пользователь отредактировал поле sip, надо проверить
  UserEditFields_sipDefault:string;   // значение которое было изначально в поле логин

  function GetCheckEditNewOperator(InUserID:Integer):Boolean;

  public
   currentEditUsers:Boolean;
   currentEditUsersID:UInt32;



    { Public declarations }

  // isUserEdit:Boolean;           // редактируется пользователь true - редактируется
  end;

var
  FormAddNewUsers: TFormAddNewUsers;




const
 cDefaultUserPass:string = '1';

 type                                    // тип запроса
   TAction_User = (user_add,
                   user_update
                    );


implementation

uses
  FunctionUnit, DMUnit, FormSettingsUnit, FormUsersUnit, GlobalVariables;

{$R *.dfm}



// сравнение строк
function IsChangedMoreThan50Percent(const Original, New: string):Boolean;
var
  i, ChangesCount: Integer;
  LengthToCompare: Integer;
begin
  // Определяем длину строки для сравнения
  LengthToCompare := Length(Original);
  if Length(New) > LengthToCompare then LengthToCompare := Length(New);

  ChangesCount := 0;

  // Сравниваем символы строк
  for i := 1 to LengthToCompare do
  begin
    // Если символы различаются, увеличиваем счетчик изменений
    if (i > Length(Original)) or (i > Length(New)) or (Original[i] <> New[i]) then  Inc(ChangesCount);
  end;
  // Проверяем, больше ли изменений 50% от длины самой длинной строки
  Result := ChangesCount > (LengthToCompare div 2);
end;


// проверка текущего оператора решили отредактировать или полностью заменить редактированием
function TFormAddNewUsers.GetCheckEditNewOperator(InUserID:Integer):Boolean;
var
  oldName:string;
  oldFamiliya:string;
begin
  Result:=False;

  oldName:=getUserNameBD(InUserID);
  oldFamiliya:=getUserFamiliya(InUserID);

  if ( IsChangedMoreThan50Percent(oldFamiliya,edtNewFamiliya.Text)) or
     ( IsChangedMoreThan50Percent(oldName,edtNewName.Text)) then Result:=True;
end;


function getResponseBD(InTypeAction:TAction_User; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;

 user_familiya,
 user_name,
 user_login,
 user_pwd,
 user_group,
 user_sip,
 user_sip_phone,
 user_chat,
 user_reports:string;

 u_role:string;

 isNewUserOperator:Boolean;  // добавляется новый оператор
 isNeedResetPwd:Word;        // надо ли сменить свой пароль при входе

 userID:string;

begin
  Result:=False;
  _errorDescription:='';

  Screen.Cursor:=crHourGlass;
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Screen.Cursor:=crDefault;
    _errorDescription:='Не удалось соединиться с сервером';
     Exit;
  end;

  isNewUserOperator:=False;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with FormAddNewUsers do begin
       user_familiya:=edtNewFamiliya.Text;
       if InTypeAction=user_add then user_familiya:=StringReplace(user_familiya,' ','',[rfReplaceAll]);

       user_name:=edtNewName.Text;
       if InTypeAction=user_add then user_name:=StringReplace(user_name,' ','',[rfReplaceAll]);

       // логин с маленькой буквы
       user_login:=edtNewLogin.Text;
       user_login:=AnsiLowerCase(user_login);
       if InTypeAction=user_add then user_login:=StringReplace(user_login,' ','',[rfReplaceAll]);

       // пароль
       if chkboxmyPwd.Checked then begin
        user_pwd:=IntToStr(getHashPwd(edtPwdNew.Text));
        isNeedResetPwd:=0; // запрос на смену пароля при входе
       end
       else begin
         // запрос на смену пароля нужно только для новых сотрудников
         if InTypeAction=user_add then begin
           isNeedResetPwd:=1;  // запрос на смену пароля при входе
           user_pwd:=IntToStr(getHashPwd(cDefaultUserPass));
         end;
       end;

       // оператор\старший оператор
       user_group:=comboxUserGroup.Items[comboxUserGroup.ItemIndex];
       u_role:= IntToStr(getUserGroupID(user_group));

       if (AnsiPos('Оператор',user_group) <> 0) or
          (AnsiPos('оператор',user_group)<> 0) then begin

         user_sip:=edtOperatorSetting_SIP_show.Text;
         user_sip_phone:=edtOperatorSetting_Tel_show.Text;

         // проверяем используется sip телефон или zoiper
         if user_sip_phone='' then begin
          // проверяем вдруг zoiper указан
          if chkboxZoiper.Checked then user_sip_phone:='zoiper'
          else user_sip_phone:='null';
         end;

         // если не редактируеся сейчас, то это не новый оператор
         if not currentEditUsers then isNewUserOperator:=True;
       end;

        // доступ к чату
        if chkboxAllowLocalChat.Checked then user_chat:='1'
        else user_chat:='0';

        // доступ к отчетам
        if chkboxAllowReports.Checked then user_reports:='1'
        else user_reports:='0';

      end;


      case InTypeAction of
        user_add:begin
          SQL.Add('insert into users (name,familiya,role,login,pass,is_need_reset_pwd,chat,reports) values ('+#39+user_name+#39+','
                                                                                                             +#39+user_familiya+#39+','
                                                                                                             +#39+u_role+#39+','
                                                                                                             +#39+user_login+#39+','
                                                                                                             +#39+user_pwd+#39+','
                                                                                                             +#39+IntToStr(isNeedResetPwd)+#39+','
                                                                                                             +#39+user_chat+#39+','
                                                                                                             +#39+user_reports+#39+')');
        end;
        user_update:begin

          if FormAddNewUsers.chkboxmyPwd.Checked then begin // надо поменять пароль

            SQL.Add('update users set name = '+#39+user_name+#39
                                              +', familiya = '+#39+user_familiya+#39
                                              +', role = '    +#39+u_role+#39
                                              +', login = '   +#39+user_login+#39
                                              +', pass = '    +#39+user_pwd+#39
                                              +', chat = '    +#39+user_chat+#39
                                              +', reports = ' +#39+user_reports+#39
                                              +' where id = ' +#39+IntToStr(FormAddNewUsers.currentEditUsersID)+#39);
             //,,,login,pass,
          end
          else begin                                        // пароль не надо менять
           SQL.Add('update users set name = '+#39+user_name+#39
                                              +', familiya = '+#39+user_familiya+#39
                                              +', role = '    +#39+u_role+#39
                                              +', login = '   +#39+user_login+#39
                                              +', chat = '    +#39+user_chat+#39
                                              +', reports = ' +#39+user_reports+#39
                                              +' where id = ' +#39+IntToStr(FormAddNewUsers.currentEditUsersID)+#39);
          end;
        end;
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             CodOshibki:=e.Message;
             _errorDescription:=CodOshibki;

            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;

             Exit;
          end;
      end;

      // id пользователя
      userID:=IntToStr(getUserID(user_login));


      // таблица операторы
      if isNewUserOperator then begin
         SQL.Clear;
         SQL.Add('insert into operators (sip,user_id,sip_phone) values ('+#39+user_sip+#39+','
                                                                         +#39+userID+#39+','
                                                                         +#39+user_sip_phone+#39+')');
        try
            ExecSQL;
        except
            on E:EIdException do begin
               Screen.Cursor:=crDefault;
               CodOshibki:=e.Message;
               _errorDescription:=CodOshibki;
                FreeAndNil(ado);
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                end;

               Exit;
            end;
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


// отображение sip+телефон оператора + локальный чат
procedure showSettingOperatorSIP(IsVisible:Boolean);
const
 //cLeft:Word                 = 286;
 cTopPanelOperators:Word    = 54;
 cTopChatReportsDefault:Word       = 191;
begin
  with FormAddNewUsers do begin
     if IsVisible then begin  // для операторских групп

       // панель оператора
       PanelOperators.Visible:=True;
       PanelOperators.Top:=cTopPanelOperators;

       chkboxZoiper.Checked:=False;

        // локальный чат
        chkboxAllowLocalChat.Top:=cTopChatReportsDefault;

        // отчеты
        chkboxAllowReports.Top:=cTopChatReportsDefault;

        if comboxUserGroup.Text='Оператор (без дашборда)' then begin
          lblOperatorSetting_Tel_show.Enabled:=False;

          edtOperatorSetting_Tel_show.Enabled:=False;
          edtOperatorSetting_Tel_show.Color:=cl3DLight;

          chkboxZoiper.Enabled:=False;

          chkboxAllowLocalChat.Enabled:=False;
          chkboxAllowReports.Enabled:=False;
        end
        else begin
          lblOperatorSetting_Tel_show.Enabled:=True;

          edtOperatorSetting_Tel_show.Enabled:=True;
          edtOperatorSetting_Tel_show.Color:=clWindow;

          chkboxZoiper.Enabled:=True;

          chkboxAllowLocalChat.Enabled:=True;
          chkboxAllowReports.Enabled:=True;
        end;

        if not currentEditUsers then edtOperatorSetting_SIP_show.Text:='';

     end
     else begin  // для всех остальных групп, кроме операторских
      PanelOperators.Visible:=False;

      chkboxAllowLocalChat.Top:=cTopPanelOperators;
      chkboxAllowReports.Top:=cTopPanelOperators;

      edtOperatorSetting_SIP_show.Text:='';
      edtOperatorSetting_Tel_show.Text:='';

      chkboxZoiper.Checked:=False;
     end;

  end;
end;

// отображение групп доступа
procedure showGroup(InUserRole:enumRole; allUsers:Boolean = True);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countGroup,i:Integer;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      if InUserRole = role_administrator then begin
        if allUsers then SQL.Add('select count(id) from role where id <> ''-1'' ')
        else SQL.Add('select count(id) from role where id <> ''-1'' and only_operators= ''1'' ');
      end
      else   SQL.Add('select count(id) from role where id <> ''-1'' and only_operators= ''1'' ');

      Active:=True;
      countGroup:=Fields[0].Value;
    end;

    with FormAddNewUsers.comboxUserGroup do begin
      Clear;

      with ado do begin
        SQL.Clear;

        if InUserRole = role_administrator then begin
         if allUsers then SQL.Add('select id from role where id <> ''-1''')
         else SQL.Add('select id from role where id <> ''-1'' and only_operators= ''1'' ');
        end
        else  SQL.Add('select id from role where id <> ''-1'' and only_operators= ''1'' ');

        Active:=True;

         for i:=0 to countGroup-1 do begin
           Items.Add(getUserGroupSTR(Fields[0].Value));
           ado.Next;
         end;
      end;

      ItemIndex:= -1;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

 procedure showPwdEdit;
 const
  cLeft:Word  = 15;
  cTop:Word   = 125;
 begin
   with FormAddNewUsers do begin
     if chkboxmyPwd.Checked then begin
       lblInfoNewPwd.Visible:=False;
       chkboxmyPwd.Visible:=False;

       lblPwd_show.Visible:=True;
       lblPwd_show.Left:=cLeft;
       lblPwd_show.Top:=cTop;

       edtPwdNew.Visible:=True;
       edtPwdNew.Left:=cLeft;
       edtPwdNew.Top:=cTop+18;

       lblPwd2_show.Visible:=True;
       lblPwd2_show.Left:=cLeft;
       lblPwd2_show.Top:=cTop+40;

       edtPwd2New.Visible:=True;
       edtPwd2New.Left:=cLeft;
       edtPwd2New.Top:=cTop+58;
     end
     else begin
       lblInfoNewPwd.Visible:=True;
       chkboxmyPwd.Visible:=True;


      lblPwd_show.Visible:=False;
      edtPwdNew.Visible:=False;
      edtPwdNew.Text:='';

      lblPwd2_show.Visible:=False;
      edtPwd2New.Visible:=False;
      edtPwdNew.Text:='';
     end;

   end;
 end;


 // проверка корреткрности заполнения полей
 function getCheckFields(var _errorDescription:string):Boolean;
 const
  cMAX_COUNT_FIO_LENGHT:Word = 35;
 var
 currentGroup:string;
 begin
   Result:=False;
   _errorDescription:='';

   with FormAddNewUsers do begin
      if edtNewFamiliya.Text='' then begin
       _errorDescription:='Не заполнено поле "Фамилия"';
        Exit;
      end;

      if edtNewName.Text='' then begin
       _errorDescription:='Не заполнено поле "Имя"';
        Exit;
      end;

      // длина Имя+Фамилия
      if Length(edtNewFamiliya.Text)+Length(edtNewName.Text)+1>cMAX_COUNT_FIO_LENGHT then begin
       _errorDescription:='Общее максимальное кол-во символов в полях Фамилия+Имя не может быть больше '+ IntToStr(cMAX_COUNT_FIO_LENGHT)+' символов' +#13+#13
                          +'Сейчас:'+#13+'Фамилия - '+IntToStr(Length(edtNewFamiliya.Text))+' символов'+#13
                          +'Имя - '+IntToStr(Length(edtNewName.Text))+' символов';
       Exit;
      end;


      if edtNewLogin.Text='' then begin
       _errorDescription:='Не заполнено поле "Логин"';
       Exit;
      end;

      // проверка логина
      if currentEditUsers then begin // редактируется пользователь
        if userEditFields_login then begin
          if userEditFields_loginDefault<>edtNewLogin.Text then begin
            if getCheckLogin(edtNewLogin.Text) then begin
             _errorDescription:='Логин '+edtNewLogin.Text+' уже существует';
             Exit;
            end;
          end;
        end;
      end
      else begin
        if getCheckLogin(edtNewLogin.Text) then begin
         _errorDescription:='Логин '+edtNewLogin.Text+' уже существует';
         Exit;
        end;

      end;


      // пароль
      if chkboxmyPwd.Checked then begin
        if edtPwdNew.Text='' then begin
         _errorDescription:='Не заполнено поле "Пароль"';
         Exit;
        end;

        if edtPwd2New.Text='' then begin
         _errorDescription:='Не заполнено поле "Подтверждение"';
         Exit;
        end;

        if edtPwdNew.Text <> edtPwd2New.Text then begin
         _errorDescription:='Пароли не совпадают';
         Exit;
        end;
      end;


      // группы доступа
      begin
        if comboxUserGroup.ItemIndex= -1 then begin
           _errorDescription:='Не выбрана "Группа доступа"';
           Exit;
        end;

        currentGroup:=comboxUserGroup.Items[comboxUserGroup.ItemIndex];

        // отоюражение нужных полей в зависимости от прав доступа
        if (AnsiPos('Оператор',currentGroup) <> 0) or
           (AnsiPos('оператор',currentGroup)<> 0) then begin

          // проверяем вдруг решили нового оператора просто отредактировать и старого не отключить
          if currentEditUsers then begin
            if GetCheckEditNewOperator(currentEditUsersID) then begin
             _errorDescription:='Текущего пользователя нельзя заменить новым'+#13#13+
                                'Для заведения нового пользователя, текущего необходимо отключить';
             Exit;
            end;
          end;


          if edtOperatorSetting_SIP_show.Text='' then begin
            _errorDescription:='Не заполнено поле "SIP номер"';
            Exit;
          end;

          // проверка есть ли такой уже номер на активном операторе
          if currentEditUsers then begin
            if UserEditFileds_sip then begin
              if UserEditFields_sipDefault <> edtOperatorSetting_SIP_show.Text then begin
                if isExistSipActiveOperator(edtOperatorSetting_SIP_show.Text) then begin
                  _errorDescription:='SIP номер '+edtOperatorSetting_SIP_show.Text+' уже существует'+#13#13+
                                     'для добавления такого SIP необходимо сначало отключить пользователя '+GetUserNameOperators(edtOperatorSetting_SIP_show.Text);
                  Exit;
                end;
              end;
            end;
          end
          else begin

            if isExistSipActiveOperator(edtOperatorSetting_SIP_show.Text) then begin
              _errorDescription:='SIP номер '+edtOperatorSetting_SIP_show.Text+' уже существует'+#13#13+
                                 'для добавления такого SIP необходимо сначало отключить пользователя '+GetUserNameOperators(edtOperatorSetting_SIP_show.Text);
              Exit;
            end;
          end;

          if edtOperatorSetting_Tel_show.Text<>'' then begin
             // проверка на корректность ip телефонии
            if AnsiPos('10.34.200.',edtOperatorSetting_Tel_show.Text)=0 then begin
              _errorDescription:='Некорректный формат "IP телефона"'+#13#13+'Телефон должен иметь формать "10.34.200.XXX"';
              Exit;
            end;
          end;

        end;
      end;
       Result:=True;
   end;
 end;



procedure show_form(InUserRole:enumRole; isEditUser:Boolean = False);
var
 id_role:Integer;
 role:string;
 i:Integer;
begin
  FormAddNewUsers.chkboxmyPwd.Checked:=False;
  showPwdEdit;

  // отображаем группы доступа (в зависимости от того какая панель сейчас выбрана)
  if FormUsers.PageControl.ActivePage.Caption = 'Все пользователи' then showGroup(InUserRole)
  else showGroup(InUserRole,False);


  with FormAddNewUsers do begin

    if not currentEditUsers then begin
      Caption:='Добавление нового пользователя';

      edtNewFamiliya.Text:='';
      edtNewName.Text:='';
      edtNewLogin.Text:='';

      chkboxManualLogin.Checked:=False;

      edtOperatorSetting_SIP_show.Text:='';
      edtOperatorSetting_Tel_show.Text:='';
      edtPwdNew.Text:='';
      edtPwd2New.Text:='';

      showSettingOperatorSIP(False);

      chkboxZoiper.Checked:=False;

      btnAddNewUser.Caption:='   Добавить';
    end
    else begin
      Caption:='Редактирование: '+getUserNameFIO(currentEditUsersID);

      edtNewFamiliya.Text:=getUserFamiliya(currentEditUsersID);
      edtNewName.Text:=getUserNameBD(currentEditUsersID);
      edtNewLogin.Text:=getUserLogin(currentEditUsersID);

      // группа доступа
       role:=getUserRoleSTR(currentEditUsersID);
      for i:=0 to comboxUserGroup.Items.Count-1 do begin
        if comboxUserGroup.Items[i] = role  then begin
           comboxUserGroup.ItemIndex:=i;
           Break;
        end;
      end;

      // локальный чат
      chkboxAllowLocalChat.Checked:=GetUserAccessLocalChat(currentEditUsersID);

     // отчеты
      chkboxAllowReports.Checked:=GetUserAccessReports(currentEditUsersID);

       // отобразим скрвтые поля
       comboxUserGroup.OnChange(comboxUserGroup);

       if (AnsiPos('Оператор',role)<>0) or
          (AnsiPos('оператор',role)<>0) then begin
          // sip номер
          edtOperatorSetting_SIP_show.Text:=getUserSIP(currentEditUsersID);
       end;

       // сброс параметров которые буду проверяться
       userEditFields_login:=False;
       userEditFields_loginDefault:=edtNewLogin.Text;

       UserEditFileds_sip:=False;
       UserEditFields_sipDefault:=edtOperatorSetting_SIP_show.Text;

       btnAddNewUser.Caption:='   Сохранить';
    end;
  end;

end;


procedure TFormAddNewUsers.btnAddNewUserClick(Sender: TObject);
var
 error:string;
 ado:TADOQuery;
begin

  if not getCheckFields(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  // добавляем нового пользака
  if not currentEditUsers then begin

    if not getResponseBD(user_add, error) then begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end;

  end
  else begin

    if not getResponseBD(user_update,error) then begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end;

  end;


  // обновление данных
   show_form(SharedCurrentUserLogon.GetRole);

   // прогрузка списка пользователей (False - не показывать отключенных пользователей)
   loadPanel_Users(SharedCurrentUserLogon.GetRole);

   // прогрузка списка пользователей (операторы) (False - не показывать отключенных пользователей)
   loadPanel_Operators;

  if not currentEditUsers then MessageBox(Handle,PChar('Новый пользователь добавлен'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION)
  else MessageBox(Handle,PChar('Пользователь отредактирован'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION)

end;

procedure TFormAddNewUsers.chkboxManualLoginClick(Sender: TObject);
begin
   if chkboxManualLogin.Checked then begin
    lblLogin.Enabled:=True;
    edtNewLogin.Enabled:=True;
    edtNewLogin.Color:=clWindow;

    if edtNewLogin.Text<>'' then begin
      if not currentEditUsers then edtNewLogin.Text:='';
    end;

   end
   else begin
    lblLogin.Enabled:=False;
    edtNewLogin.Enabled:=False;
    edtNewLogin.Color:=cl3DLight;
   end;

end;

procedure TFormAddNewUsers.chkboxmyPwdClick(Sender: TObject);
begin
  showPwdEdit;
end;

procedure TFormAddNewUsers.chkboxZoiperClick(Sender: TObject);
begin
  if chkboxZoiper.Checked then begin
    lblOperatorSetting_Tel_show.Enabled:=False;
    edtOperatorSetting_Tel_show.Enabled:=False;
    edtOperatorSetting_Tel_show.Text:='';
    edtOperatorSetting_Tel_show.Color:=cl3DLight;

  end
  else begin
   lblOperatorSetting_Tel_show.Enabled:=True;
   edtOperatorSetting_Tel_show.Enabled:=True;
   edtOperatorSetting_Tel_show.Text:='';
   edtOperatorSetting_Tel_show.Color:=clWindow;
  end;
end;

procedure TFormAddNewUsers.comboxUserGroupChange(Sender: TObject);
var
 currentGroup:string;
begin
  currentGroup:=comboxUserGroup.Items[comboxUserGroup.ItemIndex];

  // отоюражение нужных полей в зависимости от прав доступа
  if  (AnsiPos('Оператор',currentGroup)<>0) or
      (AnsiPos('оператор',currentGroup)<>0)  then showSettingOperatorSIP(True)
  else showSettingOperatorSIP(False);

end;


procedure TFormAddNewUsers.edtNewFamiliyaChange(Sender: TObject);
begin
  if not currentEditUsers then begin
    if edtNewFamiliya.Text<>'' then begin
      edtNewLogin.Text:=getTranslate(edtNewFamiliya.Text);
    end
    else edtNewLogin.Text:='';
  end;
end;


procedure TFormAddNewUsers.edtNewLoginChange(Sender: TObject);
begin
  // чтобы потом проверить измелись ли данные по логину
  if currentEditUsers then userEditFields_login:=True;
end;

procedure TFormAddNewUsers.edtOperatorSetting_SIP_showChange(Sender: TObject);
begin
  // чтобы потом проверить измелись ли данные по sip
  if currentEditUsers then UserEditFileds_sip:=True;
end;

procedure TFormAddNewUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // обновляем окно с группами
  showSettingOperatorSIP(False);

  chkboxAllowLocalChat.Checked:=False;
  chkboxAllowReports.Checked:=False;

  // на всякий случай что уже не редактируется ничего
  currentEditUsers:=False;
  currentEditUsersID:=0;

end;

procedure TFormAddNewUsers.FormShow(Sender: TObject);
begin

  if not currentEditUsers then show_form(SharedCurrentUserLogon.GetRole)   // не редактируется
  else show_form(SharedCurrentUserLogon.GetRole,True);                    // редактируется

end;

end.


