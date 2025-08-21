/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TReportCountOperators                 ///
///          "Отчет по количеству звонков операторами (подробный)"            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TReportCountOperatorsUnit;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, ActiveX, ComObj, ComCtrls,
  TAbstractReportUnit, Vcl.CheckLst, TQueueHistoryUnit, TCountRingsOperatorsUnit,
  Data.Win.ADODB, Data.DB, TAutoPodborPeopleUnit, System.DateUtils;


/////////////////////////////////////////////////////////////////////////////////////////
   // class TReportCountOperators
 type
       TReportCountOperators = class(TAbstractReport)

      private
      m_nameReport              :string;     // название отчета
      m_onlyCurrentDay          :Boolean;   // показ только текщего дня
      m_findFIO                 :Boolean;    // поиск ФИО звонящего из БД Инфоклинки
      m_queue                   :TArray<TQueueHistory>;   // список с данными истории
      countQueue                :Integer;
      m_listCountCallOperators  :TCountRingsOperators; // список с данными по звонкам по дням
      m_countOperators          :Integer;
      m_people                  :TAutoPodborPeople;
      m_detailed                :Boolean; // подробный отчет


      function GetOperatorsSIP(const p_list:TCheckListBox):TStringList;  // получение SIP операторов которые нужно в отчет впиндюрить
      procedure GenerateExcelDetailed;  // формирование данных в excel(подробный)
      procedure GenerateExcelBrief;     // формирование данных в excel(краткий)


      function FindFIO(InSipOperator:Integer;InCurrentDate:TDate):string;  // поиск фио оператора

      procedure CreateReportDetailed(const p_list:string);    // создание отчета (подробный)
      procedure CreateReportBrief;                            // создание отчета (краткий)

      public
      constructor Create(InNameReports:string;                    // название отчета
                         InDateStart,InDateStop:TDateTimePicker;  // даты отчета
                         InOnlyCurrentDay:Boolean;                // только текщий день
                         isDetailed:Boolean;                      // подробный отчет
                         isFindFIO:Boolean                        // поиск ФИО
                         );            overload;

      destructor Destroy;            override;

      procedure CreateReportExcel(const p_list:TCheckListBox); // создаем отчет

      property CountOperators:Integer read m_countOperators;
      property Count:Integer read countQueue;

      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables, TCustomTypeUnit, GlobalVariablesLinkDLL, FunctionUnit;



constructor TReportCountOperators.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDateTimePicker;
                                         InOnlyCurrentDay:Boolean;
                                         isDetailed:Boolean;
                                         isFindFIO:Boolean);
begin
  // инициализацуия родительского класса
  inherited Create(InDateStart.Date,InDateStop.Date);

  m_nameReport:=InNameReports;
  m_onlyCurrentDay:=InOnlyCurrentDay;
  m_detailed:=isDetailed;

  countQueue:=0;
  m_countOperators:=0;

  m_findFIO:=isFindFIO;
  if m_findFIO then m_people:=TAutoPodborPeople.Create;
end;


destructor TReportCountOperators.Destroy;
var
 i:Integer;
begin
  if Assigned(m_queue) then begin
    for i:=Low(m_queue) to High(m_queue) do FreeAndNil(m_queue[i]);
  end;

  inherited Destroy;
end;

// получение SIP операторов которые нужно в отчет впиндюрить
function TReportCountOperators.GetOperatorsSIP(const p_list:TCheckListBox):TStringList;
var
 i:Integer;
 sip:string;
begin
  Result:=TStringList.Create;
  if p_list.Items.Count=0 then Exit;

  for i:=0 to p_list.Count-1 do begin
    if p_list.Checked[i] then begin
      sip:=p_list.Items[i];

      System.Delete(sip,1,AnsiPos('(',sip));
      System.Delete(sip,AnsiPos(')',sip),Length(sip));

      Result.Add(sip);
    end;
  end;
end;


// создаем отчет
procedure TReportCountOperators.CreateReportExcel(const p_list:TCheckListBox);
var
 listSIP:TStringList;
 i:Integer;
 listOperators:string;
 sipList:TStringList;
 table:enumReportTableCountCallsOperator;
 tableOnHold:enumReportTableCountCallsOperatorOnHold;
begin
  // найдем список SIP для отчета
  listSIP:=GetOperatorsSIP(p_list);
  if listSIP.Count=0 then begin
    if Assigned(listSIP) then FreeAndNil(listSIP);
    Exit;
  end;

  sipList:=TStringList.Create;

  listOperators:='';  // список sip
  for i:=0 to listSIP.Count-1 do begin
   if listOperators='' then listOperators:=#39+listSIP[i]+#39
   else listOperators:=listOperators+','+#39+listSIP[i]+#39;

   // данные на случай если выбрали урезанный отчет
   sipList.Add(listSIP[i]);
  end;

   if m_detailed then begin  // подробный отчет
     CreateReportDetailed(listOperators);
   end
   else begin                // урезанный отчет
      // создаем сырой список класса
     m_countOperators:=listSIP.Count;

    // из какой таблицы брать данные
    if m_onlyCurrentDay then begin
     table:=eTableQueue;
     tableOnHold:=eTableOnHold;
    end
    else begin
     table:=eTableHistoryQueue;
     tableOnHold:=eTableHistoryOnHold;
    end;

     m_listCountCallOperators:=TCountRingsOperators.Create(sipList, GetDateStartAsString, GetDateStopAsString, table, tableOnHold, listOperators);

     // создаем отчет
     CreateReportBrief;
   end;

   if Assigned(sipList) then FreeAndNil(sipList);
end;


// поиск фио оператора
function TReportCountOperators.FindFIO(InSipOperator:Integer;InCurrentDate:TDate):string;
var
 i:Integer;
 isFinded:Boolean; // найдено фио
begin

  // TODO сделать !!! проверяем это уволенный сотрудник или нет очеень долгий это тпроцесс!! надо как то оптимизировать!!!


  isFinded:=False;

  for i:=0 to countQueue-1 do begin
    if m_queue[i].sip = InSipOperator  then begin
      if m_queue[i].operatorFIO <> '' then begin
        isFinded:=True;

        Result:=m_queue[i].operatorFIO;
        Exit;
      end;
    end;
  end;

  if not isFinded then Result:=GetUserNameOperators(IntToStr(InSipOperator));
end;

// создание отчета (подробный)
procedure TReportCountOperators.CreateReportDetailed(const p_list:string);
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 tableTrunk:enumReportTableIVR;
 tableOnHold:enumReportTableCountCallsOperatorOnHold;
 countData:Integer;
 procentLoadInt:Integer;
 procentLoadD:Double;
 procentLoadSTR:string;
 isFindFIO:Boolean;
 isAbout:Boolean;
 waitingTime:string;
 phone:string;
begin
  isAbout:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    // из какой таблицы брать данные
    if m_onlyCurrentDay then begin
      table:=EnumReportTableCountCallsOperatorToString(eTableQueue);
      tableTrunk:=eTableIVR;
      tableOnHold:=eTableOnHold;
    end
    else begin
      table:=EnumReportTableCountCallsOperatorToString(eTableHistoryQueue);
      tableTrunk:=eTableHistoryIVR;
      tableOnHold:=eTableHistoryOnHold;
    end;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from '+table+' where sip IN ('+p_list+') and answered = ''1''' );
      if not m_onlyCurrentDay then SQL.Add(' and date_time >='+#39+GetDateToDateBD(GetDateStartAsString)+' 00:00:00'+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStopAsString)+' 23:59:59'+#39+' order by date_time ASC');

      Active:=True;
      countData:=Fields[0].Value;
      if countData=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        Exit;
      end;

      if countData<>0 then begin

        // создаем список с данными
        SetLength(m_queue,countData);
        countQueue:=countData;
        if m_findFIO then isFindFIO:=True
        else isFindFIO:=False;

        for i:=0 to countData-1 do begin
           // процесс может быть длительный по этому делаем прогресс бар
           if m_findFIO then begin
             procentLoadInt:=Trunc(i*100/countData);
             SetProgressStatusText('Настройка отчета ['+IntToStr(procentLoadInt)+'%] ...');
             SetProgressBar(procentLoadInt);
           end;

           m_queue[i]:=TQueueHistory.Create(isFindFIO);
           // проверка вдруг отменили операцию
           if GetAbout then begin
             isAbout:=True;
             Break;
           end;
        end;

        if isAbout then Exit;

        SQL.Clear;
        SQL.Add('select id,number_queue,phone,waiting_time,date_time,sip,talk_time from '+table+' where sip IN ('+p_list+') and answered = ''1''');
        if not m_onlyCurrentDay then SQL.Add(' and date_time >='+#39+GetDateToDateBD(GetDateStartAsString)+' 00:00:00'+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStopAsString)+' 23:59:59'+#39+' order by date_time ASC');

        Active:=True;

        for i:=0 to countData-1 do begin
           if isESC then begin
             FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

              Exit;
           end;

           procentLoadD:=i*100/countData;
           procentLoadSTR:=FormatFloat('0.0',procentLoadD);
           procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

           SetProgressStatusText('Загрузка данных с сервера ['+procentLoadSTR+'%] ...');
           SetProgressBar(procentLoadD);


           m_queue[i].id:=StrToInt(Fields[0].Value);
           m_queue[i].number_queue:=StringToTQueue(Fields[1].Value);
           m_queue[i].phone:=Fields[2].Value;

           // время ожидания (waiting_time - talk_time)
           waitingTime:=GetTimeAnsweredSecondsToString(GetTimeAnsweredToSeconds(Fields[3].Value) - GetTimeAnsweredToSeconds(Fields[6].Value));
           m_queue[i].waiting_time:=waitingTime;

           m_queue[i].date_time:=StrToDateTime(Fields[4].Value);
           m_queue[i].sip:=StrToInt(Fields[5].Value);
           m_queue[i].talk_time:=Fields[6].Value;
           m_queue[i].operatorFIO:=FindFIO(m_queue[i].sip,m_queue[i].date_time);

           m_queue[i].trunk:=GetPhoneTrunkQueue(tableTrunk,m_queue[i].phone,Fields[4].Value);
           m_queue[i].phone_operator:=GetPhoneOperatorQueue(tableTrunk,m_queue[i].phone,Fields[4].Value);
           m_queue[i].region:=GetPhoneRegionQueue(tableTrunk,m_queue[i].phone,Fields[4].Value);

           // подсчет кол-ва времени в onhold за номер
           m_queue[i].onHold:=CountOnHoldPhoneOne(Fields[5].Value,
                                                  Fields[2].Value,
                                                  DateOf(m_queue[i].date_time),
                                                  tableOnHold);

           if m_findFIO then begin
             phone:=m_queue[i].phone;
             phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);
             m_queue[i].SetPhonePeople(phone);
           end;

           ado.Next;

           // проверка вдруг отменили операцию
           if GetAbout then Break;
        end;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  // создем excel
  GenerateExcelDetailed;
end;

// создание отчета (только кол-во)
procedure TReportCountOperators.CreateReportBrief;
begin
  if not m_listCountCallOperators.FillingData then begin
    Exit;
  end;

  // создем excel
  GenerateExcelBrief;
end;



// формирование данных в excel(подробный)
procedure TReportCountOperators.GenerateExcelDetailed;
var
 ColIndex:Integer;
 i:Integer;
 procentLoad:Double;
 procentLoadSTR:string;
begin
  SetProgressStatusText('Создание отчета ...');
  SetProgressBar(0);

  // названия колонок
  m_sheet.cells[1,1]:='ID';
  m_sheet.cells[1,2]:='Дата\Время';
  m_sheet.cells[1,3]:='Очередь';
  m_sheet.cells[1,4]:='Ожидание в очереди';
  m_sheet.cells[1,5]:='Телефон';
  m_sheet.cells[1,6]:='Линия';
  m_sheet.cells[1,7]:='Оператор';
  m_sheet.cells[1,8]:='Регион';
  m_sheet.cells[1,9]:='SIP';
  m_sheet.cells[1,10]:='Оператор';
  m_sheet.cells[1,11]:='Время разговора';
  m_sheet.cells[1,12]:='OnHold(сек)';

  if m_findFIO then begin
    m_sheet.cells[1,13]:='ФИО';
  end;

  // ширина колонок
  m_sheet.columns[1].columnwidth:=11;
  m_sheet.columns[2].columnwidth:=20.86;
  m_sheet.columns[3].columnwidth:=10.43;
  m_sheet.columns[4].columnwidth:=13.43;
  m_sheet.columns[5].columnwidth:=15.29;
  m_sheet.columns[6].columnwidth:=15.29;
  m_sheet.columns[7].columnwidth:=22;
  m_sheet.columns[8].columnwidth:=35;
  m_sheet.columns[9].columnwidth:=9;
  m_sheet.columns[10].columnwidth:=25.29;
  m_sheet.columns[11].columnwidth:=15.43;
  m_sheet.columns[12].columnwidth:=14;
  if m_findFIO then begin
    m_sheet.columns[13].columnwidth:=55;
  end;

  ColIndex:=2;

  for i:=0 to Count-1 do begin
    if isESC then  Exit;

   // прогресс бар
   procentLoad:=i*100/Count;
   procentLoadSTR:=FormatFloat('0.0',procentLoad);
   procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

   SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%] ...');
   SetProgressBar(procentLoad);

   m_sheet.cells[ColIndex,1]:=IntToStr(m_queue[i].id);                           // ID
   m_sheet.cells[ColIndex,2]:=DateTimeToStr(m_queue[i].date_time);               // Дата\Время
   m_sheet.cells[ColIndex,3]:=string(TQueueToString(m_queue[i].number_queue));   // Очередь
   m_sheet.cells[ColIndex,4]:=m_queue[i].waiting_time;                           // Ожидание в очереди
   m_sheet.cells[ColIndex,5]:=m_queue[i].phone;                                  // Телефон
   m_sheet.cells[ColIndex,6]:=m_queue[i].trunk;                                  // Линия
   m_sheet.cells[ColIndex,7]:=m_queue[i].phone_operator;                         // Оператор
   m_sheet.cells[ColIndex,8]:=m_queue[i].region;                                 // Регион
   m_sheet.cells[ColIndex,9]:=IntToStr(m_queue[i].sip);                          // SIP
   m_sheet.cells[ColIndex,10]:=m_queue[i].operatorFIO;                           // Оператор
   m_sheet.cells[ColIndex,11]:=m_queue[i].talk_time;                             // Время разговора
   m_sheet.cells[ColIndex,12]:=IntToStr(m_queue[i].onHold);                      // OnHold (сек)


    if m_findFIO then begin
      m_sheet.cells[ColIndex,13]:=m_queue[i].GetFIOPeople;
    end;

    Inc(ColIndex);

     // проверка вдруг отменили операцию
     GetAbout;
  end;


  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту ...');

    // заголовок
    if m_findFIO then begin
       m_excel.range['A1:M1'].AutoFilter;   // фильтр для заголовка
    end
    else m_excel.range['A1:L1'].AutoFilter;   // фильтр для заголовка

    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    if m_findFIO then begin
     m_excel.range['A1:M1'].select;
    end
    else m_excel.range['A1:L1'].select;

    //m_excel.selection.FreezePanes:=true;
    m_excel.selection.font.bold:=True;
    m_excel.selection.font.size:=12;
    m_excel.selection.font.name:='Times New Roman';
    // перенос по словам
    m_excel.selection.wraptext:=true;
    // выравниевание по центру по горизонтали
    m_excel.selection.verticalalignment:=2;
    m_excel.selection.horizontalalignment:=3;


    // выделение диапозона
    if m_findFIO then begin
     m_excel.range['A2:M'+inttostr(ColIndex-1)].select;
    end
    else m_excel.range['A2:L'+inttostr(ColIndex-1)].select;

    // перенос по словам
    m_excel.selection.wraptext:=true;
    // выравниевание по центру по горизонтали
    m_excel.selection.verticalalignment:=2;
    m_excel.selection.horizontalalignment:=3;

    //таблица границы ячеек
    m_excel.selection.borders.linestyle:=1;
    // размер текста
    m_excel.selection.font.size:=12;
    // font name
    m_excel.selection.font.name:='Times New Roman';

    // заглушочка чтобы вернуться в самое начало
    m_excel.range['A1'].select;
  end;

  isExistDataExcel:=True;
end;

// формирование данных в excel(краткий)
procedure TReportCountOperators.GenerateExcelBrief;
var
 ColIndex:Integer;
 i,j:Integer;
 procentLoad:Double;
 procentLoadSTR:string;
 sip:string;
 operatorFIO:string;
 countCallsAll, countHold:Integer;
begin
  SetProgressStatusText('Создание отчета ...');
  SetProgressBar(0);

  countCallsAll:=0;
  countHold:=0;

   // названия колонок
  m_sheet.cells[1,1]:='SIP';
  m_sheet.cells[1,2]:='Оператор';
  m_sheet.cells[1,3]:='Дата';
  m_sheet.cells[1,4]:='Звонков';
  m_sheet.cells[1,5]:='OnHold(сек)';

  // ширина колонок
  m_sheet.columns[1].columnwidth:=9;
  m_sheet.columns[2].columnwidth:=25.29;
  m_sheet.columns[3].columnwidth:=20.86;
  m_sheet.columns[4].columnwidth:=12;
  m_sheet.columns[5].columnwidth:=14;

  ColIndex:=2;

  for i:=0 to m_listCountCallOperators.Count-1 do begin
    // прогресс бар
     procentLoad:=i*100/m_listCountCallOperators.Count-1;
     procentLoadSTR:=FormatFloat('0.0',procentLoad);
     procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

     SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%] ...');
     SetProgressBar(procentLoad);

    if isESC then  Exit;
    if not m_listCountCallOperators.Items[i].IsExistData then Continue;

    // проверка вдруг отменили операцию
     GetAbout;

    // пробегаемся по массиву
    for j:=0 to m_listCountCallOperators.Items[i].Count-1 do begin
      sip:=IntToStr(m_listCountCallOperators.Items[i].m_sip);
      operatorFIO:=GetUserNameOperators(sip);

      m_sheet.cells[ColIndex,1]:=sip;                           // SIP
      m_sheet.cells[ColIndex,2]:=operatorFIO;      // Оператор  // TODO сделать проверку на уволенного сотрудника
      m_sheet.cells[ColIndex,3]:=m_listCountCallOperators.Items[i].ItemData[j].m_date_time; // Дата
      m_sheet.cells[ColIndex,4]:=IntToStr(m_listCountCallOperators.Items[i].ItemData[j].m_callsCount);         // Звонков
      m_sheet.cells[ColIndex,5]:=IntToStr(m_listCountCallOperators.Items[i].ItemData[j].m_ohHold);         // OnHold(сек)

      // общий подсчет звонков+hold
      countCallsAll:=countCallsAll + m_listCountCallOperators.Items[i].ItemData[j].m_callsCount;
      countHold:=countHold + m_listCountCallOperators.Items[i].ItemData[j].m_ohHold;

      Inc(ColIndex);

       // проверка вдруг отменили операцию
     GetAbout;
    end;
  end;

  // общее кол-во звонков + hold
  m_sheet.cells[ColIndex,4]:=IntToStr(countCallsAll);
  m_sheet.cells[ColIndex,5]:=IntToStr(countHold);

  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту ...');

    // заголовок
    m_excel.range['A1:E1'].AutoFilter;   // фильтр для заголовка

    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    m_excel.range['A1:E1'].select;
    //m_excel.selection.FreezePanes:=true;
    m_excel.selection.font.bold:=True;
    m_excel.selection.font.size:=12;
    m_excel.selection.font.name:='Times New Roman';
    // перенос по словам
    m_excel.selection.wraptext:=true;
    // выравниевание по центру по горизонтали
    m_excel.selection.verticalalignment:=2;
    m_excel.selection.horizontalalignment:=3;



    // выделение диапозона
    m_excel.range['A2:E'+inttostr(ColIndex-1)].select;
    // перенос по словам
    m_excel.selection.wraptext:=true;
    // выравниевание по центру по горизонтали
    m_excel.selection.verticalalignment:=2;
    m_excel.selection.horizontalalignment:=3;

    //таблица границы ячеек
    m_excel.selection.borders.linestyle:=1;
    // размер текста
    m_excel.selection.font.size:=12;
    // font name
    m_excel.selection.font.name:='Times New Roman';


    // общее кол-во звонков + hold
    // выделение диапозона
    m_excel.range['D'+inttostr(ColIndex)+':E'+inttostr(ColIndex)].select;
    m_excel.selection.font.size:=12;
    m_excel.selection.font.name:='Times New Roman';
    // перенос по словам
    m_excel.selection.wraptext:=true;
    // выравниевание по центру по горизонтали
    m_excel.selection.verticalalignment:=2;
    m_excel.selection.horizontalalignment:=3;
    m_excel.selection.Style:='Хороший';
    m_excel.selection.font.bold:=True;


    // заглушочка чтобы вернуться в самое начало
    m_excel.range['A1'].select;
  end;

  isExistDataExcel:=True;
end;


end.
