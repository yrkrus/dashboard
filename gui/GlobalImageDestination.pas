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

  ///////////////////////// ПУТИ ПАПОК /////////////////////////
  // абсолютный путь до иконок
  FOLDER_ICON:string;

  // папка -> images\auth
  FOLDER_ICON_DESTINATION_AUTH:string;
  //////////////////////////////////////////////////////////////

  // иконка авторизации(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;


implementation

initialization
  ///////////////////////// ПУТИ ПАПОК /////////////////////////
  // абсолютный путь до иконок
  FOLDER_ICON := FOLDERPATH+'images\';

  // папка -> images\auth
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON+'auth\';
  //////////////////////////////////////////////////////////////

  // иконка авторизации(images\auth)
  ICON_AUTH_USER          := FOLDER_ICON_DESTINATION_AUTH+'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    := FOLDER_ICON_DESTINATION_AUTH+'user_icon_auth_admin.png';

end.
