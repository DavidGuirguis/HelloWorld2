using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class Branch
	{
		public string BranchNo { get; set; }
		public string BranchName { get; set; }

		public Branch()
		{
			BranchNo = "";
			BranchName = "";
		}
	}
}