unit Thread_Users;

interface

uses
  System.Classes, ActiveX, System.DateUtils,System.SysUtils,TOnlineUsersUint, Vcl.ComCtrls;

type
  ThreadUsers = class(TThread)
   messclass,mess: string;
  protected
   procedure Execute; override;
   procedure Show(var p_SharedOnlineUsers: TOnlineUsers);
   procedure CriticalError;

  private


  end;

implementation

uses
  HomeForm, Functions, GlobalVariables;




procedure ThreadUsers.CriticalError;
begin
   FormHome.lblerr.Caption:=GetCurrentTime+' Thread_Users.'+messclass+'.'+mess;
end;



procedure ThreadUsers.Show(var p_SharedOnlineUsers: TOnlineUsers);
var
 i:Integer;
begin
  with FormHome do begin
    // TODO пока сюда зафигачим обновление времени
    StatusBar.Panels[0].Text:=DateTimeToStr(Now);


   if ListBoxOnlineUsers.Count <> p_SharedOnlineUsers.Count then begin
      if ListBoxOnlineUsers.Count = 0 then begin // первый запуск
        for i:=0 to p_SharedOnlineUsers.Count-1 do begin
          ListBoxOnlineUsers.Items.Add(p_SharedOnlineUsers.GetOnlineUsers_FIO(i));
        end;
      end
      else begin // обновление существующих записей
        ListBoxOnlineUsers.Clear;

        for i:=0 to p_SharedOnlineUsers.Count-1 do begin
          ListBoxOnlineUsers.Items.Add(p_SharedOnlineUsers.GetOnlineUsers_FIO(i));
        end;
      end;

      if p_SharedOnlineUsers.Count > 0 then STUsersOnline.Caption:='Онлайн: '+IntToStr(p_SharedOnlineUsers.Count)
      else STUsersOnline.Caption:='Онлайн';
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

   //Sleep(1000);

  while not Terminated do
  begin

    if UpdateThreadUsers then begin
      try
        StartTime:=GetTickCount;

        // обновим кто у нас сейчас находится онлайн
        SharedOnlineUsers.UpdateOnlineUsers;

        show(SharedOnlineUsers);

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
