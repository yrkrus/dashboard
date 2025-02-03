unit FormDEBUGUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormDEBUG = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblThread_ACTIVESIP: TLabel;
    lblThread_ACTIVESIP_countTalk: TLabel;
    lblThread_ACTIVESIP_Queue: TLabel;
    lblThread_ACTIVESIP_updatePhoneTalk: TLabel;
    lblThread_ACTIVESIP_updateTalk: TLabel;
    lblThread_AnsweredQueue: TLabel;
    lblThread_CHECKSERVERS: TLabel;
    lblThread_IVR: TLabel;
    lblThread_QUEUE: TLabel;
    lblThread_Statistics: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    lblThread_Chat: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label36: TLabel;
    lblThread_InternalProcess: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDEBUG: TFormDEBUG;

implementation

{$R *.dfm}

procedure TFormDEBUG.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

end.
