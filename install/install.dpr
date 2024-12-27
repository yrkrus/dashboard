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
 FOREGROUND_RED = 4; // ������� ����
 FOREGROUND_GREEN = 2; // ������� ����
 FOREGROUND_INTENSITY = 8; // �������

var
 folderInstall:string;
 SLCopyList:TStringList;
 Command: string;
 TargetExe:string;  // ���� � exe �����
 ShortcutExe:string; // ���� � ������ ����������� � *.lnk!!

// ��������� ����� ������������ ������������
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
  // ���������, ���������� �� �������� ����������
  if not TDirectory.Exists(SourceDir) then
    raise Exception.Create('�������� ���������� �� ����������: ' + SourceDir);

  // ������� ������� ����������, ���� ��� �� ����������
  if not TDirectory.Exists(DestDir) then
    TDirectory.CreateDirectory(DestDir);

  // �������� ��� ����� � �������� ����������
  Files := TDirectory.GetFiles(SourceDir);
  for FileName in Files do
  begin
    // �������� ���� � ������� ����������
    TFile.Copy(FileName, TPath.Combine(DestDir, TPath.GetFileName(FileName)), True);
    Writeln('�����������: '+FileName);
  end;

  // �������� ��� ������������� � �������� ����������
  SubDirs := TDirectory.GetDirectories(SourceDir);
  for SubDir in SubDirs do
  begin
    // ���������� �������� ���������� �������������
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
  StartupInfo.wShowWindow := SW_HIDE; // ������ ����

  if CreateProcess(nil, PChar(Command), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // ���� ���������� ��������
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    RaiseLastOSError; // ��������� ������
  end;
end;

procedure CreateShortcut(const TargetPath, ShortcutPath: string);
var
  Shell: OleVariant;
  Shortcut: OleVariant;
begin
  // �������������� COM ����������
  CoInitialize(nil);
  try
    // ������� ������ WScript.Shell
    Shell := CreateOleObject('WScript.Shell');

    // ������� �����
    Shortcut := Shell.CreateShortcut(ShortcutPath);

    // ������������� ���� � �������� �����
    Shortcut.TargetPath := TargetPath;

    // ������������� �������������� ��������� (�����������)
    Shortcut.Description := '������� ����������'; // �������� ������
    Shortcut.WorkingDirectory := ExtractFilePath(TargetPath); // ������� ����������

    // ��������� �����
    Shortcut.Save;
  finally
    CoUninitialize; // ����������� COM ����������
  end;
end;

//////////////////////////////////////////////////////////

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    // ���� �����������
    folderInstall:='C:\Program Files\dashboard';
    if not DirectoryExists(folderInstall) then begin
      if not CreateDir(folderInstall) then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

       Writeln('�������� ������ ��� �������� ���������� '+folderInstall);
       Writeln('��������� �� ���������!');
       Sleep(cSLEEP_ERRROR);
      end;
    end;


    CopyDirectory(FOLDERPATH,folderInstall);

    // ��������� ������
    Command:='sc create '+SERVICE_NAME+' binPath= "'+folderInstall+'\'+UPDATE_EXE+'" start= auto';

    try
      ExecuteCommand(Command);
      Writeln('');
      Writeln('������ ���������� �����������');
    except
      on E: Exception do begin
        SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
        Writeln('������ ��� ��������� ������ ����������: ' + E.Message);
        Sleep(cSLEEP_ERRROR);
      end;
    end;

     // ������ �� ������� ���� �����
    TargetExe:=folderInstall+'\'+DASHBOARD_EXE;
    ShortcutExe:='C:\Users\Public\Desktop\dashboard.lnk';

    try
      CreateShortcut(TargetExe, ShortcutExe);
      Writeln('');
      Writeln('����� ������� ������ �� ����� ������� �����');
    except
     { on E: Exception do begin
        SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
        Writeln('');
        Writeln('������ ��� �������� ������ �� ������� ����� ' + E.Message);
        Sleep(cSLEEP_ERRROR);
      end; }
    end;


    Writeln('��������� ���� ������� �� ����� '+folderInstall);
    Command:='icacls "'+folderInstall+'" /grant ���:(OI)(CI)F /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');
    Writeln('����� ��������� ����� '+folderInstall);
    Command:='icacls "'+folderInstall+'" /setowner "���" /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');

    // ��������� ������
    Command:='net start '+SERVICE_NAME;
    ExecuteCommand(Command);


    SetConsoleColor(FOREGROUND_GREEN or FOREGROUND_INTENSITY);
    Writeln('');
    Writeln('');
    Writeln('��������� ���������. ���� ����� �������');


    Sleep(cSLEEP_ERRROR);


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
