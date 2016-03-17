using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entities.Notification;

public partial class ManageNotifications : UI.Abstracts.Pages.ReportViewPage
{
	public Notification objNotification;
    protected void Page_Load(object sender, EventArgs e)
    {
		NotificationHandler objNotificationHandler = new NotificationHandler();
		objNotification = objNotificationHandler.GetNotification();
		ModuleTitle = "Manage Notifications";
    }
}