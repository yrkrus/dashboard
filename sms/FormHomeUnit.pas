unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.Samples.Gauges, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Menus, ClipBrd, System.ImageList, Vcl.ImgList,RichEdit;


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
    btnLoadFile: TBitBtn;
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
    popmenu_AddressClinic: TPopupMenu;
    chkbox_SignSMS: TCheckBox;
    st_ShowInfoAddAddressClinic: TStaticText;
    lblNameExcelFile: TLabel;
    lblManualSMS_List: TLabel;
    lblManualSMS_One: TLabel;
    popmenu_AddSpellnig: TPopupMenu;
    menu_AddSpelling: TMenuItem;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSendSMSClick(Sender: TObject);
    procedure btnLoadFile2Click(Sender: TObject);
    procedure page_TypesSMSChange(Sender: TObject);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
    procedure chkboxShowLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseLeave(Sender: TObject);
    procedure st_ShowNotSendingSMSMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure st_ShowNotSendingSMSClick(Sender: TObject);
    procedure edtManualSMSClick(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseLeave(Sender: TObject);
    procedure st_ShowInfoAddAddressClinicMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lblManualSMS_ListClick(Sender: TObject);
    procedure lblManualSMS_OneClick(Sender: TObject);
    procedure edtManualSMSChange(Sender: TObject);
    procedure edtManualSMSKeyPress(Sender: TObject; var Key: Char);
    procedure edtManualSMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure re_ManualSMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetSpelling(InValue:Boolean);
    procedure st_ShowInfoAddAddressClinicMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure re_ManualSMSMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menu_AddSpellingClick(Sender: TObject);



  private
    { Private declarations }
   isSpelling:Boolean;
   maybeDictionary:string; // слово которое моджет пойти в словарь
  public
    { Public declarations }
  function IsExistSpellingColor(var _MaybeDictionaryWord:string):Boolean;   // проверка можно ли показать меню на добавление слова в словарь


  end;


var
  FormHome: TFormHome;

const
cWIDTH_SHOWLOG:Integer=1128;
cWIDTH_HIDELOG:Integer=440;

cLOG_EXTENSION:string='.html';
cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
cWebApiSMSstatusID:string='https://a2p-sms-https.beeline.ru/proto/http/?gzip=none&user=%USERNAME&pass=%USERPWD&action=status&date_from=%DATE_START+00:00:00&date_to=%DATE_STOP+23:59:59';


implementation

uses
  FunctionUnit, GlobalVariables, TSendSMSUint, FormMyTemplateUnit, FormNotSendingSMSErrorUnit, TCustomTypeUnit, FormListSendingSMSUnit, TXmlUnit, TSpellingUnit;

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

// установка флага что есть орфографическая ошибка
procedure TFormHome.SetSpelling(InValue:Boolean);
begin
  isSpelling:=InValue;
end;


// проверка можно ли показать меню на добавление слова в словарь
function TFormHome.IsExistSpellingColor(var _MaybeDictionaryWord:string):Boolean;
var
  CursorPos: Integer;
  StartPos, EndPos: Integer;
  Word: string;
  i: Integer;
  IsRed: Boolean;
  CharColor: TColor;
begin
 _MaybeDictionaryWord:='';
 Result:=False;

 // Получаем позицию курсора
  CursorPos := re_ManualSMS.SelStart;

  // Находим границы слова под курсором
  StartPos := SendMessage(re_ManualSMS.Handle, EM_FINDWORDBREAK, WB_LEFT, CursorPos);
  EndPos := SendMessage(re_ManualSMS.Handle, EM_FINDWORDBREAK, WB_RIGHT, CursorPos);

  // Извлекаем слово
  Word := Copy(re_ManualSMS.Text, StartPos + 1, EndPos - StartPos);

  if Word = '' then begin
    Exit;
  end;

  // Проверяем, не пустое ли слово
  begin
    IsRed := False; // Предполагаем, что слово не с ошибкой
    for i := StartPos to EndPos - 1 do
    begin
      // Получаем цвет символа
      SendMessage(re_ManualSMS.Handle, EM_SETSEL, i, i + 1);
      CharColor := re_ManualSMS.SelAttributes.Color;

      // Проверяем, является ли цвет символа красным
      if CharColor = clRed then
      begin
        IsRed := True;
        Break;
      end;
    end;

    if IsRed then begin
       Word:=StringReplace(Word,' ','',[rfReplaceAll]);

      _MaybeDictionaryWord:=Word;
      Result:=True;
    end;
  end;
end;


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
 XML:TXML;
 FindPath:string;
 FullPath:string;
begin
  // ранее сохраненный путь
  XML:=TXML.Create(PChar(SETTINGS_XML));
  FindPath:=XML.GetFolderPathFindRemember;
  if FindPath = 'null' then FindPath:=FOLDERPATH;


  with OpenDialog do begin
     Title:='Загрузка файла';
     DefaultExt:='xls';
     Filter:='Excel 2003 и старее | *.xls|Excel 2007 и новее| *.xlsx';
     FilterIndex:=1;
     InitialDir:=FindPath;

      if Execute then
      begin
         FileExcelSMS:=FileName;
         while AnsiPos('\',FileExcelSMS)<>0 do System.Delete(FileExcelSMS,1,AnsiPos('\',FileExcelSMS));
         lblNameExcelFile.Caption:=FileExcelSMS;
         lblNameExcelFile.Hint:=FileName;
         lblNameExcelFile.Font.Color:=clGreen;

         FileExcelSMS:=FileName;

         // сохраняем путь
         FullPath:=ExtractFilePath(FileName);
         XML.SetFolderPathFindRemember(FullPath);
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
 i:Integer;
begin
  // проверки
  Screen.Cursor:=crHourGlass;

  begin
    case page_TypesSMS.ActivePage.PageIndex of
     0:begin                 // ручная отправка
      currentOptions:=options_Manual;

      // добавим номера телефонов в список
      SharedSendindPhoneManualSMS.Clear;
      if Length(edtManualSMS.Text) <> 0 then SharedSendindPhoneManualSMS.Add(edtManualSMS.Text)
      else begin
        for i:=0 to FormListSendingSMS.re_ListSendingSMS.Lines.Count-1 do begin
          SharedSendindPhoneManualSMS.Add(FormListSendingSMS.re_ListSendingSMS.Lines[i]);
        end;
      end;

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
        if SharedSendindPhoneManualSMS.Count > 1 then begin
          MessageBox(Handle,PChar('Сообщение отправлено на все номера из списка'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
        end
        else begin
          MessageBox(Handle,PChar('Сообщение отправлено'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
        end;
      end;
    end;
    options_Sending:begin
      ProgressStatusText.Caption:='Статус : Отправка';
      if not SendingMessage(currentOptions, error) then begin
        Screen.Cursor:=crDefault;
        MessageBox(Handle,PChar(error),PChar('Ошибка отправки'),MB_OK+MB_ICONERROR);
      end
      else begin
       Screen.Cursor:=crDefault;
       MessageBox(Handle,PChar('Отправлено'+#13+'Статус доставки доступен в отчетах'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
      end;
    end;
   end;

   // очищаем данные формы
   ClearParamsForm(currentOptions);
   Screen.Cursor:=crDefault;
end;




procedure TFormHome.chkboxShowLogClick(Sender: TObject);
begin
  if chkboxShowLog.Checked then ShowOrHideLog(log_show)
  else ShowOrHideLog(log_hide);
end;



procedure TFormHome.edtManualSMSChange(Sender: TObject);
begin
  lblManualSMS_List.Caption:='списком';
  SharedSendindPhoneManualSMS.Clear;
end;

procedure TFormHome.edtManualSMSClick(Sender: TObject);
begin
  if st_PhoneInfo.Visible then st_PhoneInfo.Visible:=False;
end;


procedure TFormHome.edtManualSMSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
  begin
    case Key of
       86: // Ctrl + V
        begin
          // Вставляем текст из буфера обмена
          edtManualSMS.Text := edtManualSMS.Text + Clipboard.AsText;
          Key := 0; // Отменяем дальнейшую обработку клавиши
        end;
      88: // Ctrl + X
        begin
          // Копируем выделенный текст в буфер обмена и удаляем его из Edit
          Clipboard.AsText := edtManualSMS.Text; // Если нужно, чтобы текст был скопирован
          edtManualSMS.ClearSelection; // Удаляем выделение
          Key := 0; // Отменяем дальнейшую обработку клавиши
        end;
    end;
  end;
end;

procedure TFormHome.edtManualSMSKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
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


function GetWordStart(const Text: string; CursorPos: Integer): Integer;
var
 size_result:Integer;
begin

  size_result := CursorPos;
  while (size_result > 0) and (Text[size_result] <> ' ') do
    Dec(size_result);
  if (size_result < Length(Text)) and (Text[size_result] = ' ') then
    Inc(size_result); // Сдвигаемся на один символ вправо, чтобы получить начало слова

    Result:=size_result-1;
end;

function GetWordEnd(const Text: string; CursorPos: Integer): Integer;
begin
  Result := CursorPos;
  while (Result < Length(Text)) and (Text[Result + 1] <> ' ') do
    Inc(Result);
  if (Result > 1) and (Text[Result + 1] = ' ') then
    Dec(Result); // Сдвигаемся на один символ влево, чтобы получить конец слова
end;




procedure TFormHome.re_ManualSMSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  CursorPos: Integer;
  StartWord, EndWord: Integer;
  Text: string;
begin
//  // Проверяем, нажата ли клавиша Backspace
//  if Key = VK_BACK then
//  begin
//    // Получаем текст из редактора
//    Text := re_ManualSMS.Text;
//    CursorPos := re_ManualSMS.SelStart;
//
//    if isSpelling then
//    begin
//      // Проверяем стиль цвета слова под курсором
//      StartWord := GetWordStart(Text, CursorPos);
//      EndWord := GetWordEnd(Text, CursorPos);
//
//      // Устанавливаем выделение для слова
//      re_ManualSMS.SelStart := StartWord;
//      re_ManualSMS.SelLength := EndWord - StartWord + 1; // Увеличиваем длину на 1, чтобы включить последний символ
//
//      // Проверка на стиль clRed
//      if re_ManualSMS.SelAttributes.Color = clRed then
//      begin
//        // Меняем цвет всего слова на clBlack
//        re_ManualSMS.SelAttributes.Color := clBlack; // Меняем цвет
//        re_ManualSMS.SelAttributes.Style:=[];
//
//        // Отменяем выделение, чтобы не удалять текст
//        re_ManualSMS.SelLength := 0;
//      end;
//    end;
//
//    // Если есть выделенный текст, удаляем его
//    if re_ManualSMS.SelLength > 0 then
//    begin
//      re_ManualSMS.SelText := ''; // Удаляем выделенный текст
//    end
//    else
//    begin
//      // Если курсор не в начале текста
//      if CursorPos > 0 then
//      begin
//        // Удаляем символ перед курсором
//        re_ManualSMS.SelStart := CursorPos - 1; // Перемещаем курсор на одну позицию влево
//        re_ManualSMS.SelLength := 1; // Устанавливаем длину выделения в 1 символ
//        re_ManualSMS.SelText := ''; // Удаляем выделенный текст (т.е. символ перед курсором)
//      end;
//    end;
//
//    // Отменяем стандартное действие Backspace
//    Key := 0;
//  end;
end;


procedure TFormHome.re_ManualSMSMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    if IsExistSpellingColor(maybeDictionary) then begin
      popmenu_AddSpellnig.Items[0].Enabled:=True;
    end
    else begin
     popmenu_AddSpellnig.Items[0].Enabled:=False;

    end;
  end;
end;

procedure TFormHome.st_ShowInfoAddAddressClinicMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    // Отображаем всплывающее меню
    popmenu_AddressClinic.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
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
  Screen.Cursor:=crHourGlass;

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
   Screen.Cursor:=crDefault;

   MessageBox(Handle,PChar('Excel не установлен'+#13#13+error),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  // возможность автоматически вставлять подпись в смс сообщение
  SignSMS;

  // создание меню быстрого доступа к адресам клиник
  CreatePopMenuAddressClinic(popmenu_AddressClinic, re_ManualSMS);

  // стартовая вкладка
  page_TypesSMS.ActivePage:=sheet_ManualSMS;


  Screen.Cursor:=crDefault;
end;

procedure TFormHome.lblManualSMS_ListClick(Sender: TObject);
var
  MousePos: TPoint;
begin
  edtManualSMS.Text:='';

  GetCursorPos(MousePos);

  with FormListSendingSMS do begin
    m_left := MousePos.X;
    m_top := MousePos.Y;
    ShowModal;
  end;
end;

procedure TFormHome.lblManualSMS_OneClick(Sender: TObject);
begin
 ShowSendingManualPhone(sending_one);
end;

procedure TFormHome.menu_AddSpellingClick(Sender: TObject);
var
  resultat:Word;
  Spelling:TSpelling;
  error:string;
begin
  resultat:=MessageBox(Handle,PChar('Точно добавить слово "'+maybeDictionary+'" в словарь?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
  if resultat=mrYes then begin
    Spelling:=TSpelling.Create(re_ManualSMS, True);

    if not Spelling.AddWordToDictionary(maybeDictionary,error) then begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end
    else MessageBox(Handle,PChar(error),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
  end;
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
