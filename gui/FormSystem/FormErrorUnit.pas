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
    lblInfoErrorEgg: TLabel;
    btnForceUpdate: TBitBtn;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerReconnectBDHostTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnForceUpdateClick(Sender: TObject);
  private
    m_messageError:string;    // ��� ����� ������� ����� ��������� � �������, �� ��������� ������������
    m_timerStatus:Boolean;    // ������ ��� ����� ��� ��� ��������� ������ �� ��������������� � ��
    m_eggMessage:string;      // ������� �����������
    m_forceUpdate:Boolean;    // �������������� ����������
    { Private declarations }
    function IsEmptyString(const AValue:string):Boolean;

  public
    { Public declarations }
   procedure CreateSettings(inMessageError:string;
                            isNeedReconnect: enumNeedReconnectBD = eNeedReconnectYES;
                            isForceUpdate:Boolean = False;
                            EggMessage:string = '');


  end;

var
  FormError: TFormError;
  StartTime:Word = 30;
  Ostatok:Word = 0;


implementation

uses
  FunctionUnit, FormHome, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}

function TFormError.IsEmptyString(const AValue: string):Boolean;
begin
  Result:=True;  // ������� ��� ������ �� ���������

  if Length(AValue) <> 0 then Result:=False;
end;


procedure TFormError.btnForceUpdateClick(Sender: TObject);
begin
  ForceUpdateDashboard(btnClose);
end;

procedure TFormError.CreateSettings(inMessageError:string;
                                    isNeedReconnect: enumNeedReconnectBD = eNeedReconnectYES;
                                    isForceUpdate:Boolean = False;
                                    EggMessage:string = '');
begin
  m_messageError:=inMessageError;   // ��������� ������
  m_eggMessage:='';
  m_forceUpdate:=isForceUpdate;

  if not IsEmptyString(EggMessage) then begin
   m_eggMessage:=EggMessage;
  end;

  m_timerStatus:=EnumNeedReconnectBDToBoolean(isNeedReconnect);     // ����� �� ��������� ������ �� ��������������� � ��
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
   Screen.Cursor:=crDefault;

   CONNECT_BD_ERROR:=True;
   lblErrorInfo.Caption:=m_messageError;

   if not IsEmptyString(m_eggMessage) then begin
    lblInfoErrorEgg.Caption:=m_eggMessage;
   end;

   // �������������� ����������
   if m_forceUpdate then begin
     btnForceUpdate.Visible:=True;

     btnClose.Width:=233;
   end;

   //  ����� ���������� ��������� ���� ��� �� �����
   if not m_timerStatus then lblTime.Visible:=False
   else lblTime.Visible:=True;

   lblTime.Caption:='��������������� ����� '+IntToStr(StartTime)+' ���';
   TimerReconnectBDHost.Enabled:=m_timerStatus;
end;

procedure TFormError.TimerReconnectBDHostTimer(Sender: TObject);
var
  serverConnect:TADOConnection;
begin

  if StartTime-Ostatok = 0 then begin
   lblTime.Caption:='��������������� ...';
     // ��� ���� ��������
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

      //TODO ������� �� ����������� ����� TThread ���������������, � �� ����� timer!!!

  end
  else lblTime.Caption:='��������������� ����� '+IntToStr(StartTime-Ostatok)+' ���';

  Inc(Ostatok);
 // Application.ProcessMessages;
  Sleep(1000);
end;

end.
