using System;
using WebSocketSharp.Net.WebSockets;

namespace WebSocketSharp
{
    public class DestroyOnDisposeWebSocket: WebSocket, IDisposable
    {
        internal DestroyOnDisposeWebSocket(HttpListenerWebSocketContext context, string protocol) : base(context, protocol)
        {
        }

        internal DestroyOnDisposeWebSocket(TcpListenerWebSocketContext context, string protocol) : base(context, protocol)
        {
        }

        public DestroyOnDisposeWebSocket(string url, params string[] protocols) : base(url, protocols)
        {
        }
        
        #region Explicit Interface Implementations

        /// <summary>
        /// Closes the WebSocket connection, and releases all associated resources, without attempting
        /// the disconnection handshake
        /// </summary>
        /// <remarks>
        /// This method closes the connection with <see cref="CloseStatusCode.Away"/>.
        /// </remarks>
        void IDisposable.Dispose ()
        {
            close (new CloseEventArgs (CloseStatusCode.Away), false, false);
        }

        #endregion
    }
}