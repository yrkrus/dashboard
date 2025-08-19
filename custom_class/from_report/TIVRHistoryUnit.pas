 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                Класс для описания истории звонка в IVR                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TIVRHistoryUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, TAutoPodborPeopleUnit;


 // class TIVRHistory
  type
      TIVRHistory = class
      private
      m_people    :TAutoPodborPeople;

      public
      id            :Integer;
      waiting_time  :string;
      phone         :string;
      date_time     :string;
      trunk         :string;
      to_queue      :Boolean;
      phone_operator  :string;
      region        :string;

      constructor Create;                      overload;
      constructor Create(const _call:TIVRHistory);   overload;
      destructor  Destroy; override;

      procedure Clear;
      procedure SetPhonePeople(_phone:string);

      function  Clone: TIVRHistory;

      function GetFIOPeople:string; // отображдение фио звонящего

      end;
 // class TIVRHistory END

implementation



constructor TIVRHistory.Create;
 begin
   inherited;
   m_people:=TAutoPodborPeople.Create;

   Clear;
 end;

 constructor TIVRHistory.Create(const _call:TIVRHistory);
 var
  i:Integer;
 begin
  Create;

  id:=_call.id;
  waiting_time:=_call.waiting_time;
  phone:=_call.phone;
  date_time:=_call.date_time;
  trunk:=_call.trunk;
  to_queue:=_call.to_queue;
  phone_operator:=_call.phone_operator;
  region:=_call.region;

  m_people.Clear;
  m_people.Add(_call.m_people);
 end;

destructor TIVRHistory.Destroy;
begin
  if Assigned(m_people) then m_people.Free;
  inherited;
end;

 procedure TIVRHistory.Clear;
 begin
  id:=0;
  waiting_time:='';
  phone:='';
  date_time:='';
  trunk:='';
  to_queue:=False;
  phone_operator:='';
  region:='';
  if Assigned(m_people) then m_people.Clear;
 end;

procedure TIVRHistory.SetPhonePeople(_phone:string);
begin
  m_people.SetPhone(_phone);
end;

function TIVRHistory.Clone: TIVRHistory;
begin
  // просто возвращаем полную копию
  Result:=TIVRHistory.Create(Self);
end;

function TIVRHistory.GetFIOPeople:string; // отображдение фио звонящего
begin
  Result:=m_people.GetFIO;
end;

end.