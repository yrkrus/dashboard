unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdHTTP,IdSSL,
  IdIOHandlerStack, IdSSLOpenSSL, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Buttons,
  TSipPhoneListUnit, System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,TPhoneListUnit;

type
  TFormHome = class(TForm)
    group_register_auto: TGroupBox;
    ImgNewYear: TImage;
    Label3: TLabel;
    lbl_operators_AutoRegisterPhone: TLabel;
    img_operators_AutoRegisterPhone: TImage;
    btnRegister: TBitBtn;
    btnNo: TBitBtn;
    group_register_manual: TGroupBox;
    lblPCName: TLabel;
    combox_SIP: TComboBox;
    Image1: TImage;
    Label4: TLabel;
    btnRegisterManual: TBitBtn;
    btnDeRegisterManual: TBitBtn;
    imgClosed: TImage;
    lblIP: TLabel;
    Label1: TLabel;
    combox_NamePC: TComboBox;
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormShow(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnRegisterManualClick(Sender: TObject);
    procedure btnDeRegisterManualClick(Sender: TObject);
    procedure imgClosedClick(Sender: TObject);
    procedure combox_SIPDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure combox_NamePCChange(Sender: TObject);
    procedure combox_NamePCDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ChangeStatus(Sender: TObject);
  private
    { Private declarations }
  m_imagelistSip  :TImageList;
  m_imagelistPC   :TImageList;
  m_phoneList     :TPhoneList;
  m_sip           :TSipPhoneList;

  procedure _INIT;
  procedure LoadIconListSip;      // прогружаем иконки
  procedure LoadIconListPC;      // прогружаем иконки
  procedure FindIPForChangeSip; // поиск ip телефона в зависимости от sip



  function CheckChoise(var _errorDescription:string):Boolean;

  public    { Public declarations }
  procedure InitComboxSip; // создание выбора спсика с sip
  procedure InitComboxPC; // создание выбора спсика с PC

  end;


var
  FormHome: TFormHome;
  isERROR:Boolean;


implementation

uses
  GlobalVariablesLinkDLL, GlobalVariables, FunctionUnit, TRegisterPhoneUnit,
  GlobalImageDestination, TIndividualSettingUserUnit, TCustomTypeUnit;

{$R *.dfm}


// создание выбора спсика с sip
procedure TFormHome.InitComboxSip;
var
 i:Integer;
begin
  if not Assigned(m_sip) then m_sip:=TSipPhoneList.Create;

  combox_SIP.Clear;

  for i:=0 to m_sip.Count-1 do begin
    if m_sip[i].m_sip <> -1 then combox_SIP.Items.Add(' '+IntToStr(m_sip.Items[i].m_sip));
  end;

  // прогружаем иконки
  LoadIconListSip;
end;


// создание выбора спсика с PC
procedure TFormHome.InitComboxPC;
var
 i:Integer;
begin
  if not Assigned(m_phoneList) then m_phoneList:=TPhoneList.Create;

  combox_NamePC.Clear;

  for i:=0 to m_phoneList.Count-1 do begin
    //if m_phoneList[i].m_sip = -1 then combox_NamePC.Items.Add(' '+m_phoneList.Items[i].m_namePC);
    combox_NamePC.Items.Add(' '+m_phoneList.Items[i].m_namePC);
  end;

  // прогружаем иконки
  LoadIconListPC;
end;

// прогружаем иконки
procedure TFormHome.LoadIconListSip;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpLocal: TPngImage;
 bmpLocal: TBitmap;
begin
  if not FileExists(ICON_GUI_SIP) then Exit;
  if not Assigned(m_imagelistSip) then m_imagelistSip:=TImageList.Create(nil);

  m_imagelistSip.SetSize(SIZE_ICON,SIZE_ICON);
  m_imagelistSip.ColorDepth:=cd32bit;

  begin
   // LOCAL
   pngbmpLocal:=TPngImage.Create;
   bmpLocal:=TBitmap.Create;

   pngbmpLocal.LoadFromFile(ICON_GUI_SIP);

    // сжимаем иконку до размера 16х16
    with bmpLocal do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpLocal);
    end;
  end;

  m_imagelistSip.Add(bmpLocal, nil);    // index = 0

  if pngbmpLocal<>nil then pngbmpLocal.Free;
  if bmpLocal<>nil then bmpLocal.Free;
end;


procedure TFormHome.LoadIconListPC;      // прогружаем иконки
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpLocal: TPngImage;
 bmpLocal: TBitmap;
begin
  if not FileExists(ICON_GUI_PC) then Exit;
  if not Assigned(m_imagelistPC) then m_imagelistPC:=TImageList.Create(nil);

  m_imagelistPC.SetSize(SIZE_ICON,SIZE_ICON);
  m_imagelistPC.ColorDepth:=cd32bit;

  begin
   // LOCAL
   pngbmpLocal:=TPngImage.Create;
   bmpLocal:=TBitmap.Create;

   pngbmpLocal.LoadFromFile(ICON_GUI_PC);

    // сжимаем иконку до размера 16х16
    with bmpLocal do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpLocal);
    end;
  end;

  m_imagelistPC.Add(bmpLocal, nil);    // index = 0

  if pngbmpLocal<>nil then pngbmpLocal.Free;
  if bmpLocal<>nil then bmpLocal.Free;
end;


procedure TFormHome.ChangeStatus(Sender: TObject);
var
 individualSettings:TIndividualSettingUser;
 errorDescription:string;
begin
 SharedCheckBoxUI.ChangeStatusCheckBox('AutoRegisterPhone');

 if SharedCheckBoxUI.Checked['AutoRegisterPhone'] then begin
  Screen.Cursor:=crHourGlass;

   individualSettings:=TIndividualSettingUser.Create(USER_STARTED_REG_PHONE_ID);

   if not individualSettings.SaveIndividualSettingUser(settingUsers_autoRegisteredSipPhone,paramStatus_ENABLED,errorDescription) then begin
    Screen.Cursor:=crDefault;

    SharedCheckBoxUI.ChangeStatusCheckBox('AutoRegisterPhone');
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);

    Exit;
   end;

   Screen.Cursor:=crDefault;
 end;
end;

// поиск ip телефона в зависимости от sip
procedure TFormHome.FindIPForChangeSip;
var
 sip:string;
begin
  if not Assigned(m_phoneList) then begin
    m_phoneList:=TPhoneList.Create;
  end;

  sip:=combox_NamePC.Items[combox_NamePC.ItemIndex];
  System.Delete(sip,1,1);   // убираем первую строку она всегада  ' '

  lblIP.Caption:=m_phoneList.IPPhoneWithNamePC[sip];
end;


// проверка выбора
function TFormHome.CheckChoise(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  if combox_SIP.ItemIndex=-1 then begin
    _errorDescription:='Не выбран SIP';
    Exit;
  end;

  if combox_NamePC.ItemIndex=-1 then begin
    _errorDescription:='Не выбрано имя ПК';
    Exit;
  end;

  Result:=True;
end;



procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin

  if DEBUG then begin
   USER_STARTED_REG_PHONE_ID:=94; // тестовый оператор2 64153
   USER_STARTED_PC_NAME:='DEV';
   USER_AUTO_REGISTERED_SIP_PHONE:=True;
   Exit;
  end;

  if ParamCount = 0 then begin
   MANUAL_STARTED:=True;
   Exit;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
       USER_STARTED_REG_PHONE_ID:= StrToInt(ParamStr(i + 1));
       //if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

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
        USER_STARTED_PC_NAME:= ParamStr(i + 1);
       // if DEBUG then ShowMessage('Value for --ACCESS: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;

    if ParamStr(i) = '--BOOLEAN' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_AUTO_REGISTERED_SIP_PHONE:=StrToBool(ParamStr(i + 1)) ;
       // if DEBUG then ShowMessage('Value for --BOOLEAN: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;


procedure TFormHome.btnDeRegisterManualClick(Sender: TObject);
var
 errorDescription:string;
 sip:string;
 userID:Integer;
 userPC:string;
begin
  if not CheckChoise(errorDescription) then begin
   MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  Screen.Cursor:=crHourGlass;

  sip:=combox_SIP.Items[combox_SIP.ItemIndex];
  System.Delete(sip,1,1);   // убираем первую строку она всегада  ' '
  userID:=GetUserID(StrToInt(sip));

  userPC:=combox_NamePC.Items[combox_NamePC.ItemIndex];
  System.Delete(userPC,1,1);   // убираем первую строку она всегада  ' '


  if not DeRegisterPhoneManual(userID, userPC, errorDescription) then begin
    Screen.Cursor:=crDefault;
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка при разрегистрации'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  MessageBox(Handle,PChar('Успешная разрегистрация'),PChar(''),MB_OK+MB_ICONINFORMATION);
  Screen.Cursor:=crDefault;
end;

procedure TFormHome.btnNoClick(Sender: TObject);
begin
 KillProcessNow;
end;

procedure TFormHome.btnRegisterClick(Sender: TObject);
var
 errorDescription:string;
begin
  Screen.Cursor:=crHourGlass;

  if not RegisterPhoneAuto(errorDescription) then begin
    Screen.Cursor:=crDefault;
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка при регистрации'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  MessageBox(Handle,PChar('Успешная регистрация'),PChar(''),MB_OK+MB_ICONINFORMATION);
  Screen.Cursor:=crDefault;



  KillProcessNow;
end;

procedure TFormHome.btnRegisterManualClick(Sender: TObject);
var
 errorDescription:string;
 sip:string;
 userID:Integer;
 userPC:string;
begin

  if not CheckChoise(errorDescription) then begin
   MessageBox(Handle,PChar(errorDescription),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  Screen.Cursor:=crHourGlass;

  sip:=combox_SIP.Items[combox_SIP.ItemIndex];
  System.Delete(sip,1,1);   // убираем первую строку она всегада  ' '
  userID:=GetUserID(StrToInt(sip));

  userPC:=combox_NamePC.Items[combox_NamePC.ItemIndex];
  System.Delete(userPC,1,1);   // убираем первую строку она всегада  ' '


  if not RegisterPhoneManual(userID, userPC, errorDescription) then begin
    Screen.Cursor:=crDefault;
    MessageBox(Handle,PChar(errorDescription),PChar('Ошибка при регистрации'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  MessageBox(Handle,PChar('Успешная регистрация'),PChar(''),MB_OK+MB_ICONINFORMATION);
  Screen.Cursor:=crDefault;
end;



procedure TFormHome.combox_NamePCChange(Sender: TObject);
begin
  FindIPForChangeSip;
end;

procedure TFormHome.combox_NamePCDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if m_imagelistPC.Count = 0 then  Exit;

  IconIndex:=0;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    m_imagelistPC.GetBitmap(IconIndex, Bitmap);
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

procedure TFormHome.combox_SIPDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if m_imagelistSip.Count = 0 then  Exit;

  IconIndex:=0;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    m_imagelistSip.GetBitmap(IconIndex, Bitmap);
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

procedure TFormHome.FormCreate(Sender: TObject);
begin
  // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(REG_PHONE_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии регистрации телефона'+#13#13+
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;


procedure TFormHome._INIT;
var
 individualSettings:TIndividualSettingUser;
 errorDescription:string;
begin
 isERROR:=False;

 // размер формы
 CreateDefaultFormSize;

 case MANUAL_STARTED of
   True:begin       // вручную запустили
    InitManual;
   end;
   False:begin      // атоматически запустили из дашборда
    InitAuto;
    individualSettings:=TIndividualSettingUser.Create(USER_STARTED_REG_PHONE_ID);

    // проверим нужно ли автоматически регистрироваться
    if individualSettings.AutoRegisterSipPhone then begin
      case USER_AUTO_REGISTERED_SIP_PHONE of
       True:begin                                // автоматически входим
         RegisterPhoneAuto(errorDescription);
       end;
       False:begin                               // автоматически выходим
         DeRegisterPhoneAuto(errorDescription);
       end;
      end;
      KillProcessNow;
    end;
   end;
 end;

end;


procedure TFormHome.FormShow(Sender: TObject);
begin
  // подгузим все данные
  _INIT;
end;



procedure TFormHome.imgClosedClick(Sender: TObject);
begin
 KillProcessNow;
end;

end.
