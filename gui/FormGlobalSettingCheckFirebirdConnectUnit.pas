unit FormGlobalSettingCheckFirebirdConnectUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, TCheckServersUnit;

type
  TFormGlobalSettingCheckFirebirdConnect = class(TForm)
    comboxServer: TComboBox;
    Label1: TLabel;
    btnSaveFirebirdSettings: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveFirebirdSettingsClick(Sender: TObject);
  private
    { Private declarations }
   servers:TCheckServersIK;
  public
    { Public declarations }
  end;

var
  FormGlobalSettingCheckFirebirdConnect: TFormGlobalSettingCheckFirebirdConnect;

implementation

uses
  FunctionUnit, GlobalVariables;

{$R *.dfm}

procedure TFormGlobalSettingCheckFirebirdConnect.btnSaveFirebirdSettingsClick(
  Sender: TObject);
 var
 id:Integer;
 resultat:Boolean;
begin
   if comboxServer.ItemIndex=-1 then begin
     MessageBox(Handle,PChar('�� ������ ������'),PChar('������'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   id:=comboxServer.ItemIndex;

   Screen.Cursor:=crHourGlass;
   resultat:=servers.GetCheckServerFirebird(ID);
   Screen.Cursor:=crDefault;

   if resultat  then begin
     MessageBox(Handle,PChar('�������� ����������� � �������:'+#13#13+servers.GetAddress(id)),PChar('�����'),MB_OK+MB_ICONINFORMATION);
   end
   else begin
     MessageBox(Handle,PChar('�� ������� ������������ � �������:'+#13#13+servers.GetAddress(id)),PChar('������'),MB_OK+MB_ICONERROR);
   end;
end;

procedure TFormGlobalSettingCheckFirebirdConnect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 servers.Free;
end;

procedure TFormGlobalSettingCheckFirebirdConnect.FormShow(Sender: TObject);
var
 i:Integer;
begin
  Screen.Cursor:=crHourGlass;
  servers:=TCheckServersIK.Create(False);

  // �������� combox
  comboxServer.Items.Clear;

  for i:=0 to servers.Count-1 do begin
    comboxServer.Items.Add(servers.GetAddress(i)+' ('+servers.GetIP(i)+')');
  end;

  comboxServer.ItemIndex:=-1;

  Screen.Cursor:=crDefault;
end;

end.
