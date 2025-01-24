/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///      Класс для описания подсчета кол-ва отвеченных звонков из очереди     ///
///                     с разбивкой по времени ответа                         ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TAnsweredQueueUnit;

interface

uses  System.Classes,
      Data.Win.ADODB,
      Data.DB,
      System.SysUtils,
      Variants,
      Graphics,
      TCustomTypeUnit,
      Vcl.Forms,
      StdCtrls;


   // class TStructAnswered_list
  type
      TStructAnswered_list = class
      public
      id                                     :Integer;
      queue                                  :enumQueueCurrent;
      waiting_time                           :string;
      talk_time                              :string;


      constructor Create;                     overload;

      end;
 // class TStructAnswered_list END




   // class TStructAnswered
  type
      TStructAnswered = class
      public
      count                                 : Integer;      // кол-во отвеченных
      list_id                               : TStringList;  // список с ID просмотренными
      list_answered_time                    : TStringList;  // список с отвеченными звонками       

      constructor Create;                     overload;
      destructor Destroy;                     override;

      procedure updateCount;                                // обновление кол-ва найденных звонков
      procedure Clear;                                      // очистка от всех данных


      end;
 // class TStructAnswered END



  // class TAnsweredQueue
  type
      TAnsweredQueue = class
      public
      list                                  : array of TStructAnswered; // список
      updateAnsweredNow                     : Boolean;                  // нужно ли обновить весь свписок

      function getCountAllAnswered          : Integer;                  // всего отвечено
      function isExistNewAnswered           : Boolean;                  // есть ли новые отвеченные по БД
      function getCountMaxAnswered          : Integer;                  // максимальное время ожидания

      constructor Create;                     overload;
      destructor  Destroy;                    overload;

      procedure updateAnswered;                                         // обновление отвеченных
      procedure showAnswered;                                           // показываем кол-во
      procedure Clear;                                                  // очитска от всех текущих данных

      private
      m_maxAnsweredTime                   :Integer;     // (время) максимальное время ожидания в очереди
      m_maxAnsweredID                     :Integer;     // (id по БД) ID этого звонка
      SL                                  :Double;      // текущее значение SL = 0.0   ↑↓

      function isExistAnsweredId(id:Integer): Boolean;                  // есть ли такой id в памяти
      procedure addAnswered(id,answered_time:Integer);                  // добавление в память
      procedure FindMaxAnsweredTime;                  // нахождене максимального времени ожидания в очереди
      procedure ShowSL(InNewSL:Double);               // отображение нового SL
      function GetProcent(InNewProcent:Double; isShowDelimiter:Boolean = true):string; overload;     // отображение процента в заивисимости от того какой результат по процентам


      end;
 // class TAnsweredQueue END


const
   cGLOBAL_ListAnswered: Word   = 4;    // константа для массива из TStructAnswered

implementation

uses
  FunctionUnit, FormHome, GlobalVariables;


 constructor TStructAnswered_list.Create;
 begin
    inherited;
    id:=0;
    queue:=queue_null;
 end;


 constructor TStructAnswered.Create;
 begin
   inherited;
   Self.count:=0;
   Self.list_answered_time:=TStringList.Create;
   Self.list_id:=TStringList.Create;
 end;

destructor TStructAnswered.Destroy;
begin
  list_id.Free;             // Освобождение TStringList
  list_answered_time.Free;  // Освобождение TStringList
  inherited Destroy;        // Вызов деструктора родительского класса
end;


 procedure TStructAnswered.Clear;
 begin
   Self.count:=0;
   Self.list_id.Clear;
   Self.list_answered_time.Clear;
 end;



procedure TStructAnswered.updateCount;
begin
  Self.count:=Self.list_id.Count;
end;


 constructor TAnsweredQueue.Create;
 var
  i:Integer;
 begin
   inherited;

   // создаем list
   begin
     SetLength(list,cGLOBAL_ListAnswered);
     for i:=0 to cGLOBAL_ListAnswered-1 do list[i]:=TStructAnswered.Create;
   end;

   Self.updateAnsweredNow:=False;
   Self.SL:=100; // default
   Self.m_maxAnsweredTime:=0;
   Self.m_maxAnsweredID:=0;
 end;


destructor TAnsweredQueue.Destroy;
var
  i: Integer;
begin
  // Освобождение каждого элемента массива
  for i:=Low(list) to High(list) do list[i].Free; // Освобождаем каждый объект TStructAnswered

  // Очистка массива
  SetLength(list, 0); // Убираем ссылки на объекты

  inherited Destroy; // Вызов деструктора родительского класса
end;


 procedure TAnsweredQueue.Clear;
 const
 colorGood:TColor     = $0031851F;
 var
  i:Integer;
 begin
    for i:=0 to cGLOBAL_ListAnswered-1 do list[i].clear;
    Self.updateAnsweredNow:=False;

    Self.m_maxAnsweredTime:=0;
    Self.m_maxAnsweredID:=0;
    Self.SL:=100;

    with HomeForm do begin
       ST_SL.Caption:='SL: '+GetProcent(SL,False)+'%';
       ST_SL.Font.Color:=colorGood;

       // текстовое отображение
       lblStatistics_Answered30.Caption:='0';
       lblStatistics_Answered60.Caption:='0';
       lblStatistics_Answered120.Caption:='0';
       lblStatistics_Answered121.Caption:='0';

       // графическое отображение
       StatisticsQueue_Answered30_Graph.Progress:=0;
       StatisticsQueue_Answered60_Graph.Progress:=0;
       StatisticsQueue_Answered120_Graph.Progress:=0;
       StatisticsQueue_Answered121_Graph.Progress:=0;
       lblStatistics_Answered30_Graph.Caption:='0';
       lblStatistics_Answered60_Graph.Caption:='0';
       lblStatistics_Answered120_Graph.Caption:='0';
       lblStatistics_Answered121_Graph.Caption:='0';
    end;
 end;


 function TAnsweredQueue.getCountMaxAnswered;
 var
  i,j,max_wait:Integer;
 begin
   max_wait:=0;
   for i:=0 to cGLOBAL_ListAnswered-1  do begin
     for j:=0 to list[i].count-1 do begin
       if max_wait< StrToInt(list[i].list_answered_time[j]) then max_wait:=StrToInt(list[i].list_answered_time[j]);
     end;
   end;

   Result:=max_wait;
 end;

 procedure TAnsweredQueue.showAnswered;
 const
 colorGraph:TColor    = clTeal;
 MINIMAL_LINE_GRAPH_SHOWING:Word = 3; // минимальная линия на графике которая видна
 var
  i:Integer;
  procent:Double;
 begin
   for i:=0 to cGLOBAL_ListAnswered-1 do begin
    with HomeForm do begin
      procent:=list[i].count * 100 / getCountAllAnswered;

     case i of
       0: begin
         lblStatistics_Answered30.Caption:=IntToStr(list[i].count) + ' ('+GetProcent(procent)+'%)';
         

         // график
         begin
           lblStatistics_Answered30_Graph.Caption:=IntToStr(list[i].count)+#13+ ' ('+GetProcent(procent)+'%)';
           StatisticsQueue_Answered30_Graph.ForeColor:=colorGraph;

           if Round(procent)< MINIMAL_LINE_GRAPH_SHOWING then procent:=MINIMAL_LINE_GRAPH_SHOWING;
           StatisticsQueue_Answered30_Graph.Progress:=Round(procent);
         end;

         // отображаем  новый SL
         ShowSL(procent);  // old value = list[i].count / getCountAllAnswered * 100
       end;
       1: begin
         lblStatistics_Answered60.Caption:=IntToStr(list[i].count)  + ' ('+GetProcent(procent)+'%)';

         // график
         begin
           lblStatistics_Answered60_Graph.Caption:=IntToStr(list[i].count)+#13+ ' ('+GetProcent(procent)+'%)';
           StatisticsQueue_Answered60_Graph.ForeColor:=colorGraph;
           if Round(procent)< MINIMAL_LINE_GRAPH_SHOWING  then procent:=MINIMAL_LINE_GRAPH_SHOWING;
           StatisticsQueue_Answered60_Graph.Progress:=Round(procent);
         end; 
         
       end;
       2: begin
         lblStatistics_Answered120.Caption:=IntToStr(list[i].count) + ' ('+GetProcent(procent)+'%)';

          // график
         begin
           lblStatistics_Answered120_Graph.Caption:=IntToStr(list[i].count)+#13+ ' ('+GetProcent(procent)+'%)';
           StatisticsQueue_Answered120_Graph.ForeColor:=colorGraph;
           if Round(procent)< MINIMAL_LINE_GRAPH_SHOWING  then procent:=MINIMAL_LINE_GRAPH_SHOWING;
           StatisticsQueue_Answered120_Graph.Progress:=Round(procent);
         end;         
       end;
       3: begin
        lblStatistics_Answered121.Caption:=IntToStr(list[i].count) + ' ('+GetProcent(procent)+'%)';

          // график
         begin
           lblStatistics_Answered121_Graph.Caption:=IntToStr(list[i].count)+#13+ ' ('+GetProcent(procent)+'%)';
           StatisticsQueue_Answered121_Graph.ForeColor:=colorGraph;
           if Round(procent)< MINIMAL_LINE_GRAPH_SHOWING  then procent:=MINIMAL_LINE_GRAPH_SHOWING;
           StatisticsQueue_Answered121_Graph.Progress:=Round(procent);
         end;

         // максимальное время ожидания в очереди (будет типа пасхалка)
         begin
           FindMaxAnsweredTime;
           if m_maxAnsweredTime<>0 then begin
             lblStatistics_Answered121_Graph.Hint:='          от 120 сек и более'+#13+
                                                   'самый упорный ждал в очереди: '+GetTimeAnsweredSecondsToString(m_maxAnsweredTime);

           end;
         end; 
         
       end;
     end;
    end;
   end;
   Application.ProcessMessages;
 end;

 procedure TAnsweredQueue.addAnswered(id,answered_time:Integer);
 begin
   case answered_time of
    0..30:begin
      list[0].list_id.Add(IntToStr(id));
      list[0].list_answered_time.Add(IntToStr(answered_time));
      list[0].updateCount; // обновим кол-во звонков
    end;
    31..60:begin
      list[1].list_id.Add(IntToStr(id));
      list[1].list_answered_time.Add(IntToStr(answered_time));
      list[1].updateCount; // обновим кол-во звонков
    end;
    61..120:begin
      list[2].list_id.Add(IntToStr(id));
      list[2].list_answered_time.Add(IntToStr(answered_time));
      list[2].updateCount; // обновим кол-во звонков
    end;
    else begin
     list[3].list_id.Add(IntToStr(id));
     list[3].list_answered_time.Add(IntToStr(answered_time));
     list[3].updateCount; // обновим кол-во звонков
    end;
   end;
 end;

 // нахождене максимального времени ожидания в очереди
 procedure TAnsweredQueue.FindMaxAnsweredTime;
 var
  i:Integer;
 begin
   if list[3].count = 0 then Exit;

   for i:=0 to list[3].count-1 do begin
     if StrToInt(list[3].list_answered_time[i]) > m_maxAnsweredTime then
     begin
      m_maxAnsweredTime:= StrToInt(list[3].list_answered_time[i]);
      m_maxAnsweredID:= StrToInt(list[3].list_id[i]);
     end;
   end;
 end;


// отображение нового SL
procedure TAnsweredQueue.ShowSL(InNewSL:Double);
const
 colorGood:TColor     = $0031851F;
 colorNotBad:Tcolor   = $0000D5D5;
 colorBad:TColor      = $0000C8C8;
 colorVeryBad:TColor  = $0000009B;
 slUP:string          = '↑';
 slDOWN:string        = '↓';

var
 currentStatusSL:string;
begin

  if InNewSL<>SL then begin
    if InNewSL>SL then currentStatusSL:=slUP
    else currentStatusSL:=slDOWN;
  end;

  SL:=InNewSL;

  // считаем SL
   with HomeForm do begin
     ST_SL.Caption:='SL: ' + currentStatusSL + GetProcent(SL,False)+'%';

     case Round(SL) of
       0..30: begin
          ST_SL.Font.Color:=colorVeryBad;
       end;
       31..59: begin
          ST_SL.Font.Color:=colorBad;
       end;
       60..79:begin
          ST_SL.Font.Color:=colorNotBad;
       end;
       80..100:begin
          ST_SL.Font.Color:=colorGood;
       end;
     end;

     ST_SL.Hint:='Текущий SL = '+GetProcent(SL);
   end;
end;

// отображение процента в заивисимости от того какой результат по процентам
function TAnsweredQueue.GetProcent(InNewProcent:Double; isShowDelimiter:Boolean = true):string;
var
   new_procent:string;
begin

  if isShowDelimiter then new_procent:=FormatFloat('0.0',InNewProcent)
  else new_procent:=FormatFloat('0',InNewProcent);

  new_procent:=StringReplace(new_procent,',','.',[rfReplaceAll]);

  // уберем лишний .0 русть будет целове число
  if AnsiPos('.0',new_procent)<>0 then begin
   System.Delete(new_procent,AnsiPos('.',new_procent), Length(new_procent));
  end;

  Result:=new_procent;
end;


 function TAnsweredQueue.getCountAllAnswered;
 var
  i:Integer;
  allCount:Integer;
 begin
    allCount:=0;

    for i:=0 to cGLOBAL_ListAnswered-1 do begin
      if allCount=0 then allCount:=list[i].count
      else allCount:=allCount+list[i].count;
    end;

    Result:=allCount;
 end;


function TAnsweredQueue.isExistNewAnswered;
var
 countAllAnswered:Integer;
begin
  countAllAnswered:=StrToInt(GetStatistics_day(stat_answered));
  if countAllAnswered=0 then begin
   Result:=False;
   Exit;
  end;

  // сверяемся с текущим кол-вом
  if getCountAllAnswered<>countAllAnswered then Result:=True
  else Result:=False;
end;


function TAnsweredQueue.isExistAnsweredId(id: Integer):Boolean;
var
 i,j:Integer;
 isExist:Boolean;
begin
  Result:=False;
  isExist:=False;

  for i:=0 to cGLOBAL_ListAnswered-1 do begin
    for j:=0 to list[i].list_id.Count-1 do begin
      if id = StrToInt(list[i].list_id[j])  then begin
        isExist:=True;
        Break;
      end;
    end;

    if isExist then Break;
  end;

  if isExist then Result:=True
  else Result:=False;
end;



// обновление отвеченных звонков
procedure TAnsweredQueue.updateAnswered;
var
 i,j:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 listAnsweredBD: array of TStructAnswered_list;
 countAnswered:Integer;
 time_queue5000,time_queue5050:Integer;
 curr_time:Integer;

  ALength: Cardinal;
      n: Cardinal;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  // кол-во отвеченных на текущий момент
  countAnswered:=StrToInt(GetStatistics_day(stat_answered));
  if countAnswered=0 then begin
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
       serverConnect.Close;
       FreeAndNil(serverConnect);
    end;

    Exit;
  end;

  // динамический массив с будущими данными
  SetLength(listAnsweredBD,countAnswered);
  for i:=0 to countAnswered-1 do listAnsweredBD[i]:=TStructAnswered_list.Create;

  try
    // найдем всех
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select id,number_queue,waiting_time,talk_time from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and answered = ''1'' and sip <>''-1'' and hash is not null');
      Active:=True;

      for i:=0 to countAnswered-1 do begin
        listAnsweredBD[i].id:=StrToInt(VarToStr(Fields[0].Value));
        listAnsweredBD[i].queue:=StringToTQueue(VarToStr(Fields[1].Value));
        listAnsweredBD[i].waiting_time:=VarToStr(Fields[2].Value);
        listAnsweredBD[i].talk_time:=VarToStr(Fields[3].Value);

       ado.Next;
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  time_queue5000:=GetIVRTimeQueue(queue_5000);
  time_queue5050:=GetIVRTimeQueue(queue_5050);

  // проверяем теперь есть ли такие id в памяти
   for i:=0 to countAnswered-1 do begin
     if not isExistAnsweredId(listAnsweredBD[i].id) then begin
       curr_time:=0;
       // добавляем в память
       // найдем разницу во времени когда поговорили и сколько ждали - время от IVR
       case listAnsweredBD[i].queue of
        queue_5000: curr_time:=GetTimeAnsweredToSeconds(listAnsweredBD[i].waiting_time) - GetTimeAnsweredToSeconds(listAnsweredBD[i].talk_time) - time_queue5000;
        queue_5050: curr_time:=GetTimeAnsweredToSeconds(listAnsweredBD[i].waiting_time) - GetTimeAnsweredToSeconds(listAnsweredBD[i].talk_time) - time_queue5050;
       end;

       if curr_time<=0 then curr_time:=0;
       addAnswered(listAnsweredBD[i].id,curr_time);
     end;
   end;

  // delete array listAnsweredBD
  for i:=0 to countAnswered-1 do FreeAndNil(listAnsweredBD[i]);
end;

end.
