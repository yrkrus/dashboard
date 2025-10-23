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
  m_idStruct:Integer;    // id � ��������� m_smsInfo

  procedure ShowStatus;
  procedure Clear;

  procedure ClearForm;
  procedure FillData; // ���������� ������� �� �����
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
  // ������� �����
  ClearForm;

  // ��������� �������
  FillData;

  // ����� �� ������
  btnSaveFirebirdSettings.SetFocus;
end;

procedure TFormStatusSendingSMS.btnSaveFirebirdSettingsClick(Sender: TObject);
var
 error:string;
 path:string;
begin

  SavePicture.DefaultExt := '.jpg';   // ���������� ������ �� ���������
  SavePicture.Filter     := 'JPEG (*.jpg)|*.jpg'; // ������ ����� ������
  SavePicture.Title      := '�������� ��� ����� � ����� ��� ����������';

  if SavePicture.Execute then
  begin
    path := SavePicture.FileName;

    if not SaveResultSendingSMS(Self.panelInfo,path,error) then
     begin
      MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
      Exit;
     end;

     MessageBox(Handle,PChar('��������� � '+path),PChar('�����'),MB_OK+MB_ICONINFORMATION);

  end;
end;



procedure TFormStatusSendingSMS.Clear;
begin
  if Assigned(m_smsInfo) then FreeAndNil(m_smsInfo);
  m_idStruct:=-1;
end;


// ������� ������ �� �����
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


// ����������� �������� �� ��������
procedure TFormStatusSendingSMS.CreateStatusImage(_code:enumStatusCodeSms);
begin
 with imgStatus.Picture do begin

   case _code of
      eStatusCodeSmsQueued:       LoadFromFile(ICON_SMS_STATUS_QUEUE);            // ��������� ��������� � ������� �������� � ��� �� ���� �������� ���������
      eStatusCodeSmsAccepted:     LoadFromFile(ICON_SMS_STATUS_SENDING_OPERATOR); // ��������� ��� �������� ���������
      eStatusCodeSmsDelivered:    LoadFromFile(ICON_SMS_STATUS_DELIVERED);        // ��������� ������� ���������� ��������
      eStatusCodeSmsRejected:     LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);    // ��������� ��������� ����������
      eStatusCodeSmsUndeliverable:LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);     // ��������� ���������� ��������� ��-�� ������������� ��������
      eStatusCodeSmsError:        LoadFromFile(ICON_SMS_STATUS_ERROR);    // ������ ��������. ��������� �� ���� ���������� ��������
      eStatusCodeSmsExpired:      LoadFromFile(ICON_SMS_STATUS_NOT_DELIVERED);     // ������� ����� �������� ���������� �������
      eStatusCodeSmsUnknown:      LoadFromFile(ICON_SMS_STATUS_ERROR);     // ������ ��������� ����������
      eStatusCodeSmsAborted:      LoadFromFile(ICON_SMS_STATUS_ABORT);     // ��������� �������� �������������
      eStatusCodeSms20107,        	    // �������� ����� ��� ������
      eStatusCodeSms20117,        	    // ������������ ����� ��������
      eStatusCodeSms20148,        	    // ���������� ������������ ������ ��� ��������
      eStatusCodeSms20154,        	    // ������ ����������
      eStatusCodeSms20158,        	    // �������� ����������, ��� ��� ����� ������ � ������ ������
      eStatusCodeSms20167,        	    // ��������� �������� ��������� � ��� �� ������� ���� �� �������� � ������� ���������� �����
      eStatusCodeSms20170,        	    // ������� ������� ���������
      eStatusCodeSms20171,        	    // ��������� �� ������ �������� �������
      eStatusCodeSms20200,        	    // ������������ ������
      eStatusCodeSms20202,        	    // �� ������ �������� ���� ��� �������� ���������
      eStatusCodeSms20203,        	    // ��� ������ �������� ��� �������������� ������ � �������
      eStatusCodeSms20204,        	    // �� ������� �������� ��� ������
      eStatusCodeSms20207, 	    // ������������ ������ ����
      eStatusCodeSms20208, 	    // ���� ������ ����� ���� �����
      eStatusCodeSms20209, 	    // ��������� ������� ������
      eStatusCodeSms20211, 	    // ��������� ���������� ��������� ��� ������������
      eStatusCodeSms20212, 	    // �������� �������� � ��������� �����
      eStatusCodeSms20213, 	    // ���������� ������ � ������
      eStatusCodeSms20218, 	    // ��������� ���������� �� ��������� �������
      eStatusCodeSms20230, 	    // ����������� �� ������� �� ������� ���������
      eStatusCodeSms20280, 	    // ��������� �������� ����� �� �������� SMS � ��������� A2P
      eStatusCodeSms20281: LoadFromFile(ICON_SMS_STATUS_ERROR);	     // ��������� �������� ����� �� �������� SMS � ��������� A2P
    else
      LoadFromFile(ICON_SMS_STATUS_ERROR);
   end;
 end;
end;


// ���������� ������� �� �����
procedure TFormStatusSendingSMS.FillData;
begin
  // id ���������
  lblID.Caption:=m_smsInfo.SmsID[m_idStruct];

  // ���� ��������
  lblDateSend.Caption:=m_smsInfo.SendingDate[m_idStruct];

  // �������
  lblPhone.Caption:=m_smsInfo.Phone;

  // ���������
  re_Message.Lines.Add(m_smsInfo.MessageSMS[m_idStruct]);

  // ��������
  lblOperator.Caption:='� ����������';

  // ������
  lblRegion.Caption:='� ����������';

  // �����������
  lblFIO.Caption:=m_smsInfo.UserFIOSending[m_idStruct];

  // ������
  if DirectoryExists(FOLDER_ICON_SMS) then CreateStatusImage(m_smsInfo.CodeStatusEnum[m_idStruct]);

  // ��� �������
  lblCode.Caption:=m_smsInfo.CodeStatusString[m_idStruct] +#13+ m_smsInfo.StatusDecrypt[m_idStruct];
  // ����� �������
  lblTimeStatus.Caption:=m_smsInfo.TimeStatus[m_idStruct];

end;

end.
