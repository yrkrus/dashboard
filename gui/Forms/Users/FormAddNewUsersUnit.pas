unit FormAddNewUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB, Data.DB, IdException,
  Vcl.Buttons, TCustomTypeUnit, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,
  Vcl.CheckLst, TCheckBoxUIUnit, TSipPhoneListUnit, System.Generics.Collections, TUserUnit;

 type
  enumAction = (action_add,action_edit);

type
  TFormAddNewUsers = class(TForm)
    btnAddNewUser: TBitBtn;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    edtNewFamiliya: TEdit;
    Label1: TLabel;
    edtNewName: TEdit;
    Label2: TLabel;
    combox_Auth: TComboBox;
    lblLogin: TLabel;
    edtLogin: TEdit;
    lblLdapInfo: TLabel;
    group_localPassword: TGroupBox;
    lblInfoNewPwd: TLabel;
    Label4: TLabel;
    edtPwdNew: TEdit;
    edtPwd2New: TEdit;
    st_edtPwd: TStaticText;
    st_edtPwd2: TStaticText;
    lblLdapInfoPassword: TLabel;
    Label5: TLabel;
    lblPassInfo: TLabel;
    lbl_checkbox_NewPassword: TLabel;
    img_NewPassword: TImage;
    GroupBox2: TGroupBox;
    img_CommonQueue5000: TImage;
    lbl_checkbox_CommonQueue5000: TLabel;
    img_CommonQueue5050: TImage;
    lbl_checkbox_CommonQueue5050: TLabel;
    img_CommonQueue5911: TImage;
    lbl_checkbox_CommonQueue5911: TLabel;
    Label6: TLabel;
    combox_AccessGroups: TComboBox;
    GroupBox3: TGroupBox;
    img_ExternalReport: TImage;
    lbl_checkbox_ExternalReport: TLabel;
    img_ExternalChat: TImage;
    lbl_checkbox_ExternalChat: TLabel;
    img_ExternalSms: TImage;
    lbl_checkbox_ExternalSms: TLabel;
    img_ExternalCalls: TImage;
    lbl_checkbox_ExternalCalls: TLabel;
    Label12: TLabel;
    lblSip: TLabel;
    combox_Sip: TComboBox;
    lblNoSip: TLabel;
    lblLoginInfo: TLabel;
    lblSwapSip: TLabel;
    btnEdit: TBitBtn;
    procedure btnAddNewUserClick(Sender: TObject);
    procedure edtNewFamiliyaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNewLoginChange(Sender: TObject);
    procedure edtOperatorSetting_SIP_showChange(Sender: TObject);
    procedure combox_AuthDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure combox_AuthChange(Sender: TObject);
    procedure combox_AccessGroupsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbl_checkbox_NewPasswordClick(Sender: TObject);
    procedure img_NewPasswordClick(Sender: TObject);
    procedure edtPwdNewClick(Sender: TObject);
    procedure edtPwd2NewClick(Sender: TObject);
    procedure lbl_checkbox_CommonQueue5000Click(Sender: TObject);
    procedure img_CommonQueue5000Click(Sender: TObject);
    procedure img_CommonQueue5050Click(Sender: TObject);
    procedure lbl_checkbox_CommonQueue5050Click(Sender: TObject);
    procedure img_CommonQueue5911Click(Sender: TObject);
    procedure lbl_checkbox_CommonQueue5911Click(Sender: TObject);
    procedure img_ExternalReportClick(Sender: TObject);
    procedure lbl_checkbox_ExternalReportClick(Sender: TObject);
    procedure img_ExternalChatClick(Sender: TObject);
    procedure lbl_checkbox_ExternalChatClick(Sender: TObject);
    procedure img_ExternalSmsClick(Sender: TObject);
    procedure lbl_checkbox_ExternalSmsClick(Sender: TObject);
    procedure img_ExternalCallsClick(Sender: TObject);
    procedure lbl_checkbox_ExternalCallsClick(Sender: TObject);
    procedure combox_AccessGroupsChange(Sender: TObject);
    procedure combox_SipDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ButtonAction(Sender: TObject);
  private
    { Private declarations }
  m_checkBoxUI              :TCheckBoxUI;   // ������������ ��� �����
  m_imagelistAuth           :TImageList;
  m_imagelistGroupAccess    :TImageList;
  m_imagelistSip            :TImageList;
  m_sipList                 :TSipPhoneList;

  m_IsEditUser              :Boolean;
  m_editUserId              :Integer;       // default = 0
  m_editUser                :TUser;

  procedure InitForm;     // ������������� �����
  procedure CloseClear;   //������� ����� ��������

  function GetCheckEditNewOperator(InUserID:Integer):Boolean;


  procedure LoadIconListAuth;         // ��������� ������
  procedure LoadIconListAccessGroup;  // ��������� ������
  procedure LoadIconListSip;          // ��������� ������

  procedure Loading;
  procedure LoadingEditUser;          // ��������� ������ �� �������������� ������������
  procedure InitComboxAuth;
  procedure InitDefaultPasswordNewUser;
  procedure InitCheckboxUI;
  procedure InitComboxAccessGroup;
  procedure InitComboxSip;

  procedure ChangeChoisAuth;  // ����� ���� �����������
  procedure ChangeFamiliya;   // ��������� �������

  procedure ShowAccessGroup(_role:enumRole);  // ����������� ����� �������

  procedure ChangeChoisNewPassword; // ����� ����� ������
  procedure ChangeChoisAccessGroup; // ����� ����� �������

  function CheckFields(var _errorDescription:string):Boolean; // �������� �����
  function CheckLogin(_login:string):Boolean;  // ���������� �� login �������������

  function ExecuteResponce(_action:enumAction; var _errorDescription:string):Boolean;

  protected
  procedure CreateParams(var Params: TCreateParams); override;
  procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

  public   { Public declarations }

  property IsEdit:Boolean read m_IsEditUser write m_IsEditUser;   // ������������� ������ ������������
  property IsEditID:Integer write m_editUserId;                   // user_id ������ �������������


  end;

var
  FormAddNewUsers: TFormAddNewUsers;

const
 cDefaultUserPass:string = '1';


implementation

uses
  FunctionUnit, FormUsersUnit, GlobalVariables, GlobalVariablesLinkDLL, GlobalImageDestination, TLdapUnit;

{$R *.dfm}


procedure TFormAddNewUsers.CreateParams(var Params: TCreateParams);
begin
  inherited;
  // 1) ������ ��������� WS_EX_APPWINDOW
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  // 2) ������� Owner/Parent � ����, �������� � ��������
  Params.WndParent := HWND_DESKTOP;
end;
//
procedure TFormAddNewUsers.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType and $FFF0) = SC_MINIMIZE then
  begin
    ShowWindow(Self.Handle, SW_MINIMIZE);
    // � �� �������� inherited, ����� �� ����������� �� �� ����������
  end
  else
  inherited;
end;


// ��������� ������
procedure TFormAddNewUsers.LoadIconListAuth;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpLocal,pngbmpLdap: TPngImage;
 bmpLocal,bmpLdap: TBitmap;
begin
  if not FileExists(ICON_GUI_AUTH_LOCAL) then Exit;
  if not FileExists(ICON_GUI_AUTH_LDAP) then Exit;
  if not Assigned(m_imagelistAuth) then m_imagelistAuth:=TImageList.Create(nil);

  m_imagelistAuth.SetSize(SIZE_ICON,SIZE_ICON);
  m_imagelistAuth.ColorDepth:=cd32bit;

  begin
   // LOCAL
   pngbmpLocal:=TPngImage.Create;
   bmpLocal:=TBitmap.Create;

   pngbmpLocal.LoadFromFile(ICON_GUI_AUTH_LOCAL);

    // ������� ������ �� ������� 16�16
    with bmpLocal do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpLocal);
    end;

   // LDAP
   pngbmpLdap:=TPngImage.Create;
   bmpLdap:=TBitmap.Create;

   pngbmpLdap.LoadFromFile(ICON_GUI_AUTH_LDAP);

    // ������� ������ �� ������� 16�16
    with bmpLdap do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpLdap);
    end;

  end;

  m_imagelistAuth.Add(bmpLocal, nil);    // index = 0
  m_imagelistAuth.Add(bmpLdap, nil);     // index = 1


  if pngbmpLocal<>nil then pngbmpLocal.Free;
  if bmpLocal<>nil then bmpLocal.Free;
  if pngbmpLdap<>nil then pngbmpLdap.Free;
  if bmpLdap<>nil then bmpLdap.Free;
end;


procedure TFormAddNewUsers.LoadIconListAccessGroup;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpLocal: TPngImage;
 bmpLocal: TBitmap;
begin
  if not FileExists(ICON_GUI_GROUP) then Exit;
  if not Assigned(m_imagelistGroupAccess) then m_imagelistGroupAccess:=TImageList.Create(nil);

  m_imagelistGroupAccess.SetSize(SIZE_ICON,SIZE_ICON);
  m_imagelistGroupAccess.ColorDepth:=cd32bit;

  begin
   // LOCAL
   pngbmpLocal:=TPngImage.Create;
   bmpLocal:=TBitmap.Create;

   pngbmpLocal.LoadFromFile(ICON_GUI_GROUP);

    // ������� ������ �� ������� 16�16
    with bmpLocal do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpLocal);
    end;
  end;

  m_imagelistGroupAccess.Add(bmpLocal, nil);    // index = 0


  if pngbmpLocal<>nil then pngbmpLocal.Free;
  if bmpLocal<>nil then bmpLocal.Free;
end;

 // ��������� ������
procedure TFormAddNewUsers.LoadIconListSip;
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

    // ������� ������ �� ������� 16�16
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


// ��������� �����
function IsChangedMoreThan50Percent(const Original, New: string):Boolean;
var
  i, ChangesCount: Integer;
  LengthToCompare: Integer;
begin
  // ���������� ����� ������ ��� ���������
  LengthToCompare := Length(Original);
  if Length(New) > LengthToCompare then LengthToCompare := Length(New);

  ChangesCount := 0;

  // ���������� ������� �����
  for i := 1 to LengthToCompare do
  begin
    // ���� ������� �����������, ����������� ������� ���������
    if (i > Length(Original)) or (i > Length(New)) or (Original[i] <> New[i]) then  Inc(ChangesCount);
  end;
  // ���������, ������ �� ��������� 50% �� ����� ����� ������� ������
  Result := ChangesCount > (LengthToCompare div 2);
end;

// ������������� �����
procedure TFormAddNewUsers.InitForm;
const
 cButtonTop:Word = 225;
begin
  case m_IsEditUser of
    false:begin   // ���������� ������ ������������
      btnAddNewUser.Top:=cButtonTop;
      btnAddNewUser.Visible:=True;

      Caption:='���������� ������ ������������';

      btnEdit.Visible:=False;
    end;
    True:begin   // �������������� ������������
     btnEdit.Top:=cButtonTop;
     btnEdit.Visible:=True;

     Caption:='�������������� ['+GetUserNameFIO(m_editUserId)+']';
     btnAddNewUser.Visible:=False;

     // ������� ������ �� ������������
     m_editUser:=TUser.Create(m_editUserId);
    end;
  end;
end;


//������� ����� ��������
procedure TFormAddNewUsers.CloseClear;
begin
 // ����� �������
 begin
   combox_Auth.ItemIndex:=-1;

   lblPassInfo.Visible:=True;

   edtNewFamiliya.Text:='';
   edtNewName.Text:='';

   edtLogin.Text:='';
   edtLogin.ShowHint:=False;
   edtLogin.Visible:=False;
   lblLogin.Enabled:=True;
   lblLoginInfo.Visible:=True;

   lblLdapInfoPassword.Visible:=False;
   lblLdapInfo.Visible:=False;
   group_localPassword.Visible:=False;
   m_checkBoxUI.ChangeStatusCheckBox('NewPassword', paramStatus_DISABLED);
 end;

 // ������ �������
 begin
  // ������� ������
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5000', paramStatus_DISABLED);
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5050', paramStatus_DISABLED);
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5911', paramStatus_DISABLED);

  // ������
  m_checkBoxUI.ChangeStatusCheckBox('ExternalReport', paramStatus_DISABLED);
  m_checkBoxUI.ChangeStatusCheckBox('ExternalChat', paramStatus_DISABLED);
  m_checkBoxUI.ChangeStatusCheckBox('ExternalSms', paramStatus_DISABLED);
  m_checkBoxUI.ChangeStatusCheckBox('ExternalCalls', paramStatus_DISABLED);

  // ������ �������
  combox_AccessGroups.ItemIndex:=-1;

  // sip
  lblSip.Visible:=False;
  combox_Sip.Visible:=False;
  lblNoSip.Visible:=False;
  lblSwapSip.Visible:=False;
 end;

 // private
 m_IsEditUser:=False;
 m_editUserId:=0;
 if Assigned(m_editUser) then FreeAndNil(m_editUser);

end;


// �������� �������� ��������� ������ ��������������� ��� ��������� �������� ���������������
function TFormAddNewUsers.GetCheckEditNewOperator(InUserID:Integer):Boolean;
var
  oldName:string;
  oldFamiliya:string;
begin
  Result:=False;

  oldName:=getUserNameBD(InUserID);
  oldFamiliya:=getUserFamiliya(InUserID);

  if ( IsChangedMoreThan50Percent(oldFamiliya,edtNewFamiliya.Text)) or
     ( IsChangedMoreThan50Percent(oldName,edtNewName.Text)) then Result:=True;
end;


procedure TFormAddNewUsers.img_CommonQueue5000Click(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5000');
end;

procedure TFormAddNewUsers.img_CommonQueue5050Click(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5050');
end;

procedure TFormAddNewUsers.img_CommonQueue5911Click(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5911');
end;

procedure TFormAddNewUsers.img_ExternalCallsClick(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('ExternalCalls');
end;

procedure TFormAddNewUsers.img_ExternalChatClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalChat');
end;

procedure TFormAddNewUsers.img_ExternalReportClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalReport');
end;

procedure TFormAddNewUsers.img_ExternalSmsClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalSms');
end;

procedure TFormAddNewUsers.img_NewPasswordClick(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('NewPassword');
 ChangeChoisNewPassword;
end;

function TFormAddNewUsers.ExecuteResponce(_action:enumAction; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

 user_auth:enumAuth;

 user_familiya, user_name, user_login,
 user_pwd, user_group, user_sip:string;

 access_chat, access_reports,
 access_sms, access_calls:enumParamStatus;

 u_role:string;

 NewUserIsOperator:Boolean;         // ����������� ����� ��������
 isNeedResetPwd:enumParamStatus;    // ���� �� ������� ���� ������ ��� �����

 userID:string;

 userQueue:TList<enumQueue>;
 i:Integer;

 request:TStringBuilder;
begin
  Result:=False;
  _errorDescription:='';

  Screen.Cursor:=crHourGlass;
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Screen.Cursor:=crDefault;
    _errorDescription:='�� ������� ����������� � ��������';
    Exit;
  end;

  try
    with ado do begin
     ado.Connection:=serverConnect;
     SQL.Clear;

     ////////////////////////// ����� ������� //////////////////////////

     user_auth:=IntegerToEnumAuth(combox_Auth.ItemIndex);

     user_familiya:=edtNewFamiliya.Text;
     user_familiya:=StringReplace(user_familiya,' ','',[rfReplaceAll]);

     user_name:=edtNewName.Text;
     user_name:=StringReplace(user_name,' ','',[rfReplaceAll]);

     // ����� � ��������� �����
     user_login:=edtLogin.Text;
     user_login:=AnsiLowerCase(user_login);
     user_login:=StringReplace(user_login,' ','',[rfReplaceAll]);

     // ������
     case user_auth of
      eAuthLocal:begin
         case m_IsEditUser of
           false:begin   // ���������� ������ ������������

             case m_checkBoxUI.Checked['NewPassword'] of
              false:begin  // ������ �� default
               user_pwd:=IntToStr(getHashPwd(cDefaultUserPass));
              end;
              true:begin
               user_pwd:=IntToStr(getHashPwd(edtPwdNew.Text));
              end;
             end;

             isNeedResetPwd:=paramStatus_ENABLED;
           end;
           true:begin    // �������������� ������������
            user_pwd:=IntToStr(getHashPwd(edtPwdNew.Text));
            isNeedResetPwd:=paramStatus_DISABLED;
           end;
         end;
      end;
      eAuthLdap:begin
         case m_IsEditUser of
           False:begin
             user_pwd:=IntToStr(getHashPwd(cDefaultUserPass)); // �������� ��� ���������� �����
             isNeedResetPwd:=paramStatus_ENABLED;              // �������� ��� ���������� �����
           end;
           True:begin
             if m_checkBoxUI.Checked['NewPassword'] then begin
              user_pwd:=IntToStr(getHashPwd(cDefaultUserPass));
              isNeedResetPwd:=paramStatus_ENABLED;
             end;
           end;
         end;
      end;
     end;


     ////////////////////////// ������ ������� //////////////////////////
     // �������
     userQueue:=TList<enumQueue>.Create;
     if m_checkBoxUI.Checked['CommonQueue5000'] then userQueue.Add(queue_5000);
     if m_checkBoxUI.Checked['CommonQueue5050'] then userQueue.Add(queue_5050);
     if m_checkBoxUI.Checked['CommonQueue5911'] then userQueue.Add(queue_5911);

     // �������
     if m_checkBoxUI.Checked['ExternalReport'] then access_reports:=paramStatus_ENABLED
     else access_reports:=paramStatus_DISABLED;
     if m_checkBoxUI.Checked['ExternalChat'] then access_chat:=paramStatus_ENABLED
     else access_chat:=paramStatus_DISABLED;
     if m_checkBoxUI.Checked['ExternalSms'] then access_sms:=paramStatus_ENABLED
     else access_sms:=paramStatus_DISABLED;
     if m_checkBoxUI.Checked['ExternalCalls'] then access_calls:=paramStatus_ENABLED
     else access_calls:=paramStatus_DISABLED;

     // ������
      user_group:=combox_AccessGroups.Items[combox_AccessGroups.ItemIndex];
      System.Delete(user_group,1,1);  // ������� ������ ������ ��� �������  ' '
      u_role:=IntToStr(getUserGroupID(user_group));

       if RoleIsOperator(StringToEnumRole(user_group)) then begin
         // ����� ���������� ������������
         if not m_IsEditUser then begin
           if combox_Sip.Items.Count = 0 then begin
            _errorDescription:='��� ���������� ������ ��������� ����������� ����� ������� SIP �����';
            Screen.Cursor:=crDefault;
            Exit;
           end;

           user_sip:=combox_Sip.Items[combox_Sip.ItemIndex];
           System.Delete(user_sip,1,1);   // ������� ������ ������ ��� �������  ' '

           NewUserIsOperator:=True;   // ����� ������������ ��� ������������ ������
         end;
       end;

      request:=TStringBuilder.Create;

      case _action of
        action_add:begin
          with request do begin
           Clear;
           Append('insert into users');
           Append(' (name,familiya,role,login,pass,is_need_reset_pwd,chat,reports,sms,calls,ldap_auth)');
           Append(' values (');
           Append(#39+user_name+#39+','+#39+user_familiya+#39+','+#39+u_role+#39+','+#39+user_login+#39);
           Append(','+#39+user_pwd+#39+','+#39+IntToStr(SettingParamsStatusToInteger(isNeedResetPwd))+#39);
           Append(','+#39+IntToStr(SettingParamsStatusToInteger(access_chat))+#39);
           Append(','+#39+IntToStr(SettingParamsStatusToInteger(access_reports))+#39);
           Append(','+#39+IntToStr(SettingParamsStatusToInteger(access_sms))+#39);
           Append(','+#39+IntToStr(SettingParamsStatusToInteger(access_calls))+#39);
           Append(','+#39+IntToStr(EnumAuthToInteger(user_auth))+#39);
           Append(')');
          end;

        end;
        action_edit:begin
          with request do begin
           Clear;
           Append('update users set ');
           Append('name='+#39+user_name+#39+',');
           Append('familiya='+#39+user_familiya+#39+',');
           Append('role='+#39+u_role+#39+',');
           Append('login='+#39+user_login+#39+',');

           if m_checkBoxUI.Checked['NewPassword'] then begin  // ������ ������ ���� ����
            Append('pass='+#39+user_pwd+#39+',');
            Append('is_need_reset_pwd='+#39+IntToStr(SettingParamsStatusToInteger(isNeedResetPwd))+#39+',');
           end;

           Append('chat='+#39+IntToStr(SettingParamsStatusToInteger(access_chat))+#39+',');
           Append('reports='+#39+IntToStr(SettingParamsStatusToInteger(access_reports))+#39+',');
           Append('sms='+#39+IntToStr(SettingParamsStatusToInteger(access_sms))+#39+',');
           Append('calls='+#39+IntToStr(SettingParamsStatusToInteger(access_calls))+#39+',');
           Append('ldap_auth='+#39+IntToStr(EnumAuthToInteger(user_auth))+#39);
           Append(' where id = '+#39+IntToStr(m_editUserId)+#39);
          end;
        end;
      end;

      try
          SQL.Add(request.ToString);
          ExecSQL;
      except
          on E:EIdException do begin
             Screen.Cursor:=crDefault;
             _errorDescription:=e.Message;

            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
              FreeAndNil(request);
            end;

             Exit;
          end;
      end;

      // id ������������
      case m_IsEditUser of
        false: userID:=IntToStr(GetUserID(user_login));  // ���������� ����� ������������
        true:  userID:=IntToStr(m_editUserId);           // ������������� ������������
      end;


      // ����������� �������
      begin
        if userQueue.Count <> 0 then begin
          case _action of
            action_add:begin  // ���������� ������ ������������
              AddUserCommonQueue(StrToInt(userID),userQueue);
            end;
            action_edit:begin // �������������� ������������
              DeleteUserCommonQueue(StrToInt(userID));
              AddUserCommonQueue(StrToInt(userID),userQueue);
            end;
          end;
        end;
      end;


      // ������� ���������
      begin
        if not m_IsEditUser then begin
          if NewUserIsOperator then begin

             SQL.Clear;
             SQL.Add('insert into operators (sip,user_id) values ('+#39+user_sip+#39+','
                                                                   +#39+userID+#39+')');
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
                      FreeAndNil(request);
                    end;
                   Exit;
                end;
            end;
          end;
        end;
      end;


      // ������� settings_sip (������� ��� ����������)
      if RoleIsOperator(StringToEnumRole(user_group)) then begin
        SQL.Clear;
         SQL.Add('update settings_sip set user_id = '+#39+userID+#39
                                                     +' where sip = ' +#39+user_sip+#39);
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
                  FreeAndNil(request);
                end;
               Exit;
            end;
        end;
      end;


    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;

  Screen.Cursor:=crDefault;

  Result:=True;
end;


// ����������� ����� �������
procedure TFormAddNewUsers.ShowAccessGroup(_role:enumRole);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countGroup,i:Integer;
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

      if _role = role_administrator then SQL.Add('select count(id) from role where id <> ''-1'' ')
      else  SQL.Add('select count(id) from role where id <> ''-1'' and only_operators= ''1'' ');

      Active:=True;
      countGroup:=StrToInt(VarToStr(Fields[0].Value));
    end;

    with combox_AccessGroups do begin
      Clear;

      with ado do begin
        SQL.Clear;

        if _role = role_administrator then SQL.Add('select id from role where id <> ''-1''')
        else  SQL.Add('select id from role where id <> ''-1'' and only_operators= ''1'' ');

        Active:=True;

         for i:=0 to countGroup-1 do begin
           Items.Add(' '+getUserGroupSTR(Fields[0].Value));
           ado.Next;
         end;

      end;
      ItemIndex:= -1;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


procedure TFormAddNewUsers.ButtonAction(Sender: TObject);
var
 error:string;
 action:enumAction;
begin
   if not CheckFields(error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ��������� ������ ��������
  case m_IsEditUser of
    false:begin   // ���������� ������ ������������
      action:=action_add;
    end;
    True:begin    // �������������� ������������
      action:=action_edit;
    end;
  end;

  showWait(show_open);

  if not ExecuteResponce(action, error) then begin
    showWait(show_close);
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ������� ������
  begin
    // ������ �� ���������� sip ��������
    if not Assigned(m_sipList) then m_sipList:=TSipPhoneList.Create
    else m_sipList.UpdateData;

    // ��������� ��������� sip
    InitComboxSip;

    FormUsers.UpdateUsersAfterAddOrEdit;
  end;

  showWait(show_close);

  case m_IsEditUser of
    false:begin   // ���������� ������ ������������
      MessageBox(Handle,PChar('����� ������������ ��������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
    end;
    True:begin    // �������������� ������������
      MessageBox(Handle,PChar('������������ ��������������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
    end;
  end;

  CloseClear;
end;

procedure TFormAddNewUsers.btnAddNewUserClick(Sender: TObject);
begin
  ButtonAction(Sender);
end;


procedure TFormAddNewUsers.combox_AccessGroupsChange(Sender: TObject);
begin
 ChangeChoisAccessGroup;
end;

procedure TFormAddNewUsers.combox_AccessGroupsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if m_imagelistGroupAccess.Count = 0 then  Exit;

  IconIndex:=0;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    m_imagelistGroupAccess.GetBitmap(IconIndex, Bitmap);
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

procedure TFormAddNewUsers.combox_AuthChange(Sender: TObject);
begin
 ChangeChoisAuth;
end;

procedure TFormAddNewUsers.combox_AuthDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 ComboBox: TComboBox;
 bitmap: TBitmap;
 IconIndex:Integer;
begin
  if m_imagelistAuth.Count = 0 then  Exit;

  IconIndex:=Index;
  ComboBox:=(Control as TComboBox);
  Bitmap:= TBitmap.Create;
  try
    m_imagelistAuth.GetBitmap(IconIndex, Bitmap);
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

procedure TFormAddNewUsers.combox_SipDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
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

procedure TFormAddNewUsers.edtNewFamiliyaChange(Sender: TObject);
begin
  ChangeFamiliya;
end;


procedure TFormAddNewUsers.edtNewLoginChange(Sender: TObject);
begin
  // ����� ����� ��������� �������� �� ������ �� ������
 // if currentEditUsers then userEditFields_login:=True;
end;

procedure TFormAddNewUsers.edtOperatorSetting_SIP_showChange(Sender: TObject);
begin
  // ����� ����� ��������� �������� �� ������ �� sip
 // if currentEditUsers then UserEditFileds_sip:=True;
end;

procedure TFormAddNewUsers.edtPwd2NewClick(Sender: TObject);
begin
 st_edtPwd2.Visible:=False;
end;

procedure TFormAddNewUsers.edtPwdNewClick(Sender: TObject);
begin
  st_edtPwd.Visible:=False;
end;

procedure TFormAddNewUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  CloseClear;
//  // ��������� ���� � ��������
//  showSettingOperatorSIP(False);
//
//  chkboxAllowLocalChat.Checked:=False;
//  chkboxAllowReports.Checked:=False;
//  chkboxAllowSMS.Checked:=False;
//
//  // �� ������ ������ ��� ��� �� ������������� ������
//  currentEditUsers:=False;
//  currentEditUsersID:=0;

end;

procedure TFormAddNewUsers.InitComboxAuth;
var
 ldap:TLdap;
begin
  combox_Auth.Clear;
  combox_Auth.Items.Add(' '+EnumAuthToString(eAuthLocal));

  // ������� �� ������ �� ldap
  ldap:=TLdap.Create;
  if ldap.GetStatusLdap then combox_Auth.Items.Add(' '+EnumAuthToString(eAuthLdap));

  // ���������� ������
  LoadIconListAuth;
end;


procedure TFormAddNewUsers.InitComboxAccessGroup;
begin
  ShowAccessGroup(SharedCurrentUserLogon.Role);

  // ���������� ������
  LoadIconListAccessGroup;
end;


procedure TFormAddNewUsers.InitComboxSip;
var
 i:Integer;
begin
  combox_Sip.Clear;

  for i:=0 to m_sipList.Count-1 do begin
    if m_sipList.Items[i].m_userId = -1 then begin
      combox_Sip.Items.Add(' '+IntToStr(m_sipList.Items[i].m_sip));
    end;
  end;

  // ���������� ������
  LoadIconListSip;
end;


procedure TFormAddNewUsers.InitDefaultPasswordNewUser;
begin
 lblInfoNewPwd.Caption:='�� ��������� ��� ����� ������������� ������ "'+cDefaultUserPass+'"';
end;


procedure TFormAddNewUsers.lbl_checkbox_CommonQueue5000Click(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5000');
end;

procedure TFormAddNewUsers.lbl_checkbox_CommonQueue5050Click(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5050');
end;

procedure TFormAddNewUsers.lbl_checkbox_CommonQueue5911Click(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('CommonQueue5911');
end;

procedure TFormAddNewUsers.lbl_checkbox_ExternalCallsClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalCalls');
end;

procedure TFormAddNewUsers.lbl_checkbox_ExternalChatClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalChat');
end;

procedure TFormAddNewUsers.lbl_checkbox_ExternalReportClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalReport');
end;

procedure TFormAddNewUsers.lbl_checkbox_ExternalSmsClick(Sender: TObject);
begin
  m_checkBoxUI.ChangeStatusCheckBox('ExternalSms');
end;

procedure TFormAddNewUsers.lbl_checkbox_NewPasswordClick(Sender: TObject);
begin
 m_checkBoxUI.ChangeStatusCheckBox('NewPassword');
 ChangeChoisNewPassword;
end;

procedure TFormAddNewUsers.InitCheckboxUI;
begin
  if not Assigned(m_checkBoxUI) then m_checkBoxUI:=TCheckBoxUI.Create;

  // ��������� ������ ������
  m_checkBoxUI.Add('NewPassword',lbl_checkbox_NewPassword,img_NewPassword, paramStatus_DISABLED);

  // ������� ������
  m_checkBoxUI.Add('CommonQueue5000',lbl_checkbox_CommonQueue5000,img_CommonQueue5000, paramStatus_DISABLED);
  m_checkBoxUI.Add('CommonQueue5050',lbl_checkbox_CommonQueue5050,img_CommonQueue5050, paramStatus_DISABLED);
  m_checkBoxUI.Add('CommonQueue5911',lbl_checkbox_CommonQueue5911,img_CommonQueue5911, paramStatus_DISABLED);

  // ������
  m_checkBoxUI.Add('ExternalReport',lbl_checkbox_ExternalReport,img_ExternalReport, paramStatus_DISABLED);
  m_checkBoxUI.Add('ExternalChat',lbl_checkbox_ExternalChat,img_ExternalChat, paramStatus_DISABLED);
  m_checkBoxUI.Add('ExternalSms',lbl_checkbox_ExternalSms,img_ExternalSms, paramStatus_DISABLED);
  m_checkBoxUI.Add('ExternalCalls',lbl_checkbox_ExternalCalls,img_ExternalCalls, paramStatus_DISABLED);

end;

// ����� ���� �����������
procedure TFormAddNewUsers.ChangeChoisAuth;
const
 cPassInfoTOP:Word = 144;
 cPassInfoLEFT:Word = 126;

 cPassGroupTOP:Word = 136;
 cPassGroupLEFT:Word = 120;
 cPassGroupWIDTH:Word = 170;
begin
  lblPassInfo.Visible:=False;
  m_checkBoxUI.ChangeStatusCheckBox('NewPassword', paramStatus_DISABLED);
  ChangeChoisNewPassword;

  if combox_Auth.ItemIndex = 1 then
  begin  // ldap
    lblLdapInfo.Visible:=True;
    edtLogin.ShowHint:=True;
    edtLogin.Enabled:=True;
    lblLogin.Enabled:=True;

    // ������ ldap
    lblLdapInfoPassword.Visible:=True;
    lblLdapInfoPassword.Top:=cPassInfoTOP;
    lblLdapInfoPassword.Left:=cPassInfoLEFT;

    // ��������� ���������� ������
    group_localPassword.Visible:=False;


  end
  else begin  // local
   lblLdapInfo.Visible:=False;
   edtLogin.ShowHint:=False;
   edtLogin.Enabled:=False;
   lblLogin.Enabled:=False;

    // ������ ldap
   lblLdapInfoPassword.Visible:=False;

   // ��������� ���������� ������
   group_localPassword.Visible:=True;
   group_localPassword.Top:=cPassGroupTOP;
   group_localPassword.Left:=cPassGroupLEFT;
   group_localPassword.Width:=cPassGroupWIDTH;
  end;
end;

// ��������� �������
procedure TFormAddNewUsers.ChangeFamiliya;
begin

  case m_IsEditUser of
   false:begin  // ����������  ������ ������������
      if edtNewFamiliya.Text<>'' then begin
       // ������ ��� ���������� �����
        lblLoginInfo.Visible:=False;
        edtLogin.Visible:=True;

       if combox_Auth.ItemIndex = 0 then begin  // ��������� ����
         lblLogin.Enabled:=False;
         edtLogin.Text:=getTranslate(edtNewFamiliya.Text);
       end;
      end;
   end;
   true:begin   // ������������ �������������
     lblLoginInfo.Visible:=False;
      edtLogin.Visible:=True;
   end;
  end;

end;


// ����� ����� ������
procedure TFormAddNewUsers.ChangeChoisNewPassword;
const
 cEdtLEFT:Word = 5;
 cSTPwdLEFT:Word = 120;
 cSTPwd2LEFT:Word = 73;
begin
  edtPwdNew.Text:='';
  edtPwd2New.Text:='';

  if m_checkBoxUI.Checked['NewPassword'] then begin
    edtPwdNew.Left:=cEdtLEFT;
    st_edtPwd.Left:=cSTPwdLEFT;

    edtPwd2New.Left:=cEdtLEFT;
    st_edtPwd2.Left:=cSTPwd2LEFT;

    edtPwdNew.Visible:=True;
    edtPwd2New.Visible:=True;
    st_edtPwd.Visible:=True;
    st_edtPwd2.Visible:=True;


    lblInfoNewPwd.Visible:=False;
    img_NewPassword.Visible:=False;
    lbl_checkbox_NewPassword.Visible:=False;
  end
  else begin
   edtPwdNew.Visible:=False;
   edtPwd2New.Visible:=False;
   st_edtPwd.Visible:=False;
   st_edtPwd2.Visible:=False;


   lblInfoNewPwd.Visible:=True;
   img_NewPassword.Visible:=True;
   lbl_checkbox_NewPassword.Visible:=True;
  end;
end;


// ���������� �� login �������������
function TFormAddNewUsers.CheckLogin(_login:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=True; // default
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
      SQL.Add('select count(id) from users where login = '+#39+_login+#39);
      Active:=True;

      if Fields[0].Value<>null then begin
        if Fields[0].Value <> 0 then Result:=True
        else Result:=False;
      end
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// �������� �����
function TFormAddNewUsers.CheckFields(var _errorDescription:string):Boolean;
 var
 currentGroup:string;
begin
   Result:=False;
   _errorDescription:='';

///////////////////////////////// ����� ������� /////////////////////////////////

  if combox_Auth.ItemIndex = -1 then begin
   _errorDescription:='�� ������ "��� �����������"';
   Exit;
  end;


  if edtNewFamiliya.Text='' then begin
   _errorDescription:='�� ��������� ���� "�������"';
    Exit;
  end;

  if AnsiPos(' ',edtNewFamiliya.Text)<>0 then begin
   _errorDescription:='� ���� "�������" ������������ ������';
    Exit;
  end;

  if edtNewName.Text='' then begin
   _errorDescription:='�� ��������� ���� "���"';
    Exit;
  end;


  if edtLogin.Text='' then begin
   _errorDescription:='�� ��������� ���� "�����"';
   Exit;
  end;

  // �������� ������
  if m_IsEditUser then begin // ������������� ������������
   // �������� ���� ��������� �����
    if m_editUser.Login <> edtLogin.Text then begin
      if CheckLogin(edtLogin.Text) then begin
         _errorDescription:='����� '+edtLogin.Text+' ��� ����������';
         Exit;
      end;
    end;
  end
  else begin
    if CheckLogin(edtLogin.Text) then begin
     _errorDescription:='����� '+edtLogin.Text+' ��� ����������';
     Exit;
    end;
  end;

  // ������
  if combox_Auth.ItemIndex = 0 then begin
    if m_checkBoxUI.Checked['NewPassword'] then begin
      if edtPwdNew.Text='' then begin
       _errorDescription:='�� ��������� ���� "������"';
       Exit;
      end;

      if edtPwd2New.Text='' then begin
       _errorDescription:='�� ��������� ���� "�������������"';
       Exit;
      end;

      if edtPwdNew.Text <> edtPwd2New.Text then begin
       _errorDescription:='������ �� ���������';
       Exit;
      end;
    end;
  end;

///////////////////////////////// ������ ������� /////////////////////////////////

  // �������
  if not (m_checkBoxUI.Checked['CommonQueue5000']
      or m_checkBoxUI.Checked['CommonQueue5050']
      or m_checkBoxUI.Checked['CommonQueue5911'] ) then
  begin
    _errorDescription:='�� ������� �� ���� �� ��������';
    Exit;
  end;

  // ������� (����� ���� � �� �������)

  // ������ �������
  begin
    if combox_AccessGroups.ItemIndex= -1 then begin
      _errorDescription:='�� ������� "������"';
      Exit;
    end;

    currentGroup:=combox_AccessGroups.Items[combox_AccessGroups.ItemIndex];

   // ����������� ������ ����� � ����������� �� ���� �������
      if (AnsiPos('��������',currentGroup) <> 0) or
         (AnsiPos('��������',currentGroup)<> 0) then begin

        // ��������� ����� ������ ������ ��������� ������ ��������������� � ������� �� ���������
        if m_IsEditUser then begin
          if GetCheckEditNewOperator(m_editUserId) then begin
           _errorDescription:='������������ ������ �������� �����'+#13#13+
                              '��� ��������� ������ ������������, �������� ���������� �������';
           Exit;
          end;
        end;
      end;
  end;

  Result:=True;
end;


procedure TFormAddNewUsers.ChangeChoisAccessGroup;
const
 cNoSIPLEFT:Word = 390;
 cNoSIPTOP:Word = 143;
var
 user_group:string;
begin
 user_group:=combox_AccessGroups.Items[combox_AccessGroups.ItemIndex];
 // ������� ������ ������ ��� �������  ' '
 System.Delete(user_group,1,1);

 if RoleIsOperator(StringToEnumRole(user_group)) then begin

  case m_IsEditUser of
    false:begin   // �� ������������� ������������
       lblSip.Visible:=True;

       // ���� �� ��������� sip
       if m_sipList.IsExistFree then begin
         // ���� ��������� ������
         lblNoSip.Visible:=False;

         combox_Sip.Visible:=True;

       end
       else begin
         // ��� �������
         combox_Sip.Visible:=False;


         lblNoSip.Visible:=True;
         lblNoSip.Left:=cNoSIPLEFT;
         lblNoSip.Top:=cNoSIPTOP;
       end;
    end;
    True:begin   // ������������� ������������
      if m_editUser.IsOperator then begin
        if _dll_GetOperatorSIP(m_editUserId)<> -1 then begin
          lblSip.Visible:=True;
          lblSwapSip.Visible:=True;
          lblSwapSip.Left:=cNoSIPLEFT;
          lblSwapSip.Top:=cNoSIPTOP;
        end;
      end;
    end;
  end;


 end
 else begin
    lblSip.Visible:=False;
    lblNoSip.Visible:=False;
    lblSwapSip.Visible:=False;
    combox_Sip.Visible:=False;
 end;

end;


procedure TFormAddNewUsers.Loading;
begin
  // ����� ���� �����������
  InitComboxAuth;

  // ������ ��� ����� ������
  InitDefaultPasswordNewUser;

  // �������� �������� ��� ������
  InitCheckboxUI;

  // ������ �������
  InitComboxAccessGroup;

  // ������ �� ���������� sip ��������
  if not Assigned(m_sipList) then m_sipList:=TSipPhoneList.Create
  else m_sipList.UpdateData;

  // ��������� ��������� sip
  InitComboxSip;

end;


// ��������� ������ �� �������������� ������������
procedure TFormAddNewUsers.LoadingEditUser;
const
 cSwapSIPLEFT:Word = 390;
 cSwapSIPTOP:Word = 143;
begin
  // �� ������ ������
  if not Assigned(m_editUser) then m_editUser:=TUser.Create(m_editUserId);

  ///////////////////////////////// ����� ������� /////////////////////////////////

  // ��� �����������
  combox_Auth.ItemIndex:=(EnumAuthToInteger(m_editUser.Auth));
  ChangeChoisAuth;

  // �������
  edtNewFamiliya.Text:=m_editUser.Familiya;
  ChangeFamiliya;

  // ���
  edtNewName.Text:=m_editUser.Name;

  // �����
  edtLogin.Text:=m_editUser.Login;

///////////////////////////////// ������ ������� /////////////////////////////////

  // �������
  m_checkBoxUI.Checked['CommonQueue5000'] :=m_editUser.Queue[queue_5000];
  m_checkBoxUI.Checked['CommonQueue5050'] :=m_editUser.Queue[queue_5050];
  m_checkBoxUI.Checked['CommonQueue5911'] :=m_editUser.Queue[queue_5911];

 // �������
  m_checkBoxUI.Checked['ExternalReport']  :=m_editUser.ExternalAccess[eExternalAccessReports];
  m_checkBoxUI.Checked['ExternalChat']    :=m_editUser.ExternalAccess[eExternalAccessLocalChat];
  m_checkBoxUI.Checked['ExternalSms']     :=m_editUser.ExternalAccess[eExternalAccessSMS];
  m_checkBoxUI.Checked['ExternalCalls']   :=m_editUser.ExternalAccess[eExternalAccessCalls];

  // ������ �������
  combox_AccessGroups.ItemIndex:=combox_AccessGroups.Items.IndexOf(' '+EnumRoleToString(m_editUser.Role));

  // sip
  if m_editUser.IsOperator then begin
    if _dll_GetOperatorSIP(m_editUserId)<> -1 then begin
      lblSip.Visible:=True;
      lblSwapSip.Visible:=True;
      lblSwapSip.Left:=cSwapSIPLEFT;
      lblSwapSip.Top:=cSwapSIPTOP;
    end;
  end;
end;


procedure TFormAddNewUsers.FormShow(Sender: TObject);
begin
  showWait(show_open);

  InitForm;

  Loading;

  // ������������� ������������
  if m_IsEditUser then LoadingEditUser;

  showWait(show_close);
end;

end.


