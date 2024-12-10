unit Thread_QUEUEUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TQueueUnit, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls;

type
  Thread_QUEUE = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show;
    procedure showQueue(var  p_listQueue: TQueue);  // переадача списка с данными по ссылке!!
    procedure CriticalError;

  end;

implementation

uses
  FunctionUnit, FormHome, FormDEBUGUnit,GlobalVariables,TCustomTypeUnit;


{ Thread_QUEUE }


procedure Thread_QUEUE.showQueue(var p_listQueue: TQueue);
var
 i:Integer;
 ListItem: TListItem;
 countQueue:Integer;
 correct_time:string;
 existingItem: TListItem;
 idToFind:Integer;
begin
  with HomeForm do begin

    countQueue:=p_listQueue.GetCount;

     if countQueue=0 then begin
       lblCount_QUEUE.Caption:='Очередь';
       STlist_QUEUE_NO_Rings.Visible:=True;
     end
     else begin
      lblCount_QUEUE.Caption:='Очередь ('+IntToStr(countQueue)+')';
      STlist_QUEUE_NO_Rings.Visible:=False;
     end;


    try
      //ListViewQueue.Visible := False; // TODO тестовое, можент и не поможет

     // ListViewQueue.Items.BeginUpdate;
     // ListViewQueue.Columns[0].Width:= 0; // Установка ширины в 0 в редких вариантах почему то он без этого параметра оборажается

      // Очищаем ListView перед добавлением новых элементов
     // ListViewQueue.Clear;


      // Проходим по всем элементам списка
      for i:=0 to countQueue-1 do
      begin
        if Length(p_listQueue.listActiveQueue[i].waiting_time_start) <> 8 then begin
          Continue;
        end;

        idToFind := p_listQueue.listActiveQueue[i].id; // Получаем номер телефона
        existingItem := nil;

        // Поиск существующего элемента по номеру телефона
        for ListItem in ListViewQueue.Items do
        begin
          if ListItem.Caption = IntToStr(idToFind) then
          begin
            existingItem := ListItem;
            Break;
          end;
        end;

        if existingItem = nil then
        begin
          // Элемент не найден, добавляем новый
          ListItem := ListViewQueue.Items.Add;
          ListItem.Caption := IntToStr(p_listQueue.listActiveQueue[i].id); // id

          ListItem.SubItems.Add(p_listQueue.listActiveQueue[i].phone); // номер телефона

          correct_time:=correctTimeQueue(StrToTQueue(p_listQueue.listActiveQueue[i].waiting_time_start),p_listQueue.listActiveQueue[i].waiting_time_start);
          ListItem.SubItems.Add(correct_time); // Время ожидания

          ListItem.SubItems.Add(p_listQueue.listActiveQueue[i].queue); // очередь
        end
        else
        begin
          correct_time:=correctTimeQueue(StrToTQueue(p_listQueue.listActiveQueue[i].waiting_time_start),p_listQueue.listActiveQueue[i].waiting_time_start);
          existingItem.SubItems[1] := correct_time; // Время ожидания
        end;
      end;

       // Удаляем элементы, которые отсутствуют в новых данных
      for i:= ListViewQueue.Items.Count - 1 downto 0 do
      begin
         if not p_listQueue.isExist(StrToInt(ListViewQueue.Items[i].Caption)) then
          ListViewQueue.Items.Delete(i);
      end;


    finally
     // ListViewQueue.Items.EndUpdate;
      //ListViewQueue.Visible := True;
    end;


  end;
end;



procedure Thread_QUEUE.CriticalError;
begin
  HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_QUEUE.'+messclass+'.'+mess;
end;

procedure Thread_QUEUE.show;
var
 listQueue:TQueue;
begin
  listQueue:=TQueue.Create;

  if (CONNECT_BD_ERROR=False) then showQueue(listQueue);

  if listQueue<>nil then FreeAndNil(listQueue);
end;

procedure Thread_QUEUE.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
begin
  inherited;

  CoInitialize(Nil);

  while not Terminated do
  begin

    if UpdateQUEUESTOP then begin
        try
          StartTime:=GetTickCount;

          show;

          EndTime:= GetTickCount;
          Duration:= EndTime - StartTime;
          FormDEBUG.lblThread_QUEUE.Caption:=IntToStr(Duration);
        except
          on E:Exception do
          begin
           INTERNAL_ERROR:=true;
           messclass:=e.ClassName;
           mess:=e.Message;
           TimeLastError:=Now;

           if SharedCurrentUserLogon.GetRole = role_administrator then Synchronize(CriticalError);
           INTERNAL_ERROR:=False;
          end;
        end;
    end;
     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
