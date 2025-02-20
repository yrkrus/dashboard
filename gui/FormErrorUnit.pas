unit FormErrorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Data.Win.ADODB, Data.DB,
  Vcl.Imaging.jpeg, Vcl.Buttons, TCustomTypeUnit;

type
  TFormError = class(TForm)
    lblTime: TLabel;
    TimerReconnectBDHost: TTimer;
    btnClose: TBitBtn;
    img_pashalka: TImage;
    Panel1: TPanel;
    lblErrorInfo: TLabel;
    Label1: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerReconnectBDHostTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    m_messageError:string;    // сам текст который будем заполнять с ошибкой, он выводится пользователю
    m_timerStatus:Boolean;    // статус что нужно или нет запускать таймер на переподключение к БД
    { Private declarations }
  public
    { Public declarations }
   procedure CreateSettings(inMessageError:string; isNeedReconnect: enumNeedReconnectBD = eNeedReconnectYES);


  end;

var
  FormError: TFormError;
  StartTime:Word = 30;
  Ostatok:Word = 0;


implementation

uses
  FunctionUnit, FormHome, GlobalVariables;

{$R *.dfm}

procedure TFormError.CreateSettings(inMessageError:string;  isNeedReconnect: enumNeedReconnectBD = eNeedReconnectYES);
begin
  m_messageError:=inMessageError;   // текстовка ошибки
  m_timerStatus:=EnumNeedReconnectBDToBoolean(isNeedReconnect);     // нужно ли запустить таймер на переподключение к БД
end;


procedure TFormError.btnCloseClick(Sender: TObject);
begin
   KillProcess;
end;

procedure TFormError.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerReconnectBDHost.Enabled:=False;
  Ostatok:=0;
end;

procedure TFormError.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormError.FormShow(Sender: TObject);
begin
   CONNECT_BD_ERROR:=True;
   lblErrorInfo.Caption:=m_messageError;

   //  смысл показывать реконнект если его не будет
   if not m_timerStatus then lblTime.Visible:=False
   else lblTime.Visible:=True;

   lblTime.Caption:='Переподключение через '+IntToStr(StartTime)+' сек';
   TimerReconnectBDHost.Enabled:=m_timerStatus;
end;

procedure TFormError.TimerReconnectBDHostTimer(Sender: TObject);
var
  serverConnect:TADOConnection;
begin

  if StartTime-Ostatok = 0 then begin
   lblTime.Caption:='Переподключение ...';
     // еще одна проверка
      try
        serverConnect:=createServerConnect;
        if not Assigned(serverConnect) then Exit;
        Ostatok:=0;
      finally
        if serverConnect.Connected then begin

          serverConnect.Close;
          FreeAndNil(serverConnect);

          TimerReconnectBDHost.Enabled:=False;

          CONNECT_BD_ERROR:=False;
          FormError.Close;
        end;
      end;

      //TODO сделать по человечески через TThread переподключение, а не через timer!!!

  end
  else lblTime.Caption:='Переподключение через '+IntToStr(StartTime-Ostatok)+' сек';

  Inc(Ostatok);
  Application.ProcessMessages;
  Sleep(1000);
end;

end.
