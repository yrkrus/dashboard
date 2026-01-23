unit FormStatisticsLisaUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, TThreadDispatcherUnit;

type
  TFormStatisticsLisa = class(TForm)
    group: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblToOperator: TLabel;
    ST_All: TStaticText;
    ST_Answered: TStaticText;
    ST_UnAnswered: TStaticText;
    lblOpenGenerateMessage: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblOpenGenerateMessageClick(Sender: TObject);
  private

    m_dispatcher    :TThreadDispatcher;   // планировщик
    m_all_old:Integer;
    m_answered_old:Integer;
    m_unanswered_old:Integer;

    { Private declarations }
  procedure LoadData;
  procedure ClearData;

  public
    { Public declarations }
  end;

var
  FormStatisticsLisa: TFormStatisticsLisa;

implementation

uses
  TLisaStatisticsDayUnit, FormStatisticsLisaShowUnit;

{$R *.dfm}

procedure TFormStatisticsLisa.ClearData;
begin
  ST_All.Caption:='---';
  ST_Answered.Caption:='---';
  ST_UnAnswered.Caption:='---';
  lblToOperator.Caption:='---';
end;


procedure TFormStatisticsLisa.LoadData;
var
 lisaStat:TLisaStatisticsDay;
begin
 lisaStat:=TLisaStatisticsDay.Create(now);

 if lisaStat.All <> m_all_old then begin
  ST_All.Caption:=IntToStr(lisaStat.All);
  m_all_old:=lisaStat.All;
 end;

  if lisaStat.Answered <> m_answered_old then begin
  ST_Answered.Caption:=IntToStr(lisaStat.Answered);
  m_answered_old:=lisaStat.Answered;
 end;

  if lisaStat.Unanswered <> m_unanswered_old then begin
  ST_UnAnswered.Caption:=IntToStr(lisaStat.Unanswered);
  m_unanswered_old:=lisaStat.Unanswered;
 end;

 FreeAndNil(lisaStat);
end;


procedure TFormStatisticsLisa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // остановливаем планировщик
  m_dispatcher.StopThread;

  if FormStatisticsLisaShow.Showing then FormStatisticsLisaShow.Close;
end;

procedure TFormStatisticsLisa.FormShow(Sender: TObject);
begin
 ClearData;

 m_all_old:=0;
 m_answered_old:=0;
 m_unanswered_old:=0;

 // создаем диспетчера
 if not Assigned(m_dispatcher) then begin
  m_dispatcher:=TThreadDispatcher.Create('FormStatisticsLisaShow',3,False,LoadData);
 end;
 LoadData;

 m_dispatcher.StartThread;
end;

procedure TFormStatisticsLisa.lblOpenGenerateMessageClick(Sender: TObject);
begin
  FormStatisticsLisaShow.Show;
end;

end.
