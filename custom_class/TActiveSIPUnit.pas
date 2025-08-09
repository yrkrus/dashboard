/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                      ����� ��� �������� TActiveSIP                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TActiveSIPUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
     Variants, Graphics, System.SyncObjs, IdException, TUserUnit,
     TCustomTypeUnit, TLogFileUnit;

  // class TOnline

  type
    TOnline = class

    public
    date_online             :TDateTime;
    hide                    :Boolean;    // ���� �� ������� �� ������� (true �� ����������� ��������� )

    procedure �lear;                                        // �������

    constructor Create;                     overload;
    destructor Destroy;                     override;

    end;
  // class TOnline END


 // class TStructSIP
   type
      TStructSIP = class

      public

      //id                                     : Integer;
      user_id                                : Integer;       // ID �������� � �� users
      sip_number                             : string;        // ����� ���������
      count_talk                             : integer;       // ���-�� ���������� �������
      count_procent                          : Double;        // % ���������� ������� �� ������ ���-�� �������
      trunk                                  : string;        // ����� � �������� ������ ������
      phone                                  : string;        // ����� ��������
      talk_time                              : string;        // ����� ���������
      queue                                  : enumQueueCurrent;    // ����� �������
      status                                 : enumStatusOperators;       // ������� ������ ���������
      status_delay                           : enumStatusOperators; // ���������� ������ (����� �������� � ���������)
      access_dashboard                       : Boolean;       // ���� �� ������ � ��������
      operator_name                          : string;        // ��� ���������
      isOnHold                               : Boolean;       // �������� ��������� � ������� onHold
      onHoldStartTime                        : string;        // ����� ����� �������� ������� � ������ onHold
      talk_time_all                          : integer;       // ����� ����� ���������
      talk_time_avg                          : Integer;       // ������� ����� ���������
      list_talk_time_all                     : TStringList;   // ������ �� ����� �����������
      online                                 : TOnline;       // ����� � �������


      procedure �lear;                                        // �������

      constructor Create;                     overload;
      destructor Destroy;                     override;


      end;

   // class TStructSIP END


/////////////////////////////////////////////////////////////////////////////////////////
  // class TActiveSIP
  type
      TActiveSIP = class
      const
      cGLOBAL_ListSIPOperators               : Word =  100; // ������ �������
      cHIDETIME_ListSIPOperators             : Word =    5; // ����� � ������� ��� ������� ������� ��� �������� ����� ����� �� �������� ����� ���� �����

      private
      m_mutex                                : TMutex;
      sipOperators                           : TStringList;
      countSipOperators                      : Word;
      countSIpOperatorsHide                  : Word;

      listOperators                          : array of TStructSIP;   // ������ � �����������
      countAllTalkCalls                      : Integer; // ����� ���-�� ���������� �������
      m_logging                              : TLoggingFile;


      procedure Clear;                       // ������� �� ���� ��������
      function GetListOperatorsGoHome:TStringList;    // ������ ���������� ������� ���� �����
      function GetListOperatorsGoHomeNotCloseDashboard:TStringList; // ������ ���������� ������� ���� ����� �� ������ ������� �������
      function GetListOperatorsGoHomeClosedActiveSession:TStringList; // ������ ���������� ������� ���� ����� �������� �������� ������


      public
      countActiveCalls                       :Integer; // ���-�� �������� �������
      countFreeOperators                     :Integer; // ���-�� ��������� ����������

      constructor Create;                     overload;
      destructor Destroy;                     override;


      procedure AddLinkLogFile(var p_Log:TLoggingFile);   // ������ ����� ������������� ������ 1 ��� ����� ����� �������� � ����� ������ �� ��� � �������� ��� ����� ��������� ��� ������ �������
      procedure showActiveAndFreeOperatorsForm;           // ����� �� ������� ����� ������� ������ ���� �������� �
      procedure showHideOperatorsForm;                    // ����� �� ������� ����� ������� ������ ������� ���������� �� ������� "���� �����"

      function  GetCountSipOperators          : Word;     // ���-�� ����������
      function  getCountSipOperatorsHide      : Word;     // ���-�� ���������� (�������)


      procedure generateSipOperators(isReBuild:Boolean; isNotViewGoHome:Boolean = False);        // �������� ������ � �������� �����������  isReBuild = true - ����������� ����������
      procedure updateListTalkTimeAll;                          // ���������� ������ � �������������� ���������

      procedure updateCountTalk;                        // ���������� ���-�� ���������� �������
      procedure updatePhoneTalk;                        // ���������� � ��� ������� ������ ��������
      procedure updateTrunkTalk;                        // ���������� � ����� ����� ������ ������
      procedure updateQueue;                            // ���������� ������� �������
      procedure updateTalkTime;                         // ���������� ������� ���������
      procedure updateTalkTimeAll;                      // ���������� ������� ��������� (�����)
      procedure UpdateStatus;                           // ���������� �������� ������� ���������
      procedure UpdateStatusDelay;                      // ���������� �������� ������� ��������� (���������� �������)
      procedure UpdateStatusOnHold;                     // ���������� �������� ������� �������� ��� ��������� (����� onHold)
      procedure updateOnline;                           // ���������� ������� �������
      procedure createUserID;                           // ��������� ������ user_id � ������


      procedure checkNewSipOperators(isDashStarted:Boolean = False);        // ���������� ������ �������� ���������� ���� ������� ������ ���������
      // true ������ ��� ������ ������� ��������

      function isExistOperatorInQueue(InSip:string):Boolean;        // �������� �������� �� �������� � ����� ���� �������
      function isExistOperator(InSip:string):Boolean;               // �������� ���� �� ��������
      function isExistOperatorInLastActiveBD(InSip:string):Boolean; // �������� ���� �� �������� � ������� active_session



      // ������ TStructSIP
      function GetListOperators_ID(_sip:Integer):Cardinal;              // listOperators.ID
      function GetListOperators_UserID(id:Integer):Integer;             // listOperators.user_id
      function GetListOperators_OperatorName(id:Integer):string;        // listOperators.operator_name
      function GetListOperators_SipNumber(id:Integer):string;           // listOperators.sip_number
      function GetListOperators_Status(id:Integer):enumStatusOperators; // listOperators.status
      function GetListOperators_StatusDelay(id:Integer):enumStatusOperators; // listOperators.status_delay
      function GetListOperators_AccessDashboad(id:Integer):Boolean;     // listOperators.access_dashboard
      function GetListOperators_Queue(id:Integer):enumQueueCurrent;     // listOperators.queue
      function GetListOperators_TalkTime(id:Integer; isReducedTime:Boolean):string;            // listOperators.talk_time
      function GetListOperators_Trunk(id:Integer):string;               // listOperators.trunk
      function GetListOperators_Phone(id:Integer):string;               // listOperators.phone
      function GetListOperators_IsOnHold(id:Integer):Boolean;           // listOperators.isOnHold
      function GetListOperators_OnHoldStartTime(id:Integer):string;     // listOperators.onHoldStartTime
      function GetListOperators_CountTalk(id:Integer):Integer;          // listOperators.count_talk
      function GetListOperators_CountProcentTalk(id:Integer):string;    // listOperators.count_procent
      function GetListOperators_TalkTimeAll(id:Integer):Integer;        // listOperators.list_talk_time_all
      function GetListOperators_TalkTimeAvg(id:Integer):Integer;        // listOperators.list_talk_time_avf
      function GetListOperators_OnlineHide(id:Integer):Boolean;         // listOperators.online.hide
      // ������ TStructSIP END


      function IsTalkOperator(_sip:string):enumStatus;                  // ������������� �� ������ ��������

      end;
 // class TActiveSIP END


implementation

uses
  FunctionUnit, FormHome, GlobalVariables, GlobalVariablesLinkDLL;


// class TOnline START
 constructor TOnline.Create;
 begin
   inherited;
 end;

 destructor TOnline.Destroy;
 begin
  inherited Destroy;              // ����� ����������� ������������� ������
 end;

 procedure TOnline.�lear;
 begin
   Self.hide:=False;
 end;


// class TOnline END


// class TStructSIP START
 constructor TStructSIP.Create;
 begin
   inherited;
   Self.list_talk_time_all:=TStringList.Create;
   Self.status:= eUnknown;
   Self.status_delay:=eUnknown;
   Self.access_dashboard:=False;
   Self.online:=TOnline.Create;
   //id:=0;
   user_id:= -1;
 end;

 destructor TStructSIP.Destroy;
 begin
  FreeAndNil(list_talk_time_all); // ������������ TStringList
  FreeAndNil(online);
  inherited Destroy;              // ����� ����������� ������������� ������
 end;

 procedure TStructSIP.�lear;
 begin
   Self.sip_number:='';
   Self.count_talk:=0;
   Self.count_procent:=0;
   Self.trunk:='';
   Self.phone:='';
   Self.talk_time:='';
   Self.queue:=queue_null;
   Self.status:=eUnknown;
   Self.status_delay:=eUnknown;
   Self.access_dashboard:=False;
   Self.operator_name:='';
   Self.isOnHold:=False;
   Self.onHoldStartTime:='';
   Self.talk_time_all:=0;
   Self.talk_time_avg:=0;
   Self.list_talk_time_all.Clear;
   Self.online.�lear;
 end;
// class TStructSIP END



// class TActiveSIP START
 constructor TActiveSIP.Create;
 var
  i:Integer;
 begin
   inherited;
   m_mutex:=TMutex.Create(nil, False, 'Global\TActiveSIP');

   countSipOperators:=0;
   countSIpOPeratorsHide:=0;

   countActiveCalls:=0;         // ���-�� �������� �������
   countFreeOperators:=0;       // ���-�� ��������� ����������
   countAllTalkCalls:=0;        // ����� ���-�� ���������� ������� �����������


   // ��������� ����� � ��������� �����������
   sipOperators:=TStringList.Create;
   with sipOperators do begin
    Sorted:=True;
    Sort;
   end;

   // ������� ListOperators
   begin
     SetLength(listOperators,cGLOBAL_ListSIPOperators);
     for i:=0 to cGLOBAL_ListSIPOperators-1 do listOperators[i]:=TStructSIP.Create;
   end;
 end;


 destructor TActiveSIP.Destroy;
 var
  i:Integer;
 begin
  m_mutex.Free;
  countSipOperators:=0;

  FreeAndNil(sipOperators); // ������������ TStringList
    // ������������ ������� �������� �������
  for i:= Low(listOperators) to High(listOperators) do listOperators[i].Free; // ����������� ������ ������ TStructSIP
  // ������� �������
  SetLength(listOperators, 0); // ������� ������ �� �������

  inherited Destroy; // ����� ����������� ������������� ������
 end;


 function TActiveSIP.GetCountSipOperators:Word;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
        Result:=countSipOperators;
      finally
        m_mutex.Release;
      end;
    end;
 end;


  function TActiveSIP.getCountSipOperatorsHide:Word;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
        Result:=countSIpOPeratorsHide;
      finally
        m_mutex.Release;
      end;
    end;
 end;


 procedure TActiveSIP.Clear;
 var
  i:Integer;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
         for i:=0 to cGLOBAL_ListSIPOperators-1 do begin
           listOperators[i].�lear;
         end;
         Self.sipOperators.Clear;
         Self.countSipOperators:=0;
         Self.countAllTalkCalls:=0;
      finally
        m_mutex.Release;
      end;
    end;
 end;


 // ������ ���������� ������� ���� �����
function TActiveSIP.GetListOperatorsGoHome:TStringList;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countStatus:Integer;
 i,j:Integer;
 preHome:TStringList;
 operatorExit,operatorGoHome:Boolean;
 GoHomeNotCloseDashboad:TStringList;
 ClosedWidthActiveSession:TStringList;
begin
  Result:=TStringList.Create;
  Result.Sorted:=True;
  Result.Duplicates:=dupIgnore;

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
      SQL.Add('select count(distinct(user_id)) from logging where action='+#39+IntToStr(EnumLoggingToInteger(eLog_home))+#39);
      Active:=True;

      countStatus:=Fields[0].Value;

      if countStatus=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        Exit;
      end;
      if Active then Active:=False;

      // ������ �������� ����� �������� �������� ����� ������ ����� (����� ��� ���������)
       begin
          preHome:=TStringList.Create;

          SQL.Clear;
          SQL.Add('select distinct(user_id) from logging where action='#39+IntToStr(EnumLoggingToInteger(eLog_home))+#39);
          Active:=True;

           for i:=0 to countStatus-1 do begin
             preHome.Add(VarToStr(Fields[0].Value));
             ado.Next;
           end;

         if Active then Active:=False;

         for i:=0 to countStatus-1 do begin
           SQL.Clear;
           SQL.Add('select action from logging where user_id = '#39+preHome[i]+#39+' order by date_time desc limit 2');
           Active:=True;

           operatorExit:=False;
           operatorGoHome:=False;

           for j:=0 to 1 do begin
              if j=0 then begin
                if VarToStr(Fields[0].Value)= '1' then operatorExit:=True;
              end
              else if j=1 then begin
                if VarToStr(Fields[0].Value)= '11' then operatorGoHome:=True;
              end;
             ado.Next;
           end;

           if (operatorExit) and (operatorGoHome) then Result.Add(preHome[i]);
           if Active then Active:=False;
         end;
       end;


       // �������� ���������� ������� ������ ������ �����, �� �� ������� �������
       GoHomeNotCloseDashboad:=GetListOperatorsGoHomeNotCloseDashboard;
       if GoHomeNotCloseDashboad.Count<>0 then begin
         for i:=0 to GoHomeNotCloseDashboad.Count-1 do begin
           Result.Add(GoHomeNotCloseDashboad[i]);
         end;
       end;
       if Assigned(GoHomeNotCloseDashboad) then FreeAndNil(GoHomeNotCloseDashboad);


       // �������� ����� ���� ���������� �������� ����� �������� �������� ������
       ClosedWidthActiveSession:=GetListOperatorsGoHomeClosedActiveSession;
       if ClosedWidthActiveSession.Count<>0 then begin
         for i:=0 to ClosedWidthActiveSession.Count-1 do begin
           Result.Add(ClosedWidthActiveSession[i]);
         end;
       end;
       if Assigned(ClosedWidthActiveSession) then FreeAndNil(ClosedWidthActiveSession);


       // � ������ �������� ����� ���� ���������\����������(������ ��� ������� � ��������)
       begin
         if Active then Active:=False;
         SQL.Clear;
         SQL.Add('select count(distinct(sip)) from queue where sip IN (select sip from operators where user_id IN (select id from users where role = '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39+'))');
         Active:=True;

         countStatus:=Fields[0].Value;
         if countStatus = 0 then begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
            if Assigned(preHome) then FreeAndNil(preHome);
           Exit;
         end;

         if Active then Active:=False;
         SQL.Clear;
         SQL.Add('select distinct(sip) from queue where sip IN (select sip from operators where user_id IN (select id from users where role = '+#39+IntToStr(EnumRoleToInteger(role_operator_no_dash))+#39+'))');
         Active:=True;

         for i:=0 to countStatus-1 do begin
           if getCurrentQueueOperator(VarToStr(Fields[0].Value)) = queue_null then Result.Add(IntToStr(getUserID(StrToInt(VarToStr(Fields[0].Value)))));
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

    Result.Sort;
  end;

  if Assigned(preHome) then FreeAndNil(preHome);
end;


// ������ ���������� ������� ���� ����� �������� �������� ������
function TActiveSIP.GetListOperatorsGoHomeClosedActiveSession:TStringList;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActiveSession:Integer;
 userId:Integer;
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

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select count(distinct(user_id)) from logging where action = '+#39+IntToStr(EnumLoggingToInteger(eLog_exit_force))+#39);
      Active:=True;

      countActiveSession:=Fields[0].Value;

      if countActiveSession = 0 then begin
         FreeAndNil(ado);
         if Assigned(serverConnect) then begin
           serverConnect.Close;
           FreeAndNil(serverConnect);
         end;
         Exit;
      end;

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select distinct user_id from logging where action = '+#39+IntToStr(EnumLoggingToInteger(eLog_exit_force))+#39);
      Active:=True;

      for i:=0 to countActiveSession-1 do begin
        userId:=StrToInt(VarToStr(Fields[0].Value));
        // �������� �������� ��
        if IsUserOperator(userId) then begin
           // �������� ������� ������
         if GetLastStatusOperator(userId) = eLog_exit_force then Result.Add(IntToStr(userId));
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
end;

// ������ ���������� ������� ���� ����� �� ������ ������� ������
function TActiveSIP.GetListOperatorsGoHomeNotCloseDashboard:TStringList;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActiveSession:Integer;
 userId:Integer;
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

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select count(user_id) from active_session where last_active>'+#39+GetNowDateTime+#39);
      Active:=True;

      countActiveSession:=Fields[0].Value;

      if countActiveSession = 0 then begin
         FreeAndNil(ado);
         if Assigned(serverConnect) then begin
           serverConnect.Close;
           FreeAndNil(serverConnect);
         end;
         Exit;
      end;

      if Active then Active:=False;

      SQL.Clear;
      SQL.Add('select user_id,last_active from active_session where last_active>'+#39+GetNowDateTime+#39);
      Active:=True;

      for i:=0 to countActiveSession-1 do begin
       if (Fields[0].Value <> Null) and (Fields[1].Value <> Null) then begin
          userId:=StrToInt(VarToStr(Fields[0].Value));

           // �������� �������� ��
          if IsUserOperator(userId) then begin
             // �������� ��� ������ ����� ���� ������ "�����"
            if getStatusOperator(userId) = eHome then begin
               // �������� �����
               if (Round((Now - VarToDateTime(Fields[1].Value)) * 24 * 60) > cHIDETIME_ListSIPOperators) then begin
                  Result.Add(IntToStr(userId));
               end;
            end;
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
end;

// ������ ����� ������������� ������ 1 ��� ����� ����� �������� � ����� ������ �� ���
// � �������� ��� ����� ��������� ��� ������ �������
 procedure TActiveSIP.AddLinkLogFile(var p_Log:TLoggingFile);
 begin
   Self.m_logging:=p_Log;
 end;

 procedure TActiveSIP.showActiveAndFreeOperatorsForm;
 var
  freeOperator:string;
  activeCalls:string;
 begin
   with HomeForm.lblCount_ACTIVESIP do begin
     if countFreeOperators = 0 then freeOperator:='-'
     else freeOperator:=IntToStr(countFreeOperators);

     if countActiveCalls = 0 then activeCalls:='-'
     else activeCalls:=IntToStr(countActiveCalls);


     Caption:='�������� ������ ('+activeCalls+') | ��������� ��������� ('+freeOperator+')';
   end;

   countActiveCalls:=0;
   countFreeOperators:=0;
 end;


 procedure TActiveSIP.showHideOperatorsForm;
 var
  countHide:Integer;
 begin
   with HomeForm do begin
     if chkboxGoHome.Checked then begin
      countHide:=getCountSipOperatorsHide;

      if countHide > 0 then begin
       ST_operatorsHideCount.Caption:='������: '+IntToStr(countHide);
       ST_operatorsHideCount.Visible:=True;
      end
      else ST_operatorsHideCount.Visible:=False; // �.�. ��� �������, �� � ���������� ��� ������� �� �����
     end
     else ST_operatorsHideCount.Visible:=False;
   end;
 end;



 procedure TActiveSIP.updateListTalkTimeAll;
 var
  i,j:Integer;
  countAnswered:Integer;
  countAll,curr_seconds:Integer;
 begin
   if getCountSipOperators=0 then Exit;

   // ��������� ����� ���������� ���-�� �������
   for i:=0 to Length(listOperators)-1 do begin

      if listOperators[i].sip_number<>'' then begin
        if (listOperators[i].count_talk<>0) then begin

          if (listOperators[i].count_talk > listOperators[i].list_talk_time_all.Count) then begin

            // ���� ������� � �������, ���� ��������� ������ �� ��������
             listOperators[i].list_talk_time_all.Clear;
             listOperators[i].list_talk_time_all:=CreateListAnsweredCall(listOperators[i].sip_number);

             // ��������� � ����� ���-�� ������
             countAll:=0;
             for j:=0 to listOperators[i].list_talk_time_all.Count-1  do begin
               curr_seconds:=GetTimeAnsweredToSeconds(listOperators[i].list_talk_time_all[j]);

               if countAll=0 then countAll:=curr_seconds
               else countAll:=countAll+curr_seconds;
             end;

             // ����� ����� ���������
             listOperators[i].talk_time_all:=countAll;

             // ������� ����� ���������
             if listOperators[i].list_talk_time_all.Count-1 > 0 then listOperators[i].talk_time_avg:=Round(countAll/listOperators[i].list_talk_time_all.Count-1)
             else listOperators[i].talk_time_avg:=Round(countAll);
          end;

        end;

       { else begin // ��������� ����� ������ ��� ��������    ������ ����, �.�. ������������ ������ ������� ���� + �������� ��� ������
           if (listOperators[i].talk_time<>'---') and (listOperators[i].talk_time<>'')  then begin
             curr_seconds:=getTimeAnsweredToSeconds(listOperators[i].talk_time);

            // ������� � ������ ������� ���������
            listOperators[i].talk_time_all:=listOperators[i].talk_time_all+curr_seconds;

            // ������� ����� ���������
            if listOperators[i].list_talk_time_all.Count-1 <>0 then begin
              listOperators[i].talk_time_avg:=Round(listOperators[i].talk_time_all/listOperators[i].list_talk_time_all.Count-1);
            end;
           end;
        end; }
      end;
   end;
 end;


 procedure TActiveSIP.generateSipOperators(isReBuild:Boolean; isNotViewGoHome:Boolean = False);
 var
  count_sip:Integer;
  i,j:Integer;
  isSipNoExist:Boolean;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  operatorsGoHome:TStringList;
  operatorsGoHomeNow:string;

 begin
   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   count_sip:=0;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


    if m_mutex.WaitFor(INFINITE) = wrSignaled  then
    begin
       if isReBuild then begin
          Self.Clear;
       end;

      try

         if isNotViewGoHome = False then begin  // ���������� ���� ����������

           try
             with ado do begin
                ado.Connection:=serverConnect;
                SQL.Clear;


                SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip <> ''-1'' order by sip asc');
                Active:=True;
                if Fields[0].Value<>null then count_sip:=Fields[0].Value;

                 if count_sip>=1 then begin

                    SQL.Clear;
                    SQL.Add('select distinct(sip) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip <> ''-1'' order by sip asc');
                    Active:=True;

                    for i:=0 to count_sip-1 do begin
                      try
                        isSipNoExist:= False;  // ������ � ������ ���

                        // �������� ���� �� ��� ����� �������� � ������
                         for j:=0 to sipOperators.Count-1 do begin
                           if Fields[0].Value = sipOperators[j] then begin
                             isSipNoExist:=True;
                             Break;
                           end;
                         end;

                         // ������� ������ ���������
                         if isSipNoExist=False then sipOperators.Add(Fields[0].Value);
                      finally
                        ado.Next;
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

           // ���-�� ������� ���������� =0, �.�. ���������� ����
           countSIpOPeratorsHide:=0;
         end
         else begin // ���������� ������ ���������� ������� �� ���� �����

           // ������� ��� � ��� ���� �����
            operatorsGoHome:=getListOperatorsGoHome;
            if operatorsGoHome.Count=0 then begin

                FreeAndNil(ado);
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                end;

             // ��� ���� ��� ���� �����, � �� ��� ������� rebuild,
             // ������ ����� �������� ������� generate
             generateSipOperators(False);
             Exit;
            end;

            operatorsGoHomeNow:='';
            for i:=0 to operatorsGoHome.Count-1 do begin
              if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39
              else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39;
            end;

          try
           with ado do begin
              ado.Connection:=serverConnect;
              SQL.Clear;
              SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');

              Active:=True;
              if Fields[0].Value<>null then count_sip:=Fields[0].Value;

               if count_sip<>0 then begin

                  SQL.Clear;
                  SQL.Add('select distinct(sip) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');
                  Active:=True;

                  for i:=0 to count_sip-1 do begin
                    try
                      isSipNoExist:= False;  // ������ � ������ ���

                      // �������� ���� �� ��� ����� �������� � ������
                       for j:=0 to sipOperators.Count-1 do begin
                         if Fields[0].Value = sipOperators[j] then begin
                           isSipNoExist:=True;
                           Break;
                         end;
                       end;

                       // ������� ������ ���������
                       if isSipNoExist=False then sipOperators.Add(Fields[0].Value);
                    finally
                      ado.Next;
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

           if Assigned(operatorsGoHome) then begin
             countSIpOPeratorsHide:=operatorsGoHome.Count;  // ���-�� ������� ����������
             FreeAndNil(operatorsGoHome);
           end;
         end;

           countSipOperators:=count_sip;

           // �������� listOPerators
           for i:=0 to countSipOperators-1 do begin
            isSipNoExist:=False;

             for j:=0 to Length(listOperators)-1 do begin

               // �������� ���� �� ��� ����� �����
               if listOperators[j].sip_number=sipOperators[i] then begin
                  isSipNoExist:=True;
                  Break;
               end;
             end;

              if isSipNoExist = False  then begin
                for j:=0 to Length(listOperators)-1 do begin
                  if listOperators[j].sip_number='' then begin
                    listOperators[j].sip_number:=sipOperators[i];
                    listOperators[j].operator_name:=GetUserNameOperators(sipOperators[i]);

                    // �������� ������ ��������� � ��������
                    listOperators[j].access_dashboard:=getOperatorAccessDashboard(sipOperators[i]);

                    break;
                  end;
                end;
              end;
           end;

      finally
        m_mutex.Release;
      end;
    end;
 end;

 procedure TActiveSIP.updateCountTalk;
 var
  i:Integer;
  oldCount:Integer;
  newCount:Integer;
  isUpdateProcent:Boolean;
  procentCount:Double;
 begin
   if getCountSipOperators=0 then Exit;

   for i:=0 to Length(listOperators)-1 do begin
      if listOperators[i].sip_number<>'' then begin
        isUpdateProcent:=False;

         // ���-�� �������
       oldCount:=listOperators[i].count_talk;
       newCount:=GetCountAnsweredCall(listOperators[i].sip_number);
       if newCount=0 then Continue;


        if oldCount<>newCount then begin
          isUpdateProcent:=True;
          listOperators[i].count_talk:=newCount;
        end;

        if isUpdateProcent then begin
          // % �� ������ ���-�� �������
          countAllTalkCalls:=getCountAnsweredCallAll;
          if countAllTalkCalls>0 then begin
            procentCount:=listOperators[i].count_talk * 100 / countAllTalkCalls;
            listOperators[i].count_procent:=procentCount;
          end;
        end;
      end;
   end;
 end;

 procedure TActiveSIP.updatePhoneTalk;
 var
  i:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

       for i:=0 to Length(listOperators)-1 do begin

          if Active then Active:=False;

          if listOperators[i].sip_number<>'' then begin

              SQL.Clear;
              SQL.Add('select phone from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+listOperators[i].sip_number+#39+' and answered=''1'' and hash is null limit 1');
              Active:=True;

              if Fields[0].Value = null then listOperators[i].phone:=''
              else listOperators[i].phone:=VarToStr(Fields[0].Value);

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


 // ���������� � ����� ����� ������ ������
 procedure TActiveSIP.updateTrunkTalk;
 var
  i:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

       for i:=0 to Length(listOperators)-1 do begin
          if Active then Active:=False;
          if listOperators[i].sip_number<>'' then begin

              if listOperators[i].phone = '' then begin
                listOperators[i].trunk:='';
                Continue;
              end;

              // ��� ������ ��� ��� ��������� �.�. �������� �� ����
              if listOperators[i].trunk = '' then begin
                SQL.Clear;
                SQL.Add('select trunk from ivr where date_time > '+#39+GetNowDateTime+#39+' and phone = '+#39+listOperators[i].phone+#39+' and to_queue = ''1'' order by date_time DESC limit 1');
                Active:=True;

                if Fields[0].Value = null then listOperators[i].trunk:='LISA'
                else listOperators[i].trunk:=VarToStr(Fields[0].Value);
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


 procedure TActiveSIP.updateQueue;
  var
  i,countQueue:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  tempQueue:enumQueueCurrent;
  oldQueue:enumQueueCurrent;
 begin
   if getCountSipOperators=0 then Exit;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

       for i:=0 to Length(listOperators)-1 do begin
         tempQueue:=queue_null;

          if Active then Active:=False;

          if listOperators[i].sip_number<>'' then begin
            oldQueue:=listOperators[i].queue;

            SQL.Clear;
            SQL.Add('select count(id) from operators_queue where sip = '+#39+listOperators[i].sip_number+#39);
            Active:=True;

            countQueue:=Fields[0].Value;

            if countQueue=0 then begin
              listOperators[i].queue:=queue_null;
              Continue;
            end;

            // ������ ��� �������
            SQL.Clear;
            SQL.Add('select queue from operators_queue where sip = '+#39+listOperators[i].sip_number+#39);
            Active:=True;

            if Fields[0].Value <> null then begin
              if countQueue = 1 then begin
                 tempQueue:=StringToEnumQueueCurrent(VarToStr(Fields[0].Value));
              end
              else tempQueue:=queue_5000_5050;
            end;

            if oldQueue<>tempQueue then listOperators[i].queue:=tempQueue;
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


procedure TActiveSIP.UpdateStatus;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

      if Active then Active:=False;

        SQL.Clear;
        SQL.Add('select status from operators where sip = '+#39+listOperators[i].sip_number+#39);
        Active:=True;

       try
          if Fields[0].Value = Null then  begin
            listOperators[i].status:=eUnknown;
          end
          else begin
            listOperators[i].status:=IntegerToEnumStatusOperators(StrToInt(VarToStr(Fields[0].Value)));
          end;
       except
          on E:Exception do
          begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
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
 end;


 procedure TActiveSIP.UpdateStatusDelay;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 logging:enumLogging;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

      if Active then Active:=False;

        SQL.Clear;
        SQL.Add('select command from remote_commands where sip = '+#39+listOperators[i].sip_number+#39 + ' and delay = ''1'' and error = ''0'' ');
        Active:=True;

       try
          if Fields[0].Value = Null then  begin
            listOperators[i].status_delay:=eUnknown;
          end
          else begin
            logging:=IntegerToEnumLogging(StrToInt(VarToStr(Fields[0].Value)));
            listOperators[i].status_delay:=EnumLoggingToStatusOperator(logging);
          end;
       except
          on E:Exception do
          begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
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
 end;

 procedure TActiveSIP.UpdateStatusOnHold;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if countSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

          SQL.Clear;
          SQL.Add('select date_time_start from operators_ohhold where date_time_stop is NULL and sip = '+#39+listOperators[i].sip_number+#39);
          Active:=True;

         try
            if Fields[0].Value = Null then  begin
              listOperators[i].isOnHold:=False;
              listOperators[i].onHoldStartTime:='';
            end
            else begin
              listOperators[i].isOnHold:=True;
              listOperators[i].onHoldStartTime:=VarToStr(Fields[0].Value);
            end;
         except
            on E:Exception do
            begin
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

              UpdateStatus;
              UpdateStatusDelay;
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
 end;



 procedure TActiveSIP.updateTalkTime;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

        if listOperators[i].sip_number<>'' then begin

           SQL.Clear;
           SQL.Add('select talk_time from queue where date_time > '+#39+GetNowDateTime+#39+' and sip = '+#39+listOperators[i].sip_number+#39+' and answered=''1'' and hash is null limit 1');
           Active:=True;

           try
              if Fields[0].Value = Null then  begin
                listOperators[i].talk_time:='';
              end
              else begin
                listOperators[i].talk_time:=VarToStr(Fields[0].Value);
              end;
           except
              on E:Exception do
              begin
                FreeAndNil(ado);
                if Assigned(serverConnect) then begin
                  serverConnect.Close;
                  FreeAndNil(serverConnect);
                end;

                updateTalkTime;
              end;
           end;

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



 procedure TActiveSIP.updateOnline;
 var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

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

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

        if listOperators[i].sip_number<>'' then begin

            // ��� ������ ��������� �.�. ��� ���� ��� � ������
            if not isExistOperatorInLastActiveBD(listOperators[i].sip_number) then Continue;

            SQL.Clear;
            SQL.Add('select last_active from active_session where user_id = '+#39+IntToStr(GetListOperators_UserID(i))+#39+' order by last_active DESC limit 1');
            Active:=True;

           try
              if Fields[0].Value <> Null then  begin
                listOperators[i].online.date_online:= VarToDateTime(Fields[0].Value);

                // ��� �� �������� �� ����� �� �� ����� �� ��������� ��� ����������� ������� "�����"
                if listOperators[i].status = eHome  then begin

                  if (Round((Now - listOperators[i].online.date_online) * 24 * 60) > cHIDETIME_ListSIPOperators) then begin
                     listOperators[i].online.hide:=True;
                  end
                  else listOperators[i].online.hide:=False;
                end;
              end;
           finally
               ado.Next;
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



procedure TActiveSIP.updateTalkTimeAll;
 begin
  // ��������� ����� �����
  updateListTalkTimeAll;
 end;


 // ���������� ������ �������� ���������� ���� ������� ������ ���������
 procedure TActiveSIP.checkNewSipOperators(isDashStarted:Boolean = False);
 var
  count_sip:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  notViewGoHome:Boolean;  // �� ���������� ������� �����
  operatorsGoHome:TStringList;
  operatorsGoHomeNow:string;
  i:Integer;
 begin

   // ��������� ����� �� �� ���������� ������� �����
    if HomeForm.chkboxGoHome.Checked then notViewGoHome:=True
    else notViewGoHome:=False;

     count_sip:=0; //default

    // �������� ������ ������ ��� ���
    if isDashStarted then begin
      if notViewGoHome=False then generateSipOperators(True) // �������� ������ � ��������� �����������
      else generateSipOperators(True,True);                  // �������� ������ � ��������� ����������� + �� �
      Exit;
    end;


  // ��������� ���� �� ����� ���������
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

        if notViewGoHome = False then begin
         SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip <> ''-1'' order by sip asc');

         Active:=True;
         if Fields[0].Value<>null then count_sip:=Fields[0].Value;
        end
        else begin

         operatorsGoHome:=getListOperatorsGoHome;
         if operatorsGoHome.Count=0 then begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;

           // TODO ��������� ��� ���, �.�. ������ �� ����� ������
          // if SharedActiveSipOperators.GetCountSipOperators = 0 then generateSipOperators(True,True);
           if SharedActiveSipOperators.GetCountSipOperators < 4 then generateSipOperators(True,True);

           Exit;
         end;

          if operatorsGoHome.Count<>0 then begin
            operatorsGoHomeNow:='';
            for i:=0 to operatorsGoHome.Count-1 do begin
              if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39
              else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39;
            end;

            SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetNowDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');
            if operatorsGoHome<>nil then FreeAndNil(operatorsGoHome);

            Active:=True;
            if Fields[0].Value<>null then count_sip:=Fields[0].Value;
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

   if count_sip <> getCountSipOperators then begin
     if notViewGoHome=False then generateSipOperators(True) // �������� ������ � ��������� �����������
     else generateSipOperators(True,True);                  // �������� ������ � ��������� ����������� + �� ���������� ������� �����
   end;
 end;



 function TActiveSIP.isExistOperatorInQueue(InSip:string):Boolean;
 var
  i:Integer;
 begin
   for i:=0 to countSipOperators-1 do begin
     if listOperators[i].sip_number = InSip then begin
        if listOperators[i].queue=queue_null then Result:=False
        else Result:=True;
        Break;
     end;
   end;
 end;


 procedure TActiveSIP.createUserID;
  var
  i:Integer;
 begin
   for i:=0 to countSipOperators-1 do begin
     if listOperators[i].access_dashboard then begin
        if listOperators[i].user_id = -1 then begin
          listOperators[i].user_id:=getUserID(StrToInt(listOperators[i].sip_number));
        end;
     end;
   end;
 end;


// �������� ���� �� �������� � ������� active_session
 function TActiveSIP.isExistOperatorInLastActiveBD(InSip:string):Boolean;
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
      SQL.Add('select count(last_active) from active_session where user_id = (select user_id from operators where sip = '+#39+InSip+#39+')' );
      Active:=True;

      if Fields[0].Value <> 0 then Result:=True;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;




 function TActiveSIP.isExistOperator(InSip:string):Boolean;
 var
  i:Integer;
 begin
   Result:=False;

   for i:=0 to cGLOBAL_ListSIPOperators -1 do begin
     if listOperators[i].sip_number = InSip then begin
        Result:=True;
        Break;
     end;
   end;
 end;


 /////////////////////////////// ������ listOPerators /////////////////////////////////////

function TActiveSIP.GetListOperators_ID(_sip:Integer):Cardinal;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      for i:=0 to countSipOperators - 1 do begin
        if listOperators[i].sip_number = IntToStr(_sip) then begin
          Result:=i;
          Break;
        end;
      end;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_UserID(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].user_id;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_OperatorName(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].operator_name;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_SipNumber(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].sip_number;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Status(id:Integer):enumStatusOperators;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].status;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_StatusDelay(id:Integer):enumStatusOperators;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].status_delay;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_AccessDashboad(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].access_dashboard;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Queue(id:Integer):enumQueueCurrent;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].queue;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTime(id:Integer; isReducedTime:Boolean):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      if isReducedTime then Result:=Copy(Self.listOperators[id].talk_time, 4, 5)
      else Result:=Self.listOperators[id].talk_time;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Trunk(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].trunk;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_Phone(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].phone;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_IsOnHold(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].isOnHold;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_OnHoldStartTime(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].onHoldStartTime;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_CountTalk(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].count_talk;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_CountProcentTalk(id:Integer):string;
var
 tmp:string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      tmp:=FormatFloat('0.0',Self.listOperators[id].count_procent);
      tmp:=StringReplace(tmp,',','.',[rfReplaceAll]);
      Result:=tmp+'%';
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTimeAll(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].talk_time_all;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTimeAvg(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].talk_time_avg;
    finally
      m_mutex.Release;
    end;
  end;
end;


function TActiveSIP.GetListOperators_OnlineHide(id:Integer):Boolean;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].online.hide;
    finally
      m_mutex.Release;
    end;
  end;
end;



 /////////////////////////////// ������ listOPerators  END ////////////////////////////////

function TActiveSIP.IsTalkOperator(_sip:string):enumStatus;
var
 i:Integer;
begin
  Result:=eNo;

  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      for i:=0 to Length(listOperators)-1 do begin
        if (_sip = listOperators[i].sip_number) then begin

          if listOperators[i].phone = '' then Result:=eNo
          else Result:=eYes;

          Exit;
        end;
      end;
    finally
      m_mutex.Release;
    end;
  end;


end;


// class TList_ACTIVESIP END



end.
