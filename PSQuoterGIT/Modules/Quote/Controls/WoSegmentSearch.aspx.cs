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
    protected string Wono;
    protected string SegmentNo;

    protected int SearchType = 1;   //1:add segment to old quote,  2:new Quote,  3:link to new quote, 4:link WO to old quote 
    protected void Page_Load(object sender, EventArgs e)
    
    {
        SearchType = Request.QueryString["SearchType"].AsInt(1);
        Wono = Request.QueryString["WONO"].AsString("").Trim();
        SegmentNo = Request.QueryString["SegmentNo"].AsString("").Trim();

        if (Wono != "" && !Page.IsPostBack)
        {
            txtKeyword.Text = Wono;
            searchWO();
        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        searchWO();
    }
    private void searchWO()
    {
        string lastWONO = "";
        StringBuilder sb = new StringBuilder();

        DataSet ds = DAL.Quote.QuoteGetWoSegmentsBySearch(txtKeyword.Text.Trim());

        

        DataTable dt = ds.Tables[0];
        //if (SearchType == 4)
		if (SearchType == 4 || SearchType == 3)	 //<CODE_TAG_104484>
            dt = ds.Tables[1];

        if (dt.Rows.Count > 0)
        {
            //Header columns
            sb.Append("<table class='segmentSearchResult' >");
            sb.Append("<tr class='reportHeader'>");
            sb.Append("<th></th>");
            sb.Append("<th>WO No</th>"); //<Ticket 41668>
            sb.Append("<th>Customer</th>");
            //if (SearchType == 4)
			if (SearchType == 4  || SearchType == 3) //<CODE_TAG_104484>	
                sb.Append("<th>Quote No</th>");
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
                if (dr["wono"].ToString() != lastWONO)
                {
                    idx2 = idx1;
                    sClass1 = (idx1 % 2 == 0) ? "rd" : "rl";
                    sb.Append("<tr class=\"" + sClass1 + "\">");
                }else
                {
                    idx2++;
                    sClass2 = (idx2 % 2 == 0) ? "rd" : "rl";
                    sb.Append("<tr class=\"" + sClass2 + "\">");
                }
                //quote header part
                if (dr["wono"].ToString()  != lastWONO)
                {
                    idx1++;
                    int quoteRowsPan = getQuoteRowsCount(dt,  dr["wono"].ToString());



                    sb.Append("<td rowspan='" + quoteRowsPan + "' ><input id='rdoWONO" + idx1 + "' name='WONO' ");

                    sb.Append( (dr["wono"].ToString().Trim( ) == Wono) ? "checked" : ""  );
                    sb.Append( " EquipManufCode='" + dr["EquipManufCode"].ToString() + "' " );
                    sb.Append( " Model='" + dr["Model"].ToString() + "' " );
                    sb.Append( " SerialNo='" + dr["SerialNo"].ToString() + "' " );
                    sb.Append( " EquipmentNo='" + dr["EquipmentNo"].ToString() + "' " );
                    sb.Append( " serviceMeter='" + dr["serviceMeter"].ToString() + "' " );
                    sb.Append( " stockNumber='" + dr["stockNumber"].ToString() + "' ");
                    sb.Append( " HourMileIndicator='" + dr["HourMileIndicator"].ToString() + "' " );
                    sb.Append( " SMUDate='" + dr["SMUDate"].ToString() + "' " );
                    sb.Append(" PromiseDate='" + dr["PromiseDate"].ToString() + "' ");
                    sb.Append(" ArriveDate='" + dr["ArriveDate"].ToString() + "' ");
                    sb.Append(" CustomerPONo='" + dr["CustomerPONo"].ToString() + "' ");
                    sb.Append(" ResponseArea='" + dr["ResponseArea"].ToString() + "' ");
                    sb.Append(" Division='" + dr["Division"].ToString() + "' ");
                    sb.Append(" WOContactName='" + dr["WOContactName"].ToString().Trim() + "' ");
                    sb.Append(" ESBYNM='" + dr["ESBYNM"].ToString().Trim() + "' ");
                    sb.Append( " CustomerNo='" + dr["CustomerNo"].ToString() + "' " );
                    sb.Append( " CustomerName='" + Server.HtmlEncode( dr["CustomerName"].ToString() )+ "' " );
                    sb.Append(" HeaderBranchNo='" + dr["HeaderBranchNo"].ToString() + "' ");  //<CODE_TAG_104537>
                    //if (SearchType == 4 && !dr["quoteNo"].ToString().IsNullOrWhiteSpace()  )  sb.Append(" disabled= 'disabled'");
					if ( (SearchType == 4 || SearchType == 3) && !dr["quoteNo"].ToString().IsNullOrWhiteSpace()  )  sb.Append(" disabled= 'disabled'");  //<CODE_TAG_104484>

                    sb.Append(" onclick='rdoWONO_click(this);' value='" + dr["wono"].ToString().Trim() + "'  type='radio'></td>");
                    sb.Append("<td rowspan='" + quoteRowsPan + "' >" + dr["wono"].ToString() + "</td>");
                    sb.Append("<td rowspan='" + quoteRowsPan + "' >" + dr["CustomerNo"].ToString() + "-" + dr["CustomerName"].ToString() + "</td>");
                    //if (SearchType == 4)
					if (SearchType == 4 || SearchType == 3) //<CODE_TAG_104484>
                        sb.Append("<td rowspan='" + quoteRowsPan + "'>" + dr["QuoteNo"] + "</td>");


                }
               
                //segment part
                sb.Append("<td>" + dr["SegmentNo"].ToString() + "</td>");
                sb.Append("<td>" + dr["jobcode"].ToString() + "-" + dr["JobCodeDesc"].ToString() + "</td>");
                sb.Append("<td>" + dr["componentCode"].ToString() + "-" + dr["ComponentCodeDesc"].ToString() + "</td>");
                sb.Append("<td><input  " + ((dr["WONO"].ToString().Trim() == Wono) ? "style='display:'" : "style='display:none'") + " type='checkbox' " + ((dr["WONO"].ToString().Trim() == Wono && dr["SegmentNo"].ToString().Trim() == SegmentNo) ? "checked" : "") + " wono='" + dr["wono"].ToString().Trim() + "-" + dr["SegmentNo"].ToString().Trim() + "' > </td>");
                 sb.Append("</tr>" );
                 lastWONO = dr["wono"].ToString();
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

    private int getQuoteRowsCount(DataTable dt,string wono)
    {
        int rt = 0;

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["wono"].ToString()  == wono) rt++; 
        }
        return rt;
    }
   

}
