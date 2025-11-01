 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             Класс для описания истории звонков + пропущенные              ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TQueueStatisticsUnit;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Data.Win.ADODB,
  Data.DB, Variants, TCustomTypeUnit, TAutoPodborPeopleUnit, System.SyncObjs,
  Windows;

var
 TQueueStatisticsCounter: Integer = 0;

 // class TCalls
   type
   TCalls = class(TObject)
   private
   m_id           :Integer;
   m_dateTime     :TDateTime;
   m_phone        :string;
   m_waiting      :string;
   m_trunk        :string;
   m_queue        :enumQueue;

   m_addFIO       :Boolean;           // нужно ли добавлять ФИО
   m_fio          :TAutoPodborPeople;

   function Clone(_addFIO:Boolean):TCalls;

   public
   constructor Create(_addFIO:Boolean = False);               overload;
   destructor Destroy;

   end;
// class TCalls END


  // class TStructMissed
  type
   TStructMissed = class(TObject)

   private
   m_count_missed               :Integer;
   m_count_missed_no_return     :Integer;

   m_missed               :TArray<TCalls>;
   m_missed_no_return     :TArray<TCalls>;

   public
   constructor Create;               overload;
   destructor Destroy;

   procedure Clear;                       overload;
   procedure Clear(_missed:enumMissed);   overload;

   procedure Add(_missed:enumMissed; NewMissed:TCalls; isCheckExist:Boolean = False);  // добавление нового в список
   procedure Delete(_missed:enumMissed; _id:Integer);
   function IsExist(_missed:enumMissed; NewMissed:TCalls):Boolean;                     // проверка на существующую запись




   end;
   // class TStructMissed END


  // class TStructStatistics
  type
    TStructStatistics = class(TObject)
    private
    m_all         :Integer;   // всего звонков
    m_ansvered    :Integer;   // всего звонков отвечено
    m_missed_all  :Integer;   // всего звонков пропущенные
    m_missed      :Integer;   // всего звонков пропущенные (не перезввонившие)

    m_listMissed  :TStructMissed;  // список с пропущенными звонками

    public
    constructor Create;                   overload;
    destructor Destroy;                   override;

    procedure Clear;      // очистка данных

    procedure AddListMissed(_missed:enumMissed; NewMissed:TCalls);  // добавление данных в пропущенные

    property All:Integer read m_all;
    property Ansvered:Integer read m_ansvered;
    property MissedAll:Integer read m_missed_all;
    property Missed:Integer read m_missed;

    end;

 // class TStructStatistics




 // class TStructQueueStatistics
  type
      TStructQueueStatistics = class(TObject)
      private
      m_queue       :enumQueue;
      m_statistics  :TStructStatistics;

      // ссылки на TLabel на форме
      m_label_all         :TLabel;
      m_label_ansvered    :TLabel;
      m_label_missed      :TLabel;

      public
      constructor Create(_queue:enumQueue);    overload;
      destructor Destroy;                             override;

      function isExistDiffMissedCalls(_missed:enumMissed):Boolean; // есть изменения в пропущенных

      end;
 // class TStructQueueStatistics END


 // class TStructQueueStatisticsDay
 type
  TStructQueueStatisticsDay = class(TStructQueueStatistics)
  private
    m_label_procent: TLabel;
    m_statistics_procent  :string;

  public
    constructor Create(_queue: enumQueue); reintroduce;
    destructor Destroy;                           override;
  end;

 // class TStructQueueStatisticsDay END


 // class TQueueStatistics
  type
      TQueueStatistics = class(TObject)
      private
      m_mutexIndex: Integer;  // порядковый номер mutex
      m_mutex  :TMutex;

      m_count   :Integer;
      m_list    :TArray<TStructQueueStatistics>;
      m_listDay :TStructQueueStatisticsDay;

      isExistStatDay:Boolean;

      procedure SetStatistics(_queue:enumQueue); overload; // занесение параметров статистики
      procedure SetStatistics; overload;                   // занесение параметров статистики
      procedure ShowQueue(_queue:enumQueue);               // показываем данные в разрезе очереди
      procedure ShowDay;                                   // показываем данные в разрезе текущего дня
      procedure UpdateQueue(_queue:enumQueue);             // обвнление данных по очередям
      procedure UpdateDay;                                 // обвнление данных за текущий день

      function GetCountAllCalls:Integer;                   // общее вол-во звонков за текущий день
      function GetCountAllMissed:Integer;                  // общее вол-во звонков за текущий день (пропущенные)

      function GetMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay;
                              var _countCalls:Integer):TArray<TCalls>;  // получение массива пропущенных звонков

      procedure UpdateMissedCalls(_queue:enumQueue;
                                  _stat:enumStatistiscDay;
                                  _beforeClear:enumStatus); //обновление подробностьей о пропущенных звонках


      function GetStatisticsCountInQueue(_queue:enumQueue;
                                         _queueType:enumQueueType):integer; // отображение инфо по очередеям



      public
      constructor Create(isCreateStatDay:Boolean = False);                   overload;
      destructor Destroy; override;

      function GetCallsAll(_queue:enumQueue):Integer;          // все звонки
      function GetCallsAnswered(_queue:enumQueue):Integer;     // отвеченные
      function GetCallsMissedAll(_queue:enumQueue):Integer;    // пропущенные все
      function GetCallsMissed(_queue:enumQueue):Integer;       // пропущенные не перезвонившие

      procedure Update;  // обновление данных
      procedure Show; // показ данных

      procedure SetLinkLabel(_queue:enumQueue;
                             var _label_all,_label_ansvered,_label_missed : TLabel); //линкова TLabel (только при старте нкужна)

      procedure SetLinkLabelStatDay(var _label_all,_label_ansvered,_label_missed,_label_procent : TLabel); //линкова TLabel (только при старте нкужна)


      // ================ функции TCalls ====================
      function GetMissedCount(_queue:enumQueue; _missed:enumMissed):Integer;  // получение кол-ва пропущенных
      function GetCalls_ID(_queue:enumQueue; _missed:enumMissed; _id:Integer):Integer;           // m_id
      function GetCalls_DateTime(_queue:enumQueue; _missed:enumMissed; _id:Integer):TDateTime;   // m_datetime
      function GetCalls_Phone(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;         // m_phone
      function GetCalls_FIO(_queue:enumQueue; _missed:enumMissed; _id:Integer; var _count:Integer):string;           // m_fio
      function GetCalls_Trunk(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;         // m_trunk
      function GetCalls_Waiting(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;       // m_waiting


      // ================ функции TCalls END ================

      property Count:Integer read m_count;
      property ExistStatDay:Boolean read isExistStatDay;
      property CountAllCalls:Integer  read GetCountAllCalls;
      property CountAllCallsMissed:Integer  read GetCountAllMissed;

      end;
 // class TQueueStatistics END

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, FormHome, GlobalVariables;


// =============================================
// TCalls

constructor TCalls.Create(_addFIO:Boolean = False);
begin
   m_id           :=0;
   m_dateTime     :=0;
   m_phone        :='';
   m_waiting      :='';
   m_trunk        :='';
   m_queue        :=queue_null;

   m_addFIO:=_addFIO;
   m_fio:=nil;
end;

destructor TCalls.Destroy;
begin
  if Assigned(m_fio) then m_fio.Free;
  inherited;
end;


function TCalls.Clone(_addFIO:Boolean): TCalls;
var
 phone:string;
 internalCall:Boolean;  // внутренний звонок был
begin
  Result:=TCalls.Create(_addFIO);
  internalCall:=False;

  Result.m_id         := Self.m_id;
  Result.m_dateTime   := Self.m_dateTime;
  Result.m_phone      := Self.m_phone;
  Result.m_waiting    := Self.m_waiting;
  Result.m_trunk      := Self.m_trunk;
  Result.m_queue      := Self.m_queue;

  if _addFIO then begin
    phone:=Self.m_phone;
    phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);

    // внутренний звонок был
    if Result.m_queue = queue_5911 then begin
     internalCall:=True;
    end;

    Result.m_fio:=TAutoPodborPeople.Create(phone,internalCall);
  end;
end;


// TCalls END
// =============================================





// =============================================
// TStructStatistics

constructor TStructMissed.Create;
begin
  Clear;
end;

destructor TStructMissed.Destroy;
begin
  Clear;
  inherited;
end;


procedure TStructMissed.Clear;
var
  i: Integer;
begin
  // Освобождаем массив m_missed
  if Length(m_missed) > 0 then begin
    for i := 0 to High(m_missed) do begin
      FreeAndNil(m_missed[i]); // Освобождаем каждый объект
    end;
    SetLength(m_missed, 0); // Устанавливаем длину массива в 0
    m_count_missed := 0; // Сбрасываем счетчик
  end;

  // Освобождаем массив m_missed_no_return
  if Length(m_missed_no_return) > 0 then begin
    for i := 0 to High(m_missed_no_return) do begin
      FreeAndNil(m_missed_no_return[i]); // Освобождаем каждый объект
    end;
    SetLength(m_missed_no_return, 0); // Устанавливаем длину массива в 0
    m_count_missed_no_return := 0; // Сбрасываем счетчик
  end;
end;


procedure TStructMissed.Clear(_missed:enumMissed);
var
  i: Integer;
begin
  case _missed of
    eMissed:begin
      // Освобождаем массив m_missed
        if Length(m_missed) > 0 then begin
          for i := 0 to High(m_missed) do begin
            FreeAndNil(m_missed[i]); // Освобождаем каждый объект
          end;
          SetLength(m_missed, 0); // Устанавливаем длину массива в 0
          m_count_missed := 0; // Сбрасываем счетчик
        end;
    end;
    eMissed_no_return:begin
      // Освобождаем массив m_missed_no_return
      if Length(m_missed_no_return) > 0 then begin
        for i := 0 to High(m_missed_no_return) do begin
          FreeAndNil(m_missed_no_return[i]); // Освобождаем каждый объект
        end;
        SetLength(m_missed_no_return, 0); // Устанавливаем длину массива в 0
        m_count_missed_no_return := 0; // Сбрасываем счетчик
      end;
    end;
    eMissed_all:begin
      Clear;
    end;
  end;
end;

// проверка на существующую запись
function TStructMissed.IsExist(_missed:enumMissed; NewMissed:TCalls):Boolean;
var
 i:Integer;
 m_array: TArray<TCalls>;
 counts:Integer;
begin
  Result:=False;
  counts:=0;

  case _missed of
    eMissed: begin
       m_array:=m_missed;
       counts:=m_count_missed;
    end;
    eMissed_no_return: begin
      m_array:=m_missed_no_return;
      counts:=m_count_missed_no_return;
    end;
  end;

  for i:=0 to counts-1 do begin
    if m_array[i].m_id = NewMissed.m_id then begin
      Result:=True;
      Exit;
    end;
  end;
end;

// добавление нового в список
procedure TStructMissed.Add(_missed:enumMissed; NewMissed:TCalls; isCheckExist:Boolean = False);
var
  CallCopy: TCalls;
  addFIO:Boolean;  // нужно ли добавлять расширенную информацию о номере (ФИО из ЦБД)
begin
 //  проверка на дубль записи
  if isCheckExist then begin
    if IsExist(_missed, NewMissed) then Exit;
  end;

  // нужно ли добавлять расширенную информацию о номере (ФИО из ЦБД)
  case _missed of
    eMissed:            addFIO :=False;
    eMissed_no_return:  addFIO :=True;
  end;

  // Создаем копию объекта
  CallCopy := NewMissed.Clone(addFIO);

  if not Assigned(CallCopy) then Exit;

  case _missed of
    eMissed:begin
      SetLength(m_missed, Length(m_missed) + 1);
      m_missed[High(m_missed)]:= CallCopy; // Добавляем копию в массив
      Inc(m_count_missed);
    end;
    eMissed_no_return:begin
      SetLength(m_missed_no_return, Length(m_missed_no_return) + 1);
      m_missed_no_return[High(m_missed_no_return)]:= CallCopy; // Добавляем копию в массив

      Inc(m_count_missed_no_return);
    end;
  end;

end;


procedure TStructMissed.Delete(_missed:enumMissed; _id:Integer);
var
  i, len: Integer;
begin
  case _missed of
    eMissed:
      begin
        len := Length(m_missed);
        for i := 0 to len - 1 do begin
         if m_missed[i].m_id = _id then
          begin
            // освободить объект
            m_missed[i].Free;
            // если не последний, сдвинуть tail массива влево
            if i < len - 1 then  Move(m_missed[i + 1], m_missed[i], (len - i - 1) * SizeOf(Pointer));
            // укоротить массив
            SetLength(m_missed, len - 1);
            Dec(m_count_missed);
            Exit;
          end;
        end;
      end;

    eMissed_no_return: begin
      len := Length(m_missed_no_return);
      for i := 0 to len - 1 do  begin
        if m_missed_no_return[i].m_id = _id then
        begin
          m_missed_no_return[i].Free;
          if i < len - 1 then  Move(m_missed_no_return[i + 1], m_missed_no_return[i], (len - i - 1) * SizeOf(Pointer));
          SetLength(m_missed_no_return, len - 1);
          Dec(m_count_missed_no_return);
          Exit;
        end;
      end;
    end;
  end;
end;

// TStructStatistics END
// =============================================



// =============================================
// TStructStatistics

constructor TStructStatistics.Create;
begin
 m_listMissed:=TStructMissed.Create;
 Clear;
end;

destructor TStructStatistics.Destroy;
begin
  m_listMissed.Free;
  inherited;
end;

// очистка данных
procedure TStructStatistics.Clear;
begin
   m_all        :=0;
   m_ansvered   :=0;
   m_missed_all :=0;
   m_missed     :=0;

   m_listMissed.Clear;
end;

// добавление данных в пропущенные
procedure TStructStatistics.AddListMissed(_missed:enumMissed; NewMissed:TCalls);
begin
  m_listMissed.Add(_missed,NewMissed,True);
end;


// TStructStatistics END
// =============================================


// =============================================
// TStructQueueStatistics

constructor TStructQueueStatistics.Create(_queue:enumQueue);
begin
  // inherited;
  m_queue:=_queue;
  m_statistics:=TStructStatistics.Create;

//  m_label_all         :=TLabel.Create(nil);
//  m_label_ansvered    :=TLabel.Create(nil);
//  m_label_missed      :=TLabel.Create(nil);

  m_label_all         :=nil;
  m_label_ansvered    :=nil;
  m_label_missed      :=nil;
end;

destructor TStructQueueStatistics.Destroy;
begin
  if Assigned(m_label_all) then m_label_all.Free;
  if Assigned(m_label_ansvered) then m_label_ansvered.Free;
  if Assigned(m_label_missed) then m_label_missed.Free;
  if Assigned(m_statistics) then m_statistics.Free;

  inherited;
end;


// есть изменения в пропущенных
function TStructQueueStatistics.isExistDiffMissedCalls(_missed:enumMissed):Boolean;
var
 i:Integer;
 count_missed_stat, count_missed_list:Integer;
begin
  Result:=False;

  case _missed of
   eMissed: begin
      count_missed_stat:=m_statistics.m_missed_all;
      count_missed_list:=m_statistics.m_listMissed.m_count_missed;
   end;
   eMissed_no_return:begin
     count_missed_stat:=m_statistics.m_missed;
     count_missed_list:=m_statistics.m_listMissed.m_count_missed_no_return;
   end;
  end;

  Result:=not (count_missed_stat = count_missed_list);
end;


// TStructQueueStatistics END
// =============================================


// =============================================
// TStructQueueStatisticsDay

// Реализация конструктора
constructor TStructQueueStatisticsDay.Create(_queue: enumQueue);
begin
  inherited Create(_queue); // Вызов конструктора родительского класса
  //m_label_procent := TLabel.Create(nil);
  m_label_procent := nil;
  m_statistics_procent:='0';
end;

destructor TStructQueueStatisticsDay.Destroy;
begin
 if Assigned(m_label_procent) then m_label_procent.Free;
  inherited;
end;


// TStructQueueStatisticsDay END
// =============================================

// =============================================
// TQueueStatistics
                                    // нужно ли создавать обект для статистики за день
constructor TQueueStatistics.Create(isCreateStatDay:Boolean = False);
var
 i:Integer;
begin
  inherited Create;

  m_mutexIndex:=InterlockedIncrement(TQueueStatisticsCounter);
  // создаём именованный мьютекс с номером экземпляра
  m_mutex:=TMutex.Create(nil, False, Format('Global\TQueueStatistics_%d', [m_mutexIndex]));


  //inherited;
  m_count:=3;    // Ord(High(enumQueue))-1;  // TODO берем только 5000 и 5050 очереди

   // создадим массив
  SetLength(m_list,m_count);
  m_list[0]:=TStructQueueStatistics.Create(queue_5000);
  m_list[1]:=TStructQueueStatistics.Create(queue_5050);
  m_list[2]:=TStructQueueStatistics.Create(queue_5911);
 // for i:=0 to m_count do m_list[i]:=TStructQueueStatistics.Create(enumQueue(i));


  // нужно ли создавать обект для статистики за день
  if isCreateStatDay then begin
    m_listDay:=TStructQueueStatisticsDay.Create(queue_5000_5050);   // TODO сумму очередей 5000 + 5050
    isExistStatDay:=True;
  end;

end;


destructor TQueueStatistics.Destroy;
var
  i: Integer;
begin
  // освобождаем мьютекс
  m_mutex.Free;
  // уменьшаем счётчик
  InterlockedDecrement(TQueueStatisticsCounter);

  // сначала дочерние «очереди»
  for i := 0 to High(m_list) do m_list[i].Free;
  SetLength(m_list, 0);

  // потом статистику за день
  if isExistStatDay then  m_listDay.Free;

  inherited;
end;

// занесение параметров статистики
procedure TQueueStatistics.SetStatistics(_queue:enumQueue);
 var
  i,j:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_queue = _queue then begin

      if StrToInt(GetStatistics_day(stat_summa,_queue)) = 0 then begin
       m_list[i].m_statistics.Clear;
       UpdateMissedCalls(_queue, stat_no_answered, eYES);
       UpdateMissedCalls(_queue, stat_no_answered_return, eYES);
       Exit;
      end;

      m_list[i].m_statistics.m_all        :=GetStatisticsCountInQueue(_queue,all_answered);
      m_list[i].m_statistics.m_ansvered   :=GetStatisticsCountInQueue(_queue,answered);
      m_list[i].m_statistics.m_missed_all :=GetStatisticsCountInQueue(_queue,no_answered);
      m_list[i].m_statistics.m_missed     :=GetStatisticsCountInQueue(_queue,no_answered_return);


      // сверяемся есть ли изменения (обновляем подробные данные по пропущенным)
      if m_list[i].isExistDiffMissedCalls(eMissed) then begin
        UpdateMissedCalls(_queue, stat_no_answered, eNO);
      end;

      if m_list[i].isExistDiffMissedCalls(eMissed_no_return) then begin
        UpdateMissedCalls(_queue, stat_no_answered_return, eYes);
      end;
    end;
  end;
end;

// занесение параметров статистики
procedure TQueueStatistics.SetStatistics;
begin
   m_listDay.m_statistics.m_all:=StrToInt(GetStatistics_day(stat_summa));
   m_listDay.m_statistics.m_ansvered:=StrToInt(GetStatistics_day(stat_answered));
   m_listDay.m_statistics.m_missed_all:=StrToInt(GetStatistics_day(stat_no_answered));
   m_listDay.m_statistics.m_missed:=StrToInt(GetStatistics_day(stat_no_answered_return));

   m_listDay.m_statistics_procent:=GetStatistics_day(stat_procent_no_answered) + '% ('+GetStatistics_day(stat_procent_no_answered_return)+'%)';
end;

 // показываем данные в разрезе очереди
procedure TQueueStatistics.ShowQueue(_queue:enumQueue);
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    if m_list[i].m_queue = _queue then begin
       // всего звонков
       m_list[i].m_label_all.Caption:=IntToStr(GetCallsAll(_queue));
       // отвечено
       m_list[i].m_label_ansvered.Caption:=IntToStr(GetCallsAnswered(_queue));
       // пропущено
       m_list[i].m_label_missed.Caption:=IntToStr(GetCallsMissedAll(_queue))+' ('+IntToStr(GetCallsMissed(_queue))+')';
    end;
  end;
end;

// показываем данные в разрезе текущего дня
procedure TQueueStatistics.ShowDay;
begin
  m_listDay.m_label_all.Caption:=IntToStr(m_listDay.m_statistics.m_all);
  m_listDay.m_label_ansvered.Caption:=IntToStr(m_listDay.m_statistics.m_ansvered);
  m_listDay.m_label_missed.Caption:=IntToStr(m_listDay.m_statistics.m_missed_all)+' ('+IntToStr(m_listDay.m_statistics.m_missed)+')';
  m_listDay.m_label_procent.Caption:=m_listDay.m_statistics_procent;
end;


procedure TQueueStatistics.SetLinkLabel(_queue:enumQueue;
                           var _label_all,_label_ansvered,_label_missed : TLabel); //линкова TLabel (только при старте нкужна)

var
 i:Integer;
begin
  for i:=0 to m_count -1 do begin
    if m_list[i].m_queue = _queue then begin
      m_list[i].m_label_all:=_label_all;
      m_list[i].m_label_ansvered:=_label_ansvered;
      m_list[i].m_label_missed:=_label_missed;

     Exit;
    end;
  end;
end;


//линкова TLabel (только при старте нкужна)
procedure TQueueStatistics.SetLinkLabelStatDay(var _label_all,_label_ansvered,_label_missed,_label_procent : TLabel);
begin
  if not isExistStatDay then Exit;

  m_listDay.m_label_all:=_label_all;
  m_listDay.m_label_ansvered:=_label_ansvered;
  m_listDay.m_label_missed:=_label_missed;
  m_listDay.m_label_procent:=_label_procent;
end;


// получение кол-ва пропущенных
function TQueueStatistics.GetMissedCount(_queue:enumQueue; _missed:enumMissed):Integer;
var
 i:Integer;
 queue_summa:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count -1 do begin
      if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed: begin
            Result:=m_list[i].m_statistics.m_listMissed.m_count_missed;
            Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_count_missed_no_return;
           Exit;
          end;
          eMissed_all:begin
            Result:=m_list[i].m_statistics.m_listMissed.m_count_missed;
            Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    queue_summa:=0;
    for i:=0 to m_count-1 do begin
      case _missed of
        eMissed: begin
          queue_summa:= queue_summa + m_list[i].m_statistics.m_listMissed.m_count_missed;
        end;
        eMissed_no_return:begin
         queue_summa:= queue_summa + m_list[i].m_statistics.m_listMissed.m_count_missed_no_return;
        end;
        eMissed_all:begin
          queue_summa:= queue_summa + (m_list[i].m_statistics.m_listMissed.m_count_missed + m_list[i].m_statistics.m_listMissed.m_count_missed_no_return);;
        end;
      end;
    end;

    Result:=queue_summa;

  finally
    m_mutex.Release;
  end;
end;

// TCalls -> m_id
function TQueueStatistics.GetCalls_ID(_queue:enumQueue; _missed:enumMissed; _id:Integer):Integer;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1do begin
    if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_id;
           Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_id;
           Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    // рекурсией найдем значение
    for i:=0 to m_count - 1 do begin
      Result:=GetCalls_ID(enumQueue(i),_missed, _id);
      if Result > 0 then begin
        Exit;
      end;
    end;

  finally
    m_mutex.Release;
  end;
end;

// TCalls -> m_datetime
function TQueueStatistics.GetCalls_DateTime(_queue:enumQueue; _missed:enumMissed; _id:Integer):TDateTime;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1do begin
      if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_dateTime;
           Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_dateTime;
           Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    // рекурсией найдем значение
    for i:=0 to m_count - 1 do begin
      Result:=GetCalls_DateTime(enumQueue(i),_missed, _id);
      if Result > 0 then begin
        Exit;
      end;
    end;

  finally
    m_mutex.Release;
  end;
end;


// TCalls -> m_phone
function  TQueueStatistics.GetCalls_Phone(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1 do begin
      if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_phone;
           Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_phone;
           Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    // рекурсией найдем значение
    for i:=0 to m_count - 1 do begin
      Result:=GetCalls_Phone(enumQueue(i),_missed, _id);
      if Result <>'' then begin
        Exit;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;


// TCalls -> m_fio
function TQueueStatistics.GetCalls_FIO(_queue:enumQueue; _missed:enumMissed; _id:Integer; var _count:Integer):string;
var
 i:Integer;
 countFIO:Integer;
begin
 countFIO:=0;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
     try
      for i:=0 to m_count - 1 do begin
        if m_list[i].m_queue = _queue then begin
          case _missed of
            eMissed:begin
             countFIO:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_fio.Count;

               case countFIO of
                0:begin
                  Result:='новый номер';
                end;
                1:begin
                  Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_fio.GetFIO(0);
                end;
                else begin
                  Result:='несколько пациентов ('+IntToStr(countFIO)+')';
                end;
               end;

             Exit;
            end;
            eMissed_no_return:begin
              countFIO:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_fio.Count;

               case countFIO of
                0:begin
                  Result:='новый номер';
                end;
                1:begin
                  Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_fio.GetFIO(0);
                end;
                else begin
                  Result:='несколько пациентов ('+IntToStr(countFIO)+')';
                end;
               end;

             Exit;
            end;
          end;
        end;
      end;
     finally
       _count:=countFIO;
     end;
  finally
    m_mutex.Release;
  end;


end;


// TCalls -> m_trunk
function TQueueStatistics.GetCalls_Trunk(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try

    for i:=0 to m_count - 1 do begin
      if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_trunk;
           Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_trunk;
           Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    // рекурсией найдем значение
    for i:=0 to m_count - 1 do begin
      Result:=GetCalls_Trunk(enumQueue(i),_missed, _id);
      if Result <> 'null' then begin
        Exit;
      end;
    end;

  finally
    m_mutex.Release;
  end;
end;

// TCalls -> m_waiting
function TQueueStatistics.GetCalls_Waiting(_queue:enumQueue; _missed:enumMissed; _id:Integer):string;
var
 i:Integer;
begin

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to m_count - 1 do begin
      if m_list[i].m_queue = _queue then begin
        case _missed of
          eMissed:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed[_id].m_waiting;
           Exit;
          end;
          eMissed_no_return:begin
           Result:=m_list[i].m_statistics.m_listMissed.m_missed_no_return[_id].m_waiting;
           Exit;
          end;
        end;
      end;
    end;

    // ничего не нашли значит это 5000 и 5050
    // рекурсией найдем значение
    for i:=0 to m_count - 1 do begin
      Result:=GetCalls_Waiting(enumQueue(i),_missed, _id);
      if Result <> '' then begin
        Exit;
      end;
    end;

  finally
    m_mutex.Release;
  end;
end;


// все звонки
function TQueueStatistics.GetCallsAll(_queue:enumQueue):Integer;
var
 i:Integer;
begin
   for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_all;
       Exit;
     end;
   end;
end;

// отвеченные
function TQueueStatistics.GetCallsAnswered(_queue:enumQueue):Integer;
var
 i:Integer;
begin
   for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_ansvered;
       Exit;
     end;
   end;
end;


// пропущенные все
function TQueueStatistics.GetCallsMissedAll(_queue:enumQueue):Integer;
var
 i:Integer;
begin
    for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_missed_all;
       Exit;
     end;
   end;
end;


// пропущенные не перезвонившие
function TQueueStatistics.GetCallsMissed(_queue:enumQueue):Integer;
var
 i:Integer;
begin
    for i:=0 to m_count do begin
     if m_list[i].m_queue = _queue then begin
       Result:=m_list[i].m_statistics.m_missed;
       Exit;
     end;
   end;
end;


// обвнление данных по очереди
procedure TQueueStatistics.UpdateQueue(_queue:enumQueue);
begin
  SetStatistics(_queue);
end;

// обвнление данных за текущий день
procedure TQueueStatistics.UpdateDay;
begin
  SetStatistics;
end;

// общее вол-во звонков за текущий день
function TQueueStatistics.GetCountAllCalls:Integer;
begin
  Result:=GetCallsAll(queue_5000)+GetCallsAll(queue_5050);
end;

// общее вол-во звонков за текущий день (пропущенные)
function TQueueStatistics.GetCountAllMissed:Integer;
begin
  Result:=GetMissedCount(queue_5000, eMissed_all)+GetMissedCount(queue_5050, eMissed_all);
end;

// получение массива пропущенных звонков
function TQueueStatistics.GetMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay;
                                         var _countCalls:Integer):TArray<TCalls>;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  call:TCalls;
  i,count:Integer;
  SQL_text:string;
  correct_time:string;
  call_id:string;
begin
 _countCalls:=0;
 SetLength(Result,0);

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  count:=StrToInt(GetStatistics_day(_stat,_queue));
  if count=0 then
  begin
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
   Exit;
  end;

  // формируем запрос
  _countCalls:=count;

  case _stat of
   stat_no_answered:begin
    SQL_text:='select id,phone,waiting_time,date_time from queue where number_queue = '+#39+TQueueToString(_queue)+#39+' and fail = ''1'' and date_time > '+#39+GetNowDateTime+#39;
   end;
   stat_no_answered_return:begin
    SQL_text:='select id,phone,waiting_time,date_time from queue where number_queue='+#39+TQueueToString(_queue)+#39+
                                                                ' and fail =''1'' and date_time >'+#39+GetNowDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue ='+#39+TQueueToString(_queue)+#39+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetNowDateTime+#39+')';
   end;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(SQL_text);
      Active:=True;

      SetLength(Result, _countCalls);

      for i:=0 to count-1 do begin
       call:=TCalls.Create;
       call.m_id        :=StrToInt(VarToStr(Fields[0].Value));
       call.m_phone     :=VarToStr(Fields[1].Value);

       // скорректируем время
       if correctTimeQueue(_queue,VarToStr(Fields[2].Value),correct_time) then begin
         call.m_waiting   := correct_time;
       end;

       call.m_dateTime  :=StrToDateTime(VarToStr(Fields[3].Value));

       try
         call_id:=_dll_GetCallIDPhoneIVR(eTableIVR,call.m_phone);     // TODO тут проверить потом а то есть подозрение что не правильно высчитвается
         call.m_trunk:=_dll_GetPhoneTrunkQueue(eTableIVR, call.m_phone, call_id);
       except
         call.m_trunk:='null';
       end;

       call.m_queue:=_queue;

       Result[i]:=call;
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
end;


//обновление подробностьей о пропущенных звонках
procedure TQueueStatistics.UpdateMissedCalls(_queue:enumQueue; _stat:enumStatistiscDay; _beforeClear:enumStatus);
var
  list_calls: TArray<TCalls>;
  count_calls: Integer;
  i,j: Integer;
  missedType: enumMissed;
begin
  count_calls:= 0;

  // Определяем тип пропущенных вызовов
  case _stat of
    stat_no_answered: missedType := eMissed;
    stat_no_answered_return: missedType := eMissed_no_return;
  else
    Exit; // Если статистика не соответствует, выходим из процедуры
  end;

  // Очистка данных, если это необходимо
  if _beforeClear = eYES then
  begin
    for i:=0 to m_count - 1 do
    begin
      if m_list[i].m_queue = _queue then
      begin
        m_list[i].m_statistics.m_listMissed.Clear(missedType);
      end;
    end;
  end;

  // Получаем список пропущенных вызовов
 try
  list_calls:=GetMissedCalls(_queue, _stat, count_calls);

  // Если есть пропущенные вызовы, добавляем их в статистику
  if count_calls > 0 then
  begin
    for i := 0 to m_count - 1 do
    begin
      if m_list[i].m_queue = _queue then
      begin
        for j := 0 to count_calls - 1 do
        begin
          m_list[i].m_statistics.AddListMissed(missedType, list_calls[j]);
        end;
      end;
    end;
  end;
 finally
  // Освобождаем память
  if Assigned(list_calls) then begin
    if Length(list_calls)>0 then
    begin
      for i := 0 to High(list_calls) do FreeAndNil(list_calls[i]);
      SetLength(list_calls, 0);
    end;
  end;
 end;
end;


// отображение инфо по очередеям
function TQueueStatistics.GetStatisticsCountInQueue(_queue:enumQueue;_queueType:enumQueueType):integer;
var
 select_response:string;
begin
  case _queueType of

    answered: begin    // отвеченные
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(_queue)+#39
                                                                             +' and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetNowDateTime+#39;
    end;
    no_answered: begin  // не отвеченные
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(_queue)+#39
                                                                             +' and fail = ''1'' and date_time > '+#39+GetNowDateTime+#39;
    end;
    no_answered_return: begin  // не отвеченные + вернувшиеся
      select_response:='select count(distinct(phone)) from queue where number_queue='+#39+TQueueToString(_queue)+#39+
                                                                ' and fail =''1'' and date_time >'+#39+GetNowDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue ='+#39+TQueueToString(_queue)+#39+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetNowDateTime+#39+')';


    end;
    all_answered:begin  // всего отвеченных
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(_queue)+#39
                                                                             +' and date_time > '+#39+GetNowDateTime+#39;
    end;
  end;


  Result:=GetSelectResponse(select_response);
end;


// обновление данных
procedure TQueueStatistics.Update;
var
 i:Integer;
begin
  // заносим данные в память
  for i:=0 to m_count-1 do begin
    UpdateQueue(m_list[i].m_queue);
  end;

  // обновление данных за текущий день
  if isExistStatDay then UpdateDay;
end;


// показ данных
procedure TQueueStatistics.Show;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
   ShowQueue(enumQueue(i));
  end;

  // показываем данные за текущий день
  if isExistStatDay then begin
    ShowDay;
  end;
end;


// TQueueStatistics END
// =============================================


end.