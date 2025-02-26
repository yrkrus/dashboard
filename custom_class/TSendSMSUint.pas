 /////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                   ����� ��� �������� �������� SMS                         ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit TSendSMSUint;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.Win.ADODB, Data.DB,
  System.Variants,
  IdHTTP,
  IdSSL,
  IdIOHandlerStack,
  IdSSLOpenSSL,
  Xml.XMLDoc, Xml.XMLIntf,
  IdException,
  Vcl.StdCtrls,
  Winapi.Windows,
  Vcl.Controls,
  TCustomTypeUnit;

  type
  TSpecials = set of AnsiChar;

const

  SpecialChar: TSpecials =
  ['=', '(', ')', '[', ']', '<', '>', ':', ';', ',', '@', '/', '?', '\',
    '"', '_'];
  NonAsciiChar: TSpecials =
  [#0..#31, #127..#255];
  URLFullSpecialChar: TSpecials =
  [';', '/', '?', ':', '@', '=', '&', '#', '+'];
  URLSpecialChar: TSpecials =
  [#$00..#$20, '<', '>', '"', '%', '{', '}', '|', '\', '^', '[', ']', '`', #$7F..#$FF];
  TableBase64 =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
  TableBase64mod =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,=';
  TableUU =
    '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  TableXX =
    '+-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  ReTablebase64 =
    #$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$3E +#$40
    +#$40 +#$40 +#$3F +#$34 +#$35 +#$36 +#$37 +#$38 +#$39 +#$3A +#$3B +#$3C
    +#$3D +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$00 +#$01 +#$02 +#$03
    +#$04 +#$05 +#$06 +#$07 +#$08 +#$09 +#$0A +#$0B +#$0C +#$0D +#$0E +#$0F
    +#$10 +#$11 +#$12 +#$13 +#$14 +#$15 +#$16 +#$17 +#$18 +#$19 +#$40 +#$40
    +#$40 +#$40 +#$40 +#$40 +#$1A +#$1B +#$1C +#$1D +#$1E +#$1F +#$20 +#$21
    +#$22 +#$23 +#$24 +#$25 +#$26 +#$27 +#$28 +#$29 +#$2A +#$2B +#$2C +#$2D
    +#$2E +#$2F +#$30 +#$31 +#$32 +#$33 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40;
  ReTableUU =
    #$01 +#$02 +#$03 +#$04 +#$05 +#$06 +#$07 +#$08 +#$09 +#$0A +#$0B +#$0C
    +#$0D +#$0E +#$0F +#$10 +#$11 +#$12 +#$13 +#$14 +#$15 +#$16 +#$17 +#$18
    +#$19 +#$1A +#$1B +#$1C +#$1D +#$1E +#$1F +#$20 +#$21 +#$22 +#$23 +#$24
    +#$25 +#$26 +#$27 +#$28 +#$29 +#$2A +#$2B +#$2C +#$2D +#$2E +#$2F +#$30
    +#$31 +#$32 +#$33 +#$34 +#$35 +#$36 +#$37 +#$38 +#$39 +#$3A +#$3B +#$3C
    +#$3D +#$3E +#$3F +#$00 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40
    +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40
    +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40;
  ReTableXX =
    #$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$00 +#$40
    +#$01 +#$40 +#$40 +#$02 +#$03 +#$04 +#$05 +#$06 +#$07 +#$08 +#$09 +#$0A
    +#$0B +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$40 +#$0C +#$0D +#$0E +#$0F
    +#$10 +#$11 +#$12 +#$13 +#$14 +#$15 +#$16 +#$17 +#$18 +#$19 +#$1A +#$1B
    +#$1C +#$1D +#$1E +#$1F +#$20 +#$21 +#$22 +#$23 +#$24 +#$25 +#$40 +#$40
    +#$40 +#$40 +#$40 +#$40 +#$26 +#$27 +#$28 +#$29 +#$2A +#$2B +#$2C +#$2D
    +#$2E +#$2F +#$30 +#$31 +#$32 +#$33 +#$34 +#$35 +#$36 +#$37 +#$38 +#$39
    +#$3A +#$3B +#$3C +#$3D +#$3E +#$3F +#$40 +#$40 +#$40 +#$40 +#$40 +#$40;



  // class TAuthSMS
type
    TAuthSMS = class
    public
    constructor Create;                   overload;

    private
    m_URL                         :string; // ������ �����������
    m_login                       :string; // �����
    m_password                    :string; // ������
    m_sign                        :string; // ������� � ������������ ���

    function GetAuth(SMSType:enumSMSAuth):string;      // ��������� ��������������� ������ ��� �������� SMS
    procedure CreateAuthSMS;      // ��������� ������ �� �����������


    end;
// class TAuthSMS END




 // class TSendSMS
  type
      TSendSMS = class
      public
      function SendSMS(InMessage:string; InNumberPhone:string; var _errorDescription:string; isAddSign:Boolean):Boolean;
      function isExistAuth:Boolean;                         // ���� �� ��� ��������������� ������
      function GetSignSMS:string;                           // ������� � ��� ���������

      constructor Create(isDEBUG:Boolean);                    overload;
      private
      m_Auth      :TAuthSMS;        // ��������������� ������
      m_isExistAuth:Boolean;       // ���� ��� ��������������� ������
      m_isDEBUG:Boolean;              // debug ��� �������� �������� ���

      function EncodeURL(const Value: AnsiString): AnsiString;
      function ResponceParsing(InServerOtvet:string; var _errorDescription:string):Boolean;  // ������� ������
      procedure SaveToBase(InServerOtvet:string; InMessage:string); // ���������� ������������ ��� � ����
      function AddSign(InMessage:string):string; // ���������� ������� � ������������� ���������
      function isExistSMS(InPhone:string;InChechMessage:string; var _errorDescription:string):Boolean; // �������� ���������� �� ��� ����� ����� ���


      end;
 // class TSendSMS END

implementation

uses
  GlobalVariables;


constructor TAuthSMS.Create;
begin
  CreateAuthSMS;
end;

function TAuthSMS.GetAuth(SMSType: enumSMSAuth):string;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
   Result:='null';

   ado:=TADOQuery.Create(nil);
   serverConnect:=createServerConnect;
  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;

      case SMSType of
       sms_server_addr:begin
         SQL.Add('select url from sms_settings');
       end;
       sms_login:begin
          SQL.Add('select sms_login from sms_settings');
       end;
       sms_pwd:begin
         SQL.Add('select sms_pwd from sms_settings');
       end;
       sms_sign:begin
         SQL.Add('select sign from sms_settings');
       end;
      end;

      Active:=True;
      if Fields[0].Value<>null then begin
        if Length(VarToStr(Fields[0].Value)) <> 0 then Result:=VarToStr(Fields[0].Value);
      end;

    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
  end;
end;

 // ��������� ������ �� �����������
procedure TAuthSMS.CreateAuthSMS;
begin
  m_URL:=GetAuth(sms_server_addr);
  m_login:=GetAuth(sms_login);
  m_password:=GetAuth(sms_pwd);
  m_sign:=GetAuth(sms_sign);
end;



 constructor TSendSMS.Create(isDEBUG:Boolean);
 begin
  // inherited;
   m_Auth:=TAuthSMS.Create;

   // ���� �� ��� ��������������� ������
   if (m_Auth.m_URL <>'null') and
      (m_Auth.m_login <>'null') and
      (m_Auth.m_password <>'null') then begin
     m_isExistAuth:=True;
   end
   else m_isExistAuth:=False;

   m_isDEBUG:=isDEBUG;
 end;


 function EncodeTriplet(const Value: AnsiString; Delimiter: AnsiChar;
  Specials: TSpecials): AnsiString;
var
  n, l: Integer;
  s: AnsiString;
  c: AnsiChar;
begin
  SetLength(Result, Length(Value) * 3);
  l := 1;
  for n := 1 to Length(Value) do
  begin
    c := Value[n];
    if c in Specials then
    begin
      Result[l] := Delimiter;
      Inc(l);
      s := IntToHex(Ord(c), 2);
      Result[l] := s[1];
      Inc(l);
      Result[l] := s[2];
      Inc(l);
    end
    else
    begin
      Result[l] := c;
      Inc(l);
    end;
  end;
  Dec(l);
  SetLength(Result, l);
end;



function TSendSMS.EncodeURL(const Value: AnsiString): AnsiString;
begin
  Result := EncodeTriplet(Value, '%', URLSpecialChar);
end;


// ���������� �������� ������
function GetResponseError(InErrorCode:Integer):string;
begin
  case InErrorCode of
    20107:Result:='�������� ����� ��� ������';
    20117:Result:='������������ ����� ��������';
    20148:Result:='���������� ������������ ������ ��� ��������';
    20154:Result:='������ ����������';
    20158:Result:='�������� ����������, ��� ��� ����� ������ � ������ ������';
    20167:Result:='��������� �������� ��������� � ��� �� ������� ���� �� �������� � ������� ���������� �����';
    20170:Result:='������� ������� ���������';
    20171:Result:='��������� �� ������ �������� �������';
    20200:Result:='������������ ������';
    20202:Result:='�� ������ �������� ���� ��� �������� ���������';
    20203:Result:='��� ������ �������� ��� �������������� ������ � �������';
    20204:Result:='�� ������� �������� ��� ������';
    20207:Result:='������������ ������ ����';
    20208:Result:='���� ������ ����� ���� �����';
    20209:Result:='��������� ������� ������';
    20211:Result:='��������� ���������� ��������� ��� ������������';
    20212:Result:='�������� �������� � ��������� �����';
    20213:Result:='���������� ������ � ������';
    20218:Result:='��������� ���������� �� ��������� �������';
    20230:Result:='����������� �� ������� �� ������� ���������';
    20280:Result:='��������� �������� ����� �� �������� SMS � ��������� A2P';
    20281:Result:='��������� �������� ����� �� �������� SMS � ��������� A2P';
    else
    Result := '����������� ������. ErrorCode "'+IntToStr(InErrorCode)+'" ����������'; // �������� �� ���������
  end;
end;


// ������� ������
function TSendSMS.ResponceParsing(InServerOtvet:string; var _errorDescription:string):Boolean;
const
 isError:string = 'error code';

 var
  errorCode:string;
  XmlDoc: IXMLDocument;
  ErrorNode: IXMLNode;
begin
  _errorDescription:='';
  Result:=False;

  // ������ ���
  if AnsiPos(isError,InServerOtvet)=0 then begin
    Result:=True;
    Exit;
  end;

  // ���� ������ ������������
  XmlDoc := TXMLDocument.Create(nil);
  try
    XmlDoc.LoadFromXML(InServerOtvet);
    XmlDoc.Active := True;

    // �������� ���� � �������
    ErrorNode := XmlDoc.DocumentElement.ChildNodes['errors'].ChildNodes['error'];
    if Assigned(ErrorNode) then
    begin
      ErrorCode := ErrorNode.Attributes['code'];
      if AnsiPos('-',ErrorCode)<>0 then ErrorCode:=StringReplace(ErrorCode,'-','',[rfReplaceAll]);

      _errorDescription:=GetResponseError(StrToInt(ErrorCode));
    end
    else _errorDescription:='����������� ������. ����������� ErrorCode';

  finally
    // XMLDoc ������������� �������������, ���� ������������ IXMLDocument
  end;

end;


// ���������� ������������ ��� � ����
procedure TSendSMS.SaveToBase(InServerOtvet:string; InMessage:string);
 var
 XmlDoc: IXMLDocument;
 RootNode: IXMLNode;
 sms_id,phone:string;
 ado:TADOQuery;
 serverConnect:TADOConnection;
 response:string;
 user_login_pc:string;
begin
  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;
//    phone:='+79093858545';
//    sms_id:='1000';
  XmlDoc := TXMLDocument.Create(nil);
  try
    XmlDoc.LoadFromXML(InServerOtvet);
    XmlDoc.Active := True;

    // �������� ����
    RootNode := XmlDoc.DocumentElement.ChildNodes['result'].ChildNodes['sms'];
    if Assigned(RootNode) then
    begin
      sms_id:=  RootNode.Attributes['id'];
      phone:=   RootNode.Attributes['phone'];
    end
    else begin
      FreeAndNil(ado);
      if Assigned(serverConnect) then begin
        serverConnect.Close;
        FreeAndNil(serverConnect);
      end;
      Exit;
    end;

  finally
    // XMLDoc ������������� �������������, ���� ������������ IXMLDocument
  end;

  user_login_pc:=GetCurrentUserNamePC;

  response:='insert into sms_sending (user_id,phone,message,sms_id,user_login_pc) values ('+#39+IntToStr(USER_STARTED_SMS_ID)+#39+','
                                                                                           +#39+phone+#39+','
                                                                                           +#39+InMessage+#39+','
                                                                                           +#39+sms_id+#39+','
                                                                                           +#39+user_login_pc+#39+')';
   try
     with ado do begin
        ado.Connection:=serverConnect;
        SQL.Clear;
        SQL.Add(response);

        try
            ExecSQL;
        except
            on E:EIdException do begin
               FreeAndNil(ado);
               if Assigned(serverConnect) then begin
                 serverConnect.Close;
                 FreeAndNil(serverConnect);
               end;
               Exit;
            end;
        end;
     end;
   finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
      serverConnect.Close;
      FreeAndNil(serverConnect);
    end;
   end;
end;


function TSendSMS.SendSMS(InMessage:string;
                          InNumberPhone:string;
                          var _errorDescription:string;
                          isAddSign:Boolean):Boolean;
const
  CustomHeaders1  :string = 'Connection:Keep-alive';
  CustomHeaders2  :string = 'Content-Type: application/x-www-form-urlencoded; charset=utf-8 ';
  CustomHeaders3  :string = 'Accept-Charset:utf-8';
  CustomHeaders4  :string = 'Accept:application/json, text/javascript, */*; q=0.01';
  //CustomUserAgent :string = 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0';
    CustomUserAgent :string = 'Wget/1.17.1 (linux-gnu)';

var
 http:TIdHTTP;
 ssl:TIdSSLIOHandlerSocketOpenSSL;
 ServerOtvet:string;
 HTTPGet:string;
 resultat:Word;
 sendMessage:string;
 tmpPhone:string;
begin
   Result:=False;
  _errorDescription:='';

  if not m_isExistAuth then begin
    _errorDescription:='����������� ��������������� ������ ��� �������� SMS';
    Exit;
  end;

   // ��������� ������ �� ��������
  begin
    sendMessage:=InMessage;
    if isAddSign then begin
     if m_Auth.m_sign <>'null' then sendMessage:=AddSign(sendMessage);
    end;

    // ������� 8 �� +7
    begin
      tmpPhone:=InNumberPhone;
      if tmpPhone.StartsWith('8') then
      begin
         // �������� '8' �� '+7'
        tmpPhone := '+7' + tmpPhone.Substring(1);
      end;
    end;


    // ��������� ����� ���������� ����� ��������� ���
    if isExistSMS(tmpPhone,sendMessage,_errorDescription) then begin
      Exit;
    end;


    HTTPGet:=m_Auth.m_URL;
    HTTPGet:=StringReplace(HTTPGet,'%USERNAME',m_Auth.m_login,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%USERPWD',m_Auth.m_password,[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%MESSAGE', EncodeURL(AnsiToUtf8(sendMessage)),[rfReplaceAll]);
    HTTPGet:=StringReplace(HTTPGet,'%PHONENUMBER',InNumberPhone,[rfReplaceAll]);
  end;

  http:=TIdHTTP.Create(nil);

  // ssl
  begin
    ssl:=TIdSSLIOHandlerSocketOpenSSL.Create(http);
    ssl.SSLOptions.Method:=sslvTLSv1_2;
    ssl.SSLOptions.SSLVersions:=[sslvTLSv1_2];
  end;


  try
    with http do begin
      IOHandler:=ssl;
      Request.CustomHeaders.Add(CustomHeaders1);
      Request.CustomHeaders.Add(CustomHeaders2);
      Request.CustomHeaders.Add(CustomHeaders3);
      Request.CustomHeaders.Add(CustomHeaders4);
      Request.UserAgent:=CustomUserAgent;

       try
//        if m_isDEBUG then begin
//          resultat:=MessageBox(0,PChar('===DEBUG MODE=== '+#13#13+'C����� ����� ���������� SMS, ����������?'),PChar('���������'),MB_YESNO+MB_ICONQUESTION);
//          if resultat=mrNo then begin
//            Exit;
//          end;
//        end;
//          Result:=True;    //debug �������
//          SaveToBase(ServerOtvet,sendMessage);
//
//          Sleep(100);
//          Exit;

        ServerOtvet:=Get(HTTPGet);
        // ������� ������, ���� ������ false ���������
        if not ResponceParsing(ServerOtvet,_errorDescription) then begin
          if ssl<>nil then FreeAndNil(ssl);
          if http<>nil then FreeAndNil(http);
          Exit;
        end;

         // ��������� � ����
         SaveToBase(ServerOtvet,sendMessage);

       except on E: EIdHTTPProtocolException do
          begin
           _errorDescription:=e.Message+': '+e.ErrorMessage;
           if ssl<>nil then FreeAndNil(ssl);
           if http<>nil then FreeAndNil(http);
           Exit;
          end;
       end;
    end;
  finally
    if ssl<>nil then FreeAndNil(ssl);
    if http<>nil then FreeAndNil(http);
  end;

  Result:=True;
end;

// ���� �� ��� ��������������� ������
function TSendSMS.isExistAuth:Boolean;
begin
  Result:=Self.m_isExistAuth;
end;

// ������� � ��� ���������
function TSendSMS.GetSignSMS:string;
begin
  Result:=m_Auth.m_sign;
end;

// ���������� ������� � ������������� ���������
function TSendSMS.AddSign(InMessage:string):string;
begin
  // ��������
  if m_Auth.m_sign = 'null' then begin
   Result:=InMessage;
   Exit;
  end;

  if (InMessage[Length(InMessage)] = '.' ) then begin
   Result:=InMessage+' '+m_Auth.m_sign;
  end else if (InMessage[Length(InMessage)] = ' ' ) then begin
   Result:=InMessage+'. '+m_Auth.m_sign;
  end else
  begin
   Result:=InMessage+'. '+m_Auth.m_sign;
  end;
end;

// �������� ���������� �� ��� ����� ����� ���
function TSendSMS.isExistSMS(InPhone:string;
                             InChechMessage:string;
                             var _errorDescription:string):Boolean;
var
 ado:TADOQuery;
 serverConnect:TADOConnection;
begin
  Result:=False;
  _errorDescription:='';

  ado:=TADOQuery.Create(nil);
  serverConnect:=createServerConnect;

  if not Assigned(serverConnect) then begin
     FreeAndNil(ado);
     Exit;
  end;

  try
    with ado do begin
      ado.Connection:=serverConnect;
      SQL.Clear;
      SQL.Add('select count(id) from sms_sending where message = '+#39+InChechMessage+#39
                                                                  +' and phone = '+#39+InPhone+#39
                                                                  +' and date_time > '+#39+GetCurrentStartDateTime+#39);

      Active:=True;
      if StrToInt(VarToStr(Fields[0].Value)) <> 0 then
      begin
        _errorDescription:='C������ ����� SMS ��� ���� ���������� �� ����� '+InPhone;
        Result:=True;
      end;
    end;
  finally
    FreeAndNil(ado);
    if Assigned(serverConnect) then begin
     serverConnect.Close;
     FreeAndNil(serverConnect);
    end;
  end;

end;

end.