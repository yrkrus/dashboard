/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///      ����� ��� �������� �������� ���-�� ���������� ������� �� �������     ///
///                     � ��������� �� ������� ������                         ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TAnsweredQueueUnit;

interface

uses System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants, Graphics, TCustomTypeUnit;


   // class TStructAnswered_list
  type
      TStructAnswered_list = class
      public
      id                                     :Integer;
      queue                                  :Integer;
      waiting_time                           :string;
      talk_time                              :string;


      constructor Create;                     overload;

      end;
 // class TStructAnswered_list END




   // class TStructAnswered
  type
      TStructAnswered = class
      public
      count                                 : Integer;      // ���-�� ����������
      list_id                               : TStringList;  // ������ � ID ��������������
      list_answered_time                    : TStringList;  // ������ � ����������� ��������


      constructor Create;                     overload;
      destructor Destroy;                     override;

      procedure updateCount;                                // ���������� ���-�� ��������� �������
      procedure Clear;                                      // ������� �� ���� ������
      end;
 // class TStructAnswered END



  // class TAnsweredQueue
  type
      TAnsweredQueue = class
      public
      list                                  : array of TStructAnswered; // ������
      updateAnsweredNow                     : Boolean;                  // ����� �� �������� ���� �������

      function getCountAllAnswered          : Integer;                  // ����� ��������
      function isExistNewAnswered           : Boolean;                  // ���� �� ����� ���������� �� ��
      function getCountMaxAnswered          : Integer;                  // ������������ ����� ��������

      constructor Create;                     overload;
      destructor  Destroy;                    overload;

      procedure updateAnswered;                                         // ���������� ����������
      procedure showAnswered;                                           // ���������� ���-��
      procedure Clear;                                                  // ������� �� ���� ������� ������

      private
      function isExistAnsweredId(id:Integer): Boolean;                  // ���� �� ����� id � ������
      procedure addAnswered(id,answered_time:Integer);                  // ���������� � ������

      end;
 // class TAnsweredQueue END


const
   cGLOBAL_ListAnswered: Word   = 4;    // ��������� ��� ������� �� TStructAnswered

implementation

uses
  FunctionUnit, FormHome, GlobalVariables;


 constructor TStructAnswered_list.Create;
 begin
    inherited;
    id:=0;
    queue:=0;
 end;


 constructor TStructAnswered.Create;
 begin
   inherited;

   count:=0;
   list_answered_time:=TStringList.Create;
   list_id:=TStringList.Create;
 end;

destructor TStructAnswered.Destroy;
begin
  list_id.Free; // ������������ TStringList
  list_answered_time.Free; // ������������ TStringList
  inherited Destroy; // ����� ����������� ������������� ������
end;


 procedure TStructAnswered.Clear;
 begin
   Self.count:=0;
   Self.list_id.Clear;
   Self.list_answered_time.Clear;
 end;

procedure TStructAnswered.updateCount;
begin
  Self.count:=Self.list_id.Count;
end;


 constructor TAnsweredQueue.Create;
 var
  i:Integer;
 begin
   inherited;

   // ������� list
   begin
     SetLength(list,cGLOBAL_ListAnswered);
     for i:=0 to cGLOBAL_ListAnswered-1 do list[i]:=TStructAnswered.Create;
   end;

   Self.updateAnsweredNow:=False;
 end;


destructor TAnsweredQueue.Destroy;
var
  i: Integer;
begin
  // ������������ ������� �������� �������
  for i:=Low(list) to High(list) do list[i].Free; // ����������� ������ ������ TStructAnswered

  // ������� �������
  SetLength(list, 0); // ������� ������ �� �������

  inherited Destroy; // ����� ����������� ������������� ������
end;


 procedure TAnsweredQueue.Clear;
 const
 colorGood:TColor     = $0031851F;
 var
  i:Integer;
 begin
    for i:=0 to cGLOBAL_ListAnswered-1 do list[i].clear;
    Self.updateAnsweredNow:=False;

    with HomeForm do begin
       ST_SL.Caption:='SL: 100%';
       ST_SL.Font.Color:=colorGood;
    end;
 end;


 function TAnsweredQueue.getCountMaxAnswered;
 var
  i,j,max_wait:Integer;
 begin
   max_wait:=0;
   for i:=0 to cGLOBAL_ListAnswered-1  do begin
     for j:=0 to list[i].count-1 do begin
       if max_wait< StrToInt(list[i].list_answered_time[j]) then max_wait:=StrToInt(list[i].list_answered_time[j]);
     end;
   end;

   Result:=max_wait;
 end;

 procedure TAnsweredQueue.showAnswered;
 const
 colorGood:TColor     = $0031851F;
 colorNotBad:Tcolor   = $0000D5D5;
 colorBad:TColor      = $000303E9;
 var
  i:Integer;
  SL:Integer;
  procent:Double;
  resultat:string;
 begin
   for i:=0 to cGLOBAL_ListAnswered-1 do begin
    with HomeForm do begin
      procent:=list[i].count * 100 / getCountAllAnswered;
      resultat:=FormatFloat('0.0',procent);
      resultat:=StringReplace(resultat,',','.',[rfReplaceAll]);

     case i of
       0: begin
         lblStatistics_Answered30.Caption:=IntToStr(list[i].count) + ' ('+resultat+'%)';

         SL:=Round(list[i].count / getCountAllAnswered * 100);
         // ������� SL
         ST_SL.Caption:='SL: '+IntToStr(SL)+'%';

         case SL of
           0..50: begin
              ST_SL.Font.Color:=colorBad;
           end;
           51..79:begin
              ST_SL.Font.Color:=colorNotBad;
           end;
           80..100:begin
              ST_SL.Font.Color:=colorGood;
           end;
         end;


       end;
       1: lblStatistics_Answered60.Caption:=IntToStr(list[i].count)  + ' ('+resultat+'%)';
       2: lblStatistics_Answered120.Caption:=IntToStr(list[i].count) + ' ('+resultat+'%)';
       3: lblStatistics_Answered121.Caption:=IntToStr(list[i].count) + ' ('+resultat+'%)';
     end;
    end;
   end;
 end;

 procedure TAnsweredQueue.addAnswered(id,answered_time:Integer);
 begin
   case answered_time of
    0..30:begin
      list[0].list_id.Add(IntToStr(id));
      list[0].list_answered_time.Add(IntToStr(answered_time));
      list[0].updateCount; // ������� ���-�� �������
    end;
    31..60:begin
      list[1].list_id.Add(IntToStr(id));
      list[1].list_answered_time.Add(IntToStr(answered_time));
      list[1].updateCount; // ������� ���-�� �������
    end;
    61..120:begin
      list[2].list_id.Add(IntToStr(id));
      list[2].list_answered_time.Add(IntToStr(answered_time));
      list[2].updateCount; // ������� ���-�� �������
    end;
    else begin
     list[3].list_id.Add(IntToStr(id));
     list[3].list_answered_time.Add(IntToStr(answered_time));
     list[3].updateCount; // ������� ���-�� �������
    end;
   end;
 end;


 function TAnsweredQueue.getCountAllAnswered;
 var
  i:Integer;
  allCount:Integer;
 begin
    allCount:=0;

    for i:=0 to cGLOBAL_ListAnswered-1 do begin
      if allCount=0 then allCount:=list[i].count
      else allCount:=allCount+list[i].count;
    end;

    Result:=allCount;
 end;


function TAnsweredQueue.isExistNewAnswered;
var
 countAllAnswered:Integer;
begin
  countAllAnswered:=StrToInt(GetStatistics_day(stat_answered));
  if countAllAnswered=0 then begin
   Result:=False;
   Exit;
  end;

  // ��������� � ������� ���-���
  if getCountAllAnswered<>countAllAnswered then Result:=True
  else Result:=False;
end;


function TAnsweredQueue.isExistAnsweredId(id: Integer):Boolean;
var
 i,j:Integer;
 isExist:Boolean;
begin
  Result:=False;
  isExist:=False;

  for i:=0 to cGLOBAL_ListAnswered-1 do begin
    for j:=0 to list[i].list_id.Count-1 do begin
      if id = StrToInt(list[i].list_id[j])  then begin
        isExist:=True;
        Break;
      end;
    end;

    if isExist then Break;
  end;

  if isExist then Result:=True
  else Result:=False;
end;



// ���������� ���������� �������
procedure TAnsweredQueue.updateAnswered;
var
 i,j:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 listAnsweredBD: array of TStructAnswered_list;
 countAnswered:Integer;
 time_queue5000,time_queue5050:Integer;
 curr_time:Integer;

  ALength: Cardinal;
      n: Cardinal;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then Exit;

  // ���-�� ���������� �� ������� ������
  countAnswered:=StrToInt(GetStatistics_day(stat_answered));
  if countAnswered=0 then begin
    FreeAndNil(ado);
    serverConnect.Close;
    FreeAndNil(serverConnect);
    Exit;
  end;

  // ������������ ������ � �������� �������
  SetLength(listAnsweredBD,countAnswered);
  for i:=0 to countAnswered-1 do listAnsweredBD[i]:=TStructAnswered_list.Create;

  // ������ ����
  with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;
    SQL.Add('select id,number_queue,waiting_time,talk_time from queue where date_time > '+#39+GetCurrentStartDateTime+#39+' and answered = ''1'' and sip <>''-1'' and hash is not null');
    Active:=True;

    for i:=0 to countAnswered-1 do begin
      listAnsweredBD[i].id:=StrToInt(VarToStr(Fields[0].Value));
      listAnsweredBD[i].queue:=StrToInt(VarToStr(Fields[1].Value));
      listAnsweredBD[i].waiting_time:=VarToStr(Fields[2].Value);
      listAnsweredBD[i].talk_time:=VarToStr(Fields[3].Value);

     Next;
    end;
  end;

  time_queue5000:=getIVRTimeQueue(queue_5000);
  time_queue5050:=getIVRTimeQueue(queue_5050);

  // ��������� ������ ���� �� ����� id � ������
   for i:=0 to countAnswered-1 do begin
     if not isExistAnsweredId(listAnsweredBD[i].id) then begin
       curr_time:=0;
       // ��������� � ������
       // ������ ������� �� ������� ����� ���������� � ������� ����� - ����� �� IVR
       case listAnsweredBD[i].queue of
        5000: curr_time:=getTimeAnsweredToSeconds(listAnsweredBD[i].waiting_time) - getTimeAnsweredToSeconds(listAnsweredBD[i].talk_time) - time_queue5000;
        5050: curr_time:=getTimeAnsweredToSeconds(listAnsweredBD[i].waiting_time) - getTimeAnsweredToSeconds(listAnsweredBD[i].talk_time) - time_queue5050;
       end;

       if curr_time<=0 then curr_time:=0;
       addAnswered(listAnsweredBD[i].id,curr_time);
     end;
   end;

  FreeAndNil(ado);
  serverConnect.Close;
  FreeAndNil(serverConnect);

  // delete array listAnsweredBD
  for i:= 0 to countAnswered- 1 do FreeAndNil(listAnsweredBD[i]);

end;

end.
