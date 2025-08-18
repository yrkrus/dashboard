/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///             ласс дл€ описани€ времени работы колл центра                  ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TWorkTimeCallCenterUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, Data.Win.ADODB,
  Data.DB, Variants, IdException;


 // class TWorkTimeCallCenter
  type
      TWorkTimeCallCenter = class

      private
      m_start     :Integer;
      m_stop      :Integer;

      function GetStart:Integer;
      function GetStop:Integer;

      public
      constructor Create(_start, _stop:Integer);  overload;
      constructor Create();                       overload;

      procedure SetWork(_start,_stop:Integer);  // установка времени
      function SaveWorkToBase(_start,_stop:Integer; var _errorDescription:string):Boolean;  // сохранение времени работы в Ѕƒ
      procedure UpdateTime;                     // обновление текущих данных

      function StartTimeStr:string;
      function StopTimeStr:string;

      property StartTime:Integer read m_start;
      property StopTime:Integer read m_stop;


      end;
 // class TWorkTimeCallCenter END

implementation

uses
  GlobalVariablesLinkDLL;



constructor TWorkTimeCallCenter.Create;
begin
 //inherited;
  m_start:=GetStart;
  m_stop:=GetStop;
end;

constructor TWorkTimeCallCenter.Create(_start, _stop:Integer);
begin
 //inherited;
 m_start:=_start;
 m_stop:=_stop;
end;

// установка времени
procedure TWorkTimeCallCenter.SetWork(_start,_stop:Integer);
begin
 m_start:=_start;
 m_stop:=_stop;
end;

function TWorkTimeCallCenter.GetStart:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;
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
      SQL.Add('select time_start from work_time_call_center where id = ''1'' ');

      Active:=True;
      Result:=StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

function TWorkTimeCallCenter.GetStop:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;
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
      SQL.Add('select time_stop from work_time_call_center where id = ''1'' ');

      Active:=True;
      Result:=StrToInt(VarToStr(Fields[0].Value));
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

// сохранение времени работы в Ѕƒ
function TWorkTimeCallCenter.SaveWorkToBase(_start,_stop:Integer; var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 error:string;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(error);

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('update work_time_call_center set time_start = '+#39+IntToStr(_start)+#39+
                                             ', time_stop= '+#39+IntToStr(_stop)+#39+' where id = ''1'' ');

      try
          ExecSQL;
      except
          on E:EIdException do begin
             _errorDescription:='Ќе удалось обновить врем€ работы'+#13+e.Message;
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
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

// обновление текущих данных
procedure TWorkTimeCallCenter.UpdateTime;
begin
  m_start:=GetStart;
  m_stop:=GetStop;
end;

function TWorkTimeCallCenter.StartTimeStr:string;
begin
  if m_start < 9 then Result:='0'+IntToStr(m_start)
  else Result:=IntToStr(m_start);
end;

function TWorkTimeCallCenter.StopTimeStr:string;
begin
  if m_stop < 9 then Result:='0'+IntToStr(m_stop)
  else Result:=IntToStr(m_stop);
end;

end.