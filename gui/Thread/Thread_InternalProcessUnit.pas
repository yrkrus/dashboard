unit Thread_InternalProcessUnit;

interface

uses
    System.Classes,
    System.DateUtils,
    SysUtils,
    ActiveX,
    TLogFileUnit,
    TInternalProcessUnit,
    FormHome;

type
  Thread_InternalProcess = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_InternalProcess: TInternalProcess);
    procedure CriticalError;
  private
    Log:TLoggingFile;
    m_userLogonID:Integer;  // id ������������� ������������
    { Private declarations }
  public
  constructor Create(InUserID: Integer); reintroduce; // ��������� �����������

 // procedure AddLogonUserID(InUserID:Integer);

  end;

implementation

uses
  GlobalVariables, FormDEBUGUnit;

//procedure Thread_InternalProcess.AddLogonUserID(InUserID:Integer);
//begin
// Self.m_userLogonID:=InUserID;
//end;

constructor Thread_InternalProcess.Create(InUserID: Integer);
begin
  inherited Create(True); // ������� ����� � ���������������� ���������
  m_userLogonID := InUserID; // �������������� m_userLogonID
  Log := TLoggingFile.Create('Thread_InternalProcess');
end;


procedure Thread_InternalProcess.CriticalError;
begin
  // ���������� � ���
  Log.Save(messclass+'.'+mess,IS_ERROR);
end;


procedure Thread_InternalProcess.show(var p_InternalProcess: TInternalProcess);
begin
  // ������� ����� ���������� ��������� �� �������� �� ���� ���� �� ������� � �� ��� ���
   p_InternalProcess.UpdateTimeDashboard;

  if not CONNECT_BD_ERROR then begin
    p_InternalProcess.CheckForceActiveSessionClosed;  // ����� �� ���������� ������� ������
    p_InternalProcess.UpdateTimeActiveSession;        // ���������� ������� ������� � ��

    p_InternalProcess.CheckStatusUpdateService;       // �������� �������� �� ������ ����������

    p_InternalProcess.XMLUpdateLastOnline;            // ���������� �������� � settings.xml
  end;


end;

procedure Thread_InternalProcess.Execute;
 const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  InternalProcess: TInternalProcess;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(1000);

  InternalProcess:=TInternalProcess.Create(m_userLogonID);

  while not Terminated do
  begin

    if UpdateInternalProcess then  begin
     try
        StartTime:=GetTickCount;

        show(InternalProcess);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;

        FormDEBUG.lblThread_InternalProcess.Caption:=IntToStr(Duration);
     except
        on E:Exception do
        begin
         //INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
        // INTERNAL_ERROR:=False;
        end;
      end;
    end;

     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;
end.