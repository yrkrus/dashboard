 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   ����� ��� �������� ������������ ���                     ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TShowMessageSMSUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.Win.ADODB, Data.DB,
  System.Variants;



   // class TStructSMS
  type
      TStructSMS = class
      public
      m_phone       :string;
      m_date        :string;
      m_sms         :string;
      m_status      :string;

      constructor Create;    overload;

      end;
 // class TStructSMS END



  // class TStructUserSending
  type
      TStructUserSending = class
      public
      m_user_id       :Integer;
      m_FIO           :string;
      m_sms           :TStructSMS;

      constructor Create;                   overload;

      end;
 // class TStructUserSending END




 // class TShowMessageSMS
  type
      TShowMessageSMS = class
      private
      m_dateStart     : TDateTime;
      m_count         : Integer;
      m_list          : TArray<TStructUserSending>;

      procedure Init;
      procedure CreateListSending;      // �������� ����� � ������� �� ������������ ���

      public

      constructor Create;                       overload;
      constructor Create(_date:TDateTime);      overload;

      function GetUserInfoSending(_id:Integer):string; // ���� � ��� ��� � �� ������� �������� � �� ����� ����� ���
      function GetMessageSMS(_id:Integer):string;      // ���� ���������

      property Count:Integer read m_count;

      end;
 // class TShowMessageSMS END

implementation

uses
  GlobalVariablesLinkDLL;


// ==================================
// TStructSMS

constructor TStructSMS.Create;
 begin
   //inherited;
   m_phone  :='';
   m_date   :='';
   m_sms    :='';
   m_status :='';
 end;


// TStructSMS END
// ==================================


// ==================================
// TStructUserSending

 constructor TStructUserSending.Create;
 begin
   inherited;
   m_user_id       :=0;
   m_FIO           :='';
   m_sms:=TStructSMS.Create;
 end;


//  TStructUserSending END
// ==================================



// ==================================
// TShowMessageSMS

constructor TShowMessageSMS.Create;
 begin
   //inherited;
   Init;
 end;

 constructor TShowMessageSMS.Create(_date:TDateTime);
 begin
   //inherited;
   m_dateStart:=_date;
   Init;
 end;

 procedure TShowMessageSMS.Init;
 var
  i:Integer;
 begin
   m_count:=GetCountSendingSMSToday;
   SetLength(m_list,m_count);
   for i:=0 to m_count-1 do m_list[i]:=TStructUserSending.Create;


   // ���������  �������
   CreateListSending;
 end;

 procedure TShowMessageSMS.CreateListSending;
 var
   ado:TADOQuery;
   serverConnect:TADOConnection;
   i:Integer;
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

      if m_dateStart = 0 then begin
        SQL.Add('select user_id, date_time, phone, message, status from sms_sending where user_id<>''0'' and  date_time > '+#39+GetCurrentStartDateTime+#39+' order by date_time DESC');
      end
      else begin
        // TODO �������
      end;

      Active:=True;
      for i:=0 to m_count - 1 do begin
        m_list[i].m_user_id:=StrToInt(VarToStr(Fields[0].Value));
        m_list[i].m_FIO:=GetUserNameFIO(m_list[i].m_user_id);
        m_list[i].m_sms.m_phone:=VarToStr(Fields[2].Value);
        m_list[i].m_sms.m_date:=VarToStr(Fields[1].Value);
        m_list[i].m_sms.m_sms:=VarToStr(Fields[3].Value);

        if Fields[4].Value <> null then m_list[i].m_sms.m_status:=VarToStr(Fields[4].Value)
        else m_list[i].m_sms.m_status:='����������';

        ado.Next;
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


// ���� � ��� ��� � �� ������� �������� � �� ����� ����� ���
function TShowMessageSMS.GetUserInfoSending(_id:Integer):string;
begin
  Result:=m_list[_id].m_FIO+' ('+m_list[_id].m_sms.m_date+')';
end;

// ���� ���������
function TShowMessageSMS.GetMessageSMS(_id:Integer):string;
begin
   Result:=m_list[_id].m_sms.m_sms;
end;

// TShowMessageSMS END
// ==================================

end.