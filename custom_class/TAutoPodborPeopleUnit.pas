 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///         ����� ��� �������� ������ �������� �� ��� ������ ���              ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TAutoPodborPeopleUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  FIBDatabase, pFIBDatabase,pFIBQuery,
  Data.Win.ADODB, Data.DB, System.Variants,
  TCustomTypeUnit, TLogFileUnit, System.DateUtils;

 const      // ������ ���
  BASE_SERVER_ALIAS:string  = 'A_MAIN_034_0030';
  BASE_SERVER:string        = '10.34.222.10';

  // class TStructPeople
  type
      TStructPeople = class
      public
      lastName            :string;     // �������
      firstName           :string;     // ���
      midName             :string;     // ���������
      gender              :enumGender; // ���
      birthday            :TDate;      // ���� ��������


      constructor Create(_lastname,_firstname,_midname:string;
                         _gender:enumGender;
                         _birthday:TDate);                   overload;

      end;
 // class TStructPeople END


 // class TAutoPodborPeople
  type
      TAutoPodborPeople = class
      private
      m_log                  :TLoggingFile;
      m_phone                :string;
      m_count                :Integer;
      m_listPhoneVariants    :TStringList;

      m_list                 :TArray<TStructPeople>;

      firebird_login                        :string;
      firebird_pwd                          :string;

      firebirdConnect                       :TpFIBDatabase;
      firebirdQuery                         :TpFIBQuery;          // ��������� ���� ��� �������
      firebirdTransaction                   :TpFIBTransaction;    // ���� ��� ����������

      procedure Init(_phone:string);                  // �������������

      procedure CreateAuthFirebird;
      procedure CreatePhoneVariants;    // �������� ��������� ������� ������� ����� ���� � ��
      procedure Find;                   // ����� � �� ��������
      function GetResponse:string;      // ������������ SQL �������

      procedure AddPeople(_lastname,_firstname,_midname:string;
                          _gender:Integer;
                          _bith:TDate); // ���������� � ���������

      procedure SetPhoneVariants;  // ������ ������ ��� ��� ����

      function LastName(_id:Integer):string;
      function BirthDay(_id:Integer):string;

      public

      constructor Create(_phone:string);    overload;
      constructor Create;                   overload;

      destructor Destroy;                                  override; // ���������� �����������

      procedure SetPhone(_phone:string);    // ��������� ������ ���
      procedure Add(const _people:TAutoPodborPeople);

      function GetFIO(_id:Integer):string; overload;
      function GetFIO:string; overload;
      function FirstName(_id:Integer):string;
      function MidName(_id:Integer):string;
      function Gender(_id:Integer):enumGender;

      procedure Clear;


      property Count:Integer read m_count;

      end;
 // class TAutoPodborPeople END

implementation

uses
  GlobalVariablesLinkDLL;

// ======================== TStructPeople

constructor TStructPeople.Create(_lastname,_firstname,_midname:string;
                                 _gender:enumGender;
                                 _birthday:TDate);
begin
 lastName  :=_lastname;
 firstName :=_firstname;
 midName   :=_midname;
 gender    :=_gender;
 birthday  :=_birthday;
end;



// ======================== TStructPeople END



constructor TAutoPodborPeople.Create(_phone:string);
begin
 inherited Create;
 Init(_phone);
end;


constructor TAutoPodborPeople.Create;
begin
 inherited Create;
 Init('');
end;

// �������������
procedure TAutoPodborPeople.Init(_phone:string);
var
 isExistPhone:Boolean;
begin
 if _phone='' then isExistPhone:=False
 else isExistPhone:=True;

 if isExistPhone then m_phone:=_phone;

 m_count:=0;
 firebirdConnect            :=  TpFIBDatabase.Create(nil);

 firebirdTransaction        :=  TpFIBTransaction.Create(nil); // �������� ����������
 firebirdTransaction.DefaultDatabase:=firebirdConnect;

 firebirdQuery              :=  TpFIBQuery.Create(nil);    // ������������� TpFIBQuery
 firebirdQuery.Database     :=  firebirdConnect;  // �������� � ���� ������
 firebirdQuery.Transaction  :=  firebirdTransaction;

 m_log:=TLoggingFile.Create('firebirdResponse_CBD');

 SetLength(m_list,0);



 // ������� �����\������ �� ��
 CreateAuthFirebird;

 // �������� ����� ���������
 if isExistPhone then begin
   SetPhoneVariants;  // ������ ������ ��� ��� ����
   Find;
 end;

 //inherited Create;
end;


destructor TAutoPodborPeople.Destroy; // ���������� �����������
var
 i:Integer;
begin
  for i:=0 to High(m_list) do m_list[i].Free;

  m_listPhoneVariants.Free; // ����������� ������, ������� TStringList
  firebirdConnect.Free;
  firebirdTransaction.Free; // ������������ ������� ����������
  firebirdQuery.Free;

  m_log.Free;

  inherited;                // ����� ����������� ������������� ������
end;


// ������ ������ ��� ��� ����
procedure TAutoPodborPeople.SetPhoneVariants;
begin
 m_listPhoneVariants:=TStringList.Create;
 // ������ ������ ��� ��� ����
 CreatePhoneVariants;
end;

// ��������� ������ ���
procedure TAutoPodborPeople.SetPhone(_phone:string);
begin
  m_phone:=_phone;

  // ������ ������ ��� ��� ����
  SetPhoneVariants;

  // ����� ���
  Find;
end;

procedure TAutoPodborPeople.Add(const _people:TAutoPodborPeople);
var
  i: Integer;
  src: TStructPeople;
begin
  m_phone:=_people.m_phone;

  // ���������� ���� ����� � ���������
  for i:= 0 to _people.Count - 1 do
  begin
    // �������� ������ �� �������� ������
    src:= _people.m_list[i];

    // ��������� � ���� ������ �������� �����
    AddPeople(src.lastName,src.firstName, src.midName,  Ord(src.gender), src.birthday);
  end;
end;

procedure TAutoPodborPeople.Clear;
var
  i: Integer;
begin
  // ���������� ��� �������
  for i := Low(m_list) to High(m_list) do begin
    if Assigned(m_list[i]) then m_list[i].Free;
  end;
  // �������� ������ � �������
  SetLength(m_list, 0);
  m_count:= 0;

  if Assigned(m_listPhoneVariants) then m_listPhoneVariants.Clear;

  m_phone:='';
end;

function TAutoPodborPeople.LastName(_id:Integer):string;
begin
  Result:=m_list[_id].lastName;
end;

function TAutoPodborPeople.FirstName(_id:Integer):string;
begin
  Result:=m_list[_id].firstName;
end;

function TAutoPodborPeople.MidName(_id:Integer):string;
begin
  Result:=m_list[_id].midName;
end;

function TAutoPodborPeople.Gender(_id:Integer):enumGender;
begin
 Result:=m_list[_id].gender;
end;

function TAutoPodborPeople.BirthDay(_id:Integer):string;
begin
 Result:=DateToStr(m_list[_id].birthday);
end;

function TAutoPodborPeople.GetFIO(_id:Integer):string;
begin
  Result:=LastName(_id)+' '+FirstName(_id)+' '+MidName(_id)+' ('+BirthDay(_id)+')';
end;

// ����������� ���
function TAutoPodborPeople.GetFIO:string;
var
 countFIO:Integer;
begin
  countFIO:=m_count;
  case countFIO of
    0:begin
      Result:='����� �����';
    end;
    1:begin
      Result:=GetFIO(0);
    end;
    else begin
      Result:='��������� ��������� ('+IntToStr(countFIO)+')';
    end;
   end;
end;

// �������� ��������� ������� ������� ����� ���� � ��
procedure TAutoPodborPeople.CreatePhoneVariants;
var
  formattedNumber: string;
begin
  // ����������� ����� � ������ "+7(XXX)XXX-XX-XX"
  if Length(m_phone) = 11 then // ���������, ��� ����� ������� �� 11 ����
  begin
    formattedNumber := Format('+7(%s)%s-%s-%s',
      [Copy(m_phone, 2, 3),
       Copy(m_phone, 5, 3),
       Copy(m_phone, 8, 2),
       Copy(m_phone, 10, 2)]);

    m_listPhoneVariants.Add(formattedNumber);
  end;

  // ����������� ����� � ������ "+ 7(XXX)XXX-XX-XX"
  if Length(m_phone) = 11 then
  begin
    formattedNumber := Format('+ 7(%s)%s-%s-%s',
      [Copy(m_phone, 2, 3),
       Copy(m_phone, 5, 3),
       Copy(m_phone, 8, 2),
       Copy(m_phone, 10, 2)]);

    m_listPhoneVariants.Add(formattedNumber);
  end;
end;


procedure TAutoPodborPeople.CreateAuthFirebird;
var
  ado:TADOQuery;
  serverConnect:TADOConnection;
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
      SQL.Add('select firebird_login,firebird_pwd from server_ik_fb');
      Active:=True;

      if (Fields[0].Value<>null) and (Fields[1].Value<>null)  then begin
        firebird_login:=VarToStr(Fields[0].Value);
        firebird_pwd:=VarToStr(Fields[1].Value);
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


// ������������ SQL �������
function TAutoPodborPeople.GetResponse:string;
var
 stroka:string;
begin
  stroka:='select LASTNAME,FIRSTNAME,MIDNAME,POL,BDATE from CLIENTS where PHONE3 IN ('
          +#39+m_listPhoneVariants[0]+#39+','+#39+m_listPhoneVariants[1]+#39+')';
//          +' OR PHONE2 IN ('
//          +#39+m_listPhoneVariants[0]+#39+','+#39+m_listPhoneVariants[1]+#39+')'
//          +' OR PHONE1 IN ('
//          +#39+m_listPhoneVariants[0]+#39+','+#39+m_listPhoneVariants[1]+#39+')';

  Result:=stroka;
end;

// ���������� � ���������
procedure TAutoPodborPeople.AddPeople(_lastname,_firstname,_midname:string; _gender:Integer; _bith:TDate);
var
  newPerson: TStructPeople;
  gender:enumGender;
begin
  case _gender of
   1:gender:=gender_male;
   2:gender:=gender_female;
  end;

  newPerson:= TStructPeople.Create(_lastname, _firstname, _midname, gender, _bith);

  SetLength(m_list, Length(m_list) + 1);
  m_list[High(m_list)] := newPerson;

  Inc(m_count);
end;


// ����� � �� ��������
procedure TAutoPodborPeople.Find;
var
 messclass,mess:string;
 response:string;

 lastName   :string;     // �������
 firstName  :string;     // ���
 midName    :string;     // ���������
 gender     :Integer;    // ���
 birth      :TDate;      // ���� ��������
begin
  with firebirdConnect do begin
    if Connected then Close;

    try
      ConnectParams.UserName:=firebird_login;
      ConnectParams.Password:=firebird_pwd;
      ConnectParams.CharSet:='WIN1251';
      DBName:=BASE_SERVER+'/3050:'+BASE_SERVER_ALIAS;
      LibraryName:='gds32.dll';
      Connected:=True;

      if Connected then begin
        response:=GetResponse;
        firebirdQuery.SQL.Clear;
        firebirdQuery.SQL.Add(response);

        // �������� ����������
        firebirdTransaction.StartTransaction;
        try
          firebirdQuery.ExecQuery;

          while not firebirdQuery.Eof do
          begin
            // ��������� ����������� �������
            lastName     :=firebirdQuery.FieldByName('LASTNAME').AsString;
            firstName    :=firebirdQuery.FieldByName('FIRSTNAME').AsString;
            midName      :=firebirdQuery.FieldByName('MIDNAME').AsString;
            gender       :=firebirdQuery.FieldByName('POL').AsInteger;
            birth        :=firebirdQuery.FieldByName('BDATE').AsDate;
            // ��������� � ���������
            AddPeople(lastName,firstName,midName,gender,birth);

            lastName:=DateToStr(birth);

            lastName:='';
            firstName:='';
            midName:='';

            firebirdQuery.Next; // ������� � ��������� ������
          end;

          // ������������� ����������
          firebirdTransaction.Commit;
        except
          on E: Exception do
          begin
            messclass := E.ClassName;
            mess := E.Message;
            m_log.Save(DBName + ': ' + messclass + ':' + mess, True);
            firebirdTransaction.Rollback; // ����� ���������� � ������ ������
            Connected := False;
          end;
        end;
      end;

     except
      on E:Exception do
      begin
       messclass:=e.ClassName;
       mess:=e.Message;
       m_log.Save(DBName+': '+messclass+':'+mess,True);
       Connected:=False;
      end;
    end;

     Connected:= False;
  end;

end;

end.