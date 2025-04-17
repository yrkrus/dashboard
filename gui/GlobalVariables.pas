/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB,
  Data.DB, SysUtils, Windows, TLogFileUnit,
  TIVRUnit, TCustomTypeUnit, TFontSizeUnit,
  TDebugCountResponseUnit, GlobalVariablesLinkDLL;


var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  // текущая директория откуда запускаем *.exe
  FOLDERPATH        :string;

  // папка с обноалением
  FOLDERUPDATE      :string;

  // Текущая версия GUID   ctrl+shift+G (GUID)
  GUID_VERSION      :string = '425D7DB4';

  // exe родителя
  DASHBOARD_EXE     :string = 'dashboard.exe';

  // файл с настройками
  SETTINGS_XML      :string = 'settings.xml';

  // чат
  CHAT_EXE          :string = 'chat.exe';
  // отчеты
  REPORT_EXE        :string = 'report.exe';
  // sms рассылка
  SMS_EXE           :string = 'sms.exe';
  // редактор услуг
  SERVICE_EXE       :string = 'service.exe';


  USER_ID_PARAM     :string = '--USER_ID';
  USER_ACCESS_PARAM :string = '--ACCESS';

  // по умолчанию nullptr потом поменяем
  USER_STARTED_SMS_ID :Integer;

  // служба обновления
  UPDATE_EXE        : string = 'update.exe';
  UPDATE_SERVICES   : string = 'update_dashboard';
  UPDATE_BAT        : string = 'update.bat'; // обновлялка

  // размер остатка свободного места при котором дашборд не запуститься
  FREE_SPACE_COUNT        :Integer = 100;

  // разница между стандартным размером окна 1470 - 1094(форма на стартовом окне)
  DEFAULT_SIZE_PANEL_ACTIVESIP :Word = 383;

  // uptime
  PROGRAMM_UPTIME:Int64 = 0;
  PROGRAM_STARTED:TDateTime;

  ///////////////////// CLASSES /////////////////////

  // лог главной формы
  SharedMainLog:TLoggingFile;

  // текущий залогиненый пользователь в системе
  SharedCurrentUserLogon: TUser;

  // список с текущими активными операторами
  SharedActiveSipOperators: TActiveSIP;

  // список с текущим IVR кто звонит на линию
  SharedIVR: TIVR;

  // размеры шрифтов на дашборде
  SharedFontSize: TFontSize;

  // список для отслеживания времени работы в потоках
  SharedCountResponseThread:TDebugCountResponse;


 ///////////////////// CLASSES /////////////////////


  // параметр для лога что есть ошибка
  IS_ERROR:Boolean = True;

  // глобальная ошибка при подключении к БД
  CONNECT_BD_ERROR        :Boolean = False;



implementation



initialization  // Инициализация
  FOLDERPATH      :=ExtractFilePath(ParamStr(0));
  FOLDERUPDATE    :=FOLDERPATH+GetUpdateNameFolder;

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedMainLog             := TLoggingFile.Create('main');   // лог работы main формы
  SharedFontSize            := TFontSize.Create;
  SharedCountResponseThread := TDebugCountResponse.Create(SharedMainLog);

finalization
  // Освобождение памяти
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  //SharedLoggingFile.Free;

end.
