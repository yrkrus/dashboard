/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания TSendMessage                          ///
///                   отправка сообщений на сервер                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TSendMessageUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException;


/////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
 // class TSendMessage
 type
      TSendMessage = class
      public
      constructor Create;                   overload;

      destructor Destroy;                   override;

      function Send(InChannel:string;
                    InSender,InRecipient:Integer;
                    InMessage:string):Boolean;

      end;
   // class TSendMessage END


implementation

uses
  GlobalVariables, Functions;


constructor TSendMessage.Create;
 begin
    inherited;
 end;


destructor TSendMessage.Destroy;
begin
  inherited;
end;


function TSendMessage.Send(InChannel: string;
                           InSender, InRecipient: Integer;
                           InMessage: string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then  Exit;


   with ado do begin
    ado.Connection:=serverConnect;
    SQL.Clear;

    SQL.Add('insert into chat (channel,sender,recipient,message) values ('+#39+InChannel+#39+','
                                                                          +#39+IntToStr(InSender)+#39+','
                                                                          +#39+IntToStr(InRecipient)+#39+','
                                                                          +#39+InMessage+#39+')');

    try
        ExecSQL;
        Result:=True;
        SENDING_MESSAGE_ERROR:='';
    except
        on E:EIdException do begin
           SENDING_MESSAGE_ERROR:=e.Message;
           FreeAndNil(ado);
           serverConnect.Close;
           if Assigned(serverConnect) then serverConnect.Free;
           Exit;
        end;
    end;
  end;

  FreeAndNil(ado);
  serverConnect.Close;
  if Assigned(serverConnect) then serverConnect.Free;
end;


end.

