<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.ReportViewPage" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
<%
    int? iRptType = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iQuoteYear = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string sBranchNo = null;/*DONE:review - check if it's using correct type*/
    string sBranchName = null;/*DONE:review - check if it's using correct type*/
    int? iQuoteStatusId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string sQuoteStatus = null;/*DONE:review - check if it's using correct type*/
    int? iSRUserId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string sSRName = null;/*DONE:review - check if it's using correct type*/
    string sSortField = null;/*DONE:review - check if it's using correct type*/
    string sSortDirection = null;/*DONE:review - check if it's using correct type*/
    int? iStartRecord = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iPageSize = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string iMonth = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iRecordCount = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? /*DONE:replace 'object' with proper type*/ i = null;
    string sColour = null;/*DONE:review - check if it's using correct type*/
    string sType = null;
    string strURLPath = null;/*DONE:review if it's right type - was 'object'*/
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    ADODB.Connection cnn = null;
    string strOperation = null;/*DONE:review if it's right type - was 'object'*/
    string strModuleTitle = null;/*DONE:review - check if it's using correct type*/
    string sDivision = null;
    int scolspan = 0;
    strModuleTitle = (string)GetLocalResourceObject("rkModuleTitle");
    //If sBranchNo <> "%%%" and sBranchNo <> "" and sBranchName <> "" then strModuleTitle = strModuleTitle & " - " & UCase(sBranchName)
    //If sDivision <> "%" then strModuleTitle = strModuleTitle & " - DIVISION " & sDivision
    //If sSRName <> "" and iRptType <> "1" then strModuleTitle = strModuleTitle & " - " & UCase(sSRName)
    //If sQuoteStatus <> "" then strModuleTitle = strModuleTitle & " - " & UCase(sQuoteStatus)
    ModuleTitle = strModuleTitle;
    Response.Write("<form method=\"post\" name=\"frmTRG\">");
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "dbo.Workflow_Detail";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    iRptType = Request.QueryString["RptType"].As<int?>();
    iQuoteYear = Request.QueryString["QuoteYear"].As<int?>();
    sBranchNo = Request.QueryString["BranchNo"];

    if (sBranchNo.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        sBranchNo = "%%%";
    }
    sBranchName = Request.QueryString["BranchName"];
    iQuoteStatusId = Request.QueryString["QuoteStatusId"].As<int?>();
    if (iQuoteStatusId.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        iQuoteStatusId = 0;
    }
    sQuoteStatus = Request.QueryString["QuoteStatus"];
    sDivision = Request.QueryString["Division"];
    if (sDivision.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        sDivision = "%";
    }
    iSRUserId = Request.QueryString["SRUserId"].As<int?>();
    if (iSRUserId.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        iSRUserId = 0;
    }
    sSRName = Request.QueryString["SRName"];
    sSortField = Request.Form["hdnSortField"];
    if (sSortField.IsNullOrWhiteSpace())
    {
        sSortField = "QuoteDate";
    }
    sSortDirection = Request.Form["hdnSortDirection"];
    if (sSortDirection.IsNullOrWhiteSpace())
    {
        sSortDirection = "desc";
    }
    iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }
    iPageSize = Request.Form["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 50; //<CODE_TAG_103473>
    }
    cmd.Parameters.Append(cmd.CreateParameter("QuoteYear", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 2, iQuoteYear));
    cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sDivision));
    cmd.Parameters.Append(cmd.CreateParameter("BranchNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sBranchNo));
    //<BEGIN-fxiao, 2010-01-18::Filtering issues - Always pass value from the filter>
    //if (cint(iSRUserId) = 0 and iRptType = "1") then
    //cmd.Parameters.Append cmd.CreateParameter("SalesRepUserId",adInteger,adParamInput,4,intUserId)
    //else
    //cmd.Parameters.Append cmd.CreateParameter("SalesRepUserId",adInteger,adParamInput,4,iSRUserId)
    //end if
    cmd.Parameters.Append(cmd.CreateParameter("SalesRepUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iSRUserId));
    //</END-fxiao, 2010-01-18>
    cmd.Parameters.Append(cmd.CreateParameter("QuoteStatusId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iQuoteStatusId));
    cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 60, sSortField));
    cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sSortDirection));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("RptType", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 2, iRptType));
    //'[<IAranda. 20080606>. PSQuoter (DollarTotals).]
    iMonth = Request.QueryString["QuoteMonth"];
    if (iMonth.IsNullOrWhiteSpace())
    {
        iMonth = "0";
    }
    //Month(Date)	'[<IAranda. 20080606>. PSQuoter.]
    cmd.Parameters.Append(cmd.CreateParameter("QuoteMonth", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, (iMonth == "0" ?  "%%" :  iMonth)));
    //'[<IAranda. 20080606>. PSQuoter (DollarTotals).]
    cmd.Parameters.Append(cmd.CreateParameter("ViewXUId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
    //<fxiao, 2010-01-18::Filtering issues - Get current user />
    rs = new Recordset();
    rs = cmd.Execute();
    //If rs.EOF = false then sBranchName = rs("BranchName")
    //Set rs = rs.NextRecordset
    if (rs.EOF == false && sBranchNo != "%%%")
    {
        sSRName = rs.Fields["SRName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
    }
    rs = rs.NextRecordset();
    iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
    rs = rs.NextRecordset();
    //***********************************Header*******************************************************************
    Response.Write("<span class=\"t14 tSb\">" + (string)GetLocalResourceObject("rkHeaderText_QuoteWorkFlow"));
    if (sBranchNo != "%%%" && !sBranchNo.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/ && !sBranchName.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
    {
        Response.Write(String.Format((string)GetLocalResourceObject("rkHeaderText_QuoteWorkFlow_BranchName"), sBranchName.ToUpper()));
    }
    if (sDivision != "%")
    {
        Response.Write(String.Format((string)GetLocalResourceObject("rkHeaderText_QuoteWorkFlow_Division"), sDivision));
    }
    if (!sSRName.IsNullOrWhiteSpace() && iRptType != 1)
    {
        Response.Write(String.Format((string)GetLocalResourceObject("rkHeaderText_QuoteWorkFlow_SSRName"), sSRName.ToUpper()));
    }
    if (!sQuoteStatus.IsNullOrWhiteSpace())
    {
        Response.Write(String.Format((string)GetLocalResourceObject("rkHeaderText_QuoteWorkFlow_SQuoteStatus"), sQuoteStatus.ToUpper()));
    }
    Response.Write("</span>");
    Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    if (i == 1)
    {
        Response.Write("<tr><td class=\"t11 tSb\" colspan=\"8\">"+(string)GetLocalResourceObject("rkHeaderText_QuotesCreatedLastThirtyDays")+"</td></tr>");
    }
    
    Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\" >");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('QuoteNo');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_QuoteNo")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('Status');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Status")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap style=\"text-align:right;\">&nbsp;<a href=# onclick=\"Sort('Division');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Division")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Type');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Type")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap align=\"middle\"><a href=# onclick=\"Sort('QuoteDate');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_QuoteDate")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;<a href=# onclick=\"Sort('CustomerNo');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Customer")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;<a href=# onclick=\"Sort('QuoteDescription');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Description")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('SalesRepFName');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_SalesRep")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;<a href=# onclick=\"Sort('Make');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Make")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;<a href=# onclick=\"Sort('Model');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_Model")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('SerialNo');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_SerialNo")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('UnitNo');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkColumnText_UnitNo")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('WorkOrderNo');\" style=\"color:black;\">"+ (string)GetLocalResourceObject("rkColumnText_WONo") +"</a></td>");//!!<CODE_TAG_102272>
    //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
    Response.Write("</tr>");
    if (rs.EOF)
    {
        Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">"+(string)GetLocalResourceObject("rkMsg_NoInfoFound")+"</font></td></tr>");
    }
    else
    {
        sColour = "white";
        while(!(rs.EOF))
        {
            sType = rs.Fields["Type"].Value.As<string>();
            //*****If only one record*****
            if (iRecordCount == 1)
            {
                //Response.Redirect(this.CreateUrl("modules/quote/quote.aspx", normalizeForAppending: true) + "LMENU=ON&QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Type=" + sType);
                Response.Redirect(this.CreateUrl("modules/quote/quote_summary.aspx", normalizeForAppending: true) + "QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Revision=" + rs.Fields["Revision"].Value.As<string>() + "&Type=" + sType/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
            }
            Response.Write("<tr valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");
            //Response.Write("<td nowrap><a href=\""+ this.CreateUrl("modules/quote/quote.aspx", normalizeForAppending: true) + "LMENU=ON&QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Type=" + sType + " "+ rs.Fields["QuoteNo"].Value.As<string>() + "\"></a></td>");
            Response.Write("<td nowrap><a href=\"" + this.CreateUrl("modules/quote/quote_summary.aspx", normalizeForAppending: true) + "QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Revision=" + rs.Fields["Revision"].Value.As<string>() + "&Type=" + sType + "\">" + rs.Fields["QuoteNo"].Value.As<string>() + "</a></td>");
            Response.Write("<td id=\"rsc\">" + (rs.Fields["Status"].Value.As<string>()) + "</td>");
            Response.Write("<td id=\"rsc\">" + (rs.Fields["Division"].Value.As<string>()) + "</td>");
            Response.Write("<td id=\"rsc\">" + sType + "</td>");
            Response.Write("<td nowrap id=\"rsc\">" + Util.DateFormat(rs.Fields["QuoteDate"].Value.As<DateTime?>()) + "</td>");
            Response.Write("<td>" + rs.Fields["CustomerNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + " - " + rs.Fields["CustomerName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td id=\"rsc\" style=\"text-align:left;\">" + (rs.Fields["QuoteDescription"].Value.As<string>()) + "</td>");
            Response.Write("<td>" + rs.Fields["SalesRepFName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "&nbsp;" + rs.Fields["SalesRepLName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["Make"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["Model"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["UnitNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["WorkOrderNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");//<CODE_TAG_102272>
            //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
            Response.Write("</tr>");
            if (sColour == "white")
            {
                sColour = "#efefef";
            }
            else
            {
                sColour = "white";
            }
            rs.MoveNext();
        }
        scolspan = 12; //9
        //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
        Response.Write("<tr><td colspan=\"" + ((scolspan - 2.0)).As<string>() + "\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td><td colspan=\"2\"><table>");
        //<CODE_TAG_100278>New param - httpMethod</CODE_TAG_100278>
        Response.Write("</table>");
    }
    rs.Close();
    rs = null;
    Util.CleanUp(cmd: cmd);
    Response.Write("</table><br>");
    Response.Write("<input type=\"hidden\" name=\"hdnSortField\" value=" + sSortField + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnSortDirection\" value=" + sSortDirection + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("</form>");
%>
<script language=javascript><!--
function Sort(sSortField){
	if (frmTRG.hdnSortField.value == sSortField && frmTRG.hdnSortDirection.value == "asc"){
		frmTRG.hdnSortDirection.value = "desc";
	}
	else {
		frmTRG.hdnSortDirection.value = "asc";
	}
		
	frmTRG.hdnSortField.value = sSortField;
	frmTRG.submit();
	
}

function Search(){
	frmTRG.submit();
	
}

//-->
</script>
</asp:Content>
