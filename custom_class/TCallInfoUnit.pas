 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///   ����� ��� �������� ���������� �� ������ (�����, ��������, ������)       ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TCallInfoUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit;


 // class TCallInfo
  type
      TCallInfo = class

      private
      m_table   :enumReportTableIVR; // �� ����� ������� ������ �������
      m_phone   :string;  // ����� ��������
      m_time    :string;  // ����� ������
      m_trunk   :string;  // �����
      m_phoneOperator:string; // ��������
      m_region:string;        // ������


      procedure Find; // ����� ������ �� ������

      public

      constructor Create(_phone:string;
                         _timeCall:string;
                         _table:enumReportTableIVR);                   overload;
      procedure Clear;


      end;
 // class TCallInfo END

implementation

uses
  GlobalVariablesLinkDLL;


constructor TCallInfo.Create(_phone:string;
                             _timeCall:string;
                             _table:enumReportTableIVR);
begin
 Clear;

 m_phone:=_phone;
 m_time:=_timeCall;
 m_table:=_table;
end;

procedure TCallInfo.Clear;
begin
  m_table:=eTableHistoryIVR; // �� ��������� �� history_*
  m_phone:='';
  m_time:='';
  m_trunk:='';
  m_phoneOperator:='';
  m_region:='';
end;

// ����� ������ �� ������
procedure TCallInfo.Find;
begin

end;



end.