unit FunctionUnit;


interface

uses
  Data.Win.ADODB, Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,System.DateUtils, ActiveX,
  System.Win.ComObj, IdException, TCustomTypeUnit;


  procedure createCopyright;                                            // �������� Copyright
  function LoadData(_file:string;
                    var _status:TStaticText;
                    var _errorDescription:string):Boolean;              // ��������� � ������ excel �����
  function isExistExcel(var _errorDescriptions:string):Boolean;         // �������� ���������� �� excel
  function TrimQuotes(const S: string): string;                         // ������� " � ������ � � �����
  procedure showWait(Status:enumShow_wait);                             // �����������\������� ���� ������� �� ������
  procedure SetRandomFontColor(var p_label: TLabel);                    // ��������� ����� �������

implementation

uses
 FormHomeUnit, GlobalVariables, GlobalVariablesLinkDLL, TServiceUnit, FormWaitUnit;

// �������� Copyright
procedure createCopyright;
begin
  with FormHome.StatusBar do begin
    Panels[0].Text:=GetCopyright;
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


// ������� " � ������ � � �����
function TrimQuotes(const S: string): string;
begin
  Result := S.Trim(['"']);
end;


// ��������� � ������ excel �����
function LoadData(_file:string; var _status:TStaticText; var _errorDescription:string):Boolean;
var
 SL: TStringList;
 i: Integer;
 Columns: TArray<string>;
 checkRows:Boolean;
 dest,code,serviceName:string;
 serviceStruct:TStructService;

begin
  Screen.Cursor:=crHourGlass;

  Result:=False;
  _errorDescription:='';
  checkRows:=False;

  _status.Caption:='������ : �������� � ������';

  if DEBUG then begin
    while (GetTask('EXCEL.EXE')) do KillTask('EXCEL.EXE');
  end;

  SL:= TStringList.Create;
  try
    SL.LoadFromFile(_file);

    if SL.Count = 0 then begin
     Screen.Cursor:=crDefault;
     _errorDescription:='���� ����';
     _status.Caption:='������ : ������ ��� �������� � ������!';
     Application.ProcessMessages;
     Exit;
    end;


    // �������� �� ������
    Columns:=SL[0].Split([';']);
    if (Columns[0] = '"FILID"')             and
       (Columns[1] = '"SPECNAME"')          and  // �����������
       (Columns[2] = '"SPECCODE"')          and
       (Columns[3] = '"GRPNAME"')           and
       (Columns[4] = '"KODOPER"')           and   // ��� ������
       (Columns[5] = '"SCHNAME"')           and   // ������
       (Columns[6] = '"MWSCHNAME"')         and
       (Columns[7] = '"SPRICE"')            and
       (Columns[8] = '"CITOPRICE"')         and
       (Columns[9] = '"URI"')               and
       (Columns[10] = '"ZAPIS"')            and
       (Columns[11] = '"HIRURGST"')         and
       (Columns[12] = '"STACIPOLIC"')       and
       (Columns[13] = '"EXAMPREPARETEXT"')  and
       (Columns[14] = '"DRAWKODOPER"')
    then checkRows:=True
    else checkRows:=False;

    if not checkRows then begin
      Screen.Cursor:=crDefault;
     _errorDescription:='������������ ������ �����';
     _status.Caption:='������ : ������������ ������ �����';
     Application.ProcessMessages;
     Exit;
    end;


    for i:=1 to SL.Count-1 do begin
      Columns:=SL[i].Split([';']);

      serviceStruct:=TStructService.Create(TrimQuotes(Columns[1]),
                                           TrimQuotes(Columns[4]),
                                           TrimQuotes(Columns[5]));

      SharedServiceListLoading.Add(serviceStruct);
    end;



  finally
    SL.Free;
  end;

  if SharedServiceListLoading.Count = 0 then begin
    _errorDescription:='������ : ��� ����� ��� ��������';
    Screen.Cursor:=crDefault;
    Exit;
  end;

   _status.Caption:='������ : ������ � �������� ('+IntToStr(SharedServiceListLoading.Count)+')';


  Result:=True;
  Screen.Cursor:=crDefault;
end;

// �����������\������� ���� ������� �� ������
procedure showWait(Status:enumShow_wait);
begin
  case (Status) of
   show_open: begin
     Screen.Cursor:=crHourGlass;
     FormWait.Show;
     Application.ProcessMessages;
   end;
   show_close: begin
     Screen.Cursor:=crDefault;
     FormWait.Close;
   end;
  end;
end;


// ��������� ����� �������
procedure SetRandomFontColor(var p_label: TLabel);
var
  RandomColor: TColor;
begin
  // ���������� ��������� �������� ��� RGB
  RandomColor := RGB(Random(256), Random(256), Random(256));

  // ������������� ��������� ���� ������ ��� �����
  p_label.Font.Color := RandomColor;
end;

end.
