/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� TUser                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TUserUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB,System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException,
      TUserAccessUnit, TCustomTypeUnit,  System.Generics.Collections;


/////////////////////////////////////////////////////////////////////////////////////////

  // class TUserCommonQueue
  type
    TUserCommonQueue = class // ����� ������� ����� ������ ������������
    private
    m_userID  :Integer;
    m_count   :Integer;
    m_list    :TList<enumQueue>;

    function GetQueue:string;
    function IsExist(_queue:enumQueue):Boolean;

    procedure LoadData;

    public
    constructor Create(_userID:Integer);                     overload;

    property Count:Integer read m_count;
    property ActiveQueueSTR:string read GetQueue;
    property IsExistQueue[_queue:enumQueue]:Boolean read IsExist; default;

    end;
   // class TUserCommonQueue END



   // class TUserData
  type
      TUserData = class
      private
      procedure _Init;
      procedure LoadData(_userId:Integer);   // ��������� ������ �� ������������


      public
      m_name                                  : string;   // ���
      m_familiya                              : string;   // �������
      m_id                                    : Integer;  // id � ��
      m_group_role                            : enumRole; // �����
      m_login                                 : string;
      m_re_password                           : enumStatus;  // ���������� ������� ������
      m_acive_session_id                      : Integer;  // id �������� ������
      m_ip                                    : string;   // ������� ip
      m_pc                                    : string;   // ��� ��
      m_user_login_pc                         : string;   // login ����� �� pc
      m_auth                                  : enumAuth; // ��� �����������

      procedure Clone(_userData:TUserData);

      constructor Create;                     overload;
      constructor Create(_userId:Integer);    overload;
      end;
 // class TUserData END

/////////////////////////////////////////////////////////////////////////////////////////

   // class TUser
  type
      TUser = class
      private
      m_params                                : TUserData;
      m_access                                : TUserAccess;
      m_userIsOperator                        : Boolean;   // ������������ �������� ��� ���
      m_externalAccessEXE                     : TDictionary<enumExternalAccessEXE, Boolean>;  // ������� std::map c++
      m_disabled                              : Boolean;   // ������ (����������� ��� ���)
      m_lastActive                            : TDateTime;  // ����� ����� ��� ������� ��������� ���
      m_commonQueue                           : TUserCommonQueue;  // ����� ������� ������������ ����� ������\������������

      procedure _Init;                                     // �������������

      function GetID                          :Integer;    // �������� ������� id
      function GetName                        :string;     // �������� ������� Name
      function GetFamiliya                    :string;     // �������� ������� familiya
      function GetLogin                       :string;     // �������� ������� m_login
      function GetIP                          :string;     // �������� ������� ip
      function GetUserLoginPC                 :string;     // �������� ������� user_login_pc
      function GetPC                          :string;     // �������� ������� pc
      function GetRePassword                  :enumStatus;    // �������� ������� re_password
      function GetAuth                        :enumAuth;    // �������� ������� m_auth
      function GetIsOperator                  :Boolean;    // ������� ������������ � ���� ���������?
      function GetIsAccessLocalChat           :Boolean;    // ������� ������������ ���� ������ � ���������� ����
      function GetIsAccessReports             :Boolean;    // ������� ������������ ���� ������ � �������
      function GetIsAccessSMS                 :Boolean;    // ������� ������������ ���� ������ � sms ��������
      function GetIsAccessService             :Boolean;    // ������� ������������ ���� ������ �������
      function GetIsAccessCalls               :Boolean;    // ������� ������������ ���� ������ �������
      function GetAccess(Menu:enumAccessList):enumAccessStatus; // ��������� ������ � ��� ����� ��������� ����� ���� ������� �� ������� � ������������
      function GetRoleIsOperator(InRole:enumRole)     :Boolean;   // �������� ���� ������������ ��� ������������ ����
      function GetAccessLocalChat(InUserID:integer)   :Boolean;   // �������� ���� �� ������ � ���������� ����
      function GetAccessReports(InUserID:integer)     :Boolean;   // �������� ���� �� ������ � �������
      function GetAccessSMS(InUserID:integer)         :Boolean;   // �������� ���� �� ������ � SMS ��������
      function GetAccessService                       :Boolean;   // �������� ���� �� ������ � �������
      function GetAccessCalls(InUserID:integer)       :Boolean;   // �������� ���� �� ������ � �������
      function GetRole                        :enumRole;
      function AccountStatus(_userId:Integer):Boolean;   // ������ �������� (����������� ��� ���)
      function LastActiveAccount(_userId:Integer):TDateTime; // ����� ����� ��������� ��� ������� � ���������
      function GetCommonQueue:string;                           //����� ������� �������� ��� ���������\��������������
      function GetExistQueue(_queue:enumQueue):Boolean;   // ������ �� ������� � �������
      function GetExternalAccess(_access:enumExternalAccessEXE):Boolean;   // ����� ������� ���� � ������� ����������

      public

      constructor Create;                     overload;
      constructor Create(_userId:Integer);    overload;
      destructor Destroy; override;

      procedure UpdateParams(InParams:TUserData);         // ���������� ���������� ������������
      function GetUserData:TUserData; // ����� ������� ������ � ������������


      // === property ===
      property ID:Integer read GetID;
      property Name:string read GetName;
      property Familiya:string read GetFamiliya;
      property Login:string read GetLogin;
      property IP:string read GetIP;
      property UserLoginPC:string read GetUserLoginPC;
      property PC:string read GetPC;
      property RePassword:enumStatus read GetRePassword;
      property Auth:enumAuth read GetAuth;
      property IsOperator:Boolean read GetIsOperator;
      property IsAccessLocalChat:Boolean read GetIsAccessLocalChat;
      property IsAccessReports:Boolean read GetIsAccessReports;
      property IsAccessSMS:Boolean read GetIsAccessSMS;
      property IsAccessService:Boolean read GetIsAccessService;
      property IsAccessCalls:Boolean read GetIsAccessCalls;
      property Access[_menu:enumAccessList]:enumAccessStatus read GetAccess; default;
      property Role:enumRole read GetRole;
      property IsNotActiveAccount:Boolean read m_disabled;
      property LastActive:TDateTime read m_lastActive;
      property CommonQueueSTR:string read GetCommonQueue;
      property Queue[_queue:enumQueue]:Boolean read GetExistQueue;
      property ExternalAccess[_access:enumExternalAccessEXE]:Boolean read GetExternalAccess;

      end;
 // class TUser END

/////////////////////////////////////////////////////////////////////////////////////////

implementation

uses
  FunctionUnit, GlobalVariables, GlobalVariablesLinkDLL;

// class TUserCommonQueue START
constructor TUserCommonQueue.Create(_userID:Integer);
begin
  m_count:=0;
  m_list:=TList<enumQueue>.Create;
  m_userID:=_userID;

  LoadData;
end;


// ��������� ������
procedure TUserCommonQueue.LoadData;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countQueue:Integer;
 request:TStringBuilder;
 i:Integer;
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

      request:=TStringBuilder.Create;
      with request do begin
        Clear;
        Append('select count(id)');
        Append(' from users_common_queue where user_id = '+#39+IntToStr(m_userID)+#39);
      end;

      SQL.Add(request.ToString);
      Active:=True;

      if Fields[0].Value = null then Exit;

      countQueue:=StrToInt(VarToStr(Fields[0].Value));
      if countQueue = 0 then Exit;

      with request do begin
        Clear;
        Append('select queue');
        Append(' from users_common_queue where user_id = '+#39+IntToStr(m_userID)+#39);
      end;

      SQL.Clear;
      SQl.Add(request.ToString);
      Active:=True;

      // ������� ������
      m_count:=countQueue;

      for i:=0 to countQueue-1 do begin
        m_list.Add(StringToEnumQueue(VarToStr(Fields[0].Value)));
        ado.Next;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;


function TUserCommonQueue.GetQueue:string;
var
 i:Integer;
 str:string;
begin
  str:='';
  Result:='---';

  if m_count = 0 then Exit;

  for i:=0 to m_count-1 do begin
    if str='' then str:=EnumQueueToString(m_list[i])
    else str:=str+','+EnumQueueToString(m_list[i]);
  end;

  Result:=str;
end;


function TUserCommonQueue.IsExist(_queue:enumQueue):Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_count-1 do begin
    if m_list[i] = _queue then begin
      Result:=True;
      Exit;
    end;
  end;
end;


// class TUserCommonQueue END



// class TUserList START
constructor TUserData.Create;
begin
  inherited Create;
 _Init;
end;

constructor TUserData.Create(_userId:Integer);
begin
   inherited Create;
  _Init;
  LoadData(_userId);
end;

procedure TUserData._Init;
begin
 m_name             :='';
 m_familiya         :='';
 m_id               :=-1;
 m_group_role       :=role_operator_no_dash;
 m_login            :='';
 m_re_password      :=eYES;
 m_acive_session_id :=-1;
 m_ip               :='0.0.0.0';
 m_pc               :='';
 m_user_login_pc    :='';
 m_auth             :=eAuthLocal;
end;


procedure TUserData.LoadData(_userId:Integer);   // ��������� ������ �� ������������
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
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

      request:=TStringBuilder.Create;
      with request do begin
        Clear;
        Append('select name,familiya,login');
        Append(' from users where id = '+#39+IntToStr(_userId)+#39);
      end;


      SQL.Add(request.ToString);
      Active:=True;


      Self.m_name                := VarToStr(Fields[0].Value);
      Self.m_familiya            := VarToStr(Fields[1].Value);
      Self.m_id                  := _userId;
      Self.m_group_role          := StringToEnumRole(getUserRoleSTR(_userId));
      Self.m_login               := VarToStr(Fields[2].Value);
      Self.m_re_password         := GetUserRePassword(_userId);
      Self.m_auth                := GetUserAuth(_userId);

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;


procedure TUserData.Clone(_userData:TUserData);
begin
  if _userData = nil then Exit;
  m_name             := _userData.m_name;
  m_familiya         := _userData.m_familiya;
  m_id               := _userData.m_id;
  m_group_role       := _userData.m_group_role;
  m_login            := _userData.m_login;
  m_re_password      := _userData.m_re_password;
  m_acive_session_id := _userData.m_acive_session_id;
  m_ip               := _userData.m_ip;
  m_pc               := _userData.m_pc;
  m_user_login_pc    := _userData.m_user_login_pc;
  m_auth             := _userData.m_auth;
end;

// class TUserData END


// class TUser START
constructor TUser.Create;
begin
   inherited Create;

   _Init;
   m_params:=TUserData.Create;
end;

constructor TUser.Create(_userId:Integer);
begin
    inherited Create;
   _Init;

  // ��������� m_params
  m_params:=TUserData.Create(_userId);

  // ��������� m_access
  m_access:=TUserAccess.Create(m_params.m_group_role);

  // �������� �������� �� ����������� ��� ���
  m_userIsOperator:=GetRoleIsOperator(m_params.m_group_role);

  // ������������ �� �������
  m_disabled:=AccountStatus(m_params.m_id);

  // �������� ���� �� ������ � ���������� ����
  m_externalAccessEXE[eExternalAccessLocalChat]:=GetAccessLocalChat(m_params.m_id);

  // �������� ���� �� ������ � �������
  m_externalAccessEXE[eExternalAccessReports]:=GetAccessReports(m_params.m_id);

  // �������� ���� �� ������ � SMS ��������
  m_externalAccessEXE[eExternalAccessSMS]:=GetAccessSMS(m_params.m_id);

  // �������� ���� �� ������ � �������
  m_externalAccessEXE[eExternalAccessService]:=GetAccessService;

   // �������� ���� �� ������ � �������
  m_externalAccessEXE[eExternalAccessCalls]:=GetAccessCalls(m_params.m_id);

  // ����� ����� ��������� ��� ������� � ���������
  m_lastActive:=LastActiveAccount(m_params.m_id);

  // ������� � ������� ���������� ������������
  m_commonQueue:=TUserCommonQueue.Create(m_params.m_id);
end;


destructor TUser.Destroy;
begin
  // ������� ���������� (���������) �������
  FreeAndNil(m_commonQueue);
  FreeAndNil(m_externalAccessEXE);
  FreeAndNil(m_access);
  FreeAndNil(m_params);
  // ����� ������
  inherited;
end;

 // �������������
procedure TUser._Init;
var
  capacity:Integer;
  i:Integer;
begin
  capacity:=Ord(High(enumExternalAccessEXE));
  m_externalAccessEXE:=TDictionary<enumExternalAccessEXE, Boolean>.Create(capacity);
  for i:=0 to capacity do begin
   m_externalAccessEXE.Add(enumExternalAccessEXE(i),False);
  end;

  m_disabled:=False;
  m_lastActive:=0;
end;



// ������ �������� (����������� ��� ���)
function TUser.AccountStatus(_userId:Integer):Boolean;
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
      SQL.Add('select disabled from users where id = '+#39+IntToStr(_userId)+#39);

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

// ����� ����� ��������� ��� ������� � ���������
function TUser.LastActiveAccount(_userId:Integer):TDateTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
  Result:=0;

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

      request:=TStringBuilder.Create;
      with request do begin
       Clear;
       Append('select date_time from logging');
       Append(' where user_id = '+#39+IntToStr(_userId)+#39);
       Append(' and action = ''0'' order by date_time DESC');
      end;

      SQL.Add(request.ToString);
      Active:=True;

      if Fields[0].Value <> null then begin
        Result:=StrToDateTime(VarToStr(Fields[0].Value));
        Exit;
      end;

      // ��� � ������� ���� ������� ������
      with request do begin
       Clear;
       Append('select date_time from history_logging');
       Append(' where user_id = '+#39+IntToStr(_userId)+#39);
       Append(' and action = ''0'' order by date_time DESC');
      end;

      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if Fields[0].Value <> null then begin
        Result:=StrToDateTime(VarToStr(Fields[0].Value));
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;

//����� ������� �������� ��� ���������\��������������
function TUser.GetCommonQueue:string;
begin
  Result:=m_commonQueue.ActiveQueueSTR;
end;

// ������ �� ������� � �������
function TUser.GetExistQueue(_queue:enumQueue):Boolean;
begin
  Result:=m_commonQueue.IsExistQueue[_queue];
end;

// ����� ������� ���� � ������� ����������
function TUser.GetExternalAccess(_access:enumExternalAccessEXE):Boolean;
begin
  Result:=m_externalAccessEXE[_access];
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


 // �������� ���� �� ������ � �������
 function TUser.GetAccessCalls(InUserID:integer):Boolean;
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
      SQL.Add('select calls from users where id = '+#39+IntToStr(InUserId)+#39);

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
  Result:=m_access.menu_service;
end;


 procedure TUser.UpdateParams(InParams:TUserData);
 begin
   with m_params do begin
     m_name               :=InParams.m_name;
     m_familiya           :=InParams.m_familiya;
     m_id                 :=InParams.m_id;
     m_group_role         :=InParams.m_group_role;
     m_login              :=InParams.m_login;
     m_re_password        :=InParams.m_re_password;
     m_acive_session_id   :=InParams.m_acive_session_id;
     m_ip                 :=InParams.m_ip;
     m_pc                 :=InParams.m_pc;
     m_user_login_pc      :=InParams.m_user_login_pc;
     m_auth               :=InParams.m_auth
   end;

   m_access:=TUserAccess.Create(InParams.m_group_role);

   // �������� �������� �� ����������� ��� ���
   m_userIsOperator:=GetRoleIsOperator(InParams.m_group_role);

   // �������� ���� �� ������ � ���������� ����
   m_externalAccessEXE[eExternalAccessLocalChat]:=GetAccessLocalChat(InParams.m_id);

   // �������� ���� �� ������ � �������
   m_externalAccessEXE[eExternalAccessReports]:=GetAccessReports(InParams.m_id);

   // �������� ���� �� ������ � SMS ��������
   m_externalAccessEXE[eExternalAccessSMS]:=GetAccessSMS(InParams.m_id);

   // �������� ���� �� ������ � �������
   m_externalAccessEXE[eExternalAccessService]:=GetAccessService;

   // �������� ���� �� ������ � �������
   m_externalAccessEXE[eExternalAccessCalls]:=GetAccessCalls(InParams.m_id);

   // ������� � ������ ��������� ������������
   m_commonQueue:=TUserCommonQueue.Create(InParams.m_id);
 end;

 function TUser.GetID:Integer;
 begin
  Result:=m_params.m_id;
 end;

 function TUser.GetName:string;
 begin
  Result:=m_params.m_name;
 end;

 function TUser.GetFamiliya:string;
 begin
  Result:=m_params.m_familiya;
 end;

 function TUser.GetLogin:string;
 begin
  Result:=m_params.m_login;
 end;

 function TUser.GetIP:string;
 begin
  Result:=m_params.m_ip;
 end;

 function TUser.GetUserLoginPC:string;
 begin
  Result:=m_params.m_user_login_pc;
 end;

 function TUser.GetPC:string;
 begin
  Result:=m_params.m_pc;
 end;

 function TUser.GetRole:enumRole;
 begin
  Result:=m_params.m_group_role;
 end;

 function TUser.GetRePassword:enumStatus;
 begin
  Result:=m_params.m_re_password;
 end;

 function TUser.GetAuth:enumAuth;
 begin
  Result:=m_params.m_auth;
 end;

 function TUser.GetIsOperator:Boolean;
 begin
  Result:=m_userIsOperator;
 end;

 function TUser.GetIsAccessLocalChat:Boolean;
 begin
  Result:=m_externalAccessEXE[eExternalAccessLocalChat];
 end;

 function TUser.GetIsAccessReports:Boolean;
 begin
  Result:=m_externalAccessEXE[eExternalAccessReports];
 end;

 function TUser.GetIsAccessSMS:Boolean;
 begin
  Result:=m_externalAccessEXE[eExternalAccessSMS];
 end;

function TUser.GetIsAccessService:Boolean;
 begin
  Result:=m_externalAccessEXE[eExternalAccessService];
 end;

function TUser.GetIsAccessCalls :Boolean;
 begin
  Result:=m_externalAccessEXE[eExternalAccessCalls];
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

 function TUser.GetUserData:TUserData;
 begin
   Result:=m_params;
 end;

// class TUser END

end.
