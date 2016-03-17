using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using DTO;
using CATPAI;
using System.Data;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;

public partial class quoteClose : UI.Abstracts.Pages.Plain
{
    protected int quoteId = 0;
    protected int quoteCloseStatusId = 0;
    protected string quoteCloseStatusDesc;
    protected int quoteRevision;
	protected int autoCreateTicket = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        quoteId = Convert.ToInt32(Request.QueryString["QuoteId"]);
        quoteCloseStatusId = Convert.ToInt32(Request.QueryString["quoteCloseStatusId"]);
        quoteCloseStatusDesc = Request.QueryString["quoteCloseStatusDesc"];
        quoteRevision = Convert.ToInt32(Request.QueryString["Revision"]);
		autoCreateTicket = (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ServiceLink") && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.AutoCreateTicket"))? 2:0 ;

        if(!IsPostBack)
        {
            var ds = DAL.Quote.Quote_Get_RevisionList(quoteId);

            rdlistQuoteRevisionList.DataSource = ds;
            rdlistQuoteRevisionList.DataValueField = "Revision";
            rdlistQuoteRevisionList.DataTextField = "RevisionDisplayName";
            rdlistQuoteRevisionList.SelectedValue = quoteRevision.ToString();
			if (autoCreateTicket == 2 && quoteCloseStatusId == 4)
				chkCreateTicket.Visible = true;
			else
				chkCreateTicket.Visible = false;

            rdlistQuoteRevisionList.DataBind();
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        var deleteRevision = rdlistQuoteRevisionList.SelectedValue.As<int>();

        DAL.Quote.QuoteStatusChange(quoteId, deleteRevision, quoteCloseStatusId, (chkCreateTicket.Checked)?2:0 );
        hidRefreshParent.Value = "1";
    }
}


