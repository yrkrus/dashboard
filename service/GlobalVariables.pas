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
  SysUtils, Windows, Classes, TServiceUnit;

var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  SERVICE_EXE           :string = 'service.exe';

  // Залогиненый польщователь который открыл услуги
  USER_STARTED_SERVICE_ID    :Integer;

  // файл с настройками
  SETTINGS_XML          :string = 'settings.xml';

  // текущая директория откуда запускаем service.exe
  FOLDERPATH:string;

  // текущий список с услугами
  SharedServiceList             :TService;
  SharedServiceListLoading      :TService;   // список услуг которые будут загружены из csv файла


implementation



initialization  // Инициализация
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedServiceListLoading    :=TService.Create(True);

end.
