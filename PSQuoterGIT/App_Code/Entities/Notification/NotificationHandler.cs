using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using Entities;
using Entities.AppState;
using Enums;
using X.Data;
using X.Extensions;
using System.Data.SqlClient;
using X;
using X.Web;
using Microsoft.VisualBasic;

namespace Entities.Notification
{
	public class NotificationHandler
	{
		public Notification GetNotification()
		{			
			var SQLParams = new List<SqlParameter>();
			SQLParams.AddRange(GetReturnResultSqlParams());

			var data = SqlHelper.ExecuteDataset(
				 CommandType.StoredProcedure
				, "dbo.Notification_Setting_List"
				, SQLParams.ToArray()
				);

			var returnCode = SQLParams[0].Value.AsInt();
			var returnCodeDesc = "";//SQLParams[1].Value.AsString(trim: true, defaultValue: null);
			var objNotification = new Notification
			{
				ExecutionState = new ExecutionState(returnCode, returnCodeDesc)
			};

			foreach (DataTable dataTable in data.Tables)
			{
				if (dataTable.Rows.Count == 0 || !dataTable.Columns.Contains("RS_Type"))
					continue;

				var rsType = dataTable.Rows[0]["RS_Type"].As<string>("");

				switch (rsType)
				{
					case "Filter.RecipientType":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new RecipientType
							{
								RecipientTypeId = row["RecipientTypeId"].As<int>(),
								RecipientTypeName = row["RecipientTypeName"].As<string>(),

								ShowTextArea = row["ShowTextArea"].As<int>(1) == 2 ? true : false,
								ShowUserSearch = row["ShowUserSearch"].As<int>(1) == 2 ? true : false,
							};
							objNotification.listRecipientType.Add(list);
						}
						break;
					case "Filter.EmailAddressField":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new EmailAddressField
							{
								EmailAddressFieldId = row["EmailAddressFieldId"].As<int>(),
								EmailAddressFieldName = row["EmailAddressFieldName"].As<string>(),
							};
							objNotification.listEmailAddressField.Add(list);
						}
						break;
					case "Filter.Event":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new Event
							{
								EventId = row["EventId"].As<int>(),
								EventName = row["EventName"].As<string>(),
								EmailSubject = row["EmailSubject"].As<string>(),
								EmailBody = row["EmailBody"].As<string>(),
							};
							objNotification.listEvent.Add(list);
						}
						break;
					case "Filter.QuoteType":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new QuoteType
							{
								QuoteTypeId = row["QuoteTypeId"].As<int>(),
								QuoteTypeDesc = row["QuoteTypeDesc"].As<string>(),
							};
							objNotification.listQuoteType.Add(list);
						}
						break;
					case "Filter.Branch":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new Branch
							{
								BranchNo = row["BranchNo"].As<string>(),
								BranchName = row["BranchName"].As<string>(),
							};
							objNotification.listBranch.Add(list);
						}
						break;
					case "Filter.Division":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new Division
							{
								DivisionId = row["DivisionId"].As<int>(),
								DivisionName = row["Division"].As<string>(),
								DivisionNameDesc = row["DivisionName"].As<string>(),
							};
							objNotification.listDivision.Add(list);
						}
						break;
					case "Filter.CommodityCategory":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new CommodityCategory
							{
								CommodityCategoryId = row["CommodityCategoryId"].As<int>(),
								CommodityCategoryName = row["CommodityCategoryName"].As<string>(),
							};
							objNotification.listCommodityCategory.Add(list);
						}
						break;
					//case "Filter.QuoteStatus":
					//	foreach (DataRow row in dataTable.Rows)
					//	{
					//		var list = new QuoteStatus
					//		{
					//			QuoteStatusId = row["QuoteStatusId"].As<int>(),
					//			QuoteStatusName = row["QuoteStatus"].As<string>(),
					//		};
					//		objNotification.listQuoteStatus.Add(list);
					//	}
					//	break;


					case "Data.Setting":
						foreach (DataRow row in dataTable.Rows)
						{
							var list = new NotificationSetting
							{
								SettingId = row["SettingId"].As<int>(),

								RecipientTypeId = row["RecipientTypeId"].As<int>(),
								RecipientTypeName = row["RecipientTypeName"].As<string>(),
								ShowTextArea = row["ShowTextArea"].As<int>(1) == 2 ? true : false,
								ShowUserSearch = row["ShowUserSearch"].As<int>(1) == 2 ? true : false,

								RecipientXUId = row["RecipientXUId"].As<int>(),
								RecipientFirstName = row["RecipientFirstName"].As<string>(),
								RecipientLastName = row["RecipientLastName"].As<string>(),
								RecipientDistributionList = row["RecipientDistributionList"].As<string>(),

								EmailAddressFieldId = row["EmailAddressFieldId"].As<int>(),
								EmailAddressFieldName = row["EmailAddressFieldName"].As<string>(),

								EventId = row["EventId"].As<int>(),
								EventName = row["EventName"].As<string>(),

								bmQuoteTypeId = row["bmQuoteTypeId"].As<int>(),
								QuoteTypeList = row["QuoteTypeList"].As<string>(),

								//bmQuoteStatusId = row["bmQuoteStatusId"].As<int>(),
								//QuoteStatusList = row["QuoteStatusList"].As<string>(),

								bmDivisionId = row["bmDivisionId"].As<int>(),
								DivisionList = row["DivisionList"].As<string>(),

								EmailSubject = row["EmailSubject"].As<string>(),
								EmailBody = row["EmailBody"].As<string>(),
								Comment = row["Comment"].As<string>(),

								EnterXUID = row["EnterXUID"].As<int>(),
								EnterFirstName = row["EnterFirstName"].As<string>(),
								EnterLastName = row["EnterLastName"].As<string>(),
								EnterDate = row["EnterDate"].As<DateTime>(),

								ChangeXUId = row["ChangeXUId"].As<int>(),
								ChangeFirstName = row["ChangeFirstName"].As<string>(),
								ChangeLastName = row["ChangeLastName"].As<string>(),
								ChangeDate = row["ChangeDate"].As<DateTime>(),

								BranchNoList = row["BranchNoList"].As<string>(),
								BranchList = row["BranchList"].As<string>(),

								CommodityCategoryIdList = row["CommodityCategoryIdList"].As<string>(),
								CommodityCategoryList = row["CommodityCategoryList"].As<string>(),
							};
							objNotification.listNotificationSetting.Add(list);
						}
						break;
				}
			}
			return objNotification;
		}

		/// <summary>
		/// Manage the Notification Setting
		/// </summary>
		/// <param name="objNotificationSetting">Modified Setting</param>
		/// <returns>The affected row</returns>
		public NotificationSetting NotificationAddUpdate(NotificationSetting objNotificationSetting)
		{
			var SQLParams = new List<SqlParameter>();
			SQLParams.AddRange(GetReturnResultSqlParams());
			SQLParams.AddRange(new SqlParameter[] {
				new SqlParameter("SettingId", objNotificationSetting.SettingId),
				new SqlParameter("RecipientTypeId", objNotificationSetting.RecipientTypeId),
				new SqlParameter("RecipientXUId", objNotificationSetting.RecipientXUId),
				new SqlParameter("RecipientDistributionList", objNotificationSetting.RecipientDistributionList),
				new SqlParameter("EmailAddressFieldId", objNotificationSetting.EmailAddressFieldId),
				new SqlParameter("EventId", objNotificationSetting.EventId),
				new SqlParameter("bmQuoteTypeId", objNotificationSetting.bmQuoteTypeId),
				//new SqlParameter("bmQuoteStatusId", objNotificationSetting.bmQuoteStatusId),
				new SqlParameter("bmDivisionId", objNotificationSetting.bmDivisionId),
				new SqlParameter("EmailSubject", objNotificationSetting.EmailSubject),
				new SqlParameter("EmailBody", objNotificationSetting.EmailBody),
				new SqlParameter("BranchNoList", objNotificationSetting.BranchNoList),
				new SqlParameter("CommodityCategoryIdList", objNotificationSetting.CommodityCategoryIdList),
				new SqlParameter("Comment", objNotificationSetting.Comment),
				new SqlParameter("ViewUserXUID", X.Web.WebContext.Current.User.IdentityEx.UserID),
            });

			var data = SqlHelper.ExecuteDataset(
				 CommandType.StoredProcedure
				, "dbo.Notification_Setting_AddUpdate"
				, SQLParams.ToArray()
				);

			var returnCode = SQLParams[0].Value.AsInt();
			var returnCodeDesc = "";//SQLParams[1].Value.AsString(trim: true, defaultValue: null);
			var result = new NotificationSetting
			{
				ExecutionState = new ExecutionState(returnCode, returnCodeDesc)
			};

			foreach (DataTable dataTable in data.Tables)
			{
				if (dataTable.Rows.Count == 0 || !dataTable.Columns.Contains("RS_Type"))
					continue;

				var rsType = dataTable.Rows[0]["RS_Type"].As<string>("");

				switch (rsType)
				{
					case "Data.Setting":
						var row = dataTable.Rows[0];
						
						result.SettingId = row["SettingId"].As<int>();
							
						result.RecipientTypeId = row["RecipientTypeId"].As<int>();
						result.RecipientTypeName = row["RecipientTypeName"].As<string>();

						result.ShowTextArea = row["ShowTextArea"].As<int>(1) == 2 ? true : false;
						result.ShowUserSearch = row["ShowUserSearch"].As<int>(1) == 2 ? true : false;
							
						result.RecipientXUId = row["RecipientXUId"].As<int>();
						result.RecipientFirstName = row["RecipientFirstName"].As<string>();
						result.RecipientLastName = row["RecipientLastName"].As<string>();
						result.RecipientDistributionList = row["RecipientDistributionList"].As<string>();
							
						result.EmailAddressFieldId = row["EmailAddressFieldId"].As<int>();
						result.EmailAddressFieldName = row["EmailAddressFieldName"].As<string>();
							
						result.EventId = row["EventId"].As<int>();
						result.EventName = row["EventName"].As<string>();
							
						result.bmQuoteTypeId = row["bmQuoteTypeId"].As<int>();
						result.QuoteTypeList = row["QuoteTypeList"].As<string>();
							
						//result.bmQuoteStatusId = row["bmQuoteStatusId"].As<int>();
						//result.QuoteStatusList = row["QuoteStatusList"].As<string>();
							
						result.bmDivisionId = row["bmDivisionId"].As<int>();
						result.DivisionList = row["DivisionList"].As<string>();
							
						result.EmailSubject = row["EmailSubject"].As<string>();
						result.EmailBody = row["EmailBody"].As<string>();
						result.Comment = row["Comment"].As<string>();
							
						result.EnterXUID = row["EnterXUID"].As<int>();
						result.EnterFirstName = row["EnterFirstName"].As<string>();
						result.EnterLastName = row["EnterLastName"].As<string>();
						result.EnterDate = row["EnterDate"].As<DateTime>();
							
						result.ChangeXUId = row["ChangeXUId"].As<int>();
						result.ChangeFirstName = row["ChangeFirstName"].As<string>();
						result.ChangeLastName = row["ChangeLastName"].As<string>();
						result.ChangeDate = row["ChangeDate"].As<DateTime>();
							
						result.BranchNoList = row["BranchNoList"].As<string>();
						result.BranchList = row["BranchList"].As<string>();
							
						result.CommodityCategoryIdList = row["CommodityCategoryIdList"].As<string>();
						result.CommodityCategoryList = row["CommodityCategoryList"].As<string>();
						
						break;
				}
			}

			return result;
		}

		/// <summary>
		/// Delete Setting
		/// </summary>
		/// <param name="SettingId">Deleted Setting Id</param>
		/// <returns>Transaction Status</returns>
		public NotificationSetting NotificationDelete(int SettingId)
		{
			var SQLParams = new List<SqlParameter>();
			SQLParams.AddRange(GetReturnResultSqlParams());
			SQLParams.AddRange(new SqlParameter[] {
				new SqlParameter("SettingId", SettingId),
			});

			var data = SqlHelper.ExecuteDataset(
				 CommandType.StoredProcedure
				, "dbo.Notification_Setting_Delete"
				, SQLParams.ToArray()
				);

			var returnCode = SQLParams[0].Value.AsInt();
			var returnCodeDesc = "";//SQLParams[1].Value.AsString(trim: true, defaultValue: null);
			var result = new NotificationSetting
			{
				ExecutionState = new ExecutionState(returnCode, returnCodeDesc)
			};	

			return result;
		}
		
		private SqlParameter[] GetReturnResultSqlParams()
		{
			return new SqlParameter[] {
                new SqlParameter("ReturnValue", SqlDbType.Int) { Direction = ParameterDirection.ReturnValue },
                //new SqlParameter("ReturnCodeDesc", SqlDbType.NVarChar, 4000) { Direction = ParameterDirection.Output },
            };
		}
		//private SqlParameter[] GetStandardContextSqlParams()
		//{
		//	return new SqlParameter[] {
		//		  new SqlParameter("ViewAppId", AppContext.ApplicationId)
		//		, new SqlParameter("ViewAppTypeId", 0)
		//		, new SqlParameter("LanguageId", AppContext.LanguageId)
		//		, new SqlParameter("ViewUserId", AppContext.User.Viewer.UserID)
		//		, new SqlParameter("ViewBusinessEntityId", AppContext.BusinessEntityId)
		//	};
		//}
    }
}

