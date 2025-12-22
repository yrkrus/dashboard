unit FunctionUnit;

interface
  uses
    Windows, Messages,Data.Win.ADODB, Data.DB, System.SysUtils,
    System.Variants, Vcl.StdCtrls, Vcl.Graphics, TCustomTypeUnit,
    Vcl.Forms, System.Classes, Controls;

    function GetComputerPCName: string;                               // функция получения имени ПК
    function GetUserID(InSIPNumber:integer):Integer;                  // полчуение userID из SIP номера
    procedure AddCustomCheckBoxUI;                                    // подгрузка своих красивых чекбоксов
    procedure CreateDefaultFormSize;                                  // размер по умолчанию окна формы
    procedure InitAuto;                                               // запустили автоматически из дашборда
    procedure InitManual;                                             // запустили вручную
    function RegisterPhoneAuto(var _errorDescription:string):Boolean;   // регистрация в телефоне
    function DeRegisterPhoneAuto(var _errorDescription:string):Boolean; // разрегистрация в телефоне
    function RegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean;   // регистрация в телефоне
    function DeRegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean; // разрегистрация в телефоне
    procedure AddFreeSipListRegister;                                 // подгрузка sip номеров (при чем те которые не залогинены)
    procedure SetRandomFontColor(var p_label: TLabel);                // изменение цвета надписи
    procedure ShowWait(Status:enumShow_wait; _sipType:enumTypeSipRegPhone); overload;               // отображение\сркытие окна запроса на сервер
    procedure ShowWait(Status:enumShow_wait); overload;               // отображение\сркытие окна запроса на сервер


implementation

uses
  FormHomeUnit, GlobalVariables,
  TRegisterPhoneUnit, GlobalVariablesLinkDLL,
  TPhoneListUnit, TSipPhoneListUnit, FormWaitUnit;


// функция получения имени ПК
function GetComputerPCName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then Result := buffer
  else Result := 'null';
end;


// полчуение userID из SIP номера
function GetUserID(InSIPNumber:integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select user_id from operators where sip = '+#39+IntToStr(InSIPNumber)+#39);
      Active:=True;

      if Fields[0].Value<>null then begin
        if Fields[0].Value <> 0 then Result:=Fields[0].Value
        else Result:=-1;
      end
      else Result:= -1;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// подгрузка своих красивых чекбоксов
procedure AddCustomCheckBoxUI;
begin
  with FormHome do begin
   // не показывать сообщение о том что нужно зарегистрироваться в телефоне сначало
    SharedCheckBoxUI.Add('AutoRegisterPhone', lbl_operators_AutoRegisterPhone, img_operators_AutoRegisterPhone, paramStatus_DISABLED);
  end;
end;


// подгрузка sip номеров (при чем те которые не залогинены)
procedure AddFreeSipListRegister;
begin
  with FormHome do begin
    InitComboxSip;
    InitComboxPC;
  end;
end;


// размер по умолчанию окна формы
procedure CreateDefaultFormSize;
begin
  if DEBUG then Exit;

  with FormHome do begin
    Width:=WIDTH_DEFAULT;
    Height:=HEIGHT_DEFAULT;
  end;

  // какой вид оттображать
  with FormHome do begin
    case MANUAL_STARTED of
     False:begin
       group_register_auto.Top:=0;
       group_register_manual.Visible:=False;
     end;
     True:begin
       group_register_manual.Top:=0;
       group_register_auto.Visible:=False;
     end;
    end;
  end;

end;


// запустили автоматически из дашборда
procedure InitAuto;
begin
  // подгружаем чек боксы
    AddCustomCheckBoxUI;


end;


// запустили вручную
procedure InitManual;
begin
  // подгрудаем свободные не залогиненые sip номера
  AddFreeSipListRegister;
end;


// регистрация в телефоне
function RegisterPhoneAuto(var _errorDescription:string):Boolean;
var
 regPhone:TRegisterPhone;
 phoneList:TPhoneList;
 sipUser:Integer;
 phoneIP:string;
begin
  Result:=False;

  phoneList:=TPhoneList.Create;
  phoneIP:=phoneList.IPPhoneWithNamePC[USER_STARTED_PC_NAME];
  sipUser:=_dll_GetOperatorSIP(USER_STARTED_REG_PHONE_ID);

  if (phoneIP='') or (sipUser=-1)  then begin
    _errorDescription:='Ошибка входных параметров';
    Exit;
  end;

  regPhone:=TRegisterPhone.Create(sipUser,phoneIP, PHONE_AUTH_USER, PHONE_AUTH_PWD);

  if not Assigned(regPhone) then begin
    _errorDescription:='Ошибка при инициализации запроса';
    Exit;
  end;

  Result:=regPhone.RegisterPhone(_errorDescription);
end;


function DeRegisterPhoneAuto(var _errorDescription:string):Boolean;   // разрегистрация в телефоне
var
 regPhone:TRegisterPhone;
 phoneList:TPhoneList;
 sipUser:Integer;
 phoneIP:string;
begin
  Result:=False;

  phoneList:=TPhoneList.Create;
  phoneIP:=phoneList.IPPhoneWithNamePC[USER_STARTED_PC_NAME];
  sipUser:=_dll_GetOperatorSIP(USER_STARTED_REG_PHONE_ID);

  regPhone:=TRegisterPhone.Create(sipUser,phoneIP, PHONE_AUTH_USER, PHONE_AUTH_PWD);

  if not Assigned(regPhone) then begin
    _errorDescription:='Ошибка при инициализации запроса';
    Exit;
  end;

  Result:=regPhone.DeRegisterPhone(_errorDescription);
end;


// регистрация в телефоне
function RegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean;
var
 regPhone:TRegisterPhone;
 phoneList:TPhoneList;
 sipUser:Integer;
 phoneIP:string;
begin
  Result:=False;

  phoneList:=TPhoneList.Create;
  phoneIP:=phoneList.IPPhoneWithNamePC[_namePC];
  sipUser:=_dll_GetOperatorSIP(_userID);

  regPhone:=TRegisterPhone.Create(sipUser ,phoneIP, PHONE_AUTH_USER, PHONE_AUTH_PWD);

  if not Assigned(regPhone) then begin
    _errorDescription:='Ошибка при инициализации запроса';
    Exit;
  end;

  Result:=regPhone.RegisterPhone(_errorDescription);
end;


function DeRegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean;   // разрегистрация в телефоне
var
 regPhone:TRegisterPhone;
 phoneList:TPhoneList;
 sipUser:Integer;
 phoneIP:string;
begin
  Result:=False;

  phoneList:=TPhoneList.Create;
  phoneIP:=phoneList.IPPhoneWithNamePC[_namePC];
  sipUser:=_dll_GetOperatorSIP(_userID);

  regPhone:=TRegisterPhone.Create(sipUser,phoneIP, PHONE_AUTH_USER, PHONE_AUTH_PWD);

  if not Assigned(regPhone) then begin
    _errorDescription:='Ошибка при инициализации запроса';
    Exit;
  end;

  Result:=regPhone.DeRegisterPhone(_errorDescription);
end;


// отображение\сркытие окна запроса на сервер
procedure ShowWait(Status:enumShow_wait);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// отображение\сркытие окна запроса на сервер
procedure ShowWait(Status:enumShow_wait; _sipType:enumTypeSipRegPhone);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.SetInfo(_sipType);
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// изменение цвета надписи
procedure SetRandomFontColor(var p_label: TLabel);
var
  RandomColor: TColor;
begin
  // Генерируем случайные значения для RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // Устанавливаем случайный цвет шрифта для метки
  p_label.Font.Color := RandomColor;
end;

end.
