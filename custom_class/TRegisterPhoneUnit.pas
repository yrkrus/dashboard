 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                        регистрация SIP телефона                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TRegisterPhoneUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, IdHTTP, IdSSL,
  IdIOHandlerStack, IdSSLOpenSSL, IdException, Data.Win.ADODB, Data.DB;


  type
   EnumRegStatus = (enumRegistration,
                    enumUnRegistration,
                    enumStatus);

 // class TRegisterPhone
  type
      TRegisterPhone = class

  const
  CustomHeaders0='Connection:Keep-alive';
  CustomUserAgent='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
  CustomHeaders2='Content-Type:application/x-www-form-urlencoded';
  CustomHeaders3='Accept-Charset:utf-8';
  CustomHeaders4='Accept:application/json, text/javascript, */*; q=0.01';

  cLoginDef = 'admin';
  cPwdDef   = '5000';

      private
      m_sip         :Integer;
      m_ipPhone     :string;
      m_authLogin   :string;
      m_authPwd     :string;

      function CreateRequest(_regStatus:EnumRegStatus; var _responce:string; var _errorDescription:string):Boolean; // отправка запроса
      function CheckRequest(const _responce:string; var _errorDescription:string):Boolean;  // проверка ответа
      function CheckStatus(_regStatus:EnumRegStatus; var _errorDescription:string):Boolean; // проверка статуса телефона
      function SendRequestToBase(_regStatus:EnumRegStatus; var _errorDescription:string):Boolean; // отправка инфы на базу

      public

      constructor Create(_sip:Integer; _ipPhone:string; _login:string; _pwd:string);        overload;
      constructor Create(_sip:Integer; _ipPhone:string);                                    overload;
      function RegisterPhone(var _errorDescription:string):Boolean;     // регистрация
      function DeRegisterPhone(var _errorDescription:string):Boolean;   // разрегистрация


      end;
 // class TRegisterPhone END

implementation

uses
  GlobalVariablesLinkDLL;



constructor TRegisterPhone.Create(_sip:Integer; _ipPhone:string; _login:string; _pwd:string);
begin
  m_sip:=_sip;
  m_ipPhone:=_ipPhone;
  m_authLogin:=_login;
  m_authPwd:=_pwd;
end;


constructor TRegisterPhone.Create(_sip:Integer; _ipPhone:string);
begin
  m_sip:=_sip;
  m_ipPhone:=_ipPhone;
  m_authLogin:=cLoginDef;
  m_authPwd:=cPwdDef;
end;


// регистрация
function TRegisterPhone.RegisterPhone(var _errorDescription:string):Boolean;
var
 responce:string;
begin
  _errorDescription:='';
  Result:=False;

  try
   if not CreateRequest(enumRegistration, responce, _errorDescription) then begin
     Exit;
   end;
  except
    on E:EIdException do begin
      _errorDescription:='Ошибка при отправке запроса по IP адресу '+m_ipPhone;
      Exit;
    end;
  end;

  if not CheckStatus(enumRegistration,_errorDescription) then begin
    Exit;
  end;

  // обновим в БД
  Result:=SendRequestToBase(enumRegistration,_errorDescription);
end;


// разрегистрация
function TRegisterPhone.DeRegisterPhone(var _errorDescription:string):Boolean;
var
 responce:string;
begin
  _errorDescription:='';
  Result:=False;

  try
   if not CreateRequest(enumUnRegistration, responce, _errorDescription) then begin
     Exit;
   end;
  except
    on E:EIdException do begin
      _errorDescription:='Ошибка при отправке запроса по IP адресу '+m_ipPhone;
      Exit;
    end;
  end;

  if not CheckStatus(enumUnRegistration,_errorDescription) then begin
    Exit;
  end;

  // обновим в БД
  Result:=SendRequestToBase(enumUnRegistration,_errorDescription);
end;


// отправка запроса
function TRegisterPhone.CreateRequest(_regStatus:EnumRegStatus; var _responce:string; var _errorDescription:string):Boolean;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet:string;
begin
   Result:=False;

   case _regStatus of
      enumRegistration:begin
        HTTPGet:='https://'+m_ipPhone+'/servlet?phonecfg=set[&account.1.enable=1][&account.1.label='+IntToStr(m_sip)+'][&account.1.display_name='+IntToStr(m_sip)+'][&account.1.auth_name='+IntToStr(m_sip)+'][&account.1.user_name='+IntToStr(m_sip)+'][&account.1.password=159753]';
      end;
      enumUnRegistration:begin
        HTTPGet:='https://'+m_ipPhone+'/servlet?phonecfg=set[&account.1.enable=0][&account.1.label=''][&account.1.display_name=''][&account.1.auth_name=''][&account.1.user_name=''][&account.1.password='']';
      end;
      enumStatus:begin
        HTTPGet:='https://'+m_ipPhone+'/servlet?phonecfg=get[&accounts=1]';
      end;
   end;

  http:=TIdHTTP.Create(nil);

  begin
   ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
   ssl.SSLOptions.Method:=sslvTLSv1_2;
   ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
  end;

  with http do begin
    IOHandler:=ssl;
    Request.CustomHeaders.Add(CustomHeaders0);
    Request.UserAgent:=CustomUserAgent;
    Request.CustomHeaders.Add(CustomHeaders2);
    Request.CustomHeaders.Add(CustomHeaders3);
    Request.CustomHeaders.Add(CustomHeaders4);
    Request.Username:=m_authLogin;
    Request.Password:=m_authPwd;
    Request.BasicAuthentication:=True;

     try
      ServerOtvet:=Get(HTTPGet);
     except on E:Exception do
        begin
         _errorDescription:=e.Message;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

  // проверим наш запрос
  if not CheckRequest(ServerOtvet, _errorDescription) then begin
    Exit;
  end;

  _responce:=ServerOtvet;

  Result:=True;
end;

// проверка ответа
function TRegisterPhone.CheckRequest(const _responce:string; var _errorDescription:string):Boolean;
begin
 _errorDescription:='';
 Result:=False;

  if (AnsiPos('Connection',_responce)<>0) or
      (AnsiPos('not found',_responce)<>0)
   then begin
    _errorDescription:='Не удается связаться с телефоном '+m_ipPhone+#13
                        +'проверьте подключение';

    Exit;
  end
  else if AnsiPos('Forbidden',_responce)<>0 then begin
    _errorDescription:='В телефоне '+m_ipPhone+' выключен удаленный доступ';

    Exit;
  end;


  Result:=True;
end;

// проверка статуса телефона
function TRegisterPhone.CheckStatus(_regStatus:EnumRegStatus; var _errorDescription:string):Boolean;
var
 response:string;
begin
  Result:=False;

  if not CreateRequest(enumStatus, response, _errorDescription) then begin
    Exit;
  end;

  case _regStatus of
    enumRegistration:begin
       if AnsiPos('Enabled',response)<>0 then begin
          Result:=True; // все ок успешная регистрация
       end
       else begin
         _errorDescription:='Не удалось зарегистрироваться по адресу '+m_ipPhone+#13#13
                             +'Response:'+#13
                             +response;
       end;

      Exit;
    end;
    enumUnRegistration:begin
        if AnsiPos('Disabled',response)<>0 then begin
          Result:=True; // все ок успешная разрегистрация
        end
        else begin
          _errorDescription:='Не удалось разрегистироваться по адресу '+m_ipPhone+#13#13
                             +'Response:'+#13
                             +response;

        end;
      Exit
    end;
  end;
end;


// отправка инфы на базу
function TRegisterPhone.SendRequestToBase(_regStatus:EnumRegStatus; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
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

      request:=TStringBuilder.Create;

      with request do begin
        Clear;
        Append('update settings_sip_phone set sip = ');

        case _regStatus of
         enumRegistration:begin
            Append(#39+IntToStr(m_sip)+#39);
         end;
         enumUnRegistration:begin
            Append(#39+IntToStr(-1)+#39);
         end;
        end;

        Append(' where phone_ip = '+#39+m_ipPhone+#39);
      end;

      SQL.Add(request.ToString);
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