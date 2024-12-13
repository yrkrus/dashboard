library core;

uses
  System.ShareMem,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Data.Win.ADODB,
  Data.DB,
  Variants,
  System.DateUtils,
  GlobalVariables in 'GlobalVariables.pas';

{$R *.res}

// �������� ����������� � �������
function createServerConnect: Pointer; stdcall; // ���������� ���������
begin
  Result:= Pointer(TADOConnection.Create(nil)); // ������� ������ � ���������� ���������

  with TADOConnection(Result) do
  begin
    DefaultDatabase := GetServerAddress;
    Provider := 'MSDASQL.1';
    ConnectionString := 'Provider=' + Provider +
                        ';Password=' + GetServerPassword +
                        ';Persist Security Info=True;User ID=' + GetServerUser +
                        ';Extended Properties="Driver=MySQL ODBC 5.3 Unicode Driver;SERVER=' + GetServerAddress +
                        ';UID=' + GetServerUser +
                        ';PWD=' + GetServerPassword +
                        ';DATABASE=' + DefaultDatabase +
                        ';PORT=3306;COLUMN_SIZE_S32=1";Initial Catalog=' + DefaultDatabase;

    LoginPrompt := False;  // ��� ������� �� ����� �����\������

    try
      Connected := True;
      Open;
    except
      on E: Exception do
      begin
        Free; // ����������� ������ � ������ ������
        //raise; // ����� ������� ����������, ����� �������� �� ������
      end;
    end;
  end;
end;

function GetCopyright:string;stdcall;export;
var
  CurrentYear: string;
begin
  CurrentYear:=FormatDateTime('yyyy', Now);
  if CurrentYear='2024' then Result:='developer by Petrov Yuri � '+CurrentYear+'       '
  else Result:='developer by Petrov Yuri � 2024-'+CurrentYear+'       ';
end;


// ��������� ����� ������������ �� ��� UserID
function GetUserFIO(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select familiya,name from users where id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;

    Result:=VarToStr(Fields[0].Value)+' '+VarToStr(Fields[1].Value);
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;
end;


// ���� �� ������ � ������������ � ���������� ����
function GetUserAccessLocalChat(InUserID:Integer):Boolean;stdcall;export;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select chat from users where id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;
    if StrToInt(VarToStr(Fields[0].Value)) = 1  then  Result:=True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;
end;



function GetUserNameFIO(InUserID:Integer):PChar; export;
begin
  Result:=PChar(GetUserFIO(InUserID));
end;


// ������� ����� ������ ���
function getNowDateTime:string;
begin
  Result:= FormatDateTime('yyyy-mm-dd 00:00:00', Now);
end;


function GetCurrentStartDateTime:PChar; stdcall; export;
begin
 Result:= PChar(getNowDateTime);
end;

// ������� ����� ������ ��� (����� ������)
function getNowDateTimeDec(DecMinutes:Integer):string;
var
  AdjustedTime: TDateTime;
begin
  AdjustedTime := IncMinute(Now, -DecMinutes);
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', AdjustedTime);
end;


function GetCurrentDateTimeDec(DecMinutes:Integer):PChar; stdcall; export;
begin
  Result:=PChar(getNowDateTimeDec(DecMinutes));
end;


// ������ ������� ����
function getCurrentNowTime:string;
begin
  Result:= FormatDateTime('yyyymmdd', Now);
end;

function GetCurrentTime:PChar; stdcall; export;
begin
  Result:=PChar(getCurrentNowTime);
end;

// ����� � ��������� �����
function GetLocalChatNameFolder:PChar; stdcall; export;
begin
 Result:= PChar('chat_history');
end;

// ���������� �����
function GetExtensionLog:PChar; stdcall; export;
begin
 Result:= PChar('.html');
end;



exports
  createServerConnect,
  GetCopyright,
  GetUserNameFIO,
  GetUserAccessLocalChat,
  GetCurrentStartDateTime,
  GetCurrentDateTimeDec,
  GetCurrentTime,
  GetLocalChatNameFolder,
  GetExtensionLog;

begin
end.
