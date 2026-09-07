using System;
using System.Configuration;

namespace Linkup.Common
{
    public class ExceptionHandlingService
    {
        private static ExceptionHandlingService _instance;
        public static ExceptionHandlingService Instance => _instance ?? (_instance = new ExceptionHandlingService());

        private readonly LogService _log = LogService.Instance;

        private ExceptionHandlingService()
        {
        }

        /// <summary>
        /// JustLog
        /// </summary>
        /// <param name="exceptionToHandle"></param>
        /// <returns></returns>
        public bool HandleException(Exception exceptionToHandle)
        {
            if (exceptionToHandle == null)
            {
                return true;
            }

            if (exceptionToHandle is WrappedException)
            {
                return true;
            }

            // 简单实现：只记录日志
            _log.Write("Exception", exceptionToHandle.Message, System.Diagnostics.TraceEventType.Error);
            return true;
        }

        public bool HandleException(Exception exceptionToHandle, string policyName)
        {
            return HandleException(exceptionToHandle);
        }

        /// <summary>
        /// LogAndWrap
        /// 如果 exceptionToHandle 是 WrappedException ,表示已经是企业库处理过的了
        /// 直接返回不再交给企业库处理
        /// exceptionToHandle 会被包装到 WrappedException 的 InnerException 中 放到 exceptionToThrow 中
        /// </summary>
        /// <param name="exceptionToHandle"></param>
        /// <param name="exceptionToThrow"></param>
        /// <returns></returns>
        public bool HandleException(Exception exceptionToHandle, out Exception exceptionToThrow)
        {
            if (exceptionToHandle is WrappedException)
            {
                exceptionToThrow = exceptionToHandle;
                return true;
            }

            // 简单实现：记录日志并将异常包装后抛出
            _log.Write("Exception", exceptionToHandle.Message, System.Diagnostics.TraceEventType.Error);
            exceptionToThrow = new WrappedException("An error occurred. See inner exception for details.", exceptionToHandle);
            return true;
        }
    }

    /// <summary>
    /// 异常包装类
    /// </summary>
    [Serializable]
    public class WrappedException : Exception
    {
        public WrappedException() : base() { }
        public WrappedException(string message) : base(message) { }
        public WrappedException(string message, Exception inner) : base(message, inner) { }
        protected WrappedException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }

    public static class ExceptionPolicyNames
    {
        /// <summary>
        /// 记录日志，并对异常进行包装后继续抛出
        /// </summary>
        public const string LogAndWrap = "LogAndWrap";

        /// <summary>
        /// 只记录日志，不继续抛出
        /// </summary>
        public const string JustLog = "JustLog";
    }
}