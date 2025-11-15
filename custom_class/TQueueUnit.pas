/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания Queue                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TQueueUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
      Graphics, System.SyncObjs, IdException,  GlobalVariablesLinkDLL, TCustomTypeUnit,
      System.Generics.Collections;

  // class TQueueStruct
 type
      TQueueStruct = class
      public
      id                    : Integer;  // id по БД
      phone                 : string;   // номер телефона
      waiting_time_start    : string;   // стартовое значение времени ожидание
      m_queue               : enumQueue;   // номер очереди
      trunk                 : string;   // транкс с которого звонок

      constructor Create;                  overload;
      procedure Clear;

      end;
   // class TQueueStruct END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TQueue
 type
      TQueue = class
      const
      cGLOBAL_ListQueue                   : Word =  100; // длинна массива

      private
      m_count                             : Integer;
      m_mutex                             : TMutex;

      function GetCountQueueList(const _queueList:TList<enumQueue>)         : Integer;
      function GetExistShowAccess(_id:Integer; _queueList:TList<enumQueue>) : Boolean;  // есть ли доступ на просмотр звонка в зависимости от прав доступа очереди

      public
      m_list                     : TArray<TQueueStruct>;

      constructor Create;                  overload;
      destructor Destroy;                  override;

      procedure Clear;
      procedure UpdateData;                             // обновление данных в массиве listActiveQueue + count
      function isExist(id:Integer)        :Boolean;   // проверка существует ли такой номер в отображении

      property Count:Integer read m_count;


      property CountQueueList[const _queueList:TList<enumQueue>]:Integer read GetCountQueueList;
      property IsExistShowAccess[_id:Integer;_queueList:TList<enumQueue>]:Boolean read GetExistShowAccess;


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
   id:=0;
   phone:='';
   waiting_time_start:='';
   m_queue:=queue_null;
   trunk:='';
 end;

constructor TQueue.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TQueue');
    m_count:=0;

   SetLength(m_list,cGLOBAL_ListQueue);
   for i:=0 to cGLOBAL_ListQueue-1 do m_list[i]:=TQueueStruct.Create;

   // получим данные
   UpdateData;
 end;

destructor TQueue.Destroy;
var
 i: Integer;
begin
  for i:=Low(m_list) to High(m_list) do FreeAndNil(m_list[i]);
  m_mutex.Free;

  inherited;
end;


 procedure TQueue.Clear;
 var
 i: Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(m_list) to High(m_list) do m_list[i].Clear;
  finally
    m_mutex.Release;
  end;
 end;


function TQueue.isExist(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:= 0 to Count - 1 do
  begin
    if m_list[i].id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;


function TQueue.GetCountQueueList(const _queueList:TList<enumQueue>):Integer;
 var
  i:Integer;
  count:Integer;
  j:Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    count:=0;
     for i := Low(m_list) to High(m_list) do begin
      if m_list[i].id<>0 then begin

         // подсчет только если у пользака есть на это права
         for j:=0 to _queueList.Count-1 do begin
           if m_list[i].m_queue = _queueList[j] then begin
             Inc(count);
             Break;
           end;
         end;
      end;
     end;

    Result:=count;
  finally
    m_mutex.Release;
  end;
 end;


// есть ли доступ на просмотр звонка в зависимости от прав доступа очереди
function TQueue.GetExistShowAccess(_id:Integer; _queueList:TList<enumQueue>):Boolean;
var
 i:Integer;
begin
  Result:=False; //default

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to _queueList.Count-1 do begin
      if m_list[_id].m_queue = _queueList[i] then begin
        Result:=True;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
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
 request:TStringBuilder;
 call_id:string;
 begin
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

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with request do begin
        Clear;
        Append('select count(phone) from queue ');
       // Append(' where date_time > '+#39+GetNowDateTimeDec(cTimeResponse)+#39);
       // Append(' and fail = ''0'' and sip = ''-1'' and hash is NULL');
        Append(' where fail = ''0'' and sip = ''-1'' and hash is NULL');
      end;

      SQL.Add(request.ToString);

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
              FreeAndNil(request);
            end;
            Exit;
          end;
      end;

       // очищаем весь список
       Clear;
       if countQueue = 0 then begin
         m_count:=countQueue;

         FreeAndNil(ado);
         serverConnect.Close;
         FreeAndNil(serverConnect);
         Exit;
       end;

       if countQueue<>0 then begin

          SQL.Clear;
          with request do begin
            Clear;
            Append('select id,phone,waiting_time,number_queue from queue ');
//            Append(' where date_time > '+#39+GetNowDateTimeDec(cTimeResponse)+#39);
//            Append(' and fail = ''0'' and sip = ''-1'' and hash is NULL');
            Append(' where fail = ''0'' and sip = ''-1'' and hash is NULL');
          end;

          SQL.Add(request.ToString);

          Active:=True;

          for i:=0 to countQueue-1 do begin
            try
              if (Fields[0].Value <> null) and
                 (Fields[1].Value <> null) and
                 (Fields[2].Value <> null) and
                 (Fields[3].Value <> null)
                then begin
                m_list[i].id:=StrToInt(VarToStr(Fields[0].Value));
                m_list[i].phone:=VarToStr(Fields[1].Value);
                m_list[i].waiting_time_start:=VarToStr(Fields[2].Value);
                m_list[i].m_queue:= StringToEnumQueue(VarToStr(Fields[3].Value));
                try
                  call_id:=_dll_GetCallIDPhoneIVR(eTableIVR,m_list[i].phone);
                  m_list[i].trunk:=_dll_GetPhoneTrunkQueue(eTableIVR,m_list[i].phone,call_id);
                except
                  m_list[i].trunk:='null';
                end;
              end;
            finally
               ado.Next;
            end;
          end;
       end;

       m_count:=countQueue;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
 end;


end.
