unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Menus;


 // class TSMSMessage
type
    TSMSMessage = class(TObject)

    public
    SMS_ID                                      : string;     // ID sms
    CreatDate                                   : TDate;       // дата когда было создано сообщение
    CreatTime                                   : TTime;       // время когда было создано сообщение
    MsgText                                     : string;      // текст сообщения
    Code                                        : string;      // код смс
    Status                                      : string;      // статус смс
    Phone                                       : string;      // номер телефона

    constructor Create;                          overload;

    function getID                              : string;
    function getDate                            : TDate;
    function getTime                            : TTime;
    function getMsg                             : string;
    function getCode                            : string;
    function getStatus                          : string;
    function getPhone                           : string;
  end;

  //class TSMSMessage END


type
  TFormHome = class(TForm)
    GroupBox2: TGroupBox;
    chkboxLog: TCheckBox;
    OpenDialog: TOpenDialog;
    page_TypesSMS: TPageControl;
    sheet_ManualSMS: TTabSheet;
    sheet_SendingSMS: TTabSheet;
    Button1: TButton;
    StatusBar: TStatusBar;
    btnSendSMS: TBitBtn;
    group_ManualSMS: TGroupBox;
    Label1: TLabel;
    edtManualSMS: TEdit;
    btnSaveFirebirdSettings: TBitBtn;
    panel_ManualSMS: TPanel;
    re_ManualSMS: TRichEdit;
    ST_StatusPanel: TStaticText;
    chkbox_SaveMyTemplate: TCheckBox;
    group_SendingSMS: TGroupBox;
    Label2: TLabel;
    edtExcelSMS: TEdit;
    btnLoadFile: TBitBtn;
    ProgressBar: TGauge;
    chkboxShowLog: TCheckBox;
    GroupBox1: TGroupBox;
    RELog: TRichEdit;
    STDEBUG: TStaticText;
    lblCountSendingSMS: TLabel;
    Label3: TLabel;
    ProgressStatusText: TStaticText;
    Label4: TLabel;
    lblCountNotSendingSMS: TLabel;
    st_ShowNotSendingSMS: TStaticText;
    st_PhoneInfo: TStaticText;
    chkbox_SaveGlobalTemplate: TCheckBox;
    Button2: TButton;
    PopMenu_AddressClinic: TPopupMenu;
    r1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    chkbox_SignSMS: TCheckBox;
    st_ShowInfoAddAddressClinic: TStaticText;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSendSMSClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure page_TypesSMSChange(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseLeave(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure st_ShowNotSendingSMSClick(Sender: TObject);
    procedure edtManualSMSClick(Sender: TObject);
    procedure chkbox_SignSMSMouseLeave(Sender: TObject);
    procedure chkbox_SignSMSMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chkbox_SaveMyTemplateMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure chkbox_SaveMyTemplateMouseLeave(Sender: TObject);
    procedure chkbox_SaveGlobalTemplateMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure chkbox_SaveGlobalTemplateMouseLeave(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseLeave(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure st_ShowInfoAddAddressClinicClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  //ParsingError:Boolean; // при разборе строк обнаружена ошибка при которой не было отправлено СМС оповещение
  //SLParsingError:TStringList; // список с ошибками

  //SLPArsingErorr:array of TErrorFileList;

  end;


var
  FormHome: TFormHome;

const
cWIDTH_SHOWLOG:Integer=1128;
cWIDTH_HIDELOG:Integer=440;

cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';

cAUTHconf:string='auth.conf';


cSLEEPNEXTSMS:Integer=150; // время задержки перед следующей отправкой смс

// cMINIMALMESSAGESIZE:Word = 70; // минимальное кол-во симовлов в отправляемом сообщении

//cMESSAGEBefor18:string='%FIO_Pacienta Вы записаны к доктору %FIO_Doctora (%Napravlenie) на %Data в %Time, %Address. При себе необходимо иметь паспорт и СНИЛС';
//cMESSAGEAfter18:string='%FIO_Pacienta %записан(а) к доктору %FIO_Doctora (%Napravlenie) на %Data в %Time, %Address. Прием возможен в присутствии законного представителя ребенка';

//cMESSAGEBefor18:string='%FIO_Pacienta Вы записаны к доктору %FIO_Doctora на %Data в %Time, %Address. При себе необходимо иметь паспорт и СНИЛС';
//cMESSAGEAfter18:string='%FIO_Pacienta %записан(а) к доктору %FIO_Doctora на %Data в %Time, %Address. Прием возможен в присутствии законного представителя ребенка';




implementation

uses
  FunctionUnit, GlobalVariables, TSendSMSUint, FormMyTemplateUnit, FormNotSendingSMSErrorUnit;

 {$R *.dfm}


// class TSMSMessage START
 constructor TSMSMessage.Create;
 begin
   inherited;
 end;

 function TSMSMessage.getID:string;
 begin
    Result:=SMS_ID;
 end;

 function TSMSMessage.getDate:TDate;
 begin
    Result:=CreatDate;
 end;

 function TSMSMessage.getTime:TTime;
 begin
    Result:=CreatTime;
 end;

 function TSMSMessage.getMsg:string;
 begin
    Result:=MsgText;
 end;

 function TSMSMessage.getCode:string;
 begin
    Result:=Code;
 end;

 function TSMSMessage.getStatus:string;
 begin
    Result:=Status;
 end;

  function TSMSMessage.getPhone:string;
 begin
    Result:=Phone;
 end;

 // class TSMSMessage END


procedure TFormHome.btnLoadFile2Click(Sender: TObject);
var
  TypeReport:Word;
begin
//  if edtExcelSMS.Text<>'' then begin
//   MessageBox(Handle,PChar('На данный момент загружен файл с рассылкой (смс)'+#13#13+
//                           'Очистите поле "смс" если необходимо загрузить файл с рассылкой (отказники) '),PChar('Ошибка'),MB_OK+MB_ICONERROR);
//   Exit;
//  end;
//
//   with OpenDialog do begin
//     Title:='Загрузка файла';
//     DefaultExt:='';
//     Filter:='OpenOffice | *.ods';
//     FilterIndex:=1;
//     InitialDir:=FOLDERPATH;
//
//      if Execute then
//      begin
//         FileExcelSMS:=FileName;
//         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
//
//
//         FileExcelSMS:=FileName;
//      end;
//   end;
//
//   // подгружаем в память
//   if FileExcelSMS<>'' then
//   begin
//     if edtExcelSMS.Text<>'' then TypeReport:=1  { файл с рассылкой (смс) }
//     else TypeReport:=2;                         { файл с рассылкой (отказники) }
//
//     // загружаем данные
//     PreLoadData(TypeReport);
//   end;

end;

procedure TFormHome.btnLoadFileClick(Sender: TObject);
var
 TypeReport:Word;
 FileExcelSMS:string;
 error:string;
begin

  with OpenDialog do begin
     Title:='Загрузка файла';
     DefaultExt:='xls';
     Filter:='Excel 2003 и старее | *.xls|Excel 2007 и новее| *.xlsx';
     FilterIndex:=1;
     InitialDir:=FOLDERPATH;

      if Execute then
      begin
         FileExcelSMS:=FileName;
         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
         edtExcelSMS.Text:=FileExcelSMS;

         FileExcelSMS:=FileName;
      end;
  end;

  if FileExcelSMS='' then Exit;

   // подгружаем загружаем данные в память
  if not LoadData(FileExcelSMS, error, ProgressStatusText,
                  lblCountSendingSMS,lblCountNotSendingSMS) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;
end;

procedure TFormHome.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
  FormMyTemplate.ShowModal;
end;

procedure TFormHome.btnSendSMSClick(Sender: TObject);
var
 currentOptions:enumSendingOptions;
 error:string;
 SendindMessage:string;
begin
  // проверки
  Screen.Cursor:=crHourGlass;

  begin
    case page_TypesSMS.ActivePage.PageIndex of
     0:begin                 // ручная отправка
      currentOptions:=options_Manual;
     end;
     1:begin                  // рассылка
      currentOptions:=options_Sending;
     end;
    end;

    if not CheckParamsBeforeSending(currentOptions,error) then begin
     Screen.Cursor:=crDefault;
     MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;
  end;


   // отправляем сообщение
   case currentOptions of
    options_Manual: begin
      if not SendingMessage(currentOptions, error) then begin
       Screen.Cursor:=crDefault;
       MessageBox(Handle,PChar(error),PChar('Ошибка отправки'),MB_OK+MB_ICONERROR);
      end
      else begin
        // запись в качестве шаблона сообщений
        if chkbox_SaveMyTemplate.Checked then SaveMyTemplateMesaage(re_ManualSMS.Text);
        if chkbox_SaveGlobalTemplate.Checked then SaveMyTemplateMesaage(re_ManualSMS.Text, ISGLOBAL_MESSAGE);

        Screen.Cursor:=crDefault;
        MessageBox(Handle,PChar('Сообщение отправлено'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
      end;
    end;
    options_Sending:begin
      if not SendingMessage(currentOptions, error) then begin
        Screen.Cursor:=crDefault;
        MessageBox(Handle,PChar(error),PChar('Ошибка отправки'),MB_OK+MB_ICONERROR);
      end;
    end;
   end;

   // очищаем данные формы
   ClearParamsForm(currentOptions);
   Screen.Cursor:=crDefault;
end;

procedure TFormHome.Button1Click(Sender: TObject);
var
 test:TStringList;
begin

 // test:=TStringList.Create;
//  test.LoadFromFile('1.log');

 // ParsingResultStatusSMS(test.Text,'89093858545');
end;

procedure TFormHome.Button2Click(Sender: TObject);
begin
  CreateThreadSendind(MAX_COUNT_THREAD_SENDIND,0,0);
end;



procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
  if chkboxShowLog.Checked then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;

procedure TFormHome.chkbox_SaveGlobalTemplateMouseLeave(Sender: TObject);
begin
  chkbox_SaveGlobalTemplate.Font.Style:=[];
end;

procedure TFormHome.chkbox_SaveGlobalTemplateMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 chkbox_SaveGlobalTemplate.Font.Style:=[fsUnderline];
end;

procedure TFormHome.chkbox_SaveMyTemplateMouseLeave(Sender: TObject);
begin
 chkbox_SaveMyTemplate.Font.Style:=[];
end;

procedure TFormHome.chkbox_SaveMyTemplateMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  chkbox_SaveMyTemplate.Font.Style:=[fsUnderline];
end;

procedure TFormHome.chkbox_SignSMSMouseLeave(Sender: TObject);
begin
  chkbox_SignSMS.Font.Style:=[];
end;

procedure TFormHome.chkbox_SignSMSMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 chkbox_SignSMS.Font.Style:=[fsUnderline];
end;

procedure TFormHome.edtManualSMSClick(Sender: TObject);
begin
  if st_PhoneInfo.Visible then st_PhoneInfo.Visible:=False;
end;



procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_SMS_ID:=1;
   USER_ACCESS_SENDING_LIST:=True;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('SMS рассылку можно запустить только из дашборда'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_SMS_ID:= StrToInt(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;

    if ParamStr(i) = '--ACCESS' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_ACCESS_SENDING_LIST:= StrToBoolean(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;


procedure TFormHome.st_ShowInfoAddAddressClinicClick(Sender: TObject);
begin
 MessageBox(Handle,PChar('Для быстрой вставки адреса клинки необходимо'+#13#10+
                         'кликнуть правой кл. мыши и выбрать нужный адрес из выпадающего меню'+#13#10+
                         'и он вставиться в сообщение на месте где находится курсор'),PChar('Инфо'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseLeave(Sender: TObject);
begin
  st_ShowInfoAddAddressClinic.Font.Style:=[];
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  st_ShowInfoAddAddressClinic.Font.Style:=[fsUnderline];
end;

procedure TFormHome.st_ShowNotSendingSMSClick(Sender: TObject);
begin
 FormNotSendingSMSError.ShowModal;
end;

procedure TFormHome.st_ShowNotSendingSMSMouseLeave(Sender: TObject);
begin
 st_ShowNotSendingSMS.Font.Style:=[];
end;

procedure TFormHome.st_ShowNotSendingSMSMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   st_ShowNotSendingSMS.Font.Style:=[fsUnderline];
end;

procedure TFormHome.FormCreate(Sender: TObject);
begin

  // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(SMS_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии sms рассылки'+#13#13+
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);


  // размер окна
  FormHome.Width:=cWIDTH_HIDELOG;
end;




procedure TFormHome.FormShow(Sender: TObject);
var
 error:string;
begin
  // debug node
  if DEBUG then STDEBUG.Visible:=True
  else begin
    // скрываем отправку рассылки для обычных операторов
    if not USER_ACCESS_SENDING_LIST then begin
       page_TypesSMS.Pages[1].TabVisible:=False;
       chkbox_SaveGlobalTemplate.Visible:=False;  // сохранить сообщение в глобальные шаблоны
    end
    else begin
       chkbox_SaveGlobalTemplate.Visible:=True;  // сохранить сообщение в глобальные шаблоны
    end;
  end;

   // создатим copyright
  CreateCopyright;

  // проверка существует ли excel
  if not isExistExcel(error) then begin
   MessageBox(Handle,PChar('Excel не установлен'+#13#13+error),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  // возможность автоматически вставлять подпись в смс сообщение
  SignSMS;

  // стартовая вкладка
  page_TypesSMS.ActivePage:=sheet_ManualSMS;
end;

procedure TFormHome.page_TypesSMSChange(Sender: TObject);
begin
  case page_TypesSMS.ActivePage.PageIndex of

   0:begin                 // ручная отправка
    OptionsStyle(options_Manual);
   end;
   1:begin                  // рассылка
    OptionsStyle(options_Sending);
   end;
  end;
end;

end.
