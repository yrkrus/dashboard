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
  SysUtils, Windows, TCustomTypeUnit;


var
  // ****************** ����� ���������� ******************
                      DEBUG:Boolean = TRUE;
  // ****************** ����� ���������� ******************

  REPORT_EXE :string = 'report.exe';

  // ������� ���������� ������ ��������� report.exe
  FOLDERPATH:string;

  // ����������� ������������ ������� ������ ������
  USER_STARTED_REPORT_ID    :Integer;

  // ���������� ������ ��� ����������� � ��
  CONNECT_BD_ERROR        :Boolean = False;
  // ���������� ������
  INTERNAL_ERROR          :Boolean =  False;

  // ���-�� �������(����� ��� ������������ ������ ����� � ��������� ������)
  MAX_COUNT_REPORT        :Word = 3;

implementation


initialization  // �������������
 FOLDERPATH:=ExtractFilePath(ParamStr(0));

 finalization

end.
