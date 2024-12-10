unit Thread_IVRUnit;

interface

uses
  System.Classes,SysUtils, ActiveX, TIVRUnit, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls;

type
  Thread_IVR = class(TThread)
  messclass,mess: string;

  protected
    procedure Execute; override;
    procedure show(var p_listDrop: TIVR);     // переадача списка с данными по ссылке!!
    procedure showIVR(var p_listIVR:TIVR);  // переадача списка с данными по ссылке!!
    procedure CriticalError;
  end;


implementation

uses
  FormHome, FunctionUnit, FormDEBUGUnit,GlobalVariables, TCustomTypeUnit;

{ Thread_IVR }

procedure Thread_IVR.CriticalError;
begin
  HomeForm.STError.Caption:=getCurrentDateTimeWithTime+' Thread_IVR.'+messclass+'.'+mess;
end;


procedure Thread_IVR.showIVR(var p_listIVR:TIVR);
var
 i:Integer;
 ListItem: TListItem;
 countIVR:Integer;
 existingItem: TListItem;
 idToFind:Integer;
begin
  with HomeForm do begin

    countIVR:=p_listIVR.GetCountActive;

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
      for i := 0 to countIVR - 1 do
      begin
        idToFind := p_listIVR.listActiveIVR[i].id; // Получаем id
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
          ListItem.Caption := IntToStr(p_listIVR.listActiveIVR[i].id); // id
          ListItem.SubItems.Add(p_listIVR.listActiveIVR[i].phone); // Номер телефона
          ListItem.SubItems.Add(p_listIVR.listActiveIVR[i].waiting_time_start); // Время ожидания
          ListItem.SubItems.Add(p_listIVR.listActiveIVR[i].trunk); // trunk
        end
        else
        begin
          // Элемент найден, обновляем его данные
          existingItem.SubItems[1] := p_listIVR.listActiveIVR[i].waiting_time_start; // Время ожидания
         end;
      end;

      // Удаляем элементы, которые отсутствуют в новых данных
      for i := ListViewIVR.Items.Count - 1 downto 0 do
      begin
        if not p_listIVR.isExistActive(StrToInt(ListViewIVR.Items[i].Caption)) then
          ListViewIVR.Items.Delete(i);
      end;

    finally
     // ListViewIVR.Items.EndUpdate;
     // ListViewIVR.Visible := True;
    end;

    lblActive.Caption:='act_'+IntToStr(p_listIVR.GetCountActive);
    {
    mActive.Clear;
    for i:=0 to p_listIVR.GetCountActive-1 do begin
      mActive.Lines.Add(p_listIVR.listActiveIVR[i].phone);

    end;  }

  end;
end;


procedure Thread_IVR.show(var p_listDrop: TIVR);
var
 listIVR:TIVR;
 i:Integer;
begin
  listIVR:=TIVR.Create;
  listIVR.UpdateData(p_listDrop);

  if (CONNECT_BD_ERROR=False) then showIVR(listIVR);

  HomeForm.lblDrop.Caption:='drop_'+IntToStr(p_listDrop.GetCountDrop);

  {HomeForm.mDrop.Clear;
    for i:=0 to p_listDrop.GetCountDrop-1 do begin
      if p_listDrop.listDropIVR[i].phone<>'' then begin
        HomeForm.mDrop.Lines.Add(p_listDrop.listDropIVR[i].phone);
      end;
    end; }

  if listIVR<>nil then FreeAndNil(listIVR);
end;

procedure Thread_IVR.Execute;
const
 SLEEP_TIME:Word = 1000;
 var
  StartTime, EndTime: Cardinal;
  Duration: Cardinal;
  listDrop: TIVR;
begin
   inherited;
   CoInitialize(Nil);

   listDrop:=TIVR.Create;

  while not Terminated do
  begin

    if UpdateIVRSTOP then begin
      try
        StartTime:=GetTickCount;

        show(listDrop);

        EndTime:= GetTickCount;
        Duration:= EndTime - StartTime;
        FormDEBUG.lblThread_IVR.Caption:=IntToStr(Duration);
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
