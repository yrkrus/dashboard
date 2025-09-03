unit FunctionUnit;

interface

uses
FormHomeUnit,
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
 System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
 Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
 IdSSL,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,System.IniFiles,
 Winapi.WinSock,  Vcl.ComCtrls, GlobalVariables, Vcl.Grids, Data.Win.ADODB,
 Data.DB, IdException,  Vcl.Menus, System.SyncObjs,
 TCustomTypeUnit, Word_TLB, ActiveX, Winapi.RichEdit,
 Vcl.Imaging.Jpeg, System.IOUtils, Vcl.ExtCtrls;


procedure CreateCopyright;                                                                    // создание Copyright


implementation

uses
  GlobalVariablesLinkDLL;


// создание Copyright
procedure CreateCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[0].Text:=GetCopyright;
  end;
end;


end.
