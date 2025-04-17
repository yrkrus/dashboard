 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///      Класс для описания прогноза кол-ва звонков на текущий день           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TForecastCallsUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  GlobalVariables,
  GlobalVariablesLinkDLL,
  Vcl.StdCtrls,
  Data.Win.ADODB,
  Data.DB,
  Variants;



 // class TForecastCalls
  type
      TForecastCalls = class

      const
      cGLOBAL_DEPTH                      : Word = 20; // глубина недель которые будут просматриваться (длинна массива)
      cGLOBAL_DEPTH_CORRECT              : Word = 3;  // глубина недель которые будут просматриваться (длинна массива) для корректировки
      cGLOBAL_DAY_START                  : Word = 7;  // начальное значение дня от которого будем считать

      public
      function ShowForecastCount         : Integer; overload;              // показ прогнозируемого значения кол-ва звонков на текущий день 
      procedure ShowForecastCount (var p_label: TStaticText); overload;    // показ прогнозируемого значения кол-ва звонков на текущий день


      constructor Create(var p_label: TStaticText);                   overload;
      constructor Create(InDate:TDateTime; var p_label: TStaticText);                   overload;

      private
      m_list                      : array of Integer; // лист со значениями
      m_listCorrect               : array of Integer; // лист со значениями

      m_dateStart                 : TDate; // дата от которой будем считать
      m_forecast                  : Integer; // прогнозируемое значение кол-ва звонков на текущий день

      isManualDateStart           :Boolean;   // ручное указание даты старта

      procedure CreateData(var p_label: TStaticText);            // добавление данных в m_list
      function GetCountCalls(InDate:TDate):Integer;   // получить текущее кол-во звонков за день
      function GetAvgCount:Double;      // среднее значение звонков
      
      
      end;
 // class TForecastCalls END

implementation



constructor TForecastCalls.Create(var p_label: TStaticText);
 var
  i:Integer;
 begin
  // inherited;
    isManualDateStart:=False;

   // создаем m_list
   SetLength(m_list,cGLOBAL_DEPTH);
   SetLength(m_listCorrect,cGLOBAL_DEPTH_CORRECT);

   m_dateStart:=Now-cGLOBAL_DAY_START;

   // создаем данные
   CreateData(p_label);
 end;


constructor TForecastCalls.Create(InDate:TDateTime; var p_label: TStaticText);
 var
  i:Integer;
 begin
  // inherited;
    isManualDateStart:=True;

   // создаем m_list
   SetLength(m_list,cGLOBAL_DEPTH);
   SetLength(m_listCorrect,cGLOBAL_DEPTH_CORRECT);

   m_dateStart:=InDate-cGLOBAL_DAY_START;

   // создаем данные
   p_label.Caption:=DateToStr(m_dateStart);
   CreateData(p_label);
 end;
  
 
 // показ прогнозируемого значения кол-ва звонков на текущий день 
 function TForecastCalls.ShowForecastCount:Integer;
 begin
  Result:=Self.m_forecast;
 end;

 // показ прогнозируемого значения кол-ва звонков на текущий день
 procedure TForecastCalls.ShowForecastCount (var p_label: TStaticText);
 begin
    if not isManualDateStart then p_label.Caption:=IntToStr(ShowForecastCount)
    else p_label.Caption:= DateToStr(m_dateStart)+' ('+IntToStr(ShowForecastCount)+')';
 end;



 // добавление данных в m_list
procedure TForecastCalls.CreateData(var p_label: TStaticText);      // добавление данных в m_list
var
 i:Integer;
 currentDate:TDate; 
 avg:Double;

// test: array of Integer;
begin
   currentDate:=m_dateStart;
   for i:=0 to cGLOBAL_DEPTH-1 do begin

     if not isManualDateStart then begin
       // делаем что то типа интерактивчика
       if p_label.Caption = '.....' then p_label.Caption:=''
       else if p_label.Caption = '' then p_label.Caption:='.'
       else if p_label.Caption = '.' then p_label.Caption:='..'
       else if p_label.Caption = '..' then p_label.Caption:='...'
       else if p_label.Caption = '...' then p_label.Caption:='....'
       else if p_label.Caption = '....' then p_label.Caption:='.....';

     end
     else begin
       // делаем что то типа интерактивчика
       if p_label.Caption = DateToStr(m_dateStart)+' .....' then p_label.Caption:=DateToStr(m_dateStart)+''
       else if p_label.Caption = DateToStr(m_dateStart)+'' then p_label.Caption:=DateToStr(m_dateStart)+' .'
       else if p_label.Caption = DateToStr(m_dateStart)+' .' then p_label.Caption:=DateToStr(m_dateStart)+' ..'
       else if p_label.Caption = DateToStr(m_dateStart)+' ..' then p_label.Caption:=DateToStr(m_dateStart)+' ...'
       else if p_label.Caption = DateToStr(m_dateStart)+' ...' then p_label.Caption:=DateToStr(m_dateStart)+' ....'
       else if p_label.Caption = DateToStr(m_dateStart)+' ....' then p_label.Caption:=DateToStr(m_dateStart)+' .....';
     end;

     m_list[i]:=GetCountCalls(currentDate);
     currentDate:=currentDate-cGLOBAL_DAY_START;
   end;


   // корректировочка по данным
   currentDate:=m_dateStart;
   for i:=0 to cGLOBAL_DEPTH_CORRECT-1 do begin
     // делаем что то типа интерактивчика
     if not isManualDateStart then begin
       if p_label.Caption = '.....' then p_label.Caption:=''
       else if p_label.Caption = '' then p_label.Caption:='.'
       else if p_label.Caption = '.' then p_label.Caption:='..'
       else if p_label.Caption = '..' then p_label.Caption:='...'
       else if p_label.Caption = '...' then p_label.Caption:='....'
       else if p_label.Caption = '....' then p_label.Caption:='.....';
     end
     else begin
      // делаем что то типа интерактивчика
       if p_label.Caption = DateToStr(m_dateStart)+' (.....)' then p_label.Caption:=DateToStr(m_dateStart)+' ()'
       else if p_label.Caption = DateToStr(m_dateStart)+' ()' then p_label.Caption:=DateToStr(m_dateStart)+' (.)'
       else if p_label.Caption = DateToStr(m_dateStart)+' (.)' then p_label.Caption:=DateToStr(m_dateStart)+' (..)'
       else if p_label.Caption = DateToStr(m_dateStart)+' (..)' then p_label.Caption:=DateToStr(m_dateStart)+' (...)'
       else if p_label.Caption = DateToStr(m_dateStart)+' (...)' then p_label.Caption:=DateToStr(m_dateStart)+' (....)'
       else if p_label.Caption = DateToStr(m_dateStart)+' (....)' then p_label.Caption:=DateToStr(m_dateStart)+' (.....)';
     end;

     m_listCorrect[i]:=GetCountCalls(currentDate);
     currentDate:=currentDate-cGLOBAL_DAY_START;
   end;


   // TODO тут хотел сделать еще дельту чтобы знать кол-во которое поступило 
   //  за последние 7 дней что бы ее в случае чего прибавить к отклонению в 5%
//   SetLength(test,7);
//   for i:=0 to 7-1 do begin
//     test[i]:=GetCountCalls(currentDate);  
//     currentDate:=currentDate-1;   
//   end; 
   
   
  m_forecast:=Round(GetAvgCount);
end;

// получить текущее кол-во звонков за день
function TForecastCalls.GetCountCalls(InDate:TDate):Integer;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;  
begin   
  Result:=0;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;  
  
  try
     with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(*) from history_queue where date_time >= '+#39+GetDateToDateBD(DateToStr(InDate))+' 00:00:00'+#39+' and date_time <= '+#39+GetDateToDateBD(DateToStr(InDate))+' 23:59:59'+#39);
     
      Active:=True;
      if Fields[0].Value<>null then begin  // TODO если кол-во = 0, то наверно стоит следующий промежуток брать, ну тут подумть надо, стоит ли это делать или нет 
        Result:=StrToInt((VarToStr(Fields[0].Value)));
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;     
end;        

// среднее значение звонков
function TForecastCalls.GetAvgCount:Double;
const
 procentCorrect:Word = 15; // корректтровка в % соотношении
var
 i:Integer;
 avg:Integer;
 avgCorrect:Integer;
 resultat:Double;
begin
   avg:=0;
   avgCorrect:=0;

   for i:=0 to cGLOBAL_DEPTH-1 do avg:=avg+m_list[i];
   for i:=0 to cGLOBAL_DEPTH_CORRECT-1 do avgCorrect:=avgCorrect+m_listCorrect[i];

   if Round(avg/cGLOBAL_DEPTH) > Round(avgCorrect/cGLOBAL_DEPTH_CORRECT) then resultat:=avg/cGLOBAL_DEPTH
   else begin
     resultat:=(((avgCorrect/cGLOBAL_DEPTH_CORRECT)*procentCorrect) / 100) + Round(avg/cGLOBAL_DEPTH);
   end;

  Result:=resultat;
end;

end.