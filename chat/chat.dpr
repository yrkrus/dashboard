program chat;

uses
  Vcl.Forms,
  HomeForm in 'HomeForm.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  Functions in 'Functions.pas',
  Thread_Users in 'Thread_Users.pas',
  TOnlineUsersUint in 'TOnlineUsersUint.pas',
  TOnlineChatUnit in 'TOnlineChatUnit.pas',
  TSendMessageUnit in 'TSendMessageUnit.pas',
  Thread_MessageMain in 'Thread_MessageMain.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
