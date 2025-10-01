unit FormSipPhoneListUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, TSipPhoneListUnit;

type
  TFormSipPhoneList = class(TForm)
    panel_sip: TPanel;
    list_sip: TListView;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    st_NoSip: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure list_sipMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  m_sipList:  TSipPhoneList;
  SelectedItemPopMenu: TListItem; // ���������� ��� �������� ���������� ��������

  procedure ShowData;
  procedure ClearListView(var p_ListView:TListView);
  procedure AddListItem(var p_ListView: TListView; const _sipList:TSipPhoneList);


  public
    { Public declarations }
  procedure NeedUpdateData; // ����� �������� ������ �� sip

  end;

var
  FormSipPhoneList: TFormSipPhoneList;

implementation

uses
  FormSipPhoneListAddUnit;


{$R *.dfm}


procedure TFormSipPhoneList.AddListItem(var p_ListView: TListView; const _sipList:TSipPhoneList);
var
  ListItem: TListItem;
  i:Integer;
begin
  for i:=0 to _sipList.Count-1 do begin
    ListItem := p_ListView.Items.Add;

    ListItem.Caption := IntToStr(_sipList.Items[i].m_id);         // id
    ListItem.SubItems.Add(IntToStr(_sipList.Items[i].m_sip));     // sip

    if _sipList.Items[i].m_userId <> -1 then begin
      ListItem.SubItems.Add(_sipList.Items[i].m_fio);     // �� ��� ���������
    end
    else ListItem.SubItems.Add('���������');
  end;
end;


// ������� ��� ������
procedure TFormSipPhoneList.btnAddClick(Sender: TObject);
begin
  FormSipPhoneListAdd.ShowModal;
end;

procedure TFormSipPhoneList.btnDeleteClick(Sender: TObject);
var
 sip:string;
 error:string;
 resultatDel:Word;
begin
  // ���������, ��� �� ������ �������
  if Assigned(SelectedItemPopMenu) then
  begin
    sip:=SelectedItemPopMenu.SubItems[0];
    resultatDel:=MessageBox(Handle,PChar('����� ������� SIP '+sip+'?'),PChar('���������'),MB_YESNO+MB_ICONWARNING);
    if resultatDel=mrNo then Exit;

    if not m_sipList.Delete(sip,error) then MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR)
    else begin
      MessageBox(Handle,PChar('SIP '+sip+' ������'),PChar('������'),MB_OK+MB_ICONINFORMATION);
      NeedUpdateData;
    end;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������ SIP �����'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

// ����� �������� ������ �� sip
procedure TFormSipPhoneList.NeedUpdateData;
begin
  ShowData;
end;

procedure TFormSipPhoneList.ClearListView(var p_ListView:TListView);
const
 cWidth_default       :Word = 330;
 cWidth_sip           :Word = 30;
 cWidth_fio           :Word = 64;
begin
 with p_ListView do begin

    Items.Clear;
    Columns.Clear;
    ViewStyle:= vsReport;

    with Columns.Add do
    begin
      Caption:='ID';
      Width:=0;
    end;

    with Columns.Add do
    begin
      Caption:='SIP';
      Width:=Round((cWidth_default*cWidth_sip)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' �� ��� ��������� ';
      Width:=Round((cWidth_default*cWidth_fio)/100);
      Alignment:=taCenter;
    end;
 end;
end;

procedure TFormSipPhoneList.ShowData;
begin
  // ������� ��� ������
  ClearListView(list_sip);

  if not Assigned(m_sipList) then m_sipList:=TSipPhoneList.Create
  else m_sipList.UpdateData;

  Caption:='������ SIP ������� ���������� ['+IntToStr(m_sipList.Count)+']';

  if m_sipList.Count>0 then st_NoSip.Visible:=False
  else st_NoSip.Visible:=True;


  AddListItem(list_sip,m_sipList);
end;


procedure TFormSipPhoneList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  btnDelete.Enabled:=False;
end;

procedure TFormSipPhoneList.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  ShowData;

  Screen.Cursor:=crDefault;
end;

procedure TFormSipPhoneList.list_sipMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedItemPopMenu := list_sip.GetItemAt(X, Y);

  // ����� �������� �� ���������\����������
  if Button = mbLeft then begin
   btnDelete.Enabled:=True;
  end;
end;

end.
