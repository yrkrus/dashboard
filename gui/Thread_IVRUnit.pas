unit Thread_IVRUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TIVRUnit, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls, TLogFileUnit;

type
  Thread_IVR = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_SharedIVR: TIVR);     // переадача списка с данными по ссылке!!
    procedure showIVR(var p_SharedIVR: TIVR);
    procedure CriticalError;
 private
  Log:TLoggingFile;

  end;


implementation

uses
  FormHome, FunctionUnit, FormDEBUGUnit,GlobalVariables, TCustomTypeUnit;

{ Thread_IVR }

procedure Thread_IVR.CriticalError;
begin
   // записываем в лог
   Log.Save(messclass+'.'+mess,IS_ERROR);
end;


procedure Thread_IVR.showIVR(var p_SharedIVR:TIVR);
var
 i:Integer;
 ListItem: TListItem;
 countIVR:Integer;
 existingItem: TListItem;
 idToFind:Integer;
begin
  with HomeForm do begin

    countIVR:=p_SharedIVR.Count;

     if countIVR=0 then begin
       lblCount_IVR.Caption:='IVR';
       STlist_IVR_NO_Rings.Visible:=True;
     end
     else begin
      lblCount_IVR.Caption:='IVR ('+IntToStr(countIVR)+')';
      STlist_IVR_NO_Rings.Visible:=False;
     end;

    try
     // ListViewIVR.Visible := False; // TODO тестовое, можент и не поможет

     // ListViewIVR.Items.BeginUpdate;
     // ListViewIVR.Columns[0].Width:= 0; // Установка ширины в 0 в редких вариантах почему то он без этого параметра оборажается

      // Очищаем ListView перед добавлением новых элементов
     // ListViewIVR.Clear;

      // Проходим по всем элементам списка
      for i:=Low(p_SharedIVR.listActiveIVR) to High(p_SharedIVR.listActiveIVR) do begin
        begin
          if p_SharedIVR.listActiveIVR[i].m_id=0 then Continue;

          // не показываем номера те которые сбросились
          if p_SharedIVR.listActiveIVR[i].m_countNoChange >= TIVR.cGLOBAL_DropPhone then Continue;



          idToFind := p_SharedIVR.listActiveIVR[i].m_id; // Получаем id
          existingItem := nil;

          // Поиск существующего элемента по номеру телефона
          for ListItem in ListViewIVR.Items do
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
            ListItem := ListViewIVR.Items.Add;
            ListItem.Caption := IntToStr(p_SharedIVR.listActiveIVR[i].m_id); // id
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_phone); // Номер телефона
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_waiting_time_start); // Время ожидания
            ListItem.SubItems.Add(p_SharedIVR.listActiveIVR[i].m_trunk); // trunk
          end
          else
          begin
            // Элемент найден, обновляем его данные
            existingItem.SubItems[1] := p_SharedIVR.listActiveIVR[i].m_waiting_time_start; // Время ожидания
           end;
        end;
      end;

      // Удаляем элементы, которые отсутствуют в новых данных
      for i := ListViewIVR.Items.Count - 1 downto 0 do
      begin
        // убрались потому что ушлм в очередь
        if not p_SharedIVR.isExistActive(StrToInt(ListViewIVR.Items[i].Caption)) then ListViewIVR.Items.Delete(i);

        // убрались потому что сбросились и не дошли до очереди
        if p_SharedIVR.isExistDropPhone(StrToInt(ListViewIVR.Items[i].Caption)) then ListViewIVR.Items.Delete(i);
      end;
    except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
        end;
    end;
  end;
end;


procedure Thread_IVR.show(var p_SharedIVR: TIVR);
begin
  if not CONNECT_BD_ERROR then begin
     p_SharedIVR.UpdateData;

     showIVR(p_SharedIVR);
  end;
end;

procedure Thread_IVR.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;

begin
   inherited;
   CoInitialize(Nil);
   Sleep(500);
   Log:=TLoggingFile.Create('Thread_IVR');

  while not Terminated do
  begin

    if UpdateIVRSTOP then begin
      try
        StartTime:=GetTickCount;

        show(SharedIVR);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_IVR.Caption:=IntToStr(Duration);
      except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;
         Synchronize(CriticalError);
        end;
      end;
    end;
     if Duration<SLEEP_TIME then Sleep(SLEEP_TIME-Duration);
  end;
end;

end.
