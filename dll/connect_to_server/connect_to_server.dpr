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
  /////////////////// PROJECT DASHBOARD ///////////////////
  // ��������������� ������ ��� ����������� � ��
  Shared_const_BD_Addr          :string  = 'dashboard';
  Shared_const_BD_Name          :string  = 'dashboard';
  Shared_const_BD_NameTest      :string  = 'dashboard_test';

  Shared_const_BD_UserName      :string  = 'dash';
  Shared_const_BD_UserPassword  :string  = 'dash';

  // ����������� �� ftp
  Shared_const_FTP_Addr         :string = 'dashboard';
  Shared_const_FTP_User         :string = 'update_dash';
  Shared_const_FTP_Pass         :string = 'update_dash';

  // tcp server dashboard
  Shared_const_TCP_server_Addr  :string = 'voip';
  Shared_const_TCP_server_Port  :Word = 12345;

  /////////////////// PROJECT DASHBOARD ///////////////////

  // *************************************************** //

  ////////////////// PROJECT CORP HEALTH //////////////////
  Shared_const_BD_Addr_Health       :string  = 'corp_health';
  Shared_const_BD_Name_Health       :string  = 'corp_health';
  // �����&������ ����� �� dash=dash �� ���� ������ � ������ �����
  ////////////////// PROJECT CORP HEALTH //////////////////


{$R *.res}

// ������� ��������� ������ �������
function GetServerAddress:string;stdcall;export;
begin
  Result:=Shared_const_BD_Addr;
 //  Result:=Shared_const_BD_Addr_Health;
end;

// ������� ��������� ����� �������
function GetServerName:string;stdcall;export;
begin
   Result:=Shared_const_BD_Name;
  //   Result:=Shared_const_BD_Name_Health;
end;

// ������� ��������� ����� ������� (��������)
function GetServerNameTest:string;stdcall;export;
begin
  Result:=Shared_const_BD_NameTest;
end;

// ������� ��������� �����
function GetServerUser:string;stdcall;export;
begin
  Result:=Shared_const_BD_UserName;
end;

// ������� ��������� ������
function GetServerPassword:string;stdcall;export;
begin
  Result:=Shared_const_BD_UserPassword;
end;


// ������� ������ ftp
function GetFTPServerAddress:string;stdcall;export;
begin
  Result:=Shared_const_FTP_Addr;
end;

// ������� ftp user
function GetFTPServerUser:string;stdcall;export;
begin
  Result:=Shared_const_FTP_User;
end;

// ������� ftp password
function GetFTPServerPassword:string;stdcall;export;
begin
  Result:=Shared_const_FTP_Pass;
end;

// ������� ��������� ������ tcp ������� dashboard
function GetTCPServerAddress:string;stdcall;export;
begin
  Result:=Shared_const_TCP_server_Addr;
end;

// ������� ��������� ����� tcp ������� dashboard
function GetTCPServerPort:Word;stdcall;export;
begin
  Result:=Shared_const_TCP_server_Port;
end;


exports  GetServerAddress,
         GetServerName,
         GetServerNameTest,
         GetServerUser,
         GetServerPassword,
         GetFTPServerAddress,
         GetFTPServerUser,
         GetFTPServerPassword,
         GetTCPServerAddress,
         GetTCPServerPort;

begin
end.
