unit FormGenerateSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, TCheckServersUnit, TCustomTypeUnit;

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
  private
    { Private declarations }
  list_clinic    :TCheckServersIK;  // ������ � ���������
  serviceChoiseList:TStringList;    // ��������� ������

  phonePodbor:string;               // ����� ��� ��� ������� �����
  phonePodborError:string;
  isAutoPodbor:Boolean;             // ���� ���� ��� ������ ��������� �� �����������
  procedure AutoPodbor;             // ���������� �����\���������\����



  procedure Clear;
  procedure CreateReasonBox;
  procedure CreateGenderBox;
  procedure CreateListAddressClinic; // �������� ������ � �������� ������
  procedure CurrentDateTime;         // ������� �����\���� �� �����


  procedure ShowGroupParams(_status:enumParamStatus);     // ����������� ������ ����������
  procedure ShowParams(_params:enumReasonSmsMessage);     // ����� ������ ����������� � ����������� �� ���������� ���� ���������
  procedure DisableAllParams;                             // ���������� ���� ����������
  procedure EnableParamsFIO;                              // ��������� ���������� ���
  procedure EnableParamsDate;                             // ��������� ���������� ����
  procedure EnableParamsTime;                             // ��������� ���������� �����
  procedure EnableParamsAddressClinic;                    // ��������� ���������� ����� �������
  procedure EnableParamsServiceList;                      // ��������� ���������� ������
  procedure EnableParamsReason;                           // ��������� ���������� �������
  procedure EnableParamsSumma;                            // ��������� ���������� �����


  procedure CreateMessage;    // ������� ���������

  public
    { Public declarations }
  procedure SetServiceChoise(_service:string);   // ���������� � ������ ���������� �����
  procedure DelServiceChoise(_service:string);   // ��������
  function GetServiceChoise(_id:Integer):string;
  function  GetCountServiceChoise:Integer;

  procedure SetPhonePodbor(_phone:string; const _error:string);  // ��������� ������ ���. ��� �������

  procedure SetAutoPodborValue(_name,_mid:string; _gender:enumGender); // ��������� ���������� ����������

  end;

var
  FormGenerateSMS: TFormGenerateSMS;

implementation

uses
  FunctionUnit, FormHomeUnit, GlobalVariables, TMessageGeneratorSMSUnit, FormServiceChoiseUnit, DMUnit, TAutoPodborPeopleUnit, FormPodborUnit;


{$R *.dfm}

// ���������� ���� ����������
procedure TFormGenerateSMS.DisableAllParams;
begin
  // ���
  lblName.Enabled:=False;
  reName.Enabled:=False;
  reName.Clear;

  // ��������
  lblOtchestvo.Enabled:=False;
  reOtchestvo.Enabled:=False;
  reOtchestvo.Clear;

  // ���
  lblPol.Enabled:=False;
  combox_Pol.Enabled:=False;
  combox_Pol.ItemIndex:=-1;

  // ����
  lblDate.Enabled:=False;
  dateShow.Enabled:=False;

  // �����
  lblTime.Enabled:=False;
  timeShow.Enabled:=False;

  // �������
  lblClinic.Enabled:=False;
  combox_AddressClinic.Enabled:=False;
  combox_AddressClinic.ItemIndex:=-1;

  // ������
  lblService.Enabled:=False;
  btnServiceList.Enabled:=False;
  lblServiceCount.Enabled:=False;
  lblServiceCount.Caption:='������� ����� : 0';

  // �����
  lblSumma.Enabled:=False;
  edtSumma.Enabled:=False;
  edtSumma.Text:='';
  st_rub.Enabled:=False;

  // �������
  lblReason.Enabled:=False;
  reReason.Enabled:=False;
  reReason.Clear;
end;


procedure TFormGenerateSMS.edtSummaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then  // #8 - Backspace, #13 - Enter
  begin
    Key := #0; // �������� ����, ���� ������ �� �������� ������
  end;
end;

// ��������� ���������� ��� + ���
procedure TFormGenerateSMS.EnableParamsFIO;
begin
   // ���
  lblName.Enabled:=True;
  reName.Enabled:=True;
  // ��������
  lblOtchestvo.Enabled:=True;
  reOtchestvo.Enabled:=True;
  // ���
  lblPol.Enabled:=True;
  combox_Pol.Enabled:=True;
end;


// ��������� ���������� ����
procedure TFormGenerateSMS.EnableParamsDate;
begin
 // ����
  lblDate.Enabled:=True;
  dateShow.Enabled:=True;
end;

// ��������� ���������� �����
procedure TFormGenerateSMS.EnableParamsTime;
begin
 // �����
  lblTime.Enabled:=True;
  timeShow.Enabled:=True;
end;

// ��������� ���������� ����� �������
procedure TFormGenerateSMS.EnableParamsAddressClinic;
begin
  // �������
  lblClinic.Enabled:=True;
  combox_AddressClinic.Enabled:=True;
  combox_AddressClinic.ItemIndex:=-1;
end;


// ��������� ���������� ������
procedure TFormGenerateSMS.EnableParamsServiceList;
begin
  // ������
  lblService.Enabled:=True;
  btnServiceList.Enabled:=True;
  lblServiceCount.Enabled:=True;
  lblServiceCount.Caption:='������� ����� : 0';
end;


// ��������� ���������� �������
procedure TFormGenerateSMS.EnableParamsReason;
begin
  // �������
  lblReason.Enabled:=True;
  reReason.Enabled:=True;
  reReason.Clear;
end;


// ��������� ���������� �����
procedure TFormGenerateSMS.EnableParamsSumma;
begin
  // �����
  lblSumma.Enabled:=True;
  edtSumma.Enabled:=True;
  edtSumma.Text:='';
  st_rub.Enabled:=False;
end;

// ���������� � ������ ���������� �����
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

// ��������
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
  // ���������, ��� �� ���� ������ ������� ����
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
  // ���������, ��� �� ���� ������ ������� ����
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
 // ���������, ��� �� ���� ������ ������� ����
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

// ��������� ������ ���. ��� �������
procedure TFormGenerateSMS.SetPhonePodbor(_phone:string; const _error:string);
begin
  phonePodbor:=_phone;
  phonePodborError:=_error;
end;

// ��������� ���������� ����������
procedure TFormGenerateSMS.SetAutoPodborValue(_name,_mid:string; _gender:enumGender);
begin
  reName.Clear;
  reName.Text:=_name;

  reOtchestvo.Clear;
  reOtchestvo.Text:=_mid;

  combox_Pol.ItemIndex:=EnumGenderToInteger(_gender);

  isAutoPodbor:=True;
end;

// ������� ���������
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

   MessageBox(Handle,PChar('�� ������ "��� ���������"'),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  params:=StringToEnumReasonSmsMessage(comboxReasonSmsMessage.Items[comboxReasonSmsMessage.ItemIndex]);
  gender:=StringToEnumGender(combox_Pol.Items[combox_Pol.ItemIndex]);
  prichina:=reReason.Text;
  money:=edtSumma.Text;

  // ������� ��������� (��� �� ������ ������)
  SharedGenerateMessage.ClearMessage;

  // �������� ���������� ����� ��������� ���������
  if not SharedGenerateMessage.CheckParams(params, serviceChoiseList, isAutoPodbor, error) then begin
   Screen.Cursor:=crDefault;
   MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  SharedGenerateMessage.CreateMessage(params, gender, reName.Text, reOtchestvo.Text, serviceChoiseList, money, prichina);

  Screen.Cursor:=crDefault;
end;


// ����� ������ ����������� � ����������� �� ���������� ���� ���������
procedure TFormGenerateSMS.ShowParams(_params:enumReasonSmsMessage);
begin
  // ��������� ��� ���������
  DisableAllParams;

  case _params of
   reason_OtmenaPriema: begin                       // ������ ������ �����, �������
     // + ��� + ���
     EnableParamsFIO;
   end;
   reason_NapominanieOPrieme:begin                  // ����������� � ������
    // + ��� + ���
    EnableParamsFIO;

    // ����
    EnableParamsDate;

    // �����
    EnableParamsTime;

    // ����� ������
    EnableParamsAddressClinic;

   end;
   reason_NapominanieOPrieme_do15:begin             // ����������� � ������ (�� 15 ���)
     // + ��� + ���
     EnableParamsFIO;

     // ����
    EnableParamsDate;

     // �����
    EnableParamsTime;

     // ����� ������
    EnableParamsAddressClinic;
   end;
   reason_NapominanieOPrieme_OMS:begin              // ����������� � ������ (���)
     // + ��� + ���
     EnableParamsFIO;

     // ����
    EnableParamsDate;

     // �����
    EnableParamsTime;

     // ����� ������
    EnableParamsAddressClinic;
   end;
   reason_IstekaetSrokGotovnostiBIOMateriala:begin  // �������� ���� �������� ������������
     // + ��� + ���
     EnableParamsFIO;

     // ����
    EnableParamsDate;

     // �����
    EnableParamsTime;
   end;
   reason_AnalizNaPereustanovke:begin               // ������ �� �������������
     // + ��� + ���
     EnableParamsFIO;
   end;
   reason_UvelichilsyaSrokIssledovaniya:begin       // ���������� ���� ���������� ������������ ������������ �� ���. ��������
    // + ��� + ���
     EnableParamsFIO;

     // ����
    EnableParamsDate;
   end;
   reason_Perezabor:begin                           // ��������� ��������� ����� (�����, �������, ������������ ������������)
     // + ��� + ���
     EnableParamsFIO;

     // ����� ������
    EnableParamsAddressClinic;

    // ������
    EnableParamsServiceList;

    // �������
    EnableParamsReason;
   end;
   reason_Critical:begin                            // �������� ������ �� ����������� � ����������� ���������
     // + ��� + ���
     EnableParamsFIO;
   end;
   reason_ReadyDiagnostic:begin                     // ����� ��������� ����������� (��������,  �������, �����)
     // + ��� + ���
     EnableParamsFIO;

     // ����� ������
     EnableParamsAddressClinic;
   end;
   reason_ReadyNalog:begin                          // ������ ������� � ���������
    // + ��� + ���
     EnableParamsFIO;

    // ����� ������
    EnableParamsAddressClinic;
   end;
   reason_ReadyDocuments:begin                      // ������ ����� ���. ������������, �������, �������
     // + ��� + ���
     EnableParamsFIO;

     // ����� ������
     EnableParamsAddressClinic;
   end;
   reason_NeedDocumentsLVN:begin                    // ���������� ������������ ������ ��� �������� ��� (�����)
    // + ��� + ���
     EnableParamsFIO;

    // ����� ������
    EnableParamsAddressClinic;
   end;
   reason_NeedDocumentsDMS:begin                    // ���������������� � ������������ ����� �� ��� (����� �������)
     // + ��� + ���
     EnableParamsFIO;
   end;
   reason_VneplanoviiPriem:begin                    // ���������� ����������� ����� (���������� �����)
     // + ��� + ���
     EnableParamsFIO;

     // �����
    EnableParamsTime;

     // ����� ������
    EnableParamsAddressClinic;
   end;
   reason_ReturnMoney:begin                         // ���������� �� ��������� ��
     // + ��� + ���
     EnableParamsFIO;

     // ����� ������
    EnableParamsAddressClinic;

     // ������
    EnableParamsServiceList;

    // �����
    EnableParamsSumma;
   end;
   reason_ReturnMoneyInfo:begin                     // ���������������� �� ������������� �������� ��
     // + ��� + ���
     EnableParamsFIO;

     // ����
    EnableParamsDate;

     // ������
    EnableParamsServiceList;

     // �����
    EnableParamsSumma;
   end;
   reason_ReturnDiagnostic:begin                    // ���������� �� ��������������� (��������������) ����������
     // + ��� + ���
     EnableParamsFIO;

     // ����� ������
     EnableParamsAddressClinic;
   end;
  end;
end;


// ����������� ������ ����������
procedure TFormGenerateSMS.ShowGroupParams(_status:enumParamStatus);
begin
  // ����� ��������� ����� ����������
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


procedure TFormGenerateSMS.CreateReasonBox;
var
 i:Integer;
 reason:enumReasonSmsMessage;
begin
  for i:=Ord(Low(enumReasonSmsMessage)) to Ord(High(enumReasonSmsMessage)) do
  begin
    reason:=enumReasonSmsMessage(i);
    if reason = reason_Empty then Continue; // ���������� ������ -1 
    
    comboxReasonSmsMessage.Items.Add(EnumReasonSmsMessageToString(reason));
  end;
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
end;


procedure TFormGenerateSMS.btnGenerateMessageClick(Sender: TObject);
begin
  CreateMessage;
  if SharedGenerateMessage.GeneretedMessage = '' then Exit;

  Screen.Cursor:=crHourGlass;
  AddMessageFromTemplate(SharedGenerateMessage.GeneretedMessage);

  // ��������� ���� ��� ��������� ������ ���������������
  FormHome.SetEditMessage(paramStatus_DISABLED,'��������� �� ���������� �� �������������!');
  FormHome.SetReasonSMSType( IntegerToEnumReasonSmsMessage(comboxReasonSmsMessage.ItemIndex));

  Screen.Cursor:=crDefault;
  Close;
end;

procedure TFormGenerateSMS.btnGenerateMessageShowClick(Sender: TObject);
begin
  CreateMessage;
  if SharedGenerateMessage.GeneretedMessage = '' then Exit;

  MessageBox(Handle,PChar(SharedGenerateMessage.GeneretedMessage),PChar('����'),MB_OK+MB_ICONINFORMATION);
end;


procedure TFormGenerateSMS.btnPrimerClick(Sender: TObject);
begin
  MessageBox(Handle,PChar(SharedGenerateMessage.GetExampleMessage(IntegerToEnumReasonSmsMessage(comboxReasonSmsMessage.ItemIndex))),
                    PChar('����'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormGenerateSMS.btnServiceListClick(Sender: TObject);
begin
  FormServiceChoise.ShowModal;
end;

procedure TFormGenerateSMS.Clear;
begin
  comboxReasonSmsMessage.Clear;
  combox_Pol.Clear;

  // ��������� ���������
  ShowGroupParams(paramStatus_DISABLED);

  // �������� ���������
  btnGenerateMessageShow.Enabled:=true;

  // ��������� ������
  if not Assigned(serviceChoiseList) then serviceChoiseList:=TStringList.Create
  else serviceChoiseList.Clear;
end;

// �������� ������ � �������� ������
procedure TFormGenerateSMS.comboxReasonSmsMessageChange(Sender: TObject);
var
 params:enumReasonSmsMessage;
begin
  //����������� ���������
  ShowGroupParams(paramStatus_ENABLED);

  // ���������� ������ ���������
 params:=StringToEnumReasonSmsMessage(comboxReasonSmsMessage.Items[comboxReasonSmsMessage.ItemIndex]);
 ShowParams(params);
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
end;


// ������� �����\���� �� �����
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

  FormHome.ShowManualMessage;
end;

procedure TFormGenerateSMS.FormShow(Sender: TObject);
begin
  if not Assigned(SharedGenerateMessage) then begin
   SharedGenerateMessage:=TMessageGeneratorSMS.Create(Self);
  end
  else SharedGenerateMessage.Clear;

  Clear;

  // �������� ����� ��������� ���������
  CreateReasonBox;
  CreateGenderBox;

  // ������ � �������� ������
  CreateListAddressClinic;

  // ������� �����\���� �� �����
  CurrentDateTime;

  // ������� ����������
  if phonePodbor<>'' then begin
   lblAutoPodbor.Enabled:=True;
   lblAutoPodbor.Caption:='���������� �����';
   lblAutoPodbor.ShowHint:=True;

   // �������
   lblAutoPodborError.Visible:=False;
  end
  else begin
   lblAutoPodbor.Enabled:=False;
   lblAutoPodbor.Caption:='���������� ����� (����������)';
   lblAutoPodbor.ShowHint:=False;

   // �������
   lblAutoPodborError.Visible:=True;
   lblAutoPodborError.Caption:='�������: '+phonePodborError;
  end;
end;

// ���������� �����\���������\����
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
    MessageBox(Handle,PChar('�� ������� ��������� � ����� �������'),PChar('������'),MB_OK+MB_ICONERROR);
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

   FormPodbor.SetListPacients(people);
   FormPodbor.ShowModal;
  end;
end;

end.
