/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ                             ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit GlobalVariables;

interface

uses
  SysUtils, Windows;


  // загрузка DLL
  // --- connect_to_server.dll ---
 function GetServerAddress:string;      stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;         stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerNameTest:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы тестовой
 function GetServerUser:string;         stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string;     stdcall;   external 'connect_to_server.dll'; // пароль
 function GetTCPServerAddress:string;   stdcall;   external 'connect_to_server.dll'; // tcp server dashboard
 function GetTCPServerPort:word;        stdcall;   external 'connect_to_server.dll'; // tcp server dashboard port


implementation

initialization  // Инициализация



finalization

end.
