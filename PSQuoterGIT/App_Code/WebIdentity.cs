using System;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using X.Web;

public class WebIdentity : X.Web.Security.WebIdentity {
    #region Uncomment for populating custom properties
    //protected override void Initialize(DataSet startUpAppData, DataSet rqAppData, X.Web.Security.WebIdentityData identityData) {
    //    base.Initialize(startUpAppData, rqAppData, identityData);

    //    //Your code goes here
    //}
    #endregion
}