/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� XML                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

library TXMLLibrary;

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  XMLDoc,
  XMLIntf;


 type
  TXMLSettings = class
  public
    constructor Create(SettingsFileName,GUIDVesrion:string); overload;
    constructor Create(SettingsFileName:string); overload;

    destructor Destroy; override;

    procedure UpdateCurrentVersion(GUIDVesrion:string);     // ���������� ������� ������
    procedure UpdateRemoteVersion(GUIDVesrion:string);      // ���������� ��������� ������

    function GetCurrentVersion: string;                     // ������� ������
    function GetRemoteVersion: string;                      // ��������� ������

    procedure UpdateLastOnline;                             // ���������� ��������� ���� � ����

    function GetLastOnline:TDateTime;                       // ����� ����� ��������� ��� ���� ������� ������

  private
    m_fileSettings: string;                                 // ���� � ������ ��������
    m_XMLDoc: IXMLDocument;
    m_RootNode, m_ChildNode: IXMLNode;
    m_mutex: TMutex;

    function isExistSettingsFile: Boolean;                  // �������� ���������� �� ���� � �����������
    procedure CreateDefaultFileSettings(GUIDVesrion:string); // �������� ��������������� ����� � �����������
  end;


var
  XMLSettings: TXMLSettings;

{ TXMLSettings }

 constructor TXMLSettings.Create(SettingsFileName,GUIDVesrion:string);
 var
  FolderPath:string;
 begin
   inherited Create;
   m_mutex:=TMutex.Create(nil, False, 'Global\TXML');

   FolderPath:=ExtractFilePath(ParamStr(0));
   Self.m_fileSettings:=FolderPath + SettingsFileName;

   // ������� ���� � �����������
   if not isExistSettingsFile then begin
    CreateDefaultFileSettings(GUIDVesrion);
   end
   else begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;

 constructor TXMLSettings.Create(SettingsFileName:string);
 var
  FolderPath:string;
 begin
   inherited Create;
   m_mutex:=TMutex.Create(nil, False, 'Global\TXML');

   FolderPath:=ExtractFilePath(ParamStr(0));
   Self.m_fileSettings:=FolderPath + SettingsFileName;

   // ������� ���� � �����������
   if isExistSettingsFile then begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;

destructor TXMLSettings.Destroy;
begin
  // ������������ ��������, ���� ��� ����������
  m_XMLDoc:= nil;
  m_mutex.Free;

  inherited Destroy;
end;


function TXMLSettings.isExistSettingsFile;
begin
  Result:=FileExists(m_fileSettings);
end;


procedure TXMLSettings.CreateDefaultFileSettings(GUIDVesrion:string);
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    try
      // ������� ����� XML-��������
      m_XMLDoc := TXMLDocument.Create(nil);
      m_XMLDoc.Active := True; // ���������� ��������

       // ������� �������� ���� <Settings>
      m_RootNode := m_XMLDoc.AddChild('Settings');

      // ������� ���� <Versions> � ��������� <Current> ������ ����
      m_ChildNode := m_RootNode.AddChild('Versions');
      m_ChildNode.AddChild('Current').Text:= GUIDVesrion;

      // ��������� ���� <Remote> ������ <Versions>
      m_ChildNode.AddChild('Remote').Text := 'null';


      // ��������� ���� <LastOnline>
      m_RootNode.AddChild('LastOnline'); // ��������� LastOnline �� ��� �� �������, ��� � Versions

      // ��������� ����� XML-��������
      m_XMLDoc.SaveToFile(m_fileSettings);
    finally
      m_XMLDoc:=nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


procedure TXMLSettings.UpdateCurrentVersion(GUIDVesrion:string);
begin
  if not isExistSettingsFile then CreateDefaultFileSettings(GUIDVesrion);

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);
    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('Current');

      if Assigned(m_ChildNode) then
      begin
        m_ChildNode.Text :=GUIDVesrion;

        m_XMLDoc.SaveToFile(m_fileSettings);
      end;
    finally
     m_XMLDoc := nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


procedure TXMLSettings.UpdateRemoteVersion(GUIDVesrion:string);
begin
  if not isExistSettingsFile then CreateDefaultFileSettings(GUIDVesrion);

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);
    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('Remote');

      if Assigned(m_ChildNode) then
      begin
        m_ChildNode.Text :=GUIDVesrion;

        m_XMLDoc.SaveToFile(m_fileSettings);
      end;
    finally
     m_XMLDoc := nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


procedure TXMLSettings.UpdateLastOnline;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled then
  try
    m_XMLDoc := LoadXMLDocument(m_fileSettings);
    try
      // �������� ����� ���� LastOnline
      m_ChildNode := m_XMLDoc.DocumentElement.ChildNodes.FindNode('LastOnline');

      // ���� ���� �� ������, ������� �����
      if not Assigned(m_ChildNode) then
      begin
        m_ChildNode := m_XMLDoc.DocumentElement.AddChild('LastOnline');
      end;

      // ��������� ����� ����
      m_ChildNode.Text:= DateTimeToStr(Now);

      // ��������� ��������� � ����
      m_XMLDoc.SaveToFile(m_fileSettings);

    finally
      m_XMLDoc:=nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


function TXMLSettings.GetCurrentVersion:string;
begin
  if not isExistSettingsFile then
  begin
    Result:='null';
    Exit;
  end;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);

    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Current');

      if Assigned(m_ChildNode) then
      begin
        Result:=m_ChildNode.Text;
      end;
    finally
      m_XMLDoc := nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


function TXMLSettings.GetRemoteVersion:string;
begin
  if not isExistSettingsFile then
  begin
    Result:='null';
    Exit;
  end;

  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);

    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Remote');

      if Assigned(m_ChildNode) then
      begin
        Result:=m_ChildNode.Text;
      end;
    finally
      m_XMLDoc := nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


function TXMLSettings.GetLastOnline:TDateTime;
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);

    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('LastOnline');

      if Assigned(m_ChildNode) then
      begin
        Result:= StrToDateTime(m_ChildNode.Text);
      end;
    finally
      m_XMLDoc := nil;
    end;
  finally
    m_mutex.Release;
  end;
end;



// �������������� �������
function CreateXMLSettings(SettingsFileName, GUIDVesrion:PChar):TXMLSettings; export;
begin
  Result:=TXMLSettings.Create(SettingsFileName, GUIDVesrion);
end;

function CreateXMLSettingsSingle(SettingsFileName:PChar):TXMLSettings; export;
begin
  Result:=TXMLSettings.Create(SettingsFileName);
end;

procedure FreeXMLSettings(TXML:TXMLSettings); export;
begin
  TXML.Free;
end;

procedure UpdateXMLLocalVersion(TXML: TXMLSettings; GUIDVesrion: PChar); export;
begin
  TXML.UpdateCurrentVersion(GUIDVesrion);
end;

procedure UpdateXMLRemoteVersion(TXML: TXMLSettings; GUIDVesrion: PChar); export;
begin
  TXML.UpdateRemoteVersion(GUIDVesrion);
end;

function GetLocalXMLVersion(TXML: TXMLSettings):PChar; export;
begin
  Result:=PChar(TXML.GetCurrentVersion);
end;

function GetXMLLastOnline(TXML: TXMLSettings):TDateTime; export;
begin
  Result:=TXML.GetLastOnline;
end;

function GetRemoteXMLVersion(TXML: TXMLSettings):PChar; export;
begin
  Result:=PChar(TXML.GetRemoteVersion);
end;

procedure UpdateXMLLastOnline(TXML:TXMLSettings); export;
begin
  TXML.UpdateLastOnline;
end;

 exports
  CreateXMLSettings,
  CreateXMLSettingsSingle,
  FreeXMLSettings,
  UpdateXMLLocalVersion,
  UpdateXMLRemoteVersion,      // ��� ������ ����������
  GetLocalXMLVersion,
  GetRemoteXMLVersion,         // ��� ������ ����������
  UpdateXMLLastOnline,
  GetXMLLastOnline;            // ��� ������ ����������


begin
end.
