unit FormPhoneListAddUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, TPhoneListUnit,
  Vcl.ExtCtrls;

type
  TFormPhoneListAdd = class(TForm)
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    edtNamePC: TEdit;
    edtPhoneIP: TEdit;
    chkboxCloseForm: TCheckBox;
    panel: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
   m_phoneList:TPhoneList;

   is_edit:Boolean; // форма для редактирования
   m_id_edit:Integer;

  function CheckFields(var _errorDescription:string):Boolean; // проверка полей

  function Add(var _errorDescription:string):Boolean;
  function Update(var _errorDescription:string):Boolean;
  procedure Clear;
  procedure LoadFormCaption(_is_edit:Boolean);

  public
    { Public declarations }

  procedure SetEdit(_value:Boolean; _id:Integer = 0); // форма для редактирования

  end;

var
  FormPhoneListAdd: TFormPhoneListAdd;

implementation

uses
  FormPhoneListUnit;

{$R *.dfm}

procedure TFormPhoneListAdd.LoadFormCaption(_is_edit:Boolean);
const
 cButtonLeft:Word = 50;
 cButtonTop:Word = 108;
begin
  case _is_edit of
    false: begin   // добавление нового номера
       Caption:='Добавление нового номера';
       chkboxCloseForm.Caption:='закрыть окно после добавления';
       chkboxCloseForm.Enabled:=True;
       chkboxCloseForm.Checked:=False;

       btnAdd.Left:=cButtonLeft;
       btnAdd.Top:=cButtonTop;
       btnAdd.Visible:=True;

       btnEdit.Visible:=False;
    end;
    true:begin     // редактирование
       Caption:='Редактирование номера';
       chkboxCloseForm.Caption:='закрыть окно после редактирования';
       chkboxCloseForm.Enabled:=False;
       chkboxCloseForm.Checked:=True;

       btnEdit.Left:=cButtonLeft;
       btnEdit.Top:=cButtonTop;
       btnEdit.Visible:=True;

       btnAdd.Visible:=False;
    end;
  end;
end;

procedure TFormPhoneListAdd.SetEdit(_value:Boolean; _id:Integer);
begin
  is_edit:=_value;
  m_id_edit:=_id;
end;


function TFormPhoneListAdd.CheckFields(var _errorDescription:string):Boolean;
begin
  Result:=False;
  _errorDescription:='';

   if edtNamePC.Text='' then begin
     _errorDescription:='ОШИБКА! Не заполнено поле "Имя ПК"';
     Exit;
   end;

   if edtPhoneIP.Text='' then begin
     _errorDescription:='ОШИБКА! Не заполнено поле "IP телефона"';
     Exit;
   end;

   Result:=True;
end;

function TFormPhoneListAdd.Add(var _errorDescription:string):Boolean;
var
 namePC, IPPhone, IPpc:string;
begin
  Result:=False;

  namePC:=edtNamePC.Text;
  IPPhone:=edtPhoneIP.Text;

  if not m_phoneList.Insert(namePC,IPPhone,_errorDescription) then Exit;

  Result:=True;
end;

function TFormPhoneListAdd.Update(var _errorDescription:string):Boolean;
var
 namePC, IPPhone, IPpc:string;
begin
  Result:=False;

  namePC:=edtNamePC.Text;
  IPPhone:=edtPhoneIP.Text;

  if not m_phoneList.Update(m_id_edit, namePC,IPPhone,_errorDescription) then Exit;

  Result:=True;
end;


procedure TFormPhoneListAdd.btnAddClick(Sender: TObject);
var
 error:string;
begin
  if not CheckFields(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if not Add(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // обновим родительскую форму
  FormPhoneList.UpdateDataForm;


  if chkboxCloseForm.Checked then Close
  else Clear;
end;

procedure TFormPhoneListAdd.btnEditClick(Sender: TObject);
var
 error:string;
begin
  if not CheckFields(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  if not Update(error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // обновим родительскую форму
  FormPhoneList.UpdateDataForm;

  if chkboxCloseForm.Checked then Close
  else Clear;
end;

procedure TFormPhoneListAdd.Clear;
begin
  edtNamePC.Text:='';
  edtPhoneIP.Text:='';

  chkboxCloseForm.Checked:=False;
  chkboxCloseForm.Enabled:=True;
end;

procedure TFormPhoneListAdd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Clear;
end;

procedure TFormPhoneListAdd.FormShow(Sender: TObject);
begin

  // подгрузка
  LoadFormCaption(is_edit);

  if not Assigned(m_phoneList) then m_phoneList:=TPhoneList.Create
  else m_phoneList.UpdateData;

  if is_edit then begin
    edtNamePC.Text:=m_phoneList.ItemsData[m_id_edit].m_namePC;
    edtPhoneIP.Text:=m_phoneList.ItemsData[m_id_edit].m_phoneIP;
  end;

end;

end.
