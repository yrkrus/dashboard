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
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  XMLDoc,
  XMLIntf,
  GlobalVariables;


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


      // ��������� ���� <LastOnline>
      m_RootNode.AddChild('LastOnline'); // ��������� LastOnline �� ��� �� �������, ��� � Versions

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
begin
 m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;

    // ��������� ������� ���� 'isUpdate'
    m_ChildNode := m_RootNode.ChildNodes.FindNode(inRootNode).ChildNodes.FindNode(InChildNode);

    // ���� ���� 'isUpdate' �� ������, ������� ���
    if not Assigned(m_ChildNode) then
    begin
      m_ChildNode := m_RootNode.ChildNodes.FindNode(inRootNode).AddChild(InChildNode);
      m_ChildNode.Text := inDefaultValue; // ������������� �������� �� ���������

      m_XMLDoc.SaveToFile(m_fileSettings);
    end;
  finally
    m_XMLDoc := nil;
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



end.
