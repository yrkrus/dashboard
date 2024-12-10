unit FormSettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Grids,Data.Win.ADODB, Data.DB, IdException, Vcl.Menus;

type
  TFormSettings = class(TForm)
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;


implementation

uses
  FunctionUnit, DMUnit, FormAddNewUsersUnit, FormHome, FormUsersUnit, FormServersIKUnit, FormSettingsGlobalUnit, FormTrunkUnit;

{$R *.dfm}


procedure TFormSettings.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;


end.
