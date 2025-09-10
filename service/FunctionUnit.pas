unit FunctionUnit;


interface

uses
  Data.Win.ADODB, Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,System.DateUtils, ActiveX,
  System.Win.ComObj, IdException, TCustomTypeUnit;


  procedure createCopyright;                                            // создание Copyright
  function LoadData(_file:string;
                    var _status:TStaticText;
                    var _errorDescription:string):Boolean;              // прогрузка в память excel файла
  function isExistExcel(var _errorDescriptions:string):Boolean;         // проверка установлен ли excel
  function TrimQuotes(const S: string): string;                         // убираем " в начале и в конце
  procedure showWait(Status:enumShow_wait);                             // отображение\сркытие окна запроса на сервер
  procedure SetRandomFontColor(var p_label: TLabel);                    // изменение цвета надписи

implementation

uses
 FormHomeUnit, GlobalVariables, GlobalVariablesLinkDLL, TServiceUnit, FormWaitUnit;

// создание Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[0].Text:=GetCopyright;
  end;
end;


// проверка установлен ли excel
function isExistExcel(var _errorDescriptions:string):Boolean;
var
  Excel:OleVariant;
begin
  Result:=False;
  _errorDescriptions:='';

  try
    Excel:=CreateOleObject('Excel.Application');
    Excel:=Unassigned; // Освобождаем объект

    Result:=True; // Если объект создан, значит Excel установлен
  except
    on E: Exception do begin
      _errorDescriptions:=e.ClassName+#13+E.Message;
    end;
  end;
end;


// убираем " в начале и в конце
function TrimQuotes(const S: string): string;
begin
  Result := S.Trim(['"']);
end;


// прогрузка в память excel файла
function LoadData(_file:string; var _status:TStaticText; var _errorDescription:string):Boolean;
var
 SL: TStringList;
 i: Integer;
 Columns: TArray<string>;
 checkRows:Boolean;
 dest,code,serviceName:string;
 serviceStruct:TStructService;

begin
  Screen.Cursor:=crHourGlass;

  Result:=False;
  _errorDescription:='';
  checkRows:=False;

  _status.Caption:='Статус : Загрузка в память';

  if DEBUG then begin
    while (GetTask('EXCEL.EXE')) do KillTask('EXCEL.EXE');
  end;

  SL:= TStringList.Create;
  try
    SL.LoadFromFile(_file);

    if SL.Count = 0 then begin
     Screen.Cursor:=crDefault;
     _errorDescription:='Файл пуст';
     _status.Caption:='Статус : Ошибка при загрузке в память!';
     Application.ProcessMessages;
     Exit;
    end;


    // проверим по поляем
    Columns:=SL[0].Split([';']);
    if (Columns[0] = '"FILID"')             and
       (Columns[1] = '"SPECNAME"')          and  // направление
       (Columns[2] = '"SPECCODE"')          and
       (Columns[3] = '"GRPNAME"')           and
       (Columns[4] = '"KODOPER"')           and   // код услуги
       (Columns[5] = '"SCHNAME"')           and   // услуга
       (Columns[6] = '"MWSCHNAME"')         and
       (Columns[7] = '"SPRICE"')            and
       (Columns[8] = '"CITOPRICE"')         and
       (Columns[9] = '"URI"')               and
       (Columns[10] = '"ZAPIS"')            and
       (Columns[11] = '"HIRURGST"')         and
       (Columns[12] = '"STACIPOLIC"')       and
       (Columns[13] = '"EXAMPREPARETEXT"')  and
       (Columns[14] = '"DRAWKODOPER"')
    then checkRows:=True
    else checkRows:=False;

    if not checkRows then begin
      Screen.Cursor:=crDefault;
     _errorDescription:='Некорректный формат файла';
     _status.Caption:='Статус : Некорректный формат файла';
     Application.ProcessMessages;
     Exit;
    end;


    for i:=1 to SL.Count-1 do begin
      Columns:=SL[i].Split([';']);

      serviceStruct:=TStructService.Create(TrimQuotes(Columns[1]),
                                           TrimQuotes(Columns[4]),
                                           TrimQuotes(Columns[5]));

      SharedServiceListLoading.Add(serviceStruct);
    end;



  finally
    SL.Free;
  end;

  if SharedServiceListLoading.Count = 0 then begin
    _errorDescription:='Статус : Нет услуг для загрузки';
    Screen.Cursor:=crDefault;
    Exit;
  end;

   _status.Caption:='Статус : Готово к загрузке ('+IntToStr(SharedServiceListLoading.Count)+')';


  Result:=True;
  Screen.Cursor:=crDefault;
end;

// отображение\сркытие окна запроса на сервер
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// изменение цвета надписи
procedure SetRandomFontColor(var p_label: TLabel);
var
  RandomColor: TColor;
begin
  // Генерируем случайные значения для RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // Устанавливаем случайный цвет шрифта для метки
  p_label.Font.Color := RandomColor;
end;

end.
