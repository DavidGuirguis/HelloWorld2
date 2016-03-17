<%@ Import Namespace = "ADODB" %>
<%
    HideLaborRate = AppContext.Current.AppSettings["psQuoter.Reports.HideLaborRate"].As<int?>();
    showCoreDescription = AppContext.Current.AppSettings["psQuoter.Reports.ShowCoreDescription"].As<string>();
    SRFaxNoLabel = AppContext.Current.AppSettings["psQuoter.Report.FaxNo.Header"].As<string>();   
    ShowSRPhoneAsExt = AppContext.Current.AppSettings["psQuoter.Quote.ShowSRPhoneAsExt"].As<int?>();   
    strDiscLabel = AppContext.Current.AppSettings["psQuoter.Quote.Print.Disc.Title"].DefaultIfNullOrWhiteSpace("Disc");

    if (SRFaxNoLabel.IsNullOrWhiteSpace())
    {
        strFaxLabel = "FAX NO.";
    }
    else
    {
        strFaxLabel = SRFaxNoLabel;
    }
    iEmail = Request.QueryString["SendEmail"];
    if (iEmail.IsNullOrWhiteSpace() || iEmail == "false")
    {
        iEmail = "0";
    }
    iQuoteId = Request.QueryString["QuoteId"];
    iRevision = Request.QueryString["Revision"];
    iInternal = Request.QueryString["Internal"];
    iRepair = Request.QueryString["Repair"];
    if (iRepair.IsNullOrWhiteSpace() || iRepair == "false")
    {
        iRepair = "0";
    }
    iJob = Request.QueryString["Job"];
    if (iJob.IsNullOrWhiteSpace() || iJob == "false")
    {
        iJob = "0";
    }
    iDetail = Request.QueryString["Detail"];
    sDivision = Request.QueryString["Division"];

    sQuoteNo = Request.QueryString["QuoteNo"];
    blnShowInternalDetails = iRepair == "1" && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.ShowInternalDetails");
    //Show disclaimers
    blnShowDisclaimers = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Disclaimers.Enabled") && Request.QueryString["Disclaimers"] == "1";
    sPrintCustomerNo = Request.QueryString["CustomerNo"];
%>
<script language="C#" runat="server">

    string iEmail = null;
    string iQuoteId = null;
    string iRevision = null;
    string iInternal = null;
    string iRepair = null;
    string iJob = null;
    string iDetail = null;
    string sQuoteNo = null;
    int? HideLaborRate = null;
    string showCoreDescription = null;
    string SRFaxNoLabel = null;
    string strFaxLabel = null;
    int?  ShowSRPhoneAsExt = null;
    bool blnShowUnitPriceSeperately = false;
    string strDiscLabel = null;
    string sDivision = null;
    bool blnShowDisclaimers = false;
    
    bool blnShowInternalDetails = false;
    
    bool blnShowUnitPriceColumnOnly = false;
    string sPrintCustomerNo = null;
    ADODB.CommandClass cmd = null;
    
    ADODB.Recordset GetPrintData() 
    {

        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.Quote_Get_DetailForPrint";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd.CommandTimeout = 120;
        cmd.Parameters.Append(cmd.CreateParameter("QuoteId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iQuoteId));
        cmd.Parameters.Append(cmd.CreateParameter("Revision", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iRevision));
        cmd.Parameters.Append(cmd.CreateParameter("Internal", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iInternal));
        cmd.Parameters.Append(cmd.CreateParameter("RepairOptions", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iRepair));
        cmd.Parameters.Append(cmd.CreateParameter("JobOperations", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iJob));
        cmd.Parameters.Append(cmd.CreateParameter("ShowDetail", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iDetail));
        cmd.Parameters.Append(cmd.CreateParameter("ShowDisclaimers", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, (blnShowDisclaimers ?  1 :  0)));
        cmd.Parameters.Append(cmd.CreateParameter("CustomerNo", ADODB.DataTypeEnum.adVarChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sPrintCustomerNo));
        cmd.Parameters.Append(cmd.CreateParameter("PrintingXUId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, X.Web.WebContext.Current.User.IdentityEx.UserID));
        
        return cmd.Execute();
    }

</script>
