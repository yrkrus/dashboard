/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TLoggingFile                          ///
///                 сохранение действия работы в лог                          ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TLogFileUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs;


   /////////////////////////////////////////////////////////////////////////////////////////
      // class TStructFileInfo
       type
         TStructFileInfo = class
        public
         m_rootFolder                         : string;   // корневая директория
         m_nodeFolder                         : string;   // папка с логами
         m_fileName                           : string;   // общее название лога
         m_fileExtension                      : string;   // расширение

        constructor Create; overload;
    end;

      // class TStructFileInfo END
/////////////////////////////////////////////////////////////////////////////////////////


 /////////////////////////////////////////////////////////////////////////////////////////
      // class TStructNavigate
       type
         TStructNavigate = class
        public

        constructor Create(InFileInfo:TStructFileInfo); overload;

        private
        m_pathToLogName                     : string;

    end;

      // class TStructNavigate END
/////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
   // class TLoggingFile
 type
      TLoggingFile = class

      public
      constructor Create(InNameLog:string);                   overload;
      destructor Destroy;                   override;


      procedure Save(InSTroka:string; isError:Boolean = False);  // запись в лог файл


      private
      m_mutex                              : TMutex;
      m_file                               : TStructFileInfo;  // вся инфа по логу
      m_navigate                           : TStructNavigate;

      function GetPathToLogName:string;     // абсолбтный путь до лога
      function isExistFileLog:Boolean;           // есть и файл лога на диске
      procedure CreateFileLog;                  // создаем файл лога
      procedure InitLogNextDay;    // инициализация лога  на следующий день

      end;
   // class TLoggingFile END

implementation

uses
  GlobalVariables;


/////////////////////////TStructFileInfo/////////////////////////////////////

constructor TStructFileInfo.Create;
begin
  inherited Create; // Вызов конструктора базового класса
end;
/////////////////////////TStructFileInfo END/////////////////////////////////////


  /////////////////////////TStructNavigate/////////////////////////////////////

constructor TStructNavigate.Create(InFileInfo:TStructFileInfo);
begin
  inherited Create; // Вызов конструктора базового класса

   m_pathToLogName:=InFileInfo.m_rootFolder+
                    InFileInfo.m_nodeFolder+'\'+
                    GetCurrentTime+'\'+
                    InFileInfo.m_fileName+InFileInfo.m_fileExtension;
end;

/////////////////////////TStructNavigate END/////////////////////////////////////



constructor TLoggingFile.Create(InNameLog:string);
begin
  m_mutex:=TMutex.Create(nil, False, 'Global\TLoggingFile');

 // создаем навигацию
  begin
     // путь и общая инфа по файлам
      m_file:=TStructFileInfo.Create;
     with m_file do begin
       m_rootFolder:=FOLDERPATH;
       m_nodeFolder:=GetLogNameFolder;
       m_fileName:=InNameLog;
       m_fileExtension:=GetExtensionLog;
     end;

    m_navigate:=TStructNavigate.Create(m_file);
  end;

  // проверим есть ли файл лога уже
  if not isExistFileLog then CreateFileLog;
end;


destructor TLoggingFile.Destroy;
begin
  m_mutex.Free;
  m_file.Free;
  m_navigate.Free;
  inherited;
end;




function TLoggingFile.GetPathToLogName:string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_navigate.m_pathToLogName;
  finally
    m_mutex.Release;
  end;
end;


// есть ли уже файл лога на диске
function TLoggingFile.isExistFileLog:Boolean;
begin
  Result:=FileExists(m_navigate.m_pathToLogName);
end;


// создаем файл лога
procedure TLoggingFile.CreateFileLog;
var
 EmptyFile:TfileStream;
 i:Integer;
begin
  // проверка есть ли папка chat_history
  if not DirectoryExists(m_file.m_rootFolder+'\'+m_file.m_nodeFolder) then CreateDir(Pchar(m_file.m_rootFolder+'\'+m_file.m_nodeFolder));

  // проверка есть ли папка log/текущая дата
  if not DirectoryExists(m_file.m_rootFolder+'\'+m_file.m_nodeFolder+'\'+GetCurrentTime) then CreateDir(Pchar(m_file.m_rootFolder+'\'+m_file.m_nodeFolder+'\'+GetCurrentTime));

    // проверка есть ли сам файл логов
  if not isExistFileLog then begin
    try
      EmptyFile:= TFileStream.Create(GetPathToLogName,fmCreate);
    finally
      EmptyFile.Free;

      // новое начало лога
      Save('<hr>');
    end;
  end;
end;



// инициализация лога на следующий день
procedure TLoggingFile.InitLogNextDay;
begin
 // проверка есть ли папка log/текущая дата
  if not DirectoryExists(m_file.m_rootFolder+'\'+m_file.m_nodeFolder+'\'+GetCurrentTime) then begin

   m_navigate.m_pathToLogName:=m_file.m_rootFolder+
                               m_file.m_nodeFolder+'\'+
                               GetCurrentTime+'\'+
                               m_file.m_fileName+m_file.m_fileExtension;

    if not isExistFileLog then CreateFileLog;
  end;

end;


procedure TLoggingFile.Save(InSTroka: string; isError: Boolean = False);
var
 SLLog:TStringList;
begin
  if not isExistFileLog then CreateFileLog;

  // на всякий случай проверим не перещли лт в новый день
  InitLogNextDay;

  SLLog:=TStringList.Create;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    SLLog.LoadFromFile(GetPathToLogName);
    if isError then InSTroka:='<font color="red"><b>'+InSTroka+'</b></font>';

    if InSTroka = '<hr>' then begin
      SLLog.Add(InSTroka);
    end
    else begin
      SLLog.Add( DateTimeToStr(Now)+' '+
               InSTroka+'<br>'
               );
    end;
    try
      SLLog.SaveToFile(GetPathToLogName);
    finally
      if Assigned(SLLog) then FreeAndNil(SLLog);
    end;
  finally
    m_mutex.Release;
  end;
end;

end.
