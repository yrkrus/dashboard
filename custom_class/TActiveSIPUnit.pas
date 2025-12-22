/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                      Класс для описания TActiveSIP                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TActiveSIPUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
     Variants, Graphics, System.SyncObjs, IdException, TUserUnit,
     TCustomTypeUnit, TLogFileUnit, System.Generics.Collections,
     Vcl.Dialogs;

  // class TOnline

  type
    TOnline = class

    public
    date_online             :TDateTime;
    hide                    :Boolean;    // есть ли простой по времени (true не показвываем оператора )

    procedure Сlear;                                        // очистка

    constructor Create;                     overload;
    destructor Destroy;                     override;

    end;
  // class TOnline END


 // class TStructSIP
   type
      TStructSIP = class

      public

      //id                                     : Integer;
      user_id                                : Integer;       // ID пользака в БД users
      sip_number                             : Integer;        // номер оператора
      count_talk                             : integer;       // кол-во отвеченных вызовов
      count_procent                          : Double;        // % отвеченных звонков от общего кол-ва звонков
      trunk                                  : string;        // транк с которого пришел звонок
      phone                                  : string;        // номер телефона
      talk_time                              : string;        // время разговора
      m_queueList                            : TList<enumQueue>;    // очереди в которых сидит оператор
      m_queuePaused                          : Boolean;       // очередь на паузе находиться или нет(при true звонки не принимаются)
      status                                 : enumStatusOperators;       // текущий статус оператора
      status_delay                           : enumStatusOperators; // отложенный статус (когда оператор в разговоре)
      access_dashboard                       : Boolean;       // есть ли доступ к дашборду
      operator_name                          : string;        // имя оператора
      isOnHold                               : Boolean;       // оператор находится в статусе onHold
      onHoldStartTime                        : string;        // время когда оператор перешел в статус onHold
      talk_time_all                          : integer;       // общее время разговора
      talk_time_avg                          : Integer;       // среднее время разговора
      list_talk_time_all                     : TStringList;   // список со всеми разговорами
      online                                 : TOnline;       // время в онлайне


      procedure Сlear;                                        // очистка

      constructor Create;                     overload;
      destructor Destroy;                     override;


      end;

   // class TStructSIP END


/////////////////////////////////////////////////////////////////////////////////////////
  // class TActiveSIP
  type
      TActiveSIP = class
      const
      cGLOBAL_ListSIPOperators               : Word =  100; // длинна массива
      cHIDETIME_ListSIPOperators             : Word =    5; // время в минутах при котором считаем что оператор заюыл выйти из дашборда когда ушед домой

      private
      m_mutex                                : TMutex;
      sipOperators                           : TStringList;
      countSipOperators                      : Word;
      countSIpOperatorsHide                  : Word;

      listOperators                          : TArray<TStructSIP>;   // список с операторами
      countAllTalkCalls                      : Integer; // общее кол-во отвеченных звонков
      m_logging                              : TLoggingFile;

      m_commonQueue                          : TList<enumQueue>; // список с очередями которые видит пользователь

      procedure Clear;                       // очистка от всех значений
      function GetListOperatorsGoHome:TStringList;    // список операторов которые ушли домой
      function GetListOperatorsGoHomeNotCloseDashboard:TStringList; // список операторов которые ушли домой но забыли закрыть дашборб
      function GetListOperatorsGoHomeClosedActiveSession:TStringList; // список операторов которые ушли через закрытие активной сессии

      function GetListOperators_QueueListExist(id:Integer; queue:enumQueue):Boolean;    // есть ли очередь уже
      
      function GetListOperators_TalkTimeAll(id:Integer):Integer;        // listOperators.list_talk_time_all
      function GetListOperators_TalkTimeAvg(id:Integer):Integer;        // listOperators.list_talk_time_avf
      function GetListOperators_QueueList(id:Integer):TList<enumQueue>;     // listOperators.m_queueList
      function GetListOperators_QueueListSTR(id:Integer):string;     // listOperators.m_queueList
      
      public
      countActiveCalls                       :Integer; // кол-во активных звонков
      countFreeOperators                     :Integer; // кол-во свободных операторов

      constructor Create;                     overload;
      destructor Destroy;                     override;


      procedure AddLinkLogFile(var p_Log:TLoggingFile);   // данный метод исключительно только 1 раз нужен чтобы добавить в класс ссылку на лог и вызывать его потом корреткно для других функций
      procedure AddCommonQueue(_queueList:TList<enumQueue>); // добавление списка с очередями которые может видеть пользователь
      procedure showActiveAndFreeOperatorsForm;           // показ на главной форме сколько сейчас есть активных и
      procedure showHideOperatorsForm;                    // показ на главной форме сколько сейчас скрытых операторов по статусу "ушли домой"

      function  GetCountSipOperators          : Word;     // кол-во операторов
      function  getCountSipOperatorsHide      : Word;     // кол-во операторов (скрытых)


      procedure GenerateSipOperators(isReBuild:Boolean; isNotViewGoHome:Boolean = False);        // получить список с текущими операторами  isReBuild = true - пересоздать операторов
      procedure updateListTalkTimeAll;                          // обновление списка с длительностями разговора

      procedure updateCountTalk;                        // обновление кол-ва отвеченных вызовов
      procedure updatePhoneTalk;                        // обновление с кем ведется сейчас разговор
      procedure updateTrunkTalk;                        // обновление с какой линии пришел звонок
      procedure updateQueue;                            // обновление текущей очереди
      procedure updateTalkTime;                         // обновление времени разговора
      procedure updateTalkTimeAll;                      // обновление времени разговора (общее)
      procedure UpdateStatus;                           // обновление текущего статуса оператора
      procedure UpdateStatusDelay;                      // обновление текущего статуса оператора (отложенная команда)
      procedure UpdateStatusOnHold;                     // обновление текущего статуса оератора при разговоре (поиск onHold)
      procedure updateOnline;                           // обновление времени онлайна
      procedure createUserID;                           // занесение записи user_id в память


      procedure checkNewSipOperators(isDashStarted:Boolean = False);        // обновление списка активных операторов если увидили нового оператора
      // true только при первом запуске дашборда

      function isExistOperatorInQueue(_sip:Integer):Boolean;        // проверка состояит ли оператор в какой либо очереди
      function isExistOperator(_sip:Integer):Boolean;               // проверка есть ли оператор
      function isExistOperatorInLastActiveBD(_sip:Integer):Boolean; // проверка есть ли оператор в таблице active_session



      // методы TStructSIP
      function GetListOperators_ID(_sip:Integer):Cardinal;              // listOperators.ID
      function GetListOperators_UserID(id:Integer):Integer;             // listOperators.user_id
      function GetListOperators_OperatorName(id:Integer):string;        // listOperators.operator_name
      function GetListOperators_SipNumber(id:Integer):Integer;           // listOperators.sip_number
      function GetListOperators_Status(id:Integer):enumStatusOperators; // listOperators.status
      function GetListOperators_StatusDelay(id:Integer):enumStatusOperators; // listOperators.status_delay
      function GetListOperators_AccessDashboad(id:Integer):Boolean;     // listOperators.access_dashboard
      function GetListOperators_TalkTime(id:Integer; isReducedTime:Boolean):string;            // listOperators.talk_time
      function GetListOperators_Trunk(id:Integer):string;               // listOperators.trunk
      function GetListOperators_Phone(id:Integer):string;               // listOperators.phone
      function GetListOperators_IsOnHold(id:Integer):Boolean;           // listOperators.isOnHold
      function GetListOperators_OnHoldStartTime(id:Integer):string;     // listOperators.onHoldStartTime
      function GetListOperators_CountTalk(id:Integer):Integer;          // listOperators.count_talk
      function GetListOperators_CountProcentTalk(id:Integer):string;    // listOperators.count_procent
      function GetListOperators_OnlineHide(id:Integer):Boolean;         // listOperators.online.hide
      // методы TStructSIP END

      function IsTalkOperator(_sip:Integer):enumStatus;                  // разговаривает ли сейчас оператор


      // ================ property ================
      property TalkTimeAll[_id:Integer]:Integer read GetListOperators_TalkTimeAll;
      property TalkTimeAvg[_id:Integer]:Integer read GetListOperators_TalkTimeAvg;
      property QueueList[_id:Integer]:TList<enumQueue> read GetListOperators_QueueList;
      property QueueListSTR[_id:Integer]:string read GetListOperators_QueueListSTR;
      property QueueListExist[_id:Integer; _queue:enumQueue]:Boolean read GetListOperators_QueueListExist; 
      
      // ================ property END ================


      end;
 // class TActiveSIP END


implementation

uses
  FunctionUnit, FormHome, GlobalVariables, GlobalVariablesLinkDLL;


// class TOnline START
 constructor TOnline.Create;
 begin
   inherited;
 end;

 destructor TOnline.Destroy;
 begin
  inherited Destroy;              // Вызов деструктора родительского класса
 end;

 procedure TOnline.Сlear;
 begin
   Self.hide:=False;
 end;


// class TOnline END


// class TStructSIP START
 constructor TStructSIP.Create;
 begin
   inherited;
   Self.list_talk_time_all:=TStringList.Create;
   Self.status:= eUnknown;
   Self.status_delay:=eUnknown;
   Self.access_dashboard:=False;
   Self.online:=TOnline.Create;
   Self.m_queueList:=TList<enumQueue>.Create;
   Self.m_queuePaused:=False;
   
   //id:=0;
   user_id:= -1;
 end;

 destructor TStructSIP.Destroy;
 begin
  FreeAndNil(list_talk_time_all); // Освобождение TStringList
  FreeAndNil(online);
  inherited Destroy;              // Вызов деструктора родительского класса
 end;

 procedure TStructSIP.Сlear;
 begin
   Self.sip_number:=-1;
   Self.count_talk:=0;
   Self.count_procent:=0;
   Self.trunk:='';
   Self.phone:='';
   Self.talk_time:='';
   Self.m_queueList.Clear;
   Self.m_queuePaused:=False;
   Self.status:=eUnknown;
   Self.status_delay:=eUnknown;
   Self.access_dashboard:=False;
   Self.operator_name:='';
   Self.isOnHold:=False;
   Self.onHoldStartTime:='';
   Self.talk_time_all:=0;
   Self.talk_time_avg:=0;
   Self.list_talk_time_all.Clear;
   Self.online.Сlear;
 end;
// class TStructSIP END



// class TActiveSIP START
 constructor TActiveSIP.Create;
 var
  i:Integer;
 begin
   inherited;
   m_mutex:=TMutex.Create(nil, False, 'Global\TActiveSIP');

   countSipOperators:=0;
   countSIpOPeratorsHide:=0;

   countActiveCalls:=0;         // кол-во активных звонков
   countFreeOperators:=0;       // кол-во свободных операторов
   countAllTalkCalls:=0;        // общее кол-во отвеченных звонков операторами


   // генерация листа с актиыными операторами
   sipOperators:=TStringList.Create;
   with sipOperators do begin
    Sorted:=True;
    Sort;
   end;

   // создаем ListOperators
   begin
     SetLength(listOperators,cGLOBAL_ListSIPOperators);
     for i:=0 to cGLOBAL_ListSIPOperators-1 do listOperators[i]:=TStructSIP.Create;
   end;
 end;


 destructor TActiveSIP.Destroy;
 var
  i:Integer;
 begin
  m_mutex.Free;
  countSipOperators:=0;

  FreeAndNil(sipOperators); // Освобождение TStringList
    // Освобождение каждого элемента массива
  for i:= Low(listOperators) to High(listOperators) do listOperators[i].Free; // Освобождаем каждый объект TStructSIP
  // Очистка массива
  SetLength(listOperators, 0); // Убираем ссылки на объекты

  inherited Destroy; // Вызов деструктора родительского класса
 end;


 function TActiveSIP.GetCountSipOperators:Word;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
        Result:=countSipOperators;
      finally
        m_mutex.Release;
      end;
    end;
 end;


  function TActiveSIP.getCountSipOperatorsHide:Word;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
        Result:=countSIpOPeratorsHide;
      finally
        m_mutex.Release;
      end;
    end;
 end;


 procedure TActiveSIP.Clear;
 var
  i:Integer;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
         for i:=0 to cGLOBAL_ListSIPOperators-1 do begin
           listOperators[i].Сlear;
         end;
         Self.sipOperators.Clear;
         Self.countSipOperators:=0;
         Self.countAllTalkCalls:=0;
      finally
        m_mutex.Release;
      end;
    end;
 end;


 // список операторов которые ушли домой
function TActiveSIP.GetListOperatorsGoHome:TStringList;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countStatus:Integer;
 i,j:Integer;
 preHome:TStringList;
 operatorExit,operatorGoHome:Boolean;
 GoHomeNotCloseDashboad:TStringList;
 ClosedWidthActiveSession:TStringList;
 queueList:TList<enumQueue>;
begin
  Result:=TStringList.Create;
  Result.Sorted:=True;
  Result.Duplicates:=dupIgnore;

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
      SQL.Add('select count(distinct(user_id)) from logging where action='+#39+IntToStr(EnumLoggingToInteger(eLog_home))+#39);
      Active:=True;

      countStatus:=Fields[0].Value;

      if countStatus=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        Exit;
      end;
      if Active then Active:=False;

      // теперь проверим вдруг оператор случайно нажал кнопку домой (такое уже случалось)
       begin
          preHome:=TStringList.Create;

          SQL.Clear;
          SQL.Add('select distinct(user_id) from logging where action='#39+IntToStr(EnumLoggingToInteger(eLog_home))+#39);
          Active:=True;

           for i:=0 to countStatus-1 do begin
             preHome.Add(VarToStr(Fields[0].Value));
             ado.Next;
           end;

         if Active then Active:=False;

         for i:=0 to countStatus-1 do begin
           SQL.Clear;
           SQL.Add('select action from logging where user_id = '#39+preHome[i]+#39+' order by date_time desc limit 2');
           Active:=True;

           operatorExit:=False;
           operatorGoHome:=False;

           for j:=0 to 1 do begin
              if j=0 then begin
                if VarToStr(Fields[0].Value)= '1' then operatorExit:=True;
              end
              else if j=1 then begin
                if VarToStr(Fields[0].Value)= '11' then operatorGoHome:=True;
              end;
             ado.Next;
           end;

           if (operatorExit) and (operatorGoHome) then Result.Add(preHome[i]);
           if Active then Active:=False;
         end;
       end;


       // проверим операторов которые нажади кнопку домой, но не закрыли дашборд
       GoHomeNotCloseDashboad:=GetListOperatorsGoHomeNotCloseDashboard;
       if GoHomeNotCloseDashboad.Count<>0 then begin
         for i:=0 to GoHomeNotCloseDashboad.Count-1 do begin
           Result.Add(GoHomeNotCloseDashboad[i]);
         end;
       end;
       if Assigned(GoHomeNotCloseDashboad) then FreeAndNil(GoHomeNotCloseDashboad);


       // проверим вдруг есть операторые закрытые через закрытие активной сессии
       ClosedWidthActiveSession:=GetListOperatorsGoHomeClosedActiveSession;
       if ClosedWidthActiveSession.Count<>0 then begin
         for i:=0 to ClosedWidthActiveSession.Count-1 do begin
           Result.Add(ClosedWidthActiveSession[i]);
         end;
       end;
       if Assigned(ClosedWidthActiveSession) then FreeAndNil(ClosedWidthActiveSession);


       // и теперь проверим вдруг есть операторы\помогаторы(статус без доступа к дашборду)
       begin
         if Active then Active:=False;
         SQL.Clear;
         SQL.Add('select count(distinct(sip)) from queue where sip IN (select sip from operators where user_id IN (select id from users where role = '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39+'))');
         Active:=True;

         countStatus:=Fields[0].Value;
         if countStatus = 0 then begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
            if Assigned(preHome) then FreeAndNil(preHome);
           Exit;
         end;

         if Active then Active:=False;
         SQL.Clear;
         SQL.Add('select distinct(sip) from queue where sip IN (select sip from operators where user_id IN (select id from users where role = '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39+'))');
         Active:=True;

         for i:=0 to countStatus-1 do begin
           queueList:=GetCurrentQueueOperator(StrToInt(VarToStr(Fields[0].Value)));
           if queueList.Count = 0 then  Result.Add(IntToStr(getUserID(StrToInt(VarToStr(Fields[0].Value)))));

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

    Result.Sort;
  end;

  if Assigned(preHome) then FreeAndNil(preHome);
end;


// список операторов которые ушли через закрытие активной сессии
function TActiveSIP.GetListOperatorsGoHomeClosedActiveSession:TStringList;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActiveSession:Integer;
 userId:Integer;
begin
  Result:=TStringList.Create;

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

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select count(distinct(user_id)) from logging where action = '+#39+IntToStr(EnumLoggingToInteger(eLog_exit_force))+#39);
      Active:=True;

      countActiveSession:=Fields[0].Value;

      if countActiveSession = 0 then begin
         FreeAndNil(ado);
         if Assigned(serverConnect) then begin
           serverConnect.Close;
           FreeAndNil(serverConnect);
         end;
         Exit;
      end;

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select distinct user_id from logging where action = '+#39+IntToStr(EnumLoggingToInteger(eLog_exit_force))+#39);
      Active:=True;

      for i:=0 to countActiveSession-1 do begin
        userId:=StrToInt(VarToStr(Fields[0].Value));
        // проверим оператор ли
        if IsUserOperator(userId) then begin
           // проверим текущий статус
         if GetLastStatusOperator(userId) = eLog_exit_force then Result.Add(IntToStr(userId));
        end;
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

// список операторов которые ушли домой но забыли закрыть дашбор
function TActiveSIP.GetListOperatorsGoHomeNotCloseDashboard:TStringList;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActiveSession:Integer;
 userId:Integer;
begin
  Result:=TStringList.Create;

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

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select count(user_id) from active_session where last_active>'+#39+GetNowDateTime+#39);
      Active:=True;

      countActiveSession:=Fields[0].Value;

      if countActiveSession = 0 then begin
         FreeAndNil(ado);
         if Assigned(serverConnect) then begin
           serverConnect.Close;
           FreeAndNil(serverConnect);
         end;
         Exit;
      end;

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select user_id,last_active from active_session where last_active>'+#39+GetNowDateTime+#39);
      Active:=True;

      for i:=0 to countActiveSession-1 do begin
       if (Fields[0].Value <> Null) and (Fields[1].Value <> Null) then begin
          userId:=StrToInt(VarToStr(Fields[0].Value));

           // проверим оператор ли
          if IsUserOperator(userId) then begin
             // проверим его статус чтобы было статус "Домой"
            if getStatusOperator(userId) = eHome then begin
               // проверим время
               if (Round((Now - VarToDateTime(Fields[1].Value)) * 24 * 60) > cHIDETIME_ListSIPOperators) then begin
                  Result.Add(IntToStr(userId));
               end;
            end;
          end;
       end;

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

// данный метод исключительно только 1 раз нужен чтобы добавить в класс ссылку на лог
// и вызывать его потом корреткно для других функций
 procedure TActiveSIP.AddLinkLogFile(var p_Log:TLoggingFile);
 begin
   Self.m_logging:=p_Log;
 end;

 // добавление списка с очередями которые может видеть пользователь
 procedure TActiveSIP.AddCommonQueue(_queueList:TList<enumQueue>);
 begin 
   Self.m_commonQueue:=_queueList;
 end;

 procedure TActiveSIP.showActiveAndFreeOperatorsForm;
 var
  freeOperator:string;
  activeCalls:string;
 begin
   with HomeForm.lblCount_ACTIVESIP do begin
     if countFreeOperators = 0 then freeOperator:='-'
     else freeOperator:=IntToStr(countFreeOperators);

     if countActiveCalls = 0 then activeCalls:='-'
     else activeCalls:=IntToStr(countActiveCalls);


     Caption:='Активные звонки ('+activeCalls+') | Свободные операторы ('+freeOperator+')';
   end;

   countActiveCalls:=0;
   countFreeOperators:=0;
 end;


 procedure TActiveSIP.showHideOperatorsForm;
 var
  countHide:Integer;
 begin
   with HomeForm do begin
     if chkboxGoHome.Checked then begin
      countHide:=getCountSipOperatorsHide;

      if countHide > 0 then begin
       ST_operatorsHideCount.Caption:='скрыто: '+IntToStr(countHide);
       ST_operatorsHideCount.Visible:=True;
      end
      else ST_operatorsHideCount.Visible:=False; // т.к. нет скрытых, то и отображать эту надпись не нужно
     end
     else ST_operatorsHideCount.Visible:=False;
   end;
 end;



 procedure TActiveSIP.updateListTalkTimeAll;
 var
  i,j:Integer;
  countAnswered:Integer;
  countAll,curr_seconds:Integer;
 begin
   if getCountSipOperators=0 then Exit;

   // проверяем вдруг изменолось кол-во звонков
   for i:=0 to Length(listOperators)-1 do begin

      if listOperators[i].sip_number <> -1 then begin
        if (listOperators[i].count_talk <> 0) then begin

          if (listOperators[i].count_talk > listOperators[i].list_talk_time_all.Count) then begin

            // есть разница в зыонках, надо обновиить список со звонками
             listOperators[i].list_talk_time_all.Clear;
             listOperators[i].list_talk_time_all:=CreateListAnsweredCall(listOperators[i].sip_number);

             // переведем в общее кол-во секунд
             countAll:=0;
             for j:=0 to listOperators[i].list_talk_time_all.Count-1  do begin
               curr_seconds:=GetTimeAnsweredToSeconds(listOperators[i].list_talk_time_all[j]);

               if countAll=0 then countAll:=curr_seconds
               else countAll:=countAll+curr_seconds;
             end;

             // общее время разговора
             listOperators[i].talk_time_all:=countAll;

             // среднее время разговора
             if listOperators[i].list_talk_time_all.Count-1 > 0 then listOperators[i].talk_time_avg:=Round(countAll/listOperators[i].list_talk_time_all.Count-1)
             else listOperators[i].talk_time_avg:=Round(countAll);
          end;

        end;

       { else begin // проверяем вдруг сейчас иде разговор    ПЛОХАЯ ИДЕЯ, т.к. суммирование общего времени идет + задержки при работе
           if (listOperators[i].talk_time<>'---') and (listOperators[i].talk_time<>'')  then begin
             curr_seconds:=getTimeAnsweredToSeconds(listOperators[i].talk_time);

            // плюсуем к общему времени разговора
            listOperators[i].talk_time_all:=listOperators[i].talk_time_all+curr_seconds;

            // среднее время разговора
            if listOperators[i].list_talk_time_all.Count-1 <>0 then begin
              listOperators[i].talk_time_avg:=Round(listOperators[i].talk_time_all/listOperators[i].list_talk_time_all.Count-1);
            end;
           end;
        end; }
      end;
   end;
 end;


 procedure TActiveSIP.GenerateSipOperators(isReBuild:Boolean; isNotViewGoHome:Boolean = False);
 var
  count_sip:Integer;
  i,j:Integer;
  isSipNoExist:Boolean;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  operatorsGoHome:TStringList;
  operatorsGoHomeNow:string;
  request:TStringBuilder;
  commonQueueSTR:string;  // список с очередями которые видит пользователь
 begin
   ado:=TADOQuery.Create(nil);
   count_sip:=0;
   request:=TStringBuilder.Create;
   commonQueueSTR:='';

   try
    serverConnect:=createServerConnect;
  except
    on E:Exception do begin
      if not Assigned(serverConnect) then begin
         FreeAndNil(ado);
         FreeAndNil(request);
         Exit;
      end;
    end;
  end;



    if m_mutex.WaitFor(INFINITE) = wrSignaled  then
    begin
       if isReBuild then begin
          Self.Clear;
       end;

     for i:=0 to m_commonQueue.Count-1 do begin
       if commonQueueSTR='' then commonQueueSTR:=#39+EnumQueueToString(m_commonQueue[i])+#39
       else commonQueueSTR:=commonQueueSTR+','+#39+EnumQueueToString(m_commonQueue[i])+#39;
     end;

      try
         if isNotViewGoHome = False then begin  // показываем всех операторов

           try
             with ado do begin
                ado.Connection:=serverConnect;
                SQL.Clear;

                with request do begin
                  Clear;
                  Append('select count(distinct sip) as total_unique_sip');
                  Append(' from (');
                  Append('select sip');
                  Append(' from queue');
                  Append(' where date_time > '+#39+GetNowDateTime+#39);
                  Append(' and sip <> ''-1''');
                  Append(' and number_queue in ('+commonQueueSTR+')');
                  Append(' union');
                  Append(' select sip');
                  Append(' from operators_queue');
                  Append(' where queue in ('+commonQueueSTR+')');
                  Append(') as t');
                end;                  

                
                SQL.Add(request.ToString);
                Active:=True;
                if Fields[0].Value<>null then count_sip:=Fields[0].Value;

                 if count_sip>=1 then begin

                    SQL.Clear;
                    with request do begin
                      Clear;
                      Append('select distinct sip as total_unique_sip');
                      Append(' from (');
                      Append('select sip');
                      Append(' from queue');
                      Append(' where date_time > '+#39+GetNowDateTime+#39);
                      Append(' and number_queue in ('+commonQueueSTR+')');
                      Append(' and sip <> ''-1''');
                      Append(' union');
                      Append(' select sip');
                      Append(' from operators_queue');
                      Append(' where queue in ('+commonQueueSTR+')');
                      Append(') as t');
                    end;                       

                    
                    SQL.Add(request.ToString);
                    Active:=True;

                    for i:=0 to count_sip-1 do begin
                      try
                        isSipNoExist:= False;  // номера в списке нет

                        // проверим есть ли уже такой оператор в списке
                         for j:=0 to sipOperators.Count-1 do begin
                           if Fields[0].Value = sipOperators[j] then begin
                             isSipNoExist:=True;
                             Break;
                           end;
                         end;

                         // добавим нового оператора
                         if isSipNoExist=False then sipOperators.Add(Fields[0].Value);
                      finally
                        ado.Next;
                      end;
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

           // кол-во скрытых операторов =0, т.к. показываем всех
           countSIpOPeratorsHide:=0;
         end
         else begin // показываем только операторов которые не ушли домой

           // смотрим кто у нас ушел домой
            operatorsGoHome:=getListOperatorsGoHome;
            if operatorsGoHome.Count=0 then begin

                FreeAndNil(ado);
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                  FreeAndNil(request);
                end;

             // нет того кто ушел домой, и мы уже сделали rebuild,
             // теперь тогла вызываем простой generate
             GenerateSipOperators(False);
             Exit;
            end;

            operatorsGoHomeNow:='';
            for i:=0 to operatorsGoHome.Count-1 do begin
              if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+IntToStr(_dll_GetOperatorSIP(StrToInt(operatorsGoHome[i])))+#39
              else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+IntToStr(_dll_GetOperatorSIP(StrToInt(operatorsGoHome[i])))+#39;
            end;

          try
           with ado do begin
              ado.Connection:=serverConnect;
              SQL.Clear;

              with request do begin
                Clear;
                Append('select count(distinct sip) as total_unique_sip');
                Append(' from (');
                Append('select sip');
                Append(' from queue');
                Append(' where date_time > '+#39+GetNowDateTime+#39);
                Append(' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1''');
                Append(' and number_queue in ('+commonQueueSTR+')');
                Append(' union');
                Append(' select sip');
                Append(' from operators_queue');
                Append(' where queue in ('+commonQueueSTR+')');
                Append(') as t');
              end; 
              
              SQL.Add(request.ToString);

              Active:=True;
              if Fields[0].Value<>null then count_sip:=Fields[0].Value;

               if count_sip<>0 then begin

                  SQL.Clear;
                  with request do begin
                    Clear;
                    Append('select distinct sip as total_unique_sip');
                    Append(' from (');
                    Append('select sip');
                    Append(' from queue');
                    Append(' where date_time > '+#39+GetNowDateTime+#39);
                    Append(' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1''');
                    Append(' and number_queue in ('+commonQueueSTR+')');
                    Append(' union');
                    Append(' select sip');
                    Append(' from operators_queue');
                    Append(' where queue in ('+commonQueueSTR+')');
                    Append(') as t');
                  end;                   
               
                  
                  SQL.Add(request.ToString);

                  Active:=True;

                  for i:=0 to count_sip-1 do begin
                    try
                      isSipNoExist:= False;  // номера в списке нет

                      // проверим есть ли уже такой оператор в списке
                       for j:=0 to sipOperators.Count-1 do begin
                         if Fields[0].Value = sipOperators[j] then begin
                           isSipNoExist:=True;
                           Break;
                         end;
                       end;

                       // добавим нового оператора
                       if isSipNoExist=False then sipOperators.Add(Fields[0].Value);
                    finally
                      ado.Next;
                    end;
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

           if Assigned(operatorsGoHome) then begin
             countSIpOPeratorsHide:=operatorsGoHome.Count;  // кол-во скрытых операторов
             FreeAndNil(operatorsGoHome);
             FreeAndNil(request);
           end;
         end;

           countSipOperators:=count_sip;

           // заполним listOPerators
           for i:=0 to countSipOperators-1 do begin
            isSipNoExist:=False;

             for j:=0 to Length(listOperators)-1 do begin

               // проверим есть ли уже такой номер
               if listOperators[j].sip_number = StrToInt(sipOperators[i]) then begin
                  isSipNoExist:=True;
                  Break;
               end;
             end;

              if isSipNoExist = False  then begin
                for j:=0 to Length(listOperators)-1 do begin
                  if listOperators[j].sip_number= -1 then begin
                    listOperators[j].sip_number:=StrToInt(sipOperators[i]);
                    listOperators[j].operator_name:=GetUserNameOperators(sipOperators[i]);

                    // проверим доступ оператора к дашборду
                    listOperators[j].access_dashboard:=getOperatorAccessDashboard(sipOperators[i]);

                    break;
                  end;
                end;
              end;
           end;

      finally
        m_mutex.Release;
      end;
    end;
 end;

 procedure TActiveSIP.updateCountTalk;
 var
  i:Integer;
  oldCount:Integer;
  newCount:Integer;
  isUpdateProcent:Boolean;
  procentCount:Double;
 begin
   if getCountSipOperators=0 then Exit;

   for i:=0 to Length(listOperators)-1 do begin
      if listOperators[i].sip_number <> -1 then begin
        isUpdateProcent:=False;

         // кол-во звонков
       oldCount:=listOperators[i].count_talk;
       newCount:=GetCountAnsweredCall(listOperators[i].sip_number);
       if newCount=0 then Continue;


        if oldCount<>newCount then begin
          isUpdateProcent:=True;
          listOperators[i].count_talk:=newCount;
        end;

        if isUpdateProcent then begin
          // % от общего кол-ва звонков
          countAllTalkCalls:=getCountAnsweredCallAll;
          if countAllTalkCalls>0 then begin
            procentCount:=listOperators[i].count_talk * 100 / countAllTalkCalls;
            listOperators[i].count_procent:=procentCount;
          end;
        end;
      end;
   end;
 end;

 procedure TActiveSIP.updatePhoneTalk;
 var
  i:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

       for i:=0 to Length(listOperators)-1 do begin

          if Active then Active:=False;

          if listOperators[i].sip_number<> -1 then begin

              SQL.Clear;
              SQL.Add('select phone from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+IntToStr(listOperators[i].sip_number)+#39+' and answered=''1'' and hash is null limit 1');
              Active:=True;

              if Fields[0].Value = null then listOperators[i].phone:=''
              else listOperators[i].phone:=VarToStr(Fields[0].Value);

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


 // обновление с какой линии пришел звонок
 procedure TActiveSIP.updateTrunkTalk;
 var
  i:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

       for i:=0 to Length(listOperators)-1 do begin
          if Active then Active:=False;
          if listOperators[i].sip_number <> -1 then begin

              if listOperators[i].phone = '' then begin
                listOperators[i].trunk:='';
                Continue;
              end;

              // нет смысла еще раз проверять т.к. разговор то один
              if listOperators[i].trunk = '' then begin
                SQL.Clear;
                SQL.Add('select trunk from ivr where date_time > '+#39+GetNowDateTime+#39+' and phone = '+#39+listOperators[i].phone+#39+' and to_queue = ''1'' order by date_time DESC limit 1');
                Active:=True;

                if Fields[0].Value = null then listOperators[i].trunk:='LISA'
                else listOperators[i].trunk:=VarToStr(Fields[0].Value);
              end;
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


 procedure TActiveSIP.updateQueue;
  var
  i:Integer;  
  tempQueue,newQueue:TList<enumQueue>;
  paused:Boolean;
 begin
   if getCountSipOperators=0 then Exit; 
   
   for i:=0 to Length(listOperators)-1 do begin
     if listOperators[i].sip_number = -1 then Continue;

     tempQueue:=listOperators[i].m_queueList;
     newQueue:=GetCurrentQueueOperator(listOperators[i].sip_number);
     paused:=GetCurrentQueuePausedOperator(listOperators[i].sip_number);

     listOperators[i].m_queuePaused:=paused;

     // равны ли пары очередей
     case EqualCurrentQueue(tempQueue,newQueue) of
       False:begin // пары не равны, обновляем данные
         listOperators[i].m_queueList.Clear;
         listOperators[i].m_queueList:=newQueue;
       end;
       True:begin  // пары равны пропускаем
         Continue;
       end;
     end;          
   end;    
  
 end;


procedure TActiveSIP.UpdateStatus;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

      if Active then Active:=False;

        SQL.Clear;
        SQL.Add('select status from operators where sip = '+#39+IntToStr(listOperators[i].sip_number)+#39);
        Active:=True;

       try
          if Fields[0].Value = Null then  begin
            listOperators[i].status:=eUnknown;
          end
          else begin
            listOperators[i].status:=IntegerToEnumStatusOperators(StrToInt(VarToStr(Fields[0].Value)));
          end;
       except
          on E:Exception do
          begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
          end;
       end;

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


 procedure TActiveSIP.UpdateStatusDelay;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 logging:enumLogging;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

      if Active then Active:=False;

        SQL.Clear;
        SQL.Add('select command from remote_commands where sip = '+#39+IntToStr(listOperators[i].sip_number)+#39 + ' and delay = ''1'' and error = ''0'' ');
        Active:=True;

       try
          if Fields[0].Value = Null then  begin
            listOperators[i].status_delay:=eUnknown;
          end
          else begin
            logging:=IntegerToEnumLogging(StrToInt(VarToStr(Fields[0].Value)));
            listOperators[i].status_delay:=EnumLoggingToStatusOperator(logging);
          end;
       except
          on E:Exception do
          begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
          end;
       end;

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

 procedure TActiveSIP.UpdateStatusOnHold;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if countSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

          SQL.Clear;
          SQL.Add('select date_time_start from operators_ohhold where date_time_stop is NULL and sip = '+#39+IntToStr(listOperators[i].sip_number)+#39);
          Active:=True;

         try
            if Fields[0].Value = Null then  begin
              listOperators[i].isOnHold:=False;
              listOperators[i].onHoldStartTime:='';
            end
            else begin
              listOperators[i].isOnHold:=True;
              listOperators[i].onHoldStartTime:=VarToStr(Fields[0].Value);
            end;
         except
            on E:Exception do
            begin
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

              UpdateStatus;
              UpdateStatusDelay;
            end;
         end;

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



 procedure TActiveSIP.updateTalkTime;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

        if listOperators[i].sip_number <> -1 then begin

           SQL.Clear;
           SQL.Add('select talk_time from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+IntToStr(listOperators[i].sip_number)+#39+' and answered=''1'' and hash is null limit 1');
           Active:=True;

           try
              if Fields[0].Value = Null then  begin
                listOperators[i].talk_time:='';
              end
              else begin
                listOperators[i].talk_time:=VarToStr(Fields[0].Value);
              end;
           except
              on E:Exception do
              begin
                FreeAndNil(ado);
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                end;

                updateTalkTime;
              end;
           end;

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



 procedure TActiveSIP.updateOnline;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

        if listOperators[i].sip_number <> -1 then begin

            // нет смысла проверять т.к. его тупо нет в списке
            if not isExistOperatorInLastActiveBD(listOperators[i].sip_number) then Continue;

            SQL.Clear;
            SQL.Add('select last_active from active_session where user_id = '+#39+IntToStr(GetListOperators_UserID(i))+#39+' order by last_active DESC limit 1');
            Active:=True;

           try
              if Fields[0].Value <> Null then  begin
                listOperators[i].online.date_online:= VarToDateTime(Fields[0].Value);

                // так же проверим не забыл ли он выйти из дашаборда при выставлении статуса "домой"
                if listOperators[i].status = eHome  then begin

                  if (Round((Now - listOperators[i].online.date_online) * 24 * 60) > cHIDETIME_ListSIPOperators) then begin
                     listOperators[i].online.hide:=True;
                  end
                  else listOperators[i].online.hide:=False;
                end;
              end;
           finally
               ado.Next;
           end;
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



procedure TActiveSIP.updateTalkTimeAll;
 begin
  // обновляем общее время
  updateListTalkTimeAll;
 end;


 // обновление списка активных операторов если увидили нового оператора
 procedure TActiveSIP.checkNewSipOperators(isDashStarted:Boolean = False);
 var
  count_sip:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  notViewGoHome:Boolean;  // не показывать ушедших домой
  operatorsGoHome:TStringList;
  operatorsGoHomeNow:string;
  i:Integer;
  request:TStringBuilder;
  commonQueueSTR:string;  // список с очередями которые видит пользователь
 begin

   // проверяем нужно ли не показывать ушедших домой
    if HomeForm.chkboxGoHome.Checked then notViewGoHome:=True
    else notViewGoHome:=False;

    count_sip:=0; //default
    commonQueueSTR:='';
    
    // проверим первый запуск или нет
    if isDashStarted then begin
      if notViewGoHome=False then GenerateSipOperators(True) // обновить список с активными операторами
      else GenerateSipOperators(True,True);                  // обновить список с активными операторами + не п
      Exit;
    end;


  // проверяем есть ли новые операторы
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

   for i:=0 to m_commonQueue.Count-1 do begin
     if commonQueueSTR='' then commonQueueSTR:=#39+EnumQueueToString(m_commonQueue[i])+#39
     else commonQueueSTR:=commonQueueSTR+','+#39+EnumQueueToString(m_commonQueue[i])+#39;   
   end;
   
   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;

        if notViewGoHome = False then begin

          with request do begin
            Clear;
            Append('select count(distinct sip) as total_unique_sip');
            Append(' from (');
            Append('select sip');
            Append(' from queue');
            Append(' where date_time > '+#39+GetNowDateTime+#39);
            Append(' and sip <> ''-1''');
            Append(' and number_queue in ('+commonQueueSTR+')');
            Append(' union');
            Append(' select sip');
            Append(' from operators_queue');
            Append(' where queue in ('+commonQueueSTR+')');
            Append(') as t');
          end;

         Sql.Add(request.ToString);

         Active:=True;
         if Fields[0].Value<>null then count_sip:=Fields[0].Value;
        end
        else begin

         operatorsGoHome:=getListOperatorsGoHome;
         if operatorsGoHome.Count=0 then begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;

           // TODO попробуем вот так, т.к. ничего не хочет искать
          // if SharedActiveSipOperators.GetCountSipOperators = 0 then GenerateSipOperators(True,True);
           if SharedActiveSipOperators.GetCountSipOperators < 4 then GenerateSipOperators(True,True);

           Exit;
         end;

          if operatorsGoHome.Count<>0 then begin
            operatorsGoHomeNow:='';
            for i:=0 to operatorsGoHome.Count-1 do begin
              if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+IntToStr(_dll_GetOperatorSIP(StrToInt(operatorsGoHome[i])))+#39
              else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+IntToStr(_dll_GetOperatorSIP(StrToInt(operatorsGoHome[i])))+#39;
            end;

            with request do begin
              Clear;
              Append('select count(distinct sip) as total_unique_sip');
              Append(' from (');
              Append('select sip');
              Append(' from queue');
              Append(' where date_time > '+#39+GetNowDateTime+#39);
              Append(' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1''');
              Append(' union');
              Append(' select sip');
              Append(' from operators_queue');
              Append(') as t');
            end;

            SQL.Add(request.ToString);
            if operatorsGoHome<>nil then FreeAndNil(operatorsGoHome);

            Active:=True;
            if Fields[0].Value<>null then count_sip:=Fields[0].Value;
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

   if count_sip <> getCountSipOperators then begin
     if notViewGoHome=False then GenerateSipOperators(True) // обновить список с активными операторами
     else GenerateSipOperators(True,True);                  // обновить список с активными операторами + не показывать ушедших домой
   end;
 end;



 function TActiveSIP.isExistOperatorInQueue(_sip:Integer):Boolean;
 var
  i:Integer;
 begin
   Result:=False;

   for i:=0 to countSipOperators - 1 do begin
     if listOperators[i].sip_number = _sip then begin
         // обновим текущие очереди, вдруг не успели это еще сделать
        listOperators[i].m_queueList.Clear;
        listOperators[i].m_queueList:=GetCurrentQueueOperator(_sip);

        if listOperators[i].m_queueList.Count > 0 then Result:=True;
        Break;
     end;
   end;
 end;


 procedure TActiveSIP.createUserID;
  var
  i:Integer;
 begin
   for i:=0 to countSipOperators-1 do begin
     if listOperators[i].access_dashboard then begin
        if listOperators[i].user_id = -1 then begin
          listOperators[i].user_id:=_dll_GetOperatorSIP(listOperators[i].sip_number);
        end;
     end;
   end;
 end;


// проверка есть ли оператор в таблице active_session
 function TActiveSIP.isExistOperatorInLastActiveBD(_sip:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

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
      SQL.Add('select count(last_active) from active_session where user_id = (select user_id from operators where sip = '+#39+IntToStr(_sip)+#39+')' );
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


function TActiveSIP.isExistOperator(_sip:Integer):Boolean;
 var
  i:Integer;
 begin
   Result:=False;

   for i:=0 to cGLOBAL_ListSIPOperators -1 do begin
     if listOperators[i].sip_number = _sip then begin
        Result:=True;
        Break;
     end;
   end;
 end;


 /////////////////////////////// МЕТОДЫ listOPerators /////////////////////////////////////

function TActiveSIP.GetListOperators_ID(_sip:Integer):Cardinal;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      for i:=0 to countSipOperators - 1 do begin
        if listOperators[i].sip_number = _sip then begin
          Result:=i;
          Break;
        end;
      end;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_UserID(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].user_id;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_OperatorName(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].operator_name;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_SipNumber(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].sip_number;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Status(id:Integer):enumStatusOperators;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].status;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_StatusDelay(id:Integer):enumStatusOperators;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].status_delay;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_AccessDashboad(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].access_dashboard;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_QueueList(id:Integer):TList<enumQueue>;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].m_queueList;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_QueueListSTR(id:Integer):string;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:='';
      for i:=0 to listOperators[id].m_queueList.Count-1 do begin
        if Result='' then Result:=EnumQueueToString(listOperators[id].m_queueList[i])
        else Result:=Result +' и '+ EnumQueueToString(listOperators[id].m_queueList[i]);
      end;

      if listOperators[id].m_queuePaused then begin
        Result:='~('+Result+')';
      end;
    finally
      m_mutex.Release;
    end;
  end;
end;



 // есть ли очередь уже
function TActiveSIP.GetListOperators_QueueListExist(id:Integer; queue:enumQueue):Boolean; 
begin  
 if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].m_queueList.Contains(queue);
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_TalkTime(id:Integer; isReducedTime:Boolean):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      if isReducedTime then Result:=Copy(Self.listOperators[id].talk_time, 4, 5)
      else Result:=Self.listOperators[id].talk_time;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Trunk(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].trunk;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Phone(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].phone;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_IsOnHold(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].isOnHold;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_OnHoldStartTime(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].onHoldStartTime;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_CountTalk(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].count_talk;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_CountProcentTalk(id:Integer):string;
var
 tmp:string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      tmp:=FormatFloat('0.0',Self.listOperators[id].count_procent);
      tmp:=StringReplace(tmp,',','.',[rfReplaceAll]);
      Result:=tmp+'%';
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTimeAll(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].talk_time_all;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTimeAvg(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].talk_time_avg;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_OnlineHide(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].online.hide;
    finally
      m_mutex.Release;
    end;
  end;
end;



 /////////////////////////////// МЕТОДЫ listOPerators  END ////////////////////////////////

function TActiveSIP.IsTalkOperator(_sip:Integer):enumStatus;
var
 i:Integer;
begin
  Result:=eNo;

  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      for i:=0 to Length(listOperators)-1 do begin
        if (_sip = listOperators[i].sip_number) then begin

          if listOperators[i].phone = '' then Result:=eNo
          else Result:=eYes;

          Exit;
        end;
      end;
    finally
      m_mutex.Release;
    end;
  end;


end;


// class TList_ACTIVESIP END



end.
