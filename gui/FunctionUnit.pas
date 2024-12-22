unit FunctionUnit;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, IniFiles, TlHelp32, IdBaseComponent, IdComponent,ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,WinSock,Math,IdHashCRC,Nb30,IdMessage,StrUtils,WinSvc,System.Win.ComObj, IdSMTP, IdText,
  IdSSL, IdSSLOpenSSL,IdAttachmentFile,DMUnit, FormHome, Data.Win.ADODB, Data.DB, IdIcmpClient,IdException, System.DateUtils,
  FIBDatabase, pFIBDatabase, TCustomTypeUnit,TUserUnit, Vcl.Menus, GlobalVariables,TActiveSIPUnit;




procedure KillProcess;                                                               // �������������� ���������� ������
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;    // ����������� ���� �� ���������
function GetStatistics_day(inStatDay:enumStatistiscDay):string;                         // ����������� ���� �� ����
procedure clearAllLists;                                                             // ������� ���� list's
procedure clearList_IVR;                                                             // ����������� ����� � �������� ��������
procedure clearList_QUEUE;                                                           // ������� listbox_QUEUE
procedure clearList_SIP(InWidth:Integer);                                            // ������� listbox_SIP
procedure clearList_Propushennie;                                                    // �������� ���������� �����������
procedure updatePropushennie;                                                        // ���������� ����������� ������� �����
procedure createThreadDashboard;                                                     // �������� �������
function getVersion(GUID:string; programm:enumProrgamm):string;                      // ����������� ������� ������
procedure showVersionAbout(programm:enumProrgamm);                                   // ����������� ������� ������
function Ping(InIp:string):Boolean;                                                  // �������� ping
procedure createCheckServersInfoclinika;                                             // �������� ������ � ���������
function StrToTRole(InRole:string):enumRole;                                         // string -> TRole
function TRoleToStr(InRole:enumRole):string;                                         // TRole -> string
function EnumProgrammToStr(InEnumProgram:enumProrgamm):string;                       // enumProgramm -> string
function GetRoleID(InRole:string):Integer;                                           // ��������� ID TRole
function getUserGroupSTR(InGroup:Integer):string;                                    // ����������� ���� ������������
function getHashPwd(inPwd: String):Integer;                                          // ����������� ������
function getUserGroupID(InGroup:string):Integer;                                     // ����������� ID ���� ������������
function getUserID(InLogin:string):Integer; overload;                                // ����������� ID ������������
function getUserID(InUserName,InUserFamiliya:string):Integer; overload;              // ��������� userID �� ���
function getUserID(InSIPNumber:integer):Integer; overload;                           // ��������� userID �� SIP ������
procedure loadPanel_Users(InUserRole:enumRole; InShowDisableUsers:Boolean = False);     // ��������� ����� �������������
procedure loadPanel_Operators;                                                       // ��������� ����� ������������� (���������)
function getCheckLogin(inLogin:string):Boolean;                                      // ���������� �� login �������������
function disableUser(InUserID:Integer):string;                                       // ���������� ������������
procedure deleteOperator(InUserID:Integer);                                          // �������� ������������ �� ������� operators
procedure LoadUsersAuthForm;                                                         // ��������� ������������� � ����� �����������
function getUserPwd(InUserID:Integer):Integer;                                       // ��������� userPwd �� userID
function getUserLogin(InUserID:Integer):string;                                      // ��������� userLogin �� userID
function getUserRoleSTR(InUserID:Integer):string;                                    // ����������� ���� ������������
function getIVRTimeQueue(InQueue:enumQueueCurrent):Integer;                             // ����� ������� ���������� �������� �� �������� ������ � �������
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;               // ���������t ����������� ������� � �������
function StrToTQueue(InQueueSTR:string):enumQueueCurrent;                               // ��������� �� string � TQueue
function getUserRePassword(InUserID:Integer):Boolean;                                // ���������� �� �������� ������ ��� �����
function updateUserPassword(InUserID,InUserNewPassword:Integer):string;              // ���������� ������ ������������
function TQueueToStr(InQueueSTR:enumQueueCurrent):string;                               // ��������� �� TQueue � string
function getLocalIP: string;                                                         // ������� ��������� ���������� IP
procedure createCurrentActiveSession(InUserID:Integer);                              // ��������� �������� ������
function isExistCurrentActiveSession(InUserID:Integer):Boolean;                      // ���������� �� ������� ������
procedure deleteActiveSession(InSessionID:Integer);                                  // �������� �������� ������
function getActiveSessionUser(InUserID:Integer):Integer;                             // ���������� ID �������� ������ ������������
function isExistSipActiveOperator(InSip:string):Boolean;                             // �������� ������� �� ��� ����� �������� ��� ����� sip ������� � �� �������
function getUserNameOperators(InSip:string):string;                                  // ��������� ����� ������������ �� ��� SIP ������
procedure accessRights(var p_TUser: TUser);                                          // ����� �������
function getCurrentUserNamePC:string;                                                // ��������� ����� ������������ ������������
function getComputerPCName: string;                                                  // ������� ��������� ����� ��
procedure updateCurrentActiveSession(InUserID:Integer);                              // ���������� ������� �������� ����� ������������
function getCurrentDateTimeWithTime:string;                                          // ������� ���� + �����
function getForceActiveSessionClosed(InUserID:Integer):Boolean;                      // �������� ����� �� ������� �������� ������
//function createServerConnect:TADOConnection;                                         // ��������� ����������� � �������
function getSelectResponse(InStroka:string):Integer;                                 // ������ �� ���������� ������
procedure LoggingRemote(InLoggingID:enumLogging);                                      // ����������� ��������
function TLoggingToInt(InTLogging:enumLogging):Integer;                                 // ��������������� �� TLogging � Integer
function IntToTLogging(InLogging:Integer):enumLogging;                                  // ��������������� �� Integer � TLogging
procedure showUserNameAuthForm;                                                      // ����������� ����� ���������� ������������ � ������ ��������� �������������
function getUserFamiliyaName_LastSuccessEnter(InUser_login_pc,
                                              InUser_pc:string):string;              // ���������� userID ����� ��������� ����� �� ��
procedure cloneRun;                                                                  // �������� �� 2�� ����� ��������
function getCountAnsweredCall(InSipOperator:string):Integer;                         // ���-�� ���������� ������� ����������
function getCountAnsweredCallAll:Integer;                                            // ���-�� ���������� ������� ���� ����������
function createListAnsweredCall(InSipOperator:string):TStringList;                   // ��������� ������ �� ���� ����������� ��������  sip ���������
function getTimeAnsweredToSeconds(InTimeAnswered:string):Integer;                    // ������� ������� ��������� ��������� ���� 00:00:00 � �������
function getTimeAnsweredSecondsToString(InSecondAnswered:Integer):string;            // ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
procedure remoteCommand_addQueue(command:enumLogging);                                  // ��������� ������� (���������� � �������)
procedure showWait(Status:enumShow_wait);                                               // �����������\������� ���� ������� �� ������
function remoteCommand_Responce(InStroka:string):string;                             // �������� ������� �� ���������� ��������� �������
function getUserSIP(InIDUser:integer):string;                                        // ����������� SIP ������������
function isExistRemoteCommand(command:enumLogging):Boolean;                             // �������� ���� �� ��� ����� ��������� ������� �� �������
function getStatus(InStatus:enumStatusOperators):string;                                  // ��������� ����� status ���������
function getCurrentQueueOperator(InSipNumber:string):enumQueueCurrent;                  // � ����� ������� ������ ��������� ��������
procedure clearOperatorStatus;                                                       // ������� �������� ������� ���������
procedure checkCurrentStatusOperator(InOperatorStatus:enumStatusOperators);                      // �������� � ����������� ������ �������� ���������
procedure showStatusOperator(InShow:Boolean = True);                                 // ����������� ������ ������� ����������
function getLastStatusTime(InUserid:Integer; InOperatorStatus:enumStatusOperators):string;                // ������� ������� � ������� ������� ���������
function getStatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;             // �������������� �������� ������� ��������� �� int � TLogging
function isOperatorGoHome(inUserID:Integer):Boolean;                                 // �������� �������� ���� ����� ��� ���
function getIsExitOperatorCurrentQueue(InCurrentRole:enumRole;InUserID:Integer):Boolean;// �������� ����� �������� ����� ����� �� �����
function getLastStatusTimeOnHold(InStartTimeonHold:string):string;                   // ������� ������� � ������� OnHold
function getTranslate(Stroka: string):string;                                        // �������������� �� ��� - > ��������
//function getUserFIO(InUserID:Integer):string;                                        // ��������� ����� ������������ �� ��� UserID
function getUserFamiliya(InUserID:Integer):string;                                   // ��������� ������� ������������ �� ��� UserID
function getUserNameBD(InUserID:Integer):string;                                     // ��������� ����� ������������ �� ��� UserID
function UserIsOperator(InUserID:Integer):Boolean;                                  // �������� userID ����������� ��������� ��� ��� TRUE - ��������
procedure disableOperator(InUserId:Integer);                                         // ���������� ��������� � ������� ��� � ������� operators_disable
function getDateTimeToDateBD(InDateTime:string):string;                              // ������� ���� � ������� � ������������ ��� ��� BD
function enableUser(InUserID:Integer):string;                                        // ��������� ������������
function getOperatorAccessDashboard(InSip:string):Boolean;                           // ���������� ������� �������� �� ������ ��������� ��� ���
function isExistSettingUsers(InUserID:Integer):Boolean;                              // �������� ��������.� �� �������������� ��������� ������������ true - ���������� ��������
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers;
                                    status:enumSettingUsersStatus);                     // ���������� ������������� �������� ������������
function SettingUsersStatusToInt(status:enumSettingUsersStatus):Integer;                // ����������� �� TSettingUsersStatus --> Int
function getStatusIndividualSettingsUser(InUserID:Integer;
                                        settings:enumSettingUsers):enumSettingUsersStatus; // ��������� ������ �� �������������� ���������� ������������
procedure LoadIndividualSettingUser(InUserId:Integer);                               // ��������� �������������� �������� ������������
function getIsExitOperatorCurrentGoHome(InCurrentRole:enumRole;InUserID:Integer):Boolean; // �������� ����� �������� �� ��������� �������, ����� �������� ����� ������� "�����"
function getLastStatusOperator(InUserId:Integer):enumLogging;                           // ������� ����� ��������� �� ������� logging
procedure CheckCurrentVersion;                                                       // �������� �� ���������� ������
function getCheckIP(InIPAdtress:string):Boolean;                                     // �������� ������������ IP ������
procedure createFormActiveSession;                                                   // �������� ���� �������� ������
function getCheckAlias(InAlias:string):Boolean;                                      // �������� �� �������������� ������ ������ ���, �� ����� ���� ������ ����!
function GetFirbirdAuth(FBType:enumFirebirdAuth):string;                                // ��������� ��������������� ������ ��� ���������� � �� firebird
function GetStatusMonitoring(status:Integer):enumMonitoringTrunk;                       // ����������� �� �����
function GetCountServersIK:Integer;                                                  // ��������� ���-�� �������� ��
procedure SetAccessMenu(InNameMenu:enumAccessList; InStatus: enumAccessStatus);            // ��������� ����������\������ �� ������ � ����
function TAccessListToStr(AccessList:enumAccessList):string;                            // TAccessListToStr -> string
function TAccessStatusToBool(Status: enumAccessStatus): Boolean;                        // TAccessStatus --> Bool
function GetOnlyOperatorsRoleID:TStringList;                                         // ��������� ������ ������������ ID ����
procedure ShowOperatorsStatus;                                                       // ����������� ����������� ���� �� ��������� ���������
procedure ResizeCentrePanelStatusOperators(WidthMainWindow:Integer);                 // ��������� ������� ������ ������� ���������� � ����������� �� ������� �������� ����
procedure VisibleIconOperatorsGoHome(InStatus:enumHideShowGoHomeOperators;
                                     InClick:Boolean = False);                       // ����������\�������� ���������� ������� �����
procedure HappyNewYear;                                                              // �������� � ����� �����
function GetExistAccessToLocalChat(InUserId:Integer):Boolean;                        //���� �� ������ � ���������� ����
procedure OpenLocalChat;                                                             // �������� exe ���������� ����
function EnumChannelChatIDToString(InChatID:enumChatID):string;                // enumChatID -> string
function EnumChannelToString(InChannel:enumChannel):string;                 //enumChannel -> string
function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;     // enumActiveBrowser -> string
function GetExistActiveSession(InUserID:Integer; var ActiveSession:string):Boolean;  // ���� �� �������� ������ ���
function GetStatusUpdateService:Boolean;                                           // �������� �������� �� ������ ����������
function IntegerToEnumStatusOperators(InStatusId:Integer):enumStatusOperators;     // Integer -> enumStatusOperators
function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;        // enumStatusOperators -> integer
function getStatusOperator(InUserId:Integer):enumStatusOperators;                  // ������� ����� ��������� �� ������� operators



implementation

uses
  FormPropushennieUnit, Thread_StatisticsUnit, Thread_IVRUnit, Thread_QUEUEUnit, Thread_ACTIVESIPUnit,
  FormAboutUnit, FormServerIKCheckUnit, Thread_CHECKSERVERSUnit, FormSettingsUnit, FormAuthUnit,
  FormErrorUnit, FormWaitUnit, Thread_AnsweredQueueUnit, FormUsersUnit, TTranslirtUnit,
  Thread_ACTIVESIP_updatetalkUnit, Thread_ACTIVESIP_updatePhoneTalkUnit, Thread_ACTIVESIP_countTalkUnit,
  Thread_ACTIVESIP_QueueUnit, FormActiveSessionUnit, TIVRUnit, FormOperatorStatusUnit, TXmlUnit, TOnlineChat, Thread_ChatUnit;



// ��������� ����������� � �������
{function createServerConnect:TADOConnection;
begin
  Result:=TADOConnection.Create(nil);

  with Result do begin
    DefaultDatabase:=GetServerAddress;
    Provider:='MSDASQL.1';
    ConnectionString:='Provider='+Provider+
                      ';Password='+GetServerPassword+
                      ';Persist Security Info=True;User ID='+GetServerUser+
                      ';Extended Properties="Driver=MySQL ODBC 5.3 Unicode Driver;SERVER='+GetServerAddress+
                      ';UID='+GetServerUser+
                      ';PWD='+GetServerPassword+
                      ';DATABASE='+DefaultDatabase+
                      ';PORT=3306;COLUMN_SIZE_S32=1";Initial Catalog='+DefaultDatabase;

    LoginPrompt:=False;  // ��� ������� �� ����� �����\�����

   try
     Connected:=True;
     Open;
     CONNECT_BD_ERROR:=False;
     if FormError.Showing then FormError.Close;

   except on E:Exception do
      begin
       Connected:=False;
       CONNECT_BD_ERROR:=True;

       with FormError do begin
         lblErrorInfo.Caption:='�������� ������ ��� ����������� � �������...'+#13#13+DateTimeToStr(Now)+' '+ e.ClassName+#13+e.Message;

         if not FormError.Showing then ShowModal;
       end;

      end;
   end;
  end;
end; }





// ��������������� �� TLogging � Integer
function TLoggingToInt(InTLogging:enumLogging):Integer;
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
function IntToTLogging(InLogging:Integer):enumLogging;
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


// �������������� �������� ������� ��������� �� int � TLogging
function getStatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;
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

 // ����������� ��������
procedure LoggingRemote(InLoggingID:enumLogging);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;

        SQL.Add('insert into logging (ip,user_id,user_login_pc,pc,action) values ('+#39+SharedCurrentUserLogon.GetIP+#39+','
                                                                                   +#39+IntToStr(SharedCurrentUserLogon.GetID)+#39+','
                                                                                   +#39+SharedCurrentUserLogon.GetUserLoginPC+#39+','
                                                                                   +#39+SharedCurrentUserLogon.GetPC+#39+','
                                                                                   +#39+IntToStr(TLoggingToInt(InLoggingID))+#39+')');

        try
            ExecSQL;
        except
            on E:EIdException do begin
               FreeAndNil(ado);
               serverConnect.Close;
               FreeAndNil(serverConnect);

               Exit;
            end;
        end;
     end;
   finally
    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
   end;
end;

// ����������� ������
function getHashPwd(inPwd: String):Integer;
var
  i, j: Integer;
begin
  Result:= 0;
  for i := 1 to Length(inPwd) do
  begin
    j := Ord(inPwd[i]);
    Result:= (Result shl 5) - Result + j;
  end;
  Result:= abs(Result);
end;



// ������� ��������� ���������� IP
function getLocalIP: string;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result:='127.0.0.1';

  if WSAStartup(WSVer, wsaData) = 0 then
   begin
    if GetHostName(@Buf, 128) = 0 then
     begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^)
      else Result:=PChar('127.0.0.1');
     end;
    WSACleanup;
   end;
end;


// ������� ��������� ����� ��
function getComputerPCName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then Result := buffer
  else Result := 'null';
end;

// string -> TRole
function StrToTRole(InRole:string):enumRole;
begin
  if InRole='�������������'             then Result:=role_administrator;
  if InRole='������� ��������'          then Result:=role_lead_operator;
  if InRole='������� ��������'          then Result:=role_senior_operator;
  if InRole='��������'                  then Result:=role_operator;
  if InRole='�������� (��� ��������)'   then Result:=role_operator_no_dash;
  if InRole='������������ ���'          then Result:=role_supervisor_cov;
end;


// TRole -> string
function TRoleToStr(InRole:enumRole):string;
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
function EnumProgrammToStr(InEnumProgram:enumProrgamm):string;
begin
  case InEnumProgram of
   eGUI     :Result:='gui';
   eCHAT    :Result:='chat';
  end;
end;

// ��������� ID TRole
function GetRoleID(InRole:string):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select id from role where name_role = '+#39+InRole+#39);

    Active:=True;
    Result:=StrToInt(VarToStr(Fields[0].Value));
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;

// �������� �������
procedure createThreadDashboard;
begin
  with HomeForm do begin
     // ���������
    if Statistics_thread=nil then
    begin
     FreeAndNil(Statistics_thread);
     Statistics_thread:=Thread_Statistics.Create(True);
     Statistics_thread.Priority:=tpNormal;
     UpdateStatistiscSTOP:=True;
    end
    else UpdateStatistiscSTOP:=True;

    // IVR
    if IVR_thread=nil then
    begin
     FreeAndNil(IVR_thread);
     IVR_thread:=Thread_IVR.Create(True);
     IVR_thread.Priority:=tpNormal;
     UpdateIVRSTOP:=True;
    end
    else UpdateIVRSTOP:=True;

    // QUEUE
    if QUEUE_thread=nil then
    begin
     FreeAndNil(QUEUE_thread);
     QUEUE_thread:=Thread_QUEUE.Create(True);
     QUEUE_thread.Priority:=tpNormal;
     UpdateQUEUESTOP:=True;
    end
    else UpdateQUEUESTOP:=True;

    // ACTIVESIP + �������� ������
    begin
      // ACTIVESIP
      if ACTIVESIP_thread=nil then
      begin
       FreeAndNil(ACTIVESIP_thread);
       ACTIVESIP_thread:=Thread_ACTIVESIP.Create(True);
       ACTIVESIP_thread.Priority:=tpNormal;
       UpdateACTIVESIPSTOP:=True;
      end
      else UpdateACTIVESIPSTOP:=True;
      ///////////////////////////////////////////
      // ACTIVESIP_Queue
      if ACTIVESIP_Queue_thread=nil then
      begin
       FreeAndNil(ACTIVESIP_Queue_thread);
       ACTIVESIP_Queue_thread:=Thread_ACTIVESIP_Queue.Create(True);
       ACTIVESIP_Queue_thread.Priority:=tpNormal;
       UpdateACTIVESIPQueue:=True;
      end
      else UpdateACTIVESIPQueue:=True;
      ///////////////////////////////////////////
      // ACTIVESIP_updateTalkTime
      if ACTIVESIP_updateTalk_thread=nil then
      begin
       FreeAndNil(ACTIVESIP_updateTalk_thread);
       ACTIVESIP_updateTalk_thread:=Thread_ACTIVESIP_updateTalk.Create(True);
       ACTIVESIP_updateTalk_thread.Priority:=tpNormal;
       UpdateACTIVESIPtalkTime:=True;
      end
      else UpdateACTIVESIPtalkTime:=True;
      ///////////////////////////////////////////
      // ACTIVESIP_updateTalkPhone
      if ACTIVESIP_updateTalkPhone_thread=nil then
      begin
       FreeAndNil(ACTIVESIP_updateTalkPhone_thread);
       ACTIVESIP_updateTalkPhone_thread:=Thread_ACTIVESIP_updatePhoneTalk.Create(True);
       ACTIVESIP_updateTalkPhone_thread.Priority:=tpNormal;
       UpdateACTIVESIPtalkTimePhone:=True;
      end
      else UpdateACTIVESIPtalkTimePhone:=True;
       ///////////////////////////////////////////
      // ACTIVESIP_countTalk
      if ACTIVESIP_countTalk_thread=nil then
      begin
       FreeAndNil(ACTIVESIP_countTalk_thread);
       ACTIVESIP_countTalk_thread:=Thread_ACTIVESIP_countTalk.Create(True);
       ACTIVESIP_countTalk_thread.Priority:=tpNormal;
       UpdateACTIVESIPcountTalk:=True;
      end
      else UpdateACTIVESIPcountTalk:=True;

    end;


    // �HECKSERVERS
    if CHECKSERVERS_thread=nil then
    begin
     FreeAndNil(CHECKSERVERS_thread);
     CHECKSERVERS_thread:=Thread_CHECKSERVERS.Create(True);
     CHECKSERVERS_thread.Priority:=tpNormal;
     UpdateCHECKSERVERSSTOP:=True;
    end
    else UpdateCHECKSERVERSSTOP:=True;

    // AnsweredQueue
    if ANSWEREDQUEUE_thread=nil then
    begin
     FreeAndNil(ANSWEREDQUEUE_thread);
     ANSWEREDQUEUE_thread:=Thread_AnsweredQueue.Create(True);
     ANSWEREDQUEUE_thread.Priority:=tpNormal;
     UpdateAnsweredStop:=True;
    end
    else UpdateAnsweredStop:=True;

    // OnlineChat
     if ONLINECHAT_thread=nil then
    begin
     FreeAndNil(ONLINECHAT_thread);
     ONLINECHAT_thread:=Thread_Chat.Create(True);
     ONLINECHAT_thread.Priority:=tpNormal;
     UpdateOnlineChatStop:=True;
    end
    else UpdateOnlineChatStop:=True;


    // ������ �������
    Statistics_thread.Resume;
    IVR_thread.Resume;
    QUEUE_thread.Resume;
    ACTIVESIP_thread.Resume;
    ACTIVESIP_Queue_thread.Resume;
    ACTIVESIP_countTalk_thread.Resume;
    ACTIVESIP_updateTalk_thread.Resume;
    ACTIVESIP_updateTalkPhone_thread.Resume;
    CHECKSERVERS_thread.Resume;
    ANSWEREDQUEUE_thread.Resume;
    if SharedCurrentUserLogon.GetIsAccessLocalChat then ONLINECHAT_thread.Resume;
  end;


end;


 //�������������� ���������� ������
procedure KillProcess;
var
 countKillExe:Integer;
begin
   try
     if not CONNECT_BD_ERROR then begin

       // ����������� (�����)  , ����� ������� ��� ������
       if getForceActiveSessionClosed(SharedCurrentUserLogon.GetID) then LoggingRemote(eLog_exit_force)
       else
       begin
        // �������� �� ����� ������ ������ ������
        if SharedCurrentUserLogon.GetID<>0 then LoggingRemote(eLog_exit);
       end;

       // ������� �������� ������� ���������
       clearOperatorStatus;

       // �������� �������� ������
       deleteActiveSession(getActiveSessionUser(SharedCurrentUserLogon.GetID));
     end;

     // ��������� chat_exe ���� ������
     countKillExe:=0;
     while GetTask(PChar(CHAT_EXE)) do begin
       KillTask(PChar(CHAT_EXE));

       // �� ������ ���� �� �������� ������� �������� exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;

   finally
      //DM.ADOConnectServer.Close;
      TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
   end;
end;



// ������� ���� + �����
function getCurrentDateTimeWithTime:string;
var
 tmpdate:string;
 tmp_year,tmp_month,tmp_day:string;
 times:TTime;
begin
  tmpdate:=DateToStr(Now);

  tmp_year:=tmpdate;
  System.Delete(tmp_year,1,6);

  tmp_month:=tmpdate;
  System.Delete(tmp_month,1,3);
  System.Delete(tmp_month,3,Length(tmp_month));

  tmp_day:=tmpdate;
  System.Delete(tmp_day,3,Length(tmp_day));

  times:=Now;

  Result:=tmp_year+'-'+tmp_month+'-'+tmp_day+' '+TimeToStr(times);
end;

// ��������� ����� ������������ ������������
function getCurrentUserNamePC:string;
 const
   cnMaxUserNameLen = 254;
 var
   sUserName: string;
   dwUserNameLen: DWORD;
begin
   dwUserNameLen := cnMaxUserNameLen - 1;
   SetLength(sUserName, cnMaxUserNameLen);
   GetUserName(PChar(sUserName), dwUserNameLen);
   SetLength(sUserName, dwUserNameLen);
   Result:= PChar(sUserName);
end;


// ������ �� ���������� ������
function getSelectResponse(InStroka:string):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add(InStroka);
    Active:=True;
    if Fields[0].Value<>null then begin
     if Fields[0].Value<=0 then Result:=0
     else Result:=StrToInt(Fields[0].Value);
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ����������� ���� �� ���������
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;
var
 select_response:string;
 s:TStringList;
begin
  case InQueueType of

    answered: begin    // ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
    no_answered: begin  // �� ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and fail = ''1'' and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
    no_answered_return: begin  // �� ���������� + �����������
     {select_response:='select ((select count(phone) from queue where number_queue ='+#39+IntToStr(InQueueNumber)+#39
                                                                                    +' and fail = ''1'' and date_time >'+#39
                                                                                    +GetCurrentStartDateTime+#39+') - (select count(distinct(phone)) from queue where number_queue ='+#39
                                                                                    +IntToStr(InQueueNumber)+#39+' and answered =''1'' and date_time >'+#39
                                                                                    +GetCurrentStartDateTime+#39+' and phone in (select distinct(phone) from queue where number_queue = '+#39
                                                                                    +IntToStr(InQueueNumber)+#39+' and fail = ''1'' and date_time > '+#39
                                                                                    +GetCurrentStartDateTime+#39+'))) as temp'; }

      select_response:='select count(distinct(phone)) from queue where number_queue='+#39+TQueueToStr(InQueueNumber)+#39+
                                                                ' and fail =''1'' and date_time >'+#39+GetCurrentStartDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue ='+#39+TQueueToStr(InQueueNumber)+#39+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetCurrentStartDateTime+#39+')';


    end;
    all_answered:begin  // ����� ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
  end;



  Result:=IntToStr(getSelectResponse(select_response));
end;


// ����������� ���� �� ����
function GetStatistics_day(inStatDay:enumStatistiscDay):string;
var
resultat:string;
select_response:string;
answered:Integer;
procent:Double;
no_answered:string;

all_queue:string;

begin
  resultat:='null';
  all_queue:=#39+TQueueToStr(queue_5000)+#39+','+#39+TQueueToStr(queue_5050)+#39;

 with HomeForm do begin
    case inStatDay of
      stat_answered:begin
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetCurrentStartDateTime+#39;
       resultat:=IntToStr(getSelectResponse(select_response));
      end;
      stat_no_answered:begin
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and fail = ''1'' and date_time > '+#39+GetCurrentStartDateTime+#39;
       resultat:=IntToStr(getSelectResponse(select_response));
      end;
      stat_no_answered_return:begin
       select_response:='select count(distinct(phone)) from queue where number_queue in ('+all_queue+')'+
                                                                ' and fail =''1'' and date_time >'+#39+GetCurrentStartDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue in ('+all_queue+')'+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetCurrentStartDateTime+#39+')';


       resultat:=IntToStr(getSelectResponse(select_response));
      end;
      stat_procent_no_answered:begin
        if lblStstistisc_Day_No_Answered.Caption='0'  then resultat:='0'
        else begin
           // �����������
          answered:=StrToInt(lblStstistisc_Day_Answered.Caption);
          if answered = 0 then begin
           Result:='0';
           Exit;
          end;

          no_answered:=lblStstistisc_Day_No_Answered.Caption;
          System.Delete(no_answered,AnsiPos(' (',no_answered),Length(no_answered));

          procent:=StrToInt(no_answered) * 100 / answered;
          resultat:=FormatFloat('0.0',procent);

          resultat:=StringReplace(resultat,',','.',[rfReplaceAll]);
        end;
      end;
      stat_procent_no_answered_return:begin
        if lblStstistisc_Day_No_Answered.Caption='0'  then resultat:='0'
        else begin
           // �����������
          answered:=StrToInt(lblStstistisc_Day_Answered.Caption);
          if answered = 0 then begin
           Result:='0';
           Exit;
          end;

          no_answered:=lblStstistisc_Day_No_Answered.Caption;
          System.Delete(no_answered,1,AnsiPos('(',no_answered));
          System.Delete(no_answered,AnsiPos(')',no_answered),Length(no_answered));

          procent:=StrToInt(no_answered) * 100 / answered;
          resultat:=FormatFloat('0.0',procent);

          resultat:=StringReplace(resultat,',','.',[rfReplaceAll]);
        end;
      end;
      stat_summa:begin
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and date_time > '+#39+GetCurrentStartDateTime+#39;
       resultat:=IntToStr(getSelectResponse(select_response));
      end;
    end;
 end;

  Result:=resultat;
end;

// ������� ���� list's
procedure clearAllLists;
begin
  clearList_IVR;
  clearList_QUEUE;
  clearList_SIP(HomeForm.Panel_SIP.Width);
end;

// ������� listbox_IVR
procedure clearList_IVR;
 const
 cWidth_default         :Word = 335;
 cProcentWidth_phone    :Word = 40;
 cProcentWidth_waiting  :Word = 30;
 cProcentWidth_trunk    :Word = 30;

begin
 with HomeForm do begin

   lblCount_IVR.Caption:='IVR';

   with ListViewIVR do begin
     ViewStyle:= vsReport;


      with ListViewIVR.Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with ListViewIVR.Columns.Add do
      begin
        Caption:='����� ��������';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewIVR.Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with ListViewIVR.Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((cWidth_default*cProcentWidth_trunk)/100);
        Alignment:=taCenter;
      end;
   end;
 end;
end;


// ������� listbox_SIP
procedure clearList_SIP(InWidth:Integer);
 const
 //cWidth_default           :Word = 1017;
 cProcentWidth_operator   :Word = 29;
 cProcentWidth_status     :Word = 15;
 cProcentWidth_responce   :Word = 7;
 cProcentWidth_phone      :Word = 12;
 cProcentWidth_talk       :Word = 12;
 cProcentWidth_queue      :Word = 11;
 cProcentWidth_time       :Word = 14;
begin
 with HomeForm do begin
   Panel_SIP.Width:=InWidth;
   STlist_ACTIVESIP_NO_Rings.Width:=InWidth;  // ������� ��� ��� �������

   ListViewSIP.Columns.Clear;

   lblCount_ACTIVESIP.Caption:='�������� ������ | ��������� ���������';

   with ListViewSIP do begin
     ViewStyle:= vsReport;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((InWidth*cProcentWidth_operator)/100);
        Alignment:=taLeftJustify;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='������';
        Width:=Round((InWidth*cProcentWidth_status)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((InWidth*cProcentWidth_responce)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='����� ��������';
        Width:=Round((InWidth*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='����� ���������';
        Width:=Round((InWidth*cProcentWidth_talk)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='�������';
        Width:=Round((InWidth*cProcentWidth_queue)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='����. ����� | �����';
        Width:=Round((InWidth*cProcentWidth_time)/100);
        Alignment:=taCenter;
      end;
   end;
 end;
end;

// ������� listbox_QUEUE
procedure clearList_QUEUE;
 const
 cWidth_default         :Word = 335;
 cProcentWidth_phone    :Word = 40;
 cProcentWidth_waiting  :Word = 30;
 cProcentWidth_queue    :Word = 30;
begin
 with HomeForm do begin

   lblCount_QUEUE.Caption:='�������';

   with ListViewQueue do begin
     ViewStyle:= vsReport;

       with ListViewQueue.Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='����� ��������';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='�������';
        Width:=Round((cWidth_default*cProcentWidth_queue)/100);
        Alignment:=taCenter;
      end;
   end;

 end;
end;


// ��������� �� string � TQueue
function StrToTQueue(InQueueSTR:string):enumQueueCurrent;
begin
  if InQueueSTR = '5000' then Result:=queue_5000;
  if InQueueSTR = '5050' then Result:=queue_5050;
end;


// ��������� �� TQueue � string
function TQueueToStr(InQueueSTR:enumQueueCurrent):string;
begin
  case InQueueSTR of
    queue_5000: Result:='5000';
    queue_5050: Result:='5050';
  end;
end;

// ���������� ����������� ������� � �������
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;
var
 correctTime,delta_time:Integer;
begin
  // ������ ��������� ����� ��� ������ �������
  delta_time:=getIVRTimeQueue(InQueue);
  // ��������� ����� � �������
  correctTime:=getTimeAnsweredToSeconds(InTime)-delta_time;

  Result:=getTimeAnsweredSecondsToString(correctTime);
end;


// ������� ������� ��������� ��������� ���� �� ������ � 00:00:00
function getTimeAnsweredSecondsToString(InSecondAnswered:Integer):string;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
 ss, mm, hh: word;
 hour,min,sec:string;
begin

  hh := (InSecondAnswered mod SecPerDay) div SecPerHour;
  mm := ((InSecondAnswered mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((InSecondAnswered mod SecPerDay) mod SecPerHour) mod SecPerMinute;


  if hh<=9 then hour:='0'+IntToStr(hh)
  else hour:=IntToStr(hh);
  if mm<=9 then min:='0'+IntToStr(mm)
  else min:=IntToStr(mm);
  if ss<=9 then sec:='0'+IntToStr(ss)
  else sec:=IntToStr(ss);

  Result:=hour+':'+min+':'+sec;
end;


// ������� ������� ��������� ��������� ���� 00:00:00 � �������
function getTimeAnsweredToSeconds(InTimeAnswered:string):Integer;
 const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
 var
 tmp_time:TTime;
 curr_time:Integer;
begin
  tmp_time:=StrToDateTime(InTimeAnswered);
  curr_time:=HourOf(tmp_time) * 3600 + MinuteOf(tmp_time) * 60 + SecondOf(tmp_time);

  Result:=curr_time;
end;


// ���-�� ���������� ������� ����������
 function getCountAnsweredCall(InSipOperator:string):Integer;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
begin
    ado:=TADOQuery.Create(nil);
    serverConnect:=createServerConnect;
    if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(phone) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip = '+#39+InSipOperator+#39+' and answered = ''1'' and fail = ''0'' and hash is not null' );
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:=0;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ���-�� ���������� ������� ���� ����������
 function getCountAnsweredCallAll:Integer;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
begin
    ado:=TADOQuery.Create(nil);
    serverConnect:=createServerConnect;
    if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(phone) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and answered = ''1'' and fail = ''0'' and hash is not null' );
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:=0;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ��������� ������ �� ���� ����������� ��������  sip ���������
function createListAnsweredCall(InSipOperator:string):TStringList;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  countTalk:Integer;
  i:Integer;
begin
   Result:=TStringList.Create;
   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    // ���-�� �������
    countTalk:=getCountAnsweredCall(InSipOperator);

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select talk_time from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip = '+#39+InSipOperator+#39+' and answered = ''1'' and fail = ''0''and hash is not null' );
    Active:=True;

    for i:=0 to countTalk-1 do begin
     Result.Add(Fields[0].Value);
     Next;
    end;
  end;


  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;

// �������� ���������� �����������
procedure clearList_Propushennie;
begin
 with FormPropushennie do begin

   listSG_Propushennie.RowCount:=1;

   listSG_Propushennie.Cells[0,0]:='����\����� ������';
   listSG_Propushennie.Cells[1,0]:='����� ��������';
   listSG_Propushennie.Cells[2,0]:='�������';
   listSG_Propushennie.Cells[3,0]:='�������';

 end;
end;

// ���������� ����������� ������� �����
procedure updatePropushennie;
var
 listCount:Integer;
 i:Integer;
 list_queue:string;
 serverConnect:TADOConnection;
begin
  listCount:=0;

  // ����������� ������ ������� 5000 � 5050
  list_queue:=#39+TQueueToStr(queue_5000)+#39+','+#39+TQueueToStr(queue_5050)+#39;


   with DM.ADOQuerySelect_Propushennie do begin
      SQL.Clear;
      SQL.Add('select count(phone) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+ ' and fail = 1 and hash is null and number_queue IN ('+list_queue+')  order by date_time DESC');
      Active:=True;
      if Fields[0].Value<>null then listCount:=Fields[0].Value;
   end;
   if listCount>=1 then begin

     with DM.ADOQuerySelect_Propushennie do begin
        SQL.Clear;
        SQL.Add('select date_time,waiting_time,phone,number_queue from queue where date_time > '+#39+GetCurrentStartDateTime+#39+ ' and fail = 1 and hash is null and number_queue IN ('+list_queue+') order by date_time DESC');
        Active:=True;

        FormPropushennie.listSG_Propushennie.RowCount:=listCount+1;

        for i:=0 to listCount-1 do begin
          try
            if (Fields[0].Value = null) or (Fields[1].Value = null) or (Fields[2].Value = null) or (Fields[3].Value = null) then
            begin
             Next;
             Break;
            end;


             with FormPropushennie.listSG_Propushennie do begin
              Cells[0,i+1]:=Fields[0].Value;

              // ��������� ����� ��������
              Cells[1,i+1]:=correctTimeQueue(StrToTQueue(Fields[3].Value),Fields[1].Value);

              Cells[2,i+1]:=Fields[2].Value;
              Cells[3,i+1]:=Fields[3].Value;
            end;


          finally
            Next;
          end;
        end;
     end;
   end;
end;


// ����������� ������� ������
function getVersion(GUID:string; programm:enumProrgamm):string;
var
 ado:TADOQuery;
 serverConnect: TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select version,bild from version_update where guid = '+#39+GUID+#39+' and programm = '+#39+EnumProgrammToStr(programm)+#39+' order by id DESC limit 1');
    Active:=True;

    Result:='v.'+Fields[0].Value+' bild '+Fields[1].Value;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then  serverConnect.Free;

end;


// ����������� ������� ������ ���������
procedure showVersionAbout(programm:enumProrgamm);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countVersion,i:Integer;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from version_update where programm = '+#39+EnumProgrammToStr(programm)+#39);
    Active:=True;

    countVersion:=Fields[0].Value;

    SQL.Clear;
    SQL.Add('select date_update,version,update_text from version_update where programm = '+#39+EnumProgrammToStr(programm)+#39+' order by date_update DESC');
    Active:=True;

    with FormAbout do begin
       case programm of
          eGUI: begin
            REHistory_GUI.Clear;

            for i:=0 to countVersion-1 do begin
                 with REHistory_GUI do begin
                  Lines.Add('������ '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
                  Lines.Add(Fields[2].Value);
                  Lines.Add('');
                  Lines.Add('');
                  Lines.Add('');
                 end;
               Next;
            end;

            REHistory_GUI.SelStart:=0;
            STInfoVersionGUI.Caption:=getVersion(GUID_VESRION,programm);
          end;
          eCHAT: begin

            REHistory_CHAT.Clear;

            for i:=0 to countVersion-1 do begin
                 with REHistory_CHAT do begin
                  Lines.Add('������ '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
                  Lines.Add(Fields[2].Value);
                  Lines.Add('');
                  Lines.Add('');
                  Lines.Add('');
                 end;
               Next;
            end;

            REHistory_CHAT.SelStart:=0;
            STInfoVersionCHAT.Caption:=getVersion(GUID_VESRION,programm);
          end;
       end;
    end;
  end;


  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// �������� ping
function Ping(InIp:string):Boolean;
const
 error:word = 0;
var
  IcmpClient: TIdIcmpClient;
begin
  IcmpClient := TIdIcmpClient.Create;
  try
    with IcmpClient do begin
      Host:=InIp;
      Ping(InIp,4);

      if ReplyStatus.TimeToLive <> error then Result:=True
      else Result:=False;
    end;
  finally
    IcmpClient.Free;
  end;
end;


// �������� ������ � ���������
procedure createCheckServersInfoclinika;
const
cTOPSTART=35;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 i:Integer;
 countServers:Integer;

 lblStatusServer:   array of TLabel;
 lblAddressServer:  array of TLabel;
 lblIP:             array of TLabel;
 nameIP:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(id) from server_ik');

    try
        Active:=True;
        countServers:=Fields[0].Value;
    except
        on E:EIdException do begin
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

    if countServers>=1 then begin

      // ���������� �����������
      SetLength(lblStatusServer,countServers);
      SetLength(lblAddressServer,countServers);
      SetLength(lblIP,countServers);

      SQL.Clear;
      SQL.Add('select id,ip,address from server_ik order by ip ASC');

      try
        Active:=True;
      except
          on E:EIdException do begin
             CodOshibki:=e.Message;
             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);

             Exit;
          end;
      end;


      for i:=0 to countServers-1 do begin

        // ������
        begin
          nameIP:=VarToStr(Fields[0].Value);

          lblStatusServer[i]:=TLabel.Create(FormServerIKCheck);
          lblStatusServer[i].Name:='lbl_'+nameIP;
          lblStatusServer[i].Tag:=1;
          lblStatusServer[i].Caption:='��������';
          lblStatusServer[i].Left:=8;

          if i=0 then lblStatusServer[i].Top:=cTOPSTART
          else lblStatusServer[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

          lblStatusServer[i].Font.Name:='Tahoma';
          lblStatusServer[i].Font.Size:=8;
          lblStatusServer[i].Font.Style:=[fsBold];
          lblStatusServer[i].AutoSize:=False;
          lblStatusServer[i].Width:=78;
          lblStatusServer[i].Height:=13;
          lblStatusServer[i].Alignment:=taCenter;
          lblStatusServer[i].Parent:=FormServerIKCheck;
        end;

        // �����
        begin
          lblAddressServer[i]:=TLabel.Create(FormServerIKCheck);
          lblAddressServer[i].Name:='lblAddr_'+nameIP;
          lblAddressServer[i].Tag:=1;
          lblAddressServer[i].Caption:=VarToStr(Fields[2].Value);
          lblAddressServer[i].Left:=90;

          if i=0 then lblAddressServer[i].Top:=cTOPSTART
          else lblAddressServer[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

          lblAddressServer[i].Font.Name:='Tahoma';
          lblAddressServer[i].Font.Size:=8;
          lblAddressServer[i].AutoSize:=False;
          lblAddressServer[i].Width:=333;
          lblAddressServer[i].Height:=13;
          lblAddressServer[i].Alignment:=taCenter;
          lblAddressServer[i].Parent:=FormServerIKCheck;
        end;

        // IP
        begin
          lblIP[i]:=TLabel.Create(FormServerIKCheck);
          lblIP[i].Name:='lblIP_'+nameIP;
          lblIP[i].Tag:=1;
          lblIP[i].Caption:=VarToStr(Fields[1].Value);
          lblIP[i].Left:=427;

          if i=0 then lblIP[i].Top:=cTOPSTART
          else lblIP[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

          lblIP[i].Font.Name:='Tahoma';
          lblIP[i].Font.Size:=8;
          lblIP[i].AutoSize:=False;
          lblIP[i].Width:=144;
          lblIP[i].Height:=13;
          lblIP[i].Alignment:=taCenter;
          lblIP[i].Parent:=FormServerIKCheck;
        end;

        Next;
      end;
    end;

  end;

  FormServerIKCheck.Caption:=FormServerIKCheck.Caption+' ('+IntToStr(countServers)+')';

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// �������� ���� �������� ������
procedure createFormActiveSession;
const
cTOPSTART=28;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 i:Integer;
 countActive:Integer;

 lblUSERID:         array of TLabel;
 lblROLE:           array of TLabel;
 lblUSERNAME:       array of TLabel;
 lblPC:             array of TLabel;
 lblIP:             array of TLabel;
 lblONLINE:         array of TLabel;
 lblSTATUS:         array of TLabel;
 btnCLOSE_SESSION:  array of TButton;
 btnCLOSE_QUEUE:    array of TButton;

 nameID:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(id) from active_session');

    try
        Active:=True;
        countActive:=Fields[0].Value;
    except
        on E:EIdException do begin
           
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

    if countActive>=1 then begin

      // ���������� �����������
      SetLength(lblUSERID,countActive);
      SetLength(lblROLE,countActive);
      SetLength(lblUSERNAME,countActive);
      SetLength(lblPC,countActive);
      SetLength(lblIP,countActive);
      SetLength(lblONLINE,countActive);
      SetLength(lblSTATUS,countActive);
      SetLength(btnCLOSE_SESSION,countActive);
      SetLength(btnCLOSE_QUEUE,countActive);

      SQL.Clear;
      // order by id ASC

      SQL.Add('SELECT asession.user_id, r.name_role, CONCAT(u.familiya, '+#39' '+#39+', u.name) AS full_name, asession.pc, asession.ip, asession.last_active FROM active_session AS asession JOIN users AS u ON asession.user_id = u.id JOIN role AS r ON u.role = r.id');

      try
        Active:=True;
      except
          on E:EIdException do begin
             CodOshibki:=e.Message;
             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);

             Exit;
          end;
      end;


      for i:=0 to countActive-1 do begin

        // ID
        begin
          nameID:=VarToStr(Fields[0].Value);

          lblUSERID[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblUSERID[i].Name:='lblUSERID_'+nameID;
          lblUSERID[i].Tag:=1;
          lblUSERID[i].Caption:=VarToStr(Fields[0].Value);
          lblUSERID[i].Left:=6;

          if i=0 then lblUSERID[i].Top:=cTOPSTART
          else lblUSERID[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblUSERID[i].Font.Name:='Tahoma';
          lblUSERID[i].Font.Size:=10;
          lblUSERID[i].AutoSize:=False;
          lblUSERID[i].Width:=79;
          lblUSERID[i].Height:=16;
          lblUSERID[i].Alignment:=taCenter;
          lblUSERID[i].Parent:=FormActiveSession.PanelActive;

        end;

        // ����
        begin
          lblROLE[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblROLE[i].Name:='lblROLE_'+nameID;
          lblROLE[i].Tag:=1;
          lblROLE[i].Caption:=VarToStr(Fields[1].Value);
          lblROLE[i].Left:=85;

          if i=0 then lblROLE[i].Top:=cTOPSTART
          else lblROLE[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblROLE[i].Font.Name:='Tahoma';
          lblROLE[i].Font.Size:=10;
          lblROLE[i].AutoSize:=False;
          lblROLE[i].Width:=150;
          lblROLE[i].Height:=16;
          lblROLE[i].Alignment:=taCenter;
          lblROLE[i].Parent:=FormActiveSession.PanelActive;
        end;

        // ������������
        begin
          lblUSERNAME[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblUSERNAME[i].Name:='lblUSERNAME_'+nameID;
          lblUSERNAME[i].Tag:=1;
          lblUSERNAME[i].Caption:=VarToStr(Fields[2].Value);
          lblUSERNAME[i].Left:=235;

          if i=0 then lblUSERNAME[i].Top:=cTOPSTART
          else lblUSERNAME[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblUSERNAME[i].Font.Name:='Tahoma';
          lblUSERNAME[i].Font.Size:=10;
          lblUSERNAME[i].AutoSize:=False;
          lblUSERNAME[i].Width:=168;
          lblUSERNAME[i].Height:=16;
          lblUSERNAME[i].Alignment:=taCenter;
          lblUSERNAME[i].Parent:=FormActiveSession.PanelActive;
        end;

        // ���������
        begin
          lblPC[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblPC[i].Name:='lblPC_'+nameID;
          lblPC[i].Tag:=1;
          lblPC[i].Caption:=VarToStr(Fields[3].Value);
          lblPC[i].Left:=403;

          if i=0 then lblPC[i].Top:=cTOPSTART
          else lblPC[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblPC[i].Font.Name:='Tahoma';
          lblPC[i].Font.Size:=10;
          lblPC[i].AutoSize:=False;
          lblPC[i].Width:=87;
          lblPC[i].Height:=16;
          lblPC[i].Alignment:=taCenter;
          lblPC[i].Parent:=FormActiveSession.PanelActive;
        end;

        // IP
        begin
          lblIP[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblIP[i].Name:='lblIP_'+nameID;
          lblIP[i].Tag:=1;
          lblIP[i].Caption:=VarToStr(Fields[4].Value);
          lblIP[i].Left:=489;

          if i=0 then lblIP[i].Top:=cTOPSTART
          else lblIP[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblIP[i].Font.Name:='Tahoma';
          lblIP[i].Font.Size:=10;
          lblIP[i].AutoSize:=False;
          lblIP[i].Width:=120;
          lblIP[i].Height:=16;
          lblIP[i].Alignment:=taCenter;
          lblIP[i].Parent:=FormActiveSession.PanelActive;
        end;

        // ���� �������
        begin
          lblONLINE[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblONLINE[i].Name:='lblONLINE_'+nameID;
          lblONLINE[i].Tag:=1;
          lblONLINE[i].Caption:=VarToStr(Fields[5].Value);
          lblONLINE[i].Left:=609;

          if i=0 then lblONLINE[i].Top:=cTOPSTART
          else lblONLINE[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblONLINE[i].Font.Name:='Tahoma';
          lblONLINE[i].Font.Size:=10;
          lblONLINE[i].AutoSize:=False;
          lblONLINE[i].Width:=121;
          lblONLINE[i].Height:=16;
          lblONLINE[i].Alignment:=taCenter;
          lblONLINE[i].Parent:=FormActiveSession.PanelActive;
        end;

        // ������
        begin
          lblSTATUS[i]:=TLabel.Create(FormActiveSession.PanelActive);
          lblSTATUS[i].Name:='lblSTATUS_'+nameID;
          lblSTATUS[i].Tag:=1;
          lblSTATUS[i].Caption:='ONLINE!';
          lblSTATUS[i].Left:=730;

          if i=0 then lblSTATUS[i].Top:=cTOPSTART
          else lblSTATUS[i].Top:=cTOPSTART+(Round(cTOPSTART)*i);

          lblSTATUS[i].Font.Name:='Tahoma';
          lblSTATUS[i].Font.Size:=10;
          lblSTATUS[i].AutoSize:=False;
          lblSTATUS[i].Width:=94;
          lblSTATUS[i].Height:=16;
          lblSTATUS[i].Alignment:=taCenter;
          lblSTATUS[i].Parent:=FormActiveSession.PanelActive;
        end;

        // ������� ������
        begin
          btnCLOSE_SESSION[i]:=TButton.Create(FormActiveSession.PanelActive);
          btnCLOSE_SESSION[i].Name:='btnCLOSE_SESSION_'+nameID;
          btnCLOSE_SESSION[i].Tag:=1;
          btnCLOSE_SESSION[i].Caption:='��������� ������!';
          btnCLOSE_SESSION[i].Left:=837;

          if i=0 then btnCLOSE_SESSION[i].Top:=cTOPSTART - 5
          else btnCLOSE_SESSION[i].Top:=cTOPSTART+(Round(cTOPSTART)*i)-5;

          btnCLOSE_SESSION[i].Font.Name:='Tahoma';
          btnCLOSE_SESSION[i].Font.Size:=10;
          btnCLOSE_SESSION[i].Width:=126;
          btnCLOSE_SESSION[i].Height:=25;
          btnCLOSE_SESSION[i].Parent:=FormActiveSession.PanelActive;
        end;

         // ������ �� �������
        begin
          btnCLOSE_QUEUE[i]:=TButton.Create(FormActiveSession.PanelActive);
          btnCLOSE_QUEUE[i].Name:='btnCLOSE_QUEUE_'+nameID;
          btnCLOSE_QUEUE[i].Tag:=1;
          btnCLOSE_QUEUE[i].Caption:='������ �� �������';
          btnCLOSE_QUEUE[i].Left:=971;

          if i=0 then btnCLOSE_QUEUE[i].Top:=cTOPSTART - 5
          else btnCLOSE_QUEUE[i].Top:=cTOPSTART+(Round(cTOPSTART)*i)-5;

          btnCLOSE_QUEUE[i].Font.Name:='Tahoma';
          btnCLOSE_QUEUE[i].Font.Size:=10;
          btnCLOSE_QUEUE[i].Width:=126;
          btnCLOSE_QUEUE[i].Height:=25;
          btnCLOSE_QUEUE[i].Parent:=FormActiveSession.PanelActive;

          if (AnsiPos('��������',VarToStr(Fields[1].Value)) <> 0) or
              (AnsiPos('��������',VarToStr(Fields[1].Value))<> 0) then begin
            btnCLOSE_QUEUE[i].Enabled:=True;
          end
          else begin
            btnCLOSE_QUEUE[i].Enabled:=False;
          end;

        end;



        Next;
      end;
    end;

  end;

  //FormServerIKCheck.Caption:=FormServerIKCheck.Caption+' ('+IntToStr(countServers)+')';

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ����������� ���� ������������
function getUserGroupSTR(InGroup:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select name_role from role where id = '+#39+IntToStr(InGroup)+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ����������� ���� ������������
function getUserRoleSTR(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select name_role from role where id = (select role from users where id = '+#39+IntToStr(InUserID)+#39+')' );
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ���������� ������� �������� �� ������ ��������� ��� ���
function getOperatorAccessDashboard(InSip:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select role from users where id = (select user_id from operators where sip = '+#39+InSip+#39+')' );
    Active:=True;

    if Fields[0].Value<>null then begin
      if StrToInt(VarToStr(Fields[0].Value)) = 6 then Result:=False
      else Result:=True;
    end
    else Result:=False;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ���������� �� �������� ������ ��� �����
function getUserRePassword(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select is_need_reset_pwd from users where id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value=0 then Result:=False
    else Result:=True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ����������� ID ���� ������������
function getUserGroupID(InGroup:string):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select id from role where name_role = '+#39+InGroup+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:= -1;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ����������� ID ������������
function getUserID(InLogin:string):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select id from users where login = '+#39+InLogin+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:= -1;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ����������� SIP ������������
function getUserSIP(InIDUser:integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InIDUser)+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value)
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� ����� �������������
procedure loadPanel_Users(InUserRole:enumRole; InShowDisableUsers:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 only_operators_roleID:TStringList;
 id_operators:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;

    if InUserRole = role_administrator then begin
      if InShowDisableUsers=False then SQL.Add('select count(id) from users where disabled =''0'' ')
      else SQL.Add('select count(id) from users where disabled =''1'' ');
    end
    else begin
      only_operators_roleID:=GetOnlyOperatorsRoleID;
      for i:=0 to only_operators_roleID.Count-1 do begin
        if id_operators='' then id_operators:=#39+only_operators_roleID[i]+#39
        else id_operators:=id_operators+','#39+only_operators_roleID[i]+#39;
      end;

      if InShowDisableUsers=False then SQL.Add('select count(id) from users where disabled =''0'' and role IN('+id_operators+') ')
      else SQL.Add('select count(id) from users where disabled =''1'' and role IN('+id_operators+') ');
     if only_operators_roleID<>nil then FreeAndNil(only_operators_roleID);
    end;

    Active:=True;

    countUsers:=Fields[0].Value;
  end;

  with FormUsers.listSG_Users do begin
   RowCount:=1;      // ���� ������� �������� ������
   RowCount:=countUsers;

    with ado do begin

      SQL.Clear;

      if InUserRole = role_administrator then begin
       if InShowDisableUsers=False then SQL.Add('select id,familiya,name,login,role,disabled from users where disabled = ''0'' order by familiya ASC')
       else SQL.Add('select id,familiya,name,login,role,disabled from users where disabled = ''1'' order by familiya ASC');
      end
      else  begin
       if InShowDisableUsers=False then SQL.Add('select id,familiya,name,login,role,disabled from users where disabled = ''0'' and role IN('+id_operators+') order by familiya ASC')
       else SQL.Add('select id,familiya,name,login,role,disabled from users where disabled = ''1'' and role IN('+id_operators+') order by familiya ASC');
      end;


      Active:=True;

       for i:=0 to countUsers-1 do begin
         Cells[0,i]:=Fields[0].Value;                       // id
         Cells[1,i]:=Fields[1].Value+ ' '+Fields[2].Value;  // ������� + ���
         Cells[2,i]:=Fields[3].Value;                       // login
         Cells[3,i]:=getUserGroupSTR(Fields[4].Value);      // ������ ����
         if InShowDisableUsers=False then begin             // ���������
          Cells[4,i]:='�������';
         end
         else begin
          if VarToStr(Fields[3].Value)='0' then Cells[4,i]:='�������'
          else Cells[4,i]:='��������';
         end;

         Next;
       end;

       FormUsers.Caption:='������������: '+IntToStr(countUsers);

    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;



// ��������� ����� ������������� (���������)
procedure loadPanel_Operators;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from operators ');

    Active:=True;

    countUsers:=Fields[0].Value;
  end;

  with FormUsers.listSG_Operators do begin
   RowCount:=1;      // ���� ������� �������� ������
   RowCount:=countUsers;

    with ado do begin

      SQL.Clear;
      SQL.Add('select id,sip,user_id,sip_phone from operators order by sip asc ');

      Active:=True;

       for i:=0 to countUsers-1 do begin

         Cells[0,i]:=Fields[0].Value;                           // id
         Cells[1,i]:=getUserNameOperators(Fields[1].Value);     // ������� ���
         Cells[2,i]:=Fields[1].Value;                           // Sip
         if Fields[3].Value<>null then Cells[3,i]:=Fields[3].Value
         else Cells[3,i]:='null';
         Cells[4,i]:=getUserRoleSTR( StrToInt(Fields[2].Value) );  // ������ ����

         Next;
       end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;


// ���������� �� login �������������
function getCheckLogin(inLogin:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from users where login = '+#39+InLogin+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      if Fields[0].Value <> 0 then Result:=True
      else Result:=False;
    end
    else Result:= True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� userID �� ���
function getUserID(InUserName,InUserFamiliya:string):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select id from users where name = '+#39+InUserName+#39 +' and familiya = '+#39+InUserFamiliya+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      if Fields[0].Value <> 0 then Result:=Fields[0].Value
      else Result:=-1;
    end
    else Result:= -1;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� userID �� SIP ������
function getUserID(InSIPNumber:integer):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select user_id from operators where sip = '+#39+IntToStr(InSIPNumber)+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      if Fields[0].Value <> 0 then Result:=Fields[0].Value
      else Result:=-1;
    end
    else Result:= -1;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� userPwd �� userID
function getUserPwd(InUserID:Integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;


  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select pass from users where id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      if Fields[0].Value <> 0 then Result:=Fields[0].Value
      else Result:=-1;
    end
    else Result:= -1;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� userLogin �� userID
function getUserLogin(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select login from users where id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:= 'null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;



// ��������� ����� status ���������
function getStatus(InStatus:enumStatusOperators):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select status from status where id = '+#39+IntToStr(EnumStatusOperatorsToInteger(InStatus))+#39);
    Active:=True;

    if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value)
    else Result:='����������';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// ���������� ������������
function disableUser(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('update users set disabled = ''1'' where id = '+#39+IntToStr(InUserID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           Result:='������! '+CodOshibki;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

    // �������� ������������ ����������� ������ ����������
    if UserIsOperator(InUserID) then begin
      disableOperator(InUserID);
      deleteOperator(InUserID);
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Result:='OK';
end;


// ��������� ������������
function enableUser(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('update users set disabled = ''0'' where id = '+#39+IntToStr(InUserID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           Result:='������! '+CodOshibki;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Result:='OK';
end;


// �������� ������������ �� ������� operators
procedure deleteOperator(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('delete from operators where user_id = '+#39+IntToStr(InUserID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

  end;
  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ��������� ������������� � ����� �����������
procedure LoadUsersAuthForm;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 countUsers,i:Integer;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(id) from users where disabled = ''0'' and role <> ''6'' ');

    try
        Active:=True;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           MessageBox(FormAuth.Handle,PChar('�������� ������ ��� ������� �� ������!'+#13#13+CodOshibki),PChar('������'),MB_OK+MB_ICONERROR);
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           KillProcess;
        end;
    end;

    countUsers:=Fields[0].Value;

    SQL.Clear;
    SQL.Add('select familiya,name from users where disabled = ''0'' and role <> ''6'' order by familiya');

    try
        Active:=True;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           MessageBox(FormAuth.Handle,PChar('�������� ������ ��� ������� �� ������!'+#13#13+CodOshibki),PChar('������'),MB_OK+MB_ICONERROR);
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           KillProcess;
        end;
    end;

     with FormAuth.comboxUser do begin

      Clear;

       for i:=0 to countUsers-1 do begin
        Items.Add(Fields[0].Value+' '+Fields[1].Value);
        Next;
       end;
     end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ���������� userID ����� ��������� ����� �� ��
function getUserFamiliyaName_LastSuccessEnter(InUser_login_pc,InUser_pc:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select familiya,name from users where id = (select user_id  from logging where user_login_pc='+#39+InUser_login_pc+#39+' and pc='+#39+InUser_pc+#39+' and action='+#39+IntToStr(TLoggingToInt(eLog_enter))+#39+' order by date_time DESC limit 1) and disabled =''0'' ');

    Active:=True;

    // ���� ��� � ��������, �� ������� � ������� history_logging
    if Fields[0].Value = null then begin
      SQL.Clear;
      SQL.Add('select familiya,name from users where id = (select user_id  from history_logging where user_login_pc='+#39+InUser_login_pc+#39+' and pc='+#39+InUser_pc+#39+' and action='+#39+IntToStr(TLoggingToInt(eLog_enter))+#39+' order by date_time DESC limit 1) and disabled =''0'' ');

      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
      else Result:='null';

    end
    else begin
      if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
      else Result:='null';
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ����������� ����� ���������� ������������ � ������ ��������� �������������
procedure showUserNameAuthForm;
var
 userNameFamiliya:string;
begin
  // ������ ��� ������� ���������� ��������� �����
  userNameFamiliya:=getUserFamiliyaName_LastSuccessEnter(getCurrentUserNamePC,getComputerPCName);
  if userNameFamiliya='null' then Exit;

  // ������ ������ items
  with FormAuth do begin
    comboxUser.ItemIndex:=comboxUser.Items.IndexOf(userNameFamiliya);
    comboxUser.SetFocus;

    edtPassword.SetFocus;
  end;

end;


// ����� ������� ���������� �������� �� �������� ������ � �������
function getIVRTimeQueue(InQueue:enumQueueCurrent):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    case InQueue of
       queue_5000:begin
         SQL.Add('select queue_5000_time from settings order by id desc limit 1');
       end;
       queue_5050:begin
         SQL.Add('select queue_5050_time from settings order by id desc limit 1');
       end;
    end;

    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:=0;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ���������� ������ ������������
function updateUserPassword(InUserID,InUserNewPassword:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('update users set pass = '+#39+IntToStr(InUserNewPassword)+#39+', is_need_reset_pwd= ''0'' where id = '+#39+IntToStr(InUserID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           Result:='������! '+CodOshibki;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

   Result:='OK';
end;


// ���������� �� ������
function isExistCurrentActiveSession(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from active_session where user_id ='+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value=0 then Result:=False
    else Result:=True;
  end;

 FreeAndNil(ado);
  serverConnect.Close;
 FreeAndNil(serverConnect);

end;


// ���������� ID �������� ������ ������������
function getActiveSessionUser(InUserID:Integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select id from active_session where user_id ='+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value<>null then begin
      Result:=Fields[0].Value;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// �������� �������� ������
procedure deleteActiveSession(InSessionID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('delete from active_session where id = '+#39+IntToStr(InSessionID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// ��������� �������� ������
procedure createCurrentActiveSession(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 ip,user_pc,pc_name:string;
begin
  Screen.Cursor:=crHourGlass;

  //��������� ���� �� ��� ����� ������
   if isExistCurrentActiveSession(InUserID) then begin
     // ������� �������� ������
     deleteActiveSession(getActiveSessionUser(InUserID));
   end;



  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  ip:=SharedCurrentUserLogon.GetIP;
  user_pc:=SharedCurrentUserLogon.GetUserLoginPC;
  pc_name:=SharedCurrentUserLogon.GetPC;


   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('insert into active_session (ip,user_id,user_login_pc,pc) values ('+#39+ip+#39+','
                                                                                 +#39+IntToStr(SharedCurrentUserLogon.GetID)+#39+','
                                                                                 +#39+user_pc+#39+','
                                                                                 +#39+pc_name+#39+')');

      try
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             CodOshibki:=e.Message;
             serverConnect.Close;
             FreeAndNil(serverConnect);

             Exit;
          end;
      end;
   end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);


  Screen.Cursor:=crDefault;
end;


// ���������� ������� �������� ����� ������������
procedure updateCurrentActiveSession(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('update active_session set last_active = '+#39+getCurrentDateTimeWithTime+#39+' where user_id = '+#39+IntToStr(InUserID)+#39);

    try
        ExecSQL;
    except
        on E:EIdException do begin
           CodOshibki:=e.Message;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// �������� ������� �� ��� ����� �������� ��� ����� sip ������� � �� �������
function isExistSipActiveOperator(InSip:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
   ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select disabled from users where id = ( select user_id from operators where sip = '+#39+InSip+#39+')');

    Active:=True;

    if Fields[0].Value<>null then begin
      if VarToStr(Fields[0].Value) = '0' then Result:=True
      else Result:=False;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� ����� ������������ �� ��� SIP ������
function getUserNameOperators(InSip:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select familiya,name from users where id = ( select user_id from operators where sip = '+#39+InSip+#39+') and disabled = ''0''');

    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

 {
// ��������� ����� ������������ �� ��� UserID
function getUserFIO(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select familiya,name from users where id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end; }

// ��������� ������� ������������ �� ��� UserID
function getUserFamiliya(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select familiya from users where id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� ����� ������������ �� ��� UserID
function getUserNameBD(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select name from users where id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value
    else Result:='null';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// ����������� ������ ������� ����������
procedure showStatusOperator(InShow:Boolean = True);
begin
   with HomeForm do begin
      if InShow then begin
       ST_StatusPanel.Visible:=True;
       ST_StatusPanelWindow.Visible:=True;
       PanelStatus.Visible:=True;
      end
      else begin
       ST_StatusPanel.Visible:=False;
       ST_StatusPanelWindow.Visible:=False;
       PanelStatus.Visible:=False;
      end;
   end;
end;

// TAccessListToStr -> string
function TAccessListToStr(AccessList:enumAccessList):string;
begin
  case AccessList of
    menu_settings_users:                      Result:='menu_Users';
    menu_settings_serversik:                  Result:='menu_ServersIK';
    menu_settings_siptrunk:                   Result:='menu_SIPtrunk';
    menu_settings_global:                     Result:='menu_GlobalSettings';
    menu_active_session:                      Result:='menu_activeSession';
  end;
end;


function FindMenuItem(AOwner: TMenuItem; const AName: string): TMenuItem;
var
  I: Integer;
begin
  Result := nil;
  // ������� ��� �������� ����
  for I := 0 to AOwner.Count - 1 do
  begin
    if AOwner[I].Name = AName then
    begin
      Result := AOwner[I];
      Exit; // ���� �����, ������� �� �������
    end;

    // ���� ������� ����� �������, ���� ���������� � �������
    if AOwner[I].Count > 0 then
    begin
      Result := FindMenuItem(AOwner[I], AName);
      if Assigned(Result) then
        Exit; // ���� ����� � �������, �������
    end;
  end;
end;


// �������������� TAccessStatus --> Bool
function TAccessStatusToBool(Status: enumAccessStatus): Boolean;
begin
  if Status = access_ENABLED then Result:=True;
  if Status = access_DISABLED then Result:=False;
end;

// ��������������� ������� ��� ��������� ����� �������� TMenuItem
function MenuItemName(AItem: TMenuItem): string;
begin
  Result := AItem.Name;
end;

// ��������������� ������� ��� ��������� ���������� �������
function MenuItemCount(AItem: TMenuItem): Integer;
begin
  Result := AItem.Count;
end;

// ��������� ����������\������ �� ������ � ����
procedure SetAccessMenu(InNameMenu:enumAccessList; InStatus: enumAccessStatus);
var
  MenuItem: TMenuItem;
begin
  MenuItem:=FindMenuItem(HomeForm.FooterMenu.Items, TAccessListToStr(InNameMenu));
  if Assigned(MenuItem) then
  begin
    MenuItem.Enabled := TAccessStatusToBool(InStatus);
  end
end;


// ����� �������
procedure accessRights(var p_TUser: TUser);
 var
  i:Integer;
  Access:enumAccessList;
begin
  with HomeForm do begin

    // HomeForm
    begin
     // ������ ������� ����������
     case p_TUser.GetRole of
       role_administrator:begin                  // �������������
        showStatusOperator(False);
       end;
       role_lead_operator:begin                  // ������� ��������
         showStatusOperator;
       end;
       role_senior_operator:begin               // ������� ��������
         showStatusOperator;
       end;
       role_operator:begin                      // ��������
        // ������ ������� ����������
        showStatusOperator;
       end;
       role_operator_no_dash:begin             // �������� (��� ��������)
        showStatusOperator;
       end;
       role_supervisor_cov:begin               // ������������ ���
        // ������ ������� ����������
        showStatusOperator(False);
       end;
     end;

      // menu
      begin
        for i:=Ord(Low(enumAccessList)) to Ord(High(enumAccessList)) do
        begin
          Access:=enumAccessList(i);
          SetAccessMenu(Access,p_TUser.GetAccess(Access));
        end;
      end;

    end;

  end;

end;


// �������� ����� �� ������� �������� ������
function getForceActiveSessionClosed(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select force_closed from active_session where user_id = '+#39+IntToStr(InUserID)+#39);

    Active:=True;

    if Fields[0].Value<>null then begin
      if VarToStr(Fields[0].Value) = '1' then Result:=True
      else Result:=False;
    end
    else Result:=False;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// �������� �� 2�� ����� ��������
procedure cloneRun;
const
 dash_name ='dashboard.exe';
var
 dashStart:Cardinal;
begin
  // �������� �� ���������� �����
   dashStart:= CreateMutex(nil, True, dash_name);
   if GetLastError = ERROR_ALREADY_EXISTS then
   begin
     MessageBox(HomeForm.Handle,PChar('��������� ������ 2�� ����� ��������'+#13#13+'��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
     KillProcess;
   end;
end;

// �������� �� ���������� ������
procedure CheckCurrentVersion;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 curr_ver:string;

 //XML:TXMLSettings;
   XML:TXML;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select id from version_current');
    Active:=True;

    curr_ver:=Fields[0].Value;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  if GUID_VESRION <> curr_ver then begin
   MessageBox(HomeForm.Handle,PChar('������� ������ �������� ���������� �� ���������� ������'+#13#13
                                    +'������������� ��������� ��� ������������� ������ ���������� ('+UPDATE_EXE+')'),PChar('������'),MB_OK+MB_ICONINFORMATION);
   KillProcess;
  end;

  // ������� ������� ������ ��������
  begin
//   if FileExists(SETTINGS_XML) then begin
//    XML:=CreateXMLSettingsSingle(PChar(SETTINGS_XML));
//    // ��������� �������
//    UpdateXMLLocalVersion(XML,PChar(GUID_VESRION));
//   end
//   else begin
//    XML:=CreateXMLSettings(PChar(SETTINGS_XML), PChar(GUID_VESRION));
//   end;
//   FreeXMLSettings(XML);

   if FileExists(SETTINGS_XML) then begin
    XML:=TXML.Create(PChar(SETTINGS_XML));
    // ��������� �������
    XML.UpdateCurrentVersion(PChar(GUID_VESRION));
   end
   else begin
    XML:=TXML.Create(PChar(SETTINGS_XML),PChar(GUID_VESRION));
   end;
   XML.Free;

  end;

end;

// �����������\������� ���� ������� �� ������
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   close: begin
     // ������������� ���������� ������ ��������
     HomeForm.PanelStatusIN.Height:=cPanelStatusHeight_default;
     FormOperatorStatus.Height:=FormOperatorStatus.cHeightStart;

     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// �������� ������� �� ���������� ��������� �������
function remoteCommand_Responce(InStroka:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add(InStroka);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);
             Result:='������! �� ������� ��������� ������'+#13#13+e.ClassName+' '+e.Message;
             Exit;
          end;
      end;
   end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
  Result:='OK';
end;


// �������� ���� �� ��� ����� ��������� ������� �� �������
function isExistRemoteCommand(command:enumLogging):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from remote_commands where command = '+#39+inttostr(TLoggingToInt(command)) +#39+' and user_id = '+#39+IntToStr(SharedCurrentUserLogon.GetID)+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      if Fields[0].Value <> 0 then Result:=True
      else Result:=False;
    end
    else Result:= True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;


// ��������� ������� (���������� � �������)
procedure remoteCommand_addQueue(command:enumLogging);
var
 resultat:string;
 response:string;
 soLongWait:UInt16;
begin
  soLongWait:=0;
  showWait(open);

  response:='insert into remote_commands (sip,command,ip,user_id,user_login_pc,pc) values ('+#39+getUserSIP(SharedCurrentUserLogon.GetID) +#39+','
                                                                                            +#39+IntToStr(TLoggingToInt(command))+#39+','
                                                                                            +#39+SharedCurrentUserLogon.GetIP+#39+','
                                                                                            +#39+IntToStr(SharedCurrentUserLogon.GetID)+#39+','
                                                                                            +#39+SharedCurrentUserLogon.GetUserLoginPC+#39+','
                                                                                            +#39+SharedCurrentUserLogon.GetPC+#39+')';
  // ��������� ������
  resultat:=remoteCommand_Responce(response);
  if AnsiPos('������!',resultat)<>0 then begin
    showWait(close);
    MessageBox(HomeForm.Handle,PChar(resultat),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ���� ���� ���������� �� core_dashboard
  while (isExistRemoteCommand(command)) do begin
   Sleep(1000);
   Application.ProcessMessages;

   if soLongWait>6 then begin

    // ������� ������� �������
       response:='delete from remote_commands where sip ='+#39+getUserSIP(SharedCurrentUserLogon.GetID)+#39+
                                                         ' and command ='+#39+IntToStr(TLoggingToInt(command))+#39;

    resultat:=remoteCommand_Responce(response);
    showWait(close);
    MessageBox(HomeForm.Handle,PChar('������� �� ���������� �� �� ���������� ������'+#13#13+'���������� ��� ���'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;

   end else begin
    Inc(soLongWait);
   end;
  end;

  showWait(close);
end;


// � ����� ������� ������ ��������� ��������
function getCurrentQueueOperator(InSipNumber:string):enumQueueCurrent;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countQueue:Integer;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(queue) from operators_queue where sip = '+#39+InSipNumber+#39);
    Active:=True;

    countQueue:=Fields[0].Value;

    if Active then Active:=False;
     

    case countQueue of
      0:begin              // �� � ����� �������
        Result:=queue_null;
      end;
      1: begin             // ���� � 5000 ���� � 5050 (���� ������ � �����)
        SQL.Clear;
        SQL.Add('select queue from operators_queue where sip = '+#39+InSipNumber+#39);
        Active:=True;

        if Fields[0].Value<>null then begin
          if (VarToStr(Fields[0].Value)='5000')       then Result:=queue_5000
          else if (VarToStr(Fields[0].Value)='5050')  then Result:=queue_5050
          else                                             Result:=queue_null;
        end
        else Result:=queue_null;

      end;
      2: begin            // � ����� ��������
        Result:=queue_5000_5050;
      end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ������� �������� ������� ���������
procedure clearOperatorStatus;
var
 isOPerator:Boolean;
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  isOPerator:=False;

  if (SharedCurrentUserLogon.GetRole = role_lead_operator) or
     (SharedCurrentUserLogon.GetRole = role_senior_operator) or
     (SharedCurrentUserLogon.GetRole = role_operator) then isOPerator:=True;


  if not isOPerator then Exit;


  // ������� ������� ������
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  try
   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update operators set status = ''-1'' where sip = '+#39+getUserSIP(SharedCurrentUserLogon.GetID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin

             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);

             Exit;
          end;
      end;
   end;
  finally
   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);
  end;
end;


// �������� � ����������� ������ �������� ���������
procedure checkCurrentStatusOperator(InOperatorStatus:enumStatusOperators);
begin
  with HomeForm do begin

    case InOperatorStatus of
     eAvailable:begin    // ��������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eHome:begin    // �����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=False;
       btnStatus_reserve.Enabled:=True;
     end;
     eExodus:begin    // �����
       btnStatus_exodus.Enabled:=False;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;

     end;
     eBreak:begin    // �������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=False;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eDinner:begin   // ����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=False;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     ePostvyzov:begin   // ���������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=False;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eStudies:begin   // �����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=False;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eIT:begin   // ��
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=False;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eTransfer:begin  // ��������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=False;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eReserve:begin  // ������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=False;
     end;
    end;
  end;

  with FormOperatorStatus do begin
    case InOperatorStatus of
     eAvailable:begin    // ��������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eHome:begin    // �����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=False;
       btnStatus_reserve.Enabled:=True;
     end;
     eExodus:begin    // �����
       btnStatus_exodus.Enabled:=False;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;

     end;
     eBreak:begin    // �������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=False;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eDinner:begin   // ����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=False;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     ePostvyzov:begin   // ���������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=False;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eStudies:begin   // �����
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=False;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eIT:begin   // ��
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=False;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eTransfer:begin  // ��������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=False;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
     end;
     eReserve:begin  // ������
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=False;
     end;
    end;
  end;
end;


// ������� ������� � ������� ������� ���������
function getLastStatusTime(InUserid:Integer; InOperatorStatus:enumStatusOperators):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 curr_date:string;
 status:Integer;
 dateToBD:TDateTime;
 dateNOW:TDateTime;
 diff:Integer;
begin
  // ������� ��������� �����
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  // ������� ������� �� ����
  status:=TLoggingToInt(getStatusOperatorToTLogging(EnumStatusOperatorsToInteger(InOperatorStatus)));


  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select date_time from logging where user_id = '+#39+IntToStr(InUserid)+#39+' and action = '+#39+IntToStr(status)+#39+ ' order by date_time DESC limit 1' );
    Active:=True;

    if Fields[0].Value<>null then curr_date:=Fields[0].Value
    else begin
      Result:='null';
      FreeAndNil(ado);
      serverConnect.Close;
      FreeAndNil(serverConnect);

      Exit;
    end;
  end;

  // ������� �� �������
   dateToBD:=StrToDateTime(curr_date);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );
   Result:=getTimeAnsweredSecondsToString(diff);

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ������� ������� � ������� OnHold
function getLastStatusTimeOnHold(InStartTimeonHold:string):string;
var
 dateToBD:TDateTime;
 dateNOW:TDateTime;
 diff:Integer;
begin
  // ������� �� �������
   dateToBD:=StrToDateTime(InStartTimeonHold);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );
   Result:=getTimeAnsweredSecondsToString(diff);
end;

// �������� �������� ���� ����� ��� ���
function isOperatorGoHome(inUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countLastStatus:Integer;
 isGoHome,IsExit:Boolean;
 i:Integer;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(action) from logging where user_id = '+#39+IntToStr(InUserid)+#39+' order by date_time DESC limit 2' );
    Active:=True;

    countLastStatus:=Fields[0].Value;

    if countLastStatus<=1 then begin
      FreeAndNil(ado);
      serverConnect.Close;
      FreeAndNil(serverConnect);

      Result:=False;
      Exit;
    end;

    // ��������� ���� �� ������ 11(�����) �� ��� 1(�����)
    if Active then Active:=False;

    isGoHome:=False;
    IsExit:=False;

    SQL.Clear;
    SQL.Add('select action from logging where user_id = '+#39+IntToStr(InUserid)+#39+' order by date_time DESC limit 2' );
    Active:=True;

    for i:=0 to 1 do begin
      if Fields[0].Value<>null then begin
         // ��������� ���� �� ������ �����
         if i=0 then begin
          if VarToStr(Fields[0].Value)='1' then IsExit:=True
          else IsExit:=False;
         end
         else if (i=1) then begin
           if VarToStr(Fields[0].Value)='11' then isGoHome:=True
          else isGoHome:=False;
         end;
      end;

      Next;
    end;

  end;
  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

 if IsExit and isGoHome then Result:=True
 else Result:=False;
end;


// �������� ����� �������� ����� ����� �� �����
function getIsExitOperatorCurrentQueue(InCurrentRole:enumRole;InUserID:Integer):Boolean;
begin
 case InCurrentRole of
   role_lead_operator,role_senior_operator,role_operator:begin

     // ���������� ���� ��� � ������� ��������� ��������
     if SharedActiveSipOperators.isExistOperatorInQueue(getUserSIP(InUserID)) then Result:=True
     else Result:=False;

   end
   else Result:=False;
 end;

end;

// �������� ����� �������� �� ��������� �������, ����� �������� ����� ������� "�����"
function getIsExitOperatorCurrentGoHome(InCurrentRole:enumRole;InUserID:Integer):Boolean;
begin
 case InCurrentRole of
   role_lead_operator,role_senior_operator,role_operator:begin

     // ���������� ���� �� ��������� ����� �������
     if getLastStatusOperator(InUserID) <> eLog_home then Result:=True
     else Result:=False;

   end
   else Result:=False;
 end;

end;


// �������������� �� ��� - > ��������
function getTranslate(Stroka: string):string;
var
 Translate:TTranslirt;
begin
  Translate:=TTranslirt.Create;
  Result:=Translate.RusToEng(Stroka);
end;

// �������� userID ����������� ��������� ��� ��� TRUE - ��������
function UserIsOperator(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value=null then Result:=False
    else Result:=True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;

// ������� ���� � ������� � ������������ ��� ��� BD
function getDateTimeToDateBD(InDateTime:string):string;
var
 Timetmp,Datetmp:string;
begin
 Timetmp:=InDateTime;
 System.Delete(Timetmp,1,AnsiPos(' ',Timetmp));

 Datetmp:=InDateTime;
 System.Delete(Datetmp,AnsiPos(' ',Datetmp),Length(Datetmp));
 Datetmp:=Copy(Datetmp,7,4)+'-'+Copy(Datetmp,4,2)+'-'+Copy(Datetmp,1,2);

 Result:=Datetmp+' '+Timetmp;
end;


// ���������� ��������� � ������� ��� � ������� operators_disable
procedure disableOperator(InUserId:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

 // ������ ��������� �� ������ operators
 date_time_create,
 sip:string;

begin
 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select date_time,sip from operators where user_id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value<>null then begin
      date_time_create:=getDateTimeToDateBD(VarToStr(Fields[0].Value));
      sip:=Fields[1].Value;
    end
    else begin
      FreeAndNil(ado);
      serverConnect.Close;
      FreeAndNil(serverConnect);

      Exit;
    end;

    if Active then Active:=False;

    SQL.Clear;
    SQL.Add('insert into operators_disabled (date_time_create,sip,user_id) values ('+#39+date_time_create+#39+','
                                                                                    +#39+sip+#39+','
                                                                                    +#39+IntToStr(InUserID)+#39+')');

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);

             Exit;
          end;
      end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// �������� ��������.� �� �������������� ��������� ������������ true - ���������� ��������
function isExistSettingUsers(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(user_id) from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
    Active:=True;

    if Fields[0].Value<>0 then Result:=True
    else Result:=False;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ����������� �� TSettingUsersStatus --> Int
function SettingUsersStatusToInt(status:enumSettingUsersStatus):Integer;
begin
  case status of
    settingUsersStatus_ENABLED:   Result:= 1;
    settingUsersStatus_DISABLED:  Result:= 0;
  end;
end;


// ���������� ������������� �������� ������������
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers; status:enumSettingUsersStatus);
var
 response:string;
begin
   Screen.Cursor:=crHourGlass;

   case settings of
    settingUsers_gohome: begin // �� ���������� ������� �����

      // ��������� ���� �� ��� ������
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set go_home = '+#39+IntToStr(SettingUsersStatusToInt(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,go_home) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingUsersStatusToInt(status))+#39+')';
      end;
    end;
    settingUsers_noConfirmExit: begin
      // ��������� ���� �� ��� ������
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set no_confirmExit = '+#39+IntToStr(SettingUsersStatusToInt(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,no_confirmExit) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingUsersStatusToInt(status))+#39+')';
      end;
    end;
   end;

  // ��������� ������
  remoteCommand_Responce(response);

  Screen.Cursor:=crDefault;
end;

// ��������� ������ �� �������������� ���������� ������������
function getStatusIndividualSettingsUser(InUserID:Integer; settings:enumSettingUsers):enumSettingUsersStatus;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

begin
 if not isExistSettingUsers(InUserID) then begin
  Result:=settingUsersStatus_DISABLED;
  Exit;
 end;

 Result:=settingUsersStatus_DISABLED;

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

     SQL.Clear;
     case settings of
      settingUsers_gohome: begin // �� ���������� ������� �����
        SQL.Add('select go_home from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
      end;
      settingUsers_noConfirmExit:begin // �� ���������� "����� ������ �����?"
        SQL.Add('select no_confirmExit from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
      end;
     end;
    Active:=True;

    if Fields[0].Value<>null then begin
      if VarToStr(Fields[0].Value) = '1'  then Result:=settingUsersStatus_ENABLED
      else Result:=settingUsersStatus_DISABLED;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// ��������� �������������� �������� ������������
procedure LoadIndividualSettingUser(InUserId:Integer);
begin
  with HomeForm do begin
    // �� ���������� ������� �����
    if getStatusIndividualSettingsUser(InUserId,settingUsers_gohome) = settingUsersStatus_ENABLED then
    begin
       VisibleIconOperatorsGoHome(goHome_Hide);
       chkboxGoHome.Checked:=True;
    end
    else  VisibleIconOperatorsGoHome(goHome_Show);

  end;
end;


// ������� ����� ��������� �� ������� logging
function getLastStatusOperator(InUserId:Integer):enumLogging;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=eLog_unknown;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select action from logging where user_id = '+#39+IntToStr(InUserId)+#39+' order by date_time desc limit 1');

      Active:=True;

      if Fields[0].Value<>null then begin
        Result:=IntToTLogging(StrToInt(VarToStr(Fields[0].Value)));
      end;
    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;


// ������� ����� ��������� �� ������� operators
function getStatusOperator(InUserId:Integer):enumStatusOperators;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=eUnknown;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select status from operators where user_id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        Result:=IntegerToEnumStatusOperators(StrToInt(VarToStr(Fields[0].Value)));
      end;
    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;

// �������� ������������ IP ������
function getCheckIP(InIPAdtress:string):Boolean;
var
 countDelimiter:Word;
 i:Integer;
 test:string;
begin
  countDelimiter:=0;

  begin
     // ��������� ���-�� �����
    for i:=1 to Length(InIPAdtress) do begin
      if InIPAdtress[i] = '.' then Inc(countDelimiter);
    end;

    if countDelimiter <> 3 then begin
      Result:=False;
      Exit;
    end;
  end;

  // ��������� ����� ���� ������ �����
  for i:=1 to Length(InIPAdtress) do begin
    if InIPAdtress[i] <> '.' then begin
      if not (InIPAdtress[i] in ['0'..'9']) then begin
        Result:=False;
        Exit;
      end;
    end;
  end;

  Result:=True;
end;


// �������� �� �������������� ������ ������ ���, �� ����� ���� ������ ����!
function getCheckAlias(InAlias:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(alias) from server_ik where alias = '+#39+InAlias+#39);

      Active:=True;
      if Fields[0].Value<>0 then Result:=True;
    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;



// ��������� ��������������� ������ ��� ���������� � �� firebird
function GetFirbirdAuth(FBType:enumFirebirdAuth):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:='null';

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      case FBType of
       firebird_login:begin
         SQL.Add('select firebird_login from server_ik_fb');
       end;
       firebird_pwd:begin
         SQL.Add('select firebird_pwd from server_ik_fb');
       end;
      end;

      Active:=True;
      if Fields[0].Value<>null then begin
         Result:=VarToStr(Fields[0].Value);
      end;

    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;


// ����������� �� �����
function GetStatusMonitoring(status:Integer):enumMonitoringTrunk;
begin
  case status of
    0:Result:=monitoring_DISABLE;
    1:Result:=monitoring_ENABLE;
  end;
end;


// ��������� ���-�� �������� ��
function GetCountServersIK:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=0;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    try
      with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add('select count(id) from server_ik');

        Active:=True;
        Result:=StrToInt(VarToStr(Fields[0].Value));
      end;
    finally
      FreeAndNil(ado);
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
end;


// ��������� ������ ������������ ID ����
function GetOnlyOperatorsRoleID:TStringList;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countID:Cardinal;
begin
  Result:=TStringList.Create;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from role where id <> ''-1'' and only_operators = ''1'' ');

      Active:=True;
      countID:= Fields[0].Value;

      if countID<>0 then begin

        SQL.Clear;
        SQL.Add('select id from role where id <> ''-1'' and only_operators = ''1'' ');

        Active:=True;
        for i:=0 to countID-1 do begin
           Result.Add(VarToStr(Fields[0].Value));
           Next;
        end;
      end;

    end;
  finally
    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
  end;
end;


// ����������� ����������� ���� �� ��������� ���������
procedure ShowOperatorsStatus;
begin
  FormOperatorStatus.show;

  with HomeForm do begin
    PanelStatus.Visible:=False;
  end;
end;


// ��������� ������� ������ ������� ���������� � ����������� �� ������� �������� ����
procedure ResizeCentrePanelStatusOperators(WidthMainWindow:Integer);
var
 Diff:Integer;
 newLeft:Integer;
begin
 with HomeForm do begin
   Diff:=Round((WidthMainWindow - PanelStatus.Width) / 2);

   newLeft:=Panel_SIP.Left + Diff;

   // ����� �������� �� ������� � ���� ������
   if newLeft >= Panel_SIP.Left  then begin
     PanelStatus.Left:= Panel_SIP.Left + Diff;
   end
   else PanelStatus.Left:= Panel_SIP.Left;
 end;
end;


// ����������\�������� ���������� ������� �����
procedure VisibleIconOperatorsGoHome(InStatus:enumHideShowGoHomeOperators; InClick:Boolean = False);
begin
  with HomeForm do begin
    case InStatus of
     goHome_Hide:begin
       if InClick then begin
        saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_gohome,settingUsersStatus_ENABLED);
        chkboxGoHome.Checked:=True;
       end;


        if img_goHome_YES.Visible then begin
         img_goHome_YES.Visible:=False;
         img_goHome_NO.Visible:=True;
         img_goHome_NO.Left:=12;
        end;

      ST_operatorsHideCount.Visible:=True;
      ST_operatorsHideCount.Caption:='������: �������...';

     end;
     goHome_Show:begin

       if InClick then begin
        saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_gohome,settingUsersStatus_DISABLED);
        chkboxGoHome.Checked:=False;
       end;

        if img_goHome_NO.Visible then begin
         img_goHome_NO.Visible:=False;
         img_goHome_YES.Visible:=True;
         img_goHome_YES.Left:=12;
        end;

       ST_operatorsHideCount.Visible:=False;
     end;
    end;
  end;
end;

// �������� � ����� �����
procedure HappyNewYear;
var
  DateNachalo: TDateTime;
begin
  // ���������� ���� ������ ����
  DateNachalo := EncodeDateTime(YearOf(Now) + 1, 1, 1, 0, 0, 0, 0);

  // ���������, ��������� �� ������� ���� � ��������� �� 7 ���� �� ������ ���� � 8 ���� �����
  if (DaysBetween(Now, DateNachalo) <= 8) and (DaysBetween(Now, DateNachalo) >= -7) then
  begin
   HomeForm.ImgNewYear.Visible:=True;
   FormAbout.ImgNewYear.Visible:=True;
   FormAuth.ImgNewYear.Visible:=True;
  end;
end;

//���� �� ������ � ���������� ����
function GetExistAccessToLocalChat(InUserId:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select chat from users where id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
      end;
    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;


// �������� exe ���������� ����
procedure OpenLocalChat;
begin
 if not SharedCurrentUserLogon.GetIsAccessLocalChat then begin
    MessageBox(HomeForm.Handle,PChar('� ��� ��� ������� � ���������� ����'),PChar('������ �����������'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(CHAT_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('�� ������� ����� ���� '+CHAT_EXE),PChar('���� �� ������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  ShellExecute(HomeForm.Handle, 'Open', PChar(CHAT_EXE),PChar(CHAT_PARAM+' '+IntToStr(SharedCurrentUserLogon.GetID)),nil,SW_SHOW);
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


// ���� �� �������� ������ ���
function GetExistActiveSession(InUserID:Integer; var ActiveSession:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=False;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select pc,user_login_pc,last_active from active_session where user_id = '+#39+IntToStr(InUserID)+#39+' and last_active > '+#39+GetCurrentDateTimeDec(1)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        Result:=True;
        ActiveSession:=VarToStr(Fields[0].Value)+' ('+VarToStr(Fields[1].Value)+') - '+VarToStr(Fields[2].Value);
      end;
    end;

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
end;


// �������� �������� �� ������ ����������
function GetStatusUpdateService:Boolean;
begin
  Result:=GetTask(UPDATE_EXE);
end;

end.
