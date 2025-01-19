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

    // записываем описание
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
  StartupInfo.wShowWindow := SW_HIDE; // Скрыть окно

  CreateProcess(nil, PChar('cmd.exe /C "' + BatchFilePath + '"'),nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo);

  // Создаем процесс для запуска .bat файла
  {if CreateProcess(nil, PChar('cmd.exe /C "' + BatchFilePath + '"'),
    nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // Ждем завершения процесса
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    // Получаем код завершения
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    // Обработка ошибок
    RaiseLastOSError;
  end; }
end;


// распаковывем zip архив
procedure UnPack(InFileName:string; var p_Log:TLoggingFile; var p_listUpdate:TStringList);
var
 ZipFile:TZipFile;
 i:Integer;
 FileName:string;
 folderDest:string;
begin
   p_Log.Save('Распаковка архива <b>'+InFileName+'</b>');
   folderDest:=FOLDERPATH+GetUpdateNameFolder;

   try
     ZipFile:=TZipFile.Create;
     ZipFile.Open(folderDest+'\'+InFileName, zmRead);

     try
        // Перебираем все файлы в архиве
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // Получаем имя файла
          // Извлекаем файл
          ZipFile.Extract(I, PChar(folderDest));
          // Отслеживаем извлечение
          p_Log.Save('Извлечен файл: <b>'+FileName+'</b>');
          p_listUpdate.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         p_Log.Save('Не удалось извлечь файл: <b>'+FileName+'</b> | '+e.Message,IS_ERROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(folderDest+'\'+InFileName);
   end;
end;

// создание установщика
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

      // закрываем exe
     Add('taskkill /F /IM '+DASHBOARD_EXE);
     Add('taskkill /F /IM '+CHAT_EXE);
     Add('taskkill /F /IM '+REPORT_EXE);
     Add('::');

     // закрываем обновлялку
     Add('net stop '+SERVICE_NAME);
     Add('::');

      // копируем новые файлы
      for i:=0 to p_listUpdate.Count-1 do begin
       Add('echo F | xcopy "%DirectoryUpdate%\'+p_listUpdate[i]+'"'+' "%Directory%'+p_listUpdate[i]+'" /Y /C');
      end;
      Add('::');

    // запускаем обновлялку
    Add('net start '+SERVICE_NAME);
    Add('exit')
   end;

   // сохраняем
   if FileExists(FOLDERPATH+UPDATE_BAT) then DeleteFile(FOLDERPATH+UPDATE_BAT);
   Bat.SaveToFile(FOLDERPATH+UPDATE_BAT);
end;

procedure Tupdate_dashboard.TimerMonitoringTimer(Sender: TObject);
const
 cTIMER_ERROR   :Cardinal = 60000;  // 1 мин
 cTIMER_OK      :Cardinal = 600000; // 10 мин
var
 XML:TXML;
 ftpClient:TFTP;
 log:TLoggingFile;
 remoteVersion:string;
 SLFilesUpdateList:TStringList;   //  список файлов которые будем обновлять

begin
// Sleep(3000);
 XML:=TXML.Create;
 log:=TLoggingFile.Create('update');
 log.Save('Проверка новой версии');

  if not XML.isExistSettingsFile then begin
    log.Save('Отсутствует файл настроек '+SETTINGS_XML, IS_ERROR);
    log.Save('Следующая попытка проверки новой версии через 1 мин');
    TimerMonitoring.Interval:=cTIMER_ERROR;
    Exit;
  end;

 // проверка вдруг уже в настоящий момент обновлямся
 if XML.isUpdate then begin
   log.Save('Обновление уже запущено, ожидание завершения процесса ... ',IS_ERROR);
   log.Save('Следующая попытка проверки новой версии через 1 мин');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
 end;

  // найдем текущую версию
  remoteVersion:=GetRemoteVersionDashboard;
  if remoteVersion='null' then begin
   log.Save('Не удается получить текущую версию дашборда', IS_ERROR);
   log.Save('Следующая попытка проверки новой версии через 1 мин');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
  end
  else begin
    // запишем текущую удаленную версию
    XML.UpdateRemoteVersion(remoteVersion);
  end;

  if CompareText(XML.GetCurrentVersion, XML.GetRemoteVersion) = 0 then begin
    log.Save('Актуальная версия');
    log.Save('Следующая попытка проверки новой версии через 10 мин');
    TimerMonitoring.Interval:=cTIMER_OK;
    Exit;
  end;

  log.Save('Обнаружена новая версия: <b>'+remoteVersion+'</b>');


  ftpClient:=TFTP.Create('update','update',eDownload,GetUpdateNameFolder);
  if not ftpClient.isConnect then begin
   log.Save('Не удается подключиться к ftp серверу ', IS_ERROR);
   log.Save('Следующая попытка проверки новой версии через 1 мин');
   TimerMonitoring.Interval:=cTIMER_ERROR;
   Exit;
  end;

  ftpClient.DownloadFile(remoteVersion+'.zip');

  // успешно скачали запуск обновления
  if ftpClient.isDownloadedFile(remoteVersion+'.zip') then begin
   log.Save('Установка новой версии: <b>'+remoteVersion+'</b>');

   while GetTask(DASHBOARD_EXE) do begin
    log.Save('Запущен родительский процесс: <b>'+DASHBOARD_EXE+'</b>. Ожидание закрытия процесса ...');
    Sleep(Round( cTIMER_ERROR / 6));
   end;

   SLFilesUpdateList:=TStringList.Create;

   // распаковываем
   UnPack(remoteVersion+'.zip', log, SLFilesUpdateList);

   // создаем cmd
    CreateCMD(XML,SLFilesUpdateList);
    if Assigned(SLFilesUpdateList) then FreeAndNil(SLFilesUpdateList);

    // запускаем
    if FileExists(FOLDERPATH+UPDATE_BAT) then begin

      // записываем инфо что обновляемся
      XML.isUpdate('true');

      ExecuteBatchFile(FOLDERPATH+UPDATE_BAT);
    end
    else begin
     log.Save('Не удалось создать дочерний процесс обновления ...', IS_ERROR);
     log.Save('Следующая попытка проверки новой версии через 1 мин');
     TimerMonitoring.Interval:=cTIMER_ERROR;
     Exit;
    end;
  end;

  log.Save('Следующая попытка проверки новой версии через 10 мин');
  TimerMonitoring.Interval:=cTIMER_OK;

  if Assigned(ftpClient) then FreeAndNil(ftpClient);
  if Assigned(XML) then FreeAndNil(XML);
end;

end.
