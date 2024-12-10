unit FormServersIKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException;

type
  TFormServersIK = class(TForm)
    PanelServers: TPanel;
    listSG_Servers_Footer: TStringGrid;
    listSG_Servers: TStringGrid;
    btnAddServer: TBitBtn;
    btnEditUser: TBitBtn;
    btnDisable: TBitBtn;
    procedure LoadSettings;
    procedure FormShow(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure listSG_ServersSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnEditUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDisableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  panel_Server_IP:string;
  panel_Server_addr:string;
  panel_Server_ID:string;
  panel_Server_Alias:string;


  end;

var
  FormServersIK: TFormServersIK;

implementation

uses
  FunctionUnit, FormServerIKEditUnit, GlobalVariables;

{$R *.dfm}


// прогрузка серверов
procedure loadPanel_Servers;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countServers,i:Integer;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from server_ik ');
    Active:=True;

    countServers:=Fields[0].Value;
  end;

  with FormServersIK.listSG_Servers do begin
   RowCount:=countServers;

    with ado do begin

      SQL.Clear;
      SQL.Add('select id,ip,alias,address from server_ik order by ip ASC');
      Active:=True;

       for i:=0 to countServers-1 do begin
          Cells[0,i]:=Fields[0].Value;
          Cells[1,i]:=Fields[1].Value;
          Cells[2,i]:=Fields[2].Value;
          Cells[3,i]:=Fields[3].Value;

         Next;
       end;
    end;
  end;

  FormServersIK.Caption:='Сервера Инфоклиники ('+IntToStr(countServers)+')';

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;

// прогрузка параметров
procedure TFormServersIK.LoadSettings;
begin
  // PanelServers
  begin
    listSG_Servers_Footer.RowCount:=1;
    listSG_Servers_Footer.Cells[0,0]:='ID';
    listSG_Servers_Footer.Cells[1,0]:='IP';
    listSG_Servers_Footer.Cells[2,0]:='Alias';
    listSG_Servers_Footer.Cells[3,0]:='Адрес';

    panel_Server_IP:='';
    panel_Server_addr:='';
    panel_Server_ID:='';
    panel_Server_Alias:='';

     // прогрузка списка серверов
    loadPanel_Servers;
  end;
end;



procedure TFormServersIK.btnAddServerClick(Sender: TObject);
begin
  FormServerIKEdit.ShowModal;
end;

procedure TFormServersIK.btnDisableClick(Sender: TObject);
var
 resultat:string;
 resultatDel:Word;
begin
  if (panel_Server_IP='') and
     (panel_Server_addr='') and
     (panel_Server_ID='') and
     (panel_Server_Alias='')
  then
  begin
   // не удалось добавить
    MessageBox(Handle,PChar('Не выбран сервер для удаления'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


 resultatDel:=MessageBox(Handle,PChar('Точно удалить '+#13+#13+
                                       panel_Server_IP+' ('+panel_Server_Alias+')'+#13+
                                       panel_Server_addr+'?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
 if resultatDel=mrNo then Exit;


  // пробуем добавить
  resultat:=FormServerIKEdit.getResponseBD(server_delete,panel_Server_IP,panel_Server_addr,panel_Server_Alias);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось добавить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем сервера
  LoadSettings;

  MessageBox(Handle,PChar('Сервер удален'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormServersIK.btnEditUserClick(Sender: TObject);
begin
  if (panel_Server_IP='') and
     (panel_Server_addr='') and
     (panel_Server_ID='') and
     (panel_Server_Alias='')
      then
  begin
   // не удалось добавить
    MessageBox(Handle,PChar('Не выбран сервер для редактирования'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  // редактирем сервер
  with FormServerIKEdit do begin
    isEditForm:=True;
    p_editIP:=panel_Server_IP;
    p_editAddress:=panel_Server_addr;
    p_editID:=panel_Server_ID;
    p_editAlias:=panel_Server_Alias;

    ShowModal;
  end;
end;

procedure TFormServersIK.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  panel_Server_IP:='';
  panel_Server_addr:='';
  panel_Server_ID:='';
  panel_Server_Alias:='';
end;

procedure TFormServersIK.FormCreate(Sender: TObject);
begin
 SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormServersIK.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  // загружаем параметры
  LoadSettings;

  Screen.Cursor:=crDefault;

end;

procedure TFormServersIK.listSG_ServersSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
ip,addr,id,alias:string;
begin
   id:=listSG_Servers.Cells[0,ARow];
   ip:=listSG_Servers.Cells[1,ARow];
   alias:=listSG_Servers.Cells[2,ARow];
   addr:=listSG_Servers.Cells[3,ARow];

 // глобальные параметры
  panel_Server_ID:=id;
  panel_Server_IP:=ip;
  panel_Server_addr:=addr;
  panel_Server_Alias:=alias
end;

end.
