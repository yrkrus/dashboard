 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///   Класс для описания информации по звонку (транк, оператор, регион)       ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TCallInfoUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit;


 // class TCallInfo
  type
      TCallInfo = class

      private
      m_table   :enumReportTableIVR; // из какой таблицы данные достаем
      m_phone   :string;  // номер телефона
      m_time    :string;  // время звонка
      m_trunk   :string;  // транк
      m_phoneOperator:string; // оператор
      m_region:string;        // регион


      procedure Find; // поиск данных по звонку

      public

      constructor Create(_phone:string;
                         _timeCall:string;
                         _table:enumReportTableIVR);                   overload;
      procedure Clear;


      end;
 // class TCallInfo END

implementation

uses
  GlobalVariablesLinkDLL;


constructor TCallInfo.Create(_phone:string;
                             _timeCall:string;
                             _table:enumReportTableIVR);
begin
 Clear;

 m_phone:=_phone;
 m_time:=_timeCall;
 m_table:=_table;
end;

procedure TCallInfo.Clear;
begin
  m_table:=eTableHistoryIVR; // по умолчанию из history_*
  m_phone:='';
  m_time:='';
  m_trunk:='';
  m_phoneOperator:='';
  m_region:='';
end;

// поиск данных по звонку
procedure TCallInfo.Find;
begin

end;



end.