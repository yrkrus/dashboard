 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         Список очередей в которые просматривает пользователь              ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TUserCommonQueueUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, System.Generics.Collections;


 // class TUserCommonQueue
  type
    TUserCommonQueue = class // какие очереди может видеть пользователь
    private
    m_userID  :Integer;
    m_count   :Integer;
    m_list    :TList<enumQueue>;

    function GetQueue:string;
    function GetQueueBase:string;
    function IsExist(_queue:enumQueue):Boolean;

    procedure LoadData;

    public
    constructor Create(_userID:Integer);                     overload;

    property Count:Integer read m_count;
    property ActiveQueueSTR:string read GetQueue;
    property ActiveQueueSTRToBase:string read GetQueueBase;
    property IsExistQueue[_queue:enumQueue]:Boolean read IsExist; default;
    property GetQueueList:TList<enumQueue> read m_list;

    end;
   // class TUserCommonQueue END


implementation

uses
  GlobalVariablesLinkDLL, Data.Win.ADODB, Data.DB, Variants;


// class TUserCommonQueue START
constructor TUserCommonQueue.Create(_userID:Integer);
begin
  m_count:=0;
  m_list:=TList<enumQueue>.Create;
  m_userID:=_userID;

  LoadData;
end;


// прогрузка данных
procedure TUserCommonQueue.LoadData;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countQueue:Integer;
 request:TStringBuilder;
 i:Integer;
begin

  ado:=TADOQuery.Create(nil);
 try
    serverConnect:=createServerConnect;
 except
    on E:Exception do begin
      if not Assigned(serverConnect) then begin
         FreeAndNil(ado);
         Exit;
      end;
    end;
 end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      request:=TStringBuilder.Create;
      with request do begin
        Clear;
        Append('select count(id)');
        Append(' from users_common_queue where user_id = '+#39+IntToStr(m_userID)+#39);
      end;

      SQL.Add(request.ToString);
      Active:=True;

      if Fields[0].Value = null then Exit;

      countQueue:=StrToInt(VarToStr(Fields[0].Value));
      if countQueue = 0 then Exit;

      with request do begin
        Clear;
        Append('select queue');
        Append(' from users_common_queue where user_id = '+#39+IntToStr(m_userID)+#39);
      end;

      SQL.Clear;
      SQl.Add(request.ToString);
      Active:=True;

      // выделям память
      m_count:=countQueue;

      for i:=0 to countQueue-1 do begin
        m_list.Add(StringToEnumQueue(VarToStr(Fields[0].Value)));
        ado.Next;
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
end;


function TUserCommonQueue.GetQueue:string;
var
 i:Integer;
 str:string;
begin
  str:='';
  Result:='---';

  if m_count = 0 then Exit;

  for i:=0 to m_count-1 do begin
    if str='' then str:=EnumQueueToString(m_list[i])
    else str:=str+','+EnumQueueToString(m_list[i]);
  end;

  Result:=str;
end;


function TUserCommonQueue.GetQueueBase:string;
var
 i:Integer;
 str:string;
begin
  str:='';
  Result:='';

  if m_count = 0 then Exit;

  for i:=0 to m_count-1 do begin
   if str='' then str:=#39+EnumQueueToString(m_list[i])+#39
   else str:=str+','+#39+EnumQueueToString(m_list[i])+#39;
  end;

  Result:=str;
end;


function TUserCommonQueue.IsExist(_queue:enumQueue):Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_count-1 do begin
    if m_list[i] = _queue then begin
      Result:=True;
      Exit;
    end;
  end;
end;


// class TUserCommonQueue END
end.