unit FormSettingsGlobal_listIVRUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Data.Win.ADODB, Data.DB, Vcl.ExtCtrls, IdException;

type
  TFormSettingsGlobal_listIVR = class(TForm)
    Panel: TPanel;
    listSG_List_Footer: TStringGrid;
    listSG_List: TStringGrid;
    btnDisable: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure listSG_ListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnDisableClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  currentID_del:string;

  public
    { Public declarations }
  end;

var
  FormSettingsGlobal_listIVR: TFormSettingsGlobal_listIVR;

implementation

uses
  FunctionUnit, FormSettingsGlobalUnit, GlobalVariables;

{$R *.dfm}


function getDeleteList(InID:string):string;
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
    SQL.Add('delete from settings where id='+#39+InID+#39);

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


procedure loadPanel_IVR;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countList,i:Integer;
begin
  Screen.Cursor:=crHourGlass;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
    SQL.Add('select count(id) from settings');

    Active:=True;

    countList:=Fields[0].Value;
  end;

  with FormSettingsGlobal_listIVR.listSG_List do begin
   RowCount:=1;      // типа очистка текущего списка
   RowCount:=countList;

    with ado do begin

      SQL.Clear;
      SQL.Add('select * from settings order by date_time DESC');

      Active:=True;

       for i:=0 to countList-1 do begin
         Cells[0,i]:=Fields[0].Value;  // id
         Cells[1,i]:=Fields[3].Value;  // дата добавление
         Cells[2,i]:=Fields[1].Value;  // 5000
         Cells[3,i]:=Fields[2].Value;  // 5050

         Next;
       end;

       FormSettingsGlobal_listIVR.Caption:='История корректировок: '+IntToStr(countList);
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  Screen.Cursor:=crDefault;
end;

procedure LoadSettings;
begin
   with FormSettingsGlobal_listIVR do begin

    with listSG_List_Footer do begin
     RowCount:=1;
     Cells[0,0]:='ID';
     Cells[1,0]:='Дата добавления';
     Cells[2,0]:='Очередь 5000';
     Cells[3,0]:='Очередь 5050';
    end;

    currentID_del:='';

   // прогрузка списка
   loadPanel_IVR;
  end;
end;

procedure TFormSettingsGlobal_listIVR.btnDisableClick(Sender: TObject);
var
resultat:Word;
resulatat_str:string;
begin

 if currentID_del='' then begin
    MessageBox(Handle,PChar('Не выбрана строка'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
 end;

 resultat:=MessageBox(Handle,PChar('Точно удалить?'),PChar('Уточнение'),MB_YESNO+MB_ICONWARNING);
 if resultat=mrNo then Exit;


  // удаляем
  resulatat_str:=getDeleteList(currentID_del);
  if AnsiPos('ОШИБКА',resulatat_str)<>0 then begin
    MessageBox(Handle,PChar(resultat),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // загружаем новые данные
  LoadSettings;
  FormSettingsGlobal.LoadSettings;
  currentID_del:='';

  MessageBox(Handle,PChar('Строка удалена'),PChar('Успешно'),MB_OK+MB_ICONINFORMATION);
end;

procedure TFormSettingsGlobal_listIVR.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  currentID_del:='';
end;

procedure TFormSettingsGlobal_listIVR.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  LoadSettings;

  Screen.Cursor:=crDefault;
end;

procedure TFormSettingsGlobal_listIVR.listSG_ListSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if listSG_List.Cells[0,ARow]<>'' then begin
    currentID_del:=listSG_List.Cells[0,ARow];
  end;
end;

end.
