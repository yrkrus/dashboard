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
  SysUtils, Windows;


  // �������� DLL
  // --- connect_to_server.dll ---
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // ������


implementation

initialization  // �������������



finalization

end.
