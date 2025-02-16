unit FormEditTemplateUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormEditTemplate = class(TForm)
    ST_StatusPanel: TStaticText;
    panel_ManualSMS: TPanel;
    re_EditMessage: TRichEdit;
    lblMsg: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure re_EditMessageChange(Sender: TObject);
  private
    { Private declarations }
  editID:Integer;       // id сообщения
  editMessage:string;  // текст сообщения которое будем редавтировать
  isGlobal:Boolean;    // глобальное ли сообщение или нет

  isChangeEdit:Boolean;

  public
    { Public declarations }
  procedure ShowEditMessage(InID:Integer; InMessage:string; isGlobalMessage:Boolean = False);


  end;

var
  FormEditTemplate: TFormEditTemplate;

implementation

uses
  FunctionUnit, FormMyTemplateUnit;

{$R *.dfm}

procedure TFormEditTemplate.FormClose(Sender: TObject;
  var Action: TCloseAction);
 var
  resultat:Word;
  NewMessage:string;
begin
  if not isChangeEdit then Exit;  

  // проверка было ли отркедактировано сообщение
  NewMessage:=CreateSMSMessage(re_EditMessage);

  if Length(editMessage) <> Length(NewMessage) then begin
    if NewMessage = '' then begin
       resultat:=MessageBox(Handle,PChar('Шаблон пуст, удалить его?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);
        if resultat=mrYes then begin
          SaveMyTemplateMessage(editID,'',True);
          // обновляем данные
          FormMyTemplate.ShowData;
          Exit;
        end;

        Exit;
    end;

     // изменился текст
    resultat:=MessageBox(Handle,PChar('Сохранить измененный текст сообщения?'),PChar('Уточнение'),MB_YESNO+MB_ICONQUESTION);

    if resultat=mrYes then begin
       SaveMyTemplateMessage(editID, NewMessage);

       // обновляем данные
       FormMyTemplate.ShowData;
    end;
  end;
end;

procedure TFormEditTemplate.FormShow(Sender: TObject);
begin
  re_EditMessage.Text:=editMessage;
  isChangeEdit:=False;
end;

procedure TFormEditTemplate.re_EditMessageChange(Sender: TObject);
begin
 isChangeEdit:=True;
end;

procedure TFormEditTemplate.ShowEditMessage(InID:Integer; InMessage:string; isGlobalMessage:Boolean = False);
begin
  editID:=InID;
  editMessage:=InMessage;
  isGlobal:=isGlobalMessage;
end;


end.
