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
  enumRole = (  role_administrator,         // �������������
                role_lead_operator,         // ������� ��������
                role_senior_operator,       // ������� ��������
                role_operator,              // ��������
                role_supervisor_cov,        // ������������ ���
                role_operator_no_dash       // �������� (��� ��������)
                );


  type  // ��� ���������� �������������� �������� ������������
    enumSettingUsers = (  settingUsers_gohome,         // �� ���������� ������� �����
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
   enumLogging = (  eLog_unknown              = -1,        // �� ��������� ������
                    eLog_enter                = 0,         // ����
                    eLog_exit                 = 1,         // �����
                    eLog_auth_error           = 2,         // �� �������� �����������
                    eLog_exit_force           = 3,         // ����� (����� ������� force_closed)
                    eLog_add_queue_5000       = 4,         // ���������� � ������� 5000
                    eLog_add_queue_5050       = 5,         // ���������� � ������� 5050
                    eLog_add_queue_5000_5050  = 6,         // ���������� � ������� 5000 � 5050
                    eLog_del_queue_5000       = 7,         // �������� �� ������� 5000
                    eLog_del_queue_5050       = 8,         // �������� �� ������� 5050
                    eLog_del_queue_5000_5050  = 9,         // �������� �� ������� 5000 � 5050
                    eLog_available            = 10,        // ��������
                    eLog_home                 = 11,        // �����
                    eLog_exodus               = 12,        // �����
                    eLog_break                = 13,        // �������
                    eLog_dinner               = 14,        // ����
                    eLog_postvyzov            = 15,        // ���������
                    eLog_studies              = 16,        // �����
                    eLog_IT                   = 17,        // ��
                    eLog_transfer             = 18,        // ��������
                    eLog_reserve              = 19         // ������
                );

   type   // ������� ������� ����������
   enumStatusOperators = (  eUnknown    = -1,    // unknown
                            eReserved0  = 0,     // ������
                            eAvailable  = 1,     // ��������
                            eHome       = 2,     // �����
                            eExodus     = 3,     // �����
                            eBreak      = 4,     // �������
                            eDinner     = 5,     // ����
                            ePostvyzov  = 6,     // ���������
                            eStudies    = 7,     // �����
                            eIT         = 8,     // ��
                            eTransfer   = 9,     // ��������
                            eReserve    = 10     // ������
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
                        access_ENABLED   = 1
                      );

  type   // ��� ����������\�������� ������� ����� ����������
   enumHideShowGoHomeOperators = (  goHome_Hide,   // ��������
                                 goHome_Show    // ����������
                               );


  type  // ��� ���������
  enumProrgamm = ( eGUI,
                   eCHAT
                   );

  type  // ����� ������� ������ ������� �������� ��� ��������������  !TODO ��� �� ���� ���� ��� � � chat.exe
   enumActiveBrowser = (  eMaster = 0,
                          eSlave  = 1,
                          eNone   = 2
                        );


  type   // ��� ����  !TODO ��� �� ���� ���� ��� � � chat.exe
  enumChannel  = ( ePublic,  // ��������� (main)
                   ePrivate  // ��������� (���-�-���)
                  );


  type  // ���� ID ����� !TODO ��� �� ���� ���� ��� � � chat.exe
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


  type  // ���� ���������� ������� ����� ����� �������\�������� �� ftp
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

  type // ����� ������ ftp
  enumModeFTP = (eDownload, // ������� � ftp
                 eUpload    // ������ �� ftp
                );



implementation



end.
