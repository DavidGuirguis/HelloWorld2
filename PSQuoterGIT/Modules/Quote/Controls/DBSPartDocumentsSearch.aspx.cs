using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Modules_Quote_Controls_DBSPartDocumentsSearch : UI.Abstracts.Pages.Plain//System.Web.UI.Page
{
    //<CODE_TAG_103600>
    //protected string QuoteId = "";
    //protected string Revision = "";
    protected string Operation = "";
    //protected string BranchNo = "";
    //</CODE_TAG_103600>
    protected void Page_Load(object sender, EventArgs e)
    {
        //<CODE_TAG_103600>
        //QuoteId = Request.QueryString["QuoteId"];
        //Revision = Request.QueryString["Revision"];
        Operation = Request.QueryString["operation"];
        //BranchNo = Request.QueryString["BranchNo"];
        //</CODE_TAG_103600>
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        searchDBSPartDocuments();
    }
    private void searchDBSPartDocuments()
    {
        //string lastDocumentNUmber = "";

        StringBuilder sb = new StringBuilder();
        DataSet ds = DAL.Quote.QuoteGetDBSPartDocumentsBySearch(txtKeyword.Text.Trim());

        if (ds!=null && ds.Tables.Count>0)
        {
            //Header columns
            sb.Append("<table class='segmentSearchResult' >");
            //sb.Append("<table class='documentSearchResult' >");
            sb.Append("<tr class='reportHeader'>");
            sb.Append("<th></th>");
            sb.Append("<th>DocNo</th>");
            sb.Append("<th>Store</th>");
            sb.Append("<th>CustomerNO</th>");
            sb.Append("<th>CustomerName</th>");
            sb.Append("<th>CustomerPONo</th>");
            sb.Append("<th>CustomerEquipNo</th>");
            //sb.Append("<th>PaidAmt</th>");//<CODE_TAG_103868>
            sb.Append("<th>SalesRep</th>");
            //<CODE_TAG_103868>
            //sb.Append("<th>TransacrionCode</th>");
            //sb.Append("<th>DeliveryLocation</th>");
            ////sb.Append("<th>TerminalName</th>");
            //sb.Append("<th></th>");
            // </CODE_TAG_103868>
            sb.Append("</tr>");

            //content
            var idx1 = 0;
            var idx2 = 0;
            var sClass1 = "";
            var sClass2 = "";
            DataTable dt = ds.Tables[0];
            foreach (DataRow dr in dt.Rows)
            {
                //if (dr["DocumentNumber"].ToString() != lastDocumentNUmber)
                //{
                //    idx2 = idx1;
                //    sClass1 = (idx1 % 2 == 0) ? "rd" : "rl";
                //    sb.Append("<tr class=\"" + sClass1 + "\">");
                //}
                //else
                //{
                //    idx2++;
                //    sClass2 = (idx2 % 2 == 0) ? "rd" : "rl";
                //    sb.Append("<tr class=\"" + sClass2 + "\">");
                //}

                //if (dr["DocumentNumber"].ToString() != lastDocumentNUmber)
                //{
                //    idx1++;
                //    int quoteRowsPan = getQuoteRowsCount(dt, dr["DocumentNumber"].ToString());

                //    sb.Append("<td rowspan='" + quoteRowsPan + "' ><input id='rdoDocumentNumber" + idx1 + "' name='DocumentNumber' ");

                //}
                sb.Append("<tr class=\"" + sClass1 + "\">");
                //sb.Append("<td></td>");
                //sb.Append("<td><input type='Checkbox' DocumentNumber='" + (dr["DocumentNumber"] != DBNull.Value ? dr["DocumentNumber"].ToString().Trim() : "") + "'  ");
                //<CODE_TAG_103600>
                if (Operation == "ImportDBSDocumentParts")
                {
                    string docNo = dr["DocumentNumber"] != DBNull.Value ? dr["DocumentNumber"].ToString().Trim() : "";
                    //sb.Append("<td><input type='Checkbox'  singleChoiceInd='2' onclick='cbxSingleChoice();'  DocumentNumber='" + (dr["DocumentNumber"] != DBNull.Value ? dr["DocumentNumber"].ToString().Trim() : "") + "'  ");
                    sb.Append("<td><input type='Checkbox'  singleChoiceInd='2' onclick='cbxSingleChoice(\"" + docNo + "\");'  DocumentNumber='" + (docNo) + "'  ");
                }
                else
                    sb.Append("<td><input type='Checkbox'  DocumentNumber='" + (dr["DocumentNumber"] != DBNull.Value ? dr["DocumentNumber"].ToString().Trim() : "") + "'  "); 
                //</CODE_TAG_103600>
                sb.Append("Store='" + (dr["Store"] != DBNull.Value ? dr["Store"].ToString().Trim() : "") + "' ");
                sb.Append("CustomerNumber='" + (dr["CustomerNumber"] != DBNull.Value ? dr["CustomerNumber"].ToString().Trim() : "") + "' ");
                sb.Append("   /> </td>");
                sb.Append("<td>" + dr["DocumentNumber"].ToString() + "</td>");
                sb.Append("<td>" + dr["Store"].ToString() + "</td>");
                sb.Append("<td>" + dr["CustomerNumber"].ToString() + "</td>");
                sb.Append("<td>" + dr["CustomerName"].ToString() + "</td>");
                sb.Append("<td>" + dr["CustomerPONumber"].ToString() + "</td>");
                sb.Append("<td>" + dr["CustomerEquipmentNumber"].ToString() + "</td>");
                //sb.Append("<td>" + dr["PaidAmount"].ToString() + "</td>");  //<CODE_TAG_103868>
                sb.Append("<td>" + dr["SalesRep"].ToString() + "</td>");
                //<CODE_TAG_103868>
                //sb.Append("<td>" + dr["TransactionCode"].ToString() + "</td>");
                //sb.Append("<td>" + dr["DeliveryLocation"].ToString() + "</td>");
                //</CODE_TAG_103868>
                //sb.Append("<td>" + dr["TerminalName"].ToString() + "</td>");
                //sb.Append("<td><input type='Checkbox' DocumentNumber='" + dr["DocumentNumber"].ToString().Trim() + "' checked  /> </td>");

                /*sb.Append("<td><input type='Checkbox' DocumentNumber='" + (dr["DocumentNumber"] != DBNull.Value ?  dr["DocumentNumber"].ToString().Trim() : "" ) + "'  ");
                sb.Append("Store='" + ( dr["Store"] != DBNull.Value ? dr["Store"].ToString().Trim() : "") + "' ");
                sb.Append("CustomerNumber='" + (dr["CustomerNumber"] != DBNull.Value ? dr["CustomerNumber"].ToString().Trim() : "") + "' ");
                sb.Append(     "   /> </td>");
                */
                //sb.Append("<td></td>");//<CODE_TAG_103868>
                sb.Append("</tr>");
                //lastDocumentNUmber = dr["DocumentNumber"].ToString();
                
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

    private int getQuoteRowsCount(DataTable dt, string DocumentNumber)
    {
        int rt = 0;

        foreach (DataRow dr in dt.Rows)
        {
            if (dr["DocumentNumber"].ToString() == DocumentNumber) rt++;
        }
        return rt;
    }
 
}