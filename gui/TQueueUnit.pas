/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания Queue                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TQueueUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants, Graphics, System.SyncObjs, IdException;

  // class TQueueStruct
 type
      TQueueStruct = class
      public
      id                                   : Integer; // id по БД
      phone                                : string;  // номер телефона
      waiting_time_start                   : string;  // стартовое значение времени ожидание
      queue                                : string;  // номер очереди

      constructor Create;                  overload;
      procedure Clear;

      end;
   // class TQueueStruct END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TQueue
 type
      TQueue = class
      const
      cGLOBAL_ListQueue                    : Word =  100; // длинна массива

      public
      listActiveQueue                      : array of TQueueStruct;


      constructor Create;                   overload;
      destructor Destroy;                   override;

      function GetCount                    : Integer;
      procedure Clear;
      procedure UpdateData;                             // обновление данных в массиве listActiveQueue + count
      function isExist(id:Integer)         :Boolean;   // проверка существует ли такой номер в отображении

      private
      count                                : Integer;
      m_mutex                              : TMutex;

      end;
   // class TQueue END


implementation

uses
  FunctionUnit, GlobalVariables;



constructor TQueueStruct.Create;
 begin
   inherited;
   Clear;
 end;


 procedure TQueueStruct.Clear;
 begin
   Self.id:=0;
   Self.phone:='';
   Self.waiting_time_start:='';
   Self.queue:='';
 end;

constructor TQueue.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TQueue');
    count:=0;

   SetLength(listActiveQueue,cGLOBAL_ListQueue);
   for i:=0 to cGLOBAL_ListQueue-1 do listActiveQueue[i]:=TQueueStruct.Create;

   // получим данные
   UpdateData;
 end;

destructor TQueue.Destroy;
var
 i: Integer;
begin
  for i:=Low(listActiveQueue) to High(listActiveQueue) do FreeAndNil(listActiveQueue[i]);
  m_mutex.Free;

  inherited;
end;


 function TQueue.GetCount;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.count;
  finally
    m_mutex.Release;
  end;
 end;

 procedure TQueue.Clear;
 var
 i: Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveQueue) to High(listActiveQueue) do listActiveQueue[i].Clear;
  finally
    m_mutex.Release;
  end;
 end;


function TQueue.isExist(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:= 0 to GetCount - 1 do
  begin
    if listActiveQueue[i].id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;

 procedure TQueue.UpdateData;
 const
  cTimeResponse:Word = 45; // время которое просматривается
 var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countQueue:Integer;
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
      SQL.Add('select count(phone) from queue where date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39+' and fail = ''0'' and sip = ''-1'' and hash is NULL');

      Active:=True;
      if Fields[0].Value<>null then countQueue:=Fields[0].Value;

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

       // очищаем весь список
       Clear;
       if countQueue = 0 then begin
         count:=countQueue;

         FreeAndNil(ado);
         serverConnect.Close;
         FreeAndNil(serverConnect);
         Exit;
       end;

       if countQueue<>0 then begin

          SQL.Clear;
          SQL.Add('select id,phone,waiting_time,number_queue from queue where date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39+' and fail = ''0'' and sip = ''-1'' and hash is NULL');

          Active:=True;

          for i:=0 to countQueue-1 do begin
            try
              if (Fields[0].Value <> null) and
                 (Fields[1].Value <> null) and
                 (Fields[2].Value <> null) and
                 (Fields[3].Value <> null)
                then begin
                listActiveQueue[i].id:=StrToInt(VarToStr(Fields[0].Value));
                listActiveQueue[i].phone:=VarToStr(Fields[1].Value);
                listActiveQueue[i].waiting_time_start:=VarToStr(Fields[2].Value);
                listActiveQueue[i].queue:=VarToStr(Fields[3].Value);
              end;
            finally
               Next;
            end;
          end;
       end;

       count:=countQueue;
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
