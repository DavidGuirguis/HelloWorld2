using System;
using System.Drawing;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace Modules {
	/// <summary>
	/// Summary description for LoginErr.
	/// </summary>
	public partial class ErrorDisplay: UI.Abstracts.Pages.Plain
    {
        protected void Page_Load(object sender, System.EventArgs e) {
			string statusCode = WebContext.ErrorHandler.Type.ToString();
			string ErrDescription	= null;
			StringBuilder sbHtml	= new StringBuilder();

			switch(WebContext.ErrorHandler.Type) 
			{
				case X.Error.ErrorType.Session:
                    ErrDescription = string.Format(Resource.GetString("rkMSG_SessionError"), WebContext.ErrorHandler.LastErrorMessage) + "(" + WebContext.Session.StatusCode.ToString() + ")";

					break;
			}

			ErrDescription			= string.Format(ErrDescription, WebContext.ErrorHandler.LastErrorMessage);

			sbHtml.AppendFormat(@"<div class=""t16 tSb"" style=""margin-top: 10px; color: red;"">"+ string.Format(Resource.GetString("rkMSG_ThereHasBeenAProblemWith"), WebContext.Application.ApplicationName) +"</div><br><span class=t12>"+Resource.GetString("rkMSG_TheFollowingErrorWasReported")+"<br><span class=t12ib>{0}</span><br><br>", ErrDescription);

            sbHtml.Append(@"<BR><BR><span class=""t14 tSb"">" + Resource.GetString("rkMSG_TakeMeTo") + "</span><br>");
            sbHtml.Append(@"<span class=tb><a href=""javascript:history.back(1);"">" + Resource.GetString("rkMSG_PreviousPage") + "</a></span><br>");

			lblMsg.Text	= sbHtml.ToString();
		}
	}
}
