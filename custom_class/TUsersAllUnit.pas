/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                  Класс для описания всех пользователей в БД               ///
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

      procedure LoadAllUsers;     // прогрузка всех пользователей которые есть в БД


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

  // прогружаем всех пользователей
  LoadAllUsers;
end;



procedure TUsersAll.LoadAllUsers;
begin

end;




end.

