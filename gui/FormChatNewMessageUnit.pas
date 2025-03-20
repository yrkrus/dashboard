unit FormChatNewMessageUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw;

type
  TFormChatNewMessage = class(TForm)
    chat_message: TWebBrowser;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChatNewMessage: TFormChatNewMessage;

implementation

uses
  FunctionUnit;

{$R *.dfm}





procedure TFormChatNewMessage.FormCreate(Sender: TObject);
begin
  // поверх всех окон
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

end.
