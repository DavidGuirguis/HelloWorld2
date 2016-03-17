using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class RecipientType
	{
		public int RecipientTypeId { get; set; }
		public string RecipientTypeName { get; set; }
		public bool ShowTextArea { get; set; }
		public bool ShowUserSearch { get; set; }

		public RecipientType()
		{
			RecipientTypeId = 0;
			RecipientTypeName = "";
			ShowUserSearch = false;
			ShowUserSearch = false;

		}
	}
}