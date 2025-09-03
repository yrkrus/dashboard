/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания TUser                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TUserUnit;

interface

uses  System.Classes,
      Data.Win.ADODB,
      Data.DB,
      System.SysUtils,
      Variants,
      Graphics,
      System.SyncObjs,
      IdException,
      TUserAccessUnit,
      TCustomTypeUnit;



/////////////////////////////////////////////////////////////////////////////////////////

   // class TUserList
  type
      TUserList = class
      public
      name                                  : string;   // имя
      familiya                              : string;   // фамилия
      id                                    : Integer;  // id в БД
      group_role                            : enumRole; //  права
      login                                 : string;
      re_password                           : Boolean;  // необходимо сменить пароль
      acive_session_id                      : Integer;  // id активной сессии
      ip                                    : string;   // текущий ip
      pc                                    : string;   // имя пк
      user_login_pc                         : string;   // login входа на pc


      procedure Clone(_userList:TUserList);

      constructor Create;                     overload;
      end;
 // class TUserList END

/////////////////////////////////////////////////////////////////////////////////////////

   // class TUser
  type
      TUser = class
      private
      Params                                  : TUserList;
      Access                                  : TUserAccess;

      isOperator                              : Boolean;   // пользователь оператор или нет
      isAccessLocalChat                       : Boolean;   // есть ли доступ в локальному чату
      isAccessReports                         : Boolean;   // есть ли доступ к отчетам
      isAccessSMS                             : Boolean;   // есть ли доступ к sms рассылке
      isAccessService                         : Boolean;   // есть ли доступ к услугам


      function GetRoleIsOperator(InRole:enumRole)     :Boolean;   // проверка роль пользователя это операторская роль
      function GetAccessLocalChat(InUserID:integer)   :Boolean;   // проверка есть ли доступ к локальному чату
      function GetAccessReports(InUserID:integer)     :Boolean;   // проверка есть ли доступ к отчетам
      function GetAccessSMS(InUserID:integer)         :Boolean;   // проверка есть ли доступ к SMS рассылке
      function GetAccessService                       :Boolean;   // проверка есть ли доступ к услугам


      public
      procedure UpdateParams(InParams:TUserList);         // обновление параметров пользователя
      function GetID                         :Integer;    // получить текущий id
      function GetName                       :string;     // получить текущий Name
      function GetFamiliya                   :string;     // получить текущий familiya
      function GetIP                         :string;     // получить текущий ip
      function GetUserLoginPC                :string;     // получить текущий user_login_pc
      function GetPC                         :string;     // получить текущий pc
      function GetRePassword                 :Boolean;    // получить текущий re_password
      function GetIsOperator                 :Boolean;    // текущий пользователь в роли оператора?
      function GetIsAccessLocalChat          :Boolean;    // текущий пользователь есть доступ к локальному чату
      function GetIsAccessReports            :Boolean;    // текущий пользователь есть доступ к отчетам
      function GetIsAccessSMS                :Boolean;    // текущий пользователь есть доступ к sms рассылке
      function GetIsAccessService            :Boolean;    // текущий пользователь есть доступ услугам


      function GetAccess(Menu:enumAccessList):enumAccessStatus; // получение данных о том какие параметры могут быть открыты на доступе у пользователя

      function GetUserList:TUserList; // вывод текущих данных о пользователе

      function GetRole                        :enumRole;
      constructor Create;                     overload;



      end;
 // class TUser END

/////////////////////////////////////////////////////////////////////////////////////////

implementation

uses
  FunctionUnit, GlobalVariables, GlobalVariablesLinkDLL;


// class TUserList START
 constructor TUserList.Create;
 begin
   inherited;
 end;


procedure TUserList.Clone(_userList:TUserList);
begin
  if _userList = nil then  Exit;
  Self.name             := _userList.name;
  Self.familiya         := _userList.familiya;
  Self.id               := _userList.id;
  Self.group_role       := _userList.group_role;
  Self.login            := _userList.login;
  Self.re_password      := _userList.re_password;
  Self.acive_session_id := _userList.acive_session_id;
  Self.ip               := _userList.ip;
  Self.pc               := _userList.pc;
  Self.user_login_pc    := _userList.user_login_pc;
end;


// class TUserList END


// class TUser START
 constructor TUser.Create;
 begin
   inherited;
   Params:=TUserList.Create;
 end;



 // проверка роль пользователя это операторская роль
function TUser.GetRoleIsOperator(InRole:enumRole):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

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
      SQL.Add('select only_operators from role where id = '+#39+IntToStr(GetRoleID(EnumRoleToString(InRole)))+#39);

      Active:=True;

      if VarToStr(Fields[0].Value) = '1' then Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


 // проверка есть ли доступ к локальному чату
 function TUser.GetAccessLocalChat(InUserID:integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;

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
      SQL.Add('select chat from users where id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


 // проверка есть ли доступ к отчетам
 function TUser.GetAccessReports(InUserID:integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;

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
      SQL.Add('select reports from users where id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;



// проверка есть ли доступ к SMS рассылке
 function TUser.GetAccessSMS(InUserID:integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;

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
      SQL.Add('select sms from users where id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// проверка есть ли доступ к SMS рассылке
function TUser.GetAccessService:Boolean;
begin
  Result:=Access.menu_service;
end;


 procedure TUser.UpdateParams(InParams:TUserList);
 begin
   with Self.Params do begin
     name               :=InParams.name;
     familiya           :=InParams.familiya;
     id                 :=InParams.id;
     group_role         :=InParams.group_role;
     login              :=InParams.login;
     re_password        :=InParams.re_password;
     acive_session_id   :=InParams.acive_session_id;
     ip                 :=InParams.ip;
     pc                 :=InParams.pc;
     user_login_pc      :=InParams.user_login_pc;
   end;

   Self.Access:=TUserAccess.Create(InParams.group_role);

   // проверка оператор ли залогинелся или нет
   Self.isOperator:=GetRoleIsOperator(InParams.group_role);

   // проверка есть ли досутп к локальному чату
   Self.isAccessLocalChat:=GetAccessLocalChat(InParams.id);

   // проверка есть ли досутп к отчетам
   Self.isAccessReports:=GetAccessReports(InParams.id);

   // проверка есть ли досутп к SMS рассылке
   Self.isAccessSMS:=GetAccessSMS(InParams.id);

      // проверка есть ли досутп к услугам
   Self.isAccessService:=GetAccessService;
 end;

 function TUser.GetID:Integer;
 begin
  Result:=Self.Params.id;
 end;

 function TUser.GetName:string;
 begin
  Result:=Self.Params.name;
 end;

 function TUser.GetFamiliya:string;
 begin
  Result:=Self.Params.familiya;
 end;

 function TUser.GetIP:string;
 begin
  Result:=Self.Params.ip;
 end;

 function TUser.GetUserLoginPC:string;
 begin
  Result:=Self.Params.user_login_pc;
 end;

 function TUser.GetPC:string;
 begin
  Result:=Self.Params.pc;
 end;

 function TUser.GetRole:enumRole;
 begin
  Result:=Self.Params.group_role;
 end;

 function TUser.GetRePassword:Boolean;
 begin
  Result:=Self.Params.re_password;
 end;


 function TUser.GetIsOperator:Boolean;
 begin
  Result:=Self.isOperator;
 end;

 function TUser.GetIsAccessLocalChat:Boolean;
 begin
  Result:=Self.isAccessLocalChat;
 end;

 function TUser.GetIsAccessReports:Boolean;
 begin
  Result:=Self.isAccessReports;
 end;

 function TUser.GetIsAccessSMS:Boolean;
 begin
  Result:=Self.isAccessSMS;
 end;

function TUser.GetIsAccessService:Boolean;
 begin
  Result:=Self.isAccessService;
 end;


 function TUser.GetAccess(Menu:enumAccessList):enumAccessStatus;
 begin
   Result:=access_DISABLED;

   case Menu of
    menu_settings_users:begin
     if Access.menu_settings_users then Result:=access_ENABLED;
    end;
    menu_settings_serversik:begin
     if Access.menu_settings_serversik then Result:=access_ENABLED;
    end;
    menu_settings_siptrunk:begin
     if Access.menu_settings_siptrunk then Result:=access_ENABLED;
    end;
    menu_settings_global:begin
     if Access.menu_settings_global then Result:=access_ENABLED;
    end;
    menu_active_session:begin
      if Access.menu_active_session then Result:=access_ENABLED;
    end;
    menu_service:begin
      if Access.menu_service then Result:=access_ENABLED;
    end;
    menu_missed_calls:begin
      if Access.menu_missed_calls then Result:=access_ENABLED;
    end;
    menu_clear_status_operator:begin
      if Access.menu_clear_status_operator then Result:=access_ENABLED;
    end;
   end;
 end;

 function TUser.GetUserList:TUserList;
 begin
   Result:=Self.Params;
 end;

// class TUser END

end.
