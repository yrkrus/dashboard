unit FormPodborUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  TAutoPodborPeopleUnit, TAutoPodborSendingSmsUnit;

 type
  enumTypePodbor =
  (
    eTypePodporPeople,  // тип подбора для отображения ФИО пациентов
    eTypePodporSMS      // тип подбора для отображения отправленных СМС на номера
  );


type
  TFormPodbor = class(TForm)
    lblHeader: TLabel;
    list_podpor: TListBox;
    lblFooter: TLabel;
    procedure FormShow(Sender: TObject);
    procedure list_podporDblClick(Sender: TObject);
  private
    { Private declarations }
  m_type:enumTypePodbor;        // тип данных которые будем отображать
  listPacients:TAutoPodborPeople;
  listSendingSMS:TAutoPodborSendingSms;

  procedure LoadData;         // подгрузка данных
  procedure LoadDataPeople;
  procedure LoadDataSmsSending;

  public
    { Public declarations }
  procedure SetTypePodbor(_type:enumTypePodbor);
  procedure SetListPacients(const _people:TAutoPodborPeople);
  procedure SetListSendingSMS(const _sending:TAutoPodborSendingSms);



  end;

var
  FormPodbor: TFormPodbor;

implementation

uses
  FormGenerateSMSUnit, FormStatusSendingSMSUnit;

{$R *.dfm}


procedure TFormPodbor.SetTypePodbor(_type:enumTypePodbor);
begin
  m_type:=_type;
end;


procedure TFormPodbor.SetListPacients(const _people:TAutoPodborPeople);
begin
 listPacients:=_people;
end;

procedure TFormPodbor.SetListSendingSMS(const _sending:TAutoPodborSendingSms);
begin
  listSendingSMS:=_sending;
end;

procedure TFormPodbor.FormShow(Sender: TObject);
begin
  LoadData;
end;

procedure TFormPodbor.list_podporDblClick(Sender: TObject);
var
 id:Integer;
begin
  id:=list_podpor.ItemIndex;
  if id = -1 then begin
    case m_type of
      eTypePodporPeople: begin
       MessageBox(Handle,PChar('Не выбран пациент'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      end;
      eTypePodporSMS: begin
       MessageBox(Handle,PChar('Не выбран номер телефона'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      end;
    end;
    Exit;
  end;

  case m_type of
    eTypePodporPeople: begin
     FormGenerateSMS.SetAutoPodborValue(listPacients.FirstName(id), listPacients.MidName(id), listPacients.Gender(id));
    end;
    eTypePodporSMS: begin
     FormStatusSendingSMS.SetSmsInfo(listSendingSMS,id);
    end;
  end;

  Close;
end;


procedure TFormPodbor.LoadDataPeople;
var
 i:Integer;
begin
  lblHeader.Caption:='Найденные пациенты по номеру телефона';
  lblFooter.Caption:='для выбора нужного пациента нужно два раз кликнуть левой кл.мыши';

  list_podpor.Clear;
  for i:=0 to listPacients.Count-1 do begin
    list_podpor.Items.Add(listPacients.GetFIO(i));
  end;
end;

procedure TFormPodbor.LoadDataSmsSending;
  var
 i:Integer;
begin
  lblHeader.Caption:='Найдено несколько дат';
  lblFooter.Caption:='для выбора нужно два раз кликнуть левой кл.мыши ';

  list_podpor.Clear;
  for i:=0 to listSendingSMS.Count-1 do begin
    list_podpor.Items.Add(listSendingSMS.Status[i]);
  end;
end;


procedure TFormPodbor.LoadData;
begin
  case m_type of
    eTypePodporPeople: begin
      LoadDataPeople;
    end;
    eTypePodporSMS: begin
      LoadDataSmsSending;
    end;
  end;
end;

end.
