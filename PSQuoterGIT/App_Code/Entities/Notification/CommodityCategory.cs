using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class CommodityCategory
	{
		public int CommodityCategoryId { get; set; }
		public string CommodityCategoryName { get; set; }

		public CommodityCategory()
		{
			CommodityCategoryId = 0;
			CommodityCategoryName = "";
		}
	}
}