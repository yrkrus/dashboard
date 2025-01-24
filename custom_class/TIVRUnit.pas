/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания IVR                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TIVRUnit;

interface

uses  System.Classes,
      Data.Win.ADODB,
      Data.DB,
      System.SysUtils,
      Variants,
      Graphics,
      System.SyncObjs,
      IdException,
      System.DateUtils;

  // class TIVRStruct
 type
      TIVRStruct = class
      public
      m_id                                   : Integer; // id по БД
      m_phone                                : string;  // номер телефона
      m_waiting_time_start                   : string;  // стартовое значение времени ожидание
      m_trunk                                : string;  // откуда пришел звонок
      m_countNoChange                        : Integer; // кол-во раз сколько не изменилось значение ожидания во времени

      constructor Create;                  overload;
      procedure Clear;                     virtual;

      end;
   // class TIVRStruct END


/////////////////////////////////////////////////////////////////////////////////////////


 // class TIVR
 type
      TIVR = class
      const
      cGLOBAL_ListIVR                      : Word = 100; // длинна массива
      cGLOBAL_DropPhone                    : Word = 3; // кол-во сбросов при котором считается что номер ушел из IVR не дождавшись

      public
      listActiveIVR                        : array of TIVRStruct;

      constructor Create;                   overload;
      destructor Destroy;                   override;


      function Count                      : Integer;

      procedure UpdateData;                             // обновление данных в массиве listActiveIVR
      function isExistActive(id:Integer)   :Boolean;   // проверка существует ли такой номер в отображении
      function isExistDropPhone(id:Integer): Boolean;  // проверка есть ли номер который сбросился из IVR


      private
      m_mutex                               : TMutex;

      procedure ClearActiveAll;
      function GetLastFreeIDStructActiveIVR:Integer;      //свободный  id какой есть в TIVRStruct
      function isChangeWaitingTime(In_m_ID:Integer; InNewTime:string):Boolean; // проверка изменилось ли время
      function GetWaitingTime(In_m_ID:Integer):string;  // нахождение времени ожидания
      function GetStructIVRID(In_m_ID:Integer):Integer; // нахождение номера TIVRStruct по его m_id
      function isExistIDIVRtoBD(In_m_id:Integer):Boolean;  // проверка есть ли еще звонок в IVR по БД
      procedure CheckToQueuePhone;                      // проверка ушел ли у нас в очередь звонок

      end;
   // class TIVR END



implementation

uses
  FunctionUnit, GlobalVariables;



constructor TIVRStruct.Create;
 begin
   inherited;
   Clear;
 end;


 procedure TIVRStruct.Clear;
 begin
   Self.m_id:=0;
   Self.m_phone:='';
   Self.m_waiting_time_start:='';
   Self.m_trunk:='';
   Self.m_countNoChange:=0;
 end;



constructor TIVR.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TIVR');


   SetLength(listActiveIVR,cGLOBAL_ListIVR);
   for i:=0 to cGLOBAL_ListIVR-1 do listActiveIVR[i]:=TIVRStruct.Create;
 end;

destructor TIVR.Destroy;
var
 i: Integer;
begin
  for i := Low(listActiveIVR) to High(listActiveIVR) do FreeAndNil(listActiveIVR[i]);
  m_mutex.Free;

  inherited;
end;


 function TIVR.Count;
 var
  i:Integer;
  count:Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    count:=0;
     for i := Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id<>0 then begin
       // дополнительная проверка чтобы не учитывались звонки которые сбросились
       if listActiveIVR[i].m_countNoChange <= cGLOBAL_DropPhone then Inc(count);
      end;
     end;

    Result:=count;
  finally
    m_mutex.Release;
  end;
 end;



procedure TIVR.ClearActiveAll;
 var
 i: Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do listActiveIVR[i].Clear;
  finally
    m_mutex.Release;
  end;
 end;

//свободный  id какой есть в TIVRStruct
function TIVR.GetLastFreeIDStructActiveIVR:Integer;
 var
 i: Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=0 then begin
        Result:=i;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// проверка изменилось ли время
function TIVR.isChangeWaitingTime(In_m_ID:Integer; InNewTime:string):Boolean;
var
 oldWaiting:string;
begin
 Result:=False;

 oldWaiting:=GetWaitingTime(In_m_ID);
 if oldWaiting='' then Exit;

 // время изменилось
 if oldWaiting<>InNewTime then Result:=True;

end;


// нахождение времени ожидания
function TIVR.GetWaitingTime(In_m_ID:Integer):string;
var
 i:Integer;
begin
 Result:='';
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=In_m_ID then begin
        Result:=listActiveIVR[i].m_waiting_time_start;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// нахождение номера TIVRStruct по его m_id
function TIVR.GetStructIVRID(In_m_ID:Integer):Integer;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=In_m_ID then begin
        Result:=i;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// проверка есть ли еще звонок в IVR по БД
function TIVR.isExistIDIVRtoBD(In_m_id:Integer):Boolean;
const
 cTimeResponse:Word=1;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

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
      SQL.Add('select count(id) from ivr where to_queue=''0'' and date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39+' and id='+#39+IntToStr(In_m_id)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
       if StrToInt(VarToStr(Fields[0].Value)) <> 0 then Result:=True;
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

 // проверка ушел ли у нас в очередь звонок
 procedure TIVR.CheckToQueuePhone;
 var
  i:Integer;
 begin
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id <> 0 then begin
      if not isExistIDIVRtoBD(listActiveIVR[i].m_id) then
      begin
        // удаляем из памяти
        listActiveIVR[i].Clear;
      end;
    end;
  end;
 end;


function TIVR.isExistActive(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;

// проверка есть ли номер который сбросился из IVR
function TIVR.isExistDropPhone(id:Integer): Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id = id then
    begin
      if listActiveIVR[i].m_countNoChange>cGLOBAL_DropPhone then begin
        Result:=True;
        Break;
      end;
    end;
  end;
end;



 procedure TIVR.UpdateData;
 const
  cTimeResponse:Word = 1; // время которое просматривается
 var
 i,j:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countIVR:Integer;
 addListActive:Boolean;   // разрешено добавить в listActive! = true
 id:Integer;

 freeIDStructIVR:Integer; // свободный ID
 currentIDStructIVR:Integer;  // текущий просматриваемый ID
 begin
  countIVR:=0;

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
      SQL.Add('select count(phone) from ivr where to_queue=''0'' and date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39);


      Active:=True;
      if Fields[0].Value<>null then countIVR:=Fields[0].Value;

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

       if countIVR>=1 then begin

          SQL.Clear;
          SQL.Add('select id,phone,waiting_time,trunk from ivr where to_queue=''0'' and  date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39);

          Active:=True;

          for i:=0 to countIVR-1 do begin

            try
              if (Fields[0].Value = null) or
                 (Fields[1].Value = null) or
                 (Fields[2].Value = null) or
                 (Fields[3].Value = null)
              then begin
               ado.Next;
               Continue;
              end;


              // проверим не ушел ли у нас в очередь звонок
              CheckToQueuePhone;


              // проверим есть ли такой id уже у нас
              if isExistActive(StrToInt(VarToStr(Fields[0].Value))) then begin
                 currentIDStructIVR:=GetStructIVRID(StrToInt(VarToStr(Fields[0].Value)));

                 // проверим изменилось ли время
                 if isChangeWaitingTime(StrToInt(VarToStr(Fields[0].Value)),VarToStr(Fields[2].Value)) then begin
                   // обновим время
                   listActiveIVR[currentIDStructIVR].m_waiting_time_start:=VarToStr(Fields[2].Value);   //Copy(VarToStr(Fields[2].Value), 4, 5);
                   listActiveIVR[currentIDStructIVR].m_countNoChange:=0;
                 end
                 else begin // время не изменилось значит надо увеличить счетчик
                   Inc(listActiveIVR[currentIDStructIVR].m_countNoChange);
                 end;

              end
              else begin
                // найдем свободный ID
                freeIDStructIVR:=GetLastFreeIDStructActiveIVR;

                 begin // тут первый запуск, чтобы были какие то данные которые будем проверять
                  listActiveIVR[freeIDStructIVR].m_id:=StrToInt(VarToStr(Fields[0].Value));
                  listActiveIVR[freeIDStructIVR].m_phone:=VarToStr(Fields[1].Value);
                  listActiveIVR[freeIDStructIVR].m_waiting_time_start:=VarToStr(Fields[2].Value); //Copy(VarToStr(Fields[2].Value), 4, 5);
                  listActiveIVR[freeIDStructIVR].m_trunk:=VarToStr(Fields[3].Value);
                 end;
              end;

            finally
               ado.Next;
            end;
          end;
       end else begin
         // очищаем весь список
         if Count<>0 then ClearActiveAll;
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


end.
