 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///Класс для хранения состояний TСheckBox для красивого отображаения состояния///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TCheckBoxUIUnit;

interface

uses
  System.Classes, System.SysUtils, TCustomTypeUnit, Vcl.StdCtrls, ExtCtrls,
  System.ImageList, Vcl.ImgList,Vcl.Imaging.pngimage, Vcl.Controls, Vcl.Graphics;


  // class TCheckBoxUIStruct
  type
      TCheckBoxUIStruct = class

      public
      m_name      :string;               // название
      m_state     :enumParamStatus;      // текущий статус
      m_tLabel    :TLabel;
      m_img       :TImage;

      constructor Create(_name:string;
                         var _label:TLabel;
                         var _img:TImage;
                         _state:enumParamStatus);                  overload;
     // procedure Clear;


      end;
 // class TCheckBoxUIStruct END

////////////////////////////////////////////////////////////////////////////

 // class TCheckBoxUI
  type
      TCheckBoxUI = class

      private
      m_imagelist  :TImageList;

      m_count     :Integer;
      m_list      :TArray<TCheckBoxUIStruct>;

      procedure LoadIconList;     // прогрузка иконок в память для последующего взятия
      function GetState(_nameComponent:string):Boolean;
      procedure SetState(_nameComponent: string; _value:Boolean);

      public
      constructor Create;                   overload;
      destructor Destroy;
      property Checked[_nameComponent: string]: Boolean read GetState write SetState;


      procedure Add(_name:string; var _label:TLabel; var _img:TImage; _state:enumParamStatus); // добавление
      procedure ChangeStatusCheckBox(_nameComponent:string; _status:enumParamStatus); overload;  // изменение статуса красивенького чек бокса
      procedure ChangeStatusCheckBox(_nameComponent:string);    overload;      // изменение статуса красивенького чек бокса



      end;
 // class TCheckBoxUI END

implementation

uses
  GlobalImageDestination;


constructor TCheckBoxUIStruct.Create(_name:string; var _label:TLabel; var _img:TImage; _state:enumParamStatus);
begin
  m_name:=_name;
  m_state:=_state;
  m_tLabel:=_label;
  m_img:=_img;
end;


constructor TCheckBoxUI.Create;
begin
 inherited Create;
 m_count:=0;

 LoadIconList;
end;


destructor TCheckBoxUI.Destroy;
begin
  m_imagelist.Free;
  inherited;
end;

// прогрузка иконок в память для последующего взятия
procedure TCheckBoxUI.LoadIconList;
const
 SIZE_ICON:Word=16;
var
 i:Integer;
 pngbmpOn,pngbmpOff: TPngImage;
 bmpOn,bmpOff: TBitmap;
begin
  if not FileExists(ICON_GUI_ON) then Exit;
  if not FileExists(ICON_GUI_OFF) then Exit;
  if not Assigned(m_imagelist) then m_imagelist:=TImageList.Create(nil);

  m_imagelist.SetSize(SIZE_ICON,SIZE_ICON);
  m_imagelist.ColorDepth:=cd32bit;

  begin
   // ON
   pngbmpOn:=TPngImage.Create;
   bmpOn:=TBitmap.Create;

   pngbmpOn.LoadFromFile(ICON_GUI_ON);

    // сжимаем иконку до размера 16х16
    with bmpOn do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpOn);
    end;

   // OFF
   pngbmpOff:=TPngImage.Create;
   bmpOff:=TBitmap.Create;

   pngbmpOff.LoadFromFile(ICON_GUI_OFF);

    // сжимаем иконку до размера 16х16
    with bmpOff do begin
     Height:=SIZE_ICON;
     Width:=SIZE_ICON;
     Canvas.StretchDraw(Rect(0, 0, Width, Height), pngbmpOff);
    end;

  end;

  m_imagelist.Add(bmpOff, nil);   // index = 0
  m_imagelist.Add(bmpOn, nil);    // index = 1


  if pngbmpOn<>nil then pngbmpOn.Free;
  if bmpOn<>nil then bmpOn.Free;
  if pngbmpOff<>nil then pngbmpOff.Free;
  if bmpOff<>nil then bmpOff.Free;
end;


// изменение статуса красивенького чек бокса
procedure TCheckBoxUI.ChangeStatusCheckBox(_nameComponent:string; _status:enumParamStatus);
var
 i:Integer;
 id:Integer;
begin
  id:=-1;

  for i:=0 to m_count-1 do begin
    if m_list[i].m_name = _nameComponent then begin
     id:=i;
     Break;
    end;
  end;

  if id = -1 then Exit;

  case _status of
   paramStatus_ENABLED: begin
     m_imagelist.GetIcon(1, m_list[i].m_img.Picture.Icon);
   end;
   paramStatus_DISABLED:begin
     m_imagelist.GetIcon(0,m_list[i].m_img.Picture.Icon);
   end;
  end;

  // ставим статус
  m_list[i].m_state:=_status;
end;


// изменение статуса красивенького чек бокса
procedure TCheckBoxUI.ChangeStatusCheckBox(_nameComponent:string);
var
 i:Integer;
 id:Integer;
begin
  id:=-1;

  for i:=0 to m_count-1 do begin
    if m_list[i].m_name = _nameComponent then begin
     id:=i;
     Break;
    end;
  end;

  if id = -1 then Exit;

  case m_list[i].m_state of
   paramStatus_ENABLED: begin
     // сейчас включено, значит выключаем
     m_imagelist.GetIcon(0, m_list[i].m_img.Picture.Icon);

     m_list[i].m_state:=paramStatus_DISABLED;
   end;
   paramStatus_DISABLED:begin
     // сейчас выключено, значит включаем
     m_imagelist.GetIcon(1,m_list[i].m_img.Picture.Icon);

     m_list[i].m_state:=paramStatus_ENABLED;
   end;
  end;
end;


function TCheckBoxUI.GetState(_nameComponent:string):Boolean;
var
 i:Integer;
 id:Integer;
begin
  id:=-1;

  for i:=0 to m_count-1 do begin
    if m_list[i].m_name = _nameComponent then begin
     id:=i;
     Break;
    end;
  end;

  if id = -1 then begin
   Result:=False;
   Exit;
  end;

  Result:=EnumParamStatusToBoolean(m_list[id].m_state);
end;

procedure TCheckBoxUI.SetState(_nameComponent: string; _value:Boolean);
var
 i:Integer;
 id:Integer;
begin
  id:=-1;

  for i:=0 to m_count-1 do begin
    if m_list[i].m_name = _nameComponent then begin
     id:=i;
     Break;
    end;
  end;

  if id = -1 then begin
   Exit;
  end;

  m_list[i].m_state:=BooleanToEnumParamStatus(_value);
  ChangeStatusCheckBox(_nameComponent, BooleanToEnumParamStatus(_value));
end;


procedure TCheckBoxUI.Add(_name:string; var _label:TLabel; var _img:TImage; _state:enumParamStatus);
begin
  SetLength(m_list, m_count+1);

  m_list[m_count]:=TCheckBoxUIStruct.Create(_name, _label, _img, _state);
  Inc(m_count);

  ChangeStatusCheckBox(_name, _state);  // поставим сразу нужный статус
end;

end.