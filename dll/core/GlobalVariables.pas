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
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // ����� �������
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // ����� ����
 function GetServerNameTest:string;     stdcall;   external 'connect_to_server.dll'; // ����� ���� ��������
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // �����
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // ������
 function GetTCPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // tcp server dashboard
 function GetTCPServerPort:word;        stdcall;   external 'connect_to_server.dll'; // tcp server dashboard port


implementation

initialization  // �������������



finalization

end.
