using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using X.Data;

//<CODE_TAG_103543> Dav
namespace Entities.Notification
{
	public class NotificationSetting
	{
		public ExecutionState ExecutionState { get; set; }

		public int SettingId { get; set; }
		
		public int RecipientTypeId { get; set; }
		public string RecipientTypeName { get; set; }
		public bool ShowTextArea { get; set; }
		public bool ShowUserSearch { get; set; }

		public int RecipientXUId { get; set; }
		public string RecipientFirstName { get; set; }
		public string RecipientLastName { get; set; }
		public string RecipientDistributionList { get; set; }

		public int EmailAddressFieldId { get; set; }
		public string EmailAddressFieldName { get; set; }

		public int EventId { get; set; }
		public string EventName { get; set; }

		public int bmQuoteTypeId { get; set; }
		public string QuoteTypeList { get; set; }

		public int bmQuoteStatusId { get; set; }
		public string QuoteStatusList { get; set; }

		public int bmDivisionId { get; set; }
		public string DivisionList { get; set; }

		public string EmailSubject { get; set; }
		public string EmailBody { get; set; }
		public string Comment { get; set; }

		public int EnterXUID { get; set; }
		public string EnterFirstName { get; set; }
		public string EnterLastName { get; set; }
		public DateTime EnterDate { get; set; }

		public int ChangeXUId { get; set; }
		public string ChangeFirstName { get; set; }
		public string ChangeLastName { get; set; }
		public DateTime ChangeDate { get; set; }

		public string BranchNoList { get; set; }
		public string BranchList { get; set; }

		public string CommodityCategoryIdList { get; set; }
		public string CommodityCategoryList { get; set; }

		public int TotalRecords { get; set; }

		public NotificationSetting()
		{
			ExecutionState = new ExecutionState(0, null);
			TotalRecords = 0;
		}
	}
}