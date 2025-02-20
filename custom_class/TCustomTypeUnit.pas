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
  SysUtils;

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


 type   // тип запрошенных данных из очереди
 enumQueueCurrent =  (queue_5000,            // 5000 очередь
                      queue_5050,            // 5050 очередь
                      queue_5000_5050,       // 5000 и 5050 очередь
                      queue_null             // нет очереди
                      );


 type   // типы прав доступа
  enumRole = (  role_administrator,         // администратор
                role_lead_operator,         // ведущий оператор
                role_senior_operator,       // старший оператор
                role_operator,              // оператор
                role_supervisor_cov,        // руководитель ЦОВ
                role_operator_no_dash       // оператор (без дашборда)
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
  enumShow_wait = ( open,
                    close );

  type
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
                    eLog_reserve              = 19         // резерв
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
                            eReserve    = 10     // резерв
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
                     menu_active_session                        // Меню-Активные сессии
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
                   eSMS
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


 // =================== ПРОЕОБРАЗОВАНИЯ ===================

  // Boolean -> string
 function BooleanToString(InValue:Boolean):string;

 function TLoggingToInteger(InTLogging:enumLogging):Integer;                       // проеобразование из TLogging в Integer
 function IntegerToTLogging(InLogging:Integer):enumLogging;                        // преобразование из Integer в TLogging
 function StringToTRole(InRole:string):enumRole;                                   // string -> TRole
 function TRoleToString(InRole:enumRole):string;                                   // TRole -> string
 function EnumProgrammToString(InEnumProgram:enumProrgamm):string;                 // enumProgramm -> string
 function TAccessListToString(AccessList:enumAccessList):string;                   // TAccessListToStr -> string
 function TAccessStatusToBool(Status: enumAccessStatus): Boolean;                  // TAccessStatus --> Bool
 function EnumChannelChatIDToString(InChatID:enumChatID):string;                   // enumChatID -> string
 function EnumChannelToString(InChannel:enumChannel):string;                       // enumChannel -> string
 function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;     // enumActiveBrowser -> string
 function IntegerToEnumStatusOperators(InStatusId:Integer):enumStatusOperators;    // Integer -> enumStatusOperators
 function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;      // enumStatusOperators -> integer
 function EnumNeedReconnectBDToBoolean(inStatusReconnect:enumNeedReconnectBD):Boolean;   // enumNeedReconnectBD -> Boolean
 function StatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;          // преобразование текущего статуса оператора из int в TLogging
 function SettingParamsStatusToInteger(status:enumParamStatus):Integer;            // SettingParamsStatus --> Int
 function IntegerToSettingParamsStatus(status:Integer):enumParamStatus;            // Int --> SettingParamsStatus
 function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;                // EnumTypeClinic -> String
 function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;                // String -> EnumTypeClinic
 function StringToSettingParamsStatus(status:string):enumParamStatus;              // String (Да\Нет) --> SettingParamsStatus
 function StrToBoolean(InValue:string):Boolean;                                    // string -> boolean

 // =================== ПРОЕОБРАЗОВАНИЯ ===================
 implementation


 // Boolean -> string
function BooleanToString(InValue:Boolean):string;
begin
  if InValue = True then Result:='True'
  else Result:='False';
end;


// проеобразование из TLogging в Integer
function TLoggingToInteger(InTLogging:enumLogging):Integer;
begin
  case InTLogging of
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
  end;
end;

// преобразование из Integer в TLogging
function IntegerToTLogging(InLogging:Integer):enumLogging;
begin
  case InLogging of
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
  end;
end;


// string -> TRole
function StringToTRole(InRole:string):enumRole;
begin
  if InRole='Администратор'             then Result:=role_administrator;
  if InRole='Ведущий оператор'          then Result:=role_lead_operator;
  if InRole='Старший оператор'          then Result:=role_senior_operator;
  if InRole='Оператор'                  then Result:=role_operator;
  if InRole='Оператор (без дашборда)'   then Result:=role_operator_no_dash;
  if InRole='Руководитель ЦОВ'          then Result:=role_supervisor_cov;
end;


// TRole -> string
function TRoleToString(InRole:enumRole):string;
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


 // enumProgramm -> string
function EnumProgrammToString(InEnumProgram:enumProrgamm):string;
begin
  case InEnumProgram of
   eGUI     :Result:='gui';
   eCHAT    :Result:='chat';
   eREPORT  :Result:='report';
  end;
end;


function TAccessListToString(AccessList:enumAccessList):string;
begin
  case AccessList of
    menu_settings_users:        Result:='menu_Users';
    menu_settings_serversik:    Result:='menu_ServersIK';
    menu_settings_siptrunk:     Result:='menu_SIPtrunk';
    menu_settings_global:       Result:='menu_GlobalSettings';
    menu_active_session:        Result:='menu_activeSession';
  end;
end;


// преобразование TAccessStatus --> Bool
function TAccessStatusToBool(Status: enumAccessStatus): Boolean;
begin
  if Status = access_ENABLED then Result:=True;
  if Status = access_DISABLED then Result:=False;
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
    0:  Result:=eReserved0;       // резерв
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
 end;
end;


 // enumNeedReconnectBD -> Boolean
function EnumNeedReconnectBDToBoolean(inStatusReconnect:enumNeedReconnectBD):Boolean;
begin
  case inStatusReconnect of
    eNeedReconnectYES: Result:=True;
    eNeedReconnectNO:  Result:=False;
  end;
end;


// преобразование текущего статуса оператора из int в TLogging
function StatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;
begin
  case InOperatorStatus of
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
  end;
end;


// SettingParamsStatus --> Int
function SettingParamsStatusToInteger(status:enumParamStatus):Integer;
begin
  case status of
    paramStatus_ENABLED:   Result:= 1;
    paramStatus_DISABLED:  Result:= 0;
  end;
end;

// Int --> SettingParamsStatus
function IntegerToSettingParamsStatus(status:Integer):enumParamStatus;
begin
  case status of
    0:Result:=paramStatus_DISABLED;
    1:Result:=paramStatus_ENABLED;
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
begin
   if typeClinic = 'ММЦ'          then Result:=eMMC;
   if typeClinic = 'ЦЛД'          then Result:=eCLD;
   if typeClinic = 'Лаборатория'  then Result:=eLaboratory;
   if typeClinic = 'Прочее'       then Result:=eOther;
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


end.
