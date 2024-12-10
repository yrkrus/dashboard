unit FormTrunkEditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus, FunctionUnit, TCustomTypeUnit;

  type                                    // тип запроса
   TypeResponse_Server = (server_add,
                          server_delete,
                          server_edit
                          );

type
  TFormTrunkEdit = class(TForm)
    Label8: TLabel;
    Label1: TLabel;
    btnAdd: TBitBtn;
    edtAlias: TEdit;
    edtLogin: TEdit;
    btnEdit: TBitBtn;
    chkboxMonitoring: TCheckBox;
    procedure btnAddClick(Sender: TObject);
    function getResponseBD(InTypePanel_Server:TypeResponse_Server; InAlias,InLogin:string; InStatus:enumMonitoringTrunk):string;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    isEditForm:Boolean; // редактируется ли сейчас
    p_editAlias,p_editLogin, p_editID:string;
    p_edtMonitoring:enumMonitoringTrunk;
    { Public declarations }
  end;

var
  FormTrunkEdit: TFormTrunkEdit;
  function getCheckFileds:string;

implementation



uses
  FormTrunkUnit, GlobalVariables;

{$R *.dfm}

// очистка данных
procedure clearPanel;
begin
  with FormTrunkEdit do begin
     edtAlias.Text:='';
     edtLogin.Text:='';
     chkboxMonitoring.Checked:=False;

     isEditForm:=False;
     p_editAlias:='';
     p_editLogin:='';
     p_editID:='';
     p_edtMonitoring:=monitoring_DISABLE;
  end;
end;


procedure TFormTrunkEdit.btnEditClick(Sender: TObject);
var
 resultat:string;
 alias,login:string;
 monitoring:enumMonitoringTrunk;
begin
   resultat:=getCheckFileds;
   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   alias:=edtAlias.Text;
   login:=edtLogin.Text;
   if chkboxMonitoring.Checked then monitoring:=monitoring_ENABLE
   else monitoring:=monitoring_DISABLE;

  // пробуем добавить
  resultat:=getResponseBD(server_edit,alias,login,monitoring);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем транки
  FormTrunk.LoadSettings;

  clearPanel;
  Close;
end;

procedure TFormTrunkEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  clearPanel;
end;

procedure TFormTrunkEdit.FormShow(Sender: TObject);
const
 cLeftButton:Word = 445;
begin
   if not isEditForm then begin  // новое добавление
     // очищаем данные
     clearPanel;

     btnAdd.Left:=cLeftButton;
     btnAdd.Visible:=True;
     btnEdit.Visible:=False;

     chkboxMonitoring.Checked:=True;

     Caption:='Добавление нового транка';

   end
   else begin             // редактируется

     edtAlias.Text:=p_editAlias;
     edtLogin.Text:=p_editLogin;

     btnEdit.Left:=cLeftButton;
     btnAdd.Visible:=False;
     btnEdit.Visible:=True;


     chkboxMonitoring.Enabled:=True;
     if p_edtMonitoring = monitoring_ENABLE then chkboxMonitoring.Checked:=True
     else chkboxMonitoring.Checked:=False;

     Caption:='Редактирование транка '+p_editLogin+' ('+p_editAlias+')';
   end;

end;

function TFormTrunkEdit.getResponseBD(InTypePanel_Server:TypeResponse_Server;InAlias,InLogin:string; InStatus:enumMonitoringTrunk):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 monitoring:Integer;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  if InStatus=monitoring_ENABLE then monitoring:=1
  else monitoring:=0;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    case InTypePanel_Server of
      server_add:begin
        SQL.Add('insert into sip_trunks (alias,username,is_monitoring) values ('+#39+InAlias+#39+','+#39+InLogin+#39+','+#39+IntToStr(monitoring)+#39+')');
      end;
      server_delete:begin
        SQL.Add('delete from sip_trunks where id='+#39+FormTrunkEdit.p_editID+#39);
      end;
      server_edit: begin
         SQL.Add('update sip_trunks set alias = '+#39+InAlias+#39
                                            +', username = '+#39+InLogin+#39
                                            +', is_monitoring = '+#39+IntToStr(monitoring)+#39
                                            +' where id = '+#39+FormTrunkEdit.p_editID+#39);
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

// проверка вдруг сущеммтвует уже такой логин
function getExistLogin(InLogin:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
 Result:=False;

 ado:=TADOQuery.Create(nil);
 serverConnect:=createServerConnect;
 if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from sip_trunks where username = '+#39+InLogin+#39);
    Active:=True;

    if Fields[0].Value=0 then Result:=False
    else Result:=True;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
end;


function getCheckFileds:string;
begin
  Result:='OK';

  with FormTrunkEdit do begin
    if edtAlias.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле "Alias"';
       Exit;
    end;

    if edtLogin.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле "Login"';
       Exit;
    end;

    if not isEditForm then begin
      if getExistLogin(edtLogin.Text) then begin
         Result:='ОШИБКА! Такой sip уже добавлен';
         Exit;
      end;
    end;

  end;
end;

procedure TFormTrunkEdit.btnAddClick(Sender: TObject);
var
 resultat:string;
 alias:string;
 login:string;
 monitoring:enumMonitoringTrunk;
begin
   resultat:=getCheckFileds;
   if AnsiPos('ОШИБКА!',resultat)<>0 then begin
     MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
     Exit;
   end;

   alias:=edtAlias.Text;
   login:=edtLogin.Text;
   if chkboxMonitoring.Checked then  monitoring:=monitoring_ENABLE
   else monitoring:=monitoring_DISABLE;

  // пробуем добавить
  resultat:=getResponseBD(server_add,alias,login,monitoring);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем транки
  FormTrunk.LoadSettings;

  //  очищаем форму
  clearPanel;

end;

end.
