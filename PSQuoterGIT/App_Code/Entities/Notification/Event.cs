using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class Event
	{
		public int EventId { get; set; }
		public string EventName { get; set; }
		public string EmailSubject { get; set; }
		public string EmailBody { get; set; }

		public Event()
		{
			EventId = 0;
			EventName = "";
			EmailSubject = "";
			EmailBody = "";
		}
	}
}