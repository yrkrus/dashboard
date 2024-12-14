unit Thread_Users;

interface

uses
  System.Classes, ActiveX, System.DateUtils,System.SysUtils,TOnlineUsersUint, Vcl.ComCtrls;

type
  ThreadUsers = class(TThread)
   messclass,mess: string;

  protected
   procedure Execute; override;
   procedure Show;
   procedure CriticalError;

  private
    p_OnlineUsers: TOnlineUsers; // ������ ������ �� ���������� ������

  public
    constructor Create(var AOnlineUsers: TOnlineUsers); // ����������� ��� �������� �������
  end;

implementation

uses
  HomeForm, Functions, GlobalVariables;


constructor ThreadUsers.Create(var AOnlineUsers: TOnlineUsers);
begin
  inherited Create(True); // ������� ����� � ���������� ���������
  p_OnlineUsers:= AOnlineUsers; // ��������� ���������� ������
end;


procedure ThreadUsers.CriticalError;
begin
   FormHome.lblerr.Caption:=GetCurrentTime+' Thread_Users.'+messclass+'.'+mess;
end;



procedure ThreadUsers.Show;
var
 i:Integer;
begin
  with FormHome do begin
    // TODO ���� ���� ��������� ���������� �������
    StatusBar.Panels[0].Text:=DateTimeToStr(Now);


   if ListBoxOnlineUsers.Count <> p_OnlineUsers.Count then begin
      if ListBoxOnlineUsers.Count = 0 then begin // ������ ������
        for i:=0 to p_OnlineUsers.Count-1 do begin
          ListBoxOnlineUsers.Items.Add(p_OnlineUsers.GetOnlineUsers_FIO(i));
        end;
      end
      else begin // ���������� ������������ �������
        ListBoxOnlineUsers.Clear;

        for i:=0 to p_OnlineUsers.Count-1 do begin
          ListBoxOnlineUsers.Items.Add(p_OnlineUsers.GetOnlineUsers_FIO(i));
        end;
      end;

      if p_OnlineUsers.Count > 0 then STUsersOnline.Caption:='������: '+IntToStr(p_OnlineUsers.Count)
      else STUsersOnline.Caption:='������';
   end;


  end;
end;


procedure ThreadUsers.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
   inherited;
   CoInitialize(Nil);

  while not Terminated do
  begin

    if UpdateThreadUsers then begin
      try
        StartTime:=GetTickCount;

        // ������� ��� � ��� ������ ��������� ������
        p_OnlineUsers.UpdateOnlineUsers;

        Queue(show);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
      except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
