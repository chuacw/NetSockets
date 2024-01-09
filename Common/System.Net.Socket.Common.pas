unit System.Net.Socket.Common;

interface

uses
  Winapi.Winsock2, System.Net.Socket, System.SysUtils;

const
  AF_INET  = Winapi.Winsock2.AF_INET;
  AF_INET6 = Winapi.Winsock2.AF_INET6;

type

  TNetEndpoint = System.Net.Socket.TNetEndpoint;
  TProc = System.SysUtils.TProc;
  TSocketState = System.Net.Socket.TSocketState;
  TSocketStates = System.Net.Socket.TSocketStates;

  TSocket = class(System.Net.Socket.TSocket)
  protected
//    function CreateSocket: TSocketHandle; override;
  end;

  TBaseSocket = class
  protected
    FSocket: TSocket;
  end;

implementation

{ TSocket }

//function TSocket.CreateSocket: TSocketHandle;
//const
//  _Type: array[TSocketType] of Integer = (SOCK_STREAM, SOCK_DGRAM, SOCK_RAW, SOCK_RDM, SOCK_SEQPACKET);
//  Proto: array[TSocketType] of Integer = (IPPROTO_TCP, IPPROTO_UDP, IPPROTO_IP, IPPROTO_IP, IPPROTO_IP);
//begin
//  Result := socket(PF_INET, _Type[SocketType], Proto[SocketType]);
////  CheckSocketResult(Result, 'socket');
//  if ReceiveTimeout > 0 then
//    DoSetReceiveTimeout(ReceiveTimeout);
//  if SendTimeout > 0 then
//    DoSetSendTimeout(SendTimeout);
//end;

end.
