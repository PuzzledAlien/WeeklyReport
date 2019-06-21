using System;
using Microsoft.AspNetCore.Mvc;

namespace Enterprise.Web.Controllers
{
	public class UnityController : EnterpriseController
	{
		public ActionResult OrganizationSelector()
		{
			return base.View();
		}

		public ActionResult PersonSelector()
		{
			return base.View();
		}

		public ActionResult MultiplePersonSelector()
		{
			return base.View();
		}
	}
}
