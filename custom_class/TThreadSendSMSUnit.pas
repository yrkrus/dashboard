 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///        Класс для описания создания потоков для отправки SMS               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TThreadSendSMSUnit;

interface

uses
  Winapi.Messages, System.Variants,
  Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,System.Win.ComObj,System.Classes,
  System.SysUtils,System.SyncObjs, // для TEvent
  Vcl.Graphics, ActiveX, Vcl.ComCtrls,
  Vcl.Controls, Windows, TCustomTypeUnit, TSendSMSUint,
  TPacientsListUnit;



  type
    TStructMessage = class
    public
    m_message : string;
    m_color   : TColor;
    constructor Create;  overload;

    private
    function Clone:TStructMessage;
  end;


  type
    TMessageLog = class
    public
    constructor Create;     overload;
    destructor Destroy;     override;

    function Count:Integer;                     // кол-во записей
    procedure Add(NewMessage:TStructMessage);   // добавление нового в список

    function GetMessage(id:Integer):string;
    function GetColor(id:Integer):TColor;

    private
    m_count : Integer;
    m_list  : array of TStructMessage;
  end;





 // class TThreadSendSMS
 type
  TThreadSendSMS = class(TThread)
  private
   m_RangeStart:Integer;
   m_RangeStop:Integer;
   m_threadID:Integer;
   m_pacients:TPacients;

   m_messageSend:TMessageLog;
   m_logForm:TRichEdit;
   m_showlog:Boolean;   // показывать ли лог

    procedure SendSyncShowLog; // Синхронизация
    procedure CreateLogAddColoredLine(InMessage:string; InColor:TColor);

  protected
    procedure Execute; override;
  public
    FThreadFinished: TEvent; // Событие для обозначения завершения потока

    constructor Create(ThreadID,RangeStart,RangeStop:Integer;
                        var p_Pacients:TPacients;
                        var p_logForm:TRichEdit;
                        isShowLog:Boolean);
    destructor Destroy; override; // Освобождение ресурсов



  end;
 // class TThreadSendSMS END

implementation

uses
  GlobalVariables;


constructor TMessageLog.Create;
 begin
   inherited;
   m_count:=0;
   SetLength(m_list, 0);
 end;


 destructor TMessageLog.Destroy;
var
 i:Integer;
begin
  for i:=Low(m_list) to High(m_list) do FreeAndNil(m_list[i]);
  inherited Destroy;
end;


constructor TStructMessage.Create;
begin
  inherited;
end;


function TMessageLog.Count;
begin
  Result:=Self.m_count;
end;


function TStructMessage.Clone:TStructMessage;
begin
  Result:=TStructMessage.Create;

  Result.m_message := Self.m_message;
  Result.m_color := Self.m_color;
end;


// добавление нового в список
procedure TMessageLog.Add(NewMessage: TStructMessage);
var
  CopyStruct: TStructMessage;
begin
  // Создаем копию объекта
  CopyStruct:= NewMessage.Clone;
  try
    SetLength(m_list, Length(m_list) + 1);
    m_list[High(m_list)] := CopyStruct; // Добавляем копию в массив
    Inc(m_count);
  except
    CopyStruct.Free; // Освобождаем память в случае ошибки
  end;
end;


function TMessageLog.GetMessage(id:Integer):string;
begin
  Result:=Self.m_list[id].m_message;
end;


function TMessageLog.GetColor(id:Integer):TColor;
begin
   Result:=Self.m_list[id].m_color;
end;

//////////////////////////////////////////////////////////////////////////////////////////////

constructor TThreadSendSMS.Create(ThreadID,RangeStart,RangeStop:Integer;
                                  var p_Pacients:TPacients;
                                  var p_logForm:TRichEdit;
                                  isShowLog:Boolean);
begin
  inherited Create(True);   // Создаем поток в приостановленном состоянии
  m_RangeStart:=RangeStart;
  m_RangeStop:=RangeStop;
  m_threadID:=ThreadID;
  m_pacients:=p_Pacients;
  m_logForm:=p_logForm;
  m_showlog:=isShowLog;

  m_messageSend:=TMessageLog.Create;

  FThreadFinished := TEvent.Create(nil, True, False, ''); // Создаем событие
end;

destructor TThreadSendSMS.Destroy;
begin
  //if Assigned(m_logMessageSend) then m_logMessageSend.Free;

  FThreadFinished.Free; // Освобождаем событие
  inherited;
end;



procedure TThreadSendSMS.Execute;
const
 cADDSIGN:Boolean = True;  // по умолчанию добавляем подпись к SMS
var
 potokName:string;
 SMS:TSendSMS;
 i:Integer;
 error:string;
 SendingMessage:string;

 log_message:TStructMessage;
begin
  inherited;
  CoInitialize(Nil);

  log_message:=TStructMessage.Create;

  // Устанавливаем событие, которое будет сигнализировать о завершении TThreadSendSMS
  FThreadFinished.ResetEvent; // Сбрасываем событие перед выполнением

  potokName:='Поток['+IntToStr(m_threadID)+']: ';
  error:='';

  SMS:=TSendSMS.Create(DEBUG);
  if not SMS.isExistAuth then begin
   log_message.m_message:=potokName+'Отсутствуют авторизационные данные для отправки SMS';
   log_message.m_color:=clRed;

    m_messageSend.Add(log_message);

    Queue(SendSyncShowLog);

    SharedMainLog.Save(log_message.m_message, True);

    FThreadFinished.SetEvent;
    Exit;
  end;



   for i:=m_RangeStart to m_RangeStop do begin
     SendingMessage:=m_pacients.CreateMessage(i, REMEMBER_MESSAGE);

     if not SMS.SendSMS(SendingMessage,m_pacients.GetPhone(i),error, cADDSIGN) then
     begin
      log_message.m_message:=potokName+'Не удалось отправить СМС на номер ('+m_pacients.GetPhone(i)+') '+error;
      log_message.m_color:=clRed;

      SharedMainLog.Save(log_message.m_message, True);
     end
     else begin
      log_message.m_message:=potokName+'Отправлено СМС на номер ('+m_pacients.GetPhone(i)+') : '+SendingMessage;
      log_message.m_color:=clGreen;

      SharedMainLog.Save(log_message.m_message);
     end;

     m_messageSend.Add(log_message);
   end;

   // показываем лог если это нужно
   if m_showlog then Queue(SendSyncShowLog);

   FThreadFinished.SetEvent;
  // Ожидаем завершения SendThreadSMS
 // FThreadFinished.WaitFor(INFINITE); // Блокируем до тех пор, пока не будет установлено событие

end;


procedure TThreadSendSMS.SendSyncShowLog;
var
 i:Integer;
begin
  for i:=0 to m_messageSend.Count-1 do begin
   CreateLogAddColoredLine(m_messageSend.GetMessage(i), m_messageSend.GetColor(i));
  end;
end;



procedure TThreadSendSMS.CreateLogAddColoredLine(InMessage:string; InColor:TColor);
begin
  with m_logForm do
  begin
    SelStart:= Length(Text);
    SelAttributes.Color:=InColor;
    SelAttributes.Size:=10;
    SelAttributes.Name:='Tahoma';
    //Lines.Add(DateTimeToStr(Now)+' '+AText);
    Lines.Add(InMessage);

    Perform(EM_LINESCROLL,0,Lines.Count-1);
    SetFocus;
  end;
end;




end.