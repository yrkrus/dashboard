unit FormHomeInit;

interface
  uses System.SysUtils, Winapi.Windows;


procedure _INIT;    // инициализация формы
procedure _CHECK;   // проверки перед запуском


implementation

uses
  FormHome, GlobalVariables, FunctionUnit, GlobalVariablesLinkDLL, FormDEBUGUnit, TCustomTypeUnit;



procedure _CHECK;
var
 errorDescription:string;
 countKillExe:Integer;
begin
  // проверка на 2ую копию дошборда
  if GetCloneRun(PChar(DASHBOARD_EXE)) then begin
    MessageBox(HomeForm.Handle,PChar('Обнаружен запуск 2ой копии программы'+#13#13+
                                     'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
    KillProcess;
  end;

  // убираем reg_phone если был не закрыт
  if GetCloneRun(PChar(REG_PHONE_EXE)) then begin
     countKillExe:=0;
     while GetTask(PChar(REG_PHONE_EXE)) do begin
       KillTask(PChar(REG_PHONE_EXE));

       // на случай если не удасться закрыть дочерний exe
       Sleep(500);
       Inc(countKillExe);
       if countKillExe>10 then Break;
     end;
  end;

  // остаток свободного места на диске
  if not isExistFreeSpaceDrive(errorDescription) then begin
    ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
  end;

  // проверка установлен ли MySQL Connector
  if not isExistMySQLConnector then begin
    errorDescription:='Не установлен MySQL Connector';
    ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
  end;

   // доступно ли ядро (в дебаг не проверяем)
   if not DEBUG then begin
     if not GetAliveCoreDashboard then begin
      errorDescription:='Критическая ошибка! Недоступен TCP сервер'+#13+
                                  '('+GetTCPServerAddress+' : '+IntToStr(GetTCPServerPort)+')'+#13#13+
                                  'Свяжитесь с отделом ИТ';
      ShowFormErrorMessage(errorDescription,SharedMainLog,'THomeForm.FormShow');
     end;
   end;

  // отображение текущей версии
  with HomeForm do begin
   if DEBUG then Caption:='    ===== DEBUG | (base:'+_dll_GetDefaultDataBase+') =====    ' + Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')'
   else Caption:=Caption+' '+GetVersion(GUID_VERSION,eGUI) + ' | '+'('+GUID_VERSION+')';
  end;

  // проверка на ткущую версию
  CheckCurrentVersion;

  // очистка от временных файлов после автообновления
  ClearAfterUpdate;
end;


procedure _INIT;
begin
      // стататус бар
   with HomeForm.StatusBar do begin
    Panels[2].Text:='Регистрация телефона [-]';
    Panels[3].Text:=SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name;
    Panels[4].Text:=GetUserRoleSTR(SharedCurrentUserLogon.ID);
    Panels[5].Text:=GetCopyright;
   end;

  // заведение данных о текущей сесии
  CreateCurrentActiveSession(SharedCurrentUserLogon.ID);

  // создание списка серверов для проверки доступности
  createCheckServersInfoclinika;

  // создание списка sip trunk для проверки
  CreateCheckSipTrunk;

  // прогрузка индивидуальных настроек пользователя
  LoadIndividualSettingUser(SharedCurrentUserLogon.ID);

  // выставление прав доступа
  AccessRights(SharedCurrentUserLogon);

  // прогрузка красивых чекбоксов на форме
  AddCustomCheckBoxUI;

  // линковка окна формы debug info в класс для подсчета статистики работы потоков
  SharedCountResponseThread.SetAddForm(FormDEBUG);

  // очищаем все лист боксы
  clearAllLists;

  // footer_menu (смена своего пароля)
  if SharedCurrentUserLogon.Auth = eAuthLdap then HomeForm.menu_ChangePassword.Visible:=False;

  // отображение только нужных очередей
  AccessUsersCommonQueue(SharedCurrentUserLogon.QueueList);

  // размер главной офрмы экрана
  WindowStateInit;

  // пасхалки
  Egg;

  // дата+время старта
  PROGRAM_STARTED:=Now;
end;
end.
