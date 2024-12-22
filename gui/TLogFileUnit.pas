/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  ����� ��� �������� TLoggingFile                          ///
///                 ���������� �������� ������ � ���                          ///
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
         m_rootFolder                         : string;   // �������� ����������
         m_nodeFolder                         : string;   // ����� � ������
         m_fileName                           : string;   // ����� �������� ����
         m_fileExtension                      : string;   // ����������

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


      procedure Save(InSTroka:string; isError:Boolean = False);  // ������ � ��� ����


      private
      m_mutex                              : TMutex;
      m_file                               : TStructFileInfo;  // ��� ���� �� ����
      m_navigate                           : TStructNavigate;

      function GetPathToLogName:string;     // ���������� ���� �� ����
      function isExistFileLog:Boolean;           // ���� � ���� ���� �� �����
      procedure CreateFileLog;                  // ������� ���� ����
      procedure InitLogNextDay;    // ������������� ����  �� ��������� ����

      end;
   // class TLoggingFile END

implementation

uses
  GlobalVariables;


/////////////////////////TStructFileInfo/////////////////////////////////////

constructor TStructFileInfo.Create;
begin
  inherited Create; // ����� ������������ �������� ������
end;
/////////////////////////TStructFileInfo END/////////////////////////////////////


  /////////////////////////TStructNavigate/////////////////////////////////////

constructor TStructNavigate.Create(InFileInfo:TStructFileInfo);
begin
  inherited Create; // ����� ������������ �������� ������

   m_pathToLogName:=InFileInfo.m_rootFolder+
                    InFileInfo.m_nodeFolder+'\'+
                    GetCurrentTime+'\'+
                    InFileInfo.m_fileName+InFileInfo.m_fileExtension;
end;

/////////////////////////TStructNavigate END/////////////////////////////////////



constructor TLoggingFile.Create(InNameLog:string);
begin
  m_mutex:=TMutex.Create(nil, False, 'Global\TLoggingFile');

 // ������� ���������
  begin
     // ���� � ����� ���� �� ������
      m_file:=TStructFileInfo.Create;
     with m_file do begin
       m_rootFolder:=FOLDERPATH;
       m_nodeFolder:=GetLogNameFolder;
       m_fileName:=InNameLog;
       m_fileExtension:=GetExtensionLog;
     end;

    m_navigate:=TStructNavigate.Create(m_file);
  end;

  // �������� ���� �� ���� ���� ���
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


// ���� �� ��� ���� ���� �� �����
function TLoggingFile.isExistFileLog:Boolean;
begin
  Result:=FileExists(m_navigate.m_pathToLogName);
end;


// ������� ���� ����
procedure TLoggingFile.CreateFileLog;
var
 EmptyFile:TfileStream;
 i:Integer;
begin
  // �������� ���� �� ����� chat_history
  if not DirectoryExists(m_file.m_rootFolder+'\'+m_file.m_nodeFolder) then CreateDir(Pchar(m_file.m_rootFolder+'\'+m_file.m_nodeFolder));

  // �������� ���� �� ����� log/������� ����
  if not DirectoryExists(m_file.m_rootFolder+'\'+m_file.m_nodeFolder+'\'+GetCurrentTime) then CreateDir(Pchar(m_file.m_rootFolder+'\'+m_file.m_nodeFolder+'\'+GetCurrentTime));

    // �������� ���� �� ��� ���� �����
  if not isExistFileLog then begin
    try
      EmptyFile:= TFileStream.Create(GetPathToLogName,fmCreate);
    finally
      EmptyFile.Free;

      // ����� ������ ����
      Save('<hr>');
    end;
  end;
end;



// ������������� ���� �� ��������� ����
procedure TLoggingFile.InitLogNextDay;
begin
 // �������� ���� �� ����� log/������� ����
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

  // �� ������ ������ �������� �� ������� �� � ����� ����
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
