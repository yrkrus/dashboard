unit Thread_QUEUEUnit;

interface

uses
    System.Classes, SysUtils, ActiveX, TQueueUnit, Vcl.StdCtrls, Vcl.Controls,
    Vcl.ComCtrls, TLogFileUnit, GlobalVariablesLinkDLL, System.SyncObjs;

type
  Thread_QUEUE = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show;
    procedure showQueue(var  p_listQueue: TQueue);  // переадача списка с данными по ссылке!!
    procedure CriticalError;

  private
  m_initThread: TEvent;  // событие что поток успешно стартовал
  Log:TLoggingFile;

  public
  constructor Create;
  destructor Destroy; override;
  function WaitForInit(_timeout:Cardinal): Boolean;

  end;

implementation

uses
  FunctionUnit, FormHome, GlobalVariables, TCustomTypeUnit, TDebugStructUnit;


{ Thread_QUEUE }


constructor Thread_QUEUE.Create;
begin
  inherited Create(True);               // Suspended=true
  FreeOnTerminate := False;
  m_initThread:=TEvent.Create(nil, False, False, '');
end;


destructor Thread_QUEUE.Destroy;
begin
  m_initThread.Free;
  inherited;
end;


function Thread_QUEUE.WaitForInit(_timeout:Cardinal): Boolean;
begin
  if Terminated then Exit(False);
  Result:=(m_initThread.WaitFor(_timeout) = wrSignaled);
end;

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

    countQueue:=p_listQueue.Count;

     if countQueue=0 then begin
       lblCount_QUEUE.Caption:='Очередь';
       STlist_QUEUE_NO_Rings.Visible:=True;
     end
     else begin
      lblCount_QUEUE.Caption:='Очередь ('+IntToStr(countQueue)+')';
      STlist_QUEUE_NO_Rings.Visible:=False;
     end;


    try
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

          correct_time:=correctTimeQueue(StringToTQueue(p_listQueue.listActiveQueue[i].waiting_time_start),p_listQueue.listActiveQueue[i].waiting_time_start);
          if correct_time<>'null' then ListItem.SubItems.Add(correct_time); // Время ожидания

          ListItem.SubItems.Add(p_listQueue.listActiveQueue[i].queue); // очередь

          if p_listQueue.listActiveQueue[i].trunk = 'LISA' then ListItem.SubItems.Add('lisa')
          else ListItem.SubItems.Add('ivr'); // транк
        end
        else
        begin
          correct_time:=correctTimeQueue(StringToTQueue(p_listQueue.listActiveQueue[i].waiting_time_start),p_listQueue.listActiveQueue[i].waiting_time_start);
          if correct_time<>'null' then existingItem.SubItems[1] := correct_time; // Время ожидания
        end;
      end;

       // Удаляем элементы, которые отсутствуют в новых данных
      for i:= ListViewQueue.Items.Count - 1 downto 0 do
      begin
         if not p_listQueue.isExist(StrToInt(ListViewQueue.Items[i].Caption)) then ListViewQueue.Items.Delete(i);
      end;


    finally
     // ListViewQueue.Items.EndUpdate;
      //ListViewQueue.Visible := True;
    end;


  end;
end;



procedure Thread_QUEUE.CriticalError;
begin
  // записываем в лог
 Log.Save(messclass+':'+mess,IS_ERROR);
end;

procedure Thread_QUEUE.show;
var
 listQueue:TQueue;
begin
  try
   listQueue:=TQueue.Create;
  except
   if not Assigned(listQueue) then Exit;
  end;

  if not CONNECT_BD_ERROR then showQueue(listQueue);

  if listQueue<>nil then FreeAndNil(listQueue);
end;

procedure Thread_QUEUE.Execute;
const
 SLEEP_TIME:Word = 1000;
 NAME_THREAD:string = 'Thread_Queue';
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

  debugInfo: TDebugStruct;
begin
  inherited;
  CoInitialize(Nil);

  Log:=TLoggingFile.Create(NAME_THREAD);

  // вывод debug info
  try
     debugInfo:=TDebugStruct.Create(NAME_THREAD,Log);
     SharedCountResponseThread.Add(debugInfo);
  except
    on E:Exception do
    begin
     messclass:=e.ClassName;
     mess:=e.Message;
     Synchronize(CriticalError);
    end;
  end;

  // событие что запустились
  m_initThread.SetEvent;

  while not Terminated do
  begin

    if UpdateQUEUESTOP then begin
        try
          StartTime:=GetTickCount;

          show;

          EndTime:= GetTickCount;
          Duration:= EndTime - StartTime;

          SharedCountResponseThread.SetCurrentResponse(NAME_THREAD,Duration);
        except
          on E:Exception do
          begin
           //INTERNAL_ERROR:=true;
           messclass:=e.ClassName;
           mess:=e.Message;

           Synchronize(CriticalError);
           //INTERNAL_ERROR:=False;
          end;
        end;
    end;
     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
