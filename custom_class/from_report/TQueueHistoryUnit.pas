 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            ����� ��� �������� ������� ������ � �������                    ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TQueueHistoryUnit;

interface

uses
    System.Classes, System.SysUtils, TCustomTypeUnit, TAutoPodborPeopleUnit;


 // class TQueueHistory
  type
      TQueueHistory = class
      private
      m_people          :TAutoPodborPeople;

      procedure Clear;

      public
      id                :Integer;            // id �� ��
      number_queue      :enumQueueCurrent;   // ����� �������
      phone             :string;             // ����� �������� � ������� �������� ���
      waiting_time      :string;             // �������� � ������� ����� �������
      date_time         :TDateTime;          // ����\�����
      sip               :Integer;            // sip ���������
      talk_time         :string;             // ����� ���������
      operatorFIO       :string;             // ��� ���������
      trunk             :string;             // ����� � �������� �������� ������
      phone_operator    :string;             // ��������
      region            :string;             // ������
      onHold            :Integer;            // OnHold(���)

      constructor Create(_createPeople:Boolean = False);                   overload;
      procedure SetPhonePeople(_phone:string);
      function GetFIOPeople:string; // ������������ ��� ���������


      end;
 // class TQueueHistory END

implementation


constructor TQueueHistory.Create(_createPeople:Boolean);
 begin
   if _createPeople then m_people:=TAutoPodborPeople.Create;

   Clear;
 end;


procedure TQueueHistory.Clear;
begin
  id:=0;
  number_queue:=queue_null;
  phone:='';
  waiting_time:='';
  date_time:=0;
  sip:=0;
  talk_time:='';
  operatorFIO:='';
  trunk:='';
  phone_operator:='';
  region:='';
  onHold:=0;

  if Assigned(m_people) then m_people.Clear;
end;


procedure TQueueHistory.SetPhonePeople(_phone:string);
begin
  m_people.SetPhone(_phone);
end;

function TQueueHistory.GetFIOPeople:string; // ������������ ��� ���������
begin
  Result:=m_people.GetFIO;
end;

end.