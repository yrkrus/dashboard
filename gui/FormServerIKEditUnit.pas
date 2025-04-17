unit FormServerIKEditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus, TCustomTypeUnit;

type                                    // ��� �������
   TypeResponse_Server = (server_add,
                          server_delete,
                          server_edit
                          );

type
  TFormServerIKEdit = class(TForm)
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    chkboxCloseWindow: TCheckBox;
    GroupBox1: TGroupBox;
    btnWorkingTime: TButton;
    combox_ShowSMS: TComboBox;
    combox_Status: TComboBox;
    combox_TypeClinic: TComboBox;
    edtAddress: TEdit;
    edtAlias: TEdit;
    edtIP: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblWorkingTimeLabel: TLabel;
    lblStatusWorkingTime: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    function getResponseBD(InTypePanel_Server:TypeResponse_Server;
                           _id:Integer;
                           InIP,
                           InAddr,
                           InAlias:string;
                           InTypeCLinic:enumTypeClinic;
                           InShowSMS:enumParamStatus;
                           InStatus:enumStatusJobClinic;
                           var _errorDescription:string):Boolean;
    procedure btnWorkingTimeClick(Sender: TObject);
    function DeleteWorkingTime(_id:Integer; var _errorDescription:string):Boolean;  // �������� ������� �� ������� ����� ������

  private
    { Private declarations }
  function getCheckFileds(var _errorDescription:string):Boolean;
  procedure AddBoxTypeClinic;   // ���������� ������� ������ �����
  procedure AddBoxShowSMS;      // ���������� ������� ������ ���������� � SMS
  procedure AddBoxStatus;       // ���������� ������� ������ ������

  public
    { Public declarations }
    isEditForm:Boolean; // ������������� �� ������ ������
    p_editID:Integer;
    p_editIP,p_editAddress,p_editAlias:string;
    p_editTypeClinic:enumTypeClinic;
    p_editShowSMS:enumParamStatus;
    p_editWorkingTime:enumParamStatus;
    p_editStatus:enumStatusJobClinic;

 procedure UpdateWorkingTimeStatus(_status:enumParamStatus; isChangeEditWorkingTime:Boolean = False); // ���������� ������� ������� ������

  end;

var
  FormServerIKEdit: TFormServerIKEdit;

implementation

uses
  FunctionUnit, FormServersIKUnit, GlobalVariables, GlobalVariablesLinkDLL, FormServerIKWorkingTimeUnit;


{$R *.dfm}
function TFormServerIKEdit.getResponseBD(InTypePanel_Server:TypeResponse_Server;
                                         _id:Integer;
                                         InIP,
                                         InAddr,
                                         InAlias:string;
                                         InTypeCLinic:enumTypeClinic;
                                         InShowSMS:enumParamStatus;
                                         InStatus:enumStatusJobClinic;
                                         var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Screen.Cursor:=crHourGlass;
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);
  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      case InTypePanel_Server of
        server_add:begin
          SQL.Add('insert into server_ik (ip,address,alias,type_clinik,showSMS,status) values ('+#39+InIP+#39+','
                                                                                                +#39+InAddr+#39+','
                                                                                                +#39+InAlias+#39+','
                                                                                                +#39+EnumTypeClinicToString(InTypeCLinic)+#39+','
                                                                                                +#39+IntToStr(SettingParamsStatusToInteger(InShowSMS))+#39+','
                                                                                                +#39+IntToStr(EnumStatusJobClinicToInteger(InStatus))+#39+
                                                                                              ')');
        end;
        server_delete:begin
          SQL.Add('delete from server_ik where ip='+#39+InIP+#39+' and address='+#39+InAddr+#39+' and alias = '+#39+InAlias+#39);
        end;
        server_edit: begin
           SQL.Add('update server_ik set ip = '+#39+InIP+#39
                                              +', address = '+#39+InAddr+#39
                                              +', alias = '+#39+InAlias+#39
                                              +', type_clinik = '+#39+EnumTypeClinicToString(InTypeCLinic)+#39
                                              +', showSMS = '+#39+IntToStr(SettingParamsStatusToInteger(InShowSMS))+#39
                                              +', status = '+#39+IntToStr(EnumStatusJobClinicToInteger(InStatus))+#39
                                              +' where id = '+#39+IntToStr(_id)+#39);
        end;
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             _errorDescription:=e.Message;
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;

    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  // ������� ����� ������
  if InTypePanel_Server = server_delete then begin
    DeleteWorkingTime(_id,_errorDescription);
  end;

  Screen.Cursor:=crDefault;
  Result:=True;
end;


procedure TFormServerIKEdit.AddBoxTypeClinic;
var
 i:Integer;
 current:enumTypeClinic;
begin
  combox_TypeClinic.Clear;

  for i:=Ord(Low(enumTypeClinic)) to Ord(High(enumTypeClinic)) do
  begin
    current:=enumTypeClinic(i);
    combox_TypeClinic.Items.Add(EnumTypeClinicToString(current));
  end;
end;


procedure TFormServerIKEdit.AddBoxShowSMS;
begin
  combox_ShowSMS.Clear;
  combox_ShowSMS.Items.Add(EnumStatusToString(eNO));
  combox_ShowSMS.Items.Add(EnumStatusToString(eYES));
end;

// ���������� ������� ������ ������
procedure TFormServerIKEdit.AddBoxStatus;
begin
  combox_Status.Clear;
  combox_Status.Items.Add(EnumStatusJobClinicToString(eClose));
  combox_Status.Items.Add(EnumStatusJobClinicToString(eOpen));
end;


// ���������� ������� ������� ������
procedure TFormServerIKEdit.UpdateWorkingTimeStatus(_status:enumParamStatus; isChangeEditWorkingTime:Boolean = False);
begin
  case _status of
   paramStatus_ENABLED:begin

     if isChangeEditWorkingTime then p_editWorkingTime:=_status;

     btnWorkingTime.Enabled:=True;
     lblWorkingTimeLabel.Enabled:=True;

     if p_editWorkingTime = paramStatus_DISABLED then begin
       lblStatusWorkingTime.Caption:='�� ���������';
       lblStatusWorkingTime.Font.Color:=clRed;
     end
     else begin
       lblStatusWorkingTime.Caption:='���������';
       lblStatusWorkingTime.Font.Color:=clGreen;
     end;
   end;
   paramStatus_DISABLED:begin
     lblStatusWorkingTime.Font.Color:=clRed;
     lblStatusWorkingTime.Caption:='���������� ��� ����������';

     btnWorkingTime.Enabled:=False;
     lblWorkingTimeLabel.Enabled:=False;
   end;
  end;
end;

function TFormServerIKEdit.getCheckFileds(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

  with FormServerIKEdit do begin
    if edtIP.Text='' then begin
       _errorDescription:='�� ��������� ���� "IP"';
       Exit;
    end;

    if edtAddress.Text='' then begin
       _errorDescription:='�� ��������� ���� "�����"';
       Exit;
    end;

    if edtAlias.Text='' then begin
       _errorDescription:='�� ��������� ���� "Alias"';
       Exit;
    end;

   // �������� IP
   if not getCheckIP(edtIP.Text) then begin
     _errorDescription:='������������ IP �����';
     Exit;
   end;

   if combox_TypeClinic.ItemIndex = -1 then begin
     _errorDescription:='�� ������ "���"';
     Exit;
   end;

   if combox_ShowSMS.ItemIndex = -1 then begin
     _errorDescription:='�� ������ �������� "���������� � SMS"';
     Exit;
   end;

   // �������� alias
   {if getCheckAlias(edtAlias.Text) then begin
     Result:='������! ����� Alias ��� ����������';
     Exit;
   end; }

   Result:=True;
  end;
end;


// ������� ������
procedure clearPanel;
begin
  with FormServerIKEdit do begin
     edtIP.Text:='';
     edtAddress.Text:='';
     edtAlias.Text:='';
     combox_TypeClinic.ItemIndex:=-1;
     combox_ShowSMS.ItemIndex:=-1;
  end;
end;



procedure TFormServerIKEdit.btnAddClick(Sender: TObject);
var
 ip,addr,alias:string;
 id:Integer;
 type_clinic:enumTypeClinic;
 show_sms:enumParamStatus;
 status:enumStatusJobClinic;
 error:string;
begin

   if not getCheckFileds(error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   id:=0; // �.�. ���������

   ip:=edtIP.Text;
   addr:=edtAddress.Text;
   alias:=edtAlias.Text;

   type_clinic:=StringToEnumTypeClinic(combox_TypeClinic.Items[combox_TypeClinic.ItemIndex]);
   show_sms:=StringToSettingParamsStatus(combox_ShowSMS.Items[combox_ShowSMS.ItemIndex]);
   status:=StringToEnumStatusJobClinic(combox_Status.Items[combox_Status.ItemIndex]);


  // ������� ��������
  if not getResponseBD(server_add, id, ip, addr, alias, type_clinic, show_sms, status, error)  then begin
     MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ���������� �������
  FormServersIK.Show;

  if chkboxCloseWindow.Checked then Close
  else clearPanel;

end;

procedure TFormServerIKEdit.btnEditClick(Sender: TObject);
var
 ip,addr,alias:string;
 id:Integer;
 type_clinic:enumTypeClinic;
 show_sms:enumParamStatus;
 status:enumStatusJobClinic;
 error:string;
begin

   if not getCheckFileds(error) then begin
     MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;
   id:=p_editID;

   ip:=edtIP.Text;
   addr:=edtAddress.Text;
   alias:=edtAlias.Text;

   type_clinic:=StringToEnumTypeClinic(combox_TypeClinic.Items[combox_TypeClinic.ItemIndex]);
   show_sms:=StringToSettingParamsStatus(combox_ShowSMS.Items[combox_ShowSMS.ItemIndex]);
   status:=StringToEnumStatusJobClinic(combox_Status.Items[combox_Status.ItemIndex]);

  // ������� ���������������
  if not getResponseBD(server_edit, id, ip, addr, alias, type_clinic, show_sms, status, error) then begin
     // �� ������� ��������
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ���������� �������
  FormServersIK.Show;

  if chkboxCloseWindow.Checked then Close
  else clearPanel;

end;

procedure TFormServerIKEdit.btnWorkingTimeClick(Sender: TObject);
begin
  with FormServerIKWorkingTime do begin
    SetAddress(p_editAddress, p_editTypeClinic);
    SetId(p_editID);

    ShowModal;
  end;
end;

// �������� ������� �� ������� ����� ������
function TFormServerIKEdit.DeleteWorkingTime(_id:Integer; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Screen.Cursor:=crHourGlass;
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);
  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('delete from server_ik_worktime where id='+#39+IntToStr(_id)+#39);

      try
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             _errorDescription:=e.Message;
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;

    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  Screen.Cursor:=crDefault;
  Result:=True;
end;


procedure TFormServerIKEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  isEditForm:=False;

  p_editIP:='';
  p_editAddress:='';
  p_editID:=0;
  p_editAlias:='';
  p_editTypeClinic:=eOther;
  p_editShowSMS:=paramStatus_DISABLED;
  p_editWorkingTime:=paramStatus_DISABLED;

  with FormServersIK do begin
    panel_Server_IP:='';
    panel_Server_addr:='';
    panel_Server_ID:=0;
    panel_Server_Alias:='';
    panel_Server_TypeClinic:=eOther;
    panel_Server_ShowSMS:=paramStatus_DISABLED;
  end;
end;

procedure TFormServerIKEdit.FormShow(Sender: TObject);
const
 cLeftButton:Word = 137;
begin
   AddBoxTypeClinic;  // ��������� ������ �����
   AddBoxShowSMS;     // ��������� ������ ���������� � SMS
   AddBoxStatus;      // ��������� ������ ������

   if not isEditForm then begin  // ����� ����������
     // ������� ������
     clearPanel;

     btnAdd.Left:=cLeftButton;
     btnAdd.Visible:=True;
     btnEdit.Visible:=False;

     chkboxCloseWindow.Caption:='������� ���� ����� ����������';
     chkboxCloseWindow.Enabled:=True;

     Caption:='���������� �������';

     // ���� ������
     UpdateWorkingTimeStatus(paramStatus_DISABLED);
   end
   else begin             // �������������

     edtIP.Text:=p_editIP;
     edtAddress.Text:=p_editAddress;
     edtAlias.Text:=p_editAlias;
     combox_TypeClinic.ItemIndex:=combox_TypeClinic.Items.IndexOf(EnumTypeClinicToString(p_editTypeClinic));
     combox_ShowSMS.ItemIndex:=SettingParamsStatusToInteger(p_editShowSMS);

     combox_Status.ItemIndex:=EnumStatusJobClinicToInteger(p_editStatus);

     // ���� �������
     UpdateWorkingTimeStatus(paramStatus_ENABLED);

     btnEdit.Left:=cLeftButton;
     btnAdd.Visible:=False;
     btnEdit.Visible:=True;

     chkboxCloseWindow.Caption:='������� ���� ����� ��������������';
     chkboxCloseWindow.Enabled:=False;
     chkboxCloseWindow.Checked:=True;

     Caption:='�������������� ������� '+p_editIP+' ('+p_editAlias+') '+p_editAddress;
   end;

end;

end.
