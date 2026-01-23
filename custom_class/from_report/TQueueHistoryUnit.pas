 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            Класс для описания истории звонка в очереди                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TQueueHistoryUnit;

interface

uses
    System.Classes, System.SysUtils, TCustomTypeUnit, TAutoPodborPeopleUnit;


 // class TQueueHistory
  type
      TQueueHistory = class
      private
      m_people          :TAutoPodborPeople;

      procedure Clear;

      public
      id                :Integer;            // id по БД
      number_queue      :enumQueue;   // номер очереди
      phone             :string;             // номер тедефона с которым разговор был
      waiting_time      :string;             // ожидание в очереди перед ответом
      date_time         :TDateTime;          // дата\время
      sip               :Integer;            // sip оператора
      talk_time         :string;             // время разговора
      operatorFIO       :string;             // фио оператора
      trunk             :string;             // транк с которого поступил звонок
      phone_operator    :string;             // оператор
      region            :string;             // регион
      onHold            :Integer;            // OnHold(сек)

      constructor Create(_createPeople:Boolean = False);                   overload;
      procedure SetPhonePeople(_phone:string; _internalCall:boolean);
      function GetFIOPeople:string; // отображдение фио звонящего


      end;
 // class TQueueHistory END

implementation


constructor TQueueHistory.Create(_createPeople:Boolean);
 begin
   if _createPeople then m_people:=TAutoPodborPeople.Create;

   Clear;
 end;


procedure TQueueHistory.Clear;
begin
  id:=0;
  number_queue:=queue_null;
  phone:='';
  waiting_time:='';
  date_time:=0;
  sip:=0;
  talk_time:='';
  operatorFIO:='';
  trunk:='';
  phone_operator:='';
  region:='';
  onHold:=0;

  if Assigned(m_people) then m_people.Clear;
end;


procedure TQueueHistory.SetPhonePeople(_phone:string; _internalCall:boolean);
begin
  if not m_people.IsInit then begin
    FreeAndNil(m_people);
    m_people:=TAutoPodborPeople.Create(_phone, _internalCall);
  end
  else begin
   m_people.Clear;
   m_people.SetPhone(_phone,_internalCall);
  end;
end;

function TQueueHistory.GetFIOPeople:string; // отображдение фио звонящего
begin
  Result:=m_people.GetFIO;
end;

end.