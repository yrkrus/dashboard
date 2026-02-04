/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   Класс для описания CallbackCall                         ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TCallbackCallUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
      Graphics, System.SyncObjs, IdException,  GlobalVariablesLinkDLL, TCustomTypeUnit,
      System.Generics.Collections,TThreadDispatcherUnit;


/////////////////////////////////////////////////////////////////////////////////////////

  type enumCallbackCallResult = (call_result_not_init,        // нет инициализации всех параметров
                                 call_result_unknown,         // что то пошло не так
                                 call_result_wait_server,     // ожидание ответа от сервера
                                 call_result_wait_responce,   // ожидание ответа
                                 call_result_fail,            // ошибка при ответе, номер не отвечает или не сброс произошел
                                 call_result_ok,              // ок, вызов произошел разговор
                                 call_result_end);            // ок, разговор завершился

  // class TCommandCallbackRemote
    type
      TCommandCallbackRemote = class

      private
      m_commandID                 :Integer;  // id возвращенной команды( после успешного создания m_commandRemoteExist)
      m_commandRemoteExist        :Boolean;  // созданная команда на сервере
      m_commandCallCreate         :Boolean;  // создан файл *.call
      m_commandTalk               :Boolean;  // совершился разговор
      m_commandTalkTime           :Integer;  // время которое начинаем отсчитывапть
      m_commandError              :Boolean;  // ошибка во время звонка (не ответили на звонок)
      m_commandCallEnd            :Boolean;  // разговор завершился
      m_commandNotAnswered        :Boolean;  // абонент не отвечает

      function GetRemoteExist:Boolean;
      procedure SetRemoteExist(_value:Boolean);
      function GetCallCreate:Boolean;
      procedure SetCallCreate(_value:Boolean);
      function GetCommandID:Integer;
      procedure SetCommandID(_value:Integer);
      function GetTalkDone:Boolean;
      procedure SetTalkDone(_value:Boolean);
      function GetTalkTime:Integer;
      procedure SetTalkTime(_value:Integer);
      function GetAnswered:Boolean;
      procedure SetAnswered(_value:Boolean);
      function GetCallError:Boolean;
      procedure SetCallError(_value:Boolean);
      function GetCallEnd:Boolean;
      procedure SetCallEnd(_value:Boolean);



      public
      constructor Create;  overload;
      procedure Clear;


      // ========= property =========
      property Exist : Boolean read GetRemoteExist write SetRemoteExist;
      property CallFileCreated : Boolean read GetCallCreate write SetCallCreate;
      property Talk : Boolean read GetTalkDone write SetTalkDone;
      property TalkTime : Integer read GetTalkTime write SetTalkTime;
      property IsError : Boolean read GetCallError write SetCallError;
      property IsCallEnd : Boolean read GetCallEnd write SetCallEnd;
      property CallNotAnswer : Boolean read GetAnswered write SetAnswered;




      property ID:Integer read GetCommandID write SetCommandID;


      end;
  // END class TCommandCallbackRemote



 // class TCallbackCall
 type
      TCallbackCall = class

      private
      m_dispatcher  :TThreadDispatcher;     // планировщик
      m_error       :string;            // какая то не понятная ошибка по мимо enumCallbackCallResult

      m_init        :Boolean;       // все данные есть для звонка
      m_userID      :Integer;       // userId по БД
      m_phone       :string;        // номер на который звоним
      m_sip         :Integer;       // user sip
      m_autoRun     :Boolean;       // сразу запуск или нет

      m_status      :enumCallbackCallResult; // текущий статус звонка
      m_mutex       :TMutex;

      /// ----- параметры команд -----
      m_command     :TCommandCallbackRemote;



     // function  RequestToBase(_response:lisaStatResponce):Integer;  // получение данных из БД
      procedure CreateThread;
      procedure UpdateCallInfo; // обновление данных по классу
      function IsInit():Boolean;  // проверка что есть все данные для совершения звонка
      function GetStatus:enumCallbackCallResult;  // текущий статус звонка
      function GetStatusString:string; // текущий статус звонка (string)
      procedure CheckInit;  // проверка что все данные есть


      // ----- команды для взаимодействия с сервером -----
//      function ResponceExecute(const _responce:TStringBuilder; var _errorDescriptions:string):boolean;    // отправка запроса на сервер
//      function ResponceSelect(const _responce:TStringBuilder;
//                                var _ado:TADOQuery;
//                                var _errorDescriptions:string):boolean;    // запрос select
      function GetLastCommandID:Integer;    // получение id последней команды
      function IsExistCallCommand:Boolean;  // проверка что уже создали команду
      function CreateRemoteCommand:Boolean; // создать удаленную команду
      function CreateCallFile:Boolean;      // проверка что команда *.call создана
      function IsTalk:Boolean;              // пошел звонок
      function GetTalkTime:Integer;         // время отсчета звонка
      function IsTalkError:Boolean;         // звонок не пошел, т.е. не ответили на него
      function IsCallEnding:Boolean;        // разговор завершился
      function CallNotAnswered:Boolean;     // абонент не отвечает

      function GetTalkTimeString:string;    // время отсчета звонка формат 00:00:00

      public

      constructor Create();   overload;
      constructor Create(_userID:Integer; _userSip:Integer);   overload;
      constructor Create(_userID:Integer; _userSip:Integer; _phone:string; _autoRun:Boolean);   overload;
      destructor Destroy;                    override;

      procedure Clear;

      procedure SetId(_userId:Integer; _userSip:Integer);
      procedure SetPhone(_phone:string);

      procedure CreateCall; // просто обертка для запуска потока


     // ========= property =========
       property Status:enumCallbackCallResult read GetStatus;
       property StatusString:string read GetStatusString;
       property TalkTime:string read GetTalkTimeString;


      end;
   // class TCallbackCall END


implementation

uses
  FunctionUnit, GlobalVariables;


// ---  не вошедшие функции ---
function CallbackCallErrorToString(_error:enumCallbackCallResult):string;
begin
  case _error of
   call_result_not_init:        Result:='TCallbackCall не инициализирован';
   call_result_unknown:         Result:='Неизвестное состояние звонка';
   call_result_wait_server:     Result:='Ожидание ответа от сервера';
   call_result_wait_responce:   Result:='Звонок на номер';
   call_result_fail:            Result:='Абонент не отвечает';
   call_result_ok:              Result:='Разговор';
   call_result_end:             Result:='Звонок завершен';
  end;
end;

// ---  не вошедшие функции (END) ---


// --- TCommandCallbackRemote ---
constructor TCommandCallbackRemote.Create();
begin
 m_commandID:=0;
 m_commandRemoteExist:=False;
 m_commandCallCreate:=False;
 m_commandTalk:=False;
 m_commandTalkTime:=0;
 m_commandError:=False;
 m_commandCallEnd:=False;
 m_commandNotAnswered:=False;
end;


procedure TCommandCallbackRemote.Clear;
begin
 m_commandID:=0;
 m_commandRemoteExist:=False;
 m_commandCallCreate:=False;
 m_commandTalk:=False;
 m_commandTalkTime:=0;
 m_commandError:=False;
 m_commandCallEnd:=False;
 m_commandNotAnswered:=False;
end;

function TCommandCallbackRemote.GetRemoteExist:Boolean;
begin
  Result:=m_commandRemoteExist;
end;

procedure TCommandCallbackRemote.SetRemoteExist(_value:Boolean);
begin
 m_commandRemoteExist:=_value;
end;

function TCommandCallbackRemote.GetCallCreate:Boolean;
begin
 Result:=m_commandCallCreate;
end;

procedure TCommandCallbackRemote.SetCallCreate(_value:Boolean);
begin
 m_commandCallCreate:=_value;
end;

function TCommandCallbackRemote.GetCommandID:Integer;
begin
 Result:=m_commandID;
end;

procedure TCommandCallbackRemote.SetCommandID(_value:Integer);
begin
 m_commandID:=_value;
end;

function TCommandCallbackRemote.GetTalkDone:Boolean;
begin
 Result:=m_commandTalk;
end;

procedure TCommandCallbackRemote.SetTalkDone(_value:Boolean);
begin
 m_commandTalk:=_value;
end;

function TCommandCallbackRemote.GetTalkTime:Integer;
begin
 Result:=m_commandTalkTime;
end;

procedure TCommandCallbackRemote.SetTalkTime(_value:Integer);
begin
 m_commandTalkTime:=_value;
end;

function TCommandCallbackRemote.GetCallError:Boolean;
begin
 Result:=m_commandError;
end;

procedure TCommandCallbackRemote.SetCallError(_value:Boolean);
begin
 m_commandError:=_value;
end;

function TCommandCallbackRemote.GetCallEnd:Boolean;
begin
 Result:=m_commandCallEnd;
end;

procedure TCommandCallbackRemote.SetCallEnd(_value:Boolean);
begin
 m_commandCallEnd:=_value;
end;

function TCommandCallbackRemote.GetAnswered:Boolean;
begin
 Result:=m_commandNotAnswered;
end;

procedure TCommandCallbackRemote.SetAnswered(_value:Boolean);
begin
 m_commandNotAnswered:=_value;
end;




// --- TCommandCallbackRemote (END)---
///////////////////////////////////////////////////////////////////////////////////////


constructor TCallbackCall.Create();
begin
  m_init:=False;
  m_error:='';

  m_userID:=0;
  m_phone:='';
  m_sip:=-1;
  m_autoRun:=False;
  m_command:=TCommandCallbackRemote.Create;

  CreateThread;
  CheckInit;
end;


constructor TCallbackCall.Create(_userID:Integer; _userSip:Integer);
begin
  m_init:=False;
  m_error:='';

  m_userID:=_userID;
  m_phone:='';
  m_sip:=_userSip;
  m_autoRun:=False;
  m_command:=TCommandCallbackRemote.Create;

  CreateThread;
  CheckInit;
end;

constructor TCallbackCall.Create(_userID:Integer; _userSip:Integer; _phone:string; _autoRun:Boolean);
begin
   m_error:='';

   m_userID:=_userID;
   m_phone:=_phone;
   m_sip:=_userSip;
   m_autoRun:=_autoRun;
   m_command:=TCommandCallbackRemote.Create;

   CreateThread;
   CheckInit;
end;

destructor TCallbackCall.Destroy;
begin
  m_mutex.Free;

  if m_dispatcher.Started then m_dispatcher.StopThread;
  m_dispatcher.Free;
end;


procedure TCallbackCall.CreateThread;
begin
  m_mutex:=TMutex.Create(nil, False, 'Global\TCallbackCall');
  m_dispatcher:=TThreadDispatcher.Create('TCallbackCall',1, False, UpdateCallInfo);
end;



procedure TCallbackCall.Clear;
begin
  m_init:=False;
  m_error:='';
  m_userID:=0;
  m_phone:='';
  m_sip:=-1;

  m_command.Clear;

  m_status:=call_result_not_init;
  m_dispatcher.StopThread;
end;

// проверка что есть все данные для совершения звонка
function TCallbackCall.IsInit():Boolean;
begin
   Result:=m_init;
end;

// текущий статус звонка
function TCallbackCall.GetStatus:enumCallbackCallResult;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=m_status;
  finally
    m_mutex.Release;
  end;
end;

function TCallbackCall.GetStatusString:string; // текущий статус звонка (string)
var
 state:enumCallbackCallResult;
begin
  state:=GetStatus;
  Result:=CallbackCallErrorToString(state);
end;


procedure TCallbackCall.CheckInit;
begin
  if ((m_userID > 0) and (m_sip > -1)) and (m_phone<>'') then begin
    m_init:=True;
    m_status:=call_result_unknown;
  end
  else begin
    m_init:=False;
    m_status:=call_result_not_init;
  end;
end;

// отправка запроса на сервер
//function TCallbackCall.ResponceExecute(const _responce:TStringBuilder; var _errorDescriptions:string):boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
//begin
//  _errorDescriptions:='';
//  Result:=False;
//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(_errorDescriptions);
//
//  if not Assigned(serverConnect) then begin
//     Result:=False;
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//   try
//     with ado do begin
//        ado.Connection:=serverConnect;
//        SQL.Clear;
//        SQL.Add(_responce.ToString);
//
//        try
//          ExecSQL;
//        except
//            on E:EIdException do begin
//               Result:=False;
//
//               FreeAndNil(ado);
//               if Assigned(serverConnect) then begin
//                 serverConnect.Close;
//                 FreeAndNil(serverConnect);
//               end;
//               _errorDescriptions:='Внутренняя ошибка сервера'+#13#13+e.ClassName+': '+e.Message;
//               Exit;
//            end;
//        end;
//     end;
//   finally
//    FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//   end;
//
//  Result:=True;
//end;

// запрос select
//function TCallbackCall.ResponceSelect(const _responce:TStringBuilder;
//                                        var _ado:TADOQuery;
//                                        var _errorDescriptions:string):boolean;
//var
// serverConnect:TADOConnection;
//begin
//  Result:=False;
//  if not Assigned(_ado) then _ado:=TADOQuery.Create(nil);
//
//  serverConnect:=createServerConnectWithError(_errorDescriptions);
//
//  if not Assigned(serverConnect) then begin
//     FreeAndNil(_ado);
//     Exit;
//  end;
//
//  try
//    with _ado do begin
//      _ado.Connection:=serverConnect;
//
//      SQL.Clear;
//      SQL.Add(_responce.ToString);
//      Active:=True;
//    end;
//  except
//    FreeAndNil(_ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//    Exit;
//  end;
//
//  Result:=True;
//end;


 // получение id последней команды
function TCallbackCall.GetLastCommandID:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=0;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
 with request do begin
   Clear;
   Append('select id from queue_outgoing');
   Append(' where user_id = '+#39+IntToStr(m_userID)+#39+' and phone = '+#39+m_phone+#39+' and sip = '+#39+IntToStr(m_sip)+#39);
   Append(' and hash is NULL order by date_time DESC limit 1');
 end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      Result:=Fields[0].Value;
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

// проверка что уже создали *.call команду
function TCallbackCall.IsExistCallCommand:Boolean;
begin
  Result:=m_command.CallFileCreated;
end;


// создать удаленную команду
function TCallbackCall.CreateRemoteCommand:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
  Result:=False;
  //m_error:='';
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

  request:=TStringBuilder.Create;

  with request do begin
    Clear;
    Append('insert into queue_outgoing');
    Append(' (user_id,phone,sip)');
    Append(' values (');
    Append(#39+IntToStr(m_userID) +#39+',' +#39+m_phone+#39+','+#39+IntToStr(m_sip)+#39);
    Append(')');
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add(request.ToString);
      if Active then Active:=False;
      try
        ExecSQL;
      except
          on E:EIdException do begin
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
                FreeAndNil(request);
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
     FreeAndNil(request);
   end;
  end;

  // получим id нашей команды
  m_command.ID:=GetLastCommandID;
  m_status:=call_result_wait_server;
  Result:=True;
end;

// проверка что команда *.call создана
function TCallbackCall.CreateCallFile:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=False;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
 with request do begin
    Clear;
    Append('select create_call from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
 end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
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

// пошел звонок
function TCallbackCall.IsTalk:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=False;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
  with request do begin
    Clear;
    Append('select answered from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
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

// время отсчета звонка
function TCallbackCall.GetTalkTime:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=0;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
  with request do begin
    Clear;
    Append('select talk_time from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      Result:=Fields[0].Value;
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


// звонок не пошел, т.е. не ответили на него
function TCallbackCall.IsTalkError:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
  Result:=False;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
  with request do begin
    Clear;
    Append('select error from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
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


// разговор завершился
function TCallbackCall.IsCallEnding:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=False;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
  with request do begin
    Clear;
    Append('select hash from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if (Fields[0].Value <> null) then Result:=True;
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


// абонент не отвечает
function TCallbackCall.CallNotAnswered:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 request:TStringBuilder;
begin
 Result:=False;
 ado:=TADOQuery.Create(nil);
 // m_error:='';

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

 request:=TStringBuilder.Create;
  with request do begin
    Clear;
    Append('select answered, hash from queue_outgoing');
    Append(' where id = '+#39+IntToStr(m_command.ID)+#39);
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(request.ToString);
      Active:=True;

      if ((Fields[0].Value = 0) and (Fields[1].Value <> null)) then Result:=True;
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

 // время отсчета звонка формат 00:00:00
function TCallbackCall.GetTalkTimeString:string;
begin
 if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=GetTimeAnsweredSecondsToString(m_command.m_commandTalkTime);
  finally
    m_mutex.Release;
  end;
end;

procedure TCallbackCall.SetId(_userId:Integer; _userSip:Integer);
begin
  m_userID:=_userId;
  m_sip:=_userSip;
  CheckInit;
end;

procedure TCallbackCall.SetPhone(_phone:string);
begin
 m_phone:=_phone;
 CheckInit;
end;

procedure TCallbackCall.CreateCall;
begin
  if not Assigned(m_dispatcher) then begin
    m_status:=call_result_not_init;
    Exit;
  end;

  m_dispatcher.StartThread;
end;

// обновление данных по классу
procedure TCallbackCall.UpdateCallInfo;
begin
  if not IsInit then begin
    m_status:=call_result_not_init;
    Exit;
  end;

  if m_command.IsError then begin
    // TODO тут еще подумать что можно еще сделать
    Exit;
  end;

  // создаем команду
  if not m_command.Exist then begin
   m_command.Exist:=CreateRemoteCommand; // отправляем команду серверу
   m_status:=call_result_wait_server;
   Exit;
  end;

  // ждем когда создасться *.call файл
  if not m_command.CallFileCreated then begin
   m_command.CallFileCreated:=CreateCallFile;
   m_status:=call_result_wait_server;
   Exit;
  end;

  //звонок на номер (ждем пока ответит или еще какой нить статус не отработает)
  if not m_command.Talk then begin
    m_command.Talk:=IsTalk;
    m_command.TalkTime:=GetTalkTime;
    m_status:=call_result_wait_responce;

    // тут же проверяем вдруг не ответили на звонок и нужно с ошибкой отвечать
    m_command.IsError:=IsTalkError;
    if m_command.IsError then begin
      m_status:=call_result_fail;
      Exit;
    end;

    // проверяем вдруг абонент не отвечает
    begin
     m_command.CallNotAnswer:=CallNotAnswered;
      if m_command.CallNotAnswer then begin
       // абонент не отвечает
       m_status:=call_result_fail;
       m_dispatcher.StopThread;
       Exit;
      end;
    end;
    Exit;
  end;

  // ответили, проверяем что завершился ли разговор или нет
  if not m_command.IsCallEnd then begin
    m_command.IsCallEnd:=IsCallEnding;
    m_command.TalkTime:=GetTalkTime;
    m_status:=call_result_ok;
   // Exit;
  end
  else begin
   // разговор завершился
   m_status:=call_result_end;
   m_dispatcher.StopThread;
  end;
end;

end.
