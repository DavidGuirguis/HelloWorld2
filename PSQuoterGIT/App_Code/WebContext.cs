using System;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using X.Web;

public class WebContext : X.Web.WebContext<WebContext, UI.Abstracts.PageBase, UI.Abstracts.MasterPageBase, WebPrincipal> {
    public WebContext(HttpApplication application, HttpContext context)
        : base(application, context) {
    }
}