using Sheng.Enterprise.Infrastructure;
using System.Text;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;

namespace Enterprise.Web
{
    public static class SessionContainer
    {
        public static void SetUserContext(HttpContext httpContext, UserContext userContext)
        {
            var json = JsonConvert.SerializeObject(userContext);
            var value = Encoding.UTF8.GetBytes(json);
            httpContext.Session.Set("UserContext", value);
        }

        public static UserContext GetUserContext(HttpContext httpContext)
        {
            if (!httpContext.Session.TryGetValue("UserContext", out var value))
            {
                return null;
            }
            var json = Encoding.UTF8.GetString(value);
            return JsonConvert.DeserializeObject<UserContext>(json);
        }

        public static void ClearUserContext(HttpContext httpContext)
        {
            httpContext.Session.Clear();
        }
    }
}
