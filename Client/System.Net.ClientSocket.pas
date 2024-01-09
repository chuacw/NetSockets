unit System.Net.ClientSocket;

{$CODEALIGN 16}

interface

uses
  System.Net.Socket, System.SysUtils, System.Net.Socket.Common;

type

  TClientSocket = class(TBaseSocket)
  protected

    function GetSocketState: TSocketStates;

    function GetReceiveTimeout: Integer;
    procedure SetReceiveTimeout(const Value: Integer);

    function GetSendTimeout: Integer;
    procedure SetSendTimeout(const Value: Integer);

    {$IF RTLVersion >= 36}
    function GetConnectTimeout: Integer;
    procedure SetConnectTimeout(const Value: Integer);
    {$ENDIF}

    function GetEncoding: TEncoding;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect(const EndPoint: TNetEndpoint);

    function Receive(var Buf; Count: Integer; Flags: TSocketFlags = []): Integer; overload; inline;
    function Receive(out Bytes: TBytes; Count: Integer = -1; Flags: TSocketFlags = []): Integer; overload; inline;
    function Receive(Count: Integer = -1; Flags: TSocketFlags = []): TBytes; overload; inline;
    function Send(const B: TBytes; Offset: Integer = 0; Count: Integer = -1; Flags: TSocketFlags = []): Integer; overload;
    function Send(const Data: string; Flags: TSocketFlags = []): Integer; overload;

    function ReceiveLength: Integer; inline;
    property ReceiveTimeout: Integer read GetReceiveTimeout write SetReceiveTimeout;
    property SendTimeout: Integer read GetSendTimeout write SetSendTimeout;

    {$IF RTLVersion >= 36}
    property ConnectTimeout: Integer read GetConnectTimeout write SetConnectTimeout;
    {$ENDIF}

    property State: TSocketStates read GetSocketState;
    property Encoding: TEncoding read GetEncoding;
  end;

implementation

uses
  System.Classes, Winapi.Windows;

{ TClientSocket }

procedure TClientSocket.Connect(const EndPoint: TNetEndpoint);
begin
  FSocket.Connect(Endpoint);
end;

constructor TClientSocket.Create;
begin
  FSocket := System.Net.Socket.Common.TSocket.Create(TSocketType.TCP, TEncoding.UTF8);
{$IF RTLVersion >= 36} //{$IF DECLARED(TSocket.ConnectTimeout)}
  FSocket.ConnectTimeout := 500;
{$ENDIF}
  FSocket.ReceiveTimeout := 150;
  FSocket.SendTimeout := 500;
end;

destructor TClientSocket.Destroy;
begin
  if TSocketState.Connected in FSocket.State then
   FSocket.Close(True);
  FSocket.Free;
  inherited;
end;

{$IF RTLVersion >= 36}
function TClientSocket.GetConnectTimeout: Integer;
begin
  Result := FSocket.ConnectTimeout;
end;

procedure TClientSocket.SetConnectTimeout(const Value: Integer);
begin
  FSocket.SendTimeout := Value;
end;
{$ENDIF}

function TClientSocket.GetEncoding: TEncoding;
begin
  Result := FSocket.Encoding;
end;

function TClientSocket.GetReceiveTimeout: Integer;
begin
  Result := FSocket.ReceiveTimeout;
end;

function TClientSocket.GetSendTimeout: Integer;
begin
  Result := FSocket.SendTimeout;
end;

function TClientSocket.GetSocketState: TSocketStates;
begin
  Result := FSocket.State;
end;

function TClientSocket.Receive(out Bytes: TBytes; Count: Integer;
  Flags: TSocketFlags): Integer;
begin
  Result := FSocket.Receive(Bytes, Count, Flags);
end;

function TClientSocket.Receive(Count: Integer; Flags: TSocketFlags): TBytes;
begin
  Result := FSocket.Receive(Count, Flags);
end;

function TClientSocket.Receive(var Buf; Count: Integer;
  Flags: TSocketFlags): Integer;
begin
  Result := FSocket.Receive(Buf, Count, Flags);
end;

function TClientSocket.ReceiveLength: Integer;
begin
  Result := FSocket.ReceiveLength;
end;

function TClientSocket.Send(const B: TBytes; Offset, Count: Integer;
  Flags: TSocketFlags): Integer;
var
  {$IF DECLARED(OutputDebugString)}
//  LSleepCount: Cardinal;
  // LTimeout: Boolean;
  {$ENDIF}

//  LStartTime: Cardinal;
  LReceiveLength: Integer;
begin
  Result := FSocket.Send(B, Offset, Count, Flags);
  {$IF DECLARED(OutputDebugString)}
//  LSleepCount := 0;
  // LTimeout := False;
  {$ENDIF}

  FSocket.Receive(LReceiveLength, SizeOf(LReceiveLength));
  Result := LReceiveLength;
//  while FSocket.ReceiveLength <> LReceiveLength do
//    begin
//      {$IF DEFINED(MSWINDOWS)}
//      TThread.Yield;
//      {$ELSE}
//      TThread.Yield;
//      {$ENDIF}
//    end;

//  // After sending data
//  // wait 2 times to receive data
//  // The 1st time, wait for the receive length to change
//  // The 2nd time, wait for the receive length to remain stable
//
//  // Wait for receive length to change
//  if FSocket.ReceiveLength = 0 then
//    begin
//      LStartTime := TThread.GetTickCount;
//      while FSocket.ReceiveLength = 0 do
//        begin
//          {$IF DECLARED(OutputDebugString)}Inc(LSleepCount);{$ENDIF}
//          if TThread.IsTimeout(LStartTime, FSocket.ReceiveTimeout) then
//            begin
//              // {$IF DECLARED(OutputDebugString)} LTimeout := True; {$ENDIF}
//              Break;
//            end;
//        end;
//      {$IF DECLARED(OutputDebugString)}
//      OutputDebugString(PChar(Format('1st wait count: %d', [LSleepCount])));
//      {$ENDIF}
//    end;
//
//  // Wait for receive length to become stable
//  LReceiveLength := FSocket.ReceiveLength;
//  LStartTime := TThread.GetTickCount;
//  {$IF DECLARED(OutputDebugString)}
//  LSleepCount := 0;
//  // LTimeout := False;
//  {$ENDIF}
//  while (FSocket.ReceiveLength = LReceiveLength) do
//    begin
//      {$IF DECLARED(OutputDebugString)}Inc(LSleepCount);{$ENDIF}
//      LNewReceiveLength := FSocket.ReceiveLength;
//      if ((LNewReceiveLength <> 0) and (LNewReceiveLength = LReceiveLength) and
//          (LSleepCount >= 60) ) or
//         TThread.IsTimeout(LStartTime, FSocket.ReceiveTimeout) then
//        begin
//          // {$IF DECLARED(OutputDebugString)}LTimeout := True;{$ENDIF}
//          Break;
//        end;
//    end;
//  {$IF DECLARED(OutputDebugString)}
//  OutputDebugString(PChar(Format('2nd wait count: %d', [LSleepCount])));
//  {$ENDIF}
////  LNewReceiveLength := FSocket.ReceiveLength;
end;

function TClientSocket.Send(const Data: string; Flags: TSocketFlags = []): Integer;
//var
//  LBuffer: TBytes;
begin
//  LBuffer := BytesOf(Data);
//  Result := Send(LBuffer);
  Result := FSocket.Send(Data);
end;

procedure TClientSocket.SetReceiveTimeout(const Value: Integer);
begin
  FSocket.ReceiveTimeout := Value;
end;

procedure TClientSocket.SetSendTimeout(const Value: Integer);
begin
  FSocket.SendTimeout := Value;
end;

end.
