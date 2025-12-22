/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                    ласс дл€ описани€ LisaStatisticsDay                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TLisaStatisticsDayUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils, Variants,
      Graphics, System.SyncObjs, IdException,  GlobalVariablesLinkDLL, TCustomTypeUnit,
      System.Generics.Collections;


/////////////////////////////////////////////////////////////////////////////////////////
 type lisaStatResponce =
  (
    lisaStat_all,
    lisaStat_answered,
    lisaStat_unanswered,
    lisaStat_to_operator
  );

 // class TLisaStatisticsDay
 type
      TLisaStatisticsDay = class

      private
      m_day           :TDate;     // день который будем прогружать
      m_all           :Integer;   // всего звонков
      m_answered      :Integer;   // отвеченные звонки
      m_unanswered    :Integer;   // не отвеченные звонки
      m_to_operator   :Integer;   // переведенные на оператора

      procedure GetData;          // получение данных
      function  RequestToBase(_response:lisaStatResponce):Integer;  // получение данных из Ѕƒ

      public


      constructor Create(_date:TDate);                  overload;
      destructor Destroy;                  override;

      procedure Clear;

      property All:Integer read m_all;
      property Answered:Integer read m_answered;
      property Unanswered:Integer read m_unanswered;
      property ToOperator:Integer read m_to_operator;

      end;
   // class TLisaStatisticsDay END


implementation

uses
  FunctionUnit, GlobalVariables;



constructor TLisaStatisticsDay.Create(_date:TDate);
begin
  m_day:=_date;

  // получим данные
  GetData;
end;

destructor TLisaStatisticsDay.Destroy;
var
 i: Integer;
begin
//  for i:=Low(m_list) to High(m_list) do FreeAndNil(m_list[i]);
//  m_mutex.Free;
//
//  inherited;
end;


procedure TLisaStatisticsDay.Clear;
begin
   m_all        :=0;
   m_answered   :=0;
   m_unanswered :=0;
   m_to_operator:=0;
end;

procedure TLisaStatisticsDay.GetData;
begin
  m_all         :=RequestToBase(lisaStat_all);
  m_answered    :=RequestToBase(lisaStat_answered);
  m_unanswered  :=RequestToBase(lisaStat_unanswered);
 // m_to_operator    TODO потом сделать
end;


// получение данных из Ѕƒ
function TLisaStatisticsDay.RequestToBase(_response:lisaStatResponce):Integer;
 var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 count:Integer;
 request:TStringBuilder;
 begin
  Result:=0;

  ado:=TADOQuery.Create(nil);
  try
      serverConnect:=createServerConnect;
   except
      on E:Exception do begin
        if not Assigned(serverConnect) then begin
           FreeAndNil(ado);
           Exit;
        end;
      end;
  end;

  request:=TStringBuilder.Create;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      with request do begin
        Clear;
        Append('select count(id) from queue_lisa ');

        case _response of
          lisaStat_all :begin
            // ничего не надо все есть
          end;
          lisaStat_answered:begin
            Append(' where answered = ''1'' and hash is not NULL');
          end;
          lisaStat_unanswered:begin
            Append(' where answered = ''0'' and hash is not NULL');
          end;
          lisaStat_to_operator:begin
            Append(' where to_queue = ''1'' and hash is not NULL');
          end;
        end;
      end;

      SQL.Add(request.ToString);

      try
        Active:=True;
        Result:= StrToInt(VarToStr(Fields[0].Value));
      except
          on E:EIdException do begin
            FreeAndNil(ado);
            if Assigned(serverConnect) then begin
              serverConnect.Close;
              FreeAndNil(serverConnect);
              FreeAndNil(request);
            end;
            Exit;
          end;
      end;
    end;
  finally
   FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
      FreeAndNil(request);
    end;
  end;
 end;

end.
