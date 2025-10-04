unit FormActiveSessionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, TActiveSessionUnit, Vcl.Buttons,
  TThreadDispatcherUnit, System.DateUtils, IdException, 
  System.Generics.Collections,TCustomTypeUnit;

type
  TFormActiveSession = class(TForm)
    group: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    scroll: TScrollBox;
    panel: TPanel;
    Label10: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    BitBtn1: TBitBtn;
    Label17: TLabel;
    btnCloseAllSession: TBitBtn;
    Label11: TLabel;
    Label18: TLabel;
    chkbox_ConfirmKillSession: TCheckBox;
    ST_Loading: TStaticText;
    Label19: TLabel;
    Label20: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Clear;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure scrollMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure scrollMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure btnActionClick(Sender: TObject);
    procedure btnCloseAllSessionClick(Sender: TObject);
    procedure chkbox_ConfirmKillSessionClick(Sender: TObject);
      
  private
    { Private declarations }
  m_active_session    :TActiveSession;
  m_dispatcher        :TThreadDispatcher;

  m_activeCount       :Integer;
  isOneUpdateData     :Boolean;             // ����������� ���������� ������

  procedure ShowInfoActiveSession(var _nextStep:Boolean);          // ����� ���������� ����� ������� ������ 
  procedure CheckedOrUnCheckedConfirmActiveSession;                // �������� ����� ������������ �������� ������
  procedure SetActiveSessionConfirm(var _action:TCheckBox);        // ��������� ��������� "������������ ���������� �������� ������"
  
  procedure Show;   
  procedure CreateForm;  // �������� �����
  procedure ClearForm;   //  ������� �����
  
  function GetPeriodLastOnline(_datetime:TDateTime;
                               var p_lbl:TLabel):string;      // ������� ������ ������� � ������� �������� ������ (� ������ ��� �� �����)

   
  procedure LoadData;  
   
  procedure EnableOrDisableAllNoActiveSession;                                 // ���\���� ������ ��������� ��� �����
  procedure ResizeForm(_countSession:Integer);                                 // ��������� ������ ���� � ����������� �� ���-�� �������
  procedure CenterForm;                                                        // ������������� ����

  
  procedure UpdateOnlyUptimeMemory;                                            // ���������� ������� uptime + memory
  procedure UpdateData;                                                        // ���������� ������

  procedure EnableOrDisableActionButton(_role:enumRole; 
                                        var p_btn:TBitBtn);                    // ���\���� ������ � ����������� �� ���� �������� ������������
                                               
  public
    { Public declarations }
  end;

 const 
 cSIZE_DEFAULT:Word             = 170; // ������ �� ��������� ��� ������ ����
 cSIZE_DEFAULT_MAX:Word         = 870; // ������������ ������ ���� ����� �������� �������� ������
 cSIZE_STEP_GROUP:Word          = 70;  // ������� �� group
 cSIZE_STEP_SCROLL:Word         = 100; // ������� �� scoll
 cSIZE_STEP_SESSION_1_UNIT:Word = 30;  // ��� ����� ������
 cSEZE_PHONE_STARTED_UNIT:Word  = 60;  // ��������� ���-�� ��������� �� ��������� (cSIZE_STEP_SESSION_1_UNIT * 2)
 cSTEP:Word                     = 28;  // ���

var
  FormActiveSession: TFormActiveSession;

implementation

uses
  GlobalVariablesLinkDLL, GlobalImageDestination, FunctionUnit, TXmlUnit, GlobalVariables;


{$R *.dfm}

procedure TFormActiveSession.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Clear;
end;

procedure TFormActiveSession.FormCreate(Sender: TObject);
begin
  SetWindowLong(0, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;


// �������� ����� ������������ �������� ������
procedure TFormActiveSession.CheckedOrUnCheckedConfirmActiveSession;
var
 XML:TXML;
begin   
  try
   XML:=TXML.Create;

   if XML.GetActiveSessionConfirm = 'true' then chkbox_ConfirmKillSession.Checked:=True
   else chkbox_ConfirmKillSession.Checked:=False;
   
  finally
    XML.Free;
  end;    
   
end;


procedure TFormActiveSession.chkbox_ConfirmKillSessionClick(Sender: TObject);
begin 
 SetActiveSessionConfirm(chkbox_ConfirmKillSession);
end;

procedure TFormActiveSession.FormShow(Sender: TObject);
begin 
 
 // �������� ����� ������������ �������� ������
 CheckedOrUnCheckedConfirmActiveSession;

 // ������� ����������
 if not Assigned(m_dispatcher) then begin
  m_dispatcher:=TThreadDispatcher.Create('ActiveSession_update', 1, False, Show);
 end;

 // Show; ��� �� ���� �������, ����� ������ ����������� 1��� � �������)  

 panel.SetFocus;
 m_dispatcher.StartThread;   
end;


procedure TFormActiveSession.Show;
begin
  if not Assigned(m_active_session) then begin
    m_active_session:=TActiveSession.Create;
  end
  else begin
    m_active_session.Update;
  end;

  // ���������� ������ �������� ���-��
  if (m_activeCount = 0) and (not isOneUpdateData) then begin
     m_activeCount:=m_active_session.Count;

     UpdateData;
     Exit;
  end;

  UpdateData;

 // �������� �������� ������
 if SharedCountResponseThread.GetAverageTime('Thread_ActiveSip') > 1000 then begin
   m_dispatcher.SetTimerPeriod( Round((SharedCountResponseThread.GetAverageTime('Thread_ActiveSip') / 1000) ) * 2);
 end
 else begin
   if m_dispatcher.GetTimerPeriod <> 1000 then begin
     m_dispatcher.SetTimerPeriod(1);
   end;
 end;
end;


procedure TFormActiveSession.CreateForm;  // �������� �����
const
  cTOPSTART=5;
  cTOPSTART_BUTTON=2;
var
 lblStatus                  :TArray<TLabel>;
 lblID                      :TArray<TLabel>;
 lblRole                    :TArray<TLabel>;
 lblUserName                :TArray<TLabel>;
 lblPC                      :TArray<TLabel>;
 lblIP                      :TArray<TLabel>;
 lblMemory                  :TArray<TLabel>;
 lblUptime                  :TArray<TLabel>;
 btnAction                  :TArray<TBitBtn>;
 lblPeriod                  :TArray<TLabel>;

 bmp                            :TBitmap;
 i                :Integer;
 nameControl      :string;
 counts           :Integer;
 FindedComponent  :TLabel;

 userID:Integer;
 inQueue:string;  // � ������� ������ ��������� ��� ��� ��������
begin
  counts:=m_active_session.Count;

  // ���������� �����������
  SetLength(lblStatus,counts);
  SetLength(lblID,counts);
  SetLength(lblRole,counts);
  SetLength(lblUserName,counts);
  SetLength(lblPC,counts);
  SetLength(lblIP,counts);
  SetLength(lblMemory,counts);
  SetLength(lblUptime,counts);
  SetLength(btnAction,counts);
  SetLength(lblPeriod,counts);

  // �������� ������� TBitmap
  begin
   if FileExists(ICON_ACTIVE_SESSION) then begin
     bmp := TBitmap.Create;
    try
      // �������� ����������� �� �����
      bmp.LoadFromFile(ICON_ACTIVE_SESSION);
    except

    end;
   end;
  end;


  for i:=0 to counts -1 do begin
    userID:=m_active_session.GetUserID(i);

    nameControl:=IntToStr(userID);
    inQueue:='';

    // �������� ��� �� ��� ����� ����� ��������� ������
    FindedComponent := TLabel(FormActiveSession.panel.FindComponent('lbl_status_' + nameControl));
    if Assigned(FindedComponent) then Continue;

    // ������
    begin
     lblStatus[i]:=TLabel.Create(FormActiveSession.panel);
     lblStatus[i].Name:='lbl_status_'+nameControl;
     lblStatus[i].Tag:=1;
     lblStatus[i].Caption:=EnumOnlineStatusToString(m_active_session.GetOnlineStatus(i));
     // ����
     case m_active_session.GetOnlineStatus(i) of
       eOffline:lblStatus[i].Font.Color:=clRed;
       eOnline:lblStatus[i].Font.Color:=clGreen;
     end;

     lblStatus[i].Left:=20;

     if i=0 then lblStatus[i].Top:=cTOPSTART
     else lblStatus[i].Top:=cTOPSTART+(cSTEP * i);

     lblStatus[i].Font.Name:='Tahoma';
     lblStatus[i].Font.Size:=10;
     lblStatus[i].AutoSize:=False;
     lblStatus[i].Width:=90;
     lblStatus[i].Height:=16;
     lblStatus[i].Alignment:=taCenter;
     lblStatus[i].Font.Style:=[fsBold];
     lblStatus[i].Parent:=FormActiveSession.panel;
    end;

     // id
    begin
     lblID[i]:=TLabel.Create(FormActiveSession.panel);
     lblID[i].Name:='lbl_id_'+nameControl;
     lblID[i].Tag:=1;
     lblID[i].Caption:=IntToStr(userID);
     lblID[i].Left:=125;

     if i=0 then lblID[i].Top:=cTOPSTART
     else lblID[i].Top:=cTOPSTART+(cSTEP * i);

     lblID[i].Font.Name:='Tahoma';
     lblID[i].Font.Size:=10;
     lblID[i].AutoSize:=False;
     lblID[i].Width:=65;
     lblID[i].Height:=16;
     lblID[i].Alignment:=taCenter;
     lblID[i].Parent:=FormActiveSession.panel;
    end;

    // ����
    begin
     lblRole[i]:=TLabel.Create(FormActiveSession.panel);
     lblRole[i].Name:='lbl_role_'+nameControl;
     lblRole[i].Tag:=1;
     lblRole[i].Caption:=EnumRoleToString(m_active_session.GetRole(i));
     lblRole[i].Left:=214;

     if i=0 then lblRole[i].Top:=cTOPSTART
     else lblRole[i].Top:=cTOPSTART+(cSTEP * i);

     lblRole[i].Font.Name:='Tahoma';
     lblRole[i].Font.Size:=10;
     lblRole[i].AutoSize:=False;
     lblRole[i].Width:=175;
     lblRole[i].Height:=16;
     lblRole[i].Alignment:=taCenter;
     lblRole[i].Parent:=FormActiveSession.panel;
    end;

    // ������������
    begin
     lblUserName[i]:=TLabel.Create(FormActiveSession.panel);
     lblUserName[i].Name:='lbl_username_'+nameControl;
     lblUserName[i].Tag:=1;
     lblUserName[i].Caption:=m_active_session.GetUserName(i);
     lblUserName[i].Left:=392;

     if i=0 then lblUserName[i].Top:=cTOPSTART
     else lblUserName[i].Top:=cTOPSTART+(cSTEP * i);

     lblUserName[i].Font.Name:='Tahoma';
     lblUserName[i].Font.Size:=10;
     lblUserName[i].AutoSize:=False;
     lblUserName[i].Width:=175;
     lblUserName[i].Height:=16;
     lblUserName[i].Alignment:=taCenter;
     lblUserName[i].Parent:=FormActiveSession.panel;
    end;

    // ��
    begin
     lblPC[i]:=TLabel.Create(FormActiveSession.panel);
     lblPC[i].Name:='lbl_pc_'+nameControl;
     lblPC[i].Tag:=1;
     lblPC[i].Caption:=m_active_session.GetPC(i);
     lblPC[i].Left:=578;

     if i=0 then lblPC[i].Top:=cTOPSTART
     else lblPC[i].Top:=cTOPSTART+(cSTEP * i);

     lblPC[i].Font.Name:='Tahoma';
     lblPC[i].Font.Size:=10;
     lblPC[i].AutoSize:=False;
     lblPC[i].Width:=100;
     lblPC[i].Height:=16;
     lblPC[i].Alignment:=taCenter;
     lblPC[i].Parent:=FormActiveSession.panel;
    end;

    // IP
    begin
     lblIP[i]:=TLabel.Create(FormActiveSession.panel);
     lblIP[i].Name:='lbl_ip_'+nameControl;
     lblIP[i].Tag:=1;
     lblIP[i].Caption:=m_active_session.GetIP(i);
     lblIP[i].Left:=674;

     if i=0 then lblIP[i].Top:=cTOPSTART
     else lblIP[i].Top:=cTOPSTART+(cSTEP * i);

     lblIP[i].Font.Name:='Tahoma';
     lblIP[i].Font.Size:=10;
     lblIP[i].AutoSize:=False;
     lblIP[i].Width:=140;
     lblIP[i].Height:=16;
     lblIP[i].Alignment:=taCenter;
     lblIP[i].Parent:=FormActiveSession.panel;
    end;

    // memory
    begin
     lblMemory[i]:=TLabel.Create(FormActiveSession.panel);
     lblMemory[i].Name:='lbl_memory_'+nameControl;
     lblMemory[i].Tag:=1;

     if m_active_session.GetOnlineStatus(i) = eOnline then begin
       lblMemory[i].Caption:=m_active_session.GetMemory(i)+' Mb';
     end
     else lblMemory[i].Caption:='---';   //��� ������ �����������.�. ������������ �� ������

     lblMemory[i].Left:=817;

     if i=0 then lblMemory[i].Top:=cTOPSTART
     else lblMemory[i].Top:=cTOPSTART+(cSTEP * i);

     lblMemory[i].Font.Name:='Tahoma';
     lblMemory[i].Font.Size:=10;
     lblMemory[i].AutoSize:=False;
     lblMemory[i].Width:=90;
     lblMemory[i].Height:=16;
     lblMemory[i].Alignment:=taCenter;
     lblMemory[i].Parent:=FormActiveSession.panel;
    end;

    // uptime
    begin
     lblUptime[i]:=TLabel.Create(FormActiveSession.panel);
     lblUptime[i].Name:='lbl_uptime_'+nameControl;
     lblUptime[i].Tag:=1;

     if m_active_session.GetOnlineStatus(i) = eOnline then begin
       lblUptime[i].Caption:=GetTimeAnsweredSecondsToString(m_active_session.GetUptime(i));
     end
     else lblUptime[i].Caption:='---';  //��� ������ ���������� ����� uptime �.�. ������������ �� ������

     lblUptime[i].Left:=905;

     if i=0 then lblUptime[i].Top:=cTOPSTART
     else lblUptime[i].Top:=cTOPSTART+(cSTEP * i);

     lblUptime[i].Font.Name:='Tahoma';
     lblUptime[i].Font.Size:=10;
     lblUptime[i].AutoSize:=False;
     lblUptime[i].Width:=130;
     lblUptime[i].Height:=16;
     lblUptime[i].Alignment:=taCenter;
     lblUptime[i].Parent:=FormActiveSession.panel;
    end;


    // ��������
    begin
      btnAction[i]:=TBitBtn.Create(FormActiveSession.panel);
      if Assigned(bmp) then btnAction[i].Glyph.Assign(bmp);
      btnAction[i].Name:='btn_action_'+nameControl;
      btnAction[i].Tag:=1;
      btnAction[i].Caption:='&��������� ������';
      btnAction[i].Left:=1043;

      if i=0 then btnAction[i].Top:=cTOPSTART_BUTTON
      else btnAction[i].Top:=cTOPSTART_BUTTON+(cSTEP * i);

      btnAction[i].Font.Name:='Tahoma';
      btnAction[i].Font.Size:=8;
      btnAction[i].Width:=144;
      btnAction[i].Height:=26;
      btnAction[i].OnClick:=btnActionClick;
      btnAction[i].Parent:=FormActiveSession.panel;

      // ���\���� ������
      EnableOrDisableActionButton(m_active_session.GetRole(i),btnAction[i]);             
    end;


    // ������
    begin
     lblPeriod[i]:=TLabel.Create(FormActiveSession.panel);
     lblPeriod[i].Name:='lbl_period_'+nameControl;
     lblPeriod[i].Tag:=1;

     // ���� ������ ������������ �������� � ������� �� ���������
     if m_active_session.IsOperator(userID) then begin
       if m_active_session.IsOperatorInQueue(userID) then begin
         inQueue:=' (� �������)';
       end;
     end;

     lblPeriod[i].Caption:=GetPeriodLastOnline(m_active_session.GetLastOnline(i),lblPeriod[i])+ inQueue;
     lblPeriod[i].Left:=1224;

     if i=0 then lblPeriod[i].Top:=cTOPSTART
     else lblPeriod[i].Top:=cTOPSTART+(cSTEP * i);

     lblPeriod[i].Font.Name:='Tahoma';
     lblPeriod[i].Font.Size:=10;
     lblPeriod[i].AutoSize:=False;
     lblPeriod[i].Width:=176;
     lblPeriod[i].Height:=16;
     lblPeriod[i].Alignment:=taCenter;
     lblPeriod[i].Parent:=FormActiveSession.panel;
    end;  
  end;

  // ���\���� ������ ��������� ��� ������
  EnableOrDisableAllNoActiveSession; 

end;

// ������� �����
procedure TFormActiveSession.ClearForm; 
var
  i, j, k, n: Integer;
  Control: TControl;
  GroupBox: TGroupBox;
  ScrollBox: TScrollBox;
  PanelFinded: TPanel;
begin
  // �������� �� ���� ��������� �����
  for i := 0 to Self.ControlCount - 1 do
  begin
    Control := Self.Controls[i];

    // ���������, �������� �� ������� TGroupBox
    if Control is TGroupBox then
    begin
      GroupBox := TGroupBox(Control); // �������� Control � TGroupBox

      // �������� �� ���� �������� ��������� TGroupBox
      for j := 0 to GroupBox.ControlCount - 1 do
      begin
        // ���������, �������� �� �������� ������� TScrollBox
        if GroupBox.Controls[j] is TScrollBox then
        begin
          ScrollBox := TScrollBox(GroupBox.Controls[j]); // �������� Control � TScrollBox

          // �������� �� ���� �������� ��������� TScrollBox
          for k := 0 to ScrollBox.ControlCount - 1 do
          begin
            // ���������, �������� �� �������� ������� TPanel
            if ScrollBox.Controls[k] is TPanel then
            begin
              PanelFinded := TPanel(ScrollBox.Controls[k]); // �������� Control � TPanel

              // ����� ����� ����������� �������� � PanelFinded
              // ��������, ���� ����� ������� ���������� � ������������ Tag
              for n := PanelFinded.ControlCount - 1 downto 0 do
              begin
                if PanelFinded.Controls[n].Tag = 1 then
                begin
                  PanelFinded.Controls[n].Free; // ������� ���������
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;


procedure TFormActiveSession.Clear;
begin
  // ������������� ����������
  if Assigned(m_dispatcher) then m_dispatcher.StopThread;

  ClearForm;  
  m_activeCount:=0;
  isOneUpdateData:=False;
  ST_Loading.Visible:=True; 

  //�������� ������ ���� �� ���������
  ResizeForm(0);    
end;


// ������� ������ ������� � ������� �������� ������ (� ������ ��� �� �����)
function TFormActiveSession.GetPeriodLastOnline(_datetime:TDateTime;
                                               var p_lbl:TLabel):string;
var
  now_time: TDateTime;
  diffMinutes: Integer;
  diffHours: Integer;
begin
  now_time := Now;
  // ��������� ������� � �������
  diffMinutes := MinutesBetween(now_time, _datetime);
  diffHours :=   Round(diffMinutes div 60); // ������������ ������ � ����

  // ���������� ������ � ����������� �� �������
  case diffMinutes of
    1: Result     := '1 ��� �����';
    2: Result     := '2 ��� �����';
    3: Result     := '3 ��� �����';
    5: Result     := '5 ��� �����';
    10: Result    := '10 ��� �����';
    15: Result    := '15 ��� �����';
    30: Result    := '30 ��� �����';
  else
    // ������������ ����
    case diffHours of
      1: Result := '1 ��� �����';
      2: Result := '2 ���� �����';
      3: Result := '3 ���� �����';
      4: Result := '4 ���� �����';
      5..7: Result := Format('%d ����� �����', [diffHours]);
      8..11: Result := Format('%d ����� �����', [diffHours]);
      12..20: Result := Format('%d ����� �����', [diffHours]);
      21: Result := Format('%d ��� �����', [diffHours]);
      22..150: Result := Format('%d ����� �����', [diffHours]);    
    else
      if diffMinutes = 0 then begin
        Result := Format('������ ���', [diffMinutes]);
      end
      else Result := Format('%d ��� �����', [diffMinutes]); // ��� �������, ����� ������� ������ 12 �����
    end;
  end;

  // ��������� ����� ����� � ����������� �� ������� �� �������
  if (diffMinutes >= 0) and (diffMinutes <= 5) then
    p_lbl.Font.Color := $00095314 // �����-�������
  else if (diffMinutes >= 6) and (diffMinutes < 60) then
    p_lbl.Font.Color := clGreen // �������
  else if (diffHours = 1) then
    p_lbl.Font.Color := clRed // �������
  else
   p_lbl.Font.Color := clMaroon; // �����-������� ��� ���� ��������� �������

end;


procedure TFormActiveSession.LoadData;
begin
   // �������� �����
 ClearForm;

 // ������� �����
  CreateForm;
end;

  
// ���\���� ������ ��������� ��� �����
 procedure TFormActiveSession.EnableOrDisableAllNoActiveSession;
 var 
  counts:Integer;
 begin                                 
   // ��������� ���-�� ���������� ������
  counts:=m_active_session.GetNoActiveSessionCount;
  
  if counts > 0 then begin
   btnCloseAllSession.Caption:='&��������� ��� ���������� ������ ('+IntToStr(counts)+')';
   btnCloseAllSession.Enabled:=True;
  end   
  else 
  begin
   btnCloseAllSession.Caption:='&��������� ��� ���������� ������';
   btnCloseAllSession.Enabled:=False;
  end;
 end;



procedure TFormActiveSession.btnCloseAllSessionClick(Sender: TObject);
var
 i:Integer;
 id_list:TList<Integer>;
 error:string;
 
begin
  try 
    // ������ � user id ��� ����������� ��������
    id_list:=TList<Integer>.Create;
    for i:=0 to m_active_session.Count-1 do begin
      if m_active_session.GetOnlineStatus(i) = eOffline then begin
        id_list.Add(m_active_session.GetUserID(i));      
      end;
    end;

    if id_list.Count = 0 then begin
     MessageBox(Handle,PChar('���� �������� ������ ����'),PChar('����������'),MB_OK+MB_ICONINFORMATION);
     Exit;
    end; 

    for i:=0 to id_list.Count - 1 do begin
      error:='';       
      if not m_active_session.DeleteOfflineSession(id_list[i], error) then begin
        MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
        Exit;
      end;    
    end;
  
    MessageBox(Handle,PChar('��� �� �������� ������ �������'),PChar('����������'),MB_OK+MB_ICONINFORMATION);  
  finally
    if Assigned(id_list) then FreeAndNil(id_list);    
  end;       
end;

// ������������� ����
procedure TFormActiveSession.CenterForm;
var
  ScreenWidth, ScreenHeight: Integer;
  FormWidth, FormHeight: Integer;
begin
  // �������� ������� ������
  ScreenWidth   := Screen.Width;
  ScreenHeight  := Screen.Height;

  // �������� ������� �����
  FormWidth   := Width;
  FormHeight  := Height;

  // ��������� ����� ����������
  Left  := (ScreenWidth - FormWidth) div 2;
  Top   := (ScreenHeight - FormHeight) div 2;
end;
 
 
// ��������� ������ ���� � ����������� �� ���-�� �������
procedure TFormActiveSession.ResizeForm(_countSession:Integer);
var
 sizeFormHeight:Integer;
begin
  if _countSession = 0 then begin    
   Caption:='�������� ������';
  end
  else begin
   Caption:='�������� ������ ['+IntToStr(_countSession)+']';
  end;

  // ������ �����
  // ��� �� default
  if _countSession <= 2 then begin
    Height        :=cSIZE_DEFAULT;
    group.Height  :=cSIZE_STEP_SCROLL;
    scroll.Height :=cSIZE_STEP_GROUP;
    panel.Height  :=cSIZE_STEP_GROUP - 10;

    CenterForm;
    Exit;
  end;

  // ���� ������ ������������� ��������
  sizeFormHeight:= cSIZE_STEP_SESSION_1_UNIT * _countSession;
  if sizeFormHeight > cSIZE_DEFAULT_MAX - cSEZE_PHONE_STARTED_UNIT then begin
    Height        :=cSIZE_DEFAULT_MAX;
    group.Height  :=cSIZE_DEFAULT_MAX - cSIZE_STEP_GROUP;
    scroll.Height :=cSIZE_DEFAULT_MAX - cSIZE_STEP_SCROLL;
    panel.Height  :=_countSession * cSIZE_STEP_SESSION_1_UNIT - ((cSIZE_STEP_SESSION_1_UNIT * _countSession) - (_countSession * cSTEP));

    CenterForm;
    Exit;
  end;

  // � �������� ����������� �������
  begin
    Height        := sizeFormHeight + cSIZE_DEFAULT - cSIZE_STEP_GROUP;// - cSIZE_STEP_GROUP;
    group.Height  := Height - cSIZE_STEP_GROUP;
    scroll.Height := Height - cSIZE_STEP_SCROLL;
    panel.Height  := _countSession * cSIZE_STEP_SESSION_1_UNIT - ((cSIZE_STEP_SESSION_1_UNIT * _countSession) - (_countSession * cSTEP));

    CenterForm;
    Exit;
  end;  
end;
    

procedure TFormActiveSession.scrollMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 scroll.VertScrollBar.Position:=scroll.VertScrollBar.Position + Round(cSIZE_STEP_SESSION_1_UNIT / 2);
end;

procedure TFormActiveSession.scrollMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 scroll.VertScrollBar.Position:=scroll.VertScrollBar.Position - Round(cSIZE_STEP_SESSION_1_UNIT / 2);
end;


procedure TFormActiveSession.btnActionClick(Sender: TObject);
var
  btn: TBitBtn;
  id:Integer;
  error:string;
  nextStep:Boolean;
begin
  // �������� Sender � ���� TBitBtn
  if Sender is TBitBtn then
  begin
     btn := TBitBtn(Sender); 
    // ������ id
     try
       id:= StrToInt(Copy(btn.Name, Length('btn_action_') + 1, Length(btn.Name) - Length('btn_action_')));
     except
      on E:EIdException do begin
       MessageBox(Handle,PChar('�������� ������ ��� �������� id'+#13#13+e.Message),PChar('������'),MB_OK+MB_ICONERROR);
        Exit;
      end;
     end;
  
    if id = 1  then begin
     MessageBox(Handle,PChar('������ ������������ ������ ���������'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;    
    end;

    if id = SharedCurrentUserLogon.ID then begin
     MessageBox(Handle,PChar('���� ������ ������ ���������'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
    end;  

  
    // ��������� � ��������� online ������ ��� ��� 
    if m_active_session.IsActiveSession(id) then begin
      // ����������� ���.��� ����� �� ������� �������� ������
      if chkbox_ConfirmKillSession.Checked then begin
        // ����, ���������� ��� ���
        nextStep:=False;
        ShowInfoActiveSession(nextStep);
        if not nextStep then Exit;
      end;  
    end;         

   if not CreateRemoteCommandCallback(remoteCommandAction_activeSession, id, error) then begin
     MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;  
  end;
end;



// ���������� ������
procedure TFormActiveSession.UpdateData;
var
 countActive:Integer;
begin   
  // ������� ���-�� ��������
  countActive:=m_active_session.Count;
  if isOneUpdateData then begin
   if countActive = m_activeCount then
   begin
     // ��������� ������ uptime + memory
     UpdateOnlyUptimeMemory;
     Exit;
   end;
  end;

  // ��������� ������
  LoadData;

  // �������� ������ ����
  ResizeForm(countActive);

  m_activeCount:=countActive;

  isOneUpdateData:=True;

  // �������� ������� �������� 
  ST_Loading.Visible:=False;    
end;

// ���\���� ������ � ����������� �� ���� �������� ������������
procedure TFormActiveSession.EnableOrDisableActionButton(_role:enumRole; var p_btn:TBitBtn);
var
 currentRole:enumRole;
begin
 currentRole:=SharedCurrentUserLogon.GetRole;

 if currentRole = role_administrator then begin
   p_btn.Enabled:=True;
   Exit; 
 end;
 
 
 if (currentRole = role_lead_operator) or
    (currentRole = role_senior_operator) or
    (currentRole = role_operator) or
    (currentRole = role_supervisor_cov) then begin
   if _role = role_administrator then p_btn.Enabled:=False;    
 end;     
 
end;


// ���������� ������� uptime 
procedure TFormActiveSession.UpdateOnlyUptimeMemory;
var
 i:Integer;
 counts:Integer;
 nameControl:string;
 userID:Integer;
 FindedComponent:TLabel;
 inQueue:string;
begin
 counts:=m_active_session.Count;

   for i:=0 to counts - 1 do begin
    userID:=m_active_session.GetUserID(i);

    nameControl:=IntToStr(userID);
    inQueue:='';

    // ������
    begin
       // ������ ���������
      FindedComponent := TLabel(FormActiveSession.panel.FindComponent('lbl_status_' + nameControl));

      if Assigned(FindedComponent) then begin
        FindedComponent.Caption:=EnumOnlineStatusToString(m_active_session.GetOnlineStatus(i));
        // ����
         case m_active_session.GetOnlineStatus(i) of
           eOffline:FindedComponent.Font.Color:=clRed;
           eOnline:FindedComponent.Font.Color:=clGreen;
         end;
      end;     
    end;    
    
    // uptime
    begin
       // ������ ���������
      FindedComponent := TLabel(FormActiveSession.panel.FindComponent('lbl_uptime_' + nameControl));

      if Assigned(FindedComponent) then begin
         if m_active_session.GetOnlineStatus(i) = eOnline then begin
         FindedComponent.Caption:=GetTimeAnsweredSecondsToString(m_active_session.GetUptime(i));
       end
       else FindedComponent.Caption:='---';
      end;
    end;

     // memory
    begin
       // ������ ���������
      FindedComponent := TLabel(FormActiveSession.panel.FindComponent('lbl_memory_' + nameControl));

      if Assigned(FindedComponent) then begin
         if m_active_session.GetOnlineStatus(i) = eOnline then begin
         FindedComponent.Caption:=m_active_session.GetMemory(i)+ ' Mb';
       end
       else FindedComponent.Caption:='---';
      end;
    end;


     // ������ ����������
    begin
       // ������ ���������
      FindedComponent := TLabel(FormActiveSession.panel.FindComponent('lbl_period_' + nameControl));

      if Assigned(FindedComponent) then begin

       // ���� ������ ������������ �������� � ������� �� ���������
       if m_active_session.IsOperator(userID) then begin
         if m_active_session.IsOperatorInQueue(userID) then begin
           inQueue:=' (� �������)';
         end;
       end;

       FindedComponent.Caption:=GetPeriodLastOnline(m_active_session.GetLastOnline(i),FindedComponent)+inQueue;
      end;     
    end;
   
   end;
end;


// ����� ���������� ����� ������� ������ 
procedure TFormActiveSession.ShowInfoActiveSession(var _nextStep:Boolean);
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  DialogResult: Integer;
  confirm:string;
begin 
  AMsgDialog := CreateMessageDialog('����� ������� �������� ������?', mtInformation, [mbYes,mbNo]);
  ACheckBox := TCheckBox.Create(AMsgDialog);

  with AMsgDialog do begin
      try
        Caption:= '��������� ��������';
        Height:= 150;
        (FindComponent('Yes') as TButton).Caption := '��';
        (FindComponent('No')  as TButton).Caption := '���';

        with ACheckBox do begin
          Parent:= AMsgDialog;
          Caption:= '�� ���������� ������ ��� ���������';
          Top:= 100;
          Left:= 8;
          Width:= AMsgDialog.Width;
        end;

        DialogResult:= ShowModal; // ��������� ��������� � ����������

        // ��������� �������� ��������� ���������� ��� ��� � ���������� ��� ���������
        begin
          // �������� �������� ��������� � ��� ����� ���� !=
          if ACheckBox.Checked then ACheckBox.Checked:=False
          else ACheckBox.Checked:=True;         
          SetActiveSessionConfirm(ACheckBox); 
        end;
        
        if DialogResult = ID_YES then
        begin 
          _nextStep:=True;                // ��������� ������          
        end
        else if DialogResult = ID_NO then
        begin
          _nextStep:=False;;              // �����
        end else _nextStep:=False;;       // �����

      finally
        FreeAndNil(ACheckBox);
        Free;
      end;
  end;       
        
end;


// ��������� ��������� "������������ ���������� �������� ������"
procedure TFormActiveSession.SetActiveSessionConfirm(var _action:TCheckBox);
var
 confirm:string;
 XML:TXML;
 
begin
  if not isOneUpdateData then Exit;
  
  if _action.Checked then confirm:='true'
  else confirm:='false';

  try
   XML:=TXML.Create;
   XML.SetActiveSessionConfirm(confirm);
  finally
   XML.Free;
  end;                                   
          
end;

end.
