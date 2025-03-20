 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///            ����� ��� �������� �������� ������� � ���� ��������            ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TFontSizeUnit;

interface

uses
System.Classes,
System.SysUtils,
TCustomTypeUnit;


 // class TFontSize
  type
      TFontSize = class
      const
         // ������ ������ �� ���������
       DEFAULT_FONT_SIZE  :Word = 10;

      public

      constructor Create;                   overload;
      procedure SetSize(InType:enumFontSize; NewSize:word);   // ��������� ������ ������� ������
      function GetSize(InType:enumFontSize):Word;             

      private
      m_ActiveSip                :Word;
      m_Ivr                      :Word;
      m_Queue                    :Word;

      end;
 // class TFontSize END

implementation




constructor TFontSize.Create;
begin
 inherited;
 m_ActiveSip  := DEFAULT_FONT_SIZE;
 m_Ivr        := DEFAULT_FONT_SIZE;
 m_Queue      := DEFAULT_FONT_SIZE;
end;


 // ��������� ������ ������� ������
procedure TFontSize.SetSize(InType: enumFontSize; NewSize: Word);
begin
  case InType of
    eActiveSip:   m_ActiveSip:=NewSize;
    eIvr:         m_Ivr:=NewSize;
    eQueue:       m_Queue:=NewSize;
  end; 
end;

function TFontSize.GetSize(InType:enumFontSize):Word;
begin
  case InType of
    eActiveSip:  Result:= m_ActiveSip;
    eIvr:        Result:= m_Ivr;
    eQueue:      Result:= m_Queue;
  end; 
end;

end.