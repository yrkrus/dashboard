 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///          Класс для описания прав доступа к меню дашборда                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TUserAccessUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.Win.ADODB,
  Data.DB,
  System.Variants,
  GlobalVariablesLinkDLL,
  TCustomTypeUnit;


 // class TUserAccess
  type
    TUserAccess = class
  private
  m_role                                      :enumRole;

  procedure LoadAccess(var p_InRole: enumRole);

  public
   menu_settings_users                        : Boolean;
   menu_settings_serversik                    : Boolean;
   menu_settings_siptrunk                     : Boolean;
   menu_settings_global                       : Boolean;
   menu_active_session                        : Boolean;
   menu_service                               : Boolean;
   menu_missed_calls                          : Boolean;

  constructor Create(InGroupRole:enumRole);      overload;
  property Role:enumRole read m_role;

  end;
 // class TUserAccess END

implementation



// class TUserAccess START
// ===============================================
 constructor TUserAccess.Create(InGroupRole:enumRole);
 begin
   //inherited;
   menu_settings_users                      :=  False;
   menu_settings_serversik                  :=  False;
   menu_settings_siptrunk                   :=  False;
   menu_settings_global                     :=  False;
   menu_active_session                      :=  False;
   menu_service                             :=  False;
   menu_missed_calls                        :=  False;

   m_role                                   :=  InGroupRole;

   LoadAccess(InGroupRole);
 end;


 procedure TUserAccess.LoadAccess(var p_InRole: enumRole);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 //test:string;
begin
//
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
    SQL.Add('select menu_users,menu_serversik, menu_siptrunk,');
    SQL.Add('menu_settings_global, menu_active_session, menu_service,');
    SQL.Add('menu_missed_calls ');
    SQL.Add('from access_panel where role = '+#39+IntToStr(GetRoleID(EnumRoleToString(p_InRole)))+#39);

    Active:=True;

    if StrToInt(VarToStr(Fields[0].Value))=1 then menu_settings_users:=True;
    if StrToInt(VarToStr(Fields[1].Value))=1 then menu_settings_serversik:=True;
    if StrToInt(VarToStr(Fields[2].Value))=1 then menu_settings_siptrunk:=True;
    if StrToInt(VarToStr(Fields[3].Value))=1 then menu_settings_global:=True;
    if StrToInt(VarToStr(Fields[4].Value))=1 then menu_active_session:=True;
    if StrToInt(VarToStr(Fields[5].Value))=1 then menu_service:=True;
    if StrToInt(VarToStr(Fields[6].Value))=1 then menu_missed_calls:=True;

  end;
 finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
 end;
end;


// class TUserAccess END
// ===============================================
end.