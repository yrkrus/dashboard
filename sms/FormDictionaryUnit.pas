unit FormDictionaryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, Data.DB, Data.Win.ADODB, IdException;

type
  TFormDictionary = class(TForm)
    panel: TPanel;
    list_Dictionary: TListView;
    Label1: TLabel;
    PopupMenu: TPopupMenu;
    menu_del: TMenuItem;
    st_NoMessage: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure menu_delClick(Sender: TObject);
    procedure list_DictionaryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  SelectedItemPopMenu: TListItem; // Переменная для хранения выбранного элемента

  procedure Show;
  procedure ClearListView(var p_ListView:TListView);
  procedure LoadData(var p_ListView:TListView);

  function SaveWord(_id:Integer;
                    InNewMessage:string;
                    var _errorDescription:string;
                    IsDelete:Boolean = False):Boolean;  // редактирование слова

  public
    { Public declarations }
  end;

var
  FormDictionary: TFormDictionary;

implementation

uses
  GlobalVariables;

{$R *.dfm}


// очистка
procedure TFormDictionary.ClearListView(var p_ListView:TListView);
const
 cWidth_default         :Word = 653;
 cWidth_date            :Word = 26;
 cWidth_user            :Word = 30;
 cWidth_slovo           :Word = 41;

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
      Caption:=' Дата добавления';
      Width:=Round((cWidth_default*cWidth_date)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Кто добавил';
      Width:=Round((cWidth_default*cWidth_user)/100);
      Alignment:=taCenter;
    end;

    with Columns.Add do
    begin
      Caption:=' Слово';
      Width:=Round((cWidth_default*cWidth_slovo)/100);
      Alignment:=taCenter;
    end;
 end;
end;


procedure TFormDictionary.LoadData(var p_ListView:TListView);
 var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 i,countDictionary:Integer;
 ListItem:TListItem;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from sms_dictionary');

      Active:=True;
      countDictionary:=Fields[0].Value;

      if countDictionary=0 then begin
        // надпись что нет данных
        st_NoMessage.Visible:=True;

        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        //убираем меню
        p_ListView.PopupMenu:=nil;

        Exit;
      end;

      // скрываем надпись что нет данных
      st_NoMessage.Visible:=False;
      ////////////////////////////////////////////////////////////////

      SQL.Clear;
      SQL.Add('select id,date_time,user_id,word from sms_dictionary order by date_time DESC');
      Caption:='Словарь. Слов - '+IntToStr(countDictionary);

      Active:=True;

      for i:=0 to countDictionary-1 do
      begin
        // Элемент не найден, добавляем новый
        ListItem:= p_ListView.Items.Add;
        ListItem.Caption := VarToStr(Fields[0].Value);  // id
        ListItem.SubItems.Add(Fields[1].Value);         // дата время
        ListItem.SubItems.Add(GetUserNameFIO(StrToInt(VarToStr(Fields[2].Value))));         // пользователь
        ListItem.SubItems.Add(Fields[3].Value);         // слово

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
end;

procedure TFormDictionary.menu_delClick(Sender: TObject);
var
 resultat:Word;
 id:integer;
 word:string;
 error:string;
begin
  // Проверяем, был ли выбран элемент
  if Assigned(SelectedItemPopMenu) then
  begin
    id:=StrToInt(SelectedItemPopMenu.Caption);
    word:=SelectedItemPopMenu.SubItems[2];
    if word='' then word:='пустое слово';

    resultat:=MessageBox(Handle,PChar('Точно удалить слово "'+word+'" ?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
    if resultat=mrYes then begin

      if not SaveWord(id, '', error, True) then begin
        MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
      // обновляем данные
      Show;
      Exit;
    end;
  end
  else
  begin
   MessageBox(Handle,PChar('Не выбрано слово'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
  end;

end;

// удаление слова из БД
function TFormDictionary.SaveWord(_id:Integer;
                                  InNewMessage:string;
                                  var _errorDescription:string;
                                  IsDelete:Boolean = False):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
    FreeAndNil(ado);
    Exit;
  end;

   try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      if not IsDelete then begin
       SQL.Add('update sms_dictionary set word = '+#39+InNewMessage+#39+' where id = '+#39+IntToStr(_id)+#39);
      end
      else begin
        SQL.Add('delete from sms_dictionary where id = '+#39+IntToStr(_id)+#39);
      end;

      try
          ExecSQL;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
              _errorDescription:=e.ClassName+': '+e.Message;
            end;
             Exit;
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

   Result:=True;
end;


procedure TFormDictionary.FormShow(Sender: TObject);
begin
  Show;
end;

procedure TFormDictionary.list_DictionaryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Проверяем, был ли клик правой кнопкой мыши
  if Button = mbRight then
  begin
    // Получаем элемент, на который кликнули
    SelectedItemPopMenu := list_Dictionary.GetItemAt(X, Y);
  end;
end;

procedure TFormDictionary.Show;
begin
  ClearListView(list_Dictionary);
  LoadData(list_Dictionary);
end;

end.
