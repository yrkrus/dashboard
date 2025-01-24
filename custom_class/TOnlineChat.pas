/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                    ласс дл€ описани€ TOnlineChat                          ///
///                  проверка есть ли новые сообщени€                         ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TOnlineChat;

interface

uses
  System.Classes,
  Data.Win.ADODB,
  Data.DB,
  System.SysUtils,
  Variants,
  Graphics,
  System.SyncObjs,
  IdException,
  TCustomTypeUnit,
  RegularExpressions;


/////////////////////////////////////////////////////////////////////////////////////////
      // class TStructFileInfo
       type
         TStructFileInfo = class
        public
         m_rootFolder                         : string;   // корнева€ директори€
         m_nodeFolder                         : string;   // папка с логами (chat_history)
         m_fileName                           : string;   // общее название лога (без расширени€ и указании master\slave)
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

        function GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;  // абсолютный путь до файла

        constructor Create( InChatID:enumChatID;
                            InFileInfo:TStructFileInfo); overload;

         private
         m_pathToLogNameMaster                     : string;
         m_pathToLogNameSlave                      : string;
    end;

      // class TStructNavigate END
/////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////
   // class TChat
 type
      TChat = class
      public

      constructor Create(InChatID:enumChatID;
                         InChannel:enumChannel);
      destructor Destroy;                   override;


      function GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;      // где живет лог

      procedure CheckNewMessage;                                        // проверка есть ли новые сообщени€

      private
      m_mutex                              : TMutex;
      m_file                               : TStructFileInfo;
      m_navigate                           : TStructNavigate;  // тут хранитьс€ все пути по файлам браузера

      m_chatID                             : enumChatID;    // какой ID чата используетс€
      m_channel                            : enumChannel;   // каой тип чата используетс€
      m_lastMessageID                      : Integer;       // последнее сообщение в чате

      function isExistFileLog:Boolean; overload;     // есть ли файлы логов в диреткории
      function isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean; overload;     // есть ли файлы логов в диреткории
      procedure CreateFileLog;   // создание пустого файла логов


      function GetLastIDMessageBase:Integer;    // последнее сообщение котороое есть в базе
      function GetCountNewMessage(InLastIDMessage:Integer):Integer;    // кол-во новых сообщений
      function GetLastIDMessageFileLog(InActiveBrowser:enumActiveBrowser):Integer;    // нахождение последнего ID сообщени€ в логе

      function isExistNewMessage:Boolean;           // проверка есть ли новые сообщени€


      function IntegerToEnumActiveBrowser(ID:Integer):enumActiveBrowser;       // enumActiveBrowser -> integer


      end;
   // class TChat END


implementation

uses
  GlobalVariables, FunctionUnit, FormHome;

const
      cMAX_BROWSER      :Word = 2;        // максимальное кол-во переключаемых браузеров в одном классе чата


/////////////////////////TStructFileInfo/////////////////////////////////////

constructor TStructFileInfo.Create;
begin
  inherited Create; // ¬ызов конструктора базового класса
end;
/////////////////////////TStructFileInfo END/////////////////////////////////////


/////////////////////////TStructNavigate/////////////////////////////////////

constructor TStructNavigate.Create(InChatID:enumChatID;
                                   InFileInfo:TStructFileInfo);
begin
  inherited Create; // ¬ызов конструктора базового класса

   m_pathToLogNameMaster:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eMaster)+InFileInfo.m_fileExtension;

   m_pathToLogNameSlave:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eSlave)+InFileInfo.m_fileExtension;
end;


// абсолютный путь до файла
function TStructNavigate.GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;
begin
  case InActiveBrowser of
    eMaster:  Result:=m_pathToLogNameMaster;
    eSlave:   Result:=m_pathToLogNameSlave;
  end;
end;

/////////////////////////TStructNavigate END/////////////////////////////////////


constructor TChat.Create(InChatID:enumChatID;
                         InChannel:enumChannel);
 var
  i:Integer;
 begin
    m_mutex:=TMutex.Create(nil, False, 'Global\TChat');

    // последнее сообщение в чате
    m_lastMessageID:=0;

    // ID чата
    m_chatID:=InChatID;

    // канал
    m_channel:=InChannel;

     // создаем навигацию
    begin
       // путь и обща€ инфа по файлам
       m_file:=TStructFileInfo.Create;
       with m_file do begin
         m_rootFolder:=FOLDERPATH;
         m_nodeFolder:=GetLocalChatNameFolder;
         m_fileName:=GetCurrentTime;
         m_fileExtension:=GetExtensionLog;
       end;

      m_navigate:=TStructNavigate.Create(m_chatID,m_file);
    end;

    if isExistFileLog then m_lastMessageID:=GetLastIDMessageFileLog(eSlave);    

 end;

destructor TChat.Destroy;
var
 i: Integer;
begin
 // for i:=Low(listActiveQueue) to High(listActiveQueue) do FreeAndNil(listActiveQueue[i]);
  m_mutex.Free;

  inherited;
end;


// где живет лог
function TChat.GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_navigate.GetPathToLogName(InActiveBrowser);
  finally
    m_mutex.Release;
  end;
end;


// есть ли уже файл истории на диске
function TChat.isExistFileLog:Boolean;
begin
   Result:=False;

   if not (FileExists(m_navigate.m_pathToLogNameMaster)) or
      not (FileExists(m_navigate.m_pathToLogNameSlave)) then Exit;

   Result:=True;
end;


// есть ли файлы логов в диреткории
function TChat.isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean;
begin
  Result:=FileExists(m_navigate.GetPathToLogName(InActiveBrowser));
end;


// последнее сообщение котороое есть в базе
function TChat.GetLastIDMessageBase:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select id from chat where channel = '+#39+EnumChannelToString(m_channel)+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39+' order by date_time DESC limit 1');

      Active:=True;
      if Fields[0].Value<>null then begin
        Result:=StrToInt(VarToStr(Fields[0].Value));
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// кол-во новых сообщений по Ѕƒ
function TChat.GetCountNewMessage(InLastIDMessage:Integer):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from chat where channel = '+#39+EnumChannelToString(m_channel)+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39+' and id >'+#39+IntToStr(InLastIDMessage)+#39);

      Active:=True;
      if Fields[0].Value<>null then begin
        Result:=StrToInt(VarToStr(Fields[0].Value));
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// нахождение последнего ID сообщени€ в логе
function TChat.GetLastIDMessageFileLog(InActiveBrowser:enumActiveBrowser):Integer;
var
 SLFileLog:TStringList;
 Regex: TRegEx;
 Match:TMatch;

 lastStroka:string;
 isExistNow:Boolean;
begin
  isExistNow:=False;

 SLFileLog:=TStringList.Create;
   try
     SLFileLog.LoadFromFile(m_navigate.GetPathToLogName(InActiveBrowser));
   finally
     if SLFileLog.Count = 0 then isExistNow:=True;
   end;

   if isExistNow then begin
      Result:=0;
      Exit;
   end;

 lastStroka:=SLFileLog[SLFileLog.Count-1];

 Regex:= TRegEx.Create('message_id="(\d+)"', [roIgnoreCase]);
 Match:= Regex.Match(lastStroka);

 if Match.Success then Result:= StrToInt(Match.Groups[1].Value)
 else Result:=0;

 if SLFileLog<>nil then FreeAndNil(SLFileLog);

end;

// проверка есть ли новые сообщени€
function TChat.isExistNewMessage:Boolean;
begin
  Result:=False;

  // не провер€ем если чат запущен TODO но если есть тэгирование то надо проверить
  if GetTask(CHAT_EXE) then
  begin
    with HomeForm.lblNewMessageLocalChat do begin
      if Visible then Visible:=False;
       Exit;
    end;
  end;

  m_lastMessageID:=GetLastIDMessageFileLog(eSlave);
  if m_lastMessageID < GetLastIDMessageBase then Result:=True;
end;


procedure TChat.CheckNewMessage;
var
 countNewMessage:Integer;
begin
  // файлов нет, нечего провер€ть
  if not isExistFileLog then CreateFileLog;
  if not isExistNewMessage then Exit;

  // есть новые сообщени€ надо об этом сообщить на главной форме
   countNewMessage:=GetCountNewMessage(m_lastMessageID);

   with HomeForm.lblNewMessageLocalChat do begin
     Visible:=True;
     Caption:='Ќовые сообщени€ в общем чате ('+IntToStr(countNewMessage)+')';
   end;
end;


procedure TChat.CreateFileLog;
var
 EmptyFile:TfileStream;
 i:Integer;
begin
  // проверка есть ли папка chat_history
  if not DirectoryExists(m_file.m_nodeFolder) then CreateDir(Pchar(m_file.m_nodeFolder));

  // проверка есть ли папка chat_history/текуща€ дата
  if not DirectoryExists(m_file.m_nodeFolder+'\'+m_file.m_fileName) then CreateDir(Pchar(m_file.m_nodeFolder+'\'+m_file.m_fileName));

  // провер€ем есть ли папка с каналом
  if not DirectoryExists(m_file.m_nodeFolder+'\'+m_file.m_fileName+'\'+EnumChannelChatIDToString(m_chatID)) then CreateDir(Pchar(m_file.m_nodeFolder+'\'+m_file.m_fileName+'\'+EnumChannelChatIDToString(m_chatID)));

  // проверка есть ли сам файл логов
  for i:=0 to cMAX_BROWSER-1 do begin
    if not isExistFileLog(IntegerToEnumActiveBrowser(i)) then begin
      try
        EmptyFile:= TFileStream.Create(m_navigate.GetPathToLogName(IntegerToEnumActiveBrowser(i)),fmCreate);
      finally
        EmptyFile.Free;
      end;
    end;
  end;
end;


// enumActiveBrowser -> integer
function TChat.IntegerToEnumActiveBrowser(ID:Integer):enumActiveBrowser;
begin
  case ID of
    0: Result:=eMaster;
    1: Result:=eSlave;
    2: Result:=eNone;
  end;
end;

end.
