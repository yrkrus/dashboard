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

  SMS_EXE           :string = 'reg_phone.exe';

//  // файл с настройками
//  SETTINGS_XML      :string = 'settings.xml';

  // лог главной формы
  SharedMainLog     :TLoggingFile;

  // текущая директория откуда запускаем reg_phone.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл reg_phone
  USER_STARTED_SMS_ID    :Integer;

  // есть ли доступ к отправке расслыки напоминание о приеме
  //USER_ACCESS_SENDING_LIST  :Boolean;

  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean = False;


implementation



initialization  // Инициализация
 FOLDERPATH:=ExtractFilePath(ParamStr(0));
 SharedMainLog                :=TLoggingFile.Create('reg_phone');   // лог работы формы

 finalization

end.
