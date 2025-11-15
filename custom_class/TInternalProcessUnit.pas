 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                Класс для внутренних процессов дашборда                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TInternalProcessUnit;

interface

uses
  System.Classes, System.SysUtils,  TCustomTypeUnit, Data.Win.ADODB,
  Data.DB, Variants, IdException, TXmlUnit,  Winapi.PsAPI, Winapi.Windows,
  TPhoneListUnit;


 // class TInternalProcess
  type
      TInternalProcess = class
      private
      m_userLogonID             :Integer;                 // текущий залогиненый пользователь
      m_startedProgrammDate     :TDateTime;               // время запуска программы
      isSendingProgrammStarted  :Boolean;                 // был ли отправлено инфо о времени запуска программы



      function GetCurrentDateTimeWithTime:string;         // текущая дата + время
      function isExistFileUpdate:Boolean;                 // загружен ли файл с обновлением
      function GetMemoryLoad:string;                      // текущая загрузка памяти


      public
      constructor Create(InUserLogonID:Integer;
                         _startedProgrammDate:TDateTime);           overload;

      procedure UpdateTimeActiveSession(uptime:Integer);      // обновление времени активной сесии пользователя
      procedure CheckForceActiveSessionClosed;
      procedure UpdateTimeDashboard;                          // обновление текущего времени в окне дашборда
      procedure CheckStatusUpdateService;                     // проверка работает ли служба обновления или нет
      procedure CheckStatusRegisteredSipPhone;                // проверка зарегестирован ли sip в телефоне
      procedure XMLUpdateLastOnline;                          // обновление времемни в settings.xml
      procedure UpdateProgramStarted;                         // обновление времени запкуска программы
      procedure UpdateMemory;                                 // обновление занимаемой оперативки



      end;
 // class TInternalProcess END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, FunctionUnit, FormHome;


constructor TInternalProcess.Create(InUserLogonID:Integer;
                                    _startedProgrammDate:TDateTime);
 begin
  // inherited;
   m_userLogonID:=InUserLogonID;
   m_startedProgrammDate:=_startedProgrammDate;
   isSendingProgrammStarted:=False;
 end;

 // текущая дата + время
function TInternalProcess.GetCurrentDateTimeWithTime:string;
var
 tmpdate:string;
 tmp_year,tmp_month,tmp_day:string;
 times:TTime;
begin
  tmpdate:=DateToStr(Now);

  tmp_year:=tmpdate;
  System.Delete(tmp_year,1,6);

  tmp_month:=tmpdate;
  System.Delete(tmp_month,1,3);
  System.Delete(tmp_month,3,Length(tmp_month));

  tmp_day:=tmpdate;
  System.Delete(tmp_day,3,Length(tmp_day));

  times:=Now;

  Result:=tmp_year+'-'+tmp_month+'-'+tmp_day+' '+TimeToStr(times);
end;

// загружен ли файл с обновлением
function TInternalProcess.isExistFileUpdate:Boolean;
var
  XML:TXML;
begin
  if not HomeForm.IsInit then Exit;

  Result:=False;
  if not DirectoryExists(FOLDERUPDATE) then Exit;
  try
    XML:=TXML.Create(PChar(SETTINGS_XML));
    if FileExists(FOLDERUPDATE+'\'+XML.GetRemoteVersion+'.zip') then Result:=True;
  finally
    XML.Free;
  end;
end;

// текущая загрузка памяти
function TInternalProcess.GetMemoryLoad:string;
var
 pmc: PPROCESS_MEMORY_COUNTERS;
 cb: Integer;
 tmp:string;
begin
  if not HomeForm.IsInit then Exit;

  Result:='0';

  cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
  GetMem(pmc, cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcess(), pmc, cb) then
  begin
  // tmp:=FormatFloat('0.#',pmc^.PagefileUsage/1024/1000);
   tmp:=FormatFloat('0.##',pmc^.WorkingSetSize/1024/1000);
   tmp:=StringReplace(tmp,',','.',[rfReplaceAll]);

   Result:=tmp;
  end;

  FreeMem(pmc);

   {test.Add('Ошибок стр.: '+ FloatToStr(pmc^.PageFaultCount));
      test.Add('Макс. использ. памяти (Kb): '+ FloatToStr(pmc^.PeakWorkingSetSize/1024));
      test.Add('Выгружаемый пул (макс.): '+ FloatToStr(pmc^.QuotaPeakPagedPoolUsage));
      test.Add('Выгружаемый пул : '+ FloatToStr(pmc^.QuotaPagedPoolUsage));
      test.Add('Невыгруж. пул (макс.): '+ FloatToStr(pmc^.QuotaPeakNonPagedPoolUsage) );
      test.Add('Невыгруж. пул : '+ FloatToStr(pmc^.QuotaNonPagedPoolUsage) );
      test.Add('Вирт. память (Kb): '+ FloatToStr(pmc^.PagefileUsage/1024/1000));
      test.Add('Макс. вирт. память (Kb): '+ FloatToStr(pmc^.PeakPagefileUsage/1024));
      test.Add('Память (Kb): ' + FloatToStr(pmc^.WorkingSetSize/1024));}
end;


// обновление времени активной сесии пользователя
procedure TInternalProcess.UpdateTimeActiveSession(uptime:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  if not HomeForm.IsInit then Exit;

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

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update active_session set last_active = '+#39+GetCurrentDateTimeWithTime+#39+', uptime = '+#39+IntToStr(uptime)+#39+' where user_id = '+#39+IntToStr(m_userLogonID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;

             Exit;
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

// обновление времени запкуска программы
procedure TInternalProcess.UpdateProgramStarted;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  if not HomeForm.IsInit then Exit;

  if isSendingProgrammStarted then Exit;

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

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update active_session set started_programm = '+#39+GetDateTimeToDateBD(DateTimeToStr(m_startedProgrammDate))+#39+' where user_id = '+#39+IntToStr(m_userLogonID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;

             Exit;
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

  isSendingProgrammStarted:=True;
end;


// обновление занимаемой оперативки
procedure TInternalProcess.UpdateMemory;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 memory:string;
begin
  memory:=GetMemoryLoad;
  if memory='0' then Exit;

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

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update active_session set memory = '+#39+memory+#39+' where user_id = '+#39+IntToStr(m_userLogonID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;

             Exit;
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


// нужно ли немедленно закрыть сессию и закрыть дашборд
procedure TInternalProcess.CheckForceActiveSessionClosed;
begin
  if not HomeForm.IsInit then Exit;

  if GetForceActiveSessionClosed(m_userLogonID) then KillProcess;
end;

// обновление текущего времени в окне дашборда
procedure TInternalProcess.UpdateTimeDashboard;
begin
  if not HomeForm.IsInit then Exit;

  with HomeForm.StatusBar do Panels[0].Text:=DateTimeToStr(now);
end;

// проверка работает ли служба обновления или нет
procedure TInternalProcess.CheckStatusUpdateService;
begin
  if not HomeForm.IsInit then Exit;

  with HomeForm.StatusBar do begin
    if GetStatusUpdateService then Panels[1].Text:='Служба обновления: работает'
    else Panels[1].Text:='Служба обновления: не запущена';
  end;
end;

 // проверка зарегестирован ли sip в телефоне
procedure TInternalProcess.CheckStatusRegisteredSipPhone;
var
 sip:Integer;
 ip:string;
begin
  if not HomeForm.IsInit then Exit;

  if SharedCurrentUserLogon.IsOperator then begin

    sip:=_dll_GetOperatorSIP(SharedCurrentUserLogon.ID);
    if sip = -1 then Exit;

    with HomeForm.StatusBar do begin
      if GetStatusRegisteredSipPhone(sip,ip) then begin
        Panels[2].Text:='Регистрация телефона: '+ip;
      end
      else begin
        Panels[2].Text:='Регистрация телефона [---]';
      end;
    end;

  end;
end;


// обновление времемни в settings.xml
procedure TInternalProcess.XMLUpdateLastOnline;
var
  XML:TXML;
begin
  if not HomeForm.IsInit then Exit;

  try
    // текущая версия дашборда
    XML:=TXML.Create(PChar(SETTINGS_XML));
    XML.UpdateLastOnline;

   if (XML.isUpdate) and (isExistFileUpdate) then begin
     HomeForm.lblNewVersionDashboard.Visible:=True;

     with HomeForm.lblNewVersionDashboard do begin
       if Visible then Visible:=False
       else Visible:=True;
     end;
   end;
  finally
   XML.Free;
  end;
end;

end.