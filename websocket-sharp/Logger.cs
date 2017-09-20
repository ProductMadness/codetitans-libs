#region License
/*
 * Logger.cs
 *
 * The MIT License
 *
 * Copyright (c) 2013-2014 sta.blockhead
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#endregion

using System;
using System.Diagnostics;
using System.IO;
using WebSocketSharp.Net;

namespace WebSocketSharp
{
    public static class Logger
    {
        public static ILogger ExtLogger { get; set; }

        #region Implementation of ILogger

        /// <inheritdoc />
        internal static void Debug(string message)
        {
            if(ExtLogger != null)
                ExtLogger.Debug(message);
        }

        /// <inheritdoc />
        internal static void Fatal(string message)
        {
            if (ExtLogger != null)
                ExtLogger.Fatal(message);
        }

        /// <inheritdoc />
        internal static void Warn(string message)
        {
            if (ExtLogger != null)
                ExtLogger.Warn(message);
        }

        /// <inheritdoc />
        internal static void Trace(string message)
        {
            if (ExtLogger != null)
                ExtLogger.Trace(message);
        }

        /// <inheritdoc />
        internal static void Error(string message)
        {
            if (ExtLogger != null)
                ExtLogger.Error(message);
        }

        /// <inheritdoc />
        internal static void Info(string message)
        {
            if (ExtLogger != null)
                ExtLogger.Info(message);
        }

        #endregion
    }
}
