/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ���������� ����������                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils, Windows;



var
 // ����� ����������
  DEBUG:Boolean = true;

  REPORT_EXE :string = 'report.exe';

  // ������� ���������� ������ ��������� report.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ ������
  USER_STARTED_REPORT_ID    :Integer;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;



  // �������� DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // ��������� �� TADOConnection
  function createServerConnect: p_TADOConnection;             stdcall;    external 'core.dll';        // �������� ����������� � �������
  function GetCopyright:Pchar;                                stdcall;    external 'core.dll';        // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;    external 'core.dll';        // ��������� ����� ������������ �� ��� UserID
  function GetUserAccessReports(InUserID:Integer):Boolean;    stdcall;     external 'core.dll';       // ���� �� ������ � ������������ � �������
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;  stdcall; external 'core.dll';// ������� ������ ��� ����� -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;  stdcall; external 'core.dll';// ������� ������ ��� � �������� 00:00:00
  function GetCurrentTime:PChar;                              stdcall; external 'core.dll';           // ������� �����  yyyymmdd
  procedure KillProcessNow;                                   stdcall;  external 'core.dll';          // ����������� ��������� ������
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;  external 'core.dll';          // �������� �� 2�� ���������� �����
  function KillTask(ExeFileName:string):integer;              stdcall;  external 'core.dll';       // ������� ��������� exe
  function GetTask(ExeFileName:string):Boolean;               stdcall;  external 'core.dll';       // �������� ������� �� �������


   // --- connect_to_server.dll ---
  // �� ������������!


implementation


uses
  FormHomeUnit;




initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
