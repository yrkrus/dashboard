unit FormStatusSendingSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Data.DB, Data.Win.ADODB, Vcl.Imaging.pngimage, System.ImageList,
  Vcl.ImgList, TCustomTypeUnit, Vcl.Imaging.jpeg, TAutoPodborSendingSmsUnit,
  Vcl.ExtDlgs;

type
  TFormStatusSendingSMS = class(TForm)
    panelInfo: TPanel;
    Label1: TLabel;
    Label8: TLabel;
    lblID: TLabel;
    lblDateSend: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnSaveFirebirdSettings: TBitBtn;
    lblPhone: TLabel;
    lblCode: TLabel;
    lblTimeStatus: TLabel;
    lblFIO: TLabel;
    imgStatus: TImage;
    Label9: TLabel;
    lblOperator: TLabel;
    Label11: TLabel;
    lblRegion: TLabel;
    SavePicture: TSavePictureDialog;
    re_Message: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
  private
    { Private declarations }
  m_smsInfo:TAutoPodborSendingSms;
  m_idStruct:Integer;    // id в структуре m_smsInfo

  procedure ShowStatus;
  procedure Clear;

  procedure ClearForm;
  procedure FillData; // заполнение данными на форме
  procedure CreateStatusImage(_code:enumStatusCodeSms);

  public
    { Public declarations }
   procedure SetSmsInfo(_info:TAutoPodborSendingSms; _idStruct:Integer); overload;
   procedure SetSmsInfo(_phone:string); overload;
   function IsExistSmsInfo:Boolean;

  end;

var
  FormStatusSendingSMS: TFormStatusSendingSMS;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, GlobalImageDestination;

{$R *.dfm}


procedure TFormStatusSendingSMS.SetSmsInfo(_info:TAutoPodborSendingSms; _idStruct:Integer);
var
 cloneSendingSMS:TAutoPodborSendingSms;
begin
  cloneSendingSMS:=TAutoPodborSendingSms.Create(_info);

  m_smsInfo:=cloneSendingSMS;
  m_idStruct:=_idStruct;
end;

procedure TFormStatusSendingSMS.SetSmsInfo(_phone:string);
var
 cloneSendingSMS:TAutoPodborSendingSms;
begin
 cloneSendingSMS:=TAutoPodborSendingSms.Create(_phone);
  m_smsInfo:=cloneSendingSMS;
  m_idStruct:=0;
end;


function TFormStatusSendingSMS.IsExistSmsInfo:Boolean;
begin
 Result:=((Assigned(m_smsInfo)) and (m_idStruct<>-1));
end;


procedure TFormStatusSendingSMS.ShowStatus;
begin
  // очищаем форму
  ClearForm;

  // заполняем данными
  FillData;

  // фокус на кнопку
  btnSaveFirebirdSettings.SetFocus;
end;

procedure TFormStatusSendingSMS.btnSaveFirebirdSettingsClick(Sender: TObject);
var
 error:string;
 path:string;
begin

  SavePicture.DefaultExt := '.jpg';   // расширение файлов по умолчанию
  SavePicture.Filter     := 'JPEG (*.jpg)|*.jpg'; // фильтр типов файлов
  SavePicture.Title      := 'Выберите имя файла и папку для сохранения';

  if SavePicture.Execute then
  begin
    path := SavePicture.FileName;

    if not SaveResultSendingSMS(Self.panelInfo,path,error) then
     begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
     end;

     MessageBox(Handle,PChar('Сохранено в '+path),PChar('Успех'),MB_OK+MB_ICONINFORMATION);

  end;
end;



procedure TFormStatusSendingSMS.Clear;
begin
  if Assigned(m_smsInfo) then FreeAndNil(m_smsInfo);
  m_idStruct:=-1;
end;


// очистка данных на форме
procedure TFormStatusSendingSMS.ClearForm;
begin
  lblID.Caption:='';
  lblDateSend.Caption:='';
  lblPhone.Caption:='';
  lblOperator.Caption:='';
  lblRegion.Caption:='';
  lblFIO.Caption:='';

  re_Message.Clear;

  lblCode.Caption:='';
  lblTimeStatus.Caption:='';
end;


procedure TFormStatusSendingSMS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Clear;
end;

procedure TFormStatusSendingSMS.FormShow(Sender: TObject);
begin
 ShowStatus;
end;


// отображение картинки со статусом
procedure TFormStatusSendingSMS.CreateStatusImage(_code:enumStatusCodeSms);
begin
 with imgStatus.Picture do begin

   case _code of
      eStatusCodeSmsQueued:       LoadFromFile(ICON_SMS_STATUS_QUEUE);            // Сообщение находится в очереди отправки и еще не было передано оператору
      eStatusCodeSmsAccepted:     LoadFromFile(ICON_SMS_STATUS_SENDING_OPERATOR); // Сообщение уже передано оператору
      eStatusCodeSmsDelivered:    LoadFromFile(ICON_SMS_STATUS_DELIVERED);        // Сообщение успешно доставлено абоненту
      eStatusCodeSmsRejected:     LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);    // Сообщение отклонено оператором
      eStatusCodeSmsUndeliverable:LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);     // Сообщение невозможно доставить из-за недоступности абонента
      eStatusCodeSmsError:        LoadFromFile(ICON_SMS_STATUS_ERROR);    // Ошибка отправки. Сообщение не было отправлено абоненту
      eStatusCodeSmsExpired:      LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);     // Истекло время ожидания финального статуса
      eStatusCodeSmsUnknown:      LoadFromFile(ICON_SMS_STATUS_ERROR);     // Статус сообщения неизвестен
      eStatusCodeSmsAborted:      LoadFromFile(ICON_SMS_STATUS_ABORT);     // Сообщение отменено пользователем
      eStatusCodeSms20107,        	    // Неверный логин или пароль
      eStatusCodeSms20117,        	    // Некорреткный номер телефона
      eStatusCodeSms20148,        	    // Невозможно предоставить услуги для продукта
      eStatusCodeSms20154,        	    // Ошибка транспорта
      eStatusCodeSms20158,        	    // Отправка невозможна, так как номер занесён в чёрный список
      eStatusCodeSms20167,        	    // Запрещено посылать сообщение с тем же текстом тому же адресату в течение нескольких минут
      eStatusCodeSms20170,        	    // Слишком длинное сообщение
      eStatusCodeSms20171,        	    // Сообщение не прошло проверку цензуры
      eStatusCodeSms20200,        	    // Неправильный запрос
      eStatusCodeSms20202,        	    // Не найден почтовый ящик для входящих сообщений
      eStatusCodeSms20203,        	    // Нет номера телефона или идентификатора группы в запросе
      eStatusCodeSms20204,        	    // Не найдены телефоны для группы
      eStatusCodeSms20207, 	    // Неправильный формат даты
      eStatusCodeSms20208, 	    // Дата начала позже даты конца
      eStatusCodeSms20209, 	    // Параметры запроса пустые
      eStatusCodeSms20211, 	    // Превышено количество сообщений для пользователя
      eStatusCodeSms20212, 	    // Превышен интервал в выбранных датах
      eStatusCodeSms20213, 	    // Невалидные номера в списке
      eStatusCodeSms20218, 	    // Запрещено отправлять на несколько адресов
      eStatusCodeSms20230, 	    // Отправитель не одобрен на стороне оператора
      eStatusCodeSms20280, 	    // Достигнут суточный лимит на отправку SMS с платформы A2P
      eStatusCodeSms20281: LoadFromFile(ICON_SMS_STATUS_ERROR);	     // Достигнут месячный лимит на отправку SMS с платформы A2P
    else
      LoadFromFile(ICON_SMS_STATUS_ERROR);
   end;
 end;
end;


// заполнение данными на форме
procedure TFormStatusSendingSMS.FillData;
begin
  // id сообщения
  lblID.Caption:=m_smsInfo.SmsID[m_idStruct];

  // дата отправки
  lblDateSend.Caption:=m_smsInfo.SendingDate[m_idStruct];

  // адресат
  lblPhone.Caption:=m_smsInfo.Phone;

  // сообщение
  re_Message.Lines.Add(m_smsInfo.MessageSMS[m_idStruct]);

  // оператор
  lblOperator.Caption:='в разработке';

  // регион
  lblRegion.Caption:='в разработке';

  // отправитель
  lblFIO.Caption:=m_smsInfo.UserFIOSending[m_idStruct];

  // статус
  if DirectoryExists(FOLDER_ICON_SMS) then CreateStatusImage(m_smsInfo.CodeStatusEnum[m_idStruct]);

  // код статуса
  lblCode.Caption:=m_smsInfo.CodeStatusString[m_idStruct] +#13+ m_smsInfo.StatusDecrypt[m_idStruct];
  // время статуса
  lblTimeStatus.Caption:=m_smsInfo.TimeStatus[m_idStruct];

end;

end.
