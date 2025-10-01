 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                Список SIP номеров доступных в программе                   ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TSipPhoneListUnit;

interface

uses
  System.Classes, System.SysUtils, Data.Win.ADODB, Data.DB, System.Variants,
  GlobalVariablesLinkDLL, TCustomTypeUnit, IdException;

  const
      _SIP_PHONE_NO_DATA:Boolean = True;

 // class TSipList
  type
      TSipList = class

      public
      m_id      :Integer;  // id по БД
      m_sip     :Integer;  // sip
      m_userId  :Integer;  // за кем закреплен
      m_fio     :string;  // ФИО

      constructor Create;               overload;
      procedure Clear;


      end;
 // class TSipList END

 //////////////////////////////////////////
 // class TSipPhoneList
  type
      TSipPhoneList = class

      private
      m_count:Integer;
      m_list: TArray<TSipList>;

      procedure LoadData;
      function GetItems(_id:Integer):TSipList;
      function IsExistSip(_sip:string):Boolean; // есть ли уже такой sip в БД
      function IsActiveSip(_sip:string; var _fioOperator:string):Boolean; // проверка что sip не используется у оператора никакого

      public
      constructor Create;                   overload;
      constructor Create(_noData:Boolean);  overload;

      procedure Clear;
      procedure UpdateData;                  // обновление данных
      function Add(_sip:string; var _errorDescription:string):Boolean;  // доьавление нового sip
      function Delete(_sip:string; var _errorDescription:string):Boolean; // удаление sip


      property Count:Integer read m_count;
      property Items[_id:Integer]:TSipList read GetItems; default;

      end;
 // class TSipPhoneList END

implementation


constructor TSipList.Create;
begin
  Clear;
end;


procedure TSipList.Clear;
begin
 m_id     :=0;
 m_sip    :=-1;
 m_userId :=-1;
 m_fio    :='';
end;


constructor TSipPhoneList.Create;
begin
  inherited;

  m_count:=0;

  // заполняем данными
  LoadData;
end;

constructor TSipPhoneList.Create(_noData:Boolean);
begin
  m_count:=0;

   // заполняем данными
  if not _noData then LoadData;
end;



// заполнение данными
procedure TSipPhoneList.LoadData;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
 dataCount:Integer;
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

    request:=TStringBuilder.Create;
    with request do begin
      Clear;
      Append('select count(id) ');
      Append('from settings_sip');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;
    if Fields[0].Value = 0 then Exit;

    dataCount:=StrToInt(VarToStr(Fields[0].Value));

    with request do begin
      Clear;
      Append('select id,sip,user_id ');
      Append('from settings_sip ');
      Append('order by sip ASC');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);
    Active:=True;

    // выделяем память под массив
    m_count:=dataCount;
    SetLength(m_list,m_count);
    for i:=0 to dataCount-1 do m_list[i]:=TSipList.Create;

    for i:=0 to dataCount-1 do begin
      m_list[i].m_id      :=StrToInt(VarToStr(Fields[0].Value));
      m_list[i].m_sip     :=StrToInt(VarToStr(Fields[1].Value));
      m_list[i].m_userId  :=StrToInt(VarToStr(Fields[2].Value));

      // ФИО
      if m_list[i].m_userId <> -1 then m_list[i].m_fio:=GetUserNameFIO(m_list[i].m_userId);

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


function TSipPhoneList.GetItems(_id:Integer):TSipList;
begin
  Result:=m_list[_id];
end;

// есть ли уже такой sip в БД
function TSipPhoneList.IsExistSip(_sip:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
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

    request:=TStringBuilder.Create;
    with request do begin
      Clear;
      Append('select count(id) ');
      Append('from settings_sip ');
      Append('where sip = '+#39+_sip+#39);
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;
    if Fields[0].Value <> 0 then Result:=True;
  end;
 finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
 end;
end;

// проверка что sip не используется у оператора никакого
function TSipPhoneList.IsActiveSip(_sip:string; var _fioOperator:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=False;
 _fioOperator:='';

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
      Append('select user_id ');
      Append('from settings_sip ');
      Append('where sip = '+#39+_sip+#39);
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;
    if VarToStr(Fields[0].Value) <> '-1' then
    begin
      _fioOperator:=GetUserNameFIO(StrToInt(VarToStr(Fields[0].Value)));
     Result:=True;
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



procedure TSipPhoneList.Clear;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do m_list[i].Clear;

  SetLength(m_list,0);
  m_count:=0;
end;

// обновление данных
procedure TSipPhoneList.UpdateData;
begin
  Clear;
  LoadData;
end;


function TSipPhoneList.Add(_sip:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
   _errorDescription:='';

  if IsExistSip(_sip) then begin
    _errorDescription:='SIP '+_sip+' ранее был уже добавлен';
    Exit;
  end;

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
      SQL.Add('insert into settings_sip (sip) values ('+#39+_sip+#39')');

      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:=e.Message;
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


// удаление sip
function TSipPhoneList.Delete(_sip:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 fioOperator:string;
begin
  Result:=False;
   _errorDescription:='';

  if IsActiveSip(_sip,fioOperator) then begin
    _errorDescription:='SIP '+_sip+' нельзя удалить, т.к. он используется оператором '+fioOperator;
    Exit;
  end;

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
      SQL.Add('delete from settings_sip where sip ='+#39+_sip+#39);
      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:=e.Message;
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


end.