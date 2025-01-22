program install;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Types,
  Winapi.Windows,
  System.Classes,
  System.IOUtils,
  ActiveX,
  ComObj,
  ShellAPI,
  ACLAPI,
  Registry,
  System.Zip,
  GlobalVariables in '..\services\delphi\GlobalVariables.pas',
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TFTPUnit in '..\custom_class\TFTPUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas';

const
 cSLEEP_ERRROR:Cardinal = 9000000;  //  такое большое значение т.к. чтобы в вечный sleep ушел
 FOREGROUND_BLUE        = 1;        // Синий цвет
 FOREGROUND_RED         = 4;        // Красный цвет
 FOREGROUND_GREEN       = 2;        // Зеленый цвет
 FOREGROUND_INTENSITY   = 8;        // Яркость



var
 SLCopyList:TStringList;
 CurrentVersionDashboard:string;
 Command: string;
 TargetExe:string;  // Путь к exe файлу
 ShortcutExe:string; // Путь к ярлыку обязательно с *.lnk!!


// проверка запущен ли install от имени администратора
function EnablePrivilege(const Value: Boolean; privilegename:string): Boolean;
var
  hToken: THandle;
  tp: TOKEN_PRIVILEGES;
  d: DWORD;
begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken) then
  begin
    tp.PrivilegeCount := 1;
    LookupPrivilegeValue(nil, pchar(privilegename), tp.Privileges[0].Luid);
    if Value then
      tp.Privileges[0].Attributes := $00000002
    else
      tp.Privileges[0].Attributes := $80000000;
    AdjustTokenPrivileges(hToken, False, tp, SizeOf(TOKEN_PRIVILEGES), nil, d);
    if GetLastError = ERROR_SUCCESS then
    begin
      Result := True;
    end;
    CloseHandle(hToken);
  end;
end;


 // очистка папки инсталляции
procedure ClearFolderInstall(InFileName:string);
var
 install:string;
begin
  install:=FOLDERPATH+FOLDER_INSTALL;
  if FileExists(install+'\'+InFileName) then DeleteFile(PChar(install+'\'+InFileName));
  if DirectoryExists(install) then TDirectory.Delete(install, True);
end;


// получение имени залогиненого пользователя
function getCurrentUserNamePC:string;
 const
   cnMaxUserNameLen = 254;
 var
   sUserName: string;
   dwUserNameLen: DWORD;
begin
   dwUserNameLen := cnMaxUserNameLen - 1;
   SetLength(sUserName, cnMaxUserNameLen);
   GetUserName(PChar(sUserName), dwUserNameLen);
   SetLength(sUserName, dwUserNameLen);
   Result:= PChar(sUserName);
end;


procedure SetConsoleColor(Color: Word);
var
  ConsoleHandle: THandle;
  ConsoleMode: DWORD;
begin
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(ConsoleHandle, Color);
end;


procedure CopyDirectory(const SourceDir, DestDir: string);
var
  Files: TStringDynArray;
  SubDirs: TStringDynArray;
  FileName: string;
  SubDir: string;
begin
  // Проверяем, существует ли исходная директория
  if not TDirectory.Exists(SourceDir) then
    raise Exception.Create('Исходная директория не существует: ' + SourceDir);

  // Создаем целевую директорию, если она не существует
  if not TDirectory.Exists(DestDir) then
    TDirectory.CreateDirectory(DestDir);

  // Получаем все файлы в исходной директории
  Files := TDirectory.GetFiles(SourceDir);
  for FileName in Files do
  begin
    // Копируем файл в целевую директорию
    TFile.Copy(FileName, TPath.Combine(DestDir, TPath.GetFileName(FileName)), True);
    Writeln('Копирование: '+FileName);
  end;

  // Получаем все поддиректории в исходной директории
  SubDirs := TDirectory.GetDirectories(SourceDir);
  for SubDir in SubDirs do
  begin
    // Рекурсивно копируем содержимое поддиректории
    CopyDirectory(SubDir, TPath.Combine(DestDir, TPath.GetFileName(SubDir)));
  end;
end;


procedure ExecuteCommand(const Command: string);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE; // Скрыть окно

  if CreateProcess(nil, PChar(Command), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // Ждем завершения процесса
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    RaiseLastOSError; // Обработка ошибок
  end;
end;

procedure CreateShortcut(const TargetPath, ShortcutPath: string);
var
  Shell: OleVariant;
  Shortcut: OleVariant;
begin
  // Инициализируем COM библиотеку
  CoInitialize(nil);
  try
    // Создаем объект WScript.Shell
    Shell := CreateOleObject('WScript.Shell');

    // Создаем ярлык
    Shortcut := Shell.CreateShortcut(ShortcutPath);

    // Устанавливаем путь к целевому файлу
    Shortcut.TargetPath := TargetPath;

    // Устанавливаем дополнительные параметры (опционально)
    Shortcut.Description := 'Дашборд КоллЦентра'; // Описание ярлыка
    Shortcut.WorkingDirectory := ExtractFilePath(TargetPath); // Рабочая директория

    // Сохраняем ярлык
    Shortcut.Save;
  finally
    CoUninitialize; // Освобождаем COM библиотеку
  end;
end;


// проверка установлен ли mysql коннектор
function isInstallMySQLConnector:Boolean;
const
 KeyPath:string = 'SOFTWARE\MySQL AB\MySQL Connector/ODBC 5.3';
 ValueName:string = 'Version';
var
  Reg:TRegistry;
begin
  Result:=False;

  Reg:=TRegistry.Create(KEY_READ); // Создаем объект TRegistry с правами на чтение
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE; // Устанавливаем корневой ключ
    // Проверяем, можем ли мы открыть указанный ключ
    if Reg.OpenKeyReadOnly(KeyPath) then
    begin
      // Проверяем, существует ли значение с указанным именем
      Result := Reg.ValueExists(ValueName);
      Reg.CloseKey; // Закрываем ключ
    end;
  finally
    Reg.Free; // Освобождаем ресурсы
  end;

end;


// скачивание файла с FTP
function GetDownloadFile(InFileName:string; InRemoteRootFolder:string;  var _errorDescriptions:string):Boolean;
var
 ftpClient:TFTP;
begin
  Result:=False;
  _errorDescriptions:='';

  // очистка от предидущего, иначе не скачается
  ClearFolderInstall(InFileName);

  ftpClient:=TFTP.Create('install',InRemoteRootFolder,eDownload,FOLDER_INSTALL);
  if not ftpClient.isConnect then begin
   _errorDescriptions:=ftpClient.GetError;
   Exit;
  end;

  // скачиваем файл
  ftpClient.DownloadFile(InFileName);
  if not ftpClient.isDownloadedFile(InFileName) then begin
    _errorDescriptions:=ftpClient.GetError;
    Exit;
  end;

  Result:=True;
end;


procedure DownloadFiles(InFileName, InRemoteRootFolder:string);
var
 error:string;
begin
  if not GetDownloadFile(InFileName,InRemoteRootFolder,error) then begin
   SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
   Writeln(error);

   Writeln('');
   Writeln('УСТАНОВКА НЕ ВЫПОЛНЕНА!');
   Sleep(cSLEEP_ERRROR);
  end;
end;


// установка mysql connector
procedure InstallMySQLConnector(InFileName:string);

begin
  Writeln('Установка MySQL Connector "'+InFileName+'"');

  Command:='msiexec /i "'+FOLDERPATH+FOLDER_INSTALL+'\'+InFileName+'"';
  ExecuteCommand(Command);

  SetConsoleColor(FOREGROUND_GREEN);
  Writeln('MySQL Connector УСТАНОВЛЕН');
  Writeln('');
end;


// распаковка + создание списка того что распаковали
function UnZipDashboard(InFile:string):TStringList;
var
 ZipFile:TZipFile;
 i:Integer;
 FileName:string;
 folderDest:string;
begin
  Result:=TStringList.Create;
  folderDest:=FOLDERPATH+FOLDER_INSTALL;

   try
     ZipFile:=TZipFile.Create;
     ZipFile.Open(folderDest+'\'+InFile, zmRead);

     try
        // Перебираем все файлы в архиве
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // Получаем имя файла
          // Извлекаем файл
          ZipFile.Extract(I, PChar(folderDest));
          // Отслеживаем извлечение
          Writeln('Извлечен файл: '+FileName);

          Result.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

         Writeln('Не удалось извлечь файл: '+FileName+' | '+e.Message);
         Writeln('');
         Writeln('УСТАНОВКА НЕ ВЫПОЛНЕНА!');
         Sleep(cSLEEP_ERRROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(PChar(folderDest+'\'+InFile));
   end;
end;


//////////////////////////////////////////////////////////

begin
  try
    CoInitialize(nil);

    { TODO -oUser -cConsole Main : Insert code here }

     if not EnablePrivilege(True,'SeDebugPrivilege') then
     begin
      SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
      Writeln('');
      Writeln('     === ЗАПУСТИТЕ ОТ ИМЕНИ АДМИРИСТРАТОРА===      ');
      Writeln('');
      Sleep(cSLEEP_ERRROR);
     end;


    Writeln('Проверка установки MySQL Connector');

    //  ========= MYSQL CONNECTOR =========
    begin
      // проверяем установлен ли mysql коннектор
      if not isInstallMySQLConnector then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
       Writeln('MySQL Connector НЕ УСТАНОВЛЕН');
       Writeln('');

       SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default белым ставим
       Writeln('Скачивание MySQL Connector "'+CONNECTOR_INSTALL_X64+'"');

       // скачивание
       DownloadFiles(CONNECTOR_INSTALL_X64,'mysql_connector');
       Writeln('Скачивание MySQL Connector "'+CONNECTOR_INSTALL_X64+'" завершено');

       // утсановка MySQL Connector
       InstallMySQLConnector(CONNECTOR_INSTALL_X64);

      end
      else begin
       SetConsoleColor(FOREGROUND_GREEN);
       Writeln('MySQL Connector УСТАНОВЛЕН');
       Writeln('');
      end;
    end;
    //  ========= MYSQL CONNECTOR END =========

    SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default белым ставим

    //  ========= скачиваем актуальную версию дашборда  =========
    begin
      CurrentVersionDashboard:=GetRemoteVersionDashboard;
      if CurrentVersionDashboard='null' then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

       Writeln('Не удается получить текущую версию dashboard');
       Writeln('');
       Writeln('УСТАНОВКА НЕ ВЫПОЛНЕНА!');
       Sleep(cSLEEP_ERRROR);
      end;
      Writeln('Актуальная версия: '+CurrentVersionDashboard);
      Writeln('Скачивание актуальной версии');

      DownloadFiles(CurrentVersionDashboard+'.zip','update');



      // распаковываем
      Writeln('Распаковка...');
      Writeln('');
      UnZipDashboard(CurrentVersionDashboard+'.zip');

    end;
    //  ========= скачиваем актуальную версию дашборда END  =========


    // путь установчный
    if not DirectoryExists(INSTALL_DASHBOARD) then begin
      if not CreateDir(INSTALL_DASHBOARD) then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

       Writeln('Ошибка при создании директории '+INSTALL_DASHBOARD);
       Writeln('');
       Writeln('УСТАНОВКА НЕ ВЫПОЛНЕНА!');
       Sleep(cSLEEP_ERRROR);
      end;
    end;

    // останавливаем служюу на всякий случай
    Command:='net stop '+SERVICE_NAME;
    ExecuteCommand(Command);


    Writeln('');
    Writeln('');
    SetConsoleColor(FOREGROUND_BLUE or FOREGROUND_INTENSITY);
    Writeln('Установка '+CurrentVersionDashboard);
    Writeln('');
    SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default белым ставим


    CopyDirectory(FOLDERPATH+FOLDER_INSTALL,INSTALL_DASHBOARD);
    // установка службы
    Command:='sc create '+SERVICE_NAME+' binPath= "'+INSTALL_DASHBOARD+'\'+UPDATE_EXE+'" start= auto';

    try
      ExecuteCommand(Command);
      Writeln('');
      Writeln('Служба обновления установлена');
    except
      on E: Exception do begin
        SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
        Writeln('Ошибка при установке службы обновления: ' + E.Message);
        Sleep(cSLEEP_ERRROR);
      end;
    end;

     // ставим на рабочий стол ярлык
    TargetExe:=INSTALL_DASHBOARD+'\'+DASHBOARD_EXE;
    ShortcutExe:='C:\Users\Public\Desktop\dashboard.lnk';

    try
      CreateShortcut(TargetExe, ShortcutExe);
      Writeln('');
      Writeln('Ярлык успешно создан на общем рабочем столе');
    except
     { on E: Exception do begin
        SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
        Writeln('');
        Writeln('Ошибка при создании ярлыка на рабочем столе ' + E.Message);
        Sleep(cSLEEP_ERRROR);
      end; }
    end;


    Writeln('Установка прав доступа на папку "'+INSTALL_DASHBOARD+'"');
    Command:='icacls "'+INSTALL_DASHBOARD+'" /grant Все:(OI)(CI)F /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');
    Writeln('Смена владельца папки '+INSTALL_DASHBOARD);
    Command:='icacls "'+INSTALL_DASHBOARD+'" /setowner "Все" /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');

    // запускаем служюу
    Command:='net start '+SERVICE_NAME;
    ExecuteCommand(Command);


    SetConsoleColor(FOREGROUND_GREEN or FOREGROUND_INTENSITY);
    Writeln('');
    Writeln('');
    Writeln('Установка выполнена. Окно можно закрыть');

    // очистка папки install
    ClearFolderInstall(CONNECTOR_INSTALL_X64);

    Sleep(cSLEEP_ERRROR);
  except
    on E: Exception do begin
     SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
     Writeln('');
     Writeln('');
     Writeln('КРИТИЧЕСКАЯ ОШИБКА '+#13+E.ClassName, ': ', E.Message);

     ClearFolderInstall(CONNECTOR_INSTALL_X64);

     Sleep(cSLEEP_ERRROR);
    end;
  end;
end.
