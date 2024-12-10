/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� TUser                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TUserUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
     Graphics, System.SyncObjs, IdException, TCustomTypeUnit;



/////////////////////////////////////////////////////////////////////////////////////////
// class TUserAccess
  type
    TUserAccess = class
  public
   menu_settings_users                        : Boolean;
   menu_settings_serversik                    : Boolean;
   menu_settings_siptrunk                     : Boolean;
   menu_settings_global                       : Boolean;
   menu_active_session                        : Boolean;

  constructor Create(InGroupRole:enumRole);      overload;
  private
  procedure LoadAccess(var p_InRole: enumRole);
  end;
 // class TUserAccess END

/////////////////////////////////////////////////////////////////////////////////////////

   // class TUserList
  type
      TUserList = class
      public
      name                                  : string;   // ���
      familiya                              : string;   // �������
      id                                    : Integer;  // id � ��
      group_role                            : enumRole;   //  �����
      login                                 : string;
      re_password                           : Boolean;  // ���������� ������� ������
      acive_session_id                      : Integer;  // id �������� ������
      ip                                    : string;   // ������� ip
      pc                                    : string;   // ��� ��
      user_login_pc                         : string;   // login ����� �� pc

      constructor Create;                     overload;
      end;
 // class TUserList END

/////////////////////////////////////////////////////////////////////////////////////////

   // class TUser
  type
      TUser = class
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

      function GetAccess(Menu:enumAccessList):enumAccessStatus; // ��������� ������ � ��� ����� ��������� ����� ���� ������� �� ������� � ������������



      function GetRole                        :enumRole;
      constructor Create;                     overload;

      private
      Params                                  : TUserList;
      Access                                  : TUserAccess;

      isOperator                              : Boolean;

      function GetRoleIsOperator(InRole:enumRole):Boolean;    // �������� ���� ������������ ��� ������������ ����

      end;
 // class TUser END

/////////////////////////////////////////////////////////////////////////////////////////

implementation

uses
  FunctionUnit, GlobalVariables;

//uses
//  FunctionUnit;

// class TUserAccess START
 constructor TUserAccess.Create(InGroupRole:enumRole);
 begin
   //inherited;
   menu_settings_users                      :=  False;
   menu_settings_serversik                  :=  False;
   menu_settings_siptrunk                   :=  False;
   menu_settings_global                     :=  False;
   menu_active_session                      :=  False;

   LoadAccess(InGroupRole);
 end;


 procedure TUserAccess.LoadAccess(var p_InRole: enumRole);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 test:string;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select menu_users,menu_serversik,menu_siptrunk,');
    SQL.Add('menu_settings_global,menu_active_session ');
    SQL.Add('from access_panel where role = '+#39+IntToStr(GetRoleID(TRoleToStr(p_InRole)))+#39);

    Active:=True;

    if StrToInt(VarToStr(Fields[0].Value))=1 then menu_settings_users:=True;
    if StrToInt(VarToStr(Fields[1].Value))=1 then menu_settings_serversik:=True;
    if StrToInt(VarToStr(Fields[2].Value))=1 then menu_settings_siptrunk:=True;
    if StrToInt(VarToStr(Fields[3].Value))=1 then menu_settings_global:=True;
    if StrToInt(VarToStr(Fields[4].Value))=1 then menu_active_session:=True;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// class TUserAccess END


// class TUserList START
 constructor TUserList.Create;
 begin
   inherited;
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
  if not Assigned(serverConnect) then Exit;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select only_operators from role where id = '+#39+IntToStr(GetRoleID(TRoleToStr(InRole)))+#39);

      Active:=True;

      if VarToStr(Fields[0].Value) = '1' then Result:=True;
    end;
  finally
    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
  end;
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
   if GetRoleIsOperator(InParams.group_role) then Self.isOperator:=True
   else Self.isOperator:=False;
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
   end;
 end;

// class TUser END

end.
