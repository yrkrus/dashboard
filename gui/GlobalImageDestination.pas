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

  ///////////////////////// ���� ����� /////////////////////////
  // ���������� ���� �� ������
  FOLDER_ICON:string;

  // ����� -> images\auth
  FOLDER_ICON_DESTINATION_AUTH:string;
  //////////////////////////////////////////////////////////////

  // ������ �����������(images\auth)
  ICON_AUTH_USER: string;
  ICON_AUTH_USER_ADMIN: string;


implementation

initialization
  ///////////////////////// ���� ����� /////////////////////////
  // ���������� ���� �� ������
  FOLDER_ICON := FOLDERPATH+'images\';

  // ����� -> images\auth
  FOLDER_ICON_DESTINATION_AUTH  := FOLDER_ICON+'auth\';
  //////////////////////////////////////////////////////////////

  // ������ �����������(images\auth)
  ICON_AUTH_USER          := FOLDER_ICON_DESTINATION_AUTH+'user_icon_auth.png';
  ICON_AUTH_USER_ADMIN    := FOLDER_ICON_DESTINATION_AUTH+'user_icon_auth_admin.png';

end.
