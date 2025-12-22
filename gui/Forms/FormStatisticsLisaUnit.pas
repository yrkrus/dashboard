unit FormStatisticsLisaUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormStatisticsLisa = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblAll: TLabel;
    lblAnswered: TLabel;
    lblUnAnswered: TLabel;
    lblToOperator: TLabel;
    procedure FormShow(Sender: TObject);
  private
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
  TLisaStatisticsDayUnit;

{$R *.dfm}

procedure TFormStatisticsLisa.ClearData;
begin
  lblAll.Caption:='---';
  lblAnswered.Caption:='---';
  lblUnAnswered.Caption:='---';
  lblToOperator.Caption:='---';
end;



procedure TFormStatisticsLisa.LoadData;
var
 lisaStat:TLisaStatisticsDay;
begin
 ClearData;

 lisaStat:=TLisaStatisticsDay.Create(now);
 lblAll.Caption:=IntToStr(lisaStat.All);
 lblAnswered.Caption:=IntToStr(lisaStat.Answered);
 lblUnAnswered.Caption:=IntToStr(lisaStat.Unanswered);

end;




procedure TFormStatisticsLisa.FormShow(Sender: TObject);
begin
  LoadData;
end;

end.
