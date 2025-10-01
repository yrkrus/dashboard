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
      m_id      :Integer;  // id по Ѕƒ
      m_sip     :Integer;  // sip зарегистрированный
      m_phoneIP :string;   // ip телефона
      m_pcIP    :string;   // ip пк
      m_namePC  :string;   // им€ пк на котром тлф стоит

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
      function CheckExist(_namepc, _ipphone, _ippc :string; var _errorDescription:string):Boolean;  // чекалка проверки есть ли уже данные
      function IsExistPCName(_namepc:string; var _errorDescription:string):Boolean;
      function IsExistIpPhone(_ipphone:string; var _errorDescription:string):Boolean;
      function IsExistIpPc(_ippc:string; var _errorDescription:string):Boolean;

      public
      constructor Create;                   overload;
      constructor Create(_noData:Boolean);  overload;

      procedure Clear;
      procedure UpdateData;                  // обновление данных
      function Insert(_namepc, _ipphone, _ippc :string; var _errorDescription:string):Boolean;  // добавление нового
//      function Delete(_sip:string; var _errorDescription:string):Boolean; // удаление sip


      property Count:Integer read m_count;
      property Items[_id:Integer]:TPhone read GetItems; default;

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
   m_pcIP    :='0.0.0.0';
   m_namePC  :='';
end;


constructor TPhoneList.Create;
begin
  inherited;
  m_count:=0;
  // заполн€ем данными
  LoadData;
end;

constructor TPhoneList.Create(_noData:Boolean);
begin
  m_count:=0;

  // заполн€ем данными
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
      Append('from settings_sip_phone');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);

    Active:=True;
    if Fields[0].Value = 0 then Exit;

    dataCount:=StrToInt(VarToStr(Fields[0].Value));

    with request do begin
      Clear;
      Append('select id,sip,phone_ip,pc_name,pc_ip');
      Append(' from settings_sip_phone');
      Append(' order by pc_name ASC');
    end;

    SQL.Clear;
    SQL.Add(request.ToString);
    Active:=True;

    // выдел€ем пам€ть под массив
    m_count:=dataCount;
    SetLength(m_list,m_count);
    for i:=0 to dataCount-1 do m_list[i]:=TPhone.Create;

    for i:=0 to dataCount-1 do begin
      m_list[i].m_id      :=StrToInt(VarToStr(Fields[0].Value));
      m_list[i].m_sip     :=StrToInt(VarToStr(Fields[1].Value));
      m_list[i].m_phoneIP :=VarToStr(Fields[2].Value);
      m_list[i].m_namePC  :=VarToStr(Fields[3].Value);
      m_list[i].m_pcIP    :=VarToStr(Fields[4].Value);

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


function TPhoneList.GetItems(_id:Integer):TPhone;
begin
  Result:=m_list[_id];
end;

//// есть ли уже такой sip в Ѕƒ
//function TSipPhoneList.IsExistSip(_sip:string):Boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// request:TStringBuilder;
//begin
// Result:=False;
//
// ado:=TADOQuery.Create(nil);
// serverConnect:=createServerConnect;
// if not Assigned(serverConnect) then begin
//   FreeAndNil(ado);
//   Exit;
// end;
//
// try
//  with ado do begin
//    ado.Connection:=serverConnect;
//
//    request:=TStringBuilder.Create;
//    with request do begin
//      Clear;
//      Append('select count(id) ');
//      Append('from settings_sip ');
//      Append('where sip = '+#39+_sip+#39);
//    end;
//
//    SQL.Clear;
//    SQL.Add(request.ToString);
//
//    Active:=True;
//    if Fields[0].Value <> 0 then Result:=True;
//  end;
// finally
//   FreeAndNil(ado);
//   if Assigned(serverConnect) then begin
//     serverConnect.Close;
//     FreeAndNil(serverConnect);
//   end;
// end;
//end;
//
//// проверка что sip не используетс€ у оператора никакого
//function TSipPhoneList.IsActiveSip(_sip:string; var _fioOperator:string):Boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// request:TStringBuilder;
//begin
// Result:=False;
// _fioOperator:='';
//



procedure TPhoneList.Clear;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do m_list[i].Clear;

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
function TPhoneList.CheckExist(_namepc, _ipphone, _ippc :string; var _errorDescription:string):Boolean;
begin
  Result:=False;

  if IsExistPCName(_namepc, _errorDescription) then Exit;
  if IsExistIpPhone(_ipphone, _errorDescription) then Exit;
  if IsExistIpPc(_ippc, _errorDescription) then Exit;

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
        _errorDescription:='»м€ ѕ  "'+_namepc+'" было добавлено ранее';
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
     end;
   end;
end;

function TPhoneList.IsExistIpPc(_ippc:string; var _errorDescription:string):Boolean;
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
        Append('select count(pc_ip) ');
        Append('from settings_sip_phone ');
        Append('where pc_ip = '+#39+_ippc+#39);
      end;

      SQL.Clear;
      SQL.Add(request.ToString);

      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 0 then Result:=False
      else begin
        _errorDescription:='IP ѕ  "'+_ippc+'" был добавлен ранее';
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


// добавление нового
function TPhoneList.Insert(_namepc, _ipphone, _ippc :string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

  if not CheckExist(_namepc, _ipphone, _ippc, _errorDescription) then begin
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
      SQL.Add('insert into settings_sip_phone (phone_ip,pc_name,pc_ip) values ('+#39+_ipphone+#39
                                                                                +','+#39+_namepc+#39
                                                                                +','+#39+_ippc+#39+')');

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

//
//function TSipPhoneList.Add(_sip:string; var _errorDescription:string):Boolean;

//begin
//  Result:=False;
//   _errorDescription:='';
//

//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(_errorDescription);
//  if not Assigned(serverConnect) then begin
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//      SQL.Clear;
//      SQL.Add('insert into settings_sip (sip) values ('+#39+_sip+#39')');
//
//      try
//          ExecSQL;
//      except
//          on E:EIdException do begin
//             _errorDescription:=e.Message;
//             FreeAndNil(ado);
//             if Assigned(serverConnect) then begin
//               serverConnect.Close;
//               FreeAndNil(serverConnect);
//             end;
//             Exit;
//          end;
//      end;
//
//    end;
//  finally
//   FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//
//  Result:=True;
//end;
//
//
//// удаление sip
//function TSipPhoneList.Delete(_sip:string; var _errorDescription:string):Boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// fioOperator:string;
//begin
//  Result:=False;
//   _errorDescription:='';
//
//  if IsActiveSip(_sip,fioOperator) then begin
//    _errorDescription:='SIP '+_sip+' нельз€ удалить, т.к. он используетс€ оператором '+fioOperator;
//    Exit;
//  end;
//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(_errorDescription);
//  if not Assigned(serverConnect) then begin
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//      SQL.Clear;
//      SQL.Add('delete from settings_sip where sip ='+#39+_sip+#39);
//      try
//          ExecSQL;
//      except
//          on E:EIdException do begin
//             _errorDescription:=e.Message;
//             FreeAndNil(ado);
//             if Assigned(serverConnect) then begin
//               serverConnect.Close;
//               FreeAndNil(serverConnect);
//             end;
//             Exit;
//          end;
//      end;
//    end;
//  finally
//   FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//
//  Result:=True;
//end;


end.