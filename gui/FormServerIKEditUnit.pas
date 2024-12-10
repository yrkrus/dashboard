unit FormServerIKEditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus;

type                                    // тип запроса
   TypeResponse_Server = (server_add,
                          server_delete,
                          server_edit
                          );

type
  TFormServerIKEdit = class(TForm)
    btnAdd: TBitBtn;
    Label8: TLabel;
    edtIP: TEdit;
    Label1: TLabel;
    edtAddress: TEdit;
    btnEdit: TBitBtn;
    chkboxCloseWindow: TCheckBox;
    Label2: TLabel;
    edtAlias: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    function getResponseBD(InTypePanel_Server:TypeResponse_Server;InIP,InAddr,InAlias:string):string;
  private
    { Private declarations }
  public
    { Public declarations }
    isEditForm:Boolean; // редактируется ли сервер сейчас
    p_editIP,p_editAddress,p_editID,p_editAlias:string;

  end;

var
  FormServerIKEdit: TFormServerIKEdit;

implementation

uses
  FunctionUnit, FormServersIKUnit, GlobalVariables;


{$R *.dfm}
function TFormServerIKEdit.getResponseBD(InTypePanel_Server:TypeResponse_Server;InIP,InAddr,InAlias:string):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    case InTypePanel_Server of
      server_add:begin
        SQL.Add('insert into server_ik (ip,address,alias) values ('+#39+InIP+#39+','+#39+InAddr+#39+','+#39+InAlias+#39+')');
      end;
      server_delete:begin
        SQL.Add('delete from server_ik where ip='+#39+InIP+#39+' and address='+#39+InAddr+#39+' and alias = '+#39+InAlias+#39);
      end;
      server_edit: begin
         SQL.Add('update server_ik set ip = '+#39+InIP+#39
                                            +', address = '+#39+InAddr+#39
                                            +', alias = '+#39+InAlias+#39
                                            +' where id = '+#39+FormServerIKEdit.p_editID+#39);
      end;
    end;

    try
        ExecSQL;
    except
        on E:EIdException do begin
           Screen.Cursor:=crDefault;
           CodOshibki:=e.Message;
           Result:='ОШИБКА! '+CodOshibki;
           FreeAndNil(ado);
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
  Screen.Cursor:=crDefault;
  Result:='OK';
end;


function getCheckFileds:string;
begin
  Result:='OK';

  with FormServerIKEdit do begin
    if edtIP.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле "IP"';
       Exit;
    end;

    if edtAddress.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле "Адрес"';
       Exit;
    end;

    if edtAlias.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле "Alias"';
       Exit;
    end;

   // проверка IP
   if not getCheckIP(edtIP.Text) then begin
     Result:='ОШИБКА! Не корректный IP адрес';
     Exit;
   end;

   // проверка alias
   {if getCheckAlias(edtAlias.Text) then begin
     Result:='ОШИБКА! Такой Alias уже существует';
     Exit;
   end; }

  end;
end;


// очистка данных
procedure clearPanel;
begin
  with FormServerIKEdit do begin
     edtIP.Text:='';
     edtAddress.Text:='';
     edtAlias.Text:='';
  end;
end;



procedure TFormServerIKEdit.btnAddClick(Sender: TObject);
var
 resultat:string;
 ip,addr,alias:string;

begin
   resultat:=getCheckFileds;
   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   ip:=edtIP.Text;
   addr:=edtAddress.Text;
   alias:=edtAlias.Text;

  // пробуем добавить
  resultat:=getResponseBD(server_add,ip,addr,alias);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем сервера
  FormServersIK.LoadSettings;

  if chkboxCloseWindow.Checked then Close
  else clearPanel;

end;

procedure TFormServerIKEdit.btnEditClick(Sender: TObject);
var
 resultat:string;
 ip,addr,alias:string;

begin
   resultat:=getCheckFileds;
   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   ip:=edtIP.Text;
   addr:=edtAddress.Text;
   alias:=edtAlias.Text;

  // пробуем добавить
  resultat:=getResponseBD(server_edit,ip,addr,alias);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем сервера
  FormServersIK.LoadSettings;

  if chkboxCloseWindow.Checked then Close
  else clearPanel;

end;

procedure TFormServerIKEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  isEditForm:=False;
  p_editIP:='';
  p_editAddress:='';
  p_editID:='';
  p_editAlias:='';

  FormServersIK.panel_Server_IP:='';
  FormServersIK.panel_Server_addr:='';
  FormServersIK.panel_Server_ID:='';
  FormServersIK.panel_Server_Alias:='';
end;

procedure TFormServerIKEdit.FormShow(Sender: TObject);
const
 cLeftButton:Word = 569;
begin
   if not isEditForm then begin  // новое добавление
     // очищаем данные
     clearPanel;

     btnAdd.Left:=cLeftButton;
     btnAdd.Visible:=True;
     btnEdit.Visible:=False;

     chkboxCloseWindow.Caption:='закрыть окно после добавления';
     chkboxCloseWindow.Enabled:=True;

    Caption:='Добавление сервера';

   end
   else begin             // редактируется

     edtIP.Text:=p_editIP;
     edtAddress.Text:=p_editAddress;
     edtAlias.Text:=p_editAlias;

     btnEdit.Left:=cLeftButton;
     btnAdd.Visible:=False;
     btnEdit.Visible:=True;

     chkboxCloseWindow.Caption:='закрыть окно после редактирования';
     chkboxCloseWindow.Enabled:=False;
     chkboxCloseWindow.Checked:=True;

     Caption:='Редактирование сервера '+p_editIP+' ('+p_editAlias+') '+p_editAddress;
   end;

end;

end.
