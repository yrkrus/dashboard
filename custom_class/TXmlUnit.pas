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
  System.SysUtils, System.Classes, System.SyncObjs, XMLDoc, XMLIntf, TCustomTypeUnit, GlobalVariables;


 type
  TXML = class
  public
    constructor Create(SettingsFileName,GUIDVesrion:string); overload;
    constructor Create(SettingsFileName:string); overload;
    constructor Create(); overload;

    destructor Destroy; override;

    procedure UpdateCurrentVersion(GUIDVesrion:string);     // обновление текущей версии
    procedure UpdateRemoteVersion(GUIDVesrion:string);      // обновление удаленной версии

    function GetCurrentVersion: string;                     // текущая версия
    function GetRemoteVersion: string;                      // удаленная версия

    procedure UpdateLastOnline;                             // обновление последней даты в сети

    function GetLastOnline:TDateTime;                       // время когда последний раз была запущен клиент
    function isExistSettingsFile: Boolean;                  // проверка существует ли файл с настройками

    procedure isUpdate(InValue:string); overload;           // установка параметра обновления
    function isUpdate:Boolean;         overload;            // текущее состояние (в обновлении или нет)

    function GetFolderPathFindRemember: string;             // путь откуда будем забирать файл с смс рассылкой
    procedure SetFolderPathFindRemember(const Path: string);// установка пути откуда будем забирать файл с смс рассылкой

    function GetFolderPathService: string;                  // путь откуда будем забирать файл с услугами
    procedure SetFolderPathService(const Path: string);     // установка пути откуда будем забирать файл с услугами

    function GetFontSize(_font:enumFontSize):Word;          // получение текущего размера шрифта
    procedure SetFontSize(_font:enumFontSize; _value:Integer); // установка размера шрифта

    function GetWindowState:string;                         // получение текущего размера окна главной формы
    procedure SetWindowState(_state:string);                // установка размера окна главной формы

    procedure ForceUpdate(InValue:string);                   // принудительное обновление
    function  isForceUpdate:Boolean;        overload;       // текущее состояние (в принудительном обновлении)

    function GetMissedCallsShow:string;                     // получение текущего значения отображать инфо о статусе callback
    procedure SetMissedCallsShow(_state:string);            // установка текущего значения отображать инфо о статусе callback

    function GetActiveSessionConfirm:string;                // получение текущего значения подтверждать действие при закрытии активной сессии
    procedure SetActiveSessionConfirm(_state:string);       // установка текущего значения подтверждать действие при закрытии активной сессии

    function GetStatusOperatorPosition(var _left:Integer;
                                       var _top: Integer):Boolean; // получение текущего значения положения окна статусы оператора
    function IsExistStatusOperatorPosition:Boolean;               // есть ли данные по позиции панели
    procedure SetStatusOperatorPosition(_left,_top:Integer);       // установка текущего значения положения окна статусы оператора



  private
    m_fileSettings: string;                                 // путь с файлом настроек
    m_XMLDoc: IXMLDocument;
    m_RootNode, m_ChildNode: IXMLNode;
    //m_mutex: TMutex;
   procedure CreateDefaultFileSettings(GUIDVesrion:string); // создание первоначального файла с настройками
   procedure checkExistNodeFields(inRootNode,InChildNode,inDefaultValue:string); // проверка существует ли новое значение

   function stringToBoolean(inValue:string):Boolean;   // конвертер string->boolean

  end;

implementation



{ TXMLSettings }

 constructor TXML.Create(SettingsFileName,GUIDVesrion:string);
 begin
   inherited Create;
   //m_mutex:=TMutex.Create(nil, False, 'Global\TXML');

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
  // m_mutex:=TMutex.Create(nil, False, 'Global\TXML');
   Self.m_fileSettings:=FOLDERPATH + SettingsFileName;

   // создаем файл с настрйоками
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
  // Освобождение ресурсов, если это необходимо
  m_XMLDoc:= nil;
 // m_mutex.Free;

  inherited Destroy;
end;


function TXML.isExistSettingsFile;
begin
  Result:=FileExists(m_fileSettings);
end;


// установка параметра обновления
procedure TXML.isUpdate(InValue:string);
begin
  // проверяем есть ли параметр
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


// принудительное обновление
procedure TXML.ForceUpdate(InValue:string);
begin
  // проверяем есть ли параметр
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

// текущее состояние (в обновлении или нет)
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


// текущее состояние (в принудительном обновлении)
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

      // Добавляем узел <isUpdate> внутрь <Versions>
      m_ChildNode.AddChild('isUpdate').Text := 'false';

      // Добавляем узел <isUpdate> внутрь <Versions>
      m_ChildNode.AddChild('ForceUpdate').Text := 'false';

      // Добавляем узел <LastOnline>
      m_RootNode.AddChild('LastOnline'); // Добавляем LastOnline на тот же уровень, что и Versions

      // Добавляем узел <SMS> и дочерний узел <FolderPathFindRemember>
      m_ChildNode := m_RootNode.AddChild('SMS');
      m_ChildNode.AddChild('FolderPathFindRemember').Text := 'null'; // Значение по умолчанию

      // Добавляем узел <Font> и дочерние узлы <ActiveSip> (отвечает за размер шрифта)
      m_ChildNode := m_RootNode.AddChild('Font');
      m_ChildNode.AddChild('ActiveSip').Text  := '10'; // Значение по умолчанию
      m_ChildNode.AddChild('IVR').Text        := '10'; // Значение по умолчанию
      m_ChildNode.AddChild('Queue').Text      := '10'; // Значение по умолчанию

      // Добавляем узел <WindowState> и дочерний узел <State> (отвечает за состояние окна главной формы на весь экран или нет)
      m_ChildNode := m_RootNode.AddChild('WindowState');
      m_ChildNode.AddChild('State').Text      := 'wsMaximized'; // Значение по умолчанию

      // Сохраняем новый XML-документ
      m_XMLDoc.SaveToFile(m_fileSettings);
    finally
      m_XMLDoc:=nil;
    end;
 // finally
 //   m_mutex.Release;
 // end;
end;

// проверка существует ли новое значение
procedure TXML.checkExistNodeFields(inRootNode,InChildNode,inDefaultValue:string);
var
 InChildNodeRef:IXMLNode;
begin
  m_XMLDoc := LoadXMLDocument(m_fileSettings);
  try
    m_RootNode := m_XMLDoc.DocumentElement;

    // Проверяем наличие корневого узла
    if Assigned(m_RootNode) then
    begin
      // Проверяем наличие узла 'inRootNode'
      m_ChildNode := m_RootNode.ChildNodes.FindNode(inRootNode);

      // Если узел 'inRootNode' не найден, создаем его
      if not Assigned(m_ChildNode) then
      begin
        m_ChildNode := m_RootNode.AddChild(inRootNode);
      end;

      // Проверяем наличие узла 'InChildNode'
      InChildNodeRef := m_ChildNode.ChildNodes.FindNode(InChildNode);

      // Если узел 'InChildNode' не найден, создаем его
      if not Assigned(InChildNodeRef) then
      begin
        InChildNodeRef := m_ChildNode.AddChild(InChildNode);
        InChildNodeRef.Text := inDefaultValue; // Устанавливаем значение по умолчанию
      end;
    end
    else
    begin
      // Если корневой узел не найден, создаем его
      m_RootNode := m_XMLDoc.AddChild(inRootNode);
      m_ChildNode := m_RootNode.AddChild(InChildNode);

      InChildNodeRef := m_ChildNode.AddChild(InChildNode);
      InChildNodeRef.Text := inDefaultValue; // Устанавливаем значение по умолчанию;
    end;

    // Сохраняем изменения в файл только один раз
    m_XMLDoc.SaveToFile(m_fileSettings);
  finally
    m_XMLDoc := nil; // Освобождаем ресурс
  end;
end;

// конвертер string->boolean
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
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <SMS>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('SMS');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <FolderPathFindRemember>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('FolderPathFindRemember');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;


procedure TXML.SetFolderPathFindRemember(const Path: string);
begin
  // Проверяем наличие узла
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

// путь откуда будем забирать файл с услугами
function TXML.GetFolderPathService: string;
begin
  Result := 'null';

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <Service>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Service');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <FolderPathService>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('FolderPathService');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;


// установка пути откуда будем забирать файл с услугами
procedure TXML.SetFolderPathService(const Path: string);
begin
  // Проверяем наличие узла
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

// получение текущего размера шрифта
function TXML.GetFontSize(_font:enumFontSize):Word;
begin
  Result := 10;  // defaul value font size

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <Font>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('Font');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <EnumFontSize>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode(EnumFontSizeToString(_font));
      if Assigned(m_ChildNode) then
      begin
        Result:= StrToInt(m_ChildNode.Text); // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;

// установка размера шрифта
procedure TXML.SetFontSize(_font:enumFontSize; _value:Integer);
begin
  // Проверяем наличие узла
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

// получение текущего размера окна главной формы
function TXML.GetWindowState:string;
begin
   Result := 'wsMaximized';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <WindowState>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('WindowState');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <EnumFontSize>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('State');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;

// установка размера окна главной формы
procedure TXML.SetWindowState(_state:string);
begin
 // Проверяем наличие узла
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


// получение текущего значения отображать инфо о статусе callback
function TXML.GetMissedCallsShow:string;
begin
   Result := 'true';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <InfoMissedCallsShow>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('InfoMissedCallsShow');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <State>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Show');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;

// установка текущего значения отображать инфо о статусе callback
procedure TXML.SetMissedCallsShow(_state:string);
begin
 // Проверяем наличие узла
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



// получение текущего значения подтверждать действие при закрытии активной сессии
function TXML.GetActiveSessionConfirm:string;
begin
   Result := 'true';  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <InfoMissedCallsShow>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('ActiveSessionConfirm');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <State>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Show');
      if Assigned(m_ChildNode) then
      begin
        Result:= m_ChildNode.Text; // Возвращаем текст узла
      end;
    end;
  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;
end;


// установка текущего значения подтверждать действие при закрытии активной сессии
procedure TXML.SetActiveSessionConfirm(_state:string);
begin
 // Проверяем наличие узла
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

// получение текущего значения положения окна статусы оператора
function TXML.GetStatusOperatorPosition(var _left:Integer; var _top: Integer):Boolean;
begin
  Result:=false;  // defaul value state

  if not isExistSettingsFile then
  begin
    m_XMLDoc := nil; // Освобождаем ресурсы
    Exit;
  end;

  // Загружаем XML-документ
  m_XMLDoc:= LoadXMLDocument(m_fileSettings);
  try
    m_RootNode:= m_XMLDoc.DocumentElement;

    // Проверяем наличие узла <PanelStatusOperatorPosition>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition');
    if Assigned(m_ChildNode) then
    begin
      // Проверяем наличие узла <X>
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('X');
      if Assigned(m_ChildNode) then
      begin
        _left:= StrToInt(m_ChildNode.Text); // Возвращаем текст узла
      end;
    end;

    // Проверяем наличие узла <PanelStatusOperatorPosition>
    m_ChildNode := m_RootNode.ChildNodes.FindNode('PanelStatusOperatorPosition');
    if Assigned(m_ChildNode) then
    begin
      m_ChildNode := m_ChildNode.ChildNodes.FindNode('Y');
      if Assigned(m_ChildNode) then
      begin
        _top:= StrToInt(m_ChildNode.Text); // Возвращаем текст узла
      end;
    end;

    Result:=(_left > 0) and (_top > 0);

  finally
    m_XMLDoc := nil; // Освобождаем ресурсы
  end;

end;

// есть ли данные по позиции панели
function TXML.IsExistStatusOperatorPosition:Boolean;
var
 X,Y:Integer;
begin
  X:=0;
  Y:=0;
  Result:=GetStatusOperatorPosition(X,Y);
end;

// установка текущего значения положения окна статусы оператора
procedure TXML.SetStatusOperatorPosition(_left,_top:Integer);
begin
  // Проверяем наличие узла
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
