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
  Forms,
  TActiveSIPUnit, TUserUnit, Data.Win.ADODB, Data.DB, SysUtils, Windows, TLogFileUnit,
  TIVRUnit, TCustomTypeUnit, TFontSizeUnit, TQueueStatisticsUnit, TStatusUnit,
  TDebugCountResponseUnit, GlobalVariablesLinkDLL, TCheckBoxUIUnit;

 type // глобальный перехват всех незарегистрированных исключений
  TGlobalExeption = class
  public
    procedure HandleGlobalException(Sender: TObject; E: Exception);
    procedure Setup;
  end;


var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  // текущая директория откуда запускаем *.exe
  FOLDERPATH        :string;

  // папка с обноалением
  FOLDERUPDATE      :string;

  // Текущая версия GUID   ctrl+shift+G (GUID)
  GUID_VERSION      :string = 'A427F0B5';

  // exe родителя
  DASHBOARD_EXE     :string = 'dashboard.exe';

  // файл с настройками
  SETTINGS_XML      :string = 'settings.xml';

  ///////////////////// MODULE /////////////////////
  CHAT_EXE          :string = 'chat.exe';         // чат
  REPORT_EXE        :string = 'report.exe';       // отчеты
  SMS_EXE           :string = 'sms.exe';          // sms
  SERVICE_EXE       :string = 'service.exe';      // редактор услуг
  OUTGOING_EXE      :string = 'outgoing.exe';     // звонилка
  REG_PHONE_EXE     :string = 'reg_phone.exe';    // регистрация телефона
  ///////////////////// MODULE /////////////////////

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
  SharedMainLog             :TLoggingFile;         // лог главной формы
  SharedCurrentUserLogon    :TUser;                // текущий залогиненый пользователь в системе
  SharedActiveSipOperators  :TActiveSIP;           // список с текущими активными операторами
  SharedIVR                 :TIVR;                 // список с текущим IVR кто звонит на линию
  SharedQueueStatistics     :TQueueStatistics;     // список с текущей статистикой звонков за день
  SharedFontSize            :TFontSize;            // размеры шрифтов на дашборде
  SharedCountResponseThread :TDebugCountResponse;  // список для отслеживания времени работы в потоках
  SharedStatus              :TStatus;              // смена текущего статуса оператора
  SharedCheckBoxUI          :TCheckBoxUI;          // список с красивыми чекбоксами
 ///////////////////// CLASSES /////////////////////


  // параметр для лога что есть ошибка
  IS_ERROR:Boolean = True;

  // глобальная ошибка при подключении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  GlobalExceptions        :TGlobalExeption;


implementation



procedure TGlobalExeption.HandleGlobalException(Sender: TObject; E: Exception);
begin
   SharedMainLog.Save('Global Exception: ' + E.ClassName + ': ' + E.Message, IS_ERROR);
end;

procedure TGlobalExeption.Setup;
begin
  Application.OnException:=HandleGlobalException;
end;

initialization  // Инициализация

  FOLDERPATH      :=ExtractFilePath(ParamStr(0));
  FOLDERUPDATE    :=FOLDERPATH+GetUpdateNameFolder;

  SharedActiveSipOperators  := TActiveSIP.Create;
  SharedIVR                 := TIVR.Create;
  SharedQueueStatistics     := TQueueStatistics.Create(True);
  SharedMainLog             := TLoggingFile.Create('main');   // лог работы main формы
  SharedFontSize            := TFontSize.Create;
  SharedCountResponseThread := TDebugCountResponse.Create(SharedMainLog);
  SharedStatus              := TStatus.Create(True);
  SharedCheckBoxUI          := TCheckBoxUI.Create;

  begin
    GlobalExceptions        := TGlobalExeption.Create;
    GlobalExceptions.Setup;
  end;


finalization

  // Освобождение памяти
  GlobalExceptions.Free;
  SharedIVR.Free;
  SharedQueueStatistics.Free;
  SharedActiveSipOperators.Free;
  SharedCurrentUserLogon.Free;
  SharedCountResponseThread.Free;
  SharedStatus.Free;
  SharedCheckBoxUI.Free;

end.
