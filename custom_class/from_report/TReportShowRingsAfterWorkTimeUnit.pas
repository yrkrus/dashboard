/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             Класс для описания TReportShowRingsAfterWorkTime              ///
///                "Отчет по звонкам после рабочего времени"                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TReportShowRingsAfterWorkTimeUnit;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, ActiveX, ComObj, ComCtrls,
  TAbstractReportUnit, Vcl.CheckLst, TCountRingsOperatorsUnit,
  Data.Win.ADODB, Data.DB, TIVRHistoryUnit, TCustomTypeUnit, TWorkTimeCallCenterUnit,
  DateUtils, Variants;


/////////////////////////////////////////////////////////////////////////////////////////
   // class TReportShowRingsAfterWorkTime
 type
      TReportShowRingsAfterWorkTime = class(TAbstractReport)

      private
      m_nameReport              :string;     // название отчета
      m_onlyCurrentDay          :Boolean;   // показ только текщего дня
      m_history                 :TArray<TIVRHistory>;   // список с данными истории
      m_workTime                :TWorkTimeCallCenter; // время работы коллцентра
      m_count                   :Integer; //m_history count
      m_findFIO                 :Boolean; // поиск ФИО по номеру телефона



      procedure GenerateExcel;    // формирование данных в excel
      procedure CreateReport(_listDate:TStringList);     // создание данных для отчета
      function GetCountCalls(_table:enumReportTableIVR; _listDate:TStringList):Integer; overload;
      function GetCountCalls(_listDate:TStringList):Integer;                            overload;

      procedure FindCalls(var _ado:TADOQuery;
                              _table:enumReportTableIVR;
                              _count:Integer;
                              _listDate:TStringList); overload; // поиск звонков

      procedure FindCalls(var _ado:TADOQuery;
                              _count:Integer;
                              _listDate:TStringList); overload;// поиск звонков

      procedure AddIvrHistory(_call:TIVRHistory); // добавление данных для генерации в excel

      public
      constructor Create(InNameReports:string;                    // название отчета
                         InDateStart,InDateStop:TDateTimePicker;  // даты отчета
                         InOnlyCurrentDay:Boolean;                // только текщий день
                         InFindFIO:Boolean);  overload;           // поиск ФИО по номеру телефона


      destructor Destroy;            override;
      procedure CreateReportExcel; // создаем отчет

      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL;



constructor TReportShowRingsAfterWorkTime.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDateTimePicker;
                                         InOnlyCurrentDay:Boolean;
                                         InFindFIO:Boolean);
begin
  // инициализацуия родительского класса
  inherited Create(InDateStart.Date,InDateStop.Date);

  m_nameReport:=InNameReports;
  m_onlyCurrentDay:=InOnlyCurrentDay;

  m_workTime:=TWorkTimeCallCenter.Create;

  m_findFIO:=InFindFIO;

  SetLength(m_history,0);
  m_count:=0;
end;


destructor TReportShowRingsAfterWorkTime.Destroy;
var
 i:Integer;
begin
  if Assigned(m_history) then begin
    for i:=Low(m_history) to High(m_history) do FreeAndNil(m_history[i]);
  end;

  inherited Destroy;
end;

// создаем отчет
procedure TReportShowRingsAfterWorkTime.CreateReportExcel;
var
 listDate:TStringList;  //лист с датами
 currentDate, stopDate:TDate;
begin
  listDate:=TStringList.Create;

   // найдем все промежутки дат
   currentDate:=GetDateStartAsDate;
   stopDate:=GetDateStopAsDate;

   while currentDate <= stopDate do begin
    listDate.Add(GetDateToDateBD(DateToStr(currentDate)));
    currentDate:=IncDay(currentDate);
   end;

   // создаем отчет
   CreateReport(listDate);

   if Assigned(listDate) then FreeAndNil(listDate);
end;


function TReportShowRingsAfterWorkTime.GetCountCalls(_listDate:TStringList):Integer;
begin
  Result:=GetCountCalls(eTableHistoryIVR,_listDate);
end;

function TReportShowRingsAfterWorkTime.GetCountCalls(_table:enumReportTableIVR; _listDate:TStringList):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 listDate:string;
 countData:Integer;
 request:TStringBuilder;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  for i:=0 to _listDate.Count-1 do begin
   if listDate='' then listDate:=#39+_listDate[i]+#39
   else listDate:=listDate+','+#39+_listDate[i]+#39;
  end;

  try
    // из какой таблицы брать данные
    table:=EnumReportTableIVRToString(_table);

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      if m_onlyCurrentDay then begin
         request:=TStringBuilder.Create;
         with request do begin
          Append('select ');
          Append('(select count(*) ');
          Append('from '+EnumReportTableIVRToString(eTableHistoryIVR));
          Append(' where date_time >= '+#39+_listDate[0]+' '+m_workTime.StopTimeStr+':00:00'+#39);
          Append(' and date_time < '+#39+_listDate[1]+' '+m_workTime.StartTimeStr+':00:00'+#39);
          Append(')');
          Append(' +');
          Append(' (select count(*) ');
          Append('from '+EnumReportTableIVRToString(eTableIVR));
          Append(' where date_time >= '+#39+_listDate[0]+' '+m_workTime.StopTimeStr+':00:00'+#39);
          Append(' and date_time < '+#39+_listDate[1]+' '+m_workTime.StartTimeStr+':00:00'+#39);
          Append(')');
          Append(' AS total_count');
         end;

         SQL.Add(request.ToString);
      end
      else begin
        SQL.Add('select count(id) from '+table+' where DATE(date_time) IN ('+listDate+') and (TIME(date_time) >= '+#39+m_workTime.StopTimeStr+':00:00'+#39+' OR TIME(date_time) < '+#39+m_workTime.StartTimeStr+':00:00'+#39+')');
      end;

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

      Result:=countData;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

 // поиск звонков
procedure TReportShowRingsAfterWorkTime.FindCalls(var _ado:TADOQuery;
                                                      _count:Integer;
                                                      _listDate:TStringList);
begin
  FindCalls(_ado,eTableHistoryIVR,_count,_listDate);
end;

// поиск звонков
procedure TReportShowRingsAfterWorkTime.FindCalls(var _ado:TADOQuery;
                                                      _table:enumReportTableIVR;
                                                      _count:Integer;
                                                      _listDate:TStringList);
const
 cFIELDS_TABLE:string = 'id,call_time,phone,date_time,trunk,to_queue,operator,region';
 cINTERNALCALLS:Boolean = False;
var
 table:string;
 i:Integer;
 listDate:string;
 procentLoad:Double;
 procentLoadSTR:string;
 call:TIVRHistory;
 phone:string;
 request:TStringBuilder;
begin
 table:=EnumReportTableIVRToString(_table);

  for i:=0 to _listDate.Count-1 do begin
   if listDate='' then listDate:=#39+_listDate[i]+#39
   else listDate:=listDate+','+#39+_listDate[i]+#39;
  end;

 with _ado do begin

    SQL.Clear;

    if m_onlyCurrentDay then begin
      request:=TStringBuilder.Create;

      with request do begin
       Append('select '+cFIELDS_TABLE);
       Append(' from '+EnumReportTableIVRToString(eTableHistoryIVR));
       Append(' where date_time >= '+#39+_listDate[0]+' '+m_workTime.StopTimeStr+':00:00'+#39);
       Append(' and date_time < '+#39+_listDate[1]+' '+m_workTime.StartTimeStr+':00:00'+#39);
       Append(' union all ');
       Append('select '+cFIELDS_TABLE);
       Append(' from '+EnumReportTableIVRToString(eTableIVR));
       Append(' where date_time >= '+#39+_listDate[0]+' '+m_workTime.StopTimeStr+':00:00'+#39);
       Append(' and date_time < '+#39+_listDate[1]+' '+m_workTime.StartTimeStr+':00:00'+#39);
       Append(' ORDER BY date_time');
      end;

      SQL.Add(request.ToString);
    end
    else begin
     SQL.Add('select '+cFIELDS_TABLE+' from '+table+' where DATE(date_time) IN ('+listDate+') and (TIME(date_time) >= '+#39+m_workTime.StopTimeStr+':00:00'+#39+' OR TIME(date_time) < '+#39+m_workTime.StartTimeStr+':00:00'+#39+')');
    end;

    Active:=True;

    if isESC then Exit;

    call:=TIVRHistory.Create;

    for i:=0 to _count-1 do begin
     call.Clear;
     procentLoad:=i*100/_count;
     procentLoadSTR:=FormatFloat('0.0',procentLoad);
     procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

     SetProgressStatusText('Загрузка данных ['+procentLoadSTR+'%]');
     SetProgressBar(procentLoad);

     call.id:=StrToInt(VarToStr(Fields[0].Value));
     call.call_time:=StrToInt(VarToStr(Fields[1].Value));
     call.phone:=VarToStr(Fields[2].Value);
     call.date_time:=Fields[3].Value;
     call.trunk:=Fields[4].Value;
     call.to_queue:=StrToBool(Fields[5].Value);
     if Fields[6].Value<>null then call.phone_operator:=Fields[6].Value;
     if Fields[7].Value<>null then call.region:=Fields[7].Value;

     // проверяем нужно ли искать ФИО
     if m_findFIO then begin
       phone:=call.phone;
       phone:=StringReplace(phone,'+7','8',[rfReplaceAll]);

       call.SetPhonePeople(phone,cINTERNALCALLS);
     end;

     AddIvrHistory(call);
     _ado.Next;

     // проверка вдруг отменили операцию
     if GetAbout then Break;
    end;
 end;
end;

// добавление данных для генерации в excel
procedure TReportShowRingsAfterWorkTime.AddIvrHistory(_call:TIVRHistory);
begin
  SetLength(m_history, Length(m_history) + 1);

  // создаём реальный клон (а не просто копируем указатель)
  m_history[High(m_history)]:= _call.Clone;
  Inc(m_count);
end;


// создание отчета
procedure TReportShowRingsAfterWorkTime.CreateReport(_listDate:TStringList);
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 listDate:string;
 countData:Integer;
begin
  countData:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  for i:=0 to _listDate.Count-1 do begin
   if listDate='' then listDate:=#39+_listDate[i]+#39
   else listDate:=listDate+','+#39+_listDate[i]+#39;
  end;

  try
    // найдем кол-во
    begin
      if m_onlyCurrentDay then countData:=GetCountCalls(_listDate)
      else countData:=GetCountCalls(eTableHistoryIVR,_listDate); // тут все проcто ищем только в истории

      if countData=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        Exit;
      end;
    end;

     ado.Connection:=serverConnect;

    // найдем данные
    if m_onlyCurrentDay then FindCalls(ado, countData, _listDate)
    else FindCalls(ado, eTableHistoryIVR, countData, _listDate);

  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  // создем excel
  GenerateExcel;
end;


// формирование данных в excel
procedure TReportShowRingsAfterWorkTime.GenerateExcel;
var
 ColIndex:Integer;
 i:Integer;
 procentLoad:Double;
 procentLoadSTR:string;
 curr_time:Integer;
begin

  SetProgressStatusText('Создание отчета');
  SetProgressBar(0);

   // названия колонок
  m_sheet.cells[1,1]:='ID';
  m_sheet.cells[1,2]:='Дата\Время';
  m_sheet.cells[1,3]:='Ожидание в IVR';
  m_sheet.cells[1,4]:='Телефон';
  m_sheet.cells[1,5]:='Линия';
  m_sheet.cells[1,6]:='Оператор';
  m_sheet.cells[1,7]:='Регион';

  if m_findFIO then begin
   m_sheet.cells[1,8]:='ФИО';
  end;

  // ширина колонок
  m_sheet.columns[1].columnwidth:=11;
  m_sheet.columns[2].columnwidth:=20.86;
  m_sheet.columns[3].columnwidth:=12;
  m_sheet.columns[4].columnwidth:=15.29;
  m_sheet.columns[5].columnwidth:=15.29;
  m_sheet.columns[6].columnwidth:=22;
  m_sheet.columns[7].columnwidth:=35;
  if m_findFIO then begin
    m_sheet.columns[8].columnwidth:=55;
  end;

  ColIndex:=2;

  for i:=0 to m_count-1 do begin
    if isESC then  Exit;

   // прогресс бар
   procentLoad:=i*100/m_count;
   procentLoadSTR:=FormatFloat('0.0',procentLoad);
   procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

   SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%]');
   SetProgressBar(procentLoad);

    m_sheet.cells[ColIndex,1]:=IntToStr(m_history[i].id);   // ID
    m_sheet.cells[ColIndex,2]:=m_history[i].date_time;      // Дата\Время
    m_sheet.cells[ColIndex,3]:=GetTimeAnsweredSecondsToString(m_history[i].call_time);   // Ожидание в IVR
    m_sheet.cells[ColIndex,4]:=m_history[i].phone;          // Телефон
    m_sheet.cells[ColIndex,5]:=m_history[i].trunk;          // Транк
    m_sheet.cells[ColIndex,6]:=m_history[i].phone_operator; // Оператор
    m_sheet.cells[ColIndex,7]:=m_history[i].region;         // Регион

    if m_findFIO then begin
     m_sheet.cells[ColIndex,8]:=m_history[i].GetFIOPeople;  // ФИО звонящего
    end;

    Inc(ColIndex);

     // проверка вдруг отменили операцию
     GetAbout;
  end;

  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту');

    // заголовок
    if m_findFIO then begin
      m_excel.range['A1:H1'].AutoFilter;   // фильтр для заголовка
    end
    else m_excel.range['A1:G1'].AutoFilter;   // фильтр для заголовка



    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    if m_findFIO then begin
     m_excel.range['A1:H1'].select;
    end
    else m_excel.range['A1:G1'].select;


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
      m_excel.range['A2:H'+inttostr(m_count+1)].select;
    end
    else  m_excel.range['A2:G'+inttostr(m_count+1)].select;


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
