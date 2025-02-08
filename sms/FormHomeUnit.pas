unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Buttons;


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
    CheckBox1: TCheckBox;
    group_SendingSMS: TGroupBox;
    Label2: TLabel;
    edtExcelSMS: TEdit;
    btnLoadFile: TBitBtn;
    lblProgressBar: TLabel;
    ProgressBar: TGauge;
    chkboxShowLog: TCheckBox;
    GroupBox1: TGroupBox;
    RELog: TRichEdit;
    STDEBUG: TStaticText;
    lblCountSendingSMS: TLabel;
    Label3: TLabel;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSendSMSClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtNumbeFromStatusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
      procedure Button2Click(Sender: TObject);
    procedure page_TypesSMSChange(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  ParsingError:Boolean; // при разборе строк обнаружена ошибка при которой не было отправлено СМС оповещение
  SLParsingError:TStringList; // список с ошибками

  //SLPArsingErorr:array of TErrorFileList;

  end;


var
  FormHome: TFormHome;
  FileExcelSMS:string;

  SLSMS:TStringList; // файл с выгрузкой из exel

  //currentUser:TUser;


const
cWIDTH_SHOWLOG:Integer=1128;
cWIDTH_HIDELOG:Integer=440;

cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';

cAUTHconf:string='auth.conf';

//CustomHeaders0='Connection:Keep-alive';
//CustomUserAgent='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
//CustomHeaders2='Content-Type:application/x-www-form-urlencoded';
//CustomHeaders3='Accept-Charset:utf-8';
//CustomHeaders4='Accept:application/json, text/javascript, */*; q=0.01';
//CustomHeaders4='Content-Encoding: gzip';


cSLEEPNEXTSMS:Integer=150; // время задержки перед следующей отправкой смс

cMINIMALMESSAGESIZE:Word = 70; // минимальное кол-во симовлов в отправляемом сообщении

//cMESSAGEBefor18:string='%FIO_Pacienta Вы записаны к доктору %FIO_Doctora (%Napravlenie) на %Data в %Time, %Address. При себе необходимо иметь паспорт и СНИЛС';
//cMESSAGEAfter18:string='%FIO_Pacienta %записан(а) к доктору %FIO_Doctora (%Napravlenie) на %Data в %Time, %Address. Прием возможен в присутствии законного представителя ребенка';

//cMESSAGEBefor18:string='%FIO_Pacienta Вы записаны к доктору %FIO_Doctora на %Data в %Time, %Address. При себе необходимо иметь паспорт и СНИЛС';
//cMESSAGEAfter18:string='%FIO_Pacienta %записан(а) к доктору %FIO_Doctora на %Data в %Time, %Address. Прием возможен в присутствии законного представителя ребенка';

cMESSAGE:string='%FIO_Pacienta %записан(а) к доктору %FIO_Doctora в %Time %Data в Клинику по адресу %Address. Если у Вас есть вопросы, готовы на них ответить, номер тел. для связи (8442)220-220 или (8443)450-450';

cTempAddrClinika:string='ул. 40 лет ВЛКСМ, 55Б';

cMAXCOUNTMESSAGEOLD:Word = 50; //кол-во сообщений которые прогружать и хранить в памяти при успешных отправках

implementation

uses
  FunctionUnit, GlobalVariables, TSendSMSUint, FormMyTemplateUnit;

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

   // подгружаем в память
   if FileExcelSMS<>'' then
   begin
     if edtExcelSMS.Text<>'' then TypeReport:=1  { файл с рассылкой (смс) }
     else TypeReport:=2;                         { файл с рассылкой (отказники) }

     // загружаем данные
     PreLoadData(TypeReport);
   end;

end;

procedure TFormHome.btnSaveFirebirdSettingsClick(Sender: TObject);
begin
  FormMyTemplate.ShowModal;
end;

procedure TFormHome.btnSendSMSClick(Sender: TObject);
var
// TypeReport:Word;
// resultat:Word;
// sresult:string;
// SMSResult:string;
// i:Integer;
// MessageSMS:string;
 currentOptions:enumSendingOptions;
 error:string;
 SendindMessage:string;
begin
  // проверки
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
     MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
    end;
  end;


   // отправляем сообщение
   case currentOptions of
    options_Manual: begin
      if not SendingMessage(currentOptions, error) then  MessageBox(Handle,PChar(error),PChar('Ошибка отправки'),MB_OK+MB_ICONERROR)
      else MessageBox(Handle,PChar('Сообщение отправлено'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
    end;
    options_Sending:begin

    end;
   end;

   // очищаем данные формы
   ClearParamsForm(currentOptions);


//  case PageType.ActivePage.PageIndex of
//   0:begin                 // проверка статуса сообщения
//      try
//       // SMSResult:=GetSMSStatusID(edtNumbeFromStatus.Text);
//
//        if AnsiPos('ОШИБКА',SMSResult) <> 0 then begin
//          MessageBox(Handle,PChar(sresult),PChar('Ошибка'),MB_OK+MB_ICONERROR);
//          Exit;
//        end;
//      except on E:Exception do
//          begin
//           // CurrentPostAddColoredLine('ОШИБКА! Не удалось проверить статус СМС на номер "'+reNumberPhoneList.Lines[i]+'" , '+e.ClassName+': '+e.Message,clRed);
//            Exit;
//          end;
//      end;
//
//   end;
//   1:begin                 // ручная отправка
//
//      // длинна сообшения
//      MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');
//
//      if Length(MessageSMS) <= cMINIMALMESSAGESIZE then begin
//
//        resultat:=MessageBox(FormHome.Handle,PChar('Размер отправляемого сообщения меньше рекомендованной МИНИМАЛЬНОЙ длины ('+IntToStr(cMINIMALMESSAGESIZE)+' символов)'+#13#13+
//                                                   'Возможно это ошибка, точно отправить сообщение?'+#13#13#13+
//                                                   'Будет отправлено следующее сообщение:'+#13+
//                                                    MessageSMS),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
//        if resultat=mrNo then begin
//           Exit;
//        end;
//      end;


      {for i:=0 to reNumberPhoneList.Lines.Count-1 do begin

        begin
         ProgressBar.Progress:=Round(100*i/reNumberPhoneList.Lines.Count-1);
         lblProgressBar.Caption:=IntToStr(i+1)+' из '+IntToStr(reNumberPhoneList.Lines.Count);
         Application.ProcessMessages;
        end;

         try
          SMSResult:=GetSMS(reNumberPhoneList.Lines[i]);

         except on E:Exception do
          begin
            CurrentPostAddColoredLine('ОШИБКА! Не удалось отправить СМС на номер "'+reNumberPhoneList.Lines[i]+'" , '+e.ClassName+': '+e.Message,clRed);
            Exit;
          end;
         end;

         if SMSResult='OK' then begin
           CurrentPostAddColoredLine('Отправлено СМС на номер "'+reNumberPhoneList.Lines[i]+'"',clGreen);
         end
         else begin
           CurrentPostAddColoredLine(SMSResult+'. Номер телефона на который не удалось отправить СМС "'+reNumberPhoneList.Lines[i]+'"',clRed);
         end;
      end; }

//     // очищаем данные
//     reNumberPhoneList.Lines.Clear;
//     ProgressBar.Progress:=0;
//     lblProgressBar.Caption:='Статус отправки';
//   end;
//   2:begin                            // рассылка
//    if edtExcelSMS.Text<>'' then TypeReport:=1  { файл с рассылкой (смс) }
//    else TypeReport:=2;                         { файл с рассылкой (отказники) }
//
//       //отправляем смс
//       if SLSMS.Count<>0 then ParsingSMSandSend(SLSMS,TypeReport)
//       else begin
//        CurrentPostAddColoredLine('ОШИБКА ОТПРАВКИ! В памяти нет данных для отправки',clRed);
//
//        MessageBox(Handle,PChar('В памяти нет данных для отправки'+#13+
//                                'Сформируйте отчет еще раз '),PChar('Ошибка'),MB_OK+MB_ICONERROR);
//        Exit;
//       end;
//
//      // очищаем данные
//      ProgressBar.Progress:=0;
//      lblProgressBar.Caption:='Статус отправки';
//
//      // есть ошибки
//      if ParsingError then begin
//        SLParsingError.SaveToFile(ParsingDirectory+'ErrorSend.log');
//
//        resultat:=MessageBox(FormHome.Handle,PChar('В процессе отправки рассылки, возникли ошибки ('+inttostr(SLParsingError.Count)+')'+#13+
//                                                   'Сформирован отчет ErrorSend.log'+#13#13+
//                                                   'Открыть отчет?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
//        SLParsingError.Clear;
//        if resultat=mrYes then begin
//           ShellExecute(Handle, 'Open', PChar(ParsingDirectory+'ErrorSend.log'),nil,nil,SW_SHOWNORMAL);
//        end;
//      end;
//   end;
//  end;

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
var
 SMS:TSendSMS;
 error:string;

begin
  SMS:=TSendSMS.Create;

  if not SMS.SendSMS('Тескт чтобы не повторялся '+DateTimeToStr(now),'89093858545',error) then begin
    ShowMessage(error);
    Exit;
  end;

  ShowMessage('Сообщение отправлено');

end;



procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
  if chkboxShowLog.Checked then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;

procedure TFormHome.edtNumbeFromStatusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if SettingsLoadString(cAUTHconf,'core','send_enter','true')='true' then begin
    if (Key=VK_RETURN) then begin
        btnSendSMS.Click;
    end;
 end;
end;


procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_SMS_ID:=1;
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
  end;
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

  // debug node
  if DEBUG then STDEBUG.Visible:=True;


  // размер окна
  FormHome.Width:=cWIDTH_HIDELOG;



  // создаем текущего рльзака
 {

  with FormHome do begin

  if global_DEBUG then Caption:='     ### DEBUG ###      '+Caption;

  Width:=cWIDTHStart;
 end;

  ParsingDirectory:=ExtractFilePath(ParamStr(0));
  ProgressBar.Progress:=0;

  SLSMS:=TStringList.Create;
  SLParsingError:=TStringList.Create;


  // вкладка рассылки (по умолчанию)
  PageType.ActivePageIndex:=2;

  // отображаем лог (по умолчанию)
  chkboxShowLog.Checked:=True; }


end;




procedure TFormHome.page_TypesSMSChange(Sender: TObject);
begin
  case page_TypesSMS.ActivePage.PageIndex of

   0:begin                 // ручная отправка
    //ClearTabs(MsgStatus);
   // ClearTabs(Rassilka);

    OptionsStyle(options_Manual);
   end;
   1:begin                  // рассылка
   // ClearTabs(MsgStatus);
   // ClearTabs(ManualSend);

    OptionsStyle(options_Sending);
   end;
  end;
end;

end.
