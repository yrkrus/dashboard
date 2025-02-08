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
  SysUtils,
  Windows,
  TCustomTypeUnit;


  type   // тип отправки
   enumSendingOptions = (options_Manual,  // ручна€ отправка
                         options_Sending); // рассылка

  type  // тип показывать\скрывать лог
  enumFormShowingLog = (log_show,     // лог показывать
                        log_hide);    // лог скрывать


var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  SMS_EXE :string = 'sms.exe';

  // текуща€ директори€ откуда запускаем sms.exe
  FOLDERPATH:string;

  // «алогиненый польщователь который открыл sms
  USER_STARTED_SMS_ID    :Integer;

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
  function GetUserAccessSMS(InUserID:Integer):Boolean;        stdcall;    external 'core.dll';         // есть ли доступ у пользовател€ к SMS отчетам
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;   stdcall; external 'core.dll';// текущее начала дн€ минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;   stdcall; external 'core.dll';// текущее начала дн€ с минутами 00:00:00
  function GetCurrentTime:PChar;                              stdcall;    external 'core.dll';           // текущее врем€  yyyymmdd
  procedure KillProcessNow;                                   stdcall;    external 'core.dll';          // немедленное звершение работы
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // проверка на 2ую запущенную копию
  function KillTask(ExeFileName:string):integer;              stdcall;    external 'core.dll';          // функци€ остановки exe
  function GetTask(ExeFileName:string):Boolean;               stdcall;    external 'core.dll';          // проверка запущен ли процесс
  function GetDateToDateBD(InDateTime:string):PChar;          stdcall;    external 'core.dll';          // перевод даты и времени в ненормальный вид дл€ BD
  //function GetTimeAnsweredToSeconds(InTimeAnswered:string):Integer; stdcall;  external 'core.dll';    // перевод времени разговора оператора типа 00:00:00 в секунды
  //function GetTimeAnsweredSecondsToString(InSecondAnswered:Integer):PChar; stdcall;  external 'core.dll'; // перевод времени разговора оператора типа из секунд в 00:00:00
 // function GetIVRTimeQueue(InQueue:enumQueueCurrent):Integer;  stdcall;  external 'core.dll';    // врем€ которое необходимо отнимать от текущего звонка в очереди
  //function StringToTQueue(InQueueSTR:string):enumQueueCurrent; stdcall;  external 'core.dll';      // конвертер из string в TQueue
 // function TQueueToString(InQueueSTR:enumQueueCurrent):PChar;  stdcall;  external 'core.dll';      // конвертер из TQueue в string
 // function GetUserNameOperators(InSip:string):PChar;           stdcall;  external 'core.dll';      // полчуение имени пользовател€ из его SIP номера


  // --- connect_to_server.dll ---
  // Ќ≈ »—ѕќЋ№«”≈“—я!


implementation



initialization  // »нициализаци€
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
