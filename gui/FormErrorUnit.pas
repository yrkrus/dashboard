unit FormErrorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Data.Win.ADODB, Data.DB,
  Vcl.Imaging.jpeg, Vcl.Buttons;

type
  TFormError = class(TForm)
    lblErrorInfo: TLabel;
    Label1: TLabel;
    lblTime: TLabel;
    TimerReconnectBDHost: TTimer;
    imgImg: TImage;
    btnClose: TBitBtn;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerReconnectBDHostTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }


  end;

var
  FormError: TFormError;
  StartTime:Word = 10;
  Ostatok:Word = 0;


implementation

uses
  FunctionUnit, FormHome, GlobalVariables;

{$R *.dfm}

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
   TimerReconnectBDHost.Enabled:=True;
end;

procedure TFormError.TimerReconnectBDHostTimer(Sender: TObject);
var
  serverConnect:TADOConnection;
begin

  if StartTime-Ostatok =0 then begin
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
          FormError.Close;
        end;
      end;

  end
  else lblTime.Caption:=IntToStr(StartTime-Ostatok);

  Inc(Ostatok);
  Application.ProcessMessages;
  Sleep(1000);
end;

end.
