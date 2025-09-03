unit FormHomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

type
  TFormHome = class(TForm)
    panel_number: TPanel;
    Label2: TLabel;
    panel_buttons: TPanel;
    ImgNewYear: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    img0: TImage;
    img0_draw: TImage;
    StatusBar: TStatusBar;
    Image11: TImage;
    Edit1: TEdit;
    StaticText1: TStaticText;
    Image12: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ProcessCommandLineParams(DEBUG:Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation

uses
  GlobalVariablesLinkDLL, GlobalVariables, TCustomTypeUnit, FunctionUnit;

{$R *.dfm}

procedure TFormHome.ProcessCommandLineParams(DEBUG:Boolean);
var
  i: Integer;
begin
  if DEBUG then begin
   USER_STARTED_OUTGOING_ID:=1;
   USER_ACCESS_SENDING_LIST:=True;
   Exit;
  end;

  if ParamCount = 0 then begin
   MessageBox(Handle,PChar('Приложение можно запустить только из дашборда'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  for i:= 1 to ParamCount do
  begin
    if ParamStr(i) = '--USER_ID' then
    begin
      if (i + 1 <= ParamCount) then
      begin
        USER_STARTED_OUTGOING_ID:= StrToInt(ParamStr(i + 1));
       // if DEBUG then ShowMessage('Value for --USER_ID: ' + ParamStr(i + 1));

      end
      else
      begin
        MessageBox(Handle,PChar('Слишком много параметров'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
        KillProcessNow;
      end;
    end;
  end;
end;

procedure TFormHome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 KillProcessNow;
end;

procedure TFormHome.FormCreate(Sender: TObject);
begin
  // проверка на запуска 2ой копи
  if GetCloneRun(Pchar(OUTGOING_EXE)) then begin
    MessageBox(Handle,PChar('Обнаружен запуск 2ой копии звонилки(хз как назвать потом переименовать)'+#13#13+ // TODO назвать как нить по другому
                            'Для продолжения закройте предыдущую копию'),PChar('Ошибка запуска'),MB_OK+MB_ICONERROR);
   KillProcessNow;
  end;

  ProcessCommandLineParams(DEBUG);
end;

procedure TFormHome.FormShow(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;

  // debug node
  if DEBUG then begin
    Caption:='DEBUG | (base:'+GetDefaultDataBase+') '+Caption;
  end;


 // создатим copyright
  CreateCopyright;


  Screen.Cursor:=crDefault;
end;

end.
