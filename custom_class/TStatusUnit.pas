 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            Класс для описания смены статусов у оператора                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TStatusUnit;

interface

uses
  System.Classes, System.SysUtils, Data.Win.ADODB,
  Data.DB, System.Variants, Forms, GlobalVariablesLinkDLL,
  IdException, TCustomTypeUnit, TUserUnit;


 // class TStatusUnit
  type
    TStatus = class
  private
    m_userID:Integer;
    m_user:TUserData;
    m_waitInfo:Boolean;   // флаг отображаения окна подождите или нет


    function IsExistCommand(_command:enumLogging; var _errorDescriptions:string):Boolean;       // есть ли уже такая команда на сервере
    function AddCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; var _errorDescriptions:string):Boolean; // добавление команды в БД для дальнейшей обработки на стороне core
    function Responce(InStroka:string; var _errorDescriptions:string):boolean;     // отправка запроса на добавление удаленной команды
    function IsFail(_command:enumLogging):boolean;
    function GetFailStr(var _errorDescriptions:string):string;                    // получение строки с ошибкой при выполнении удаленной команды


  public
   procedure SetUserID(_userID:integer);
   procedure SetUser(_user:TUserData);
   function SendCommand(_command:enumLogging;
                        _delay:enumStatus;
                        _paused:Boolean;
                        var _errorDescriptions:string):Boolean;  // отправка команды



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

function TStatus.SendCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; var _errorDescriptions:string):Boolean;  // отправка команды
begin
  _errorDescriptions:='';

  // проверяем есть ли уже такая ранее команда
  if IsExistCommand(_command, _errorDescriptions) then begin
    _errorDescriptions:='Команда "'+EnumLoggingToString(_command)+'" еще не обработана';
    Result:=False;
    Exit;
  end;

  Result:=AddCommand(_command, _delay, _paused, _errorDescriptions);
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


function TStatus.AddCommand(_command:enumLogging; _delay:enumStatus; _paused:Boolean; var _errorDescriptions:string):Boolean;
var
 resultat:string;
 soLongWait:UInt16;
 request:TStringBuilder;
 paused:string;
begin
   Result:=False;
  _errorDescriptions:='';

  soLongWait:=0;
  if m_waitInfo then ShowWait(show_open);

  request:=TStringBuilder.Create;
  paused:=IntToStr(BooleanToInteger(_paused));

  with request do begin
    Clear;
    Append('insert into remote_commands');
    case _delay of
     eNO:  Append(' (sip,command,ip,user_id,user_login_pc,pc,pause)');
     eYES: Append(' (sip,command,ip,user_id,user_login_pc,pc,pause,delay)');
    end;
    Append(' values (');
    Append(#39+IntToStr(_dll_GetOperatorSIP(m_userID)) +#39+',' +#39+IntToStr(EnumLoggingToInteger(_command))+#39);
    Append(','+#39+m_user.m_ip+#39+','+#39+IntToStr(m_user.m_id)+#39);
    Append(',' +#39+m_user.m_user_login_pc+#39+','+#39+m_user.m_pc+#39);
    Append(',' +#39+paused+#39);

    if _delay = eYES then begin
     Append(','+#39+IntToStr(EnumStatusToInteger(_delay))+#39);
    end;

    Append(')');
  end;

  // выполняем запрос
  if not Responce(request.ToString,_errorDescriptions) then begin

    if m_waitInfo then ShowWait(show_close);
    if Assigned(request) then FreeAndNil(request);
    Exit;
  end;

  // отлеженная команда сразу выходим
  if _delay = eYES then begin
    Result:=True;
    if m_waitInfo then ShowWait(show_close);
    if Assigned(request) then FreeAndNil(request);

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

    with request do begin
      Clear;
      Append('delete from remote_commands');
      Append(' where sip ='+#39+IntToStr(_dll_GetOperatorSIP(m_userID))+#39);
      Append(' and command ='+#39+IntToStr(EnumLoggingToInteger(_command))+#39);
    end;

    if not Responce(request.ToString,_errorDescriptions) then begin

      if m_waitInfo then ShowWait(show_close);
      if Assigned(request) then FreeAndNil(request);
      Exit;
    end;

     if m_waitInfo then ShowWait(show_close);

    _errorDescriptions:='Сервер не смог обработать команду'+#13#13+'Причина: '+resultat;
    if Assigned(request) then FreeAndNil(request);
    Exit;

   end else begin
    Inc(soLongWait);
   end;
  end;

  if m_waitInfo then ShowWait(show_close);
  if Assigned(request) then FreeAndNil(request);

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
               _errorDescriptions:='Внутренняя ошибка сервера'+#13#13+e.ClassName+': '+e.Message;
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
  Result:='Таймаут запроса';

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