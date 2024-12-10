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
var
 Document:OleVariant;
 test:string;

 HTMLContent: string;
  HTMLCode:string;
  ms: TMemoryStream;

  Document2: IHTMLDocument2;
   v: OleVariant;

   Doc: Variant;
begin
Sleep(3000);
  with FormHome do begin
    // HTMLCode:='test';

    // Doc := ChatMain.Document;
   // Doc.Clear;
   // Doc.Write(HTMLCode);
   // Doc.Close;

     { Document := chat_main.Document as IHtmlDocument2;
      v := VarArrayCreate([0, 0], varVariant);
       v[0] := WideString(p_Message.m_message.Text);
      Document.Write(PSafeArray(TVarData(v).VArray));
      Document.Close;
                        }

     { begin

        try
          ms := TMemoryStream.Create;
        try
          p_Message.m_message.Text := HTMLCode;
          p_Message.m_message.SaveToStream(ms);
          ms.Seek(0, 0);
        (WebBrowser1.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
        finally
         ms.Free;
        end;
        finally
        // sl.Free;
        end;
      end;   }


    // chat_main.Refresh2;
    try

     Document:=WebBrowser1.Document;

     HTMLContent:=WideString('<html><head><title>Test</title></head><body>'+p_Message.m_message.Text+'</body></html>');

     Document.Write(HTMLContent);

    finally
       Document.Close;
    end;

  // Doc:= chat_main.Document;
 //  Doc.Clear;
  // Doc.Write(p_Message.m_message.Text);
  // Body:=doc.Body;

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
    filehtml:=ExtractFilePath(ParamStr(0))+'test.html';

    // загружаем пустую страницу
     with FormHome do begin
       try
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

