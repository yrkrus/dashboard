unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP,IdSSL,
  IdIOHandlerStack, IdSSLOpenSSL;

type
  TFormHome = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    chkboxRegister: TCheckBox;
    chkboxUnRegister: TCheckBox;
    edtSIP: TEdit;
    edtPhone: TEdit;
    btnActive: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure chkboxRegisterClick(Sender: TObject);
    procedure chkboxUnRegisterClick(Sender: TObject);
    procedure btnActiveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type   // тип решистрации
   TRegStatus = (Registration,
                 UnRegistration,
                 test,
                 test2,
                 hold,
                 status_tel);



var
  FormHome: TFormHome;
  isERROR:Boolean;
  sendStatus:TRegStatus;

 const
  CustomHeaders0='Connection:Keep-alive';
  CustomUserAgent='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
  CustomHeaders2='Content-Type:application/x-www-form-urlencoded';
  CustomHeaders3='Accept-Charset:utf-8';
  CustomHeaders4='Accept:application/json, text/javascript, */*; q=0.01';
  version:string = '2.0';



implementation

{$R *.dfm}

function checkFirmwareVersion(response:string):Boolean;
begin
 { if AnsiPos('_RES_INFO_',otvetFirst)<>0 then begin
    MessageBox(FormHome.Handle,PChar('Что то пошло не так!'+#13#13
                                    +'Не удалось авторизоваться в телефоне'),PChar('Ошибка'),MB_OK+MB_ICONERROR);

    isERROR:=True;
    Exit;
  end; }



  if AnsiPos('FirmwareVersion=53.84.14.7',response)<>0 then Result:=True
  else Result:=False;
end;


procedure ShowMessageConnections(status:TRegStatus; otvetFirst:string; isCheckResponse:Boolean);
begin
 Screen.Cursor:=crDefault;

  if isCheckResponse = False then begin
     if (AnsiPos('Connection',otvetFirst)<>0) or
        (AnsiPos('not found',otvetFirst)<>0)
      then begin
      MessageBox(FormHome.Handle,PChar('Не удается связаться с телефоном'+#13
                                      +'проверьте подключение'),PChar('Ошибка'),MB_OK+MB_ICONERROR);

      isERROR:=True;
      Exit;
     end;

     if AnsiPos('Forbidden',otvetFirst)<>0 then begin
      MessageBox(FormHome.Handle,PChar('В телефоне выключен удаленный доступ'),PChar('Ошибка'),MB_OK+MB_ICONERROR);

      isERROR:=True;
      Exit;
     end;
  end;


   // в зависимости от того что сделали находим
   //все ок тут прошли проверки, отправляем на проверку статуса

   { if not checkFirmwareVersion(otvetFirst) then begin
       MessageBox(FormHome.Handle,PChar('Прошивка телефона не подходящая'+#13#13
                                       +'Нужна 53.84.14.7'),PChar('Ошибка'),MB_OK+MB_ICONERROR);

       Exit;
    end; }
  if isCheckResponse then begin
     case sendStatus of
       Registration: begin

         if AnsiPos('Enabled',otvetFirst)<>0 then begin
          MessageBox(FormHome.Handle,PChar('Успешная регистрация'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
         end
         else begin
          MessageBox(FormHome.Handle,PChar('Не удалось зарегистрироваться'+#13#13
                                            +'Response:'+#13
                                            +otvetFirst),PChar('Ошибка'),MB_OK+MB_ICONERROR);
         end;

         Exit;
       end;
       UnRegistration: begin
        if AnsiPos('Disabled',otvetFirst)<>0 then begin
          MessageBox(FormHome.Handle,PChar('Успешная разрегистрация'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
        end
        else begin
          MessageBox(FormHome.Handle,PChar('Не удалось разрегистироваться'+#13#13
                                            +'Response:'+#13
                                            +otvetFirst),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        end;

         Exit;
       end;
       else begin
        MessageBox(FormHome.Handle,PChar('Эта надпись никогда не должна была показаться, но на случай если она покажется то:'+#13#13
                                          +'Response:'+#13
                                          + otvetFirst),PChar('Ошибка'),MB_OK+MB_ICONERROR);
       end;
     end;
  end;
end;


procedure ViewInfoButton(status:TRegStatus);
begin
  with FormHome do begin
    case status of
      Registration:begin
        btnActive.Caption:='Регистрация';
      end;
      UnRegistration:begin
        btnActive.Caption:='Разрегистрация';
      end;
    end;
  end;

end;


// действие
procedure getActionReg(status:TRegStatus; sip:string; phone:string; isCheckResponse:Boolean);
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet,HTTPGet2:string;
begin

  {
  https://admin:asz741@10.34.42.47/servlet?phonecfg=set[&account.1.label=64197][&account.1.display_name=64197][&account.1.auth_name=64197][&account.1.user_name=64197][&account.1.password=1240]

   https://admin:5000@10.34.42.183/screencapture

   Лейбл     = &account.1.label=XXX
   Отображаемое имя = &account.1.display_name=XXX
   Имя регистрации  = &account.1.auth_name=XXX
   Имя пользователя = &account.1.user_name=XXX
   Пароль     = &account.1.password=XXX

   052 - регистрация в ояереди 5000
   050 - выход из очереди 5000

   055 - регистрация в ояереди 5050


     	53.84.14.7 - работающая прошивка

   045 - 5050 очередь
  }

   case status of
      Registration:begin
        HTTPGet:='https://'+phone+'/servlet?phonecfg=set[&account.1.enable=1][&account.1.label='+sip+'][&account.1.display_name='+sip+'][&account.1.auth_name='+sip+'][&account.1.user_name='+sip+'][&account.1.password=159753]';

       // HTTPGet:='https://'+phone+'/servlet?m=mod_action&command=screenshot';


      end;
      UnRegistration:begin
        HTTPGet:='https://'+phone+'/servlet?phonecfg=set[&account.1.enable=0][&account.1.label=''][&account.1.display_name=''][&account.1.auth_name=''][&account.1.user_name=''][&account.1.password='']';
      end;
      test: begin
        HTTPGet:='https://'+phone+'/servlet?key=number=055';

        //HTTPGet:='https://'+phone+'/servlet?key=number=*455050';

      end;
      test2: begin
        HTTPGet:='https://'+phone+'/servlet?key=number=050';

      end;
      hold:begin
       HTTPGet:='https://'+phone+'/servlet?key=reboot';
      end;
      status_tel:begin
       HTTPGet:='https://'+phone+'/servlet?phonecfg=get[&accounts=1]';
      end;

          // https://admin:5000@10.34.42.183/servlet?m=mod_action&command=screenshot
    end;


  http:=TIdHTTP.Create(nil);

  begin
   ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
   ssl.SSLOptions.Method:=sslvTLSv1_2;
   ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
  end;

  with http do begin
    IOHandler:=ssl;
    Request.CustomHeaders.Add(CustomHeaders0);
    Request.UserAgent:=CustomUserAgent;
    Request.CustomHeaders.Add(CustomHeaders2);
    Request.CustomHeaders.Add(CustomHeaders3);
    Request.CustomHeaders.Add(CustomHeaders4);
    Request.Username:='admin';
    Request.Password:='5000';
     // Request.Password:='asz741';
    Request.BasicAuthentication:=True;

     try
      ServerOtvet:=Get(HTTPGet);
      ShowMessageConnections(status,ServerOtvet,isCheckResponse);
     except on E:Exception do
        begin
         ShowMessageConnections(status, e.Message,isCheckResponse);
         //ShowMessage('ОШИБКА! '+e.Message+' / '+e.ErrorMessage);
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;
end;


procedure TFormHome.btnActiveClick(Sender: TObject);
var
 stat:Boolean;
 RegStatus:TRegStatus;
begin
  // проверки
  begin

    //поля
    if edtSIP.Text='' then begin
      MessageBox(Handle,PChar('Не заполнено поле SIP номер'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;

    end;

    if edtPhone.Text='' then begin
      MessageBox(Handle,PChar('Не заполнено поле IP\DNS телефона'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;

    end;

    // действие
    if (chkboxRegister.Checked=False) and (chkboxUnRegister.Checked=False) then begin
      MessageBox(Handle,PChar('Не выбрано действие:'+#13+'Регистрация или разрегистрация'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end;

    if chkboxRegister.Checked then RegStatus:=Registration;
    if chkboxUnRegister.Checked then RegStatus:=UnRegistration;

  end;
   Screen.Cursor:=crHourGlass;
   getActionReg(RegStatus,edtSIP.Text,edtPhone.Text, False);


   if not isERROR then begin
    sendStatus:=RegStatus;
    Screen.Cursor:=crHourGlass;
    getActionReg(status_tel,edtSIP.Text,edtPhone.Text, True);
   end;

end;

procedure TFormHome.Button1Click(Sender: TObject);
begin
  //getActionReg(test,edtSIP.Text,edtPhone.Text, False);
end;

procedure TFormHome.Button2Click(Sender: TObject);
begin
  //getActionReg(test2,edtSIP.Text,edtPhone.Text);
end;

procedure TFormHome.Button3Click(Sender: TObject);
var
 SLlist:TStringList;
 i:Integer;
begin
 { SLlist:=TStringList.Create;
  SLlist.LoadFromFile('1.txt');

  for i:=0 to SLlist.Count-1 do begin
    Application.ProcessMessages;
    Label3.Caption:='reboot '+SLlist[i];
    try
       getActionReg(reboot,'',SLlist[i]);
    finally
       Sleep(5000);
    end;
  end;  }


 // getActionReg(hold,'',edtPhone.Text);

end;

procedure TFormHome.Button4Click(Sender: TObject);
begin
 //getActionReg(status_tel,edtSIP.Text,edtPhone.Text);
end;

procedure TFormHome.chkboxRegisterClick(Sender: TObject);
begin
   if chkboxRegister.Checked then begin
      chkboxUnRegister.Checked:=False;
      ViewInfoButton(Registration);
   end;

end;

procedure TFormHome.chkboxUnRegisterClick(Sender: TObject);
begin
    if chkboxUnRegister.Checked then begin
      chkboxRegister.Checked:=False;
      ViewInfoButton(UnRegistration);
    end;

end;

procedure TFormHome.FormShow(Sender: TObject);
begin
 Caption:=Caption+' ('+version+')';

 isERROR:=False;
end;

end.
