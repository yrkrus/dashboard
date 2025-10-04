/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания TUser                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TUserUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB,System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException,
      TUserAccessUnit, TCustomTypeUnit,  System.Generics.Collections;


/////////////////////////////////////////////////////////////////////////////////////////

   // class TUserList
  type
      TUserList = class
      public
      name                                  : string;   // имя
      familiya                              : string;   // фамилия
      id                                    : Integer;  // id в БД
      group_role                            : enumRole; // права
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
      m_params                                  : TUserList;
      m_access                                  : TUserAccess;
      isUserOperator                          : Boolean;   // пользователь оператор или нет
      m_externalAccessEXE                     : TDictionary<enumExternalAccessEXE, Boolean>;  // подобие std::map c++

      function GetID                          :Integer;    // получить текущий id
      function GetName                        :string;     // получить текущий Name
      function GetFamiliya                    :string;     // получить текущий familiya
      function GetIP                          :string;     // получить текущий ip
      function GetUserLoginPC                 :string;     // получить текущий user_login_pc
      function GetPC                          :string;     // получить текущий pc
      function GetRePassword                  :Boolean;    // получить текущий re_password
      function GetIsOperator                  :Boolean;    // текущий пользователь в роли оператора?
      function GetIsAccessLocalChat           :Boolean;    // текущий пользователь есть доступ к локальному чату
      function GetIsAccessReports             :Boolean;    // текущий пользователь есть доступ к отчетам
      function GetIsAccessSMS                 :Boolean;    // текущий пользователь есть доступ к sms рассылке
      function GetIsAccessService             :Boolean;    // текущий пользователь есть доступ услугам
      function GetAccess(Menu:enumAccessList):enumAccessStatus; // получение данных о том какие параметры могут быть открыты на доступе у пользователя



      function GetRoleIsOperator(InRole:enumRole)     :Boolean;   // проверка роль пользователя это операторская роль
      function GetAccessLocalChat(InUserID:integer)   :Boolean;   // проверка есть ли доступ к локальному чату
      function GetAccessReports(InUserID:integer)     :Boolean;   // проверка есть ли доступ к отчетам
      function GetAccessSMS(InUserID:integer)         :Boolean;   // проверка есть ли доступ к SMS рассылке
      function GetAccessService                       :Boolean;   // проверка есть ли доступ к услугам


      public
      procedure UpdateParams(InParams:TUserList);         // обновление параметров пользователя


      function GetUserList:TUserList; // вывод текущих данных о пользователе

      function GetRole                        :enumRole;
      constructor Create;                     overload;

      // === property ===
      property ID:Integer read GetID;
      property Name:string read GetName;
      property Familiya:string read GetFamiliya;
      property IP:string read GetIP;
      property UserLoginPC:string read GetUserLoginPC;
      property PC:string read GetPC;
      property RePassword:Boolean read GetRePassword;
      property IsOperator:Boolean read GetIsOperator;
      property IsAccessLocalChat:Boolean read GetIsAccessLocalChat;
      property IsAccessReports:Boolean read GetIsAccessReports;
      property IsAccessSMS:Boolean read GetIsAccessSMS;
      property IsAccessService:Boolean read GetIsAccessService;

      property Access[_menu:enumAccessList]:enumAccessStatus read GetAccess; default;

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
 var
  capacity:Integer;
  i:Integer;
 begin
   inherited;

   capacity:=Ord(High(enumExternalAccessEXE));
   m_externalAccessEXE:=TDictionary<enumExternalAccessEXE, Boolean>.Create(capacity);
   for i:=0 to capacity do begin
    m_externalAccessEXE.Add(enumExternalAccessEXE(i),False);
   end;



   m_params:=TUserList.Create;
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
  Result:=m_access.menu_service;
end;


 procedure TUser.UpdateParams(InParams:TUserList);
 begin
   with Self.m_params do begin
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

   Self.m_access:=TUserAccess.Create(InParams.group_role);

   // проверка оператор ли залогинелся или нет
   Self.isUserOperator:=GetRoleIsOperator(InParams.group_role);

   // проверка есть ли досутп к локальному чату
   Self.m_externalAccessEXE[eExternalAccessLocalChat]:=GetAccessLocalChat(InParams.id);

   // проверка есть ли досутп к отчетам
   Self.m_externalAccessEXE[eExternalAccessReports]:=GetAccessReports(InParams.id);

   // проверка есть ли досутп к SMS рассылке
   Self.m_externalAccessEXE[eExternalAccessSMS]:=GetAccessSMS(InParams.id);

      // проверка есть ли досутп к услугам
   Self.m_externalAccessEXE[eExternalAccessService]:=GetAccessService;
 end;

 function TUser.GetID:Integer;
 begin
  Result:=Self.m_params.id;
 end;

 function TUser.GetName:string;
 begin
  Result:=Self.m_params.name;
 end;

 function TUser.GetFamiliya:string;
 begin
  Result:=Self.m_params.familiya;
 end;

 function TUser.GetIP:string;
 begin
  Result:=Self.m_params.ip;
 end;

 function TUser.GetUserLoginPC:string;
 begin
  Result:=Self.m_params.user_login_pc;
 end;

 function TUser.GetPC:string;
 begin
  Result:=Self.m_params.pc;
 end;

 function TUser.GetRole:enumRole;
 begin
  Result:=Self.m_params.group_role;
 end;

 function TUser.GetRePassword:Boolean;
 begin
  Result:=Self.m_params.re_password;
 end;

 function TUser.GetIsOperator:Boolean;
 begin
  Result:=Self.isUserOperator;
 end;

 function TUser.GetIsAccessLocalChat:Boolean;
 begin
  Result:=Self.m_externalAccessEXE[eExternalAccessLocalChat];
 end;

 function TUser.GetIsAccessReports:Boolean;
 begin
  Result:=Self.m_externalAccessEXE[eExternalAccessReports];
 end;

 function TUser.GetIsAccessSMS:Boolean;
 begin
  Result:=Self.m_externalAccessEXE[eExternalAccessSMS];
 end;

function TUser.GetIsAccessService:Boolean;
 begin
  Result:=Self.m_externalAccessEXE[eExternalAccessService];;
 end;


 function TUser.GetAccess(Menu:enumAccessList):enumAccessStatus;
 begin
   Result:=access_DISABLED;

   case Menu of
    menu_settings_users:begin
     if m_access.menu_settings_users then Result:=access_ENABLED;
    end;
    menu_settings_serversik:begin
     if m_access.menu_settings_serversik then Result:=access_ENABLED;
    end;
    menu_settings_siptrunk:begin
     if m_access.menu_settings_siptrunk then Result:=access_ENABLED;
    end;
    menu_settings_global:begin
     if m_access.menu_settings_global then Result:=access_ENABLED;
    end;
    menu_active_session:begin
      if m_access.menu_active_session then Result:=access_ENABLED;
    end;
    menu_service:begin
      if m_access.menu_service then Result:=access_ENABLED;
    end;
    menu_missed_calls:begin
      if m_access.menu_missed_calls then Result:=access_ENABLED;
    end;
    menu_clear_status_operator:begin
      if m_access.menu_clear_status_operator then Result:=access_ENABLED;
    end;
   end;
 end;

 function TUser.GetUserList:TUserList;
 begin
   Result:=Self.m_params;
 end;

// class TUser END

end.
