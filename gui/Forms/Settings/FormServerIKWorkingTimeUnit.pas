unit FormServerIKWorkingTimeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, System.DateUtils, TCustomTypeUnit,
  Data.Win.ADODB, Data.DB, IdException,
  TWorkingTimeClinicUnit;


 type                                  // ��� �������
   TypeResponse_Server = (server_add,
                          server_edit
                          );

type
  TFormServerIKWorkingTime = class(TForm)
    lblAddress: TLabel;
    GroupBox1: TGroupBox;
    lbl_mon: TLabel;
    lbl_tue: TLabel;
    TimeStart_mon: TDateTimePicker;
    TimeStop_mon: TDateTimePicker;
    lbl_delimiter_mon: TLabel;
    chkbox_mon: TCheckBox;
    TimeStart_tue: TDateTimePicker;
    lbl_delimiter_tue: TLabel;
    TimeStop_tue: TDateTimePicker;
    chkbox_tue: TCheckBox;
    TimeStart_wed: TDateTimePicker;
    lbl_delimiter_wed: TLabel;
    TimeStop_wed: TDateTimePicker;
    chkbox_wed: TCheckBox;
    lbl_wed: TLabel;
    lbl_thu: TLabel;
    lbl_fri: TLabel;
    lbl_sat: TLabel;
    lbl_sun: TLabel;
    TimeStart_thu: TDateTimePicker;
    lbl_delimiter_thu: TLabel;
    TimeStop_thu: TDateTimePicker;
    chkbox_thu: TCheckBox;
    TimeStart_fri: TDateTimePicker;
    lbl_delimiter_fri: TLabel;
    TimeStop_fri: TDateTimePicker;
    chkbox_fri: TCheckBox;
    TimeStart_sat: TDateTimePicker;
    lbl_delimiter_sat: TLabel;
    TimeStop_sat: TDateTimePicker;
    chkbox_sat: TCheckBox;
    TimeStart_sun: TDateTimePicker;
    lbl_delimiter_sun: TLabel;
    TimeStop_sun: TDateTimePicker;
    chkbox_sun: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure IsEditData(Sender: TObject);
    procedure chkbox_monClick(Sender: TObject);
    procedure chkbox_tueClick(Sender: TObject);
    procedure chkbox_wedClick(Sender: TObject);
    procedure chkbox_thuClick(Sender: TObject);
    procedure chkbox_friClick(Sender: TObject);
    procedure chkbox_satClick(Sender: TObject);
    procedure chkbox_sunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimeStop_wedClick(Sender: TObject);
  private
    { Private declarations }
  m_address   :string;   // �����
  m_type      :enumTypeClinic;  // ���
  m_id        :Integer;  // id ������� �� server_ik -> id
  m_clinic    :TWorkingTimeClinic;

  m_isEditData:Boolean;  // �� ����� ���� ��������������

  m_DataLoading:Boolean;  // ���������� �� ������ ��� ���

  procedure Clear;  // �������
  procedure ChangeStatus(_week:string; _status:enumParamStatus);  // ����� ������� (���\����)

  function GetResponseBD( _response:TypeResponse_Server;
                          var p_clinic:TWorkingTimeClinic;
                          var _errorDescription:string):Boolean;
  procedure AddData;      // ������� ������ � m_clinic
  procedure ShowWorkingTime; //������� � ���������� ������� ������ � �����


  public
    { Public declarations }
  procedure SetAddress(_address:string; _type:enumTypeClinic);
  procedure SetId(_id:Integer);

  end;

var
  FormServerIKWorkingTime: TFormServerIKWorkingTime;

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, FormTrunkEditUnit, FormServersIKUnit, FormServerIKEditUnit;



{$R *.dfm}


procedure TFormServerIKWorkingTime.IsEditData(Sender: TObject);
begin
  if not m_DataLoading then Exit;

  m_isEditData:=True;
end;


function TFormServerIKWorkingTime.GetResponseBD( _response:TypeResponse_Server;
                                                 var p_clinic:TWorkingTimeClinic;
                                                 var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Screen.Cursor:=crHourGlass;
  Result:=False;

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

      case _response of
        server_add:begin
          SQL.Add('insert into server_ik_worktime (id,mon,tue,wed,thu,fri,sat,sun) values ('+#39+IntToStr(p_clinic.ID)+#39+','
                                                                                            +#39+p_clinic.m_time.m_monday+#39+','
                                                                                            +#39+p_clinic.m_time.m_tuesday+#39+','
                                                                                            +#39+p_clinic.m_time.m_wednesday+#39+','
                                                                                            +#39+p_clinic.m_time.m_thursday+#39+','
                                                                                            +#39+p_clinic.m_time.m_friday+#39+','
                                                                                            +#39+p_clinic.m_time.m_saturday+#39+','
                                                                                            +#39+p_clinic.m_time.m_sunday+#39+')');
        end;
        server_edit: begin
           SQL.Add('update server_ik_worktime set mon = '+#39+p_clinic.m_time.m_monday+#39
                                                         +', tue = '+#39+p_clinic.m_time.m_tuesday+#39
                                                         +', wed = '+#39+p_clinic.m_time.m_wednesday+#39
                                                         +', thu = '+#39+p_clinic.m_time.m_thursday+#39
                                                         +', fri = '+#39+p_clinic.m_time.m_friday+#39
                                                         +', sat = '+#39+p_clinic.m_time.m_saturday+#39
                                                         +', sun = '+#39+p_clinic.m_time.m_sunday+#39
                                                         +' where id = '+#39+IntToStr(p_clinic.ID)+#39);
        end;
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
            Screen.Cursor:=crDefault;
            _errorDescription:=e.ClassName+': '+e.Message;
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


// ������� ������ � m_clinic
procedure TFormServerIKWorkingTime.AddData;
const
  list: TArray<string> = ['mon',
                          'tue',
                          'wed',
                          'thu',
                          'fri',
                          'sat',
                          'sun'];
var
 i,j,k:Integer;
 time_start,time_stop:string;
 Control: TControl;
 times:TDateTimePicker;
 chkbox:TCheckBox;
 GroupBox: TGroupBox;
 output:Boolean; // ��������
begin
  for i:= Low(list) to High(list) do
  begin
    time_start:='';
    time_stop:='';
    output:=False;

    // �������� �� ���� ��������� �����
    for j:=0 to Self.ControlCount - 1 do
    begin
      Control:= Self.Controls[j];

      // ���������, �������� �� ������� TGroupBox
      if Control is TGroupBox then
      begin
        GroupBox:= TGroupBox(Control); // �������� Control � TGroupBox
        // �������� �� ���� �������� ��������� TGroupBox
        for k:=0 to GroupBox.ControlCount - 1 do
        begin
          // ���� ��������
          if GroupBox.Controls[k] is TCheckBox then begin
           if AnsiPos('chkbox_'+list[i], GroupBox.Controls[k].Name)<>0 then begin
             chkbox:=TCheckBox(GroupBox.Controls[k]);

             if chkbox.Checked then begin
               output:=True;
             end;
           end;
          end;

          if GroupBox.Controls[k] is TDateTimePicker then
          begin
            if AnsiPos('TimeStart_'+list[i], GroupBox.Controls[k].Name)<>0 then
            begin
               times:=TDateTimePicker(GroupBox.Controls[k]);
               time_start:=FormatDateTime('hh:mm', times.Time);
            end;
            if AnsiPos('TimeStop_'+list[i], GroupBox.Controls[k].Name)<>0 then
            begin
               times:=TDateTimePicker(GroupBox.Controls[k]);
               time_stop:=FormatDateTime('hh:mm', times.Time);
            end;
          end;
        end;
      end;

      if (time_start<>'') and (time_stop<>'') then begin
       m_clinic.SetWorking(enumWorkingTime(i), time_start+' - '+time_stop, output);
      end;
    end;
  end;
end;


//������� � ���������� ������� ������ � �����
procedure TFormServerIKWorkingTime.ShowWorkingTime;

const   // �������� list TArray<string> == enumWorkingTime[] !!!
  list: TArray<string> = ['mon',
                          'tue',
                          'wed',
                          'thu',
                          'fri',
                          'sat',
                          'sun'];
var
  i,j,k:Integer;
  Control: TControl;
  times:TDateTimePicker;
  GroupBox: TGroupBox;
  chkbox:TCheckBox;
  time_start,time_stop:string;
  output:Boolean;  // ��������

begin
   for i:=Ord(Low(enumWorkingTime)) to Ord(High(enumWorkingTime)) do begin

     output:=False;
     // ��������
     if m_clinic.GetWorking(enumWorkingTime(i)) = 'output' then begin
      output:=True;
     end
     else begin
      time_start:=Copy(m_clinic.GetWorking(enumWorkingTime(i)), 1, 5);
      time_stop:=Copy(m_clinic.GetWorking(enumWorkingTime(i)), 9, 5);
     end;

     // �������� �� ���� ��������� �����
     for j:= 0 to Self.ControlCount - 1 do
     begin
        Control:= Self.Controls[j];

        // ���������, �������� �� ������� TGroupBox
        if Control is TGroupBox then
        begin
          GroupBox:= TGroupBox(Control); // �������� Control � TGroupBox
          // �������� �� ���� �������� ��������� TGroupBox
          for k:= 0 to GroupBox.ControlCount - 1 do
          begin
            // ��������
            if output then begin

              if GroupBox.Controls[k] is TCheckBox then begin
               if AnsiPos('chkbox_'+list[i], GroupBox.Controls[k].Name)<>0 then begin
                 chkbox:=TCheckBox(GroupBox.Controls[k]);
                 chkbox.Checked:=True;
               end;
              end;

             Continue;
            end;

            if GroupBox.Controls[k] is TDateTimePicker then
            begin
              if AnsiPos('TimeStart_'+list[i], GroupBox.Controls[k].Name)<>0 then
              begin
                 times:=TDateTimePicker(GroupBox.Controls[k]);
                 times.Time:=StrToTime(time_start);

              end;
              if AnsiPos('TimeStop_'+list[i], GroupBox.Controls[k].Name)<>0 then
              begin
                times:=TDateTimePicker(GroupBox.Controls[k]);
                times.Time:=StrToTime(time_stop);
              end;
            end;
          end;
        end;
     end;
   end;
end;

procedure TFormServerIKWorkingTime.TimeStop_wedClick(Sender: TObject);
begin

end;

// ����� ������� (���\����)
procedure TFormServerIKWorkingTime.ChangeStatus(_week:string; _status:enumParamStatus);
var
  i, j: Integer;
  Control: TControl;
  lbl:TLabel;
  times:TDateTimePicker;
  GroupBox: TGroupBox;
begin
  // �������� �� ���� ��������� �����
  for i:= 0 to Self.ControlCount - 1 do
  begin
    Control:= Self.Controls[i];

    // ���������, �������� �� ������� TGroupBox
    if Control is TGroupBox then
    begin
      GroupBox:= TGroupBox(Control); // �������� Control � TGroupBox
      // �������� �� ���� �������� ��������� TGroupBox
      for j:= 0 to GroupBox.ControlCount - 1 do
      begin
        if GroupBox.Controls[j] is TLabel then
        begin
          if AnsiPos(_week, GroupBox.Controls[j].Name)<>0 then
          begin
             lbl:= TLabel(GroupBox.Controls[j]);
             case _status of
              paramStatus_ENABLED: lbl.Enabled:=True;
              paramStatus_DISABLED: lbl.Enabled:=False;
             end;
          end;
        end;

        if GroupBox.Controls[j] is TDateTimePicker then
        begin
          if AnsiPos(_week, GroupBox.Controls[j].Name)<>0 then
          begin
             times:= TDateTimePicker(GroupBox.Controls[j]);
             case _status of
              paramStatus_ENABLED: times.Enabled:=True;
              paramStatus_DISABLED: times.Enabled:=False;
             end;
          end;
        end;
      end;
    end;
  end;
end;


procedure TFormServerIKWorkingTime.SetAddress(_address:string; _type:enumTypeClinic);
begin
  m_address:=_address;
  m_type:=_type;
end;

procedure TFormServerIKWorkingTime.SetId(_id:Integer);
begin
  m_id:=_id;
end;


procedure TFormServerIKWorkingTime.chkbox_friClick(Sender: TObject);
const
 week:string ='_fri';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_fri.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_monClick(Sender: TObject);
const
 week:string ='_mon';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_mon.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_satClick(Sender: TObject);
const
 week:string ='_sat';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_sat.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_sunClick(Sender: TObject);
const
 week:string ='_sun';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_sun.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_thuClick(Sender: TObject);
const
 week:string ='_thu';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_thu.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_tueClick(Sender: TObject);
const
 week:string ='_tue';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_tue.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.chkbox_wedClick(Sender: TObject);
const
 week:string ='_wed';
var
 status:enumParamStatus;
begin
  m_isEditData:=True;

  if not chkbox_wed.Checked then status:=paramStatus_ENABLED
  else status:=paramStatus_DISABLED;

  ChangeStatus(week,status);
end;

procedure TFormServerIKWorkingTime.Clear;
var
  i, j: Integer;
  Control: TControl;
  GroupBox: TGroupBox;
begin
  m_isEditData:=False;

  // �������� �� ���� ��������� �����
  for i:= 0 to Self.ControlCount - 1 do
  begin
    Control:= Self.Controls[i];
    // ���������, �������� �� ������� TGroupBox
    if Control is TGroupBox then
    begin
      GroupBox:= TGroupBox(Control); // �������� Control � TGroupBox
      // �������� �� ���� �������� ��������� TGroupBox
      for j:= 0 to GroupBox.ControlCount - 1 do
      begin
        // ���� �������� ������� TDateTimePicker, �������� ���
        if GroupBox.Controls[j] is TDateTimePicker then
        begin
          TDateTimePicker(GroupBox.Controls[j]).Time:= EncodeTime(0, 0, 0, 0);
        end;

        if GroupBox.Controls[j] is TCheckBox then
        begin
          TCheckBox(GroupBox.Controls[j]).Checked:= False;
        end;
      end;
    end;
  end;
end;

procedure TFormServerIKWorkingTime.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 error:string;
 responce:TypeResponse_Server;
 resultat:Word;
begin
  m_DataLoading:=False;

  if m_isEditData then begin

    resultat:=MessageBox(Handle,PChar('������ ���� ��������'+#13#13+
                                      '��������� ���������?'),PChar('���������'),MB_YESNO+MB_ICONINFORMATION);
    if resultat = mrNo then Exit;
  end
  else Exit;

  // ������� ������ �������
  AddData;

  // ������ ������� �� �� ��� ������ ��� �������?
  if m_clinic.ExistTime then responce:=server_edit
  else responce:=server_add;

  if not GetResponseBD(responce,m_clinic,error) then begin
   MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  // ������� ������ ���� ���� ������ ����� �����
  if not m_clinic.ExistTime then begin
   FormServersIK.Show;
   FormServerIKEdit.UpdateWorkingTimeStatus(paramStatus_ENABLED,True);
  end;

end;

procedure TFormServerIKWorkingTime.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormServerIKWorkingTime.FormShow(Sender: TObject);
begin
  // ������� �����
  Clear;

  lblAddress.Caption:=m_address+' ('+EnumTypeClinicToString(m_type)+')';

  // �������� ��������� ������ ������ � �������
  m_clinic:=TWorkingTimeClinic.Create(m_id);

  // ��������� �������
  if m_clinic.ExistTime then ShowWorkingTime;

  // ��� ������ ����������
  m_DataLoading:=True;
end;

end.
