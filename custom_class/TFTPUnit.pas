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
  IdFTP,
  IdComponent,
  IdBaseComponent,
  IdCustomTCPServer,
  IdTCPConnection,
  IdTCPClient,
  IdFTPList,
  IdFTPCommon,
  IdAllFTPListParsers,
  IdExplicitTLSClientServerBase,
  TlHelp32,
  TLogFileUnit,
  TCustomTypeUnit,
  System.IOUtils;


 type
  TFTP = class
  public
    constructor Create(InLogName,InRootFolder:string; InMode:enumModeFTP; InFolderDownloaded:string); overload;
    destructor Destroy; override;

    procedure DownloadFile(InFileNameDownload:string); // скачать файл
    function isDownloadedFile(InFileNameDownload:string):Boolean; // успешно ли скачан файд
    function isConnect:Boolean;       // успешно ли подключились к ftp

    function GetError:string;   // текущая ошибка

  private
    m_ftp             :TIdFTP;   // сам ftp
    m_host            :string;
    m_userName        :string;
    m_password        :string;
    m_log             :TLoggingFile;

    isDownloaded      : Boolean;   // успешно ли скачали файл

    isConnected       :Boolean;
    m_listFilesFTP    :TStringList; // список с файлами которые есть на ftp
    m_mode            :enumModeFTP; // режим работы
    m_sizeFile        :Int64;

    m_folderDownloaded :string;      // путь до папки куда будем скачивать

    m_ErrorDownloadCRC: Word; // кол-во ошибок скачки файла

    m_errorDesriptions:string;    // текущая внутренная ошибка


    function enumExtensionFTPToString(enumTypes:enumExtensionFTP):string;  // enumExtensionFTP -> string
    function isExistFileToFTP(InFileName:string):Boolean;     // есть ли файл на сервере в папке
    function GetFileSize(InStroka:string):Int64;  // поиск размер файла на ftp
    procedure CreateFolderDownload(InFolderName:string);  // создаем папку куда будем скачивать все
    function CheckDownloadFile(InFileNameDownload:string):Boolean;   // проверка весь ли файл скачался

  end;

implementation

 const
      cMAX_CRC_ERROR  :Word = 5;     // максимальное кол-во попыток перекачки файла


{ TFTPSettings }

 constructor TFTP.Create(InLogName,InRootFolder:string; InMode:enumModeFTP; InFolderDownloaded:string);
 var
  error_message:string;
 begin
   inherited Create;
   m_log:=TLoggingFile.Create(InLogName,False);
   m_ftp:=TIdFTP.Create(nil);
   m_listFilesFTP:=TStringList.Create;
   m_folderDownloaded:=InFolderDownloaded;
   m_errorDesriptions:='';

   m_mode:=InMode;
   m_sizeFile:=0; // размер файле
   m_ErrorDownloadCRC:=0;  // кол-во ошибок скачки

   isDownloaded:=False;
   isConnected:=False;

   // первоначальные настройки
   m_host:=GetFTPServerAddress;
   m_userName:=GetFTPServerUser;
   m_password:=GetFTPServerPassword;
   

   if not Assigned(m_ftp) then begin
     m_log.Save('Не удалось создать процесс ftp',IS_ERROR);
     m_errorDesriptions:='Не удалось создать процесс ftp';
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
          m_errorDesriptions:=error_message;
          isConnected:=False;
        end;
    end;
   end;

    if not isConnected then begin
     m_log.Save('Не удалось подключиться к серверу: '+'<b>'+m_host+'</b> | '+error_message,IS_ERROR);
     m_errorDesriptions:='Не удалось подключиться к серверу: '+m_host;
     Exit;
    end
    else begin
      m_log.Save('Успешное подключение к серверу: '+'<b>'+m_host+'</b>');
    end;

    m_ftp.ChangeDir('/');
    m_ftp.ChangeDir('/'+InRootFolder);
 end;

destructor TFTP.Destroy;
begin
  // Освобождение ресурсов, если это необходимо
  if isConnected then m_ftp.Disconnect;
  m_ftp.Free;
  m_listFilesFTP.Free;

  inherited Destroy;
end;


// скачать файл
procedure TFTP.DownloadFile(InFileNameDownload:string);
var
 isErrorDownload:Boolean;
begin
  isErrorDownload:=False;

  m_log.Save('Скачивание файла: '+'<b>'+InFileNameDownload+'</b>');

  if not isConnected then begin
   m_log.Save('Подключение к серверу '+'<b>'+m_host+'</b> не установлено',IS_ERROR);
   m_errorDesriptions:='Подключение к серверу '+m_host+' не установлено';
   Exit;
  end;

  if not isExistFileToFTP(InFileNameDownload) then begin
   m_log.Save('На сервере отсутствует файл: '+'<b>'+InFileNameDownload+'</b>',IS_ERROR);
   m_errorDesriptions:='На сервере отсутствует файл: '+InFileNameDownload;
   Exit;
  end;

  if m_sizeFile=0 then begin
     m_log.Save('Не удается получить размер файла <b>'+InFileNameDownload+'</b>',IS_ERROR);
     m_errorDesriptions:='Не удается получить размер файла '+InFileNameDownload;
     isErrorDownload:=True;
     Exit;
  end;


  m_log.Save('Размер файла: '+'<b>'+InFileNameDownload+' ('+IntToStr(m_sizeFile)+' байт)</b>');

  // скачиваем
  begin
   // инициализация папки + создание
   CreateFolderDownload(m_folderDownloaded);

   try
     m_ftp.Get(InFileNameDownload,m_folderDownloaded+'\'+InFileNameDownload,True);
   except
    on E: Exception do begin
       m_log.Save('При скачивании файла <b>'+InFileNameDownload+'</b> возникла ошибка | '+E.Message,IS_ERROR);
       m_errorDesriptions:='При скачивании файла '+InFileNameDownload+' возникла ошибка | '+E.Message;
       isErrorDownload:=True;
    end;
   end;
  end;

  if isErrorDownload then Exit;

  // проверим весь ли скачался файл
  if not CheckDownloadFile(InFileNameDownload) then begin
    Inc(m_ErrorDownloadCRC);
    m_log.Save('CRC хэш файла <b>'+InFileNameDownload+'</b> не соответствтует. Перекачиваем заново, попытка #'+IntToStr(m_ErrorDownloadCRC),IS_ERROR);


    if m_ErrorDownloadCRC < cMAX_CRC_ERROR then DownloadFile(InFileNameDownload)
    else begin
     m_log.Save('Превышено кол-во попыток скачивания',IS_ERROR);
     m_errorDesriptions:='Превышено кол-во попыток скачивания';
     Exit
    end;
  end;

   m_log.Save('Скачивание файла '+'<b>'+InFileNameDownload+'</b> завершено');
end;

// успешно ли скачан файд
function TFTP.isDownloadedFile(InFileNameDownload:string):Boolean;
begin
  Result:=CheckDownloadFile(InFileNameDownload);

 // Result:=Self.isDownloaded;
end;

// успешно ли подключились к ftp
function TFTP.isConnect:Boolean;
begin
   Result:=Self.isConnected;
end;

 // текущая ошибка
function TFTP.GetError:string;
begin
   Result:=Self.m_errorDesriptions;
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

// есть ли файл на сервере в папке
function TFTP.isExistFileToFTP(InFileName:string):Boolean;
var
 i:Integer;
begin
  Result:=False;

  // получим список файлов которые у нас есть на ftp
  m_listFilesFTP.Clear;
  m_ftp.List(m_listFilesFTP);

  if m_listFilesFTP.Count=0 then begin
    Exit;
  end;

  for i:=0 to m_listFilesFTP.Count-1 do begin
     if AnsiPos(InFileName,m_listFilesFTP[i])<>0 then begin
       Result:=True;

       // размер файла
       if m_mode=eDownload then begin
         m_sizeFile:=GetFileSize(m_listFilesFTP[i]);
       end;

       Exit;
     end;
  end;
end;


// поиск размер файла на ftp
function TFTP.GetFileSize(InStroka:string):Int64;
var
 stroka:TStringList;
 i,j:Integer;
 finded:Boolean;
begin
  finded:=False;
  Result:=0;

  stroka:=TStringList.Create;
  stroka.Delimiter:=' ';
  stroka.StrictDelimiter := True;
  stroka.DelimitedText := InStroka;

  // ('-rw-r--r--  1 1004  0    7427159 Dec 24 21:36 11FC1DF9.zip', nil)

  for i:=0 to stroka.Count-1 do begin
    if stroka[i] = '0' then begin
      for j:=i+1 to stroka.Count-1 do begin
        if TryStrToInt64(stroka[j],Result) then begin
          finded:=True;
          Break;
        end;
      end;

    end;
    if finded then Break;
  end;

  if Assigned(stroka) then FreeAndNil(stroka);
end;

 // создаем папку обновлением
procedure TFTP.CreateFolderDownload(InFolderName:string);
begin
  m_folderDownloaded:=FOLDERPATH+InFolderName;
  // удаляем сначало всю директорию
  if DirectoryExists(m_folderDownloaded) then  TDirectory.Delete(m_folderDownloaded, True);


  // проверка есть ли папка
  if not DirectoryExists(m_folderDownloaded) then CreateDir(Pchar(m_folderDownloaded));
end;

// проверка весь ли файл скачался
function TFTP.CheckDownloadFile(InFileNameDownload:string):Boolean;
var
 sizefile:Int64;
 FileStream: TFileStream;
begin
  Result:=False;
  isDownloaded:=False; // успешно ли скачали файл

  if not FileExists(m_folderDownloaded+'\'+InFileNameDownload) then Exit;

  FileStream := TFileStream.Create(Pchar(m_folderDownloaded+'\'+InFileNameDownload), fmOpenRead or fmShareDenyWrite);
  try
    sizefile:= FileStream.Size; // Получаем размер файла
  finally
    FileStream.Free; // Освобождаем ресурсы
  end;

  if sizefile = m_sizeFile then begin
    isDownloaded:=True;
    Result:=True;
  end;

end;

end.
