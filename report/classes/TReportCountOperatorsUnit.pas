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
      m_queue             : array of TQueueHistory;   // список с данными истории

      function GetOperatorsSIP(const p_list:TCheckListBox):TStringList;  // получение SIP операторов которые нужно в отчет впиндюрить

      procedure GenerateExcel;  // формирование данных в excel


      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables;



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
      SQL.Add('select count(id) from '+table+' where sip IN ('+listOperators+') and date_time >='+#39+GetDateToDateBD(GetDateStart)+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStop)+#39);

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
        for i:=0 to countData-1 do m_queue[i]:=TQueueHistory.Create;

        SQL.Clear;
        SQL.Add('select id,number_queue,phone,waiting_time,date_time,sip,talk_time from '+table+' where sip IN ('+listOperators+') and date_time >='+#39+GetDateToDateBD(GetDateStart)+#39+' and date_time<='+#39+GetDateToDateBD(GetDateStop)+#39);


        Active:=True;
        for i:=0 to countData-1 do begin
           if isESC then Exit;

           procentLoad:=Trunc(i*100/countData);

           SetProgressStatusText('Загрузка данных с сервера ['+IntToStr(procentLoad)+'%] ...');
           SetProgressBar(procentLoad);


           m_queue[i].id:=StrToInt(Fields[0].Value);
           m_queue[i].number_queue:=StrToInt(Fields[1].Value);
           m_queue[i].phone:=Fields[2].Value;
           m_queue[i].waiting_time:=Fields[3].Value;
           m_queue[i].date_time:=StrToDateTime(Fields[4].Value);
           m_queue[i].sip:=StrToInt(Fields[5].Value);
           m_queue[i].talk_time:=Fields[6].Value;

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
end;


// формирование данных в excel
procedure TReportCountOperators.GenerateExcel;
begin

end;



end.
