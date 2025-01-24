/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   ����� ��� �������� TOnlineChat                          ///
///                  �������� ���� �� ����� ���������                         ///
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
         m_rootFolder                         : string;   // �������� ����������
         m_nodeFolder                         : string;   // ����� � ������ (chat_history)
         m_fileName                           : string;   // ����� �������� ���� (��� ���������� � �������� master\slave)
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

        function GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;  // ���������� ���� �� �����

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


      function GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;      // ��� ����� ���

      procedure CheckNewMessage;                                        // �������� ���� �� ����� ���������

      private
      m_mutex                              : TMutex;
      m_file                               : TStructFileInfo;
      m_navigate                           : TStructNavigate;  // ��� ��������� ��� ���� �� ������ ��������

      m_chatID                             : enumChatID;    // ����� ID ���� ������������
      m_channel                            : enumChannel;   // ���� ��� ���� ������������
      m_lastMessageID                      : Integer;       // ��������� ��������� � ����

      function isExistFileLog:Boolean; overload;     // ���� �� ����� ����� � ����������
      function isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean; overload;     // ���� �� ����� ����� � ����������
      procedure CreateFileLog;   // �������� ������� ����� �����


      function GetLastIDMessageBase:Integer;    // ��������� ��������� �������� ���� � ����
      function GetCountNewMessage(InLastIDMessage:Integer):Integer;    // ���-�� ����� ���������
      function GetLastIDMessageFileLog(InActiveBrowser:enumActiveBrowser):Integer;    // ���������� ���������� ID ��������� � ����

      function isExistNewMessage:Boolean;           // �������� ���� �� ����� ���������


      function IntegerToEnumActiveBrowser(ID:Integer):enumActiveBrowser;       // enumActiveBrowser -> integer


      end;
   // class TChat END


implementation

uses
  GlobalVariables, FunctionUnit, FormHome;

const
      cMAX_BROWSER      :Word = 2;        // ������������ ���-�� ������������� ��������� � ����� ������ ����


/////////////////////////TStructFileInfo/////////////////////////////////////

constructor TStructFileInfo.Create;
begin
  inherited Create; // ����� ������������ �������� ������
end;
/////////////////////////TStructFileInfo END/////////////////////////////////////


/////////////////////////TStructNavigate/////////////////////////////////////

constructor TStructNavigate.Create(InChatID:enumChatID;
                                   InFileInfo:TStructFileInfo);
begin
  inherited Create; // ����� ������������ �������� ������

   m_pathToLogNameMaster:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eMaster)+InFileInfo.m_fileExtension;

   m_pathToLogNameSlave:=InFileInfo.m_rootFolder+
                          InFileInfo.m_nodeFolder+'\'+InFileInfo.m_fileName+'\'+
                          EnumChannelChatIDToString(InChatID)+'\'+
                          EnumActiveBrowserToString(eSlave)+InFileInfo.m_fileExtension;
end;


// ���������� ���� �� �����
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

    // ��������� ��������� � ����
    m_lastMessageID:=0;

    // ID ����
    m_chatID:=InChatID;

    // �����
    m_channel:=InChannel;

     // ������� ���������
    begin
       // ���� � ����� ���� �� ������
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


// ��� ����� ���
function TChat.GetPathToLogName(InActiveBrowser:enumActiveBrowser):string;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_navigate.GetPathToLogName(InActiveBrowser);
  finally
    m_mutex.Release;
  end;
end;


// ���� �� ��� ���� ������� �� �����
function TChat.isExistFileLog:Boolean;
begin
   Result:=False;

   if not (FileExists(m_navigate.m_pathToLogNameMaster)) or
      not (FileExists(m_navigate.m_pathToLogNameSlave)) then Exit;

   Result:=True;
end;


// ���� �� ����� ����� � ����������
function TChat.isExistFileLog(InActiveBrowser:enumActiveBrowser):Boolean;
begin
  Result:=FileExists(m_navigate.GetPathToLogName(InActiveBrowser));
end;


// ��������� ��������� �������� ���� � ����
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


// ���-�� ����� ��������� �� ��
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


// ���������� ���������� ID ��������� � ����
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

// �������� ���� �� ����� ���������
function TChat.isExistNewMessage:Boolean;
begin
  Result:=False;

  // �� ��������� ���� ��� ������� TODO �� ���� ���� ����������� �� ���� ���������
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
  // ������ ���, ������ ���������
  if not isExistFileLog then CreateFileLog;
  if not isExistNewMessage then Exit;

  // ���� ����� ��������� ���� �� ���� �������� �� ������� �����
   countNewMessage:=GetCountNewMessage(m_lastMessageID);

   with HomeForm.lblNewMessageLocalChat do begin
     Visible:=True;
     Caption:='����� ��������� � ����� ���� ('+IntToStr(countNewMessage)+')';
   end;
end;


procedure TChat.CreateFileLog;
var
 EmptyFile:TfileStream;
 i:Integer;
begin
  // �������� ���� �� ����� chat_history
  if not DirectoryExists(m_file.m_nodeFolder) then CreateDir(Pchar(m_file.m_nodeFolder));

  // �������� ���� �� ����� chat_history/������� ����
  if not DirectoryExists(m_file.m_nodeFolder+'\'+m_file.m_fileName) then CreateDir(Pchar(m_file.m_nodeFolder+'\'+m_file.m_fileName));

  // ��������� ���� �� ����� � �������
  if not DirectoryExists(m_file.m_nodeFolder+'\'+m_file.m_fileName+'\'+EnumChannelChatIDToString(m_chatID)) then CreateDir(Pchar(m_file.m_nodeFolder+'\'+m_file.m_fileName+'\'+EnumChannelChatIDToString(m_chatID)));

  // �������� ���� �� ��� ���� �����
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
