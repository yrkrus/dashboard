unit TPhoneListUnit;

interface

uses
  System.Classes, System.SysUtils, Data.Win.ADODB, Data.DB, System.Variants,
  GlobalVariablesLinkDLL, TCustomTypeUnit, IdException;

  const
      _PHONE_NO_DATA:Boolean = True;

 // class TPhone
  type
      TPhone = class

      public
      m_id      :Integer;  // id по БД
      m_sip     :Integer;  // sip зарегистрированный
      m_phoneIP :string;   // ip телефона
      m_namePC  :string;   // имя пк на котром тлф стоит

      constructor Create;               overload;
      procedure Clear;


      end;
 // class TPhone END

 //////////////////////////////////////////
 // class TPhoneList
  type
      TPhoneList = class

      private
      m_count:Integer;
      m_list: TArray<TPhone>;

      procedure LoadData;
      function GetItems(_id:Integer):TPhone;
      function GetItemsData(_id_base:Integer):TPhone;
      function CheckExist(_namepc, _ipphone:string; var _errorDescription:string):Boolean;  // чекалка проверки есть ли уже данные
      function IsExistPCName(_namepc:string; var _errorDescription:string):Boolean;
      function IsExistIpPhone(_ipphone:string; var _errorDescription:string):Boolean;
      function GetIPPhoneWithNamePC(_namePC:string):string;  // получение ip адрес из имени пк
      function GetIPPhoneWithSip(_sip:Integer):string;        // получение ip адрес из sip
      function GetRegisterdSip(_sip:Integer):Boolean;

      public
      constructor Create;                   overload;
      constructor Create(_noData:Boolean);  overload;

      procedure Clear;
      procedure UpdateData;                  // обновление данных
      function Insert(_namepc, _ipphone:string; var _errorDescription:string):Boolean;  // добавление нового
      function Update(_id:Integer; _namepc, _ipphone:string; var _errorDescription:string):Boolean;  // редактирование
      function Delete(_id:Integer; var _errorDescription:string):Boolean;  // удаление


      property Count:Integer read m_count;
      property Items[_id:Integer]:TPhone read GetItems; default;
      property ItemsData[_id_base:Integer]:TPhone read GetItemsData;  // получение данных по id которое из БД
      property IPPhoneWithNamePC[_namePC:string]:string read GetIPPhoneWithNamePC;  // получение ip адрес из имени пк
      property IPPhoneWithSip[_sip:Integer]:string read GetIPPhoneWithSip;          // получение ip адрес из имени пк
      property IsRegisterdSip[_sip:Integer]:Boolean read GetRegisterdSip;           // зарегестировани ли sip номер на телеыоне


      end;
 // class TSipPhoneList END

implementation


constructor TPhone.Create;
begin
  Clear;
end;


procedure TPhone.Clear;
begin
   m_id      :=-1;
   m_sip     :=-1;
   m_phoneIP :='0.0.0.0';
   m_namePC  :='';
end;


constructor TPhoneList.Create;
begin
  inherited;
  m_count:=0;
  // заполняем данными
  LoadData;
end;

constructor TPhoneList.Create(_noData:Boolean);
begin
  m_count:=0;

  // заполняем данными
  if not _noData then LoadData;
end;



// заполнение данными
procedure TPhoneList.LoadData;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
 dataCount:Integer;
 i:Integer;
begin

 ado:=TADOQuery.Create(nil);
  try
      serverConnect:=createServerConnect;
 except
    on E:Exception do begin
      if not Assigned(serverConnect) then begin
         FreeAndNil(ado);
         Exit;
      end;
    end;
 end;

 try
  with ado do begin
    ado.Connection:=serverConnect;

    request:=TStringBuilder.Create;
    with request do begin
      Clear;
      Append('select count(id) ');
      Append('from settings_sip_phone');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;
    if Fields[0].Value = 0 then Exit;

    dataCount:=StrToInt(VarToStr(Fields[0].Value));

    with request do begin
      Clear;
      Append('select id,sip,phone_ip,pc_name');
      Append(' from settings_sip_phone');
      Append(' order by pc_name ASC');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);
    Active:=True;

    // выделяем память под массив
    m_count:=dataCount;
    SetLength(m_list,m_count);
    for i:=0 to dataCount-1 do m_list[i]:=TPhone.Create;

    for i:=0 to dataCount-1 do begin
      m_list[i].m_id      :=StrToInt(VarToStr(Fields[0].Value));
      m_list[i].m_sip     :=StrToInt(VarToStr(Fields[1].Value));
      m_list[i].m_phoneIP :=VarToStr(Fields[2].Value);
      m_list[i].m_namePC  :=VarToStr(Fields[3].Value);

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


function TPhoneList.GetItems(_id:Integer):TPhone;
begin
  Result:=m_list[_id];
end;

function TPhoneList.GetItemsData(_id_base:Integer):TPhone;
var
 i:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_id = _id_base then begin
      Result:=m_list[i];
      Break;
    end;
  end;
end;


procedure TPhoneList.Clear;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
   m_list[i].Clear;
   m_list[i].Free;
   m_list[i]:= nil;
  end;

  SetLength(m_list,0);
  m_count:=0;
end;

// обновление данных
procedure TPhoneList.UpdateData;
begin
  Clear;
  LoadData;
end;

// чекалка проверки есть ли уже данные
function TPhoneList.CheckExist(_namepc, _ipphone :string; var _errorDescription:string):Boolean;
begin
  Result:=False;

  if IsExistPCName(_namepc, _errorDescription) then Exit;
  if IsExistIpPhone(_ipphone, _errorDescription) then Exit;

  Result:=True;
end;


function TPhoneList.IsExistPCName(_namepc:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
   Result:=True; // по умолчанию считаем что есть такие данные
   _errorDescription:='';

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnectWithError(_errorDescription);
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
        Append('select count(pc_name) ');
        Append('from settings_sip_phone ');
        Append('where pc_name = '+#39+_namepc+#39);
      end;

      SQL.Clear;
      SQL.Add(request.ToString);

      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 0 then Result:=False
      else begin
        _errorDescription:='Имя ПК "'+_namepc+'" было добавлено ранее';
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

function TPhoneList.IsExistIpPhone(_ipphone:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
   Result:=True; // по умолчанию считаем что есть такие данные
   _errorDescription:='';

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnectWithError(_errorDescription);
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
        Append('select count(phone_ip) ');
        Append('from settings_sip_phone ');
        Append('where phone_ip = '+#39+_ipphone+#39);
      end;

      SQL.Clear;
      SQL.Add(request.ToString);

      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 0 then Result:=False
      else begin
        _errorDescription:='IP телефона "'+_ipphone+'" был добавлен ранее';
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


// получение ip адрес из имени пк
function TPhoneList.GetIPPhoneWithNamePC(_namePC:string):string;
var
 i:Integer;
begin
   for i:=0 to m_count-1 do begin
     if m_list[i].m_namePC = _namePC then begin
       Result:=m_list[i].m_phoneIP;
       Exit;
     end;
   end;
end;


// получение ip адрес из sip
function TPhoneList.GetIPPhoneWithSip(_sip:Integer):string;
var
 i:Integer;
begin
   for i:=0 to m_count-1 do begin
     if m_list[i].m_sip = _sip then begin
       Result:=m_list[i].m_phoneIP;
       Exit;
     end;
   end;
end;


function TPhoneList.GetRegisterdSip(_sip:Integer):Boolean;
var
 i:Integer;
begin
   Result:=False;

   for i:=0 to m_count-1 do begin
     if m_list[i].m_sip = _sip then begin
       Result:=True;
       Exit;
     end;
   end;
end;


// добавление нового
function TPhoneList.Insert(_namepc, _ipphone:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

  if not CheckExist(_namepc, _ipphone, _errorDescription) then begin
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
      SQL.Add('insert into settings_sip_phone (phone_ip,pc_name) values ('+#39+_ipphone+#39
                                                                                +','+#39+_namepc+#39+')');

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


// редактирование
function TPhoneList.Update(_id:Integer; _namepc, _ipphone:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

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
      SQL.Add('update settings_sip_phone set phone_ip = '+#39+_ipphone+#39+
                                             ',pc_name = '+#39+_namepc+#39+
                                             ' where id = '+#39+IntToStr(_id)+#39);

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

 // удаление
function TPhoneList.Delete(_id:Integer; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

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
      SQL.Add('delete from settings_sip_phone where id = '+#39+IntToStr(_id)+#39);

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