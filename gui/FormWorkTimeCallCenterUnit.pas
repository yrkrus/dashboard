unit FormWorkTimeCallCenterUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Samples.Spin, TWorkTimeCallCenterUnit;

type
  TFormWorkTimeCallCenter = class(TForm)
    btnSaveWorkTime: TBitBtn;
    Label9: TLabel;
    Label1: TLabel;
    SE_start: TSpinEdit;
    SE_stop: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveWorkTimeClick(Sender: TObject);
  private
    m_workTimeCallCenter  :TWorkTimeCallCenter;


    procedure ShowWorkTime;

    { Private declarations }

  public
    { Public declarations }
  end;

var
  FormWorkTimeCallCenter: TFormWorkTimeCallCenter;

implementation

uses
  FormSettingsGlobalUnit;



{$R *.dfm}

procedure TFormWorkTimeCallCenter.ShowWorkTime;
begin
  m_workTimeCallCenter:=TWorkTimeCallCenter.Create;

  SE_start.Value:=m_workTimeCallCenter.StartTime;
  SE_stop.Value:=m_workTimeCallCenter.StopTime;
end;


procedure TFormWorkTimeCallCenter.btnSaveWorkTimeClick(Sender: TObject);
var
 error:string;
 start,stop:Integer;
begin
  start:=SE_start.Value;
  stop:=SE_stop.Value;

  if not m_workTimeCallCenter.SaveWorkToBase(start, stop, error) then begin
    MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
    Exit;
  end;

  Close;
end;

procedure TFormWorkTimeCallCenter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // обновим данные
  FormSettingsGlobal.ShowWorkTimeCallCenter;
end;

procedure TFormWorkTimeCallCenter.FormShow(Sender: TObject);
begin
  ShowWorkTime;



end;

end.
