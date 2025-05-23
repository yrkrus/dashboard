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
   FOLDER_ICON_DESTINATION_AUTH       :string; // ����� -> images\auth
   FOLDER_ICON_MISSED_CALLS           :string; // ����� -> images\missed_calls
   FOLDER_ICON_ACTIVE_SESSION         :string; // ����� -> images\active_session
  //================ ���� ����� ================

  // ������ �����������(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;

  // ������ ������(images\missed_calls)
  ICON_MISSED_CALLS:string;

  // ������ kill session (images\active_session)
  ICON_ACTIVE_SESSION:string;


implementation

initialization
  // ================ ���� ����� INIT ================
  FOLDER_ICON                   := FOLDERPATH+'images\';            // ���������� ���� �� ������
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON+'auth\';             // ����� -> images\auth
  FOLDER_ICON_MISSED_CALLS      := FOLDER_ICON+'missed_calls\';     // ����� -> images\auth
  FOLDER_ICON_ACTIVE_SESSION    := FOLDER_ICON+'active_session\';   // ����� -> images\active_session

  // ================ ���� ����� INIT  ================

  // ������ �����������(images\auth)
  ICON_AUTH_USER          := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    := FOLDER_ICON_DESTINATION_AUTH + 'user_icon_auth_admin.png';
  ICON_MISSED_CALLS       := FOLDER_ICON_MISSED_CALLS     + 'phone_16.bmp';
  ICON_ACTIVE_SESSION     := FOLDER_ICON_ACTIVE_SESSION   + 'kill_session.bmp';
end.
