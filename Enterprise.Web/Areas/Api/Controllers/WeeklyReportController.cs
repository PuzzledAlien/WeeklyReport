using Sheng.Enterprise.Core;
using Sheng.Enterprise.Infrastructure;
using System;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace Enterprise.Web.Areas.Api.Controllers
{
	public class WeeklyReportController : EnterpriseController
	{
		private static readonly WeeklyReportManager _weeklyReportManager = WeeklyReportManager.Instance;
        private readonly IWebHostEnvironment _environment;
        public WeeklyReportController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

		[HttpPost("Api/{controller}/Post")]
        public ActionResult PostWeeklyReport()
		{
			WeeklyReport weeklyReport = base.RequestArgs<WeeklyReport>();
			weeklyReport.Domain = base.UserContext.Domain.Id;
			weeklyReport.User = base.UserContext.User.Id;
			DateTime monday;
			DateTime sunday;
			DateTimeHelper.GetWeek(weeklyReport.Year, weeklyReport.WeekOfYear, out monday, out sunday);
			weeklyReport.Monday = monday;
			weeklyReport.Sunday = sunday;
			if (weeklyReport.ItemList != null)
			{
				foreach (WeeklyReportItem item in weeklyReport.ItemList)
				{
					item.Domain = base.UserContext.Domain.Id;
					item.WeeklyReport = weeklyReport.Id;
					item.User = weeklyReport.User;
					item.Year = weeklyReport.Year;
					item.Month = weeklyReport.Month;
					item.WeekOfYear = weeklyReport.WeekOfYear;
					item.Monday = weeklyReport.Monday;
					item.Sunday = weeklyReport.Sunday;
				}
			}
			WeeklyReportController._weeklyReportManager.Post(weeklyReport);
			var data = new
			{
				WeekLogId = weeklyReport.Id
			};
			return this.RespondDataResult(data);
		}

		public ActionResult Check()
		{
			CheckResult checkResult = base.RequestArgs<CheckResult>();
			checkResult.Checker = base.UserContext.User.Id;
			DateTime monday;
			DateTime sunday;
			DateTimeHelper.GetWeek(checkResult.Year, checkResult.WeekOfYear, out monday, out sunday);
			checkResult.Monday = monday;
			checkResult.Sunday = sunday;
			WeeklyReportController._weeklyReportManager.Check(checkResult);
			return this.RespondResult();
		}

		public ActionResult Uncheck()
		{
			string input = base.Request.Query["id"];
			WeeklyReportController._weeklyReportManager.Uncheck(Guid.Parse(input));
			return this.RespondResult();
		}

		public ActionResult ExportByPersonal()
		{
			ExportByPersonalArgs args = base.RequestArgs<ExportByPersonalArgs>();
			FileInfo fileInfo = new FileInfo(ExcelHelper.ExportPersonal(_environment.ContentRootPath, args));
			return this.RespondDataResult(fileInfo.Name);
		}

		public ActionResult ExportByWorkType()
		{
			ExportByWorkTypeArgs exportByWorkTypeArgs = base.RequestArgs<ExportByWorkTypeArgs>();
			exportByWorkTypeArgs.Domain = base.UserContext.Domain.Id;
			FileInfo fileInfo = new FileInfo(ExcelHelper.ExportWorkType(_environment.ContentRootPath, exportByWorkTypeArgs));
			return this.RespondDataResult(fileInfo.Name);
		}

		public ActionResult ExportByOrganization()
		{
			ExportByOrganizationArgs exportByOrganizationArgs = base.RequestArgs<ExportByOrganizationArgs>();
			exportByOrganizationArgs.Domain = base.UserContext.Domain.Id;
			FileInfo fileInfo = new FileInfo(ExcelHelper.ExportOrganization(_environment.ContentRootPath, exportByOrganizationArgs));
			return this.RespondDataResult(fileInfo.Name);
		}
	}
}
