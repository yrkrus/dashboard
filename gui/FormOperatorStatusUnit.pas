unit FormOperatorStatusUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, TCustomTypeUnit;

type
  TFormOperatorStatus = class(TForm)
    PanelStatus: TPanel;
    lblLevelCheck: TLabel;
    btnStatus_available: TButton;
    btnStatus_exodus: TButton;
    btnStatus_break: TButton;
    btnStatus_dinner: TButton;
    btnStatus_postvyzov: TButton;
    btnStatus_studies: TButton;
    btnStatus_IT: TButton;
    btnStatus_transfer: TButton;
    btnStatus_home: TButton;
    btnStatus_add_queue5000: TButton;
    btnStatus_add_queue5050: TButton;
    btnStatus_add_queue5000_5050: TButton;
    btnStatus_del_queue_all: TButton;
    btnStatus_reserve: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStatus_availableClick(Sender: TObject);
    procedure btnStatus_exodusClick(Sender: TObject);
    procedure btnStatus_breakClick(Sender: TObject);
    procedure btnStatus_dinnerClick(Sender: TObject);
    procedure btnStatus_postvyzovClick(Sender: TObject);
    procedure btnStatus_studiesClick(Sender: TObject);
    procedure btnStatus_ITClick(Sender: TObject);
    procedure btnStatus_transferClick(Sender: TObject);
    procedure btnStatus_reserveClick(Sender: TObject);
    procedure btnStatus_homeClick(Sender: TObject);
    procedure btnStatus_add_queue5000Click(Sender: TObject);
    procedure btnStatus_add_queue5050Click(Sender: TObject);
    procedure btnStatus_add_queue5000_5050Click(Sender: TObject);
    procedure btnStatus_del_queue_allClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function GetCalculateHeightStart:Word;
    function GetCalculateHeightRegister:Word;
    procedure Button2Click(Sender: TObject);
  private
  procedure SendCommand(_command:enumLogging;_userID:Integer); // �������� ��������� �������

    { Private declarations }
  public
    { Public declarations }
  const
   cHeightStart:Word      =83;
   cHeightRegister:Word   =126;
  end;




var
  FormOperatorStatus: TFormOperatorStatus;

implementation

uses
  FunctionUnit, GlobalVariables, FormHome;

{$R *.dfm}

// �������� ��������� �������
procedure TFormOperatorStatus.SendCommand(_command:enumLogging;_userID:Integer);
var
 error:string;
begin
 if isExistRemoteCommand(_command,_userID) then begin
   MessageBox(Handle,PChar('���������� ����� �� ������� ��� �� ����������'),PChar('������� � �������� ���������'),MB_OK+MB_ICONINFORMATION);
   Exit;
 end;

 if not remoteCommand_addQueue(_command,error) then begin
   MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
  Exit;
 end;
end;



// ������������ ������� ���� �� default
// ��� ����� �� �� ���� ��� ���� ���������� ������ ��� 100%, �� ���� �� ��� ������������
function TFormOperatorStatus.GetCalculateHeightStart:Word;
begin

 // while (lblLevelCheck.) do begin


 // end;
     {

� Delphi �� ������ ������� �������, ������� ����� ���������, ���������� �� �������� ���������� �� �����, � ���� ���, ������������� �������� ������ �����. ��� ������ ����� �������:

procedure AdjustFormSizeToFitControls(AForm: TForm);
var
  Control: TControl;
  TotalHeight, MaxWidth: Integer;
begin
  TotalHeight := 0;
  MaxWidth := 0;

  // �������� �� ���� ��������� ���������� �� �����
  for Control in AForm.Controls do
  begin
    // ������� ����� ������ � ������������ ������
    TotalHeight := TotalHeight + Control.Height + 8; // ��������� ������
    if Control.Width > MaxWidth then
      MaxWidth := Control.Width;
  end;

  // ������������� ����� ������ �����
  AForm.Height := TotalHeight + AForm.BorderWidth * 2 + AForm.CaptionHeight;

  // ������������� ����� ������ �����
  AForm.Width := MaxWidth + AForm.BorderWidth * 2;
end;


��� ������������ ��� �������:



    �������� AdjustFormSizeToFitControls(Self); � ������ ����� ������ ����, ��������, � ������� OnCreate ����� ��� ����� ����������/��������� ��������� ����������.



    ���������, ��� � ��� ���� ����������� �������, ����� �������� �� ��������� � ����� �����.



����������:


    ��� ������� ��������� � �������� ��������� ������ ����� (TForm), ������� �� ������ ����������.

    � ������� ����������� ������ � ������ ��������� ����������, � ����� ������� ��� ����� ����������� �����������.

    �� ������ ��������� ������, ����� ��������� ������ ������������ ���� ��������� ���������� (��������, ������ TButton), ���� ��� ����������.



     }


  Result:=cHeightStart;
end;

function TFormOperatorStatus.GetCalculateHeightRegister:Word;
begin
  Result:=cHeightRegister;
end;

procedure TFormOperatorStatus.btnStatus_add_queue5000Click(Sender: TObject);
begin
 SendCommand(eLog_add_queue_5000,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_add_queue5000_5050Click(
  Sender: TObject);
begin
 SendCommand(eLog_add_queue_5000_5050,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_add_queue5050Click(Sender: TObject);
begin
 SendCommand(eLog_add_queue_5050,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_availableClick(Sender: TObject);
var
 curr_queue:enumQueueCurrent;
begin
   if Height=GetCalculateHeightRegister then begin
    Height:=GetCalculateHeightStart;
    Exit;
   end;

   Screen.Cursor:=crHourGlass;

   Height:=GetCalculateHeightRegister;

  // ��������� � ����� ������� ��������� ��������
  curr_queue:=getCurrentQueueOperator(getUserSIP(SharedCurrentUserLogon.GetID));

  case curr_queue of
    queue_5000:begin
      btnStatus_add_queue5000.Enabled:=False;
      btnStatus_add_queue5050.Enabled:=True;
      btnStatus_add_queue5000_5050.Enabled:=False;
      btnStatus_del_queue_all.Enabled:=True;
    end;
    queue_5050:begin
      btnStatus_add_queue5000.Enabled:=True;
      btnStatus_add_queue5050.Enabled:=False;
      btnStatus_add_queue5000_5050.Enabled:=False;
      btnStatus_del_queue_all.Enabled:=True;
    end;
    queue_5000_5050:begin
      btnStatus_add_queue5000.Enabled:=False;
      btnStatus_add_queue5050.Enabled:=False;
      btnStatus_add_queue5000_5050.Enabled:=False;
      btnStatus_del_queue_all.Enabled:=True;
    end;
    queue_null:begin
      btnStatus_add_queue5000.Enabled:=True;
      btnStatus_add_queue5050.Enabled:=True;
      btnStatus_add_queue5000_5050.Enabled:=True;
      btnStatus_del_queue_all.Enabled:=False;
    end;
  end;

  Screen.Cursor:=crDefault;
end;

procedure TFormOperatorStatus.btnStatus_breakClick(Sender: TObject);
begin
 SendCommand(eLog_break,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_del_queue_allClick(Sender: TObject);
begin
  SendCommand(eLog_del_queue_5000_5050,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_dinnerClick(Sender: TObject);
begin
  // ����
  SendCommand(eLog_dinner,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_exodusClick(Sender: TObject);
begin
  // �����
 SendCommand(eLog_exodus,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_homeClick(Sender: TObject);
begin
 // �����
  SendCommand(eLog_home,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_ITClick(Sender: TObject);
begin
 // ��
  SendCommand(eLog_IT,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_postvyzovClick(Sender: TObject);
begin
  // ���������
  SendCommand(eLog_postvyzov,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_reserveClick(Sender: TObject);
begin
  // ��������
 SendCommand(eLog_reserve,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_studiesClick(Sender: TObject);
begin
  // �����
  SendCommand(eLog_studies,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.btnStatus_transferClick(Sender: TObject);
begin
 // ��������
 SendCommand(eLog_transfer,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.Button2Click(Sender: TObject);
begin
 // callback
  SendCommand(eLog_callback,SharedCurrentUserLogon.GetID);
end;

procedure TFormOperatorStatus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if HomeForm.PanelStatus.Visible = False then HomeForm.PanelStatus.Visible:=True;
end;

procedure TFormOperatorStatus.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormOperatorStatus.FormShow(Sender: TObject);
begin
  Height:=GetCalculateHeightStart;
end;

end.
