unit FormOperatorStatusUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

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
  private
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
  TCustomTypeUnit, FunctionUnit, GlobalVariables, FormHome;

{$R *.dfm}

// высчитывание размера окна по default
// это нужно из за того что если устноавлен размер нет 100%, то окно не все отображается
function TFormOperatorStatus.GetCalculateHeightStart:Word;
begin

 // while (lblLevelCheck.) do begin


 // end;
     {

В Delphi вы можете создать функцию, которая будет проверять, помещаются ли элементы управления на форме, и если нет, автоматически изменять размер формы. Вот пример такой функции:

procedure AdjustFormSizeToFitControls(AForm: TForm);
var
  Control: TControl;
  TotalHeight, MaxWidth: Integer;
begin
  TotalHeight := 0;
  MaxWidth := 0;

  // Проходим по всем элементам управления на форме
  for Control in AForm.Controls do
  begin
    // Считаем общую высоту и максимальную ширину
    TotalHeight := TotalHeight + Control.Height + 8; // добавляем отступ
    if Control.Width > MaxWidth then
      MaxWidth := Control.Width;
  end;

  // Устанавливаем новую высоту формы
  AForm.Height := TotalHeight + AForm.BorderWidth * 2 + AForm.CaptionHeight;

  // Устанавливаем новую ширину формы
  AForm.Width := MaxWidth + AForm.BorderWidth * 2;
end;


Как использовать эту функцию:



    Вызовите AdjustFormSizeToFitControls(Self); в нужном месте вашего кода, например, в событии OnCreate формы или после добавления/изменения элементов управления.



    Убедитесь, что у вас есть необходимые отступы, чтобы элементы не прилипали к краям формы.



Примечания:


    Эта функция принимает в качестве параметра объект формы (TForm), который вы хотите подстроить.

    В функции учитываются высота и ширина элементов управления, а также отступы для более корректного отображения.

    Вы можете настроить логику, чтобы учитывать только определенные типы элементов управления (например, только TButton), если это необходимо.



     }


  Result:=cHeightStart;
end;

function TFormOperatorStatus.GetCalculateHeightRegister:Word;
begin
  Result:=cHeightRegister;
end;

procedure TFormOperatorStatus.btnStatus_add_queue5000Click(Sender: TObject);
begin
   // добавление в очередь 5000
 if not isExistRemoteCommand(eLog_add_queue_5000) then remoteCommand_addQueue(eLog_add_queue_5000)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_add_queue5000_5050Click(
  Sender: TObject);
begin
  // добавление в очередь 5000 и 5050
 if not isExistRemoteCommand(eLog_add_queue_5000_5050) then remoteCommand_addQueue(eLog_add_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_add_queue5050Click(Sender: TObject);
begin
   // добавление в очередь 5050
 if not isExistRemoteCommand(eLog_add_queue_5050) then remoteCommand_addQueue(eLog_add_queue_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end
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

  // проверяем в какой очереди находится оператор
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
  // перерыв
 if not isExistRemoteCommand(eLog_break) then remoteCommand_addQueue(eLog_break)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_del_queue_allClick(Sender: TObject);
begin
  // выход из всех очередей из 5000 и 5050
 if not isExistRemoteCommand(eLog_del_queue_5000_5050) then remoteCommand_addQueue(eLog_del_queue_5000_5050)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_dinnerClick(Sender: TObject);
begin
  // обед
 if not isExistRemoteCommand(eLog_dinner) then remoteCommand_addQueue(eLog_dinner)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_exodusClick(Sender: TObject);
begin
 // исход
 if not isExistRemoteCommand(eLog_exodus) then remoteCommand_addQueue(eLog_exodus)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_homeClick(Sender: TObject);
begin
 // домой
 if not isExistRemoteCommand(eLog_home) then remoteCommand_addQueue(eLog_home)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_ITClick(Sender: TObject);
begin
 // ИТ
 if not isExistRemoteCommand(eLog_IT) then remoteCommand_addQueue(eLog_IT)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_postvyzovClick(Sender: TObject);
begin
  // поствызов
 if not isExistRemoteCommand(eLog_postvyzov) then remoteCommand_addQueue(eLog_postvyzov)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_reserveClick(Sender: TObject);
begin
  // переносы
 if not isExistRemoteCommand(eLog_reserve) then remoteCommand_addQueue(eLog_reserve)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_studiesClick(Sender: TObject);
begin
  // учеба
 if not isExistRemoteCommand(eLog_studies) then remoteCommand_addQueue(eLog_studies)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
end;

procedure TFormOperatorStatus.btnStatus_transferClick(Sender: TObject);
begin
 // переносы
 if not isExistRemoteCommand(eLog_transfer) then remoteCommand_addQueue(eLog_transfer)
 else begin
    MessageBox(Handle,PChar('Предыдущая такая же команда еще не обработана'),PChar('Команда в процессе обработки'),MB_OK+MB_ICONINFORMATION);
 end;
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
