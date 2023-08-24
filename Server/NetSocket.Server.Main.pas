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
    function RunThread(AServerSocket: TServerSocket; ASocket: System.Net.Socket.TSocket): TProc;
  public
    { Public declarations }
  end;

var
  frmSocketServer: TfrmSocketServer;

implementation

uses
  System.Net.Socket.Common,
  System.JSON;

{$R *.dfm}

procedure TfrmSocketServer.FormCreate(Sender: TObject);
var
  LEndpoint: TNetEndpoint;
begin
  FServerSocket := TServerSocket.Create(RunThread);
  FServerSocket.ReceiveTimeout := 50;
  LEndpoint.Port := 8083;
  LEndpoint.Family := AF_INET;
  LEndpoint.SetAddress('localhost');
  FServerSocket.Listen(LEndpoint);
end;

procedure TfrmSocketServer.FormDestroy(Sender: TObject);
begin
  FServerSocket.Free;
end;

function TfrmSocketServer.RunThread(AServerSocket: TServerSocket; ASocket: System.Net.Socket.TSocket): TProc;
begin
  Result := procedure
  var
    LSendString, LJSONS: string;
    LReceiveBuffer, LSendBuffer: TBytes;
    LReceiveTimeout, LID: Integer;
    LJSON: TJSONValue;
  begin
    while not AServerSocket.Terminated do
      begin
        LReceiveBuffer := ASocket.Receive; // ReceivedFrom;
        if Length(LReceiveBuffer) <> 0 then
          begin
            LJSONS := StringOf(LReceiveBuffer);
            TThread.Synchronize(nil, procedure
            var
              LReceivedString: string;
            begin
              LReceivedString := StringOf(LReceiveBuffer);
              if LReceivedString <> '' then
                Memo1.Lines.Add(LReceivedString);
            end);
            LSendString := '';
            LJSON := TJSONObject.ParseJSONValue(LJSONS);
            if Assigned(LJSON) and LJSON.TryGetValue<Integer>('id', LID) then
              begin
                LSendString := Format('{"jsonrpc": 2.0, "id": %d}', [LID]);
              end;
            LSendBuffer := BytesOf(LSendString);
            ASocket.Send(LSendBuffer);
          end;
        LReceiveTimeout := AServerSocket.ReceiveTimeout;

        Sleep(LReceiveTimeout);
      end;
  end;
end;

end.
