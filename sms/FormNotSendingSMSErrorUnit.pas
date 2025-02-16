unit FormNotSendingSMSErrorUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.ExtCtrls,IdException;

type
  TFormNotSendingSMSError = class(TForm)
    panel_Error: TPanel;
    re_LogError: TRichEdit;
    btnLoadFile: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
  private
    { Private declarations }
  procedure ShowError;
  function SaveFile(var _errorDescription:string):Boolean;

  public
    { Public declarations }
  end;

var
  FormNotSendingSMSError: TFormNotSendingSMSError;

implementation

uses
  GlobalVariables, FunctionUnit;

{$R *.dfm}


// отображение лога с ошибками отправки
procedure TFormNotSendingSMSError.btnLoadFileClick(Sender: TObject);
var
 error:string;
begin
  if re_LogError.Lines.Count = 0 then Exit;

  if not SaveFile(error) then begin
   MessageBox(Handle,PChar(error),PChar('Ошибка'),MB_OK+MB_ICONERROR);
   Exit;
  end;

  if error<>'' then begin
    MessageBox(Handle,PChar(error),PChar('Успех'),MB_OK+MB_ICONINFORMATION);
    Close;
  end;
end;

procedure TFormNotSendingSMSError.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShowError;
  Caption:='Ошибки ('+IntToStr(SharedPacientsListNotSending.Count)+')';

  Screen.Cursor:=crDefault;
end;

procedure TFormNotSendingSMSError.ShowError;
var
 i:Integer;
begin
  // очищаем данные, вдруг еще раз будет прогрузка
  re_LogError.Clear;

  for i:=0 to SharedPacientsListNotSending.Count-1 do begin
    CreateLogAddColoredLine(re_LogError,SharedPacientsListNotSending.GetErrorDescriptions(i),clRed);
    CreateLogAddColoredLine(re_LogError,SharedPacientsListNotSending.ShowPacientInfo(i),clBlack);
  end;
end;


// сохранение файла
function TFormNotSendingSMSError.SaveFile(var _errorDescription:string):Boolean;
var
  SaveDialog: TSaveDialog;
  FileName: string;
begin
  Result:=False;
  _errorDescription:='';

  SaveDialog := TSaveDialog.Create(nil);
  try
      // Устанавливаем фильтр для типов файлов
      SaveDialog.Filter := 'Rich Text Format (*.rtf)|*.rtf';
      SaveDialog.DefaultExt := 'rtf'; // Устанавливаем расширение по умолчанию
      SaveDialog.Title := 'Сохранить в файл ... ';

      // Показываем диалог и проверяем, был ли выбран файл
      if SaveDialog.Execute then
      begin
        try
          re_LogError.Lines.SaveToFile(SaveDialog.FileName);
        except on E: EIdException do
          begin

           _errorDescription:='Не удалось сохранить в файл'+#13#10+SaveDialog.FileName+#13#13+
                              e.ClassName+': '+E.Message;
           SaveDialog.Free;
           Exit;
          end;
       end;
      end;
  finally
    if SaveDialog.FileName<>'' then _errorDescription:='Сохранено в '+#13+SaveDialog.FileName;
    SaveDialog.Free;
  end;

  Result:=True;
end;
end.
