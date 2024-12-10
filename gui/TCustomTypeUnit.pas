/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       ������ ��������� ���� ������                        ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TCustomTypeUnit;

interface

  type    // ��� �������� ������������ �� ����� ��� ���
  enumMonitoringTrunk = ( monitoring_DISABLE,
                       monitoring_ENABLE
                     );


 type      // ��� ������� � firebird
  enumFirebirdAuth = (firebird_login,   // �����
                   firebird_pwd      // ������
                  );

 type   // ��� ����������� ������ �� �������
 enumQueueCurrent =  (queue_5000,            // 5000 �������
                     queue_5050,            // 5050 �������
                     queue_5000_5050,       // 5000 � 5050 �������
                     queue_null             // ��� �������
                     );


 type   // ���� ���� �������
  enumRole = ( role_administrator,         // �������������
            role_lead_operator,         // ������� ��������
            role_senior_operator,       // ������� ��������
            role_operator,              // ��������
            role_supervisor_cov,        // ������������ ���
            role_operator_no_dash       // �������� (��� ��������)
            );


  type  // ��� ���������� �������������� �������� ������������
    enumSettingUsers = (settingUsers_gohome,         // �� ���������� ������� �����
                     settingUsers_noConfirmExit   // �� ���������� ���� "����� ������ ����� �� ��������?"
    );

  type  // ��� ���������\���������� �������������� ���������������� ��������
    enumSettingUsersStatus = (settingUsersStatus_ENABLED = 1,  // ��������
                           settingUsersStatus_DISABLED = 0  // ���������
                          );

  {
     �� ������!!
     ��� ���������� ������ �������� ������� �������������� ����� � TLoggingToInt

     + �� ������� �������� � core_dashboard - namespace LOG::Log

   }

  type   // ����������� \ ������� ���� ������� �� ������
  enumShow_wait = (  open,
                  close );

  type
   enumLogging = ( TLog_unknown              = -1,        // �� ��������� ������
                TLog_enter                = 0,         // ����
                TLog_exit                 = 1,         // �����
                TLog_auth_error           = 2,         // �� �������� �����������
                TLog_exit_force           = 3,         // ����� (����� ������� force_closed)
                TLog_add_queue_5000       = 4,         // ���������� � ������� 5000
                TLog_add_queue_5050       = 5,         // ���������� � ������� 5050
                TLog_add_queue_5000_5050  = 6,         // ���������� � ������� 5000 � 5050
                TLog_del_queue_5000       = 7,         // �������� �� ������� 5000
                TLog_del_queue_5050       = 8,         // �������� �� ������� 5050
                TLog_del_queue_5000_5050  = 9,         // �������� �� ������� 5000 � 5050
                TLog_available            = 10,        // ��������
                TLog_home                 = 11,        // �����
                TLog_exodus               = 12,        // �����
                TLog_break                = 13,        // �������
                TLog_dinner               = 14,        // ����
                TLog_postvyzov            = 15,        // ���������
                TLog_studies              = 16,        // �����
                TLog_IT                   = 17,        // ��
                TLog_transfer             = 18,        // ��������
                TLog_reserve              = 19         // ������
              );



  type   // ��� ����������� ������ �� �������
   enumQueueType = (answered,            //  ���-�� ����������
                no_answered,          //  ���-��  �� ����������
                no_answered_return,   //  ���-�� �� ���������� + ����������� ������� ������ �����������
                procent_answered,
                procent_no_answered,
                all_answered          // ����� ��������
                );


 type   // ��� ����������� ������ �� �������
   enumStatistiscDay = (stat_answered,            //  ���-�� ����������
                     stat_no_answered,         //  ���-��  �� ����������
                     stat_no_answered_return,  //  ���-��  �� ���������� + ����������� ������ �����������
                     stat_procent_no_answered, // �������
                     stat_procent_no_answered_return, // ������� + �����������
                     stat_summa                // �����
                     );

  type    // ���� ��������
   enumAccessList = (menu_settings_users,                       // ����-������������
                  menu_settings_serversik,                   // ����-���������
                  menu_settings_siptrunk,                    // ����-Sip_������
                  menu_settings_global,                      // ����-����������_���������
                  menu_active_session                        // ����-�������� ������
                  );


  type   // ��� ����������\������ �� ������ � ����
   enumAccessStatus = ( access_DISABLED  = 0,
                     access_ENABLED   =1
                   );

  type   // ��� ����������\�������� ������� ����� ����������
   enumHideShowGoHomeOperators = (  goHome_Hide,   // ��������
                                 goHome_Show    // ����������
                               );

implementation



end.
