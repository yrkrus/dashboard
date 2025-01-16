unit Thread_ACTIVESIPUnit;

interface

uses
  System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, Vcl.ComCtrls, TLogFileUnit;

type
  Thread_ACTIVESIP = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure Show(var p_ActiveSipOperators:TActiveSIP);
    procedure CriticalError;
    procedure UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);

  private
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

  end;


implementation

uses
  FunctionUnit, FormHome, FormDEBUGUnit, GlobalVariables, FormOperatorStatusUnit, TCustomTypeUnit, TXmlUnit;



 procedure Thread_ACTIVESIP.CriticalError;
 begin
   // записываем в лог
   Log.Save(messclass+'.'+mess,IS_ERROR);
 end;


{ Thread_ACTIVESIP }
procedure Thread_ACTIVESIP.UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);
var
 XML:TXML;
begin
  if not CONNECT_BD_ERROR then begin
    // проверим есть ли новые операторы
    p_ActiveSipOperators.checkNewSipOperators(isCheckThreadSipOperators);

    //  обновим текущие статусы
    p_ActiveSipOperators.updateStatus;
    p_ActiveSipOperators.updateStatusOnHold;

    // тут просто найцдем user_id операторов всех у кого есть доступ к дашборду
    // (по факту вызываетмся когда нет этой записи в памяти)
    p_ActiveSipOperators.createUserID;

    // обновим дату последнего онлайна
    p_ActiveSipOperators.updateOnline;
  end;

  // обновляем время
  with HomeForm.StatusBar do begin
    Panels[0].Text:=DateTimeToStr(now);
    if GetStatusUpdateService then Panels[1].Text:='Служба обновления: работает'
    else Panels[1].Text:='Служба обновления: не запущена';
  end;

  // текущая версия дашборда + онлайн время
  XML:=TXML.Create(PChar(SETTINGS_XML));
  XML.UpdateLastOnline;

  if XML.isUpdate then begin
   HomeForm.lblNewVersionDashboard.Visible:=True;
   // подкрашиваем надпись
   SetRandomFontColor(HomeForm.lblNewVersionDashboard);
  end;

  XML.Free;
end;


function Thread_ACTIVESIP.CreateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                                     i: Integer;
                                                     ListView: TListView):TListItem;
var
 ListItem: TListItem;
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
            else ListItem.SubItems.Add('неизвестен');

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
             // для привязвнной форме
             HomeForm.lblCurrentStatus.Caption:='неизвестен';

             // для отвязанонй формы
             FormOperatorStatus.Caption:='Текущий статус: неизвестен';
            end;
         end
         else begin // доступа к дашборду нет значит это  тип "операторы (доступ без дашборда)"

            // находится ли в очереди
            if p_ActiveSipOperators.GetListOperators_Queue(i) <> '' then begin
               if p_ActiveSipOperators.GetListOperators_TalkTime(i) <>'' then begin
                 ListItem.SubItems.Add('разговор');

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
             (p_ActiveSipOperators.GetListOperators_Queue(i) <> '') and
             ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

            // проверим вдруг оператор в состоянии onHold
            if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
              ListItem.SubItems.Add('OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');
            end else begin
              ListItem.SubItems.Add('разговор');
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
                ListItem.SubItems.Add('OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');

              end
              else begin
               ListItem.SubItems.Add(getStatus(p_ActiveSipOperators.GetListOperators_Status(i)));

                if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // кол-во свободных операторов
                   Inc(p_ActiveSipOperators.countFreeOperators);
                end;
              end;

            end;
          end;

          if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
           // для привязвнной форме
           HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

            // для отвязанонй формы
            FormOperatorStatus.Caption:='Текущий статус: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

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
         if (SharedCurrentUserLogon.GetRole = role_operator) or (SharedCurrentUserLogon.GetRole = role_lead_operator) then ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i)))
        else ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')');
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
     if p_ActiveSipOperators.GetListOperators_TalkTime(i) = '' then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_TalkTime(i));
    end;

    // ===== ОЧЕРЕДЬ =====
    begin
     if p_ActiveSipOperators.GetListOperators_Queue(i) = '' then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_Queue(i));
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
 //  HomeForm.ListViewSIP.Items.BeginUpdate;

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
              else ListItem.SubItems[1]:='неизвестен';

              if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
                 // для привязвнной форме
                 HomeForm.lblCurrentStatus.Caption:='неизвестен';

                 // для отвязанонй формы
                 FormOperatorStatus.Caption:='Текущий статус: неизвестен';
              end;
           end
           else begin // доступа к дашборду нет значит это  тип "операторы (доступ без дашборда)"

              // находится ли в очереди
              if p_ActiveSipOperators.GetListOperators_Queue(i) <> '' then begin
                 if p_ActiveSipOperators.GetListOperators_TalkTime(i) <>'' then begin
                   ListItem.SubItems[1]:='разговор';

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
               (p_ActiveSipOperators.GetListOperators_Queue(i) <> '') and
               ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

              // проверим вдруг оператор в состоянии onHold
              if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                ListItem.SubItems[1]:='OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')';

              end else begin
                ListItem.SubItems[1]:='разговор';
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
                  ListItem.SubItems[1]:='OnHold ('
                                                  +getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))
                                                  +')';

                end
                else begin
                 ListItem.SubItems[1]:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i));

                  if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // кол-во свободных операторов
                     Inc(p_ActiveSipOperators.countFreeOperators);
                  end;
                end;

              end;
            end;

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
             // для привязвнной форме
             HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                        +')';
             // для отвязанонй формы
             FormOperatorStatus.Caption:='Текущий статус: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                        +')';

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
         if (SharedCurrentUserLogon.GetRole = role_operator) or (SharedCurrentUserLogon.GetRole = role_lead_operator) then ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))
         else ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')';
        end;
      end;


      // ===== НОМЕР ТЕЛЕФОНА =====
      begin
        if p_ActiveSipOperators.GetListOperators_Phone(i) = '' then begin
          ListItem.SubItems[3]:='---';

        end
        else begin
         ListItem.SubItems[3]:=p_ActiveSipOperators.GetListOperators_Phone(i);
         Inc(p_ActiveSipOperators.countActiveCalls);
        end;
      end;

      // ===== ВРЕМЯ РАЗГОВОРА =====
      begin
       if p_ActiveSipOperators.GetListOperators_TalkTime(i) = '' then ListItem.SubItems[4]:='---'
       else ListItem.SubItems[4]:=p_ActiveSipOperators.GetListOperators_TalkTime(i);
      end;

      // ===== ОЧЕРЕДЬ =====
      begin
       if p_ActiveSipOperators.GetListOperators_Queue(i) = '' then ListItem.SubItems[5]:='---'
       else ListItem.SubItems[5]:=p_ActiveSipOperators.GetListOperators_Queue(i);
      end;

      // ===== ОБЩЕЕ ВРЕМЯ РАЗГОВОРА =====
      begin
       if  p_ActiveSipOperators.GetListOperators_TalkTimeAll(i) = 0 then ListItem.SubItems[6]:='00:00:00 | 00:00:00'
       else ListItem.SubItems[6]:=GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAvg(i))
                                  +' | '
                                  +GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAll(i));

      end;
    end;

  finally
  // HomeForm.ListViewSIP.Items.EndUpdate;
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

    countActiveSipOperators:=p_ActiveSipOperators.getCountSipOperators;

     if countActiveSipOperators = 0 then begin
       STlist_ACTIVESIP_NO_Rings.Visible:=True;
     end
     else begin
       STlist_ACTIVESIP_NO_Rings.Visible:=False;
     end;

    try

     // ListViewSIP.Items.BeginUpdate;
     // ListViewSIP.Columns[0].Width:= 0; // Установка ширины в 0 в редких вариантах почему то он без этого параметра оборажается

      // Очищаем ListView перед добавлением новых элементов
     // ListViewSIP.Clear;


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
         if not p_ActiveSipOperators.isExistOperator(ListViewSIP.Items[i].Caption) then ListViewSIP.Items.Delete(i);

      end;

    finally
      //ListViewSIP.Items.EndUpdate;
    end;

  end;
end;

procedure Thread_ACTIVESIP.Execute;
const
 SLEEP_TIME:Word = 1000;
var
  StartTime, EndTime  :Cardinal;
  Duration            :Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(100);

  Log:=TLoggingFile.Create('Thread_ActiveSip');

  // default при первом запуске
  isCheckThreadSipOperators:=True;

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


        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_ACTIVESIP.Caption:=IntToStr(Duration);

        // проверили орераторов
        if isCheckThreadSipOperators then isCheckThreadSipOperators:=False;

     except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);

  end;
end;

end.
