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
    <rsweb:ReportViewer ID="ReportViewer2" runat="server" ClientIDMode="Static" Width="900px"
        Height="700px" />
    <!--#include file="../../PSQIncludes/PSQReport.aspx"-->
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

            if (!IsPostBack)
            {
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



                DataSet ds = new DataSet();
                ds = SqlHelper.ExecuteDataset("Quote_Get_DetailForPrint", Parameter_QuoteId, Parameter_Revision, Parameter_Internal, 0, 0, 1, 0, Parameter_CustomerNo, Parameter_UserId);
                foreach (DataTable dt in ds.Tables)
                {
                    if (dt.Rows.Count > 0)
                    {
                        dt.TableName = dt.Rows[0]["RS_Type"].ToString();
                    }
                }
                ReportDataSource rds = new ReportDataSource();
                rds.Name = "QuoterHeader";
                rds.Value = ds.Tables[5];
                ReportViewer2.LocalReport.DataSources.Add(rds);

                string strReport = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
                strReport += "<Report xmlns:rd=\"http://schemas.microsoft.com/SQLServer/reporting/reportdesigner\" xmlns=\"http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition\">";
                strReport += GetReportTemplateDatasetConfiguration();
                strReport += GetReportTemplatePageAndFooterConfiguration(ds);
                strReport += GetReportTemplateResource();
                strReport += GetReportTemplateBody(ds);
                strReport += "</Report>";
                            
                //out put the text file
                string AttachmentPDFFile = Server.MapPath("/") + "PDFGenDocs\\PSQ_" + Global_QuoteNo + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".txt";
		        File.WriteAllText(AttachmentPDFFile, strReport);


                byte[] byteArray = System.Text.Encoding.ASCII.GetBytes(strReport);
                MemoryStream stream = new MemoryStream(byteArray);

                ReportViewer2.LocalReport.LoadReportDefinition(stream);
                ReportViewer2.LocalReport.DisplayName = "quoter";
            }
            
        }
    </script>
</asp:Content>
