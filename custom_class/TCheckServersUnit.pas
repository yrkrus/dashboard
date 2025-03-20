
/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                     Класс для описания ChekServersIK                      ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TCheckServersUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, Vcl.StdCtrls,
      IdException, FIBDatabase, pFIBDatabase, TLogFileUnit,
      Vcl.ExtCtrls, Vcl.Dialogs;


/////////////////////////////////////////////////////////////////////////////////////////
  // class TStructServers
 type
      TStructServers = class

      public
       id              :Integer;
       ip              :string;
       address         :string;
       alias           :string;
       countErrors     :Integer;


      constructor Create;             overload;
      procedure Clear;

      private
      m_mutex                               : TMutex;


      end;
   // class TStructServers END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TCheckServersIK
 type
      TCheckServersIK = class

      public

      listServers             :array of TStructServers;


      constructor Create(var p_Log:TLoggingFile);                   overload;


      destructor Destroy;                   override;

      function GetCount                     :Integer;

      procedure CheckServerPing;                // проверка на доступность серверов инфоклиники режим Ping
      procedure CheckServerFirebird;            // проверка на доступность серверов инфоклиники режим Firebird (через подключение к БД Firebird)

      function GetCheckServerFirebird(ID:Integer):Boolean;  // единичная проверка сервера


      private
      m_mutex                               : TMutex;
      m_log                                 : TLoggingFile;

      count                                 : Integer;
      firebird_login                        : string;
      firebird_pwd                          : string;

      firebirdConnect                       : TpFIBDatabase;

      procedure CreateListServers;                                   // получение данных о серверах(ip, alias)
      procedure CreateAuthFirebird;
      function CheckServer(InServerIP,InServerID_Alias:string):Boolean;

      end;
   // class TCheckServersIK END


implementation

uses
  FunctionUnit, FormHome, FormServerIKCheckUnit, GlobalVariables, TCustomTypeUnit;


constructor TStructServers.Create;
 begin
    inherited;
    Clear;
 end;

 procedure TStructServers.Clear;
 begin
    Self.id:=0;
    Self.ip:='';
    Self.address:='';
    Self.alias:='';

    Self.countErrors:=0;
 end;


constructor TCheckServersIK.Create(var p_Log:TLoggingFile);
 begin
   // inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TCheckServersIK');

    m_log:=p_Log;
    firebirdConnect:=TpFIBDatabase.Create(nil);
    count:=0;

   // получим данные
   CreateListServers;
   CreateAuthFirebird;
 end;

destructor TCheckServersIK.Destroy;
var
 i: Integer;
begin
  for i:=Low(listServers) to High(listServers) do FreeAndNil(listServers[i]);
  SetLength(listServers, 0); // Убираем массив

  m_mutex.Free;
  firebirdConnect.Free;

  inherited;
end;


function TCheckServersIK.GetCount:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.count;
  finally
    m_mutex.Release;
  end;
end;


procedure TCheckServersIK.CreateAuthFirebird;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
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
      SQL.Add('select firebird_login,firebird_pwd from server_ik_fb');
      Active:=True;

      if (Fields[0].Value<>null) and (Fields[1].Value<>null)  then begin
        firebird_login:=VarToStr(Fields[0].Value);
        firebird_pwd:=VarToStr(Fields[1].Value);
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

procedure TCheckServersIK.CreateListServers;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 countServers:Integer;
 i:Integer;
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
      SQL.Add('select count(id) from server_ik');

      try
          Active:=True;
          countServers:=Fields[0].Value;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;


      if countServers>=1 then begin

        //создадиим структуру
        SetLength(listServers,countServers);
        for i:=0 to countServers-1 do listServers[i]:=TStructServers.Create;

        count:=countServers;

        if Active then ACtive:=false;

        SQL.Clear;
        SQL.Add('select id,ip,address,alias from server_ik');

        try
         Active:=True;
        except
            on E:EIdException do begin
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

              Exit;
            end;
        end;


         for i:=0 to countServers-1 do begin
           listServers[i].id:=StrToInt(VarToStr(Fields[0].Value));
           listServers[i].ip:=VarToStr(Fields[1].Value);
           listServers[i].address:=VarToStr(Fields[2].Value);
           listServers[i].alias:=VarToStr(Fields[3].Value);
           listServers[i].countErrors:=0;

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


procedure TCheckServersIK.CheckServerPing;
var
 i,j:Integer;
 countServers:Integer;
 checkIP:string;
 lblName:string;
 CodOshibki:string;
 viewErrors:Integer;
 allCount:Integer;
begin

   for i:=0 to GetCount-1 do begin

    try
     if Ping(listServers[i].ip)=False then begin
       //listServers[i].isRunning:=False;
     end;
    except
      on E:Exception do
      begin
        CodOshibki:=e.Message;
        if AnsiPos('10013',CodOshibki)<>0 then begin  // 'Socket Error # 10013'#$D#$A'Access denied.'
          HomeForm.lblCheckInfocilinikaServerAlive.Caption:='Exception.Access denied';
          HomeForm.lblCheckInfocilinikaServerAlive.Font.Color:=clRed;
          Exit;
        end else if AnsiPos('long',CodOshibki)<>0 then begin
          //listServers[i].isRunning:=False;
          //Inc(countErrors);
        end;
      end;
    end;

      // подправим статусы
      with FormServerIKCheck do begin

        {for j:=0 to ComponentCount-1 do begin
          if Components[j].Name='lbl_'+IntToStr(listServers[i].id) then begin
            if listServers[i].isRunning then begin  // НЕТ ОШИБКИ!!
               (Components[j] as TLabel).Caption:='доступен';
               (Components[j] as TLabel).Font.Color:=clGreen;
            end
            else begin                  // ЕСТЬ ОШИБКА!!!
              (Components[j] as TLabel).Caption:='не доступен';
              (Components[j] as TLabel).Font.Color:=clRed;
            end;
          end;
        end;  }

      end;
   end;


  // надпись после проверки
 { with HomeForm do begin
    for i:=0 to GetCount-1 do begin

      if countErrors = 0 then begin
        lblCheckInfocilinikaServerAlive.Caption:='отсутствуют';
        lblCheckInfocilinikaServerAlive.Font.Color:=clGreen;
      end
      else begin
        lblCheckInfocilinikaServerAlive.Font.Color:=clRed;

        case countErrors of
         1:begin
          for j:=0 to GetCount-1 do begin
            if not listServers[j].isRunning then begin
              lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
            end;
          end;
         end;
         2:begin
          viewErrors:=0;
          for j:=0 to GetCount-1 do begin
            if not listServers[j].isRunning then begin
              if viewErrors=0 then begin
               lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
               Inc(viewErrors);
              end
              else begin
                lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и '+listServers[j].address;
              end;

            end;
          end;
         end;
        else
         viewErrors:=0;
          for j:=0 to GetCount-1 do begin
            if not listServers[j].isRunning then begin
              if viewErrors=0 then begin
               lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
               Inc(viewErrors);
              end
              else if (viewErrors=1) then begin
                lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и '+listServers[j].address;
                inc(viewErrors);
              end;
            end;
          end;

          if viewErrors>=2 then begin
           lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и еще '+IntToStr(countErrors-2)+' (нажмите сюда для показа...)';
          end;
        end;
      end;
    end;
  end;  }

end;


 // проверка FIREBIRD сервера
function TCheckServersIK.CheckServer(InServerIP,InServerID_Alias:string):Boolean;
 var
  isConnectedSQL:Boolean;
  messclass,mess:string;

begin
   isConnectedSQL:=False;

  with firebirdConnect do begin

    if Connected then Close;

    try
      ConnectParams.UserName:=firebird_login;
      ConnectParams.Password:=firebird_pwd;
      ConnectParams.CharSet:='WIN1251';
      DBName:=InServerIP+'/3050:'+InServerID_Alias;
      LibraryName:='gds32.dll';
      Connected:=True;

      if Connected then isConnectedSQL:=True
      else isConnectedSQL:=False;

     except
      on E:Exception do
      begin
       messclass:=e.ClassName;
       mess:=e.Message;
       m_log.Save(DBName+': '+messclass+'.'+mess,IS_ERROR);
       Connected:=False;
       Close;
      end;
    end;

    Connected:=False;
    Close;

  end;
  if isConnectedSQL then Result:=True
  else Result:=False;
end;


function TCheckServersIK.GetCheckServerFirebird(ID:Integer):Boolean;
var
 connectBD_Firebird:Boolean;
begin
  Result:=False;

  try
     connectBD_Firebird:=CheckServer(listServers[ID].ip,listServers[ID].alias);

     if connectBD_Firebird then Result:=True;
  except
      on E:Exception do
      begin
        Exit;
      end;
  end;
end;


procedure TCheckServersIK.CheckServerFirebird;
const
 countWarningsErrors:Word = 5;
 colorError:TColor        = clRed;
 colorWarning:TColor      = $0000D5D5;
 colorOk:TColor           = clGreen;

var
 i,j:Integer;
 countServers:Integer;
 checkIP:string;
 lblName:string;
 CodOshibki:string;
 viewErrors:Integer;
 connectBD_Firebird:Boolean;
 allCountErrors:Integer;
 isWarningError:Boolean;  // есть кандидат на ошибку
 isWarningErrorCount:Integer;
begin
   if (firebird_login='') or (firebird_pwd='') then Exit;
   allCountErrors:=0; // общее кол-во серверов с ошибками
   isWarningError:=False;
   isWarningErrorCount:=0;

   for i:=0 to GetCount-1 do begin

    try
      connectBD_Firebird:=CheckServer(listServers[i].ip,listServers[i].alias);

      if not connectBD_Firebird then begin
        // увеличиаем кол-во
        if listServers[i].countErrors<countWarningsErrors then begin
          Inc(listServers[i].countErrors);
        end;
      end
      else begin
        if listServers[i].countErrors<>0 then begin
          if listServers[i].countErrors > 0 then begin
            Dec(listServers[i].countErrors);
          end;
        end;
      end;

    except
      on E:Exception do
      begin
        CodOshibki:=e.Message;
       // HomeForm.STError.Caption:=CodOshibki;
        if listServers[i].countErrors<countWarningsErrors then begin
          Inc(listServers[i].countErrors);
        end;
      end;
    end;

      // подправим статусы
      with FormServerIKCheck do begin

        for j:=0 to ComponentCount-1 do begin
          if Components[j].Name='lbl_'+IntToStr(listServers[i].id) then begin
            if listServers[i].countErrors=0 then begin  // НЕТ ОШИБКИ!!
               (Components[j] as TLabel).Caption:='доступен';
               (Components[j] as TLabel).Font.Color:=colorOk;
            end
            else begin                                  // ЕСТЬ ОШИБКА!!!
              if listServers[i].countErrors<countWarningsErrors then begin
                (Components[j] as TLabel).Caption:='проблема';
                (Components[j] as TLabel).Font.Color:=colorWarning;
                isWarningError:=True;
                Inc(isWarningErrorCount);
              end;

              if listServers[i].countErrors=countWarningsErrors then begin
                (Components[j] as TLabel).Caption:='не доступен';
                (Components[j] as TLabel).Font.Color:=colorError;
              end;
            end;
          end;
        end;

      end;
   end;


  // надпись после проверки
  with HomeForm do begin
    // кол-во с ошибками
    for i:=0 to GetCount-1 do begin
      if listServers[i].countErrors>=countWarningsErrors then begin
         Inc(allCountErrors);
      end;
    end;

    for i:=0 to GetCount-1 do begin

      if allCountErrors = 0 then begin

        if isWarningError then begin
         lblCheckInfocilinikaServerAlive.Caption:='возможная проблема ('+IntToStr(isWarningErrorCount)+') (подробнее)';
         lblCheckInfocilinikaServerAlive.Font.Color:=colorWarning;
        end
        else begin
         lblCheckInfocilinikaServerAlive.Caption:='отсутствуют';
         lblCheckInfocilinikaServerAlive.Font.Color:=colorOk;
        end;
      end
      else begin
        lblCheckInfocilinikaServerAlive.Font.Color:=colorError;

        case allCountErrors of
         1:begin
          for j:=0 to GetCount-1 do begin
            if listServers[j].countErrors>=countWarningsErrors then begin
              lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
            end;
          end;
         end;
         2:begin
          viewErrors:=0;
          for j:=0 to GetCount-1 do begin
            if listServers[j].countErrors>=countWarningsErrors then begin
              if viewErrors=0 then begin
               lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
               Inc(viewErrors);
              end
              else begin
                lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и '+listServers[j].address;
              end;
            end;
          end;
         end;
        else
         viewErrors:=0;
          for j:=0 to GetCount-1 do begin
            if listServers[j].countErrors>=countWarningsErrors then begin
              if viewErrors=0 then begin
               lblCheckInfocilinikaServerAlive.Caption:=listServers[j].address;
               Inc(viewErrors);
              end
              else if (viewErrors=1) then begin
                lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и '+listServers[j].address;
                inc(viewErrors);
              end;
            end;
          end;

          if viewErrors>=2 then begin
           lblCheckInfocilinikaServerAlive.Caption:=lblCheckInfocilinikaServerAlive.Caption+' и еще '+IntToStr(allCountErrors-2)+' (нажмите сюда для показа...)';
          end;
        end;
      end;
    end;
  end;
end;

end.
