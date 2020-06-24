using Linkup.Common;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Sheng.Enterprise.Core;

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
            services.AddSession();

            services.AddControllersWithViews()
                .AddNewtonsoftJson();
            services.AddRazorPages();

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

            app.UseSession();

            app.UseStaticFiles();

            app.UseCookiePolicy();

            app.UseRouting();

            app.UseAuthorization();

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
