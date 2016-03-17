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
using System.Text;

public partial class quoteSegmentSearch : UI.Abstracts.Pages.Plain
{
   protected  string QuoteNo;
   protected  string SegmentNo;
    protected void Page_Load(object sender, EventArgs e)
    {
        QuoteNo = Request.QueryString["QuoteNo"].AsString("").Trim();
        SegmentNo = Request.QueryString["SegmentNo"].AsString("").Trim();

        if (!Page.IsPostBack)
        {
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))
                lstSearchFields.Items.Add( new ListItem("Quote Description","QuoteDescription" ) );


            if (QuoteNo != "")
            {
                txtKeyword.Text = QuoteNo;
                searchQuote();
            }
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        searchQuote();
    }
    protected void searchQuote()
    {
        int lastQuoteId = 0, lastRevision = 0;

        StringBuilder sb = new StringBuilder();

        DataSet ds = DAL.Quote.QuoteGetSegmentsBySearch(lstSearchFields.SelectedValue, lstOp.SelectedValue, txtKeyword.Text.Trim());

        DataTable dt = ds.Tables[0]; 
        

        if (dt.Rows.Count > 0)
        {
            //Header columns
            sb.Append("<table class='segmentSearchResult' >");
            sb.Append("<tr class='reportHeader'>");
            sb.Append("<th>Quote No</th>");
            sb.Append("<th>Quote Description</th>"); //<CODE_TAG_103363>
            sb.Append("<th>Customer</th>");
            sb.Append("<th>Rev</th>");
            sb.Append("<th>Seg No</th>");
            sb.Append("<th>Job Code</th>");
            sb.Append("<th>Component Code</th>");
            sb.Append("<th></th>");
            sb.Append("</tr>");

            var idx1 = 0;
            var idx2 = 0;
            var sClass1 = "";
            var sClass2 = "";
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["quoteId"].AsInt() != lastQuoteId)
                {
                    idx2 = idx1;
                    sClass1 = (idx1 % 2 == 0) ? "rd" : "rl";
                    sb.Append("<tr class=\"" + sClass1 + "\">");
                }
                else
                {
                    idx2++;
                    sClass2 = (idx2 % 2 == 0) ? "rd" : "rl";
                    sb.Append("<tr class=\"" + sClass2 + "\">");
                }
                //quote header part
                if (dr["quoteId"].AsInt() != lastQuoteId)
                {
                    idx1++;
                    int quoteRowsPan = getQuoteRowsCount(dt,  dr["quoteId"].AsInt());
                    sb.Append("<td rowspan='" + quoteRowsPan + "' >" + dr["QuoteNo"].ToString() + "</td>");
                    sb.Append("<td rowspan='" + quoteRowsPan + "' >" + dr["QuoteDescription"].ToString() + "</td>");//<CODE_TAG_103363>
                    sb.Append("<td rowspan='" + quoteRowsPan + "' >" + dr["CustomerNo"].ToString() + "-" + dr["CustomerName"].ToString() + "</td>");
                }
                //Revision part
                if (dr["quoteId"].AsInt() != lastQuoteId || dr["revision"].AsInt() != lastRevision)
                {
                    int revisionRowsPan = getRevisionRowsCount(dt, dr["quoteId"].AsInt(), dr["Revision"].AsInt());
                    sb.Append("<td rowspan='" + revisionRowsPan + "' >" + dr["Revision"].ToString() + "</td>");
                }
                //segment part
                sb.Append("<td>" + dr["SegmentNo"].ToString() + "</td>");
                sb.Append("<td>" + dr["jobcode"].ToString() + "-" + dr["JobCodeDesc"].ToString() + "</td>");
                sb.Append("<td>" + dr["componentCode"].ToString() + "-" + dr["ComponentCodeDesc"].ToString() + "</td>");
                sb.Append("<td><input type='checkbox' "  + ( (dr["QuoteNo"].ToString().Trim( )==  QuoteNo && dr["SegmentNo"].ToString().Trim( ) == SegmentNo ) ? "checked": "") + " quoteSegmentId='" + dr["QuoteSegmentId"].ToString().Trim() + "' > </td>");

                 sb.Append("</tr>" );
                 lastQuoteId = dr["quoteId"].AsInt();
                 lastRevision = dr["Revision"].AsInt();
            }

            //footer
            sb.Append("</table>");
        }
        else
        {
            sb.Append("No Matches Found.");

        }


        litResult.Text = sb.ToString();


    }

    private int getQuoteRowsCount(DataTable dt, int QuoteId)
    {
        int rt = 0;

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["quoteId"].AsInt() == QuoteId) rt++; 
        }
        return rt;
    }

    private int getRevisionRowsCount(DataTable dt, int QuoteId, int Revision )
    {
        int rt = 0;

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["quoteId"].AsInt() == QuoteId && dr["revision"].AsInt( ) == Revision ) rt++;
        }
        return rt;

    }
    

}

