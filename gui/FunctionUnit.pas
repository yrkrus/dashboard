unit FunctionUnit;

interface

  uses
    Windows, Messages, SysUtils, Variants, Classes,
    Graphics, Controls, Forms, Dialogs, Registry,
    IniFiles, TlHelp32, IdBaseComponent, IdComponent,
    ShellAPI, StdCtrls, ComCtrls, ExtCtrls, WinSock,
    Math, IdHashCRC, Nb30, IdMessage, StrUtils, WinSvc,
    System.Win.ComObj, IdSMTP, IdText, IdSSL, IdSSLOpenSSL,
    IdAttachmentFile, DMUnit, FormHome, Data.Win.ADODB,
    Data.DB, IdIcmpClient, IdException, System.DateUtils,
    FIBDatabase, pFIBDatabase, TCustomTypeUnit, TUserUnit,
    Vcl.Menus, GlobalVariables, GlobalVariablesLinkDLL, TActiveSIPUnit, System.IOUtils,
    TLogFileUnit, Vcl.Buttons, IdGlobal;


procedure KillProcess;                                                               // �������������� ���������� ������
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;    // ����������� ���� �� ���������
function GetStatistics_day(inStatDay:enumStatistiscDay; _queue:enumQueueCurrent =queue_null):string;                      // ����������� ���� �� ����
procedure clearAllLists;                                                             // ������� ���� list's
procedure clearList_IVR(InFontSize:Word);                                            // ����������� ����� � �������� ��������
procedure clearList_QUEUE(InFontSize:Word);                                          // ������� listbox_QUEUE
procedure clearList_SIP(InWidth:Integer;InFontSize:Word);                            // ������� listbox_SIP
procedure createThreadDashboard;                                                     // �������� �������
function GetVersion(GUID:string; programm:enumProrgamm):string;                      // ����������� ������� ������
procedure showVersionAbout(programm:enumProrgamm);                                   // ����������� ������� ������
function GetVersionAbout(programm:enumProrgamm; inGUID:string):string;               // ����������� ������� ������ ��������� (������ ������� ������)
procedure CreateCheckServersInfoclinika;                                             // �������� ������ � ���������
procedure CreateCheckSipTrunk;                                                       // �������� ������ � sip ��������
//function GetRoleID(InRole:string):Integer;                                           // ��������� ID TRole
function GetUserGroupSTR(InGroup:Integer):string;                                    // ����������� ���� ������������
function getHashPwd(inPwd: String):Integer;                                          // ����������� ������
function GetUserGroupID(InGroup:string):Integer;                                     // ����������� ID ���� ������������
function getUserID(InLogin:string):Integer; overload;                                // ����������� ID ������������
function getUserID(InUserName,InUserFamiliya:string):Integer; overload;              // ��������� userID �� ���
function getUserID(InSIPNumber:integer):Integer; overload;                           // ��������� userID �� SIP ������
procedure LoadPanel_Users(InUserRole:enumRole; InShowDisableUsers:Boolean = False);  // ��������� ����� �������������
procedure LoadPanel_Operators;                                                       // ��������� ����� ������������� (���������)
function GetCheckLogin(inLogin:string):Boolean;                                      // ���������� �� login �������������
function DisableUser(InUserID:Integer; var _errorDescription:string):Boolean;        // ���������� ������������
procedure DeleteOperator(InUserID:Integer);                                          // �������� ������������ �� ������� operators
function getUserPwd(InUserID:Integer):Integer;                                       // ��������� userPwd �� userID
function getUserLogin(InUserID:Integer):string;                                      // ��������� userLogin �� userID
function GetUserRoleSTR(InUserID:Integer):string;                                    // ����������� ���� ������������
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;            // ���������t ����������� ������� � �������
function GetUserRePassword(InUserID:Integer):Boolean;                                // ���������� �� �������� ������ ��� �����
function UpdateUserPassword(InUserID,InUserNewPassword:Integer;
                            var _errorDescription:string):boolean;                   // ���������� ������ ������������
function getLocalIP: string;                                                         // ������� ��������� ���������� IP
procedure CreateCurrentActiveSession(InUserID:Integer);                              // ��������� �������� ������
function isExistCurrentActiveSession(InUserID:Integer):Boolean;                      // ���������� �� ������� ������
procedure DeleteActiveSession(InSessionID:Integer);                                  // �������� �������� ������
function GetActiveSessionUser(InUserID:Integer):Integer;                             // ���������� ID �������� ������ ������������
function isExistSipActiveOperator(InSip:string):Boolean;                             // �������� ������� �� ��� ����� �������� ��� ����� sip ������� � �� �������
procedure accessRights(var p_TUser: TUser);                                          // ����� �������
function getComputerPCName: string;                                                  // ������� ��������� ����� ��
function GetForceActiveSessionClosed(InUserID:Integer):Boolean;                      // �������� ����� �� ������� �������� ������
function GetSelectResponse(InStroka:string):Integer;                                 // ������ �� ���������� ������
procedure LoggingRemote(InLoggingID:enumLogging;_userID:Integer);                    // ����������� ��������
function GetUserFamiliyaName_LastSuccessEnter(InUser_login_pc,
                                              InUser_pc:string):string;              // ���������� userID ����� ��������� ����� �� ��
function GetCountAnsweredCall(InSipOperator:string):Integer;                         // ���-�� ���������� ������� ����������
function GetCountAnsweredCallAll:Integer;                                            // ���-�� ���������� ������� ���� ����������
function CreateListAnsweredCall(InSipOperator:string):TStringList;                   // ��������� ������ �� ���� ����������� ��������  sip ���������
//function remoteCommand_addQueue(_command:enumLogging;
//                                _userID:Integer;
//                                var _errorDescriptions:string):Boolean;              // ��������� ������� (���������� � �������)
procedure showWait(Status:enumShow_wait);                                            // �����������\������� ���� ������� �� ������
function remoteCommand_Responce(InStroka:string; var _errorDescriptions:string):boolean;  // �������� ������� �� ���������� ��������� �������
function getUserSIP(InIDUser:integer):string;                                        // ����������� SIP ������������
//function isExistRemoteCommand(command:enumLogging;_userID:Integer):Boolean;         // �������� ���� �� ��� ����� ��������� ������� �� �������
function getStatus(InStatus:enumStatusOperators):string;                             // ��������� ����� status ���������
function getCurrentQueueOperator(InSipNumber:string):enumQueueCurrent;               // � ����� ������� ������ ��������� ��������
procedure UpdateOperatorStatus(_status:enumStatusOperators;_userID:Integer);         // ������� �������� ������� ���������
procedure checkCurrentStatusOperator(InOperatorStatus:enumStatusOperators);              // �������� � ����������� ������ �������� ���������
procedure showStatusOperator(InShow:Boolean = True);                                 // ����������� ������ ������� ����������
function getLastStatusTime(InUserid:Integer; InOperatorStatus:enumStatusOperators):string;    // ������� ������� � ������� ������� ���������
function isOperatorGoHome(inUserID:Integer):Boolean;                                 // �������� �������� ���� ����� ��� ���
function isOperatorGoHomeWithForceClosed(inUserID:Integer):Boolean;                  // �������� �������� ���� ����� ��� ��� (����� ���������� �������� ������)
function getIsExitOperatorCurrentQueue(InCurrentRole:enumRole;InUserID:Integer):Boolean;// �������� ����� �������� ����� ����� �� �����
function GetLastStatusTimeOnHold(InStartTimeonHold:string):string;                   // ������� ������� � ������� OnHold
function getTranslate(Stroka: string):string;                                        // �������������� �� ��� - > ��������
//function getUserFIO(InUserID:Integer):string;                                      // ��������� ����� ������������ �� ��� UserID
function getUserFamiliya(InUserID:Integer):string;                                   // ��������� ������� ������������ �� ��� UserID
function getUserNameBD(InUserID:Integer):string;                                     // ��������� ����� ������������ �� ��� UserID
function IsUserOperator(InUserID:Integer):Boolean;                                   // �������� userID ����������� ��������� ��� ��� TRUE - ��������
procedure disableOperator(InUserId:Integer);                                         // ���������� ��������� � ������� ��� � ������� operators_disable
function EnableUser(InUserID:Integer; var _errorDescription:string):Boolean;             // ��������� ������������
function GetOperatorAccessDashboard(InSip:string):Boolean;                           // ���������� ������� �������� �� ������ ��������� ��� ���
function isExistSettingUsers(InUserID:Integer):Boolean;                              // �������� ��������.� �� �������������� ��������� ������������ true - ���������� ��������
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers;
                                    status:enumParamStatus);                     // ���������� ������������� �������� ������������
function getStatusIndividualSettingsUser(InUserID:Integer;
                                        settings:enumSettingUsers):enumParamStatus; // ��������� ������ �� �������������� ���������� ������������
procedure LoadIndividualSettingUser(InUserId:Integer);                               // ��������� �������������� �������� ������������
function getIsExitOperatorCurrentGoHome(InCurrentRole:enumRole;InUserID:Integer):Boolean; // �������� ����� �������� �� ��������� �������, ����� �������� ����� ������� "�����"
function GetLastStatusOperator(InUserId:Integer):enumLogging;                           // ������� ����� ��������� �� ������� logging
procedure CheckCurrentVersion;                                                       // �������� �� ���������� ������
function getCheckIP(InIPAdtress:string):Boolean;                                     // �������� ������������ IP ������
function getCheckAlias(InAlias:string):Boolean;                                      // �������� �� �������������� ������ ������ ���, �� ����� ���� ������ ����!
function GetFirbirdAuth(FBType:enumFirebirdAuth):string;                             // ��������� ��������������� ������ ��� ���������� � �� firebird
//function GetSMSAuth(SMSType:enumSMSAuth):string;                                     // ��������� ��������������� ������ ��� �������� SMS
function GetStatusMonitoring(status:Integer):enumMonitoringTrunk;                    // ����������� �� �����
function GetCountServersIK:Integer;                                                  // ��������� ���-�� �������� ��
procedure SetAccessMenu(InNameMenu:enumAccessList; InStatus: enumAccessStatus);      // ��������� ����������\������ �� ������ � ����
function GetOnlyOperatorsRoleID:TStringList;                                         // ��������� ������ ������������ ID ����
procedure ShowOperatorsStatus;                                                       // ����������� ����������� ���� �� ��������� ���������
procedure ResizeCentrePanelStatusOperators(WidthMainWindow:Integer);                 // ��������� ������� ������ ������� ���������� � ����������� �� ������� �������� ����
procedure VisibleIconOperatorsGoHome(InStatus:enumHideShowGoHomeOperators;
                                     InClick:Boolean = False);                       // ����������\�������� ���������� ������� �����

procedure Egg;                                                                       // ��������
procedure HappyNewYear;                                                              // �������� � ����� �����
procedure Mart8;                                                                     // �������� � 8 �����
function GetExistAccessToLocalChat(InUserId:Integer):Boolean;                        // ���� �� ������ � ���������� ����
function OpenMissedCalls(var _errorDescriptions:string;
                        _queue:enumQueueCurrent = queue_5000_5050;
                        _missed:enumMissed = eMissed_no_return):Boolean;                     // ������ � ����������� �������
procedure OpenLocalChat;                                                             // �������� exe ���������� ����
procedure OpenReports;                                                               // �������� exe �������
procedure OpenService;                                                               // �������� exe �����
procedure OpenSMS;                                                                   // �������� exe SMS ��������
function GetExistActiveSession(InUserID:Integer; var ActiveSession:string):Boolean;  // ���� �� �������� ������ ���
function GetStatusUpdateService:Boolean;                                             // �������� �������� �� ������ ����������
function getStatusOperator(InUserId:Integer):enumStatusOperators;                    // ������� ����� ��������� �� ������� operators
procedure ClearAfterUpdate;                                                          //  ������� �� ����� ��� �������� ����� ����������
function GetListAdminRole:TStringList;                                               // ��������� ������ ������������ � ����� �������������
procedure SetRandomFontColor(var p_label: TLabel);                                   // ��������� ����� �������
procedure ShowInfoNewVersionAfterUpdate(InGUID:string);                              // ����� ���������� � ����� ������
procedure ShowStatisticsCallsDay(InTypeStatisticsCalls: enumStatisticsCalls;         // ����������� ���������� �������� � ������� �� ������� ����
                                 InClick:Boolean = False);
function isExistMySQLConnector:Boolean;                                              // ���������� �� MySQL COnnector
procedure ShowFormErrorMessage(_errorMessage:string;
                               var p_Log:TLoggingFile;
                               const __METHOD_NAME__:string;
                               forceUpdate:Boolean = False);                         // ������������ ���� � �������
function GetNeedReconnectBase(const _errorMessage:string):enumNeedReconnectBD;       // �������� ����� �� ������������� reconnect � ����
function GetNowDateTimeDec(DecMinutes:Integer):string;                               // ������� ����� ������ ��� (����� ������)
function GetNowDateTime:string;                                                      // ������� ����� ������ ���
function GetFreeSpa�eDrive(InDrive:string):int64;                                    // ������� �������� ������� ���� ���������� ����� �� �����
function isExistFreeSpaceDrive(var _errorDescription:string):Boolean;                // �������� ���� �� ��������� ����� �� �����
procedure ChangeFontSize(InChange:enumFontChange; InTypeFont:enumFontSize);          // ��������� ������� ������ �� ������� ����� � TListView
procedure ForceUpdateDashboard(var p_ButtonClose:TBitBtn);                           // ������ ��������������� ����������
procedure WindowStateInit;                                                           // ����������� ������� ����� ���� ��� ��������
function GetProgrammUptime:int64;  overload;                                         // ������� uptime
function GetProgrammUptime(_uptime:Int64):string;  overload;                         // ������� uptime
function GetProgrammStarted:TDateTime;   overload;                                   // ����� ������� ���������(������� ������������)
function GetProgrammStarted(_userID:Integer):TDateTime;  overload;                   // ����� ������� ���������(����� ������������)
function GetProgrammStartedFirstLogon(_userID:Integer):TDateTime;                    // ����� ������� ��������� �� ������� ������
function GetProgrammExit(_userID:Integer):TDateTime;                                 // ����� �������� ��������� �� ������ ������
function GetPhoneTrunkQueue(_phone:string;_timecall:string):string;                  // ���������� �� ����� ����� ������ ����� ������� ���� � �������
function CreateRemoteCommandCallback(_action:enumRemoteCommandAction; _id:Integer;
                                      var _errorDescription:string): Boolean;        // �������� �� ��������� ������� ��� �������� ������ ��� ��� ������������ ������
function ExecuteCommandKillActiveSession(_userID:Integer;
                                         var _errorDescription:string):Boolean;      // ���������� ������� �������� �������� ������
//function remoteCommand_GetFailStr(_userId:Integer; var _errorDescriptions:string):string;             // ��������� ������ � ������� ��� ���������� ��������� �������
//function remoteCommand_IsFail(command:enumLogging;_userID:Integer):boolean;         // �������� �� ������ ��� ���������� ��������� ��������
function SendCommandStatusDelay(_userID:Integer):enumStatus;                          // ����� �� ������ �������� ��� ����� ������� ���������



implementation

uses
  FormPropushennieUnit,
  Thread_StatisticsUnit,
  Thread_IVRUnit,
  Thread_QUEUEUnit,
  Thread_ACTIVESIPUnit,
  FormAboutUnit,
  FormServerIKCheckUnit,
  Thread_CHECKSERVERSUnit,
  FormSettingsUnit,
  FormAuthUnit,
  FormErrorUnit,
  FormWaitUnit,
  Thread_AnsweredQueueUnit,
  FormUsersUnit,
  TTranslirtUnit,
  Thread_ACTIVESIP_updatetalkUnit,
  Thread_ACTIVESIP_updatePhoneTalkUnit,
  Thread_ACTIVESIP_countTalkUnit,
  Thread_ACTIVESIP_QueueUnit,
  FormActiveSessionUnit,
  TIVRUnit,
  FormOperatorStatusUnit,
  TXmlUnit,
  TOnlineChat,
  Thread_ChatUnit,
  Thread_ForecastUnit,
  Thread_InternalProcessUnit, TActiveSessionUnit, FormTrunkSipUnit, Thread_CheckTrunkUnit;




 // ����������� ��������
procedure LoggingRemote(InLoggingID:enumLogging; _userID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'LoggingRemote');
     FreeAndNil(ado);
     Exit;
  end;



   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;

        SQL.Add('insert into logging (ip,user_id,user_login_pc,pc,action) values ('+#39+SharedCurrentUserLogon.GetIP+#39+','
                                                                                   +#39+IntToStr(_userID)+#39+','
                                                                                   +#39+SharedCurrentUserLogon.GetUserLoginPC+#39+','
                                                                                   +#39+SharedCurrentUserLogon.GetPC+#39+','
                                                                                   +#39+IntToStr(EnumLoggingToInteger(InLoggingID))+#39+')');

        try
            ExecSQL;
        except
            on E:EIdException do begin
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;

               Exit;
            end;
        end;
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
    end;
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


//
//// ��������� ID TRole
//function GetRoleID(InRole:string):Integer;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// error:string;
//begin
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(error);
//
//  if not Assigned(serverConnect) then begin
//     ShowFormErrorMessage(error,SharedMainLog,'GetRoleID');
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//      SQL.Clear;
//      SQL.Add('select id from role where name_role = '+#39+InRole+#39);
//
//      Active:=True;
//      Result:=StrToInt(VarToStr(Fields[0].Value));
//    end;
//  finally
//    FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//     serverConnect.Close;
//     FreeAndNil(serverConnect);
//    end;
//  end;
//end;

// �������� �������
procedure createThreadDashboard;
begin
  with HomeForm do begin
     // ���������
    if STATISTICS_thread=nil then
    begin
     FreeAndNil(STATISTICS_thread);
     STATISTICS_thread:=Thread_Statistics.Create(True);
     STATISTICS_thread.Priority:=tpNormal;
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

    //CheckSipTrunks
    if CHECKSIPTRUNKS_thread=nil then
    begin
     FreeAndNil(CHECKSIPTRUNKS_thread);
     CHECKSIPTRUNKS_thread:=Thread_CheckTrunks.Create(True);
     CHECKSIPTRUNKS_thread.Priority:=tpNormal;
     UpdateCheckSipTrunksStop:=True;
    end
    else UpdateCheckSipTrunksStop:=True;


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


    // Forecast
    if FORECAST_thread=nil then
    begin
     FreeAndNil(FORECAST_thread);
     FORECAST_thread:=Thread_Forecast.Create(True);
     FORECAST_thread.Priority:=tpNormal;
     UpdateForecast:=True;
    end
    else UpdateForecast:=True;


    // InternalProcess
    if INTERNALPROCESS_thread=nil then
    begin
     FreeAndNil(INTERNALPROCESS_thread);
     INTERNALPROCESS_thread:=Thread_InternalProcess.Create(SharedCurrentUserLogon.GetID);
     INTERNALPROCESS_thread.Priority:=tpNormal;
     UpdateInternalProcess:=True;
    end
    else UpdateInternalProcess:=True;

    // ������ �������
    STATISTICS_thread.Start;
    Sleep(10);
    IVR_thread.Start;
    Sleep(10);
    QUEUE_thread.Start;
    Sleep(10);
    ACTIVESIP_thread.Start;
    Sleep(10);
    ACTIVESIP_Queue_thread.Start;
    Sleep(10);
    ACTIVESIP_countTalk_thread.Start;
    Sleep(10);
    ACTIVESIP_updateTalk_thread.Start;
    Sleep(10);
    ACTIVESIP_updateTalkPhone_thread.Start;
    Sleep(10);
    CHECKSERVERS_thread.Start;
    Sleep(10);
    CHECKSIPTRUNKS_thread.Start;
    Sleep(10);
    ANSWEREDQUEUE_thread.Start;
    Sleep(10);
    if SharedCurrentUserLogon.GetIsAccessLocalChat then ONLINECHAT_thread.Start;
    Sleep(10);
    FORECAST_thread.Start;
    Sleep(10);
    INTERNALPROCESS_thread.Start;
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
       if GetForceActiveSessionClosed(SharedCurrentUserLogon.GetID) then LoggingRemote(eLog_exit_force,SharedCurrentUserLogon.GetID)
       else
       begin
        // �������� �� ����� ������ ������ ������
        if SharedCurrentUserLogon.GetID<>0 then LoggingRemote(eLog_exit,SharedCurrentUserLogon.GetID);
       end;

       // ������� �������� ������� ���������
       UpdateOperatorStatus(eUnknown, SharedCurrentUserLogon.GetID);

       // �������� �������� ������
       DeleteActiveSession(GetActiveSessionUser(SharedCurrentUserLogon.GetID));
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

     // ��������� report_exe ���� ������
     countKillExe:=0;
     while GetTask(PChar(REPORT_EXE)) do begin
       KillTask(PChar(REPORT_EXE));

       // �� ������ ���� �� �������� ������� �������� exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;

      // ��������� sms_exe ���� ������
     countKillExe:=0;
     while GetTask(PChar(SMS_EXE)) do begin
       KillTask(PChar(SMS_EXE));

       // �� ������ ���� �� �������� ������� �������� exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;

     // ��������� service_exe ���� ������
     countKillExe:=0;
     while GetTask(PChar(SERVICE_EXE)) do begin
       KillTask(PChar(SERVICE_EXE));

       // �� ������ ���� �� �������� ������� �������� exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;

   finally
      KillProcessNow;
   end;
end;


// ������ �� ���������� ������
function GetSelectResponse(InStroka:string):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetSelectResponse');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
  finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
  end;

end;


// ����������� ���� �� ���������
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;
var
 select_response:string;
 s:TStringList;
begin
  case InQueueType of

    answered: begin    // ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(InQueueNumber)+#39
                                                                             +' and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetNowDateTime+#39;
    end;
    no_answered: begin  // �� ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(InQueueNumber)+#39
                                                                             +' and fail = ''1'' and date_time > '+#39+GetNowDateTime+#39;
    end;
    no_answered_return: begin  // �� ���������� + �����������
      select_response:='select count(distinct(phone)) from queue where number_queue='+#39+TQueueToString(InQueueNumber)+#39+
                                                                ' and fail =''1'' and date_time >'+#39+GetNowDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue ='+#39+TQueueToString(InQueueNumber)+#39+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetNowDateTime+#39+')';


    end;
    all_answered:begin  // ����� ����������
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToString(InQueueNumber)+#39
                                                                             +' and date_time > '+#39+GetNowDateTime+#39;
    end;
  end;



  Result:=IntToStr(GetSelectResponse(select_response));
end;


// ����������� ���� �� ����
function GetStatistics_day(inStatDay:enumStatistiscDay; _queue:enumQueueCurrent = queue_null):string;
var
resultat:string;
select_response:string;
answered:Integer;
procent:Double;
no_answered:string;

all_queue:string;

begin
  resultat:='null';
  if _queue = queue_null then begin
    all_queue:=#39+TQueueToString(queue_5000)+#39+','+#39+TQueueToString(queue_5050)+#39;
  end
  else begin
    all_queue:=#39+TQueueToString(_queue)+#39;
  end;

 with HomeForm do begin
    case inStatDay of
      stat_answered:begin
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetNowDateTime+#39;
       resultat:=IntToStr(GetSelectResponse(select_response));
      end;
      stat_no_answered:begin
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and fail = ''1'' and date_time > '+#39+GetNowDateTime+#39;
       resultat:=IntToStr(GetSelectResponse(select_response));
      end;
      stat_no_answered_return:begin
       select_response:='select count(distinct(phone)) from queue where number_queue in ('+all_queue+')'+
                                                                ' and fail =''1'' and date_time >'+#39+GetNowDateTime+#39+
                                                                ' and phone not in (select phone from queue where number_queue in ('+all_queue+')'+
                                                                ' and answered  = ''1'' and date_time > +'#39+GetNowDateTime+#39+')';


       resultat:=IntToStr(GetSelectResponse(select_response));
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
       select_response:='select count(phone) from queue where number_queue in ('+all_queue+') and date_time > '+#39+GetNowDateTime+#39;
       resultat:=IntToStr(GetSelectResponse(select_response));
      end;
    end;
 end;

  Result:=resultat;
end;

// ������� ���� list's
procedure clearAllLists;
var
 XML:TXML;
 i:Integer;
 fontSize:enumFontSize;
begin
  // ��������� ������ �������� � ������� � ������
  begin
    XML:=TXML.Create;
    for i:=Ord(Low(enumFontSize)) to Ord(High(enumFontSize)) do
    begin
      fontSize:=enumFontSize(i);
      SharedFontSize.SetSize(fontSize, XML.GetFontSize(fontSize));
    end;
    XML.Free;
  end;

  clearList_IVR(SharedFontSize.GetSize(eIvr));
  clearList_QUEUE(SharedFontSize.GetSize(eQueue));
  clearList_SIP(HomeForm.Panel_SIP.Width, SharedFontSize.GetSize(eActiveSip));
end;

// ������� listbox_IVR
procedure clearList_IVR(InFontSize:Word);
 const
 cWidth_default         :Word = 335;
 cProcentWidth_phone    :Word = 40;
 cProcentWidth_waiting  :Word = 30;
 cProcentWidth_trunk    :Word = 30;

begin
 with HomeForm do begin

   lblCount_IVR.Caption:='IVR';

   ListViewIVR.Columns.Clear;

   with ListViewIVR do begin
     ViewStyle:= vsReport;
     Font.Size:=InFontSize;

      with Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with Columns.Add do
      begin
        Caption:='����� ��������';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((cWidth_default*cProcentWidth_trunk)/100);
        Alignment:=taCenter;
      end;
   end;
 end;
end;


// ������� listbox_SIP
procedure clearList_SIP(InWidth:Integer; InFontSize:Word);
 const
 //cWidth_default           :Word = 1094;
 cProcentWidth_operator   :Word = 27;
 cProcentWidth_status     :Word = 13;
 cProcentWidth_responce   :Word = 9;
 cProcentWidth_trunk      :Word = 9;
 cProcentWidth_phone      :Word = 9;
 cProcentWidth_talk       :Word = 11;
 cProcentWidth_queue      :Word = 8;
 cProcentWidth_time       :Word = 14;

 var // ��� ������
  test_size_operator,
  test_size_status,
  test_size_responce,
  test_size_trunk,
  test_size_phone,
  test_size_talk,
  test_size_queue,
  test_size_time:Word;

begin
 with HomeForm do begin
   Panel_SIP.Width:=InWidth;
   STlist_ACTIVESIP_NO_Rings.Width:=InWidth;  // ������� ��� ��� �������

   ListViewSIP.Columns.Clear;

   lblCount_ACTIVESIP.Caption:='�������� ������ | ��������� ���������';

   with ListViewSIP do begin
     ViewStyle:= vsReport;
     Font.Size:=InFontSize;

      with Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((InWidth*cProcentWidth_operator)/100);
        test_size_operator:=Width;

        Alignment:=taLeftJustify;
      end;

      with Columns.Add do
      begin
        Caption:='������';
        Width:=Round((InWidth*cProcentWidth_status)/100);
        test_size_status:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((InWidth*cProcentWidth_responce)/100);
        test_size_responce:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((InWidth*cProcentWidth_trunk)/100);
        test_size_trunk:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�����';
        Width:=Round((InWidth*cProcentWidth_phone)/100);
        test_size_phone:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='����� ���������';
        Width:=Round((InWidth*cProcentWidth_talk)/100);
        test_size_talk:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�������';
        Width:=Round((InWidth*cProcentWidth_queue)/100);
        test_size_queue:=Width;

        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='����. ����� | �����';
        Width:=Round((InWidth*cProcentWidth_time)/100);
        test_size_time:=Width;

        Alignment:=taCenter;
      end;
   end;
 end;
end;

// ������� listbox_QUEUE
procedure clearList_QUEUE(InFontSize:Word);
 const
 cWidth_default         :Word = 335;
 cProcentWidth_phone    :Word = 40;
 cProcentWidth_waiting  :Word = 30;
 cProcentWidth_queue    :Word = 30;
begin
 with HomeForm do begin

   lblCount_QUEUE.Caption:='�������';

   ListViewQueue.Columns.Clear;

   with ListViewQueue do begin
     ViewStyle:= vsReport;
     Font.Size:=InFontSize;

      with Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with Columns.Add do
      begin
        Caption:='����� ��������';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='��������';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='�������';
        Width:=Round((cWidth_default*cProcentWidth_queue)/100);
        Alignment:=taCenter;
      end;
   end;

 end;
end;

// ���������� ����������� ������� � �������
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;
var
 correctTime,delta_time:Integer;
begin
  // ������ ��������� ����� ��� ������ �������
  try
    delta_time:=GetIVRTimeQueue(InQueue);
  except
    delta_time:=-1;
    Result:='null';
    Exit;
  end;

  // ��������� ����� � �������
  correctTime:=getTimeAnsweredToSeconds(InTime) - delta_time;

  Result:=GetTimeAnsweredSecondsToString(correctTime);
end;

// ���-�� ���������� ������� ����������
 function GetCountAnsweredCall(InSipOperator:string):Integer;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
begin
    ado:=TADOQuery.Create(nil);
    serverConnect:=createServerConnect;
    if not Assigned(serverConnect) then begin
       FreeAndNil(ado);
       Exit;
    end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(phone) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+InSipOperator+#39+' and answered = ''1'' and fail = ''0'' and hash is not null' );
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:=0;
    end;
  finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
  end;
end;


// ���-�� ���������� ������� ���� ����������
 function GetCountAnsweredCallAll:Integer;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

 try
  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(phone) from queue where date_time > '+#39+GetNowDateTime+#39+' and answered = ''1'' and fail = ''0'' and hash is not null' );
    Active:=True;

    if Fields[0].Value<>null then Result:=Fields[0].Value;

  end;
 finally
  FreeAndNil(ado);
  if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
  end;
 end;
end;


// ��������� ������ �� ���� ����������� ��������  sip ���������
function CreateListAnsweredCall(InSipOperator:string):TStringList;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  countTalk:Integer;
  i:Integer;
begin
   Result:=TStringList.Create;
   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;

    if not Assigned(serverConnect) then begin
       FreeAndNil(ado);
       Exit;
    end;

    // ���-�� �������
    countTalk:=GetCountAnsweredCall(InSipOperator);

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select talk_time from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+InSipOperator+#39+' and answered = ''1'' and fail = ''0''and hash is not null' );
      Active:=True;

      for i:=0 to countTalk-1 do begin
       Result.Add(Fields[0].Value);
       ado.Next;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
       serverConnect.Close;
       FreeAndNil(serverConnect);
    end;
  end;
end;


// ����������� ������� ������
function GetVersion(GUID:string; programm:enumProrgamm):string;
var
 ado:TADOQuery;
 serverConnect: TADOConnection;
 error:string;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetVersion');
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select version,bild from version_update where guid = '+#39+GUID+#39+' and programm = '+#39+EnumProgrammToString(programm)+#39+' order by id DESC limit 1');
      Active:=True;

      if (Fields[0].Value<>null) and (Fields[1].Value<>null) then  Result:='v.'+Fields[0].Value+' bild '+Fields[1].Value;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ����������� ������� ������ ���������
procedure showVersionAbout(programm:enumProrgamm);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countVersion,i:Integer;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'showVersionAbout');
     FreeAndNil(ado);
     Exit;
  end;


   try
     with ado do begin
        ado.Connection:=serverConnect;

        SQL.Clear;
        SQL.Add('select count(id) from version_update where programm = '+#39+EnumProgrammToString(programm)+#39);
        Active:=True;

        countVersion:=Fields[0].Value;

        SQL.Clear;
        SQL.Add('select date_update,version,update_text from version_update where programm = '+#39+EnumProgrammToString(programm)+#39+' order by date_update DESC');
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
                   ado.Next;
                end;

                REHistory_GUI.SelStart:=0;
                STInfoVersionGUI.Caption:=GetVersion(GUID_VERSION,programm);
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
                   ado.Next;
                end;

                REHistory_CHAT.SelStart:=0;
                STInfoVersionCHAT.Caption:=GetVersion(GUID_VERSION,programm);
              end;
              eREPORT:begin
                REHistory_REPORT.Clear;

                for i:=0 to countVersion-1 do begin
                     with REHistory_REPORT do begin
                      Lines.Add('������ '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
                      Lines.Add(Fields[2].Value);
                      Lines.Add('');
                      Lines.Add('');
                      Lines.Add('');
                     end;
                   ado.Next;
                end;

                REHistory_REPORT.SelStart:=0;
                STInfoVersionREPORT.Caption:=GetVersion(GUID_VERSION,programm);
              end;
              eSMS:begin
                REHistory_SMS.Clear;

                for i:=0 to countVersion-1 do begin
                     with REHistory_SMS do begin
                      Lines.Add('������ '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
                      Lines.Add(Fields[2].Value);
                      Lines.Add('');
                      Lines.Add('');
                      Lines.Add('');
                     end;
                   ado.Next;
                end;

                REHistory_SMS.SelStart:=0;
                STInfoVersionSMS.Caption:=GetVersion(GUID_VERSION,programm);
              end;
           end;
        end;
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
end;


// ����������� ������� ������ ��������� (������ ������� ������)
function GetVersionAbout(programm:enumProrgamm; inGUID:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetVersionAbout');
     FreeAndNil(ado);
     Exit;
  end;


   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add('select date_update,version,update_text from version_update where programm = '+#39+EnumProgrammToString(programm)+#39+' and guid = '+#39+inGUID+#39+' order by date_update DESC');
        Active:=True;

        Result:=VarToStr(Fields[2].Value);
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
end;


// �������� ������ � ���������
procedure CreateCheckServersInfoclinika;
const
cTOPSTART=35;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 i:Integer;
 countServers:Integer;

 lblStatusServer:   TArray<TLabel>;
 lblAddressServer:  TArray<TLabel>;
 lblIP:             TArray<TLabel>;
 nameIP:string;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'CreateCheckServersInfoclinika');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
             Exit;
          end;
      end;

      if countServers>=1 then begin

        // ���������� �����������
        SetLength(lblStatusServer,countServers);
        SetLength(lblAddressServer,countServers);
        SetLength(lblIP,countServers);

        SQL.Clear;
        SQL.Add('select id,ip,address,status from server_ik order by ip ASC');

        try
          Active:=True;
        except
            on E:EIdException do begin
               CodOshibki:=e.Message;
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;

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
            lblStatusServer[i].Font.Size:=10;
            lblStatusServer[i].Font.Style:=[fsBold];
            lblStatusServer[i].AutoSize:=False;
            lblStatusServer[i].Width:=90;
            lblStatusServer[i].Height:=19;
            lblStatusServer[i].Alignment:=taCenter;
            lblStatusServer[i].Parent:=FormServerIKCheck;
          end;

          // �����
          begin
            lblAddressServer[i]:=TLabel.Create(FormServerIKCheck);
            lblAddressServer[i].Name:='lblAddr_'+nameIP;
            lblAddressServer[i].Tag:=1;

            if VarToStr(Fields[3].Value) = '0' then begin  // ������� �� �������
              lblAddressServer[i].Caption:=VarToStr(Fields[2].Value)+' ('+EnumStatusJobClinicToString(eClose) +')';
              lblAddressServer[i].Font.Style:=[fsStrikeOut];
            end
            else lblAddressServer[i].Caption:=VarToStr(Fields[2].Value);

            lblAddressServer[i].Left:=109;

            if i=0 then lblAddressServer[i].Top:=cTOPSTART
            else lblAddressServer[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

            lblAddressServer[i].Font.Name:='Tahoma';
            lblAddressServer[i].Font.Size:=10;
            lblAddressServer[i].AutoSize:=False;
            lblAddressServer[i].Width:=333;
            lblAddressServer[i].Height:=19;
            lblAddressServer[i].Alignment:=taCenter;
            lblAddressServer[i].Parent:=FormServerIKCheck;
          end;

          // IP
          begin
            lblIP[i]:=TLabel.Create(FormServerIKCheck);
            lblIP[i].Name:='lblIP_'+nameIP;
            lblIP[i].Tag:=1;
            lblIP[i].Caption:=VarToStr(Fields[1].Value);
            lblIP[i].Left:=454;

            if i=0 then lblIP[i].Top:=cTOPSTART
            else lblIP[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

            lblIP[i].Font.Name:='Tahoma';
            lblIP[i].Font.Size:=10;
            lblIP[i].AutoSize:=False;
            lblIP[i].Width:=144;
            lblIP[i].Height:=19;
            lblIP[i].Alignment:=taCenter;
            lblIP[i].Parent:=FormServerIKCheck;
          end;

          ado.Next;
        end;
      end;

   end;

   FormServerIKCheck.Caption:=FormServerIKCheck.Caption+' ('+IntToStr(countServers)+')';
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// �������� ������ � sip ��������
procedure CreateCheckSipTrunk;
const
cTOPSTART=35;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 i:Integer;
 countTrunk:Integer;

 lblStatusTrunk:  TArray<TLabel>;
 lblNameTrunk:    TArray<TLabel>;
 lblTimeUpdate:   TArray<TLabel>;
 nameTrunk:string;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'CreateCheckSipTrunk');
     FreeAndNil(ado);
     Exit;
  end;


  try
   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from sip_trunks where is_monitoring = ''1'' ');

      try
          Active:=True;
          countTrunk:=Fields[0].Value;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
             Exit;
          end;
      end;

      if countTrunk>=1 then begin

        // ���������� �����������
        SetLength(lblStatusTrunk,countTrunk);
        SetLength(lblNameTrunk,countTrunk);
        SetLength(lblTimeUpdate,countTrunk);


        SQL.Clear;
        SQL.Add('select id,alias,date_time_update from sip_trunks where is_monitoring = ''1'' ');

        try
          Active:=True;
        except
            on E:EIdException do begin
               CodOshibki:=e.Message;
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;

               Exit;
            end;
        end;


        for i:=0 to countTrunk-1 do begin

          // ������
          begin
            nameTrunk:=VarToStr(Fields[0].Value);

            lblStatusTrunk[i]:=TLabel.Create(FormTrunkSip);
            lblStatusTrunk[i].Name:='lbl_'+nameTrunk;
            lblStatusTrunk[i].Tag:=1;
            lblStatusTrunk[i].Caption:='��������';
            lblStatusTrunk[i].Left:=8;

            if i=0 then lblStatusTrunk[i].Top:=cTOPSTART
            else lblStatusTrunk[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

            lblStatusTrunk[i].Font.Name:='Tahoma';
            lblStatusTrunk[i].Font.Size:=10;
            lblStatusTrunk[i].Font.Style:=[fsBold];
            lblStatusTrunk[i].AutoSize:=False;
            lblStatusTrunk[i].Width:=120;
            lblStatusTrunk[i].Height:=19;
            lblStatusTrunk[i].Alignment:=taCenter;
            lblStatusTrunk[i].Parent:=FormTrunkSip;
          end;

          // �������� ������
          begin
            lblNameTrunk[i]:=TLabel.Create(FormTrunkSip);
            lblNameTrunk[i].Name:='lblName_'+nameTrunk;
            lblNameTrunk[i].Tag:=1;
            lblNameTrunk[i].Caption:=VarToStr(Fields[1].Value);
            lblNameTrunk[i].Left:=140;

            if i=0 then lblNameTrunk[i].Top:=cTOPSTART
            else lblNameTrunk[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

            lblNameTrunk[i].Font.Name:='Tahoma';
            lblNameTrunk[i].Font.Size:=10;
            lblNameTrunk[i].AutoSize:=False;
            lblNameTrunk[i].Width:=160;
            lblNameTrunk[i].Height:=19;
            lblNameTrunk[i].Alignment:=taCenter;
            lblNameTrunk[i].Parent:=FormTrunkSip;
          end;

          // ����� ����������
          begin
            lblTimeUpdate[i]:=TLabel.Create(FormTrunkSip);
            lblTimeUpdate[i].Name:='lblTime_'+nameTrunk;
            lblTimeUpdate[i].Tag:=1;
            lblTimeUpdate[i].Caption:=VarToStr(Fields[2].Value);
            lblTimeUpdate[i].Left:=314;

            if i=0 then lblTimeUpdate[i].Top:=cTOPSTART
            else lblTimeUpdate[i].Top:=cTOPSTART+(Round(cTOPSTART/2)*i);

            lblTimeUpdate[i].Font.Name:='Tahoma';
            lblTimeUpdate[i].Font.Size:=10;
            lblTimeUpdate[i].AutoSize:=False;
            lblTimeUpdate[i].Width:=160;
            lblTimeUpdate[i].Height:=19;
            lblTimeUpdate[i].Alignment:=taCenter;
            lblTimeUpdate[i].Parent:=FormTrunkSip;
          end;

          ado.Next;
        end;
      end;

   end;

   FormTrunkSip.Caption:=FormTrunkSip.Caption+' ('+IntToStr(countTrunk)+')';
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ����������� ���� ������������
function GetUserGroupSTR(InGroup:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetUserGroupSTR');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select name_role from role where id = '+#39+IntToStr(InGroup)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:='null';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ����������� ���� ������������
function GetUserRoleSTR(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetUserRoleSTR');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select name_role from role where id = (select role from users where id = '+#39+IntToStr(InUserID)+#39+')' );
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:='null';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���������� ������� �������� �� ������ ��������� ��� ���
function GetOperatorAccessDashboard(InSip:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
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
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���������� �� �������� ������ ��� �����
function GetUserRePassword(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetUserRePassword');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select is_need_reset_pwd from users where id = '+#39+IntToStr(InUserID)+#39);
      Active:=True;

      if Fields[0].Value=0 then Result:=False
      else Result:=True;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

end;


// ����������� ID ���� ������������
function GetUserGroupID(InGroup:string):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'GetUserGroupID');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select id from role where name_role = '+#39+InGroup+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:= -1;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ����������� ID ������������
function getUserID(InLogin:string):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select id from users where login = '+#39+InLogin+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:= -1;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ����������� SIP ������������
function getUserSIP(InIDUser:integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InIDUser)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value);
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� ����� �������������
procedure LoadPanel_Users(InUserRole:enumRole; InShowDisableUsers:Boolean = False);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 only_operators_roleID:TStringList;
 id_operators:string;
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'LoadPanel_Users');
     FreeAndNil(ado);
     Exit;
  end;


  try
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

             ado.Next;
           end;

           FormUsers.Caption:='������������: '+IntToStr(countUsers);

        end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;

    Screen.Cursor:=crDefault;
  end;

end;



// ��������� ����� ������������� (���������)
procedure LoadPanel_Operators;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers,i:Integer;
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error,SharedMainLog,'LoadPanel_Operators');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
           Cells[1,i]:=GetUserNameOperators(Fields[1].Value);     // ������� ���
           Cells[2,i]:=Fields[1].Value;                           // Sip
           if Fields[3].Value<>null then Cells[3,i]:=Fields[3].Value
           else Cells[3,i]:='null';
           Cells[4,i]:=getUserRoleSTR( StrToInt(Fields[2].Value) );  // ������ ����

           ado.Next;
         end;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   Screen.Cursor:=crDefault;
  end;
end;


// ���������� �� login �������������
function GetCheckLogin(inLogin:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'GetCheckLogin');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� userID �� ���
function getUserID(InUserName,InUserFamiliya:string):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
 end;

 try
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
 finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
 end;
end;


// ��������� userID �� SIP ������
function getUserID(InSIPNumber:integer):Integer; overload;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
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
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� userPwd �� userID
function getUserPwd(InUserID:Integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'getUserPwd');
     FreeAndNil(ado);
     Exit;
  end;

  try
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
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� userLogin �� userID
function getUserLogin(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
   ShowFormErrorMessage(error, SharedMainLog, 'getUserLogin');
   FreeAndNil(ado);
   Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select login from users where id = '+#39+IntToStr(InUserID)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:= 'null';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;



// ��������� ����� status ���������
function getStatus(InStatus:enumStatusOperators):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select status from status where id = '+#39+IntToStr(EnumStatusOperatorsToInteger(InStatus))+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value)
      else Result:='---';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ���������� ������������
function DisableUser(InUserID:Integer; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     _errorDescription:=error;
     ShowFormErrorMessage(error, SharedMainLog, 'DisableUser');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update users set disabled = ''1'' where id = '+#39+IntToStr(InUserID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:='�� ������� ��������� ������������'+#13+e.Message;
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

             Exit;
          end;
      end;

      // �������� ������������ ����������� ������ ����������
      if IsUserOperator(InUserID) then begin
        disableOperator(InUserID);
        deleteOperator(InUserID);
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Result:=True;
end;


// ��������� ������������
function EnableUser(InUserID:Integer; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     _errorDescription:=error;
     ShowFormErrorMessage(error, SharedMainLog, 'EnableUser');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update users set disabled = ''0'' where id = '+#39+IntToStr(InUserID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:='�� ������� �������� ������������'+#13+e.Message;
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;


             Exit;
          end;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Result:=True;
end;


// �������� ������������ �� ������� operators
procedure DeleteOperator(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 error:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'DeleteOperator');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;

             Exit;
          end;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���������� userID ����� ��������� ����� �� ��
function GetUserFamiliyaName_LastSuccessEnter(InUser_login_pc,InUser_pc:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'GetUserFamiliyaName_LastSuccessEnter');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select familiya,name from users where id = (select user_id  from logging where user_login_pc='+#39+InUser_login_pc+#39+' and pc='+#39+InUser_pc+#39+' and action='+#39+IntToStr(EnumLoggingToInteger(eLog_enter))+#39+' order by date_time DESC limit 1) and disabled =''0'' ');

      Active:=True;

      // ���� ��� � ��������, �� ������� � ������� history_logging
      if Fields[0].Value = null then begin
        SQL.Clear;
        SQL.Add('select familiya,name from users where id = (select user_id  from history_logging where user_login_pc='+#39+InUser_login_pc+#39+' and pc='+#39+InUser_pc+#39+' and action='+#39+IntToStr(EnumLoggingToInteger(eLog_enter))+#39+' order by date_time DESC limit 1) and disabled =''0'' ');

        Active:=True;

        if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
        else Result:='null';

      end
      else begin
        if Fields[0].Value<>null then Result:=Fields[0].Value+' '+Fields[1].Value
        else Result:='null';
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ���������� ������ ������������
function UpdateUserPassword(InUserID,InUserNewPassword:Integer; var _errorDescription:string):boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'UpdateUserPassword');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('update users set pass = '+#39+IntToStr(InUserNewPassword)+#39+', is_need_reset_pwd= ''0'' where id = '+#39+IntToStr(InUserID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:='�� ������� �������� ������'+#13+e.Message;
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;

    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

   Result:=True;
end;


// ���������� �� ������
function isExistCurrentActiveSession(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'isExistCurrentActiveSession');
     FreeAndNil(ado);
     Exit;
  end;


  try
     with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(id) from active_session where user_id ='+#39+IntToStr(InUserID)+#39);

      Active:=True;

      if Fields[0].Value=0 then Result:=False
      else Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ���������� ID �������� ������ ������������
function GetActiveSessionUser(InUserID:Integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'GetActiveSessionUser');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select id from active_session where user_id ='+#39+IntToStr(InUserID)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        Result:=Fields[0].Value;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// �������� �������� ������
procedure DeleteActiveSession(InSessionID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'DeleteActiveSession');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      SQL.Add('delete from active_session where id = '+#39+IntToStr(InSessionID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ��������� �������� ������
procedure CreateCurrentActiveSession(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 ip,user_pc,pc_name:string;
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  //��������� ���� �� ��� ����� ������
   if isExistCurrentActiveSession(InUserID) then begin
     // ������� �������� ������
     DeleteActiveSession(GetActiveSessionUser(InUserID));
   end;



  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     ShowFormErrorMessage(error, SharedMainLog, 'CreateCurrentActiveSession');
     FreeAndNil(ado);
     Exit;
  end;



  ip:=SharedCurrentUserLogon.GetIP;
  user_pc:=SharedCurrentUserLogon.GetUserLoginPC;
  pc_name:=SharedCurrentUserLogon.GetPC;

  try
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
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
               end;

               Exit;
            end;
        end;
     end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Screen.Cursor:=crDefault;
end;


// �������� ������� �� ��� ����� �������� ��� ����� sip ������� � �� �������
function isExistSipActiveOperator(InSip:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'isExistSipActiveOperator');
     FreeAndNil(ado);
     Exit;
  end;


  try
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
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� ������� ������������ �� ��� UserID
function getUserFamiliya(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'getUserFamiliya');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select familiya from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:='null';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� ����� ������������ �� ��� UserID
function getUserNameBD(InUserID:Integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'getUserNameBD');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select name from users where id = '+#39+IntToStr(InUserID)+#39);

      Active:=True;

      if Fields[0].Value<>null then Result:=Fields[0].Value
      else Result:='null';
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ����������� ������ ������� ����������
procedure showStatusOperator(InShow:Boolean = True);
begin
   with HomeForm do begin
      if InShow then begin
       ST_StatusPanel.Visible:=True;
      // img_ShowOperatorStatus.Visible:=True;
       PanelStatus.Visible:=True;
      end
      else begin
       ST_StatusPanel.Visible:=False;
      // img_ShowOperatorStatus.Visible:=False;
       PanelStatus.Visible:=False;
      end;
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
  MenuItem:=FindMenuItem(HomeForm.FooterMenu.Items, EnumAccessListToString(InNameMenu));
  if Assigned(MenuItem) then
  begin
    MenuItem.Enabled := EnumAccessStatusToBool(InStatus);
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

     case p_TUser.GetRole of
       role_administrator:begin                  // �������������
        // ������ ������� ����������
        showStatusOperator(False);
       end;
       role_lead_operator:begin                  // ������� ��������
        // ������ ������� ����������
        showStatusOperator;
       end;
       role_senior_operator:begin                // ������� ��������
        // ������ ������� ����������
        showStatusOperator;

        // ����������� ���� (���������)
        ListViewSIP.PopupMenu:=nil;
       end;
       role_operator:begin                       // ��������
        // ������ ������� ����������
        showStatusOperator;

        // ����������� ���� (���������)
        ListViewSIP.PopupMenu:=nil;
       end;
       role_operator_no_dash:begin               // �������� (��� ��������)
        // ������ ������� ����������
        showStatusOperator;

        // ����������� ���� (���������)
        ListViewSIP.PopupMenu:=nil;
       end;
       role_supervisor_cov:begin                 // ������������ ���
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
function GetForceActiveSessionClosed(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);
  if not Assigned(serverConnect) then begin
     ShowFormErrorMessage(error, SharedMainLog, 'GetForceActiveSessionClosed');
     FreeAndNil(ado);
     Exit;
  end;

  try
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
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// �������� �� ���������� ������
procedure CheckCurrentVersion;
var
 remoteVersion:string;
 XML:TXML;
 error:string;
 force_update:Boolean;
begin
  remoteVersion:=GetRemoteVersionDashboard(error);

  if remoteVersion = 'null' then begin
   error:='������ ��������� ������� ������ ��������'+#13#13+
           error+#13#13+
          '��� ��: '+getComputerPCName;

   ShowFormErrorMessage(error,SharedMainLog,'CheckCurrentVersion');

   KillProcess;
  end;

  if GUID_VERSION <> remoteVersion then begin

    if GetStatusUpdateService then begin
      error:='������� ������ ��������� ���������� �� ���������� ������'+#13#13
              +'���������� � ����� �� ��� �������� ������� �� ������'+#13
              +'"�������������� ����������"' +#13#13
              +'��� ��: '+getComputerPCName;

      force_update:=True;
    end
    else begin
       error:='������� ������ ��������� ���������� �� ���������� ������'+#13#13
          +'������ ��������������� ���������� �� ��������'+#13
          +'���������� � ����� ��' +#13#13
          +'��� ��: '+getComputerPCName;

      force_update:=False;
    end;

   ShowFormErrorMessage(error,SharedMainLog,'CheckCurrentVersion',force_update);

   KillProcess;
  end;

  // ������� ������� ������ ��������
  begin
   if FileExists(SETTINGS_XML) then begin
    XML:=TXML.Create(PChar(SETTINGS_XML));
    // ��������� �������
    XML.UpdateCurrentVersion(PChar(GUID_VERSION));
   end
   else begin
    XML:=TXML.Create(PChar(SETTINGS_XML),PChar(GUID_VERSION));
   end;
   XML.Free;
  end;
end;

// �����������\������� ���� ������� �� ������
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     // ������������� ���������� ������ ��������
     HomeForm.PanelStatusIN.Height:=cPanelStatusHeight_default;
     FormOperatorStatus.Height:=FormOperatorStatus.cHeightStart;

     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// �������� ������� �� ���������� ��������� �������
function remoteCommand_Responce(InStroka:string; var _errorDescriptions:string):boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  _errorDescriptions:='';
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescriptions);

  if not Assigned(serverConnect) then begin
     Result:=False;
     FreeAndNil(ado);
     Exit;
  end;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(InStroka);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               Result:=False;

               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;
               _errorDescriptions:='���������� ������ �������'+#13#13+e.ClassName+': '+e.Message;
               Exit;
            end;
        end;
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;

  Result:=True;
end;


//// ��������� ������ � ������� ��� ���������� ��������� �������
//function remoteCommand_GetFailStr(_userId:Integer; var _errorDescriptions:string):string;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// error:string;
//begin
//  Result:='������� �������';
//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(error);
//  if not Assigned(serverConnect) then begin
//     ShowFormErrorMessage(error, SharedMainLog, 'remoteCommand_GetFailStr');
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//
//      SQL.Clear;
//      SQL.Add('select error_str from remote_commands where error = ''1'' and user_id = '+#39+IntToStr(_userId)+#39);
//
//      Active:=True;
//
//      if ((Fields[0].Value<>null) and (VarToStr(Fields[0].Value) <> '')) then Result:=VarToStr(Fields[0].Value);
//
//    end;
//  finally
//   FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//end;


// �������� �� ������ ��� ���������� ��������� ��������
//function remoteCommand_IsFail(command:enumLogging;_userID:Integer):boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// error:string;
//begin
//  Result:=False;
//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(error);
//
//  if not Assigned(serverConnect) then begin
//     ShowFormErrorMessage(error, SharedMainLog, 'remoteCommand_IsExistFail');
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//
//      SQL.Clear;
//      SQL.Add('select error from remote_commands where command = '+#39+inttostr(EnumLoggingToInteger(command)) +#39+' and user_id = '+#39+IntToStr(_userID)+#39);
//      Active:=True;
//
//      if Fields[0].Value<>null then begin
//        if VarToStr(Fields[0].Value) = '1' then Result:=True
//        else Result:=False;
//      end;
//
//    end;
//  finally
//    FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//end;

// �������� ���� �� ��� ����� ��������� ������� �� �������
//function isExistRemoteCommand(command:enumLogging;_userID:Integer):Boolean;
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
// error:string;
//begin
//  Result:=False;
//
//  ado:=TADOQuery.Create(nil);
//  serverConnect:=createServerConnectWithError(error);
//
//  if not Assigned(serverConnect) then begin
//     ShowFormErrorMessage(error, SharedMainLog, 'isExistRemoteCommand');
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//
//      SQL.Clear;
//      SQL.Add('select count(id) from remote_commands where command = '+#39+inttostr(EnumLoggingToInteger(command)) +#39+' and user_id = '+#39+IntToStr(_userID)+#39);
//      Active:=True;
//
//      if Fields[0].Value<>null then begin
//        if Fields[0].Value <> 0 then Result:=True
//        else Result:=False;
//      end
//      else Result:= True;
//    end;
//  finally
//    FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//end;


// ��������� �������
//function remoteCommand_addQueue(_command:enumLogging;
//                                _userID:Integer;
//                                var _errorDescriptions:string):Boolean;
//var
// resultat:string;
// response:string;
// soLongWait:UInt16;
//begin
//   Result:=False;
//  _errorDescriptions:='';
//
//  soLongWait:=0;
//  showWait(show_open);
//
//  // ���������� ������� (�����)
//
//
//  response:='insert into remote_commands (sip,command,ip,user_id,user_login_pc,pc) values ('+#39+getUserSIP(_userID) +#39+','
//                                                                                            +#39+IntToStr(EnumLoggingToInteger(_command))+#39+','
//                                                                                            +#39+SharedCurrentUserLogon.GetIP+#39+','
//                                                                                            +#39+IntToStr(SharedCurrentUserLogon.GetID)+#39+','
//                                                                                            +#39+SharedCurrentUserLogon.GetUserLoginPC+#39+','
//                                                                                            +#39+SharedCurrentUserLogon.GetPC+#39+')';
//  // ��������� ������
//  if not remoteCommand_Responce(response,_errorDescriptions) then begin
//    showWait(show_close);
//    Exit;
//  end;
//
//  // ���� ���� ���������� �� core_dashboard
//  while (isExistRemoteCommand(_command,_userID)) do begin
//   Sleep(100);
//   Application.ProcessMessages;
//
//   // ���� �� ������ �� ��������� �������
//   if remoteCommand_IsFail(_command,_userID) then soLongWait:=100;
//
//   if soLongWait>50 then begin
//
//    // ������� ������ � �������
//    resultat:=remoteCommand_GetFailStr(SharedCurrentUserLogon.GetID, _errorDescriptions);
//
//
//    // ������� ������� �������
//       response:='delete from remote_commands where sip ='+#39+getUserSIP(_userID)+#39+
//                                                         ' and command ='+#39+IntToStr(EnumLoggingToInteger(_command))+#39;
//
//    if not remoteCommand_Responce(response,_errorDescriptions) then begin
//      showWait(show_close);
//      Exit;
//    end;
//
//    showWait(show_close);
//    _errorDescriptions:='������ �� ���� ���������� �������'+#13#13+'�������: '+resultat;
//    Exit;
//
//   end else begin
//    Inc(soLongWait);
//   end;
//  end;
//
//  showWait(show_close);
//  Result:=True;
//end;


// � ����� ������� ������ ��������� ��������
function getCurrentQueueOperator(InSipNumber:string):enumQueueCurrent;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countQueue:Integer;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
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
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� �������� ������� ���������
procedure UpdateOperatorStatus(_status:enumStatusOperators;_userID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  if not IsUserOperator(_userID) then Exit;

  // ������� ������� ������
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  try
   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update operators set status = '+#39+IntToStr(EnumStatusOperatorsToInteger(_status))+#39+
                                             ' where sip = '+#39+getUserSIP(_userID)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
            Exit;
          end;
      end;
   end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
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
       btnStatus_callback.Enabled:=True;
     end;
      eCallback:begin  // callback
       btnStatus_exodus.Enabled:=True;
       btnStatus_break.Enabled:=True;
       btnStatus_dinner.Enabled:=True;
       btnStatus_postvyzov.Enabled:=True;
       btnStatus_studies.Enabled:=True;
       btnStatus_IT.Enabled:=True;
       btnStatus_transfer.Enabled:=True;
       btnStatus_home.Enabled:=True;
       btnStatus_reserve.Enabled:=True;
       btnStatus_callback.Enabled:=False;
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
  Result:='null';

  // ������� ��������� �����
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  // ������� ������� �� ����
  status:=EnumLoggingToInteger(StatusOperatorToEnumLogging(EnumStatusOperatorsToInteger(InOperatorStatus)));

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select date_time from logging where user_id = '+#39+IntToStr(InUserid)+#39+' and action = '+#39+IntToStr(status)+#39+ ' order by date_time DESC limit 1' );
      Active:=True;

      if Fields[0].Value<>null then curr_date:=Fields[0].Value
      else begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;
        Exit;
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  // ������� �� �������
   dateToBD:=StrToDateTime(curr_date);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );
   Result:=GetTimeAnsweredSecondsToString(diff);
end;


// ������� ������� � ������� OnHold
function GetLastStatusTimeOnHold(InStartTimeonHold:string):string;
var
 dateToBD:TDateTime;
 dateNOW:TDateTime;
 diff:Integer;
 fullTime:string;
begin
  // ������� �� �������
   dateToBD:=StrToDateTime(InStartTimeonHold);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );

   fullTime:=GetTimeAnsweredSecondsToString(diff);

   Result:=Copy(fullTime, 4, 5);  // ������ (mm::ss)
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
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(action) from logging where user_id = '+#39+IntToStr(InUserid)+#39+' order by date_time DESC limit 2' );
      Active:=True;

      countLastStatus:=Fields[0].Value;

      if countLastStatus<=1 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;
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

        ado.Next;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;


 if IsExit and isGoHome then Result:=True
 else Result:=False;
end;


// �������� �������� ���� ����� ��� ��� (����� ���������� �������� ������)
function isOperatorGoHomeWithForceClosed(inUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select action from logging where user_id = '+#39+IntToStr(InUserid)+#39+' order by date_time DESC limit 1' );
      Active:=True;

     if Fields[0].Value<>null then begin
       if StrToInt(VarToStr(Fields[0].Value)) = EnumLoggingToInteger(eLog_exit_force) then Result:=True;
     end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

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
     if GetLastStatusOperator(InUserID) <> eLog_home then Result:=True
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
function IsUserOperator(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InUserID)+#39);
      Active:=True;

      if Fields[0].Value=null then Result:=False
      else Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
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
  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select date_time,sip from operators where user_id = '+#39+IntToStr(InUserID)+#39);
      Active:=True;

      if Fields[0].Value<>null then begin
        date_time_create:=GetDateTimeToDateBD(VarToStr(Fields[0].Value));
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
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                end;
               Exit;
            end;
        end;
    end;
  finally
   FreeAndNil(ado);
   if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
   end;
  end;
end;


// �������� ��������.� �� �������������� ��������� ������������ true - ���������� ��������
function isExistSettingUsers(InUserID:Integer):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
 end;

 try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(user_id) from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
      Active:=True;

      if Fields[0].Value<>0 then Result:=True
      else Result:=False;
    end;
 finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
 end;
end;



// ���������� ������������� �������� ������������
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers; status:enumParamStatus);
var
 response:string;
 error:string;
begin
   Screen.Cursor:=crHourGlass;

   case settings of
    settingUsers_gohome: begin // �� ���������� ������� �����

      // ��������� ���� �� ��� ������
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set go_home = '+#39+IntToStr(SettingParamsStatusToInteger(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,go_home) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(status))+#39+')';
      end;
    end;
    settingUsers_noConfirmExit: begin  // �� ���������� ���� "����� ������ ����� �� ��������?"

      // ��������� ���� �� ��� ������
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set no_confirmExit = '+#39+IntToStr(SettingParamsStatusToInteger(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,no_confirmExit) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(status))+#39+')';
      end;
    end;
    settingUsers_showStatisticsQueueDay:begin  // ����� ��� ������� ���������� � ������ "��������� �������� � �������" 0-����� | 1 - ������
      // ��������� ���� �� ��� ������
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set statistics_queue_day = '+#39+IntToStr(SettingParamsStatusToInteger(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,statistics_queue_day) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(status))+#39+')';
      end;
    end;
   end;

  // ��������� ������
  if not remoteCommand_Responce(response,error) then begin
    Screen.Cursor:=crDefault;
    MessageBox(HomeForm.Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  Screen.Cursor:=crDefault;
end;

// ��������� ������ �� �������������� ���������� ������������
function getStatusIndividualSettingsUser(InUserID:Integer; settings:enumSettingUsers):enumParamStatus;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

begin
 Result:=paramStatus_DISABLED;
 if not isExistSettingUsers(InUserID) then Exit;

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
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
        settingUsers_showStatisticsQueueDay:begin  // ����� ��� ������� ���������� � ������ "��������� �������� � �������" 0-����� | 1 - ������
          SQL.Add('select statistics_queue_day from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
        end;
       end;
      Active:=True;

      if Fields[0].Value<>null then begin
        if VarToStr(Fields[0].Value) = '1'  then Result:=paramStatus_ENABLED
        else Result:=paramStatus_DISABLED;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� �������������� �������� ������������
procedure LoadIndividualSettingUser(InUserId:Integer);
begin
  with HomeForm do begin
    // �� ���������� ������� �����
    begin
      if getStatusIndividualSettingsUser(InUserId,settingUsers_gohome) = paramStatus_ENABLED then
      begin
         VisibleIconOperatorsGoHome(goHome_Hide);
         chkboxGoHome.Checked:=True;
      end
      else  VisibleIconOperatorsGoHome(goHome_Show);
    end;


    // ����� ��� ������� ���������� � ������ "��������� �������� � �������"  0- ����� | 1 - ������
    begin
     if getStatusIndividualSettingsUser(InUserId,settingUsers_showStatisticsQueueDay) = paramStatus_DISABLED then
     begin
      ShowStatisticsCallsDay(eNumbers);
     end
     else ShowStatisticsCallsDay(eGraph);
    end;

  end;
end;


// ������� ����� ��������� �� ������� logging
function GetLastStatusOperator(InUserId:Integer):enumLogging;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:=eLog_unknown;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then begin
      FreeAndNil(ado);
      Exit;
   end;

   try
      with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add('select action from logging where user_id = '+#39+IntToStr(InUserId)+#39+' order by date_time desc limit 1');

        Active:=True;

        if Fields[0].Value<>null then begin
          Result:=IntegerToEnumLogging(StrToInt(VarToStr(Fields[0].Value)));
        end;
      end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
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
   if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
   end;

   try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select status from operators where user_id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        Result:=IntegerToEnumStatusOperators(StrToInt(VarToStr(Fields[0].Value)));
      end;
    end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
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
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(alias) from server_ik where alias = '+#39+InAlias+#39);

      Active:=True;
      if Fields[0].Value<>0 then Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
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
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
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
          if Length(VarToStr(Fields[0].Value))<>0 then Result:=VarToStr(Fields[0].Value);
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


//// ��������� ��������������� ������ ��� �������� SMS
//function GetSMSAuth(SMSType:enumSMSAuth):string;   // TODO ����� ��� ������ ��������� � ����� ��� �������� SMS
//var
// ado:TADOQuery;
// serverConnect:TADOConnection;
//begin
//   Result:='null';
//
//   ado:=TADOQuery.Create(nil);
//   serverConnect:=createServerConnect;
//  if not Assigned(serverConnect) then begin
//     FreeAndNil(ado);
//     Exit;
//  end;
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//      SQL.Clear;
//
//      case SMSType of
//       sms_server_addr:begin
//         SQL.Add('select url from sms_settings');
//       end;
//       sms_login:begin
//         SQL.Add('select sms_login from sms_settings');
//       end;
//       sms_pwd:begin
//         SQL.Add('select sms_pwd from sms_settings');
//       end;
//       sms_sign:begin
//         SQL.Add('select sign from sms_settings');
//       end;
//      end;
//
//      Active:=True;
//      if Fields[0].Value<>null then begin
//        if Length(VarToStr(Fields[0].Value)) <> 0 then Result:=VarToStr(Fields[0].Value);
//      end;
//
//    end;
//  finally
//    FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//    end;
//  end;
//end;


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
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

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
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
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
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


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
           ado.Next;
        end;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
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
        saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_gohome,paramStatus_ENABLED);
        chkboxGoHome.Checked:=True;
       end;


        if img_goHome_YES.Visible then begin
         img_goHome_YES.Visible:=False;
         img_goHome_NO.Visible:=True;
         img_goHome_NO.Left:=49;
        end;

      ST_operatorsHideCount.Visible:=True;
      ST_operatorsHideCount.Caption:='������: �������...';

     end;
     goHome_Show:begin

       if InClick then begin
        saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_gohome,paramStatus_DISABLED);
        chkboxGoHome.Checked:=False;
       end;

        if img_goHome_NO.Visible then begin
         img_goHome_NO.Visible:=False;
         img_goHome_YES.Visible:=True;
         img_goHome_YES.Left:=49;
        end;

       ST_operatorsHideCount.Visible:=False;
     end;
    end;
  end;
end;

// ��������
procedure Egg;
begin
  HappyNewYear;
  Mart8;
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

// �������� � 8 �����
procedure Mart8;
var
  DateMarch8: TDateTime;
begin
  // ���������� ���� ������ ����
   DateMarch8 := EncodeDate(YearOf(Now), 3, 8);

  if IsSameDay(Now, DateMarch8) then
  begin
    HomeForm.ImageLogo.Visible := False;
    HomeForm.Img8Mart.Visible:=True;
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
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select chat from users where id = '+#39+IntToStr(InUserId)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
        if StrToInt(VarToStr(Fields[0].Value)) = 1 then Result:=True;
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ������ � ����������� �������
function OpenMissedCalls(var _errorDescriptions:string; _queue:enumQueueCurrent = queue_5000_5050; _missed:enumMissed = eMissed_no_return):Boolean;
begin
  Result:=False;

  if SharedCurrentUserLogon.GetAccess(menu_missed_calls) = access_DISABLED then begin
   _errorDescriptions:='����������� ������ � ����������� �������';
   Exit;
  end;

 if SharedCurrentUserLogon.GetAccess(menu_missed_calls) = access_ENABLED then begin
   with FormPropushennie do begin
    SetQueue(_queue, _missed);
   end;

   Result:=True;
 end;

end;


// �������� exe ���������� ����
procedure OpenLocalChat;
begin
 if not SharedCurrentUserLogon.GetIsAccessLocalChat then begin
    MessageBox(HomeForm.Handle,PChar('����������� ������ � ���������� ����'),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(CHAT_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('�� ������� ����� ���� '+CHAT_EXE),PChar('���� �� ������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  ShellExecute(HomeForm.Handle, 'Open', PChar(CHAT_EXE),PChar(USER_ID_PARAM+' '+IntToStr(SharedCurrentUserLogon.GetID)),nil,SW_SHOW);
end;


// �������� exe �������
procedure OpenReports;
begin
 if not SharedCurrentUserLogon.GetIsAccessReports then begin
    MessageBox(HomeForm.Handle,PChar('����������� ������ � �������'),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(REPORT_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('�� ������� ����� ���� '+REPORT_EXE),PChar('���� �� ������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  ShellExecute(HomeForm.Handle, 'Open', PChar(REPORT_EXE),PChar(USER_ID_PARAM+' '+IntToStr(SharedCurrentUserLogon.GetID)),nil,SW_SHOW);
end;


// �������� exe �����
procedure OpenService;
begin
 if not SharedCurrentUserLogon.GetIsAccessService then begin
    MessageBox(HomeForm.Handle,PChar('����������� ������ � �������'),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(SERVICE_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('�� ������� ����� ���� '+SERVICE_EXE),PChar('���� �� ������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  ShellExecute(HomeForm.Handle, 'Open', PChar(SERVICE_EXE),PChar(USER_ID_PARAM+' '+IntToStr(SharedCurrentUserLogon.GetID)),nil,SW_SHOW);
end;

// �������� exe SMS ��������
procedure OpenSMS;
 var
  showSendingSMS:Boolean; // ���������� �� excel ��������
begin
 if not SharedCurrentUserLogon.GetIsAccessSMS then begin
    MessageBox(HomeForm.Handle,PChar('����������� ������ � SMS ��������'),PChar('����������� ������'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(SMS_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('�� ������� ����� ���� '+SMS_EXE),PChar('���� �� ������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ���������� �� excel ��������
  if (SharedCurrentUserLogon.GetRole = role_senior_operator) or
     (SharedCurrentUserLogon.GetRole = role_operator) or
     (SharedCurrentUserLogon.GetRole = role_operator_no_dash)
   then showSendingSMS:=False
   else showSendingSMS:=True;

  ShellExecute(HomeForm.Handle, 'Open', PChar(SMS_EXE),PChar(USER_ID_PARAM+' '+
                                                            IntToStr(SharedCurrentUserLogon.GetID)+' '+
                                                            USER_ACCESS_PARAM +' '+
                                                            BooleanToString(showSendingSMS)),nil,SW_SHOW);
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
 if not Assigned(serverConnect) then begin
   FreeAndNil(ado);
   Exit;
 end;

 try
   with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select pc,user_login_pc,last_active from active_session where user_id = '+#39+IntToStr(InUserID)+#39+' and last_active > '+#39+GetNowDateTimeDec(1)+#39);

    Active:=True;

    if Fields[0].Value<>null then begin
      Result:=True;
      ActiveSession:=VarToStr(Fields[0].Value)+' ('+VarToStr(Fields[1].Value)+') - '+VarToStr(Fields[2].Value);
    end;
  end;
 finally
  FreeAndNil(ado);
  if Assigned(serverConnect) then begin
    serverConnect.Close;
    FreeAndNil(serverConnect);
  end;
 end;
end;


// �������� �������� �� ������ ����������
function GetStatusUpdateService:Boolean;
begin
  Result:=GetTask(UPDATE_EXE);
end;

//  ������� �� ����� ��� �������� ����� ����������
procedure ClearAfterUpdate;
var
 folderUpdate_:string;
 XML:TXML;
begin
   folderUpdate_:=FOLDERUPDATE;
  // ������� ������� ��� ����������
  if DirectoryExists(folderUpdate_) then TDirectory.Delete(folderUpdate_, True);

  if FileExists(FOLDERPATH+UPDATE_BAT) then begin
   // ���� ���� ���� � ��������������� ������ ���� �������� ���������� � ����� �������� ������
    DeleteFile(FOLDERPATH+UPDATE_BAT);

    XML:=TXML.Create;
    XML.isUpdate('false');
    XML.ForceUpdate('false');
    XML.UpdateCurrentVersion(PChar(GUID_VERSION));
    XML.Free;

    // ��������� ���� � ����� ������
    ShowInfoNewVersionAfterUpdate(GUID_VERSION);
  end;
end;


// ��������� ������ ������������ � ����� �������������
function GetListAdminRole:TStringList;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countUsers:Integer;
 i:Integer;
begin
 Result:=TStringList.Create;

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then begin
   FreeAndNil(ado);
   Exit;
 end;

 try
  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select count(id) from users where role = '+#39+IntToStr(GetRoleID(EnumRoleToString(role_administrator)))+#39+' and disabled = ''0'' ');

    Active:=True;
    countUsers:=Fields[0].Value;

    if countUsers=0 then begin
      FreeAndNil(ado);
      if Assigned(serverConnect) then begin
        serverConnect.Close;
        FreeAndNil(serverConnect);
      end;
      Exit;
    end;

    if Active then Active:=False;

    SQL.Clear;
    SQL.Add('select familiya,name from users where role = '+#39+IntToStr(GetRoleID(EnumRoleToString(role_administrator)))+#39+' and disabled = ''0'' ');

    Active:=True;

    for i:=0 to countUsers-1 do begin
      Result.Add(Fields[0].Value+' '+Fields[1].Value);
      ado.Next;
    end;
  end;
 finally
  FreeAndNil(ado);
  if Assigned(serverConnect) then begin
    serverConnect.Close;
    FreeAndNil(serverConnect);
  end;
 end;
end;

// ��������� ����� �������
procedure SetRandomFontColor(var p_label: TLabel);
var
  RandomColor: TColor;
begin
  // ���������� ��������� �������� ��� RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // ������������� ��������� ���� ������ ��� �����
  p_label.Font.Color := RandomColor;
end;

// ����� ���������� � ����� ������
procedure ShowInfoNewVersionAfterUpdate(InGUID:string);
begin
  MessageBox(0,PChar(GetVersionAbout(eGUI,InGUID)),PChar('���������� � ����� ������'),MB_OK+MB_ICONINFORMATION);
end;

// ����������� ���������� �������� � ������� �� ������� ����
procedure ShowStatisticsCallsDay(InTypeStatisticsCalls: enumStatisticsCalls; InClick:Boolean = False);
begin
  with HomeForm do begin
     case InTypeStatisticsCalls of
       eNumbers: begin
        if InClick then begin
          // ��������� ������� �����
         saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_showStatisticsQueueDay,paramStatus_DISABLED);
        end;

        PanelStatisticsQueue_Numbers.Visible:=True;
        PanelStatisticsQueue_Graph.Visible:=False;

        img_StatisticsQueue_Graph.Visible:=True;
        img_StatisticsQueue_Numbers.Visible:=False;
       end;
       eGraph: begin
        if InClick then begin
         // ��������� ������� �����
         saveIndividualSettingUser(SharedCurrentUserLogon.GetID,settingUsers_showStatisticsQueueDay,paramStatus_ENABLED);

        end;

        PanelStatisticsQueue_Numbers.Visible:=False;
        PanelStatisticsQueue_Graph.Visible:=True;

        img_StatisticsQueue_Graph.Visible:=False;
        img_StatisticsQueue_Numbers.Visible:=True;
       end;
     end;
  end;
end;

// ���������� �� MySQL COnnector
function isExistMySQLConnector:Boolean;
const
 KeyPath:string = 'SOFTWARE\MySQL AB\MySQL Connector/ODBC 5.3';
 ValueName:string = 'Version';
var
  Reg:TRegistry;
begin
  Result:=False;

  Reg:=TRegistry.Create(KEY_READ); // ������� ������ TRegistry � ������� �� ������
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE; // ������������� �������� ����
    // ���������, ����� �� �� ������� ��������� ����
    if Reg.OpenKeyReadOnly(KeyPath) then
    begin
      // ���������, ���������� �� �������� � ��������� ������
      Result := Reg.ValueExists(ValueName);
      Reg.CloseKey; // ��������� ����
    end;
  finally
    Reg.Free; // ����������� �������
  end;

end;




// �������� ����� �� ������������� reconnect � ����
function GetNeedReconnectBase(const _errorMessage:string):enumNeedReconnectBD;
begin
  // TODO ���� ���� ������� ��������, ����� ���� ����� ����������� �������� �� ������� ����� ������� ��������

  Result:=eNeedReconnectYES;

  if AnsiPos('��������� ��������� ODBC',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('MySQL Connector',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if (AnsiPos('������� ������ ��������� ���������� �� ���������� ������',_errorMessage)<>0) or
     (AnsiPos('������ ��������� ������� ������ ��������',_errorMessage)<>0) then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('�������� ������ ��� ������� �� ������!',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('�������� ����������� ������',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('�� ����� �������� ���� ���������� �����',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('��������� ������������ ���-�� ������� �����',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;

  if AnsiPos('����������� ������! ���������� ���� ��������',_errorMessage)<>0 then begin
    Result:=eNeedReconnectNO;
    Exit;
  end;
end;


// ������� ����� ������ ��� (����� ������)
function GetNowDateTimeDec(DecMinutes:Integer):string;
var
  AdjustedTime: TDateTime;
begin
  AdjustedTime := IncMinute(Now, -DecMinutes);
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', AdjustedTime);
end;


// ������� ����� ������ ���
function GetNowDateTime:string;
begin
  Result:= FormatDateTime('yyyy-mm-dd 00:00:00', Now);
end;


// ������������ ���� � �������
procedure ShowFormErrorMessage(_errorMessage:string;
                               var p_Log:TLoggingFile;
                               const __METHOD_NAME__:string;
                               forceUpdate:Boolean = False);
var
  needReconnect:enumNeedReconnectBD;
  EggMessage:string;
begin
  EggMessage:='';
  // ���������� � Log
  if Assigned(p_Log) then p_Log.Save(__METHOD_NAME__+': '+ _errorMessage,IS_ERROR);

  // �������� ����� �� ������������� Reconnect
  needReconnect:=GetNeedReconnectBase(_errorMessage);

  if forceUpdate then begin
    EggMessage:='����,'+#13+'����� ����������!';
  end;

  // ���� ������ ����������� � ��
  if AnsiPos('EDatabaseError',_errorMessage )<> 0 then begin
    _errorMessage:='������ ��� ������� � ���� �����������';
    EggMessage:='����,'+#13+'����� ����������!';
  end;


  with FormError do begin
    if not Showing then begin
     CreateSettings(_errorMessage,needReconnect,forceUpdate,EggMessage);
     ShowModal;
    end;
  end;
end;


// ������� �������� ������� ���� ���������� ����� �� �����
function GetFreeSpa�eDrive(InDrive:string):int64;
var
 FS:pLargeInteger;
 F,T: int64;
 tmp:string;
 Space:int64;
begin
  InDrive:=Copy(InDrive,1,1);

  if Length(InDrive)=1 then begin
    try
      if GetDiskFreeSpaceEx(Pchar(InDrive+':\'),F,T,@FS) then begin
       Space:=F;
       Space:=trunc(Space/1024/1024);

       Result:=Space;
      end
      else Result:=-1;
    except
       Result:=-1;
    end;
  end
  else Result:=-1;
end;


// �������� ���� �� ��������� ����� �� �����
function isExistFreeSpaceDrive(var _errorDescription:string):Boolean;
 var
  CurrentSpace:Integer;
begin
  Result:=False;
  _errorDescription:='';

  CurrentSpace:=GetFreeSpa�eDrive(FOLDERPATH);

  if CurrentSpace = -1 then begin
    Result:=True; // ������� ��� ���� ����� �� �����
    Exit;
  end;

  if CurrentSpace<=FREE_SPACE_COUNT then begin
    _errorDescription:='�� ����� �������� ���� ���������� �����!'+#13+'�������� '+IntToStr(CurrentSpace)+ ' Mb';
    Exit;
  end;

  Result:=True;
end;

// ��������� ������� ������ �� ������� ����� � TListView
procedure ChangeFontSize(InChange:enumFontChange; InTypeFont:enumFontSize);
var
 NewSize:Word;
 XML:TXML;
begin
  NewSize:=SharedFontSize.GetSize(InTypeFont);

  case InChange of
   eFontUP:   Inc(NewSize);
   eFontDonw: Dec(NewSize);
  end;

  // ��������� ��������
  XML:=TXML.Create;
  XML.SetFontSize(InTypeFont,NewSize);
  XML.Free;

  SharedFontSize.SetSize(InTypeFont,NewSize);

  case InTypeFont of
    eActiveSip: clearList_SIP(HomeForm.Width - DEFAULT_SIZE_PANEL_ACTIVESIP, SharedFontSize.GetSize(InTypeFont));
    eIvr:       clearList_IVR(SharedFontSize.GetSize(InTypeFont));
    eQueue:     clearList_QUEUE(SharedFontSize.GetSize(InTypeFont));
  end;
end;


// ������ ��������������� ����������
procedure ForceUpdateDashboard(var p_ButtonClose:TBitBtn);
var
 XML:TXML;
begin
  p_ButtonClose.Enabled:=False;

  XML:=TXML.Create;
  XML.ForceUpdate('true');
  XML.Free;

  MessageBox(0,PChar('���������� �������� ��� ������ ����� 1 ���'+#13#13+'������� ��������� �������������'),PChar('���������� ��������'),MB_OK+MB_ICONINFORMATION);
end;


// ����������� ������� ����� ���� ��� ��������
procedure WindowStateInit;
var
 XML:TXML;
begin
  XML:=TXML.Create;
  with HomeForm do begin
    if XML.GetWindowState = 'wsMaximized' then WindowState:=wsMaximized
    else begin
     WindowState  :=wsNormal;
     Height       :=900; //1011  // default
     ClientWidth  :=1470;        // default
    end;
  end;
  XML.Free;
end;


// ������� uptime
function GetProgrammUptime:int64;
begin
  Result:=PROGRAMM_UPTIME;
end;

// ������� uptime
function GetProgrammUptime(_uptime:Int64):string;
begin
  Result:=GetTimeAnsweredSecondsToString(_uptime);
end;

// ����� ������� ���������(������� ������������)
function GetProgrammStarted:TDateTime;
begin
  Result:=PROGRAM_STARTED;
end;

// ����� ������� ��������� �� ������� ������
function GetProgrammStartedFirstLogon(_userID:Integer):TDateTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select date_time from logging where user_id = '+#39+IntToStr(_userID)+#39 +' and action = ''0'' order by date_time ASC limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=VarToDateTime(Fields[0].Value);
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ����� �������� ��������� �� ������ ������
function GetProgrammExit(_userID:Integer):TDateTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select date_time from logging where user_id = '+#39+IntToStr(_userID)+#39 +' and action = ''1'' order by date_time DESC limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=VarToDateTime(Fields[0].Value);
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ����� ������� ���������(����� ������������)
function GetProgrammStarted(_userID:Integer):TDateTime;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select started_programm from active_session where user_id = '+#39+IntToStr(_userID)+#39);

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=VarToDateTime(Fields[0].Value);
      end
      else begin
        Result:=GetProgrammStartedFirstLogon(_userID);
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// ���������� �� ����� ����� ������ ����� ������� ���� � �������
function GetPhoneTrunkQueue(_phone:string;_timecall:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select trunk from ivr where phone = '+#39+_phone+#39+' and date_time < '+#39+GetDateTimeToDateBD(_timecall)+#39+' and to_queue = 1 limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
       Result:=VarToStr(Fields[0].Value);
      end
      else Result:='LISA';
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// �������� �� ��������� ������� ��� �������� ������ ��� ��� ������������ ������
function CreateRemoteCommandCallback(_action:enumRemoteCommandAction; _id:Integer; var _errorDescription:string): Boolean;
begin
  Result:=False;
  _errorDescription:='';

  case _action of
    remoteCommandAction_activeSession: Result:=ExecuteCommandKillActiveSession(_id,_errorDescription);
   // remoteCommandAction_missedCalls: ;
  end;

end;


// ���������� ������� �������� �������� ������
function ExecuteCommandKillActiveSession(_userID:Integer; var _errorDescription:string):Boolean;
var
 currentActiveSession:TActiveSession;
 isSetOperatorGoHome:Boolean;  // ���� ���� ����� �������� ������ ��������� �� �����
begin
 Result:=False;
 _errorDescription:='';

 try
  Result:=False;
  isSetOperatorGoHome:=False;

  currentActiveSession:=TActiveSession.Create;

  // ������������ �� ������ � ��������� �� � �������
   if (currentActiveSession.IsOperator(_userID)) and
      (currentActiveSession.IsOperatorInQueue(_userID)) then begin
      // ������� �� ������� (��������� ���� ������)
      if not currentActiveSession.ForceExitOperatorInQueue(_userID, _errorDescription) then begin
        // ��� �� ����� �� ��� �������
        Exit;
      end;

      isSetOperatorGoHome:=True;
   end;

   // ��������� ���� ������ offline\online
    case currentActiveSession.IsActiveSession(_userID) of
     True:begin   // online ������
      Result:=currentActiveSession.DeleteOnlineSession(_userID,_errorDescription);
     end;
     False:begin   // offline ������
      Result:=currentActiveSession.DeleteOfflineSession(_userID,_errorDescription,isSetOperatorGoHome);
     end;
    end;

 finally
   if Assigned(currentActiveSession) then FreeAndNil(currentActiveSession);
 end;
end;


// ����� �� ������ �������� ��� ����� ������� ���������
function SendCommandStatusDelay(_userID:Integer):enumStatus;
var
 sip:string;
begin
  // �������� ������������� �� ��������
  sip:=getUserSIP(_userID);

  Result:=SharedActiveSipOperators.IsTalkOperator(sip);
end;



end.
