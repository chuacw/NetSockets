unit NetSocket.Client.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, System.Net.ClientSocket;

type
  TfrmSocketClient = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FID: UInt64;
    FSocket: TClientSocket;
    FThread: TThread;
  public
    { Public declarations }
  end;

var
  frmSocketClient: TfrmSocketClient;

implementation

uses
  System.Net.Socket.Common, System.DateUtils, Winapi.Winsock2,
  System.Net.Socket;

{$R *.dfm}

procedure TfrmSocketClient.Button1Click(Sender: TObject);
var
  LEndpoint: TNetEndpoint;
  LBuffer: TBytes;
  LText: string;
  LByteCount: Integer;
begin
  if IsDebuggerPresent then
    begin
      FSocket.ReceiveTimeout := 500;
      FSocket.SendTimeout := FSocket.ReceiveTimeout;
      FSocket.ConnectTimeout := FSocket.ReceiveTimeout;
    end else
    begin
      FSocket.ReceiveTimeout := 150;
      FSocket.SendTimeout := FSocket.ReceiveTimeout;
      FSocket.ConnectTimeout := FSocket.ReceiveTimeout;
    end;

  if not (TSocketState.Connected in FSocket.State) then
    begin
      LEndpoint.Port := 8083;
      LEndpoint.SetAddress('localhost');
      LEndpoint.Family := AF_INET; // IPv6 not supported by System.Net.Socket
      FSocket.Connect(LEndpoint);
    end;
//  LText := Format('%s - %s', [FormatDateTime('hh:nn:ss', Now), Edit1.Text]);
  Inc(FID);
  LText :=  Format(
  '''
  {"jsonrpc": 2.0, "method": "回声", "params": {"Text":"%s"}, "id": %d}
  '''
  , [Edit1.Text, FID]);
  FSocket.Send(LText);
  FSocket.Receive(LByteCount, SizeOf(LByteCount));
  FSocket.Receive(LBuffer, LByteCount);
  if Length(LBuffer) <> 0 then
    begin
      var LReceivedString := FSocket.Encoding.GetString(LBuffer);
      Memo1.Lines.Add(LReceivedString);
    end;
end;

procedure TfrmSocketClient.FormCreate(Sender: TObject);
begin
  FSocket := TClientSocket.Create;
  FSocket.ReceiveTimeout := 150;
  FID := 0;
end;

procedure TfrmSocketClient.FormDestroy(Sender: TObject);
begin
  if Assigned(FThread) then
    FThread.Terminate;
  FThread.Free;
  FSocket.Free;
end;

end.
