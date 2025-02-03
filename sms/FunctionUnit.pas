unit FunctionUnit;

interface

uses
FormHomeUnit,
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Win.ComObj,System.StrUtils,math, IdHTTP,
  IdSSL,httpsend,ssl_openssl,IdIOHandlerStack, IdSSLOpenSSL, System.DateUtils,synacode, System.IniFiles,
  Winapi.WinSock;


procedure LoadData(InTypeReport:Word);                                                        // загрузка excel
procedure Log(InText:string;InError:Boolean);                                                 // запись в лог
procedure CurrentPostAddColoredLine(AText:string;AColor: TColor);
procedure ParsingSMSandSend(InSMSList:TStringList;InTypeReport:Word);                         // разбор и отправка смс   { InTypeReport=1 - отчет СМС | InTypeReport=2 - отчет отказнки  }
function GetSMS(inPacientPhone:string):string; overload;                                      // отправка смс v2
function GetSMS(inPacientPhone,inPacientIO,inPacientBirthday,
                inPacientPol,inDataPriema,inTimePriema,inFIOVracha,
                inNapravlenie,inAddress:string):string; overload;                             // отправка смс
function SettingsLoadString(INFILE,INSection,INValue,INValueDefault:string):string;           // загрузка параметров
procedure SettingsSaveString(INFILE,INSection,INValue,INValueDefault:string);                 // сохранение параметров
procedure LoadAuthotization;                                                                  // загрузка параметров авторизации
procedure ErrorParsingLog(InPhoneNumber,InTypeParsing,InFullStackSMSParsing:string);          // отображение ошибки в логе
procedure SmsTypeStyle(InSMSStyle:TSmsStyle);                                                 // выбор типа отправляемого смс
function GetCheckAuth(InSMSStyle:TSmsStyle):string;                                           // проверка на заполненость
procedure PreLoadData(inTypeReport:Word);                                                     // пред загрузка данных об отправке
function GetTimeDiff(InCurrentSec:Integer):string;                                            // время высчитывание примерного времени
function GetSMSStatusID(inPacientPhone:string):string;                                        // проверка смс статуса
procedure LoadMsgMessageOld(InMaxCount:Integer);                                              // прогрузка последних успешных сообщений
function GetExistSaveMessage(InMEssage:string):Boolean;                                       // проверка есть ли уже ранее сохраненное сообщение
procedure AddSaveMessageOld(InMessage:string);                                                // сохранение сообщения
procedure LoadSettingEnterSend;                                                               // отправка смс по нажатию на enter
procedure SaveSettingEnterSend(inBool:Boolean);                                               // сохранение параметров по нажатию на enter
procedure ClearTabs(InTypeStatus:TSmsStyle);                                                  // очистка заполненных полей
function GetCheckNumber(InNumberPhone:string):string;                                         // проверка корректности номера телефона при вводе
procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);                         // парсинг и создание формы инфо статуса сообщения
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;                             // кол-во смс которые были отправлены
procedure ShowInfoMessage(arrMsg: array of TSMSMessage; arrCount:Integer);                    // отображение инфо об отправке
function GetLocalIP: String;                                                                  // функция получения локального IP
function GetComputerNetName: string;                                                          // функция получения имени ПК
function GetCurrentUserName: string;                                                          // получение имени залогиненого пользователя

implementation

uses
  FormMsgPerenosUnit;


// получение имени залогиненого пользователя
function GetCurrentUserName: string;
 const
   cnMaxUserNameLen = 254;
 var
   sUserName: string;
   dwUserNameLen: DWORD;
begin
   dwUserNameLen := cnMaxUserNameLen - 1;
   SetLength(sUserName, cnMaxUserNameLen);
   GetUserName(PChar(sUserName), dwUserNameLen);
   SetLength(sUserName, dwUserNameLen);
   Result:= PChar(sUserName);
end;


// функция получения имени ПК
function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then Result := buffer
  else Result := 'null';
end;

// функция получения локального IP
function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result:='127.0.0.1';

  if WSAStartup(WSVer, wsaData) = 0 then
   begin
    if GetHostName(@Buf, 128) = 0 then
     begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^)
      else Result:='127.0.0.1';
     end;
    WSACleanup;
   end;
end;


// проверка корректности номера телефона при вводе
function GetCheckNumber(InNumberPhone:string):string;
const
 TypeErrorRassilka:string   = 'отправки SMS';
 TypeErrorMsgStatus:string  = 'проверки статуса SMS';
var
 telefon:string;
begin
  telefon:=InNumberPhone;

   if telefon='' then begin
    Result:='ОШИБКА! Пустой номер телефона в первой строке';
    Exit;
   end;

   // номер должен начинаться с 8
   if telefon[1]<>'8' then begin
    Result:='ОШИБКА! Номер телефона '+telefon+' должен начинаться с 8';
    Exit;
   end;

   // длина
   if (Length(telefon)<>11) then begin
    Result:='ОШИБКА! Некорректный номер '+telefon+' для %type_status'+#13#13+
            'Длина номера должна быть 11 символов,'+#13+'сейчас длина '+IntToStr(Length(telefon))+' символов';

    with FormHome do begin
      case PageType.ActivePage.PageIndex of
       0:begin                              // проверка статуса сообщения
         Result:=StringReplace(Result,'%type_status',TypeErrorMsgStatus,[rfReplaceAll]);
       end;
       1:begin                              // ручная отправка
         Result:=StringReplace(Result,'%type_status',TypeErrorRassilka,[rfReplaceAll]);
       end;
       2:begin                              // рассылка
         // ничего не заменяем
       end;
      end;
    end;

    Exit;
   end;

   Result:='OK';
end;


// проверка на заполненость
function GetCheckAuth(InSMSStyle:TSmsStyle):string;
var
 i:Integer;
 preResult:string;
begin

   with FormHome do begin
      if (edtLogin.Text='') and (edtPwd.Text='') then begin
       Result:='ОШИБКА! Не заполнены поля Авторизация';
       Exit;
      end;

      if edtLogin.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле Авторизация.Логин';
       Exit;
      end;

      if edtPwd.Text='' then begin
       Result:='ОШИБКА! Не заполнено поле Авторизация.Пароль';
       Exit;
      end;

     case InSMSStyle of
        MsgStatus:begin
          // проверка номера телефона
          if edtNumbeFromStatus.Text=''  then begin
            Result:='ОШИБКА! Отсутвует номер телефона для проверки статуса отправки';
            Exit;
          end;

          preResult:=GetCheckNumber(edtNumbeFromStatus.Text);

           if AnsiPos('ОШИБКА',preResult)<>0 then begin
             Result:=preResult;
             Exit;
           end;

        end;
        ManualSend: begin
          // есть ли текст сообщения
          if SettingsLoadString(cAUTHconf,'core','msg_perenos','')='' then begin
           Result:='ОШИБКА! Не написан текст СМС сообщения';
           Exit;
          end;

         // проверка телефона
         begin
          if reNumberPhoneList.Lines.Count=0  then begin
              Result:='ОШИБКА! Отсутвует номер телефона для отправки СМС';
              Exit;
          end;

          for i:=0 to reNumberPhoneList.Lines.Count-1 do begin

             preResult:=GetCheckNumber(reNumberPhoneList.Lines[i]);

             if AnsiPos('ОШИБКА',preResult)<>0 then begin
               Result:=preResult;
               Exit;
             end;
          end;

         end;
        end;
        Rassilka: begin
           // загружаем exel для последкующего разбора
           if FileExcelSMS='' then begin
             Result:='ОШИБКА! Не загружен файл отчета';
             Exit;
           end;
        end;
     end;
   end;
end;

// пред загрузка данных об отправке
procedure PreLoadData(inTypeReport:Word);
var
 FormPleaseWait:TForm;
 lblPlease:TLabel;
begin

    // динамическая форма
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='Загрузка отчета';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' Подождите ...';
     lblPlease.Left:=4;
     lblPlease.Top:=5;
     lblPlease.Width:=ClientWidth-10;
     lblPlease.Height:=25;
     lblPlease.Visible:=True;
     lblPlease.Layout:=tlCenter;
     lblPlease.Font.Size:=12;
     lblPlease.Font.Name:='Times New Roman';
     lblPlease.Parent:=FormPleaseWait;
     Show;
     Application.ProcessMessages;
   end;

   with FormHome do begin
       SLSMS.Clear;
       // загружаем файл с рассылкой
       LoadData(inTypeReport);
   end;

    FormPleaseWait.Free;
end;

// выбор типа отправляемого смс
procedure SmsTypeStyle(InSMSStyle:TSmsStyle);
begin
  with FormHome do begin
   case InSMSStyle of
      ManualSend: begin
       btnSendSMS.Caption:='Отправить SMS';
       lblProgressBar.Caption:='Статус отправки';
      end;
      Rassilka: begin
       btnSendSMS.Caption:='Отправить SMS рассылку';
       lblProgressBar.Caption:='Статус отправки';
      end;
      MsgStatus:begin
       lblMsgStatusInfo.Caption:=StringReplace(lblMsgStatusInfo.Caption,'%current_date',DateToStr(Now-4),[rfReplaceAll]);
       lblMsgStatusInfo.Caption:=StringReplace(lblMsgStatusInfo.Caption,'%now_date',DateToStr(Now),[rfReplaceAll]);

       btnSendSMS.Caption:='Проверка статуса';
       lblProgressBar.Caption:='Поиск сообщений';
      end;
   end;
  end;
end;


// очистка заполненных полей
procedure ClearTabs(InTypeStatus:TSmsStyle);
begin
  with FormHome do begin
    case InTypeStatus of
      ManualSend:begin
        reNumberPhoneList.Lines.Clear;
      end;
      Rassilka:begin
        edtExcelSMS.Text:='';
        edtExcelSMS2.Text:='';

       if SLSMS.Count<>0 then SLSMS.Clear;
      end;
      MsgStatus:begin
         edtNumbeFromStatus.Text:='';
      end;
    end;
  end;
end;

// сохранение параметров
procedure SettingsSaveString(INFILE,INSection,INValue,INValueDefault:string);
var
SettingsConf:TIniFile;
begin
 try
   SettingsConf:=TIniFile.Create(ParsingDirectory+'/'+INFILE);
   SettingsConf.WriteString(INSection,INValue,INValueDefault);
 finally
   if SettingsConf<>nil then FreeAndNil(SettingsConf);
 end;

end;

// загрузка параметров
function SettingsLoadString(INFILE,INSection,INValue,INValueDefault:string):string;
var
  SettingsConf: TIniFile;
begin
   SettingsConf:=TIniFile.Create(ParsingDirectory+'/'+INFILE);
    with SettingsConf do begin
       Result:=ReadString(INSection,INValue,INValueDefault);
       Free;
    end;
end;


procedure CurrentPostAddColoredLine(AText:string;AColor: TColor);
 var
 Error:Boolean;
begin
  with FormHome.RELog do
  begin
    SelStart:= Length(Text);
    SelAttributes.Color:=AColor;
    SelAttributes.Size:=10;
    SelAttributes.Name:='Times New Roman';
    Lines.Add(DateTimeToStr(Now)+' '+AText);
    Perform(EM_LINESCROLL,0,Lines.Count-1);
    SetFocus;
  end;


  // есть или нет ошибки
  if AColor=clRed then Log(AText,True)
  else Log(AText,False);
end;

  // загрузка счета
procedure LoadData(InTypeReport:Word);  { InTypeReport=1 - отчет СМС | InTypeReport=2 - отчет отказнки  }
var
 WorkSheet,Excel:OLEVariant;
 Rows, Cols, i:integer;
 FData: OLEVariant;


 stopRows:string;

 RowsAdd:Boolean; // подгружаем строки

 PacientPhone,PacientIO,PacientBirthday,PacientPol,DataPriema,TimePriema,
 FIOVracha,Napravlenie,Address:string;

 tmpOstatok:string;

begin
    CurrentPostAddColoredLine('Загрузка отчета',clBlack);

    RowsAdd:=False;

    Excel:=CreateOleObject('Excel.Application');
    Excel.displayAlerts:=False;
    Excel.workbooks.add;

      //открываем книгу
    Excel.Workbooks.Open(FileExcelSMS);
    //получаем активный лист
    WorkSheet:=Excel.ActiveWorkbook.ActiveSheet;
    //определяем количество строк и столбцов таблицы
    Rows:=WorkSheet.UsedRange.Rows.Count;
    Cols:=WorkSheet.UsedRange.Columns.Count;

    //считываем данные всего диапазона
    try
     FData:=WorkSheet.UsedRange.Value;
    except on E:Exception do
            begin
              MessageBox(FormHome.Handle,PChar('ОШИБКА! Не удалось загрузить файл в память'+#13#13+
                                               e.ClassName+': '+e.Message),PChar('Ошибка'),MB_OK+MB_ICONERROR);

              Excel.quit;
              Exit;
            end;
    end;


   with FormHome do begin
      // смотримм нужны ли формат

     case InTypeReport of
      1:begin
        if (FData[1,1]='PCODE')       and
           (FData[1,2]='PHONE')       and
           (FData[1,3]='LASTNAME')    and
           (FData[1,4]='IO')          and
           (FData[1,5]='BDATE')       and
           (FData[1,6]='POL')         and
           (FData[1,7]='WORKDATE')    and
           (FData[1,8]='TIMES')       and
           (FData[1,9]='DNAME')       and
           (FData[1,10]='DEPNAME')    and
           (FData[1,11]='F_FILID')    and
           (FData[1,12]='F_SHORTADDR')
        then RowsAdd:=True
        else RowsAdd:=False;


        if RowsAdd=False then begin
           Excel.quit;

           CurrentPostAddColoredLine('ОШИБКА ЗАГРУЗКИ! Некорректный формат отчета',clRed);

           Application.ProcessMessages;

           MessageBox(Handle,PChar('Некорректный формат отчета'+#13#13+
                                   'Формат должен включать следуюшие столбцы:'+#13+
                                   '1. PCODE'+#13+
                                   '2. PHONE'+#13+
                                   '3. LASTNAME'+#13+
                                   '4. IO'+#13+
                                   '5. BDATE'+#13+
                                   '6. POL'+#13+
                                   '7. WORKDATE'+#13+
                                   '8. TIMES'+#13+
                                   '9. DNAME'+#13+
                                   '10.DEPNAME'+#13+
                                   '11.F_FILID'+#13+
                                   '12.F_SHORTADDR'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
           // очищаем строку с отчетом
          FileExcelSMS:='';
          edtExcelSMS.Text:='';

          SLSMS.Clear;
          Exit;
        end;
      end;
      2:begin
        if (FData[1,1]='PCODE')         and
           (FData[1,2]='PHONE1')        and
           (FData[1,3]='PHONE2')        and
           (FData[1,4]='PHONE3')        and
           (FData[1,5]='LASTNAME')      and
           (FData[1,6]='IO')            and
           (FData[1,7]='BDATE')         and
           (FData[1,8]='POL')           and
           (FData[1,9]='WORKDATE')      and
           (FData[1,10]='TIMES')        and
           (FData[1,11]='DNAME')        and
           (FData[1,12]='DEPNAME')      and
           (FData[1,13]='F_FILID')      and
           (FData[1,14]='F_SHORTADDR')  and
           (FData[1,15]='DOPINFO')      and
           (FData[1,16]='PHONE')
        then RowsAdd:=True
        else RowsAdd:=False;


        if RowsAdd=False then begin
           Excel.quit;

           CurrentPostAddColoredLine('ОШИБКА ЗАГРУЗКИ! Некорректный формат отчета',clRed);

           Application.ProcessMessages;

           MessageBox(Handle,PChar('Некорректный формат отчета'+#13#13+
                                   'Формат должен включать следуюшие столбцы:'+#13+
                                   '1. PCODE'+#13+
                                   '2. PHONE1'+#13+
                                   '3. PHONE2'+#13+
                                   '4. PHONE3'+#13+
                                   '5. LASTNAME'+#13+
                                   '6. IO'+#13+
                                   '7. POL'+#13+
                                   '8. TIMES'+#13+
                                   '9. WORKDATE'+#13+
                                   '10.TIMES'+#13+
                                   '11.DNAME'+#13+
                                   '12.DEPNAME'+#13+
                                   '13.F_FILID'+#13+
                                   '14.F_SHORTADDR'+#13+
                                   '15.DOPINFO'+#13+
                                   '16.PHONE'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
           // очищаем строку с отчетом
          FileExcelSMS:='';
          edtExcelSMS.Text:='';

          SLSMS.Clear;
          Exit;
        end;

      end;
     end;



    //выводим данные в таблицу
     RowsAdd:=False;
     for i:=1 to Rows do
     begin

       // поиск нужных строк
       case InTypeReport of
        1: begin
          if RowsAdd=False then begin
            if (FData[i,1]='PCODE')     and
               (FData[i,2]='PHONE')     and
               (FData[i,3]='LASTNAME')  and
               (FData[i,4]='IO') then
            begin
             RowsAdd:=True;
             Continue;
            end;
          end;

         PacientPhone:=FData[i,2];
         PacientIO:=FData[i,4];
         PacientBirthday:=FData[i,5];
         PacientPol:=FData[i,6];
         DataPriema:=FData[i,7];
         TimePriema:=FData[i,8];
         FIOVracha:=FData[i,9];
         Napravlenie:=FData[i,10];
         Address:=FData[i,12];


        end;
        2:begin
          if RowsAdd=False then begin
            if (FData[i,1]='PCODE')     and
               (FData[i,2]='PHONE1')    and
               (FData[i,3]='PHONE2')    and
               (FData[i,4]='PHONE3')    and
               (FData[i,5]='LASTNAME')  and
               (FData[i,9]='WORKDATE')  and
               (FData[i,14]='F_SHORTADDR') then
            begin
             RowsAdd:=True;
             Continue;
            end;
          end;


         PacientPhone:=FData[i,16];
         PacientIO:=FData[i,6];
         PacientBirthday:=FData[i,7];
         PacientPol:=FData[i,8];
         DataPriema:=FData[i,9];
         TimePriema:=FData[i,10];
         FIOVracha:=FData[i,11];
         Napravlenie:=FData[i,12];
         Address:=FData[i,14];
        end;
       end;

      begin
        // заносим в память
        SLSMS.Add(PacientPhone+';'+
                  PacientIO+';'+
                  PacientBirthday+';'+
                  PacientPol+';'+
                  DataPriema+';'+
                  TimePriema+';'+
                  FIOVracha+';'+
                  Napravlenie+';'+
                  Address);
      end;

     end;
   end;

  Excel.quit;
  CurrentPostAddColoredLine('Отчет загружен',clBlack);
  CurrentPostAddColoredLine('Кол-во сообщений на отправку: '+IntToStr(SLSMS.Count), clGreen);
  CurrentPostAddColoredLine('Примерное время на отправку всех СМС: '+GetTimeDiff(SLSMS.Count), clRed);


  Application.ProcessMessages;
end;


// запись в лог
procedure Log(InText:string;InError:Boolean);
var
 SLSave:TStringList;
 CurrentDateTime,DateTimeNow:string;
 TextStyle,TextColor,TextFont,TextSize:string;

 Color: TColor;
 R,G,B: Byte;
 i:Integer;

 user:string;
begin
 SLSave:=TStringList.Create;
 CurrentDateTime:=FormatDateTime('ddmmyyyy',Now);
 DateTimeNow:=DateTimeToStr(Now);

 TextFont:='Times New Roman';

 TextSize:='3';
 if InError=False then TextColor:='0'
 else TextColor:='262331';
 Color:=ColorToRGB(StrToInt(TextColor));

 user:='['+currentUser.getUserName+' | '+currentUser.getIP+'] ';

 // переводим в HEX
 TextColor:=IntToHex(GetRValue(Color),2)+IntToHex(GetGValue(Color),2)+IntToHex(GetBValue(Color),2);

 if not DirectoryExists(ParsingDirectory+'log') then CreateDir(ParsingDirectory+'log');

 if not FileExists(ParsingDirectory+'log\'+CurrentDateTime+cLOG_EXTENSION) then begin
  if InText<>'<hr>' then SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+user+DateTimeNow+' '+InText+'</font><br>')
  else SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+InText+'</font><br>');


  try
    SLSave.SaveToFile(ParsingDirectory+'log\'+CurrentDateTime+cLOG_EXTENSION);
  finally
    // ничего не делаем продолжаем
  end;
 end
 else begin
  SLSave.LoadFromFile(ParsingDirectory+'log\'+CurrentDateTime+cLOG_EXTENSION);

  if InText<>'<hr>' then SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+user+DateTimeNow+' '+InText+'</font><br>')
  else SLSave.Insert(0, '<font color="'+TextColor+'"'+' size="'+TextSize+'"'+' face="'+TextFont+'">'+InText+'</font><br>');


  try
   SLSave.SaveToFile(ParsingDirectory+'log\'+CurrentDateTime+cLOG_EXTENSION);
  finally
   // ничего не делаем продолжаем
  end;
 end;

 if SLSave<>nil then FreeAndNil(SLSave);
end;


// отправка смс
function GetSMS(inPacientPhone,inPacientIO,inPacientBirthday,inPacientPol,
                inDataPriema,inTimePriema,inFIOVracha,inNapravlenie,inAddress:string):string; overload;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;

 Child:Boolean; // TRUE - ребенок | FALSE - взрослый

 Age:int64;

 MessageSMS:string;
 HTTPGet:string;
begin

 if global_DEBUG then inPacientPhone:='89275052333';

 // разберем текст
 (*  begin
     // ребенок или взрослый
     begin
      Age:=0;
      Child:=False;

      Age:=DateTimeToUnix(Now)-DateTimeToUnix(StrToDateTime(inPacientBirthday));
      if Age>=cAGELIMIT18 then Child:=False
      else Child:=True;
     end;


    if Child=False then begin  { Сообщение если взрослый }
     MessageSMS:=cMESSAGEBefor18;


     MessageSMS:=StringReplace(MessageSMS,'%FIO_Pacienta',inPacientIO,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%FIO_Doctora',inFIOVracha,[rfReplaceAll]);
    // MessageSMS:=StringReplace(MessageSMS,'%Napravlenie',inNapravlenie,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Data',inDataPriema,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Time',inTimePriema,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Address',inAddress,[rfReplaceAll]);

    end
    else begin                 { Сообщение если ребенок }
     MessageSMS:=cMESSAGEAfter18;
     MessageSMS:=StringReplace(MessageSMS,'%FIO_Pacienta',inPacientIO,[rfReplaceAll]);
     if inPacientPol='м' then MessageSMS:=StringReplace(MessageSMS,'%записан(а)','записан',[rfReplaceAll])
     else MessageSMS:=StringReplace(MessageSMS,'%записан(а)','записана',[rfReplaceAll]);

     MessageSMS:=StringReplace(MessageSMS,'%FIO_Doctora',inFIOVracha,[rfReplaceAll]);
    // MessageSMS:=StringReplace(MessageSMS,'%Napravlenie',inNapravlenie,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Data',inDataPriema,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Time',inTimePriema,[rfReplaceAll]);
     MessageSMS:=StringReplace(MessageSMS,'%Address',inAddress,[rfReplaceAll]);
    end;
   end;  *)

 // нет градации ребенок или взрослый
  begin
   MessageSMS:=cMESSAGE;

   MessageSMS:=StringReplace(MessageSMS,'%FIO_Pacienta',inPacientIO,[rfReplaceAll]);
   if inPacientPol='м' then MessageSMS:=StringReplace(MessageSMS,'%записан(а)','записан',[rfReplaceAll])
   else MessageSMS:=StringReplace(MessageSMS,'%записан(а)','записана',[rfReplaceAll]);

   MessageSMS:=StringReplace(MessageSMS,'%FIO_Doctora',inFIOVracha,[rfReplaceAll]);
  // MessageSMS:=StringReplace(MessageSMS,'%Napravlenie',inNapravlenie,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Data',inDataPriema,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Time',inTimePriema,[rfReplaceAll]);
   MessageSMS:=StringReplace(MessageSMS,'%Address',inAddress,[rfReplaceAll]);
  end;


  // формируем ссылку на отправку
  begin
   HTTPGet:=cWebApiSMS;
    {
   cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
   }

   with FormHome do begin
    HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', EncodeURL(AnsiToUtf8(MessageSMS)),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%PHONENUMBER',inPacientPhone,[rfReplaceAll]);
   end;
  end;

   http:=TIdHTTP.Create(nil);

    begin
     ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
     ssl.SSLOptions.Method:=sslvTLSv1_2;
     ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
    end;

  with http do begin
    IOHandler:=ssl;
    Request.CustomHeaders.Add(CustomHeaders0);
    Request.UserAgent:=CustomUserAgent;
    Request.CustomHeaders.Add(CustomHeaders2);
    Request.CustomHeaders.Add(CustomHeaders3);
    Request.CustomHeaders.Add(CustomHeaders4);

     try
       if global_DEBUG=False then ServerOtvet:=Get(HTTPGet)
       else ServerOtvet:='OK';
     except on E: EIdHTTPProtocolException do
        begin
         Result:='ОШИБКА ОТПРАВКИ! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    Result:='OK';
    Log(MessageSMS,False);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;
end;


// отправка смс v2
function GetSMS(inPacientPhone:string):string; overload;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;

 MessageSMS:string;
 HTTPGet:string;
begin

 if global_DEBUG then inPacientPhone:='89275052333';

 MessageSMS:=SettingsLoadString(cAUTHconf,'core','msg_perenos','');

  // формируем ссылку на отправку
  begin
   HTTPGet:=cWebApiSMS;
    {
   cWebApiSMS:string='https://a2p-sms-https.beeline.ru/proto/http/?user=%USERNAME&pass=%USERPWD&action=post_sms&message=%MESSAGE&target=%PHONENUMBER';
   }

   with FormHome do begin
    HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
  //  HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', MessageSMS,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', EncodeURL(AnsiToUtf8(MessageSMS)),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%PHONENUMBER',inPacientPhone,[rfReplaceAll]);
   end;
  end;

   http:=TIdHTTP.Create(nil);

    begin
     ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
     ssl.SSLOptions.Method:=sslvTLSv1_2;
     ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
    end;

  with http do begin
    IOHandler:=ssl;
    Request.CustomHeaders.Add(CustomHeaders0);
    Request.UserAgent:=CustomUserAgent;
    Request.CustomHeaders.Add(CustomHeaders2);
    Request.CustomHeaders.Add(CustomHeaders3);
    Request.CustomHeaders.Add(CustomHeaders4);

     try
       if global_DEBUG=False then ServerOtvet:=Get(HTTPGet)
       else ServerOtvet:='OK';
     except on E: EIdHTTPProtocolException do
        begin
         Result:='ОШИБКА ОТПРАВКИ! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    Result:='OK';
    Log(MessageSMS,False);

    // сохраняем последнее отправленное сообщение для истории и типа для формирования шаблонов сообщений
    AddSaveMessageOld(MessageSMS);

    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   Sleep(500);
end;


// отображение инфо об отправке
procedure ShowInfoMessage(arrMsg: array of TSMSMessage; arrCount:Integer);
var
  SLMsg:TStringList;
  i:Integer;
begin

  SLMsg:=TStringList.Create;

  for i:=0 to arrCount-1 do begin
    SLMsg.Add('Время: '+DateToStr(arrMsg[i].getDate)+' '+TimeToStr(arrMsg[i].getTime));
    SLMsg.Add('Номер телефона: '+arrMsg[i].getPhone);
    SLMsg.Add('Статус сообщения: '+arrMsg[i].getCode+' ('+arrMsg[i].getStatus+')');
    SLMsg.Add('');
    SLMsg.Add('Текст сообщения: '+arrMsg[i].getMsg);
    SLMsg.Add(' ================================================================= ');
    SLMsg.Add('');
    SLMsg.Add('');
  end;

  ShowMessage(SLMsg.Text);

  if SLMsg<> nil then FreeAndNil(SLMsg);
end;

// кол-во смс которые были отправлены
function GetMsgCount(ResultServer,inPacientPhone:string):Integer;
var
  count: integer;
  sCount:Integer;
begin
  count:=0;
  sCount:=0;

  count:=PosEx(inPacientPhone, ResultServer, 1);
   while count<>0 do
   begin
      inc(sCount);
      count:=PosEx(inPacientPhone, ResultServer, count+length(inPacientPhone));
   end;

   Result:=sCount;
end;


// парсинг и создание формы инфо статуса сообщения
procedure ParsingResultStatusSMS(ResultServer,inPacientPhone:string);
const
  MSGSTART:string = '<MESSAGES>';
  MSGSTOP:string  = '</MESSAGE>';

  var
  numberPhoneCount:Integer;
  listMsg:array of TSMSMessage;
  i:Integer;
  tmp:string;

  oldLenghtResult:Integer;

  FormPleaseWait:TForm;
  lblPlease:TLabel;

  // разобранное сообщение
  SMS_ID: string;     // ID sms
  CreatDate: string;    // дата когда было создано сообщение
  CreatTime: string;    // время когда было создано сообщение
  MsgText: string;     // текст сообщения
  Code: string;        // код смс
  Status: string;      // статус смс

  nowbreak:Int64;

begin
  (*
   // динамическая форма
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='Разбор запроса';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' Подождите ...';
     lblPlease.Left:=4;
     lblPlease.Top:=5;
     lblPlease.Width:=ClientWidth-10;
     lblPlease.Height:=25;
     lblPlease.Visible:=True;
     lblPlease.Layout:=tlCenter;
     lblPlease.Font.Size:=12;
     lblPlease.Font.Name:='Times New Roman';
     lblPlease.Parent:=FormPleaseWait;
     Show;
     Application.ProcessMessages;
   end;
    *)

 // поменяем 8 -> 7
 inPacientPhone[1]:='7';
 numberPhoneCount:=GetMsgCount(ResultServer,inPacientPhone);

 nowbreak:=Length(ResultServer);

 // создадтим динамический массивчик сообщений
 if numberPhoneCount=0 then begin
  // FormPleaseWait.Free;

   MessageBox(FormHome.Handle,PChar('За период с '+DateToStr(Now-4)+' по '+DateToStr(Now)+' отсутствуют отправленные SMS'),PChar('Информация'),MB_OK+MB_ICONSTOP);
   Exit;
 end;

 SetLength(listMsg,numberPhoneCount);
 for i:=0 to numberPhoneCount-1 do listMsg[i]:=TSMSMessage.Create;
 i:=0;

 oldLenghtResult:=Length(ResultServer);

 // парсим для последующего создания человеческой формы
 while(AnsiPos(MSGSTOP,ResultServer))<> 0 do begin

   FormHome.ProgressBar.Progress:=100-(Round(100*Length(ResultServer)/oldLenghtResult));
   Application.ProcessMessages;

   tmp:=ResultServer;

   // найдем начало и конец сообщения
   System.Delete(tmp,1,AnsiPos(MSGSTART,tmp)+Length(MSGSTART));
   System.Delete(tmp,AnsiPos(MSGSTOP,tmp),Length(tmp));

   // разбираем
   if AnsiPos(inPacientPhone,tmp)<>0 then begin

      if i<numberPhoneCount then listMsg[i].Phone:=inPacientPhone;

      //ShowMessage(IntToStr(100-(Round(100*Length(ResultServer)/oldLenghtResult))));

      SMS_ID:=tmp;
      System.Delete(SMS_ID,1,AnsiPos('"',SMS_ID));
      System.Delete(SMS_ID,AnsiPos('"',SMS_ID),Length(SMS_ID));
      if i<numberPhoneCount then listMsg[i].SMS_ID:=SMS_ID;

      CreatDate:=tmp;
      System.Delete(CreatDate,1,AnsiPos('<CREATED>',CreatDate)+Length('<CREATED>')-1);
      System.Delete(CreatDate,AnsiPos(' ',CreatDate),Length(CreatDate));
      if i<numberPhoneCount then listMsg[i].CreatDate:=StrToDate(CreatDate);

      CreatTime:=tmp;
      System.Delete(CreatTime,1,AnsiPos('<CREATED>',CreatTime)+Length('<CREATED>')-1);
      System.Delete(CreatTime,1,AnsiPos(' ',CreatTime));
      System.Delete(CreatTime,AnsiPos('<',CreatTime),Length(CreatTime));
      if i<numberPhoneCount then listMsg[i].CreatTime:=StrToTime(CreatTime);

      MsgText:=tmp;
      System.Delete(MsgText,1,AnsiPos('[CDATA[',MsgText)+Length('[CDATA[')-1);
      System.Delete(MsgText,AnsiPos(']]></SMS_TEXT>',MsgText),Length(MsgText));
      if i<numberPhoneCount then listMsg[i].MsgText:=MsgText;

      Code:=tmp;
      System.Delete(Code,1,AnsiPos('<SMSSTC_CODE>',Code)+Length('<SMSSTC_CODE>')-1);
      System.Delete(Code,AnsiPos('</SMSSTC_CODE>',Code),Length(Code));
      if i<numberPhoneCount then listMsg[i].Code:=Code;

      Status:=tmp;
      System.Delete(Status,1,AnsiPos('<SMS_STATUS>',Status)+Length('<SMS_STATUS>')-1);
      System.Delete(Status,AnsiPos('</SMS_STATUS>',Status),Length(Status));
      if i<numberPhoneCount then listMsg[i].Status:=Status;

      Inc(i);
   end;

   // следующий разбор
    System.Delete(ResultServer,1,AnsiPos(MSGSTOP,ResultServer));

   Dec(nowbreak,1);
   if nowbreak=0 then begin
    // FormPleaseWait.Free;
     MessageBox(FormHome.Handle,PChar('Превышено время отведенное для разбора запроса'),PChar('Runtime Error'),MB_OK+MB_ICONERROR);
     Exit;
   end;

 end;

  FormHome.ProgressBar.Progress:=0;

  //отображаем найденное
  if numberPhoneCount<>0 then ShowInfoMessage(listMsg,numberPhoneCount);


  //FormPleaseWait.Free;
end;

// проверка смс статуса
function GetSMSStatusID(inPacientPhone:string):string;
var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet:string;

 FormPleaseWait:TForm;
 lblPlease:TLabel;
begin

   // динамическая форма
   FormPleaseWait:=TForm.Create(Application);
   lblPlease:=TLabel.Create(FormPleaseWait);

   with FormPleaseWait do begin
     Caption:='Отправка запроса';
     BorderStyle:=bsSizeable;
     ClientWidth:=280;
     ClientHeight:=35;
     Position:=poScreenCenter;
     WindowState:=wsNormal;
     BorderIcons:=[];
     lblPlease.Caption:=' Подождите ...';
     lblPlease.Left:=4;
     lblPlease.Top:=5;
     lblPlease.Width:=ClientWidth-10;
     lblPlease.Height:=25;
     lblPlease.Visible:=True;
     lblPlease.Layout:=tlCenter;
     lblPlease.Font.Size:=12;
     lblPlease.Font.Name:='Times New Roman';
     lblPlease.Parent:=FormPleaseWait;
     Show;
     Application.ProcessMessages;
   end;


  // формируем ссылку на отправку
  begin
   HTTPGet:=cWebApiSMSstatusID;

   with FormHome do begin
    HTTPGet:=StringReplace(HTTPGet,'%USERNAME',edtLogin.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%USERPWD',edtPwd.Text,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%DATE_START',DateToStr(Now-4),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%DATE_STOP',DateToStr(Now),[rfReplaceAll]);
   end;
  end;

   http:=TIdHTTP.Create(nil);

    begin
     ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
     ssl.SSLOptions.Method:=sslvTLSv1_2;
     ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
    end;

  with http do begin
    IOHandler:=ssl;
    Request.CustomHeaders.Add(CustomHeaders0);
    Request.UserAgent:=CustomUserAgent;
    Request.CustomHeaders.Add(CustomHeaders2);
    Request.CustomHeaders.Add(CustomHeaders3);
    Request.CustomHeaders.Add(CustomHeaders4);

     try
       ServerOtvet:=Get(HTTPGet);
     except on E: EIdHTTPProtocolException do
        begin
         FormPleaseWait.Free;

         Result:='ОШИБКА ОТПРАВКИ! '+e.Message+' / '+e.ErrorMessage;
         if ssl<>nil then FreeAndNil(ssl);
         if http<>nil then FreeAndNil(http);
         Exit;
        end;
     end;
  end;

   begin
    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
   end;

   FormPleaseWait.Free;

  // парсим и создаем форму
  ParsingResultStatusSMS(ServerOtvet,inPacientPhone);
end;

// разбор и отправка смс
procedure ParsingSMSandSend(InSMSList:TStringList;InTypeReport:Word);   { InTypeReport=1 - отчет СМС | InTypeReport=2 - отчет отказнки  }
var
 i,j:Integer;

 PacientPhonetmp:string;
 PacientPhone,PacientIO,PacientBirthday,PacientPol,DataPriema,TimePriema,
 FIOVracha,Napravlenie,Address:string;

 SMSResult:string;

begin
  for i:=0 to InSMSList.Count-1 do begin
    PacientPhone:='';
    PacientIO:='';
    PacientBirthday:='';
    PacientPol:='';
    DataPriema:='';
    TimePriema:='';
    FIOVracha:='';
    Napravlenie:='';
    Address:='';

    with FormHome do begin
     ProgressBar.Progress:=Round(100*i/InSMSList.Count-1);
     lblProgressBar.Caption:=IntToStr(i+1)+' из '+IntToStr(InSMSList.Count);
     Application.ProcessMessages;
    end;

    // разбираем
    PacientPhone:=InSMSList[i];
    System.Delete(PacientPhone,AnsiPos(';',PacientPhone),Length(PacientPhone));
    PacientPhonetmp:=PacientPhone;

    // проверим чтобы лишнего ничего не было (PacientPhone)
    begin
     if AnsiPos(' ',PacientPhone)<>0 then begin
      // присутствует пробел
      CurrentPostAddColoredLine('НАЙДЕНА ОШИБКА! В номере телефона "'+PacientPhone+'" присутствует пробел',clRed);
      PacientPhone:=StringReplace(PacientPhone,' ','',[rfReplaceAll]);
     end;

     // проверим чтобы номер телефона был только сотовым
     case InTypeReport of
      1:begin
       if AnsiPos('(9',PacientPhone)=0 then begin
        // номер телефона не сотовый
        CurrentPostAddColoredLine('НАЙДЕНА ОШИБКА! Номер телефона "'+PacientPhone+'" не мобильный, пропуск данной записи',clRed);

        // занесем данную ошибку в список
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('Номер телефона не мобильный >> '+InSMSList[i]);
        end;

        Continue;
       end;

       // разберем до состояния привет как охуенно ))
       PacientPhone:=StringReplace(PacientPhone,'(','',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,')','',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,'+7','8',[rfReplaceAll]);
       PacientPhone:=StringReplace(PacientPhone,'-','',[rfReplaceAll]);

      end;
      2:begin
       if (PacientPhone[1]<>'7') and (PacientPhone[2]<>'9') then begin
        // номер телефона не сотовый
        CurrentPostAddColoredLine('НАЙДЕНА ОШИБКА! Номер телефона "'+PacientPhone+'" не мобильный, пропуск данной записи',clRed);

        // занесем данную ошибку в список
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('Номер телефона не мобильный >> '+InSMSList[i]);
        end;

        Continue;
       end;
       // разберем до состояния привет как охуенно ))
       PacientPhone[1]:='8';
      end;
     end;


     // последняя проверка, чтобы длинна былав не меньше и не больше 11 символов
     if Length(PacientPhone)<>11  then begin
      CurrentPostAddColoredLine('НАЙДЕНА ОШИБКА! Не удалось корректно распознать номер телефона "'+PacientPhonetmp+'", пропуск данной записи',clRed);

       with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add('Номер телефона не мобильный >> '+InSMSList[i]);
       end;

       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (PacientIO)
    begin
      PacientIO:=InSMSList[i];
      for j:=1 to 1 do System.Delete(PacientIO,1,AnsiPos(';',PacientIO));
      System.Delete(PacientIO,AnsiPos(';',PacientIO),Length(PacientIO));

      if PacientIO='' then begin
       ErrorParsingLog(PacientPhone,'Имя Отчество',InSMSList[i]);
       Continue;
      end;

    end;

    // проверим чтобы лишнего ничего не было (PacientBirthday)
    begin
      PacientBirthday:=InSMSList[i];
      for j:=1 to 2 do System.Delete(PacientBirthday,1,AnsiPos(';',PacientBirthday));
      System.Delete(PacientBirthday,AnsiPos(';',PacientBirthday),Length(PacientBirthday));

      if PacientBirthday='' then begin
       ErrorParsingLog(PacientPhone,'Дата рождения',InSMSList[i]);
       Continue;
      end;

    end;


    // проверим чтобы лишнего ничего не было (PacientPol)
    begin
      PacientPol:=InSMSList[i];
      for j:=1 to 3 do System.Delete(PacientPol,1,AnsiPos(';',PacientPol));
      System.Delete(PacientPol,AnsiPos(';',PacientPol),Length(PacientPol));

     if PacientPol='' then begin
       ErrorParsingLog(PacientPhone,'Пол',InSMSList[i]);
       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (DataPriema)
    begin
      DataPriema:=InSMSList[i];
      for j:=1 to 4 do System.Delete(DataPriema,1,AnsiPos(';',DataPriema));
      System.Delete(DataPriema,AnsiPos(';',DataPriema),Length(DataPriema));

     if DataPriema='' then begin
       ErrorParsingLog(PacientPhone,'Дата приема',InSMSList[i]);
       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (TimePriema)
    begin
      TimePriema:=InSMSList[i];
      for j:=1 to 5 do System.Delete(TimePriema,1,AnsiPos(';',TimePriema));
      System.Delete(TimePriema,AnsiPos(';',TimePriema),Length(TimePriema));

     if TimePriema='' then begin
       ErrorParsingLog(PacientPhone,'Время приема',InSMSList[i]);
       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (FIOVracha)
    begin
      FIOVracha:=InSMSList[i];
      for j:=1 to 6 do System.Delete(FIOVracha,1,AnsiPos(';',FIOVracha));
      System.Delete(FIOVracha,AnsiPos(';',FIOVracha),Length(FIOVracha));

     if FIOVracha='' then begin
       ErrorParsingLog(PacientPhone,'ФИО врача',InSMSList[i]);
       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (Napravlenie)
    begin
      Napravlenie:=InSMSList[i];
      for j:=1 to 7 do System.Delete(Napravlenie,1,AnsiPos(';',Napravlenie));
      System.Delete(Napravlenie,AnsiPos(';',Napravlenie),Length(Napravlenie));
      // Переведем в человеческий вид, чтобы все было не капсом
     Napravlenie:=AnsiLowerCase(Napravlenie);

     if Napravlenie='' then begin
       ErrorParsingLog(PacientPhone,'Направление',InSMSList[i]);
       Continue;
     end;
    end;

    // проверим чтобы лишнего ничего не было (Address)
    begin
      Address:=InSMSList[i];
      for j:=1 to 8 do System.Delete(Address,1,AnsiPos(';',Address));

     // if Address='' then Address:=cTempAddrClinika;

     if Address='' then begin
        CurrentPostAddColoredLine('НАЙДЕНА ОШИБКА! Адрес клиники "пустой", пропуск данной записи',clRed);

        // занесем данную ошибку в список
        with FormHome do begin
          ParsingError:=True;
          SLParsingError.Add('Пустой адрес клиники >> '+InSMSList[i]);
        end;

        Continue;
     end;

     // проверим есть ли в строке г.
     if (AnsiPos('г.',Address)=0) then Address:='г. '+Address;
    end;


    // отправляем смс
   try
    SMSResult:=GetSMS(PacientPhone,
                      PacientIO,
                      PacientBirthday,
                      PacientPol,
                      DataPriema,
                      TimePriema,
                      FIOVracha,
                      Napravlenie,
                      Address);

   except on E:Exception do
    begin
       CurrentPostAddColoredLine('ОШИБКА! Не удалось отправить СМС на номер "'+PacientPhonetmp+'" , '+e.ClassName+': '+e.Message,clRed);

       with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add(InSMSList[i]);
       end;

      SMSResult:=SMSResult+' '+e.Message;
      Continue;
    end;
   end;

   if SMSResult='OK' then begin
      if global_DEBUG=False then CurrentPostAddColoredLine('Отправлено СМС на номер "'+PacientPhonetmp+'"',clGreen)
      else CurrentPostAddColoredLine('DEBUG. Виртуально отправлено СМС на номер "'+PacientPhonetmp+'"',clGreen)
   end
   else begin
     CurrentPostAddColoredLine(SMSResult+'. Номер телефона на который не удалось отправить СМС "'+PacientPhonetmp+'"',clRed);

      with FormHome do begin
        ParsingError:=True;
        SLParsingError.Add(InSMSList[i]);
      end;
   end;

   Sleep(cSLEEPNEXTSMS);
  end;

//  ShowMessage(FormHome.SLParsingError.Text);
end;


// загрузка параметров авторизации
procedure LoadAuthotization;
begin
 if FileExists(ParsingDirectory+cAUTHconf)=False then begin
   with FormHome do begin
    lblLogin.Visible:=True;
    lblPwd.Visible:=True;

    PanelAuthEdit.Visible:=False;
   end;
    Exit;
 end;



 // прогружаем параметры
 with FormHome do begin
   edtLogin.Text:=SettingsLoadString(cAUTHconf,'core','usr','');
   edtPwd.Text:=SettingsLoadString(cAUTHconf,'core','pwd','');
 end;
end;


// отправка смс по нажатию на enter
procedure LoadSettingEnterSend;
begin
 with FormHome do begin
    if SettingsLoadString(cAUTHconf,'core','send_enter','true')='true' then chkEnter.Checked:=True
    else chkEnter.Checked:=False;
 end;
end;


// сохранение параметров по нажатию на enter
procedure SaveSettingEnterSend(inBool:Boolean);
begin
 case inBool of
  False: begin
     SettingsSaveString(cAUTHconf,'core','send_enter','false');
  end;
  True: begin
     SettingsSaveString(cAUTHconf,'core','send_enter','true');
  end;
 end;
end;


// отображение ошибки в логе
procedure ErrorParsingLog(InPhoneNumber,InTypeParsing,InFullStackSMSParsing:string);
var
 TextError:string;
begin
  TextError:='Не заполнена строка ' +InTypeParsing;

  CurrentPostAddColoredLine('ОШИБКА! Не удалось отправить СМС на номер "'+InPhoneNumber+'" , причина ошибки: '+TextError,clRed);

   with FormHome do begin
    ParsingError:=True;
    SLParsingError.Add(InFullStackSMSParsing);
   end;
end;


// время высчитывание примерного времени
function GetTimeDiff(InCurrentSec:Integer):string;
var
 WorkingHours:string;
 days,hour,min,sec:Integer;
 hourtmp,mintmp,sectmp:string;
 CurrentSec:Integer;
begin
  // InType=0 - отображать формат Xд XXчас XXмин XXсек
  // InType=1 - отображать формат 1д 00:00:00

   CurrentSec:=InCurrentSec;

  days:=Trunc(CurrentSec/(24*3600));
  dec(CurrentSec,days * 24*3600);

  hour:=Trunc(CurrentSec/3600);
  hourtmp:=IntToStr(hour);
  if Length(hourtmp)=1 then hourtmp:='0'+hourtmp;
  dec(CurrentSec,hour * 3600);


  min:=Trunc(CurrentSec/60);
  mintmp:=IntToStr(min);
  if Length(mintmp)=1 then mintmp:='0'+mintmp;
  dec(CurrentSec,min * 60);

  sec:=CurrentSec;
  sectmp:=IntToStr(sec);
  if Length(sectmp)=1 then sectmp:='0'+sectmp;

  if days<>0 then WorkingHours:=IntToStr(days)+' дн '+IntToStr(hour)+' час '+IntToStr(min)+' мин '+IntToStr(sec)+' сек'
  else
  begin
   if hour<>0 then WorkingHours:=IntToStr(hour)+' час '+IntToStr(min)+' мин '+IntToStr(sec)+' сек'
   else
   begin
    if min<>0 then WorkingHours:=IntToStr(min)+' мин '+IntToStr(sec)+' сек'
    else
    begin
     WorkingHours:=IntToStr(sec)+' сек';
     if WorkingHours='0 сек' then WorkingHours:='0.5 сек';
    end;
   end;
  end;

  result:=WorkingHours;
end;


// сохранение сообщения
procedure AddSaveMessageOld(InMessage:string);
var
 lastIDmsg:Integer;
begin
 // проверим есть ли сообщение ранее
 if GetExistSaveMessage(InMessage) then Exit;

 // сохраним
 lastIDmsg:=StrToInt(SettingsLoadString(cAUTHconf,'msg','lastID','0'));

 if lastIDmsg>=cMAXCOUNTMESSAGEOLD-1 then lastIDmsg:=0; // обнуляем ID

  SettingsSaveString(cAUTHconf,'msg','msg'+IntToStr(lastIDmsg),InMessage);
  SettingsSaveString(cAUTHconf,'msg','lastID',IntToStr(lastIDmsg+1));
end;


// проверка есть ли уже ранее сохраненное сообщение
function GetExistSaveMessage(InMEssage:string):Boolean;
var
 i:Integer;
 isExist:Boolean;
begin
   isExist:=False;

   for i:=0 to cMAXCOUNTMESSAGEOLD-1 do begin
     if InMEssage=SettingsLoadString(cAUTHconf,'msg','msg'+IntToStr(i),'') then isExist:=True;
   end;

   result:=isExist;
end;



// прогрузка последних успешных сообщений
procedure LoadMsgMessageOld(InMaxCount:Integer);
const
  DefColWidth:Integer = 427;   // минимальная длина при котором будет увеличиваться поле
  Koeff:Double        = 6.27;  // коэффициент расширения поля
var
 i,j:Integer;
 msg:string;

 LastID:Integer;

 maxLenghMsg:Integer; // максимальная длинна сообщения

 SLMsg:TStringList;

begin

  with FormMsgPerenos.SG do begin
    LastID:=StrToInt(SettingsLoadString(cAUTHconf,'msg','lastID','0'));
    if LastID=0 then  Inc(LastID);

    DefaultColWidth:=DefColWidth;
    RowCount:=LastID;

    // очистим список
    for i:=0 to RowCount do begin
      for j:=0 to ColCount do begin
         Cells[i,j]:='';
      end;
    end;

    maxLenghMsg:=0;
    SLMsg:=TStringList.Create;

    // пробежимся по списку
    for i:=cMAXCOUNTMESSAGEOLD-1 downto 0 do begin
      msg:=SettingsLoadString(cAUTHconf,'msg','msg'+IntToStr(i),'');

      if Length(msg)>maxLenghMsg then maxLenghMsg:=Length(msg);
      if msg<>'' then  SLMsg.Add(msg);
    end;

    for i:=0 to SLMsg.Count-1 do  Cells[0,i]:=SLMsg[i];

    // изменяем размер
    if maxLenghMsg*Koeff > DefColWidth  then  DefaultColWidth:=Round(maxLenghMsg*Koeff);
  end;
end;

end.
