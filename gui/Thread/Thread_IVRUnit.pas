unit Thread_IVRUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TIVRUnit, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls, TLogFileUnit,
  System.SyncObjs;

type
  Thread_IVR = class(TThread)
  messclass,mess: string;


  protected
    procedure Execute; override;
    procedure show(var p_SharedIVR: TIVR);     // ��������� ������ � ������� �� ������!!
    procedure showIVR(var p_SharedIVR: TIVR);
    procedure CriticalError;
 private
   m_initThread: TEvent;  // ������� ��� ����� ������� ���������
  Log:TLoggingFile;

 public
  constructor Create;
  destructor Destroy; override;
  function WaitForInit(_timeout:Cardinal): Boolean;

  end;


implementation

uses
  FormHome, FunctionUnit, GlobalVariables, TCustomTypeUnit, TDebugStructUnit;

{ Thread_IVR }


constructor Thread_IVR.Create;
begin
  inherited Create(True);               // Suspended=true
  FreeOnTerminate := False;
  m_initThread:=TEvent.Create(nil, False, False, '');
end;


destructor Thread_IVR.Destroy;
begin
  m_initThread.Free;
  inherited;
end;


function Thread_IVR.WaitForInit(_timeout:Cardinal): Boolean;
begin
  if Terminated then Exit(False);
  Result:=(m_initThread.WaitFor(_timeout) = wrSignaled);
end;


procedure Thread_IVR.CriticalError;
begin
   // ���������� � ���
   Log.Save(messclass+':'+mess,IS_ERROR);
end;


procedure Thread_IVR.showIVR(var p_SharedIVR:TIVR);
var
 i:Integer;
 ListItem: TListItem;
 countIVR:Integer;
 existingItem: TListItem;
 idToFind:Integer;
begin
  with HomeForm do begin

    countIVR:=p_SharedIVR.Count;

     if countIVR=0 then begin
       lblCount_IVR.Caption:='IVR';
       STlist_IVR_NO_Rings.Visible:=True;
     end
     else begin
      lblCount_IVR.Caption:='IVR ('+IntToStr(countIVR)+')';
      STlist_IVR_NO_Rings.Visible:=False;
     end;

    try

      for i:=Low(p_SharedIVR.listActiveIVR) to High(p_SharedIVR.listActiveIVR) do begin
        begin
          if p_SharedIVR.listActiveIVR[i].m_id=0 then Continue;

          // �� ���������� ������ �� ������� ����������
          if p_SharedIVR.listActiveIVR[i].m_countNoChange >= TIVR.cGLOBAL_DropPhone then Continue;

          idToFind := p_SharedIVR.listActiveIVR[i].m_id; // �������� id
          existingItem := nil;

          // ����� ������������� �������� �� ������ ��������
          for ListItem in ListViewIVR.Items do
          begin
            if ListItem.Caption = IntToStr(idToFind) then
            begin
              existingItem := ListItem;
              Break;
            end;
          end;

          if existingItem = nil then
          begin
            // ������� �� ������, ��������� �����
            ListItem := ListViewIVR.Items.Add;
            ListItem.Caption := IntToStr(p_SharedIVR.listActiveIVR[i].m_id); // id
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_phone); // ����� ��������
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_waiting_time_start); // ����� ��������
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_trunk); // trunk
          end
          else
          begin
            // ������� ������, ��������� ��� ������
            existingItem.SubItems[1] := p_SharedIVR.listActiveIVR[i].m_waiting_time_start; // ����� ��������
           end;
        end;
      end;

      for i := ListViewIVR.Items.Count - 1 downto 0 do
      begin
        // �������� ������ ��� ���� � �������
        if not p_SharedIVR.isExistActive(StrToInt(ListViewIVR.Items[i].Caption)) then ListViewIVR.Items.Delete(i);

        // i ����� ��������� �� �������,
        // ������� ������ �� ���������� �����
        // �������� ��������� �� ListViewIVR
       if i >= ListViewIVR.Items.Count then Continue;

       if p_SharedIVR.isExistDropPhone(StrToInt(ListViewIVR.Items[i].Caption)) then ListViewIVR.Items.Delete(i);
      end;


    except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
        end;
    end;
  end;
end;


procedure Thread_IVR.show(var p_SharedIVR: TIVR);
begin
  if not CONNECT_BD_ERROR then begin
      p_SharedIVR.UpdateData;
      showIVR(p_SharedIVR);
  end;
end;

procedure Thread_IVR.Execute;
const
 SLEEP_TIME:Word = 1000;
 NAME_THREAD:string = 'Thread_IVR';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

  debugInfo: TDebugStruct;
begin
   inherited;
   CoInitialize(Nil);
  // Sleep(500);
   Log:=TLoggingFile.Create(NAME_THREAD);

  // ����� debug info
  try
     debugInfo:=TDebugStruct.Create(NAME_THREAD,Log);
     SharedCountResponseThread.Add(debugInfo);
  except
    on E:Exception do
    begin
     messclass:=e.ClassName;
     mess:=e.Message;
     Synchronize(CriticalError);
    end;
  end;

  // ������� ��� �����������
  m_initThread.SetEvent;

  while not Terminated do
  begin

    if UpdateIVRSTOP then begin
      try
        StartTime:=GetTickCount;

        show(SharedIVR);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;

        SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
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
