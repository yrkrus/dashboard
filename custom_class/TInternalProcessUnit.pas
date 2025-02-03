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
  System.Classes,
  System.SysUtils,
  TCustomTypeUnit,
  Data.Win.ADODB,
  Data.DB,
  Variants,
  IdException,
  TXmlUnit;


 // class TInternalProcess
  type
      TInternalProcess = class
      public
      constructor Create(InUserLogonID:Integer);                   overload;

      procedure UpdateTimeActiveSession;                      // ���������� ������� �������� ����� ������������
      procedure CheckForceActiveSessionClosed;
      procedure UpdateTimeDashboard;                          // ���������� �������� ������� � ���� ��������
      procedure CheckStatusUpdateService;                     // �������� �������� �� ������ ���������� ��� ���
      procedure XMLUpdateLastOnline;                          // ���������� �������� � settings.xml


      private
      m_userLogonID       :Integer;                       // ������� ����������� ������������
      function GetCurrentDateTimeWithTime:string;          // ������� ���� + �����



      end;
 // class TInternalProcess END

implementation

uses
  GlobalVariables, FunctionUnit, FormHome;


constructor TInternalProcess.Create(InUserLogonID:Integer);
 begin
  // inherited;
   m_userLogonID:=InUserLogonID;
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


// ���������� ������� �������� ����� ������������
procedure TInternalProcess.UpdateTimeActiveSession;
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

      SQL.Add('update active_session set last_active = '+#39+GetCurrentDateTimeWithTime+#39+' where user_id = '+#39+IntToStr(m_userLogonID)+#39);

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
  if getForceActiveSessionClosed(m_userLogonID) then KillProcess;
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

  if XML.isUpdate then begin
   HomeForm.lblNewVersionDashboard.Visible:=True;
   // ������������ �������
   SetRandomFontColor(HomeForm.lblNewVersionDashboard);
  end;

  XML.Free;
end;

end.