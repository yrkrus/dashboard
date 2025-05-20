 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///           ласс дл€ описани€ услуг которые есть в клиниках                 ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TServiceUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit,
  Data.Win.ADODB, Data.DB, IdException, Variants,
  Vcl.StdCtrls, Vcl.Forms;



 // class TStructService
  type
      TStructService = class

      public
      m_destination   :string;  // направление
      m_code          :string;  // код
      m_name          :string;  // название услуги


      constructor Create;                               overload;
      constructor Create(_sevice:TStructService);       overload;
      constructor Create(_dest,_code,_name:string);     overload;

      procedure Clear;

      end;
 // class TStructService END

/////////////////////////////////////////////////////////////////////////////////////////

 // class TService
  type
      TService = class
      private
      m_list        :TArray<TStructService>; // массив с данными
      m_count       :Integer;


      function GetResponse(_stroka:string; var _errorDescription:string):Boolean;  // действие c Ѕƒ
      procedure CreateList;                                         // создание\заполнение листа с данными
      function IsExist(const _service:TStructService):Boolean;      // есть ли така€ уже услуга
      function CreateDestination:TStringList;                       // список со всеми направлени€ми


      public
      constructor Create(IsEmptyPreLoading:Boolean = False);                 overload;


      procedure Clear;

      procedure Add(const _service:TStructService);                                        // добавление услуги в лист
      function Update(const _service:TService;
                      var p_Text:TStaticText;
                      var _errorDescription:string):Boolean;      // обновление данных (добавлением в Ѕƒ)


      function Find(const _text:string; var _countFinded:Integer):TArray<TStructService>;        // поиск
      function GetService(_id:Integer):TStructService;
      function GetDestination(_id:Integer):string;
      function GetCode(_id:Integer):string;
      function GetName(_id:Integer):string;
      property Count:Integer read m_count;

      end;
 // class TService END

implementation

uses
  GlobalVariablesLinkDLL;


/////////////////////////////// TStructService /////////////////////////////////////////////

constructor TStructService.Create;
begin
 Clear;
end;

constructor TStructService.Create(_sevice:TStructService);
begin
 m_destination:=_sevice.m_destination;
 m_code:=_sevice.m_code;
 m_name:=_sevice.m_name;
end;

constructor TStructService.Create(_dest,_code,_name:string);
begin
 m_destination:=_dest;
 m_code:=_code;
 m_name:=_name;
end;

procedure TStructService.Clear;
begin
 m_destination:='';
 m_code:='';
 m_name:='';
end;


////////////////////////////////// TService ////////////////////////////////////////////////
constructor TService.Create(IsEmptyPreLoading:Boolean = False);
begin
  // inherited;
  m_count:=0;

  // запоолним данными
  if not IsEmptyPreLoading then CreateList;
end;


procedure TService.Clear;
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
    m_list[i].Clear;
  end;
  m_count:=0;
  SetLength(m_list, m_count);
end;


// действие c Ѕƒ
function TService.GetResponse(_stroka:string; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(_stroka);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;

               _errorDescription:=e.ClassName+' '+e.Message;
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

// добавление услуги в лист
procedure TService.Add(const _service:TStructService);
begin
 SetLength(m_list, m_count+1);

 m_list[m_count]:=TStructService.Create(_service);
 Inc(m_count);
end;


// обновление данных (добавлением в Ѕƒ)
function TService.Update(const _service:TService; var p_Text:TStaticText; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 response:string;

 i:Integer;
 procent:Integer;

begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescription);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;


  for i:=0 to _service.Count-1 do begin
    procent:=Round((i * 100) / _service.Count-1);
    if procent<0  then procent:=0;
    p_Text.Caption:='—татус : «агрузка ['+IntToStr(procent)+'%]';

   // есть ли уже така€ услуга
   if IsExist(_service.m_list[i]) then Continue;

     response:='insert into sms_service (dest,code,service_name) values ('+#39+_service.m_list[i].m_destination +#39+','
                                                                          +#39+_service.m_list[i].m_code +#39+','
                                                                          +#39+_service.m_list[i].m_name+#39+')';

     if not GetResponse(response,_errorDescription) then begin
       p_Text.Caption:='—татус : Ќеудачна€ загрузка';
       Exit;
     end;

    Add(_service.m_list[i]);

    Application.ProcessMessages;
  end;


  // обновим новое кол-во
  begin
   Clear;
   CreateList;
  end;

  p_Text.Caption:='—татус : ”спешно загружено';
  Result:=True;
end;

// поиск
function TService.Find(const _text:string; var _countFinded:Integer):TArray<TStructService>;
var
 i:Integer;
 arr_count:Integer;
 txtFind:string;
 txtBase,txtBaseCode:string;
begin
  arr_count:=0;
  _countFinded:=0;

  txtFind:=AnsiLowerCase(_text);
  SetLength(Result, 0);

  for i:=0 to m_count-1 do begin
   txtBase:=AnsiLowerCase(m_list[i].m_name);
   txtBaseCode:=AnsiLowerCase(m_list[i].m_code);

   if (AnsiPos(txtFind,txtBase)<>0) or (AnsiPos(txtFind,txtBaseCode)<>0) then begin

      SetLength(Result, arr_count + 1);
      Result[arr_count] := TStructService.Create(m_list[i]);
      Inc(arr_count);

     _countFinded:=arr_count;
   end;
  end;
end;


function TService.GetService(_id:Integer):TStructService;
begin
  Result:=m_list[_id];
end;


function TService.GetDestination(_id:Integer):string;
begin
  Result:=m_list[_id].m_destination;
end;


function TService.GetCode(_id:Integer):string;
begin
  Result:=m_list[_id].m_code;
end;

function TService.GetName(_id:Integer):string;
begin
  Result:=m_list[_id].m_name;
end;


// создание\заполнение листа с данными
procedure TService.CreateList;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 i,j:Integer;
 countService:Integer;
 service:TStructService;

 destinationList:TStringList; // список с направлени€ми
   t:string;
begin

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  // найдем все направлени€
  destinationList:=CreateDestination;

  try
    with ado do begin
      ado.Connection:=serverConnect;

      // пройдемс€ по направлени€м
      for i:=0 to destinationList.Count-1 do begin
        SQL.Clear;
        SQL.Add('select count(dest) from sms_service where dest='+#39+destinationList[i]+#39);
        Active:=True;
        countService:= Fields[0].Value;

        if countService <> 0 then begin

          SQL.Clear;
          SQL.Add('select code,service_name from sms_service where dest = '+#39+destinationList[i]+#39+' order by service_name ASC');

          Active:=True;

          for j:=0 to countService-1 do begin
             service:=TStructService.Create(destinationList[i], VarToStr(Fields[0].Value), VarToStr(Fields[1].Value));
             Add(service);

             Application.ProcessMessages;
             ado.Next;
          end;
        end;
      end;

    end;
  finally
    if Assigned(destinationList) then FreeAndNil(destinationList);    

    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// есть ли така€ уже услуга
function TService.IsExist(const _service:TStructService):Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_count-1 do begin
    if (m_list[i].m_destination = _service.m_destination) and
       (m_list[i].m_code = _service.m_code) and
       (m_list[i].m_name = _service.m_name) then begin
      Result:=True;
      Exit;
    end;
  end;
end;

// список со всеми направлени€ми
function TService.CreateDestination:TStringList;
var
  countDest:Integer;
  ado:TADOQuery;
  serverConnect:TADOConnection;
  i:Integer;
begin
  Result:=TStringList.Create;

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
      SQL.Add('select count(distinct(dest)) from sms_service');

      Active:=True;
      countDest:= Fields[0].Value;

      if countDest <> 0 then begin

        SQL.Clear;
        SQL.Add('select distinct(dest) from sms_service order by dest ASC');

        Active:=True;

        for i:=0 to countDest-1 do begin
           Result.Add(VarToStr(Fields[0].Value));
           Application.ProcessMessages;

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
end;


end.