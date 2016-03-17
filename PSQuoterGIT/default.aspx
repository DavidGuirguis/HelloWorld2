<%@ Page language="c#" Inherits="UI.Abstracts.PageBase"%>
<script runat="server">
    protected override void Construct() {
        base.Construct();
        HasLayout = false;
    }

    void Page_Load(object sender, System.EventArgs e) {
	    // redirect to home page
	    if(X.Web.WebContext.Current.Application.DefaultUrl != null)
		    Response.Redirect(X.Web.WebContext.Current.Application.DefaultUrl );
    }
</script>