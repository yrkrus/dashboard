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
   FOLDER_ICON_SMS                    :string; // Ô‡ÔÍ‡ -> images\sms               | sms.exe
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

  // ËÍÓÌÍ‡ ÒÚ‡ÚÛÒ˚ sms (images\sms)
  ICON_SMS_STATUS_ABORT         :string;
  ICON_SMS_STATUS_DELIVERED     :string;
  ICON_SMS_STATUS_ERROR         :string;
  ICON_SMS_STATUS_NOT_DELIVERED :string;
  ICON_SMS_STATUS_QUEUE         :string;
  ICON_SMS_STATUS_SENDING_OPERATOR:string;


implementation

initialization
  // ================ œ”“» œ¿œŒ  INIT ================
  FOLDER_ICON                   := FOLDERPATH   + 'images\';           // ‡·ÒÓÎ˛ÚÌ˚È ÔÛÚ¸ ‰Ó ËÍÓÌÓÍ
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON  + 'auth\';             // Ô‡ÔÍ‡ -> images\auth
  FOLDER_ICON_MISSED_CALLS      := FOLDER_ICON  + 'missed_calls\';     // Ô‡ÔÍ‡ -> images\auth
  FOLDER_ICON_ACTIVE_SESSION    := FOLDER_ICON  + 'active_session\';   // Ô‡ÔÍ‡ -> images\active_session
  FOLDER_ICON_REPORT            := FOLDER_ICON  + 'report\';           // Ô‡ÔÍ‡ -> images\report
  FOLDER_ICON_SMS               := FOLDER_ICON  + 'sms\';              // Ô‡ÔÍ‡ -> images\sms

  // ================== » ŒÕ » INIT  =================
  ICON_AUTH_USER                := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN          := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth_admin.png';
  ICON_MISSED_CALLS             := FOLDER_ICON_MISSED_CALLS     + 'phone_16.bmp';
  ICON_ACTIVE_SESSION           := FOLDER_ICON_ACTIVE_SESSION   + 'kill_session.bmp';
  ICON_REPORT                   := FOLDER_ICON_REPORT           + 'excel.bmp';
  ICON_SMS_STATUS_ABORT         := FOLDER_ICON_SMS              + 'sms_status_abort.jpg';
  ICON_SMS_STATUS_DELIVERED     := FOLDER_ICON_SMS              + 'sms_status_delivered.jpg';
  ICON_SMS_STATUS_ERROR         := FOLDER_ICON_SMS              + 'sms_status_error.jpg';
  ICON_SMS_STATUS_NOT_DELIVERED := FOLDER_ICON_SMS              + 'sms_status_not_delivered.jpg';
  ICON_SMS_STATUS_QUEUE         := FOLDER_ICON_SMS              + 'sms_status_queue.jpg';
  ICON_SMS_STATUS_SENDING_OPERATOR:= FOLDER_ICON_SMS            + 'sms_status_sending_operator.jpg';

end.
