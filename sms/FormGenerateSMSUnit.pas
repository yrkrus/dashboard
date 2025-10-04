unit FormGenerateSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, TCheckServersUnit, TCustomTypeUnit, System.ImageList, Vcl.ImgList,Vcl.Imaging.pngimage;

type
  TFormGenerateSMS = class(TForm)
    Label1: TLabel;
    comboxReasonSmsMessage: TComboBox;
    group_Params: TGroupBox;
    lblName: TLabel;
    lblOtchestvo: TLabel;
    combox_Pol: TComboBox;
    lblPol: TLabel;
    lblDate: TLabel;
    dateShow: TDateTimePicker;
    lblTime: TLabel;
    timeShow: TDateTimePicker;
    lblClinic: TLabel;
    combox_AddressClinic: TComboBox;
    lblService: TLabel;
    btnServiceList: TButton;
    lblServiceCount: TLabel;
    lblSumma: TLabel;
    edtSumma: TEdit;
    st_rub: TStaticText;
    btnGenerateMessage: TBitBtn;
    btnGenerateMessageShow: TBitBtn;
    group_info: TGroupBox;
    lbl9: TLabel;
    lblReason: TLabel;
    reName: TRichEdit;
    reOtchestvo: TRichEdit;
    reReason: TRichEdit;
    btnPrimer: TBitBtn;
    lblAutoPodbor: TLabel;
    lblAutoPodborError: TLabel;
    procedure FormShow(Sender: TObject);
    procedure comboxReasonSmsMessageChange(Sender: TObject);
    procedure btnGenerateMessageShowClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGenerateMessageClick(Sender: TObject);
    procedure btnServiceListClick(Sender: TObject);
    procedure reNameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure reOtchestvoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure reReasonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtSummaKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrimerClick(Sender: TObject);
    procedure lblAutoPodborClick(Sender: TObject);
    procedure comboxReasonSmsMessageDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure combox_PolDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure combox_AddressClinicDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  list_clinic    :TCheckServersIK;  // список с клиниками
  serviceChoiseList:TStringList;    // выбранные услуги

  phonePodbor:string;               // номер тлф для подбора имени
  phonePodborError:string;
  isAutoPodbor:Boolean;             // флаг того что данные заполнены из автоподбора
  procedure AutoPodbor;             // автоподбор имени\отчетства\пола



  procedure Clear;
  procedure CreateReasonBox;
  procedure CreateGenderBox;
  procedure CreateListAddressClinic; // создание списка с адресами клиник
  procedure CurrentDateTime;         // текущее время\дата на форме


  procedure ShowGroupParams(_status:enumParamStatus);     // отображение выбора параметров
  procedure ShowParams(_params:enumReasonSmsMessage);     // показ нужных рпараметров в зависимости от выбранного типа сообщения
  procedure DisableAllParams;                             // отключение всех параметров
  procedure EnableParamsFIO;                              // включение параметров ФИО
  procedure EnableParamsDate;                             // включение параметров дата
  procedure EnableParamsTime;                             // включение параметров время
  procedure EnableParamsAddressClinic;                    // включение параметров адрес клиники
  procedure EnableParamsServiceList;                      // включение параметров услуги
  procedure EnableParamsReason;                           // включение параметров причина
  procedure EnableParamsSumma;                            // включение параметров сумма


  procedure CreateMessage;    // создать сообщение

  // загрузка иконок в лист бокс для последующего отображения в combobox
  procedure LoadIconListBoxChoise;

    // загрузка иконок в лист бокс для последующего отображения в combobox
  procedure LoadIconListBoxPol;

      // загрузка иконок в лист бокс для последующего отображения в combobox
  procedure LoadIconListBoxBase;


  public
    { Public declarations }
  procedure SetServiceChoise(_service:string);   // добавление в списко выбьранных услуг
  procedure DelServiceChoise(_service:string);   // удаление
  function GetServiceChoise(_id:Integer):string;
  function  GetCountServiceChoise:Integer;

  procedure SetPhonePodbor(_phone:string; const _error:string);  // установка номера тлф. для подбора

  procedure SetAutoPodborValue(_name,_mid:string; _gender:enumGender); // установка параметров атоподбора

  end;

var
  FormGenerateSMS: TFormGenerateSMS;

implementation

uses
  FunctionUnit, FormHomeUnit, GlobalVariables, TMessageGeneratorSMSUnit, FormServiceChoiseUnit, DMUnit, TAutoPodborPeopleUnit, FormPodborUnit, GlobalImageDestination;


{$R *.dfm}

// отключение всех параметров
procedure TFormGenerateSMS.DisableAllParams;
begin
  // имя
  lblName.Enabled:=False;
  reName.Enabled:=False;
  reName.Clear;

  // отчество
  lblOtchestvo.Enabled:=False;
  reOtchestvo.Enabled:=False;
  reOtchestvo.Clear;

  // пол
  lblPol.Enabled:=False;
  combox_Pol.Enabled:=False;
  combox_Pol.ItemIndex:=-1;

  // дата
  lblDate.Enabled:=False;
  dateShow.Enabled:=False;

  // время
  lblTime.Enabled:=False;
  timeShow.Enabled:=False;

  // клиника
  lblClinic.Enabled:=False;
  combox_AddressClinic.Enabled:=False;
  combox_AddressClinic.ItemIndex:=-1;

  // услуги
  lblService.Enabled:=False;
  btnServiceList.Enabled:=False;
  lblServiceCount.Enabled:=False;
  lblServiceCount.Caption:='выбрано услуг : 0';

  // сумма
  lblSumma.Enabled:=False;
  edtSumma.Enabled:=False;
  edtSumma.Text:='';
  st_rub.Enabled:=False;

  // причина
  lblReason.Enabled:=False;
  reReason.Enabled:=False;
  reReason.Clear;
end;


procedure TFormGenerateSMS.edtSummaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // Отменяем ввод, если символ не является цифрой
  end;
end;

// включение параметров ФИО + пол
procedure TFormGenerateSMS.EnableParamsFIO;
begin
   // имя
  lblName.Enabled:=True;
  reName.Enabled:=True;
  // отчество
  lblOtchestvo.Enabled:=True;
  reOtchestvo.Enabled:=True;
  // пол
  lblPol.Enabled:=True;
  combox_Pol.Enabled:=True;
end;


// включение параметров дата
procedure TFormGenerateSMS.EnableParamsDate;
begin
 // дата
  lblDate.Enabled:=True;
  dateShow.Enabled:=True;
end;

// включение параметров время
procedure TFormGenerateSMS.EnableParamsTime;
begin
 // время
  lblTime.Enabled:=True;
  timeShow.Enabled:=True;
end;

// включение параметров адрес клиники
procedure TFormGenerateSMS.EnableParamsAddressClinic;
begin
  // клиника
  lblClinic.Enabled:=True;
  combox_AddressClinic.Enabled:=True;
  combox_AddressClinic.ItemIndex:=-1;
end;


// включение параметров услуги
procedure TFormGenerateSMS.EnableParamsServiceList;
begin
  // услуги
  lblService.Enabled:=True;
  btnServiceList.Enabled:=True;
  lblServiceCount.Enabled:=True;
  lblServiceCount.Caption:='выбрано услуг : 0';
end;


// включение параметров причина
procedure TFormGenerateSMS.EnableParamsReason;
begin
  // причина
  lblReason.Enabled:=True;
  reReason.Enabled:=True;
  reReason.Clear;
end;


// включение параметров сумма
procedure TFormGenerateSMS.EnableParamsSumma;
begin
  // сумма
  lblSumma.Enabled:=True;
  edtSumma.Enabled:=True;
  edtSumma.Text:='';
  st_rub.Enabled:=False;
end;

// добавление в списко выбьранных услуг
procedure TFormGenerateSMS.SetServiceChoise(_service:string);
var
 i:Integer;
 isExist:Boolean;
begin
  isExist:=False;

  for i:=0 to serviceChoiseList.Count-1 do begin
    if serviceChoiseList[i] = _service then begin
     isExist:=True;
     Break;
    end;
  end;

  if not isExist then serviceChoiseList.Add(_service);
end;

// удаление
procedure TFormGenerateSMS.DelServiceChoise(_service:string);
var
 i:Integer;
begin
  for i:=serviceChoiseList.Count-1 downto 0 do begin
    if serviceChoiseList[i] = _service then begin
      serviceChoiseList.Delete(i);

     Break;
    end;
  end;
end;


function TFormGenerateSMS.GetServiceChoise(_id:Integer):string;
begin
  Result:=serviceChoiseList[_id];
end;


procedure TFormGenerateSMS.lblAutoPodborClick(Sender: TObject);
begin
  AutoPodbor;
end;

procedure TFormGenerateSMS.reNameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    if IsExistSpellingColor(DM.maybeDictionary, reName) then begin
      DM.popmenu_AddSpellnig.Items[0].Enabled:=True;
    end
    else begin
     DM.popmenu_AddSpellnig.Items[0].Enabled:=False;
    end;
  end;
end;

procedure TFormGenerateSMS.reOtchestvoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    if IsExistSpellingColor(DM.maybeDictionary, reOtchestvo) then begin
      DM.popmenu_AddSpellnig.Items[0].Enabled:=True;
    end
    else begin
     DM.popmenu_AddSpellnig.Items[0].Enabled:=False;
    end;
  end;
end;

procedure TFormGenerateSMS.reReasonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    if IsExistSpellingColor(DM.maybeDictionary, reReason) then begin
      DM.popmenu_AddSpellnig.Items[0].Enabled:=True;
    end
    else begin
     DM.popmenu_AddSpellnig.Items[0].Enabled:=False;
    end;
  end;
end;

function TFormGenerateSMS.GetCountServiceChoise:Integer;
begin
  Result:=serviceChoiseList.Count;
end;

// установка номера тлф. для подбора
procedure TFormGenerateSMS.SetPhonePodbor(_phone:string; const _error:string);
begin
  phonePodbor:=_phone;
  phonePodborError:=_error;
end;

// установка параметров атоподбора
procedure TFormGenerateSMS.SetAutoPodborValue(_name,_mid:string; _gender:enumGender);
begin
  reName.Clear;
  reName.Text:=_name;

  reOtchestvo.Clear;
  reOtchestvo.Text:=_mid;

  combox_Pol.ItemIndex:=EnumGenderToInteger(_gender);

  isAutoPodbor:=True;
end;

// создать сообщение
procedure TFormGenerateSMS.CreateMessage;
var
 params:enumReasonSmsMessage;
 gender:enumGender;
 prichina:string;
 money:string;
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  if comboxReasonSmsMessage.ItemIndex = -1 then begin
   Screen.Cursor:=crDefault;

   MessageBox(Handle,PChar('Не выбран "Тип сообщения"'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  params:=StringToEnumReasonSmsMessage(comboxReasonSmsMessage.Items[comboxReasonSmsMessage.ItemIndex]);
  gender:=StringToEnumGender(combox_Pol.Items[combox_Pol.ItemIndex]);
  prichina:=reReason.Text;
  money:=edtSumma.Text;

  // очищаем сообщение (так на всякий случай)
  SharedGenerateMessage.ClearMessage;

  // проверка параметров перед созданием сообщения
  if not SharedGenerateMessage.CheckParams(params, serviceChoiseList, isAutoPodbor, error) then begin
   Screen.Cursor:=crDefault;
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  SharedGenerateMessage.CreateMessage(params, gender, reName.Text, reOtchestvo.Text, serviceChoiseList, money, prichina);

  Screen.Cursor:=crDefault;
end;


// показ нужных рпараметров в зависимости от выбранного типа сообщения
procedure TFormGenerateSMS.ShowParams(_params:enumReasonSmsMessage);
begin
  // отключаем все параметры
  DisableAllParams;

  case _params of
   reason_OtmenaPriema: begin                       // Отмена приема врача, перенос
     // + ФИО + пол
     EnableParamsFIO;
   end;
   reason_NapominanieOPrieme:begin                  // Напоминание о приеме
    // + ФИО + пол
    EnableParamsFIO;

    // дата
    EnableParamsDate;

    // время
    EnableParamsTime;

    // адрес клинки
    EnableParamsAddressClinic;

   end;
   reason_NapominanieOPrieme_do15:begin             // Напоминание о приеме (до 15 лет)
     // + ФИО + пол
     EnableParamsFIO;

     // дата
    EnableParamsDate;

     // время
    EnableParamsTime;

     // адрес клинки
    EnableParamsAddressClinic;
   end;
   reason_NapominanieOPrieme_OMS:begin              // Напоминание о приеме (ОМС)
     // + ФИО + пол
     EnableParamsFIO;

     // дата
    EnableParamsDate;

     // время
    EnableParamsTime;

     // адрес клинки
    EnableParamsAddressClinic;
   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // Истекает срок годности биоматериала
     // + ФИО + пол
     EnableParamsFIO;

     // дата
    EnableParamsDate;

     // время
    EnableParamsTime;
   end;
   reason_AnalizNaPereustanovke:begin               // Анализ на переустановке
     // + ФИО + пол
     EnableParamsFIO;
   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // Увеличился срок выполнения лабораторных исследований по тех. причинам
    // + ФИО + пол
     EnableParamsFIO;

     // дата
    EnableParamsDate;
   end;
   reason_Perezabor:begin                           // Требуется перезабор крови (хилез, сгусток, недостаточно биоматериала)
     // + ФИО + пол
     EnableParamsFIO;

     // адрес клинки
    EnableParamsAddressClinic;

    // услуги
    EnableParamsServiceList;

    // причина
    EnableParamsReason;
   end;
   reason_Critical:begin                            // Получено письмо из лаборатории о критических значениях
     // + ФИО + пол
     EnableParamsFIO;
   end;
   reason_ReadyDiagnostic:begin                     // Готов результат диагностики (например,  ХОЛТЕРа, СМАДа)
     // + ФИО + пол
     EnableParamsFIO;

     // адрес клинки
     EnableParamsAddressClinic;
   end;
   reason_ReadyNalog:begin                          // Готова справка в налоговую
    // + ФИО + пол
     EnableParamsFIO;

    // адрес клинки
    EnableParamsAddressClinic;
   end;
   reason_ReadyDocuments:begin                      // Готова копия мед. документации, выписка, справка
     // + ФИО + пол
     EnableParamsFIO;

     // адрес клинки
     EnableParamsAddressClinic;
   end;
   reason_NeedDocumentsLVN:begin                    // Необходимо предоставить данные для открытия ЛВН (СНИЛС)
    // + ФИО + пол
     EnableParamsFIO;

    // адрес клинки
    EnableParamsAddressClinic;
   end;
   reason_NeedDocumentsDMS:begin                    // Проинформировать о согласовании услуг по ДМС (когда обещали)
     // + ФИО + пол
     EnableParamsFIO;
   end;
   reason_VneplanoviiPriem:begin                    // Согласован внеплановый прием (обозначить время)
     // + ФИО + пол
     EnableParamsFIO;

     // время
    EnableParamsTime;

     // адрес клинки
    EnableParamsAddressClinic;
   end;
   reason_ReturnMoney:begin                         // Пригласить за возвратом ДС
     // + ФИО + пол
     EnableParamsFIO;

     // адрес клинки
    EnableParamsAddressClinic;

     // услуги
    EnableParamsServiceList;

    // сумма
    EnableParamsSumma;
   end;
   reason_ReturnMoneyInfo:begin                     // Проинформировать об осуществлении возврата ДС
     // + ФИО + пол
     EnableParamsFIO;

     // дата
    EnableParamsDate;

     // услуги
    EnableParamsServiceList;

     // сумма
    EnableParamsSumma;
   end;
   reason_ReturnDiagnostic:begin                    // Пригласить за гистологическим (цитологическим) материалом
     // + ФИО + пол
     EnableParamsFIO;

     // адрес клинки
     EnableParamsAddressClinic;
   end;
   reason_OtmenaPriemaNal_DMS:begin                // Отмена приема, врач не принимает по ДМС
     // + ФИО + пол
     EnableParamsFIO;
   end;
  end;
end;


// отображение выбора параметров
procedure TFormGenerateSMS.ShowGroupParams(_status:enumParamStatus);
begin
  // сброс выбранных ранее параметров
  if Assigned(serviceChoiseList) then serviceChoiseList.Clear;


  case _status of
    paramStatus_ENABLED: begin
     group_Params.Visible:=True;
     group_info.Visible:=False;
    end;
    paramStatus_DISABLED: begin
     group_Params.Visible:=False;
     group_info.Visible:=True;
    end;
  end;

  group_info.Left:=group_Params.Left;
  group_info.Top:=group_Params.Top;
end;


// загрузка иконок в лист бокс для последующего отображения в combobox
procedure TFormGenerateSMS.LoadIconListBoxChoise;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmp: TPngImage;
 bmp: TBitmap;
begin
 // **********************************************************
 // добавление тут + в events DrawItem самого combox
 // **********************************************************
  if not FileExists(ICON_SMS_CHOISE_REASON) then Exit;

  // изменение стиля для отображения иконок в combox
  comboxReasonSmsMessage.Style:=csOwnerDrawFixed;

  DM.ImageListIcon_choise.SetSize(SIZE_ICON,SIZE_ICON);
  DM.ImageListIcon_choise.ColorDepth:=cd32bit;

  pngbmp:=TPngImage.Create;
  bmp:=TBitmap.Create;

  pngbmp.LoadFromFile(ICON_SMS_CHOISE_REASON);

  // сжимаем иконку до размера 16х16
  with bmp do begin
   Height:=SIZE_ICON;
   Width:=SIZE_ICON;
   Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmp);
  end;

  DM.ImageListIcon_choise.Add(bmp, nil);

  if pngbmp<>nil then pngbmp.Free;
  if bmp<>nil then bmp.Free;
end;



// загрузка иконок в лист бокс для последующего отображения в combobox
procedure TFormGenerateSMS.LoadIconListBoxPol;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpMale,pngbmpFeMale: TPngImage;
 bmpMale,bmpFeMale: TBitmap;
begin
 // **********************************************************
 // добавление тут + в events DrawItem самого combox
 // **********************************************************
  if not FileExists(ICON_SMS_POL_MALE) then Exit;
  if not FileExists(ICON_SMS_POL_FEMALE) then Exit;

  // изменение стиля для отображения иконок в combox
  combox_Pol.Style:=csOwnerDrawFixed;

  DM.ImageListIcon_pol.SetSize(SIZE_ICON,SIZE_ICON);
  DM.ImageListIcon_pol.ColorDepth:=cd32bit;

  begin
   // male
   pngbmpMale:=TPngImage.Create;
   bmpMale:=TBitmap.Create;

   pngbmpMale.LoadFromFile(ICON_SMS_POL_MALE);

    // сжимаем иконку до размера 16х16
    with bmpMale do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpMale);
    end;

   // female
   pngbmpFeMale:=TPngImage.Create;
   bmpFeMale:=TBitmap.Create;

   pngbmpFeMale.LoadFromFile(ICON_SMS_POL_FEMALE);

    // сжимаем иконку до размера 16х16
    with bmpFeMale do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpFeMale);
    end;

  end;

  DM.ImageListIcon_pol.Add(bmpMale, nil);
  DM.ImageListIcon_pol.Add(bmpFeMale, nil);


  if pngbmpMale<>nil then pngbmpMale.Free;
  if bmpMale<>nil then bmpMale.Free;
  if pngbmpFeMale<>nil then pngbmpFeMale.Free;
  if bmpFeMale<>nil then bmpFeMale.Free;
end;


// загрузка иконок в лист бокс для последующего отображения в combobox
procedure TFormGenerateSMS.LoadIconListBoxBase;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmp: TPngImage;
 bmp: TBitmap;
begin
 // **********************************************************
 // добавление тут + в events DrawItem самого combox
 // **********************************************************
  if not FileExists(ICON_SMS_BASE_CHOISE) then Exit;

  // изменение стиля для отображения иконок в combox
  combox_AddressClinic.Style:=csOwnerDrawFixed;

  DM.ImageListIcon_base.SetSize(SIZE_ICON,SIZE_ICON);
  DM.ImageListIcon_base.ColorDepth:=cd32bit;

  pngbmp:=TPngImage.Create;
  bmp:=TBitmap.Create;

  pngbmp.LoadFromFile(ICON_SMS_BASE_CHOISE);

  // сжимаем иконку до размера 16х16
  with bmp do begin
   Height:=SIZE_ICON;
   Width:=SIZE_ICON;
   Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmp);
  end;

  DM.ImageListIcon_base.Add(bmp, nil);

  if pngbmp<>nil then pngbmp.Free;
  if bmp<>nil then bmp.Free;
end;




procedure TFormGenerateSMS.CreateReasonBox;
var
 i:Integer;
 reason:enumReasonSmsMessage;
begin
  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    reason:=enumReasonSmsMessage(i);
    if reason = reason_Empty then Continue; // пропускаем пустой -1
    
    comboxReasonSmsMessage.Items.Add(EnumReasonSmsMessageToString(reason));
  end;

  // кол-во значений выбора в выпадабщем меню
  comboxReasonSmsMessage.DropDownCount:=Ord(High(enumReasonSmsMessage))+1;

  // прогрузка инконки выбора
  LoadIconListBoxChoise;
end;


procedure TFormGenerateSMS.CreateGenderBox;
var
 i:Integer;
 gender:enumGender;
begin
  for i:=Ord(Low(enumGender)) to Ord(High(enumGender)) do
  begin
    gender:=enumGender(i);
    combox_Pol.Items.Add(EnumGenderToString(gender));
  end;

    // прогрузка инконки пола
  LoadIconListBoxPol;
end;


procedure TFormGenerateSMS.btnGenerateMessageClick(Sender: TObject);
begin
  CreateMessage;
  if not SharedGenerateMessage.IsGeneretedMessage then Exit;

  Screen.Cursor:=crHourGlass;
  AddMessageFromTemplate(SharedGenerateMessage.GeneretedMessage);

  // добавляем инфо что сообщение нельзя отредактировать
  FormHome.SetEditMessage(paramStatus_DISABLED,'Сообщение из генератора не редактируется!');
  FormHome.SetReasonSMSType( IntegerToEnumReasonSmsMessage(comboxReasonSmsMessage.ItemIndex));

  Screen.Cursor:=crDefault;
  Close;
end;

procedure TFormGenerateSMS.btnGenerateMessageShowClick(Sender: TObject);
begin
  CreateMessage;
  if not SharedGenerateMessage.IsGeneretedMessage then Exit;

  MessageBox(Handle,PChar(SharedGenerateMessage.GeneretedMessage),PChar('Инфо'),MB_OK+MB_ICONINFORMATION);
end;


procedure TFormGenerateSMS.btnPrimerClick(Sender: TObject);
begin
  MessageBox(Handle,PChar(SharedGenerateMessage.GetExampleMessage(IntegerToEnumReasonSmsMessage(comboxReasonSmsMessage.ItemIndex))),
                    PChar('Инфо'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormGenerateSMS.btnServiceListClick(Sender: TObject);
begin
  FormServiceChoise.ShowModal;
end;

procedure TFormGenerateSMS.Clear;
begin
  comboxReasonSmsMessage.Clear;
  combox_Pol.Clear;

  // параметры сообщения
  ShowGroupParams(paramStatus_DISABLED);

  // показать сообщение
  btnGenerateMessageShow.Enabled:=true;

  // выбранные услуги
  if not Assigned(serviceChoiseList) then serviceChoiseList:=TStringList.Create
  else serviceChoiseList.Clear;
end;

// создание списка с адресами клиник
procedure TFormGenerateSMS.comboxReasonSmsMessageChange(Sender: TObject);
var
 params:enumReasonSmsMessage;
begin
  //ототбражаем параметры
  ShowGroupParams(paramStatus_ENABLED);

  // отображаем нужные параметры
 params:=StringToEnumReasonSmsMessage(comboxReasonSmsMessage.Items[comboxReasonSmsMessage.ItemIndex]);
 ShowParams(params);
end;

procedure TFormGenerateSMS.comboxReasonSmsMessageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if DM.ImageListIcon_choise.Count = 0 then  Exit;

  IconIndex:=0;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    DM.ImageListIcon_choise.GetBitmap(IconIndex, Bitmap);
    with ComboBox.Canvas do
    begin
      FillRect(Rect);
      if Bitmap.Handle <> 0 then
        Draw(Rect.Left + 2, Rect.Top, Bitmap);
      Rect := Bounds(
        Rect.Left + ComboBox.ItemHeight + 3,
        Rect.Top,
        Rect.Right - Rect.Left,
        Rect.Bottom - Rect.Top
      );
      DrawText(
        handle,
        PChar(ComboBox.Items[Index]),
        length(ComboBox.Items[index]),
        Rect,
        DT_VCENTER + DT_SINGLELINE
      );
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TFormGenerateSMS.combox_AddressClinicDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if DM.ImageListIcon_base.Count = 0 then  Exit;

  IconIndex:=0;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    DM.ImageListIcon_base.GetBitmap(IconIndex, Bitmap);
    with ComboBox.Canvas do
    begin
      FillRect(Rect);
      if Bitmap.Handle <> 0 then
        Draw(Rect.Left + 2, Rect.Top, Bitmap);
      Rect := Bounds(
        Rect.Left + ComboBox.ItemHeight + 3,
        Rect.Top,
        Rect.Right - Rect.Left,
        Rect.Bottom - Rect.Top
      );
      DrawText(
        handle,
        PChar(ComboBox.Items[Index]),
        length(ComboBox.Items[index]),
        Rect,
        DT_VCENTER + DT_SINGLELINE
      );
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TFormGenerateSMS.combox_PolDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if DM.ImageListIcon_pol.Count = 0 then  Exit;

  IconIndex:=Index;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    DM.ImageListIcon_pol.GetBitmap(IconIndex, Bitmap);
    with ComboBox.Canvas do
    begin
      FillRect(Rect);
      if Bitmap.Handle <> 0 then
        Draw(Rect.Left + 2, Rect.Top, Bitmap);
      Rect := Bounds(
        Rect.Left + ComboBox.ItemHeight + 3,
        Rect.Top,
        Rect.Right - Rect.Left,
        Rect.Bottom - Rect.Top
      );
      DrawText(
        handle,
        PChar(ComboBox.Items[Index]),
        length(ComboBox.Items[index]),
        Rect,
        DT_VCENTER + DT_SINGLELINE
      );
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TFormGenerateSMS.CreateListAddressClinic;
var
 i:Integer;
begin
  combox_AddressClinic.Clear;
  list_clinic:=TCheckServersIK.Create(True);

  for i:=0 to list_clinic.Count-1 do begin
    combox_AddressClinic.Items.Add(list_clinic.GetAddress(i));
  end;

  // прогрузка инконки
  LoadIconListBoxBase;
end;


// текущее время\дата на форме
procedure TFormGenerateSMS.CurrentDateTime;
begin
 dateShow.Date:=Now;
 timeShow.Time:=Now;
end;


procedure TFormGenerateSMS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  phonePodbor:='';
  phonePodborError:='';
  isAutoPodbor:=False;

  // проверим что создали сообщение
  if not SharedGenerateMessage.IsGeneretedMessage then begin
   OptionsStyle(options_Manual);
   Exit;
  end;

  FormHome.ShowManualMessage;
end;

procedure TFormGenerateSMS.FormShow(Sender: TObject);
begin
  if not Assigned(SharedGenerateMessage) then begin
   SharedGenerateMessage:=TMessageGeneratorSMS.Create(Self);
  end
  else SharedGenerateMessage.Clear;

  Clear;

  // создадим выбор вариантов сообщений
  CreateReasonBox;
  CreateGenderBox;

  // список с адресами клиник
  CreateListAddressClinic;

  // текущее время\дата на форме
  CurrentDateTime;

  // влючить автоподбор
  if phonePodbor<>'' then begin
   lblAutoPodbor.Enabled:=True;
   lblAutoPodbor.Caption:='Автоподбор имени';
   lblAutoPodbor.ShowHint:=True;

   // причина
   lblAutoPodborError.Visible:=False;
  end
  else begin
   lblAutoPodbor.Enabled:=False;
   lblAutoPodbor.Caption:='Автоподбор имени (недоступен)';
   lblAutoPodbor.ShowHint:=False;

   // причина
   lblAutoPodborError.Visible:=True;
   lblAutoPodborError.Caption:='Причина: '+phonePodborError;
  end;
end;

// автоподбор имени\отчетства\пола
procedure TFormGenerateSMS.AutoPodbor;
var
 people:TAutoPodborPeople;
begin
  showWait(show_open);

  Screen.Cursor:=crHourGlass;

  people:=TAutoPodborPeople.Create(phonePodbor);
  if people.Count = 0 then begin
    showWait(show_close);
    Screen.Cursor:=crDefault;
    MessageBox(Handle,PChar('В базе ИК нет записи по номеру '+#39+phonePodbor+#39),PChar('Нет записи'),MB_OK+MB_ICONINFORMATION);
    Exit;
  end;

  if people.Count = 1 then begin
    showWait(show_close);
    Screen.Cursor:=crDefault;

    SetAutoPodborValue(people.FirstName(0),people.MidName(0),people.Gender(0));
  end
  else begin
   showWait(show_close);
   Screen.Cursor:=crDefault;

   with FormPodbor do begin
     SetTypePodbor(eTypePodporPeople);
     SetListPacients(people);
     ShowModal;
   end;

  end;
end;

end.
