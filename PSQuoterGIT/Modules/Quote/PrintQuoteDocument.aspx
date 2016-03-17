<%@ Page Language="c#" Inherits="UI.Abstracts.Pages.Popup" MasterPageFile="~/library/masterPages/_base.master" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Microsoft.Reporting.WebForms" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="X.Data" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" runat="Server">
       
    <!--#include file="../../../DealerAppSettings/PSQuoter/DocumentGenerator/PSQReport.aspx"--><!--Please change accordingly when it deployed-->
    <script runat="server">
        string docType = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            Parameter_QuoteId = Request.QueryString["QuoteId"].AsInt(0);
            Parameter_Revision = Request.QueryString["Revision"].AsInt(0);
            Parameter_Internal = Request.QueryString["Internal"].AsInt(0);
            Parameter_CustomerNo = Request.QueryString["CustomerNo"];
            Parameter_UserId = Request.QueryString["UserId"].AsInt(0);
            docType = Request.QueryString["docType"].AsString("");
            
            DataSet dsHeader = DAL.Quote.QuoteHeaderGet(Parameter_QuoteId, Parameter_Revision, 0);

            foreach (DataTable dt in dsHeader.Tables)
            {
                if (dt.Rows.Count > 0)
                {
                    dt.TableName = dt.Rows[0]["RS_Type"].ToString();
                }
            }

            DataRow drHeader = null;
            if (dsHeader.Tables.Contains("QuoteHeader"))
            {
                drHeader = dsHeader.Tables["QuoteHeader"].Rows[0];
            }

            if (drHeader != null)
            {
                Global_QuoteNo = drHeader["QuoteNo"].ToString();
                Global_CustomerName = drHeader["CustomerName"].ToString();
                Global_SalesrepEmail = drHeader["SREmail"].ToString();
            }


            string fileName = "";
            if (docType == "PDF")
              fileName=  GetReportDocumentFileName("PDF");
            //<CODE_TAG_104470>
            if (docType == "WORD")
              fileName = GetReportDocumentFileName("WORD");
            if (docType == "EXCEL")
                fileName = GetReportDocumentFileName("EXCEL");
            //</CODE_TAG_104470>
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("content-disposition", "attachment; filename=" + Path.GetFileName(fileName));
            Response.WriteFile(fileName);
            Response.End();
              
        }

    </script>
</asp:Content>
