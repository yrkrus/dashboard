unit FunctionUnit;

interface
  uses
    Windows, Messages,Data.Win.ADODB, Data.DB, System.SysUtils, System.Variants;


    function GetComputerPCName: string;                               // ������� ��������� ����� ��
    function GetUserID(InSIPNumber:integer):Integer;                  // ��������� userID �� SIP ������
    procedure AddCustomCheckBoxUI;                                    // ��������� ����� �������� ���������
    procedure CreateDefaultFormSize;                                  // ������ �� ��������� ���� �����
    procedure InitAuto;                                               // ��������� ������������� �� ��������
    procedure InitManual;                                             // ��������� �������
    function RegisterPhoneAuto(var _errorDescription:string):Boolean;   // ����������� � ��������
    function DeRegisterPhoneAuto(var _errorDescription:string):Boolean; // �������������� � ��������
    function RegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean;   // ����������� � ��������
    function DeRegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean; // �������������� � ��������

    procedure AddFreeSipListRegister;                                 // ��������� sip ������� (��� ��� �� ������� �� ����������)


implementation

uses
  FormHomeUnit, GlobalVariables, TCustomTypeUnit,
  TRegisterPhoneUnit, GlobalVariablesLinkDLL,
  TPhoneListUnit, TSipPhoneListUnit;


// ������� ��������� ����� ��
function GetComputerPCName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then Result := buffer
  else Result := 'null';
end;


// ��������� userID �� SIP ������
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

// ��������� ����� �������� ���������
procedure AddCustomCheckBoxUI;
begin
  with FormHome do begin
   // �� ���������� ��������� � ��� ��� ����� ������������������ � �������� �������
    SharedCheckBoxUI.Add('AutoRegisterPhone', lbl_operators_AutoRegisterPhone, img_operators_AutoRegisterPhone, paramStatus_DISABLED);
  end;
end;


// ��������� sip ������� (��� ��� �� ������� �� ����������)
procedure AddFreeSipListRegister;
begin
  with FormHome do begin
    InitComboxSip;
    InitComboxPC;
  end;
end;


// ������ �� ��������� ���� �����
procedure CreateDefaultFormSize;
begin
  if DEBUG then Exit;

  with FormHome do begin
    Width:=WIDTH_DEFAULT;
    Height:=HEIGHT_DEFAULT;
  end;

  // ����� ��� �����������
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


// ��������� ������������� �� ��������
procedure InitAuto;
begin
  // ���������� ��� �����
    AddCustomCheckBoxUI;


end;


// ��������� �������
procedure InitManual;
begin
  // ���������� ��������� �� ����������� sip ������
  AddFreeSipListRegister;


end;


// ����������� � ��������
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

  regPhone:=TRegisterPhone.Create(sipUser,phoneIP, PHONE_AUTH_USER, PHONE_AUTH_PWD);

  if not Assigned(regPhone) then begin
    _errorDescription:='������ ��� ������������� �������';
    Exit;
  end;

  Result:=regPhone.RegisterPhone(_errorDescription);
end;


function DeRegisterPhoneAuto(var _errorDescription:string):Boolean;   // �������������� � ��������
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
    _errorDescription:='������ ��� ������������� �������';
    Exit;
  end;

  Result:=regPhone.DeRegisterPhone(_errorDescription);
end;


// ����������� � ��������
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
    _errorDescription:='������ ��� ������������� �������';
    Exit;
  end;

  Result:=regPhone.RegisterPhone(_errorDescription);
end;


function DeRegisterPhoneManual(_userID:Integer; _namePC:string; var _errorDescription:string):Boolean;   // �������������� � ��������
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
    _errorDescription:='������ ��� ������������� �������';
    Exit;
  end;

  Result:=regPhone.DeRegisterPhone(_errorDescription);
end;


end.
