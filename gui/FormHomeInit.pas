unit FormHomeInit;

interface
  uses System.SysUtils, Winapi.Windows;


procedure _INIT;    // ������������� �����
procedure _CHECK;   // �������� ����� ��������


implementation

uses
  FormHome, GlobalVariables, FunctionUnit, GlobalVariablesLinkDLL, FormDEBUGUnit, TCustomTypeUnit;



procedure _CHECK;
var
 errorDescription:string;
begin
    // ������� ���������� ����� �� �����
  if not isExistFreeSpaceDrive(errorDescription) then begin
    ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
  end;

  // �������� ���������� �� MySQL Connector
  if not isExistMySQLConnector then begin
    errorDescription:='�� ���������� MySQL Connector';
    ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
  end;

   // �������� �� ���� (� ����� �� ���������)
   if not DEBUG then begin
     if not GetAliveCoreDashboard then begin
      errorDescription:='����������� ������! ���������� TCP ������'+#13+
                                  '('+GetTCPServerAddress+' : '+IntToStr(GetTCPServerPort)+')'+#13#13+
                                  '��������� � ������� ��';
      ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
     end;
   end;

  // ����������� ������� ������
  with HomeForm do begin
   if DEBUG then Caption:='    ===== DEBUG | (base:'+GetDefaultDataBase+') =====    ' + Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')'
   else Caption:=Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')';
  end;


  // �������� �� ������ ������
  CheckCurrentVersion;

  // ������� �� ��������� ������ ����� ��������������
  ClearAfterUpdate;

   // �������� �� 2�� ����� ��������
  if GetCloneRun(PChar(DASHBOARD_EXE)) then begin
    MessageBox(HomeForm.Handle,PChar('��������� ������ 2�� ����� ���������'+#13#13+
                                     '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
    KillProcess;
  end;

end;


procedure _INIT;
begin
      // �������� ���
   with HomeForm.StatusBar do begin
    Panels[2].Text:=SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name;
    Panels[3].Text:=GetUserRoleSTR(SharedCurrentUserLogon.ID);
    Panels[4].Text:=GetCopyright;
   end;

  // ��������� ������ � ������� �����
  CreateCurrentActiveSession(SharedCurrentUserLogon.ID);

  // �������� ������ �������� ��� �������� �����������
  createCheckServersInfoclinika;
  // �������� ������ sip trunk ��� ��������
  CreateCheckSipTrunk;

  // ��������� �������������� �������� ������������
  LoadIndividualSettingUser(SharedCurrentUserLogon.ID);

  // ����������� ���� �������
  AccessRights(SharedCurrentUserLogon);

  // ��������� �������� ��������� �� �����
  AddCustomCheckBoxUI;

  // ��������
  Egg;

  // �������� ���� ����� debug info � ����� ��� �������� ���������� ������ �������
  SharedCountResponseThread.SetAddForm(FormDEBUG);

  // ������� ��� ���� �����
  clearAllLists;

  // footer_menu (����� ������ ������)
  if SharedCurrentUserLogon.Auth = eAuthLdap then HomeForm.menu_ChangePassword.Visible:=False;

  // ����������� ������ ������ ��������
  AccessUsersCommonQueue(SharedCurrentUserLogon.QueueList);


  // ����+����� ������
  PROGRAM_STARTED:=Now;

  // ������ ������� ����� ������
  WindowStateInit;
end;


end.
