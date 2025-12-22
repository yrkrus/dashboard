unit FormPropushennieUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Data.Win.ADODB, Data.DB, IdException,
  Vcl.StdCtrls,TCustomTypeUnit,
  TQueueStatisticsUnit, Vcl.Buttons, Vcl.ExtCtrls,
  System.DateUtils, TThreadDispatcherUnit, Clipbrd;


type
  TFormPropushennie = class(TForm)
    Label2: TLabel;
    combox_QueueFilter: TComboBox;
    group: TGroupBox;
    scroll: TScrollBox;
    panel: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ST_no_missed: TStaticText;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure scrollMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure scrollMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure combox_QueueFilterChange(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure lblPeopleClick(Sender: TObject);
    procedure lblPhoneCopyBufferClick(Sender: TObject);


  private
    { Private declarations }
  m_queueStart    :enumQueue;  // текущие очереди с которых будет открываться окно
  m_missedStart   :enumMissed;
  m_callbakRun    :BOOL;

  m_showInfoRecallMissed:Boolean;  // флаг того что нужно показать инфо что перезвон только для статуса callback
  m_missedCount   :Integer;
  isOneUpdateData :Boolean;             // однократное обновление данных


  m_dispatcher    :TThreadDispatcher;   // планировщик

  m_manualShow    :Boolean; // флаг того что руками открыли окно, а не через диспетчер

  procedure Show;
  procedure CreateForm(_queue:enumQueue; _missed:enumMissed);  // создание формы
  procedure LoadData(_queue:enumQueue;_missed:enumMissed);
  procedure Clear;
  procedure ClearForm;                 // очитска формы
  procedure CreateComboxChoiseQueue;   // создвание листа с выбором фильтра по очередям

  procedure ResizeForm(_countMissed:Integer);  // изменение размер окна в заивсимости от кол-ва пропущенных телефонов
  function GetPeriodCall(_datetime:TDateTime;
                         var p_lbl:TLabel):string;  // сколько прошло времени с момента звонка (в классе это не нужно)


  procedure CenterForm;  // центрирование окна

  procedure EnableOrDisableReCallButton(var p_button:TBitBtn); // вкл\выкл кнопку перезвонить
  procedure ShowInfoRecallMissed; // показ информации что кнопки перезвона доступны если в статусе callback находится оператор


  procedure UpdateOnlyTimesPeriod; // обновление времени периода звонка
  procedure UpdateData;   // обновление данных


  protected
 // procedure CreateParams(var Params: TCreateParams); override;
 // procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

  public
    { Public declarations }
  procedure SetQueue(_queue:enumQueue; _missed:enumMissed);  // установка с какой очереди будем открывать окно
  procedure SetCallbak; // открытые окна из под оператора + статус callback

  procedure SetManualShow(_value:Boolean); // ручное открытие окна


  end;

const
 cSIZE_DEFAULT:Word             = 170; // размер по умолчанию для вывода окна
 cSIZE_DEFAULT_MAX:Word         = 870; // максимальный размер окга после которого включаем сколлл
 cSIZE_STEP_GROUP:Word          = 70;  // разница на group
 cSIZE_STEP_SCROLL:Word         = 100; // разница на scoll
 cSIZE_STEP_PHONE_1_UNIT:Word   = 30;  // щаг одного номера
 cSEZE_PHONE_STARTED_UNIT:Word  = 60; // стартовое кол-во телефонов по умолчанию (cSIZE_STEP_PHONE_1_UNIT * 2)
 cSTEP:Word = 28;       // шаг

var
  FormPropushennie: TFormPropushennie;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL, GlobalImageDestination, GlobalVariables, TXmlUnit, FormPropushennieShowPeopleUnit, TAutoPodborPeopleUnit;

{$R *.dfm}

//procedure TFormPropushennie.CreateParams(var Params: TCreateParams);
//begin
//  inherited;
//  // 1) заново добавляем WS_EX_APPWINDOW
//  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
//  // 2) снимаем Owner/Parent у окна, приклеив к десктопу
//  Params.WndParent := HWND_DESKTOP;
//end;

//procedure TFormPropushennie.WMSysCommand(var Msg: TWMSysCommand);
//begin
//  if (Msg.CmdType and $FFF0) = SC_MINIMIZE then
//  begin
//    ShowWindow(Self.Handle, SW_MINIMIZE);
//    // и НЕ вызываем inherited, чтобы не прокатилось на всё приложение
//  end
//  else
//  inherited;
//end;


// установка с какой очереди будем открывать окно
procedure TFormPropushennie.SetQueue(_queue:enumQueue; _missed:enumMissed);
begin
  m_queueStart:=_queue;
  m_missedStart:=_missed;
end;

// открытые окна из под оператора + статус callback
procedure TFormPropushennie.SetCallbak;
begin
  m_callbakRun:=True;
end;

// ручное открытие окна
procedure TFormPropushennie.SetManualShow(_value:Boolean);
begin
  m_manualShow:=_value;
end;

// создание формы
procedure TFormPropushennie.CreateForm(_queue:enumQueue; _missed:enumMissed);
const
  cTOPSTART=5;
  cTOPSTART_BUTTON=2;
var
 lblName                        :TArray<TLabel>;
 lblTime                        :TArray<TLabel>;
 lblPhone                       :TArray<TLabel>;
 lblFIO                         :TArray<TLabel>;
 lblTrunk                       :TArray<TLabel>;
 lblWaiting                     :TArray<TLabel>;
 btnAction                      :TArray<TBitBtn>;
 lblPeriod                      :TArray<TLabel>;

 bmp                            :TBitmap;
 i                :Integer;
 nameControl      :string;
 counts           :Integer;
 FindedComponent  :TLabel;

 _id:Integer;

 countPeople:Integer;
begin
 counts:=SharedQueueStatistics.GetMissedCount(_queue,_missed);

  // выставляем размерность
  SetLength(lblName,counts);
  SetLength(lblTime,counts);
  SetLength(lblPhone,counts);
  SetLength(lblFIO,counts);
  SetLength(lblTrunk,counts);
  SetLength(lblWaiting,counts);
  SetLength(btnAction,counts);
  SetLength(lblPeriod,counts);


  // Создание объекта TBitmap
  begin
   if FileExists(ICON_MISSED_CALLS) then begin
     bmp := TBitmap.Create;
    try
      // Загрузка изображения из файла
      bmp.LoadFromFile(ICON_MISSED_CALLS);
    except

    end;
   end;
  end;

   _id:=0;  // это нужно чтобюы в обратном направлении создались элементы от нового к старому

   for i:=counts-1 downto 0 do begin
    nameControl:=IntToStr(SharedQueueStatistics.GetCalls_ID(_queue,_missed,i));

    // проверим был ли уже ранее такой компонент сделан
    FindedComponent := TLabel(FormPropushennie.panel.FindComponent('lbl_datetime_' + nameControl));
    if Assigned(FindedComponent) then Continue;

     // время звонка
      begin

        lblTime[_id]:=TLabel.Create(FormPropushennie.panel);
        lblTime[_id].Name:='lbl_datetime_'+nameControl;
        lblTime[_id].Tag:=1;
        lblTime[_id].Caption:=DateTimeToStr(SharedQueueStatistics.GetCalls_DateTime(_queue,_missed,i));
        lblTime[_id].Left:=14;

        if _id=0 then lblTime[_id].Top:=cTOPSTART
        else lblTime[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblTime[_id].Font.Name:='Tahoma';
        lblTime[_id].Font.Size:=10;
        lblTime[_id].AutoSize:=False;
        lblTime[_id].Width:=131;
        lblTime[_id].Height:=16;
        lblTime[_id].Alignment:=taCenter;
        lblTime[_id].Parent:=FormPropushennie.panel;
      end;

      // номер телефона
      begin
        lblPhone[_id]:=TLabel.Create(FormPropushennie.panel);
        lblPhone[_id].Name:='lbl_phone_'+nameControl;
        lblPhone[_id].Tag:=1;
        lblPhone[_id].Caption:=SharedQueueStatistics.GetCalls_Phone(_queue,_missed,i);
        lblPhone[_id].Left:=166;

        if _id=0 then lblPhone[_id].Top:=cTOPSTART
        else lblPhone[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblPhone[_id].Font.Name:='Tahoma';
        lblPhone[_id].Font.Size:=10;
        lblPhone[_id].AutoSize:=False;
        lblPhone[_id].Width:=139;
        lblPhone[_id].Height:=16;

        // копирование номера тлф в буфер обмена
        lblPhone[_id].OnClick:=lblPhoneCopyBufferClick;
        lblPhone[_id].Cursor:=crHandPoint;
        lblPhone[_id].Hint:='Скопировать номер телефона в буфер обмена';
        lblPhone[_id].ShowHint:=True;


        lblPhone[_id].Alignment:=taCenter;
        lblPhone[_id].Parent:=FormPropushennie.panel;
      end;

      // ФИО
      begin
        lblFIO[_id]:=TLabel.Create(FormPropushennie.panel);
        lblFIO[_id].Name:='lbl_fio_'+nameControl;
        lblFIO[_id].Tag:=1;
        lblFIO[_id].Caption:=SharedQueueStatistics.GetCalls_FIO(_queue,_missed,i,countPeople);
        lblFIO[_id].Left:=309;

        if _id=0 then lblFIO[_id].Top:=cTOPSTART
        else lblFIO[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblFIO[_id].Font.Name:='Tahoma';
        lblFIO[_id].Font.Size:=8;
        lblFIO[_id].Font.Style:=[fsBold];
        lblFIO[_id].Font.Color:=clHighlight;
        lblFIO[_id].AutoSize:=False;
        lblFIO[_id].Width:=278;
        lblFIO[_id].Height:=16;
        lblFIO[_id].WordWrap:=True;

        // больше чем 1 пациент на номере
        if countPeople >= 2  then begin
          lblFIO[_id].OnClick:=lblPeopleClick;
          lblFIO[_id].Cursor:=crHandPoint;
          lblFIO[_id].Hint:='Показать список пациентов';
          lblFIO[_id].ShowHint:=True;
        end;

        lblFIO[_id].Alignment:=taCenter;
        lblFIO[_id].Parent:=FormPropushennie.panel;
      end;


      // линия
      begin
        lblTrunk[_id]:=TLabel.Create(FormPropushennie.panel);
        lblTrunk[_id].Name:='lbl_trunk_'+nameControl;
        lblTrunk[_id].Tag:=1;
        lblTrunk[_id].Caption:=SharedQueueStatistics.GetCalls_Trunk(_queue,_missed,i);
        lblTrunk[_id].Left:=590;

        if _id=0 then lblTrunk[_id].Top:=cTOPSTART
        else lblTrunk[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblTrunk[_id].Font.Name:='Tahoma';
        lblTrunk[_id].Font.Size:=10;
        lblTrunk[_id].AutoSize:=False;
        lblTrunk[_id].Width:=110;
        lblTrunk[_id].Height:=16;
        lblTrunk[_id].Alignment:=taCenter;
        lblTrunk[_id].Parent:=FormPropushennie.panel;
      end;

      // время ожидания
      begin
        lblWaiting[_id]:=TLabel.Create(FormPropushennie.panel);
        lblWaiting[_id].Name:='lbl_waiting_'+nameControl;
        lblWaiting[_id].Tag:=1;
        lblWaiting[_id].Caption:=SharedQueueStatistics.GetCalls_Waiting(_queue,_missed,i);
        lblWaiting[_id].Left:=728;

        if _id=0 then lblWaiting[_id].Top:=cTOPSTART
        else lblWaiting[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblWaiting[_id].Font.Name:='Tahoma';
        lblWaiting[_id].Font.Size:=10;
        lblWaiting[_id].AutoSize:=False;
        lblWaiting[_id].Width:=114;
        lblWaiting[_id].Height:=16;
        lblWaiting[_id].Alignment:=taCenter;
        lblWaiting[_id].Parent:=FormPropushennie.panel;
      end;

      // действие
      begin
        btnAction[_id]:=TBitBtn.Create(FormPropushennie.panel);
        if Assigned(bmp) then btnAction[_id].Glyph.Assign(bmp);
        btnAction[_id].Name:='btn_action_'+nameControl;
        btnAction[_id].Tag:=1;
        btnAction[_id].Caption:='&Перезвонить';
        btnAction[_id].Left:=895;

        if _id=0 then btnAction[_id].Top:=cTOPSTART_BUTTON
        else btnAction[_id].Top:=cTOPSTART_BUTTON+(cSTEP * _id);

        btnAction[_id].Font.Name:='Tahoma';
        btnAction[_id].Font.Size:=8;
        btnAction[_id].Width:=111;
        btnAction[_id].Height:=26;
        btnAction[_id].OnClick:=btnActionClick;
        btnAction[_id].Parent:=FormPropushennie.panel;

        // вкл\выкл кнопку
        EnableOrDisableReCallButton(btnAction[_id]);
      end;

      // Период
      begin
        lblPeriod[_id]:=TLabel.Create(FormPropushennie.panel);
        lblPeriod[_id].Name:='lbl_period_'+nameControl;
        lblPeriod[_id].Tag:=1;
        lblPeriod[_id].Caption:=GetPeriodCall(SharedQueueStatistics.GetCalls_DateTime(_queue,_missed,i), lblPeriod[_id]);
        lblPeriod[_id].Hint:=DateTimeToStr(SharedQueueStatistics.GetCalls_DateTime(_queue,_missed,i));
        lblPeriod[_id].ShowHint:=True;
        lblPeriod[_id].Left:=1039;

        if _id=0 then lblPeriod[_id].Top:=cTOPSTART
        else lblPeriod[_id].Top:=cTOPSTART+(cSTEP * _id);

        lblPeriod[_id].Font.Name:='Tahoma';
        lblPeriod[_id].Font.Size:=10;
        lblPeriod[_id].AutoSize:=False;
        lblPeriod[_id].Width:=125;
        lblPeriod[_id].Height:=16;
        lblPeriod[_id].Alignment:=taCenter;
        lblPeriod[_id].Parent:=FormPropushennie.panel;
      end;

      Inc(_id);
   end;

   if Assigned(bmp) then bmp.Free;
end;

procedure TFormPropushennie.LoadData(_queue:enumQueue; _missed:enumMissed);
begin
 // очищавем форму
 ClearForm;

 // создаем форму
  CreateForm(_queue, _missed);
end;

 // очитска формы
procedure TFormPropushennie.ClearForm;
var
  i, j, k, n: Integer;
  Control: TControl;
  GroupBox: TGroupBox;
  ScrollBox: TScrollBox;
  PanelFinded: TPanel;
begin
  // Проходим по всем контролам формы
  for i := 0 to Self.ControlCount - 1 do
  begin
    Control := Self.Controls[i];

    // Проверяем, является ли контрол TGroupBox
    if Control is TGroupBox then
    begin
      GroupBox := TGroupBox(Control); // Приводим Control к TGroupBox

      // Проходим по всем дочерним контролам TGroupBox
      for j := 0 to GroupBox.ControlCount - 1 do
      begin
        // Проверяем, является ли дочерний контрол TScrollBox
        if GroupBox.Controls[j] is TScrollBox then
        begin
          ScrollBox := TScrollBox(GroupBox.Controls[j]); // Приводим Control к TScrollBox

          // Проходим по всем дочерним контролам TScrollBox
          for k := 0 to ScrollBox.ControlCount - 1 do
          begin
            // Проверяем, является ли дочерний контрол TPanel
            if ScrollBox.Controls[k] is TPanel then
            begin
              PanelFinded := TPanel(ScrollBox.Controls[k]); // Приводим Control к TPanel

              // Здесь можно производить действия с PanelFinded
              // Например, если нужно удалить компоненты с определенным Tag
              for n := PanelFinded.ControlCount - 1 downto 0 do
              begin
                if PanelFinded.Controls[n].Tag = 1 then
                begin
                  PanelFinded.Controls[n].Free; // Удаляем компонент
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;


procedure TFormPropushennie.combox_QueueFilterChange(Sender: TObject);
var
 queue:enumQueue;
begin
  queue:=StringToEnumQueue(combox_QueueFilter.Text);
  m_queueStart    :=queue;
  m_missedStart   :=eMissed_no_return;

  Show;
end;


procedure TFormPropushennie.btnActionClick(Sender: TObject);
var
  btn: TBitBtn;
  id:Integer;
  error:string;
begin
  // Приводим Sender к типу TBitBtn
  if Sender is TBitBtn then
  begin
    btn := TBitBtn(Sender);

    // найдем id
     try
       id := StrToInt(Copy(btn.Name, Length('btn_action_') + 1, Length(btn.Name) - Length('btn_action_')));
     except
      on E:EIdException do begin
       MessageBox(Handle,PChar('Возникла ошибка при парсинге id номера'+#13#13+e.Message),PChar('Ошибка'),MB_OK+MB_ICONERROR);
        Exit;
      end;
     end;

    if not CreateRemoteCommandCallback(remoteCommandAction_missedCalls,id,error) then begin
       MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
       Exit;
    end;
     // TODO сюда какое то окошко типа звоним ждите....
  end;
end;


procedure TFormPropushennie.lblPeopleClick(Sender: TObject);
var
  lbl: TLabel;
  id:Integer;
  people:TAutoPodborPeople;
  phonePodbor:string;
  FindedComponent:TLabel;
begin
  // Приводим Sender к типу TLabel
  if Sender is TLabel then
  begin
    lbl:= TLabel(Sender);

    // найдем id
     try
       id := StrToInt(Copy(lbl.Name, Length('lbl_fio_') + 1, Length(lbl.Name) - Length('lbl_fio_')));

       // проверим был ли уже ранее такой компонент сделан
        FindedComponent := TLabel(FormPropushennie.panel.FindComponent('lbl_phone_' + IntToStr(id)));
        if not Assigned(FindedComponent) then
        begin
         MessageBox(Handle,PChar('Возникла ошибка при парсинге id номера'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
         Exit;
        end;

       phonePodbor:=FindedComponent.Caption;
       phonePodbor:=StringReplace(phonePodbor,'+7','8',[rfReplaceAll]);


     except
      on E:EIdException do begin
       MessageBox(Handle,PChar('Возникла ошибка при парсинге id номера'+#13#13+e.Message),PChar('Ошибка'),MB_OK+MB_ICONERROR);
       Exit;
      end;
     end;

     ShowWait(show_open);
     people:=TAutoPodborPeople.Create(phonePodbor, False);

     FormPropushennieShowPeople.SetListPacients(people);
     ShowWait(show_close);

     FormPropushennieShowPeople.ShowModal;
  end;
end;


procedure TFormPropushennie.lblPhoneCopyBufferClick(Sender: TObject);
var
  lbl: TLabel;
  id:Integer;
  phonePodbor:string;
  FindedComponent:TLabel;
begin
  // Приводим Sender к типу TLabel
  if Sender is TLabel then
  begin
    lbl:= TLabel(Sender);

    // найдем id
     try
       id := StrToInt(Copy(lbl.Name, Length('lbl_phone_') + 1, Length(lbl.Name) - Length('lbl_phone_')));

       // проверим был ли уже ранее такой компонент сделан
        FindedComponent := TLabel(FormPropushennie.panel.FindComponent('lbl_phone_' + IntToStr(id)));
        if not Assigned(FindedComponent) then
        begin
         MessageBox(Handle,PChar('Возникла ошибка при парсинге id номера'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
         Exit;
        end;

       phonePodbor:=FindedComponent.Caption;
       try
         Clipboard.AsText:=phonePodbor;
         MessageBox(Handle,PChar('Скопировано'),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
       except
         on E:Exception do
          begin
           MessageBox(Handle,PChar('Ошибка доступа к буферу обмена'+#13#13+e.Message),PChar('Ошибка'),MB_OK+MB_ICONERROR);
           Exit;
          end;
       end;

     except
      on E:EIdException do begin
       MessageBox(Handle,PChar('Возникла ошибка при парсинге id номера'+#13#13+e.Message),PChar('Ошибка'),MB_OK+MB_ICONERROR);
       Exit;
      end;
     end;
  end;
end;


procedure TFormPropushennie.Clear;
begin
  m_queueStart:=queue_null;
  ClearForm;
  m_showInfoRecallMissed:=False;
  m_callbakRun:=False;
  m_missedCount:=0;
  isOneUpdateData:=False;

  m_manualShow:=False;

  // остановливаем планировщик
  m_dispatcher.StopThread;
end;


// создвание листа с выбором фильтра по очередям
procedure TFormPropushennie.CreateComboxChoiseQueue;
var
 i:Integer;
begin
  combox_QueueFilter.Clear;

  // в зависимости от того к акаим очередям есть доступ у пользака их и показывать
  for i:=0 to SharedCurrentUserLogon.QueueList.Count-1 do begin
   combox_QueueFilter.Items.Add(EnumQueueToString(SharedCurrentUserLogon.QueueList[i]));
  end;

  combox_QueueFilter.ItemIndex:=EnumQueueCurrentToInteger(m_queueStart);
end;


// изменение размер окна в заивсимости от кол-ва пропущенных телефонов
procedure TFormPropushennie.ResizeForm(_countMissed:Integer);
var
 sizeFormHeight:Integer;
begin
  if _countMissed = 0 then begin
   ST_no_missed.Visible:=True;
   Caption:='Не перезвонившие';
  end
  else begin
   Caption:='Не перезвонившие ('+IntToStr(_countMissed)+')';
   ST_no_missed.Visible:=False;
  end;

  // размер формы
  // все по default
  if _countMissed <= 2 then begin
    Height        :=cSIZE_DEFAULT;
    group.Height  :=cSIZE_STEP_SCROLL;
    scroll.Height :=cSIZE_STEP_GROUP;
    panel.Height  :=cSIZE_STEP_GROUP - 10;

    CenterForm;
    Exit;
  end;

  // если больше максимального значения
  sizeFormHeight:= cSIZE_STEP_PHONE_1_UNIT * _countMissed;
  if sizeFormHeight > cSIZE_DEFAULT_MAX - cSEZE_PHONE_STARTED_UNIT then begin
    Height        :=cSIZE_DEFAULT_MAX;
    group.Height  :=cSIZE_DEFAULT_MAX - cSIZE_STEP_GROUP;
    scroll.Height :=cSIZE_DEFAULT_MAX - cSIZE_STEP_SCROLL;
    panel.Height  :=_countMissed * cSIZE_STEP_PHONE_1_UNIT - ((cSIZE_STEP_PHONE_1_UNIT * _countMissed) - (_countMissed * cSTEP));

    CenterForm;
    Exit;
  end;

  // в пределах допустимого размера
  begin
    Height        := sizeFormHeight + cSIZE_DEFAULT - cSIZE_STEP_GROUP;// - cSIZE_STEP_GROUP;
    group.Height  := Height - cSIZE_STEP_GROUP;
    scroll.Height := Height - cSIZE_STEP_SCROLL;
    panel.Height  := _countMissed * cSIZE_STEP_PHONE_1_UNIT - ((cSIZE_STEP_PHONE_1_UNIT * _countMissed) - (_countMissed * cSTEP));

    CenterForm;
    Exit;
  end;

// cSIZE_DEFAULT:Word             = 170; // размер по умолчанию для вывода окна
// cSIZE_DEFAULT_MAX:Word         = 870; // максимальный размер окга после которого включаем сколлл
// cSIZE_STEP_GROUP:Word          = 70;  // разница на group
// cSIZE_STEP_SCROLL:Word         = 100; // разница на scoll
// cSIZE_STEP_PHONE_1_UNIT:Word   = 30;  // щаг одного номера
//
// cSEZE_PHONE_STARTED_UNIT:Word = cSIZE_STEP_PHONE_1_UNIT * 2; // стартовое кол-во телефонов по умолчанию

end;


// сколько прошло времени с момента звонка (в классе это не нужно)
function TFormPropushennie.GetPeriodCall(_datetime:TDateTime;
                                         var p_lbl:TLabel):string;
var
  now_time: TDateTime;
  diffMinutes: Integer;
  diffHours: Integer;
begin
  now_time := Now;
  // Вычисляем разницу в минутах
  diffMinutes := MinutesBetween(now_time, _datetime);
  diffHours :=   Round(diffMinutes div 60); // Конвертируем минуты в часы

  // Определяем строку в зависимости от разницы
  case diffMinutes of
    1: Result     := '1 мин назад';
    2: Result     := '2 мин назад';
    3: Result     := '3 мин назад';
    5: Result     := '5 мин назад';
    10: Result    := '10 мин назад';
    15: Result    := '15 мин назад';
    30: Result    := '30 мин назад';
  else
    // Обрабатываем часы
    case diffHours of
      1: Result := '1 час назад';
      2: Result := '2 часа назад';
      3: Result := '3 часа назад';
      4: Result := '4 часа назад';
      5..7: Result := Format('%d часов назад', [diffHours]);
      8..11: Result := Format('%d часов назад', [diffHours]);
      12..20: Result := Format('%d часов назад', [diffHours]);
    else
      if diffMinutes = 0 then begin
        Result := Format('только что', [diffMinutes]);
      end
      else Result := Format('%d мин назад', [diffMinutes]); // Для случаев, когда разница больше 12 часов
    end;
  end;

  // Установка цвета метки в зависимости от разницы во времени
  if (diffMinutes >= 0) and (diffMinutes <= 30) then
    p_lbl.Font.Color := $00095314 // Темно-зеленый
  else if (diffMinutes >= 31) and (diffMinutes < 60) then
    p_lbl.Font.Color := clGreen // Зеленый
  else if (diffHours = 1) then
    p_lbl.Font.Color := clRed // Красный
  else
   p_lbl.Font.Color := clMaroon; // Бордо-красный для всех остальных случаев

end;


// центрирование окна
procedure TFormPropushennie.CenterForm;
var
  ScreenWidth, ScreenHeight: Integer;
  FormWidth, FormHeight: Integer;
begin
  // Получаем размеры экрана
  ScreenWidth := Screen.Width;
  ScreenHeight := Screen.Height;

  // Получаем размеры формы
  FormWidth := Width;
  FormHeight := Height;

  // Вычисляем новые координаты
  Left := (ScreenWidth - FormWidth) div 2;
  Top := (ScreenHeight - FormHeight) div 2;
end;

// вкл\выкл кнопку перезвонить
procedure TFormPropushennie.EnableOrDisableReCallButton(var p_button:TBitBtn);
var
 i,countActiveSipOperators:Integer;
begin
  p_button.Enabled:=False;

  // пользователь не оператор
  if not SharedCurrentUserLogon.IsOperator then Exit;

 // пользователь опертаор
  // запустил из под статуса callbek?
  if m_callbakRun then begin
    p_button.Enabled:=True;
    Exit;
  end;


  begin
    // проверим статус
    countActiveSipOperators:=SharedActiveSipOperators.getCountSipOperators;

    for i:=0 to countActiveSipOperators - 1 do begin
       if SharedActiveSipOperators.GetListOperators_OperatorName(i) = SharedCurrentUserLogon.Familiya+' '+SharedCurrentUserLogon.Name then begin
         if SharedActiveSipOperators.GetListOperators_Status(i) <> eCallback then begin
           m_showInfoRecallMissed:=True;
           Exit;
         end
         else begin
          p_button.Enabled:=True;
          Exit;
         end;
       end
       else begin
         m_showInfoRecallMissed:=True;
       end;
    end;
  end;
end;


// показ информации что кнопки перезвона доступны если в статусе callback находится оператор
procedure TFormPropushennie.ShowInfoRecallMissed;
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  DialogResult: Integer;
  XML:TXML;
begin
   // не показываем данное окно, т.к. пользователь ранее поставил галку
   XML:=TXML.Create;
   if  XML.GetMissedCallsShow = 'false' then begin
    XML.Free;
    Exit;
   end;

  AMsgDialog := CreateMessageDialog('Функционал "перезвонить" включается если находится в статусе "'+getStatus(eCallback)+'"', mtInformation, [mbOK]);
  ACheckBox := TCheckBox.Create(AMsgDialog);

  with AMsgDialog do
  try
    Caption:= 'Информация';
    Height:= 150;
   // (FindComponent('OK') as TButton).Caption := 'Хорошо';

    with ACheckBox do begin
      Parent:= AMsgDialog;
      Caption:= 'Не показывать больше это сообщение';
      Top:= 100;
      Left:= 8;
      Width:= AMsgDialog.Width;
    end;

    DialogResult:= ShowModal; // Сохраняем результат в переменной

    if ACheckBox.Checked then begin
      // не показываем в дальнейше
      XML:=TXML.Create;
      XML.SetMissedCallsShow('false');
      XML.Free;
    end;

  finally
    FreeAndNil(ACheckBox);
    Free;
  end;
end;


procedure TFormPropushennie.scrollMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  scroll.VertScrollBar.Position:=scroll.VertScrollBar.Position + Round(cSIZE_STEP_PHONE_1_UNIT / 2);
end;

procedure TFormPropushennie.scrollMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 scroll.VertScrollBar.Position:=scroll.VertScrollBar.Position - Round(cSIZE_STEP_PHONE_1_UNIT  / 2);
end;

procedure TFormPropushennie.Show;
begin
 if m_manualShow then begin
   ShowWait(show_open);
 end;

  // инициируем первое значение кол-ва
  if (m_missedCount = 0) and (not isOneUpdateData) then begin
     m_missedCount:=SharedQueueStatistics.GetMissedCount(m_queueStart,m_missedStart);

     Screen.Cursor:=crHourGlass;
     UpdateData;
     Screen.Cursor:=crDefault;

     if m_manualShow then begin
       ShowWait(show_close);
       m_manualShow:=False;
     end;

     Exit;
  end;

  UpdateData;

  if m_manualShow then begin
    ShowWait(show_close);
    m_manualShow:=False;
  end;

end;

procedure TFormPropushennie.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Clear;
end;

procedure TFormPropushennie.FormCreate(Sender: TObject);
begin
 // SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW);
end;

procedure TFormPropushennie.FormShow(Sender: TObject);
begin
 // создаем диспетчера
 if not Assigned(m_dispatcher) then begin
  m_dispatcher:=TThreadDispatcher.Create('FormPropushennieShow',10,False,Show);
 end;

 Show;

 // показываем информацию что нужно находится в статусе callback чтобы включился перезвон на копках
 if SharedCurrentUserLogon.IsOperator then begin
    if m_showInfoRecallMissed then ShowInfoRecallMissed;
 end;

 panel.SetFocus;
 m_dispatcher.StartThread;
end;


// обновление времени периода звонка
procedure TFormPropushennie.UpdateOnlyTimesPeriod;
var
 i:Integer;
 counts:Integer;
 nameControl:string;
 FindedComponent:TLabel;
begin
 counts:=SharedQueueStatistics.GetMissedCount(m_queueStart, m_missedStart);

   for i:=counts-1 downto 0 do begin
    nameControl:=IntToStr(SharedQueueStatistics.GetCalls_ID(m_queueStart,m_missedStart,i));

    // найдем компонент
    FindedComponent := TLabel(FormPropushennie.panel.FindComponent('lbl_period_' + nameControl));
    if not Assigned(FindedComponent) then Continue;

    FindedComponent.Caption:=GetPeriodCall(SharedQueueStatistics.GetCalls_DateTime(m_queueStart,m_missedStart,i), FindedComponent);
   end;
end;


// обновление данных
procedure TFormPropushennie.UpdateData;
var
 countMissed:Integer;
begin
  // создаем фильтр с выбором по очередям
  if combox_QueueFilter.Items.Count = 0 then CreateComboxChoiseQueue;

  // текущее кол-во пропущенных
  countMissed:=SharedQueueStatistics.GetMissedCount(m_queueStart,m_missedStart);
  if isOneUpdateData then begin
   if countMissed = m_missedCount then
   begin
     // обновляем только период времени звонка
     UpdateOnlyTimesPeriod;
     Exit;
   end;
  end;

  // загружаем данные
  LoadData(m_queueStart, m_missedStart);

  // изменяем размер окна
  ResizeForm(countMissed);

  m_missedCount:=countMissed;

  isOneUpdateData:=True;
end;


end.

