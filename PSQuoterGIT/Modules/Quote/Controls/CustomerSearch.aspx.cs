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
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string lastCustomerNo = "";
        StringBuilder sb = new StringBuilder();
        DataSet ds = DAL.Quote.QuoteGetCustomersBySearch(lstSearchFields.SelectedValue, lstOp.SelectedValue, txtKeyword.Text.Trim());
        DataTable dt = ds.Tables[0]; 
        
        if (dt.Rows.Count > 0)
        {
            //Header columns
            sb.Append("<table width='100%'>");
            sb.Append("<tr class='reportHeader'>");
            sb.Append("<th style='width:30%' >Customer No</th>");
            sb.Append("<th style='width:65%'>Customer Name</th>");
            sb.Append("<th style='width:5%'></th>");

            sb.Append("</tr>");

            var idx1 = 0;
            var idx2 = 0;
            var sClass1 = "";
            var sClass2 = "";
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["customerNumber"].ToString()  != lastCustomerNo)
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

                //sb.Append("<td><input type='radio' name='customer' customerNo='" + dr["customerNumber"].ToString().Trim() + "' customerName='" + dr["customerName"].ToString().Trim().HtmlEncode( ) + "'  > </td>");
                sb.Append("<td>" + dr["customerNumber"].ToString() + "</td>");
                sb.Append("<td>" + dr["customerName"].ToString() + "</td>");
                sb.Append("<td><a href='javascript:btnAdd_click(\"" + dr["customerNumber"].ToString() + "\",\"" + dr["customerName"].ToString().Trim().HtmlEncode() + "\")'> Add </a> </td>");
                sb.Append("</tr>");
                lastCustomerNo = dr["customerNumber"].ToString() ;
                idx1++;
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
}
