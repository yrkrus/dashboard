 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                ����� ��� ���������� ��������� ��������                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TInternalProcessUnit;

interface

uses
  System.Classes, System.SysUtils,  TCustomTypeUnit, Data.Win.ADODB,
  Data.DB, Variants, IdException, TXmlUnit,  Winapi.PsAPI, Winapi.Windows;


 // class TInternalProcess
  type
      TInternalProcess = class
      private
      m_userLogonID       :Integer;                       // ������� ����������� ������������
      m_startedProgrammDate: TDateTime;                   // ����� ������� ���������
      isSendingProgrammStarted:Boolean;                   // ��� �� ���������� ���� � ������� ������� ���������

      function GetCurrentDateTimeWithTime:string;         // ������� ���� + �����
      function isExistFileUpdate:Boolean;                 // �������� �� ���� � �����������
      function GetMemoryLoad:string;                      // ������� �������� ������


      public
      constructor Create(InUserLogonID:Integer;
                         _startedProgrammDate:TDateTime);           overload;

      procedure UpdateTimeActiveSession(uptime:Integer);      // ���������� ������� �������� ����� ������������
      procedure CheckForceActiveSessionClosed;
      procedure UpdateTimeDashboard;                          // ���������� �������� ������� � ���� ��������
      procedure CheckStatusUpdateService;                     // �������� �������� �� ������ ���������� ��� ���
      procedure XMLUpdateLastOnline;                          // ���������� �������� � settings.xml
      procedure UpdateProgramStarted;                         // ���������� ������� �������� ���������
      procedure UpdateMemory;                                 // ���������� ���������� ����������



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

 // ������� ���� + �����
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

// �������� �� ���� � �����������
function TInternalProcess.isExistFileUpdate:Boolean;
var
  XML:TXML;
begin
  Result:=False;
  if not DirectoryExists(FOLDERUPDATE) then Exit;
  try
    XML:=TXML.Create(PChar(SETTINGS_XML));
    if FileExists(FOLDERUPDATE+'\'+XML.GetRemoteVersion+'.zip') then Result:=True;
  finally
    XML.Free;
  end;
end;

// ������� �������� ������
function TInternalProcess.GetMemoryLoad:string;
var
 pmc: PPROCESS_MEMORY_COUNTERS;
 cb: Integer;
 tmp:string;
begin
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

   {test.Add('������ ���.: '+ FloatToStr(pmc^.PageFaultCount));
      test.Add('����. �������. ������ (Kb): '+ FloatToStr(pmc^.PeakWorkingSetSize/1024));
      test.Add('����������� ��� (����.): '+ FloatToStr(pmc^.QuotaPeakPagedPoolUsage));
      test.Add('����������� ��� : '+ FloatToStr(pmc^.QuotaPagedPoolUsage));
      test.Add('��������. ��� (����.): '+ FloatToStr(pmc^.QuotaPeakNonPagedPoolUsage) );
      test.Add('��������. ��� : '+ FloatToStr(pmc^.QuotaNonPagedPoolUsage) );
      test.Add('����. ������ (Kb): '+ FloatToStr(pmc^.PagefileUsage/1024/1000));
      test.Add('����. ����. ������ (Kb): '+ FloatToStr(pmc^.PeakPagefileUsage/1024));
      test.Add('������ (Kb): ' + FloatToStr(pmc^.WorkingSetSize/1024));}
end;


// ���������� ������� �������� ����� ������������
procedure TInternalProcess.UpdateTimeActiveSession(uptime:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
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

// ���������� ������� �������� ���������
procedure TInternalProcess.UpdateProgramStarted;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  if isSendingProgrammStarted then Exit;

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


// ���������� ���������� ����������
procedure TInternalProcess.UpdateMemory;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 memory:string;
begin
  memory:=GetMemoryLoad;
  if memory='0' then Exit;

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


// ����� �� ���������� ������� ������ � ������� �������
procedure TInternalProcess.CheckForceActiveSessionClosed;
begin
  if GetForceActiveSessionClosed(m_userLogonID) then KillProcess;
end;

// ���������� �������� ������� � ���� ��������
procedure TInternalProcess.UpdateTimeDashboard;
begin
  with HomeForm.StatusBar do Panels[0].Text:=DateTimeToStr(now);
end;

// �������� �������� �� ������ ���������� ��� ���
procedure TInternalProcess.CheckStatusUpdateService;
begin
  with HomeForm.StatusBar do begin
    if GetStatusUpdateService then Panels[1].Text:='������ ����������: ��������'
    else Panels[1].Text:='������ ����������: �� ��������';
  end;
end;

// ���������� �������� � settings.xml
procedure TInternalProcess.XMLUpdateLastOnline;
var
  XML:TXML;
begin
  // ������� ������ ��������
  XML:=TXML.Create(PChar(SETTINGS_XML));
  XML.UpdateLastOnline;

  try
   if (XML.isUpdate) and (isExistFileUpdate) then begin
     HomeForm.lblNewVersionDashboard.Visible:=True;
     // ������������ �������
     SetRandomFontColor(HomeForm.lblNewVersionDashboard);
   end;
  finally
   XML.Free;
  end;
end;

end.