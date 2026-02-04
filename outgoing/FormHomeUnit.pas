unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, ClipBrd, Vcl.Imaging.jpeg, TThreadDispatcherUnit,
  TCallbackCallUnit;

type
  TFormHome = class(TForm)
    panel_buttons: TPanel;
    ImgNewYear: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    img0: TImage;
    img0_draw: TImage;
    group: TGroupBox;
    imgStartCall: TImage;
    imgStopCall: TImage;
    imgClosed: TImage;
    GroupBox1: TGroupBox;
    edtPhone: TEdit;
    ST_Time: TStaticText;
    st_PhoneInfo: TStaticText;
    ST_State: TStaticText;
    lblDebug: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ProcessCommandLineParams(DEBUG:Boolean);
    procedure FormShow(Sender: TObject);
    procedure imgClosedClick(Sender: TObject);
    procedure edtPhoneKeyPress(Sender: TObject; var Key: Char);
    procedure edtPhoneClick(Sender: TObject);
    procedure edtPhoneChange(Sender: TObject);
    procedure edtPhoneKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgStartCallClick(Sender: TObject);
  private
    m_dispatcherCall        :TThreadDispatcher;     // планировщик
    m_activeCall            :Boolean;               // совершается активный звонок


    procedure  _INIT;
    function CreateCall(var p_callback:TCallbackCall;
                        var _errorDescription:string):Boolean;   // основная процедура для создания звонка

    procedure ParsingCall;  // процедура запускаемая через планировщик
    procedure ShowTalkTimeCall;  // отсчет времени звонка
    procedure CallEnding;   // звонок завершился
    procedure CallStarting; // звонок начинается


    { Private declarations }

  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

const
 // расположение иконки звонка
 IMG_LEFT:Word = 293;
 IMG_TOP:Word = 19;

implementation

uses
  GlobalVariablesLinkDLL, GlobalVariables, TCustomTypeUnit, FunctionUnit;

{$R *.dfm}


procedure TFormHome.ParsingCall;
begin
  // статус
  ST_State.Caption:='Статус: '+SharedCallbackCall.StatusString;

  case SharedCallbackCall.Status of
   call_result_not_init: begin

   end;
   call_result_unknown:begin

   end;
   call_result_wait_server:begin

   end;
   call_result_wait_responce:begin
    // отсчитваем время звонка
    ShowTalkTimeCall;
   end;
   call_result_fail:begin
    CallEnding;
   end;
   call_result_ok:begin
    // отсчитваем время звонка
    ShowTalkTimeCall;
   end;
   call_result_end:begin  // звонок завершился
    CallEnding;
   end;
  end;
end;

// отсчет времени звонка
procedure TFormHome.ShowTalkTimeCall;
begin
  ST_Time.Caption:=SharedCallbackCall.TalkTime;

end;


 // звонок завершился
procedure TFormHome.CallEnding;
begin
 ST_Time.Caption:='--:--:--';
 m_activeCall:=False;
 imgStopCall.Visible:=False;

 // показ иконки начала звонка
 imgStartCall.Left:=IMG_LEFT;
 imgStartCall.Top:=IMG_TOP;
 imgStartCall.Visible:=True;
end;

// звонок начинается
procedure TFormHome.CallStarting;
begin
  m_activeCall:=True;
  imgStartCall.Visible:=False;

  // показ иконки завершения звонка
  imgStopCall.Left:=IMG_LEFT;
  imgStopCall.Top:=IMG_TOP;
  imgStopCall.Visible:=True;
end;


// основная процедура для создания звонка
function TFormHome.CreateCall(var p_callback:TCallbackCall;
                              var _errorDescription:string):Boolean;
begin
  if Assigned(m_dispatcherCall) then m_dispatcherCall.StopThread;

  USER_PHONE_CALL:=edtPhone.Text;

  // проверяем номер тлф
  if not CheckPhone(USER_PHONE_CALL,_errorDescription) then begin
    Result:=False;
    Exit;
  end;

  // ставим номер телефона
  p_callback.SetPhone(USER_PHONE_CALL);
  p_callback.CreateCall();  // создаем внутренний поток и ждем отработки

  // создаем звонок
 if not Assigned(m_dispatcherCall) then begin
  m_dispatcherCall:=TThreadDispatcher.Create('CallbackCall', 1, False, ParsingCall);
 end;

 m_dispatcherCall.StartThread;

 CallStarting; // совершается активный звонок

 // выходим из функции и отдаем работу в поток
 Result:=True;
end;

procedure  TFormHome._INIT;
begin
   case AUTO_RUN of
    True:begin  // сразу звоним
     InitAutoRun;
    end;
    False:begin
      InitManual;
    end;
   end;
end;

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_OUTGOING_ID:=38;
   USER_STARTED_OUTGOING_SIP:=64197;
   USER_PHONE_CALL:='89275052333';
   AUTO_RUN:=False;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('Приложение можно запустить только из дашборда'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_OUTGOING_ID:= StrToInt(ParamStr(i + 1));

        // найдем сразу userSip
        USER_STARTED_OUTGOING_SIP:=_dll_GetOperatorSIP(USER_STARTED_OUTGOING_ID);
        if USER_STARTED_OUTGOING_SIP = -1 then begin
         MessageBox(Handle,PChar('Ошибка определения Sip номера'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
         KillProcessNow;
        end;

       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));
        ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1) + #13#13+
                    'Value for USER_STARTED_OUTGOING_ID: '+ IntToStr(USER_STARTED_OUTGOING_SIP));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;

    if ParamStr(i) = '--PHONE_CALL' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_PHONE_CALL:= ParamStr(i + 1);
       // if DEBUG then ShowMessage('Value for --ACCESS: ' + ParamStr(i + 1));
        ShowMessage('Value for --PHONE_CALL: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;

  // запуск был автоматический
  if Length(USER_PHONE_CALL) <> 0 then AUTO_RUN:=True;
end;

procedure TFormHome.edtPhoneChange(Sender: TObject);
begin
 if Length(edtPhone.Text) > 0 then st_PhoneInfo.Visible:=False
 else st_PhoneInfo.Visible:=True;
end;

procedure TFormHome.edtPhoneClick(Sender: TObject);
begin
 if st_PhoneInfo.Visible then st_PhoneInfo.Visible:=False;
end;

procedure TFormHome.edtPhoneKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
  begin
    case Key of
       86: // Ctrl + V
        begin
          // Вставляем текст из буфера обмена
          edtPhone.Text := ParsePhoneNumber(Clipboard.AsText);
          Key := 0; // Отменяем дальнейшую обработку клавиши
        end;
      88: // Ctrl + X
        begin
          // Копируем выделенный текст в буфер обмена и удаляем его из Edit
          Clipboard.AsText := edtPhone.Text; // Если нужно, чтобы текст был скопирован
          edtPhone.ClearSelection; // Удаляем выделение
          Key := 0; // Отменяем дальнейшую обработку клавиши
        end;
    end;
  end;
end;

procedure TFormHome.edtPhoneKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    if m_activeCall then begin
     MessageBox(Handle,PChar('Во время звонка закрыть не получится'),PChar(''),MB_OK+MB_ICONINFORMATION);
     Exit;
    end;

    KillProcessNow;
  end;

  if Key = #13 then
  begin
    imgStartCall.OnClick(Sender);
  end;

  if not (Key in ['0'..'9', #8 ]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
end;

procedure TFormHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 KillProcessNow;
end;

procedure TFormHome.FormCreate(Sender: TObject);
var
 FolderDll:string;
begin
  // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(OUTGOING_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии звонилки(хз как назвать потом переименовать)'+#13#13+ // TODO назвать как нить по другому
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  // папка для dll firebird
  begin
    FolderDll:= FOLDERPATH + 'dll';

    // Проверка на существование папки
    if DirectoryExists(FolderDll) then begin
      // путь к папке с DLL
      SetDllDirectory(PChar(FolderDll));
    end
    else begin
      MessageBox(Handle,PChar('Не найдена папка с dll библиотеками'+#13#13+FolderDll),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      KillProcessNow; // Завершаем выполнение процедуры, чтобы не продолжать дальше
    end;
  end;

  ProcessCommandLineParams(DEBUG);
end;

procedure TFormHome.FormShow(Sender: TObject);
begin
  // подгузим все данные
  _INIT;

 Screen.Cursor:=crHourGlass;

  // debug node
  if DEBUG then begin
    lblDebug.Caption:='DEBUG | (base:'+_dll_GetDefaultDataBase+')';
    lblDebug.Visible:=True;
  end;

 // создатим copyright
 // CreateCopyright;

  Screen.Cursor:=crDefault;
end;

procedure TFormHome.imgStartCallClick(Sender: TObject);
var
 errorDescription:string;
begin
 if not Assigned(SharedCallbackCall) then begin
   MessageBox(Handle,PChar('Не удается создать экземпляр класса TCallbackCall'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
 end;

 if Assigned(SharedCallbackCall) then begin
   // на всякий случай обнулим данные
   SharedCallbackCall.Clear;
 end;

 SharedCallbackCall.SetId(USER_STARTED_OUTGOING_ID, USER_STARTED_OUTGOING_SIP);

 if not CreateCall(SharedCallbackCall, errorDescription) then begin
   MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
 end;
end;

procedure TFormHome.imgClosedClick(Sender: TObject);
begin
  if m_activeCall then begin
   MessageBox(Handle,PChar('Во время звонка закрыть не получится'),PChar(''),MB_OK+MB_ICONINFORMATION);
   Exit;
  end;

  KillProcessNow;
end;

end.
