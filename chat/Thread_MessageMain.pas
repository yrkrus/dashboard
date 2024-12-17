unit Thread_MessageMain;

interface

uses
  System.Classes, ActiveX, System.DateUtils,System.SysUtils,
  TOnlineUsersUint, Vcl.ComCtrls,TOnlineChatUnit, System.Variants,
  Vcl.OleCtrls,SHDocVw,MSHTML,Vcl.Controls;

type
  ThreadMessageMain = class(TThread)
    messclass,mess: string;

   procedure Execute; override;
   procedure Show;
   procedure CriticalError;

   private
   p_ChatMessage: TOnlineChat; // Храним ссылку на переданный объект


   public
    constructor Create(var AOnlineChat: TOnlineChat); // Конструктор для передачи объекта

  end;

implementation

uses
  Functions, GlobalVariables, HomeForm;


{ Thread_MessageMain }



constructor ThreadMessageMain.Create(var AOnlineChat: TOnlineChat);
begin
  inherited Create(True); // Создаем поток в неактивном состоянии
  p_ChatMessage:= AOnlineChat; // Сохраняем переданный объект
end;

procedure ThreadMessageMain.CriticalError;
begin
   FormHome.lblerr.Caption:=GetCurrentTime+' ThreadMessageMain.'+messclass+'.'+mess;
end;


procedure ThreadMessageMain.Show;
begin
  p_ChatMessage.ShowChat;
end;


procedure ThreadMessageMain.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  m_browser:TWebBrowser;

begin
   inherited;
   CoInitialize(Nil);

   // делаем инициализацию браузеров
   p_ChatMessage.InitBrowser;

  while not Terminated do
  begin

    if UpdateThreadMessageMain then begin
      try
        StartTime:=GetTickCount;

        // Queue(show);
        Show;

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
      except
        on E:Exception do
        begin
         INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
        // TimeLastError:=Now;
         Synchronize(CriticalError);
         INTERNAL_ERROR:=False;
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.

