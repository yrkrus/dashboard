unit FunctionUnit;

interface

uses
FormHomeUnit,
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
 System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
 Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
 IdSSL,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,System.IniFiles,
 Winapi.WinSock,  Vcl.ComCtrls, GlobalVariables, Vcl.Grids, Data.Win.ADODB,
 Data.DB, IdException,  Vcl.Menus, System.SyncObjs,
 TCustomTypeUnit, Word_TLB, ActiveX, Winapi.RichEdit,
 Vcl.Imaging.Jpeg, System.IOUtils, Vcl.ExtCtrls;


  procedure CreateCopyright;                                                                    // создание Copyright
  procedure InitManual;                                                       // русной запуск формы
  procedure InitAutoRun;                                                      // автоматический запуск
  function ParsePhoneNumber(const PhoneNumber: string): string;               // пасинг номера тлф при вствке в поле номер телефона
  function CheckPhone(var _errorDescription:string; const p_phone:TEdit):Boolean;                  // проверка номера телефона
  function IsOnlyNumber(ch: Char): Boolean;                                   // проверка только на цифру цифру


implementation

uses
  GlobalVariablesLinkDLL;


// создание Copyright
procedure CreateCopyright;
begin

end;

 // ручной запуск формы
procedure InitManual;
begin
  with FormHome do begin
    ST_Time.Visible:=False;
    st_PhoneInfo.Visible:=True;

    edtPhone.Text:='';
    edtPhone.SetFocus;
    // Ставим курсор в конец текста и убираем выделение
    edtPhone.SelStart := Length(edtPhone.Text);
    edtPhone.SelLength := 0;
  end;
end;

 // автоматический запуск
procedure InitAutoRun;
begin
 with FormHome do begin

 end;
end;


// пасинг номера тлф при вствке в поле номер телефона
function ParsePhoneNumber(const PhoneNumber: string): string;
var
  CleanedNumber: string;
  i: Integer;
begin
  CleanedNumber := '';

  // Проходим по каждому символу в исходной строке
  for i := 1 to Length(PhoneNumber) do
  begin
    // Проверяем, является ли символ цифрой
    if PhoneNumber[i] in ['0'..'9'] then
    begin
      // Добавляем цифру в очищенный номер
      CleanedNumber := CleanedNumber + PhoneNumber[i];
    end;
  end;

  // Проверяем, если номер начинается с "7" и добавляем "8" в начале
  if (Length(CleanedNumber) > 0) and (CleanedNumber[1] = '7') then
  begin
    CleanedNumber := '8' + Copy(CleanedNumber, 2, Length(CleanedNumber) - 1);
  end;

  Result := CleanedNumber;
end;

// проверка только на цифру цифру
function IsOnlyNumber(ch: Char): Boolean;
begin
  Result := (ch in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']);
end;

 // проверка номера телефона
function CheckPhone(var _errorDescription:string;
                    const p_phone:TEdit):Boolean;
var
 phone:string;
 i:Integer;
begin
  Result:=False;
  _errorDescription:='';
  phone:=p_phone.Text;

  if Length(phone) = 0 then begin
   _errorDescription:='Пустой номер телефона';
   Exit;
  end;

  // номер должен начинаться с 8
  if phone[1]<>'8' then begin
   _errorDescription:='Номер телефона "'+phone+'" должен начинаться с 8';
   Exit;
  end;

  // длина
  if (Length(phone)<>11) then begin
   _errorDescription:='Некорректный номер телефона "'+phone+'"'+#13#13+
                      'Длина номера телефона должна быть 11 символов'+#13+'сейчас длина '+IntToStr(Length(phone))+' символов';
    Exit;
  end;

  // проверка что бы были только цифры
  for i:=1 to Length(phone) do begin
    if not IsOnlyNumber(phone[i]) then begin
      _errorDescription:='Номер телефона "'+phone+'" должен содержать только цифры';
       Exit;
    end;
  end;

  Result:=True;
end;


end.
