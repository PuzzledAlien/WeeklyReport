using Sheng.Enterprise.Core;
using Sheng.Enterprise.Infrastructure;
using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;

namespace Enterprise.Web.Areas.Api.Controllers
{
	public class SettingsController : EnterpriseController
	{
		private SettingsManager _settingsManager = SettingsManager.Instance;

		[HttpPost("Api/Settings/CreateJobTitle")]
		public ActionResult CreateJobTitle()
		{
			JobTitle jobTitle = RequestArgs<JobTitle>();
			if (jobTitle == null)
			{
				return RespondResult(false, "参数无效。");
			}
			jobTitle.Id = Guid.NewGuid();
			_settingsManager.CreateJobTitle(jobTitle);
			return RespondDataResult(new
			{
				jobTitle.Id
			});
		}

		[HttpPost("Api/Settings/UpdateJobTitle")]
		public ActionResult UpdateJobTitle()
		{
			JobTitle jobTitle = RequestArgs<JobTitle>();
			if (jobTitle == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateJobTitle(jobTitle);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveJobTitle")]
		public ActionResult RemoveJobTitle()
        {
            string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveJobTitle(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateJobLevel")]
		public ActionResult CreateJobLevel()
		{
			JobLevel jobLevel = RequestArgs<JobLevel>();
			if (jobLevel == null)
			{
				return RespondResult(false, "参数无效。");
			}
			jobLevel.Id = Guid.NewGuid();
			_settingsManager.CreateJobLevel(jobLevel);
			return RespondDataResult(new
			{
				jobLevel.Id
			});
		}

		[HttpPost("Api/Settings/UpdateJobLevel")]
		public ActionResult UpdateJobLevel()
		{
			JobLevel jobLevel = RequestArgs<JobLevel>();
			if (jobLevel == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateJobLevel(jobLevel);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveJobLevel")]
		public ActionResult RemoveJobLevel()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveJobLevel(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateOfficeLocation")]
		public ActionResult CreateOfficeLocation()
		{
			OfficeLocation officeLocation = RequestArgs<OfficeLocation>();
			if (officeLocation == null)
			{
				return RespondResult(false, "参数无效。");
			}
			officeLocation.Id = Guid.NewGuid();
			_settingsManager.CreateOfficeLocation(officeLocation);
			return RespondDataResult(new
			{
				officeLocation.Id
			});
		}

		[HttpPost("Api/Settings/UpdateOfficeLocation")]
		public ActionResult UpdateOfficeLocation()
		{
			OfficeLocation officeLocation = RequestArgs<OfficeLocation>();
			if (officeLocation == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateOfficeLocation(officeLocation);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveOfficeLocation")]
		public ActionResult RemoveOfficeLocation()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveOfficeLocation(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateWorkType")]
		public ActionResult CreateWorkType()
		{
			WorkType workType = RequestArgs<WorkType>();
			if (workType == null)
			{
				return RespondResult(false, "参数无效。");
			}
			workType.Id = Guid.NewGuid();
			_settingsManager.CreateWorkType(workType);
			return RespondDataResult(new
			{
				workType.Id
			});
		}

		[HttpPost("Api/Settings/UpdateWorkType")]
		public ActionResult UpdateWorkType()
		{
			WorkType workType = RequestArgs<WorkType>();
			if (workType == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateWorkType(workType);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveWorkType")]
		public ActionResult RemoveWorkType()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveWorkType(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateWorkTask")]
		public ActionResult CreateWorkTask()
		{
			WorkTask workTask = RequestArgs<WorkTask>();
			if (workTask == null)
			{
				return RespondResult(false, "参数无效。");
			}
			workTask.Id = Guid.NewGuid();
			_settingsManager.CreateWorkTask(workTask);
			return RespondDataResult(new
			{
				workTask.Id
			});
		}

		[HttpPost("Api/Settings/UpdateWorkTask")]
		public ActionResult UpdateWorkTask()
		{
			WorkTask workTask = RequestArgs<WorkTask>();
			if (workTask == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateWorkTask(workTask);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveWorkTask")]
		public ActionResult RemoveWorkTask()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveWorkTask(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateWorkStatus")]
		public ActionResult CreateWorkStatus()
		{
			WorkStatus workStatus = RequestArgs<WorkStatus>();
			if (workStatus == null)
			{
				return RespondResult(false, "参数无效。");
			}
			workStatus.Id = Guid.NewGuid();
			_settingsManager.CreateWorkStatus(workStatus);
			return RespondDataResult(new
			{
				workStatus.Id
			});
		}

		[HttpPost("Api/Settings/UpdateWorkStatus")]
		public ActionResult UpdateWorkStatus()
		{
			WorkStatus workStatus = RequestArgs<WorkStatus>();
			if (workStatus == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.UpdateWorkStatus(workStatus);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveWorkStatus")]
		public ActionResult RemoveWorkStatus()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveWorkStatus(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/CreateCheckRelation")]
		public ActionResult CreateCheckRelation()
		{
			CheckRelationJsonContract checkRelationJsonContract = RequestArgs<CheckRelationJsonContract>();
			if (checkRelationJsonContract == null)
			{
				return RespondResult(false, "参数无效。");
			}
			checkRelationJsonContract.Domain = UserContext.Domain.Id;
			_settingsManager.CreateCheckRelation(checkRelationJsonContract);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveCheckRelation")]
		public ActionResult RemoveCheckRelation()
		{
			string text = Request.Query["checker"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveCheckRelation(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/GetCheckStaffList")]
		public ActionResult GetCheckStaffList()
		{
			string text = Request.Query["checker"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			List<CheckStaffWrapper> checkStaffList = _settingsManager.GetCheckStaffList(Guid.Parse(text));
			return RespondDataResult(checkStaffList);
		}

		[HttpPost("Api/Settings/CreateRole")]
		public ActionResult CreateRole()
		{
			Role role = RequestArgs<Role>();
			if (role == null)
			{
				return RespondResult(false, "参数无效。");
			}
			role.Id = Guid.NewGuid();
			role.Domain = UserContext.Domain.Id;
			_settingsManager.CreateRole(role);
			return RespondDataResult(new
			{
				role.Id
			});
		}

		[HttpPost("Api/Settings/UpdateRole")]
		public ActionResult UpdateRole()
		{
			Role role = RequestArgs<Role>();
			if (role == null)
			{
				return RespondResult(false, "参数无效。");
			}
			role.Domain = UserContext.Domain.Id;
			_settingsManager.UpdateRole(role);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveRole")]
		public ActionResult RemoveRole()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveRole(Guid.Parse(text));
			return RespondResult();
		}

		[HttpPost("Api/Settings/GetRole")]
		public ActionResult GetRole()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			Role role = _settingsManager.GetRole(Guid.Parse(text));
			return RespondDataResult(role);
		}

		[HttpPost("Api/Settings/GetAuthorizationListByRoleId")]
		public ActionResult GetAuthorizationListByRoleId()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			List<Authorization> authorizationListByRoleId = _settingsManager.GetAuthorizationListByRoleId(Guid.Parse(text));
			return RespondDataResult(authorizationListByRoleId);
		}

		[HttpPost("Api/Settings/UpdateAuthorizationListByRoleId")]
		public ActionResult UpdateAuthorizationListByRoleId()
		{
			RoleAuthorizationRelation roleAuthorizationRelation = RequestArgs<RoleAuthorizationRelation>();
			if (roleAuthorizationRelation == null)
			{
				return RespondResult(false, "参数无效。");
			}
			roleAuthorizationRelation.Domain = UserContext.Domain.Id;
			_settingsManager.UpdateAuthorizationListByRoleId(roleAuthorizationRelation);
			return RespondResult();
		}

		[HttpPost("Api/Settings/AddUserToRole")]
		public ActionResult AddUserToRole()
		{
			List<RoleUser> list = RequestArgs<List<RoleUser>>();
			if (list == null)
			{
				return RespondResult(false, "参数无效。");
			}
			using (List<RoleUser>.Enumerator enumerator = list.GetEnumerator())
			{
				while (enumerator.MoveNext())
				{
					enumerator.Current.Domain = UserContext.Domain.Id;
				}
			}
			_settingsManager.AddUserToRole(list);
			return RespondResult();
		}

		[HttpPost("Api/Settings/RemoveUserFromRole")]
		public ActionResult RemoveUserFromRole()
		{
			RoleUser roleUser = RequestArgs<RoleUser>();
			if (roleUser == null)
			{
				return RespondResult(false, "参数无效。");
			}
			_settingsManager.RemoveUserFromRole(roleUser);
			return RespondResult();
		}

		[HttpPost("Api/Settings/GetUserListByRoleId")]
		public ActionResult GetUserListByRoleId()
		{
			string text = Request.Query["id"];
			if (string.IsNullOrEmpty(text))
			{
				return RespondResult(false, "参数无效。");
			}
			List<User> userListByRoleId = _settingsManager.GetUserListByRoleId(Guid.Parse(text));
			return RespondDataResult(userListByRoleId);
		}

		[HttpGet("Api/Settings/Feedback")]
		public ActionResult Feedback()
		{
			Feedback feedback = RequestArgs<Feedback>();
			if (feedback == null)
			{
				return RespondResult(false, "参数无效。");
			}
			feedback.Domain = UserContext.Domain.Id;
			feedback.User = UserContext.User.Id;
			feedback.IP = HttpContext?.Features?.Get<IHttpConnectionFeature>()?.RemoteIpAddress?.ToString();
			feedback.Time = DateTime.Now;
			_settingsManager.Feedback(feedback);
			return RespondResult();
		}
	}
}
