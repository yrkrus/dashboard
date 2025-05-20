 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                 Класс для описания выпадающего меню                       ///
///                 для быстрого доступа к адресу клиники                     ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TAddressClinicPopMenuUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.Win.ADODB, Data.DB,
  Vcl.Menus,
  Windows,
  Messages, Variants,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Vcl.ComCtrls,
  TCustomTypeUnit;


 // class TAddressClinicPopMenu
  type
      TAddressClinicPopMenu = class
      public

      procedure AddressItemClick(Sender: TObject);

      constructor Create(var p_menu:TPopupMenu; var p_Text:TRichEdit);                   overload;
      destructor Destroy;                                          override;

      private
      m_popmenu                 :TPopupMenu;               // само выпадающее меню
      m_city                    :TStringList;
      m_types                   :TStringList;
      m_text                    :TRichEdit;


      procedure FindCity;               // поиск города
      procedure AddTypes;               // добавление типов
      procedure CreateMenu;             // создание меню

      function GetAddressClinic(InCity,inType:string):TStringList; // поиск адреса для SubSubMenu;



      end;
 // class TAddressClinicPopMenu END

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL;


constructor TAddressClinicPopMenu.Create(var p_menu:TPopupMenu; var p_Text:TRichEdit);
 begin

   // init
   m_popmenu:=p_menu;
   m_text:=p_Text;

   m_city:=TStringList.Create;
   m_types:=TStringList.Create;

   // найдем список с городами
   FindCity;
   // подтипы
   AddTypes;

   // создаем менею
   CreateMenu;
 end;


destructor TAddressClinicPopMenu.Destroy;
begin

  if Assigned(m_city) then m_city.Free;
  if Assigned(m_types) then m_types.Free;

end;


// Обработчик клика для адресов
procedure TAddressClinicPopMenu.AddressItemClick(Sender: TObject);
var
 address:string;
begin
  address:=TMenuItem(Sender).Caption;
  address:=StringReplace(address,'&','',[rfReplaceAll]);

  m_text.SelStart := m_text.GetTextLen; // Устанавливаем курсор в конец текста
  m_text.SelLength := 0;                // Указываем, что ничего не выделено
  m_text.SelText := ' ' + address+' ';  // Вставляем текст с пробелом перед ним
end;

 // поиск города
 procedure TAddressClinicPopMenu.FindCity;
 var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  countCity:Integer;
  i,j:Integer;
  city:string;
  isNotExist:Boolean;

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
      SQL.Add('select count(id) from server_ik where showSMS = ''1'' and address like ''г. %'' ');

      Active:=True;
      countCity:=StrToInt(VarToStr(Fields[0].Value));

      if countCity = 0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
         serverConnect.Close;
         FreeAndNil(serverConnect);
        end;
        Exit;
      end;

      SQL.Clear;
      SQL.Add('select address from server_ik where showSMS = ''1'' and address like ''г. %'' ');
      Active:=True;

      for i:=0 to countCity-1 do begin
       city:=Fields[0].Value;
       System.Delete(city,1,AnsiPos('г. ',city)+2 );
       System.Delete(city, AnsiPos(',',city), Length(city));

       isNotExist:=False;
       for j:=0 to m_city.Count-1 do begin
         if city = m_city[j] then begin
           isNotExist:=True;
           Break;
         end;
       end;

       if not isNotExist then m_city.Add(city);
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


// добавление типов
procedure TAddressClinicPopMenu.AddTypes;
begin
  m_types.Add(EnumTypeClinicToString(eMMC));
  m_types.Add(EnumTypeClinicToString(eCLD));
end;

// создание меню
procedure TAddressClinicPopMenu.CreateMenu;
var
 i,j,k:Integer;
 cityMenuItem, typeMenuItem, addressMenuItem: TMenuItem;

 address:TStringList;
begin
  if m_city.Count = 0 then Exit;

  for i:=0 to m_city.Count-1 do begin   // Основное меню

    cityMenuItem:=TMenuItem.Create(m_popmenu);
    cityMenuItem.Caption := m_city[i];

     // Создаем субменю для каждого города
     for j:=0 to m_types.Count-1 do begin   // Субменю
      typeMenuItem:=TMenuItem.Create(cityMenuItem);
      typeMenuItem.Caption:=m_types[j];

       address:=GetAddressClinic(m_city[i],m_types[j]);

       for k:=0 to address.Count-1 do begin
        addressMenuItem:=TMenuItem.Create(typeMenuItem);
        addressMenuItem.Caption:= address[k];

        // Привязываем обработчик события OnClick для каждого адреса
        addressMenuItem.OnClick := AddressItemClick;

        typeMenuItem.Add(addressMenuItem); // Добавляем адрес в субменю
       end;

       cityMenuItem.Add(typeMenuItem); // Добавляем субменю к элементу города
     end;

     m_popmenu.Items.Add(cityMenuItem); // Добавляем в основное меню
  end;
end;


// поиск адреса для SubSubMenu;
function TAddressClinicPopMenu.GetAddressClinic(InCity,inType:string):TStringList;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
  i:Integer;
  countAddress:Integer;
 begin
  Result:=TStringList.Create;
  Result.Clear;

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
      SQL.Add('select count(id) from server_ik where showSMS=''1'' and address like '+#39+'%'+InCity+'%'+#39+' and type_clinik ='+#39+inType+#39+'');

      Active:=True;
      countAddress:=StrToInt(VarToStr(Fields[0].Value));

      if countAddress = 0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
         serverConnect.Close;
         FreeAndNil(serverConnect);
        end;
        Exit;
      end;

      SQL.Clear;
      SQL.Add('select address from server_ik where showSMS=''1'' and address like '+#39+'%'+InCity+'%'+#39+' and type_clinik ='+#39+inType+#39+' order by address');
      Active:=True;

      for i:=0 to countAddress-1 do begin
        Result.Add(VarToStr(Fields[0].Value));
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


end.