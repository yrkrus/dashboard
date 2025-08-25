/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         ����� ��� �������� XML                            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////

unit TXmlUnit;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, XMLDoc, XMLIntf, TCustomTypeUnit, GlobalVariables;


 type
  TXML = class
  public
    constructor Create(SettingsFileName,GUIDVesrion:string); overload;
    constructor Create(SettingsFileName:string); overload;
    constructor Create(); overload;

    destructor Destroy; override;

    procedure UpdateCurrentVersion(GUIDVesrion:string);     // ���������� ������� ������
    procedure UpdateRemoteVersion(GUIDVesrion:string);      // ���������� ��������� ������

    function GetCurrentVersion: string;                     // ������� ������
    function GetRemoteVersion: string;                      // ��������� ������

    procedure UpdateLastOnline;                             // ���������� ��������� ���� � ����

    function GetLastOnline:TDateTime;                       // ����� ����� ��������� ��� ���� ������� ������
    function isExistSettingsFile: Boolean;                  // �������� ���������� �� ���� � �����������

    procedure isUpdate(InValue:string); overload;           // ��������� ��������� ����������
    function isUpdate:Boolean;         overload;            // ������� ��������� (� ���������� ��� ���)

    function GetFolderPathFindRemember: string;             // ���� ������ ����� �������� ���� � ��� ���������
    procedure SetFolderPathFindRemember(const Path: string);// ��������� ���� ������ ����� �������� ���� � ��� ���������

    function GetFolderPathService: string;                  // ���� ������ ����� �������� ���� � ��������
    procedure SetFolderPathService(const Path: string);     // ��������� ���� ������ ����� �������� ���� � ��������

    function GetFontSize(_font:enumFontSize):Word;          // ��������� �������� ������� ������
    procedure SetFontSize(_font:enumFontSize; _value:Integer); // ��������� ������� ������

    function GetWindowState:string;                         // ��������� �������� ������� ���� ������� �����
    procedure SetWindowState(_state:string);                // ��������� ������� ���� ������� �����

    procedure ForceUpdate(InValue:string);                   // �������������� ����������
    function  isForceUpdate:Boolean;        overload;       // ������� ��������� (� �������������� ����������)

    function GetMissedCallsShow:string;                     // ��������� �������� �������� ���������� ���� � ������� callback
    procedure SetMissedCallsShow(_state:string);            // ��������� �������� �������� ���������� ���� � ������� callback

    function GetActiveSessionConfirm:string;                // ��������� �������� �������� ������������ �������� ��� �������� �������� ������
    procedure SetActiveSessionConfirm(_state:string);       // ��������� �������� �������� ������������ �������� ��� �������� �������� ������

    function GetStatusOperatorPosition(var _left:Integer;
                                       var _top: Integer):Boolean; // ��������� �������� �������� ��������� ���� ������� ���������
    function IsExistStatusOperatorPosition:Boolean;               // ���� �� ������ �� ������� ������
    procedure SetStatusOperatorPosition(_left,_top:Integer);       // ��������� �������� �������� ��������� ���� ������� ���������



  private
    m_fileSettings: string;                                 // ���� � ������ ��������
    m_XMLDoc: IXMLDocument;
    m_RootNode, m_ChildNode: IXMLNode;
    //m_mutex: TMutex;
   procedure CreateDefaultFileSettings(GUIDVesrion:string); // �������� ��������������� ����� � �����������
   procedure checkExistNodeFields(inRootNode,InChildNode,inDefaultValue:string); // �������� ���������� �� ����� ��������

   function stringToBoolean(inValue:string):Boolean;   // ��������� string->boolean

  end;

implementation



{ TXMLSettings }

 constructor TXML.Create(SettingsFileName,GUIDVesrion:string);
 begin
   inherited Create;
   //m_mutex:=TMutex.Create(nil, False, 'Global\TXML');

   Self.m_fileSettings:=FOLDERPATH + SettingsFileName;

   // ������� ���� � �����������
   if not isExistSettingsFile then begin
    CreateDefaultFileSettings(GUIDVesrion);
   end
   else begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;

 constructor TXML.Create(SettingsFileName:string);
 begin
   inherited Create;
  // m_mutex:=TMutex.Create(nil, False, 'Global\TXML');
   Self.m_fileSettings:=FOLDERPATH + SettingsFileName;

   // ������� ���� � �����������
   if isExistSettingsFile then begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;


 constructor TXML.Create();
 begin
   inherited Create;
 //  m_mutex:=TMutex.Create(nil, False, 'Global\TXML');
   Self.m_fileSettings:=FOLDERPATH + SETTINGS_XML;

   if isExistSettingsFile then begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;

destructor TXML.Destroy;
begin
  // ������������ ��������, ���� ��� ����������
  m_XMLDoc:= nil;
 // m_mutex.Free;

  inherited Destroy;
end;


function TXML.isExistSettingsFile;
begin
  Result:=FileExists(m_fileSettings);
end;


// ��������� ��������� ����������
procedure TXML.isUpdate(InValue:string);
begin
  // ��������� ���� �� ��������
  checkExistNodeFields('Versions','isUpdate','InValue');

   m_XMLDoc:= LoadXMLDocument(m_fileSettings);
    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('isUpdate');

      if Assigned(m_ChildNode) then
      begin
        m_ChildNode.Text :=InValue;
        m_XMLDoc.SaveToFile(m_fileSettings);
      end;
    finally
     m_XMLDoc := nil;
    end;
end;


// �������������� ����������
procedure TXML.ForceUpdate(InValue:string);
begin
  // ��������� ���� �� ��������
  checkExistNodeFields('Versions','ForceUpdate','InValue');

   m_XMLDoc:= LoadXMLDocument(m_fileSettings);
    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('ForceUpdate');

      if Assigned(m_ChildNode) then
      begin
        m_ChildNode.Text :=InValue;
        m_XMLDoc.SaveToFile(m_fileSettings);
      end;
    finally
     m_XMLDoc := nil;
    end;
end;

// ������� ��������� (� ���������� ��� ���)
function TXML.isUpdate:Boolean;
begin
  Result:=False;

  m_XMLDoc:= LoadXMLDocument(m_fileSettings);

  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('isUpdate');

    if Assigned(m_ChildNode) then
    begin
      Result:= stringToBoolean(m_ChildNode.Text);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;


// ������� ��������� (� �������������� ����������)
function TXML.isForceUpdate:Boolean;
begin
  Result:=False;

  m_XMLDoc:= LoadXMLDocument(m_fileSettings);

  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('ForceUpdate');

    if Assigned(m_ChildNode) then
    begin
      Result:= stringToBoolean(m_ChildNode.Text);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;

procedure TXML.CreateDefaultFileSettings(GUIDVesrion:string);
begin
 // if m_mutex.WaitFor(INFINITE)=wrSignaled then
//  try
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

      // ��������� ���� <isUpdate> ������ <Versions>
      m_ChildNode.AddChild('isUpdate').Text := 'false';

      // ��������� ���� <isUpdate> ������ <Versions>
      m_ChildNode.AddChild('ForceUpdate').Text := 'false';

      // ��������� ���� <LastOnline>
      m_RootNode.AddChild('LastOnline'); // ��������� LastOnline �� ��� �� �������, ��� � Versions

      // ��������� ���� <SMS> � �������� ���� <FolderPathFindRemember>
      m_ChildNode := m_RootNode.AddChild('SMS');
      m_ChildNode.AddChild('FolderPathFindRemember').Text := 'null'; // �������� �� ���������

      // ��������� ���� <Font> � �������� ���� <ActiveSip> (�������� �� ������ ������)
      m_ChildNode := m_RootNode.AddChild('Font');
      m_ChildNode.AddChild('ActiveSip').Text  := '10'; // �������� �� ���������
      m_ChildNode.AddChild('IVR').Text        := '10'; // �������� �� ���������
      m_ChildNode.AddChild('Queue').Text      := '10'; // �������� �� ���������

      // ��������� ���� <WindowState> � �������� ���� <State> (�������� �� ��������� ���� ������� ����� �� ���� ����� ��� ���)
      m_ChildNode := m_RootNode.AddChild('WindowState');
      m_ChildNode.AddChild('State').Text      := 'wsMaximized'; // �������� �� ���������

      // ��������� ����� XML-��������
      m_XMLDoc.SaveToFile(m_fileSettings);
    finally
      m_XMLDoc:=nil;
    end;
 // finally
 //   m_mutex.Release;
 // end;
end;

// �������� ���������� �� ����� ��������
procedure TXML.checkExistNodeFields(inRootNode,InChildNode,inDefaultValue:string);
var
 InChildNodeRef:IXMLNode;
begin
  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;

    // ��������� ������� ��������� ����
    if Assigned(m_RootNode) then
    begin
      // ��������� ������� ���� 'inRootNode'
      m_ChildNode := m_RootNode.ChildNodes.FindNode(inRootNode);

      // ���� ���� 'inRootNode' �� ������, ������� ���
      if not Assigned(m_ChildNode) then
      begin
        m_ChildNode := m_RootNode.AddChild(inRootNode);
      end;

      // ��������� ������� ���� 'InChildNode'
      InChildNodeRef := m_ChildNode.ChildNodes.FindNode(InChildNode);

      // ���� ���� 'InChildNode' �� ������, ������� ���
      if not Assigned(InChildNodeRef) then
      begin
        InChildNodeRef := m_ChildNode.AddChild(InChildNode);
        InChildNodeRef.Text := inDefaultValue; // ������������� �������� �� ���������
      end;
    end
    else
    begin
      // ���� �������� ���� �� ������, ������� ���
      m_RootNode := m_XMLDoc.AddChild(inRootNode);
      m_ChildNode := m_RootNode.AddChild(InChildNode);

      InChildNodeRef := m_ChildNode.AddChild(InChildNode);
      InChildNodeRef.Text := inDefaultValue; // ������������� �������� �� ���������;
    end;

    // ��������� ��������� � ���� ������ ���� ���
    m_XMLDoc.SaveToFile(m_fileSettings);
  finally
    m_XMLDoc := nil; // ����������� ������
  end;
end;

// ��������� string->boolean
function TXML.stringToBoolean(inValue:string):Boolean;
begin
 if (inValue='true') or (inValue='True') or (inValue='TRUE') then Result:=True
 else Result:=False;
end;

procedure TXML.UpdateCurrentVersion(GUIDVesrion:string);
begin
  if not isExistSettingsFile then CreateDefaultFileSettings(GUIDVesrion);

 // if m_mutex.WaitFor(INFINITE)=wrSignaled then
 // try
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
 // finally
 //   m_mutex.Release;
 // end;
end;


procedure TXML.UpdateRemoteVersion(GUIDVesrion:string);
begin
  if not isExistSettingsFile then CreateDefaultFileSettings(GUIDVesrion);

 /// if m_mutex.WaitFor(INFINITE)=wrSignaled then
 // try
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
 // finally
 //   m_mutex.Release;
 // end;
end;


procedure TXML.UpdateLastOnline;
begin
 // if m_mutex.WaitFor(INFINITE) = wrSignaled then
 // try
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
 // finally
 //   m_mutex.Release;
 // end;
end;


function TXML.GetCurrentVersion:string;
begin
  if not isExistSettingsFile then
  begin
    Result:='null';
    Exit;
  end;

//  if m_mutex.WaitFor(INFINITE)=wrSignaled then
//  try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);

    try
      m_RootNode := m_XMLDoc.DocumentElement;
      m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('Current');

      if Assigned(m_ChildNode) then
      begin
        Result:=m_ChildNode.Text;
      end;
    finally
      m_XMLDoc := nil;
    end;
 // finally
 //   m_mutex.Release;
 // end;
end;


function TXML.GetRemoteVersion:string;
begin
  if not isExistSettingsFile then
  begin
    Result:='null';
    Exit;
  end;

 // if m_mutex.WaitFor(INFINITE)=wrSignaled then
 // try
    m_XMLDoc:= LoadXMLDocument(m_fileSettings);

    try
      m_RootNode := m_XMLDoc.DocumentElement;
       m_ChildNode := m_RootNode.ChildNodes.FindNode('Versions').ChildNodes.FindNode('Remote');

      if Assigned(m_ChildNode) then
      begin
        Result:=m_ChildNode.Text;
      end;
    finally
      m_XMLDoc := nil;
    end;
 // finally
 //   m_mutex.Release;
 // end;
end;


function TXML.GetLastOnline:TDateTime;
begin
 // if m_mutex.WaitFor(INFINITE)=wrSignaled then
 // try
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
 // finally
 //   m_mutex.Release;
 // end;
end;


function TXML.GetFolderPathFindRemember: string;
begin
  Result := 'null';

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <SMS>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('SMS');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <FolderPathFindRemember>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('FolderPathFindRemember');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;


procedure TXML.SetFolderPathFindRemember(const Path: string);
begin
  // ��������� ������� ����
  checkExistNodeFields('SMS', 'FolderPathFindRemember', Path);

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('SMS').ChildNodes.FindNode('FolderPathFindRemember');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := Path;
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;

// ���� ������ ����� �������� ���� � ��������
function TXML.GetFolderPathService: string;
begin
  Result := 'null';

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <Service>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Service');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <FolderPathService>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('FolderPathService');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;


// ��������� ���� ������ ����� �������� ���� � ��������
procedure TXML.SetFolderPathService(const Path: string);
begin
  // ��������� ������� ����
  checkExistNodeFields('Service', 'FolderPathService', Path);

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Service').ChildNodes.FindNode('FolderPathService');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := Path;
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;

// ��������� �������� ������� ������
function TXML.GetFontSize(_font:enumFontSize):Word;
begin
  Result := 10;  // defaul value font size

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <Font>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Font');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <EnumFontSize>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode(EnumFontSizeToString(_font));
      if Assigned(m_ChildNode) then
      begin
        Result:= StrToInt(m_ChildNode.Text); // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;

// ��������� ������� ������
procedure TXML.SetFontSize(_font:enumFontSize; _value:Integer);
begin
  // ��������� ������� ����
  checkExistNodeFields('Font', EnumFontSizeToString(_font), IntToStr(_value));

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Font').ChildNodes.FindNode(EnumFontSizeToString(_font));

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := IntToStr(_value);
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;

// ��������� �������� ������� ���� ������� �����
function TXML.GetWindowState:string;
begin
   Result := 'wsMaximized';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <WindowState>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('WindowState');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <EnumFontSize>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('State');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;

// ��������� ������� ���� ������� �����
procedure TXML.SetWindowState(_state:string);
begin
 // ��������� ������� ����
  checkExistNodeFields('WindowState', 'State', 'wsMaximized');

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('WindowState').ChildNodes.FindNode('State');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := _state;
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;


// ��������� �������� �������� ���������� ���� � ������� callback
function TXML.GetMissedCallsShow:string;
begin
   Result := 'true';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <InfoMissedCallsShow>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('InfoMissedCallsShow');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <State>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Show');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;

// ��������� �������� �������� ���������� ���� � ������� callback
procedure TXML.SetMissedCallsShow(_state:string);
begin
 // ��������� ������� ����
  checkExistNodeFields('InfoMissedCallsShow', 'Show', 'true');

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('InfoMissedCallsShow').ChildNodes.FindNode('Show');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := _state;
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;



// ��������� �������� �������� ������������ �������� ��� �������� �������� ������
function TXML.GetActiveSessionConfirm:string;
begin
   Result := 'true';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <InfoMissedCallsShow>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('ActiveSessionConfirm');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <State>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Show');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // ���������� ����� ����
      end;
    end;
  finally
    m_XMLDoc := nil; // ����������� �������
  end;
end;


// ��������� �������� �������� ������������ �������� ��� �������� �������� ������
procedure TXML.SetActiveSessionConfirm(_state:string);
begin
 // ��������� ������� ����
  checkExistNodeFields('ActiveSessionConfirm', 'Show', 'true');

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('ActiveSessionConfirm').ChildNodes.FindNode('Show');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := _state;
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;

// ��������� �������� �������� ��������� ���� ������� ���������
function TXML.GetStatusOperatorPosition(var _left:Integer; var _top: Integer):Boolean;
begin
  Result:=false;  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // ����������� �������
    Exit;
  end;

  // ��������� XML-��������
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // ��������� ������� ���� <PanelStatusOperatorPosition>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition');
    if Assigned(m_ChildNode) then
    begin
      // ��������� ������� ���� <X>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('X');
      if Assigned(m_ChildNode) then
      begin
        _left:= StrToInt(m_ChildNode.Text); // ���������� ����� ����
      end;
    end;

    // ��������� ������� ���� <PanelStatusOperatorPosition>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition');
    if Assigned(m_ChildNode) then
    begin
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Y');
      if Assigned(m_ChildNode) then
      begin
        _top:= StrToInt(m_ChildNode.Text); // ���������� ����� ����
      end;
    end;

    Result:=(_left > 0) and (_top > 0);

  finally
    m_XMLDoc := nil; // ����������� �������
  end;

end;

// ���� �� ������ �� ������� ������
function TXML.IsExistStatusOperatorPosition:Boolean;
var
 X,Y:Integer;
begin
  X:=0;
  Y:=0;
  Result:=GetStatusOperatorPosition(X,Y);
end;

// ��������� �������� �������� ��������� ���� ������� ���������
procedure TXML.SetStatusOperatorPosition(_left,_top:Integer);
begin
  // ��������� ������� ����
  checkExistNodeFields('PanelStatusOperatorPosition', 'X', '0');
  checkExistNodeFields('PanelStatusOperatorPosition', 'Y', '0');

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition').ChildNodes.FindNode('X');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := IntToStr(_left);
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;

  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition').ChildNodes.FindNode('Y');

    if Assigned(m_ChildNode) then
    begin
      m_ChildNode.Text := IntToStr(_top);
      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
  end;
end;



end.
