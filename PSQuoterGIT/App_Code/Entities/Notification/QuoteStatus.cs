using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class QuoteStatus
	{
		public int QuoteStatusId { get; set; }
		public string QuoteStatusName { get; set; }

		public QuoteStatus()
		{
			QuoteStatusId = 0;
			QuoteStatusName = "";
		}
	}
}