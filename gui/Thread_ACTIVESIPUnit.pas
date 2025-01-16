unit Thread_ACTIVESIPUnit;

interface

uses
  System.Classes, System.DateUtils, SysUtils, ActiveX, TActiveSIPUnit, Vcl.ComCtrls, TLogFileUnit;

type
  Thread_ACTIVESIP = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure Show(var p_ActiveSipOperators:TActiveSIP);
    procedure CriticalError;
    procedure UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);

  private
   Log:TLoggingFile;
  isCheckThreadSipOperators:Boolean; // ���� ��� �������������� �������� ���� ������� ����������, ����� ������ ��� ������ ��������


  // �������� submenu
  function CreateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                      i: Integer;
                                      ListView: TListView):TListItem;

  // ���������� submenu
  procedure UpdateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                       i: Integer;
                                       ListItem: TListItem);

  end;


implementation

uses
  FunctionUnit, FormHome, FormDEBUGUnit, GlobalVariables, FormOperatorStatusUnit, TCustomTypeUnit, TXmlUnit;



 procedure Thread_ACTIVESIP.CriticalError;
 begin
   // ���������� � ���
   Log.Save(messclass+'.'+mess,IS_ERROR);
 end;


{ Thread_ACTIVESIP }
procedure Thread_ACTIVESIP.UpdateActiveSipOperators(var p_ActiveSipOperators:TActiveSIP);
var
 XML:TXML;
begin
  if not CONNECT_BD_ERROR then begin
    // �������� ���� �� ����� ���������
    p_ActiveSipOperators.checkNewSipOperators(isCheckThreadSipOperators);

    //  ������� ������� �������
    p_ActiveSipOperators.updateStatus;
    p_ActiveSipOperators.updateStatusOnHold;

    // ��� ������ ������� user_id ���������� ���� � ���� ���� ������ � ��������
    // (�� ����� ����������� ����� ��� ���� ������ � ������)
    p_ActiveSipOperators.createUserID;

    // ������� ���� ���������� �������
    p_ActiveSipOperators.updateOnline;
  end;

  // ��������� �����
  with HomeForm.StatusBar do begin
    Panels[0].Text:=DateTimeToStr(now);
    if GetStatusUpdateService then Panels[1].Text:='������ ����������: ��������'
    else Panels[1].Text:='������ ����������: �� ��������';
  end;

  // ������� ������ �������� + ������ �����
  XML:=TXML.Create(PChar(SETTINGS_XML));
  XML.UpdateLastOnline;

  if XML.isUpdate then begin
   HomeForm.lblNewVersionDashboard.Visible:=True;
   // ������������ �������
   SetRandomFontColor(HomeForm.lblNewVersionDashboard);
  end;

  XML.Free;
end;


function Thread_ACTIVESIP.CreateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                                     i: Integer;
                                                     ListView: TListView):TListItem;
var
 ListItem: TListItem;
begin

 ListItem := ListView.Items.Add;
 ListItem.Caption := p_ActiveSipOperators.GetListOperators_SipNumber(i);

  // submenu
  begin
    // ===== ��� ��������� =====
     if p_ActiveSipOperators.GetListOperators_OperatorName(i)<>'null' then
     begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_OperatorName(i)+' ('+p_ActiveSipOperators.GetListOperators_SipNumber(i)+')');
     end
     else begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_SipNumber(i));
     end;


     // ===== ������ =====
     begin
       if p_ActiveSipOperators.GetListOperators_Status(i) = eUnknown then begin // ������ '����������'

         // �������� ���� �� ������ � ��������
         if p_ActiveSipOperators.GetListOperators_AccessDashboad(i) then begin
            // �������� ����� ������������ �������� � ������ ���� �����
            if isOperatorGoHome(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems.Add(getStatus(eHome))
            else ListItem.SubItems.Add('����������');

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
             // ��� ����������� �����
             HomeForm.lblCurrentStatus.Caption:='����������';

             // ��� ���������� �����
             FormOperatorStatus.Caption:='������� ������: ����������';
            end;
         end
         else begin // ������� � �������� ��� ������ ���  ��� "��������� (������ ��� ��������)"

            // ��������� �� � �������
            if p_ActiveSipOperators.GetListOperators_Queue(i) <> '' then begin
               if p_ActiveSipOperators.GetListOperators_TalkTime(i) <>'' then begin
                 ListItem.SubItems.Add('��������');

               end
               else begin
                ListItem.SubItems.Add('��������');
                Inc(p_ActiveSipOperators.countFreeOperators);
               end;
            end
            else begin
              ListItem.SubItems.Add('�����');

            end;
         end;
       end
       else begin

          // �������� ������ �� "��������", ���� �������� � �������������
          if (p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable) and
             (p_ActiveSipOperators.GetListOperators_Queue(i) <> '') and
             ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

            // �������� ����� �������� � ��������� onHold
            if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
              ListItem.SubItems.Add('OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');
            end else begin
              ListItem.SubItems.Add('��������');
            end;

          end else begin
            // ��������� ����� ������� ������ ��������� �������� � �������
            if p_ActiveSipOperators.GetListOperators_Status(i) > eHome then begin

              ListItem.SubItems.Add(getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                    +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                    +')');

            end
            else begin
              // �������� ����� �������� � ��������� onHold (�� ���� ������ �� ���� ����� ��� �������� � ���� �����)
              if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                ListItem.SubItems.Add('OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')');

              end
              else begin
               ListItem.SubItems.Add(getStatus(p_ActiveSipOperators.GetListOperators_Status(i)));

                if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // ���-�� ��������� ����������
                   Inc(p_ActiveSipOperators.countFreeOperators);
                end;
              end;

            end;
          end;

          if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
           // ��� ����������� �����
           HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

            // ��� ���������� �����
            FormOperatorStatus.Caption:='������� ������: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

            // ��������\���������� ������ �������� � ����������� �� �������� ������� ���������
            checkCurrentStatusOperator(p_ActiveSipOperators.GetListOperators_Status(i));
          end;
       end;
     end;


    // ===== �������� =====
    begin
      if p_ActiveSipOperators.GetListOperators_CountTalk(i) = 0 then ListItem.SubItems.Add('0')
      else begin
        // ���� ������� ��������\������� �� ����� ��� ���������� %
         if (SharedCurrentUserLogon.GetRole = role_operator) or (SharedCurrentUserLogon.GetRole = role_lead_operator) then ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i)))
        else ListItem.SubItems.Add(IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')');
      end;
    end;

    // ===== ����� �������� =====
    begin
      if p_ActiveSipOperators.GetListOperators_Phone(i) = '' then begin
       ListItem.SubItems.Add('---');

      end
      else begin
       ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_Phone(i));
       Inc(p_ActiveSipOperators.countActiveCalls);
      end;
    end;

    // ===== ����� ��������� =====
    begin
     if p_ActiveSipOperators.GetListOperators_TalkTime(i) = '' then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_TalkTime(i));
    end;

    // ===== ������� =====
    begin
     if p_ActiveSipOperators.GetListOperators_Queue(i) = '' then ListItem.SubItems.Add('---')
     else ListItem.SubItems.Add(p_ActiveSipOperators.GetListOperators_Queue(i));
    end;

    // ===== ����� ����� ��������� =====
    begin
     if  p_ActiveSipOperators.GetListOperators_TalkTimeAll(i) = 0 then ListItem.SubItems.Add('00:00:00 | 00:00:00')
     else ListItem.SubItems.Add(GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAvg(i))
                                +' | '
                                +GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAll(i)));

    end;
  end;

end;


procedure Thread_ACTIVESIP.UpdateListSubMenuItems(var p_ActiveSipOperators: TActiveSIP;
                                                      i: Integer;
                                                      ListItem: TListItem);

begin
  try
 //  HomeForm.ListViewSIP.Items.BeginUpdate;

    // submenu
    begin
      // ===== ��� ��������� =====
       if p_ActiveSipOperators.GetListOperators_OperatorName(i)<>'null' then
       begin
         ListItem.SubItems[0]:=p_ActiveSipOperators.GetListOperators_OperatorName(i)+' ('+p_ActiveSipOperators.GetListOperators_SipNumber(i)+')';
       end
       else begin
         ListItem.SubItems[0]:=p_ActiveSipOperators.GetListOperators_SipNumber(i);
       end;


       // ===== ������ =====
       begin
         if p_ActiveSipOperators.GetListOperators_Status(i) = eUnknown then begin // ������ '����������'

           // �������� ���� �� ������ � ��������
           if p_ActiveSipOperators.GetListOperators_AccessDashboad(i) then begin
              // �������� ����� ������������ �������� � ������ ���� �����
              if isOperatorGoHome(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i)))) then ListItem.SubItems[1]:=getStatus(eHome)
              else ListItem.SubItems[1]:='����������';

              if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
                 // ��� ����������� �����
                 HomeForm.lblCurrentStatus.Caption:='����������';

                 // ��� ���������� �����
                 FormOperatorStatus.Caption:='������� ������: ����������';
              end;
           end
           else begin // ������� � �������� ��� ������ ���  ��� "��������� (������ ��� ��������)"

              // ��������� �� � �������
              if p_ActiveSipOperators.GetListOperators_Queue(i) <> '' then begin
                 if p_ActiveSipOperators.GetListOperators_TalkTime(i) <>'' then begin
                   ListItem.SubItems[1]:='��������';

                 end
                 else begin
                  ListItem.SubItems[1]:='��������';
                  Inc(p_ActiveSipOperators.countFreeOperators);
                 end;
              end
              else begin
                ListItem.SubItems[1]:='�����';

              end;
           end;
         end
         else begin

            // �������� ������ �� "��������", ���� �������� � �������������
            if (p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable) and
               (p_ActiveSipOperators.GetListOperators_Queue(i) <> '') and
               ((p_ActiveSipOperators.GetListOperators_Phone(i) <> ''){ and (listOperators[i].talk_time<>'')} ) then begin

              // �������� ����� �������� � ��������� onHold
              if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                ListItem.SubItems[1]:='OnHold ('+getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))+')';

              end else begin
                ListItem.SubItems[1]:='��������';
              end;

            end else begin
              // ��������� ����� ������� ������ ��������� �������� � �������
              if p_ActiveSipOperators.GetListOperators_Status(i) > eHome then begin

                ListItem.SubItems[1]:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                      +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                      +')';

              end
              else begin
                // �������� ����� �������� � ��������� onHold (�� ���� ������ �� ���� ����� ��� �������� � ���� �����)
                if p_ActiveSipOperators.GetListOperators_IsOnHold(i) then begin
                  ListItem.SubItems[1]:='OnHold ('
                                                  +getLastStatusTimeOnHold(p_ActiveSipOperators.GetListOperators_OnHoldStartTime(i))
                                                  +')';

                end
                else begin
                 ListItem.SubItems[1]:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i));

                  if p_ActiveSipOperators.GetListOperators_Status(i) = eAvailable then begin // ���-�� ��������� ����������
                     Inc(p_ActiveSipOperators.countFreeOperators);
                  end;
                end;

              end;
            end;

            if p_ActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.GetFamiliya+' '+SharedCurrentUserLogon.GetName then begin
             // ��� ����������� �����
             HomeForm.lblCurrentStatus.Caption:=getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                        +')';
             // ��� ���������� �����
             FormOperatorStatus.Caption:='������� ������: '+getStatus(p_ActiveSipOperators.GetListOperators_Status(i))
                                        +' ('+getLastStatusTime(getUserID(StrToInt(p_ActiveSipOperators.GetListOperators_SipNumber(i))), p_ActiveSipOperators.GetListOperators_Status(i))
                                        +')';

              // ��������\���������� ������ �������� � ����������� �� �������� ������� ���������
              checkCurrentStatusOperator(p_ActiveSipOperators.GetListOperators_Status(i));
            end;
         end;
       end;


      // ===== �������� =====
      begin
        if p_ActiveSipOperators.GetListOperators_CountTalk(i) = 0 then ListItem.SubItems[2]:='0'
        else begin
         // ���� ������� ��������\������� �� ����� ��� ���������� %
         if (SharedCurrentUserLogon.GetRole = role_operator) or (SharedCurrentUserLogon.GetRole = role_lead_operator) then ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))
         else ListItem.SubItems[2]:=IntToStr(p_ActiveSipOperators.GetListOperators_CountTalk(i))+' ('+p_ActiveSipOperators.GetListOperators_CountProcentTalk(i)+')';
        end;
      end;


      // ===== ����� �������� =====
      begin
        if p_ActiveSipOperators.GetListOperators_Phone(i) = '' then begin
          ListItem.SubItems[3]:='---';

        end
        else begin
         ListItem.SubItems[3]:=p_ActiveSipOperators.GetListOperators_Phone(i);
         Inc(p_ActiveSipOperators.countActiveCalls);
        end;
      end;

      // ===== ����� ��������� =====
      begin
       if p_ActiveSipOperators.GetListOperators_TalkTime(i) = '' then ListItem.SubItems[4]:='---'
       else ListItem.SubItems[4]:=p_ActiveSipOperators.GetListOperators_TalkTime(i);
      end;

      // ===== ������� =====
      begin
       if p_ActiveSipOperators.GetListOperators_Queue(i) = '' then ListItem.SubItems[5]:='---'
       else ListItem.SubItems[5]:=p_ActiveSipOperators.GetListOperators_Queue(i);
      end;

      // ===== ����� ����� ��������� =====
      begin
       if  p_ActiveSipOperators.GetListOperators_TalkTimeAll(i) = 0 then ListItem.SubItems[6]:='00:00:00 | 00:00:00'
       else ListItem.SubItems[6]:=GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAvg(i))
                                  +' | '
                                  +GetTimeAnsweredSecondsToString(p_ActiveSipOperators.GetListOperators_TalkTimeAll(i));

      end;
    end;

  finally
  // HomeForm.ListViewSIP.Items.EndUpdate;
  end;

end;

procedure Thread_ACTIVESIP.Show(var p_ActiveSipOperators:TActiveSIP);
var
 i:Integer;
 ListItem: TListItem;
 countActiveSipOperators:Integer;
 existingItem: TListItem;
 idToFind:string;
begin
  with HomeForm do begin

    countActiveSipOperators:=p_ActiveSipOperators.getCountSipOperators;

     if countActiveSipOperators = 0 then begin
       STlist_ACTIVESIP_NO_Rings.Visible:=True;
     end
     else begin
       STlist_ACTIVESIP_NO_Rings.Visible:=False;
     end;

    try

     // ListViewSIP.Items.BeginUpdate;
     // ListViewSIP.Columns[0].Width:= 0; // ��������� ������ � 0 � ������ ��������� ������ �� �� ��� ����� ��������� �����������

      // ������� ListView ����� ����������� ����� ���������
     // ListViewSIP.Clear;


      // �������� �� ���� ����������
      for i:=0 to countActiveSipOperators-1 do
      begin
        idToFind := p_ActiveSipOperators.GetListOperators_SipNumber(i);
        existingItem := nil;

        // ����� ������������� �������� �� id
        for ListItem in ListViewSIP.Items do
        begin
          if ListItem.Caption = idToFind then
          begin
            existingItem := ListItem;
            Break;
          end;
        end;

        if existingItem = nil then
        begin
          // ������� �� ������, ��������� �����
          ListItem:=CreateListSubMenuItems(p_ActiveSipOperators, i, ListViewSIP);
        end
        else
        begin
          // ��������� ������������ �������
          UpdateListSubMenuItems(p_ActiveSipOperators, i, existingItem);
        end;
      end;

      // ���������� ���-�� ��������\��������� ����������
       p_ActiveSipOperators.showActiveAndFreeOperatorsForm;

      // ������� ��������, ������� ����������� � ����� ������
      for i:= ListViewSIP.Items.Count - 1 downto 0 do
      begin
         if not p_ActiveSipOperators.isExistOperator(ListViewSIP.Items[i].Caption) then ListViewSIP.Items.Delete(i);

      end;

    finally
      //ListViewSIP.Items.EndUpdate;
    end;

  end;
end;

procedure Thread_ACTIVESIP.Execute;
const
 SLEEP_TIME:Word = 1000;
var
  StartTime, EndTime  :Cardinal;
  Duration            :Cardinal;
begin
  inherited;
  CoInitialize(Nil);
  Sleep(100);

  Log:=TLoggingFile.Create('Thread_ActiveSip');

  // default ��� ������ �������
  isCheckThreadSipOperators:=True;

  while not Terminated do
  begin

    if UpdateACTIVESIPSTOP then  begin

     try
        StartTime:=GetTickCount;

        UpdateActiveSipOperators(SharedActiveSipOperators);

        //���������� ��� � ��� �� ���������� �� ������� �����
        Show(SharedActiveSipOperators);

        // ���������� ���-�� ������� ���������� ���� ���������� �������� "�� ���������� ������� �����"
        SharedActiveSipOperators.showHideOperatorsForm;


        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_ACTIVESIP.Caption:=IntToStr(Duration);

        // ��������� ����������
        if isCheckThreadSipOperators then isCheckThreadSipOperators:=False;

     except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);

  end;
end;

end.
