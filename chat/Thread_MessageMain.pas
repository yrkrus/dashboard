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
   p_ChatMessage: TOnlineChat; // ������ ������ �� ���������� ������


   public
    constructor Create(var AOnlineChat: TOnlineChat); // ����������� ��� �������� �������

  end;

implementation

uses
  Functions, GlobalVariables, HomeForm;


{ Thread_MessageMain }



constructor ThreadMessageMain.Create(var AOnlineChat: TOnlineChat);
begin
  inherited Create(True); // ������� ����� � ���������� ���������
  p_ChatMessage:= AOnlineChat; // ��������� ���������� ������
end;

procedure ThreadMessageMain.CriticalError;
begin
   FormHome.lblerr.Caption:=GetCurrentTime+' ThreadMessageMain.'+messclass+'.'+mess;
end;



procedure ThreadMessageMain.Show;
var
  last_id:Integer;
  Doc: IHTMLDocument2;
  HTMLContent:string;

    v: Variant;
  HTMLDocument: IHTMLDocument2;

begin

  p_ChatMessage.ShowChat;


  // ��������� ���� �� �� ����� ���������


 // last_id:=GetLastIDMessageFileLog(p_Chat.GetChannel,p_Chat.GetPathToLogName);


 // if not p_Chat.isExistNewMessage(last_id) then Exit;

  // ��������� ����� ���������
//  p_Chat.LoadingMessageMain(enumMessage.eMessage_update);
//  last_id:=GetLastIDMessageFileLog(p_Chat.GetChannel,p_Chat.GetPathToLogName);

//  FormHome.lblerr.Caption:=DateTimeToStr(now);


  with FormHome do begin
// ���� ����� ���������, ���� �� ��������
 // p_Chat.ShowChat;
 end;
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
   Sleep(1000);

  while not Terminated do
  begin

    if UpdateThreadMessageMain then begin
      try
        StartTime:=GetTickCount;

        Queue(show);

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

