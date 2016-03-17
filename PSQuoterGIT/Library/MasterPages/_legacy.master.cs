using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Template : UI.Abstracts.MasterPages.Plain {
    //protected void Page_Load(object sender, EventArgs e) {

    //}

    public override Control FindControlManual(string id) {
        Control ctrl = FindControlRecursive(null, id, null);

        if (id == "cntMP" || ctrl == null) {
            ctrl = this.Master.FindControl("cntMP").FindControl(id);
        }

        return ctrl;
    }
}