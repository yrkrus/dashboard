/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       ������ ��������� ���� ������                        ///
///                            + ��������������                               ///
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


  type    // ��� �������� ������������ �� ����� ��� ���
  enumMonitoringTrunk = ( monitoring_DISABLE,
                          monitoring_ENABLE
                        );


 type      // ��� ������� � firebird
  enumFirebirdAuth = (firebird_login,   // �����
                      firebird_pwd      // ������
                      );

 type      // ��� ������� � SMS �����������
  enumSMSAuth = (sms_server_addr,           // ������ ����� �������
                 sms_login,                 // �����
                 sms_pwd,                   // ������
                 sms_sign                   // ������� � ����� ���
                );


 type     // ���� ������ (���, ���, �����������)
  enumTypeClinic = (eMMC,                  // ���
                    eCLD,                  // ���
                    eLaboratory,           // �����������
                    eOther                 // ������
                    );


 type   // ��� ����������� ������ �� ������� ! TODO ����� � TQueueStatistics  �������� ������ queue_5000 � queue_5050
 enumQueueCurrent =  (queue_5000,            // 5000 �������
                      queue_5050,            // 5050 �������
                      queue_5000_5050,       // 5000 � 5050 �������
                      queue_null             // ��� �������
                      );


 type   // ���� ���� �������
  enumRole = (  role_administrator    = 1,       // �������������
                role_lead_operator    = 2,       // ������� ��������
                role_senior_operator  = 3,       // ������� ��������
                role_operator         = 4,       // ��������
                role_supervisor_cov   = 5,       // ������������ ���
                role_operator_no_dash = 6        // �������� (��� ��������)
                );


  type  // ��� ���������� �������������� �������� ������������
    enumSettingUsers = (  settingUsers_gohome,                  // �� ���������� ������� �����
                          settingUsers_noConfirmExit,           // �� ���������� ���� "����� ������ ����� �� ��������?"
                          settingUsers_showStatisticsQueueDay   // ����� ��� ������� ���������� � ������ "��������� �������� � �������" 0-����� | 1 - ������
                            );

  type  // ��� ���������\���������� boolean ����������
    enumParamStatus = (paramStatus_ENABLED  = 1,  // ��������
                       paramStatus_DISABLED = 0   // ���������
                       );

  {
     �� ������!!
     ��� ���������� ������ �������� ������� �������������� ����� � TLoggingToInt

     + �� ������� �������� � core_dashboard - namespace LOG::Log

   }

  type   // ����������� \ ������� ���� ������� �� ������
  enumShow_wait = ( show_open,
                    show_close );

  type       // ������� logging_action
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
                    eLog_reserve              = 19,        // ������
                    eLog_callback             = 20,        // callback
                    eLog_create_new_user      = 21,        // �������� ������ ������������
                    eLog_edit_user            = 22         // �������������� ������������
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
                            eReserve    = 10,    // ������
                            eCallback   = 11     // callback
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
                     menu_active_session,                       // ����-�������� ������
                     menu_service,                              // ����-������
                     menu_missed_calls                          // ����-����������� ������
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
                   eCHAT,
                   eREPORT,
                   eSMS,
                   eService
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


  type  // ����� ������ ���������� �� ������� �� ����
  enumStatisticsCalls = (eNumbers,  // �����
                         eGraph);   // ������


  type  // ����� �� ���������������� � �� � ������ ������
  enumNeedReconnectBD = (eNeedReconnectYES,   // ��
                         eNeedReconnectNO);   // ���


  type   // ������ �������� SMS
  enumManualSMS = (sending_one,      // �������� �� 1 �����
                   sending_list);    // �������� �� ��������� �������


  type   // ������ ��� | ��
  enumStatus = (eNO   = 0,
                eYES  = 1);

  type  // ������ ������� ������� | ��������
  enumStatusJobClinic = ( eClose = 0,
                          eOpen  = 1);


  type // ���� ������� �������
  enumFontSize  = (eActiveSip,
                   eIvr,
                   eQueue);

  type  // ��� ��������� ������� ������
  enumFontChange = (eFontUP,
                    eFontDonw);


   type // ��� ��� ����������� ������� ������� ���������
   enumColorStatus = (color_Default,        // �� ����������
                      color_Good,           // ��������
                      color_NotBad,         // �������� �� 3��� �� 10���  | ��������� >= 3���
                      color_Bad,            // �������� �� 10��� �� 15���
                      color_Very_Bad,       // �������� >= 15���
                      color_Break);         // ���� ��� �������


   type // ��� ������� �������� ���
   enumReasonSmsMessage = (reason_Empty                               = -1, // ������
                           reason_OtmenaPriema                        = 0,  // ������ ������ �����, �������
                           reason_NapominanieOPrieme                  = 1,  // ����������� � ������
                           reason_NapominanieOPrieme_do15             = 2,  // ����������� � ������ (�� 15 ���)
                           reason_NapominanieOPrieme_OMS              = 3,  // ����������� � ������ (���)
                           reason_IstekaetSrokGotovnostiBIOMateriala  = 4,  // �������� ���� �������� ������������
                           reason_AnalizNaPereustanovke               = 5,  // ������ �� �������������
                           reason_UvelichilsyaSrokIssledovaniya       = 6,  // ���������� ���� ���������� ������������ ������������ �� ���. ��������
                           reason_Perezabor                           = 7,  // ��������� ��������� ����� (�����, �������, ������������ ������������)
                           reason_Critical                            = 8,  // �������� ������ �� ����������� � ����������� ���������
                           reason_ReadyDiagnostic                     = 9,  // ����� ��������� ����������� (��������,  �������, �����)
                           reason_ReadyNalog                          = 10, // ������ ������� � ���������
                           reason_ReadyDocuments                      = 11, // ������ ����� ���. ������������, �������, �������
                           reason_NeedDocumentsLVN                    = 12, // ���������� ������������ ������ ��� �������� ��� (�����)
                           reason_NeedDocumentsDMS                    = 13, // ���������������� � ������������ ����� �� ��� (����� �������)
                           reason_VneplanoviiPriem                    = 14, // ���������� ����������� ����� (���������� �����)
                           reason_ReturnMoney                         = 15, // ���������� �� ��������� ��
                           reason_ReturnMoneyInfo                     = 16, // ���������������� �� ������������� �������� ��
                           reason_ReturnDiagnostic                    = 17  // ���������� �� ��������������� (��������������) ����������
                          );
   type  // ������ ��������� � ����������� �� ���� ��������
   enumReasonSmsMessageTemplate = (
                           reasonTemplate_Empty                               = -1,
                           reasonTemplate_OtmenaPriema                        = 0,  // ������ ������ �����, �������
                           reasonTemplate_NapominanieOPrieme                  = 1,  // ����������� � ������
                           reasonTemplate_NapominanieOPrieme_do15             = 2,  // ����������� � ������ (�� 15 ���)
                           reasonTemplate_NapominanieOPrieme_OMS              = 3,  // ����������� � ������ (���)
                           reasonTemplate_IstekaetSrokGotovnostiBIOMateriala  = 4,  // �������� ���� �������� ������������
                           reasonTemplate_AnalizNaPereustanovke               = 5,  // ������ �� �������������
                           reasonTemplate_UvelichilsyaSrokIssledovaniya       = 6,  // ���������� ���� ���������� ������������ ������������ �� ���. ��������
                           reasonTemplate_Perezabor                           = 7,  // ��������� ��������� ����� (�����, �������, ������������ ������������)
                           reasonTemplate_Critical                            = 8,  // �������� ������ �� ����������� � ����������� ���������
                           reasonTemplate_ReadyDiagnostic                     = 9,  // ����� ��������� ����������� (��������,  �������, �����)
                           reasonTemplate_ReadyNalog                          = 10, // ������ ������� � ���������
                           reasonTemplate_ReadyDocuments                      = 11, // ������ ����� ���. ������������, �������, �������
                           reasonTemplate_NeedDocumentsLVN                    = 12, // ���������� ������������ ������ ��� �������� ��� (�����)
                           reasonTemplate_NeedDocumentsDMS                    = 13, // ���������������� � ������������ ����� �� ��� (����� �������)
                           reasonTemplate_VneplanoviiPriem                    = 14, // ���������� ����������� ����� (���������� �����)
                           reasonTemplate_ReturnMoney                         = 15, // ���������� �� ��������� ��
                           reasonTemplate_ReturnMoneyInfo                     = 16, // ���������������� �� ������������� �������� ��
                           reasonTemplate_ReturnDiagnostic                    = 17  // ���������� �� ��������������� (��������������) ����������
     );



    type  // ��������� ���������� ��������
    enumTreeSettings =(
                        tree_queue,            // ������������� �������
                        tree_firebird,         // ������ firebird
                        tree_sms,              // ��������� sms
                        tree_access            // ������������� ���� ����� �� ����
                      );

    type // ��������� ���� ������
     enumWorkingTime = ( workingtime_Monday,
                         workingtime_Tuesday,
                         workingtime_Wednesday,
                         workingtime_Thursday,
                         workingtime_Friday,
                         workingtime_Saturday,
                         workingtime_Sunday
                        );

   type   // ������� ������������ ������
   enumMissed  = ( eMissed,              // �����������
                   eMissed_no_return,    // ����������� �� �����������
                   eMissed_all           );


   type  // ������ ������
   enumOnlineStatus = ( eOffline = 0,  // ��������
                        eOnline  = 1); // ������


   type // ���� �������� ��� ��������� ������� (����������� ������, �������� ������)
   enumRemoteCommandAction = ( remoteCommandAction_activeSession,       // �������� ������
                               remoteCommandAction_missedCalls          // ����������� ������
   );

   type // ��� ����
   enumGender = (gender_male,        // �������
                 gender_female);     // �������

   type // ��� �� ����� ������� ��������� ������ ��� �������� ������ "����� �� ���������� ������� �����������"
   enumReportTableCountCallsOperator = (eTableQueue,
                                        eTableHistoryQueue);

   type // ��� �� ����� ������� ��������� ������ ��� �������� ������ "����� �� ���������� ������� �����������"
   enumReportTableCountCallsOperatorOnHold = (eTableOnHold,
                                              eTableHistoryOnHold);

   type // ��� ������� sip ������
   enumTrunkStatus = (eTrunkUnknown = -1,
                      eTrunkRegisterd = 0,
                      eTrunkRequest = 1);

  // =================== ��������������� ===================

  // Boolean -> string
 function BooleanToString(InValue:Boolean):string;

 function EnumLoggingToInteger(_logging:enumLogging):Integer;                      // ��������������� �� EnumLogging � Integer
 function IntegerToEnumLogging(_logging:Integer):enumLogging;                      // �������������� �� Integer � EnumLogging
 function EnumLoggingToString(_logging:enumLogging):string;                        // EnumLogging -> String
 function StringToEnumRole(InRole:string):enumRole;                                // String -> EnumRole
 function EnumRoleToString(InRole:enumRole):string;                                // EnumRole -> String
 function EnumRoleToStringName(InRole:enumRole):string;                            // EnumRole -> String(����������� ��������)
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
 function StatusOperatorToEnumLogging(_operatorStatus:Integer):enumLogging;          // �������������� �������� ������� ��������� �� int � EnumLogging
 function EnumLoggingToStatusOperator(_logging:enumLogging):enumStatusOperators;    // �������������� EnumLogging � ������� ������ ���������
 function SettingParamsStatusToInteger(_status:enumParamStatus):Integer;            // SettingParamsStatus --> Int
 function IntegerToSettingParamsStatus(_status:Integer):enumParamStatus;            // Int --> SettingParamsStatus
 function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;                // EnumTypeClinic -> String
 function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;                // String -> EnumTypeClinic
 function EnumQueueCurrentToString(_queue:enumQueueCurrent):string;                // EnumQueueCurrent - > String
 function EnumQueueCurrentToInteger(_queue:enumQueueCurrent):Integer;              // EnumQueueCurrent - > Integer
 function StringToEnumQueueCurrent(_queue:string):enumQueueCurrent;                // String -> EnumQueueCurrent
 function StringToSettingParamsStatus(status:string):enumParamStatus;             // String (��\���) --> SettingParamsStatus
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


 // =================== ��������������� ===================
 implementation


 // Boolean -> string
function BooleanToString(InValue:Boolean):string;
begin
  if InValue = True then Result:='True'
  else Result:='False';
end;


// ��������������� �� EnumLoggin � Integer
function EnumLoggingToInteger(_logging:enumLogging):Integer;
begin
  case _logging of
    eLog_unknown:             Result:=-1;       // ����������� ������
    eLog_enter:               Result:=0;        // ����
    eLog_exit:                Result:=1;        // �����
    eLog_auth_error:          Result:=2;        // �� �������� �����������
    eLog_exit_force:          Result:=3;        // ����� (����� ������� force_closed)
    eLog_add_queue_5000:      Result:=4;        // ���������� � ������� 5000
    eLog_add_queue_5050:      Result:=5;        // ���������� � ������� 5050
    eLog_add_queue_5000_5050: Result:=6;        // ���������� � ������� 5000 � 5050
    eLog_del_queue_5000:      Result:=7;        // �������� �� ������� 5000
    eLog_del_queue_5050:      Result:=8;        // �������� �� ������� 5050
    eLog_del_queue_5000_5050: Result:=9;        // �������� �� ������� 5000 � 5050
    eLog_available:           Result:=10;       // ��������
    eLog_home:                Result:=11;       // �����
    eLog_exodus:              Result:=12;       // �����
    eLog_break:               Result:=13;       // �������
    eLog_dinner:              Result:=14;       // ����
    eLog_postvyzov:           Result:=15;       // ���������
    eLog_studies:             Result:=16;       // �����
    eLog_IT:                  Result:=17;       // ��
    eLog_transfer:            Result:=18;       // ��������
    eLog_reserve:             Result:=19;       // ������
    eLog_callback:            Result:=20;       // callback
    eLog_create_new_user:     Result:=21;       // �������� ������ ������������
    eLog_edit_user:           Result:=22;       // �������������� ������������

  else  Result:=-1;
  end;
end;

// �������������� �� Integer � TLogging
function IntegerToEnumLogging(_logging:Integer):enumLogging;
begin
  case _logging of
   -1:    Result:=eLog_unknown;             // ����������� ������
    0:    Result:=eLog_enter;               // ����
    1:    Result:=eLog_exit;                // �����
    2:    Result:=eLog_auth_error;          // �� �������� �����������
    3:    Result:=eLog_exit_force;          // ����� (����� ������� force_closed)
    4:    Result:=eLog_add_queue_5000;      // ���������� � ������� 5000
    5:    Result:=eLog_add_queue_5050;      // ���������� � ������� 5050
    6:    Result:=eLog_add_queue_5000_5050; // ���������� � ������� 5000 � 5050
    7:    Result:=eLog_del_queue_5000;      // �������� �� ������� 5000
    8:    Result:=eLog_del_queue_5050;      // �������� �� ������� 5050
    9:    Result:=eLog_del_queue_5000_5050; // �������� �� ������� 5000 � 5050
    10:   Result:=eLog_available;           // ��������
    11:   Result:=eLog_home;                // �����
    12:   Result:=eLog_exodus;              // �����
    13:   Result:=eLog_break;               // �������
    14:   Result:=eLog_dinner;              // ����
    15:   Result:=eLog_postvyzov;           // ���������
    16:   Result:=eLog_studies;             // �����
    17:   Result:=eLog_IT;                  // ��
    18:   Result:=eLog_transfer;            // ��������
    19:   Result:=eLog_reserve;             // ������
    20:   Result:=eLog_callback;            // callback
    21:   Result:=eLog_create_new_user;     // �������� ������ ������������
    22:   Result:=eLog_edit_user;           // �������������� ������������
  else Result:=eLog_unknown;
  end;
end;


// EnumLogging -> String
function EnumLoggingToString(_logging:enumLogging):string;
begin
  case _logging of
    eLog_unknown:             Result:='����������� ������';
    eLog_enter:               Result:='����';
    eLog_exit:                Result:='�����';
    eLog_auth_error:          Result:='�� �������� �����������';
    eLog_exit_force:          Result:='����� (����� ������� force_closed)';
    eLog_add_queue_5000:      Result:='���������� � ������� 5000';
    eLog_add_queue_5050:      Result:='���������� � ������� 5050';
    eLog_add_queue_5000_5050: Result:='���������� � ������� 5000 � 5050';
    eLog_del_queue_5000:      Result:='�������� �� ������� 5000';
    eLog_del_queue_5050:      Result:='�������� �� ������� 5050';
    eLog_del_queue_5000_5050: Result:='�������� �� ������� 5000 � 5050';
    eLog_available:           Result:='��������';
    eLog_home:                Result:='�����';
    eLog_exodus:              Result:='�����';
    eLog_break:               Result:='�������';
    eLog_dinner:              Result:='����';
    eLog_postvyzov:           Result:='���������';
    eLog_studies:             Result:='�����';
    eLog_IT:                  Result:='��';
    eLog_transfer:            Result:='��������';
    eLog_reserve:             Result:='������';
    eLog_callback:            Result:='Callback';
    eLog_create_new_user:     Result:='�������� ������ ������������';
    eLog_edit_user:           Result:='�������������� ������������';
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
   role_administrator       :Result:='�������������';
   role_lead_operator       :Result:='������� ��������';
   role_senior_operator     :Result:='������� ��������';
   role_operator            :Result:='��������';
   role_operator_no_dash    :Result:='�������� (��� ��������)';
   role_supervisor_cov      :Result:='������������ ���';
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

// EnumRole -> String(����������� ��������)
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


// �������� ��� �� ����� TMenu
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

// enumAccessList -> String(name BD) �������� ��� � ��
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

// �������������� EnumAccessStatus --> Bool
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
    0:  Result:=eReserved0;       // ��������������� ��� ����� ������
    1:  Result:=eAvailable;       // ��������
    2:  Result:=eHome;            // �����
    3:  Result:=eExodus;          // �����
    4:  Result:=eBreak;           // �������
    5:  Result:=eDinner;          // ����
    6:  Result:=ePostvyzov;       // ���������
    7:  Result:=eStudies;         // �����
    8:  Result:=eIT;              // ��
    9:  Result:=eTransfer;        // ��������
   10:  Result:=eReserve;         // ������
   11:  Result:=eCallback;        // callback
 else Result:=eUnknown
 end;
end;

 // enumStatusOperators -> integer
function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;
begin
 case InStatus of
   eUnknown:    Result:= -1;      // unknown
   eReserved0:  Result:= 0;       // ������
   eAvailable:  Result:= 1;       // ��������
   eHome:       Result:= 2;       // �����
   eExodus:     Result:= 3;       // �����
   eBreak:      Result:= 4;       // �������
   eDinner:     Result:= 5;       // ����
   ePostvyzov:  Result:= 6;       // ���������
   eStudies:    Result:= 7;       // �����
   eIT:         Result:= 8;       // ��
   eTransfer:   Result:= 9;       // ��������
   eReserve:    Result:= 10;      // ������
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


// �������������� �������� ������� ��������� �� int � EnumLogging
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

// �������������� EnumLogging � ������� ������ ���������
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

// string (��\���) --> SettingParamsStatus
function StringToSettingParamsStatus(status:string):enumParamStatus;
var
 tmp:string;
begin
  tmp:=status;
  tmp:=AnsiLowerCase(status);

  if tmp='��' then Result:=paramStatus_ENABLED
  else if tmp='���' then Result:=paramStatus_DISABLED
  else Result:=paramStatus_DISABLED;
end;


// EnumTypeClinic -> String
function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;
begin
   case typeClinic of
     eMMC:            Result:='���';
     eCLD:            Result:='���';
     eLaboratory:     Result:='�����������';
     eOther:          Result:='������';
   end;
end;

// String -> EnumTypeClinic
function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;
var
 tmp:enumTypeClinic;
begin
   tmp:=eOther;

   if typeClinic = '���'          then tmp:=eMMC;
   if typeClinic = '���'          then tmp:=eCLD;
   if typeClinic = '�����������'  then tmp:=eLaboratory;
   if typeClinic = '������'       then tmp:=eOther;

   Result:=tmp;
end;

// EnumQueueCurrent - > String
function EnumQueueCurrentToString(_queue:enumQueueCurrent):string;
begin
   case _queue of
    queue_5000:       Result:='5000';
    queue_5050:       Result:='5050';
    queue_5000_5050:  Result:='5000 � 5050';
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
  if _queue = '5000 � 5050' then  Result:=queue_5000_5050;
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
    eNO:  Result:='���';
    eYES: Result:='��';
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
  if InStatus = '���'  then Result:=eNO;
  if InStatus = '��'   then Result:=eYES;
end;

// enumStatusJobClinic -> String
function EnumStatusJobClinicToString(InStatus:enumStatusJobClinic):string;
begin
   case InStatus of
    eClose: Result:='�������';
    eOpen:  Result:='��������';
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
  if InStatus = '�������'  then Result:=eClose;
  if InStatus = '��������' then Result:=eOpen;
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
    color_Default:    Result := clBlack;    // �� ���������
    color_Good:       Result := clGreen;    // ��������
    color_NotBad:     Result := clRed;      // �������� �� 3��� �� 10���  | ��������� >= 3���
    color_Bad:        Result := $0000008A;  // �������� �� 10��� �� 15���
    color_Very_Bad:   Result := clBlue;     // �������� >= 15���
    color_Break:      Result := $00DDB897;  // ���� ��� �������
  else
    Result := clBlack;
  end;
end;


// enumReasonSmsMessage -> String
function EnumReasonSmsMessageToString(_reasonSmsMessage:enumReasonSmsMessage):string;
begin
  case _reasonSmsMessage of
     reason_OtmenaPriema                        :Result:='������ ������ �����, �������';
     reason_NapominanieOPrieme                  :Result:='����������� � ������';
     reason_NapominanieOPrieme_do15             :Result:='����������� � ������ (�� 15 ���)';
     reason_NapominanieOPrieme_OMS              :Result:='����������� � ������ (���)';
     reason_IstekaetSrokGotovnostiBIOMateriala  :Result:='�������� ���� �������� ������������';
     reason_AnalizNaPereustanovke               :Result:='������ �� �������������';
     reason_UvelichilsyaSrokIssledovaniya       :Result:='���������� ���� ���������� ������������ ������������ �� ���. ��������';
     reason_Perezabor                           :Result:='��������� ��������� ����� (�����, �������, ������������ ������������)';
     reason_Critical                            :Result:='�������� ������ �� ����������� � ����������� ���������';
     reason_ReadyDiagnostic                     :Result:='����� ��������� ����������� (��������,  �������, �����)';
     reason_ReadyNalog                          :Result:='������ ������� � ���������';
     reason_ReadyDocuments                      :Result:='������ ����� ���. ������������, �������, �������';
     reason_NeedDocumentsLVN                    :Result:='���������� ������������ ������ ��� �������� ��� (�����)';
     reason_NeedDocumentsDMS                    :Result:='���������������� � ������������ ����� �� ��� (����� �������)';
     reason_VneplanoviiPriem                    :Result:='���������� ����������� �����';
     reason_ReturnMoney                         :Result:='���������� �� ��������� ��';
     reason_ReturnMoneyInfo                     :Result:='���������������� �� ������������� �������� ��';
     reason_ReturnDiagnostic                    :Result:='���������� �� ��������������� (��������������) ����������';
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
   reasonTemplate_OtmenaPriema                        : begin // ������ ������ �����, �������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('��������, ��� �� ��������� ��������� ���� ������ � �����. ');
    Result.Append('���������, ����������, � ���� ��� ������ �������� ������� ��������� ������� �� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_NapominanieOPrieme                  : begin  // ����������� � ������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, ');
    Result.Append('�� �������� � ������� %date% � %time% � ������� �� ������ %address%');
   end;
   reasonTemplate_NapominanieOPrieme_do15             : begin // ����������� � ������ (�� 15 ���)
    Result.Append('������������! %name% %otchestvo% %pol% � ������� %date% � %time% ');
    Result.Append('� ������� �� ������ %address%. ����� �������� � ����������� ��������� ������������� �������');
   end;
   reasonTemplate_NapominanieOPrieme_OMS              : begin // ����������� � ������ (���)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, ');
    Result.Append('�� �������� � ������� %date% � %time% � ������� �� ������ %address%. ');
    Result.Append('��� ���� ���������� ����� �������, ����� � ����� ���');
   end;
   reasonTemplate_IstekaetSrokGotovnostiBIOMateriala  : begin // �������� ���� �������� ������������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ��� ���� ������������� ������������ ������������. ');
    Result.Append('�� %date% %time% ���������, ����������, � ���� ��� ��������� ������� �� ������ +7(8442)220-220 ��� +7(8443)450-450. ');
    Result.Append('����� ���������� ������� �� ����������� ����������� ');
    Result.Append('� ��� ���������� ������������ ��� ���������� ����� ����� ����������� ��������');
   end;
   reasonTemplate_AnalizNaPereustanovke               : begin // ������ �� �������������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('���� ���������� ������������ �������� �������������, ������� ��������� � ���� ��� ��������� ������� ');
    Result.Append('�� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_UvelichilsyaSrokIssledovaniya       : begin // ���������� ���� ���������� ������������ ������������ �� ���. ��������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('�������� ���, ��� � ����� � ����������� ����� ������ ����������� ������������ ������������ ������������� ');
    Result.Append('�� %date%. �������� ��������� �� ������������ ����������');
   end;
   reasonTemplate_Perezabor                           : begin // ��������� ��������� ����� (�����, �������, ������������ ������������)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('�������� ���, ��� %labs% %study% �� %maybe% ���� %done% �� ������� "%prichina%". ');
    Result.Append('���������� ��� ��� ���������� ������������ � ������� �� ������ %address% ');
    Result.Append('��� ������ ��������� � ���� �� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_Critical                            : begin // �������� ������ �� ����������� � ����������� ���������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('�������� ���, ��� �� ����������� ������������ ������������ ��� ���������� ��� ����� ������� ���������� � ����� ');
    Result.Append('��� ��������� � ���� �� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_ReadyDiagnostic                     : begin // ����� ��������� ����������� (��������,  �������, �����)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, ��������� ����� �������������� ����������� �����. ');
    Result.Append('������� ���������� �� ������ � ���� ������ ������� (%time_clinic%) �� ������ %address%');
   end;
   reasonTemplate_ReadyNalog                          : begin // ������ ������� � ���������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, ���� ������� �� ������ ����������� ����� ��� ��������� ����������� ���������� ������ ������. ');
    Result.Append('������� �������� �� ������ � ���� ������ ������� (%time_clinic%) �� ������ %address%');
   end;
   reasonTemplate_ReadyDocuments                      : begin // ������ ����� ���. ������������, �������, �������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, ������������� ���� ����������� ������������ ������. ');
    Result.Append('������� �������� �� ������ � ���� ������ ������� (%time_clinic%) �� ������ %address%');
   end;
   reasonTemplate_NeedDocumentsLVN                    : begin // ���������� ������������ ������ ��� �������� ��� (�����)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('��������, ��� ��� �������� ����� ��������� ������������������ ��� ���������� ������������ ������ ������ ������. ');
    Result.Append('������ ��� ���������� � ������� �� ������ %address% ��� ��������� � ���� �� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_NeedDocumentsDMS                    : begin // ���������������� � ������������ ����� �� ��� (����� �������)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� ����������� �� ������� ������������ ����� � ������ ��������� ���. ');
    Result.Append('������ ��� ��������� � ���� �� ������ +7(8442)220-220 ��� +7(8443)450-450');
   end;
   reasonTemplate_VneplanoviiPriem                    : begin // ���������� ����������� ����� (���������� �����)
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('������ ������ ������� ��� ���������� ������� � %time% � ������� �� ������ %address%. ');
    Result.Append('������ ��������� � ���� �� ������ +7(8442)220-220 ��� +7(8443)450-450 ��� ������������� ��� ������ ������');
   end;
   reasonTemplate_ReturnMoney                         : begin // ���������� �� ��������� ��
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('��������, ��� ��� ���������� ������� �������� ������� �� %list_service% � ������� %money% ���. ');
    Result.Append('��� ������������� �������� �� ������ ���������� � ������� �� ������ %address%. ');
    Result.Append('��� ���� ���������� ����� ������� � ���������� �����, �� ������� �������������� ������');
   end;
   reasonTemplate_ReturnMoneyInfo                     : begin // ���������������� �� ������������� �������� ��
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('��������, ��� %date% ����������� ������� �������� ������� �� ��� ��������� ���� �� %list_service% ');
    Result.Append('� ������� %money% ���');
   end;
   reasonTemplate_ReturnDiagnostic                    : begin // ���������� �� ��������������� (��������������) ����������
    Result.Append('������������! %uvazaemii% %name% %otchestvo%, � ���������, �� �� ������ �� ��� �����������. ');
    Result.Append('��������, ��� �� ����������� �������� ��� ��������������� (��������������) ��������. ');
    Result.Append('������� ��� �� ������ � ���� ������ ������� (%time_clinic%) �� ������ %address%. ');
    Result.Append('��� ���� ���������� ����� �������');
   end;
  end;
end;


// enumTreeSettings -> String
function EnumTreeSettingsToString(_enumTreeSettings:enumTreeSettings):string;
begin
  case _enumTreeSettings of
    tree_queue:     Result:='������������� �������';
    tree_firebird:  Result:='������ firebird';
    tree_sms:       Result:='��������� SMS';
    tree_access:    Result:='����� ����� �� ����';
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
  if _gender = gender_male    then Result:='�������';
  if _gender = gender_female  then Result:='�������';
end;

// String -> EnumGender
function StringToEnumGender(_gender:string):enumGender;
begin
  if _gender = '�������'  then Result:=gender_male;
  if _gender = '�������'  then Result:=gender_female;
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
    workingtime_Monday:     Result:='��';
    workingtime_Tuesday:    Result:='��';
    workingtime_Wednesday:  Result:='��';
    workingtime_Thursday:   Result:='��';
    workingtime_Friday:     Result:='��';
    workingtime_Saturday:   Result:='���';
    workingtime_Sunday:     Result:='��';
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
