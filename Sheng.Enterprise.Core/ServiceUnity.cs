using Linkup.Common;
using Linkup.Data;

namespace Sheng.Enterprise.Core
{
	public class ServiceUnity
	{
        public static ServiceUnity Instance { get; } = new ServiceUnity();

        public DatabaseWrapper Database { get; set; } = new DatabaseWrapper();

        public LogService Log { get; } = LogService.Instance;

        public ExceptionHandlingService ExceptionHandling { get; } = ExceptionHandlingService.Instance;
    }
}
