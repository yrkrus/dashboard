/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  ����� ��� �������� TOnlineUsers                          ///
///               �������� ������������� ��� � �������                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TOnlineUsersUint;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException;


/////////////////////////////////////////////////////////////////////////////////////////
     // class TStructUsers
    type
      TStructUsers = class

      public
      userID            :Integer;
      FIO               :string;

      constructor Create;                   overload;

      procedure Clear;

      end;

     // class TStructUsers END

/////////////////////////////////////////////////////////////////////////////////////////
 // class TOnlineUsers
 type
      TOnlineUsers = class
      const
      cMAXUSERS       : Word = 100;
      cOFFLINE_TIME   :Word = 10; // ����� � �������� ��� ������� ������� ��� ��� ��� � ������� ������������

      public


      constructor Create;                   overload;
      destructor Destroy;                   override;

      function Count:Integer;               // ������� � ��� ���� �������������
      procedure Clear;

      procedure CreateOnlineUsers;         // �������������� �������� �������������
      procedure UpdateOnlineUsers;           // ���������� ��� � ��� ������ ��������� ������


      function GetOnlineUsers_ID(i:Integer):Integer;    // listUsers.userID
      function GetOnlineUsers_FIO(i:Integer):string;    // listUsers.FIO

      private

      m_count                              : Integer;
      m_mutex                              : TMutex;
      listUsers                            : array of TStructUsers;

      function GetUsersOnline:TStringList;     // ������ ������������� ��� ������ � �������

      end;
   // class TOnlineUsers END


implementation

uses
  GlobalVariables, Functions;

constructor TStructUsers.Create;
 begin
   inherited;
   Self.Clear;
 end;

 procedure TStructUsers.Clear;
 begin
  Self.userID:=0;
  Self.FIO:='';
 end;

constructor TOnlineUsers.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TOnlineUsers');
    m_count:=0;

   SetLength(listUsers,cMAXUSERS);
   for i:=0 to cMAXUSERS-1 do listUsers[i]:=TStructUsers.Create;

   // �������� ������������� �������������
   CreateOnlineUsers;
 end;


destructor TOnlineUsers.Destroy;
var
 i: Integer;
begin
  for i := Low(listUsers) to High(listUsers) do FreeAndNil(listUsers[i]);
  m_mutex.Free;
  inherited;
end;


// ������ ������������� ��� ������ � �������
function TOnlineUsers.GetUsersOnline:TStringList;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countOnline:Integer;
 userID:Integer;
 lastSession:TDateTime;
begin
  Result:=TStringList.Create;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(user_id) from active_session');

    Active:=True;

    countOnline:=StrToInt(VarToStr(Fields[0].Value));

    if countOnline=0 then begin
      FreeAndNil(ado);
      serverConnect.Close;
      if Assigned(serverConnect) then serverConnect.Free;
      Exit;
    end;

    SQL.Clear;
    SQL.Add('select user_id,last_active from active_session');
    Active:=True;

    for i:=0 to countOnline-1 do begin
      userID:=StrToInt(VarToStr(Fields[0].Value));
      lastSession:=StrToDateTime(VarToStr(Fields[1].Value));

      if (Round((Now - lastSession) * 24 * 60 *60) < cOFFLINE_TIME) then begin
       // ���� �� ������ � ����
       if GetUserAccessLocalChat(userID) then Result.Add(IntToStr(userID));
      end;

      Next;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;
end;


procedure TOnlineUsers.CreateOnlineUsers;
var
 i:Integer;
 usersOnline:TStringList;
begin
  // ������ id � �������� � ����
  usersOnline:=GetUsersOnline;
  if usersOnline.Count <> 0  then begin

     // ���������� ������� ��� ������ �������
     for i:=0 to usersOnline.Count-1 do begin
       listUsers[i].userID:=StrToInt(usersOnline[i]);
       // ������ ���
       listUsers[i].FIO:=GetUserNameFIO(listUsers[i].userID);
     end;

     m_count:=usersOnline.Count;
  end;

  if usersOnline<>nil then FreeAndNil(usersOnline);

end;



// ���������� ��� ������ ��������� ������
procedure TOnlineUsers.UpdateOnlineUsers;
var
 i:Integer;
 usersOnline:TStringList;
 needUpdate:Boolean;
begin
  usersOnline:=GetUsersOnline;

  if usersOnline.Count <> Count then begin

    if m_mutex.WaitFor(INFINITE)=wrSignaled then
    try
      if usersOnline.Count<>Count then begin
         Self.Clear;

          // ���������� ������� ��� ������ �������
         for i:=0 to usersOnline.Count-1 do begin
           listUsers[i].userID:=StrToInt(usersOnline[i]);
           // ������ ���
           listUsers[i].FIO:=GetUserNameFIO(listUsers[i].userID);
         end;
         m_count:=usersOnline.Count;
      end;

    finally
      m_mutex.Release;
    end;

  end;

   if usersOnline<>nil then FreeAndNil(usersOnline);
end;

 function TOnlineUsers.Count:integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=m_count;
  finally
    m_mutex.Release;
  end;
 end;

 procedure TOnlineUsers.Clear;
  var
   i:Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
   for i:=0 to cMAXUSERS-1 do begin
      listUsers[i].Clear;
   end;
   m_count:=0;
  finally
    m_mutex.Release;
  end;
 end;


 function TOnlineUsers.GetOnlineUsers_ID(i:Integer):integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.listUsers[i].userID
  finally
    m_mutex.Release;
  end;
 end;

  function TOnlineUsers.GetOnlineUsers_FIO(i:Integer):string;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.listUsers[i].FIO;
  finally
    m_mutex.Release;
  end;
 end;


end.
