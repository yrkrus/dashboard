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
    Image12: TImage;
    imgClosed: TImage;
    GroupBox1: TGroupBox;
    edtPhone: TEdit;
    ST_Time: TStaticText;
    st_PhoneInfo: TStaticText;
    ST_State: TStaticText;
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
    m_dispatcherCreateCall     :TThreadDispatcher;     // планировщик

    procedure  _INIT;
    function CreateCall(var _callback:TCallbackCall;
                        var _errorDescription:string):Boolean;   // основная процедура для создания звонка

    { Private declarations }

  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation

uses
  GlobalVariablesLinkDLL, GlobalVariables, TCustomTypeUnit, FunctionUnit;

{$R *.dfm}

// основная процедура для создания звонка
function TFormHome.CreateCall(var _callback:TCallbackCall;
                              var _errorDescription:string):Boolean;
begin
  if not Assigned(_callback) then begin
    _errorDescription:='Не удается инициализировать класс TCallbackCall';
    Result:=False;
    Exit;

  end;

//  Result:=False;
//  phone:=edtPhone.Text;
//
//  if not CheckPhone(_errorDescription, edtPhone) then begin
//    Exit;
//  end;
//
//  callbackCall:=TCallbackCall.Create(USER_STARTED_OUTGOING_ID, phone, False);
//
//  while callbackCall.CommandResult(_errorDescription) <> call_result_ok  do begin
//
//  end;



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
   USER_STARTED_OUTGOING_ID:=1;
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
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

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
    KillProcessNow;  // TODO перед выполнением проверить не в активном ли разговре находится сейчас программа
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
    Caption:='DEBUG | (base:'+_dll_GetDefaultDataBase+') '+Caption;
  end;

 // создатим copyright
 // CreateCopyright;

  Screen.Cursor:=crDefault;
end;

procedure TFormHome.imgStartCallClick(Sender: TObject);
var
 callbackCall:TCallbackCall;
 errorDescription:string;
begin
 callbackCall:=TCallbackCall.Create(USER_STARTED_OUTGOING_ID);

 if not CreateCall(callbackCall, errorDescription) then begin
   MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
 end;

 // тут дальше создаем диспетчер который состояние отслеживает
end;

procedure TFormHome.imgClosedClick(Sender: TObject);
begin
  KillProcessNow;
end;

end.
