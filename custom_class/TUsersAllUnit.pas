/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  ����� ��� �������� ���� ������������� � ��               ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TUsersAllUnit;

interface

uses  System.Classes, Data.Win.ADODB, Data.DB, System.SysUtils,
      Variants, Graphics, System.SyncObjs, IdException, TUserUnit;



/////////////////////////////////////////////////////////////////////////////////////////
 // class TUsersAll
 type
      TUsersAll = class
      private
      m_count   :Integer;
      m_list    :TArray<TUser>;

      procedure LoadAllUsers;     // ��������� ���� ������������� ������� ���� � ��


      public
      constructor Create;                   overload;
     // destructor Destroy;                   override;



      end;
   // class TUsersAll END


implementation




constructor TUsersAll.Create;
begin
  inherited;
  m_count:=0;

  // ���������� ���� �������������
  LoadAllUsers;
end;



procedure TUsersAll.LoadAllUsers;
begin

end;




end.

