 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///        Класс для описания истории изменения статусов оператора            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit THistoryStatusOperatorsUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB, Data.Win.ADODB, IdException,System.Variants,
  TCustomTypeUnit;

 // class TStatusDuration
 type
    TStatusDuration = class

  public
  m_available   :Cardinal;     // Доступен
  m_exodus      :Cardinal;     // Исход
  m_break       :Cardinal;     // Перерыв
  m_dinner      :Cardinal;     // Обед
  m_postvyzov   :Cardinal;     // Поствызов
  m_studies     :Cardinal;     // Учеба
  m_IT          :Cardinal;     // ИТ
  m_transfer    :Cardinal;     // Переносы
  m_reserve     :Cardinal;     // Резерв
  m_callback    :Cardinal;     // callback
  m_home        :Cardinal;     // Домой

  constructor Create      overload;

 end;

 // class TStatusDuration END



// class THistoryStruct
 type
  THistoryStruct = class

  public
  m_status          :enumLogging;  // тип лога
  m_dateStart       :TDateTime;    // дата начала
  m_dateStop        :TDateTime;    // дата окончвания
  m_duration        :Cardinal;     // длительность статуса

  constructor Create      overload;


  end;
// class THistoryStruct END


 // class THistoryStatusOperators
  type
      THistoryStatusOperators = class
      private
      m_id                    :Integer;
      m_sip                   :Integer;

      m_history               :TArray<THistoryStruct>;
      m_countHistory          :Cardinal;

      m_status                :TStatusDuration;

      procedure CreateArrayHistory;         // создание и заполнение данными истории статусов
      procedure AddCountStatusLogging(_log:enumLogging; _count:Cardinal); // добавление суммароного кол-ва нахождения в статусе



      public
      constructor Create(_id,_sip:Integer);               overload;
      destructor Destroy;                                 override;

      function GetStatus(_id:Cardinal):enumLogging;
      function GetDateStart(_id:Cardinal):TDateTime;
      function GetDateStop(_id:Cardinal):TDateTime;
      function GetDuration(_id:Cardinal):Cardinal;

      function GetCountTimeLogging(_log:enumLogging):string; // общее время нахождения в статусах



      property Count:Cardinal read m_countHistory;

      end;
 // class THistoryStatusOperators END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL;


constructor TStatusDuration.Create;
 begin
   inherited;
  m_available   :=0;
  m_exodus      :=0;
  m_break       :=0;
  m_dinner      :=0;
  m_postvyzov   :=0;
  m_studies     :=0;
  m_IT          :=0;
  m_transfer    :=0;
  m_reserve     :=0;
  m_callback    :=0;
  m_home        :=0;
 end;



constructor THistoryStruct.Create;
 begin
   inherited;

   m_status:=eLog_unknown;
   m_dateStart:=0;
   m_dateStop:=0;
   m_duration:=0;
 end;



constructor THistoryStatusOperators.Create(_id,_sip:Integer);
begin
 // inherited;
  m_id:=_id;
  m_sip:=_sip;

  m_status:=TStatusDuration.Create;

  // заполняем данными
  CreateArrayHistory;

end;


 destructor THistoryStatusOperators.Destroy;
 var
  i:Integer;
 begin
    // Освобождение каждого элемента массива
  for i:= Low(m_history) to High(m_history) do m_history[i].Free; // Освобождаем каждый объект
  // Очистка массива
  SetLength(m_history, 0); // Убираем ссылки на объекты

  inherited Destroy; // Вызов деструктора родительского класса
 end;


function THistoryStatusOperators.GetStatus(_id:Cardinal):enumLogging;
begin
 Result:=m_history[_id].m_status;
end;

function THistoryStatusOperators.GetDateStart(_id:Cardinal):TDateTime;
begin
  Result:=m_history[_id].m_dateStart;
end;

function THistoryStatusOperators.GetDateStop(_id:Cardinal):TDateTime;
begin
   Result:=m_history[_id].m_dateStop;
end;

function THistoryStatusOperators.GetDuration(_id:Cardinal):Cardinal;
begin
  Result:=m_history[_id].m_duration;
end;

// общее время нахождения в статусах
function THistoryStatusOperators.GetCountTimeLogging(_log:enumLogging):string;
var
 countTime:Cardinal;
begin
  Result:='---';

  case _log of
   eLog_available     :countTime := m_status.m_available;        // доступен
   eLog_home          :countTime := m_status.m_home;             // домой
   eLog_exodus        :countTime := m_status.m_exodus;           // исход
   eLog_break         :countTime := m_status.m_break;            // перерыв
   eLog_dinner        :countTime := m_status.m_dinner;           // обед
   eLog_postvyzov     :countTime := m_status.m_postvyzov;        // поствызов
   eLog_studies       :countTime := m_status.m_studies;          // учеба
   eLog_IT            :countTime := m_status.m_IT;               // ИТ
   eLog_transfer      :countTime := m_status.m_transfer;         // переносы
   eLog_reserve       :countTime := m_status.m_reserve;          // резерв
   eLog_callback      :countTime := m_status.m_callback;         // callback
  else
    Exit;
  end;

  Result:= GetTimeAnsweredSecondsToString(countTime);

end;

// создание и заполнение данными истории статусов
procedure THistoryStatusOperators.CreateArrayHistory;
const
  SecsPerDay = 24 * 60 * 60; // 86400 секунд в сутках
var
  ado: TADOQuery;
  serverConnect: TADOConnection;
  i:Integer;
  action:enumLogging;
  actionTime:TDateTime;
begin
  ado := TADOQuery.Create(nil);
  serverConnect := createServerConnect;

  if not Assigned(serverConnect) then
  begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do
    begin
      Connection := serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from logging where user_id = '+#39+IntToStr(m_id)+#39);
      Active := True;
      m_countHistory := Fields[0].Value;

      if m_countHistory = 0 then
      begin
        Exit;
      end;

      SetLength(m_history,m_countHistory);
      for i:=0 to m_countHistory-1 do begin
        m_history[i]:=THistoryStruct.Create;
      end;

      SQL.Clear;
      SQL.Add('select action,date_time from logging where user_id = '+#39+IntToStr(m_id)+#39+' order by date_time ASC');
      Active := True;

      for i := 0 to m_countHistory - 1 do
      begin
        action       :=IntegerToEnumLogging(StrToInt(VarToStr(Fields[0].Value)));
        actionTime   :=StrToDateTime(VarToStr(Fields[1].Value));

        m_history[i].m_status:=action;
        m_history[i].m_dateStart:=actionTime;

        // не сервисный статус
        if not (action in [eLog_add_queue_5000 .. eLog_callback]) then begin
          ado.Next;
          Continue;
        end;

        // добавим время
        ado.Next;
        if i < m_countHistory - 1 then begin
         actionTime   :=StrToDateTime(VarToStr(Fields[1].Value));
         m_history[i].m_dateStop:=actionTime;
         m_history[i].m_duration:=Cardinal(Round((m_history[i].m_dateStop - m_history[i].m_dateStart) * SecsPerDay));

         // подсчитываем общее время нахождения в статусах
          AddCountStatusLogging(action,m_history[i].m_duration);
        end;
      end;

      {
        enumLogging = (  eLog_unknown              = -1,        // неизвестный статус
                    eLog_enter                = 0,         // Вход
                    eLog_exit                 = 1,         // Выход
                    eLog_auth_error           = 2,         // не успешная авторизация
                    eLog_exit_force           = 3,         // Выход (через команду force_closed)
                    eLog_add_queue_5000       = 4,         // добавление в очередь 5000
                    eLog_add_queue_5050       = 5,         // добавление в очередь 5050
                    eLog_add_queue_5000_5050  = 6,         // добавление в очередь 5000 и 5050
                    eLog_del_queue_5000       = 7,         // удаление из очереди 5000
                    eLog_del_queue_5050       = 8,         // удаление из очереди 5050
                    eLog_del_queue_5000_5050  = 9,         // удаление из очереди 5000 и 5050
                    eLog_available            = 10,        // доступен
                    eLog_home                 = 11,        // домой
                    eLog_exodus               = 12,        // исход
                    eLog_break                = 13,        // перерыв
                    eLog_dinner               = 14,        // обед
                    eLog_postvyzov            = 15,        // поствызов
                    eLog_studies              = 16,        // учеба
                    eLog_IT                   = 17,        // ИТ
                    eLog_transfer             = 18,        // переносы
                    eLog_reserve              = 19,        // резерв
                    eLog_create_new_user      = 20,        // создание нового пользователя
                    eLog_edit_user            = 21         // редактирование пользователя
                );
      }
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then
    begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

end;

// добавление суммароного кол-ва нахождения в статусе
procedure THistoryStatusOperators.AddCountStatusLogging(_log:enumLogging; _count:Cardinal);
begin
  case _log of
    eLog_enter                :Exit;       // неизвестный статус (не считаем)
    eLog_exit                 :Exit;       // Выход (не считаем)
    eLog_auth_error           :Exit;       // не успешная авторизация  (не считаем)
    eLog_exit_force           :Exit;       // Выход (через команду force_closed)  (не считаем)
    eLog_add_queue_5000       :m_status.m_available := m_status.m_available + _count;         // добавление в очередь 5000
    eLog_add_queue_5050       :m_status.m_available := m_status.m_available + _count;         // добавление в очередь 5050
    eLog_add_queue_5000_5050  :m_status.m_available := m_status.m_available + _count;         // добавление в очередь 5000 и 5050
    eLog_del_queue_5000       :Exit;         // удаление из очереди 5000  (не считаем)
    eLog_del_queue_5050       :Exit;         // удаление из очереди 5050  (не считаем)
    eLog_del_queue_5000_5050  :Exit;         // удаление из очереди 5000 и 5050(не считаем)
    eLog_available            :m_status.m_available := m_status.m_available + _count;         // доступен
    eLog_home                 :m_status.m_home      := m_status.m_home + _count;              // домой
    eLog_exodus               :m_status.m_exodus    := m_status.m_exodus + _count;            // исход
    eLog_break                :m_status.m_break     := m_status.m_break + _count;             // перерыв
    eLog_dinner               :m_status.m_dinner    := m_status.m_dinner + _count;            // обед
    eLog_postvyzov            :m_status.m_postvyzov := m_status.m_postvyzov + _count;         // поствызов
    eLog_studies              :m_status.m_studies   := m_status.m_studies + _count;           // учеба
    eLog_IT                   :m_status.m_IT        := m_status.m_IT + _count;                // ИТ
    eLog_transfer             :m_status.m_transfer  := m_status.m_transfer + _count;          // переносы
    eLog_reserve              :m_status.m_reserve   := m_status.m_reserve + _count;           // резерв
    eLog_callback             :m_status.m_callback  := m_status.m_callback + _count;          // callback
    eLog_create_new_user      :Exit;         // создание нового пользователя  (не считаем)
    eLog_edit_user            :Exit;         // редактирование пользователя  (не считаем)
  end;
end;
end.