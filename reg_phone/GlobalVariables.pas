/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ���������� ����������                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils, Windows, Classes, TCustomTypeUnit, TLogFileUnit;



var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  SMS_EXE           :string = 'reg_phone.exe';

//  // ���� � �����������
//  SETTINGS_XML      :string = 'settings.xml';

  // ��� ������� �����
  SharedMainLog     :TLoggingFile;

  // ������� ���������� ������ ��������� reg_phone.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ reg_phone
  USER_STARTED_SMS_ID    :Integer;

  // ���� �� ������ � �������� �������� ����������� � ������
  //USER_ACCESS_SENDING_LIST  :Boolean;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean = False;


implementation



initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));
 SharedMainLog                :=TLoggingFile.Create('reg_phone');   // ��� ������ �����

 finalization

end.
