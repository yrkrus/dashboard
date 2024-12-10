unit FormWaitUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls;

type
  TFormWait = class(TForm)
    Label1: TLabel;
    MP: TMediaPlayer;
    PanelPlay: TPanel;
    procedure FormShow(Sender: TObject);
    procedure MPNotify(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWait: TFormWait;

implementation

{$R *.dfm}

procedure TFormWait.FormShow(Sender: TObject);
const
 FilePlay:string = 'time.mpg';
begin
    if FileExists(FilePlay) then begin
      with MP do begin
       { FileName:=FilePlay;
        Display:=PanelPlay;
        Open;
        AutoRewind:=true;
        DisplayRect:=PanelPlay.ClientRect;
        Play;
        Notify:=true;}
      end;
    end;
end;

procedure TFormWait.MPNotify(Sender: TObject);
begin
   if MP.NotifyValue=nvSuccessful then begin
    MP.Play;
    MP.Notify := True;
  end;
end;



end.
