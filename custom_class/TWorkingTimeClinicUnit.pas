 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///               Класс для описания времени работы клиник                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TWorkingTimeClinicUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.Win.ADODB,
  System.Variants,
  Data.DB,
  TCustomTypeUnit;


    type
     TWorkingStruct = class
     public
     m_monday       :string;
     m_tuesday      :string;
     m_wednesday    :string;
     m_thursday     :string;
     m_friday       :string;
     m_saturday     :string;
     m_sunday       :string;

     constructor Create(_id:Integer; _isExistData:Boolean);                   overload;

     private
     m_id           :Integer;

     procedure SetWorkingTime;   // заполнение данными о времени работы

     end;


 // class TWorkingTimeClinic
  type
      TWorkingTimeClinic = class

      private
      m_address       :string;
      m_id            :integer;


      isExistDataTime     :Boolean;    // есть ли данные по времени работы в БД

      function GetClinicAddress(_id:Integer):string;  // достать адрес клиники
      function IsExistTime(_id:Integer):Boolean;      // есть ли данные по времени работы в БД

      public
      m_time          :TWorkingStruct;

      constructor Create(_id:Integer);       overload;
      procedure SetWorking(_work:enumWorkingTime; _value:string; isOutput:Boolean);
      function GetWorking(_work:enumWorkingTime):string;

      property ExistTime:Boolean read isExistDataTime;
      property ID:Integer read m_id;

      end;
 // class TWorkingTimeClinic END

implementation

uses
  GlobalVariables, FunctionUnit, GlobalVariablesLinkDLL;

// ===============================
// TWorkingStruct


constructor TWorkingStruct.Create(_id:Integer; _isExistData:Boolean);
begin
  m_id:=_id;

  if not _isExistData then begin
    m_monday    :='';
    m_tuesday   :='';
    m_wednesday :='';
    m_thursday  :='';
    m_friday    :='';
    m_saturday  :='';
    m_sunday    :='';
  end
  else SetWorkingTime;  // заполняем даннвыми о работе
end;

// заполнение данными о времени работы
procedure TWorkingStruct.SetWorkingTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select mon,tue,wed,thu,fri,sat,sun from server_ik_worktime where id = '+#39+IntToStr(m_id)+#39);

      Active:=True;
      m_monday    := VarToStr(Fields[0].Value);
      m_tuesday   := VarToStr(Fields[1].Value);
      m_wednesday := VarToStr(Fields[2].Value);
      m_thursday  := VarToStr(Fields[3].Value);
      m_friday    := VarToStr(Fields[4].Value);
      m_saturday  := VarToStr(Fields[5].Value);
      m_sunday    := VarToStr(Fields[6].Value);

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// TWorkingStruct END
// ===============================


// ===============================
// TWorkingTimeClinic

constructor TWorkingTimeClinic.Create(_id:Integer);
begin
  // inherited;
   m_id:=_id;
   m_address:=GetClinicAddress(_id);
   isExistDataTime:=IsExistTime(_id);

   m_time:=TWorkingStruct.Create(_id,isExistDataTime);
end;


function TWorkingTimeClinic.GetClinicAddress(_id:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select address from server_ik where id = '+#39+IntToStr(_id)+#39);

      Active:=True;
      if Fields[0].Value<>null then begin
        Result:=(VarToStr(Fields[0].Value));
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

// есть ли данные по времени работы в БД
function TWorkingTimeClinic.IsExistTime(_id:Integer):Boolean;
begin
  Result:=IsServerIkExistWorkingTime(_id);
end;


procedure TWorkingTimeClinic.SetWorking(_work:enumWorkingTime; _value:string; isOutput:Boolean);
begin
  // выходной
  if isOutput then _value:='output';

  case _work of
   workingtime_Monday:    m_time.m_monday     :=_value;
   workingtime_Tuesday:   m_time.m_tuesday    :=_value;
   workingtime_Wednesday: m_time.m_wednesday  :=_value;
   workingtime_Thursday:  m_time.m_thursday   :=_value;
   workingtime_Friday:    m_time.m_friday     :=_value;
   workingtime_Saturday:  m_time.m_saturday   :=_value;
   workingtime_Sunday:    m_time.m_sunday     :=_value;
  end;
end;


function TWorkingTimeClinic.GetWorking(_work:enumWorkingTime):string;
begin
  case _work of
   workingtime_Monday:    Result:=  m_time.m_monday;
   workingtime_Tuesday:   Result:=  m_time.m_tuesday;
   workingtime_Wednesday: Result:=  m_time.m_wednesday;
   workingtime_Thursday:  Result:=  m_time.m_thursday;
   workingtime_Friday:    Result:=  m_time.m_friday;
   workingtime_Saturday:  Result:=  m_time.m_saturday;
   workingtime_Sunday:    Result:=  m_time.m_sunday;
  end;
end;

// TWorkingTimeClinicUnit END
// ===============================

end.