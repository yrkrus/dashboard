/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  ����� ��� �������� TOnlineChat                           ///
///               �������� ������� ��������� � ������                         ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TOnlineChatUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException;


  type    // ��� �������� ���������
  enumMessage = ( message_init,    // �������������� ��������
                  message_update   // ���������� ������������� ���������
                );


/////////////////////////////////////////////////////////////////////////////////////////
   // class TStructMessage
 type
      TStructMessage = class
      public
      m_idMessage                            : Integer;     // ����� ���������
      m_channel                              : string;      // �����
      m_sender                               : Integer;     // �����������
      m_recipient                            : Integer;     // ����������
      m_datetime                             : TDateTime;   // ����
      m_call                                 : Integer;     // ������ ������, ��� �� ���������� ���������
      m_message                              : string;      // ���� ���������

      constructor Create;                   overload;


      procedure Clear;
      //procedure CreateFile(InFileName:string);

      end;
   // class TStructMessage END

/////////////////////////////////////////////////////////////////////////////////////////
 // class TOnlineChat
 type
      TOnlineChat = class
      const
      cMAX_MESSAGE_DAY  :Word = 2500;     // ������������ ���-�� ��������� ������� ����� ������
      public
      m_listMessage                          : array of TStructMessage;  // ������� ���������

      constructor Create(InChannel:string);                 overload;
      destructor Destroy;                   override;

      function Count:Integer;               // ���-�� ��������� � ������

      procedure CreateFile(InFileName:string);
      procedure Clear;

      private
      m_mutex                              : TMutex;
      m_channel                            : string;
      m_lastIDMessage                      : Integer;   // ��������� ��������� ������� ����������

      procedure LoadingMessageMain(isStartedLocalChat:enumMessage);     // ������� ��������� ��� ������ ������ ����

      end;
   // class TOnlineChat END


implementation

uses
  GlobalVariables, Functions;



constructor TStructMessage.Create;
begin
  inherited Create; // ����� ������������ �������� ������
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


constructor TOnlineChat.Create(InChannel:string);
 var
  i:Integer;
 begin

    m_mutex:=TMutex.Create(nil, False, 'Global\TOnlineChat');

    SetLength(m_listMessage,cMAX_MESSAGE_DAY);
    for i:=0 to cMAX_MESSAGE_DAY-1 do m_listMessage[i]:=TStructMessage.Create;

    m_lastIDMessage:=0;

    // �����
    m_channel:=InChannel;

    // ��������� ��������� ��� ������ ���� (�������������� ��������)
    LoadingMessageMain(message_init);
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

// ���-�� ��������� � ������
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


procedure TOnlineChat.CreateFile(InFileName:string);
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
   { for i:=0 to m_message.Count-1 do begin
      m_message.SaveToFile(InFileName);
    end; }
  finally
    m_mutex.Release;
  end;
end;


// ������� ��������� ��� ������ ������ ����
procedure  TOnlineChat.LoadingMessageMain(isStartedLocalChat:enumMessage);
var
 i:Integer;
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

    case isStartedLocalChat of
     message_init: begin       // ���������� ��� ���������
        SQL.Add('select count(id) from chat where channel = '+#39+m_channel+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);

        if m_lastIDMessage <> 0 then begin
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
        if m_lastIDMessage <> 0 then begin
         SQL.Add(' and id > '+IntToStr(m_lastIDMessage));
        end;
        SQL.Add(' order by date_time ASC');

        Active:=True;

        for i:=0 to countMessage-1 do begin
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
     end;
     message_update:begin     // ��������� ������������ ���������

     end;
    end;

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;


end;


end.

