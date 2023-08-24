unit System.Net.ClientSocket;

interface

uses
  System.Net.Socket, System.SysUtils, System.Net.Socket.Common;

type

  TClientSocket = class
  protected
    FSocket: TSocket;

    function GetSocketState: TSocketStates;

    function GetConnectTimeout: Integer;
    function GetReceiveTimeout: Integer;
    function GetSendTimeout: Integer;
    procedure SetConnectTimeout(const Value: Integer);
    procedure SetReceiveTimeout(const Value: Integer);
    procedure SetSendTimeout(const Value: Integer);
  public
    constructor Create;

    procedure Connect(const EndPoint: TNetEndpoint);

    function Receive(out Bytes: TBytes; Count: Integer = -1; Flags: TSocketFlags = []): Integer; overload; inline;
    function Receive(Count: Integer = -1; Flags: TSocketFlags = []): TBytes; overload; inline;
    function Send(const B: TBytes; Offset: Integer = 0; Count: Integer = -1; Flags: TSocketFlags = []): Integer;

    function ReceiveLength: Integer; inline;
    property ReceiveTimeout: Integer read GetReceiveTimeout write SetReceiveTimeout;
    property SendTimeout: Integer read GetSendTimeout write SetSendTimeout;
    property ConnectTimeout: Integer read GetConnectTimeout write SetConnectTimeout;

    property State: TSocketStates read GetSocketState;
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
  FSocket := System.Net.Socket.TSocket.Create(TSocketType.TCP, TEncoding.UTF8);
  FSocket.ConnectTimeout := 500;
  FSocket.ReceiveTimeout := 500;
  FSocket.SendTimeout := 500;
end;

function TClientSocket.GetConnectTimeout: Integer;
begin
  Result := FSocket.ConnectTimeout;
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

function TClientSocket.ReceiveLength: Integer;
begin
  Result := FSocket.ReceiveLength;
end;

function TClientSocket.Send(const B: TBytes; Offset, Count: Integer;
  Flags: TSocketFlags): Integer;
var
  {$IF DECLARED(OutputDebugString)}
  LSleepCount: Cardinal;
  // LTimeout: Boolean;
  {$ENDIF}

  LStartTime: Cardinal;
  LReceiveLength, LNewReceiveLength: Integer;
begin
  Result := FSocket.Send(B, Offset, Count, Flags);
  {$IF DECLARED(OutputDebugString)}
  LSleepCount := 0;
  // LTimeout := False;
  {$ENDIF}
  // After sending data
  // wait 2 times to receive data
  // The 1st time, wait for the receive length to change
  // The 2nd time, wait for the receive length to remain stable

  // Wait for receive length to change
  if FSocket.ReceiveLength = 0 then
    begin
      LStartTime := TThread.GetTickCount;
      while FSocket.ReceiveLength = 0 do
        begin
          {$IF DECLARED(OutputDebugString)}Inc(LSleepCount);{$ENDIF}
          if TThread.IsTimeout(LStartTime, FSocket.ReceiveTimeout) then
            begin
              // {$IF DECLARED(OutputDebugString)} LTimeout := True; {$ENDIF}
              Break;
            end;
        end;
      {$IF DECLARED(OutputDebugString)}
      OutputDebugString(PChar(Format('1st wait count: %d', [LSleepCount])));
      {$ENDIF}
    end;

  // Wait for receive length to become stable
  LReceiveLength := FSocket.ReceiveLength;
  LStartTime := TThread.GetTickCount;
  {$IF DECLARED(OutputDebugString)}
  LSleepCount := 0;
  // LTimeout := False;
  {$ENDIF}
  while (FSocket.ReceiveLength = LReceiveLength) do
    begin
      {$IF DECLARED(OutputDebugString)}Inc(LSleepCount);{$ENDIF}
      if TThread.IsTimeout(LStartTime, FSocket.ReceiveTimeout) then
        begin
          // {$IF DECLARED(OutputDebugString)}LTimeout := True;{$ENDIF}
          Break;
        end;
    end;
  {$IF DECLARED(OutputDebugString)}
  OutputDebugString(PChar(Format('2nd wait count: %d', [LSleepCount])));
  {$ENDIF}
  LNewReceiveLength := FSocket.ReceiveLength;
end;

procedure TClientSocket.SetConnectTimeout(const Value: Integer);
begin
  FSocket.SendTimeout := Value;
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
