/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       ТОЛЬКО СОЗДАННЫЕ ТИПЫ ДАННЫХ                        ///
///                            + преобразования                               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TCustomTypeUnit;

interface

  uses
  SysUtils, Windows, Vcl.Graphics;


  type
  TFlashWindowInfo = record
    cbSize: DWORD;
    hwnd: HWND;
    dwFlags: DWORD;
    uCount: DWORD;
    dwTimeout: DWORD;
  end;


  type    // тип проверки мониториться ли транк или нет
  enumMonitoringTrunk = ( monitoring_DISABLE,
                          monitoring_ENABLE
                        );


 type      // тип запроса к firebird
  enumFirebirdAuth = (firebird_login,   // логин
                      firebird_pwd      // пароль
                      );

 type      // тип запроса к SMS рассыльщику
  enumSMSAuth = (sms_server_addr,           // полный адрес сервера
                 sms_login,                 // логин
                 sms_pwd,                   // пароль
                 sms_sign                   // подпись в конце смс
                );


 type     // типы клиник (ММЦ, ЦЛД, Яаборатория)
  enumTypeClinic = (eMMC,                  // ММЦ
                    eCLD,                  // ЦЛД
                    eLaboratory,           // Лаборатория
                    eOther                 // Прочее
                    );


 type   // тип запрошенных данных из очереди ! TODO ВАЖНО в TQueueStatistics  береться только queue_5000 и queue_5050
 enumQueueCurrent =  (queue_5000,            // 5000 очередь
                      queue_5050,            // 5050 очередь
                      queue_5000_5050,       // 5000 и 5050 очередь
                      queue_null             // нет очереди
                      );


 type   // типы прав доступа
  enumRole = (  role_administrator    = 1,       // администратор
                role_lead_operator    = 2,       // ведущий оператор
                role_senior_operator  = 3,       // старший оператор
                role_operator         = 4,       // оператор
                role_supervisor_cov   = 5,       // руководитель ЦОВ
                role_operator_no_dash = 6        // оператор (без дашборда)
                );


  type  // тип сохранения индивидуальных настроек пользователя
    enumSettingUsers = (  settingUsers_gohome,                  // не показывать ушедших домой
                          settingUsers_noConfirmExit,           // не показывать окно "точно хотите выйти из дашборда?"
                          settingUsers_showStatisticsQueueDay   // какой тип графика отображать в модуле "сатистика ожидания в очереди" 0-цифры | 1 - график
                            );

  type  // тип включение\отключение boolean параметров
    enumParamStatus = (paramStatus_ENABLED  = 1,  // включить
                       paramStatus_DISABLED = 0   // выключить
                       );

  {
     НЕ ЗАБЫТЬ!!
     при добавлении нового действия сделать преобразование типов в TLoggingToInt

     + не забыить добавить в core_dashboard - namespace LOG::Log

   }

  type   // отображение \ сркытие окна запроса на сервер
  enumShow_wait = ( show_open,
                    show_close );

  type       // таблица logging_action
   enumLogging = (  eLog_unknown              = -1,        // не известный статус
                    eLog_enter                = 0,         // Вход
                    eLog_exit                 = 1,         // Выход
                    eLog_auth_error           = 2,         // не успешная авторизация
                    eLog_exit_force           = 3,         // Выход (через команду force_closed)
                    eLog_add_queue_5000       = 4,         // добавление в очередь 5000
                    eLog_add_queue_5050       = 5,         // добавление в очередь 5050
                    eLog_add_queue_5000_5050  = 6,         // добавление в очередь 5000 и 5050
                    eLog_del_queue_5000       = 7,         // удаление из очереди 5000
                    eLog_del_queue_5050       = 8,         // удаление из очереди 5050
                    eLog_del_queue_5000_5050  = 9,         // удаление из очереди 5000 и 5050
                    eLog_available            = 10,        // доступен
                    eLog_home                 = 11,        // домой
                    eLog_exodus               = 12,        // исход
                    eLog_break                = 13,        // перерыв
                    eLog_dinner               = 14,        // обед
                    eLog_postvyzov            = 15,        // поствызов
                    eLog_studies              = 16,        // учеба
                    eLog_IT                   = 17,        // ИТ
                    eLog_transfer             = 18,        // переносы
                    eLog_reserve              = 19,        // резерв
                    eLog_callback             = 20,        // callback
                    eLog_create_new_user      = 21,        // создание нового пользователя
                    eLog_edit_user            = 22         // редактирование пользователя
                );

   type   // текущие статусы операторов
   enumStatusOperators = (  eUnknown    = -1,    // unknown
                            eReserved0  = 0,     // резерв
                            eAvailable  = 1,     // доступен
                            eHome       = 2,     // домой
                            eExodus     = 3,     // исход
                            eBreak      = 4,     // перерыв
                            eDinner     = 5,     // обед
                            ePostvyzov  = 6,     // поствызов
                            eStudies    = 7,     // учеба
                            eIT         = 8,     // ИТ
                            eTransfer   = 9,     // переносы
                            eReserve    = 10,    // резерв
                            eCallback   = 11     // callback
   );

  type   // тип запрошенных данных из очереди
   enumQueueType = (answered,            //  кол-во отвеченных
                    no_answered,          //  кол-во  не отвеченных
                    no_answered_return,   //  кол-во не отвеченных + вернувшиеся которые решили перезвонить
                    procent_answered,
                    procent_no_answered,
                    all_answered          // всего отвечено
                    );


 type   // тип запрошенных данных из очереди
   enumStatistiscDay = (stat_answered,            //  кол-во отвеченных
                        stat_no_answered,         //  кол-во  не отвеченных
                        stat_no_answered_return,  //  кол-во  не отвеченных + вернувшиеся решили перезвонить
                        stat_procent_no_answered, // процент
                        stat_procent_no_answered_return, // процент + вернувшиеся
                        stat_summa                // сумма
                        );

  type    // типы доступов
   enumAccessList = (menu_settings_users,                       // Меню-Пользователи
                     menu_settings_serversik,                   // Меню-СервераИК
                     menu_settings_siptrunk,                    // Меню-Sip_транки
                     menu_settings_global,                      // Меню-Глобальные_настройки
                     menu_active_session,                       // Меню-Активные сессии
                     menu_service,                              // Меню-Услуги
                     menu_missed_calls                          // Меню-Пропущенные звонки
                     );


  type   // тип разрешение\запрет на доступ к меню
   enumAccessStatus = ( access_DISABLED  = 0,
                        access_ENABLED   = 1
                      );

  type   // тип показывать\скрывать ушедших домой операторов
   enumHideShowGoHomeOperators = (  goHome_Hide,   // скрывать
                                    goHome_Show    // показывать
                                 );


  type  // тип программы
  enumProrgamm = ( eGUI,
                   eCHAT,
                   eREPORT,
                   eSMS,
                   eService
                 );

  type  // какой браузер сейчас активен основной или дополнительный  !TODO эти же типы есть еще и в chat.exe
   enumActiveBrowser = (  eMaster = 0,
                          eSlave  = 1,
                          eNone   = 2
                        );


  type   // тип чата  !TODO эти же типы есть еще и в chat.exe
  enumChannel  = ( ePublic,  // публичный (main)
                   ePrivate  // приватный (тет-а-тет)
                  );


  type  // типы ID чатов !TODO эти же типы есть еще и в chat.exe
 enumChatID = ( eChatMain = -1,
                eChatID0  = 0,
                eChatID1  = 1,
                eChatID2  = 2,
                eChatID3  = 3,
                eChatID4  = 4,
                eChatID5  = 5,
                eChatID6  = 6,
                eChatID7  = 7,
                eChatID8  = 8,
                eChatID9  = 9
                );


  type  // типы расширений которые можно будет скачать\закачать на ftp
  enumExtensionFTP = (  eFTP_Unknown,
                        eFTP_Zip,
                        eFTP_Doc,
                        eFTP_Docx,
                        eFTP_Xls,
                        eFTP_Xlsx,
                        eFTP_Txt,
                        eFTP_Jpeg,
                        eFTP_Png,
                        eFTP_Pdf
                      );

  type // режим работы ftp
  enumModeFTP = (eDownload, // скачать с ftp
                 eUpload    // залить на ftp
                );


  type  // режим показа ститистика по звонкам за день
  enumStatisticsCalls = (eNumbers,  // цифры
                         eGraph);   // график


  type  // нужно ли переподключаться к БД в случае ошибки
  enumNeedReconnectBD = (eNeedReconnectYES,   // да
                         eNeedReconnectNO);   // нет


  type   // ручная отправка SMS
  enumManualSMS = (sending_one,      // отпрвака на 1 номер
                   sending_list);    // отпрвака на сножество номеров


  type   // статус Нет | Да
  enumStatus = (eNO   = 0,
                eYES  = 1);

  type  // Статус клиники Закрыта | Работает
  enumStatusJobClinic = ( eClose = 0,
                          eOpen  = 1);


  type // типа размера шрифтов
  enumFontSize  = (eActiveSip,
                   eIvr,
                   eQueue);

  type  // тип изменение размера шрифта
  enumFontChange = (eFontUP,
                    eFontDonw);


   type // тип для окрашивание цветого статуса оператора
   enumColorStatus = (color_Default,        // по умолчаниюю
                      color_Good,           // доступен
                      color_NotBad,         // разговор от 3мин до 10мин  | поствызов >= 3мин
                      color_Bad,            // разговор от 10мин до 15мин
                      color_Very_Bad,       // разговор >= 15мин
                      color_Break);         // обед или перерыв


   type // тип причины отправки смс
   enumReasonSmsMessage = (reason_Empty                               = -1, // пустой
                           reason_OtmenaPriema                        = 0,  // Отмена приема врача, перенос
                           reason_NapominanieOPrieme                  = 1,  // Напоминание о приеме
                           reason_NapominanieOPrieme_do15             = 2,  // Напоминание о приеме (до 15 лет)
                           reason_NapominanieOPrieme_OMS              = 3,  // Напоминание о приеме (ОМС)
                           reason_IstekaetSrokGotovnostiBIOMateriala  = 4,  // Истекает срок годности биоматериала
                           reason_AnalizNaPereustanovke               = 5,  // Анализ на переустановке
                           reason_UvelichilsyaSrokIssledovaniya       = 6,  // Увеличился срок выполнения лабораторных исследований по тех. причинам
                           reason_Perezabor                           = 7,  // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)
                           reason_Critical                            = 8,  // Получено письмо из лаборатории о критических значениях
                           reason_ReadyDiagnostic                     = 9,  // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)
                           reason_ReadyNalog                          = 10, // Готова справка в налоговую
                           reason_ReadyDocuments                      = 11, // Готова копия мед. документации, выписка, справка
                           reason_NeedDocumentsLVN                    = 12, // Необходимо предоставить данные для открытия ЛВН (СНИЛС)
                           reason_NeedDocumentsDMS                    = 13, // Проинформировать о согласовании услуг по ДМС (когда обещали)
                           reason_VneplanoviiPriem                    = 14, // Согласован внеплановый прием (обозначить время)
                           reason_ReturnMoney                         = 15, // Пригласить за возвратом ДС
                           reason_ReturnMoneyInfo                     = 16, // Проинформировать об осуществлении возврата ДС
                           reason_ReturnDiagnostic                    = 17  // Пригласить за гистологическим (цитологическим) материалом
                          );
   type  // шаблон сообщения в зависимости от типа отправки
   enumReasonSmsMessageTemplate = (
                           reasonTemplate_Empty                               = -1,
                           reasonTemplate_OtmenaPriema                        = 0,  // Отмена приема врача, перенос
                           reasonTemplate_NapominanieOPrieme                  = 1,  // Напоминание о приеме
                           reasonTemplate_NapominanieOPrieme_do15             = 2,  // Напоминание о приеме (до 15 лет)
                           reasonTemplate_NapominanieOPrieme_OMS              = 3,  // Напоминание о приеме (ОМС)
                           reasonTemplate_IstekaetSrokGotovnostiBIOMateriala  = 4,  // Истекает срок годности биоматериала
                           reasonTemplate_AnalizNaPereustanovke               = 5,  // Анализ на переустановке
                           reasonTemplate_UvelichilsyaSrokIssledovaniya       = 6,  // Увеличился срок выполнения лабораторных исследований по тех. причинам
                           reasonTemplate_Perezabor                           = 7,  // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)
                           reasonTemplate_Critical                            = 8,  // Получено письмо из лаборатории о критических значениях
                           reasonTemplate_ReadyDiagnostic                     = 9,  // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)
                           reasonTemplate_ReadyNalog                          = 10, // Готова справка в налоговую
                           reasonTemplate_ReadyDocuments                      = 11, // Готова копия мед. документации, выписка, справка
                           reasonTemplate_NeedDocumentsLVN                    = 12, // Необходимо предоставить данные для открытия ЛВН (СНИЛС)
                           reasonTemplate_NeedDocumentsDMS                    = 13, // Проинформировать о согласовании услуг по ДМС (когда обещали)
                           reasonTemplate_VneplanoviiPriem                    = 14, // Согласован внеплановый прием (обозначить время)
                           reasonTemplate_ReturnMoney                         = 15, // Пригласить за возвратом ДС
                           reasonTemplate_ReturnMoneyInfo                     = 16, // Проинформировать об осуществлении возврата ДС
                           reasonTemplate_ReturnDiagnostic                    = 17  // Пригласить за гистологическим (цитологическим) материалом
     );



    type  // параметры глобальных настроек
    enumTreeSettings =(
                        tree_queue,            // корректировка времени
                        tree_firebird,         // пароль firebird
                        tree_sms,              // настройка sms
                        tree_access            // разграничение прав групп на меню
                      );

    type // параметры дней недели
     enumWorkingTime = ( workingtime_Monday,
                         workingtime_Tuesday,
                         workingtime_Wednesday,
                         workingtime_Thursday,
                         workingtime_Friday,
                         workingtime_Saturday,
                         workingtime_Sunday
                        );

   type   // признак пропущенного звонка
   enumMissed  = ( eMissed,              // пропущенные
                   eMissed_no_return,    // пропущенные не вернувшиеся
                   eMissed_all           );


   type  // статус онлайн
   enumOnlineStatus = ( eOffline = 0,  // офонлайн
                        eOnline  = 1); // онлайн


   type // типп действия при удаленной команде (пропущенные звонки, активные сессии)
   enumRemoteCommandAction = ( remoteCommandAction_activeSession,       // активные сесиис
                               remoteCommandAction_missedCalls          // пропущенные звонки
   );

   type // тип пола
   enumGender = (gender_male,        // мужской
                 gender_female);     // женский

   type // тип из какой таблицы доставать данные при создании отчета "Отчет по количеству звонков операторами"
   enumReportTableCountCallsOperator = (eTableQueue,
                                        eTableHistoryQueue);

   type // тип из какой таблицы доставать данные при создании отчета "Отчет по количеству звонков операторами"
   enumReportTableCountCallsOperatorOnHold = (eTableOnHold,
                                              eTableHistoryOnHold);

   type // тип статуса sip транка
   enumTrunkStatus = (eTrunkUnknown = -1,
                      eTrunkRegisterd = 0,
                      eTrunkRequest = 1);

  // =================== ПРОЕОБРАЗОВАНИЯ ===================

  // Boolean -> string
 function BooleanToString(InValue:Boolean):string;

 function EnumLoggingToInteger(_logging:enumLogging):Integer;                      // проеобразование из EnumLogging в Integer
 function IntegerToEnumLogging(_logging:Integer):enumLogging;                      // преобразование из Integer в EnumLogging
 function EnumLoggingToString(_logging:enumLogging):string;                        // EnumLogging -> String
 function StringToEnumRole(InRole:string):enumRole;                                // String -> EnumRole
 function EnumRoleToString(InRole:enumRole):string;                                // EnumRole -> String
 function EnumRoleToStringName(InRole:enumRole):string;                            // EnumRole -> String(сокращенное название)
 function EnumRoleToInteger(_InRole:enumRole):Integer;                             // EnumRole -> Integer
 function EnumProgrammToString(InEnumProgram:enumProrgamm):string;                 // enumProgramm -> string
 function EnumAccessListToString(AccessList:enumAccessList):string;                // enumAccessList -> String
 function EnumAccessListToStringBaseName(_access:enumAccessList):string;           // enumAccessList -> String(name BD)
 function EnumAccessStatusToBool(_status: enumAccessStatus): Boolean;               // enumAccessStatus -> Bool
 function EnumChannelChatIDToString(InChatID:enumChatID):string;                   // enumChatID -> string
 function EnumChannelToString(InChannel:enumChannel):string;                       // enumChannel -> string
 function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;     // enumActiveBrowser -> string
 function IntegerToEnumStatusOperators(InStatusId:Integer):enumStatusOperators;    // Integer -> enumStatusOperators
 function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;      // enumStatusOperators -> integer
 function EnumNeedReconnectBDToBoolean(inStatusReconnect:enumNeedReconnectBD):Boolean;   // enumNeedReconnectBD -> Boolean
 function StatusOperatorToEnumLogging(_operatorStatus:Integer):enumLogging;          // преобразование текущего статуса оператора из int в EnumLogging
 function EnumLoggingToStatusOperator(_logging:enumLogging):enumStatusOperators;    // преобразование EnumLogging в текущий статус оператора
 function SettingParamsStatusToInteger(_status:enumParamStatus):Integer;            // SettingParamsStatus --> Int
 function IntegerToSettingParamsStatus(_status:Integer):enumParamStatus;            // Int --> SettingParamsStatus
 function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;                // EnumTypeClinic -> String
 function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;                // String -> EnumTypeClinic
 function EnumQueueCurrentToString(_queue:enumQueueCurrent):string;                // EnumQueueCurrent - > String
 function EnumQueueCurrentToInteger(_queue:enumQueueCurrent):Integer;              // EnumQueueCurrent - > Integer
 function StringToEnumQueueCurrent(_queue:string):enumQueueCurrent;                // String -> EnumQueueCurrent
 function StringToSettingParamsStatus(status:string):enumParamStatus;             // String (Да\Нет) --> SettingParamsStatus
 function StrToBoolean(InValue:string):Boolean;                                    // string -> boolean
 function EnumStatusToString(InStatus:enumStatus):string;                          // enumStatus -> String
 function EnumStatusToInteger(InStatus:enumStatus):Integer;                        // enumStatus -> Integer
 function BooleanToEnumStatus(_value:Boolean):enumStatus;                          // Boolean -> enumStatus
 function StringToEnumStatus(InStatus:string):enumStatus;                          // String -> enumStatus
 function EnumStatusJobClinicToString(InStatus:enumStatusJobClinic):string;        // enumStatusJobClinic -> String
 function EnumStatusJobClinicToInteger(InStatus:enumStatusJobClinic):integer;      // enumStatusJobClinic -> Integer
 function StringToEnumStatusJobClinic(InStatus:string):enumStatusJobClinic;        // String -> enumStatusJobClinic
 function EnumFontSizeToString(InFont:enumFontSize):string;                        // enumFontSize -> String;
 function EnumColorStatusToTColor(_statusColor:enumColorStatus):TColor;            // enumColorStatus -> TColor
 function EnumReasonSmsMessageToString(_reasonSmsMessage:enumReasonSmsMessage):string; // enumReasonSmsMessage -> String
 function EnumReasonSmsMessageToInteger(_reasonSmsMessage:enumReasonSmsMessage):integer; // enumReasonSmsMessage -> Integer
 function IntegerToEnumReasonSmsMessage(_value:Integer):enumReasonSmsMessage; // Integer -> enumReasonSmsMessage
 function StringToEnumReasonSmsMessage(InStatus:string):enumReasonSmsMessage;      // String -> enumReasonSmsMessage
 function EnumReasonSmsMessageToEnumReasonSmsMessageTemplate(_reasonSmsMessage:enumReasonSmsMessage):EnumReasonSmsMessageTemplate; // enumReasonSmsMessage -> enumReasonSmsMessageTemplate
 function EnumReasonSmsMessageTemplateToString(_reasonSmsMessageTemplate:enumReasonSmsMessageTemplate):TStringBuilder; // EnumReasonSmsMessageTemplate -> String
 function EnumTreeSettingsToString(_enumTreeSettings:enumTreeSettings):string;        // enumTreeSettings -> String
 function StringToEnumTreeSettings(_status:string):enumTreeSettings;                  // String -> enumTreeSettings
 function EnumOnlineStatusToString(_status:enumOnlineStatus):string;                  // EnumOnlineStatus -> String
 function EnumGenderToString(_gender:enumGender):string;                              // EnumGender -> String
 function StringToEnumGender(_gender:string):enumGender;                              // String -> EnumGender
 function EnumGenderToInteger(_gender:enumGender):Integer;                            // EnumGender -> Integer
 function EnumWorkingTimeToString(_workingTime:enumWorkingTime):string;               // enumWorkingTime -> String
 function EnumReportTableCountCallsOperatorToString(_table:enumReportTableCountCallsOperator):string; //enumReportTableCountCallsOperator -> String
 function EnumReportTableCountCallsOperatorOnHoldToString(_table:enumReportTableCountCallsOperatorOnHold):string; //EnumReportTableCountCallsOperatorOnHold -> String
 function StringToEnumTrunkStatus(_status:string):enumTrunkStatus;                    // EnumTrunkStatus - > String


 // =================== ПРОЕОБРАЗОВАНИЯ ===================
 implementation


 // Boolean -> string
function BooleanToString(InValue:Boolean):string;
begin
  if InValue = True then Result:='True'
  else Result:='False';
end;


// проеобразование из EnumLoggin в Integer
function EnumLoggingToInteger(_logging:enumLogging):Integer;
begin
  case _logging of
    eLog_unknown:             Result:=-1;       // неизвестный статус
    eLog_enter:               Result:=0;        // вход
    eLog_exit:                Result:=1;        // выход
    eLog_auth_error:          Result:=2;        // не успешная авторизация
    eLog_exit_force:          Result:=3;        // выход (через команду force_closed)
    eLog_add_queue_5000:      Result:=4;        // добавление в очередь 5000
    eLog_add_queue_5050:      Result:=5;        // добавление в очередь 5050
    eLog_add_queue_5000_5050: Result:=6;        // добавление в очередь 5000 и 5050
    eLog_del_queue_5000:      Result:=7;        // удаление из очереди 5000
    eLog_del_queue_5050:      Result:=8;        // удаление из очереди 5050
    eLog_del_queue_5000_5050: Result:=9;        // удаление из очереди 5000 и 5050
    eLog_available:           Result:=10;       // доступен
    eLog_home:                Result:=11;       // домой
    eLog_exodus:              Result:=12;       // исход
    eLog_break:               Result:=13;       // перерыв
    eLog_dinner:              Result:=14;       // обед
    eLog_postvyzov:           Result:=15;       // поствызов
    eLog_studies:             Result:=16;       // учеба
    eLog_IT:                  Result:=17;       // ИТ
    eLog_transfer:            Result:=18;       // переносы
    eLog_reserve:             Result:=19;       // резерв
    eLog_callback:            Result:=20;       // callback
    eLog_create_new_user:     Result:=21;       // создание нового пользователя
    eLog_edit_user:           Result:=22;       // редактирование пользователя

  else  Result:=-1;
  end;
end;

// преобразование из Integer в TLogging
function IntegerToEnumLogging(_logging:Integer):enumLogging;
begin
  case _logging of
   -1:    Result:=eLog_unknown;             // неизвестный статус
    0:    Result:=eLog_enter;               // вход
    1:    Result:=eLog_exit;                // выход
    2:    Result:=eLog_auth_error;          // не успешная авторизация
    3:    Result:=eLog_exit_force;          // выход (через команду force_closed)
    4:    Result:=eLog_add_queue_5000;      // добавление в очередь 5000
    5:    Result:=eLog_add_queue_5050;      // добавление в очередь 5050
    6:    Result:=eLog_add_queue_5000_5050; // добавление в очередь 5000 и 5050
    7:    Result:=eLog_del_queue_5000;      // удаление из очереди 5000
    8:    Result:=eLog_del_queue_5050;      // удаление из очереди 5050
    9:    Result:=eLog_del_queue_5000_5050; // удаление из очереди 5000 и 5050
    10:   Result:=eLog_available;           // доступен
    11:   Result:=eLog_home;                // домой
    12:   Result:=eLog_exodus;              // исход
    13:   Result:=eLog_break;               // перерыв
    14:   Result:=eLog_dinner;              // обед
    15:   Result:=eLog_postvyzov;           // поствызов
    16:   Result:=eLog_studies;             // учеба
    17:   Result:=eLog_IT;                  // ИТ
    18:   Result:=eLog_transfer;            // переносы
    19:   Result:=eLog_reserve;             // резерв
    20:   Result:=eLog_callback;            // callback
    21:   Result:=eLog_create_new_user;     // создание нового пользователя
    22:   Result:=eLog_edit_user;           // редактирование пользователя
  else Result:=eLog_unknown;
  end;
end;


// EnumLogging -> String
function EnumLoggingToString(_logging:enumLogging):string;
begin
  case _logging of
    eLog_unknown:             Result:='Неизвестный статус';
    eLog_enter:               Result:='Вход';
    eLog_exit:                Result:='Выход';
    eLog_auth_error:          Result:='Не успешная авторизация';
    eLog_exit_force:          Result:='Выход (через команду force_closed)';
    eLog_add_queue_5000:      Result:='Добавление в очередь 5000';
    eLog_add_queue_5050:      Result:='Добавление в очередь 5050';
    eLog_add_queue_5000_5050: Result:='Добавление в очередь 5000 и 5050';
    eLog_del_queue_5000:      Result:='Удаление из очереди 5000';
    eLog_del_queue_5050:      Result:='Удаление из очереди 5050';
    eLog_del_queue_5000_5050: Result:='Удаление из очереди 5000 и 5050';
    eLog_available:           Result:='Доступен';
    eLog_home:                Result:='Домой';
    eLog_exodus:              Result:='Исход';
    eLog_break:               Result:='Перерыв';
    eLog_dinner:              Result:='Обед';
    eLog_postvyzov:           Result:='Поствызов';
    eLog_studies:             Result:='Учеба';
    eLog_IT:                  Result:='ИТ';
    eLog_transfer:            Result:='Переносы';
    eLog_reserve:             Result:='Резерв';
    eLog_callback:            Result:='Callback';
    eLog_create_new_user:     Result:='Создание нового пользователя';
    eLog_edit_user:           Result:='Редактирование пользователя';
  end;
end;

// String -> EnumRole
function StringToEnumRole(InRole:string):enumRole;
var
 i:Integer;
 role:enumRole;
begin
  Result:=role_operator_no_dash;

  for i:=Ord(Low(enumRole)) to Ord(High(enumRole)) do
  begin
    role:=enumRole(i);
    if EnumRoleToString(role) = InRole then begin
     Result:=role;
     Exit;
    end;
  end;
end;


// EnumRole -> String
function EnumRoleToString(InRole:enumRole):string;
begin
  case InRole of
   role_administrator       :Result:='Администратор';
   role_lead_operator       :Result:='Ведущий оператор';
   role_senior_operator     :Result:='Старший оператор';
   role_operator            :Result:='Оператор';
   role_operator_no_dash    :Result:='Оператор (без дашборда)';
   role_supervisor_cov      :Result:='Руководитель ЦОВ';
  end;
end;

// EnumRole -> Integer
function EnumRoleToInteger(_InRole:enumRole):Integer;
var
 i:Integer;
begin
  Result:=6; // operator_no_dash

  for i:=Ord(Low(enumRole)) to Ord(High(enumRole)) do
  begin
    if enumRole(i) = _InRole then begin
      Result:=i;
      Exit;
    end;
  end;
end;

// EnumRole -> String(сокращенное название)
function EnumRoleToStringName(InRole:enumRole):string;
begin
 case InRole of
   role_administrator       :Result:='administrator';
   role_lead_operator       :Result:='lead_operator';
   role_senior_operator     :Result:='senior_operator';
   role_operator            :Result:='operator';
   role_operator_no_dash    :Result:='operator_no_dash';
   role_supervisor_cov      :Result:='supervisor_cov';
  end;
end;

 // enumProgramm -> string
function EnumProgrammToString(InEnumProgram:enumProrgamm):string;
begin
  case InEnumProgram of
   eGUI     :Result:='gui';
   eCHAT    :Result:='chat';
   eREPORT  :Result:='report';
   eSMS     :Result:='sms';
   eService :Result:='service';
  end;
end;


// название как на форме TMenu
function EnumAccessListToString(AccessList:enumAccessList):string;
begin
  case AccessList of
    menu_settings_users:        Result:='menu_Users';
    menu_settings_serversik:    Result:='menu_ServersIK';
    menu_settings_siptrunk:     Result:='menu_SIPtrunk';
    menu_settings_global:       Result:='menu_GlobalSettings';
    menu_active_session:        Result:='menu_activeSession';
    menu_service:               Result:='menu_service';
    menu_missed_calls:          Result:='menu_missed_calls';
  end;
end;

// enumAccessList -> String(name BD) название как в БД
function EnumAccessListToStringBaseName(_access:enumAccessList):string;
begin
 case _access of
    menu_settings_users:        Result:='menu_users';
    menu_settings_serversik:    Result:='menu_serversik';
    menu_settings_siptrunk:     Result:='menu_siptrunk';
    menu_settings_global:       Result:='menu_settings_global';
    menu_active_session:        Result:='menu_active_session';
    menu_service:               Result:='menu_service';
    menu_missed_calls:          Result:='menu_missed_calls';
  end;
end;

// преобразование EnumAccessStatus --> Bool
function EnumAccessStatusToBool(_status: enumAccessStatus): Boolean;
begin
  case _status of
    access_ENABLED:   Result:= True;
    access_DISABLED:  Result:= False;
    else
     Result:=False;
  end;
end;


// enumChatID -> string
function EnumChannelChatIDToString(InChatID:enumChatID):string;
begin
  case InChatID of
    eChatMain:  Result:='main';
    eChatID0:   Result:='0';
    eChatID1:   Result:='1';
    eChatID2:   Result:='2';
    eChatID3:   Result:='3';
    eChatID4:   Result:='4';
    eChatID5:   Result:='5';
    eChatID6:   Result:='6';
    eChatID7:   Result:='7';
    eChatID8:   Result:='8';
    eChatID9:   Result:='9';
  end;
end;

//enumChannel -> string
function EnumChannelToString(InChannel:enumChannel):string;
begin
   case InChannel of
     ePublic:   Result:='public';
     ePrivate:  Result:='private';
   end;
end;


// enumActiveBrowser -> string
function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;
begin
  case InActiveBrowser of
    eNone   :Result:='none';
    eMaster :Result:='master';
    eSlave  :Result:='slave';
  end;
end;


 // Integer -> enumStatusOperators
function IntegerToEnumStatusOperators(InStatusId:Integer):enumStatusOperators;
begin
 case InStatusId of
   -1:  Result:=eUnknown;         // unknown
    0:  Result:=eReserved0;       // зарезервировано под новый статус
    1:  Result:=eAvailable;       // доступен
    2:  Result:=eHome;            // домой
    3:  Result:=eExodus;          // исход
    4:  Result:=eBreak;           // перерыв
    5:  Result:=eDinner;          // обед
    6:  Result:=ePostvyzov;       // поствызов
    7:  Result:=eStudies;         // учеба
    8:  Result:=eIT;              // ИТ
    9:  Result:=eTransfer;        // переносы
   10:  Result:=eReserve;         // резерв
   11:  Result:=eCallback;        // callback
 else Result:=eUnknown
 end;
end;

 // enumStatusOperators -> integer
function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;
begin
 case InStatus of
   eUnknown:    Result:= -1;      // unknown
   eReserved0:  Result:= 0;       // резерв
   eAvailable:  Result:= 1;       // доступен
   eHome:       Result:= 2;       // домой
   eExodus:     Result:= 3;       // исход
   eBreak:      Result:= 4;       // перерыв
   eDinner:     Result:= 5;       // обед
   ePostvyzov:  Result:= 6;       // поствызов
   eStudies:    Result:= 7;       // учеба
   eIT:         Result:= 8;       // ИТ
   eTransfer:   Result:= 9;       // переносы
   eReserve:    Result:= 10;      // резерв
   eCallback:   Result:= 11;      // callback
 else Result:=-1
 end;
end;


 // enumNeedReconnectBD -> Boolean
function EnumNeedReconnectBDToBoolean(inStatusReconnect:enumNeedReconnectBD):Boolean;
begin
  case inStatusReconnect of
    eNeedReconnectYES: Result:=True;
    eNeedReconnectNO:  Result:=False;
  else Result:=False;
  end;
end;


// преобразование текущего статуса оператора из int в EnumLogging
 function StatusOperatorToEnumLogging(_operatorStatus:Integer):enumLogging;
begin
  case  _operatorStatus of
     1: Result:=eLog_available;
     2: Result:=eLog_home;
     3: Result:=eLog_exodus;
     4: Result:=eLog_break;
     5: Result:=eLog_dinner;
     6: Result:=eLog_postvyzov;
     7: Result:=eLog_studies;
     8: Result:=eLog_IT;
     9: Result:=eLog_transfer;
    10: Result:=eLog_reserve;
    11: Result:=eLog_callback;
  else Result:=eLog_unknown;
  end;
end;

// преобразование EnumLogging в текущий статус оператора
function EnumLoggingToStatusOperator(_logging:enumLogging):enumStatusOperators;
begin
  case _logging of
    eLog_unknown,
    eLog_enter,
    eLog_exit,
    eLog_auth_error,
    eLog_exit_force,
    eLog_add_queue_5000,
    eLog_add_queue_5050,
    eLog_add_queue_5000_5050,
    eLog_del_queue_5000,
    eLog_del_queue_5050,
    eLog_del_queue_5000_5050,
    eLog_create_new_user,
    eLog_edit_user,
    eLog_available:   Result:=eUnknown;
    eLog_home:        Result:=eHome;
    eLog_exodus:      Result:=eExodus;
    eLog_break:       Result:=eBreak;
    eLog_dinner:      Result:=eDinner;
    eLog_postvyzov:   Result:=ePostvyzov;
    eLog_studies:     Result:=eStudies;
    eLog_IT:          Result:=eIT;
    eLog_transfer:    Result:=eTransfer;
    eLog_reserve:     Result:=eReserve;
    eLog_callback:    Result:=eCallback;
  else Result:=eUnknown;
  end;
end;

// SettingParamsStatus --> Int
function SettingParamsStatusToInteger(_status:enumParamStatus):Integer;
begin
  case _status of
    paramStatus_ENABLED:   Result:= 1;
    paramStatus_DISABLED:  Result:= 0;
  else Result:=0;
  end;
end;

// Int --> SettingParamsStatus
function IntegerToSettingParamsStatus(_status:Integer):enumParamStatus;
begin
  case _status of
    0:Result:=paramStatus_DISABLED;
    1:Result:=paramStatus_ENABLED;
  else Result:=paramStatus_DISABLED;
  end;
end;

// string (Да\Нет) --> SettingParamsStatus
function StringToSettingParamsStatus(status:string):enumParamStatus;
var
 tmp:string;
begin
  tmp:=status;
  tmp:=AnsiLowerCase(status);

  if tmp='да' then Result:=paramStatus_ENABLED
  else if tmp='нет' then Result:=paramStatus_DISABLED
  else Result:=paramStatus_DISABLED;
end;


// EnumTypeClinic -> String
function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;
begin
   case typeClinic of
     eMMC:            Result:='ММЦ';
     eCLD:            Result:='ЦЛД';
     eLaboratory:     Result:='Лаборатория';
     eOther:          Result:='Прочее';
   end;
end;

// String -> EnumTypeClinic
function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;
var
 tmp:enumTypeClinic;
begin
   tmp:=eOther;

   if typeClinic = 'ММЦ'          then tmp:=eMMC;
   if typeClinic = 'ЦЛД'          then tmp:=eCLD;
   if typeClinic = 'Лаборатория'  then tmp:=eLaboratory;
   if typeClinic = 'Прочее'       then tmp:=eOther;

   Result:=tmp;
end;

// EnumQueueCurrent - > String
function EnumQueueCurrentToString(_queue:enumQueueCurrent):string;
begin
   case _queue of
    queue_5000:       Result:='5000';
    queue_5050:       Result:='5050';
    queue_5000_5050:  Result:='5000 и 5050';
    queue_null:       Result:='null';
   else  Result:='null';
   end;
end;

// EnumQueueCurrent - > Integer
function EnumQueueCurrentToInteger(_queue:enumQueueCurrent):Integer;
var
 i:Integer;
begin
  for i:=0 to Ord(High(enumQueueCurrent)) do begin
    if enumQueueCurrent(i) = _queue then begin
      Result:=i;
      Exit;
    end;
  end;
end;

// String -> EnumQueueCurrent
function StringToEnumQueueCurrent(_queue:string):enumQueueCurrent;
begin
  if _queue = '5000' then         Result:=queue_5000;
  if _queue = '5050' then         Result:=queue_5050;
  if _queue = '5000 и 5050' then  Result:=queue_5000_5050;
  if _queue = 'null' then         Result:=queue_null;
end;

// string -> boolean
function StrToBoolean(InValue:string):Boolean;
var
 tmp:string;
begin
  Result:=False;
  tmp:=AnsiLowerCase(InValue);
  if tmp = 'true' then Result:=True;
end;

// enumStatus -> String
function EnumStatusToString(InStatus:enumStatus):string;
begin
  case InStatus of
    eNO:  Result:='Нет';
    eYES: Result:='Да';
  end;
end;

// enumStatus -> Integer
function EnumStatusToInteger(InStatus:enumStatus):Integer;
begin
  case InStatus of
    eNO:  Result:=0;
    eYES: Result:=1;
  end;
end;

// Boolean -> enumStatus
function BooleanToEnumStatus(_value:Boolean):enumStatus;
begin
  if _value = False then Result:=eNO;
  if _value = True  then Result:=eYES;
end;


// String -> enumStatus
function StringToEnumStatus(InStatus:string):enumStatus;
begin
  if InStatus = 'Нет'  then Result:=eNO;
  if InStatus = 'Да'   then Result:=eYES;
end;

// enumStatusJobClinic -> String
function EnumStatusJobClinicToString(InStatus:enumStatusJobClinic):string;
begin
   case InStatus of
    eClose: Result:='Закрыто';
    eOpen:  Result:='Работает';
   end;
end;

// enumStatusJobClinic -> Integer
function EnumStatusJobClinicToInteger(InStatus:enumStatusJobClinic):integer;
begin
  case InStatus of
    eClose: Result:=0;
    eOpen:  Result:=1;
   end;
end;

// String -> enumStatusJobClinic
function StringToEnumStatusJobClinic(InStatus:string):enumStatusJobClinic;
begin
  if InStatus = 'Закрыто'  then Result:=eClose;
  if InStatus = 'Работает' then Result:=eOpen;
end;

// enumFontSize -> String;
function EnumFontSizeToString(InFont:enumFontSize):string;
begin
  case InFont of
    eActiveSip: Result:='ActiveSip';
    eIvr:       Result:='IVR';
    eQueue:     Result:='Queue';
  end;
end;

 // enumColorStatus -> TColor
function EnumColorStatusToTColor(_statusColor:enumColorStatus):TColor;
begin
  case _statusColor of
    color_Default:    Result := clBlack;    // по умолчанию
    color_Good:       Result := clGreen;    // доступен
    color_NotBad:     Result := clRed;      // разговор от 3мин до 10мин  | поствызов >= 3мин
    color_Bad:        Result := $0000008A;  // разговор от 10мин до 15мин
    color_Very_Bad:   Result := clBlue;     // разговор >= 15мин
    color_Break:      Result := $00DDB897;  // обед или перерыв
  else
    Result := clBlack;
  end;
end;


// enumReasonSmsMessage -> String
function EnumReasonSmsMessageToString(_reasonSmsMessage:enumReasonSmsMessage):string;
begin
  case _reasonSmsMessage of
     reason_OtmenaPriema                        :Result:='Отмена приема врача, перенос';
     reason_NapominanieOPrieme                  :Result:='Напоминание о приеме';
     reason_NapominanieOPrieme_do15             :Result:='Напоминание о приеме (до 15 лет)';
     reason_NapominanieOPrieme_OMS              :Result:='Напоминание о приеме (ОМС)';
     reason_IstekaetSrokGotovnostiBIOMateriala  :Result:='Истекает срок годности биоматериала';
     reason_AnalizNaPereustanovke               :Result:='Анализ на переустановке';
     reason_UvelichilsyaSrokIssledovaniya       :Result:='Увеличился срок выполнения лабораторных исследований по тех. причинам';
     reason_Perezabor                           :Result:='Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)';
     reason_Critical                            :Result:='Получено письмо из лаборатории о критических значениях';
     reason_ReadyDiagnostic                     :Result:='Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)';
     reason_ReadyNalog                          :Result:='Готова справка в налоговую';
     reason_ReadyDocuments                      :Result:='Готова копия мед. документации, выписка, справка';
     reason_NeedDocumentsLVN                    :Result:='Необходимо предоставить данные для открытия ЛВН (СНИЛС)';
     reason_NeedDocumentsDMS                    :Result:='Проинформировать о согласовании услуг по ДМС (когда обещали)';
     reason_VneplanoviiPriem                    :Result:='Согласован внеплановый прием';
     reason_ReturnMoney                         :Result:='Пригласить за возвратом ДС';
     reason_ReturnMoneyInfo                     :Result:='Проинформировать об осуществлении возврата ДС';
     reason_ReturnDiagnostic                    :Result:='Пригласить за гистологическим (цитологическим) материалом';
  end;
end;

// enumReasonSmsMessage -> Integer
function EnumReasonSmsMessageToInteger(_reasonSmsMessage:enumReasonSmsMessage):integer;
var
 i:Integer;
begin
  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    if enumReasonSmsMessage(i) = _reasonSmsMessage then begin
     Result:=i;
     Break;
    end;
  end;
end;

// Integer -> enumReasonSmsMessage
function IntegerToEnumReasonSmsMessage(_value:Integer):enumReasonSmsMessage;
var
 i:Integer;
begin
  Result:=reason_Empty;

  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    if i = _value then begin
      Result:=enumReasonSmsMessage(i);
      Exit;
    end;
  end;
end;

// String -> enumReasonSmsMessage
function StringToEnumReasonSmsMessage(InStatus:string):enumReasonSmsMessage;
var
 i:Integer;
 reason:enumReasonSmsMessage;
begin
  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    reason:=enumReasonSmsMessage(i);
    if EnumReasonSmsMessageToString(reason) = InStatus then begin
     Result:=reason;
     Break;
    end;
  end;
end;

// enumReasonSmsMessage -> enumReasonSmsMessageTemplate
function EnumReasonSmsMessageToEnumReasonSmsMessageTemplate(_reasonSmsMessage:enumReasonSmsMessage):EnumReasonSmsMessageTemplate;
var
 i:Integer;
 reason:enumReasonSmsMessage;
begin
 for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    reason:=enumReasonSmsMessage(i);
    if reason = _reasonSmsMessage then begin
      Result:=enumReasonSmsMessageTemplate(i);
      Break;
    end;
  end;
end;


// EnumReasonSmsMessageTemplate -> String
function EnumReasonSmsMessageTemplateToString(_reasonSmsMessageTemplate:enumReasonSmsMessageTemplate):TStringBuilder;
begin
  Result:=TStringBuilder.Create;

  case _reasonSmsMessageTemplate of
   reasonTemplate_OtmenaPriema                        : begin // Отмена приема врача, перенос
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем, что мы вынуждены перенести Вашу запись к врачу. ');
    Result.Append('Свяжитесь, пожалуйста, с нами для выбора удобного времени посещения клиники по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_NapominanieOPrieme                  : begin  // Напоминание о приеме
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, ');
    Result.Append('Вы записаны к доктору %date% в %time% в клинику по адресу %address%');
   end;
   reasonTemplate_NapominanieOPrieme_do15             : begin // Напоминание о приеме (до 15 лет)
    Result.Append('Здравствуйте! %name% %otchestvo% %pol% к доктору %date% в %time% ');
    Result.Append('в клинику по адресу %address%. Прием возможен в присутствии законного представителя ребенка');
   end;
   reasonTemplate_NapominanieOPrieme_OMS              : begin // Напоминание о приеме (ОМС)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, ');
    Result.Append('Вы записаны к доктору %date% в %time% в клинику по адресу %address%. ');
    Result.Append('При себе необходимо иметь паспорт, СНИЛС и полис ОМС');
   end;
   reasonTemplate_IstekaetSrokGotovnostiBIOMateriala  : begin // Истекает срок годности биоматериала
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, у Вас есть неоформленные лабораторные исследования. ');
    Result.Append('До %date% %time% свяжитесь, пожалуйста, с нами для уточнения деталей по номеру +7(8442)220-220 или +7(8443)450-450. ');
    Result.Append('После указанного времени мы утилизируем биоматериал ');
    Result.Append('и для выполнения исследования Вам необходимо будет сдать биоматериал повторно');
   end;
   reasonTemplate_AnalizNaPereustanovke               : begin // Анализ на переустановке
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Срок готовности лабораторных анализов увеличивается, просьба связаться с нами для уточнения деталей ');
    Result.Append('по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_UvelichilsyaSrokIssledovaniya       : begin // Увеличился срок выполнения лабораторных исследований по тех. причинам
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем Вам, что в связи с техническим сбоем выдача результатов лабораторных исследований задерживается ');
    Result.Append('до %date%. Приносим извинения за доставленные неудобства');
   end;
   reasonTemplate_Perezabor                           : begin // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем Вам, что %labs% %study% не %maybe% быть %done% по причине "%prichina%". ');
    Result.Append('Приглашаем Вас для перезабора биоматериала в клинику по адресу %address% ');
    Result.Append('или просим связаться с нами по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_Critical                            : begin // Получено письмо из лаборатории о критических значениях
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем Вам, что по результатам лабораторных исследований Вам необходимо как можно быстрее обратиться к врачу ');
    Result.Append('или связаться с нами по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_ReadyDiagnostic                     : begin // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, результат Вашей функциональной диагностики готов. ');
    Result.Append('Забрать заключение Вы можете в часы работы клиники (%time_clinic%) по адресу %address%');
   end;
   reasonTemplate_ReadyNalog                          : begin // Готова справка в налоговую
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, Ваша справка об оплате медицинских услуг для получения социального налогового вычета готова. ');
    Result.Append('Забрать документ Вы можете в часы работы клиники (%time_clinic%) по адресу %address%');
   end;
   reasonTemplate_ReadyDocuments                      : begin // Готова копия мед. документации, выписка, справка
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, запрашиваемая Вами медицинская документация готова. ');
    Result.Append('Забрать документ Вы можете в часы работы клиники (%time_clinic%) по адресу %address%');
   end;
   reasonTemplate_NeedDocumentsLVN                    : begin // Необходимо предоставить данные для открытия ЛВН (СНИЛС)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем, что для открытия листа временной нетрудоспособности Вам необходимо предоставить данные Вашего СНИЛСа. ');
    Result.Append('Просим Вас обратиться в клинику по адресу %address% или связаться с нами по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_NeedDocumentsDMS                    : begin // Проинформировать о согласовании услуг по ДМС (когда обещали)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться по вопросу согласования услуг в рамках программы ДМС. ');
    Result.Append('Просим Вас связаться с нами по номеру +7(8442)220-220 или +7(8443)450-450');
   end;
   reasonTemplate_VneplanoviiPriem                    : begin // Согласован внеплановый прием (обозначить время)
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Доктор сможет принять Вас внепланово сегодня в %time% в клинике по адресу %address%. ');
    Result.Append('Просим связаться с нами по номеру +7(8442)220-220 или +7(8443)450-450 для подтверждения или отмены записи');
   end;
   reasonTemplate_ReturnMoney                         : begin // Пригласить за возвратом ДС
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем, что Вам согласован возврат денежных средств за %list_service% в размере %money% руб. ');
    Result.Append('Для осуществления возврата Вы можете обратиться в клинику по адресу %address%. ');
    Result.Append('При себе необходимо иметь паспорт и банковскую карту, по которой осуществлялась оплата');
   end;
   reasonTemplate_ReturnMoneyInfo                     : begin // Проинформировать об осуществлении возврата ДС
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем, что %date% осуществлен возврат денежных средств на Ваш расчетный счет за %list_service% ');
    Result.Append('в размере %money% руб');
   end;
   reasonTemplate_ReturnDiagnostic                    : begin // Пригласить за гистологическим (цитологическим) материалом
    Result.Append('Здравствуйте! %uvazaemii% %name% %otchestvo%, к сожалению, мы не смогли до Вас дозвониться. ');
    Result.Append('Сообщаем, что из лаборатории поступил Ваш гистологический (цитологический) материал. ');
    Result.Append('Забрать его Вы можете в часы работы клиники (%time_clinic%) по адресу %address%. ');
    Result.Append('При себе необходимо иметь паспорт');
   end;
  end;
end;


// enumTreeSettings -> String
function EnumTreeSettingsToString(_enumTreeSettings:enumTreeSettings):string;
begin
  case _enumTreeSettings of
    tree_queue:     Result:='Корректировка времени';
    tree_firebird:  Result:='Пароль firebird';
    tree_sms:       Result:='Настройка SMS';
    tree_access:    Result:='Права групп на меню';
  end;
end;

// String -> enumTreeSettings
function StringToEnumTreeSettings(_status:string):enumTreeSettings;
var
 i:Integer;
 tree_settings:enumTreeSettings;
begin
  for i:=Ord(Low(enumTreeSettings)) to Ord(High(enumTreeSettings)) do
  begin
    tree_settings:=enumTreeSettings(i);
    if EnumTreeSettingsToString(tree_settings) = _status then begin
     Result:=tree_settings;
     Break;
    end;
  end;
end;

// EnumOnlineStatus -> String
function EnumOnlineStatusToString(_status:enumOnlineStatus):string;
begin
  if _status = eOffline then Result:='offline';
  if _status = eOnline then Result:='online';
end;


// EnumGender -> String
function EnumGenderToString(_gender:enumGender):string;
begin
  if _gender = gender_male    then Result:='мужской';
  if _gender = gender_female  then Result:='женский';
end;

// String -> EnumGender
function StringToEnumGender(_gender:string):enumGender;
begin
  if _gender = 'мужской'  then Result:=gender_male;
  if _gender = 'женский'  then Result:=gender_female;
end;

// EnumGender -> Integer
function EnumGenderToInteger(_gender:enumGender):Integer;
begin
  case _gender of
   gender_male:   Result:=0;
   gender_female: Result:=1;
  else Result:=0;
  end;
end;

// enumWorkingTime -> String
function EnumWorkingTimeToString(_workingTime:enumWorkingTime):string;
begin
  case _workingTime of
    workingtime_Monday:     Result:='пн';
    workingtime_Tuesday:    Result:='вт';
    workingtime_Wednesday:  Result:='ср';
    workingtime_Thursday:   Result:='чт';
    workingtime_Friday:     Result:='пт';
    workingtime_Saturday:   Result:='суб';
    workingtime_Sunday:     Result:='вс';
  end;
end;

// EnumReportTableCountCallsOperator -> String
function EnumReportTableCountCallsOperatorToString(_table:enumReportTableCountCallsOperator):string;
begin
  case _table of
   eTableQueue:         Result:='queue';
   eTableHistoryQueue:  Result:='history_queue';
  end;
end;

//EnumReportTableCountCallsOperatorOnHold -> String
function EnumReportTableCountCallsOperatorOnHoldToString(_table:enumReportTableCountCallsOperatorOnHold):string;
begin
 case _table of
   eTableOnHold:         Result:='operators_ohhold';
   eTableHistoryOnHold:  Result:='history_onhold';
  end;
end;

 // EnumTrunkStatus - > String
function StringToEnumTrunkStatus(_status:string):enumTrunkStatus;
var
 tmp:enumTrunkStatus;
begin
  tmp:=eTrunkUnknown;

  if _status = 'Unknown' then tmp:=eTrunkUnknown;
  if _status = 'Registered' then tmp:=eTrunkRegisterd;
  if _status = 'Request' then tmp:=eTrunkRequest;

  Result:=tmp;
end;


end.
