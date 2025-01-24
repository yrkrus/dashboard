/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� IVR                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TIVRUnit;

interface

uses  System.Classes,
      Data.Win.ADODB,
      Data.DB,
      System.SysUtils,
      Variants,
      Graphics,
      System.SyncObjs,
      IdException,
      System.DateUtils;

  // class TIVRStruct
 type
      TIVRStruct = class
      public
      m_id                                   : Integer; // id �� ��
      m_phone                                : string;  // ����� ��������
      m_waiting_time_start                   : string;  // ��������� �������� ������� ��������
      m_trunk                                : string;  // ������ ������ ������
      m_countNoChange                        : Integer; // ���-�� ��� ������� �� ���������� �������� �������� �� �������

      constructor Create;                  overload;
      procedure Clear;                     virtual;

      end;
   // class TIVRStruct END


/////////////////////////////////////////////////////////////////////////////////////////


 // class TIVR
 type
      TIVR = class
      const
      cGLOBAL_ListIVR                      : Word = 100; // ������ �������
      cGLOBAL_DropPhone                    : Word = 3; // ���-�� ������� ��� ������� ��������� ��� ����� ���� �� IVR �� ����������

      public
      listActiveIVR                        : array of TIVRStruct;

      constructor Create;                   overload;
      destructor Destroy;                   override;


      function Count                      : Integer;

      procedure UpdateData;                             // ���������� ������ � ������� listActiveIVR
      function isExistActive(id:Integer)   :Boolean;   // �������� ���������� �� ����� ����� � �����������
      function isExistDropPhone(id:Integer): Boolean;  // �������� ���� �� ����� ������� ��������� �� IVR


      private
      m_mutex                               : TMutex;

      procedure ClearActiveAll;
      function GetLastFreeIDStructActiveIVR:Integer;      //���������  id ����� ���� � TIVRStruct
      function isChangeWaitingTime(In_m_ID:Integer; InNewTime:string):Boolean; // �������� ���������� �� �����
      function GetWaitingTime(In_m_ID:Integer):string;  // ���������� ������� ��������
      function GetStructIVRID(In_m_ID:Integer):Integer; // ���������� ������ TIVRStruct �� ��� m_id
      function isExistIDIVRtoBD(In_m_id:Integer):Boolean;  // �������� ���� �� ��� ������ � IVR �� ��
      procedure CheckToQueuePhone;                      // �������� ���� �� � ��� � ������� ������

      end;
   // class TIVR END



implementation

uses
  FunctionUnit, GlobalVariables;



constructor TIVRStruct.Create;
 begin
   inherited;
   Clear;
 end;


 procedure TIVRStruct.Clear;
 begin
   Self.m_id:=0;
   Self.m_phone:='';
   Self.m_waiting_time_start:='';
   Self.m_trunk:='';
   Self.m_countNoChange:=0;
 end;



constructor TIVR.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TIVR');


   SetLength(listActiveIVR,cGLOBAL_ListIVR);
   for i:=0 to cGLOBAL_ListIVR-1 do listActiveIVR[i]:=TIVRStruct.Create;
 end;

destructor TIVR.Destroy;
var
 i: Integer;
begin
  for i := Low(listActiveIVR) to High(listActiveIVR) do FreeAndNil(listActiveIVR[i]);
  m_mutex.Free;

  inherited;
end;


 function TIVR.Count;
 var
  i:Integer;
  count:Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    count:=0;
     for i := Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id<>0 then begin
       // �������������� �������� ����� �� ����������� ������ ������� ����������
       if listActiveIVR[i].m_countNoChange <= cGLOBAL_DropPhone then Inc(count);
      end;
     end;

    Result:=count;
  finally
    m_mutex.Release;
  end;
 end;



procedure TIVR.ClearActiveAll;
 var
 i: Integer;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do listActiveIVR[i].Clear;
  finally
    m_mutex.Release;
  end;
 end;

//���������  id ����� ���� � TIVRStruct
function TIVR.GetLastFreeIDStructActiveIVR:Integer;
 var
 i: Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=0 then begin
        Result:=i;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// �������� ���������� �� �����
function TIVR.isChangeWaitingTime(In_m_ID:Integer; InNewTime:string):Boolean;
var
 oldWaiting:string;
begin
 Result:=False;

 oldWaiting:=GetWaitingTime(In_m_ID);
 if oldWaiting='' then Exit;

 // ����� ����������
 if oldWaiting<>InNewTime then Result:=True;

end;


// ���������� ������� ��������
function TIVR.GetWaitingTime(In_m_ID:Integer):string;
var
 i:Integer;
begin
 Result:='';
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=In_m_ID then begin
        Result:=listActiveIVR[i].m_waiting_time_start;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// ���������� ������ TIVRStruct �� ��� m_id
function TIVR.GetStructIVRID(In_m_ID:Integer):Integer;
var
 i:Integer;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
      if listActiveIVR[i].m_id=In_m_ID then begin
        Result:=i;
        Break;
      end;
    end;
  finally
    m_mutex.Release;
  end;
end;

// �������� ���� �� ��� ������ � IVR �� ��
function TIVR.isExistIDIVRtoBD(In_m_id:Integer):Boolean;
const
 cTimeResponse:Word=1;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

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
      SQL.Add('select count(id) from ivr where to_queue=''0'' and date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39+' and id='+#39+IntToStr(In_m_id)+#39);

      Active:=True;

      if Fields[0].Value<>null then begin
       if StrToInt(VarToStr(Fields[0].Value)) <> 0 then Result:=True;
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

 // �������� ���� �� � ��� � ������� ������
 procedure TIVR.CheckToQueuePhone;
 var
  i:Integer;
 begin
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id <> 0 then begin
      if not isExistIDIVRtoBD(listActiveIVR[i].m_id) then
      begin
        // ������� �� ������
        listActiveIVR[i].Clear;
      end;
    end;
  end;
 end;


function TIVR.isExistActive(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;

// �������� ���� �� ����� ������� ��������� �� IVR
function TIVR.isExistDropPhone(id:Integer): Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:=Low(listActiveIVR) to High(listActiveIVR) do begin
    if listActiveIVR[i].m_id = id then
    begin
      if listActiveIVR[i].m_countNoChange>cGLOBAL_DropPhone then begin
        Result:=True;
        Break;
      end;
    end;
  end;
end;



 procedure TIVR.UpdateData;
 const
  cTimeResponse:Word = 1; // ����� ������� ���������������
 var
 i,j:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countIVR:Integer;
 addListActive:Boolean;   // ��������� �������� � listActive! = true
 id:Integer;

 freeIDStructIVR:Integer; // ��������� ID
 currentIDStructIVR:Integer;  // ������� ��������������� ID
 begin
  countIVR:=0;

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
      SQL.Add('select count(phone) from ivr where to_queue=''0'' and date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39);


      Active:=True;
      if Fields[0].Value<>null then countIVR:=Fields[0].Value;

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

       if countIVR>=1 then begin

          SQL.Clear;
          SQL.Add('select id,phone,waiting_time,trunk from ivr where to_queue=''0'' and  date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39);

          Active:=True;

          for i:=0 to countIVR-1 do begin

            try
              if (Fields[0].Value = null) or
                 (Fields[1].Value = null) or
                 (Fields[2].Value = null) or
                 (Fields[3].Value = null)
              then begin
               ado.Next;
               Continue;
              end;


              // �������� �� ���� �� � ��� � ������� ������
              CheckToQueuePhone;


              // �������� ���� �� ����� id ��� � ���
              if isExistActive(StrToInt(VarToStr(Fields[0].Value))) then begin
                 currentIDStructIVR:=GetStructIVRID(StrToInt(VarToStr(Fields[0].Value)));

                 // �������� ���������� �� �����
                 if isChangeWaitingTime(StrToInt(VarToStr(Fields[0].Value)),VarToStr(Fields[2].Value)) then begin
                   // ������� �����
                   listActiveIVR[currentIDStructIVR].m_waiting_time_start:=VarToStr(Fields[2].Value);   //Copy(VarToStr(Fields[2].Value), 4, 5);
                   listActiveIVR[currentIDStructIVR].m_countNoChange:=0;
                 end
                 else begin // ����� �� ���������� ������ ���� ��������� �������
                   Inc(listActiveIVR[currentIDStructIVR].m_countNoChange);
                 end;

              end
              else begin
                // ������ ��������� ID
                freeIDStructIVR:=GetLastFreeIDStructActiveIVR;

                 begin // ��� ������ ������, ����� ���� ����� �� ������ ������� ����� ���������
                  listActiveIVR[freeIDStructIVR].m_id:=StrToInt(VarToStr(Fields[0].Value));
                  listActiveIVR[freeIDStructIVR].m_phone:=VarToStr(Fields[1].Value);
                  listActiveIVR[freeIDStructIVR].m_waiting_time_start:=VarToStr(Fields[2].Value); //Copy(VarToStr(Fields[2].Value), 4, 5);
                  listActiveIVR[freeIDStructIVR].m_trunk:=VarToStr(Fields[3].Value);
                 end;
              end;

            finally
               ado.Next;
            end;
          end;
       end else begin
         // ������� ���� ������
         if Count<>0 then ClearActiveAll;
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


end.
