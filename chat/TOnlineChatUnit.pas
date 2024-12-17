/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TOnlineChat                           ///
///         отображение сообщений на форме + загрузка новых                   ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////



unit TOnlineChatUnit;

interface


uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException,
      SHDocVw, ActiveX, MSHTML, ComObj, Vcl.Controls,
      Vcl.Forms, Vcl.OleCtrls, Vcl.ComCtrls,
      Winapi.Windows, Winapi.Messages,
      Vcl.Dialogs,  Vcl.ExtCtrls, Vcl.StdCtrls,
      Vcl.ButtonGroup, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
      Vcl.WinXCtrls,CustomTypeUnit, RegularExpressions;


    //  end;

/////////////////////////////////////////////////////////////////////////////////////////
      // class TStructFileInfo
       type
         TStructFileInfo = class
        public
         m_rootFolder                         : string;   // корневая директория
         m_nodeFolder                         : string;   // папка с логами (chat_history)
         m_fileName                           : string;   // общее название лога (без расширения и указании master\slave)
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
        function GetPathToNavigate(InActiveBrowser:enumActiveBrowser):string; // полный путь для m_browser.Navigate

        constructor Create( InChatID:enumChatID;
                            InFileInfo:TStructFileInfo); overload;

         private
         m_pathToLogNameMaster                     : string;
         m_pathToLogNameSlave                      : string;
         m_pathToNavigateMaster                    : string;
         m_pathToNavigateSlave                     : string;

    end;

      // class TStructNavigate END
/////////////////////////////////////////////////////////////////////////////////////////

   // class TStructBrowser
  type
    TStructBrowser = class
    public
    m_browser         : TWebBrowser;          // сам браузер
    m_active          : enumActiveBrowser;
    // инициализация браузеров, только после того как саму форму уже показали!! делаем это уже в потоке
    procedure InitLinkingBrowser(InTypeBrouser:enumActiveBrowser;   // тип браузера (всего 2 типа Master и Slave)
                                 InChatID:enumChatID);

    constructor Create; overload;
    destructor Destroy; override;


    end;
    // class TStructBrowser END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TStructMessage
 type
      TStructMessage = class
      public
      m_idMessage                            : Integer;     // номер сообщения
      m_sender                               : Integer;     // отправитель
      m_recipient                            : Integer;     // получатель
      m_datetime                             : TDateTime;   // дата
      m_call                                 : Integer;     // тэгаем когото, что бы отобразить сообщение
      m_message                              : string;      // само сообщение

      constructor Create;                   overload;

      procedure Clear;


      end;
   // class TStructMessage END

/////////////////////////////////////////////////////////////////////////////////////////
 // class TOnlineChat
 type
      TOnlineChat = class
      public

      constructor Create( InChatID:enumChatID;       // ID номер чата который будет отображаться на форме
                          InChannel:enumChannel      // тип канала public\private это название будет добавлено в БД chat.channel | varchar(50)
                        );

      destructor Destroy;                   override;

      function Count:Integer;               // кол-во сообщений в памяти

      procedure SaveToFileLog(InCountMessage:enumLoadMessage);
      procedure Clear;
      procedure LoadingMessage(InCountMessage:enumLoadMessage);     // получим сообщения с учетом есть ли новые сообщения или нет

      function GetLastIDMessage:Integer;     // последнее прогруженное сообщение
      function GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;      // где живет лог
      function GetPathToNavigate(InActiveBrowser:enumActiveBrowser):string;     // где живет лог (то же самое только для отображения на форме)


      function isExistNewMessage(InLastIDMessageHistory:Integer):Boolean;  // есть ли разница между тем что в итории и тем что по БД

      procedure InitBrowser;        // инициализация браузеров (master и slave)

      // отображаем на браузере то ради чего этот класс и нужен
      procedure ShowChat;


      private
      m_mutex                              : TMutex;
      m_listMessage                        : array of TStructMessage;  // текущие сообщения
      m_listBrowser                        : array of TStructBrowser; // список браузеров
      m_activeBrowser                      : enumActiveBrowser; // каой тип браузер сейчас активен
      m_channel                            : enumChannel;             // каой тип чата используется
      isInitBrowser                        : Boolean;  // инициализированы ли браузеры
      m_chatID                             : enumChatID;  // какой ID чата используется

      m_file                               : TStructFileInfo;
      m_navigate                           : TStructNavigate;  // тут храниться все пути по файлам браузера

      m_lastIDMessage                      : Integer;   // последнее сообщение которое прогрузили

      procedure ShowBrowser(InActiveBrowser:enumActiveBrowser);  // отображение активного браузера на форме

      function GetLastStructMessageID:Integer;    // последний номер ID в TStructMessage
      function GetLastIDMessageBase:Integer;    // последнее сообщение котороое есть в базе
      function isExistFileLog:Boolean; overload;     // есть ли файлы логов в диреткории
      function isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean; overload;     // есть ли файлы логов в диреткории
      function GetLastIDMessageFileLog(InActiveBrowser:enumActiveBrowser):Integer;    // нахождение последнего ID сообщения в логе

      procedure CreateFileLog;         // создание файла с чатом

      end;
   // class TOnlineChat END


implementation

uses
  GlobalVariables, Functions, HomeForm;

const
      cMAX_MESSAGE_DAY  :Word = 2500;     // максимальное кол-во сообщений которое можем храить
      cMAX_BROWSER      :Word = 2;        // максимальное кол-во переключаемых браузеров в одном классе чата




/////////////////////////TStructFileInfo/////////////////////////////////////

constructor TStructFileInfo.Create;
begin
  inherited Create; // Вызов конструктора базового класса
end;
/////////////////////////TStructFileInfo END/////////////////////////////////////



/////////////////////////TStructNavigate/////////////////////////////////////

constructor TStructNavigate.Create(InChatID:enumChatID;
                                   InFileInfo:TStructFileInfo);
begin
  inherited Create; // Вызов конструктора базового класса

   m_pathToLogNameMaster:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eMaster)+InFileInfo.m_fileExtension;

   m_pathToNavigateMaster:=m_pathToLogNameMaster;
   m_pathToNavigateMaster:= 'file:///' + StringReplace(m_pathToNavigateMaster, '\', '/', [rfReplaceAll]);


   m_pathToLogNameSlave:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eSlave)+InFileInfo.m_fileExtension;

   m_pathToNavigateSlave:=m_pathToLogNameSlave;
   m_pathToNavigateSlave:= 'file:///' + StringReplace(m_pathToNavigateSlave, '\', '/', [rfReplaceAll]);

end;



// абсолютный путь до файла
function TStructNavigate.GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;
begin
  case InActiveBrowser of
    eMaster:  Result:=m_pathToLogNameMaster;
    eSlave:   Result:=m_pathToLogNameSlave;
  end;
end;

// полный путь для m_browser.Navigate
function TStructNavigate.GetPathToNavigate(InActiveBrowser:enumActiveBrowser):string;
begin
 case InActiveBrowser of
    eMaster:  Result:=m_pathToNavigateMaster;
    eSlave:   Result:=m_pathToNavigateSlave;
 end;
end;
/////////////////////////TStructNavigate END/////////////////////////////////////


/////////////////////////TStructBrowser/////////////////////////////////////

constructor TStructBrowser.Create;
begin
  inherited Create; // Вызов конструктора базового класса
  m_active:=eNone;
end;

destructor TStructBrowser.Destroy;
begin
  m_browser.Free;   // Освобождаем ресурсы, если m_brouser был создан
  inherited Destroy; // Вызов деструктора базового класса
end;


// инициализация браузеров, только после того как саму форму уже показали!! делаем это уже в потоке
procedure TStructBrowser.InitLinkingBrowser(InTypeBrouser:enumActiveBrowser;   // тип браузера (всего 2 типа Master и Slave)
                                            InChatID:enumChatID);
var
 chatname:string;
begin
  chatname:='chat_'+EnumChannelChatIDToString(InChatID)+'_'+EnumActiveBrowserToString(InTypeBrouser);

  // тут передаем в память twebbrowser чтобы потом через него взаимодействовать с чатом
  Self.m_browser:=FormHome.FindComponent(chatname) as TWebBrowser;
  Self.m_browser.Navigate(DEFAULT_URL);
  while m_browser.ReadyState <> READYSTATE_COMPLETE do Sleep(100);  // немного подождем

  Self.m_active:=eNone;
end;

/////////////////////////TStructBrowser END/////////////////////////////////////



/////////////////////////TStructMessage/////////////////////////////////////

constructor TStructMessage.Create;
begin
  inherited Create; // Вызов конструктора базового класса
  Clear;
end;

 procedure TStructMessage.Clear;
 begin
  Self.m_idMessage:=0;
  Self.m_sender:=0;
  Self.m_recipient:=-1;
  Self.m_datetime:=0;
  Self.m_call:=-1;
  Self.m_message:='';
 end;


 /////////////////////////TStructMessage END/////////////////////////////////////


 /////////////////////////TOnlineChat/////////////////////////////////////
constructor TOnlineChat.Create(InChatID:enumChatID;
                              InChannel:enumChannel);
 var
  i:Integer;
 begin
    m_mutex:=TMutex.Create(nil, False, 'Global\TOnlineChat');

    SetLength(m_listMessage,cMAX_MESSAGE_DAY);
    for i:=0 to cMAX_MESSAGE_DAY-1 do m_listMessage[i]:=TStructMessage.Create;

    // создаем браузеры TODO тут они еще = nil т.к. они иниуиализируются уже после того как показали саму главную форму в потоке
    SetLength(m_listBrowser,cMAX_BROWSER);
    for i:=0 to cMAX_BROWSER-1 do m_listBrowser[i]:=TStructBrowser.Create;

    // браузеры не инициализированы
    isInitBrowser:=False;

    // последнее актуальное сообщение
    m_lastIDMessage:=0;

    // ID чата
    m_chatID:=InChatID;

    // канал
    m_channel:=InChannel;

    // создаем навигацию
    begin
       // путь где у нас запускается exe + общая инфа по файлам
       m_file:=TStructFileInfo.Create;
       with m_file do begin
         m_rootFolder:=FOLDERPATH;
         m_nodeFolder:=GetLocalChatNameFolder;
         m_fileName:=GetCurrentTime;
         m_fileExtension:=GetExtensionLog;
       end;

      m_navigate:=TStructNavigate.Create(m_chatID,m_file);
    end;

   // подгрузим сообщения (первоначальная загрузка)если есть уже сообщения то подгружаем разницу
   if not isExistFileLog then  LoadingMessage(eAll)
   else LoadingMessage(eDiff);

   // тут всегда будет eNone инаяе при загрузке не отображается истоия
   m_activeBrowser:=eNone;
 end;

 // генерация сообщения
 function GenerateMessage(InOriginalMessage:TStructMessage; InTag:Integer):string;
 const
  color_user:string = '#4682B4';
  color_time:string = '#A9A9A9';
 var
  tmp,message_time:string;
 begin
    message_time:=FormatDateTime('hh:mm', InOriginalMessage.m_datetime);

   if InTag = -1 then begin // никого не вызвали
     tmp:='<div id="last_'+IntToStr(InOriginalMessage.m_idMessage)+'"  message_id="'+ IntToStr(InOriginalMessage.m_idMessage)+'">'+
          '<font color= "'+color_user+'">'+GetUserNameFIO(InOriginalMessage.m_sender)+'</font>'+'  '+'<font color ="'+color_time+'" style="font-size: xx-small;">'+message_time+'</font>'
                         + '<br>'
                         +  InOriginalMessage.m_message
                         + '<br><br></div>';
   end
   else begin             // вызвыали через тэгирование
      // TODO написать
   end;

   Result:=tmp;
 end;

destructor TOnlineChat.Destroy;
var
 i: Integer;
begin
  for i:= Low(m_listMessage) to High(m_listMessage) do FreeAndNil(m_listMessage[i]);
  for i:= Low(m_listBrowser) to High(m_listBrowser) do FreeAndNil(m_listBrowser[i]);

  m_mutex.Free;
  m_file.Free;
  m_navigate.Free;

  inherited;
end;


procedure TOnlineChat.Clear;
var
 i:Integer;
begin
  for i:= Low(m_listMessage) to High(m_listMessage) do m_listMessage[i].Clear;
end;

// последнее прогруженное сообщение
function TOnlineChat.GetLastIDMessage:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_lastIDMessage;
  finally
    m_mutex.Release;
  end;
end;

// где живет лог (
function TOnlineChat.GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_navigate.GetPathToLogName(InActiveBrowser);
  finally
    m_mutex.Release;
  end;
end;

// где живет лог (то же самое только для отображения на форме)
function TOnlineChat.GetPathToNavigate(InActiveBrowser:enumActiveBrowser):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_navigate.GetPathToNavigate(InActiveBrowser);
  finally
    m_mutex.Release;
  end;
end;


// кол-во сообщений в памяти
function TOnlineChat.Count;
var
 i:Integer;
 countMessage:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    countMessage:=0;

    for i:=0 to cMAX_MESSAGE_DAY-1 do begin
      if (m_listMessage[i].m_idMessage <> 0) then Inc(countMessage);
      if m_listMessage[i].m_idMessage = 0 then Break;
    end;

    Result:=countMessage;
  finally
    m_mutex.Release;
  end;
end;


procedure TOnlineChat.SaveToFileLog(InCountMessage:enumLoadMessage);
var
 i,j,k:Integer;
 SLTemp:TStringList;
 message_time:string;
 lastIDFile:Integer;
 lastStructMessageID:Integer;
begin
    // проверяем есть ли у нас уже истоия ранее сохраненных файлов
   if not isExistFileLog then begin   // история уже есть подгружаем
       // создадим файл лога
     CreateFileLog;
   end;


  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
   SLTemp:=TStringList.Create;

   case InCountMessage of
     eAll: begin
      for i:=0 to Count-1 do begin
        SLTemp.Add(GenerateMessage(m_listMessage[i],m_listMessage[i].m_call));
      end;

       // сохраняем в файл(master\slave)
       try
         for i:=0 to cMAX_BROWSER-1 do begin
           SLTemp.SaveToFile(m_navigate.GetPathToLogName(enumActiveBrowser(i)));
         end;
       except
          on E:EIdException do begin
            FormHome.lblerr.Caption:=e.Message;
          end;
       end;
     end;
     eDiff: begin
      for i:=0 to cMAX_BROWSER-1 do begin
       SLTemp.Clear;
       // загрузим текущие сообщения в память
       SLTemp.LoadFromFile(GetPathToLogName(enumActiveBrowser(i)));

       // последнее сообщение в файле истории
       lastIDFile:=GetLastIDMessageFileLog(enumActiveBrowser(i));

        // нет изменений
        if lastIDFile = m_lastIDMessage then begin
         SLTemp.Clear;
         Continue;
        end;


        for j:=0 to Count-1 do begin
          if AnsiPos('message_id="'+IntToStr(m_listMessage[j].m_idMessage)+'"',SLTemp[SLTemp.Count-1])=0 then begin
            SLTemp.Add(GenerateMessage(m_listMessage[j],m_listMessage[j].m_call));
          end;
        end;

       // сохраняем в файл(master\slave)
       try
         SLTemp.SaveToFile(m_navigate.GetPathToLogName(enumActiveBrowser(i)));
       except
          on E:EIdException do begin
            FormHome.lblerr.Caption:=e.Message;
          end;
       end;
      end;
     end;
   end;

   if SLTemp<>nil then FreeAndNil(SLTemp);
  finally
    m_mutex.Release;
  end;
end;


// получим сообщения для канала общего чата
procedure  TOnlineChat.LoadingMessage(InCountMessage:enumLoadMessage);
var
 i,startCount:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countMessage:Integer;

 lastIDMessage:Integer; // последнее сообщение которое у нас есть в истории
 lastStructMessageID:Integer;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  lastIDMessage:=0;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('select count(id) from chat where channel = '+#39+EnumChannelToString(m_channel)+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);

    if InCountMessage = eDiff then begin
      // последнее собщение которое у нас есть в истории
      lastIDMessage:=GetLastIDMessageFileLog(eMaster);

      SQL.Add(' and id > '+#39+IntToStr(lastIDMessage)+#39);
    end;


    Active:=True;
    countMessage:=StrToInt(VarToStr(Fields[0].Value));

    if countMessage=0 then begin
      FreeAndNil(ado);
      serverConnect.Close;
      if Assigned(serverConnect) then serverConnect.Free;

      // на всякий случай проверим есть ли у нас файлы лога (это нужно когда переходим в новый день и еще нет собощений)
       if not isExistFileLog then begin
           // создадим файл лога
         CreateFileLog;
       end;

      // так же на всякий случай проверим вдруг нет сообщений в памяти(это нужно для корерктно дальнейшей проверки)
      if m_lastIDMessage=0 then m_lastIDMessage:=lastIDMessage;

      Exit;
    end;

    SQL.Clear;
    SQL.Add('select id,sender,recipient,date_time,call_id,message from chat where channel = '+#39+EnumChannelToString(m_channel)+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);

    if InCountMessage = eDiff then begin
      SQL.Add(' and id > '+#39+IntToStr(lastIDMessage)+#39);
    end;

    SQL.Add(' order by date_time ASC');

    Active:=True;

    // ID последнего сообщения в памяти StructMessage
    lastStructMessageID:=GetLastStructMessageID;

    for i:=lastStructMessageID to lastStructMessageID+countMessage-1 do begin
      m_listMessage[i].m_idMessage:=StrToInt(VarToStr(Fields[0].Value));
      m_listMessage[i].m_sender:=StrToInt(VarToStr(Fields[1].Value));
      m_listMessage[i].m_recipient:=StrToInt(VarToStr(Fields[2].Value));
      m_listMessage[i].m_datetime:=StrToDateTime(VarToStr(Fields[3].Value));
      m_listMessage[i].m_call:=StrToInt(VarToStr(Fields[4].Value));
      m_listMessage[i].m_message:=VarToStr(Fields[5].Value);

      m_lastIDMessage:=StrToInt(VarToStr(Fields[0].Value));
      Next;
    end;

    // сохраняем в историю лога
    SaveToFileLog(InCountMessage);
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;

end;


function TOnlineChat.GetLastStructMessageID:Integer;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=0 to cMAX_MESSAGE_DAY-1 do begin
      if (m_listMessage[i].m_idMessage = 0) then begin
        Result:=i;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;



// последнее сообщение котороое есть в базе
function TOnlineChat.GetLastIDMessageBase:Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;


  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select id from chat where channel = '+#39+EnumChannelToString(m_channel)+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39+' order by date_time DESC limit 1');

    Active:=True;
    if Fields[0].Value<>null then begin
      Result:=StrToInt(VarToStr(Fields[0].Value));
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;
end;


function TOnlineChat.isExistNewMessage(InLastIDMessageHistory:Integer):Boolean;
begin
 Result:=False;
 if m_lastIDMessage <> GetLastIDMessageBase then Result:=True;
end;


// инициализация браузеров
procedure TOnlineChat.InitBrowser;
var
 i:Integer;
begin
  if isInitBrowser then Exit;

  for i:=0 to cMAX_BROWSER-1 do m_listBrowser[i].InitLinkingBrowser(IntegerToEnumActiveBrowser(i),m_chatID);
  isInitBrowser:=True;
end;



// есть ли уже файл истории на диске
function TOnlineChat.isExistFileLog:Boolean;
begin
   Result:=False;

   if not (FileExists(m_navigate.m_pathToLogNameMaster)) or
      not (FileExists(m_navigate.m_pathToLogNameSlave)) then Exit;

   Result:=True;
end;


// есть ли файлы логов в диреткории
function TOnlineChat.isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean;
begin
  Result:=FileExists(m_navigate.GetPathToLogName(InActiveBrowser));
end;


procedure TOnlineChat.ShowBrowser(InActiveBrowser:enumActiveBrowser);
var
 visibleBrowser:enumActiveBrowser;
begin
   // тут наоборот действие если выбирем eMaster, то выбираем eSlave и наоброт
   if (InActiveBrowser = eMaster) or (InActiveBrowser = eNone) then visibleBrowser:=eSlave
   else visibleBrowser:=eMaster;

   m_listBrowser[EnumActiveBrowserToInteger(visibleBrowser)].m_browser.Navigate(m_navigate.GetPathToNavigate(visibleBrowser)+'#last_'+IntToStr(m_lastIDMessage));

   // пустую страницу ставим предидущему браузеру
   if AnsiPos(DEFAULT_URL, m_listBrowser[EnumActiveBrowserToInteger(InActiveBrowser)].m_browser.LocationURL) = 0 then begin
    m_listBrowser[EnumActiveBrowserToInteger(InActiveBrowser)].m_browser.Navigate(DEFAULT_URL);
   end;

   if not isVisibleWebBrowser(visibleBrowser,m_chatID) then VisibleWebBrowser(visibleBrowser,m_chatID);

   m_listBrowser[EnumActiveBrowserToInteger(visibleBrowser)].m_active:=InActiveBrowser;
   // активен master
   m_activeBrowser:=visibleBrowser;

   HideWebBrowser(InActiveBrowser,m_chatID);
end;


procedure TOnlineChat.CreateFileLog;
var
 EmptyFile:TfileStream;
 i:Integer;
begin
  // проверка есть ли папка chat_history
  if not DirectoryExists(m_file.m_nodeFolder) then CreateDir(Pchar(m_file.m_nodeFolder));

  // проверка есть ли папка chat_history/текущая дата
  if not DirectoryExists(m_file.m_nodeFolder+'\'+m_file.m_fileName) then CreateDir(Pchar(m_file.m_nodeFolder+'\'+m_file.m_fileName));

  // проверяем есть ли папка с каналом
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



// нахождение последнего ID сообщения в логе
function TOnlineChat.GetLastIDMessageFileLog(InActiveBrowser:enumActiveBrowser):Integer;
var
 SLFileLog:TStringList;
 FolderPath:string;
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

// отображаем на браузере то ради чего этот класс и нужен
procedure TOnlineChat.ShowChat;
var
 lastID:Integer;
begin
  // проверяем какой у нас сейчас виден на форме браузер
   if m_activeBrowser = eNone then begin
     ShowBrowser(eMaster);
     Exit;
   end;

   // теперь будем проверять есть ли у нас изменения в разнице между БД и тем что у нас сейчас в истории
   lastID:=GetLastIDMessageFileLog(eMaster);
   if not isExistNewMessage(lastID) then Exit;
   // подгрузим новые сообщения
    LoadingMessage(eDiff);

    // отображем новые данные
    ShowBrowser(m_activeBrowser);
end;

 /////////////////////////TOnlineChat END/////////////////////////////////////


end.

