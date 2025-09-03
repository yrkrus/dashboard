 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   Список с отключенными операторами                       ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TDisableOperatorUnit;

interface

uses
    System.Classes, System.SysUtils, Data.Win.ADODB, Data.DB;

 // class TStructDisableOperator
  type
      TStructDisableOperator = class
      public
      m_sip         :Integer;
      m_userID      :Integer;
      m_FIO         :string;
      m_dateStart   :TDateTime; // дата принятия
      m_dateStop    :TDateTime; // дата ухода

      constructor Create;                   overload;

      end;
 // class TStructDisableOperator END



 ////////////////////////////////////////////////////

 // class TDisableOperator
  type
      TDisableOperator = class
      private
      m_count         :Integer;
      m_list          :TArray<TStructDisableOperator>;

      //procedure Clear;

      procedure CreateListDisableOperator;  // созданием листа с отключенными
      function FindSip(_sip:Integer; _date:TDate):Boolean; // прверка входит ли пользак в отключенные

      public
      constructor Create;                   overload;

      function IsDisable(_sip:Integer; _date:TDate):Boolean;
      function GetUserNameOperator(_sip:Integer; _date:TDate):string;


      end;
 // class TDisableOperator END

implementation

uses
  GlobalVariablesLinkDLL;


constructor TStructDisableOperator.Create();
begin
   m_sip        :=0;
   m_userID     :=0;
   m_FIO        :='';
   m_dateStart  :=0;
   m_dateStop   :=0;
end;



constructor TDisableOperator.Create;
begin
 inherited;
 m_count:=0;

 // заполняем данными
 CreateListDisableOperator;
end;


 // созданием листа с отключенными
procedure TDisableOperator.CreateListDisableOperator;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
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
      SQL.Add('select count(id) from operators_disabled');

      Active:=True;
      countData:=Fields[0].Value;
      if countData=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

        Exit;
      end;

      if countData<>0 then begin

        // создаем список с данными
        SetLength(m_list,countData);
        for i:=0 to countData-1 do m_list[i]:=TStructDisableOperator.Create;
        m_count:=countData;

        SQL.Clear;
        SQL.Add('select sip,user_id,date_time_create,date_time_disable from operators_disabled ');

        Active:=True;

        for i:=0 to countData-1 do begin

           m_list[i].m_sip:=StrToInt(Fields[0].Value);
           m_list[i].m_userID:=StrToInt(Fields[1].Value);
           m_list[i].m_dateStart:=StrToDateTime((Fields[2].Value));
           m_list[i].m_dateStop:=StrToDateTime((Fields[3].Value));
           m_list[i].m_FIO:=GetUserNameFIO(m_list[i].m_userID);

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


function TDisableOperator.IsDisable(_sip:Integer; _date:TDate):Boolean;
begin
  Result:=FindSip(_sip,_date);
end;

// прверка входит ли пользак в отключенные
function TDisableOperator.FindSip(_sip:Integer; _date:TDate):Boolean;
var
 i:Integer;
 finded:Boolean;
begin
  Result:=False;    // default
  finded:=False;

  for i:=0 to m_count-1 do begin
    if m_list[i].m_sip = _sip then begin
      finded:=(_date>=m_list[i].m_dateStart) and (_date<=m_list[i].m_dateStop);
      Break;
    end;
  end;

  Result:=finded;
end;


function TDisableOperator.GetUserNameOperator(_sip:Integer; _date:TDate):string;
var
 i:Integer;
begin
  Result:='null';

  for i:=0 to m_count-1 do begin
    if m_list[i].m_sip = _sip then begin
      if ((_date>=m_list[i].m_dateStart) and (_date<=m_list[i].m_dateStop)) then begin
        Result:=m_list[i].m_FIO;
        Break;
      end;
    end;
  end;
end;


end.