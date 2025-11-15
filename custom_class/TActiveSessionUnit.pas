/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания активных сессий                       ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////



unit TActiveSessionUnit;

interface

uses
    System.Classes, Data.Win.ADODB, Data.DB,
    System.SysUtils, Variants, Graphics,
    System.SyncObjs, IdException,
    TCustomTypeUnit, TThreadDispatcherUnit, System.DateUtils, System.Generics.Collections;



 // class TActiveStruct
  type
      TActiveStruct = class
      public

      m_userID                  : Integer;
      m_role                    : enumRole;
      m_userName                : string;
      m_PC                      : string;
      m_IP                      : string;
      m_memory                  : string;
      m_lastDateOnline          : TDateTime;
      m_uptime                  : Integer;

      isOperator                :Boolean;   // операторская учетка
      isOperatorInQueue         :Boolean;   // оператор находится в очереди
      m_operatorQueueList       :TList<enumQueue>;  // список в каких очередях находится оператор


      m_online                  :enumOnlineStatus;   // текущий статус ONLINE\OFFLINE
      constructor Create;               overload;
      destructor Destroy; override;

      procedure Clear;

      end;
  // class TActiveStruct END

// ==========================================

  // class TActiveSession
  type
      TActiveSession = class
      private
      m_mutex                                 : TMutex;
      m_listActiveSession                     : TArray<TActiveStruct>;
      m_count                                 : Word;                 // кол-во которое сейчас онлайн


      procedure CreateListActiveSession;                      // создание списка активных сессий
      procedure Clear;                                        // обнуление массива
      function GetCountActiveSessionBD        : Word;         // текущее кол-во активных сессий по БД
      function GetLastOnlineUser(_user_id:Integer):TDateTime; // время когда последний раз был пользователь онлайн
      procedure UpdateActiveSession;          // обновление текущего листа с активными сессиями


      procedure UpdateTimeOnline(_id:Integer); // обновление времени онлайна пользователя
      procedure RemoveSessionIndex(AIndex: Integer);
      function GetResponse(_stroka:string; var _errorDescription:string):Boolean; // отправка запроса на сервер


      public

      constructor Create;                     overload;
      destructor Destroy;                     override;

      procedure Update;                                     // заупск обновления данных
      function GetNoActiveSessionCount:Integer;             //кол-во неактивных сесиий
      function IsActiveSession(_idUser:Integer):Boolean;    // сессия сейчас активна или нет
      function IsOperator(_idUser:Integer):Boolean;         // операторсекая учетка
      function IsOperatorInQueue(_idUser:Integer):Boolean;  // оператор находится в очереди
      function DeleteOfflineSession(_idUser:Integer;
                                    var _errorDescription:string;
                                    _isSetStatusOperatorGoHome:Boolean = False):Boolean; // удаление активной сессии (offline)
      function DeleteOnlineSession(_idUser:Integer; var _errorDescription:string):Boolean;  // удаление активной сессии (online)
      function ForceExitOperatorInQueue(_idUser:Integer; var _errorDescription:string):Boolean;  // выход из очереди активного оператора


      // ===================== доставание данных =====================
      function GetArrayID(_idUser:Integer)        :Integer;           // m_listActiveSession[]
      function GetUserID(_id:Integer)             :Integer;           // m_listActiveSession.m_userID
      function GetOnlineStatus(_id:Integer)       :enumOnlineStatus;  // m_listActiveSession.m_online
      function GetRole(_id:Integer)               :enumRole;          // m_listActiveSession.m_role
      function GetUserName(_id:Integer)           :string;            // m_listActiveSession.m_userName
      function GetPC(_id:Integer)                 :string;            // m_listActiveSession.m_pc
      function GetIP(_id:Integer)                 :string;            // m_listActiveSession.m_ip
      function GetMemory(_id:Integer)             :string;            // m_listActiveSession.m_memory
      function GetUptime(_id:Integer)             :Integer;           // m_listActiveSession.m_uptime
      function GetLastOnline(_id:Integer)         :TDateTime;         // m_listActiveSession.m_lastDateOnline
      // ===================== доставание данных =====================
      property Count :word read m_count;



      end;
  // class TActiveSession END





implementation

uses
  FunctionUnit, GlobalVariables, GlobalVariablesLinkDLL, TStatusUnit;

 const
  cTIME_ONLINE:Word = 10; // время в секундах при котором считается что пользоак не онлайн

//////////////////////////////////////////////////
// class TActiveStruct  STARt

constructor TActiveStruct.Create;
 begin
   inherited;
   Clear;
 end;

destructor TActiveStruct.Destroy;
begin
  m_operatorQueueList.Free;
  inherited;
end;

 procedure TActiveStruct.Clear;
 begin
   m_userID           :=0;
   m_role             :=role_operator_no_dash;
   m_userName         :='';
   m_PC               :='';
   m_IP               :='0.0.0.0';
   m_memory           :='0';
   m_lastDateOnline   :=0;
   m_uptime           :=0;

   isOperator         :=False;
   isOperatorInQueue  :=False;

   if not Assigned(m_operatorQueueList) then m_operatorQueueList:=TList<enumQueue>.Create
   else m_operatorQueueList.Clear;

   m_online           :=eOffline;


 end;

// class TActiveStruct  END
//////////////////////////////////////////////////



//////////////////////////////////////////////////
// class TActiveSession START
constructor TActiveSession.Create;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TActiveSession');
    m_count:=0;

    // создаем текущий список
    CreateListActiveSession;
 end;

destructor TActiveSession.Destroy;
var
 i: Integer;
begin
  for i:=Low(m_listActiveSession) to High(m_listActiveSession) do FreeAndNil(m_listActiveSession[i]);
  m_mutex.Free;

  inherited;
end;

 // заупск обновления данных
procedure TActiveSession.Update;
begin
  // вошел\вышел кто то
  if m_count <> GetCountActiveSessionBD then begin
    Clear;
    CreateListActiveSession;
  end;

  UpdateActiveSession;
end;


//кол-во неактивных сесиий
function TActiveSession.GetNoActiveSessionCount:Integer;
var
 i:Integer;
 no_active:Integer;
begin
  no_active:=0;

  for i:=0 to m_count -1 do begin
    if m_listActiveSession[i].m_online = eOffline then Inc(no_active);
  end;

  Result:=no_active;
end;

// сессия сейчас активна или нет
function TActiveSession.IsActiveSession(_idUser:Integer):Boolean;
var
 i:Integer;
begin
  Result:=False;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count-1 do begin
      if m_listActiveSession[i].m_userID = _idUser then begin
        if m_listActiveSession[i].m_online = eOnline then begin
          Result:=True;
          Exit;
        end;
        Exit;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// операторсекая учетка
function TActiveSession.IsOperator(_idUser:Integer):Boolean;
var
 i:Integer;
begin
  Result:=False;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1 do begin
      if m_listActiveSession[i].m_userID = _idUser then begin
        Result:=m_listActiveSession[i].isOperator;
        Exit;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;


// оператор находится в очереди
function TActiveSession.IsOperatorInQueue(_idUser:Integer):Boolean;
var
 i:Integer;
begin
  Result:=False;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1 do begin
      if m_listActiveSession[i].m_userID = _idUser then begin
        Result:=m_listActiveSession[i].isOperatorInQueue;
        Exit;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;


 // удаление активной сессии (offline)
function TActiveSession.DeleteOfflineSession(_idUser:Integer; var _errorDescription:string; _isSetStatusOperatorGoHome:Boolean = False):Boolean;
var
 response:string;
begin
  Result:=False;
  _errorDescription:='';

  // если оператоская учетка нужно ли принудительно посатвить статус (домой)
  if _isSetStatusOperatorGoHome then begin
     LoggingRemote(eLog_exit_force,_idUser);
     UpdateOperatorStatus(eUnknown,_idUser);
  end;

  response:='delete from active_session where user_id='+#39+IntToStr(_idUser)+#39;

  if not GetResponse(response, _errorDescription) then begin
    Exit;
  end;

  // уберем из списка этот id
  RemoveSessionIndex(GetArrayID(_idUser));

  Result:=True;
end;


// удаление активной сессии (online)
function TActiveSession.DeleteOnlineSession(_idUser:Integer; var _errorDescription:string):Boolean;
var
 response:string;
begin
   Result:=False;
  _errorDescription:='';

  response:='update active_session set force_closed = '+#39+IntToStr(SettingParamsStatusToInteger(paramStatus_ENABLED))+#39+' where user_id = '+#39+IntToStr(_idUser)+#39;

  if not GetResponse(response,_errorDescription) then begin
    Exit;
  end;

  // уберем из списка этот id
  RemoveSessionIndex(GetArrayID(_idUser));

  Result:=True;
end;


// выход из очереди активного оператора
function TActiveSession.ForceExitOperatorInQueue(_idUser:Integer; var _errorDescription:string):Boolean;
var
 status:TStatus;
 delay:enumStatus;
begin
  delay:=eNO;

  status:=TStatus.Create(_idUser, SharedCurrentUserLogon.GetUserData, False);
  Result:=status.SendCommand(eLog_home, delay, _errorDescription);
end;


// m_listActiveSession[]
function TActiveSession.GetArrayID(_idUser:Integer):Integer;
var
 i:Integer;
begin
  Result:=-1;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count-1 do begin
       if m_listActiveSession[i].m_userID = _idUser then begin
         Result:=i;
         Exit;
       end;
    end;
  finally
    m_mutex.Release;
  end;
end;


// m_listActiveSession.m_userID
function TActiveSession.GetUserID(_id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_userID;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_online
function TActiveSession.GetOnlineStatus(_id:Integer):enumOnlineStatus;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_online;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_role
function TActiveSession.GetRole(_id:Integer):enumRole;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_role;
  finally
    m_mutex.Release;
  end;
end;

 // m_listActiveSession.m_userName
function TActiveSession.GetUserName(_id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_userName;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_pc
function TActiveSession.GetPC(_id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_PC;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_ip
function TActiveSession.GetIP(_id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_IP;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_memory
function TActiveSession.GetMemory(_id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_memory;
  finally
    m_mutex.Release;
  end;
end;


// m_listActiveSession.m_uptime
function TActiveSession.GetUptime(_id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_uptime;
  finally
    m_mutex.Release;
  end;
end;

// m_listActiveSession.m_lastDateOnline
function TActiveSession.GetLastOnline(_id:Integer):TDateTime;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     Result:=m_listActiveSession[_id].m_lastDateOnline;
  finally
    m_mutex.Release;
  end;
end;


function TActiveSession.GetCountActiveSessionBD:Word;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

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
      SQL.Clear;
      SQL.Add('select count(id) from active_session');

      try
        Active:=True;
        Result:=StrToInt(VarToStr(Fields[0].Value));
      except
          on E:EIdException do begin
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
end;

// время когда последний раз был пользователь онлайн
function TActiveSession.GetLastOnlineUser(_user_id:Integer):TDateTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

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
      SQL.Clear;
      SQL.Add('select last_active from active_session where user_id = '+#39+IntToStr(_user_id)+#39+' order by last_active DESC limit 1');

      try
        Active:=True;
        if Fields[0].Value<>null then begin
          Result:=StrToDateTime(VarToStr(Fields[0].Value));
        end;
      except
          on E:EIdException do begin
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
end;


procedure TActiveSession.UpdateActiveSession;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActive:Integer;
begin
  // вдруг отличаеться кол-во активных сессий по памяти и по БД
  countActive:=GetCountActiveSessionBD;

 // if m_count = countActive then Exit;

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
      SQL.Clear;
      SQL.Add('SELECT asession.user_id, r.name_role, CONCAT(u.familiya, '+#39' '+#39+', u.name) '+
              ' AS full_name, asession.pc, asession.ip, asession.last_active, asession.uptime, asession.memory FROM active_session'+
              ' AS asession JOIN users AS u ON asession.user_id = u.id JOIN role AS r ON u.role = r.id');

      try
        Active:=True;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
          end;
      end;

      for i:=0 to countActive-1 do begin
        // ID
        m_listActiveSession[i].m_userID:=StrToInt(VarToStr(Fields[0].Value));
        // роль
        m_listActiveSession[i].m_role:=StringToEnumRole(VarToStr(Fields[1].Value));
        // пользователь
         m_listActiveSession[i].m_userName:=VarToStr(Fields[2].Value);
        // компьютер
        m_listActiveSession[i].m_PC:=VarToStr(Fields[3].Value);
        // IP
        m_listActiveSession[i].m_IP:=VarToStr(Fields[4].Value);
        // Дата онлайна
        m_listActiveSession[i].m_lastDateOnline:= StrToDateTime(VarToStr(Fields[5].Value));
        // Статус
        UpdateTimeOnline(i);
        // uptime
        m_listActiveSession[i].m_uptime:= StrToInt(VarToStr(Fields[6].Value));
        // memory
        m_listActiveSession[i].m_memory:= VarToStr(Fields[7].Value);

        // проверка роль оператора или нет
        if (AnsiPos('Оператор',VarToStr(Fields[1].Value)) <> 0) or
           (AnsiPos('оператор',VarToStr(Fields[1].Value)) <> 0) then begin
           m_listActiveSession[i].isOperator:=True;

           // проверка в очереди или нет находится оператор
           m_listActiveSession[i].m_operatorQueueList.Clear;
           m_listActiveSession[i].m_operatorQueueList:=GetCurrentQueueOperator(_dll_GetOperatorSIP(m_listActiveSession[i].m_userID));
           if m_listActiveSession[i].m_operatorQueueList.Count = 0 then m_listActiveSession[i].isOperatorInQueue:=False
           else m_listActiveSession[i].isOperatorInQueue:=True;

        end
        else begin  // не операторская учетка
         m_listActiveSession[i].isOperator:=False;
         m_listActiveSession[i].isOperatorInQueue:=False;
        end;

        ado.Next;
      end;

      m_count:=countActive;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

procedure TActiveSession.CreateListActiveSession;
var
 i:Integer;
 counts:Integer;
begin
  counts:=GetCountActiveSessionBD;

  // создаем listActiveSession
  SetLength(m_listActiveSession,counts);
  for i:=0 to counts-1 do m_listActiveSession[i]:=TActiveStruct.Create;

   // обновляем данные
   UpdateActiveSession;
end;

// обнуление массива
procedure TActiveSession.Clear;
//var
// i:Integer;
//begin
// if m_mutex.WaitFor(INFINITE)=wrSignaled then
//  try
//    for i:=0 to m_count -1 do begin
//      m_listActiveSession[i].Clear;
//    end;
//
//    m_count:=0;
//    SetLength(m_listActiveSession,m_count);
//  finally
//    m_mutex.Release;
//  end;
//end;
var
  i: Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i := 0 to m_count - 1 do  m_listActiveSession[i].Free;  // а не .Clear
    m_count := 0;
    SetLength(m_listActiveSession, 0);
  finally
    m_mutex.Release;
  end;
end;

// обновление времени онлайна пользователя
procedure TActiveSession.UpdateTimeOnline(_id:Integer);
begin
  // обновим время
  m_listActiveSession[_id].m_lastDateOnline:=GetLastOnlineUser(m_listActiveSession[_id].m_userID);

  // обновление статуса онлайн\не онлайн
  if SecondsBetween(Now, m_listActiveSession[_id].m_lastDateOnline ) > cTIME_ONLINE then m_listActiveSession[_id].m_online:=eOffline
  else m_listActiveSession[_id].m_online:=eOnline;
end;


// удаление элемента из массива по его индексу
procedure TActiveSession.RemoveSessionIndex(AIndex: Integer);
var
  i: Integer;
begin
  // проверяем границы
  if (AIndex < 0) or (AIndex >= Length(m_listActiveSession)) then Exit;

  // освобождаем объект
  m_listActiveSession[AIndex].Free;

  // сдвигаем все последующие элементы влево
  for i:= AIndex to High(m_listActiveSession) - 1 do m_listActiveSession[i] := m_listActiveSession[i + 1];

  // укорачиваем массив
  SetLength(m_listActiveSession, Length(m_listActiveSession) - 1);

  // корректируем количество
  if m_count > 0 then Dec(m_count);
end;

// отправка запроса на сервер
function TActiveSession.GetResponse(_stroka:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

begin
  Result:=False;
  _errorDescription:='';

   ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
     Result:=False;
     FreeAndNil(ado);
     Exit;
  end;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(_stroka);
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

               _errorDescription:='Сервер не смог обработать команду из за внутренней ошибки'+#13#13+e.ClassName+': '+e.Message;
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


// class TActiveSession END
//////////////////////////////////////////////////
end.

{
 try
      if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
        try





        finally
          m_mutex.Release;
        end;
      end;
     finally
       m_mutex.Free;
     end;
}