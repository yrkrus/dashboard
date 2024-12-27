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
  GlobalVariables in '..\services\delphi\GlobalVariables.pas';



const
 cSLEEP_ERRROR:Cardinal = 9000000;
 FOREGROUND_RED = 4; // Красный цвет
 FOREGROUND_GREEN = 2; // Зеленый цвет
 FOREGROUND_INTENSITY = 8; // Яркость

var
 folderInstall:string;
 SLCopyList:TStringList;
 Command: string;
 TargetExe:string;  // Путь к exe файлу
 ShortcutExe:string; // Путь к ярлыку обязательно с *.lnk!!

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

//////////////////////////////////////////////////////////

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    // путь установчный
    folderInstall:='C:\Program Files\dashboard';
    if not DirectoryExists(folderInstall) then begin
      if not CreateDir(folderInstall) then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

       Writeln('Возникла ошибка при создании директории '+folderInstall);
       Writeln('УСТАНОВКА НЕ ВЫПОЛНЕНА!');
       Sleep(cSLEEP_ERRROR);
      end;
    end;


    CopyDirectory(FOLDERPATH,folderInstall);

    // установка службы
    Command:='sc create '+SERVICE_NAME+' binPath= "'+folderInstall+'\'+UPDATE_EXE+'" start= auto';

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
    TargetExe:=folderInstall+'\'+DASHBOARD_EXE;
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


    Writeln('Установка прав доступа на папку '+folderInstall);
    Command:='icacls "'+folderInstall+'" /grant Все:(OI)(CI)F /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');
    Writeln('Смена владельца папки '+folderInstall);
    Command:='icacls "'+folderInstall+'" /setowner "Все" /T';
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


    Sleep(cSLEEP_ERRROR);


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
