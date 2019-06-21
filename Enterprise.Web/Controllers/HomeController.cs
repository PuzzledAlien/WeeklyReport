using Sheng.Enterprise.Core;
using Enterprise.Web.Models;
using System;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Enterprise.Web.Controllers
{
	public class HomeController : EnterpriseController
	{
		private static readonly UserManager _userManager = UserManager.Instance;

		private static readonly DomainManager _domainManager = DomainManager.Instance;

		[AllowAnonymous]
		public ActionResult Login()
		{
			LoginViewModel model = new LoginViewModel();
			return View(model);
		}

		public ActionResult Logout()
		{
			SessionContainer.ClearUserContext(HttpContext);
			return RedirectToAction("Login");
		}

		[AllowAnonymous]
		public ActionResult Register()
		{
			RegisterViewModel model = new RegisterViewModel();
			return View(model);
		}

		[AllowAnonymous]
		public ActionResult ResetPassword()
		{
			return View();
		}

		public ActionResult Introduction()
		{
			return View();
		}

		[AllowAnonymous]
		public ActionResult ErrorView()
		{
			return View();
		}

		public ActionResult Index()
		{
			return View();
		}
	}
}
