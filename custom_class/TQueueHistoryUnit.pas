 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            Класс для описания истории звонка в очереди                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TQueueHistoryUnit;

interface

uses
System.Classes,
System.SysUtils,
TCustomTypeUnit;


 // class TQueueHistory
  type
      TQueueHistory = class
      public
      id                :Integer;
      number_queue      :enumQueueCurrent;
      phone             :string;
     // waiting_time      :string;
      date_time         :TDateTime;
      sip               :Integer;
      talk_time         :string;
      userFIO           :string;

      constructor Create;                   overload;

      end;
 // class TQueueHistory END

implementation


constructor TQueueHistory.Create;
 begin
   inherited;
 end;

end.