unit dashboard_update;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr,
  Vcl.Dialogs,Registry, Vcl.ExtCtrls, System.Zip;

type
  Tupdate_dashboard = class(TService)
    TimerMonitoring: TTimer;
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure TimerMonitoringTimer(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  update_dashboard: Tupdate_dashboard;

implementation

uses
  GlobalVariables, TXmlUnit, TLogFileUnit, TFTPUnit, TCustomTypeUnit;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  update_dashboard.Controller(CtrlCode);
end;

function Tupdate_dashboard.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure Tupdate_dashboard.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
  ServiceName,path,path2 : string;
begin
  ServiceName:=SERVICE_NAME;
  path:='\SYSTEM\CurrentControlSet\services\Eventlog\Application\';
  path2:='\SYSTEM\CurrentControlSet\services\';

  reg:=TRegistry.Create(KEY_ALL_ACCESS);
 with reg do begin
  try
    RootKey:=HKEY_LOCAL_MACHINE;
    OpenKey(path+ServiceName, True);
    WriteString('EventMessageFile',ParamStr(0));
    WriteInteger('TypesSupported',7);

    // ���������� ��������
    OpenKey(path2+ServiceName,False);
    WriteString('Description',SERVICE_DESCRIPTION);
   finally
    FreeAndNil(reg);
  end;
 end;
end;

procedure Tupdate_dashboard.ServiceAfterUninstall(Sender: TService);
var
  reg: TRegistry;
  ServiceName,path,path2 : string;
begin
  ServiceName:=SERVICE_NAME;
  path:='\SYSTEM\CurrentControlSet\services\Eventlog\Application\';
  path2:='\SYSTEM\CurrentControlSet\services\';

  reg:=TRegistry.Create(KEY_ALL_ACCESS);
  try
   reg.RootKey:=HKEY_LOCAL_MACHINE;
   reg.OpenKey(path+ServiceName,False);
   reg.DeleteValue('TypesSupported');
   reg.DeleteValue('EventMessageFile');
   reg.DeleteKey(path+ServiceName);
   finally
    FreeAndNil(reg);
  end;
end;

procedure Tupdate_dashboard.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  Continued:=True;
end;

procedure Tupdate_dashboard.ServiceExecute(Sender: TService);
begin
 while not terminated do
 begin
   ServiceThread.ProcessRequests(False);
 end;
end;

procedure Tupdate_dashboard.ServicePause(Sender: TService; var Paused: Boolean);
begin
    Paused:=True;
end;

procedure Tupdate_dashboard.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  TimerMonitoring.Enabled:=True;
end;

procedure Tupdate_dashboard.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
 TimerMonitoring.Enabled:=False;
 Stopped:=True;
end;


procedure ExecuteBatchFile(const BatchFilePath: string);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ExitCode: DWORD;
begin
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE; // ������ ����

  CreateProcess(nil, PChar('cmd.exe /C "' + BatchFilePath + '"'),nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo);

  // ������� ������� ��� ������� .bat �����
  {if CreateProcess(nil, PChar('cmd.exe /C "' + BatchFilePath + '"'),
    nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // ���� ���������� ��������
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    // �������� ��� ����������
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    // ��������� ������
    RaiseLastOSError;
  end; }
end;


// ������������ zip �����
procedure UnPack(InFileName:string; var p_Log:TLoggingFile; var p_listUpdate:TStringList);
var
 ZipFile:TZipFile;
 i:Integer;
 FileName:string;
 folderDest:string;
begin
   p_Log.Save('���������� ������ <b>'+InFileName+'</b>');
   folderDest:=FOLDERPATH+GetUpdateNameFolder;

   try
     ZipFile:=TZipFile.Create;
     ZipFile.Open(folderDest+'\'+InFileName, zmRead);

     try
        // ���������� ��� ����� � ������
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // �������� ��� �����
          // ��������� ����
          ZipFile.Extract(I, PChar(folderDest));
          // ����������� ����������
          p_Log.Save('�������� ����: <b>'+FileName+'</b>');
          p_listUpdate.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         p_Log.Save('�� ������� ������� ����: <b>'+FileName+'</b> | '+e.Message,IS_ERROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(folderDest+'\'+InFileName);
   end;
end;

// �������� �����������
procedure CreateCMD(var p_XML:TXML; var p_listUpdate:TStringList);
var
  Bat:TStringList;
  i:Integer;
begin
  Bat:=TStringList.Create;
   with Bat do begin
     Add('@echo off');
     Add('set DirectoryUpdate='+FOLDERPATH+GetUpdateNameFolder);
     Add('set Directory='+FOLDERPATH);
     Add('::');
     Add('echo                      AutoUpdate Dashboard ');
     Add('echo                  upgrade '+p_XML.GetCurrentVersion+' to '+p_XML.GetRemoteVersion);
     Add('echo                    started after 2 sec ...');
     Add('echo.');
     Add('ping -n 2 localhost>Nul');
     Add('::');

      // ��������� exe
     Add('taskkill /F /IM '+DASHBOARD_EXE);
     Add('taskkill /F /IM '+CHAT_EXE);
     Add('taskkill /F /IM '+REPORT_EXE);
     Add('::');

     // ��������� ����������
     Add('net stop '+SERVICE_NAME);
     Add('::');

      // �������� ����� �����
      for i:=0 to p_listUpdate.Count-1 do begin
       Add('echo F | xcopy "%DirectoryUpdate%\'+p_listUpdate[i]+'"'+' "%Directory%'+p_listUpdate[i]+'" /Y /C');
      end;
      Add('::');

    // ��������� ����������
    Add('net start '+SERVICE_NAME);
    Add('exit')
   end;

   // ���������
   if FileExists(FOLDERPATH+UPDATE_BAT) then DeleteFile(FOLDERPATH+UPDATE_BAT);
   Bat.SaveToFile(FOLDERPATH+UPDATE_BAT);
end;

procedure Tupdate_dashboard.TimerMonitoringTimer(Sender: TObject);
const
 cTIMER_ERROR   :Cardinal = 60000;  // 1 ���
 cTIMER_OK      :Cardinal = 600000; // 10 ���
var
 XML:TXML;
 ftpClient:TFTP;
 log:TLoggingFile;
 remoteVersion:string;
 SLFilesUpdateList:TStringList;   //  ������ ������ ������� ����� ���������

begin
// Sleep(3000);
 XML:=TXML.Create;
 log:=TLoggingFile.Create('update');
 log.Save('�������� ����� ������');

  if not XML.isExistSettingsFile then begin
    log.Save('����������� ���� �������� '+SETTINGS_XML, IS_ERROR);
    log.Save('��������� ������� �������� ����� ������ ����� 1 ���');
    TimerMonitoring.Interval:=cTIMER_ERROR;
    Exit;
  end;

 // �������� ����� ��� � ��������� ������ ����������
 if XML.isUpdate then begin
   log.Save('���������� ��� ��������, �������� ���������� �������� ... ',IS_ERROR);
   log.Save('��������� ������� �������� ����� ������ ����� 1 ���');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
 end;

  // ������ ������� ������
  remoteVersion:=GetRemoteVersionDashboard;
  if remoteVersion='null' then begin
   log.Save('�� ������� �������� ������� ������ ��������', IS_ERROR);
   log.Save('��������� ������� �������� ����� ������ ����� 1 ���');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
  end
  else begin
    // ������� ������� ��������� ������
    XML.UpdateRemoteVersion(remoteVersion);
  end;

  if CompareText(XML.GetCurrentVersion, XML.GetRemoteVersion) = 0 then begin
    log.Save('���������� ������');
    log.Save('��������� ������� �������� ����� ������ ����� 10 ���');
    TimerMonitoring.Interval:=cTIMER_OK;
    Exit;
  end;

  log.Save('���������� ����� ������: <b>'+remoteVersion+'</b>');


  ftpClient:=TFTP.Create('update','update',eDownload,GetUpdateNameFolder);
  if not ftpClient.isConnect then begin
   log.Save('�� ������� ������������ � ftp ������� ', IS_ERROR);
   log.Save('��������� ������� �������� ����� ������ ����� 1 ���');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
  end;

  ftpClient.DownloadFile(remoteVersion+'.zip');

  // ������� ������� ������ ����������
  if ftpClient.isDownloadedFile(remoteVersion+'.zip') then begin
   log.Save('��������� ����� ������: <b>'+remoteVersion+'</b>');

   while GetTask(DASHBOARD_EXE) do begin
    log.Save('������� ������������ �������: <b>'+DASHBOARD_EXE+'</b>. �������� �������� �������� ...');
    Sleep(Round( cTIMER_ERROR / 6));
   end;

   SLFilesUpdateList:=TStringList.Create;

   // �������������
   UnPack(remoteVersion+'.zip', log, SLFilesUpdateList);

   // ������� cmd
    CreateCMD(XML,SLFilesUpdateList);
    if Assigned(SLFilesUpdateList) then FreeAndNil(SLFilesUpdateList);

    // ���������
    if FileExists(FOLDERPATH+UPDATE_BAT) then begin

      // ���������� ���� ��� �����������
      XML.isUpdate('true');

      ExecuteBatchFile(FOLDERPATH+UPDATE_BAT);
    end
    else begin
     log.Save('�� ������� ������� �������� ������� ���������� ...', IS_ERROR);
     log.Save('��������� ������� �������� ����� ������ ����� 1 ���');
     TimerMonitoring.Interval:=cTIMER_ERROR;
     Exit;
    end;
  end;

  log.Save('��������� ������� �������� ����� ������ ����� 10 ���');
  TimerMonitoring.Interval:=cTIMER_OK;

  if Assigned(ftpClient) then FreeAndNil(ftpClient);
  if Assigned(XML) then FreeAndNil(XML);
end;

end.
