/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  ����� ��� �������� �������� ������                       ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////



unit TActiveSessionUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants, Graphics, System.SyncObjs, IdException,TCustomTypeUnit;


 // class TActiveStruct
  type
      TActiveStruct = class
      public

      userID                  : Integer;
      role                    : string;
      userName                : string;
      PC                      : string;
      IP                      : string;
      dateOnline              : string;
      status                  : string;
      isQueue                 : Boolean; // ������� �� �������� � ������� ��� ���

      constructor Create;                     overload;

      end;
  // class TActiveStruct END

// ==========================================

  // class TActiveSession
  type
      TActiveSession = class
      public
      listActiveSession                       : array of TActiveStruct;

      function GetCountOnline                 : Word;
      procedure UpdateActiveSession;          // ���������� �������� ����� � ��������� ��������


      constructor Create;                     overload;
      destructor Destroy;                     override;

      private
      m_mutex                                 : TMutex;
      m_threadUpdate_isQueue                  : TThread;  // ����� �������� ��������� �� �������� � �������
      count                                   : Word;  // ���-�� ������� ������ ������


      function GetCountActiveSessionBD        : Word;  // ������� ���-�� �������� ������ �� ��
      procedure CreateListActiveSession;       // �������� ������ �������� ������

      end;
  // class TActiveSession END





implementation

uses
  FunctionUnit, GlobalVariables;

//////////////////////////////////////////////////
// class TActiveStruct  STARt

constructor TActiveStruct.Create;
 begin
    inherited;

   Self.userID    :=0;
   Self.role      :='';
   Self.userName  :='';
   Self.PC        :='';
   Self.IP        :='';
   Self.dateOnline:='';
   Self.status    :='';
   Self.isQueue   :=False;

 end;

// class TActiveStruct  END
//////////////////////////////////////////////////



//////////////////////////////////////////////////
// class TActiveSession START
constructor TActiveSession.Create;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TActiveSession');
    count:=0;

    // ������� ������� ������
    CreateListActiveSession;
 end;

destructor TActiveSession.Destroy;
var
 i: Integer;
begin
  for i:=Low(listActiveSession) to High(listActiveSession) do FreeAndNil(listActiveSession[i]);
  m_mutex.Free;
  inherited;
end;

 function TActiveSession.GetCountOnline;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    // �������� � ������ ���������
    Result:=Self.count;
  finally
    // ������������ �������
    m_mutex.Release;
  end;
 end;

function TActiveSession.GetCountActiveSessionBD:Word;
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
      SQL.Add('select count(id) from active_session');

      try
        Active:=True;
        Result:=StrToInt(VarToStr(Fields[0].Value));
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
          end;
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

procedure TActiveSession.UpdateActiveSession;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countActive:Integer;
begin
  // ����� ����������� ���-�� �������� ������ �� ������ � �� ��
  if GetCountOnline = GetCountActiveSessionBD then Exit;

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
      SQL.Add('SELECT asession.user_id, r.name_role, CONCAT(u.familiya, '+#39' '+#39+', u.name) '+
              ' AS full_name, asession.pc, asession.ip, asession.last_active FROM active_session'+
              ' AS asession JOIN users AS u ON asession.user_id = u.id JOIN role AS r ON u.role = r.id');

      try
        Active:=True;
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
            end;
           Exit;
          end;
      end;

      // ���������� ���-�� �������
      count:=GetCountActiveSessionBD;

      for i:=0 to count-1 do begin

        // ID
        listActiveSession[i].userID:=StrToInt(VarToStr(Fields[0].Value));
        // ����
        listActiveSession[i].role:=VarToStr(Fields[1].Value);
        // ������������
        listActiveSession[i].userName:=VarToStr(Fields[2].Value);
        // ���������
        listActiveSession[i].PC:=VarToStr(Fields[3].Value);
        // IP
        listActiveSession[i].IP:=VarToStr(Fields[4].Value);
        // ���� �������
        listActiveSession[i].dateOnline:=VarToStr(Fields[5].Value);
        // ������
        begin
           // TODO ��������� THREAD!!
           listActiveSession[i].status:='ONLINE';
        end;

        // �������� ���� ��������� ��� ���
        if (AnsiPos('��������',VarToStr(Fields[1].Value)) <> 0) or
           (AnsiPos('��������',VarToStr(Fields[1].Value)) <> 0) then begin
           // �������� � ������� ��� ��� ��������� ��������
           if getCurrentQueueOperator(getUserSIP(listActiveSession[i].userID)) = queue_null  then listActiveSession[i].isQueue:=False
           else listActiveSession[i].isQueue:=True;
        end
        else listActiveSession[i].isQueue:=False;

        Next;
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

procedure TActiveSession.CreateListActiveSession;
var
 i:Integer;
 countActive:Integer;
begin
  countActive:=GetCountActiveSessionBD;

   // ������� listActiveSession
   begin
     SetLength(listActiveSession,countActive);
     for i:=0 to countActive-1 do listActiveSession[i]:=TActiveStruct.Create;
   end;

   UpdateActiveSession;
end;


// class TActiveSession END
//////////////////////////////////////////////////
end.

{
 try
      if m_mutex.WaitFor(INFINITE) = wrSignaled  then begin
        try





        finally
          m_mutex.Release;
        end;
      end;
     finally
       m_mutex.Free;
     end;
}