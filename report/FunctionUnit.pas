unit FunctionUnit;


interface

uses
  Data.Win.ADODB, Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,System.DateUtils, ActiveX,
  System.Win.ComObj, TCustomTypeUnit;


  procedure createCopyright;                                                 // �������� Copyright
  function GetOnlyOperatorsRoleID:TStringList;                               // ��������� ������ ������������ ID ����
  function getUserSIP(InIDUser:integer):string;                              // ����������� SIP ������������
  function SetFindDate(var _startDate:TDateTimePicker;                       // ��������� ���� ������ � ����� ������� ������
                       var _stopDate:TDateTimePicker;
                       var _errorDescriptions:string):Boolean;
  function isExistExcel(var _errorDescriptions:string):Boolean;              // �������� ���������� �� excel
  procedure ShowProgressBar;                                                 // ���������� �������� ���
  procedure CloseProgressBar;                                                // ��������� �������� ���
  procedure SetStatusProgressBarText(InText:string);                         // ��������� ������ ������� �������� ����
  procedure SetStatusProgressBar(InProgress:Integer);  overload;             // ��������� ������� �������� ����
  procedure SetStatusProgressBar(InProgress:Double);   overload;             // ��������� ������� �������� ����
  function GetAboutGenerateReport:Boolean;                                   // ������ ��������� ������
  function CountOnHoldPhone(_sip:string; _date:TDate; _table:enumReportTableCountCallsOperatorOnHold):Integer;  // ���-�� ������ � ������� onHold
  procedure CursourHover(var _label:TLabel; _state:enumCursorHover);        // ��������� ����� label ��� ���������\�������� �����


implementation

uses
 FormHomeUnit, GlobalVariables, FormWaitUnit, GlobalVariablesLinkDLL;

// �������� Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[0].Text:=GetCopyright;
  end;
end;


// ��������� ������ ������������ ID ����
function GetOnlyOperatorsRoleID:TStringList;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countID:Cardinal;
begin
  Result:=TStringList.Create;

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
      SQL.Add('select count(id) from role where id <> ''-1'' and only_operators = ''1'' ');

      Active:=True;
      countID:= Fields[0].Value;

      if countID<>0 then begin

        SQL.Clear;
        SQL.Add('select id from role where id <> ''-1'' and only_operators = ''1'' ');

        Active:=True;
        for i:=0 to countID-1 do begin
           Result.Add(VarToStr(Fields[0].Value));
           ado.Next;
        end;
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

// ����������� SIP ������������
function getUserSIP(InIDUser:integer):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:='null';

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
      SQL.Add('select sip from operators where user_id = '+#39+IntToStr(InIDUser)+#39);
      Active:=True;

      if Fields[0].Value<>null then Result:=VarToStr(Fields[0].Value);
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;


// ��������� ���� ������ � ����� ������� ������
function SetFindDate(var _startDate:TDateTimePicker;
                     var _stopDate:TDateTimePicker;
                     var _errorDescriptions:string):Boolean;
var
  CurrentDate: TDateTime;
  FirstDayOfPreviousMonth: TDateTime;
  LastDayOfPreviousMonth: TDateTime;
begin
 Result:=False;
 _errorDescriptions:='';

   try
      // �������� ������� ����
      CurrentDate := Now;

      // �������� ������ ����� ����������� ������
      if MonthOf(CurrentDate) = 1 then FirstDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate) - 1, 12, 1) // ������� �������� ����
      else FirstDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate), MonthOf(CurrentDate) - 1, 1);

       // �������� ��������� ���� ����������� ������
      if MonthOf(CurrentDate) = 1 then LastDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate) - 1, 12, 31) // ��������� ���� ������� �������� ����
      else LastDayOfPreviousMonth := EncodeDate(YearOf(CurrentDate), MonthOf(CurrentDate), 1) - 1;

      _startDate.DateTime:=FirstDayOfPreviousMonth;
      _stopDate.DateTime:=LastDayOfPreviousMonth;

      Result:=True;
   except
      on E: Exception do begin
        _errorDescriptions:=e.ClassName+#13+E.Message;
      end;
   end;
end;


// �������� ���������� �� excel
function isExistExcel(var _errorDescriptions:string):Boolean;
var
  Excel:OleVariant;
begin
  Result:=False;
  _errorDescriptions:='';

  try
    Excel:=CreateOleObject('Excel.Application');
    Excel:=Unassigned; // ����������� ������

    Result:=True; // ���� ������ ������, ������ Excel ����������
  except
    on E: Exception do begin
      _errorDescriptions:=e.ClassName+#13+E.Message;
    end;
  end;
end;

// ���������� �������� ���
procedure ShowProgressBar;
begin
  with FormWait do begin
   ProgressBar.Progress:=0;
   ProgressStatusText.Caption:='������: ';
   Show;
  end;
end;

// ��������� �������� ���
procedure CloseProgressBar;
begin
  if FormWait.Showing then FormWait.Close;
end;

// ��������� ������ ������� �������� ����
procedure SetStatusProgressBarText(InText:string);
begin
  FormWait.ProgressStatusText.Caption:='������: '+InText;
  Application.ProcessMessages;
end;


// ��������� ������� �������� ����
procedure SetStatusProgressBar(InProgress:Integer);
begin
  FormWait.ProgressBar.Progress:=InProgress;
  Application.ProcessMessages;
end;


// ��������� ������� �������� ����
procedure SetStatusProgressBar(InProgress:double);
var
 value:integer;
begin
  value:=Trunc(InProgress);

  FormWait.ProgressBar.Progress:=value;
  Application.ProcessMessages;
end;


// ������ ��������� ������
function GetAboutGenerateReport:Boolean;
begin
  Result:=FormWait.isAboutGenerate;
end;


// ���-�� ������ � ������� onHold
function CountOnHoldPhone(_sip:string; _date:TDate; _table:enumReportTableCountCallsOperatorOnHold):Integer;
var
 i:Integer;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 countData:Integer;
 seconds:Integer;
 secondsAll:Integer;
begin
  Result:=0;
  secondsAll:=0;

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
      SQL.Add('select count(id) from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')'+
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

      Active:=True;
      countData:=Fields[0].Value;

      if countData=0 then begin
        FreeAndNil(ado);
        if Assigned(serverConnect) then begin
          serverConnect.Close;
          FreeAndNil(serverConnect);
        end;

       Exit;
      end;

      SQL.Clear;
      SQL.Add('select date_time_start,date_time_stop from '+EnumReportTableCountCallsOperatorOnHoldToString(_table)+' where sip IN ('+_sip+')' +
              ' and date_time_start >='+#39+GetDateToDateBD(DateToStr(_date))+' 00:00:00'+#39+
              ' and date_time_start <='+#39+GetDateToDateBD(DateToStr(_date))+' 23:59:59'+#39+
              ' and date_time_stop is not NULL');

      Active:=True;
      for i:=0 to countData-1 do begin
        seconds:= SecondsBetween(StrToDateTime(Fields[0].Value), StrToDateTime(Fields[1].Value));

        //����� �����
        secondsAll := secondsAll + seconds;

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

  Result:=secondsAll;
end;

// ��������� ����� label ��� ���������\�������� �����
procedure CursourHover(var _label:TLabel; _state:enumCursorHover);
begin
  _label.Cursor:=crHandPoint;

  case _state of
   eMouseLeave:begin
     _label.Font.Style:=[fsBold];
   end;
   eMouseMove:begin
    _label.Font.Style:=[fsUnderline,fsBold];
   end;
  end;
end;


procedure LoadingListOperators(var _listUsers:TCheckListBox; InShowDisableUsers:Boolean = False);
begin

end;

end.
