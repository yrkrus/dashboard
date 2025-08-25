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
  TMessageGeneratorSMSUnit,
  TPacientsListUnit;


  type   // тип отправки
   enumSendingOptions = (options_Manual,    // ручная отправка
                         options_Sending,   // рассылка
                         options_Find);     // поиск статуса

  type  // тип показывать\скрывать лог
  enumFormShowingLog = (log_show,           // лог показывать
                        log_hide);          // лог скрывать


  type  // тип прогрузки шаблонов сообщений
  enumTemplateMessage = (template_my,       // мои шаблоны
                         template_global);  // глобальные шаблоны                  

var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  SMS_EXE           :string = 'sms.exe';

  // файл с настройками
  SETTINGS_XML      :string = 'settings.xml';

  // лог главной формы
  SharedMainLog     :TLoggingFile;

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
  MAX_COUNT_THREAD_SENDIND :Word = 20;

  // список для СМС отправки
  SharedPacientsList            : TPacients;
  SharedPacientsListNotSending  : TPacients;

  // кол-во номеров на отправку которое считается подозрительным
  MAX_COUNT_PHONE_SENDING_WARNING :Word = 1000;

  // Сгенерированное сообщение из шаблоноа генератора
  SharedGenerateMessage         : TMessageGeneratorSMS;

  // список с номерами тлф для ручной одиночной отправки
  SharedSendindPhoneManualSMS   : TStringList;

  // Сохранение в глобальный шаблон
  ISGLOBAL_MESSAGE:Boolean = True;

  // текстовка SMS сообщения, напоминания о приеме   // TODO %к_доктору  сделать счобы менялось на или к доктору!
  REMEMBER_MESSAGE        :string='%FIO_Pacienta %записан(а) %к_доктору %FIO_Doctora в %Time %Data в клинику по адресу %Address.'+
                                  ' Если у Вас есть вопросы, готовы на них ответить, номер тел. для связи (8442)220-220 или (8443)450-450';

  // сообщение когда не прогружен excel файл
  EXCEL_FILE_NOT_LOADED:string ='не загружен';

implementation




initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedPacientsList           :=TPacients.Create;
 SharedPacientsListNotSending :=TPacients.Create;

 SharedMainLog                :=TLoggingFile.Create('sms');   // лог работы формы
 SharedSendindPhoneManualSMS  :=TStringList.Create;

 finalization

end.
