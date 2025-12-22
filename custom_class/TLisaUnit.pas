/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания Lisa                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TLisaUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
      Graphics, System.SyncObjs, IdException,  GlobalVariablesLinkDLL, TCustomTypeUnit,
      System.Generics.Collections;

  // class TLisaStruct
 type
      TLisaStruct = class
      public
      id                    : Integer;  // id по БД
      phone                 : string;   // номер телефона
      talkTime              : Integer;  // стартовое значение времени ожидание

      constructor Create;                  overload;
      procedure Clear;

      end;
   // class TLisaStruct END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TLisa
 type
      TLisa = class
      const
      cGLOBAL_ListLisa                   : Word =  200; // длинна массива

      private
      m_count                             : Integer;
      m_mutex                             : TMutex;

      public
      m_list                     : TArray<TLisaStruct>;

      constructor Create;                  overload;
      destructor Destroy;                  override;

      procedure Clear;
      procedure UpdateData;                           // обновление данных в массиве m_list + count
      function isExist(id:Integer)        :Boolean;   // проверка существует ли такой номер в отображении

      property Count:Integer read m_count;

      end;
   // class TLisa END


implementation

uses
  FunctionUnit, GlobalVariables;



constructor TLisaStruct.Create;
 begin
   inherited;
   Clear;
 end;


 procedure TLisaStruct.Clear;
 begin
   id:=0;
   phone:='';
   talkTime:=0;
 end;

constructor TLisa.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TLisa');
    m_count:=0;

   SetLength(m_list,cGLOBAL_ListLisa);
   for i:=0 to cGLOBAL_ListLisa-1 do m_list[i]:=TLisaStruct.Create;

   // получим данные
   UpdateData;
 end;

destructor TLisa.Destroy;
var
 i: Integer;
begin
  for i:=Low(m_list) to High(m_list) do FreeAndNil(m_list[i]);
  m_mutex.Free;

  inherited;
end;


 procedure TLisa.Clear;
 var
 i: Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(m_list) to High(m_list) do m_list[i].Clear;
  finally
    m_mutex.Release;
  end;
 end;


function TLisa.isExist(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:= 0 to Count - 1 do
  begin
    if m_list[i].id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;


 procedure TLisa.UpdateData;
 var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countLisa:Integer;
 request:TStringBuilder;
 begin
  ado:=TADOQuery.Create(nil);
  try
      serverConnect:=createServerConnect;
    except
      on E:Exception do begin
        if not Assigned(serverConnect) then begin
           FreeAndNil(ado);
           Exit;
        end;
      end;
    end;

  request:=TStringBuilder.Create;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with request do begin
        Clear;
        Append('select count(id) from queue_lisa ');
        Append(' where hash is NULL ');
      end;

      SQL.Add(request.ToString);

      Active:=True;
      if Fields[0].Value<>null then countLisa:=Fields[0].Value;

      try
        Active:=True;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
              FreeAndNil(request);
            end;
            Exit;
          end;
      end;

       // очищаем весь список
       Clear;
       if countLisa = 0 then begin
         m_count:=countLisa;

         FreeAndNil(ado);
         serverConnect.Close;
         FreeAndNil(serverConnect);
         Exit;
       end;

       if countLisa<>0 then begin

          SQL.Clear;
          with request do begin
            Clear;
            Append('select id,phone,talk_time from queue_lisa ');
            Append(' where hash is NULL ');
          end;

          SQL.Add(request.ToString);

          Active:=True;

          for i:=0 to countLisa-1 do begin
            try
              if (Fields[0].Value <> null) and
                 (Fields[1].Value <> null) and
                 (Fields[2].Value <> null)
                then begin
                m_list[i].id:=StrToInt(VarToStr(Fields[0].Value));
                m_list[i].phone:=VarToStr(Fields[1].Value);
                m_list[i].talkTime:=StrToInt(VarToStr(Fields[2].Value));
              end;
            finally
               ado.Next;
            end;
          end;
       end;
       m_count:=countLisa;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
 end;


end.
