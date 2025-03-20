 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///     ����� ��� �������� ��������� �������� ���������� � �������            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TDebugStructUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs,
  TLogFileUnit;

  type
  PIntegerArray = ^TIntegerArray;
  TIntegerArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;


// ����� TAverageCalculator
type
  TAverageCalculator = class(TThread)
  messclass,mess: string;

  private
    FAverage      :Integer;
    m_array       :PIntegerArray; // ��������� �� ������
    m_count       :Integer;       // ���������� ��������� � �������
    Log           :TLoggingFile;

    m_nameStruct  :string;

    procedure UpdateAverage;
    procedure UpdateArray(arrayAverage:PIntegerArray; count:Integer);
  protected
    procedure Execute; override;
    procedure CriticalError;
  public
    constructor Create(arrayAverage:PIntegerArray; count:Integer; _nameStruct:string);
    property Average: Integer read FAverage;
    procedure SetLog(var p_Log:TLoggingFile);

  end;
// ����� TAverageCalculator END

// ����� TDebugStruct
type
  TDebugStruct = class
  private
    m_mutex               :TMutex;
    m_name                :string;
    m_currentResponse     :Integer;
    m_currentMax          :Integer;
    m_currentMaxTime      :TDateTime;
    m_average             :Integer;
    m_listAverage         :array of Integer;
    countListAverage      :Integer;

    Log                   :TLoggingFile;

    FAverageCalculator    :TAverageCalculator; // ����� ����� ��� ���������� ��������

  public
    constructor Create(inNameThread: string; var p_Log:TLoggingFile); overload;
    destructor Destroy; override;

    function Clone      :TDebugStruct;

    procedure SetResponse(_value: Integer);

    function isExistLog:Boolean;            // �������� ���� ������� ��������� ��� ���
    procedure SendLog(_text:string);        // �������� ��������� � ���

    property Name: string read m_name;
    property Mutex: TMutex read m_mutex;

  end;
// ����� TDebugStruct END

implementation


constructor TAverageCalculator.Create(arrayAverage: PIntegerArray; count: Integer; _nameStruct:string);
begin
  inherited Create(True); // ������� ����� � ���������������� ���������
  m_array:=arrayAverage;
  m_count:=count;
  m_nameStruct:=_nameStruct;
  FAverage := 0;
end;


procedure TAverageCalculator.SetLog(var p_Log:TLoggingFile);
begin
  Log:=p_Log;
  Log.Save('Log file attached is <b>TAverageCalculator --> '+m_nameStruct+'</b>');
end;


procedure TAverageCalculator.CriticalError;
const
 IS_ERROR:Boolean = True;
begin
   // ���������� � ���
   Log.Save(m_nameStruct+' --> '+ messclass+'.'+mess,IS_ERROR);
end;

procedure TAverageCalculator.Execute;
begin
  while not Terminated do
  begin
    try
      UpdateAverage;
    except
        on E:Exception do
        begin
         messclass:=e.ClassName;
         mess:=e.Message;

         Synchronize(CriticalError);
        end;
    end;
    Sleep(1000); // ��������� ������� �������� ������ �������
  end;
end;

procedure TAverageCalculator.UpdateAverage;
var
  Total: Integer;
  i: Integer;
  testI:Integer;
begin
  Total:= 0;

  if (m_count <= 0) or (m_array = nil) then
  begin
    FAverage := 0;
    Exit;
  end;

  for i:=0 to m_count - 1 do begin
    testI:=m_array^[i];
    Total := Total + testI;
  end;

  if Total=0 then begin
    FAverage:=0;
    Exit;
  end;

  FAverage:= Round(Total / m_count); // ��������� ������� ��������
end;


procedure TAverageCalculator.UpdateArray(arrayAverage:PIntegerArray; count:Integer);
begin
 m_array:=arrayAverage;
 m_count:=count;
end;


constructor TDebugStruct.Create(inNameThread: string;
                                var p_Log:TLoggingFile);
begin
  m_mutex := TMutex.Create(nil, False, 'Global\TDebugCountResponse_' + inNameThread);
  m_name := inNameThread;
  m_currentResponse := 0;
  m_currentMax := 0;
  m_average:=0;
  SetLength(m_listAverage, 0);
  countListAverage := 0;
  Log:=p_Log;

  // ������������� ������ ��� ���������� ��������
  FAverageCalculator := nil; // ���������� ����� �� ���������
end;

destructor TDebugStruct.Destroy;
begin
  // ��������� ������ ����� ������������, ���� �� ��� ������
  if Assigned(FAverageCalculator) then
  begin
    FAverageCalculator.Terminate;
    FAverageCalculator.WaitFor; // ����, ���� ����� ����������
    FAverageCalculator.Free; // ����������� �����
  end;

  m_mutex.Free; // ����������� mutex
  SetLength(m_listAverage, 0);

  inherited;
end;

function TDebugStruct.Clone: TDebugStruct;
begin
  Result:= TDebugStruct.Create(m_name,Log); // ������� ����� ������ � ������ ��������
  Result.m_currentResponse := Self.m_currentResponse; // �������� ������� �������� �������
  Result.m_currentMax := Self.m_currentMax; // �������� ������� ������������ ��������
  Result.m_currentMaxTime := Self.m_currentMaxTime; // �������� ������� ����� ���������
  Result.m_average:=Self.m_average;
  Result.Log:=Self.Log;

  // �������� ������ m_listAverage
  SetLength(Result.m_listAverage, Length(Self.m_listAverage));
  if Length(Self.m_listAverage) > 0 then
    Move(Self.m_listAverage[0], Result.m_listAverage[0], Length(Self.m_listAverage) * SizeOf(Integer));
  Result.countListAverage := Self.countListAverage;

  // ������� ����� ��������� TMutex ��� �������������� �������
  Result.m_mutex := TMutex.Create(nil, False, 'Global\TDebugCountResponse_' + m_name);
end;


procedure TDebugStruct.SetResponse(_value: Integer);
const
  MAX_LIST_AVERAGE: Word = 100;
begin
  // ������� ��������
  m_currentResponse := _value;

  // ������������ ��������
  if m_currentResponse > m_currentMax then
  begin
    m_currentMax := m_currentResponse;
    m_currentMaxTime := Now;
  end;

  // ��������� ����� �������� � m_listAverage
  if countListAverage >= MAX_LIST_AVERAGE then
  begin
    countListAverage := 0;
    SetLength(m_listAverage, countListAverage);
  end;

  SetLength(m_listAverage, countListAverage + 1); // ����������� ������ ������� �� 1
  m_listAverage[countListAverage] := _value; // ��������� ����� �������� � ����� �������
  Inc(countListAverage);

  // ������������� ������ ��� ���������� ��������, ���� �� ��� �� ������
  if not Assigned(FAverageCalculator) then
  begin
    FAverageCalculator:= TAverageCalculator.Create(@m_listAverage[0], countListAverage, m_name); // �������� ��������� �� ������ � ��� ������
    FAverageCalculator.SetLog(Log);
    FAverageCalculator.Start; // ������ ������
  end
  else FAverageCalculator.UpdateArray(@m_listAverage[0],countListAverage);

  m_average:=FAverageCalculator.Average;
end;

// �������� ���� ������� ��������� ��� ���
function TDebugStruct.isExistLog:Boolean;
begin
  Result:=Assigned(Log);
end;

// �������� ��������� � ���
procedure TDebugStruct.SendLog(_text:string);
begin
  if isExistLog then Log.Save(_text);
end;

end.
