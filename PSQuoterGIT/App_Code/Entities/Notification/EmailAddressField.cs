using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class EmailAddressField
	{
		public int EmailAddressFieldId { get; set; }
		public string EmailAddressFieldName { get; set; }

		public EmailAddressField()
		{
			EmailAddressFieldId = 0;
			EmailAddressFieldName = "";
		}
	}
}