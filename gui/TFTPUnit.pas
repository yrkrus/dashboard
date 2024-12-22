/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания FTP                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TFTPUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  XMLDoc,
  XMLIntf,
  GlobalVariables,
  IdFTP, IdComponent,
  IdBaseComponent, IdCustomTCPServer,
  IdTCPConnection, IdTCPClient,IdFTPList, IdFTPCommon,
  IdAllFTPListParsers,   IdExplicitTLSClientServerBase,
  TlHelp32, TLogFileUnit,TCustomTypeUnit;


 type
  TFTP = class
  public
    constructor Create(InRootFolder:string); overload;
    destructor Destroy; override;

  private

    m_ftp             :TIdFTP;   // сам ftp

    m_host            :string;
    m_userName        :string;
    m_password        :string;
    m_log             :TLoggingFile;

    isConnected       :Boolean;
    m_listFilesFTP    :TStringList; // список с файлами которые есть на ftp
    m_filesTypes      :enumExtensionFTP; // тип файлов которые нужно скачать\закачать

    procedure GetListFiles; // получим список файлов


    function enumExtensionFTPToString(enumTypes:enumExtensionFTP):string;  // enumExtensionFTP -> string


  end;

implementation



{ TFTPSettings }

 constructor TFTP.Create(InRootFolder:string);
 var
  error_message:string;
 begin
   inherited Create;
   m_log:=TLoggingFile.Create('FTPClient');
   m_ftp:=TIdFTP.Create(nil);
   m_listFilesFTP:=TStringList.Create;

  // m_filesTypes:=InFilesType;  InFilesType:enumExtensionFTP
   isConnected:=False;

   // первоначальные настройки
   m_host:=GetFTPServerAddress;
   m_userName:=GetFTPServerUser;
   m_password:=GetFTPServerPassword;
   

   if not Assigned(m_ftp) then begin
     m_log.Save('Не удалось создать дочерний процесс ftp',IS_ERROR);
     Exit;
   end;

   with m_ftp do begin
    ConnectTimeout:=300000;
    ReadTimeout:=300000;

    ProxySettings.ProxyType:=fpcmNone;
    UseTLS:=utNoTLSSupport;
    NATKeepAlive.IdleTimeMS:=0;
    NATKeepAlive.IntervalMS:=0;
    NATKeepAlive.UseKeepAlive:=true;
    TransferType:=ftBinary;


    Passive:=True;
    Host:=m_host;
    Username:=m_userName;
    Password:=m_password;

    try
      m_log.Save('Подключение к серверу: '+'<b>'+m_host+'</b>');
      Connect;
      if Connected then isConnected:=True;
     except
        on E: Exception do begin
          error_message:=E.Message;
          isConnected:=False;
        end;
    end;
   end;

    if not isConnected then begin
     m_log.Save('Не удалось подключиться к серверу: '+'<b>'+m_host+'</b> | '+error_message,IS_ERROR);
     Exit;
    end
    else begin
      m_log.Save('Успешное подключение к серверу: '+'<b>'+m_host+'</b>');
    end;



    m_ftp.ChangeDir('/');
    m_ftp.ChangeDir('/'+InRootFolder);
   // m_ftp.Status(mlist);
    try
      m_ftp.List(m_listFilesFTP,enumExtensionFTPToString(m_filesTypes),False);
    finally
       m_listFilesFTP.Count;
    end;


    m_ftp.Get('11FC1DF8.zip',PChar('C:\Users\home0\Desktop\DASHBOARD\develop\gui\Win64\Debug\log\11FC1DF8.zip'),false,True);

    m_ftp.ChangeDir('/');

   { try
       m_ftp.List(list);
    except
        on E: Exception do begin
          error_message:=E.Message;
          isConnected:=False;
        end;
    end; }


 end;

destructor TFTP.Destroy;
begin
  // Освобождение ресурсов, если это необходимо
  if isConnected then m_ftp.Disconnect;
  m_ftp.Free;
  m_listFilesFTP.Free;

  inherited Destroy;
end;

// получим список файлов
procedure TFTP.GetListFiles; 
begin

end;

// enumExtensionFTP -> string
function TFTP.enumExtensionFTPToString(enumTypes:enumExtensionFTP):string;
begin  
  case enumTypes of
   eFTP_Unknown:  Result:='unknown';
   eFTP_Zip:      Result:='*.zip';
   eFTP_Doc:      Result:='*.doc';
   eFTP_Docx:     Result:='*.docx';
   eFTP_Xls:      Result:='*.xls';
   eFTP_Xlsx:     Result:='*.xlsx';
   eFTP_Txt:      Result:='*.txt';
   eFTP_Jpeg:     Result:='*.jpeg';
   eFTP_Png:      Result:='*.png';
   eFTP_Pdf:      Result:='*.pdf';    
  end;
end;


end.
