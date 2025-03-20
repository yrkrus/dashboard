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
  Vcl.Forms,
  System.SyncObjs,
  FormDEBUGUnit,
  TDebugStructUnit,
  TCustomTypeUnit;

 ////////////////////////////////////////////////////////////////

// class TDebugCountResponse
  type
      TDebugCountResponse = class
      private
      m_listNameThread            :TStringList;
      m_count                     :Integer;
      m_list                      :array of TDebugStruct;

      m_Form                      :TFormDEBUG;
      isCreatedDataWithForm       :Boolean;   // создали ли уже данные на форме

      public
      constructor Create;                   overload;
      procedure SetAddForm(var p_Form:TFormDEBUG);   // используется только для добавление линковки формы
      procedure CreateForm;                          // создание и заполнение формы дебага
      procedure ShowDebug;                           // показ текущего состояния потоков

      procedure Add(_structDebug:TDebugStruct);       // добавить поток в мониторинг
      procedure SetCurrentResponse(_name:string; _value:Integer);   // текущее значение


      property CreatedForm: Boolean read isCreatedDataWithForm;


      end;
 // class TDebugCountResponse END

implementation


constructor TDebugCountResponse.Create;
begin
   inherited;
   m_count:=0;
   m_listNameThread:=TStringList.Create;
   SetLength(m_list, 0);
end;

 // используется только для добавление линковки формы
procedure TDebugCountResponse.SetAddForm(var p_Form:TFormDEBUG);
begin
   m_Form:=p_Form;
   isCreatedDataWithForm:=False;  // флаг того что показали ли первый раз уже форму или нет, нужно ли ее создаваить
end;

// создание и заполнение формы дебага
procedure TDebugCountResponse.CreateForm;
begin

end;

// показ текущего состояния потоков
procedure TDebugCountResponse.ShowDebug;
begin
  // TODO сделать тут запуск отдельного потока который будет отображать все инфо
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


// текущее значение
procedure TDebugCountResponse.SetCurrentResponse(_name:string; _value:Integer);
var
 i:Integer;
begin
  for i:=0 to m_count-1 do begin
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
end;

end.