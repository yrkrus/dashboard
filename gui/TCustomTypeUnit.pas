/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       ТОЛЬКО СОЗДАННЫЕ ТИПЫ ДАННЫХ                        ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TCustomTypeUnit;

interface

  type    // тип проверки мониториться ли транк или нет
  enumMonitoringTrunk = ( monitoring_DISABLE,
                          monitoring_ENABLE
                        );


 type      // тип запроса к firebird
  enumFirebirdAuth = (firebird_login,   // логин
                      firebird_pwd      // пароль
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
    enumSettingUsers = (  settingUsers_gohome,         // не показывать ушедших домой
                          settingUsers_noConfirmExit   // не показывать окно "точно хотите выйти из дашборда?"
                        );

  type  // тип включение\отключение индивидуальных пользовательских настроек
    enumSettingUsersStatus = (settingUsersStatus_ENABLED = 1,  // включить
                           settingUsersStatus_DISABLED = 0  // выключить
                          );

  {
     НЕ ЗАБЫТЬ!!
     при добавлении нового действия сделать преобразование типов в TLoggingToInt

     + не забыить добавить в core_dashboard - namespace LOG::Log

   }

  type   // отображение \ сркытие окна запроса на сервер
  enumShow_wait = (  open,
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
                   eCHAT
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



implementation



end.
