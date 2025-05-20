/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ПУТЕЙ СТАТИТЕСКИХ ИЗОБРАЖЕНИЙ               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalImageDestination;


interface

uses
  GlobalVariables;

var

  // ================ ПУТИ ПАПОК ================
   FOLDER_ICON                        :string; // абсолютный путь до иконок
   FOLDER_ICON_DESTINATION_AUTH       :string; // папка -> images\auth
   FOLDER_ICON_MISSED_CALLS           :string; // папка -> images\missed_calls
   FOLDER_ICON_ACTIVE_SESSION         :string; // папка -> images\active_session
  //================ ПУТИ ПАПОК ================

  // иконка авторизации(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;

  // иконка звонка(images\missed_calls)
  ICON_MISSED_CALLS:string;

  // иконка kill session (images\active_session)
  ICON_ACTIVE_SESSION:string;


implementation

initialization
  // ================ ПУТИ ПАПОК INIT ================
  FOLDER_ICON                   := FOLDERPATH+'images\';            // абсолютный путь до иконок
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON+'auth\';             // папка -> images\auth
  FOLDER_ICON_MISSED_CALLS      := FOLDER_ICON+'missed_calls\';     // папка -> images\auth
  FOLDER_ICON_ACTIVE_SESSION    := FOLDER_ICON+'active_session\';   // папка -> images\active_session

  // ================ ПУТИ ПАПОК INIT  ================

  // иконка авторизации(images\auth)
  ICON_AUTH_USER          := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth_admin.png';
  ICON_MISSED_CALLS       := FOLDER_ICON_MISSED_CALLS     + 'phone_16.bmp';
  ICON_ACTIVE_SESSION     := FOLDER_ICON_ACTIVE_SESSION   + 'kill_session.bmp';
end.
