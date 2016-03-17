using System;
using System.Drawing;
using System.Reflection;
using System.Security;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using X.Configuration;
using X;
using ExceptionHandling;

namespace Modules
{
    /// <summary>
    /// Summary description for customErrors.
    /// </summary>
    public partial class customErrors : UI.Abstracts.Pages.Error
    {

        private void Page_Load(object sender, EventArgs e)
        {
            Page.DataBind();
            phrHomePage.Visible = Request.IsAuthenticated;

            string friendlyMessage = Resource.GetString("rkMSG_NotifyProgrammer");

            // get last error
            Exception lastExcep = Server.GetLastError();

            // can't get last error
            if (lastExcep == null)
            {
                return;
            }

            // get error path
            string aspxErrorPath = null;

            aspxErrorPath = Request.Path;
            lnkAspErrorPath.Text = aspxErrorPath.Substring(ApplicationPath.Length);
            lnkAspErrorPath.NavigateUrl = Request.RawUrl;

            ExceptionHandler.Log(ref friendlyMessage, lastExcep);

            if (friendlyMessage.Length != 0)
            {
                DisplayMessage(msg, friendlyMessage, Color.Black);
            }
        }
    }
}
