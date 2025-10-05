unit Thread_ACTIVESIPUnit;

interface

uses
  System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, Vcl.ComCtrls,
  TLogFileUnit, GlobalVariablesLinkDLL, System.SyncObjs;

type
  Thread_ACTIVESIP = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure Show(var p_ActiveSipOperators:TActiveSIP);
    procedure CriticalError;
    procedure UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);

  private
   m_initThread: TEvent;  // событие что поток успешно стартовал

   Log:TLoggingFile;
   isCheckThreadSipOperators:Boolean; // флаг для первоначальной проверки всех активнх операторов, нужен только при старте дашборда

   // создание submenu
  function CreateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                      i: Integer;
                                      ListView: TListView):TListItem;

  // обновление submenu
  procedure UpdateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                       i: Integer;
                                       ListItem: TListItem);

  public
  constructor Create;
  destructor Destroy; override;
  function WaitForInit(_timeout:Cardinal): Boolean;


  end;


implementation

uses
  FunctionUnit, FormHome, GlobalVariables, TCustomTypeUnit, TXmlUnit, TDebugStructUnit;


constructor Thread_ACTIVESIP.Create;
begin
  inherited Create(True);               // Suspended=true
  FreeOnTerminate := False;
  m_initThread:=TEvent.Create(nil, False, False, '');
end;


destructor Thread_ACTIVESIP.Destroy;
begin
  m_initThread.Free;
  inherited;
end;


function Thread_ACTIVESIP.WaitForInit(_timeout:Cardinal): Boolean;
begin
  if Terminated then Exit(False);
  Result:=(m_initThread.WaitFor(_timeout) = wrSignaled);
end;


procedure Thread_ACTIVESIP.CriticalError;
begin
  // записываем в лог
  Log.Save(messclass+':'+mess,IS_ERROR);
end;


{ Thread_ACTIVESIP }
procedure Thread_ACTIVESIP.UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);
begin
  if not CONNECT_BD_ERROR then begin
    // проверим есть ли новые операторы
    p_ActiveSipOperators.checkNewSipOperators(isCheckThreadSipOperators);

    //  обновим текущие статусы
    p_ActiveSipOperators.UpdateStatus;
    p_ActiveSipOperators.UpdateStatusDelay;
    p_ActiveSipOperators.UpdateStatusOnHold;

    // тут просто найцдем user_id операторов всех у кого есть доступ к дашборду
    // (по факту вызываетмся когда нет этой записи в памяти)
    p_ActiveSipOperators.createUserID;

    // обновим дату последнего онлайна
    p_ActiveSipOperators.updateOnline;
  end;
end;


function Thread_ACTIVESIP.CreateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                                     i: Integer;
                                                     ListView: TListView):TListItem;
var
 ListItem: TListItem;
 TimeAnsweredSeconds:string;
begin

 ListItem := ListView.Items.Add;
 ListItem.Caption := p_ActiveSipOperators.GetListOperators_SipNumber(i);

  // submenu
  begin
    // ===== ИМЯ ОПЕРАТОРА =====
     if p_ActiveSipOperators.GetListOperators_OperatorName(i)<>'null' then
     begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_OperatorName(i)+' ('+p_ActiveSipOperators.GetListOperators_SipNumber(i)+')');
     end
     else begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_SipNumber(i));
     end;


     // ===== СТАТУС =====
     begin
       if p_ActiveSipOperators.GetListOperators_Status(i) = eUnknown then begin // статус 'НЕИЗВЕСТЕН'

         // проверим есть ли доступ к дашборду
         if p_ActiveSipOperators.GetListOperators_AccessDashboad(i) then begin
            // проверим вдруг разговаривал оператор и просто ушел домой
            if isOperatorGoHome(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems.Add(getStatus(eHome))
            else begin
              if isOperatorGoHomeWithForceClosed(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems.Add(getStatus(eHome))
              else ListItem.SubItems.Add('---');
            end;

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name then begin
             // для привязвнной форме
             HomeForm.lblCurrentStatus.Caption:='---';

             // для отвязанонй формы
            // FormOperatorStatus.Caption:='Текущий статус: ---';
            end;
         end
         else begin // доступа к дашборду нет значит это  тип "операторы (доступ без дашборда)"

            // находится ли в очереди
            if p_ActiveSipOperators.GetListOperators_Queue(i) <> queue_null then begin
               if p_ActiveSipOperators.GetListOperators_TalkTime(i,True) <> '' then begin

                 // отложенная команда на смену статуса
                 if p_ActiveSipOperators.GetListOperators_StatusDelay(i) <> eUnknown then begin
                   ListItem.SubItems.Add('разговор → '+ getStatus(p_ActiveSipOperators.GetListOperators_StatusDelay(i)));
                 end
                 else begin
                    ListItem.SubItems.Add('разговор');
                 end;
               end
               else begin
                ListItem.SubItems.Add('доступен');
                Inc(p_ActiveSipOperators.countFreeOperators);
               end;
            end
            else begin
              ListItem.SubItems.Add('домой');

            end;
         end;
       end
       else begin

          // изменяем статус на "разговор", если доступен и разговаривают
          if (p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable) and
             (p_ActiveSipOperators.GetListOperators_Queue(i) <> queue_null) and
             ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

            // проверим вдруг оператор в состоянии onHold
            if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
              ListItem.SubItems.Add('OnHold ('+GetLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');
            end else begin
             // отложенная команда на смену статуса
             if p_ActiveSipOperators.GetListOperators_StatusDelay(i) <> eUnknown then begin
               ListItem.SubItems.Add('разговор → '+ getStatus(p_ActiveSipOperators.GetListOperators_StatusDelay(i)));
             end
             else begin
                ListItem.SubItems.Add('разговор');
             end;
            end;

          end else begin
            // добавляем время сколько сейчас находится оператор в статусе
            if p_ActiveSipOperators.GetListOperators_Status(i) > eHome then begin

              ListItem.SubItems.Add(getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                    +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                    +')');

            end
            else begin
              // проверим вдруг оператор в состоянии onHold (ну типа забыли из него выйти или нечаянно в него вошли)
              if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                ListItem.SubItems.Add('OnHold ('+GetLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');

              end
              else begin
               ListItem.SubItems.Add(getStatus(p_ActiveSipOperators.GetListOperators_Status(i)));

                if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // кол-во свободных операторов
                   Inc(p_ActiveSipOperators.countFreeOperators);
                end;
              end;

            end;
          end;

          if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name then begin
           // для привязвнной форме
           HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

//            // для отвязанонй формы
//            FormOperatorStatus.Caption:='Текущий статус: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
//                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
//                                      +')';

            // скрываем\отображаем кнопки статусов в зависимости от текущего статуса оператора
            checkCurrentStatusOperator(p_ActiveSipOperators.GetListOperators_Status(i));
          end;
       end;
     end;


    // ===== ОТВЕЧЕНО =====
    begin
      if p_ActiveSipOperators.GetListOperators_CountTalk(i) = 0 then ListItem.SubItems.Add('0')
      else begin
        // если обычный оператор\старший не нужно ему показывать %
         if (SharedCurrentUserLogon.Role = role_operator) or (SharedCurrentUserLogon.Role = role_senior_operator) then ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i)))
        else ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')');
      end;
    end;

    // ===== ЛИНИЯ =====
    begin
      if p_ActiveSipOperators.GetListOperators_Trunk(i) = '' then begin
       ListItem.SubItems.Add('---');
      end
      else begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_Trunk(i));
      end;
    end;

    // ===== НОМЕР ТЕЛЕФОНА =====
    begin
      if p_ActiveSipOperators.GetListOperators_Phone(i) = '' then begin
       ListItem.SubItems.Add('---');

      end
      else begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_Phone(i));
       Inc(p_ActiveSipOperators.countActiveCalls);
      end;
    end;

    // ===== ВРЕМЯ РАЗГОВОРА =====
    begin
     if p_ActiveSipOperators.GetListOperators_TalkTime(i,True) = '' then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_TalkTime(i,True));
    end;

    // ===== ОЧЕРЕДЬ =====
    begin
     if p_ActiveSipOperators.GetListOperators_Queue(i) = queue_null then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(EnumQueueToString(p_ActiveSipOperators.GetListOperators_Queue(i)));
    end;

    // ===== ОБЩЕЕ ВРЕМЯ РАЗГОВОРА =====
    begin
     if  p_ActiveSipOperators.GetListOperators_TalkTimeAll(i) = 0 then ListItem.SubItems.Add('00:00:00 | 00:00:00')
     else ListItem.SubItems.Add(GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAvg(i))
                                +' | '
                                +GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAll(i)));

    end;
  end;

end;


procedure Thread_ACTIVESIP.UpdateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                                      i: Integer;
                                                      ListItem: TListItem);

begin
  try
    // submenu
    begin
      // ===== ИМЯ ОПЕРАТОРА =====
       if p_ActiveSipOperators.GetListOperators_OperatorName(i)<>'null' then
       begin
         ListItem.SubItems[0]:=p_ActiveSipOperators.GetListOperators_OperatorName(i)+' ('+p_ActiveSipOperators.GetListOperators_SipNumber(i)+')';
       end
       else begin
         ListItem.SubItems[0]:=p_ActiveSipOperators.GetListOperators_SipNumber(i);
       end;


       // ===== СТАТУС =====
       begin
         if p_ActiveSipOperators.GetListOperators_Status(i) = eUnknown then begin // статус 'НЕИЗВЕСТЕН'

           // проверим есть ли доступ к дашборду
           if p_ActiveSipOperators.GetListOperators_AccessDashboad(i) then begin
              // проверим вдруг разговаривал оператор и просто ушел домой
              if isOperatorGoHome(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems[1]:=getStatus(eHome)
              else begin // проверим вдруг закрыли через "завепшение активной сессии"
                if isOperatorGoHomeWithForceClosed(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems[1]:=getStatus(eHome)
                else ListItem.SubItems[1]:='---';
              end;


              if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name then begin
                 // для привязвнной форме
                 HomeForm.lblCurrentStatus.Caption:='---';

                 // для отвязанонй формы
                // FormOperatorStatus.Caption:='Текущий статус: ---';
              end;
           end
           else begin // доступа к дашборду нет значит это  тип "операторы (доступ без дашборда)"

              // находится ли в очереди
              if p_ActiveSipOperators.GetListOperators_Queue(i) <> queue_null then begin
                 if p_ActiveSipOperators.GetListOperators_TalkTime(i,True) <>'' then begin

                   // отложенная команда на смену статуса
                   if p_ActiveSipOperators.GetListOperators_StatusDelay(i) <> eUnknown then begin
                      ListItem.SubItems[1]:='разговор → '+ getStatus(p_ActiveSipOperators.GetListOperators_StatusDelay(i));
                   end
                   else begin
                      ListItem.SubItems[1]:='разговор';
                   end;

                 end
                 else begin
                  ListItem.SubItems[1]:='доступен';
                  Inc(p_ActiveSipOperators.countFreeOperators);
                 end;
              end
              else begin
                ListItem.SubItems[1]:='домой';

              end;
           end;
         end
         else begin

            // изменяем статус на "разговор", если доступен и разговаривают
            if (p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable) and
               (p_ActiveSipOperators.GetListOperators_Queue(i) <> queue_null) and
               ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

              // проверим вдруг оператор в состоянии onHold
              if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                ListItem.SubItems[1]:='OnHold ('+GetLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')';

              end else begin
                // отложенная команда на смену статуса
                 if p_ActiveSipOperators.GetListOperators_StatusDelay(i) <> eUnknown then begin
                    ListItem.SubItems[1]:='разговор → '+ getStatus(p_ActiveSipOperators.GetListOperators_StatusDelay(i));
                 end
                 else begin
                    ListItem.SubItems[1]:='разговор';
                 end;
              end;

            end else begin
              // добавляем время сколько сейчас находится оператор в статусе
              if p_ActiveSipOperators.GetListOperators_Status(i) > eHome then begin

                ListItem.SubItems[1]:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

              end
              else begin
                // проверим вдруг оператор в состоянии onHold (ну типа забыли из него выйти или нечаянно в него вошли)
                if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                  ListItem.SubItems[1]:='OnHold ('+GetLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')';
                end
                else begin
                 ListItem.SubItems[1]:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i));

                  if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // кол-во свободных операторов
                     Inc(p_ActiveSipOperators.countFreeOperators);
                  end;
                end;

              end;
            end;

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name then begin
             // для привязвнной форме
             HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                        +')';
             // для отвязанонй формы
//             FormOperatorStatus.Caption:='Текущий статус: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
//                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
//                                        +')';

              // скрываем\отображаем кнопки статусов в зависимости от текущего статуса оператора
              checkCurrentStatusOperator(p_ActiveSipOperators.GetListOperators_Status(i));
            end;
         end;
       end;


      // ===== ОТВЕЧЕНО =====
      begin
        if p_ActiveSipOperators.GetListOperators_CountTalk(i) = 0 then ListItem.SubItems[2]:='0'
        else begin
         // если обычный оператор\старший не нужно ему показывать %
         if (SharedCurrentUserLogon.Role = role_operator) or (SharedCurrentUserLogon.Role = role_senior_operator) then ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))
         else ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')';
        end;
      end;

      // ===== ЛИНИЯ =====
      begin
        if p_ActiveSipOperators.GetListOperators_Trunk(i) = '' then begin
          ListItem.SubItems[3]:='---';

        end
        else begin
         ListItem.SubItems[3]:=p_ActiveSipOperators.GetListOperators_Trunk(i);
        end;
      end;


      // ===== НОМЕР ТЕЛЕФОНА =====
      begin
        if p_ActiveSipOperators.GetListOperators_Phone(i) = '' then begin
          ListItem.SubItems[4]:='---';

        end
        else begin
         ListItem.SubItems[4]:=p_ActiveSipOperators.GetListOperators_Phone(i);
         Inc(p_ActiveSipOperators.countActiveCalls);
        end;
      end;

      // ===== ВРЕМЯ РАЗГОВОРА =====
      begin
       if p_ActiveSipOperators.GetListOperators_TalkTime(i,True) = '' then ListItem.SubItems[5]:='---'
       else ListItem.SubItems[5]:=p_ActiveSipOperators.GetListOperators_TalkTime(i,True);
      end;

      // ===== ОЧЕРЕДЬ =====
      begin
       if p_ActiveSipOperators.GetListOperators_Queue(i) = queue_null then ListItem.SubItems[6]:='---'
       else ListItem.SubItems[6]:=EnumQueueToString(p_ActiveSipOperators.GetListOperators_Queue(i));
      end;

      // ===== ОБЩЕЕ ВРЕМЯ РАЗГОВОРА =====
      begin
       if  p_ActiveSipOperators.GetListOperators_TalkTimeAll(i) = 0 then ListItem.SubItems[7]:='00:00:00 | 00:00:00'
       else ListItem.SubItems[7]:=GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAvg(i))
                                  +' | '
                                  +GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAll(i));

      end;
    end;

  finally
//   HomeForm.ListViewSIP.Items.EndUpdate;
  end;

end;

procedure Thread_ACTIVESIP.Show(var p_ActiveSipOperators:TActiveSIP);
var
 i:Integer;
 ListItem: TListItem;
 countActiveSipOperators:Integer;
 existingItem: TListItem;
 idToFind:string;
begin
  with HomeForm do begin

    try
      countActiveSipOperators:=p_ActiveSipOperators.getCountSipOperators;

       if countActiveSipOperators = 0 then begin
         STlist_ACTIVESIP_NO_Rings.Visible:=True;
       end
       else begin
         STlist_ACTIVESIP_NO_Rings.Visible:=False;
       end;


        // Проходим по всем операторам
        for i:=0 to countActiveSipOperators-1 do
        begin
          idToFind := p_ActiveSipOperators.GetListOperators_SipNumber(i);
          existingItem := nil;

          // Поиск существующего элемента по id
          for ListItem in ListViewSIP.Items do
          begin
            if ListItem.Caption = idToFind then
            begin
              existingItem := ListItem;
              Break;
            end;
          end;

          if existingItem = nil then
          begin
            // Элемент не найден, добавляем новый
            ListItem:=CreateListSubMenuItems(p_ActiveSipOperators, i, ListViewSIP);
          end
          else
          begin
            // Обновляем существующий элемент
            UpdateListSubMenuItems(p_ActiveSipOperators, i, existingItem);
          end;
        end;

        // отображаем кол-во активных\свободных операторов
         p_ActiveSipOperators.showActiveAndFreeOperatorsForm;

        // Удаляем элементы, которые отсутствуют в новых данных
        for i:= ListViewSIP.Items.Count - 1 downto 0 do
        begin
           if not p_ActiveSipOperators.isExistOperator(ListViewSIP.Items[i].Caption) then
           begin
             try
               ListViewSIP.Items.Delete(i);
             except
              on E:Exception do
              begin
               Log.Save(e.ClassName+' : '+E.Message, IS_ERROR);
              end;
             end;
           end;
        end;

     except
      on E:Exception do
      begin
       messclass:=e.ClassName;
       mess:=e.Message;

       Synchronize(CriticalError);
      end;
    end;
  end;
end;

procedure Thread_ACTIVESIP.Execute;
const
 NAME_THREAD:string       = 'Thread_ActiveSip';
 cDEF_SLEEP_TIME:Word     = 1000;
 cSTATIC_CKIP_CHECK:Word  = 10; // 10 раз не проверяем скорость
var
  StartTime, EndTime  :Cardinal;

  Duration            :Cardinal;
  debugInfo           :TDebugStruct;

  defSLEEP_TIME       :Word; // default sleep time
  avgTIME             :Integer; // среднее значение потока
  skipCheck           :Word;
begin
  inherited;
  CoInitialize(Nil);
  Duration:=0;

  defSLEEP_TIME:=cDEF_SLEEP_TIME;
  avgTIME:=0;
  skipCheck:=0;

  Log:=TLoggingFile.Create(NAME_THREAD);

  // вывод debug info
  try
     debugInfo:=TDebugStruct.Create(NAME_THREAD,Log);
     SharedCountResponseThread.Add(debugInfo);
  except
    on E:Exception do
    begin
     messclass:=e.ClassName;
     mess:=e.Message;
     Synchronize(CriticalError);
    end;
  end;

  // добавляем ссылку на Log в класс
  SharedActiveSipOperators.AddLinkLogFile(Log);

  // default при первом запуске
  isCheckThreadSipOperators:=True;

  // событие что запустились
   m_initThread.SetEvent;

  while not Terminated do
  begin

    if UpdateACTIVESIPSTOP then  begin

     try
        StartTime:=GetTickCount;
        UpdateActiveSipOperators(SharedActiveSipOperators);

        //отображаем что у нас по операторам на главной форме
        Show(SharedActiveSipOperators);

        // отображаем кол-во скрытых операторов если установлен параметр "не показывать ушедших домой"
        SharedActiveSipOperators.showHideOperatorsForm;

        EndTime:=GetTickCount;
        Duration:=EndTime-StartTime;

        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);

        // проверили орераторов
        if isCheckThreadSipOperators then isCheckThreadSipOperators:=False;

        if skipCheck <= cSTATIC_CKIP_CHECK then Inc(skipCheck);

     except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
      end;
    end;

    // сверим среднее значение (Добавлена автоматическая оптимизация запросов к серверу в зависимости от нагрузки на оперативную память клиентского ПК)
    if skipCheck>=cSTATIC_CKIP_CHECK then begin
      avgTIME:=SharedCountResponseThread.GetAverageTime(NAME_THREAD);

      if avgTIME > defSLEEP_TIME then begin
         defSLEEP_TIME:=avgTIME;

         if defSLEEP_TIME > cDEF_SLEEP_TIME then Sleep(defSLEEP_TIME-cDEF_SLEEP_TIME)
         else sleep(defSLEEP_TIME);
      end
      else
      begin
       defSLEEP_TIME:=cDEF_SLEEP_TIME;
       if Duration<defSLEEP_TIME then Sleep(defSLEEP_TIME-Duration);
      end;
    end;
  end;
end;

end.
