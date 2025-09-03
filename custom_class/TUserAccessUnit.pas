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
   menu_clear_status_operator                 : Boolean;

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
   menu_clear_status_operator               :=  False;

   m_role                                   :=  InGroupRole;

   LoadAccess(InGroupRole);
 end;


 procedure TUserAccess.LoadAccess(var p_InRole: enumRole);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
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

    request:=TStringBuilder.Create;
    with request do begin
      Clear;
      Append('select menu_users,menu_serversik, menu_siptrunk,');
      Append('menu_settings_global, menu_active_session, menu_service,');
      Append('menu_missed_calls, menu_clear_status_operator ');
      Append('from access_panel where role = '+#39+IntToStr(GetRoleID(EnumRoleToString(p_InRole)))+#39);
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;

    if StrToInt(VarToStr(Fields[0].Value))=1 then menu_settings_users:=True;
    if StrToInt(VarToStr(Fields[1].Value))=1 then menu_settings_serversik:=True;
    if StrToInt(VarToStr(Fields[2].Value))=1 then menu_settings_siptrunk:=True;
    if StrToInt(VarToStr(Fields[3].Value))=1 then menu_settings_global:=True;
    if StrToInt(VarToStr(Fields[4].Value))=1 then menu_active_session:=True;
    if StrToInt(VarToStr(Fields[5].Value))=1 then menu_service:=True;
    if StrToInt(VarToStr(Fields[6].Value))=1 then menu_missed_calls:=True;
    if StrToInt(VarToStr(Fields[7].Value))=1 then menu_clear_status_operator:=True;

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