 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             ласс дл€ описани€ смены статусов у оператора                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TStatusUnit;

interface

uses
  System.Classes, System.SysUtils, Data.Win.ADODB,
  Data.DB, System.Variants, Forms, GlobalVariablesLinkDLL,
  IdException,
  TCustomTypeUnit, TUserUnit;


 // class TStatusUnit
  type
    TStatus = class
  private
    m_userID:Integer;
    m_user:TUserData;
    m_waitInfo:Boolean;   // флаг отображаени€ окна подождите или нет


    function IsExistCommand(_command:enumLogging; var _errorDescriptions:string):Boolean;       // есть ли уже така€ команда на сервере
    function AddCommand(_command:enumLogging; _delay:enumStatus; var _errorDescriptions:string):Boolean; // добавление команды в Ѕƒ дл€ дальнейшей обработки на стороне core
    function Responce(InStroka:string; var _errorDescriptions:string):boolean;     // отправка запроса на добавление удаленной команды
    function IsFail(_command:enumLogging):boolean;
    function GetFailStr(var _errorDescriptions:string):string;                    // получение строки с ошибкой при выполнении удаленной команды


  public
   procedure SetUserID(_userID:integer);
   procedure SetUser(_user:TUserData);
   function SendCommand(_command:enumLogging; _delay:enumStatus; var _errorDescriptions:string):Boolean;  // отправка команды



  constructor Create(_waitInfo:Boolean);      overload;
  constructor Create(_userID:Integer; _user:TUserData; _waitInfo:Boolean);      overload;

  end;
 // class TStatus END

implementation

uses
  FunctionUnit;



// class TStatus START
// ===============================================
 constructor TStatus.Create(_waitInfo:Boolean);
 begin
   //inherited;
   m_waitInfo:=_waitInfo;

 end;

  constructor TStatus.Create(_userID:Integer; _user:TUserData; _waitInfo:Boolean);
 begin
   //inherited;
   m_userID:=_userID;
   m_user:=_user;
   m_waitInfo:=_waitInfo;
 end;


procedure TStatus.SetUserID(_userID:integer);
begin
  m_userID:=_userID;
end;

procedure TStatus.SetUser(_user:TUserData);
begin
  m_user:=TUserData.Create;
  m_user.Clone(_user);
end;

function TStatus.SendCommand(_command:enumLogging; _delay:enumStatus; var _errorDescriptions:string):Boolean;  // отправка команды
begin
  _errorDescriptions:='';

  // провер€ем есть ли уже така€ ранее команда
  if IsExistCommand(_command, _errorDescriptions) then begin
    _errorDescriptions:=' оманда "'+EnumLoggingToString(_command)+'" еще не обработана';
    Result:=False;
    Exit;
  end;

  Result:=AddCommand(_command, _delay, _errorDescriptions);
end;


function TStatus.IsExistCommand(_command:enumLogging; var _errorDescriptions:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     _errorDescriptions:=error;
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(id) from remote_commands where command = '+#39+inttostr(EnumLoggingToInteger(_command)) +#39+' and user_id = '+#39+IntToStr(m_userID)+#39);
      Active:=True;

      if Fields[0].Value<>null then begin
        if Fields[0].Value <> 0 then Result:=True
        else Result:=False;
      end
      else Result:= True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


function TStatus.AddCommand(_command:enumLogging; _delay:enumStatus; var _errorDescriptions:string):Boolean;
var
 resultat:string;
 response:string;
 soLongWait:UInt16;
begin
   Result:=False;
  _errorDescriptions:='';

  soLongWait:=0;
  if m_waitInfo then showWait(show_open);


  if _delay = eNO then begin
    response:='insert into remote_commands (sip,command,ip,user_id,user_login_pc,pc) values ('+#39+getUserSIP(m_userID) +#39+','
                                                                                            +#39+IntToStr(EnumLoggingToInteger(_command))+#39+','
                                                                                            +#39+m_user.m_ip+#39+','
                                                                                            +#39+IntToStr(m_user.m_id)+#39+','
                                                                                            +#39+m_user.m_user_login_pc+#39+','
                                                                                            +#39+m_user.m_pc+#39+')';

  end
  else begin
    response:='insert into remote_commands (sip,command,ip,user_id,user_login_pc,pc,delay) values ('+#39+getUserSIP(m_userID) +#39+','
                                                                                            +#39+IntToStr(EnumLoggingToInteger(_command))+#39+','
                                                                                            +#39+m_user.m_ip+#39+','
                                                                                            +#39+IntToStr(m_user.m_id)+#39+','
                                                                                            +#39+m_user.m_user_login_pc+#39+','
                                                                                            +#39+m_user.m_pc+#39+','
                                                                                            +#39+IntToStr(EnumStatusToInteger(_delay))+#39+')';
  end;


  // выполн€ем запрос
  if not Responce(response,_errorDescriptions) then begin

    if m_waitInfo then showWait(show_close);
    Exit;
  end;

  // отлеженна€ команда сразу выходим
  if _delay = eYES then begin
    Result:=True;
    if m_waitInfo then showWait(show_close);

    Exit;
  end;

  // ждем пока отработает на core
  while (IsExistCommand(_command,_errorDescriptions)) do begin
   Sleep(100);
   Application.ProcessMessages;

   // есть ли ошибка по удаленной команде
   if IsFail(_command) then soLongWait:=100;

   if soLongWait>50 then begin

    // получим строку с ошибкой
    resultat:=GetFailStr(_errorDescriptions);


    // пробуем удалить команду
       response:='delete from remote_commands where sip ='+#39+getUserSIP(m_userID)+#39+
                                                         ' and command ='+#39+IntToStr(EnumLoggingToInteger(_command))+#39;

    if not Responce(response,_errorDescriptions) then begin

      if m_waitInfo then showWait(show_close);

      Exit;
    end;

     if m_waitInfo then showWait(show_close);

    _errorDescriptions:='—ервер не смог обработать команду'+#13#13+'ѕричина: '+resultat;
    Exit;

   end else begin
    Inc(soLongWait);
   end;
  end;

  if m_waitInfo then showWait(show_close);

  Result:=True;
end;



// отправка запроса на добавление удаленной команды
function TStatus.Responce(InStroka:string; var _errorDescriptions:string):boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  _errorDescriptions:='';
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescriptions);

  if not Assigned(serverConnect) then begin
     Result:=False;
     FreeAndNil(ado);
     Exit;
  end;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(InStroka);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               Result:=False;

               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;
               _errorDescriptions:='¬нутренн€€ ошибка сервера'+#13#13+e.ClassName+': '+e.Message;
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


function TStatus.IsFail(_command:enumLogging):boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select error from remote_commands where command = '+#39+inttostr(EnumLoggingToInteger(_command)) +#39+' and user_id = '+#39+IntToStr(m_userID)+#39);
      Active:=True;

      if Fields[0].Value<>null then begin
        if VarToStr(Fields[0].Value) = '1' then Result:=True
        else Result:=False;
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


// получение строки с ошибкой при выполнении удаленной команды
function TStatus.GetFailStr(var _errorDescriptions:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:='“аймаут запроса';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);
  if not Assigned(serverConnect) then begin
     _errorDescriptions:=error;
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select error_str from remote_commands where error = ''1'' and user_id = '+#39+IntToStr(m_userID)+#39);

      Active:=True;

      if ((Fields[0].Value<>null) and (VarToStr(Fields[0].Value) <> '')) then Result:=VarToStr(Fields[0].Value);

    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// class TStatus END
// ===============================================
end.