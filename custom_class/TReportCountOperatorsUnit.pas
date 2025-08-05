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
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  ActiveX, ComObj,
  ComCtrls,
  TAbstractReportUnit,
  Vcl.CheckLst,
  TQueueHistoryUnit,
  TCountRingsOperatorsUnit,
  Data.Win.ADODB, Data.DB;



/////////////////////////////////////////////////////////////////////////////////////////
   // class TReportCountOperators
 type
       TReportCountOperators = class(TAbstractReport)

      private
      m_nameReport              :string;     // название отчета
      m_onlyCurrentDay          :Boolean;   // показ только текщего дня
      m_queue                   :TArray<TQueueHistory>;   // список с данными истории
      countQueue                :Integer;
      m_listCountCallOperators  :TCountRingsOperators; // список с данными по звонкам по дням
      m_countOperators          :Integer;
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
                         isDetailed:Boolean                      // подробный отчет
                         );            overload;

      destructor Destroy;            override;

      procedure CreateReportExcel(const p_list:TCheckListBox); // создаем отчет

      property CountOperators:Integer read m_countOperators;


      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables, TCustomTypeUnit, GlobalVariablesLinkDLL;



constructor TReportCountOperators.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDateTimePicker;
                                         InOnlyCurrentDay:Boolean;
                                         isDetailed:Boolean);
begin
  // инициализацуия родительского класса
  inherited Create(InDateStart.Date,InDateStop.Date);

  m_nameReport:=InNameReports;
  m_onlyCurrentDay:=InOnlyCurrentDay;
  m_detailed:=isDetailed;

  countQueue:=0;
  m_countOperators:=0;
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


     m_listCountCallOperators:=TCountRingsOperators.Create(sipList, GetDateStart, GetDateStop, table, tableOnHold, listOperators);

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

  // TODO сделать !!! проверяем это уволенный сотрудник или нет



  isFinded:=False;

  for i:=0 to countQueue-1 do begin
    if m_queue[i].sip = InSipOperator  then begin
      if m_queue[i].userFIO <> '' then begin
        isFinded:=True;

        Result:=m_queue[i].userFIO;
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
 countData:Integer;
 procentLoad:Integer;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    // из какой таблицы брать данные
    if m_onlyCurrentDay then table:='queue'
    else table:='history_queue';

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from '+table+' where sip IN ('+p_list+')' );
      if not m_onlyCurrentDay then SQL.Add(' and date_time >='+#39+GetDateToDateBD(GetDateStart)+' 00:00:00'+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStop)+' 23:59:59'+#39+' order by date_time ASC');

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
        for i:=0 to countData-1 do m_queue[i]:=TQueueHistory.Create;

        SQL.Clear;
        SQL.Add('select id,number_queue,phone,waiting_time,date_time,sip,talk_time from '+table+' where sip IN ('+p_list+')' );
        if not m_onlyCurrentDay then SQL.Add(' and date_time >='+#39+GetDateToDateBD(GetDateStart)+' 00:00:00'+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStop)+' 23:59:59'+#39+' order by date_time ASC');

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

           procentLoad:=Trunc(i*100/countData);

           SetProgressStatusText('Загрузка данных с сервера ['+IntToStr(procentLoad)+'%] ...');
           SetProgressBar(procentLoad);


           m_queue[i].id:=StrToInt(Fields[0].Value);
           m_queue[i].number_queue:=StringToTQueue(Fields[1].Value);
           m_queue[i].phone:=Fields[2].Value;
          // m_queue[i].waiting_time:=Fields[3].Value;
           m_queue[i].date_time:=StrToDateTime(Fields[4].Value);
           m_queue[i].sip:=StrToInt(Fields[5].Value);
           m_queue[i].talk_time:=Fields[6].Value;
           m_queue[i].userFIO:=FindFIO(m_queue[i].sip,m_queue[i].date_time);

           ado.Next;

           // проверка вдруг отменили операцию
           GetAbout;
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
// time_queue5000,time_queue5050:Integer;
 curr_time:Integer;
begin
  SetProgressStatusText('Создание отчета ...');
  SetProgressBar(0);


   // названия колонок
  m_sheet.cells[1,1]:='ID';
  m_sheet.cells[1,2]:='Дата\Время';
  m_sheet.cells[1,3]:='Очередь';
 // m_sheet.cells[1,4]:='Время ожидания';
  m_sheet.cells[1,4]:='Телефон';
  m_sheet.cells[1,5]:='SIP';
  m_sheet.cells[1,6]:='Оператор';
  m_sheet.cells[1,7]:='Время разговора';


  // ширина колонок
  m_sheet.columns[1].columnwidth:=11;
  m_sheet.columns[2].columnwidth:=20.86;
  m_sheet.columns[3].columnwidth:=10.43;
 // m_sheet.columns[4].columnwidth:=15.43;
  m_sheet.columns[4].columnwidth:=15.29;
  m_sheet.columns[5].columnwidth:=9;
  m_sheet.columns[6].columnwidth:=25.29;
  m_sheet.columns[7].columnwidth:=15.43;

  // общий формат
//  m_excel.range['B2:B'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';
//
//  m_excel.range['E2:E'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';
//
//  m_excel.range['H2:H'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';


  ColIndex:=2;
  //time_queue5000:=GetIVRTimeQueue(queue_5000);
  //time_queue5050:=GetIVRTimeQueue(queue_5050);

  for i:=0 to countQueue-1 do begin
    if isESC then  Exit;

   // прогресс бар
   procentLoad:=i*100/countQueue;
   procentLoadSTR:=FormatFloat('0.0',procentLoad);
   procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

   SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%] ...');
   SetProgressBar(procentLoad);

    m_sheet.cells[ColIndex,1]:=IntToStr(m_queue[i].id);               // ID
    m_sheet.cells[ColIndex,2]:=DateTimeToStr(m_queue[i].date_time);   // Дата\Время
    m_sheet.cells[ColIndex,3]:=string(TQueueToString(m_queue[i].number_queue));     // Очередь

    {curr_time:=0;
    case m_queue[i].number_queue of     // время одидания
     queue_5000:curr_time:=GetTimeAnsweredToSeconds(m_queue[i].waiting_time) - GetTimeAnsweredToSeconds(m_queue[i].talk_time) - time_queue5000;
     queue_5050:curr_time:=GetTimeAnsweredToSeconds(m_queue[i].waiting_time) - GetTimeAnsweredToSeconds(m_queue[i].talk_time) - time_queue5050;
    end;
    if curr_time<=0 then curr_time:=0;
    m_sheet.cells[ColIndex,4]:=string(GetTimeAnsweredSecondsToString(curr_time)); }


    m_sheet.cells[ColIndex,4]:=m_queue[i].phone;                      // Телефон
    m_sheet.cells[ColIndex,5]:=IntToStr(m_queue[i].sip);              // SIP
    m_sheet.cells[ColIndex,6]:=m_queue[i].userFIO;                    // Оператор
    m_sheet.cells[ColIndex,7]:=m_queue[i].talk_time;                  // Время разговора


    Inc(ColIndex);

     // проверка вдруг отменили операцию
     GetAbout;
  end;


  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту ...');

    // заголовок
    m_excel.range['A1:G1'].AutoFilter;   // фильтр для заголовка

    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    m_excel.range['A1:G1'].select;
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
    m_excel.range['A2:G'+inttostr(countQueue+1)].select;
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
// time_queue5000,time_queue5050:Integer;
 curr_time:Integer;
begin
  m_excel.visible:=True;

  SetProgressStatusText('Создание отчета ...');
  SetProgressBar(0);


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
  m_sheet.columns[4].columnwidth:=11;
  m_sheet.columns[5].columnwidth:=11;


  // общий формат
//  m_excel.range['B2:B'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';
//
//  m_excel.range['E2:E'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';
//
//  m_excel.range['H2:H'+inttostr(countQueue+1)].select;
//  m_excel.selection.NumberFormat:='@';

  ColIndex:=2;


  for i:=0 to m_listCountCallOperators.Count-1 do begin
   // for j:=0 to  := Low to High do



      if isESC then  Exit;

     // прогресс бар
     procentLoad:=i*100/m_listCountCallOperators.Count-1;
     procentLoadSTR:=FormatFloat('0.0',procentLoad);
     procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

     SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%] ...');
     SetProgressBar(procentLoad);

      m_sheet.cells[ColIndex,1]:=IntToStr(m_queue[i].id);               // ID
      m_sheet.cells[ColIndex,2]:=DateTimeToStr(m_queue[i].date_time);   // Дата\Время
      m_sheet.cells[ColIndex,3]:=string(TQueueToString(m_queue[i].number_queue));     // Очередь

      {curr_time:=0;
      case m_queue[i].number_queue of     // время одидания
       queue_5000:curr_time:=GetTimeAnsweredToSeconds(m_queue[i].waiting_time) - GetTimeAnsweredToSeconds(m_queue[i].talk_time) - time_queue5000;
       queue_5050:curr_time:=GetTimeAnsweredToSeconds(m_queue[i].waiting_time) - GetTimeAnsweredToSeconds(m_queue[i].talk_time) - time_queue5050;
      end;
      if curr_time<=0 then curr_time:=0;
      m_sheet.cells[ColIndex,4]:=string(GetTimeAnsweredSecondsToString(curr_time)); }


      m_sheet.cells[ColIndex,4]:=m_queue[i].phone;                      // Телефон
      m_sheet.cells[ColIndex,5]:=IntToStr(m_queue[i].sip);              // SIP
      m_sheet.cells[ColIndex,6]:=m_queue[i].userFIO;                    // Оператор
      m_sheet.cells[ColIndex,7]:=m_queue[i].talk_time;                  // Время разговора


      Inc(ColIndex);

       // проверка вдруг отменили операцию
       GetAbout;
  end;


  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту ...');

    // заголовок
    m_excel.range['A1:G1'].AutoFilter;   // фильтр для заголовка

    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    m_excel.range['A1:G1'].select;
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
    m_excel.range['A2:G'+inttostr(countQueue+1)].select;
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


end.
