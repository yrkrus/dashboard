unit FormUsersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TFormUsers = class(TForm)
    PageControl: TPageControl;
    UsersAll: TTabSheet;
    OnlyOPerators: TTabSheet;
    listSG_Users_Footer: TStringGrid;
    listSG_Users: TStringGrid;
    btnShowUsers: TBitBtn;
    btnDisable: TBitBtn;
    btnEditUser: TBitBtn;
    listSG_Operators: TStringGrid;
    listSG_Operators_Footer: TStringGrid;
    chkboxViewDisabled: TCheckBox;
    btnEnable: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnShowUsersClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure chkboxViewDisabledClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure listSG_UsersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure listSG_OperatorsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnDisableClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEnableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
   currentEditUserId:string;

  public

    { Public declarations }
  end;

var
  FormUsers: TFormUsers;

implementation

uses
  FunctionUnit, FormAddNewUsersUnit, GlobalVariables;

{$R *.dfm}

procedure LoadSettingsLogic;
begin
 with FormUsers do begin
   chkboxViewDisabled.Checked:=False;
   chkboxViewDisabled.Visible:=True;
   PageControl.ActivePageIndex:=0;
 end;
end;

procedure LoadSettings;
begin
  with FormUsers do begin

    // ������� ��� ������������
    with listSG_Users_Footer do begin
     RowCount:=1;
     Cells[0,0]:='ID';
     Cells[1,0]:='������� ���';
     Cells[2,0]:='�����';
     Cells[3,0]:='������ ����';
     Cells[4,0]:='���������';
    end;

     // ������� ���������
    with listSG_Operators_Footer do begin
      RowCount:=1;
      Cells[0,0]:='ID';
      Cells[1,0]:='������� ���';
      Cells[2,0]:='Sip';
      Cells[3,0]:='IP �������';
      Cells[4,0]:='������ ����';
    end;


   // ��������� ������ ������������� (False - �� ���������� ����������� �������������)
   loadPanel_Users(SharedCurrentUserLogon.GetRole);

   // ��������� ������ ������������� (���������) (False - �� ���������� ����������� �������������)
   loadPanel_Operators;

  end;
end;

procedure TFormUsers.btnDisableClick(Sender: TObject);
var
resultat:Word;
id:Integer;
 error:string;
begin
 if currentEditUserId='1' then begin
    MessageBox(Handle,PChar('������������ ������ ���������!'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 if currentEditUserId='' then begin
    MessageBox(Handle,PChar('�� ������ ������������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 id:=StrToInt(currentEditUserId);

 resultat:=MessageBox(Handle,PChar('����� ��������� '+getUserNameFIO(id)+'?'),PChar('���������'),MB_YESNO+MB_ICONWARNING);
 if resultat=mrNo then Exit;


  // ���������
  if not DisableUser(id, error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  // ��������� ����� ������
    LoadSettings;

  MessageBox(Handle,PChar('������������ ��������'),PChar('�������'),MB_OK+MB_ICONINFORMATION);

end;

procedure TFormUsers.btnEditUserClick(Sender: TObject);
begin
  if currentEditUserId='1' then begin
    MessageBox(Handle,PChar('������������ ������ ���������������!'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if currentEditUserId='' then begin
    MessageBox(Handle,PChar('�� ������ ������������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  with FormAddNewUsers do begin
    currentEditUsers:=True;
    currentEditUsersID:=StrToInt64(currentEditUserId);

    // ���������� ��� ���� ��������������
    currentEditUserId:='';

    ShowModal;
  end;

end;

procedure TFormUsers.btnEnableClick(Sender: TObject);
var
  resultat:Word;
  id:Integer;
  error:string;
begin
 if currentEditUserId='' then begin
    MessageBox(Handle,PChar('�� ������ ������������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 id:=StrToInt(currentEditUserId);

 resultat:=MessageBox(Handle,PChar('����� �������� '+getUserNameFIO(id)+'?'),PChar('���������'),MB_YESNO+MB_ICONWARNING);
 if resultat=mrNo then Exit;


  // ��������
  if not EnableUser(id,error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ��������� ����� ������
  LoadSettings;
  LoadSettingsLogic;

  MessageBox(Handle,PChar('������������ �������'),PChar('�������'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormUsers.btnShowUsersClick(Sender: TObject);
begin
 FormAddNewUsers.ShowModal;
end;

procedure TFormUsers.chkboxViewDisabledClick(Sender: TObject);
begin
  if chkboxViewDisabled.Checked then begin
   loadPanel_Users(SharedCurrentUserLogon.GetRole,True);
   btnDisable.Visible:=False;

   btnEditUser.Enabled:=False;


   btnEnable.Visible:=True;
   btnEnable.Top:=btnDisable.Top;
   btnEnable.Left:=btnDisable.Left;
  end
  else begin
   loadPanel_Users(SharedCurrentUserLogon.GetRole);

   btnEditUser.Enabled:=True;

   btnDisable.Visible:=True;
   btnEnable.Visible:=False;
  end;

end;

procedure TFormUsers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LoadSettingsLogic;
end;

procedure TFormUsers.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormUsers.FormShow(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;

  // ������� ��������� �������
  currentEditUserId:='';

  LoadSettings;
  LoadSettingsLogic;

  Screen.Cursor:=crDefault;
end;

procedure TFormUsers.listSG_OperatorsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
  var
   id:Integer;
begin
  // �������� id �� sip
  if listSG_Operators.Cells[2,ARow]<>'' then begin
    id:=getUserID(StrToInt(listSG_Operators.Cells[2,ARow]));

    currentEditUserId:=IntToStr(id);
  end;

end;

procedure TFormUsers.listSG_UsersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if listSG_Users.Cells[0,ARow]<>'' then begin
    currentEditUserId:=listSG_Users.Cells[0,ARow];
  end;
end;

procedure TFormUsers.PageControlChange(Sender: TObject);
begin
   currentEditUserId:='';

   if PageControl.ActivePage.Caption='��� ������������' then begin
    chkboxViewDisabled.Visible:=True;
    btnDisable.Enabled:=True;

    if chkboxViewDisabled.Checked then begin
     btnEnable.Enabled:=True;
    end;

   end
   else begin
     chkboxViewDisabled.Visible:=False;
     btnDisable.Enabled:=False;

     btnEnable.Enabled:=False;
   end;

end;

end.
