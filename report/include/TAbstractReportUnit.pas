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
      m_excel :OleVariant;
      m_sheet :OleVariant;


      constructor Create;
      destructor Destroy;                 override;


      private


      end;
   // class TAbstractReport END

implementation

uses
  GlobalVariables, FormHomeUnit;



constructor TAbstractReport.Create;
begin
  inherited Create;

   try
      m_excel:=CreateOleObject('Excel.Application');
    except
      on E: Exception do
      begin
       MessageBox(0,PChar('Ошибка при создании объекта Excel: ' + E.Message),PChar('Ошибка конструктора'),MB_OK+MB_ICONERROR);
       Exit; // Выход из конструктора при ошибке
      end;
   end;

  m_excel.displayAlerts:=False;
  m_excel.workbooks.add;
  m_excel.Visible:=True;  // debug потом закоментировать

  // название имени
  m_excel.workbooks[1].worksheets[1].name:='Отчет';

  // активная страница
  m_sheet:=m_excel.workbooks[1].worksheets[1];
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


end.
