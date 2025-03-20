 /////////////////////////////////////////////////////////////////////////////////
///                                                                            ///
///                                                                            ///
///             Класс для описания пациента  для отправки SMS                  ///
///                                                                            ///
///                                                                            ///
//////////////////////////////////////////////////////////////////////////////////


unit TPacientsListUnit;

interface

uses
System.Classes,
System.SysUtils,
TCustomTypeUnit;


 // class TListPacients
  type
      TListPacients = class
      public
       PCODE              :Integer;

       Phone              :string;
       Familiya           :string;
       IO                 :string;
       Birthday           :TDate;
       Pol                :string;
       DataPriema         :TDate;
       TimePriema         :TTime;
       FIOVracha          :string;
       ServiceNapravlenie :string;
       ClinicAddress      :string;

       //isService          :Boolean; // услуга (если улуга то формировать смс из ServiceNapravlenie, а не ФИО врача)
       _errorDescriptions : string; // лень делать отдельный класс, по этому запишем здесь (это для Drop номеров)


      constructor Create;               overload;
      procedure Clear;          // очистка

      private
      function Clone:TListPacients;

      end;
 // class TListPacients END


     // class TPacients
  type
      TPacients = class
      public

      function isExistList:Boolean;             // есть ли список с данными
      procedure Add(NewPacient:TListPacients; isCheckExist:Boolean = False);  // добавление нового в список
      function Count:Integer;                   // кол-во записей на отправку

      function CreateMessage(id:Integer; InRemeberMessage:string):string; // создание смс сообщения
      function GetPhone(id:Integer):string;     // номер телефона

      constructor Create;            overload;
      destructor Destroy;            override;

      procedure Clear;                          // очистка
      function GetErrorDescriptions(id:Integer) :string;  // получение ошибки
      function ShowPacientInfo(id:Integer):string;        // отображение инфо о пациенте


      private
       m_count     :Integer;
       m_lists     :array of TListPacients;

      function IsExistPacient(NewPacient:TListPacients):Boolean;  // проверка есть ли уже такая запись

      end;
 // class TPacients END


implementation


constructor TListPacients.Create;
 begin
   inherited;
 end;

 procedure TListPacients.Clear;
 begin
   with Self do begin
     PCODE:=0;
     Phone:='';
     Familiya:='';
     IO:='';
     Birthday:=0;
     Pol:='';
     DataPriema:=0;
     TimePriema:=0;
     FIOVracha:='';
     ServiceNapravlenie:='';
     ClinicAddress:='';
    // isService:=False;

     _errorDescriptions:='';
   end;
 end;


function TListPacients.Clone: TListPacients;
begin
  Result:=TListPacients.Create;

  Result.PCODE := Self.PCODE;
  Result.Phone := Self.Phone;
  Result.Familiya := Self.Familiya;
  Result.IO := Self.IO;
  Result.Birthday := Self.Birthday;
  Result.Pol := Self.Pol;
  Result.DataPriema := Self.DataPriema;
  Result.TimePriema := Self.TimePriema;
  Result.FIOVracha := Self.FIOVracha;
  Result.ServiceNapravlenie := Self.ServiceNapravlenie;
  Result.ClinicAddress := Self.ClinicAddress;
  //Result.isService:= Self.isService;

  Result._errorDescriptions := Self._errorDescriptions;
end;

 constructor TPacients.Create;
 begin
   inherited;
   m_count:=0;
   SetLength(m_lists, 0);
 end;


destructor TPacients.Destroy;
var
 i:Integer;
begin
  for i:=Low(m_lists) to High(m_lists) do FreeAndNil(m_lists[i]);
  inherited Destroy;
end;

function TPacients.isExistList:Boolean;
begin
  Result:= m_count > 0;
end;

procedure TPacients.Clear;
var
 i:Integer;
begin
  if m_count=0 then Exit;
  for i:=Low(m_lists) to High(m_lists) do m_lists[i].Clear;

  SetLength(m_lists, 0);  // Очищаем массив
  m_count := 0;           // Сбрасываем счетчик
end;


procedure TPacients.Add(NewPacient: TListPacients; isCheckExist:Boolean = False);
var
  PacientCopy: TListPacients;
begin
  // проверка на дубль записи
  if isCheckExist then begin
    if IsExistPacient(NewPacient) then Exit;
  end;

  // Создаем копию объекта
  PacientCopy := NewPacient.Clone;
  try
    SetLength(m_lists, Length(m_lists) + 1);
    m_lists[High(m_lists)] := PacientCopy; // Добавляем копию в массив
    Inc(m_count);
  except
    PacientCopy.Free; // Освобождаем память в случае ошибки
    raise;            // Пробрасываем исключение дальше
  end;
end;

// кол-во записей на отправку
function TPacients.Count:Integer;
begin
  Result:=m_count;
end;

// получение ошибки
function TPacients.GetErrorDescriptions(id:Integer) :string;
begin
  Result:=Self.m_lists[id]._errorDescriptions;
end;

// отображение инфо о пациенте
function TPacients.ShowPacientInfo(id:Integer):string;
begin
  Result:=Self.m_lists[id].Familiya+' '+Self.m_lists[id].IO+' '+
          '('+DateToStr(Self.m_lists[id].Birthday)+')';
end;


// проверка есть ли уже такая запись
function TPacients.IsExistPacient(NewPacient:TListPacients):Boolean;
var
 i:Integer;
begin
  Result:=False;

  for i:=0 to m_count-1 do begin
    if m_lists[i].PCODE = NewPacient.PCODE then begin
      Result:=True;
      Exit;
    end;
  end;
end;

// проверка это фио фрача или это услуга
function isFIOVracha(FIOVracha:string):Boolean;
var
 countDot:Integer;
 i:Integer;
begin
  Result:=False;
  countDot:=0;

  for i:=1 to Length(FIOVracha) do begin
    if FIOVracha[i]='.' then Inc(countDot);
  end;

  if countDot = 2 then Result:=True;
end;

// создание смс сообщения
function TPacients.CreateMessage(id:Integer; InRemeberMessage:string):string;
var
 tempMessage:string;
begin
   tempMessage:=InRemeberMessage;

   tempMessage:=StringReplace(tempMessage,'%FIO_Pacienta',m_lists[id].IO,[rfReplaceAll]);

   if m_lists[id].Pol='м' then tempMessage:=StringReplace(tempMessage,'%записан(а)','записан',[rfReplaceAll])
   else tempMessage:=StringReplace(tempMessage,'%записан(а)','записана',[rfReplaceAll]);

   if isFIOVracha(m_lists[id].FIOVracha) then tempMessage:=StringReplace(tempMessage,'%к_доктору','к доктору',[rfReplaceAll])
   else tempMessage:=StringReplace(tempMessage,'%к_доктору','на',[rfReplaceAll]);

   tempMessage:=StringReplace(tempMessage,'%FIO_Doctora',m_lists[id].FIOVracha,[rfReplaceAll]);

   tempMessage:=StringReplace(tempMessage,'%Time',FormatDateTime('hh:nn', m_lists[id].TimePriema),[rfReplaceAll]);
   tempMessage:=StringReplace(tempMessage,'%Data',DateToStr(m_lists[id].DataPriema),[rfReplaceAll]);

   tempMessage:=StringReplace(tempMessage,'%Address',m_lists[id].ClinicAddress,[rfReplaceAll]);

   Result:=tempMessage;
end;

// номер телефона
function TPacients.GetPhone(id:Integer):string;
begin
  Result:=Self.m_lists[id].Phone;
end;


end.