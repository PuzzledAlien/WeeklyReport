using Sheng.Enterprise.Infrastructure;
using System;
using System.Collections.Generic;

namespace Enterprise.Web.Models
{
	public class WorkTypeViewModel
	{
		public List<WorkType> WorkTypeList
		{
			get;
			set;
		}

		public List<WorkTask> WorkTaskList
		{
			get;
			set;
		}
	}
}
