program NetSocket.Client;

uses
  Vcl.Forms,
  NetSocket.Client.Main in 'NetSocket.Client.Main.pas' {frmSocketClient},
  System.Net.ClientSocket in 'System.Net.ClientSocket.pas',
  System.Net.Socket.Common in '..\Common\System.Net.Socket.Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSocketClient, frmSocketClient);
  Application.Run;
end.
