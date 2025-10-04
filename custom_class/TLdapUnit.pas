 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                               LDAP                                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TLdapUnit;

interface

uses
  System.ShareMem, System.SysUtils, System.Classes,
   Winapi.Windows, Data.Win.ADODB, Data.DB, Variants, IdException,
   Winapi.Winsock2;

const
  // ����������� ���� LDAP
  LDAP_PORT               = 389;

  // ���� ������/�����������
  LDAP_SUCCESS            = 0;
  LDAP_OPERATIONS_ERROR   = 1;

  // ������ ���������
  LDAP_VERSION2           = 2;
  LDAP_VERSION3           = 3;

  // ��������� ��� ldap_set_option
  LDAP_OPT_PROTOCOL_VERSION = 17;

  // ����� �������������� SSPI/Kerberos
  LDAP_AUTH_NEGOTIATE     = $A;

  LDAP_NO_DATA = TRUE;

  LDAP_SCOPE_BASE     = 0;
  LDAP_SCOPE_ONELEVEL = 1;
  LDAP_SCOPE_SUBTREE  = 2;

type
  // opaque-��� ��� ��������� ����������
  PLDAP = Pointer;
  PLDAPMessage = Pointer;
  PPLDAPMessage = ^PLDAPMessage;

  // ��� ��� ������������ ����� � �����
  TLdapInt = Integer;


{ ������������� ���������� � LDAP-��������. }
function ldap_init(Host: PAnsiChar; PortNumber: TLdapInt): PLDAP; stdcall; external 'wldap32.dll';

{ ������������� ��������� (�������� ������ ���������). }
function ldap_set_option(ld: PLDAP; Option: Integer; const InValue: TLdapInt): TLdapInt; stdcall; external 'wldap32.dll';

{ ������� �������� (bind) � ���������� LDAP_SUCCESS ��� ��� ������. }
function ldap_simple_bind_s(ld: PLDAP; DistinguishedName, Password: PAnsiChar): TLdapInt; stdcall; external 'wldap32.dll';

{ ������� ���������� � ���������� ��� �������. }
function ldap_unbind(ld: PLDAP): TLdapInt; stdcall; external 'wldap32.dll';

function ldap_bind_sW(ld: PLDAP; dn: PWideChar; AuthIdentity: Pointer; Method: TLdapInt): TLdapInt; stdcall; external 'wldap32.dll' name 'ldap_bind_sW';
function ldap_search_sA(
  ld        : PLDAP;
  base      : PAnsiChar;
  scope     : Integer;
  filter    : PAnsiChar;
  attrs     : PPAnsiChar;
  attrsonly : Integer;
  res       : PPLDAPMessage
): TLdapInt; stdcall; external 'wldap32.dll';

{ �������� TLS �� StartTLS }
function ldap_start_tls_sW(
  ld             : PLDAP;
  ServerControls : Pointer;
  ClientControls : Pointer
): TLdapInt; stdcall; external 'wldap32.dll';

function ldap_first_entry(ld: PLDAP; lm: PLDAPMessage): PLDAPMessage; stdcall; external 'wldap32.dll';
function ldap_next_entry(ld: PLDAP; lm: PLDAPMessage): PLDAPMessage; stdcall; external 'wldap32.dll';
function ldap_first_attributeA(ld: PLDAP; entry: PLDAPMessage; var ber: Pointer): PAnsiChar; stdcall; external 'wldap32.dll';
function ldap_next_attributeA(ld: PLDAP; entry: PLDAPMessage; ber: Pointer): PAnsiChar; stdcall; external 'wldap32.dll';
function ldap_get_valuesA(ld: PLDAP; entry: PLDAPMessage; attr: PAnsiChar): PPAnsiChar; stdcall; external 'wldap32.dll';
procedure ldap_value_freeA(vals: PPAnsiChar); stdcall; external 'wldap32.dll';
procedure ldap_memfreeA(p: Pointer); stdcall; external 'wldap32.dll';
procedure ber_free(ber: Pointer; freebuf: Integer); stdcall; external 'wldap32.dll';
function ldap_msgfree(msg: PLDAPMessage): Integer; stdcall; external 'wldap32.dll';


 // class TLdap

  type
    TLdap = class

    private
    m_init:Boolean;     // ���� ��� ������ �� ldap
    m_host:string;      // ���� ldap
    m_port:Integer;     // ���� ldap
    m_enabled:Boolean;  // ��������� �� ����������� �� LDAP

    procedure CreateLdapData;   // ��������� ������ ldap

    public

    constructor Create;                                 overload;
    constructor Create(_nodata:Boolean);                overload;
    constructor Create(_host:string;_port:Integer);     overload;

    function CheckAuth(_userName,_userPassword:string):Boolean; overload; // �������� �� �����������
    function CheckAuth: Boolean;                                overload;      // �� ������!!
    function SaveLdapDataToBase(_host:string;_port:Integer; var _errorDescription:string):Boolean; // ���������� ������ ldap � ��
    function SetStatusLdap(_value:Boolean; var _errorDescription:string):Boolean; // ���\���� ����������� ����������� �� LDAP
    function GetStatusLdap:Boolean;
    function GetUserFullName(const Login: string; out FullName: string): Boolean;


    property LdapHost:string read m_host;
    property LdapPort:Integer read m_port;
    property LdapIsInit:Boolean read m_init;

    end;
  // class TLdap END


implementation

uses
  GlobalVariablesLinkDLL;

constructor TLdap.Create;
begin
  m_init:=False;
  CreateLdapData;
end;

constructor TLdap.Create(_nodata:Boolean);
begin
  m_init:=False;
  if not _nodata then CreateLdapData;
end;

constructor TLdap.Create(_host:string;_port:Integer);
begin
  m_host:=_host;
  m_port:=_port;

  m_init:=True;
end;

procedure TLdap.CreateLdapData;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
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
       SQL.Add('select host,port,enable from settings_ldap where id = ''1'' ');
       Active:=True;

       if (Fields[0].Value=null) or (Fields[1].Value=null) then Exit;

       m_host:=VarToStr(Fields[0].Value);
       m_port:=StrToInt(VarToStr(Fields[1].Value));

       if StrToInt(VarToStr(Fields[2].Value)) = 0 then m_enabled:=False
       else m_enabled:=True;


      // m_port:=636;
       m_init:=True;
      end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
end;


function TLdap.GetStatusLdap:Boolean;
begin
  Result:=m_enabled;
end;


// ���������� ������ ldap � ��
function TLdap.SaveLdapDataToBase(_host:string;_port:Integer;
                                  var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update settings_ldap set host = '+#39+_host+#39
                                              +', port = '+#39+IntToStr(_port)+#39
                                              +' where id = ''1'' ');
      try
          ExecSQL;
      except
          on E:EIdException do begin
            _errorDescription:='������! '+e.Message;
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

  Result:=True;
end;


// ���\���� ����������� ����������� �� LDAP
function TLdap.SetStatusLdap(_value:Boolean; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 status:string;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  if _value then status:='1' else status:='0';


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update settings_ldap set enable = '+#39+status+#39
                                                  +' where id = ''1'' ');
      try
          ExecSQL;
      except
          on E:EIdException do begin
            _errorDescription:='������! '+e.Message;
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

  Result:=True;
end;


function TLdap.CheckAuth(_userName, _userPassword: string):Boolean;
var
  ldap: PLDAP;
  rc: TLdapInt;
  opt: TLdapInt;
begin
  Result:=False;

  // ��� �� ����� �� ���
  if not m_init then Exit;


  ldap := ldap_init(PAnsiChar(AnsiString(m_host)), m_port);
  if ldap = nil then Exit;

  // ������������� �� LDAPv3
  opt := LDAP_VERSION3;
  ldap_set_option(ldap, LDAP_OPT_PROTOCOL_VERSION, opt);

  // �������� �����������
  rc:= ldap_simple_bind_s(ldap, PAnsiChar(AnsiString(_userName+'@'+m_host)), PAnsiChar(AnsiString(_userPassword)));
  if rc = LDAP_SUCCESS then Result:=True;

  ldap_unbind(ldap);
end;


function TLdap.CheckAuth: Boolean;
var
  ldap: PLDAP;
  rc: TLdapInt;
  opt: TLdapInt;

  errRc: Integer;
  pErr, pDiag: PWideChar;
begin
  Result := False;
  // 1. �������������
  ldap := ldap_init(PAnsiChar(AnsiString(m_host)), m_port);
  if ldap = nil then Exit;

  try
    // 2. ������ LDAP-���������
    opt := LDAP_VERSION3;
    ldap_set_option(ldap, LDAP_OPT_PROTOCOL_VERSION, opt);

    // 3. SSPI/Kerberos bind: dn = nil, AuthIdentity = nil, Method = NEGOTIATE
    //    ���� ����� = NEGOTIATE � ������ = nil, WinLDAP ��������� ������� ����� Windows
    rc := ldap_bind_sW(ldap, nil, nil, LDAP_AUTH_NEGOTIATE);

//     errRc := ldap_bind_sW( ldap, nil, nil, LDAP_AUTH_NEGOTIATE );
//    if errRc <> LDAP_SUCCESS then
//    begin
//      ldap_get_optionW( ldap, LDAP_OPT_ERROR_STRING, @pErr );
//      ldap_get_optionW( ldap, LDAP_OPT_DIAGNOSTIC_MESSAGE, @pDiag );
//      ShowMessageFmt( 'bind_sW failed: %d, server: %s, diagnostic: %s',
//    [errRc, string(pErr), string(pDiag)] );
//    end;

    Result := (rc = LDAP_SUCCESS);
  finally
    // 4. ������� ����������
    ldap_unbind(ldap);
  end;
end;




function TLdap.GetUserFullName(const Login: string; out FullName: string): Boolean;
const
  // ��������, ������� ����������� � ����������
  // ��������� ������� ������ ���� nil
  Attrs: array[0..1] of PAnsiChar = ('displayName', nil);
var
  ld: PLDAP;
  rc: TLdapInt;
  opt: TLdapInt;
  msg: PLDAPMessage;
  entry: PLDAPMessage;
  vals: PPAnsiChar;
  searchFilter: AnsiString;
  WSAData: TWSAData;
begin
  Result:= False;
  FullName:= '';
  if not m_init then Exit;      // �� ���������������

 // WSAStartup(MAKEWORD(2,2), WSAData);
  if WSAStartup($0202, WSAData) <> 0 then Exit;

  // 1) �������������� ����������
  ld := ldap_init(PAnsiChar(AnsiString(m_host)), m_port);
  if ld = nil then Exit;

  // 2) ������ LDAPv3
  opt := LDAP_VERSION3;
  ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, opt);
  rc := ldap_start_tls_sW(ld, nil, nil);


  // 3) Bind: ����� ������� ��������� ��� �� ��� ������� �������
  //    ���� �����, ����� ���������� ������ ��������������
  rc := ldap_simple_bind_s(
    ld,
    PAnsiChar(AnsiString('@dialine.local')),  // ������ � �������
    PAnsiChar(AnsiString(''))                  // � ������
    );
  if rc <> LDAP_SUCCESS then
  begin
    ldap_unbind(ld);
    Exit;
  end;

  // 4) ������ ������ ������ �� ������
  searchFilter := Format('(&(objectClass=user)(sAMAccountName=%s))', [AnsiString(Login)]);

  // 5) ���������� �����
  msg := nil;
  rc := ldap_search_sA(ld,
                       PAnsiChar(AnsiString('DC=dialine,DC=local')), LDAP_SCOPE_SUBTREE,
                       PAnsiChar(searchFilter),
                       PPAnsiChar(@Attrs), // ����������� displayName
                       0,
                       msg);
  if (rc <> LDAP_SUCCESS) or (msg = nil) then
  begin
    ldap_unbind(ld);
    Exit;
  end;

  // 6) ��������� ������ ��������� ������
  entry := ldap_first_entry(ld, msg);
  if entry <> nil then
  begin
    vals := ldap_get_valuesA(ld, entry, 'displayName');
    if (vals <> nil) and (vals^ <> nil) then
    begin
      FullName := string(vals^);
      ldap_value_freeA(vals);
      Result := True;
    end;
  end;

  // 7) ������ �� �����
  ldap_msgfree(msg);
  ldap_unbind(ld);
end;


end.

