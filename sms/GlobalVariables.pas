/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils,
  Windows,
  Classes,
  TCustomTypeUnit,
  TLogFileUnit,
  TPacientsListUnit;


  type   // тип отправки
   enumSendingOptions = (options_Manual,  // ручная отправка
                         options_Sending); // рассылка

  type  // тип показывать\скрывать лог
  enumFormShowingLog = (log_show,     // лог показывать
                        log_hide);    // лог скрывать


  type  // тип прогрузки шаблонов сообщений
  enumTemplateMessage = (template_my,       // мои шаблоны
                         template_global);  // глобальные шаблоны                  

var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  SMS_EXE :string = 'sms.exe';

  // лог главной формы
  SharedMainLog:TLoggingFile;

  // текущая директория откуда запускаем sms.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл sms
  USER_STARTED_SMS_ID    :Integer;

  // есть ли доступ к отправке расслыки напоминание о приеме
  USER_ACCESS_SENDING_LIST  :Boolean;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean = False;

  // кол-во одновременных потоков для отправки рассылки SMS
  MAX_COUNT_THREAD_SENDIND :Word = 10;

  // список для СМС отправки
  SharedPacientsList            : TPacients;
  SharedPacientsListNotSending  : TPacients;

  // список с номерами тлф для ручной одиночной отправки
  SharedSendindPhoneManualSMS   : TStringList;

  // Сохранение в глобальный шаблон
  ISGLOBAL_MESSAGE:Boolean = True;

  // текстовка SMS сообщения, напоминания о приеме   // TODO %к_доктору  сделать счобы менялось на или к доктору!
  REMEMBER_MESSAGE        :string='%FIO_Pacienta %записан(а) %к_доктору %FIO_Doctora в %Time %Data в клинику по адресу %Address.'+
                                  ' Если у Вас есть вопросы, готовы на них ответить, номер тел. для связи (8442)220-220 или (8443)450-450';

   // сообщение когда не прогружен excel файл
   EXCEL_FILE_NOT_LOADED:string ='не загружен';

  // загрузка DLL
  // --- core.dll ---
  type
  p_TADOConnection = Pointer; // Указатель на TADOConnection
  function createServerConnect: p_TADOConnection;             stdcall;    external 'core.dll';        // Создание подключения к серверу
  function GetCopyright:Pchar;                                stdcall;    external 'core.dll';        // copyright
  function GetUserNameFIO(InUserID:Integer):PChar;            stdcall;    external 'core.dll';        // полчуение имени пользователя из его UserID
  function GetUserAccessSMS(InUserID:Integer):Boolean;        stdcall;    external 'core.dll';         // есть ли доступ у пользователя к SMS отчетам
  function GetCurrentDateTimeDec(DecMinutes:Integer):PChar;   overload;   stdcall; external 'core.dll';// текущее начала дня минус -DecMinutes
  function GetCurrentStartDateTime:PChar;                     overload;   stdcall; external 'core.dll';// текущее начала дня с минутами 00:00:00
  function GetCurrentTime:PChar;                              stdcall;    external 'core.dll';           // текущее время  yyyymmdd
  procedure KillProcessNow;                                   stdcall;    external 'core.dll';          // немедленное звершение работы
  function GetCloneRun(InExeName:Pchar):Boolean;              stdcall;    external 'core.dll';          // проверка на 2ую запущенную копию
  function KillTask(ExeFileName:string):integer;              stdcall;    external 'core.dll';          // функция остановки exe
  function GetTask(ExeFileName:string):Boolean;               stdcall;    external 'core.dll';          // проверка запущен ли процесс
  function GetDateToDateBD(InDateTime:string):PChar;          stdcall;    external 'core.dll';          // перевод даты и времени в ненормальный вид для BD
  function GetExtensionLog:PChar;                             stdcall;    external 'core.dll';       // папка с локальным чатом
  function GetLogNameFolder:PChar;                            stdcall;    external 'core.dll';       // папка с логом

  // --- connect_to_server.dll ---
  // НЕ ИСПОЛЬЗУЕТСЯ!


implementation




initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedPacientsList           :=TPacients.Create;
 SharedPacientsListNotSending :=TPacients.Create;

 SharedMainLog                :=TLoggingFile.Create('sms');   // лог работы формы
 SharedSendindPhoneManualSMS  :=TStringList.Create;


 finalization

end.
