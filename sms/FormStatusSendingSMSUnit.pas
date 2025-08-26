unit FormStatusSendingSMSUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Data.DB, Data.Win.ADODB, Vcl.Imaging.pngimage, System.ImageList,
  Vcl.ImgList, TCustomTypeUnit;

type
  TFormStatusSendingSMS = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label8: TLabel;
    lblID: TLabel;
    lblDateSend: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnSaveFirebirdSettings: TBitBtn;
    lblPhone: TLabel;
    re_MessageText: TRichEdit;
    lblStatus: TLabel;
    lblCode: TLabel;
    lblTimeStatus: TLabel;
    lblFIO: TLabel;
    ImgNewYear: TImage;
    img_list: TImageList;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  m_phone:string;
  m_table:enumReportTableSMSStatus;


  procedure ShowStatus;
  procedure Clear;
  public
    { Public declarations }
   procedure SetPhone(_phone:string);
   procedure SetTable(_table:enumReportTableSMSStatus);

   function IsExistPhoneFind:Boolean;

  end;

var
  FormStatusSendingSMS: TFormStatusSendingSMS;

implementation

uses
  FunctionUnit, GlobalVariablesLinkDLL;

{$R *.dfm}


procedure TFormStatusSendingSMS.SetPhone(_phone:string);
begin
  m_phone:=_phone;
end;

procedure TFormStatusSendingSMS.SetTable(_table:enumReportTableSMSStatus);
begin
  m_table:=_table;
end;


function TFormStatusSendingSMS.IsExistPhoneFind:Boolean;
begin
  Result:=False;
  if Length(m_phone) <> 0 then Result:=True;
end;


procedure TFormStatusSendingSMS.ShowStatus;
begin
  showWait(show_open);
  // проверим кол-во сообщений в БД



  showWait(show_close);
end;

procedure TFormStatusSendingSMS.Clear;
begin
  m_phone:='';
end;

procedure TFormStatusSendingSMS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Clear;
end;

procedure TFormStatusSendingSMS.FormShow(Sender: TObject);
begin
 ShowStatus;
end;

end.
