/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TReportCountOperators                 ///
///                  "Отчет по количеству звонков операторами"                ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////
unit TReportCountOperatorsUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  ActiveX, ComObj,
  TAbstractReportUnit;



/////////////////////////////////////////////////////////////////////////////////////////
   // class TReportCountOperators
 type
       TReportCountOperators = class(TAbstractReport)

      public
      constructor Create(InNameReports:string;          // название отчета
                         InDateStart,InDateStop:TDate   // даты отчета
                        );            overload;

      destructor Destroy;            override;


      private
      m_nameReport      :string;     // название отчета
      m_dateStart       :TDate;      // дата начала
      m_dateStop        :TDate;      // дата окончания


      end;
   // class TReportCountOperators END

implementation

uses
  GlobalVariables;



constructor TReportCountOperators.Create(InNameReports:string;
                                         InDateStart,InDateStop:TDate);
begin
  // инициализацуия родительского класса
  inherited Create;

  m_nameReport:=InNameReports;
  m_dateStart:=InDateStart;
  m_dateStop:=InDateStop;
end;


destructor TReportCountOperators.Destroy;
begin
  inherited Destroy;
end;


end.
