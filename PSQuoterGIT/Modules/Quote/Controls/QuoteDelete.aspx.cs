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

public partial class quoteDelete : UI.Abstracts.Pages.Plain
{
    int quoteId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        quoteId = Convert.ToInt32(Request.QueryString["QuoteId"]);
        hidParentRedirect.Value = ""; 
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        var deleteType = rdlistQuoteDeleteOptions.SelectedValue.As<int>();

        DAL.Quote.DeleteQuote(quoteId, deleteType);

        hidParentRedirect.Value = "modules/Quote/Quote_list.aspx"; // X.Web.WebContext.Current.Application.DefaultUrl;
        
    }
}

