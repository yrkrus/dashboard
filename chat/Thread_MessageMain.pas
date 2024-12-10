unit Thread_MessageMain;

interface

uses
  System.Classes, ActiveX, System.DateUtils,System.SysUtils,
  TOnlineUsersUint, Vcl.ComCtrls,TOnlineChatUnit, System.Variants,
  Vcl.OleCtrls,SHDocVw,MSHTML;

type
  ThreadMessageMain = class(TThread)
    messclass,mess: string;
   procedure Execute; override;
   procedure Show(var p_Message:TOnlineChat);
   procedure CriticalError;
  end;

implementation

uses
  Functions, GlobalVariables, HomeForm;


{ Thread_MessageMain }


procedure ThreadMessageMain.CriticalError;
begin
  // HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_ACTIVESIP_updateTalk.'+messclass+'.'+mess;
end;



procedure ThreadMessageMain.Show(var p_Message:TOnlineChat);
begin
  with FormHome do begin





  end;
end;


procedure ThreadMessageMain.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  MessageMain:TOnlineChat; // текущие собощение в общем чате
  filehtml:string;

  test:Boolean;

begin
   inherited;
   CoInitialize(Nil);
   Sleep(100);

   MessageMain:=TOnlineChat.Create('main');
  //  filehtml:=ExtractFilePath(ParamStr(0))+'test.html';

    // загружаем пустую страницу
     with FormHome do begin
       try
      //  WebBrowser1.Navigate(filehtml);

          WebBrowser1.Navigate('about:blank');

        // WVBrowser1.CreateBrowser(WVWindowParent1.Handle);


       //  if test=False then FormHome.lblerr.Caption:=DateTimeToStr(Now)+' error';



        // WVBrowser1.Navigate('ya.ru');
       except
         on E:Exception do
        begin
        // INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         FormHome.lblerr.Caption:=DateTimeToStr(Now)+' '+messclass+' '+mess;

        // TimeLastError:=Now;

        // if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
        // INTERNAL_ERROR:=False;
        end;
       end;



      // WVWindowParent1.Browser.Navigate('https://ya.ru');



      // WVBrowser1.CreateBrowser(ChatMain.Handle);
      // WVBrowser1.DefaultURL:='ya.ru';
      // WVBrowser1.OpenDefaultDownloadDialog;

     end;


  while not Terminated do
  begin

    if UpdateThreadMessageMain then begin
      try
        StartTime:=GetTickCount;

        show(MessageMain);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
      except
        on E:Exception do
        begin
        // INTERNAL_ERROR:=true;
         messclass:=e.ClassName;
         mess:=e.Message;
         FormHome.lblerr.Caption:=DateTimeToStr(Now)+' '+messclass+' '+mess;

        // TimeLastError:=Now;

        // if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
        // INTERNAL_ERROR:=False;
        end;
      end;
    end;

    if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.

