unit FormPhoneListUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, TPhoneListUnit;

type
  TFormPhoneList = class(TForm)
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    panel_phone: TPanel;
    list_phone: TListView;
    st_NoPhone: TStaticText;
    btnEdit: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure list_phoneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
   m_phoneList:TPhoneList;
   SelectedItem: TListItem; // ���������� ��� �������� ���������� ��������

    procedure ShowData;
    procedure ClearListView(var p_ListView:TListView);
    procedure AddListItem(var p_ListView: TListView; const _phoneList:TPhoneList);

  public
    { Public declarations }
  procedure UpdateDataForm; // ����������� ������ �� �����

  end;

var
  FormPhoneList: TFormPhoneList;

implementation

uses
  FormPhoneListAddUnit;



{$R *.dfm}


// ����������� ������ �� �����
procedure TFormPhoneList.UpdateDataForm;
begin
 ShowData;
end;

procedure TFormPhoneList.AddListItem(var p_ListView: TListView; const _phoneList:TPhoneList);
var
  ListItem: TListItem;
  i:Integer;
begin
  for i:=0 to _phoneList.Count-1 do begin
    ListItem := p_ListView.Items.Add;

    ListItem.Caption := IntToStr(_phoneList.Items[i].m_id);  // id
    ListItem.SubItems.Add(_phoneList.Items[i].m_namePC);     // ��� ��
    ListItem.SubItems.Add(_phoneList.Items[i].m_phoneIP);    // ip ��������
    ListItem.SubItems.Add(_phoneList.Items[i].m_pcIP);       // ip ��

    if _phoneList.Items[i].m_sip <> -1 then begin
      ListItem.SubItems.Add(IntToStr(_phoneList.Items[i].m_sip));     // ������� ������������ sip
    end
    else ListItem.SubItems.Add('---');
  end;
end;


procedure TFormPhoneList.btnAddClick(Sender: TObject);
begin
  with FormPhoneListAdd do begin
   SetEdit(false);
   ShowModal;
  end;
end;

procedure TFormPhoneList.btnDeleteClick(Sender: TObject);
var
 resultat:Word;
 error:string;
begin

   if not Assigned(SelectedItem) then begin
    MessageBox(Handle,PChar('�� ������� ������'),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
   end;

   resultat:=MessageBox(Handle,PChar('����� ������� '+#13
                                      + m_phoneList.ItemsData[StrToInt(SelectedItem.Caption)].m_namePC+'?'),PChar('���������'),MB_YESNO+MB_ICONWARNING);
   if resultat=mrNo then Exit;

   if not m_phoneList.Delete(StrToInt(SelectedItem.Caption),error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
   end;

  // ��������� ����� ������
  UpdateDataForm;
  MessageBox(Handle,PChar('������ �������'),PChar('�������'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormPhoneList.btnEditClick(Sender: TObject);
begin
  if not Assigned(SelectedItem) then begin
   MessageBox(Handle,PChar('�� ������� ������'),PChar('������'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  with FormPhoneListAdd do begin
   SetEdit(True, StrToInt(SelectedItem.Caption));
   ShowModal;
  end;
end;

procedure TFormPhoneList.ClearListView(var p_ListView:TListView);
const
 cWidth_default       :Word = 540;
 cWidth_namePC        :Word = 14;
 cWidth_IPPhone       :Word = 18;
 cWidth_IPPC          :Word = 18;
 cWidth_ActiveSip     :Word = 49;
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
      Caption:=' ��� �� ';
      Width:=Round((cWidth_default*cWidth_namePC)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' IP �������� ';
      Width:=Round((cWidth_default*cWidth_IPPhone)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' IP �� ';
      Width:=Round((cWidth_default*cWidth_IPPC)/100);
      Alignment:=taCenter;
    end;

     with Columns.Add do
    begin
      Caption:=' �������� SIP ';
      Width:=Round((cWidth_default*cWidth_ActiveSip)/100);
      Alignment:=taCenter;
    end;
 end;
end;

procedure TFormPhoneList.ShowData;
begin
    // ������� ��� ������
  ClearListView(list_phone);

  if not Assigned(m_phoneList) then m_phoneList:=TPhoneList.Create
  else m_phoneList.UpdateData;

  Caption:='�������� IP ��������� ['+IntToStr(m_phoneList.Count)+']';

  if m_phoneList.Count>0 then st_NoPhone.Visible:=False
  else st_NoPhone.Visible:=True;


  AddListItem(list_phone,m_phoneList);
end;

procedure TFormPhoneList.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  ShowData;

  Screen.Cursor:=crDefault;
end;

procedure TFormPhoneList.list_phoneMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // �������� �������, �� ������� ��������
   SelectedItem:= list_phone.GetItemAt(X, Y);

   // ��������
   if Assigned(SelectedItem) then begin
     btnEdit.Enabled:=True;
     btnDelete.Enabled:=True;
   end
   else begin
    btnEdit.Enabled:=False;
    btnDelete.Enabled:=False;
   end;
end;

end.
