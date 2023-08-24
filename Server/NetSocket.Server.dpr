program NetSocket.Server;

uses
  Vcl.Forms,
  NetSocket.Server.Main in 'NetSocket.Server.Main.pas' {frmSocketServer},
  System.Net.ServerSocket in 'System.Net.ServerSocket.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSocketServer, frmSocketServer);
  Application.Run;
end.
