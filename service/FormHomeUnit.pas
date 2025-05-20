unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TFormHome = class(TForm)
    StatusBar: TStatusBar;
    group_load_service: TGroupBox;
    btnLoadFile: TBitBtn;
    Label2: TLabel;
    lblNameExcelFile: TLabel;
    OpenDialog: TOpenDialog;
    btnLoadService: TBitBtn;
    ProgressStatusText: TStaticText;
    btnListService: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ProcessCommandLineParams(DEBUG:Boolean = False);
    procedure FormShow(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnLoadServiceClick(Sender: TObject);
  private

   procedure Clear;
   procedure UpdateCountService;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation

uses
  GlobalVariables, GlobalVariablesLinkDLL, FunctionUnit, TXmlUnit, TCustomTypeUnit, TServiceUnit;

{$R *.dfm}


procedure TFormHome.btnLoadServiceClick(Sender: TObject);
var
 error:string;
begin
  // ���������� ������ � ������
  if not SharedServiceList.Update(SharedServiceListLoading, ProgressStatusText, error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  // ��������� ����� ���-�� ����������� �����
  UpdateCountService;
  MessageBox(Handle,PChar('������ ���������'),PChar('�����'),MB_OK+MB_ICONINFORMATION);
  btnLoadService.Enabled:=False;
end;

procedure TFormHome.Clear;
begin
  btnLoadService.Enabled:=False;

  lblNameExcelFile.Caption:='�� ���������';
  lblNameExcelFile.Font.Color:=clRed;
  ProgressStatusText.Caption:='������ : ';

end;


procedure TFormHome.UpdateCountService;
begin
 // debug node
  Caption:='������';

  if DEBUG then begin
    Caption:='    ===== DEBUG =====    ' + Caption;
  end;

  Caption:=Caption+' ('+IntToStr(SharedServiceList.Count)+')';

  // �������� ������ ��� ��������
  SharedServiceListLoading.Clear;
end;


procedure TFormHome.FormShow(Sender: TObject);
var
 error:string;
begin
  showWait(show_open);
  if not Assigned(SharedServiceList) then SharedServiceList:=TService.Create;  // TODO ������� ���� ����� ���� ���� � ��� ��� ���� ������ �� �������
  Application.ProcessMessages;

  UpdateCountService;

   // �������� copyright
  createCopyright;

  // �������� ���������� �� excel
  if not isExistExcel(error) then begin
   showWait(show_close);
   MessageBox(Handle,PChar('Excel �� ����������'+#13#13+error),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  showWait(show_close);
end;

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_SERVICE_ID:=1;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('������ ����� ��������� ������ �� ��������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_SERVICE_ID:= StrToInt(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('������� ����� ����������'),PChar('������ �������'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;


procedure TFormHome.btnLoadFileClick(Sender: TObject);
var
 FileExcelService:string;
 error:string;
 XML:TXML;
 FindPath:string;
 FullPath:string;
begin
  Clear;

  // ����� ����������� ����
  XML:=TXML.Create(PChar(SETTINGS_XML));
  FindPath:=XML.GetFolderPathService;
  if FindPath = 'null' then FindPath:=FOLDERPATH;


  with OpenDialog do begin
     Title:='�������� �����';
     DefaultExt:='csv';
     Filter:='���� csv| *.csv';
     FilterIndex:=1;
     InitialDir:=FindPath;

      if Execute then
      begin
         FileExcelService:=FileName;
         while AnsiPos('\',FileExcelService)<>0 do System.Delete(FileExcelService,1,AnsiPos('\',FileExcelService));
         lblNameExcelFile.Caption:=FileExcelService;
         lblNameExcelFile.Hint:=FileName;
         lblNameExcelFile.Font.Color:=clGreen;

         FileExcelService:=FileName;

         // ��������� ����
         FullPath:=ExtractFilePath(FileName);
         XML.SetFolderPathService(FullPath);
      end;
  end;

  if FileExcelService='' then Exit;

  // ���������� ������ � ������
  if not LoadData(FileExcelService, ProgressStatusText, error) then begin
    MessageBox(Handle,PChar(error),PChar('������'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  btnLoadService.Enabled:=True;
end;

procedure TFormHome.FormCreate(Sender: TObject);
begin
  // �������� �� ������� 2�� ����
  if GetCloneRun(Pchar(SERVICE_EXE)) then begin
    MessageBox(Handle,PChar('��������� ������ 2�� ����� �����'+#13#13+
                            '��� ����������� �������� ���������� �����'),PChar('������ �������'),MB_OK+MB_ICONERROR);
    KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;

end.
