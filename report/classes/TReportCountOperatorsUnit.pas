/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TReportCountOperators                 ///
///                  "Отчет по количеству звонков операторами"                ///
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
  Data.Win.ADODB, Data.DB;



/////////////////////////////////////////////////////////////////////////////////////////
   // class TReportCountOperators
 type
       TReportCountOperators = class(TAbstractReport)

      public
      constructor Create(InNameReports:string;                    // название отчета
                         InDateStart,InDateStop:TDateTimePicker;   // даты отчета
                         InOnlyCurrentDay:Boolean                // только текщий день
                        );            overload;

      destructor Destroy;            override;

      procedure CreateReportExcel(const p_list:TCheckListBox); // создаем отчет

      private
      m_nameReport        :string;     // название отчета
      m_onlyCurrentDay    :Boolean;   // показ только текщего дня
      m_queue             :array of TQueueHistory;   // список с данными истории
      countQueue          :Integer;

      function GetOperatorsSIP(const p_list:TCheckListBox):TStringList;  // получение SIP операторов которые нужно в отчет впиндюрить

      procedure GenerateExcel;  // формирование данных в excel

      function FindFIO(InSipOperator:Integer):string;  // поиск фио оператора

      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables, TCustomTypeUnit;



constructor TReportCountOperators.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDateTimePicker;
                                         InOnlyCurrentDay:Boolean);
begin
  // инициализацуия родительского класса
  inherited Create(InDateStart.Date,InDateStop.Date);

  m_nameReport:=InNameReports;
  m_onlyCurrentDay:=InOnlyCurrentDay;
end;


destructor TReportCountOperators.Destroy;
var
 i:Integer;
begin
  for i:=Low(m_queue) to High(m_queue) do FreeAndNil(m_queue[i]);
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
      System.Delete(sip,AnsiPos(DELIMITER,sip),Length(sip));

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
 ado:TADOQuery;
 serverConnect:TADOConnection;
 table:string;
 countData:Integer;
 procentLoad:Integer;
begin
  // найдем список SIP для отчета
  listSIP:=GetOperatorsSIP(p_list);
  if listSIP.Count=0 then begin
    if Assigned(listSIP) then FreeAndNil(listSIP);
    Exit;
  end;

  listOperators:='';  // список sip
  for i:=0 to listSIP.Count-1 do begin
   if listOperators='' then listOperators:=#39+listSIP[i]+#39
   else listOperators:=listOperators+','+#39+listSIP[i]+#39;
  end;

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
      SQL.Add('select count(id) from '+table+' where sip IN ('+listOperators+')' );
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
        SQL.Add('select id,number_queue,phone,waiting_time,date_time,sip,talk_time from '+table+' where sip IN ('+listOperators+')' );
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
           m_queue[i].userFIO:=FindFIO(m_queue[i].sip);

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
  GenerateExcel;
end;


// поиск фио оператора
function TReportCountOperators.FindFIO(InSipOperator:Integer):string;
var
 i:Integer;
 isFinded:Boolean; // найдено фио
begin
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


// формирование данных в excel
procedure TReportCountOperators.GenerateExcel;
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


end.
