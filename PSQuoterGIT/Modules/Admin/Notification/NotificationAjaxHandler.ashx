<%@ WebHandler Language="C#" Class="NotificationAjaxHandler" %>

using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Entities;
using X.Extensions;
using CATPAI;
using DTO;
using System.Text;
using Helpers;
using System.Data;
using Entities.Notification;

public class NotificationAjaxHandler : IHttpHandler
{
	/// <summary>
	/// Called from ManageNotifications to manage the notification's settings
	/// </summary>
	/// <param name="context"></param>
	/// <Query stings>
	/// Action Name: Add/Update/Delete
	/// SettingId: the Id of the Recipient
	/// 
	/// </Query stings>
    public void ProcessRequest(HttpContext context)
    {
		context.Response.ContentType = "application/json; charset=utf-8";
		
		//ActionName
		//RecipientXUID
		//RecipientTypeId
		//EventId
		//Comment
		//bmQuoteTypeId
		//bmQuoteStatusId
		//bmDivisionId
		//BranchNoList
		//CommodityCategoryList
		//EmailAddressFieldId
		//EmailSubject
		//EmailBody
		//ViewUserXUID

		string ActionName = context.Request.QueryString["ActionName"].As<string>("").ToUpper();
		if (ActionName.ToLower() == "add" || ActionName.ToLower() == "update")
		{
			int SettingId = context.Request.QueryString["SettingId"].As<int>();
			int RecipientXUID = context.Request.QueryString["RecipientXUID"].As<int>();
			int RecipientTypeId = context.Request.QueryString["RecipientTypeId"].As<int>();
			string RecipientDistributionList = context.Request.QueryString["RecipientDistributionList"].As<string>("");
			int EventId = context.Request.QueryString["EventId"].As<int>();
			string Comment = context.Request.QueryString["Comment"].As<string>();
			int bmQuoteTypeId = context.Request.QueryString["bmQuoteTypeId"].As<int>();
			//int bmQuoteStatusId = context.Request.QueryString["bmQuoteStatusId"].As<int>();
			int bmDivisionId = context.Request.QueryString["bmDivisionId"].As<int>();
			string BranchNoList = context.Request.QueryString["BranchNoList"].As<string>();
			string CommodityCategoryIdList = context.Request.QueryString["CommodityCategoryIdList"].As<string>();
			int EmailAddressFieldId = context.Request.QueryString["EmailAddressFieldId"].As<int>();
			string EmailSubject = context.Request.QueryString["EmailSubject"].As<string>();
			string EmailBody = context.Request.QueryString["EmailBody"].As<string>();
			
			NotificationHandler objNotificationHandler = new NotificationHandler();
			NotificationSetting objNotificationRecipient = new NotificationSetting
			{
				SettingId = SettingId,
				RecipientTypeId = RecipientTypeId,
				RecipientXUId = RecipientXUID,
				RecipientDistributionList = RecipientDistributionList,
				EmailAddressFieldId = EmailAddressFieldId,
				EventId = EventId,
				bmQuoteTypeId = bmQuoteTypeId,
				//bmQuoteStatusId = bmQuoteStatusId,
				bmDivisionId = bmDivisionId,
				EmailSubject = EmailSubject,
				EmailBody = EmailBody,
				Comment = Comment,
				BranchNoList = BranchNoList,
				CommodityCategoryIdList = CommodityCategoryIdList,
			};

			var UpdateResult = objNotificationHandler.NotificationAddUpdate(objNotificationRecipient);
			context.Response.Write(ToJSON(UpdateResult));
		}
		else if (ActionName.ToLower() == "delete")
		{
			int SettingId = context.Request.QueryString["SettingId"].As<int>();
			NotificationHandler objNotificationHandler = new NotificationHandler();
			var UpdateResult = objNotificationHandler.NotificationDelete(SettingId);
			context.Response.Write(ToJSON(UpdateResult));
		}
    }


	private string ToJSON(NotificationSetting objNotificationRecipient)
	{
		//System.Web.Script.Serialization.JavaScriptSerializer javaScriptSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
		//string serNotification = javaScriptSerializer.Serialize(UpdateResult);
		//context.Response.Write(serNotification);
		
		
		//Class Parameters
		
		//SettingId
		//RecipientTypeId
		//RecipientTypeName
		//RecipientXUId
		//RecipientFullName
		//RecipientDistributionList
		//EmailAddressFieldId
		//EmailAddressFieldName
		//EventId
		//EventName
		//bmQuoteTypeId
		//QuoteTypeList
		//bmQuoteStatusId
		//QuoteStatusList
		//bmDivisionId
		//DivisionList
		//EmailSubject
		//EmailBody
		//Comment
		//EnterXUID
		//EnterFullName
		//EnterDate
		//ChangeXUId
		//ChangeFullName
		//ChangeDate
		//BranchNoList
		//BranchList
		//CommodityCategoryIdList
		//CommodityCategoryList
		
		StringBuilder json = new StringBuilder();

		json.Append("{");

		string ExecutionState = @"""executionState"":{" + String.Format("\"Status\":{0},\"Description\":\"{1}\",\"Success\":{2}", objNotificationRecipient.ExecutionState.Status.As<string>("0"), objNotificationRecipient.ExecutionState.Description.As<string>(""), objNotificationRecipient.ExecutionState.Success.As<string>("").ToLower()) + "}";
		json.Append(ExecutionState);
		json.AppendFormat(",\"SettingId\":{0}", objNotificationRecipient.SettingId);
		json.AppendFormat(",\"RecipientTypeId\":{0}", objNotificationRecipient.RecipientTypeId);
		json.AppendFormat(",\"RecipientTypeName\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.RecipientTypeName));
		json.AppendFormat(",\"ShowTextArea\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.ShowTextArea.ToString()));
		json.AppendFormat(",\"ShowUserSearch\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.ShowUserSearch.ToString()));
		json.AppendFormat(",\"RecipientXUId\":{0}", objNotificationRecipient.RecipientXUId);
		json.AppendFormat(",\"RecipientFullName\":\"{0}\"", StringUtils.JSONEscape(Helpers.Util.FormatFullName(objNotificationRecipient.RecipientFirstName, objNotificationRecipient.RecipientLastName)));
		json.AppendFormat(",\"RecipientDistributionList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.RecipientDistributionList));
		json.AppendFormat(",\"EmailAddressFieldId\":{0}", objNotificationRecipient.EmailAddressFieldId);
		json.AppendFormat(",\"EmailAddressFieldName\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.EmailAddressFieldName));
		json.AppendFormat(",\"EventId\":{0}", objNotificationRecipient.EventId);
		json.AppendFormat(",\"EventName\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.EventName));
		json.AppendFormat(",\"bmQuoteTypeId\":{0}", objNotificationRecipient.bmQuoteTypeId);
		json.AppendFormat(",\"QuoteTypeList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.QuoteTypeList == null ? null : objNotificationRecipient.QuoteTypeList.Replace("}{", "; ").Replace("}", "").Replace("{", "")));
		//json.AppendFormat(",\"bmQuoteStatusId\":{0}", objNotificationRecipient.bmQuoteStatusId);
		//json.AppendFormat(",\"QuoteStatusList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.QuoteStatusList == null ? null : objNotificationRecipient.QuoteStatusList.Replace("}{", "; ").Replace("}", "").Replace("{", "")));
		json.AppendFormat(",\"bmDivisionId\":{0}", objNotificationRecipient.bmDivisionId);
		json.AppendFormat(",\"DivisionList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.DivisionList == null ? "" : objNotificationRecipient.DivisionList.Replace("}{", "; ").Replace("}", "").Replace("{", "")));
		json.AppendFormat(",\"EmailSubject\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.EmailSubject));
		json.AppendFormat(",\"EmailBody\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.EmailBody));
		json.AppendFormat(",\"Comment\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.Comment));
		json.AppendFormat(",\"EnterXUID\":{0}", objNotificationRecipient.EnterXUID);
		json.AppendFormat(",\"EnterFullName\":\"{0}\"", StringUtils.JSONEscape(Helpers.Util.FormatFullName(objNotificationRecipient.EnterFirstName, objNotificationRecipient.EnterLastName)));
		json.AppendFormat(",\"EnterDate\":\"{0}\"", Helpers.DateTimeHelper.FormatDate(objNotificationRecipient.EnterDate, false, null));
		json.AppendFormat(",\"ChangeXUId\":{0}", objNotificationRecipient.ChangeXUId);
		json.AppendFormat(",\"ChangeFullName\":\"{0}\"", StringUtils.JSONEscape(Helpers.Util.FormatFullName(objNotificationRecipient.ChangeFirstName, objNotificationRecipient.ChangeLastName)));
		json.AppendFormat(",\"ChangeDate\":\"{0}\"", Helpers.DateTimeHelper.FormatDate(objNotificationRecipient.ChangeDate, false, null));
		json.AppendFormat(",\"BranchNoList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.BranchNoList));
		json.AppendFormat(",\"BranchList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.BranchList == null ? "" : objNotificationRecipient.BranchList.Replace("}{", "; ").Replace("}", "").Replace("{", "")));
		json.AppendFormat(",\"CommodityCategoryIdList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.CommodityCategoryIdList));
		json.AppendFormat(",\"CommodityCategoryList\":\"{0}\"", StringUtils.JSONEscape(objNotificationRecipient.CommodityCategoryList == null ? "" : objNotificationRecipient.CommodityCategoryList.Replace("}{", "; ").Replace("}", "").Replace("{", "")));

		json.Append("}");

		return json.ToString();
	}
	public bool IsReusable
	{
		get
		{
			return false;
		}
	}
}
