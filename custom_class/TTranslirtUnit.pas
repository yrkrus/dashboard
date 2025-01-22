/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                    ласс дл€ описани€ транлитерации                        ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TTranslirtUnit;

interface

uses System.Classes, System.SysUtils, Variants;


 // class TRule
  type
      TRule = class
      public
      rusLetter                       : string;
      engLetter                       : string;

      constructor Create;             overload;

      end;
 // class TRule END


 // class TTranslirt
  type
      TTranslirt = class
      public
      function RusToEng(stroka:string)      :string;   // транлитераци€ из RUS -> ENG

      constructor Create;                   overload;

      private
      rule                            : array of TRule;
      countRule                       : UInt16;
      procedure createRule;           // создавние правил
      function find(bukva:string)     :string;  // поиск буквы в правиле


      end;
 // class TTranslirt END




implementation



constructor TTranslirt.Create;
 begin
   inherited;
   // создаем правила
   createRule;

 end;


function TTranslirt.find(bukva:string):string;
var
 i:Integer;
begin
  for i:=0 to countRule-1 do begin
    if rule[i].rusLetter = bukva then begin
       Result:=rule[i].engLetter;
       Exit;
    end;
  end;
end;


function TTranslirt.RusToEng(stroka: string):string;
var
 i,j:Integer;
 countStoka:Integer;
 translirt:string;
 bukva:string;
begin

  countStoka:=Length(stroka);
  if countStoka=0 then begin
    Result:='';
    Exit;
  end;

  translirt:='';

   for i:=1 to countStoka do begin
    bukva:= find(AnsiLowerCase(stroka[i]));
    if translirt='' then translirt:=bukva
    else translirt:=translirt+bukva;
   end;


  Result:=translirt;

end;


 procedure TTranslirt.createRule;
 const
  COUNT_RUS_ALFAVIT:Word = 36;
 var
  i:Integer;
 begin
   SetLength(Self.rule,COUNT_RUS_ALFAVIT);
   for i:=0 to COUNT_RUS_ALFAVIT-1 do rule[i]:=TRule.Create;

   Self.countRule:=COUNT_RUS_ALFAVIT;

   for i:=0 to COUNT_RUS_ALFAVIT-1 do begin

      case i of
         0: begin
           rule[i].rusLetter:='а';
           rule[i].engLetter:='a';
         end;
         1:begin
           rule[i].rusLetter:='б';
           rule[i].engLetter:='b';
         end;
         2:begin
           rule[i].rusLetter:='в';
           rule[i].engLetter:='v';
         end;
         3:begin
           rule[i].rusLetter:='г';
           rule[i].engLetter:='g';
         end;
         4: begin
           rule[i].rusLetter:='д';
           rule[i].engLetter:='d';
         end;
         5:begin
           rule[i].rusLetter:='е';
           rule[i].engLetter:='e';
         end;
         6:begin
           rule[i].rusLetter:='Є';
           rule[i].engLetter:='e';
         end;
         7:begin
           rule[i].rusLetter:='ж';
           rule[i].engLetter:='zh';
         end;
         8: begin
          rule[i].rusLetter:='з';
          rule[i].engLetter:='z';
         end;
         9:begin
          rule[i].rusLetter:='и';
          rule[i].engLetter:='i';
         end;
         10:begin
          rule[i].rusLetter:='й';
           rule[i].engLetter:='j';
         end;
         11:begin
           rule[i].rusLetter:='к';
           rule[i].engLetter:='k';
         end;
         12: begin
           rule[i].rusLetter:='л';
           rule[i].engLetter:='l';
         end;
         13:begin
           rule[i].rusLetter:='м';
           rule[i].engLetter:='m';
         end;
         14:begin
           rule[i].rusLetter:='н';
           rule[i].engLetter:='n';
         end;
         15:begin
           rule[i].rusLetter:='о';
           rule[i].engLetter:='o';
         end;
         16: begin
           rule[i].rusLetter:='п';
           rule[i].engLetter:='p';
         end;
         17:begin
          rule[i].rusLetter:='р';
           rule[i].engLetter:='r';
         end;
         18:begin
           rule[i].rusLetter:='с';
           rule[i].engLetter:='s';
         end;
         19:begin
           rule[i].rusLetter:='т';
           rule[i].engLetter:='t';
         end;
         20: begin
           rule[i].rusLetter:='у';
           rule[i].engLetter:='u';
         end;
         21:begin
           rule[i].rusLetter:='ф';
           rule[i].engLetter:='f';
         end;
         22:begin
          rule[i].rusLetter:='х';
           rule[i].engLetter:='ch';
         end;
         23:begin
           rule[i].rusLetter:='ц';
           rule[i].engLetter:='c';
         end;
         24: begin
           rule[i].rusLetter:='ч';
           rule[i].engLetter:='ch';
         end;
         25:begin
           rule[i].rusLetter:='ш';
           rule[i].engLetter:='sh';
         end;
         26:begin
           rule[i].rusLetter:='щ';
           rule[i].engLetter:='shh';
         end;
         27:begin
          rule[i].rusLetter:='ъ';
           rule[i].engLetter:='';
         end;
         28:begin
           rule[i].rusLetter:='ы';
           rule[i].engLetter:='y';
         end;
         29:begin
           rule[i].rusLetter:='ь';
           rule[i].engLetter:='';
         end;
         30:begin
           rule[i].rusLetter:='э';
           rule[i].engLetter:='e';
         end;
         31:begin
          rule[i].rusLetter:='ю';
           rule[i].engLetter:='yu';
         end;
         32:begin
           rule[i].rusLetter:='€';
           rule[i].engLetter:='ya';
         end;
         33:begin
           rule[i].rusLetter:='.';
           rule[i].engLetter:='.';
         end;
         34:begin
           rule[i].rusLetter:=',';
           rule[i].engLetter:=',';
         end;
         35:begin
           rule[i].rusLetter:=' ';
           rule[i].engLetter:=' ';
         end;
      end;
   end;
 end;

 constructor TRule.Create;
 begin
   inherited;
   Self.rusLetter:='';
   Self.engLetter:='';
 end;

end.
