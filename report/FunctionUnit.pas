unit FunctionUnit;


interface

uses
  Data.Win.ADODB, Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,System.DateUtils, ActiveX,
  System.Win.ComObj, TCustomTypeUnit, Vcl.CheckLst, Vcl.ExtCtrls;


  procedure createCopyright;                                                 // создание Copyright
  procedure HappyNewYear;                                                    // пасхалка с новым годом
  function GetOnlyOperatorsRoleID:TStringList;                               // получение только операторские ID роли
  function getUserSIP(InIDUser:integer):string;                              // отображение SIP пользвоателя
  function SetFindDate(var _startDate:TDateTimePicker;                       // установка дата начала и конца времени отбора
                       var _stopDate:TDateTimePicker;
                       var _errorDescriptions:string):Boolean;
  function isExistExcel(var _errorDescriptions:string):Boolean;              // проверка установлен ли excel
  procedure ShowProgressBar;                                                 // показываем прогресс бар
  procedure CloseProgressBar;                                                // закрываем прогресс бар
  procedure SetStatusProgressBarText(InText:string);                         // установка текста статуса прогресс бара
  procedure SetStatusProgressBar(InProgress:Integer);  overload;             // установка статуса прогресс бара
  procedure SetStatusProgressBar(InProgress:Double);   overload;             // установка статуса прогресс бара
  function GetAboutGenerateReport:Boolean;                                   // отмена генерации отчета
  function CountOnHoldDateInterval(_table:enumReportTableCountCallsOperatorOnHold;
                                   _dateStart:TDate;
                                   _dateStop:TDate;
                                   _sip:string):Integer; // кол-во секунд в статусе onHold за интервал дат
  function CountOnHoldDay(_sip:string;
                       _date:TDate;
                       _table:enumReportTableCountCallsOperatorOnHold):Integer;  // кол-во секунд в статусе onHold за день
  function CountOnHoldPhone(_sip:string;
                       _phone:string;
                       _date:TDate;
                       _table:enumReportTableCountCallsOperatorOnHold):Integer;   // кол-во секунд в статусе onHold за номер

  procedure CursourHover(var _label:TLabel; _state:enumCursorHover);        // изменение стиля label при наведении\убирании мышки
  procedure LoadingListOperatorsForm(var _listUsers:TCheckListBox;
                                          InShowDisableUsers:Boolean = False);   // прогрузка текущих пользователей на форму
  procedure CreateImageReport(_countRepot:Word);                                   // создание иконки рядом с отчетами
  procedure FindSipCallOperators(var _listUsers:TStringList; _dateStart, _dateStop:Tdate);  //поиск sip номеров которые разговаривали в период заданного времени

implementation

uses
 FormHomeUnit, GlobalVariables, FormWaitUnit, GlobalVariablesLinkDLL, GlobalImageDestination;

// создание Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[0].Text:=GetCopyright;
  end;
end;

// пасхалка с новым годом
procedure HappyNewYear;
var
  DateNachalo: TDateTime;
begin
  // Определяем дату Нового года
  DateNachalo := EncodeDateTime(YearOf(Now) + 1, 1, 1, 0, 0, 0, 0);

  // Проверяем, находится ли текущая дата в диапазоне от 7 дней до Нового года и 8 дней после
  if (DaysBetween(Now, DateNachalo) <= 8) and (DaysBetween(Now, DateNachalo) >= -7) then
  begin
   FormHome.ImgNewYear.Visible:=True;
  end;
end;


// получение только операторские ID роли
function GetOnlyOperatorsRoleID:TStringList;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countID:Cardinal;
begin
  Result:=TStringList.Create;

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
      SQL.Add('select count(id) from role where id <> ''-1'' and only_operators = ''1'' ');

      Active:=True;
      countID:= Fields[0].Value;

      if countID<>0 then begin

        SQL.Clear;
        SQL.Add('select id from role where id <> ''-1'' and only_operators = ''1'' ');

        Active:=True;
        for i:=0 to countID-1 do begin
           Result.Add(VarToStr(Fields[0].Value));
           ado.Next;
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
end;

// отображение SIP пользвоателя
function getUserSIP(InIDUser:integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

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
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InIDUser)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value);
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// установка дата начала и конца времени отбора
function SetFindDate(var _startDate:TDateTimePicker;
                     var _stopDate:TDateTimePicker;
                     var _errorDescriptions:string):Boolean;
var
  CurrentDate: TDateTime;
  FirstDayOfPreviousMonth: TDateTime;
  LastDayOfPreviousMonth: TDateTime;
begin
 Result:=False;
 _errorDescriptions:='';

   try
      // Получаем текущую дату
      CurrentDate := Now;

      // Получаем первое число предыдущего месяца
      if MonthOf(CurrentDate) = 1 then FirstDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate) - 1, 12, 1) // Декабрь прошлого года
      else FirstDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate), MonthOf(CurrentDate) - 1, 1);

       // Получаем последний день предыдущего месяца
      if MonthOf(CurrentDate) = 1 then LastDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate) - 1, 12, 31) // Последний день декабря прошлого года
      else LastDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate), MonthOf(CurrentDate), 1) - 1;

      _startDate.DateTime:=FirstDayOfPreviousMonth;
      _stopDate.DateTime:=LastDayOfPreviousMonth;

      Result:=True;
   except
      on E: Exception do begin
        _errorDescriptions:=e.ClassName+#13+E.Message;
      end;
   end;
end;


// проверка установлен ли excel
function isExistExcel(var _errorDescriptions:string):Boolean;
var
  Excel:OleVariant;
begin
  Result:=False;
  _errorDescriptions:='';

  try
    Excel:=CreateOleObject('Excel.Application');
    Excel:=Unassigned; // Освобождаем объект

    Result:=True; // Если объект создан, значит Excel установлен
  except
    on E: Exception do begin
      _errorDescriptions:=e.ClassName+#13+E.Message;
    end;
  end;
end;

// показываем прогресс бар
procedure ShowProgressBar;
begin
  with FormWait do begin
   ProgressBar.Progress:=0;
   ProgressStatusText.Caption:='Статус: ';
   Show;
  end;
end;

// закрываем прогресс бар
procedure CloseProgressBar;
begin
  if FormWait.Showing then FormWait.Close;
end;

// установка текста статуса прогресс бара
procedure SetStatusProgressBarText(InText:string);
begin
  FormWait.ProgressStatusText.Caption:='Статус: '+InText;
  Application.ProcessMessages;
end;


// установка статуса прогресс бара
procedure SetStatusProgressBar(InProgress:Integer);
begin
  FormWait.ProgressBar.Progress:=InProgress;
  Application.ProcessMessages;
end;


// установка статуса прогресс бара
procedure SetStatusProgressBar(InProgress:double);
var
 value:integer;
begin
  value:=Trunc(InProgress);

  FormWait.ProgressBar.Progress:=value;
  Application.ProcessMessages;
end;


// отмена генерации отчета
function GetAboutGenerateReport:Boolean;
begin
  Result:=FormWait.isAboutGenerate;
end;


// кол-во секунд в статусе onHold за интервал дат
function CountOnHoldDateInterval(_table:enumReportTableCountCallsOperatorOnHold;
                                 _dateStart:TDate;
                                 _dateStop:TDate;
                                 _sip:string):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 seconds:Integer;
 secondsAll:Integer;
begin
 Result:=0;
  secondsAll:=0;

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
      SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')'+
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_dateStart))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_dateStop))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

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

      SQL.Clear;
      SQL.Add('select date_time_start,date_time_stop from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')' +
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_dateStart))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_dateStop))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

      Active:=True;
      for i:=0 to countData-1 do begin
        seconds:= SecondsBetween(StrToDateTime(Fields[0].Value), StrToDateTime(Fields[1].Value));

        //общее время
        secondsAll := secondsAll + seconds;

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

  Result:=secondsAll;
end;


// кол-во секунд в статусе onHold за день
function CountOnHoldDay(_sip:string; _date:TDate; _table:enumReportTableCountCallsOperatorOnHold):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 seconds:Integer;
 secondsAll:Integer;
begin
  Result:=0;
  secondsAll:=0;

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
      SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')'+
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

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

      SQL.Clear;
      SQL.Add('select date_time_start,date_time_stop from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')' +
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

      Active:=True;
      for i:=0 to countData-1 do begin
        seconds:= SecondsBetween(StrToDateTime(Fields[0].Value), StrToDateTime(Fields[1].Value));

        //общее время
        secondsAll := secondsAll + seconds;

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

  Result:=secondsAll;
end;

// кол-во секунд в статусе onHold за номер
function CountOnHoldPhone(_sip:string;
                     _phone:string;
                     _date:TDate;
                     _table:enumReportTableCountCallsOperatorOnHold):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 seconds:Integer;
 secondsAll:Integer;
begin
  Result:=0;
  secondsAll:=0;

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
      SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')'+
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL and phone = '+#39+_phone+#39);

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

      SQL.Clear;
      SQL.Add('select date_time_start,date_time_stop from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')' +
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL and phone = '+#39+_phone+#39);

      Active:=True;
      for i:=0 to countData-1 do begin
        seconds:= SecondsBetween(StrToDateTime(Fields[0].Value), StrToDateTime(Fields[1].Value));

        //общее время
        secondsAll := secondsAll + seconds;

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

  Result:=secondsAll;
end;


// изменение стиля label при наведении\убирании мышки
procedure CursourHover(var _label:TLabel; _state:enumCursorHover);
begin
  _label.Cursor:=crHandPoint;

  case _state of
   eMouseLeave:begin
     _label.Font.Style:=[fsBold];
   end;
   eMouseMove:begin
    _label.Font.Style:=[fsUnderline,fsBold];
   end;
  end;
end;


//поиск sip номеров которые разговаривали в период заданного времени
procedure FindSipCallOperators(var _listUsers:TStringList; _dateStart, _dateStop:Tdate);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countSip,i:Integer;
 only_operators_roleID:TStringList;
 id_operators:string;
 request:TStringBuilder;
begin
  Screen.Cursor:=crHourGlass;
  _listUsers.Clear;

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

      begin
        request:=TStringBuilder.Create;
        with request do begin
         Append('select count(distinct sip)');
         Append(' from '+EnumReportTableCountCallsOperatorToString(eTableHistoryQueue));
         Append(' where date_time between '+#39+GetDateToDateBD(DateToStr(_dateStart))+' 00:00:00'+#39+' and '+#39+GetDateToDateBD(DateToStr(_dateStop))+' 23:59:59'+#39);
         Append(' and sip <> ''-1'' ');
        end;

        SQL.Add(request.ToString);
      end;

      Active:=True;
      countSip:=Fields[0].Value;
    end;

    with ado do begin
      SQL.Clear;
      begin
        request:=TStringBuilder.Create;
        with request do begin
         Append('select distinct sip');
         Append(' from '+EnumReportTableCountCallsOperatorToString(eTableHistoryQueue));
         Append(' where date_time between '+#39+GetDateToDateBD(DateToStr(_dateStart))+' 00:00:00'+#39+' and '+#39+GetDateToDateBD(DateToStr(_dateStop))+' 23:59:59'+#39);
         Append(' and sip <> ''-1'' ');
        end;

        SQL.Add(request.ToString);
      end;

      Active:=True;

       for i:=0 to countSip-1 do begin
         _listUsers.Add(VarToStr(Fields[0].Value));
         ado.Next;
       end;
    end;

  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;

    Screen.Cursor:=crDefault;
  end;
end;


// прогрузка текущих пользователей на форму
procedure LoadingListOperatorsForm(var _listUsers:TCheckListBox; InShowDisableUsers:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 only_operators_roleID:TStringList;
 id_operators:string;
 request:TStringBuilder;

 commonQueueSTR:string;  // список с очередями которые видит пользователь

begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  commonQueueSTR:=SharedUserCommonQueue.ActiveQueueSTRToBase;
  request:=TStringBuilder.Create;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      begin
        only_operators_roleID:=GetOnlyOperatorsRoleID;
        for i:=0 to only_operators_roleID.Count-1 do begin
          if id_operators='' then id_operators:=#39+only_operators_roleID[i]+#39
          else id_operators:=id_operators+','#39+only_operators_roleID[i]+#39;
        end;

        with request do begin

                 fdhdfh

        end;


        if InShowDisableUsers=False then SQL.Add('select count(id) from users where disabled =''0'' and role IN('+id_operators+') ')
        else SQL.Add('select count(id) from users where disabled =''1'' and role IN('+id_operators+') ');
       if only_operators_roleID<>nil then FreeAndNil(only_operators_roleID);
      end;

      Active:=True;

      countUsers:=Fields[0].Value;
    end;

    _listUsers.Clear;

      with ado do begin
        SQL.Clear;
        begin
         if InShowDisableUsers=False then SQL.Add('select familiya,name,id from users where disabled = ''0'' and role IN('+id_operators+') order by familiya ASC')
         else SQL.Add('select familiya,name,id from users where disabled = ''1'' and role IN('+id_operators+') order by familiya ASC');
        end;

        Active:=True;

         for i:=0 to countUsers-1 do begin
           _listUsers.Items.Add(Fields[0].Value+' '+Fields[1].Value + '('+getUserSIP(Fields[2].Value)+')');
           ado.Next;
         end;
      end;

  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;

    Screen.Cursor:=crDefault;
  end;
end;

// создание иконки рядом с отчетами
procedure CreateImageReport(_countRepot:Word);
const
 cSTEP:Word = 20; // шаг
 cTOP_START:Word = 10;
 cLEFT:Word = 10;
var
  bmp:TBitmap;
  imgLbl:TArray<TImage>;  // массив с
  i:Integer;
begin
  if not FileExists(ICON_REPORT) then Exit;

  // Создание объекта TBitmap
  bmp:=TBitmap.Create;
  try
    // Загрузка изображения из файла
    bmp.LoadFromFile(ICON_REPORT);
  except

  end;
  if not Assigned(bmp) then Exit;

  SetLength(imgLbl, _countRepot);

  for i:=0 to _countRepot - 1 do begin
   imgLbl[i]:=TImage.Create(FormHome);
   imgLbl[i].Picture.Bitmap.Assign(bmp);

   // позиционирование
   imgLbl[i].Parent := FormHome;
   imgLbl[i].Left   := cLEFT;

   if i=0 then imgLbl[i].Top:=cTOP_START
   else imgLbl[i].Top:=cTOP_START+(cSTEP * i);
  end;
end;


end.
