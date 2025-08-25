unit FormSendingSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, TShowMessageSMSUnit;

type
  TFormSendingSMS = class(TForm)
    panel: TPanel;
    re_LogSending: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  m_showTodaySendingSMS:Boolean;  // показываем отправленные за сегодня смс или массовую расслыку
  m_sendingSMS:TShowMessageSMS;

  procedure Show;

  procedure CreateLogAddColoredLine(var p_Log: TRichEdit;
                                    InMessagePhone: string; InColorPhone: TColor;
                                    InMessage: string; InColor: TColor);

  public
    { Public declarations }
  procedure SetTodaySendingSms(_value:Boolean);

  end;

var
  FormSendingSMS: TFormSendingSMS;

implementation

uses
  GlobalVariables;

{$R *.dfm}


procedure TFormSendingSMS.SetTodaySendingSms(_value:Boolean);
begin
  m_showTodaySendingSMS:=_value;
end;


procedure TFormSendingSMS.CreateLogAddColoredLine(var p_Log: TRichEdit;
                                                  InMessagePhone: string; InColorPhone: TColor;
                                                  InMessage: string; InColor: TColor);
begin
 with p_Log do
  begin
    // Устанавливаем курсор в конец текста
    SelStart := Length(Text);

    // Добавляем первое сообщение с первым цветом
    SelAttributes.Color := InColorPhone;
    SelAttributes.Size := 10;
    SelAttributes.Name := 'Tahoma';
    SelText := InMessagePhone; // Используем SelText для добавления текста

    // Добавляем три пробела
    SelText := '   ';

    // Добавляем второе сообщение с вторым цветом
    SelAttributes.Color := InColor;
    SelText := InMessage; // Используем SelText для добавления текста

    // Прокрутка к последней строке
    Perform(EM_LINESCROLL, 0, Lines.Count - 1);
    Lines.Add('');
    SetFocus;
  end;
end;



procedure TFormSendingSMS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 m_showTodaySendingSMS:=False;
end;

procedure TFormSendingSMS.FormShow(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;

  Show;

  Screen.Cursor:=crDefault;
end;

procedure TFormSendingSMS.Show;
var
 i:Integer;
 sendingStatus:TColor;
 sendingError:Boolean;
 messageSMS:string;
begin
  // очищаем данные, вдруг еще раз будет прогрузка
  re_LogSending.Clear;

  if not m_showTodaySendingSMS then begin
    for i:=0 to SharedPacientsList.Count-1 do begin

      CreateLogAddColoredLine(re_LogSending,
                              SharedPacientsList.GetPhone(i),clGreen,
                              SharedPacientsList.CreateMessage(i, REMEMBER_MESSAGE),clBlack);
    end;
  end
  else begin
   // текущие отправленные смс
   m_sendingSMS:=TShowMessageSMS.Create;

   for i:=0 to m_sendingSMS.Count-1 do begin
     if m_sendingSMS.Sending[i] then begin
       sendingStatus:=clGreen;
       sendingError:=False;
     end
     else begin
      sendingStatus:=clRed;
      sendingError:=True;
     end;

     messageSMS:=m_sendingSMS.GetUserInfoSending(i,sendingError);

     CreateLogAddColoredLine(re_LogSending,
                             messageSMS,sendingStatus,
                             m_sendingSMS.GetMessageSMS(i),clBlack);
   end;
  end;

  re_LogSending.SelStart:=0;
end;

end.
