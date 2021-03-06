using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace UI.Abstracts.MasterPages
{
    /// <summary>
    /// Summary description for Popup
    /// </summary>
    public abstract class QuoteDetailViewLayout : ReportViewLayout {
        protected override void InitializePage() {
            base.InitializePage();

            Layout = "~/library/masterPages/ReportView.cshtml";
        }
    }
}