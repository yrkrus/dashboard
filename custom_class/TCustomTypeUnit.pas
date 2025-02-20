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
  SysUtils;

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
  enumShow_wait = ( open,
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
                   eCHAT,
                   eREPORT,
                   eSMS
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


 // =================== ��������������� ===================

  // Boolean -> string
 function BooleanToString(InValue:Boolean):string;

 function TLoggingToInteger(InTLogging:enumLogging):Integer;                       // ��������������� �� TLogging � Integer
 function IntegerToTLogging(InLogging:Integer):enumLogging;                        // �������������� �� Integer � TLogging
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
 function StatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;          // �������������� �������� ������� ��������� �� int � TLogging
 function SettingParamsStatusToInteger(status:enumParamStatus):Integer;            // SettingParamsStatus --> Int
 function IntegerToSettingParamsStatus(status:Integer):enumParamStatus;            // Int --> SettingParamsStatus
 function EnumTypeClinicToString(typeClinic:enumTypeClinic):string;                // EnumTypeClinic -> String
 function StringToEnumTypeClinic(typeClinic:string):enumTypeClinic;                // String -> EnumTypeClinic
 function StringToSettingParamsStatus(status:string):enumParamStatus;              // String (��\���) --> SettingParamsStatus
 function StrToBoolean(InValue:string):Boolean;                                    // string -> boolean

 // =================== ��������������� ===================
 implementation


 // Boolean -> string
function BooleanToString(InValue:Boolean):string;
begin
  if InValue = True then Result:='True'
  else Result:='False';
end;


// ��������������� �� TLogging � Integer
function TLoggingToInteger(InTLogging:enumLogging):Integer;
begin
  case InTLogging of
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
  end;
end;

// �������������� �� Integer � TLogging
function IntegerToTLogging(InLogging:Integer):enumLogging;
begin
  case InLogging of
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
  end;
end;


// string -> TRole
function StringToTRole(InRole:string):enumRole;
begin
  if InRole='�������������'             then Result:=role_administrator;
  if InRole='������� ��������'          then Result:=role_lead_operator;
  if InRole='������� ��������'          then Result:=role_senior_operator;
  if InRole='��������'                  then Result:=role_operator;
  if InRole='�������� (��� ��������)'   then Result:=role_operator_no_dash;
  if InRole='������������ ���'          then Result:=role_supervisor_cov;
end;


// TRole -> string
function TRoleToString(InRole:enumRole):string;
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


// �������������� TAccessStatus --> Bool
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
    0:  Result:=eReserved0;       // ������
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


// �������������� �������� ������� ��������� �� int � TLogging
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
begin
   if typeClinic = '���'          then Result:=eMMC;
   if typeClinic = '���'          then Result:=eCLD;
   if typeClinic = '�����������'  then Result:=eLaboratory;
   if typeClinic = '������'       then Result:=eOther;
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
