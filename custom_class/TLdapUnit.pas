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
  Windows;

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

type
  // opaque-��� ��� ��������� ����������
  PLDAP = Pointer;

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

implementation

end.




//uses
//  Windows, Ldap;
//
//function LdapAuthenticate(const Host: string;
//  const UserDN, Password: string;
//  Port: Integer = LDAP_PORT): Boolean;
//var
//  ld: PLDAP;
//  rc: TLdapInt;
//  opt: TLdapInt;
//begin
//  Result := False;
//  ld := ldap_init(PAnsiChar(AnsiString(Host)), Port);
//  if ld = nil then Exit;
//
//  // ������������� �� LDAPv3
//  opt := LDAP_VERSION3;
//  ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, opt);
//
//  // �������� �����������
//  rc := ldap_simple_bind_s(ld,
//    PAnsiChar(AnsiString(UserDN)),
//    PAnsiChar(AnsiString(Password)));
//
//  if rc = LDAP_SUCCESS then
//    Result := True;
//
//  ldap_unbind(ld);
//end;
