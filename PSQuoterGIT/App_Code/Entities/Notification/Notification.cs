using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using Enums;
using X.Data;

//<CODE_TAG_103443> Dav
namespace Entities.Notification
{
	public class Notification
	{
		public ExecutionState ExecutionState { get; set; }

		public List<Branch> listBranch{ get; set; }
		public List<CommodityCategory> listCommodityCategory{ get; set; }
		public List<Division> listDivision{ get; set; }
		public List<EmailAddressField> listEmailAddressField{ get; set; }
		public List<Event> listEvent{ get; set; }
		public List<QuoteStatus> listQuoteStatus{ get; set; }
		public List<QuoteType> listQuoteType{ get; set; }
		public List<RecipientType> listRecipientType { get; set; }
		public List<NotificationSetting> listNotificationSetting { get; set; }

		public int TotalRecords { get; set; }

		public Notification()
		{
			ExecutionState = new ExecutionState(0, null); 
			
			listBranch = new List<Branch>();
			listCommodityCategory = new List<CommodityCategory>();
			listDivision = new List<Division>();
			listEmailAddressField = new List<EmailAddressField>();
			listEvent = new List<Event>();
			listQuoteStatus = new List<QuoteStatus>();
			listQuoteType = new List<QuoteType>();
			listRecipientType = new List<RecipientType>();
			listNotificationSetting = new List<NotificationSetting>();

			TotalRecords = 0;
		}
	}
}