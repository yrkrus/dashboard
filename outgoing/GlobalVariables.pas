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

  OUTGOING_EXE           :string = 'outgoing.exe';

  // ���� � �����������
  SETTINGS_XML      :string = 'settings.xml';

  // ��� ������� �����
  SharedMainLog     :TLoggingFile;

  // ������� ���������� ������ ��������� ougoing.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ ougoing.exe
  USER_STARTED_OUTGOING_ID    :Integer;

  // ���� �� ������ � �������
  USER_ACCESS_SENDING_LIST  :Boolean;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean = False;


implementation



initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 SharedMainLog                :=TLoggingFile.Create('outgoing');   // ��� ������ �����


 finalization

end.
