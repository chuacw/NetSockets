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

implementation

end.
