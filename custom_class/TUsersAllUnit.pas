/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   ласс дл€ описани€ всех пользователей в Ѕƒ               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TUsersAllUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException, TUserUnit,
      TCustomTypeUnit;



/////////////////////////////////////////////////////////////////////////////////////////
 // class TUsersAll
 type
      TUsersAll = class
      private
      m_role    :enumRole;      // права доступа под которыми запускаетс€ класс

      m_count   :Integer;
      m_list    :TArray<TUser>;


      procedure LoadAllUsers;                       // прогрузка всех пользователей которые есть в Ѕƒ
      function GetOnlyOperatorsRoleID:TStringList;  // получение только операторские ID роли


      public
      constructor Create(_role:enumRole);   overload;
      destructor Destroy;                   override;

      procedure Update;

      property Count:Integer read m_count;

      end;
   // class TUsersAll END


implementation

uses
  GlobalVariablesLinkDLL;




constructor TUsersAll.Create(_role:enumRole);
begin
  m_count:=0;
  m_role:=_role;

  // прогружаем всех пользователей
  LoadAllUsers;
end;

destructor TUsersAll.Destroy;
begin
  FreeAndNil(m_list);
  inherited;
end;


// получение только операторские ID роли
function TUsersAll.GetOnlyOperatorsRoleID:TStringList;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countID:Cardinal;
begin
  Result:=TStringList.Create;

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
      SQL.Add('select count(id) from role where id <> ''-1'' and only_operators = ''1'' ');

      Active:=True;
      countID:= Fields[0].Value;

      if countID<>0 then begin

        SQL.Clear;
        SQL.Add('select id from role where id <> ''-1'' and only_operators = ''1'' ');

        Active:=True;
        for i:=0 to countID-1 do begin
           Result.Add(VarToStr(Fields[0].Value));
           ado.Next;
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
end;

procedure TUsersAll.LoadAllUsers;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 request:TStringBuilder;
 only_operators_roleID:TStringList;
 id_operators:string;
 user_id:Integer;
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

        if m_role = role_administrator then begin
          Append('select count(id) from users');  // показываем все даже заблоченных
        end
        else begin
          only_operators_roleID:=GetOnlyOperatorsRoleID;
          for i:=0 to only_operators_roleID.Count-1 do begin
            if id_operators='' then id_operators:=#39+only_operators_roleID[i]+#39
            else id_operators:=id_operators+','#39+only_operators_roleID[i]+#39;
          end;

          Append('select count(id) from users where disabled =''0'' and role IN('+id_operators+')');

          if Assigned(only_operators_roleID) then FreeAndNil(only_operators_roleID);
        end;

        SQL.Add(request.ToString);
        Active:=True;

        countUsers:= StrToInt(VarToStr(Fields[0].Value));
      end;
    end;

    if countUsers=0 then Exit;


    with ado do begin
      SQL.Clear;

     with request do begin
      Clear;

      if m_role = role_administrator then begin
        Append('select id from users order by familiya ASC');
      end
      else begin
        Append('select id from users where disabled = ''0'' and role IN('+id_operators+') order by familiya ASC');
      end;
     end;

     SQL.Add(request.ToString);
     Active:=True;

     // выдел€им пам€ть
     m_count:=countUsers;
     SetLength(m_list, m_count);
     for i:=0 to m_count-1 do begin
       user_id:=StrToInt(VarToStr(Fields[0].Value));
       m_list[i]:=TUser.Create(user_id);

       ado.Next;
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

procedure TUsersAll.Update;
begin

end;



end.

