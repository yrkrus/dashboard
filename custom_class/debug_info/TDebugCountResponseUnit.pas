 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///          Класс для описания подсчета выполнения в потоках                 ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TDebugCountResponseUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  TLogFileUnit,
  Vcl.Forms,
  Vcl.StdCtrls,
  System.SyncObjs,
  Vcl.Graphics,
  FormDEBUGUnit,
  TDebugStructUnit,
  TCustomTypeUnit;

 ////////////////////////////////////////////////////////////////

 // class TThreadShow
  type
      TThreadShow = class(TThread)
      messclass,mess: string;

  private
    m_Form                      :TFormDEBUG;
    Log                         :TLoggingFile;

    m_listNameThread            :TStringList;
    m_count                     :Integer;
    m_list                      :TArray<TDebugStruct>;

   procedure Update;

  protected
    procedure Execute; override;
    procedure CriticalError;

  public
    constructor Create;
    procedure SetLog(var p_Log:TLoggingFile);
    procedure SetAddForm(var p_Form:TFormDEBUG);
    procedure SetAddListNameThread(var p_listNameThread:TStringList);
    procedure SetAddCountList(var p_Count:Integer);
    procedure SetAddListStruct(var p_List:TArray<TDebugStruct>);

   end;

 // class TThreadShow END
////////////////////////////////////////////////////////////////

// class TDebugCountResponse
  type
      TDebugCountResponse = class
      private
      m_listNameThread            :TStringList;
      m_count                     :Integer;
      m_list                      :TArray<TDebugStruct>;

      m_Form                      :TFormDEBUG;
      isCreatedDataWithForm       :Boolean;   // создали ли уже данные на форме

      Log                         :TLoggingFile;
      m_showThread                :TThreadShow; // экземпляр потока отвечающий за отображение инфо на форме DEBUG



      public
      constructor Create(var p_Log:TLoggingFile)           overload;
      destructor Destroy;                                  override;

      procedure SetAddForm(var p_Form:TFormDEBUG);   // используется только для добавление линковки формы
      procedure CreateForm;                          // создание и заполнение формы дебага

      procedure ShowStart;                           // показ текущего состояния потоков
      procedure ShowStop;                            // остановка потока показа состояния потоков

      procedure Add(_structDebug:TDebugStruct);      // добавить поток в мониторинг
      procedure AddParamsTThreadShow;                // добавление параметров для работы потока отображения инфо на форме DEBUG

      procedure SetCurrentResponse(_name:string; _value:Integer);   // текущее значение
      function GetAverageTime(_name:string):Integer;                // среднее время обновления

      property CreatedForm: Boolean read isCreatedDataWithForm;


      end;
 // class TDebugCountResponse END

implementation

uses
  FunctionUnit;

constructor TThreadShow.Create;
begin
   inherited Create(True);
   messclass:='';
   mess:='';
end;

procedure TThreadShow.SetLog(var p_Log: TLoggingFile);
begin
  Log:=p_Log;
end;


procedure TThreadShow.SetAddForm(var p_Form: TFormDEBUG);
begin
  m_Form:=p_Form;
end;


procedure TThreadShow.SetAddListNameThread(var p_listNameThread: TStringList);
begin
  m_listNameThread:=p_listNameThread;
end;

procedure TThreadShow.SetAddCountList(var p_Count:Integer);
begin
 m_count:=p_Count;
end;


procedure TThreadShow.SetAddListStruct(var p_List:TArray<TDebugStruct>);
begin
  m_list:=p_List;
end;



procedure TThreadShow.Update;
var
 i,j:Integer;
 nameThread:string;
 lastValue:string;
 uptime:Int64;
begin
  // uptime
  begin
   uptime:=GetProgrammUptime;
   m_Form.lblUptime.Caption:=GetProgrammUptime(uptime)+' ('+IntToStr(uptime)+')';
  end;

  // programm_started
  begin
    if m_Form.lblProgramStarted.Caption='---' then m_Form.lblProgramStarted.Caption:=DateTimeToStr(GetProgrammStarted);
  end;


  for i:=0 to m_count-1 do begin
    nameThread:=m_listNameThread[i];

    // текущее значение
    for j:=0 to m_Form.panel.ComponentCount-1 do begin
      if m_Form.panel.Components[j].Name='lblCurrent_'+nameThread then begin
        lastValue:=(m_Form.panel.Components[j] as TLabel).Caption;

        if lastValue<>IntToStr(m_list[i].CurrentResponse) then begin
          (m_Form.panel.Components[j] as TLabel).Caption:=IntToStr(m_list[i].CurrentResponse);
          (m_Form.panel.Components[j] as TLabel).InitiateAction;
          (m_Form.panel.Components[j] as TLabel).Repaint;
        end;
      end;
    end;

    // среднее значение
    for j:=0 to m_Form.panel.ComponentCount-1 do begin
      if m_Form.panel.Components[j].Name='lblAverage_'+nameThread then begin
        lastValue:=(m_Form.panel.Components[j] as TLabel).Caption;

        if lastValue<>IntToStr(m_list[i].CurrentAverage) then begin
         (m_Form.panel.Components[j] as TLabel).Caption:=IntToStr(m_list[i].CurrentAverage);
         (m_Form.panel.Components[j] as TLabel).InitiateAction;
         (m_Form.panel.Components[j] as TLabel).Repaint;
        end;
      end;
    end;

    // максимальное значение
    for j:=0 to m_Form.panel.ComponentCount-1 do begin
      if m_Form.panel.Components[j].Name='lblMax_'+nameThread then begin
        lastValue:=(m_Form.panel.Components[j] as TLabel).Caption;

        if lastValue <> IntToStr(m_list[i].CurrentMax)+' ('+DateTimeToStr(m_list[i].CurrentMaxTime)+')' then begin
          (m_Form.panel.Components[j] as TLabel).Caption:=IntToStr(m_list[i].CurrentMax)+
                                                                ' ('+DateTimeToStr(m_list[i].CurrentMaxTime)+')';
         (m_Form.panel.Components[j] as TLabel).InitiateAction;
         (m_Form.panel.Components[j] as TLabel).Repaint;
        end;
      end;
    end;

  end;
end;

procedure TThreadShow.Execute;
begin
  while not Terminated do
  begin
    try
      Update;
    except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
    end;
    Sleep(1000); // обновляем среднее значение каждую секунду
  end;
end;

procedure TThreadShow.CriticalError;
const
 IS_ERROR:Boolean = True;
begin
  // записываем в лог
  Log.Save(messclass+':'+mess, IS_ERROR);
end;


constructor TDebugCountResponse.Create(var p_Log:TLoggingFile);
begin
  // inherited;
   m_count:=0;
   m_listNameThread:=TStringList.Create;
   SetLength(m_list, 0);
   Log:=p_Log;
end;

destructor TDebugCountResponse.Destroy;
var i: Integer;
begin
  // Останавливаем и освобождаем поток
  if Assigned(m_showThread) then
  begin
    m_showThread.Terminate;
    m_showThread.WaitFor;
    m_showThread.Free;
  end;

  // Освобождаем все TDebugStruct
  for i := 0 to High(m_list) do m_list[i].Free;
  SetLength(m_list, 0);

  // Освобождаем имя-потоков
  m_listNameThread.Free;

  inherited;
end;

 // используется только для добавление линковки формы
procedure TDebugCountResponse.SetAddForm(var p_Form:TFormDEBUG);
begin
   m_Form:=p_Form;
   isCreatedDataWithForm:=False;  // флаг того что показали ли первый раз уже форму или нет, нужно ли ее создаваить
end;

// создание и заполнение формы дебага
procedure TDebugCountResponse.CreateForm;
const
  cTOPSTART=6;
  cSTEP:Word = 20;
  var
 lblNameThread          :array of TLabel;
 lblCurrent             :array of TLabel;
 lblAverage             :array of TLabel;
 lblMax                 :array of TLabel;

 i:Integer;
 nameThread:string;
begin
   // выставляем размерность
  SetLength(lblNameThread,m_count);
  SetLength(lblCurrent,m_count);
  SetLength(lblAverage,m_count);
  SetLength(lblMax,m_count);

   for i:=0 to m_count-1 do begin
      nameThread:=m_listNameThread[i];

      // название потока
      begin
        lblNameThread[i]:=TLabel.Create(m_Form.panel);
        lblNameThread[i].Name:='lbl_'+nameThread;
        lblNameThread[i].Tag:=1;
        lblNameThread[i].Caption:=nameThread;
        lblNameThread[i].Left:=8;

        if i=0 then lblNameThread[i].Top:=cTOPSTART
        else lblNameThread[i].Top:=cTOPSTART+(cSTEP * i);

        lblNameThread[i].Font.Name:='Tahoma';
        lblNameThread[i].Font.Size:=10;
        //lblNameThread[i].Font.Style:=[fsBold];
        lblNameThread[i].AutoSize:=False;
        lblNameThread[i].Width:=214;
        lblNameThread[i].Height:=16;
        lblNameThread[i].Alignment:=taLeftJustify;
        lblNameThread[i].Parent:=m_Form.panel;
      end;

      // текущее значение
      begin
        lblCurrent[i]:=TLabel.Create(m_Form.panel);
        lblCurrent[i].Name:='lblCurrent_'+nameThread;
        lblCurrent[i].Tag:=1;
        lblCurrent[i].Caption:='---';

        lblCurrent[i].Left:=243;

        if i=0 then lblCurrent[i].Top:=cTOPSTART
        else lblCurrent[i].Top:=cTOPSTART+(cSTEP * i);

        lblCurrent[i].Font.Name:='Tahoma';
        lblCurrent[i].Font.Size:=10;
        lblCurrent[i].AutoSize:=False;
        lblCurrent[i].Width:=100;
        lblCurrent[i].Height:=16;
        lblCurrent[i].Alignment:=taCenter;
        lblCurrent[i].Parent:=m_Form.panel;

      end;

      // среднее значение
      begin
        lblAverage[i]:=TLabel.Create(m_Form.panel);
        lblAverage[i].Name:='lblAverage_'+nameThread;
        lblAverage[i].Tag:=1;
        lblAverage[i].Caption:='---';

        lblAverage[i].Left:=349;

        if i=0 then lblAverage[i].Top:=cTOPSTART
        else lblAverage[i].Top:=cTOPSTART+(cSTEP * i);

        lblAverage[i].Font.Name:='Tahoma';
        lblAverage[i].Font.Size:=10;
        lblAverage[i].AutoSize:=False;
        lblAverage[i].Width:=100;
        lblAverage[i].Height:=16;
        lblAverage[i].Alignment:=taCenter;
        lblAverage[i].Parent:=m_Form.panel;
      end;

      // максимальное значение
      begin
        lblMax[i]:=TLabel.Create(m_Form.panel);
        lblMax[i].Name:='lblMax_'+nameThread;
        lblMax[i].Tag:=1;
        lblMax[i].Caption:='---';

        lblMax[i].Left:=452;

        if i=0 then lblMax[i].Top:=cTOPSTART
        else lblMax[i].Top:=cTOPSTART+(cSTEP * i);

        lblMax[i].Font.Name:='Tahoma';
        lblMax[i].Font.Size:=10;
        lblMax[i].AutoSize:=False;
        lblMax[i].Width:=210;
        lblMax[i].Height:=16;
        lblMax[i].Alignment:=taCenter;
        lblMax[i].Parent:=m_Form.panel;
      end;
   end;

   isCreatedDataWithForm:=True;
end;

// показ текущего состояния потоков
procedure TDebugCountResponse.ShowStart;
begin
  // Инициализация потока для показа данных на форме DEBUG
  if not Assigned(m_showThread) or m_showThread.Terminated then
  begin
    m_showThread := TThreadShow.Create;
    AddParamsTThreadShow; // Добавляем параметры для потока
  end;

  if not m_showThread.Started then
  begin
    m_showThread.Start; // Запускаем, если еще не запущен
  end;
end;

// остановка потока показа состояния потоков
procedure TDebugCountResponse.ShowStop;
begin
  if Assigned(m_showThread) and m_showThread.Started then
  begin
    m_showThread.Terminate; // Устанавливаем флаг завершения
    m_showThread.WaitFor; // Ждем завершения потока
  end;
end;


procedure TDebugCountResponse.Add(_structDebug:TDebugStruct);
var
  newLength: Integer;
  clonedStruct: TDebugStruct;
begin
  try
    clonedStruct:= _structDebug.Clone;
    m_listNameThread.Add(clonedStruct.Name);

    // Увеличиваем размер массива на 1
    newLength:= Length(m_list) + 1;
    SetLength(m_list, newLength);

    // Добавляем клонированный объект в массив
    m_list[newLength - 1]:= clonedStruct;

    // Увеличиваем счетчик
    Inc(m_count);
  finally
    if clonedStruct.isExistLog then clonedStruct.SendLog('Debug thread <b>'+clonedStruct.Name+'</b> is created!');
  end;
end;


procedure TDebugCountResponse.AddParamsTThreadShow;
begin
  m_showThread.SetAddListNameThread(m_listNameThread);
  m_showThread.SetAddCountList(m_count);
  m_showThread.SetAddListStruct(m_list);
  m_showThread.SetLog(Log);
  m_showThread.SetAddForm(m_Form);
end;

// текущее значение
procedure TDebugCountResponse.SetCurrentResponse(_name:string; _value:Integer);
var
 i:Integer;
begin
   try
     for i:=0 to m_count-1 do begin

        if m_listNameThread[i]='' then Continue;

        if m_listNameThread[i] = _name then begin

          if m_list[i].Mutex.WaitFor(INFINITE)= wrSignaled then
          try
            m_list[i].SetResponse(_value);
          finally
            m_list[i].Mutex.Release;
          end;

          Break;
        end;
     end;
   except
    on E:Exception do
    begin
     Log.Save('TDebugCountResponse.SetCurrentResponse | '+e.ClassName+' : '+E.Message, True);
    end;
   end;
end;

// среднее время обновления
function TDebugCountResponse.GetAverageTime(_name:string):Integer;
var
 i:Integer;
begin
  Result:=0;

   try
     for i:=0 to m_count-1 do begin
        if (m_listNameThread.Count=0) or (i > m_count-1) then Exit;

        if m_listNameThread[i] = _name then begin

          if m_list[i].Mutex.WaitFor(INFINITE)= wrSignaled then
          try
           Result:=m_list[i].CurrentAverage;
          finally
            m_list[i].Mutex.Release;
          end;

          Break;
        end;
     end;
   except
    on E:Exception do
    begin
     Log.Save('TDebugCountResponse.GetAverageTime | '+e.ClassName+' : '+E.Message, True);
    end;
   end;
end;


end.