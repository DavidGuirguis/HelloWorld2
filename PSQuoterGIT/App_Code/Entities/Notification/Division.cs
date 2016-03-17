using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class Division
	{
		public int DivisionId { get; set; }
		public string DivisionName { get; set; }
		public string DivisionNameDesc { get; set; }

		public Division()
		{
			DivisionId = 0;
			DivisionName = "";
			DivisionNameDesc = "";
		}
	}
}