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
  SysUtils, Windows, Classes, TCustomTypeUnit, TLogFileUnit;



var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  OUTGOING_EXE      :string = 'outgoing.exe';

  // файл с настройками
  SETTINGS_XML      :string = 'settings.xml';

  // лог главной формы
  SharedMainLog     :TLoggingFile;

  // текущая директория откуда запускаем ougoing.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл ougoing.exe
  USER_STARTED_OUTGOING_ID    :Integer;

  // номер звонка при атвоматическом вызове
  USER_PHONE_CALL  :string;

  // автоматический запуск (при этом параметре звоним сразу на номер)
  AUTO_RUN                :Boolean = False;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean = False;


implementation



initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedMainLog                :=TLoggingFile.Create('outgoing');   // лог работы формы


 finalization

end.
