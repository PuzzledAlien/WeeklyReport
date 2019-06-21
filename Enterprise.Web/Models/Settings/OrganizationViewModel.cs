using Sheng.Enterprise.Infrastructure;
using System;

namespace Enterprise.Web.Models
{
	public class OrganizationViewModel
	{
		private Domain _domain = new Domain();

		public Domain Domain
		{
			get
			{
				return this._domain;
			}
			set
			{
				this._domain = value;
			}
		}
	}
}
