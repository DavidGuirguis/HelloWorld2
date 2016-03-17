using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class QuoteType
	{
		public int QuoteTypeId { get; set; }
		public string QuoteTypeDesc { get; set; }

		public QuoteType()
		{
			QuoteTypeId = 0;
			QuoteTypeDesc = "";
		}
	}
}