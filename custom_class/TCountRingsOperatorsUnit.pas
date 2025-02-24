 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            Класс для описания кол-ва звонков оператором                   ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TCountRingsOperatorsUnit;

interface

uses
System.Classes,
System.SysUtils;


   // class TStructCount
  type
      TStructCount = class
      public
      date_time   : TDateTime;
      count       : Integer;

      constructor Create;                   overload;

      end;
 // class TStructCount END




 // class TCountRingsOperators
  type
      TCountRingsOperators = class
      public

      m_sip         : Integer;
      m_listCount   : array of TStructCount;

      constructor Create;                   overload;

      end;
 // class TCountRingsOperators END

implementation

constructor TStructCount.Create;
 begin
   inherited;
 end;

constructor TCountRingsOperators.Create;
 begin
   inherited;
   SetLength(m_listCount,0);
 end;



end.