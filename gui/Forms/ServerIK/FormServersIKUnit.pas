unit FormServersIKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, TCustomTypeUnit;

 const
  countEnumParseType:Word = 7;

  type    // тип разбора при парсинге
  enumParseType = (eIP,
                   eAlias,
                   eAddr,
                   eTypeClinic,
                   eShowSMS,
                   eWorkingTime,
                   eStatus);

type
  TFormServersIK = class(TForm)
    PanelServers: TPanel;
    btnAddServer: TBitBtn;
    btnEditUser: TBitBtn;
    btnDisable: TBitBtn;
    list_Servers: TListView;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAddServerClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDisableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure list_ServersClick(Sender: TObject);
    procedure list_ServersCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
  procedure ClearList;
  procedure LoadServers(var p_ListView:TListView);

  function ParseString(const p_ListView:TListItem;
                       const p_ListViewID:Integer;
                       typeParse:enumParseType;
                       var _errorDescription:string):Boolean;

  public
    { Public declarations }

  panel_Server_IP:string;
  panel_Server_addr:string;
  panel_Server_ID:Integer;
  panel_Server_Alias:string;
  panel_Server_TypeClinic:enumTypeClinic;
  panel_Server_ShowSMS:enumParamStatus;
  panel_Server_WorkingTime:enumParamStatus;
  panel_Server_Status:enumStatusJobClinic;

  procedure Show;

  end;

var
  FormServersIK: TFormServersIK;

implementation

uses
  FunctionUnit, FormServerIKEditUnit, GlobalVariables, GlobalVariablesLinkDLL;

{$R *.dfm}


function TFormServersIK.ParseString(const p_ListView:TListItem;
                                    const p_ListViewID:Integer;
                                    typeParse:enumParseType;
                                    var _errorDescription:string):Boolean;
var
  Lines: TArray<string>;
  i: Integer;
  stroka:string;
begin
  Result:=False;
  _errorDescription:='';

  stroka:=p_ListView.SubItems.Text;
  // Разделяем строку по символам #13 и #10
  Lines := stroka.Split([#13, #10], TStringSplitOptions.ExcludeEmpty);

  if Length(Lines) <> countEnumParseType then begin
    _errorDescription:='Ошибка разбора строки';
    Exit;
  end;

  panel_Server_ID:=p_ListViewID;

  // Обрабатываем строку
  case typeParse of
   eIP          : panel_Server_IP:=Lines[0];
   eAlias       : panel_Server_Alias:=Lines[1];
   eAddr        : panel_Server_addr:=Lines[2];
   eTypeClinic  : panel_Server_TypeClinic:=StringToEnumTypeClinic(Lines[3]);
   eShowSMS     : panel_Server_ShowSMS:=StringToSettingParamsStatus(Lines[4]);
   eWorkingTime : panel_Server_WorkingTime:=StringToSettingParamsStatus(Lines[5]);
   eStatus      : panel_Server_Status:=StringToEnumStatusJobClinic(Lines[6]);
  end;

  Result:=True;
end;

// очистка листа
procedure TFormServersIK.ClearList;
 const
 cWidth_default             :Word = 951;
 cProcentWidth_IP           :Word = 11;
 cProcentWidth_Alias        :Word = 13;
 cProcentWidth_Address      :Word = 29;
 cProcentWidth_Type         :Word = 10;
 cProcentWidth_ShowSMS      :Word = 14;
 cProcentWidth_WorkingTime  :Word = 10;
 cProcentWidth_Status       :Word = 11;

begin
   with list_Servers do begin
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
        Caption:='IP';
        Width:=Round((cWidth_default*cProcentWidth_IP)/100);
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='Alias';
        Width:=Round((cWidth_default*cProcentWidth_Alias)/100)-1;
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='Адрес';
        Width:=Round((cWidth_default*cProcentWidth_Address)/100);
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='Тип';
        Width:=Round((cWidth_default*cProcentWidth_Type)/100);
        Alignment:=taCenter;
      end;

      with Columns.Add do
      begin
        Caption:='Показывать в SMS';
        Width:=Round((cWidth_default*cProcentWidth_ShowSMS)/100);
        Alignment:=taCenter;
      end;

       with Columns.Add do
      begin
        Caption:='Время работы';
        Width:=Round((cWidth_default*cProcentWidth_WorkingTime)/100);
        Alignment:=taCenter;
      end;

       with Columns.Add do
      begin
        Caption:='Статус';
        Width:=Round((cWidth_default*cProcentWidth_Status)/100);
        Alignment:=taCenter;
      end;
   end;
end;


procedure TFormServersIK.Show;
begin
  // очищаем лист
  ClearList;

  // подгружаем сервера
  LoadServers(list_Servers);

  panel_Server_IP:='';
  panel_Server_addr:='';
  panel_Server_ID:=0;
  panel_Server_Alias:='';
  panel_Server_TypeClinic:=eOther;
  panel_Server_ShowSMS:=paramStatus_DISABLED;
  panel_Server_WorkingTime:=paramStatus_DISABLED;
  panel_Server_Status:=eOpen;
end;

// прогрузка серверов
procedure TFormServersIK.LoadServers(var p_ListView:TListView);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countServers,i:Integer;

 ListItem: TListItem;
 existingItem: TListItem;
 idToFind:Integer;

 id,ip,alias,address,type_clinik,showSMS,status:string;

begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     Screen.Cursor:=crDefault;
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(id) from server_ik ');
      Active:=True;

      countServers:=Fields[0].Value;
    end;


    with ado do begin

      SQL.Clear;
      SQL.Add('select id,ip,alias,address,type_clinik,showSMS,status from server_ik order by ip ASC');
      Active:=True;

       for i:=0 to countServers-1 do begin

          id          := VarToStr(Fields[0].Value);
          ip          := VarToStr(Fields[1].Value);
          alias       := VarToStr(Fields[2].Value);
          address     := VarToStr(Fields[3].Value);
          type_clinik := VarToStr(Fields[4].Value);
          showSMS     := VarToStr(Fields[5].Value);
          status      := VarToStr(Fields[6].Value);


         try
            idToFind := StrToInt(id); // Получаем id
            existingItem := nil;

            // Поиск существующего элемента
            for ListItem in p_ListView.Items do
            begin
              if ListItem.Caption = IntToStr(idToFind) then
              begin
                existingItem := ListItem;
                ado.Next;
                Continue;
              end;
            end;

            if existingItem = nil then
            begin
              // Элемент не найден, добавляем новый
              ListItem := p_ListView.Items.Add;
              ListItem.Caption := id; // id

              ListItem.SubItems.Add(ip);
              ListItem.SubItems.Add(alias);
              ListItem.SubItems.Add(address);
              ListItem.SubItems.Add(type_clinik);
              if showSMS = '0' then ListItem.SubItems.Add(EnumStatusToString(eNO));
              if showSMS = '1' then ListItem.SubItems.Add(EnumStatusToString(eYES));

              if IsServerIkExistWorkingTime(StrToInt(id)) then ListItem.SubItems.Add(EnumStatusToString(eYES))
              else ListItem.SubItems.Add(EnumStatusToString(eNO));

              if status = '0' then ListItem.SubItems.Add(EnumStatusJobClinicToString(eClose));
              if status = '1' then ListItem.SubItems.Add(EnumStatusJobClinicToString(eOpen));

            end;

         finally
           // ListViewQueue.Items.EndUpdate;
            //ListViewQueue.Visible := True;
         end;

         ado.Next;
       end;
    end;

  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;

  FormServersIK.Caption:='Сервера Инфоклиники ('+IntToStr(countServers)+')';
  Screen.Cursor:=crDefault;
end;

procedure TFormServersIK.btnAddServerClick(Sender: TObject);
begin
  FormServerIKEdit.ShowModal;
end;

procedure TFormServersIK.btnDisableClick(Sender: TObject);
var
 resultatDel:Word;
 error:string;
begin
  if (panel_Server_IP='') or
     (panel_Server_addr='') or
     (panel_Server_ID=0) or
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


  // удаляем
  if not FormServerIKEdit.getResponseBD(server_delete,
                                        panel_Server_ID,
                                        panel_Server_IP,
                                        panel_Server_addr,
                                        panel_Server_Alias,
                                        panel_Server_TypeClinic,
                                        panel_Server_ShowSMS,
                                        panel_Server_Status,
                                        error) then
  begin

    // не удалось
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;


  // прогружаем сервера
  Show;

  MessageBox(Handle,PChar('Сервер удален'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormServersIK.btnEditUserClick(Sender: TObject);
begin
  if (Length(panel_Server_IP) = 0) or
     (Length(panel_Server_addr)=0) or
     (panel_Server_ID=0) or
     (Length(panel_Server_Alias)=0)
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
    p_editTypeClinic:=panel_Server_TypeClinic;
    p_editShowSMS:=panel_Server_ShowSMS;
    p_editWorkingTime:=panel_Server_WorkingTime;
    p_editStatus:=panel_Server_Status;

    ShowModal;
  end;
end;

procedure TFormServersIK.Button1Click(Sender: TObject);
var
 id,ip,alias,address,type_clinik,showSMS,status:Integer;
begin
  with list_Servers do begin
     id:=Columns[0].Width;
     ip:=Columns[1].Width;
     alias:=Columns[2].Width;
     address:=Columns[3].Width;
     type_clinik:=Columns[4].Width;
     showSMS:=Columns[5].Width;
     status:=Columns[6].Width;
  end;

  ShowMessage('id = '+IntToStr(id)+#13+
              'ip = '+IntToStr(ip)+#13+
              'alias = '+IntToStr(alias)+#13+
              'address = '+IntToStr(address)+#13+
              'type_clinik ='+IntToStr(type_clinik)+#13+
              'showSMS = '+ IntToStr(showSMS)+#13+
              'status = '+IntToStr(status));

end;

procedure TFormServersIK.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  panel_Server_IP:='';
  panel_Server_addr:='';
  panel_Server_ID:=0;
  panel_Server_Alias:='';
  panel_Server_TypeClinic:=eOther;
  panel_Server_ShowSMS:=paramStatus_DISABLED;
  panel_Server_Status:=eOpen;
end;

procedure TFormServersIK.FormCreate(Sender: TObject);
begin
 SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;


procedure TFormServersIK.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  // загружаем параметры
  Show;

  Screen.Cursor:=crDefault;
end;

procedure TFormServersIK.list_ServersClick(Sender: TObject);
var
  SelectedItem: TListItem;
  error:string;
  i:Integer;
  parse:enumParseType;
  id:Integer;
begin
  // Получаем выбранный элемент
  SelectedItem := list_Servers.Selected;

  // Проверяем, выбран ли элемент
  if not Assigned(SelectedItem) then begin
   MessageBox(Handle,PChar('Не выбран сервер для редактирования'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  id:=StrToInt(SelectedItem.Caption);

  for i:=Ord(Low(enumParseType)) to Ord(High(enumParseType)) do
  begin
    parse:=enumParseType(i);
    if not ParseString(SelectedItem,id,parse,error) then begin
      MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Exit;
    end;
  end;
end;

procedure TFormServersIK.list_ServersCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
 counts:Integer;
 time_talk:Integer;
 test:string;
 longtalk:string;
begin
  if not Assigned(Item) then Exit;
  try
    counts:=Item.SubItems.Count;

    if Item.SubItems.Count = 6 then
    begin
      if Item.SubItems.Strings[5] = EnumStatusJobClinicToString(eClose) then
      begin
        Sender.Canvas.Font.Color := clRed;
        Exit;
      end;

     Sender.Canvas.Font.Color := clBlack;
     end;
  except
    on E:Exception do
    begin
     SharedMainLog.Save('TFormServersIK.list_ServersCustomDrawItem. '+e.ClassName+': '+e.Message, IS_ERROR);
    end;
  end;


end;


end.
