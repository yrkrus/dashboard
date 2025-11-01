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
  SysUtils, Windows, Classes, TCustomTypeUnit, TLogFileUnit, TCheckBoxUIUnit;



var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  REG_PHONE_EXE           :string = 'reg_phone.exe';

//  // ���� � �����������
//  SETTINGS_XML      :string = 'settings.xml';

  // ��� ������� �����
  SharedMainLog     :TLoggingFile;

  // ������� ���������� ������ ��������� reg_phone.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ reg_phone
  USER_STARTED_REG_PHONE_ID    :Integer;
  // ��� �� � �������� ���������
  USER_STARTED_PC_NAME         :string;

  // ������������� ���������������� ��� ���
  AUTO_REGISTER                : Boolean;

  // ������ ��������
  MANUAL_STARTED                :Boolean;

  // ���������� �� ��������
  PHONE_AUTH_USER               :string = 'admin';
  PHONE_AUTH_PWD                :string = '5000';


  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean = False;


  // ������ ������� �����
  HEIGHT_DEFAULT          :Word  = 122;
  WIDTH_DEFAULT           :Word  = 360;

 ///////////////////// CLASSES /////////////////////
  SharedCheckBoxUI          :TCheckBoxUI;          // ������ � ��������� ����������
 ///////////////////// CLASSES /////////////////////


implementation







initialization  // �������������
 FOLDERPATH                   :=ExtractFilePath(ParamStr(0));
 SharedMainLog                :=TLoggingFile.Create('reg_phone');   // ��� ������ �����
 SharedCheckBoxUI             := TCheckBoxUI.Create;

 finalization

end.
