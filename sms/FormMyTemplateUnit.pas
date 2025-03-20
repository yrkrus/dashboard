unit FormMyTemplateUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.Grids,
  Vcl.ComCtrls, Data.DB, Vcl.DBGrids, Data.Win.ADODB, System.ImageList,
  Vcl.ImgList;

type
  TFormMyTemplate = class(TForm)
    Label1: TLabel;
    PopupMenu: TPopupMenu;
    menu_edit: TMenuItem;
    menu_del: TMenuItem;
    N2: TMenuItem;
    page_Template: TPageControl;
    sheet_MyTemplate: TTabSheet;
    sheet_GlobalTemplate: TTabSheet;
    st_NoMessage_MyTemplate: TStaticText;
    st_NoMessage_GlobalTemplate: TStaticText;
    list_MyTemplate: TListView;
    list_GlobalTemplate: TListView;
    editFindMessage: TEdit;
    st_FindMessage: TStaticText;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure list_MyTemplateDblClick(Sender: TObject);
    procedure list_GlobalTemplateDblClick(Sender: TObject);
    procedure menu_editClick(Sender: TObject);
    procedure list_MyTemplateMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure list_GlobalTemplateMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure menu_delClick(Sender: TObject);




  private
    { Private declarations }
  SelectedItemPopMenu: TListItem; // ���������� ��� �������� ���������� ��������
  public
    { Public declarations }
   procedure ShowData;

  end;

var
  FormMyTemplate: TFormMyTemplate;

implementation

uses
  GlobalVariables, FunctionUnit, FormEditTemplateUnit;

{$R *.dfm}

procedure  TFormMyTemplate.ShowData;
begin
   Screen.Cursor:=crHourGlass;

   // ���������� ����������� ���������
   ShowSaveTemplateMessage(page_Template,list_MyTemplate,template_my,st_NoMessage_MyTemplate);
   ShowSaveTemplateMessage(page_Template,list_GlobalTemplate,template_global,st_NoMessage_GlobalTemplate);

   // ��������� �������
   page_Template.ActivePage:=sheet_MyTemplate;

   Screen.Cursor:=crDefault;
end;

procedure TFormMyTemplate.FormCreate(Sender: TObject);
begin
 SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;


procedure TFormMyTemplate.FormShow(Sender: TObject);
begin
  ShowData;
end;


procedure TFormMyTemplate.list_GlobalTemplateDblClick(Sender: TObject);
var
  SelectedItem: TListItem;
begin
  // �������� ��������� �������
  SelectedItem := list_GlobalTemplate.Selected;

  // ���������, ������ �� �������
  if Assigned(SelectedItem) then
  begin
     AddMessageFromTemplate(SelectedItem.SubItems.Text);
     Close;
  end
  else
  begin
    MessageBox(Handle,PChar('�� ������� ��������� �� �������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

procedure TFormMyTemplate.list_GlobalTemplateMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   // ���������, ��� �� ���� ������ ������� ����
  if Button = mbRight then
  begin
    // �������� �������, �� ������� ��������
    SelectedItemPopMenu := list_GlobalTemplate.GetItemAt(X, Y);
  end;
end;

procedure TFormMyTemplate.list_MyTemplateDblClick(Sender: TObject);
var
  SelectedItem: TListItem;
begin
  // �������� ��������� �������
  SelectedItem := list_MyTemplate.Selected;

  // ���������, ������ �� �������
  if Assigned(SelectedItem) then
  begin
     AddMessageFromTemplate(SelectedItem.SubItems.Text);
     Close;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������� ��������� �� �������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

procedure TFormMyTemplate.list_MyTemplateMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // ���������, ��� �� ���� ������ ������� ����
  if Button = mbRight then
  begin
    // �������� �������, �� ������� ��������
    SelectedItemPopMenu := list_MyTemplate.GetItemAt(X, Y);
  end;
end;

procedure TFormMyTemplate.menu_delClick(Sender: TObject);
var
 isGlobal:Boolean;
 resultat:Word;
begin
 // ���������� �� ������
 if page_Template.ActivePage = sheet_GlobalTemplate then isGlobal:=True
 else isGlobal:=False;

 // ���������, ��� �� ������ �������
  if Assigned(SelectedItemPopMenu) then
  begin
    // ��������� ������ �� ������������ � ������ ������� ����� ������������� ���������� �������
    if isGlobal then begin
     if not USER_ACCESS_SENDING_LIST then begin
       MessageBox(Handle,PChar('���������� ������ ����� ������������� ������ "������� ��������"'),PChar('������'),MB_OK+MB_ICONERROR);
       Exit;
     end;
    end;

    resultat:=MessageBox(Handle,PChar('����� ������� ������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
    if resultat=mrYes then begin
      SaveMyTemplateMessage(StrToInt(SelectedItemPopMenu.Caption),'',True);
      // ��������� ������
      FormMyTemplate.ShowData;
      Exit;
    end;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������� ��������� �� �������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

procedure TFormMyTemplate.menu_editClick(Sender: TObject);
var
 isGlobal:Boolean;
begin
 // ���������� �� ������
 if page_Template.ActivePage = sheet_GlobalTemplate then isGlobal:=True
 else isGlobal:=False;

 // ���������, ��� �� ������ �������
  if Assigned(SelectedItemPopMenu) then
  begin
    // ��������� ������ �� ������������ � ������ ������� ����� ������������� ���������� �������
    if isGlobal then begin
     if not USER_ACCESS_SENDING_LIST then begin
       MessageBox(Handle,PChar('���������� ������ ����� ������������� ������ "������� ��������"'),PChar('������'),MB_OK+MB_ICONERROR);
       Exit;
     end;
    end;

     FormEditTemplate.ShowEditMessage(StrToInt(SelectedItemPopMenu.Caption),SelectedItemPopMenu.SubItems.Text, isGlobal );
     FormEditTemplate.ShowModal;
  end
  else
  begin
   MessageBox(Handle,PChar('�� ������� ��������� �� �������'),PChar('������'),MB_OK+MB_ICONERROR);
  end;
end;

end.
