/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� TUser                          ///
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
      name                                  : string;   // ���
      familiya                              : string;   // �������
      id                                    : Integer;  // id � ��
      group_role                            : enumRole; //  �����
      login                                 : string;
      re_password                           : Boolean;  // ���������� ������� ������
      acive_session_id                      : Integer;  // id �������� ������
      ip                                    : string;   // ������� ip
      pc                                    : string;   // ��� ��
      user_login_pc                         : string;   // login ����� �� pc


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

      isOperator                              : Boolean;   // ������������ �������� ��� ���
      isAccessLocalChat                       : Boolean;   // ���� �� ������ � ���������� ����
      isAccessReports                         : Boolean;   // ���� �� ������ � �������
      isAccessSMS                             : Boolean;   // ���� �� ������ � sms ��������
      isAccessService                         : Boolean;   // ���� �� ������ � �������


      function GetRoleIsOperator(InRole:enumRole)     :Boolean;   // �������� ���� ������������ ��� ������������ ����
      function GetAccessLocalChat(InUserID:integer)   :Boolean;   // �������� ���� �� ������ � ���������� ����
      function GetAccessReports(InUserID:integer)     :Boolean;   // �������� ���� �� ������ � �������
      function GetAccessSMS(InUserID:integer)         :Boolean;   // �������� ���� �� ������ � SMS ��������
      function GetAccessService                       :Boolean;   // �������� ���� �� ������ � �������


      public
      procedure UpdateParams(InParams:TUserList);         // ���������� ���������� ������������
      function GetID                         :Integer;    // �������� ������� id
      function GetName                       :string;     // �������� ������� Name
      function GetFamiliya                   :string;     // �������� ������� familiya
      function GetIP                         :string;     // �������� ������� ip
      function GetUserLoginPC                :string;     // �������� ������� user_login_pc
      function GetPC                         :string;     // �������� ������� pc
      function GetRePassword                 :Boolean;    // �������� ������� re_password
      function GetIsOperator                 :Boolean;    // ������� ������������ � ���� ���������?
      function GetIsAccessLocalChat          :Boolean;    // ������� ������������ ���� ������ � ���������� ����
      function GetIsAccessReports            :Boolean;    // ������� ������������ ���� ������ � �������
      function GetIsAccessSMS                :Boolean;    // ������� ������������ ���� ������ � sms ��������
      function GetIsAccessService            :Boolean;    // ������� ������������ ���� ������ �������


      function GetAccess(Menu:enumAccessList):enumAccessStatus; // ��������� ������ � ��� ����� ��������� ����� ���� ������� �� ������� � ������������

      function GetUserList:TUserList; // ����� ������� ������ � ������������

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



 // �������� ���� ������������ ��� ������������ ����
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


 // �������� ���� �� ������ � ���������� ����
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


 // �������� ���� �� ������ � �������
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



// �������� ���� �� ������ � SMS ��������
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


// �������� ���� �� ������ � SMS ��������
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

   // �������� �������� �� ����������� ��� ���
   Self.isOperator:=GetRoleIsOperator(InParams.group_role);

   // �������� ���� �� ������ � ���������� ����
   Self.isAccessLocalChat:=GetAccessLocalChat(InParams.id);

   // �������� ���� �� ������ � �������
   Self.isAccessReports:=GetAccessReports(InParams.id);

   // �������� ���� �� ������ � SMS ��������
   Self.isAccessSMS:=GetAccessSMS(InParams.id);

      // �������� ���� �� ������ � �������
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
