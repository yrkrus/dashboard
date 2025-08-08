
/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                    ласс дл€ описани€ ChekSipTrunk                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TCheckSipTrunkUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, Vcl.StdCtrls,
      IdException, FIBDatabase, pFIBDatabase, TLogFileUnit,
      Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Forms, TCustomTypeUnit, FormTrunkSipUnit;


/////////////////////////////////////////////////////////////////////////////////////////
  // class TStructTrunk
 type
      TStructTrunk = class

      public
       id              :Integer;
       status          :enumTrunkStatus;
       alias           :string;
       is_alive        :Boolean; // живой транк или нет true - живой

      constructor Create;             overload;
      procedure Clear;

      end;
   // class TStructTrunk END


/////////////////////////////////////////////////////////////////////////////////////////
   // class TCheckSipTrunk
 type
      TCheckSipTrunk = class
      private
      m_listTrunk                           :TArray<TStructTrunk>;
      m_count                               :Integer;
      m_mutex                               :TMutex;

      m_log                                 :TLoggingFile;
      p_checkTrunkInfo                      :TLabel;
      p_formCheckTrunks                     :TFormTrunkSip;

      procedure CreateListTrunk;                    // получение данных о транках(status, alias)

      procedure Check;        // внутренн€€ проверка состо€ние sip транков
      function GetStateTrunk(_id:Integer):enumTrunkStatus;  // статус транка

      public
      constructor Create(var p_Log:TLoggingFile;
                         var p_TextCheckTrunkInfo:TLabel;
                         var p_FormCheckTrunk:TFormTrunkSip); overload;

      destructor Destroy;                   override;

      procedure CheckSipTrunk;            // проверка на доступность sip транков

      property Count:Integer read  m_count;


      end;
   // class TCheckSipTrunk END


implementation

uses
  FunctionUnit, GlobalVariables, GlobalVariablesLinkDLL;


constructor TStructTrunk.Create;
 begin
    inherited;
    Clear;
 end;

 procedure TStructTrunk.Clear;
 begin
    Self.id:=0;
    Self.status:=eTrunkUnknown;
    Self.alias:='';
    Self.is_alive:=False;
 end;


constructor TCheckSipTrunk.Create(var p_Log:TLoggingFile;
                                  var p_TextCheckTrunkInfo:TLabel;
                                  var p_FormCheckTrunk:TFormTrunkSip);
 begin
   // inherited;
    m_mutex:=TMutex.Create(nil, False, 'Global\TCheckTrunk');

    m_log:=p_Log;
    p_checkTrunkInfo:=p_TextCheckTrunkInfo;
    p_formCheckTrunks:=p_FormCheckTrunk;

    m_count:=0;

   // получим данные
   CreateListTrunk;
 end;


destructor TCheckSipTrunk.Destroy;
var
 i: Integer;
begin
  for i:=Low(m_listTrunk) to High(m_listTrunk) do FreeAndNil(m_listTrunk[i]);
  SetLength(m_listTrunk, 0); // ”бираем массив

  m_mutex.Free;

  inherited;
end;


procedure TCheckSipTrunk.CreateListTrunk;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countTrunks:Integer;
 i:Integer;
 response:string;
begin
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
      response:='select count(id) from sip_trunks where is_monitoring = ''1'' ';
      SQL.Add(response);

      try
          Active:=True;
          countTrunks:=Fields[0].Value;
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
             end;
             Exit;
          end;
      end;


      if countTrunks>=1 then begin

        //создадиим структуру
        SetLength(m_listTrunk,countTrunks);
        for i:=0 to countTrunks-1 do m_listTrunk[i]:=TStructTrunk.Create;

        m_count:=countTrunks;

        if Active then ACtive:=false;

        SQL.Clear;
        response:='select id,state,alias from sip_trunks where is_monitoring = ''1''';

        SQL.Add(response);

        try
         Active:=True;
        except
            on E:EIdException do begin
              FreeAndNil(ado);
              if Assigned(serverConnect) then begin
                serverConnect.Close;
                FreeAndNil(serverConnect);
              end;

              Exit;
            end;
        end;


         for i:=0 to countTrunks-1 do begin
           m_listTrunk[i].id:=StrToInt(VarToStr(Fields[0].Value));
           m_listTrunk[i].status:=StringToEnumTrunkStatus(VarToStr(Fields[1].Value));
           m_listTrunk[i].alias:=VarToStr(Fields[2].Value);

           // живой ли транк
           if m_listTrunk[i].status = eTrunkRegisterd then  m_listTrunk[i].is_alive:=True;

           ado.Next;
         end;
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

// внутренн€€ проверка состо€ние sip транков
procedure TCheckSipTrunk.Check;
var
 i:Integer;
begin
  for i:=Low(m_listTrunk) to High(m_listTrunk) do begin
    m_listTrunk[i].status:=GetStateTrunk(m_listTrunk[i].id);

    // живой ли транк
    if m_listTrunk[i].status = eTrunkRegisterd then m_listTrunk[i].is_alive:=True
    else m_listTrunk[i].is_alive:=False;
  end;
end;

// статус транка
function TCheckSipTrunk.GetStateTrunk(_id:Integer):enumTrunkStatus;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
 response:string;
begin
  Result:=eTrunkUnknown;

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
      response:='select state from sip_trunks where id = '+#39+IntToStr(_id)+#39+'';
      SQL.Add(response);

      try
          Active:=True;
          if Fields[0].Value <> null then Result:=StringToEnumTrunkStatus(VarToStr(Fields[0].Value));
      except
          on E:EIdException do begin
             FreeAndNil(ado);
             if Assigned(serverConnect) then begin
               serverConnect.Close;
               FreeAndNil(serverConnect);
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
    end;
  end;
end;


procedure TCheckSipTrunk.CheckSipTrunk;
const
 colorError:TColor        = clRed;
 colorWarning:TColor      = $0000D5D5;
 colorOk:TColor           = clGreen;

var
 i,j:Integer;
 lblName:string;
 CodOshibki:string;
 viewErrors:Integer;
 connectBD_Firebird:Boolean;
 allCountErrors:Integer;
begin
   allCountErrors:=0; // общее кол-во серверов с ошибками

   // провер€ем состо€ние
    Check;

   for i:=0 to Count-1 do begin

      // подправим статусы
      with p_formCheckTrunks do begin

        for j:=0 to ComponentCount-1 do begin
          if Components[j].Name='lbl_'+IntToStr(m_listTrunk[i].id) then begin
            if m_listTrunk[i].is_alive then begin  // Ќ≈“ ќЎ»Ѕ »!!
               (Components[j] as TLabel).Caption:='доступен';
               (Components[j] as TLabel).Font.Color:=colorOk;
            end
            else begin                                  // ≈—“№ ќЎ»Ѕ ј!!!
               (Components[j] as TLabel).Caption:='не доступен';
               (Components[j] as TLabel).Font.Color:=colorError;
            end;
          end;
        end;

      end;
   end;

  // надпись после проверки
  begin
      for i:=0 to Count-1 do begin

          // кол-во с ошибками
          for j:=0 to Count-1 do begin
            if not m_listTrunk[j].is_alive then begin
               Inc(allCountErrors);
            end;
          end;

          case allCountErrors of
           1:begin
            for j:=0 to Count-1 do begin
              if not m_listTrunk[j].is_alive then begin
                p_checkTrunkInfo.Caption:=m_listTrunk[j].alias;
                p_checkTrunkInfo.InitiateAction;
                p_checkTrunkInfo.Repaint;
              end;
            end;
           end;
           2:begin
            viewErrors:=0;
            for j:=0 to Count-1 do begin
              if not m_listTrunk[j].is_alive then begin
                if viewErrors=0 then begin
                 p_checkTrunkInfo.Caption:=m_listTrunk[j].alias;
                 Inc(viewErrors);
                end
                else begin
                  p_checkTrunkInfo.Caption:=p_checkTrunkInfo.Caption+' и '+m_listTrunk[j].alias;
                end;

                p_checkTrunkInfo.InitiateAction;
                p_checkTrunkInfo.Repaint;
              end;
            end;
           end;
          else
           viewErrors:=0;
            for j:=0 to Count-1 do begin
              if not m_listTrunk[j].is_alive then begin
                if viewErrors=0 then begin
                 p_checkTrunkInfo.Caption:=m_listTrunk[j].alias;
                 Inc(viewErrors);
                end
                else if (viewErrors=1) then begin
                  p_checkTrunkInfo.Caption:=p_checkTrunkInfo.Caption+' и '+m_listTrunk[j].alias;
                  inc(viewErrors);
                end;

                p_checkTrunkInfo.InitiateAction;
                p_checkTrunkInfo.Repaint;
              end;
            end;

            if viewErrors>=2 then begin
             p_checkTrunkInfo.Caption:=p_checkTrunkInfo.Caption+' и еще '+IntToStr(allCountErrors-2)+' (нажмите сюда дл€ показа...)';
             p_checkTrunkInfo.InitiateAction;
             p_checkTrunkInfo.Repaint;
            end;
          end;

      end;
  end;

end;

end.
