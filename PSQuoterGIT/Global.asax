<%@ Application Language="C#" Inherits="X.Web.WebClientApplication" %>
<%@ Import Namespace="X.Configuration" %>
<%@ Import Namespace="X.Web.UI" %>
<%@ Import Namespace="X.Web" %>
<%@ Import Namespace="X" %>
<%@ Import Namespace="System.Web.Mvc" %>
<%@ Import Namespace="System.Web.Routing" %>
<script runat="server">
    protected override void PageBeginRequest() {
        HttpContext.Current.Items["__reqStartedAt"] = DateTime.Now;
    }

    protected override void PagePostAuthenticateRequest() {
        if (WebContext.Current.SessionStateEnabled && WebContext.Current.User.IdentityEx.IsAuthenticated)
            AppContext.Current.InitializeRequest();
    }
    
    protected override void PageEndRequest() {
        if (!WebContext.Current.SkipAuthorization
            && !WebContext.Current.Request.IsAjax // .AJAXRequest //custom conditions can be added to determine whether current request is AJAX request via Web.ApplicationStateManager::CheckIfAJAXRequest method (App_Code\X\Web\ApplicationState.cs)
            && (EnvironmentSettings.Current.IsDevelopment || WebContext.Current.User.IsDebugger)
        ) {
            object reqStartedAtCache = HttpContext.Current.Items["__reqStartedAt"];

            if (reqStartedAtCache == null) return;

            DateTime reqStartedAt = (DateTime) reqStartedAtCache;
            TimeSpan elapsedTime = DateTime.Now.Subtract(reqStartedAt);

            var curPage = WebContext.Current.Page;
            if (curPage == null || curPage.HasLayout == false) return;

            Response.Write("<" + "script language='javascript'>try{document.getElementById('spnElpsd').innerHTML = '" + elapsedTime.TotalSeconds + "';}catch(x){}</" + "script>");
        }
    }

    protected override void HandleError(Exception exception, out bool errorHandled) {
        if (!WebContext.Current.User.IsDebugger && !EnvironmentSettings.Current.IsDevelopment) {
            errorHandled = true;
            Response.Clear();
            Server.Transfer("~/modules/errors/customErrors.aspx", true);
        } 
        else if (!EnvironmentSettings.Current.IsDevelopment) {
            ExceptionHandling.ExceptionHandler.Log("Exception", exception, clearError: false);
            errorHandled = true;
            return;
        }
        
        errorHandled = false;
    }

    protected override void RenderLayoutSection(IPage page, LayoutSection section, bool sectionDefined = false, System.IO.TextWriter writer = null) {
        base.RenderLayoutSection(page, section, sectionDefined, writer);

        LayoutHelper.RenderSection(page: page, section: section, sectionDefined: sectionDefined, writer: writer);
    }

    private void XSession_Start(object sender, X.Web.ApplicationStateModule.SessionStartEventArgs e) {
        AppContext.Current.Initialize(e.AppData);
    }
</script>