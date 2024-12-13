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
       Vcl.Forms, Vcl.OleCtrls, Vcl.ComCtrls;


  type    // тип загрузки сообщений
  enumMessage = (   eMessage_init,    // первоначальная загрузка
                    eMessage_update   // обновление существующиъх сообщений
                );

   type  // какой браузер сейчас активен основной или дополнительный
   enumActiveBrowser = (  eMaster,
                          eSlave
                        );

/////////////////////////////////////////////////////////////////////////////////////////

   // class TStructBrowser
  type
    TStructBrowser = class
    public
    m_brouser         :TWebBrowser;         // сам браузер
    m_typeBrouser     :enumActiveBrowser;   // тип браузера


    constructor Create(InTypeBrouser:enumActiveBrowser;   // тип браузера (всего 2 типа Master и Slave)
                       var p_PageControl:TPageControl;
                       InNameSheet : string;              // название листа к которому нужно прилипает webbrawser
                       );                   overload;
    procedure Clear;

    end;
    // class TStructBrowser END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TStructMessage
 type
      TStructMessage = class
      public
      m_idMessage                            : Integer;     // номер сообщения
      m_channel                              : string;      // канал
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

      constructor Create(InChannel,         // название канала например 'main' // это название будет добавлено в БД chat.channel | varchar(50)
                         InChannelName,     // название канала на PageControl (напрмер Общий чат)
                         InPath,
                         InFileName,
                         InExtensions:string;
                         var p_PageControl:TPageControl);        overload;


      destructor Destroy;                   override;

      function Count:Integer;               // кол-во сообщений в памяти

      procedure SaveToFileLog(InFileName:string);
      procedure Clear;
      procedure LoadingMessageMain(isStartedLocalChat:enumMessage);     // получим сообщения для канала общего чата

      function GetLastIDMessage:Integer;     // последнее прогруженное сообщение
      function GetPathToLogName:string;      // где живет лог
      function GetPathToNavigate:string;     // где живет лог (то же самое только для отображения на форме)
      function GetChannel:string;            // текущий канал


      function isExistNewMessage(InLastIDMessageHistory:Integer):Boolean;  // есть ли разница между тем что в итории и тем что по БД

      // отображаем на браузере то ради чего этот класс и нужен
      procedure ShowChat(var p_WebBrouser_master: TWebBrowser;
                         var p_WebBrouser_slave : TWebBrowser);


      private
      m_mutex                              : TMutex;
      m_listMessage                        : array of TStructMessage;  // текущие сообщения

      m_activeBrowser                      : enumActiveBrowser; // каой тип браузер сейчас активен

      m_listBrowser                        :array of TStructBrowser; // список браузеров

      m_rootfolder                         : string;   // корневая директория
      m_channel                            : string;   // канал + папка с логами
      m_filename                           : string;   // название лога
      m_pathToLogName                      : string;
      m_pathToNavigate                     : string;
      m_lastIDMessage                      : Integer;   // последнее сообщение которое прогрузили

      function GetLastStructMessageID:Integer;    // последний номер ID в TStructMessage
      function GetLastIDMessageBase:Integer;    // последнее сообщение котороое есть в базе


      end;
   // class TOnlineChat END


implementation

uses
  GlobalVariables, Functions, HomeForm;

const
      cMAX_MESSAGE_DAY  :Word = 2500;     // максимальное кол-во сообщений которое можем храить
      cMAX_BROWSER      :Word = 2;        // максимальное кол-во переключаемых браузеров в одном классе чата

// enumActiveBrowser -> string
function EnumActiveBrowserToString(InActiveBrowser:enumActiveBrowser):string;
begin
  case InActiveBrowser of
    eMaster :Result:='master';
    eSlave  :Result:='slave';
  end;
end;

/////////////////////////TStructBrowser/////////////////////////////////////

constructor TStructBrowser.Create(InTypeBrouser:enumActiveBrowser);
begin
  inherited Create; // Вызов конструктора базового класса
  Clear;

  Self.m_brouser:=TWebBrowser.Create(Self);
  with Self.m_brouser do begin
    Parent:=
    Visible:=False;


  end;

  Self.m_typeBrouser:=InTypeBrouser;

end;


procedure TStructBrowser.Clear;
begin

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
  Self.m_channel:='';
  Self.m_sender:=0;
  Self.m_recipient:=-1;
  Self.m_datetime:=0;
  Self.m_call:=-1;
  Self.m_message:='';
 end;


 /////////////////////////TStructMessage END/////////////////////////////////////


 /////////////////////////TOnlineChat/////////////////////////////////////
constructor TOnlineChat.Create(InChannel,InPath,InFileName,InExtensions:string);
 var
  i:Integer;
 begin

    m_mutex:=TMutex.Create(nil, False, 'Global\TOnlineChat');

    SetLength(m_listMessage,cMAX_MESSAGE_DAY);
    for i:=0 to cMAX_MESSAGE_DAY-1 do m_listMessage[i]:=TStructMessage.Create;

    SetLength(m_listBrowser,cMAX_BROWSER);
    for i:=0 to cMAX_BROWSER-1 do m_listBrowser[i]:=TStructBrowser.Create;

    m_lastIDMessage:=0;

    // канал
    m_channel:=InChannel;

    m_rootfolder:=InPath;
    m_filename:=InFileName+InExtensions;

    // полный путь до файла лога
    m_pathToLogName:=InPath+'\'+InChannel+'\'+InFileName+InExtensions;

     // полный путь до файла лога для отображения на форме
    m_pathToNavigate:=m_pathToLogName;
    m_pathToNavigate:= 'file:///' + StringReplace(m_pathToNavigate, '\', '/', [rfReplaceAll]);


   if not isExistFileLog(m_channel,m_filename) then begin
     // создадим файл лога
     CreateFileLocalChat(m_channel,m_filename);
   end;

    // подгрузим сообщения для общего чата (первоначальная загрузка)
    LoadingMessageMain(eMessage_init);
 end;


destructor TOnlineChat.Destroy;
var
 i: Integer;
begin
  for i:= Low(m_listMessage) to High(m_listMessage) do FreeAndNil(m_listMessage[i]);
  m_mutex.Free;

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
function TOnlineChat.GetPathToLogName:string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_pathToLogName;
  finally
    m_mutex.Release;
  end;
end;

// где живет лог (то же самое только для отображения на форме)
function TOnlineChat.GetPathToNavigate:string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_pathToNavigate;
  finally
    m_mutex.Release;
  end;
end;

// текущий канал
function TOnlineChat.GetChannel:string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_channel;
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


procedure TOnlineChat.SaveToFileLog(InFileName:string);
const
  color_user:string = '#4682B4';
  color_time:string = '#A9A9A9';
var
 i:Integer;
 SLTemp:TStringList;
 message_time:string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
   SLTemp:=TStringList.Create;

   {

    '<table>' +
                 '<tr>' +
                 '<td>' + AContent + '</td>' + // Вставляем содержимое в ячейку
                 '</tr>' +
                 '</table>' +

   }

   // <div message_id="123"><font color = ""> Петров Юрий 17:43<br>123<br><br></div>
   // <div message_id="123">17:43:56 Петров Юрий → Тут ФИО: 123<br></div>

   for i:=0 to Count-1 do begin
     message_time:=FormatDateTime('hh:mm', m_listMessage[i].m_datetime);

     if m_listMessage[i].m_call = -1 then begin // никого не вызывали через тэгирование
       SLTemp.Add('<div id="last_'+IntToStr(m_listMessage[i].m_idMessage)+'"  message_id="'+ IntToStr(m_listMessage[i].m_idMessage)+'">'+
                  '<font color= "'+color_user+'">'+GetUserNameFIO(m_listMessage[i].m_sender)+'</font>'+'  '+'<font color ="'+color_time+'">'+message_time+'</font>'
                                   + '<br>'
                                   +  m_listMessage[i].m_message
                                   + '<br><br></div>'
      );
     end
     else begin
       // TODO написать

     end;
   end;

   try
     SLTemp.SaveToFile(InFileName);
   except
        on E:EIdException do begin
          FormHome.lblerr.Caption:=e.Message;
        end;
   end;

   if SLTemp<>nil then FreeAndNil(SLTemp);
  finally
    m_mutex.Release;
  end;
end;


// получим сообщения для канала общего чата
procedure  TOnlineChat.LoadingMessageMain(isStartedLocalChat:enumMessage);
var
 i,startCount:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countMessage:Integer;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('select count(id) from chat where channel = '+#39+m_channel+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);

    if isStartedLocalChat = eMessage_update  then begin
      SQL.Add(' and id > '+IntToStr(m_lastIDMessage));
    end;

    Active:=True;
    countMessage:=StrToInt(VarToStr(Fields[0].Value));

    if countMessage=0 then begin
      FreeAndNil(ado);
      serverConnect.Close;
      if Assigned(serverConnect) then serverConnect.Free;
      Exit;
    end;

    SQL.Clear;
    SQL.Add('select id,channel,sender,recipient,date_time,call_id,message from chat where channel = '+#39+m_channel+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);

    if isStartedLocalChat = eMessage_update  then begin
      SQL.Add(' and id > '+IntToStr(m_lastIDMessage));
    end;

    SQL.Add(' order by date_time ASC');

    // с какого сообщения будем начинать
    case isStartedLocalChat of
      eMessage_init:    startCount:=0;
      eMessage_update:  startCount:=GetLastStructMessageID;
    end;

     Active:=True;

    for i:=startCount to startCount+countMessage-1 do begin
      m_listMessage[i].m_idMessage:=StrToInt(VarToStr(Fields[0].Value));
      m_listMessage[i].m_channel:=VarToStr(Fields[1].Value);
      m_listMessage[i].m_sender:=StrToInt(VarToStr(Fields[2].Value));
      m_listMessage[i].m_recipient:=StrToInt(VarToStr(Fields[3].Value));
      m_listMessage[i].m_datetime:=StrToDateTime(VarToStr(Fields[4].Value));
      m_listMessage[i].m_call:=StrToInt(VarToStr(Fields[5].Value));
      m_listMessage[i].m_message:=VarToStr(Fields[6].Value);

      m_lastIDMessage:=StrToInt(VarToStr(Fields[0].Value));
      Next;
    end;

    // сохраняем в историю лога
    SaveToFileLog(m_pathToLogName);
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
    SQL.Add('select id from chat where channel = '+#39+m_channel+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39+' order by date_time DESC limit 1');

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

// отображаем на браузере то ради чего этот класс и нужен
procedure TOnlineChat.ShowChat;
begin
  {

  message_main.Navigate(PChar(p_Message.GetPathToNavigate+'#last_'+IntToStr(last_id)),navNoWriteToCache);
    while message_main.ReadyState <> READYSTATE_COMPLETE do Sleep(100);
  }
end;


 /////////////////////////TOnlineChat END/////////////////////////////////////


end.

