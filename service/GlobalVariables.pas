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
  SysUtils, Windows, Classes, TServiceUnit;

var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  SERVICE_EXE           :string = 'service.exe';

  // ����������� ������������ ������� ������ ������
  USER_STARTED_SERVICE_ID    :Integer;

  // ���� � �����������
  SETTINGS_XML          :string = 'settings.xml';

  // ������� ���������� ������ ��������� service.exe
  FOLDERPATH:string;

  // ������� ������ � ��������
  SharedServiceList             :TService;
  SharedServiceListLoading      :TService;   // ������ ����� ������� ����� ��������� �� csv �����


implementation



initialization  // �������������
  FOLDERPATH:=ExtractFilePath(ParamStr(0));

  SharedServiceListLoading    :=TService.Create(True);

end.
