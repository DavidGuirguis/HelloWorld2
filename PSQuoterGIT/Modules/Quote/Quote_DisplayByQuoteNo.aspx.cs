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

public partial class quoteDisplayByQuoteNo : UI.Abstracts.Pages.ReportViewPage  
{

    protected void Page_Load(object sender, EventArgs e)
    {
        string quoteNo = Request.QueryString["QuoteNo"].AsString("").Trim();
        if (quoteNo != "")
        {
            DataSet ds = DAL.Quote.QuoteGetIdByQuoteNo(quoteNo);
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                int quoteId = dr["quoteId"].AsInt(0);
                int revision = dr["revision"].AsInt(0);
                if (quoteId > 0 && revision > 0)
                {
                    Response.Redirect("quote_Summary.aspx?QuoteId=" + quoteId  + "&Revision="  + revision );
                }
            }

        }

    }

}

