/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   Класс для описания CallbackCall                         ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TCallbackCallUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
      Graphics, System.SyncObjs, IdException,  GlobalVariablesLinkDLL, TCustomTypeUnit,
      System.Generics.Collections;


/////////////////////////////////////////////////////////////////////////////////////////

  type ecCallbackCallResult = (call_result_unknown,         // что то пошло не так
                               call_result_whait_responce,  // ожидание ответа
                               call_result_fail,            // ошибка при ответе, номер не отвечает или не сброс произошел
                               call_result_ok);             // ок, вызов произошел разговор


 // class TCallbackCall
 type
      TCallbackCall = class

      private
      m_userID      :Integer;       // userId по БД
      m_phone       :string;        // номер на который звоним
      m_autoRun     :Boolean;       // сразу запуск или нет

     // function  RequestToBase(_response:lisaStatResponce):Integer;  // получение данных из БД
      function SendCommand(var _errorDescription:string):ecCallbackCallResult;
      public

      constructor Create(_userID:Integer);   overload;
      constructor Create(_userID:Integer; _phone:string; _autoRun:Boolean);   overload;


      function CommandResult(var _errorDescription:string):ecCallbackCallResult;

      // destructor Destroy;                    override;

     // procedure Clear;




      end;
   // class TCallbackCall END


implementation

uses
  FunctionUnit, GlobalVariables;



constructor TCallbackCall.Create(_userID:Integer);
begin
  m_userID:=_userID;
  m_autoRun:=False;
end;

constructor TCallbackCall.Create(_userID:Integer; _phone:string; _autoRun:Boolean);
begin
   m_userID:=_userID;
   m_phone:=_phone;
   m_autoRun:=_autoRun;
end;

function TCallbackCall.CommandResult(var _errorDescription:string):ecCallbackCallResult;
begin
  Result:=SendCommand(_errorDescription);
end;

function TCallbackCall.SendCommand(var _errorDescription:string):ecCallbackCallResult;
begin
  Result:=call_result_unknown;

end;

//destructor TLisaStatisticsDay.Destroy;
//var
// i: Integer;
//begin
////  for i:=Low(m_list) to High(m_list) do FreeAndNil(m_list[i]);
////  m_mutex.Free;
////
////  inherited;
//end;


//procedure TLisaStatisticsDay.Clear;
//begin
//   m_all        :=0;
//   m_answered   :=0;
//   m_unanswered :=0;
//   m_to_operator:=0;
//end;

//procedure TLisaStatisticsDay.GetData;
//begin
//  m_all         :=RequestToBase(lisaStat_all);
//  m_answered    :=RequestToBase(lisaStat_answered);
//  m_unanswered  :=RequestToBase(lisaStat_unanswered);
// // m_to_operator    TODO потом сделать
//end;


// получение данных из БД
//function TLisaStatisticsDay.RequestToBase(_response:lisaStatResponce):Integer;
// var
// i:Integer;
// ado:TADOQuery;
// serverConnect:TADOConnection;
// count:Integer;
// request:TStringBuilder;
// begin
//  Result:=0;
//
//  ado:=TADOQuery.Create(nil);
//  try
//      serverConnect:=createServerConnect;
//   except
//      on E:Exception do begin
//        if not Assigned(serverConnect) then begin
//           FreeAndNil(ado);
//           Exit;
//        end;
//      end;
//  end;
//
//  request:=TStringBuilder.Create;
//
//  try
//    with ado do begin
//      ado.Connection:=serverConnect;
//      SQL.Clear;
//
//      with request do begin
//        Clear;
//        Append('select count(id) from queue_lisa ');
//
//        case _response of
//          lisaStat_all :begin
//            // ничего не надо все есть
//          end;
//          lisaStat_answered:begin
//            Append(' where answered = ''1'' and hash is not NULL');
//          end;
//          lisaStat_unanswered:begin
//            Append(' where answered = ''0'' and hash is not NULL');
//          end;
//          lisaStat_to_operator:begin
//            Append(' where to_queue = ''1'' and hash is not NULL');
//          end;
//        end;
//      end;
//
//      SQL.Add(request.ToString);
//
//      try
//        Active:=True;
//        Result:= StrToInt(VarToStr(Fields[0].Value));
//      except
//          on E:EIdException do begin
//            FreeAndNil(ado);
//            if Assigned(serverConnect) then begin
//              serverConnect.Close;
//              FreeAndNil(serverConnect);
//              FreeAndNil(request);
//            end;
//            Exit;
//          end;
//      end;
//    end;
//  finally
//   FreeAndNil(ado);
//    if Assigned(serverConnect) then begin
//      serverConnect.Close;
//      FreeAndNil(serverConnect);
//      FreeAndNil(request);
//    end;
//  end;
// end;

end.
