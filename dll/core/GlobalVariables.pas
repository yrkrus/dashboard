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
 function GetServerAddress:string;  stdcall;   external 'connect_to_server.dll'; // адрес сервера
 function GetServerName:string;     stdcall;   external 'connect_to_server.dll'; // адрес базы
 function GetServerUser:string;     stdcall;   external 'connect_to_server.dll'; // логин
 function GetServerPassword:string; stdcall;   external 'connect_to_server.dll'; // пароль


implementation

initialization  // Инициализация



finalization

end.
