/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                      ����� ��� �������� TActiveSIP                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TActiveSIPUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants, Graphics, System.SyncObjs, IdException, TUserUnit;

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

      id                                     : Integer;
      user_id                                : Integer;       // ID �������� � �� users
      sip_number                             : string;        // ����� ���������
      count_talk                             : integer;       // ���-�� ���������� �������
      phone                                  : string;        // ����� ��������
      talk_time                              : string;        // ����� ���������
      queue                                  : string;        // ����� �������
      status                                 : integer;       // ������� ������ ���������
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


      procedure Clear;                       // ������� �� ���� ��������


      public
      countActiveCalls                       :Integer; // ���-�� �������� �������
      countFreeOperators                     :Integer; // ���-�� ��������� ����������

      constructor Create;                     overload;
      destructor Destroy;                     override;


      procedure showActiveAndFreeOperatorsForm;           // ����� �� ������� ����� ������� ������ ���� �������� �
      procedure showHideOperatorsForm;                    // ����� �� ������� ����� ������� ������ ������� ���������� �� ������� "���� �����"

      function  getCountSipOperators          : Word;     // ���-�� ����������
      function  getCountSipOperatorsHide      : Word;     // ���-�� ���������� (�������)


      procedure generateSipOperators(isReBuild:Boolean; isNotViewGoHome:Boolean = False);        // �������� ������ � �������� �����������  isReBuild = true - ����������� ����������
      procedure updateListTalkTimeAll;                          // ���������� ������ � �������������� ���������

      procedure updateCountTalk;                        // ���������� ���-�� ���������� �������
      procedure updatePhoneTalk;                        // ���������� � ��� ������� ������ ��������
      procedure updateQueue;                            // ���������� ������� �������
      procedure updateTalkTime;                         // ���������� ������� ���������
      procedure updateTalkTimeAll;                      // ���������� ������� ��������� (�����)
      procedure updateStatus;                           // ���������� �������� ������� ���������
      procedure updateStatusOnHold;                     // ���������� �������� ������� �������� ��� ��������� (����� onHold)
      procedure updateOnline;                           // ���������� ������� �������
      procedure createUserID;                           // ��������� ������ user_id � ������


      procedure checkNewSipOperators(isDashStarted:Boolean = False);        // ���������� ������ �������� ���������� ���� ������� ������ ���������
      // true ������ ��� ������ ������� ��������

      function isExistOperatorInQueue(InSip:string):Boolean;      // �������� �������� �� �������� � ����� ���� �������
      function isExistOperator(InSip:string):Boolean;             // �������� ���� �� ��������
      function isExistOperatorInLastActiveBD(InSip:string):Boolean; // �������� ���� �� �������� � ������� active_session



      // ������ TStructSIP
      function GetListOperators_ID(id:Integer):Cardinal;             // listOperators.ID
      function GetListOperators_UserID(id:Integer):Integer;          // listOperators.user_id
      function GetListOperators_OperatorName(id:Integer):string;     // listOperators.operator_name
      function GetListOperators_SipNumber(id:Integer):string;        // listOperators.sip_number
      function GetListOperators_Status(id:Integer):Integer;          // listOperators.status
      function GetListOperators_AccessDashboad(id:Integer):Boolean;  // listOperators.access_dashboard
      function GetListOperators_Queue(id:Integer):string;            // listOperators.queue
      function GetListOperators_TalkTime(id:Integer):string;         // listOperators.talk_time
      function GetListOperators_Phone(id:Integer):string;            // listOperators.phone
      function GetListOperators_IsOnHold(id:Integer):Boolean;        // listOperators.isOnHold
      function GetListOperators_OnHoldStartTime(id:Integer):string;  // listOperators.onHoldStartTime
      function GetListOperators_CountTalk(id:Integer):Integer;       // listOperators.count_talk
      function GetListOperators_TalkTimeAll(id:Integer):Integer;     // listOperators.list_talk_time_all
      function GetListOperators_TalkTimeAvg(id:Integer):Integer;     // listOperators.list_talk_time_avf
      function GetListOperators_OnlineHide(id:Integer):Boolean;      // listOperators.online.hide
      // ������ TStructSIP END

      end;
 // class TActiveSIP END


implementation

uses
  FunctionUnit, FormHome, GlobalVariables;


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
   Self.status:= -1;
   Self.access_dashboard:=False;
   Self.online:=TOnline.Create;
   id:=0;
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
   Self.phone:='';
   Self.talk_time:='';
   Self.queue:='';
   Self.status:=-1;
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

   countActiveCalls:=0;   // ���-�� �������� �������
   countFreeOperators:=0; // ���-�� ��������� ����������

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


 function TActiveSIP.getCountSipOperators:Word;
 begin
    if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
      try
        // Result:=sipOperators.Count;
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
        // Result:=sipOperators.Count;
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
      finally
        m_mutex.Release;
      end;
    end;
 end;


 procedure TActiveSIP.showActiveAndFreeOperatorsForm;
 begin
   with HomeForm.lblCount_ACTIVESIP do begin
     Caption:='�������� ������ ('+IntToStr(countActiveCalls)+') | ��������� ��������� ('+IntToStr(countFreeOperators)+')';
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




     end else ST_operatorsHideCount.Visible:=False;
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

          if listOperators[i].count_talk > listOperators[i].list_talk_time_all.Count then begin

            // ���� ������� � �������, ���� ��������� ������ �� ��������
             listOperators[i].list_talk_time_all.Clear;
             listOperators[i].list_talk_time_all:=createListAnsweredCall(listOperators[i].sip_number);

             // ��������� � ����� ���-�� ������
             countAll:=0;
             for j:=0 to listOperators[i].list_talk_time_all.Count-1  do begin
               curr_seconds:=getTimeAnsweredToSeconds(listOperators[i].list_talk_time_all[j]);

               if countAll=0 then countAll:=curr_seconds
               else countAll:=countAll+curr_seconds;
             end;

             // ����� ����� ���������
             listOperators[i].talk_time_all:=countAll;

             // ������� ����� ���������
             listOperators[i].talk_time_avg:=Round(countAll/listOperators[i].list_talk_time_all.Count-1);
          end
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
   if not Assigned(serverConnect) then Exit;

    if m_mutex.WaitFor(INFINITE) = wrSignaled  then
    begin
      try

         if isNotViewGoHome = False then begin  // ���������� ���� ����������

          if isReBuild then begin
            Self.Clear;
          end;

             with ado do begin
                ado.Connection:=serverConnect;
                SQL.Clear;


                SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip <> ''-1'' order by sip asc');
                Active:=True;
                if Fields[0].Value<>null then count_sip:=Fields[0].Value;

                 if count_sip>=1 then begin

                    SQL.Clear;
                    SQL.Add('select distinct(sip) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip <> ''-1'' order by sip asc');
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
                        Next;
                      end;
                    end;
                 end;
             end;

           // ���-�� ������� ���������� =0, �.�. ���������� ����
           countSIpOPeratorsHide:=0;
         end
         else begin // ���������� ������ ���������� ������� �� ���� �����

           // ������� ��� � ��� ���� �����
            operatorsGoHome:=getListOperatorsGoHome(Self);
            if operatorsGoHome.Count=0 then begin
             FreeAndNil(ado);
             serverConnect.Close;
             FreeAndNil(serverConnect);
             Exit;
            end;


            if isReBuild then begin
              Self.Clear;
            end;

            operatorsGoHomeNow:='';
            for i:=0 to operatorsGoHome.Count-1 do begin
              if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39
              else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39;
            end;
           with ado do begin
              ado.Connection:=serverConnect;
              SQL.Clear;
              SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');

              Active:=True;
              if Fields[0].Value<>null then count_sip:=Fields[0].Value;

               if count_sip<>0 then begin

                  SQL.Clear;
                  SQL.Add('select distinct(sip) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');
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
                      Next;
                    end;
                  end;
               end;
           end;

           if operatorsGoHome<>nil then begin
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
                    listOperators[j].operator_name:=getUserNameOperators(sipOperators[i]);

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

    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
 end;

 procedure TActiveSIP.updateCountTalk;
 var
  i:Integer;
  oldCount:Integer;
  newCount:Integer;
 begin
   if getCountSipOperators=0 then Exit;

   for i:=0 to Length(listOperators)-1 do begin
      if listOperators[i].sip_number<>'' then begin
         oldCount:=listOperators[i].count_talk;
         newCount:=getCountAnsweredCall(listOperators[i].sip_number);

         if oldCount<>newCount then listOperators[i].count_talk:=newCount;
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
   if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

     for i:=0 to Length(listOperators)-1 do begin

        if Active then Active:=False;

        if listOperators[i].sip_number<>'' then begin

            SQL.Clear;
            SQL.Add('select phone from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip = '+#39+listOperators[i].sip_number+#39+' and answered=''1'' and hash is null limit 1');
            Active:=True;

            if Fields[0].Value = null then listOperators[i].phone:=''
            else listOperators[i].phone:=VarToStr(Fields[0].Value);

          Next;
        end;
     end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
 end;


 procedure TActiveSIP.updateQueue;
  var
  i,j,countQueue:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  tempQueue:string;
  oldQueue:string;
 begin
   if getCountSipOperators=0 then Exit;

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
   if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

     for i:=0 to Length(listOperators)-1 do begin
       tempQueue:='';

        if Active then Active:=False;

        if listOperators[i].sip_number<>'' then begin
          oldQueue:=listOperators[i].queue;

          SQL.Clear;
          SQL.Add('select count(id) from operators_queue where sip = '+#39+listOperators[i].sip_number+#39);
          Active:=True;

          countQueue:=Fields[0].Value;

          if countQueue=0 then begin
            listOperators[i].queue:='';
            Continue;
          end;

          // ������ ��� �������
          SQL.Clear;
          SQL.Add('select queue from operators_queue where sip = '+#39+listOperators[i].sip_number+#39);
          Active:=True;


          for j:=0 to countQueue-1 do begin

            if Fields[0].Value <> null then begin
               if tempQueue='' then tempQueue:=VarToStr(Fields[0].Value)
               else tempQueue:=tempQueue+' � '+VarToStr(Fields[0].Value);
            end;
            Next;
          end;

          if oldQueue<>tempQueue then listOperators[i].queue:=tempQueue;

        end;
     end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
 end;


 procedure TActiveSIP.updateStatus;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if getCountSipOperators=0 then Exit;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

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
            listOperators[i].status:=-1;
          end
          else begin
            listOperators[i].status:=StrToInt(VarToStr(Fields[0].Value));
          end;
       except
          on E:Exception do
          begin
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);
           Exit;
          end;
       end;

        Next;
   end;

  end;

   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);

 end;


 procedure TActiveSIP.updateStatusOnHold;
var
  i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 begin
  if countSipOperators=0 then Exit;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

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
            updateStatus;
          end;
       end;

        Next;
   end;

  end;

   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);

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
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

   for i:=0 to Length(listOperators)-1 do begin

      if Active then Active:=False;

      if listOperators[i].sip_number<>'' then begin

         SQL.Clear;
         SQL.Add('select talk_time from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip = '+#39+listOperators[i].sip_number+#39+' and answered=''1'' and hash is null limit 1');
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
              updateTalkTime;
            end;
         end;

        Next;
      end;
   end;

  end;

   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);

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
  if not Assigned(serverConnect) then Exit;

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
              if listOperators[i].status = 2  then begin

                if (Round((Now - listOperators[i].online.date_online) * 24 * 60) > cHIDETIME_ListSIPOperators) then begin
                   listOperators[i].online.hide:=True;
                end
                else listOperators[i].online.hide:=False;
              end;
            end;
         finally
             Next;
         end;
      end;
   end;
  end;

   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);

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
   if not Assigned(serverConnect) then Exit;

   with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      if notViewGoHome = False then begin
       SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip <> ''-1'' order by sip asc');

       Active:=True;
       if Fields[0].Value<>null then count_sip:=Fields[0].Value;
      end
      else begin

       operatorsGoHome:=getListOperatorsGoHome(Self);
        {if operatorsGoHome.Count=0 then begin
         FreeAndNil(ado);
         serverConnect.Close;
         FreeAndNil(serverConnect);
         Exit;
        end;}
        if operatorsGoHome.Count<>0 then begin
          operatorsGoHomeNow:='';
          for i:=0 to operatorsGoHome.Count-1 do begin
            if operatorsGoHomeNow='' then operatorsGoHomeNow:=#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39
            else operatorsGoHomeNow:=operatorsGoHomeNow+','+#39+getUserSIP(StrToInt(operatorsGoHome[i]))+#39;
          end;

          SQL.Add('select count(distinct(sip)) from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and sip not IN ('+operatorsGoHomeNow+') and sip <> ''-1'' order by sip asc');
          if operatorsGoHome<>nil then FreeAndNil(operatorsGoHome);

          Active:=True;
          if Fields[0].Value<>null then count_sip:=Fields[0].Value;
        end;
      end;


   end;

   FreeAndNil(ado);
   serverConnect.Close;
   FreeAndNil(serverConnect);

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
        if listOperators[i].queue='' then Result:=False
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


 function TActiveSIP.isExistOperatorInLastActiveBD(InSip:string):Boolean;
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
    SQL.Add('select count(last_active) from active_session where user_id = (select user_id from operators where sip = '+#39+InSip+#39+')' );
    Active:=True;

    if Fields[0].Value <> 0 then Result:=True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

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

function TActiveSIP.GetListOperators_ID(id:Integer):Cardinal;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].id;
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


function TActiveSIP.GetListOperators_Status(id:Integer):Integer;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].status;
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


function TActiveSIP.GetListOperators_Queue(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].queue;
    finally
      m_mutex.Release;
    end;
  end;
end;

function TActiveSIP.GetListOperators_TalkTime(id:Integer):string;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
    try
      Result:=Self.listOperators[id].talk_time;
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

// class TList_ACTIVESIP END



end.
