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
  System.Classes, System.SysUtils, TCustomTypeUnit;


 // class TIVRHistory
  type
      TIVRHistory = class
      public
      id        :Integer;
      phone     :string;
      date_time :string;
      trunk     :string;
      to_queue  :Boolean;
     //  to_robot   :Boolean;
      phone_operator  :string;
      region    :string;

      constructor Create;                      overload;
      constructor Create(_call:TIVRHistory);   overload;

      procedure Clear;
      function Clone(_call:TIVRHistory):TIVRHistory;

      end;
 // class TIVRHistory END

implementation

constructor TIVRHistory.Create;
 begin
   inherited;
   Clear;
 end;

 constructor TIVRHistory.Create(_call:TIVRHistory);
 begin
  Self.id:=_call.id;
  Self.phone:=_call.phone;
  Self.date_time:=_call.date_time;
  Self.trunk:=_call.trunk;
  Self.to_queue:=_call.to_queue;
  Self.phone_operator:=_call.phone_operator;
  Self.region:=_call.region;
 end;

 procedure TIVRHistory.Clear;
 begin
  id:=0;
  phone:='';
  date_time:='';
  trunk:='';
  to_queue:=False;
  phone_operator:='';
  region:='';
 end;

function TIVRHistory.Clone(_call:TIVRHistory):TIVRHistory;
begin
  Result:=TIVRHistory.Create;

  Result.id:=_call.id;
  Result.phone:=_call.phone;
  Result.date_time:=_call.date_time;
  Result.trunk:=_call.trunk;
  Result.to_queue:=_call.to_queue;
  Result.phone_operator:=_call.phone_operator;
  Result.region:=_call.region;
end;

end.