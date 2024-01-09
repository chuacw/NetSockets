unit NetSocket.Server.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Net.Socket, Vcl.StdCtrls, System.Net.ServerSocket;

type
  TfrmSocketServer = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FServerSocket: TServerSocket;

  protected
    function RunThread(AServerSocket: TServerSocket; ANewSocket: System.Net.Socket.TSocket): TProc;
  public
    { Public declarations }
  end;

var
  frmSocketServer: TfrmSocketServer;

implementation

uses
  System.Net.Socket.Common, System.JSON, System.Types, Winapi.Winsock2;

{$R *.dfm}

procedure TfrmSocketServer.FormCreate(Sender: TObject);
var
  LEndpoint: TNetEndpoint;
begin
  FServerSocket := TServerSocket.Create(RunThread);
  FServerSocket.ReceiveTimeout := 500;
  LEndpoint.Port := 8083;
  LEndpoint.Family := AF_INET; // IPv6 not supported by System.Net.Socket
  LEndpoint.Address := TIPAddress.Any;
  FServerSocket.Listen(LEndpoint);
end;

procedure TfrmSocketServer.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FServerSocket);
end;

function TfrmSocketServer.RunThread(AServerSocket: TServerSocket;
  ANewSocket: System.Net.Socket.TSocket): TProc;
var
  LNewSocket: System.Net.Socket.TSocket;
begin
  LNewSocket := ANewSocket;
  Result := procedure
  var
    LSendString, LText, LJSONS: string;
    LReceiveBuffer: TBytes;
    LByteCount: Integer;
    LReceiveTimeout, LID: Integer;
    LJSON: TJSONValue;
    LLocalSocket: System.Net.Socket.TSocket;
  begin
    LLocalSocket := LNewSocket;
    while not AServerSocket.Terminated do
      begin
        LReceiveBuffer := LLocalSocket.Receive; // ReceivedFrom;
        if Length(LReceiveBuffer) <> 0 then
          begin
            LJSONS := LLocalSocket.Encoding.GetString(LReceiveBuffer);
            TThread.Synchronize(nil, procedure
            var
              LReceivedString: string;
            begin
              LReceivedString := LLocalSocket.Encoding.GetString(LReceiveBuffer);
              if LReceivedString <> '' then
                Memo1.Lines.Add(LReceivedString);
            end);
            LSendString := '';
            // place breakpoint below
            LJSON := TJSONObject.ParseJSONValue(LJSONS);
            try
              if Assigned(LJSON) and LJSON.TryGetValue<Integer>('id', LID) and
                LJSON.TryGetValue<string>('params.Text', LText) then
                begin
                  LSendString := Format('{"jsonrpc": 2.0, "id": %d, "echo": "%s"}',
                    [LID, LText]);
                  OutputDebugString(PChar(LSendString));
                end;
              if LSendString <> '' then
                begin
                  LByteCount := LLocalSocket.Encoding.GetByteCount(LSendString);
                  LLocalSocket.Send(LByteCount, SizeOf(LByteCount));
                  LLocalSocket.Send(LSendString);
                  LSendString := '';
                end;
            finally
              LJSON.Free;
            end;
          end;
        LReceiveTimeout := AServerSocket.ReceiveTimeout;

        Sleep(LReceiveTimeout);
      end;
    FreeAndNil(LLocalSocket);
  end;
end;

end.
