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
  enumRole = ( role_administrator,         // администратор
            role_lead_operator,         // ведущий оператор
            role_senior_operator,       // старший оператор
            role_operator,              // оператор
            role_supervisor_cov,        // руководитель ЦОВ
            role_operator_no_dash       // оператор (без дашборда)
            );


  type  // тип сохранения индивидуальных настроек пользователя
    enumSettingUsers = (settingUsers_gohome,         // не показывать ушедших домой
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
   enumLogging = ( TLog_unknown              = -1,        // не известный статус
                TLog_enter                = 0,         // Вход
                TLog_exit                 = 1,         // Выход
                TLog_auth_error           = 2,         // не успешная авторизация
                TLog_exit_force           = 3,         // Выход (через команду force_closed)
                TLog_add_queue_5000       = 4,         // добавление в очередь 5000
                TLog_add_queue_5050       = 5,         // добавление в очередь 5050
                TLog_add_queue_5000_5050  = 6,         // добавление в очередь 5000 и 5050
                TLog_del_queue_5000       = 7,         // удаление из очереди 5000
                TLog_del_queue_5050       = 8,         // удаление из очереди 5050
                TLog_del_queue_5000_5050  = 9,         // удаление из очереди 5000 и 5050
                TLog_available            = 10,        // доступен
                TLog_home                 = 11,        // домой
                TLog_exodus               = 12,        // исход
                TLog_break                = 13,        // перерыв
                TLog_dinner               = 14,        // обед
                TLog_postvyzov            = 15,        // поствызов
                TLog_studies              = 16,        // учеба
                TLog_IT                   = 17,        // ИТ
                TLog_transfer             = 18,        // переносы
                TLog_reserve              = 19         // резерв
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
                     access_ENABLED   =1
                   );

  type   // тип показывать\скрывать ушедших домой операторов
   enumHideShowGoHomeOperators = (  goHome_Hide,   // скрывать
                                 goHome_Show    // показывать
                               );

implementation



end.
