 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                 Индивидуальные настройки пользователя                     ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TIndividualSettingUserUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit,
   Data.Win.ADODB, Data.DB, System.Variants, IdException;


 // class TIndividualSettingUser
  type
      TIndividualSettingUser = class

      private
      m_userID                  :Integer;
      m_go_home                 :enumParamStatus;
      m_no_confirmExit          :enumParamStatus;
      m_statistics_queue_day    :enumParamStatus;
      m_auto_register_sip_phone :enumParamStatus;

      procedure LoadData;       // прогрузка данных
      function IsExistSettingUsers:Boolean;            // проверка существу.т ли индивидуальные настрокий пользователч
      function GetStatusIndividualSettingsUser(_settings:enumSettingUsers):enumParamStatus;
      function SendCommand(_response:string; var _errorDescriptions:string):boolean;

      function Status_GoHome:Boolean;
      function Status_NoConfirmExit:Boolean;
      function StatusStatisticsQueueDay:Boolean;
      function Status_AutoRegisterSipPhone:Boolean;

      public
      constructor Create(_userID:Integer);               overload;
      function SaveIndividualSettingUser(_settings:enumSettingUsers; _status:enumParamStatus;
                                          var _errorDescription:string):Boolean;



      property GoHome:Boolean read Status_GoHome;
      property NoConfirmExit:Boolean read Status_NoConfirmExit;
      property StatisticsQueueDay:Boolean read StatusStatisticsQueueDay;
      property AutoRegisterSipPhone:Boolean read Status_AutoRegisterSipPhone;

      end;
 // class TIndividualSettingUser END

implementation

uses
  GlobalVariablesLinkDLL;


constructor TIndividualSettingUser.Create(_userID:Integer);
begin
 m_userID:=_userID;
 LoadData;
end;


// прогрузка данных
procedure TIndividualSettingUser.LoadData;
begin
 m_go_home                 :=GetStatusIndividualSettingsUser(settingUsers_gohome);
 m_no_confirmExit          :=GetStatusIndividualSettingsUser(settingUsers_noConfirmExit);
 m_statistics_queue_day    :=GetStatusIndividualSettingsUser(settingUsers_showStatisticsQueueDay);
 m_auto_register_sip_phone :=GetStatusIndividualSettingsUser(settingUsers_autoRegisteredSipPhone);
end;


// проверка существу.т ли индивидуальные настрокий пользователч
function TIndividualSettingUser.IsExistSettingUsers:Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
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

 try
    with ado do begin
      ado.Connection:=serverConnect;

      SQL.Clear;
      SQL.Add('select count(user_id) from settings_users where user_id = '+#39+IntToStr(m_userID)+#39);
      Active:=True;

      if Fields[0].Value<>0 then Result:=True
      else Result:=False;
    end;
 finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
 end;
end;


function TIndividualSettingUser.GetStatusIndividualSettingsUser(_settings:enumSettingUsers):enumParamStatus;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;

begin
 Result:=paramStatus_DISABLED;
 if not IsExistSettingUsers then Exit;

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

  try
    with ado do begin
      ado.Connection:=serverConnect;

       SQL.Clear;
       case _settings of
        settingUsers_gohome: begin // не показывать ушедших домой
          SQL.Add('select go_home from settings_users where user_id = '+#39+IntToStr(m_userID)+#39);
        end;
        settingUsers_noConfirmExit:begin // не показывать "Точно хотите выйти?"
          SQL.Add('select no_confirmExit from settings_users where user_id = '+#39+IntToStr(m_userID)+#39);
        end;
        settingUsers_showStatisticsQueueDay:begin  // какой тип графика отображать в модуле "сатистика ожидания в очереди" 0-цифры | 1 - график
          SQL.Add('select statistics_queue_day from settings_users where user_id = '+#39+IntToStr(m_userID)+#39);
        end;
        settingUsers_autoRegisteredSipPhone:begin  // автоматическая регистрация в sip телефоне
          SQL.Add('select auto_register_sip_phone from settings_users where user_id = '+#39+IntToStr(m_userID)+#39);
        end;
       end;
      Active:=True;

      if Fields[0].Value<>null then begin
        if VarToStr(Fields[0].Value) = '1'  then Result:=paramStatus_ENABLED
        else Result:=paramStatus_DISABLED;
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


function TIndividualSettingUser.SaveIndividualSettingUser(_settings:enumSettingUsers; _status:enumParamStatus;
                                                          var _errorDescription:string):Boolean;
var
 response:string;
begin
  Result:=False;
  _errorDescription:='';

   case _settings of
    settingUsers_gohome: begin // не показывать ушедших домой

      // проверяем есть ли уже запись
      if isExistSettingUsers then begin
        response:='update settings_users set go_home = '+#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+' where user_id = '+#39+IntToStr(m_userID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,go_home) values ('+#39+IntToStr(m_userID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+')';
      end;
    end;
    settingUsers_noConfirmExit: begin  // не показывать окно "точно хотите выйти из дашборда?"

      // проверяем есть ли уже запись
      if isExistSettingUsers then begin
        response:='update settings_users set no_confirmExit = '+#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+' where user_id = '+#39+IntToStr(m_userID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,no_confirmExit) values ('+#39+IntToStr(m_userID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+')';
      end;
    end;
    settingUsers_showStatisticsQueueDay:begin  // какой тип графика отображать в модуле "сатистика ожидания в очереди" 0-цифры | 1 - график
      // проверяем есть ли уже запись
      if isExistSettingUsers then begin
        response:='update settings_users set statistics_queue_day = '+#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+' where user_id = '+#39+IntToStr(m_userID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,statistics_queue_day) values ('+#39+IntToStr(m_userID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+')';
      end;
    end;
    settingUsers_autoRegisteredSipPhone:begin  // автоматическая регистрация в sip телефоне
      // проверяем есть ли уже запись
      if isExistSettingUsers then begin
        response:='update settings_users set auto_register_sip_phone = '+#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+' where user_id = '+#39+IntToStr(m_userID)+#39;

      end
      else begin
        response:='insert into settings_users (user_id,auto_register_sip_phone) values ('+#39+IntToStr(m_userID) +#39+','
                                                                         +#39+IntToStr(SettingParamsStatusToInteger(_status))+#39+')';
      end;
    end;
   end;

  // выполняем запрос
  Result:=SendCommand(response, _errorDescription);
end;


function TIndividualSettingUser.Status_GoHome:Boolean;
begin
  Result:=EnumParamStatusToBoolean(m_go_home);
end;

function TIndividualSettingUser.Status_NoConfirmExit:Boolean;
begin
  Result:=EnumParamStatusToBoolean(m_no_confirmExit);
end;

function TIndividualSettingUser.StatusStatisticsQueueDay:Boolean;
begin
  Result:=EnumParamStatusToBoolean(m_statistics_queue_day);
end;

function TIndividualSettingUser.Status_AutoRegisterSipPhone:Boolean;
begin
  Result:=EnumParamStatusToBoolean(m_auto_register_sip_phone);
end;


function TIndividualSettingUser.SendCommand(_response:string; var _errorDescriptions:string):boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  _errorDescriptions:='';
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnectWithError(_errorDescriptions);

  if not Assigned(serverConnect) then begin
     Result:=False;
     FreeAndNil(ado);
     Exit;
  end;

   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(_response);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               Result:=False;

               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;
               _errorDescriptions:='Внутренняя ошибка сервера "'+e.ClassName+'": '+e.Message;
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

end.