unit FunctionUnit;

interface

  uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, IniFiles, TlHelp32, IdBaseComponent, IdComponent,ShellAPI, StdCtrls, ComCtrls,
  ExtCtrls,WinSock,Math,IdHashCRC,Nb30,IdMessage,StrUtils,WinSvc,System.Win.ComObj, IdSMTP, IdText,
  IdSSL, IdSSLOpenSSL,IdAttachmentFile,DMUnit, FormHome, Data.Win.ADODB, Data.DB, IdIcmpClient,IdException, System.DateUtils,
  FIBDatabase, pFIBDatabase, TCustomTypeUnit,TUserUnit, Vcl.Menus, GlobalVariables,TActiveSIPUnit;




procedure KillProcess;                                                               // принудительное завершение работы
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;    // отображение инфо по очередеям
function GetStatistics_day(inStatDay:enumStatistiscDay):string;                         // отображение инфо за день
procedure clearAllLists;                                                             // очистка всех list's
procedure clearList_IVR;                                                             // отображение листа с текущими звонками
procedure clearList_QUEUE;                                                           // очистка listbox_QUEUE
procedure clearList_SIP(InWidth:Integer);                                            // очистка listbox_SIP
procedure clearList_Propushennie;                                                    // создание интерфейса пропущенные
procedure updatePropushennie;                                                        // обновление пропущенных звонков форма
procedure createThreadDashboard;                                                     // создание потоков
function getVersion(GUID:string; programm:enumProrgamm):string;                      // отображение текущей версии
procedure showVersionAbout(programm:enumProrgamm);                                   // отображение истории вресий
function Ping(InIp:string):Boolean;                                                  // проверка ping
procedure createCheckServersInfoclinika;                                             // создание списка с серверами
function StrToTRole(InRole:string):enumRole;                                         // string -> TRole
function TRoleToStr(InRole:enumRole):string;                                         // TRole -> string
function EnumProgrammToStr(InEnumProgram:enumProrgamm):string;                       // enumProgramm -> string
function GetRoleID(InRole:string):Integer;                                           // получение ID TRole
function getUserGroupSTR(InGroup:Integer):string;                                    // отображение роли пользвоателя
function getHashPwd(inPwd: String):Integer;                                          // хэширование пароля
function getUserGroupID(InGroup:string):Integer;                                     // отображение ID роли пользвоателя
function getUserID(InLogin:string):Integer; overload;                                // отображение ID пользвоателя
function getUserID(InUserName,InUserFamiliya:string):Integer; overload;              // полчуение userID из ФИО
function getUserID(InSIPNumber:integer):Integer; overload;                           // полчуение userID из SIP номера
procedure loadPanel_Users(InUserRole:enumRole; InShowDisableUsers:Boolean = False);     // прогрузка спика пользвоателей
procedure loadPanel_Operators;                                                       // прогрузка спика пользвоателей (операторы)
function getCheckLogin(inLogin:string):Boolean;                                      // существует ли login пользвоателчя
function disableUser(InUserID:Integer):string;                                       // отключение пользователя
procedure deleteOperator(InUserID:Integer);                                          // удаление пользователя из таблицы operators
procedure LoadUsersAuthForm;                                                         // прогрузка пользователей в форму авторизации
function getUserPwd(InUserID:Integer):Integer;                                       // полчуение userPwd из userID
function getUserLogin(InUserID:Integer):string;                                      // полчуение userLogin из userID
function getUserRoleSTR(InUserID:Integer):string;                                    // отображение роли пользвоателя
function getIVRTimeQueue(InQueue:enumQueueCurrent):Integer;                             // время которое необходимо отнимать от текущего звонка в очереди
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;               // правильноt отображение времени в очереди
function StrToTQueue(InQueueSTR:string):enumQueueCurrent;                               // конвертер из string в TQueue
function getUserRePassword(InUserID:Integer):Boolean;                                // необходимо ли поменять пароль при входе
function updateUserPassword(InUserID,InUserNewPassword:Integer):string;              // обновление пароля пользователя
function TQueueToStr(InQueueSTR:enumQueueCurrent):string;                               // конвертер из TQueue в string
function getLocalIP: string;                                                         // функция получения локального IP
procedure createCurrentActiveSession(InUserID:Integer);                              // заведение активной сессии
function isExistCurrentActiveSession(InUserID:Integer):Boolean;                      // сущуствует ли акивная сессия
procedure deleteActiveSession(InSessionID:Integer);                                  // удаление активной сессии
function getActiveSessionUser(InUserID:Integer):Integer;                             // доставание ID активной сессии пользователя
function isExistSipActiveOperator(InSip:string):Boolean;                             // проверка заведен ли уже ранее оператор под таким sip номером и он активен
function getUserNameOperators(InSip:string):string;                                  // полчуение имени пользователя из его SIP номера
procedure accessRights(var p_TUser: TUser);                                          // права доступа
function getCurrentUserNamePC:string;                                                // получение имени залогиненого пользователя
function getComputerPCName: string;                                                  // функция получения имени ПК
procedure updateCurrentActiveSession(InUserID:Integer);                              // обновление времени активной сесии пользователя
function getCurrentDateTimeWithTime:string;                                          // текущая дата + время
function getForceActiveSessionClosed(InUserID:Integer):Boolean;                      // проверка нужно ли закрыть активную сессию
//function createServerConnect:TADOConnection;                                         // создвание подключения к серверу
function getSelectResponse(InStroka:string):Integer;                                 // запрос по статичтике данных
procedure LoggingRemote(InLoggingID:enumLogging);                                      // логирование действий
function TLoggingToInt(InTLogging:enumLogging):Integer;                                 // проеобразование из TLogging в Integer
function IntToTLogging(InLogging:Integer):enumLogging;                                  // проеобразование из Integer в TLogging
procedure showUserNameAuthForm;                                                      // отображение ранее входивщего пользователя в выборе вариантов пользователей
function getUserFamiliyaName_LastSuccessEnter(InUser_login_pc,
                                              InUser_pc:string):string;              // нахождение userID после успешного входа на пк
procedure cloneRun;                                                                  // проверка на 2ую копию дашборда
function getCountAnsweredCall(InSipOperator:string):Integer;                         // кол-во отвеченных звонков оператором
function getCountAnsweredCallAll:Integer;                                            // кол-во отвеченных звонков всех операторов
function createListAnsweredCall(InSipOperator:string):TStringList;                   // создвание списка со всем отвеченными звонками  sip оператора
function getTimeAnsweredToSeconds(InTimeAnswered:string):Integer;                    // перевод времени разговора оператора типа 00:00:00 в секунды
function getTimeAnsweredSecondsToString(InSecondAnswered:Integer):string;            // перевод времени разговора оператора типа из секунд в 00:00:00
procedure remoteCommand_addQueue(command:enumLogging);                                  // удаленная команда (добавление в очередь)
procedure showWait(Status:enumShow_wait);                                               // отображение\сркытие окна запроса на сервер
function remoteCommand_Responce(InStroka:string):string;                             // отправка запроса на добавление удаленной команды
function getUserSIP(InIDUser:integer):string;                                        // отображение SIP пользвоателя
function isExistRemoteCommand(command:enumLogging):Boolean;                             // проверка есть ли уже такая удаленная команда на сервера
function getStatus(InStatus:enumStatusOperators):string;                                  // полчуение имени status оператора
function getCurrentQueueOperator(InSipNumber:string):enumQueueCurrent;                  // в какой очереди сейчас находится оператор
procedure clearOperatorStatus;                                                       // очитска текущего статуса оператора
procedure checkCurrentStatusOperator(InOperatorStatus:enumStatusOperators);                      // проверка и отображение кнопок статусов оператора
procedure showStatusOperator(InShow:Boolean = True);                                 // отобрадение панели статусы операторов
function getLastStatusTime(InUserid:Integer; InOperatorStatus:enumStatusOperators):string;                // подсчет времени в текущем статусе оператора
function getStatusOperatorToTLogging(InOperatorStatus:Integer):enumLogging;             // преобразование текущего статуса оператора из int в TLogging
function isOperatorGoHome(inUserID:Integer):Boolean;                                 // проверка оператор ушел домой или нет
function getIsExitOperatorCurrentQueue(InCurrentRole:enumRole;InUserID:Integer):Boolean;// проверка вдруг оператор забыл выйти из линии
function getLastStatusTimeOnHold(InStartTimeonHold:string):string;                   // подсчет времени в статусе OnHold
function getTranslate(Stroka: string):string;                                        // Транслитерация из рус - > транлирт
//function getUserFIO(InUserID:Integer):string;                                        // полчуение имени пользователя из его UserID
function getUserFamiliya(InUserID:Integer):string;                                   // полчуение фамилии пользователя из его UserID
function getUserNameBD(InUserID:Integer):string;                                     // полчуение имени пользователя из его UserID
function UserIsOperator(InUserID:Integer):Boolean;                                  // проверка userID принадлежит оператору или нет TRUE - оператор
procedure disableOperator(InUserId:Integer);                                         // отключение оператора и перенос его в таблицу operators_disable
function getDateTimeToDateBD(InDateTime:string):string;                              // перевод даты и времени в ненормальный вид для BD
function enableUser(InUserID:Integer):string;                                        // включение пользователя
function getOperatorAccessDashboard(InSip:string):Boolean;                           // нахождение статуса доступен ли дашбор орератору или нет
function isExistSettingUsers(InUserID:Integer):Boolean;                              // проверка существу.т ли индивидуальные настрокий пользователч true - существуют настроки
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers;
                                    status:enumSettingUsersStatus);                     // сохранение индивидульных настроек пользователя
function SettingUsersStatusToInt(status:enumSettingUsersStatus):Integer;                // конвертация из TSettingUsersStatus --> Int
function getStatusIndividualSettingsUser(InUserID:Integer;
                                        settings:enumSettingUsers):enumSettingUsersStatus; // получение данных об индивидуальных настройках пользователя
procedure LoadIndividualSettingUser(InUserId:Integer);                               // прогрузка индивидуальных настроек пользователя
function getIsExitOperatorCurrentGoHome(InCurrentRole:enumRole;InUserID:Integer):Boolean; // проверка вдруг оператор не правильно выходит, нужно выходить через команду "домой"
function getLastStatusOperator(InUserId:Integer):enumLogging;                           // текущий стаус оператора из таблицы logging
procedure CheckCurrentVersion;                                                       // проверка на актуальную версию
function getCheckIP(InIPAdtress:string):Boolean;                                     // проверка корректности IP адреса
procedure createFormActiveSession;                                                   // создание окна активных сессий
function getCheckAlias(InAlias:string):Boolean;                                      // проверка на существаование такого алиаса уже, он может быть только один!
function GetFirbirdAuth(FBType:enumFirebirdAuth):string;                                // получение авторизационных данных при подключени к БД firebird
function GetStatusMonitoring(status:Integer):enumMonitoringTrunk;                       // мониторится ли транк
function GetCountServersIK:Integer;                                                  // получение кол-ва серверов ИК
procedure SetAccessMenu(InNameMenu:enumAccessList; InStatus: enumAccessStatus);            // установка разрешение\запрет на доступ к меню
function TAccessListToStr(AccessList:enumAccessList):string;                            // TAccessListToStr -> string
function TAccessStatusToBool(Status: enumAccessStatus): Boolean;                        // TAccessStatus --> Bool
function GetOnlyOperatorsRoleID:TStringList;                                         // получение только операторские ID роли
procedure ShowOperatorsStatus;                                                       // отображение оотдельного окна со статусами оператора
procedure ResizeCentrePanelStatusOperators(WidthMainWindow:Integer);                 // изменение позиции панели статусы операторов в зависимости от размера главного окна
procedure VisibleIconOperatorsGoHome(InStatus:enumHideShowGoHomeOperators;
                                     InClick:Boolean = False);                       // показывать\скрывать операторов ушедших домой
procedure HappyNewYear;                                                              // пасхалка с новым годом
function GetExistAccessToLocalChat(InUserId:Integer):Boolean;                        //есть ли доступ к локальному чату
procedure OpenLocalChat;                                                             // открытые exe локального чата
function EnumChannelChatIDToString(InChatID:enumChatID):string;                // enumChatID -> string
function EnumChannelToString(InChannel:enumChannel):string;                 //enumChannel -> string
function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;     // enumActiveBrowser -> string
function GetExistActiveSession(InUserID:Integer; var ActiveSession:string):Boolean;  // есть ли активная сессия уже
function GetStatusUpdateService:Boolean;                                           // проверка запущена ли служба обновления
function IntegerToEnumStatusOperators(InStatusId:Integer):enumStatusOperators;     // Integer -> enumStatusOperators
function EnumStatusOperatorsToInteger(InStatus:enumStatusOperators):Integer;        // enumStatusOperators -> integer
function getStatusOperator(InUserId:Integer):enumStatusOperators;                  // текущий стаус оператора из таблицы operators



implementation

uses
  FormPropushennieUnit, Thread_StatisticsUnit, Thread_IVRUnit, Thread_QUEUEUnit, Thread_ACTIVESIPUnit,
  FormAboutUnit, FormServerIKCheckUnit, Thread_CHECKSERVERSUnit, FormSettingsUnit, FormAuthUnit,
  FormErrorUnit, FormWaitUnit, Thread_AnsweredQueueUnit, FormUsersUnit, TTranslirtUnit,
  Thread_ACTIVESIP_updatetalkUnit, Thread_ACTIVESIP_updatePhoneTalkUnit, Thread_ACTIVESIP_countTalkUnit,
  Thread_ACTIVESIP_QueueUnit, FormActiveSessionUnit, TIVRUnit, FormOperatorStatusUnit, TXmlUnit, TOnlineChat, Thread_ChatUnit;



// создвание подключения к серверу
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

    LoginPrompt:=False;  // без запроса на вывод логин\парля

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
         lblErrorInfo.Caption:='Возникла ошибка при подключении к серверу...'+#13#13+DateTimeToStr(Now)+' '+ e.ClassName+#13+e.Message;

         if not FormError.Showing then ShowModal;
       end;

      end;
   end;
  end;
end; }





// проеобразование из TLogging в Integer
function TLoggingToInt(InTLogging:enumLogging):Integer;
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
function IntToTLogging(InLogging:Integer):enumLogging;
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


// преобразование текущего статуса оператора из int в TLogging
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

 // логирование действий
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

// хэширование пароля
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



// функция получения локального IP
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


// функция получения имени ПК
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
  if InRole='Администратор'             then Result:=role_administrator;
  if InRole='Ведущий оператор'          then Result:=role_lead_operator;
  if InRole='Старший оператор'          then Result:=role_senior_operator;
  if InRole='Оператор'                  then Result:=role_operator;
  if InRole='Оператор (без дашборда)'   then Result:=role_operator_no_dash;
  if InRole='Руководитель ЦОВ'          then Result:=role_supervisor_cov;
end;


// TRole -> string
function TRoleToStr(InRole:enumRole):string;
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
function EnumProgrammToStr(InEnumProgram:enumProrgamm):string;
begin
  case InEnumProgram of
   eGUI     :Result:='gui';
   eCHAT    :Result:='chat';
  end;
end;

// получение ID TRole
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

// создание потоков
procedure createThreadDashboard;
begin
  with HomeForm do begin
     // Статисика
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

    // ACTIVESIP + дочерние потоки
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


    // СHECKSERVERS
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


    // запуск потоков
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


 //принудительное завершение работы
procedure KillProcess;
var
 countKillExe:Integer;
begin
   try
     if not CONNECT_BD_ERROR then begin

       // логирование (выход)  , через команду или руками
       if getForceActiveSessionClosed(SharedCurrentUserLogon.GetID) then LoggingRemote(eLog_exit_force)
       else
       begin
        // проверка на вдруг нажали просто отмена
        if SharedCurrentUserLogon.GetID<>0 then LoggingRemote(eLog_exit);
       end;

       // очичтка текущего статуса оператора
       clearOperatorStatus;

       // удаление активной сессии
       deleteActiveSession(getActiveSessionUser(SharedCurrentUserLogon.GetID));
     end;

     // закрываем chat_exe если открыт
     countKillExe:=0;
     while GetTask(PChar(CHAT_EXE)) do begin
       KillTask(PChar(CHAT_EXE));

       // на случай если не удасться закрыть дочерний exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;

   finally
      //DM.ADOConnectServer.Close;
      TerminateProcess(OpenProcess($0001, Boolean(0), getcurrentProcessID), 0);
   end;
end;



// текущая дата + время
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

// получение имени залогиненого пользователя
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


// запрос по статичтике данных
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


// отображение инфо по очередеям
function GetStatistics_queue(InQueueNumber:enumQueueCurrent;InQueueType:enumQueueType):string;
var
 select_response:string;
 s:TStringList;
begin
  case InQueueType of

    answered: begin    // отвеченные
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and answered = ''1'' and sip <>''-1'' and hash is not null and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
    no_answered: begin  // не отвеченные
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and fail = ''1'' and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
    no_answered_return: begin  // не отвеченные + вернувшиеся
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
    all_answered:begin  // всего отвеченных
      select_response:='select count(phone) from queue where number_queue = '+#39+TQueueToStr(InQueueNumber)+#39
                                                                             +' and date_time > '+#39+GetCurrentStartDateTime+#39;
    end;
  end;



  Result:=IntToStr(getSelectResponse(select_response));
end;


// отображение инфо за день
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
           // расчитываем
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
           // расчитываем
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

// очистка всех list's
procedure clearAllLists;
begin
  clearList_IVR;
  clearList_QUEUE;
  clearList_SIP(HomeForm.Panel_SIP.Width);
end;

// очистка listbox_IVR
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
        Caption:='Номер телефона';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewIVR.Columns.Add do
      begin
        Caption:='Время';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with ListViewIVR.Columns.Add do
      begin
        Caption:='Линия';
        Width:=Round((cWidth_default*cProcentWidth_trunk)/100);
        Alignment:=taCenter;
      end;
   end;
 end;
end;


// очистка listbox_SIP
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
   STlist_ACTIVESIP_NO_Rings.Width:=InWidth;  // надпись что нет звонков

   ListViewSIP.Columns.Clear;

   lblCount_ACTIVESIP.Caption:='Активные звонки | Свободные операторы';

   with ListViewSIP do begin
     ViewStyle:= vsReport;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Оператор';
        Width:=Round((InWidth*cProcentWidth_operator)/100);
        Alignment:=taLeftJustify;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Статус';
        Width:=Round((InWidth*cProcentWidth_status)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Отвечено';
        Width:=Round((InWidth*cProcentWidth_responce)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Номер телефона';
        Width:=Round((InWidth*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Время разговора';
        Width:=Round((InWidth*cProcentWidth_talk)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Очередь';
        Width:=Round((InWidth*cProcentWidth_queue)/100);
        Alignment:=taCenter;
      end;

      with ListViewSIP.Columns.Add do
      begin
        Caption:='Сред. время | Общее';
        Width:=Round((InWidth*cProcentWidth_time)/100);
        Alignment:=taCenter;
      end;
   end;
 end;
end;

// очистка listbox_QUEUE
procedure clearList_QUEUE;
 const
 cWidth_default         :Word = 335;
 cProcentWidth_phone    :Word = 40;
 cProcentWidth_waiting  :Word = 30;
 cProcentWidth_queue    :Word = 30;
begin
 with HomeForm do begin

   lblCount_QUEUE.Caption:='Очередь';

   with ListViewQueue do begin
     ViewStyle:= vsReport;

       with ListViewQueue.Columns.Add do
      begin
        Caption:='ID';
        Width:=0;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='Номер телефона';
        Width:=Round((cWidth_default*cProcentWidth_phone)/100);
        Alignment:=taCenter;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='Ожидание';
        Width:=Round((cWidth_default*cProcentWidth_waiting)/100)-1;
        Alignment:=taCenter;
      end;

      with ListViewQueue.Columns.Add do
      begin
        Caption:='Очередь';
        Width:=Round((cWidth_default*cProcentWidth_queue)/100);
        Alignment:=taCenter;
      end;
   end;

 end;
end;


// конвертер из string в TQueue
function StrToTQueue(InQueueSTR:string):enumQueueCurrent;
begin
  if InQueueSTR = '5000' then Result:=queue_5000;
  if InQueueSTR = '5050' then Result:=queue_5050;
end;


// конвертер из TQueue в string
function TQueueToStr(InQueueSTR:enumQueueCurrent):string;
begin
  case InQueueSTR of
    queue_5000: Result:='5000';
    queue_5050: Result:='5050';
  end;
end;

// правильное отображение времени в очереди
function correctTimeQueue(InQueue:enumQueueCurrent;InTime:string):string;
var
 correctTime,delta_time:Integer;
begin
  // найдем корректно время для нужной очереди
  delta_time:=getIVRTimeQueue(InQueue);
  // переведем время в секунлы
  correctTime:=getTimeAnsweredToSeconds(InTime)-delta_time;

  Result:=getTimeAnsweredSecondsToString(correctTime);
end;


// перевод времени разговора оператора типа из секунд в 00:00:00
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


// перевод времени разговора оператора типа 00:00:00 в секунды
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


// кол-во отвеченных звонков оператором
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


// кол-во отвеченных звонков всех операторов
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


// создвание списка со всем отвеченными звонками  sip оператора
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

    // кол-во звонков
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

// создание интерфейса пропущенные
procedure clearList_Propushennie;
begin
 with FormPropushennie do begin

   listSG_Propushennie.RowCount:=1;

   listSG_Propushennie.Cells[0,0]:='дата\время звонка';
   listSG_Propushennie.Cells[1,0]:='время ожидания';
   listSG_Propushennie.Cells[2,0]:='телефон';
   listSG_Propushennie.Cells[3,0]:='очередь';

 end;
end;

// обновление пропущенных звонков форма
procedure updatePropushennie;
var
 listCount:Integer;
 i:Integer;
 list_queue:string;
 serverConnect:TADOConnection;
begin
  listCount:=0;

  // отображение только очереди 5000 и 5050
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

              // подправим время ожидания
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


// отображение текущей версии
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


// отображение истории вресий дашбоарда
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
                  Lines.Add('версия '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
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
                  Lines.Add('версия '+VarToStr(Fields[1].Value) + ' ('+VarToStr(Fields[0].Value)+')');
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


// проверка ping
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


// создание списка с серверами
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

      // выставляем размерность
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

        // статус
        begin
          nameIP:=VarToStr(Fields[0].Value);

          lblStatusServer[i]:=TLabel.Create(FormServerIKCheck);
          lblStatusServer[i].Name:='lbl_'+nameIP;
          lblStatusServer[i].Tag:=1;
          lblStatusServer[i].Caption:='проверка';
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

        // адрес
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

// создание окна активных сессий
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

      // выставляем размерность
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

        // роль
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

        // пользователь
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

        // компьютер
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

        // Дата онлайна
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

        // Статус
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

        // Закрыть сессию
        begin
          btnCLOSE_SESSION[i]:=TButton.Create(FormActiveSession.PanelActive);
          btnCLOSE_SESSION[i].Name:='btnCLOSE_SESSION_'+nameID;
          btnCLOSE_SESSION[i].Tag:=1;
          btnCLOSE_SESSION[i].Caption:='Завершить сессию!';
          btnCLOSE_SESSION[i].Left:=837;

          if i=0 then btnCLOSE_SESSION[i].Top:=cTOPSTART - 5
          else btnCLOSE_SESSION[i].Top:=cTOPSTART+(Round(cTOPSTART)*i)-5;

          btnCLOSE_SESSION[i].Font.Name:='Tahoma';
          btnCLOSE_SESSION[i].Font.Size:=10;
          btnCLOSE_SESSION[i].Width:=126;
          btnCLOSE_SESSION[i].Height:=25;
          btnCLOSE_SESSION[i].Parent:=FormActiveSession.PanelActive;
        end;

         // Убрать из очереди
        begin
          btnCLOSE_QUEUE[i]:=TButton.Create(FormActiveSession.PanelActive);
          btnCLOSE_QUEUE[i].Name:='btnCLOSE_QUEUE_'+nameID;
          btnCLOSE_QUEUE[i].Tag:=1;
          btnCLOSE_QUEUE[i].Caption:='Убрать из очереди';
          btnCLOSE_QUEUE[i].Left:=971;

          if i=0 then btnCLOSE_QUEUE[i].Top:=cTOPSTART - 5
          else btnCLOSE_QUEUE[i].Top:=cTOPSTART+(Round(cTOPSTART)*i)-5;

          btnCLOSE_QUEUE[i].Font.Name:='Tahoma';
          btnCLOSE_QUEUE[i].Font.Size:=10;
          btnCLOSE_QUEUE[i].Width:=126;
          btnCLOSE_QUEUE[i].Height:=25;
          btnCLOSE_QUEUE[i].Parent:=FormActiveSession.PanelActive;

          if (AnsiPos('Оператор',VarToStr(Fields[1].Value)) <> 0) or
              (AnsiPos('оператор',VarToStr(Fields[1].Value))<> 0) then begin
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


// отображение роли пользвоателя
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


// отображение роли пользвоателя
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


// нахождение статуса доступен ли дашбор орератору или нет
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


// необходимо ли поменять пароль при входе
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


// отображение ID роли пользвоателя
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


// отображение ID пользвоателя
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


// отображение SIP пользвоателя
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


// прогрузка спика пользвоателей
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
   RowCount:=1;      // типа очистка текущего списка
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
         Cells[1,i]:=Fields[1].Value+ ' '+Fields[2].Value;  // фамилия + имя
         Cells[2,i]:=Fields[3].Value;                       // login
         Cells[3,i]:=getUserGroupSTR(Fields[4].Value);      // группа прав
         if InShowDisableUsers=False then begin             // состояние
          Cells[4,i]:='Активен';
         end
         else begin
          if VarToStr(Fields[3].Value)='0' then Cells[4,i]:='Активен'
          else Cells[4,i]:='Отключен';
         end;

         Next;
       end;

       FormUsers.Caption:='Пользователи: '+IntToStr(countUsers);

    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;



// прогрузка спика пользвоателей (операторы)
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
   RowCount:=1;      // типа очистка текущего списка
   RowCount:=countUsers;

    with ado do begin

      SQL.Clear;
      SQL.Add('select id,sip,user_id,sip_phone from operators order by sip asc ');

      Active:=True;

       for i:=0 to countUsers-1 do begin

         Cells[0,i]:=Fields[0].Value;                           // id
         Cells[1,i]:=getUserNameOperators(Fields[1].Value);     // Фамилия Имя
         Cells[2,i]:=Fields[1].Value;                           // Sip
         if Fields[3].Value<>null then Cells[3,i]:=Fields[3].Value
         else Cells[3,i]:='null';
         Cells[4,i]:=getUserRoleSTR( StrToInt(Fields[2].Value) );  // Группа прав

         Next;
       end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;


// существует ли login пользвоателчя
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


// полчуение userID из ФИО
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


// полчуение userID из SIP номера
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


// полчуение userPwd из userID
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


// полчуение userLogin из userID
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



// полчуение имени status оператора
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
    else Result:='неизвестен';
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

end;

// отключение пользователя
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
           Result:='ОШИБКА! '+CodOshibki;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

    // проверим пользователь принадлежит группе операторов
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


// включение пользователя
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
           Result:='ОШИБКА! '+CodOshibki;
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


// удаление пользователя из таблицы operators
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


// прогрузка пользователей в форму авторизации
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
           MessageBox(FormAuth.Handle,PChar('Возникла ошибка при запросе на сервер!'+#13#13+CodOshibki),PChar('Ошибка'),MB_OK+MB_ICONERROR);
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
           MessageBox(FormAuth.Handle,PChar('Возникла ошибка при запросе на сервер!'+#13#13+CodOshibki),PChar('Ошибка'),MB_OK+MB_ICONERROR);
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


// нахождение userID после успешного входа на пк
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

    // если нет в основной, то смотрим в таблице history_logging
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


// отображение ранее входивщего пользователя в выборе вариантов пользователей
procedure showUserNameAuthForm;
var
 userNameFamiliya:string;
begin
  // найдем Имя фамилию последнего успешного входа
  userNameFamiliya:=getUserFamiliyaName_LastSuccessEnter(getCurrentUserNamePC,getComputerPCName);
  if userNameFamiliya='null' then Exit;

  // найдем нужный items
  with FormAuth do begin
    comboxUser.ItemIndex:=comboxUser.Items.IndexOf(userNameFamiliya);
    comboxUser.SetFocus;

    edtPassword.SetFocus;
  end;

end;


// время которое необходимо отнимать от текущего звонка в очереди
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


// обновление пароля пользователя
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
           Result:='ОШИБКА! '+CodOshibki;
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


// сущуствует ли сессия
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


// доставание ID активной сессии пользователя
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

// удаление активной сессии
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

// заведение активной сессии
procedure createCurrentActiveSession(InUserID:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 ip,user_pc,pc_name:string;
begin
  Screen.Cursor:=crHourGlass;

  //проверяем есть ли уже такая сессия
   if isExistCurrentActiveSession(InUserID) then begin
     // удаляем активную сессию
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


// обновление времени активной сесии пользователя
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


// проверка заведен ли уже ранее оператор под таким sip номером и он активен
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


// полчуение имени пользователя из его SIP номера
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
// полчуение имени пользователя из его UserID
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

// полчуение фамилии пользователя из его UserID
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


// полчуение имени пользователя из его UserID
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

// отобрадение панели статусы операторов
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
  // Обходим все элементы меню
  for I := 0 to AOwner.Count - 1 do
  begin
    if AOwner[I].Name = AName then
    begin
      Result := AOwner[I];
      Exit; // Если нашли, выходим из функции
    end;

    // Если элемент имеет подменю, ищем рекурсивно в подменю
    if AOwner[I].Count > 0 then
    begin
      Result := FindMenuItem(AOwner[I], AName);
      if Assigned(Result) then
        Exit; // Если нашли в подменю, выходим
    end;
  end;
end;


// преобразование TAccessStatus --> Bool
function TAccessStatusToBool(Status: enumAccessStatus): Boolean;
begin
  if Status = access_ENABLED then Result:=True;
  if Status = access_DISABLED then Result:=False;
end;

// Вспомогательная функция для получения имени элемента TMenuItem
function MenuItemName(AItem: TMenuItem): string;
begin
  Result := AItem.Name;
end;

// Вспомогательная функция для получения количества подменю
function MenuItemCount(AItem: TMenuItem): Integer;
begin
  Result := AItem.Count;
end;

// установка разрешение\запрет на доступ к меню
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


// права доступа
procedure accessRights(var p_TUser: TUser);
 var
  i:Integer;
  Access:enumAccessList;
begin
  with HomeForm do begin

    // HomeForm
    begin
     // панель статусы операторов
     case p_TUser.GetRole of
       role_administrator:begin                  // администратор
        showStatusOperator(False);
       end;
       role_lead_operator:begin                  // ведущий оператор
         showStatusOperator;
       end;
       role_senior_operator:begin               // старший оператор
         showStatusOperator;
       end;
       role_operator:begin                      // оператор
        // панель статусы операторов
        showStatusOperator;
       end;
       role_operator_no_dash:begin             // оператор (без дашборда)
        showStatusOperator;
       end;
       role_supervisor_cov:begin               // Руководитель ЦОВ
        // панель статусы операторов
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


// проверка нужно ли закрыть активную сессию
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

// проверка на 2ую копию дашборда
procedure cloneRun;
const
 dash_name ='dashboard.exe';
var
 dashStart:Cardinal;
begin
  // проверка на запущенную копию
   dashStart:= CreateMutex(nil, True, dash_name);
   if GetLastError = ERROR_ALREADY_EXISTS then
   begin
     MessageBox(HomeForm.Handle,PChar('Обнаружен запуск 2ой копии дашборда'+#13#13+'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
     KillProcess;
   end;
end;

// проверка на актуальную версию
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
   MessageBox(HomeForm.Handle,PChar('Текущая версия дашборда отличается от актуальной версии'+#13#13
                                    +'Перезагрузите компьютер или перезапустите службу обновления ('+UPDATE_EXE+')'),PChar('Ошибка'),MB_OK+MB_ICONINFORMATION);
   KillProcess;
  end;

  // запишем текущую версию дашборда
  begin
//   if FileExists(SETTINGS_XML) then begin
//    XML:=CreateXMLSettingsSingle(PChar(SETTINGS_XML));
//    // обновляем текущий
//    UpdateXMLLocalVersion(XML,PChar(GUID_VESRION));
//   end
//   else begin
//    XML:=CreateXMLSettings(PChar(SETTINGS_XML), PChar(GUID_VESRION));
//   end;
//   FreeXMLSettings(XML);

   if FileExists(SETTINGS_XML) then begin
    XML:=TXML.Create(PChar(SETTINGS_XML));
    // обновляем текущий
    XML.UpdateCurrentVersion(PChar(GUID_VESRION));
   end
   else begin
    XML:=TXML.Create(PChar(SETTINGS_XML),PChar(GUID_VESRION));
   end;
   XML.Free;

  end;

end;

// отображение\сркытие окна запроса на сервер
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   close: begin
     // устанавливаем нормальный размер панельки
     HomeForm.PanelStatusIN.Height:=cPanelStatusHeight_default;
     FormOperatorStatus.Height:=FormOperatorStatus.cHeightStart;

     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// отправка запроса на добавление удаленной команды
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
             Result:='ОШИБКА! Не удалось выполнить запрос'+#13#13+e.ClassName+' '+e.Message;
             Exit;
          end;
      end;
   end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
  Result:='OK';
end;


// проверка есть ли уже такая удаленная команда на сервера
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


// удаленная команда (добавление в очередь)
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
  // выполняем запрос
  resultat:=remoteCommand_Responce(response);
  if AnsiPos('ОШИБКА!',resultat)<>0 then begin
    showWait(close);
    MessageBox(HomeForm.Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ждем пока отработает на core_dashboard
  while (isExistRemoteCommand(command)) do begin
   Sleep(1000);
   Application.ProcessMessages;

   if soLongWait>6 then begin

    // пробуем удалить команду
       response:='delete from remote_commands where sip ='+#39+getUserSIP(SharedCurrentUserLogon.GetID)+#39+
                                                         ' and command ='+#39+IntToStr(TLoggingToInt(command))+#39;

    resultat:=remoteCommand_Responce(response);
    showWait(close);
    MessageBox(HomeForm.Handle,PChar('Команда не обработана из за внутренней ошибки'+#13#13+'Попробуйте еще раз'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;

   end else begin
    Inc(soLongWait);
   end;
  end;

  showWait(close);
end;


// в какой очереди сейчас находится оператор
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
      0:begin              // ни в какой очереди
        Result:=queue_null;
      end;
      1: begin             // либо в 5000 либо в 5050 (надо понять в какой)
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
      2: begin            // в обоих очередях
        Result:=queue_5000_5050;
      end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// очитска текущего статуса оператора
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


  // очищаем текущий статус
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


// проверка и отображение кнопок статусов оператора
procedure checkCurrentStatusOperator(InOperatorStatus:enumStatusOperators);
begin
  with HomeForm do begin

    case InOperatorStatus of
     eAvailable:begin    // доступен
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
     eHome:begin    // домой
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
     eExodus:begin    // исход
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
     eBreak:begin    // перерыв
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
     eDinner:begin   // обед
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
     ePostvyzov:begin   // поствызов
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
     eStudies:begin   // учеба
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
     eIT:begin   // ИТ
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
     eTransfer:begin  // переносы
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
     eReserve:begin  // резерв
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
     eAvailable:begin    // доступен
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
     eHome:begin    // домой
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
     eExodus:begin    // исход
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
     eBreak:begin    // перерыв
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
     eDinner:begin   // обед
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
     ePostvyzov:begin   // поствызов
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
     eStudies:begin   // учеба
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
     eIT:begin   // ИТ
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
     eTransfer:begin  // переносы
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
     eReserve:begin  // резерв
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


// подсчет времени в текущем статусе оператора
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
  // находим последнее время
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  // текущий статуса из лога
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

  // разница во времени
   dateToBD:=StrToDateTime(curr_date);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );
   Result:=getTimeAnsweredSecondsToString(diff);

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


// подсчет времени в статусе OnHold
function getLastStatusTimeOnHold(InStartTimeonHold:string):string;
var
 dateToBD:TDateTime;
 dateNOW:TDateTime;
 diff:Integer;
begin
  // разница во времени
   dateToBD:=StrToDateTime(InStartTimeonHold);
   dateNOW:=Now;
   diff:=Round((dateNOW - dateToBD) * 24 * 60 * 60 );
   Result:=getTimeAnsweredSecondsToString(diff);
end;

// проверка оператор ушел домой или нет
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

    // проверяем есть ли статус 11(домой) за тем 1(выход)
    if Active then Active:=False;

    isGoHome:=False;
    IsExit:=False;

    SQL.Clear;
    SQL.Add('select action from logging where user_id = '+#39+IntToStr(InUserid)+#39+' order by date_time DESC limit 2' );
    Active:=True;

    for i:=0 to 1 do begin
      if Fields[0].Value<>null then begin
         // проверяем есть ли статус выход
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


// проверка вдруг оператор забыл выйти из линии
function getIsExitOperatorCurrentQueue(InCurrentRole:enumRole;InUserID:Integer):Boolean;
begin
 case InCurrentRole of
   role_lead_operator,role_senior_operator,role_operator:begin

     // проверяемв друг еще в очереди находится оператор
     if SharedActiveSipOperators.isExistOperatorInQueue(getUserSIP(InUserID)) then Result:=True
     else Result:=False;

   end
   else Result:=False;
 end;

end;

// проверка вдруг оператор не правильно выходит, нужно выходить через команду "домой"
function getIsExitOperatorCurrentGoHome(InCurrentRole:enumRole;InUserID:Integer):Boolean;
begin
 case InCurrentRole of
   role_lead_operator,role_senior_operator,role_operator:begin

     // проверяемв друг не правильно вышел гаденыш
     if getLastStatusOperator(InUserID) <> eLog_home then Result:=True
     else Result:=False;

   end
   else Result:=False;
 end;

end;


// Транслитерация из рус - > транлирт
function getTranslate(Stroka: string):string;
var
 Translate:TTranslirt;
begin
  Translate:=TTranslirt.Create;
  Result:=Translate.RusToEng(Stroka);
end;

// проверка userID принадлежит оператору или нет TRUE - оператор
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

// перевод даты и времени в ненормальный вид для BD
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


// отключение оператора и перенос его в таблицу operators_disable
procedure disableOperator(InUserId:Integer);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

 // данные оператора из таблиц operators
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


// проверка существу.т ли индивидуальные настрокий пользователч true - существуют настроки
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


// конвертация из TSettingUsersStatus --> Int
function SettingUsersStatusToInt(status:enumSettingUsersStatus):Integer;
begin
  case status of
    settingUsersStatus_ENABLED:   Result:= 1;
    settingUsersStatus_DISABLED:  Result:= 0;
  end;
end;


// сохранение индивидульных настроек пользователя
procedure saveIndividualSettingUser(InUserID:Integer; settings:enumSettingUsers; status:enumSettingUsersStatus);
var
 response:string;
begin
   Screen.Cursor:=crHourGlass;

   case settings of
    settingUsers_gohome: begin // не показывать ушедших домой

      // проверяем есть ли уже запись
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set go_home = '+#39+IntToStr(SettingUsersStatusToInt(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,go_home) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingUsersStatusToInt(status))+#39+')';
      end;
    end;
    settingUsers_noConfirmExit: begin
      // проверяем есть ли уже запись
      if isExistSettingUsers(InUserID) then begin
        response:='update settings_users set no_confirmExit = '+#39+IntToStr(SettingUsersStatusToInt(status))+#39+' where user_id = '+#39+IntToStr(InUserID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,no_confirmExit) values ('+#39+IntToStr(InUserID) +#39+','
                                                                         +#39+IntToStr(SettingUsersStatusToInt(status))+#39+')';
      end;
    end;
   end;

  // выполняем запрос
  remoteCommand_Responce(response);

  Screen.Cursor:=crDefault;
end;

// получение данных об индивидуальных настройках пользователя
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
      settingUsers_gohome: begin // не показывать ушедших домой
        SQL.Add('select go_home from settings_users where user_id = '+#39+IntToStr(InUserID)+#39);
      end;
      settingUsers_noConfirmExit:begin // не показывать "Точно хотите выйти?"
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


// прогрузка индивидуальных настроек пользователя
procedure LoadIndividualSettingUser(InUserId:Integer);
begin
  with HomeForm do begin
    // не показывать ушедших домой
    if getStatusIndividualSettingsUser(InUserId,settingUsers_gohome) = settingUsersStatus_ENABLED then
    begin
       VisibleIconOperatorsGoHome(goHome_Hide);
       chkboxGoHome.Checked:=True;
    end
    else  VisibleIconOperatorsGoHome(goHome_Show);

  end;
end;


// текущий стаус оператора из таблицы logging
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


// текущий стаус оператора из таблицы operators
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

// проверка корректности IP адреса
function getCheckIP(InIPAdtress:string):Boolean;
var
 countDelimiter:Word;
 i:Integer;
 test:string;
begin
  countDelimiter:=0;

  begin
     // проверяем кол-во точек
    for i:=1 to Length(InIPAdtress) do begin
      if InIPAdtress[i] = '.' then Inc(countDelimiter);
    end;

    if countDelimiter <> 3 then begin
      Result:=False;
      Exit;
    end;
  end;

  // проверяем чтобы были только цыфры
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


// проверка на существаование такого алиаса уже, он может быть только один!
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



// получение авторизационных данных при подключени к БД firebird
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


// мониторится ли транк
function GetStatusMonitoring(status:Integer):enumMonitoringTrunk;
begin
  case status of
    0:Result:=monitoring_DISABLE;
    1:Result:=monitoring_ENABLE;
  end;
end;


// получение кол-ва серверов ИК
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


// получение только операторские ID роли
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


// отображение оотдельного окна со статусами оператора
procedure ShowOperatorsStatus;
begin
  FormOperatorStatus.show;

  with HomeForm do begin
    PanelStatus.Visible:=False;
  end;
end;


// изменение позиции панели статусы операторов в зависимости от размера главного окна
procedure ResizeCentrePanelStatusOperators(WidthMainWindow:Integer);
var
 Diff:Integer;
 newLeft:Integer;
begin
 with HomeForm do begin
   Diff:=Round((WidthMainWindow - PanelStatus.Width) / 2);

   newLeft:=Panel_SIP.Left + Diff;

   // чтобы панелька не убегала к краю экрана
   if newLeft >= Panel_SIP.Left  then begin
     PanelStatus.Left:= Panel_SIP.Left + Diff;
   end
   else PanelStatus.Left:= Panel_SIP.Left;
 end;
end;


// показывать\скрывать операторов ушедших домой
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
      ST_operatorsHideCount.Caption:='скрыто: подсчет...';

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

// пасхалка с новым годом
procedure HappyNewYear;
var
  DateNachalo: TDateTime;
begin
  // Определяем дату Нового года
  DateNachalo := EncodeDateTime(YearOf(Now) + 1, 1, 1, 0, 0, 0, 0);

  // Проверяем, находится ли текущая дата в диапазоне от 7 дней до Нового года и 8 дней после
  if (DaysBetween(Now, DateNachalo) <= 8) and (DaysBetween(Now, DateNachalo) >= -7) then
  begin
   HomeForm.ImgNewYear.Visible:=True;
   FormAbout.ImgNewYear.Visible:=True;
   FormAuth.ImgNewYear.Visible:=True;
  end;
end;

//есть ли доступ к локальному чату
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


// открытые exe локального чата
procedure OpenLocalChat;
begin
 if not SharedCurrentUserLogon.GetIsAccessLocalChat then begin
    MessageBox(HomeForm.Handle,PChar('У Вас нет доступа к локальному чату'),PChar('Доступ отсутствует'),MB_OK+MB_ICONINFORMATION);
    Exit;
 end;

  if not FileExists(CHAT_EXE) then begin
    MessageBox(HomeForm.Handle,PChar('Не удается найти файл '+CHAT_EXE),PChar('Файл не найден'),MB_OK+MB_ICONERROR);
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


// есть ли активная сессия уже
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


// проверка запущена ли служба обновления
function GetStatusUpdateService:Boolean;
begin
  Result:=GetTask(UPDATE_EXE);
end;

end.
