using Linkup.Common;
using Newtonsoft.Json;
using Sheng.Enterprise.Infrastructure;
using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Authorization;

namespace Enterprise.Web
{
    public class EnterpriseController : Controller
    {
        public UserContext UserContext { get; set; }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            if(filterContext.ActionDescriptor.EndpointMetadata != null)
            {
                foreach(var obj in filterContext.ActionDescriptor.EndpointMetadata)
                {
                    if(obj is AllowAnonymousAttribute )
                    {
                        return;
                    }
                }
            }

            this.UserContext = SessionContainer.GetUserContext(filterContext.HttpContext);
            if (this.UserContext == null)
            {
                filterContext.Result = new RedirectResult("~/Home/Login");
                return;
            }

            List<string> list = new List<string>();
            int num = 2015;
            int year = DateTime.Now.Year;
            do
            {
                list.Add(num.ToString());
                num++;
            } while (num <= year);

            ViewBag.UserContext = this.UserContext;
            ViewBag.RootOrganization = this.UserContext.RootOrganization;
            ViewBag.User = this.UserContext.User;
            ViewBag.Domain = this.UserContext.Domain;
            ViewBag.YearList = list;
        }

        protected T RequestArgs<T>() where T : class
        {
            return JsonConvert.DeserializeObject<T>(new StreamReader(HttpContext.Request.Body).ReadToEndAsync().Result);
        }


        protected virtual ContentResult RespondResult()
		{
			return this.RespondResult(true, null);
		}

		protected virtual ContentResult RespondResult(bool success, string message)
		{
			return this.RespondResult(success, message, null);
		}

		protected virtual ContentResult RespondResult(bool success, string message, object data)
		{
			ApiResult apiResult = new ApiResult
			{
				Success = success,
				Message = message,
				Data = data
			};
			return this.RespondResult(apiResult);
		}

		protected virtual ContentResult RespondResult(ApiResult apiResult)
		{
			return new ContentResult
			{
				Content = JsonHelper.NewtonsoftSerializer(apiResult)
			};
		}

		protected virtual ContentResult RespondDataResult(object data)
		{
			return this.RespondResult(true, null, data);
		}
	}
}
