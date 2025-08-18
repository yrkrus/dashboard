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


      procedure GenerateExcel;    // формирование данных в excel
      procedure CreateReport(_listDate:TStringList);     // создание данных для отчета
      function GetCountCalls(_table:enumReportTableIVR; _listDate:TStringList):Integer;

      procedure FindCalls(var _ado:TADOQuery;
                              _table:enumReportTableIVR;
                              _count:Integer;
                              _listDate:TStringList); // поиск звонков

      procedure AddIvrHistory(_call:TIVRHistory); // добавление данных для генерации в excel

      public
      constructor Create(InNameReports:string;                    // название отчета
                         InDateStart,InDateStop:TDateTimePicker;  // даты отчета
                         InOnlyCurrentDay:Boolean);  overload;    // только текщий день


      destructor Destroy;            override;
      procedure CreateReportExcel; // создаем отчет

      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL;



constructor TReportShowRingsAfterWorkTime.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDateTimePicker;
                                         InOnlyCurrentDay:Boolean);
begin
  // инициализацуия родительского класса
  inherited Create(InDateStart.Date,InDateStop.Date);

  m_nameReport:=InNameReports;
  m_onlyCurrentDay:=InOnlyCurrentDay;

  m_workTime:=TWorkTimeCallCenter.Create;

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


function TReportShowRingsAfterWorkTime.GetCountCalls(_table:enumReportTableIVR; _listDate:TStringList):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 listDate:string;
 countData:Integer;
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
      SQL.Add('select count(id) from '+table+' where DATE(date_time) IN ('+listDate+') and (TIME(date_time) >= '+#39+m_workTime.StopTimeStr+':00:00'+#39+' OR TIME(date_time) < '+#39+m_workTime.StartTimeStr+':00:00'+#39+')');

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
                                                      _table:enumReportTableIVR;
                                                      _count:Integer;
                                                      _listDate:TStringList);
var
 table:string;
 i:Integer;
 listDate:string;
 procentLoad:Integer;
 call:TIVRHistory;
begin
 table:=EnumReportTableIVRToString(_table);

  for i:=0 to _listDate.Count-1 do begin
   if listDate='' then listDate:=#39+_listDate[i]+#39
   else listDate:=listDate+','+#39+_listDate[i]+#39;
  end;

 with _ado do begin

    SQL.Clear;
    SQL.Add('select id,phone,date_time,trunk,to_queue,operator,region from '+table+' where DATE(date_time) IN ('+listDate+') and (TIME(date_time) >= '+#39+m_workTime.StopTimeStr+':00:00'+#39+' OR TIME(date_time) < '+#39+m_workTime.StartTimeStr+':00:00'+#39+')');

    Active:=True;

    if isESC then Exit;

    call:=TIVRHistory.Create;

    for i:=0 to _count-1 do begin
     call.Clear;
     procentLoad:=Trunc(i*100/_count);

     SetProgressStatusText('Загрузка данных с сервера ['+IntToStr(procentLoad)+'%] ...');
     SetProgressBar(procentLoad);

     call.id:=StrToInt(VarToStr(Fields[0].Value));
     call.phone:=VarToStr(Fields[1].Value);
     call.date_time:=Fields[2].Value;
     call.trunk:=Fields[3].Value;
     call.to_queue:=StrToBool(Fields[4].Value);
     if Fields[5].Value<>null then call.phone_operator:=Fields[5].Value;
     if Fields[6].Value<>null then call.region:=Fields[6].Value;


     AddIvrHistory(call);
     _ado.Next;

     // проверка вдруг отменили операцию
     GetAbout;
    end;
 end;
end;

// добавление данных для генерации в excel
procedure TReportShowRingsAfterWorkTime.AddIvrHistory(_call:TIVRHistory);
begin
  SetLength(m_history, Length(m_history) + 1);
  m_history[High(m_history)] := TIVRHistory.Create(_call);
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
      if m_onlyCurrentDay then begin
         for i:=Ord(Low(enumReportTableIVR)) to Ord(High(enumReportTableIVR)) do
         begin
           if countData = 0 then countData:=GetCountCalls(enumReportTableIVR(i),_listDate)
           else countData:=countData + GetCountCalls(enumReportTableIVR(i),_listDate);
         end;
      end
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
    if m_onlyCurrentDay then begin
       for i:=Ord(Low(enumReportTableIVR)) to Ord(High(enumReportTableIVR)) do
       begin
         // тут придется еще раз count найти
         countData:=GetCountCalls(enumReportTableIVR(i),_listDate);
         FindCalls(ado, enumReportTableIVR(i), countData, _listDate);
       end;
    end
    else begin
     // тут придется еще раз count найти
      countData:=GetCountCalls(eTableHistoryIVR,_listDate);
      FindCalls(ado, eTableHistoryIVR, countData, _listDate);
    end;

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
  SetProgressStatusText('Создание отчета ...');
  SetProgressBar(0);

   // названия колонок
  m_sheet.cells[1,1]:='ID';
  m_sheet.cells[1,2]:='Дата\Время';
  m_sheet.cells[1,3]:='Телефон';
  m_sheet.cells[1,4]:='Линия';
  m_sheet.cells[1,5]:='Оператор';
  m_sheet.cells[1,6]:='Регион';

  // ширина колонок
  m_sheet.columns[1].columnwidth:=11;
  m_sheet.columns[2].columnwidth:=20.86;
  m_sheet.columns[3].columnwidth:=15.29;
  m_sheet.columns[4].columnwidth:=15.29;
  m_sheet.columns[5].columnwidth:=22;
  m_sheet.columns[6].columnwidth:=35;

  ColIndex:=2;

  for i:=0 to m_count-1 do begin
    if isESC then  Exit;

   // прогресс бар
   procentLoad:=i*100/m_count;
   procentLoadSTR:=FormatFloat('0.0',procentLoad);
   procentLoadSTR:=StringReplace(procentLoadSTR,',','.',[rfReplaceAll]);

   SetProgressStatusText('Создание отчета ['+procentLoadSTR+'%] ...');
   SetProgressBar(procentLoad);

    m_sheet.cells[ColIndex,1]:=IntToStr(m_history[i].id);   // ID
    m_sheet.cells[ColIndex,2]:=m_history[i].date_time;      // Дата\Время
    m_sheet.cells[ColIndex,3]:=m_history[i].phone;          // Телефон
    m_sheet.cells[ColIndex,4]:=m_history[i].trunk;          // Транк
    m_sheet.cells[ColIndex,5]:=m_history[i].phone_operator; // Оператор
    m_sheet.cells[ColIndex,6]:=m_history[i].region;         // Регион

    Inc(ColIndex);

     // проверка вдруг отменили операцию
     GetAbout;
  end;

  // наведем красоту
  begin
     SetProgressStatusText('Наводим красоту ...');

    // заголовок
    m_excel.range['A1:F1'].AutoFilter;   // фильтр для заголовка

    // Замораживаем заголовок
    m_sheet.Range['A2'].Select;
    m_excel.ActiveWindow.FreezePanes:=true;

    m_excel.range['A1:F1'].select;
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
    m_excel.range['A2:F'+inttostr(m_count+1)].select;
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
