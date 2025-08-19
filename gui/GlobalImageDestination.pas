/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         √ÀŒ¡¿À‹Õ€≈ œ≈–≈Ã≈ÕÕ€≈ œ”“≈… —“¿“»“≈— »’ »«Œ¡–¿∆≈Õ»…               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalImageDestination;


interface

uses
  GlobalVariables;

var

  // ================ œ”“» œ¿œŒ  ================
   FOLDER_ICON                        :string; // ‡·ÒÓÎ˛ÚÌ˚È ÔÛÚ¸ ‰Ó ËÍÓÌÓÍ
   FOLDER_ICON_DESTINATION_AUTH       :string; // Ô‡ÔÍ‡ -> images\auth              | dashboard.exe
   FOLDER_ICON_MISSED_CALLS           :string; // Ô‡ÔÍ‡ -> images\missed_calls      | dashboard.exe
   FOLDER_ICON_ACTIVE_SESSION         :string; // Ô‡ÔÍ‡ -> images\active_session    | dashboard.exe
   FOLDER_ICON_REPORT                 :string; // Ô‡ÔÍ‡ -> images\report            | report.exe
  //================ œ”“» œ¿œŒ  ================

  // ËÍÓÌÍ‡ ‡‚ÚÓËÁ‡ˆËË(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;

  // ËÍÓÌÍ‡ Á‚ÓÌÍ‡(images\missed_calls)
  ICON_MISSED_CALLS:string;

  // ËÍÓÌÍ‡ kill session (images\active_session)
  ICON_ACTIVE_SESSION:string;

  // ËÍÓÌÍ‡ excel (images\report)
  ICON_REPORT:string;


implementation

initialization
  // ================ œ”“» œ¿œŒ  INIT ================
  FOLDER_ICON                   := FOLDERPATH   + 'images\';           // ‡·ÒÓÎ˛ÚÌ˚È ÔÛÚ¸ ‰Ó ËÍÓÌÓÍ
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON  + 'auth\';             // Ô‡ÔÍ‡ -> images\auth
  FOLDER_ICON_MISSED_CALLS      := FOLDER_ICON  + 'missed_calls\';     // Ô‡ÔÍ‡ -> images\auth
  FOLDER_ICON_ACTIVE_SESSION    := FOLDER_ICON  + 'active_session\';   // Ô‡ÔÍ‡ -> images\active_session
  FOLDER_ICON_REPORT            := FOLDER_ICON  + 'report\';           // Ô‡ÔÍ‡ -> images\report

  // ================== » ŒÕ » INIT  =================
  ICON_AUTH_USER          := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth_admin.png';
  ICON_MISSED_CALLS       := FOLDER_ICON_MISSED_CALLS     + 'phone_16.bmp';
  ICON_ACTIVE_SESSION     := FOLDER_ICON_ACTIVE_SESSION   + 'kill_session.bmp';
  ICON_REPORT             := FOLDER_ICON_REPORT           + 'excel.bmp';
end.
