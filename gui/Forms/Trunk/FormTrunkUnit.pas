unit FormTrunkUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.ComCtrls, Data.Win.ADODB, Data.DB, IdException, FunctionUnit, TCustomTypeUnit;



type
  TFormTrunk = class(TForm)
    PanelTrunk: TPanel;
    listSG_Trunks_Footer: TStringGrid;
    listSG_Trunks: TStringGrid;
    btnAddServer: TBitBtn;
    btnEditUser: TBitBtn;
    btnDisable: TBitBtn;
    procedure LoadSettings;
    procedure FormShow(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure listSG_TrunksSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditUserClick(Sender: TObject);
    procedure btnDisableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  procedure LoadPanel_Trunk;

  public

  panel_Trunks_ID         :string;
  panel_Trunks_Alias      :string;
  panel_Trunks_Login      :string;
  panel_Trunks_Monitoring :enumMonitoringTrunk;
    { Public declarations }
  end;

var
  FormTrunk: TFormTrunk;

implementation

uses
  FormTrunkEditUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}

// прогрузка транков
procedure TFormTrunk.LoadPanel_Trunk;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countServers,i:Integer;
 error:string;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     ShowFormErrorMessage(error, SharedMainLog, 'TFormTrunk.LoadPanel_Trunk');
     FreeAndNil(ado);
     Exit;
  end;


  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(id) from sip_trunks');
      Active:=True;

      countServers:=Fields[0].Value;
    end;

    with FormTrunk.listSG_Trunks do begin
     RowCount:=countServers;

      with ado do begin

        SQL.Clear;
        SQL.Add('select id,alias,username,state,is_monitoring from sip_trunks');
        Active:=True;

         for i:=0 to countServers-1 do begin
            Cells[0,i]:=Fields[0].Value;
            Cells[1,i]:=Fields[1].Value;
            Cells[2,i]:=Fields[2].Value;

            if Fields[3].Value<>null then Cells[3,i]:=Fields[3].Value
            else Cells[3,i]:='опроса еще не было';

            if GetStatusMonitoring(StrToInt(Fields[4].Value)) = monitoring_ENABLE then Cells[4,i]:='Да'
            else Cells[4,i]:='Нет';

            ado.Next;
         end;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  FormTrunk.Caption:='Активные SIP транки ('+IntToStr(countServers)+')';
  Screen.Cursor:=crDefault;
end;


// прогрузка параметров
procedure TFormTrunk.LoadSettings;
begin
  // PanelTrunk
  begin
    listSG_Trunks_Footer.RowCount:=1;
    listSG_Trunks_Footer.Cells[0,0]:='ID';
    listSG_Trunks_Footer.Cells[1,0]:='Alias (Псевдоним)';
    listSG_Trunks_Footer.Cells[2,0]:='Login';
    listSG_Trunks_Footer.Cells[3,0]:='Статус';
    listSG_Trunks_Footer.Cells[4,0]:='Мониторится';


    panel_Trunks_ID:='';
    panel_Trunks_Alias:='';
    panel_Trunks_Login:='';
    panel_Trunks_Monitoring:=monitoring_DISABLE;


     // прогрузка списка транков
     LoadPanel_Trunk;
  end;
end;

procedure TFormTrunk.btnAddServerClick(Sender: TObject);
begin
  FormTrunkEdit.ShowModal;
end;



procedure TFormTrunk.btnDisableClick(Sender: TObject);
var
 resultat:string;
 resultatDel:Word;
begin
  if (panel_Trunks_ID='') and
     (panel_Trunks_Alias='') and
     (panel_Trunks_Login='')
  then
  begin
   // не удалось добавить
    MessageBox(Handle,PChar('Не выбран транк для удаления'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


 resultatDel:=MessageBox(Handle,PChar('Точно удалить '+#13+#13+
                                       panel_Trunks_Login+' ('+panel_Trunks_Alias+') ?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
 if resultatDel=mrNo then Exit;


  // пробуем добавить
  FormTrunkEdit.p_editID:=panel_Trunks_ID;

  resultat:=FormTrunkEdit.getResponseBD(server_delete,panel_Trunks_Alias,panel_Trunks_Login,monitoring_DISABLE);

  if AnsiPos('ОШИБКА',resultat)<>0  then begin
    // не удалось удалить
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // прогружаем транки
  LoadSettings;

  MessageBox(Handle,PChar('Транк удален'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormTrunk.btnEditUserClick(Sender: TObject);
begin
 if (panel_Trunks_ID='') and
    (panel_Trunks_Alias='') and
    (panel_Trunks_Login='')
  then
  begin
   // не удалось добавить
    MessageBox(Handle,PChar('Не выбран транк для редактирования'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // редактирем сервер
  with FormTrunkEdit do begin
    isEditForm:=True;

    p_editID:=panel_Trunks_ID;
    p_editAlias:=panel_Trunks_Alias;
    p_editLogin:=panel_Trunks_Login;
    p_edtMonitoring:=panel_Trunks_Monitoring;

    ShowModal;
  end;
end;

procedure TFormTrunk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  panel_Trunks_ID:='';
  panel_Trunks_Alias:='';
  panel_Trunks_Login:='';
  panel_Trunks_Monitoring:=monitoring_DISABLE;
end;

procedure TFormTrunk.FormCreate(Sender: TObject);
begin
 SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TFormTrunk.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  // загружаем параметры
  LoadSettings;

  Screen.Cursor:=crDefault;
end;

procedure TFormTrunk.listSG_TrunksSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
  var
  id,alias,login,monitoring:string;
begin
   id:=listSG_Trunks.Cells[0,ARow];
   alias:=listSG_Trunks.Cells[1,ARow];
   login:=listSG_Trunks.Cells[2,ARow];
   monitoring:=listSG_Trunks.Cells[4,ARow];

 // глобальные параметры
  panel_Trunks_ID:=id;
  panel_Trunks_Alias:=alias;
  panel_Trunks_Login:=login;
  if monitoring='Да' then panel_Trunks_Monitoring:=monitoring_ENABLE
  else panel_Trunks_Monitoring:=monitoring_DISABLE;
end;

end.
