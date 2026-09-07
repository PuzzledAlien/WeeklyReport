using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Linkup.Common
{
    /// <summary>
    /// Critical  Error  Warning  Information  Verbose  ActivityTracing 严重程度依次递减
    /// </summary>
    public class LogService
    {
        private static LogService _instance;
        public static LogService Instance => _instance ?? (_instance = new LogService());

        protected LogService()
        {
            // 使用简单的日志实现，不再依赖Enterprise Library
        }

        /// <summary>
        /// Information
        /// </summary>
        /// <param name="message"></param>
        /// <param name="title"></param>
        public void Write(string title)
        {
            Write(title, null, TraceEventType.Information);
        }

        public void Write(string title, TraceEventType traceEventType)
        {
            Write(title, null, traceEventType);
        }

        /// <summary>
        /// Information
        /// </summary>
        /// <param name="title"></param>
        /// <param name="message"></param>
        public void Write(string title, string message)
        {
            Write(title, message, TraceEventType.Information);
        }

        public void Write(string title, string message, TraceEventType traceEventType)
        {
            // 使用System.Diagnostics.Trace进行简单日志记录
            string logMessage = $"[{traceEventType}] {title}: {message}";
            Trace.WriteLine(logMessage);

            // 同时输出到Debug窗口
            Debug.WriteLine(logMessage);
        }
    }
}