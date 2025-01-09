/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         √ЋќЅјЋ№Ќџ≈ ѕ≈–≈ћ≈ЌЌџ≈                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils, Windows;



var
 // режим разработки
  DEBUG:Boolean = true;

  REPORT_EXE :string = 'report.exe';

  // текуща€ директори€ откуда запускаем report.exe
  FOLDERPATH:string;

  // «алогиненый польщователь который открыл отчеты
  USER_STARTED_REPORT_ID    :Integer;

  // глобальна€ ошибка при подкобчении к Ѕƒ
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренн€€ ошибка
  INTERNAL_ERROR          :Boolean =  False;



  // загрузка DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // ”казатель на TADOConnection
  function createServerConnect: p_TADOConnection;             stdcall;    external 'core.dll';        // —оздание подключени€ к серверу
  function GetCopyright:Pchar;                                stdcall;    external 'core.dll';        // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;    external 'core.dll';        // полчуение имени пользовател€ из его UserID
  function GetUserAccessReports(InUserID:Integer):Boolean;    stdcall;     external 'core.dll';       // есть ли доступ у пользовател€ к отчетам
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;  stdcall; external 'core.dll';// текущее начала дн€ минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;  stdcall; external 'core.dll';// текущее начала дн€ с минутами 00:00:00
  function GetCurrentTime:PChar;                              stdcall; external 'core.dll';           // текущее врем€  yyyymmdd
  procedure KillProcessNow;                                   stdcall;  external 'core.dll';          // немедленное звершение работы
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;  external 'core.dll';          // проверка на 2ую запущенную копию
  function KillTask(ExeFileName:string):integer;              stdcall;  external 'core.dll';       // функци€ остановки exe
  function GetTask(ExeFileName:string):Boolean;               stdcall;  external 'core.dll';       // проверка запущен ли процесс


   // --- connect_to_server.dll ---
  // Ќ≈ »—ѕќЋ№«”≈“—я!


implementation


uses
  FormHomeUnit;




initialization  // »нициализаци€
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
