unit FormServiceChoiseUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, TServiceUnit, RegularExpressions;

type
  TFormServiceChoise = class(TForm)
    editFind: TEdit;
    st_FindMessage: TStaticText;
    group_tree: TGroupBox;
    tree_menu: TTreeView;
    Label1: TLabel;
    lblChoiseCount: TLabel;
    btnShowChoise: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure editFindClick(Sender: TObject);
    procedure editFindChange(Sender: TObject);
    procedure tree_menuDblClick(Sender: TObject);
    procedure btnShowChoiseClick(Sender: TObject);
  private
    { Private declarations }
  serviceList       :TService;

  procedure LoadSettings;    // ��������� ���������
  procedure LoadTree(var _tree:TTreeView; var _nodeIxistList:TStringList; _service:TStructService);
  procedure CreateTree(const _findName:string = '');      // ��������� ������ (� �������)
  function IsTreeNodeExist(const _list:TStringList; _destinationName:string):Boolean;    // ���� �� ��� ����� ����
  function ExtractTextAfterParentheses(const Input: string; var isError:Boolean): string;

  public
    { Public declarations }
  end;

var
  FormServiceChoise: TFormServiceChoise;

implementation

uses
  FunctionUnit, TCustomTypeUnit, FormGenerateSMSUnit, FormServiceChoiseListUnit;


{$R *.dfm}

// ���� �� ��� ����� ����
function TFormServiceChoise.IsTreeNodeExist(const _list:TStringList; _destinationName:string):Boolean;
var
 i:Integer;
begin
   Result:=False;

   for i:=0 to _list.Count-1 do begin
     if _list[i] = _destinationName then begin
       Result:=True;
       Exit;
     end;
   end;
end;


procedure TFormServiceChoise.LoadTree(var _tree:TTreeView; var _nodeIxistList:TStringList; _service:TStructService);
var
  ParentNode: TTreeNode;
begin
  // ���������, ���������� �� ������������ ����
  if not IsTreeNodeExist(_nodeIxistList, _service.m_destination) then
  begin
    // ��������� ������������ ����
    ParentNode := _tree.Items.Add(nil, _service.m_destination); // �������� ������ ��� ������������ ����
    ParentNode.Data := Pointer(_service.m_destination); // ��������� ������ �� ������

    _nodeIxistList.Add(_service.m_destination);
  end
  else
  begin
    // ���� ���� ��� ����������, �������� ���
    ParentNode := _tree.Items.GetFirstNode; // �������� ������ ����
    while Assigned(ParentNode) do
    begin
      if ParentNode.Text = _service.m_destination then  Break; // ���� ������
      ParentNode := ParentNode.GetNext; // ��������� � ���������� ����
    end;
  end;

  // ��������� �������� ����
  if Assigned(ParentNode) then _tree.Items.AddChild(ParentNode, '(' + _service.m_code + ') ' + _service.m_name);
end;


function TFormServiceChoise.ExtractTextAfterParentheses(const Input: string; var isError:Boolean): string;
var
  Regex: TRegEx;
  Match: TMatch;
begin
  isError:=False;

  // ���������� ��������� ��� ������ ������ ����� ����������� ������� ������
  Regex := TRegEx.Create('\)\s*(.*)'); // ������� ����� ����� ')'

  Match := Regex.Match(Input);
  if Match.Success then
    Result := Match.Groups[1].Value // ���������� ��������� �����
  else begin
   Result := ''; // ���� ������ �� �������, ���������� ������ ������
   isError:=True;
  end;
end;


procedure TFormServiceChoise.tree_menuDblClick(Sender: TObject);
 var
 treeString:string;
 error:Boolean;
begin
  error:=False;

  treeString:=ExtractTextAfterParentheses(tree_menu.Selected.Text, error);
  if error then Exit;

  FormGenerateSMS.SetServiceChoise(treeString);
  lblChoiseCount.Caption:='������� ����� : '+IntToStr(FormGenerateSMS.GetCountServiceChoise);
end;

// ��������� ������
procedure TFormServiceChoise.btnShowChoiseClick(Sender: TObject);
begin
 FormServiceChoiseList.ShowModal;
end;

procedure TFormServiceChoise.CreateTree(const _findName:string = '');
  var
  i: Integer;
  nodeList:TStringList;
  findedList:TArray<TStructService>;
  findCount:Integer;
begin
  tree_menu.Items.Clear;
  nodeList:=TStringList.Create;

  if Length(_findName) = 0 then begin
    // ��������� ���
    for i:= 0 to serviceList.Count-1 do
    begin
       LoadTree(tree_menu, nodeList, serviceList.GetService(i));
    end;
  end
  else begin
   findedList:=serviceList.Find(_findName,findCount);

    for i:= 0 to findCount-1 do
    begin
       LoadTree(tree_menu, nodeList, findedList[i]);
    end;
  end;

  if Assigned(nodeList) then FreeAndNil(nodeList);
end;


// ��������� ���������
procedure TFormServiceChoise.LoadSettings;
begin
   // ��������� ������ � ��������
   if not Assigned(serviceList) then serviceList:=TService.Create;

   // ��������� ������
   if serviceList.Count<>0 then CreateTree;

   // ���� �� ����� ��� ��������� ������
   if FormGenerateSMS.GetCountServiceChoise<>0 then lblChoiseCount.Caption:='������� ����� : '+IntToStr(FormGenerateSMS.GetCountServiceChoise)
   else lblChoiseCount.Caption:='������� ����� : 0';
end;



procedure TFormServiceChoise.editFindChange(Sender: TObject);
begin
  if Length(editFind.Text) >=3 then begin
    CreateTree(editFind.Text);
  end;

  if Length(editFind.Text) = 0 then CreateTree;
end;

procedure TFormServiceChoise.editFindClick(Sender: TObject);
begin
  st_FindMessage.Visible:=False;
end;

procedure TFormServiceChoise.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 st_FindMessage.Visible:=True;

 if FormGenerateSMS.GetCountServiceChoise<>0 then begin
  FormGenerateSMS.lblServiceCount.Caption:='������� ����� : '+IntToStr(FormGenerateSMS.GetCountServiceChoise);
 end;

end;

procedure TFormServiceChoise.FormShow(Sender: TObject);
begin
  showWait(show_open);

  // ��������� ���������
  LoadSettings;

  editFind.SetFocus;

  showWait(show_close);
end;

end.
