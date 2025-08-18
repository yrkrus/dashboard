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
  TCustomTypeUnit in '..\custom_class\TCustomTypeUnit.pas',
  TFTPUnit in '..\custom_class\TFTPUnit.pas',
  TLogFileUnit in '..\custom_class\TLogFileUnit.pas',
  GlobalVariables in '..\update\GlobalVariables.pas',
  GlobalVariablesLinkDLL in '..\gui\GlobalVariablesLinkDLL.pas';

const
 cSLEEP_ERRROR:Cardinal = 9000000;  //  ����� ������� �������� �.�. ����� � ������ sleep ����
 FOREGROUND_BLUE        = 1;        // ����� ����
 FOREGROUND_RED         = 4;        // ������� ����
 FOREGROUND_GREEN       = 2;        // ������� ����
 FOREGROUND_INTENSITY   = 8;        // �������



var
 SLCopyList:TStringList;
 CurrentVersionDashboard:string;
 Command: string;
 TargetExe:string;   // ���� � exe �����
 ShortcutExe:string; // ���� � ������ ����������� � *.lnk!!
 error:string;



////////////////////////////////////////////////////////////////////////////////////////////////////////////




procedure SetConsoleColor(Color: Word);
var
  ConsoleHandle: THandle;
  ConsoleMode: DWORD;
begin
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(ConsoleHandle, Color);
end;


procedure ProcessCommandLineParams;
begin
  // �������� �� ������� 2�� ����
  if GetCloneRun(Pchar(INSTALL_EXE)) then begin
    SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
    Writeln('');
    Writeln('  ��������� ������ 2�� ����� ����������  ');
    Writeln('  ��� ����������� �������� ���������� �����  ');
    Writeln('');
    Sleep(cSLEEP_ERRROR);
  end;


//  // ��� ���������� ��
//  if ParamCount = 0 then begin
//    Exit;
//  end;
//
//  for i:= 1 to ParamCount do
//  begin
//    if ParamStr(i) = USER_FORCE_UPDATE then
//    begin
//      if (i + 1 <= ParamCount) then
//      begin
//        params:= ParamStr(i + 1);
//        if params = 'true' then Result:=True;
//      end
//      else
//      begin
//        SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
//        Writeln('');
//        Writeln('  ������� ����� ���������� ');
//        Writeln('');
//        Sleep(cSLEEP_ERRROR);
//      end;
//    end;
//
//
//  end;
end;




// �������� ������� �� install �� ����� ��������������
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


 // ������� ����� �����������
procedure ClearFolderInstall(InFileName:string);
var
 install:string;
begin
  install:=FOLDERPATH+FOLDER_INSTALL;
  if FileExists(install+'\'+InFileName) then DeleteFile(PChar(install+'\'+InFileName));
  if DirectoryExists(install) then TDirectory.Delete(install, True);
end;


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


// �������� ���������� �� mysql ���������
function isInstallMySQLConnector:Boolean;
const
 KeyPath:string = 'SOFTWARE\MySQL AB\MySQL Connector/ODBC 5.3';
 ValueName:string = 'Version';
var
  Reg:TRegistry;
begin
  Result:=False;

  Reg:=TRegistry.Create(KEY_READ); // ������� ������ TRegistry � ������� �� ������
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE; // ������������� �������� ����
    // ���������, ����� �� �� ������� ��������� ����
    if Reg.OpenKeyReadOnly(KeyPath) then
    begin
      // ���������, ���������� �� �������� � ��������� ������
      Result := Reg.ValueExists(ValueName);
      Reg.CloseKey; // ��������� ����
    end;
  finally
    Reg.Free; // ����������� �������
  end;

end;


// ���������� ����� � FTP
function GetDownloadFile(InFileName:string; InRemoteRootFolder:string;  var _errorDescriptions:string):Boolean;
var
 ftpClient:TFTP;
begin
  Result:=False;
  _errorDescriptions:='';

  // ������� �� �����������, ����� �� ���������
  ClearFolderInstall(InFileName);

  ftpClient:=TFTP.Create('install',InRemoteRootFolder,eDownload,FOLDER_INSTALL);
  if not ftpClient.isConnect then begin
   _errorDescriptions:=ftpClient.GetError;
   Exit;
  end;

  // ��������� ����
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
   Writeln('��������� �� ���������!');
   Sleep(cSLEEP_ERRROR);
  end;
end;


// ��������� mysql connector
procedure InstallMySQLConnector(InFileName:string);
begin
  Writeln('��������� MySQL Connector "'+InFileName+'"');

  Command:='msiexec /i "'+FOLDERPATH+FOLDER_INSTALL+'\'+InFileName+'"';
  ExecuteCommand(Command);

  SetConsoleColor(FOREGROUND_GREEN);
  Writeln('MySQL Connector ����������');
  Writeln('');
end;


// ���������� + �������� ������ ���� ��� �����������
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
        // ���������� ��� ����� � ������
        for I := 0 to ZipFile.FileCount - 1 do
        begin
          FileName := ZipFile.FileNames[I]; // �������� ��� �����
          // ��������� ����
          ZipFile.Extract(I, PChar(folderDest));
          // ����������� ����������
          Writeln('�������� ����: '+FileName);

          Result.Add(StringReplace(FileName,'/','\',[rfReplaceAll]));
        end;
     except
       on E:Exception do
       begin
         SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

         Writeln('�� ������� ������� ����: '+FileName+' | '+e.Message);
         Writeln('');
         Writeln('��������� �� ���������!');
         Sleep(cSLEEP_ERRROR);
       end;
     end;
   finally
     if ZipFile<>nil then ZipFile.Free;
     DeleteFile(PChar(folderDest+'\'+InFile));
   end;
end;

// ��������� settings.xml
procedure ClearSettingsXMLFile;
var
 f_dest: string;
begin
  f_dest:=INSTALL_DASHBOARD+'\'+SETTINGS_XML;
  if FileExists(f_dest) then DeleteFile(PChar(f_dest));
end;


// �������� ���� �������� ���������
procedure KillChildTask;
var
 countKillExe:Integer;
begin
   Writeln('����� �������� ���������');
   // ��������� chat_exe ���� ������
   countKillExe:=0;
   while GetTask(PChar(CHAT_EXE)) do begin
     Writeln('�������� �������� '+PChar(CHAT_EXE));
     KillTask(PChar(CHAT_EXE));

     // �� ������ ���� �� �������� ������� �������� exe
     Sleep(500);
     Inc(countKillExe);
     if countKillExe>10 then Break;
   end;

   // ��������� report_exe ���� ������
   countKillExe:=0;
   while GetTask(PChar(REPORT_EXE)) do begin
     Writeln('�������� �������� '+PChar(REPORT_EXE));
     KillTask(PChar(REPORT_EXE));

     // �� ������ ���� �� �������� ������� �������� exe
     Sleep(500);
     Inc(countKillExe);
     if countKillExe>10 then Break;
   end;

    // ��������� sms_exe ���� ������
   countKillExe:=0;
   while GetTask(PChar(SMS_EXE)) do begin
    Writeln('�������� �������� '+PChar(SMS_EXE));
     KillTask(PChar(SMS_EXE));

     // �� ������ ���� �� �������� ������� �������� exe
     Sleep(500);
     Inc(countKillExe);
     if countKillExe>10 then Break;
   end;

     // ��������� sms_exe ���� ������
   countKillExe:=0;
   while GetTask(PChar(DASHBOARD_EXE)) do begin
     Writeln('�������� �������� '+PChar(DASHBOARD_EXE));
     KillTask(PChar(DASHBOARD_EXE));

     // �� ������ ���� �� �������� ������� �������� exe
     Sleep(500);
     Inc(countKillExe);
     if countKillExe>10 then Break;
   end;
end;


////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////// START PROGRAMM  ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


begin
  try
    CoInitialize(nil);
    ProcessCommandLineParams;

    { TODO -oUser -cConsole Main : Insert code here }

     if not EnablePrivilege(True,'SeDebugPrivilege') then
     begin
      SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
      Writeln('');
      Writeln('     === ��������� �� ����� �������������� ===      ');
      Writeln('');
      Sleep(cSLEEP_ERRROR);
     end;

     Writeln('�������� ��������� MySQL Connector');

      //  ========= MYSQL CONNECTOR =========
      begin
        // ��������� ���������� �� mysql ���������
        if not isInstallMySQLConnector then begin
         SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
         Writeln('MySQL Connector �� ����������');
         Writeln('');

         SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default ����� ������
         Writeln('���������� MySQL Connector "'+CONNECTOR_INSTALL_X64+'"');

         // ����������
         DownloadFiles(CONNECTOR_INSTALL_X64,'mysql_connector');
         Writeln('���������� MySQL Connector "'+CONNECTOR_INSTALL_X64+'" ���������');

         // ��������� MySQL Connector
         InstallMySQLConnector(CONNECTOR_INSTALL_X64);

        end
        else begin
         SetConsoleColor(FOREGROUND_GREEN);
         Writeln('MySQL Connector ����������');
         Writeln('');
        end;
      end;
      //  ========= MYSQL CONNECTOR END =========


    SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default ����� ������

     // �������� �������� ���������
     // ==============================================
     KillChildTask;

    //  ========= �������� ������ �����   =========
    if DirectoryExists(INSTALL_DASHBOARD) then TDirectory.Delete(INSTALL_DASHBOARD, True);


    //  ========= ��������� ���������� ������ ��������  =========
    begin
      CurrentVersionDashboard:=GetRemoteVersionDashboard(error);
      if CurrentVersionDashboard='null' then begin
       SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

       Writeln('�� ������� �������� ������� ������ dashboard');
       Writeln(error);
       Writeln('');
       Writeln('��������� �� ���������!');
       Sleep(cSLEEP_ERRROR);
      end;
      Writeln('���������� ������: '+CurrentVersionDashboard);
      Writeln('���������� ���������� ������');

      DownloadFiles(CurrentVersionDashboard+'.zip','update');

      // �������������
      Writeln('����������...');
      Writeln('');
      UnZipDashboard(CurrentVersionDashboard+'.zip');

    end;
    //  ========= ��������� ���������� ������ �������� END  =========


      // ���� �����������
      if not DirectoryExists(INSTALL_DASHBOARD) then begin
        if not CreateDir(INSTALL_DASHBOARD) then begin
         SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);

         Writeln('������ ��� �������� ���������� '+INSTALL_DASHBOARD);
         Writeln('');
         Writeln('��������� �� ���������!');
         Sleep(cSLEEP_ERRROR);
        end;
      end;


    // ������������� ������ �� ������ ������
    Command:='net stop '+SERVICE_NAME;
    ExecuteCommand(Command);


    // �������� ������� settings.xml
    // ==============================================
    ClearSettingsXMLFile;


    Writeln('');
    Writeln('');
    SetConsoleColor(FOREGROUND_BLUE or FOREGROUND_INTENSITY);
    Writeln('��������� '+CurrentVersionDashboard);
    Writeln('');
    SetConsoleColor(FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE); //default ����� ������


    CopyDirectory(FOLDERPATH+FOLDER_INSTALL,INSTALL_DASHBOARD);
    // ��������� ������
    Command:='sc create '+SERVICE_NAME+' binPath= "'+INSTALL_DASHBOARD+'\'+UPDATE_EXE+'" start= auto';

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
    TargetExe:=INSTALL_DASHBOARD+'\'+DASHBOARD_EXE;
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


    Writeln('��������� ���� ������� �� ����� "'+INSTALL_DASHBOARD+'"');
    Command:='icacls "'+INSTALL_DASHBOARD+'" /grant ���:(OI)(CI)F /T';
    ExecuteCommand(Command);
    Writeln('');
    Writeln('');
    Writeln('����� ��������� ����� '+INSTALL_DASHBOARD);
    Command:='icacls "'+INSTALL_DASHBOARD+'" /setowner "���" /T';
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

    // ������� ����� install
    ClearFolderInstall(CONNECTOR_INSTALL_X64);

    Sleep(cSLEEP_ERRROR);
  except
    on E: Exception do begin
     SetConsoleColor(FOREGROUND_RED or FOREGROUND_INTENSITY);
     Writeln('');
     Writeln('');
     Writeln('����������� ������ '+#13+E.ClassName, ': ', E.Message);

     ClearFolderInstall(CONNECTOR_INSTALL_X64);

     Sleep(cSLEEP_ERRROR);
    end;
  end;
end.
