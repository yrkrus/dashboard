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
  SysUtils, Windows, Classes, TCustomTypeUnit, TLogFileUnit, TCheckBoxUIUnit;



var
  // ****************** режим разработки ******************
                      DEBUG:Boolean = FALSE;
  // ****************** режим разработки ******************

  REG_PHONE_EXE           :string = 'reg_phone.exe';

//  // файл с настройками
//  SETTINGS_XML      :string = 'settings.xml';

  // лог главной формы
  SharedMainLog     :TLoggingFile;

  // текущая директория откуда запускаем reg_phone.exe
  FOLDERPATH:string;

  // Залогиненый польщователь который открыл reg_phone
  USER_STARTED_REG_PHONE_ID    :Integer;
  // ИМЯ ПК с которого запустили
  USER_STARTED_PC_NAME         :string;
  // автоматически пытаться зарешестироватбься сразу
  USER_AUTO_REGISTERED_SIP_PHONE:Boolean;

  // автоматически регистрироваться или нет
  AUTO_REGISTER                : Boolean;

  // ручное открытие
  MANUAL_STARTED                :Boolean;

  // аторизация на телефоне
  PHONE_AUTH_USER               :string = 'admin';
  PHONE_AUTH_PWD                :string = '5000';


  // глобальная ошибка при подкобчении к БД
  CONNECT_BD_ERROR        :Boolean = False;
  // внутренняя ошибка
  INTERNAL_ERROR          :Boolean = False;


  // размер главной формы
  HEIGHT_DEFAULT          :Word  = 122;
  WIDTH_DEFAULT           :Word  = 360;

 ///////////////////// CLASSES /////////////////////
  SharedCheckBoxUI          :TCheckBoxUI;          // список с красивыми чекбоксами
 ///////////////////// CLASSES /////////////////////


implementation







initialization  // Инициализация
 FOLDERPATH                   :=  ExtractFilePath(ParamStr(0));
 SharedMainLog                :=  TLoggingFile.Create('reg_phone');   // лог работы формы
 SharedCheckBoxUI             :=  TCheckBoxUI.Create;

 finalization

end.
