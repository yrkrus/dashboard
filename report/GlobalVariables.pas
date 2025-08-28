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
  SysUtils, Windows, TCustomTypeUnit;


var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = TRUE;
  // ****************** режим разработки ******************

  REPORT_EXE :string = 'report.exe';

  // текущая директория откуда запускаем report.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл отчеты
  USER_STARTED_REPORT_ID    :Integer;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean =  False;

  // кол-во отчетов(нужно для формирования иконки рядом с названием отчета)
  MAX_COUNT_REPORT        :Word = 3;

implementation


initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
