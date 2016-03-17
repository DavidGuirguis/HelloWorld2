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
    public abstract class WebFormView : Plain
    {
        public override Control FindControlManual(string id)
        {
            Control ctrl = FindControlRecursive(null, id, null);

            if (id == "cntMP" || ctrl == null)
            {
                ctrl = this.Master.Master.FindControl("cntMP").FindControl("cntMP").FindControl(id);
            }
                
            return ctrl;
        }
    }
}