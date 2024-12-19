/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                         Класс для описания XML                            ///
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

    destructor Destroy; override;

    procedure UpdateCurrentVersion(GUIDVesrion:string);     // обновление текущей версии
    procedure UpdateRemoteVersion(GUIDVesrion:string);      // обновление удаленной версии

    function GetCurrentVersion: string;                     // текущая версия
    function GetRemoteVersion: string;                      // удаленная версия

    procedure UpdateLastOnline;                             // обновление последней даты в сети

    function GetLastOnline:TDateTime;                       // время когда последний раз была запущен клиент

  private
    m_fileSettings: string;                                 // путь с файлом настроек
    m_XMLDoc: IXMLDocument;
    m_RootNode, m_ChildNode: IXMLNode;
    m_mutex: TMutex;

    function isExistSettingsFile: Boolean;                  // проверка существует ли файл с настройками
    procedure CreateDefaultFileSettings(GUIDVesrion:string); // создание первоначального файла с настройками
  end;

implementation

{ TXMLSettings }

 constructor TXML.Create(SettingsFileName,GUIDVesrion:string);
 begin
   inherited Create;
   m_mutex:=TMutex.Create(nil, False, 'Global\TXML');

   Self.m_fileSettings:=FOLDERPATH + SettingsFileName;

   // создаем файл с настрйоками
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
   m_mutex:=TMutex.Create(nil, False, 'Global\TXML');
   Self.m_fileSettings:=FOLDERPATH + SettingsFileName;

   // создаем файл с настрйоками
   if isExistSettingsFile then begin
    m_XMLDoc:=LoadXMLDocument(m_fileSettings);
   end;
 end;

destructor TXML.Destroy;
begin
  // Освобождение ресурсов, если это необходимо
  m_XMLDoc:= nil;
  m_mutex.Free;

  inherited Destroy;
end;


function TXML.isExistSettingsFile;
begin
  Result:=FileExists(m_fileSettings);
end;


procedure TXML.CreateDefaultFileSettings(GUIDVesrion:string);
begin
  if m_mutex.WaitFor(INFINITE)=wrSignaled then
  try
    try
      // Создаем новый XML-документ
      m_XMLDoc := TXMLDocument.Create(nil);
      m_XMLDoc.Active := True; // Активируем документ

       // Создаем корневой узел <Settings>
      m_RootNode := m_XMLDoc.AddChild('Settings');

      // Создаем узел <Versions> и добавляем <Current> внутрь него
      m_ChildNode := m_RootNode.AddChild('Versions');
      m_ChildNode.AddChild('Current').Text:= GUIDVesrion;

      // Добавляем узел <Remote> внутрь <Versions>
      m_ChildNode.AddChild('Remote').Text := 'null';


      // Добавляем узел <LastOnline>
      m_RootNode.AddChild('LastOnline'); // Добавляем LastOnline на тот же уровень, что и Versions

      // Сохраняем новый XML-документ
      m_XMLDoc.SaveToFile(m_fileSettings);
    finally
      m_XMLDoc:=nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


procedure TXML.UpdateCurrentVersion(GUIDVesrion:string);
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


procedure TXML.UpdateRemoteVersion(GUIDVesrion:string);
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


procedure TXML.UpdateLastOnline;
begin
  if m_mutex.WaitFor(INFINITE) = wrSignaled then
  try
    m_XMLDoc := LoadXMLDocument(m_fileSettings);
    try
      // Пытаемся найти узел LastOnline
      m_ChildNode := m_XMLDoc.DocumentElement.ChildNodes.FindNode('LastOnline');

      // Если узел не найден, создаем новый
      if not Assigned(m_ChildNode) then
      begin
        m_ChildNode := m_XMLDoc.DocumentElement.AddChild('LastOnline');
      end;

      // Обновляем текст узла
      m_ChildNode.Text:= DateTimeToStr(Now);

      // Сохраняем изменения в файл
      m_XMLDoc.SaveToFile(m_fileSettings);

    finally
      m_XMLDoc:=nil;
    end;
  finally
    m_mutex.Release;
  end;
end;


function TXML.GetCurrentVersion:string;
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


function TXML.GetRemoteVersion:string;
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


function TXML.GetLastOnline:TDateTime;
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



end.
