using AppContext = Canam.AppContext;
using System;
using System.Data;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using X.Web;

/// <summary>
/// Summary description for SessionState
/// </summary>

public class ApplicationStateManager : X.Web.ApplicationStateManager {
    protected override X.Web.WebContext CreateWebContext(HttpApplication application, HttpContext context) {
        return new WebContext(application, context);
    }

    // Application Start
    protected override void ApplicationStart(System.Collections.Generic.IDictionary<string, System.Collections.Generic.IEnumerable<DataRow>> appStartUpData) {
        AppContext.OneTimeInit(appStartUpData);

        // Mvc
        AreaRegistration.RegisterAllAreas();

        RegisterGlobalFilters(GlobalFilters.Filters);
        RegisterRoutes(RouteTable.Routes);
    }

    private void RegisterGlobalFilters(GlobalFilterCollection filters) {
        filters.Add(new HandleErrorAttribute());
    }

    private void RegisterRoutes(RouteCollection routes) {
        routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
    }
    //- Application Start

    /*
        * Uncomment for doing extra logic when initializing request (e.g. overriding application info by URL)
        * 
    protected override void InitializeRequest(HttpApplication application, HttpContext context)
    {
        //Mandatory  
        base.InitializeRequest(application, context);

        SetApplicationInfo(<new appid>, <new app name>);
    }
    */

    /* 
        * Uncomment for specifying extra params to Custom Session/Login check stored proc 
        * 
	protected override string GetValidationExtraParams(HttpContext context, WebContext sessionContext) {
		return null;
	}

	protected override string GetAuthenticationExtraParams(HttpContext context) {
		return null;
	}
    */

    /*
        * Uncomment for add new logic to determine whether current request is a AJAX request, 
        * the value can be retrieved via 'WebContext.Current.Request.AJAXRequest' property
        * 
    protected override bool CheckIfAJAXRequest(HttpContext context)
    {
        return base.CheckIfAJAXRequest(context);
    }
    */ 
}

