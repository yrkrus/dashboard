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


/////////////////////////////////////////////////////////////////////////////////////////
 // class TOnlineChat
 type
      TOnlineChat = class
      public
      m_message                            : TStringList;  // ������� ���������

      constructor Create(InChannel:string);                 overload;
      destructor Destroy;                   override;

      function Count:Integer;               // ���-�� ��������� � ������

      private
      m_mutex                              : TMutex;
      m_channel                            : string;
      m_lastIDMessage                      : Integer;   // ��������� ��������� ������� ����������

      procedure GetLoadingMessageMain;     // ������� ��������� ��� ������ ������ ����

      end;
   // class TOnlineChat END


implementation

uses
  GlobalVariables, Functions;



constructor TOnlineChat.Create(InChannel:string);
 var
  i:Integer;
 begin

    m_mutex:=TMutex.Create(nil, False, 'Global\TOnlineChat');
    m_message:=TStringList.Create;
    m_lastIDMessage:=0;

    // �����
    m_channel:=InChannel;

    // ��������� ��������� ��� ������ ����
    GetLoadingMessageMain;
 end;


destructor TOnlineChat.Destroy;
var
 i: Integer;
begin
 // for i := Low(listmessage) to High(lilistmessagestUsers) do FreeAndNil(listmessage[i]);
  m_mutex.Free;
  m_message.Free;

  inherited;
end;


// ���-�� ��������� � ������
function TOnlineChat.Count;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.m_message.Count;
  finally
    m_mutex.Release;
  end;
end;


// ������� ��������� ��� ������ ������ ����
procedure  TOnlineChat.GetLoadingMessageMain;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countMessage:Integer;

 senderUser:string;
 timeMessage:string;
 msg:string;

begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;

  with ado do begin
    ado.Connection:=serverConnect;

    SQL.Clear;
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
    SQL.Add('select id,sender,date_time,message from chat where channel = '+#39+m_channel+#39+' and date_time > '+#39+GetCurrentStartDateTime+#39);
    if m_lastIDMessage <> 0 then begin
     SQL.Add(' and id > '+IntToStr(m_lastIDMessage));
    end;
    SQL.Add(' order by date_time ASC');

    Active:=True;

    for i:=0 to countMessage-1 do begin
      senderUser:=GetUserNameFIO(StrToInt(VarToStr(Fields[1].Value)));
      timeMessage:=VarToStr(Fields[2].Value);
      msg:=VarToStr(Fields[3].Value);


      // ���������
      m_message.Add(timeMessage+' '+senderUser+': '+msg+'<br>');

      m_lastIDMessage:=StrToInt(VarToStr(Fields[0].Value));
      Next;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;


end;


end.

