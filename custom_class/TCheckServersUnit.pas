
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
      Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Forms, FormServerIKCheckUnit;


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
      private
      m_listServers                         :TArray<TStructServers>;
      m_count                               :Integer;
      m_mutex                               :TMutex;

      m_log                                 :TLoggingFile;
      p_checkServerInfo                     :TLabel;
      p_formCheckServers                    :TFormServerIKCheck;

      firebird_login                        :string;
      firebird_pwd                          :string;

      firebirdConnect                       :TpFIBDatabase;

      procedure CreateListServers(isShowSMS:Boolean);                         // получение данных о серверах(ip, alias)
      procedure CreateAuthFirebird;
      function CheckServer(InServerIP,InServerID_Alias:string):Boolean;


      public
      constructor Create(var p_Log:TLoggingFile;
                         var p_TextCheckServerInfo:TLabel;
                         var p_FormCheckServer:TFormServerIKCheck); overload;

      constructor Create(onlyShowSMS:Boolean);                      overload;

      destructor Destroy;                   override;

      procedure CheckServerPing;                // проверка на доступность серверов инфоклиники режим Ping
      procedure CheckServerFirebird;            // проверка на доступность серверов инфоклиники режим Firebird (через подключение к БД Firebird)

      function GetCheckServerFirebird(_id:Integer):Boolean;  // единичная проверка сервера

      function GetAddress(_id:Integer):string;
      function GetIP(_id:Integer):string;

      property Count:Integer read  m_count;


      end;
   // class TCheckServersIK END


implementation

uses
  FunctionUnit, {FormHome, FormServerIKCheckUnit,} GlobalVariables, TCustomTypeUnit, GlobalVariablesLinkDLL;


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


constructor TCheckServersIK.Create(var p_Log:TLoggingFile;
                                   var p_TextCheckServerInfo:TLabel;
                                   var p_FormCheckServer:TFormServerIKCheck);
 begin
   // inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TCheckServersIK');

    m_log:=p_Log;
    p_checkServerInfo:=p_TextCheckServerInfo;
    p_formCheckServers:=p_FormCheckServer;


    firebirdConnect:=TpFIBDatabase.Create(nil);
    m_count:=0;

   // получим данные
   CreateListServers(False);
   CreateAuthFirebird;
 end;

constructor TCheckServersIK.Create(onlyShowSMS:Boolean);
begin
   // inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TCheckServersIK');

    firebirdConnect:=TpFIBDatabase.Create(nil);
    m_count:=0;
   // получим данные
   CreateListServers(onlyShowSMS);
   CreateAuthFirebird;
end;


destructor TCheckServersIK.Destroy;
var
 i: Integer;
begin
  for i:=Low(m_listServers) to High(m_listServers) do FreeAndNil(m_listServers[i]);
  SetLength(m_listServers, 0); // Убираем массив

  m_mutex.Free;
  firebirdConnect.Free;

  inherited;
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

procedure TCheckServersIK.CreateListServers(isShowSMS:Boolean);
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 CodOshibki:string;
 countServers:Integer;
 i:Integer;
 response:string;
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
      if isShowSMS then response:='select count(id) from server_ik where showSMS = ''1'' ' // для отображения в СМС
      else response:='select count(id) from server_ik';

      SQL.Add(response);

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
        SetLength(m_listServers,countServers);
        for i:=0 to countServers-1 do m_listServers[i]:=TStructServers.Create;

        m_count:=countServers;

        if Active then ACtive:=false;

        SQL.Clear;
        if isShowSMS then response:='select id,ip,address,alias from server_ik where showSMS = ''1'' order by address ASC' // для отображения в СМС
        else response:='select id,ip,address,alias from server_ik';

        SQL.Add(response);

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
           m_listServers[i].id:=StrToInt(VarToStr(Fields[0].Value));
           m_listServers[i].ip:=VarToStr(Fields[1].Value);
           m_listServers[i].address:=VarToStr(Fields[2].Value);
           m_listServers[i].alias:=VarToStr(Fields[3].Value);
           m_listServers[i].countErrors:=0;

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

   for i:=0 to Count-1 do begin

    try
     if Ping(m_listServers[i].ip)=False then begin
       //listServers[i].isRunning:=False;
     end;
    except
      on E:Exception do
      begin
        CodOshibki:=e.Message;
        if AnsiPos('10013',CodOshibki)<>0 then begin  // 'Socket Error # 10013'#$D#$A'Access denied.'
          p_checkServerInfo.Caption:='Exception.Access denied';
          p_checkServerInfo.Font.Color:=clRed;
          Exit;
        end else if AnsiPos('long',CodOshibki)<>0 then begin
          //listServers[i].isRunning:=False;
          //Inc(countErrors);
        end;
      end;
    end;

      // подправим статусы
//      with FormServerIKCheck do begin
//
//        for j:=0 to ComponentCount-1 do begin
//          if Components[j].Name='lbl_'+IntToStr(listServers[i].id) then begin
//            if listServers[i].isRunning then begin  // НЕТ ОШИБКИ!!
//               (Components[j] as TLabel).Caption:='доступен';
//               (Components[j] as TLabel).Font.Color:=clGreen;
//            end
//            else begin                  // ЕСТЬ ОШИБКА!!!
//              (Components[j] as TLabel).Caption:='не доступен';
//              (Components[j] as TLabel).Font.Color:=clRed;
//            end;
//          end;
//        end;
//
//      end;
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
       m_log.Save(DBName+': '+messclass+':'+mess,True);
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


function TCheckServersIK.GetCheckServerFirebird(_id:Integer):Boolean;
var
 connectBD_Firebird:Boolean;
begin
  Result:=False;

  try
     connectBD_Firebird:=CheckServer(m_listServers[_id].ip,m_listServers[_id].alias);

     if connectBD_Firebird then Result:=True;
  except
      on E:Exception do
      begin
        Exit;
      end;
  end;
end;

function TCheckServersIK.GetAddress(_id:Integer):string;
begin
  Result:=m_listServers[_id].address;
end;

function TCheckServersIK.GetIP(_id:Integer):string;
begin
  Result:=m_listServers[_id].ip;
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

   for i:=0 to Count-1 do begin

    try
      connectBD_Firebird:=CheckServer(m_listServers[i].ip,m_listServers[i].alias);

      if not connectBD_Firebird then begin
        // увеличиаем кол-во
        if m_listServers[i].countErrors<countWarningsErrors then begin
          Inc(m_listServers[i].countErrors);
        end;
      end
      else begin
        if m_listServers[i].countErrors<>0 then begin
          if m_listServers[i].countErrors > 0 then begin
            Dec(m_listServers[i].countErrors);
          end;
        end;
      end;

    except
      on E:Exception do
      begin
        CodOshibki:=e.Message;
        if m_listServers[i].countErrors<countWarningsErrors then begin
          Inc(m_listServers[i].countErrors);
        end;
      end;
    end;

      // подправим статусы
      with p_formCheckServers do begin

        for j:=0 to ComponentCount-1 do begin
          if Components[j].Name='lbl_'+IntToStr(m_listServers[i].id) then begin
            if m_listServers[i].countErrors=0 then begin  // НЕТ ОШИБКИ!!
               (Components[j] as TLabel).Caption:='доступен';
               (Components[j] as TLabel).Font.Color:=colorOk;
            end
            else begin                                  // ЕСТЬ ОШИБКА!!!
              if m_listServers[i].countErrors<countWarningsErrors then begin
                (Components[j] as TLabel).Caption:='проблема';
                (Components[j] as TLabel).Font.Color:=colorWarning;
                isWarningError:=True;
                Inc(isWarningErrorCount);
              end;

              if m_listServers[i].countErrors=countWarningsErrors then begin
                (Components[j] as TLabel).Caption:='не доступен';
                (Components[j] as TLabel).Font.Color:=colorError;
              end;
            end;
          end;
        end;

      end;
   end;


  // надпись после проверки
  begin
     // кол-во с ошибками
      for i:=0 to Count-1 do begin
        if m_listServers[i].countErrors>=countWarningsErrors then begin
           Inc(allCountErrors);
        end;
      end;

      for i:=0 to Count-1 do begin

        if allCountErrors = 0 then begin

          if isWarningError then begin
           p_checkServerInfo.Caption:='возможная проблема ('+IntToStr(isWarningErrorCount)+') (подробнее)';
           p_checkServerInfo.Font.Color:=colorWarning;
          end
          else begin
           p_checkServerInfo.Caption:='отсутствуют';
           p_checkServerInfo.Font.Color:=colorOk;
          end;

          p_checkServerInfo.InitiateAction;
          p_checkServerInfo.Repaint;
        end
        else begin
          p_checkServerInfo.Font.Color:=colorError;

          case allCountErrors of
           1:begin
            for j:=0 to Count-1 do begin
              if m_listServers[j].countErrors>=countWarningsErrors then begin
                p_checkServerInfo.Caption:=m_listServers[j].address;
                p_checkServerInfo.InitiateAction;
                p_checkServerInfo.Repaint;
              end;
            end;
           end;
           2:begin
            viewErrors:=0;
            for j:=0 to Count-1 do begin
              if m_listServers[j].countErrors>=countWarningsErrors then begin
                if viewErrors=0 then begin
                 p_checkServerInfo.Caption:=m_listServers[j].address;
                 Inc(viewErrors);
                end
                else begin
                  p_checkServerInfo.Caption:=p_checkServerInfo.Caption+' и '+m_listServers[j].address;
                end;

                p_checkServerInfo.InitiateAction;
                p_checkServerInfo.Repaint;
              end;
            end;
           end;
          else
           viewErrors:=0;
            for j:=0 to Count-1 do begin
              if m_listServers[j].countErrors>=countWarningsErrors then begin
                if viewErrors=0 then begin
                 p_checkServerInfo.Caption:=m_listServers[j].address;
                 Inc(viewErrors);
                end
                else if (viewErrors=1) then begin
                  p_checkServerInfo.Caption:=p_checkServerInfo.Caption+' и '+m_listServers[j].address;
                  inc(viewErrors);
                end;

                p_checkServerInfo.InitiateAction;
                p_checkServerInfo.Repaint;
              end;
            end;

            if viewErrors>=2 then begin
             p_checkServerInfo.Caption:=p_checkServerInfo.Caption+' и еще '+IntToStr(allCountErrors-2)+' (нажмите сюда для показа...)';
             p_checkServerInfo.InitiateAction;
             p_checkServerInfo.Repaint;
            end;
          end;
        end;
      end;
  end;

end;

end.
