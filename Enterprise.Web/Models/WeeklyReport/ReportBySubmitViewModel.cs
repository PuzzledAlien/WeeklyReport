using Sheng.Enterprise.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;

namespace Enterprise.Web.Models
{
	public class ReportBySubmitViewModel
	{
		public int Year
		{
			get;
			set;
		}

		public int Month
		{
			get;
			set;
		}

		public int WeekOfYear
		{
			get;
			set;
		}

		public int CurrentWeekOfYear
		{
			get;
			set;
		}

		public Guid OrganizationId
		{
			get;
			set;
		}

		public string OrganizationName
		{
			get;
			set;
		}

		public List<Week> WeekList
		{
			get;
			set;
		}

		public DataTable Data
		{
			get;
			set;
		}
	}
}
