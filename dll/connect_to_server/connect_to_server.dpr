library connect_to_server;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.ShareMem,
  System.SysUtils,
  System.Classes,
  Winapi.Windows;

const
  // авторизационные данные для подключения к БД
  Shared_const_BD_Addr          :string  = 'dashboard';
  Shared_const_BD_Name          :string  = 'dashboard';
  Shared_const_BD_UserName      :string  = 'dash';
  Shared_const_BD_UserPassword  :string  = 'dash';

{$R *.res}

// функция получения адреса сервера
function GetServerAddress:string;stdcall;export;
begin
  Result:=Shared_const_BD_Addr;
end;

// функция получения имени сервера
function GetServerName:string;stdcall;export;
begin
  Result:=Shared_const_BD_Name;
end;


// функция получения имени
function GetServerUser:string;stdcall;export;
begin
  Result:=Shared_const_BD_UserName;
end;

// функция получения пароля
function GetServerPassword:string;stdcall;export;
begin
  Result:=Shared_const_BD_UserPassword;
end;

exports  GetServerAddress,
         GetServerName,
         GetServerUser,
         GetServerPassword;

begin
end.
