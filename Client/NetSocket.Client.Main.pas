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
  System.Net.Socket.Common, System.DateUtils;

{$R *.dfm}

procedure TfrmSocketClient.Button1Click(Sender: TObject);
var
  LEndpoint: TNetEndpoint;
  LBuffer: TBytes;
  LText: string;
begin
  if IsDebuggerPresent then
    begin
      FSocket.ReceiveTimeout := 150;
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
      LEndpoint.Family := AF_INET;
      FSocket.Connect(LEndpoint);
    end;
//  LText := Format('%s - %s', [FormatDateTime('hh:nn:ss', Now), Edit1.Text]);
  Inc(FID);
  LText :=  Format(
  '''
  {"jsonrpc": 2.0, "method": "GetSomeDate", "params": {"ADateTime":"%s"}, "id": %d}
  '''
  , [DateToISO8601(Now), FID]);
  LBuffer := BytesOf(LText);

  FSocket.Send(LBuffer);
  LBuffer := nil;

  FSocket.Receive(LBuffer);
  if Length(LBuffer) <> 0 then
    begin
      var LReceivedString := StringOf(LBuffer);
      Memo1.Lines.Add(LReceivedString);
    end;

//  LTotalSleep := 0;
//  while (FSocket.ReceiveLength = 0) do
//    begin
//      Sleep(10);
//      Inc(LTotalSleep, 10);
//      if LTotalSleep > FSocket.ReceiveTimeout then
//        Break;
//    end;
end;

procedure TfrmSocketClient.FormCreate(Sender: TObject);
begin
//  FSocket := System.Net.Socket.TSocket.Create(TSocketType.TCP, TEncoding.UTF8);
  FSocket := TClientSocket.Create;
  FSocket.ReceiveTimeout := 500;
  FID := 0;
//  FThread := TThread.CreateAnonymousThread(procedure
//  var
//    LReceiveBuffer: TBytes;
////    LSocket: System.Net.Socket.TSocket;
//    LSocket: TClientSocket;
//  begin
//    LSocket := FSocket;
//    try
//      while Assigned(FThread) and not TThread.CheckTerminated do
//        begin
//          LReceiveBuffer := nil;
//          // LSocket := FSocket;
//          if TSocketState.Connected in LSocket.State then
//            begin
//              LReceiveBuffer := LSocket.Receive;
//              if Length(LReceiveBuffer) <> 0 then
//                begin
//                  TThread.Synchronize(nil, procedure
//                  var
//                    LReceiveString: string;
//                  begin
//                    LReceiveString := StringOf(LReceiveBuffer);
//                    Memo1.Lines.Add(LReceiveString);
//                  end);
//                end;
//            end;
//          Sleep(LSocket.ReceiveTimeout);
//        end;
//      OutputDebugString('Terminating...');
//    except
//    end;
//  end);
//  FThread.FreeOnTerminate := False;
//  FThread.Start;
end;

procedure TfrmSocketClient.FormDestroy(Sender: TObject);
begin
  if Assigned(FThread) then
    FThread.Terminate;
  FThread.Free;
  FSocket.Free;
end;

end.
