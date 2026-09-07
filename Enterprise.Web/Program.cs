using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Linkup.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Enterprise.Web
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    // 在 Startup 之前设置数据库配置
                    webBuilder.ConfigureAppConfiguration((context, config) =>
                    {
                        var configuration = config.Build();
                        DatabaseWrapper.SetConfiguration(configuration);
                    });
                    webBuilder.UseStartup<Startup>();
                });
    }
}


