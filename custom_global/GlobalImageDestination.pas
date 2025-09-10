/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         ���������� ���������� ����� ����������� �����������               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalImageDestination;


interface

uses
  GlobalVariables;

var

  // ================ ���� ����� ================
   FOLDER_ICON                        :string; // ���������� ���� �� ������
   FOLDER_ICON_DESTINATION_AUTH       :string; // ����� -> images\auth              | dashboard.exe
   FOLDER_ICON_MISSED_CALLS           :string; // ����� -> images\missed_calls      | dashboard.exe
   FOLDER_ICON_ACTIVE_SESSION         :string; // ����� -> images\active_session    | dashboard.exe
   FOLDER_ICON_REPORT                 :string; // ����� -> images\report            | report.exe
   FOLDER_ICON_SMS                    :string; // ����� -> images\sms               | sms.exe
  //================ ���� ����� ================

  // ������ �����������(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;

  // ������ ������(images\missed_calls)
  ICON_MISSED_CALLS:string;

  // ������ kill session (images\active_session)
  ICON_ACTIVE_SESSION:string;

  // ������ excel (images\report)
  ICON_REPORT:string;

  // ������ ������� sms (images\sms)
  ICON_SMS_STATUS_ABORT         :string;
  ICON_SMS_STATUS_DELIVERED     :string;
  ICON_SMS_STATUS_ERROR         :string;
  ICON_SMS_STATUS_NOT_DELIVERED :string;
  ICON_SMS_STATUS_QUEUE         :string;
  ICON_SMS_STATUS_SENDING_OPERATOR:string;


implementation

initialization
  // ================ ���� ����� INIT ================
  FOLDER_ICON                   := FOLDERPATH   + 'images\';           // ���������� ���� �� ������
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON  + 'auth\';             // ����� -> images\auth
  FOLDER_ICON_MISSED_CALLS      := FOLDER_ICON  + 'missed_calls\';     // ����� -> images\auth
  FOLDER_ICON_ACTIVE_SESSION    := FOLDER_ICON  + 'active_session\';   // ����� -> images\active_session
  FOLDER_ICON_REPORT            := FOLDER_ICON  + 'report\';           // ����� -> images\report
  FOLDER_ICON_SMS               := FOLDER_ICON  + 'sms\';              // ����� -> images\sms

  // ================== ������ INIT  =================
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
