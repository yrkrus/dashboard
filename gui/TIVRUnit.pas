/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� IVR                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TIVRUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants, Graphics, System.SyncObjs, IdException, System.DateUtils;

  // class TIVRStruct
 type
      TIVRStruct = class
      public
      id                                   : Integer; // id �� ��
      phone                                : string;  // ����� ��������
      waiting_time_start                   : string;  // ��������� �������� ������� ��������
      trunk                                : string;  // ������ ������ ������

      constructor Create;                  overload;
      procedure Clear;                      virtual;

      end;
   // class TIVRStruct END


/////////////////////////////////////////////////////////////////////////////////////////

  // class TIVRDrop
  type
      TIVRDrop = class(TIVRStruct)
      public
      countDrop                       : Integer; // ���-�� ��� ������� ����������

      constructor Create;             overload;
      procedure Clear;                override;


      end;


  // class TIVRDrop END

/////////////////////////////////////////////////////////////////////////////////////////
   // class TIVR
 type
      TIVR = class
      const
      cGLOBAL_ListIVR                      : Word = 100; // ������ �������

      public
      listActiveIVR                        : array of TIVRStruct;
      listDropIVR                          : array of TIVRDrop;

      constructor Create;                   overload;
      destructor Destroy;                   override;


      function GetCountDrop                :Integer;

      function GetCountActive              : Integer;
      procedure ClearActive;
      procedure UpdateData(var p_listDrop:TIVR);                             // ���������� ������ � ������� listActiveIVR + count
      function isExistActive(id:Integer)        :Boolean;   // �������� ���������� �� ����� ����� � �����������


      private
      count_active                          : Integer;
      count_drop                            : Integer;
      m_mutex                               : TMutex;

      function isExistDrop(id:Integer)        :Boolean;   // �������� ���������� �� ����� ����� � �����������
      function isChangeDropTime(id:Integer; InNewTime:string):Boolean;  // �������� ���������� �� ����� � ������� ���������� � listdrop
      procedure addCountDrop(id:Integer);     // ���������� +1 � countDrop

      procedure addListDrop(struct:TIVRStruct); // ���������� ���� ��������� � listdrop
      procedure clearDropExpensityCalls(listActive:array of TIVRStruct; arrayCount:Integer); // �������� ������������ ������� �� listDrop
      procedure DeleteDropID(id:Integer);

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
   Self.id:=0;
   Self.phone:='';
   Self.waiting_time_start:='';
   Self.trunk:='';
 end;


constructor TIVRDrop.Create;
begin
  inherited Create; // ����� ������������ �������� ������
  countDrop:= 0;
end;


procedure TIVRDrop.Clear;
begin
  inherited Clear; // ����� ������ Clear �������� ������
  countDrop:= 0;
end;



constructor TIVR.Create;
 var
  i:Integer;
 begin
    inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TIVR');
    count_active:=0;
    count_drop:=0;

   SetLength(listActiveIVR,cGLOBAL_ListIVR);
   for i:=0 to cGLOBAL_ListIVR-1 do listActiveIVR[i]:=TIVRStruct.Create;

   SetLength(listDropIVR,cGLOBAL_ListIVR);
   for i:=0 to cGLOBAL_ListIVR-1 do listDropIVR[i]:=TIVRDrop.Create;

 end;

destructor TIVR.Destroy;
var
 i: Integer;
begin
  for i := Low(listActiveIVR) to High(listActiveIVR) do FreeAndNil(listActiveIVR[i]);
  for i := Low(listDropIVR) to High(listDropIVR) do FreeAndNil(listDropIVR[i]);

  m_mutex.Free;

  inherited;
end;


 function TIVR.GetCountActive;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.count_active;
  finally
    m_mutex.Release;
  end;
 end;

  function TIVR.GetCountDrop;
 begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    Result:=Self.count_drop;
  finally
    m_mutex.Release;
  end;
 end;

 procedure TIVR.DeleteDropID(id:Integer);
 var
  i:Integer;
 begin
   for i:=0 to cGLOBAL_ListIVR-1 do begin
     if listDropIVR[i].id = id then begin
       listDropIVR[i].Clear;
       Dec(count_drop);
       Break;
     end;
   end;
 end;

 procedure TIVR.ClearActive;
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


function TIVR.isExistActive(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:= 0 to GetCountActive - 1 do
  begin
    if listActiveIVR[i].id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;

function TIVR.isExistDrop(id:Integer):Boolean;
var
  i: Integer;
begin
  Result:=False;
  for i:=0 to GetCountDrop - 1 do
  begin
    if listDropIVR[i].id = id then
    begin
      Result:=True;
      Break;
    end;
  end;
end;


function TIVR.isChangeDropTime(id:Integer; InNewTime:string):Boolean;
var
  i:Integer;
begin
  Result:=False;
  for i:=0 to GetCountDrop - 1 do
  begin
    if listDropIVR[i].id = id then
    begin
      if listDropIVR[i].waiting_time_start <> InNewTime then Result:=True // ����� ���������� � ��� ������
      else Result:=False;

      Break;
    end;
  end;
end;


procedure TIVR.addCountDrop(id:Integer);
var
  i:Integer;
begin
  for i:=0 to GetCountDrop - 1 do
  begin
    if listDropIVR[i].id = id then
    begin
      Inc(listDropIVR[i].countDrop);
      Break;
    end;
  end;
end;


procedure TIVR.addListDrop(struct:TIVRStruct);
var
  i:Integer;
begin
  if isExistDrop(struct.id) then Exit;

  for i:=0 to cGLOBAL_ListIVR - 1 do
  begin
    if listDropIVR[i].id = 0 then
    begin
      listDropIVR[i].id:=struct.id;
      listDropIVR[i].phone:=struct.phone;
      listDropIVR[i].waiting_time_start:=struct.waiting_time_start;
      listDropIVR[i].trunk:=struct.trunk;

      Inc(count_drop);
      Break;
    end;
  end;
end;


procedure TIVR.clearDropExpensityCalls(listActive:array of TIVRStruct; arrayCount:Integer);
var
  i,j:Integer;
  isExist:Boolean;
begin

  for i:=0 to cGLOBAL_ListIVR-1 do begin
    if listDropIVR[i].id<>0 then begin
      isExist:=False;
      for j:=0 to arrayCount-1 do begin
        if listDropIVR[i].id = listActive[j].id then begin
          isExist:=True;
          Break;
        end;
      end;

      if isExist=False then begin
       DeleteDropID(listDropIVR[i].id);
      end;
    end;
  end;

end;



 procedure TIVR.UpdateData(var p_listDrop:TIVR);
 const
  cTimeResponse:Word = 1; // ����� ������� ���������������
 var
 i,j:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countIVR:Integer;
 addListActive:Boolean;   // ��������� �������� � listActive! = true
 id:Integer;

 begin

  countIVR:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

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
           serverConnect.Close;
           FreeAndNil(serverConnect);

           Exit;
        end;
    end;

     // ������� ���� ������
     ClearActive;

     if countIVR>=1 then begin

        SQL.Clear;
        SQL.Add('select id,phone,waiting_time,trunk from ivr where to_queue=''0'' and  date_time > '+#39+GetCurrentDateTimeDec(cTimeResponse)+#39);

        Active:=True;

        for i:=0 to countIVR-1 do begin
          //addListActive:=False;

          try
            if Fields[0].Value <> null then begin

               // ��������� ���� �� ���������
               {if p_listDrop.GetCountDrop<>0 then begin

                 id:=StrToInt(VarToStr(Fields[0].Value));

                 // �������� ���� �� ����� id � �����
                  if p_listDrop.isExistDrop(id) then begin
                     // �������� ���������� �� �����
                     if p_listDrop.isChangeDropTime(id,VarToStr(Fields[2].Value))=False then begin
                        // ����� �� ���������� ������� +1 � drop
                        p_listDrop.addCountDrop(id);
                     end
                     else begin
                       addListActive:=True;
                     end;
                  end
                  else begin
                    addListActive:=True;
                  end;


                  if addListActive then begin
                    listActiveIVR[i].id:=StrToInt(VarToStr(Fields[0].Value));
                    listActiveIVR[i].phone:=VarToStr(Fields[1].Value);
                    listActiveIVR[i].waiting_time_start:=VarToStr(Fields[2].Value);
                    listActiveIVR[i].trunk:=VarToStr(Fields[3].Value);
                    Inc(count_active);

                    // ��������� � listDrop
                    p_listDrop.addListDrop(listActiveIVR[i]);
                  end;


               end
               else} begin // ��� ������ ������, ����� ���� ����� �� ������ ������� ����� ���������
                listActiveIVR[i].id:=StrToInt(VarToStr(Fields[0].Value));
                listActiveIVR[i].phone:=VarToStr(Fields[1].Value);
                listActiveIVR[i].waiting_time_start:=VarToStr(Fields[2].Value);
                listActiveIVR[i].trunk:=VarToStr(Fields[3].Value);
                Inc(count_active);

                // ��������� � listDrop
                p_listDrop.addListDrop(listActiveIVR[i]);
               end;
            end;

          finally
             Next;
          end;
        end;
     end;

     //������� ������������ ������ �� listdrop
     p_listDrop.clearDropExpensityCalls(listActiveIVR,count_active);

  end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);
 end;


end.
