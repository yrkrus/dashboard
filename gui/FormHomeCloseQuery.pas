unit FormHomeCloseQuery;

interface
  uses System.SysUtils, Winapi.Windows;


procedure _CLOSEQUERY(Sender: TObject; var CanClose: Boolean);   // инициализация формы


implementation

uses
  FormHome, GlobalVariables, FunctionUnit, GlobalVariablesLinkDLL, FormDEBUGUnit, TCustomTypeUnit,
  vcl.Forms, vcl.StdCtrls, TPhoneListUnit, Vcl.Dialogs;


procedure _CLOSEQUERY(Sender: TObject; var CanClose: Boolean);
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  DialogResult: Integer;
  errorDescription:string;
  regPhone:TPhoneList;
begin
  if DEBUG then begin
    KillProcess;
  end;

  if SharedCurrentUserLogon.IsOperator then begin

    // проверяемв друг еще в очереди находится оператор
     if SharedActiveSipOperators.isExistOperatorInQueue(_dll_GetOperatorSIP(SharedCurrentUserLogon.ID)) then begin
       CanClose:= Application.MessageBox(PChar('Вы забыли выйти из очереди'), 'Ошибка при выходе', MB_OK + MB_ICONERROR) = IDNO;
       Exit;
     end;

    // проверяем правильно ли оператор вышел через команду
    if getIsExitOperatorCurrentGoHome(SharedCurrentUserLogon.Role, SharedCurrentUserLogon.ID) then begin
      CanClose:= Application.MessageBox(PChar('Прежде чем закрыть, необходимо выбрать статус "Домой"'), 'Ошибка при выходе', MB_OK + MB_ICONERROR) = IDNO;
      Exit;
    end;

   // разрегистрация в тлф
   regPhone:=TPhoneList.Create;
   if regPhone.IsRegisterdSip[_dll_GetOperatorSIP(SharedCurrentUserLogon.ID)] then begin
    OpenRegPhone(eAutoRunningDeRegistered);
   end;
  end;

  if not SharedIndividualSettingUser.NoConfirmExit then begin
    AMsgDialog := CreateMessageDialog('Вы действительно хотите завершить работу?', mtConfirmation, [mbYes, mbNo]);
    ACheckBox := TCheckBox.Create(AMsgDialog);

    with AMsgDialog do
    try
      Caption:= 'Уточнение выхода';
      Height:= 150;
      (FindComponent('Yes') as TButton).Caption := 'Да';
      (FindComponent('No')  as TButton).Caption := 'Нет';

      with ACheckBox do begin
        Parent:= AMsgDialog;
        Caption:= 'Не показывать больше это сообщение';
        Top:= 100;
        Left:= 8;
        Width:= AMsgDialog.Width;
      end;

      DialogResult:= ShowModal; // Сохраняем результат в переменной

      if DialogResult = ID_YES then
      begin
        if ACheckBox.Checked then begin
          // созраняем параметр чтобы больше не показывать это окно
         SharedIndividualSettingUser.SaveIndividualSettingUser(settingUsers_noConfirmExit,paramStatus_ENABLED,errorDescription);
        end;

        KillProcess;
      end
      else if DialogResult = ID_NO then
      begin
        Abort; // Отмена выхода
      end else Abort;

    finally
      FreeAndNil(ACheckBox);
      Free;
    end;
  end;
  KillProcess;
end;

end.
