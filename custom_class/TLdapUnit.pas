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
  // стандартный порт LDAP
  LDAP_PORT               = 389;

  // коды ошибок/результатов
  LDAP_SUCCESS            = 0;
  LDAP_OPERATIONS_ERROR   = 1;

  // версия протокола
  LDAP_VERSION2           = 2;
  LDAP_VERSION3           = 3;

  // параметры для ldap_set_option
  LDAP_OPT_PROTOCOL_VERSION = 17;

type
  // opaque-тип для контекста соединения
  PLDAP = Pointer;

  // тип для возвращаемых кодов и опций
  TLdapInt = Integer;

{ Инициализация соединения с LDAP-сервером. }
function ldap_init(Host: PAnsiChar; PortNumber: TLdapInt): PLDAP; stdcall; external 'wldap32.dll';

{ Устанавливает параметры (например версию протокола). }
function ldap_set_option(ld: PLDAP; Option: Integer; const InValue: TLdapInt): TLdapInt; stdcall; external 'wldap32.dll';

{ Простая привязка (bind) – возвращает LDAP_SUCCESS или код ошибки. }
function ldap_simple_bind_s(ld: PLDAP; DistinguishedName, Password: PAnsiChar): TLdapInt; stdcall; external 'wldap32.dll';

{ Закрыть соединение и освободить все ресурсы. }
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
//  // Переключаемся на LDAPv3
//  opt := LDAP_VERSION3;
//  ldap_set_option(ld, LDAP_OPT_PROTOCOL_VERSION, opt);
//
//  // Пытаемся привязаться
//  rc := ldap_simple_bind_s(ld,
//    PAnsiChar(AnsiString(UserDN)),
//    PAnsiChar(AnsiString(Password)));
//
//  if rc = LDAP_SUCCESS then
//    Result := True;
//
//  ldap_unbind(ld);
//end;
