 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///   Класс для описания информации по звонку в подборе СМС приложения        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TSMSCallTalkInfoUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit;


 // class TSMSCallTalkInfo
  type
      TSMSCallTalkInfo = class

      private


      public

      constructor Create;                   overload;
     // procedure Clear;


      end;
 // class TSMSCallTalkInfo END

implementation

uses
  GlobalVariablesLinkDLL;


constructor TSMSCallTalkInfo.Create();
begin
// Clear;
//
// m_phone:=_phone;
// m_time:=_timeCall;
// m_table:=_table;
end;

//procedure TCallInfo.Clear;
//begin
//  m_table:=eTableHistoryIVR; // по умолчанию из history_*
//  m_phone:='';
//  m_time:='';
//  m_trunk:='';
//  m_phoneOperator:='';
//  m_region:='';
//end;






end.