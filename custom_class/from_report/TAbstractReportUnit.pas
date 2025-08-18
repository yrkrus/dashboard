/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TAbstractReport                       ///
///                 класс от которого будут наследники отчетов                ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TAbstractReportUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  Winapi.ActiveX,
  System.Win.ComObj,
  Variants,
  Winapi.Windows;



/////////////////////////////////////////////////////////////////////////////////////////
   // class TAbstractReport
 type
      TAbstractReport = class

      public
      constructor Create;                                 overload;
      constructor Create(InDateStart,InDateStop:TDate);   overload;

      destructor Destroy;                 override;

      procedure ShowProgress;          // показ статус бара
      procedure CloseProgress;         // закрываем статус бар
      procedure SetProgressStatusText(InText:string); // установка текста статуса
      procedure SetProgressBar(InProgress:Integer); overload;   // установка прогресс бара
      procedure SetProgressBar(InProgress:double);  overload;   // установка прогресс бара

      procedure ShowExcel; // отображение окна excel

      function GetDateStartAsString:string;
      function GetDateStopAsString:string;
      function GetDateStartAsDate:TDate;
      function GetDateStopAsDate:TDate;


      protected
      m_excel           :OleVariant;
      m_sheet           :OleVariant;
      isESC             :Boolean;    // отмена формирования отчета
      isExistDataExcel  :Boolean;    // есть ли данные для отображения

      function GetAbout:Boolean;    // нажали отмену генерации


      private
      m_dateStart       :TDate;      // дата начала
      m_dateStop        :TDate;      // дата окончания




      procedure InitExcel; // инициализация excel

      end;
   // class TAbstractReport END

implementation

uses
  GlobalVariables, FunctionUnit;



constructor TAbstractReport.Create;
begin
  inherited Create;
  InitExcel;
end;


constructor TAbstractReport.Create(InDateStart,InDateStop:TDate);
begin
  inherited Create;

  m_dateStart:=InDateStart;
  m_dateStop:=InDateStop;

  InitExcel;
end;


destructor TAbstractReport.Destroy;
begin
   // Освобождение ресурсов, если нужно
  if not VarIsNull(m_excel) then
  begin
    m_excel.Quit; // Закрываем Excel
    m_excel:=Unassigned; // Освобождаем объект
    m_sheet:=Unassigned;
  end;

  inherited Destroy;
end;


procedure TAbstractReport.InitExcel;
begin
  try
      m_excel:=CreateOleObject('Excel.Application');
  except
      on E: Exception do
      begin
       MessageBox(0,PChar('Ошибка при создании объекта Excel'+#13#13+ E.Message),PChar('Ошибка конструктора TAbstractReport'),MB_OK+MB_ICONERROR);
       Exit; // Выход из конструктора при ошибке
      end;
   end;

  m_excel.displayAlerts:=False;
  m_excel.workbooks.add;
  // m_excel.Visible:=True;  // debug потом закоментировать

  // название имени
  m_excel.workbooks[1].worksheets[1].name:='Отчет';

  // активная страница
  m_sheet:=m_excel.workbooks[1].worksheets[1];

  // пока данных нет для отображения
  isExistDataExcel:=False;

  // отмена формирования отчета
  isESC:=False;
end;


procedure TAbstractReport.ShowProgress;
begin
  ShowProgressBar;
end;

procedure TAbstractReport.CloseProgress;
begin
  CloseProgressBar;
end;

// установка текста статуса
procedure TAbstractReport.SetProgressStatusText(InText:string);
begin
  SetStatusProgressBarText(InText);
end;

// установка прогресс бара (integer)
procedure TAbstractReport.SetProgressBar(InProgress:Integer);
begin
  SetStatusProgressBar(InProgress);
end;

// установка прогресс бара (double)
procedure TAbstractReport.SetProgressBar(InProgress:double);
begin
 SetStatusProgressBar(InProgress);
end;

// отображение окна excel
procedure TAbstractReport.ShowExcel;
begin
  if isESC then begin
    MessageBox(0,PChar('Создание отчета отменено'),PChar('Дейстиве отменено'),MB_OK+MB_ICONSTOP);
    Exit;
  end;

 if Self.isExistDataExcel then m_excel.Visible:=True
 else MessageBox(0,PChar('Данные за указанный период отсутствуют'),PChar('Данных нет'),MB_OK+MB_ICONINFORMATION);
end;


function TAbstractReport.GetDateStartAsString:string;
begin
  Result:=DateToStr(Self.m_dateStart);
end;

function TAbstractReport.GetDateStopAsString:string;
begin
  Result:=DateToStr(Self.m_dateStop);
end;

function TAbstractReport.GetDateStartAsDate:TDate;
begin
  Result:=Self.m_dateStart;
end;

function TAbstractReport.GetDateStopAsDate:TDate;
begin
  Result:=Self.m_dateStop;
end;

// нажали отмену генерации
function TAbstractReport.GetAbout:Boolean;
begin
  isESC:=GetAboutGenerateReport;
  Result:=isESC;
end;

end.
