program chat;

uses
  Vcl.Forms,
  HomeForm in 'HomeForm.pas' {FormHome},
  GlobalVariables in 'GlobalVariables.pas',
  Functions in 'Functions.pas',
  Thread_Users in 'Thread_Users.pas',
  Thread_MessageMain in 'Thread_MessageMain.pas',
  CustomTypeUnit in 'CustomTypeUnit.pas',
  TSendMessageUnit in '..\custom_class\TSendMessageUnit.pas',
  TOnlineUsersUint in '..\custom_class\TOnlineUsersUint.pas',
  TOnlineChatUnit in '..\custom_class\TOnlineChatUnit.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.HintHidePause:=60000;
  Application.HintPause:=100;

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;
end.
