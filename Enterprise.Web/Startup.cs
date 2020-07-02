using Linkup.Common;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Sheng.Enterprise.Core;
using System;
using System.IO;
using System.Text.Encodings.Web;
using System.Text.Unicode;
using Microsoft.Extensions.FileProviders;

namespace Enterprise.Web
{
    public class Startup
    {
        private static LogService _logService = LogService.Instance;

        private ExceptionHandlingService _exceptionHandling = ServiceUnity.Instance.ExceptionHandling;
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            _logService.Write("Application_Start");

            services.Configure<CookiePolicyOptions>(options =>
            {
                // This lambda determines whether user consent for non-essential cookies is needed for a given request.
                options.CheckConsentNeeded = context => true;
            });

            services.AddHttpContextAccessor();

            services.AddDistributedMemoryCache();

            services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromMinutes(10);
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
            });

            services.AddControllersWithViews()
                .AddNewtonsoftJson();
            services.AddRazorPages();

            services.AddSingleton(HtmlEncoder.Create(UnicodeRanges.All));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
            }

            app.UseStaticFiles();

            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(Directory.GetCurrentDirectory(), "ExcelExport")),
                RequestPath = "/ExcelExport"
            });

            app.UseCookiePolicy();

            app.UseRouting();

            app.UseAuthorization();

            app.UseSession();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapControllerRoute(
                    name: "Default",
                    pattern: "{controller}/{action}",
                    defaults: new { controller = "WeeklyReport", action = "Post" }
                    );
                endpoints.MapControllerRoute(
                    name: "Api_default", 
                    pattern:"Api/{controller}/{action}",
                    defaults: new { action = "Index" },
                    constraints: new { area = "api" }
                    );
                endpoints.MapDefaultControllerRoute();
                endpoints.MapRazorPages();
            });
        }
    }
}
