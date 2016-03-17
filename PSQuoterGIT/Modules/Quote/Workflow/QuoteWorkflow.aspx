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
<!--#include file="../inc_quote.aspx"-->

<%
    //[<IAranda. 20080606>. PSQuoter (CloseRate).]
    iRows = 0;
    CloseRateCalculation = AppContext.Current.AppSettings["psQuoter.CloseRate.Calculation"];
    //DONE Redim Preserve not supported.
    arrQuoteStatusDesc = new string/*DONE:replace 'object' with proper type*/[-1 + 1];
    //</END-fxiao, 2010-01-29>
    iYear = Request.Form["cboYear"].As<int?>();
    if (iYear.IsNullOrWhiteSpace())
    {
        iYear = DateTime.Today.Year;
    }
    sDivision = Request.Form["cboDivision"];
    if (sDivision.IsNullOrWhiteSpace())
    {
        sDivision = "";
    }
    iSRUserId = Request.Form["cboSalesRep"].As<int?>();
    if (iSRUserId.IsNullOrWhiteSpace())
    {
        iSRUserId = 0;
    }
    sBranchNo = Request.Form["cboBranch"];
    if (sBranchNo.IsNullOrWhiteSpace())
    {
        sBranchNo = "";
    }
    if ((sBranchNo == "%%%"))
    {
        BranchNoGrandTotal = "";
    }
    else
    {
        BranchNoGrandTotal = sBranchNo;
    }
    SRidGrandTotal = iSRUserId;
    iRptType = CType.ToInt32(Request.QueryString["RptType"], 1);
    iMonth = Request.Form["cboMonth"].As<int?>();
    if (iMonth.IsNullOrWhiteSpace())
    {
        iMonth = 0;
    }
    //[<IAranda. 20080606>. PSQuoter.]
    ModuleTitle = String.Format((string)GetLocalResourceObject("rkModuleTitle"), ((iRptType == 1 ?  (string)GetLocalResourceObject("rkHeaderText_Branch") :  "Quote Workflow by Owner")));
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.ActiveConnection.CursorLocation = ADODB.CursorLocationEnum.adUseClient;
    cmd.CommandText = "dbo.Workflow_Summary";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.Parameters.Append(cmd.CreateParameter("RptType", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iRptType));
    cmd.Parameters.Append(cmd.CreateParameter("QuoteYear", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 2, iYear));
    cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sDivision));
    cmd.Parameters.Append(cmd.CreateParameter("BranchNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sBranchNo));
    //<BEGIN-fxiao, 2010-01-18::Filtering issues - Always pass value from the filter>
    //if (iSRUserId = 0 and iRptType = "1") then
    //cmd.Parameters.Append cmd.CreateParameter("SalesRepUserId",adInteger,adParamInput,4,intUserId)
    //else
    //cmd.Parameters.Append cmd.CreateParameter("SalesRepUserId",adInteger,adParamInput,4,iSRUserId)
    //end if
    cmd.Parameters.Append(cmd.CreateParameter("SalesRepUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iSRUserId));
    //</END-fxiao, 2010-01-18>
    cmd.Parameters.Append(cmd.CreateParameter("QuoteMonth", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, iMonth));
    //[<IAranda. 20080606>. PSQuoter.]
    //<BEGIN-fxiao, 2010-01-18::Filtering issues - Add new params>
    cmd.Parameters.Append(cmd.CreateParameter("ViewXUId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("ShowAllUsersInd", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamOutput, 0, DBNull.Value));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
    rs = cmd.Execute();
    blnShowAllUsers = BitMaskBoolean.IsTrue(cmd.Parameters["ShowAllUsersInd"].Value);
    //</END-fxiao, 2010-01-18>
    
    Response.Write("<div id=\"wrapper\" style=\"width:700px;\">");
    //****************************Title and Year Filter*******************************************************************
    Response.Write("<div class=\"filters\">");
    Response.Write("<form method=\"post\" action id=\"frmTRG\">");
    Response.Write("<table  border=\"0\" cellpadding=\"2\" cellspacing=\"1\" style=\"MARGIN-BOTTOM:5px\">");
    //Response.Write("<tr id=\"rshl\"><td class=t14 tSb nowrap>Quote Workflow by Owner</td>");
    //<CODE_TAG_103573>
    if (iRptType == 1 )
        Response.Write("<tr id=\"rshl\"><td class=t14 tSb nowrap>Quote Workflow by Branch</td>");

    else
        Response.Write("<tr id=\"rshl\"><td class=t14 tSb nowrap>Quote Workflow by Owner</td>");
    //</CODE_TAG_103573>
    //*****Year Filter*****
    Response.Write("<td align=right width=10><select name=\"cboYear\" class=\"f\" onchange=\"frmTRG.submit();\">");
    for(c = DateTime.Now.Year; c >= 2006; c += -1)
    {
        Response.Write("<option value=" + c/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
        if (c == iYear)
        {
            Response.Write(" selected ");
        }
        Response.Write(">" + c/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "</option>");
    }
    Response.Write("</select></td>");
    //[<IAranda. 20080606>. PSQuoter. START]
    Response.Write("<td align=right width=10><select name=\"cboMonth\" class=\"f\" onchange=\"frmTRG.submit();\">");
    Response.Write("<option value='0'");
    if (iMonth == 0)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_AllMonths")+"</option>");
    Response.Write("<option value='1'");
    if (iMonth == 1)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_January")+"</option>");
    Response.Write("<option value='2'");
    if (iMonth == 2)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_February")+"</option>");
    Response.Write("<option value='3'");
    if (iMonth == 3)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_March")+"</option>");
    Response.Write("<option value='4'");
    if (iMonth == 4)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_April")+"</option>");
    Response.Write("<option value='5'");
    if (iMonth == 5)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_May")+"</option>");
    Response.Write("<option value='6'");
    if (iMonth == 6)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_June")+"</option>");
    Response.Write("<option value='7'");
    if (iMonth == 7)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_July")+"</option>");
    Response.Write("<option value='8'");
    if (iMonth == 8)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_August")+"</option>");
    Response.Write("<option value='9'");
    if (iMonth == 9)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_September")+"</option>");
    Response.Write("<option value='10'");
    if (iMonth == 10)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_October")+"</option>");
    Response.Write("<option value='11'");
    if (iMonth == 11)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_November")+"</option>");
    Response.Write("<option value='12'");
    if (iMonth == 12)
    {
        Response.Write(" selected ");
    }
    Response.Write(">"+(string)GetLocalResourceObject("rkFilter_December")+"</option>");
    Response.Write("</select></td>");
    //[<IAranda. 20080606>. PSQuoter. END]
    //*****Division Filter*****
    Response.Write("<td align=right width=10><select name=\"cboDivision\" class=\"f\" onchange=\"frmTRG.submit();\">");
    Response.Write("<option value=\"\">" + (string)GetLocalResourceObject("rkFilter_AllDivisions"));
    while(rs.EOF == false)
    {
        sDivRS = rs.Fields["Division"].Value.As<string>();
        Response.Write("<option value=\"" + sDivRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "\"");
        if (sDivRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == sDivision)
        {
            Response.Write(" selected ");
        }
        Response.Write(">" + sDivRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " - " + rs.Fields["DivisionName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/);
        rs.MoveNext();
    }
    Response.Write("</select></td>");
    rs = rs.NextRecordset();
    showAdmin = AppContext.Current.AppSettings["psQuoter.Quote.List.ShowAdmin"];
    if (iRptType/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 1)
    {
            //*****Sales Rep Filter*****
        if (blnShowAllUsers)
        {
            //<fxiao, 2010-01-18::Filtering issues - Apply new flag to control visibility of Sales Rep filter />
            Response.Write("<td align=right width=10><select name=\"cboSalesRep\" class=\"f\" onchange=\"frmTRG.submit();\">");
            Response.Write("<option value=\"0\">All Owners" );
            while(rs.EOF == false)
            {
                iSRUserIdRS = rs.Fields["SalesRepUserId"].Value.As<int?>();
                Response.Write("<option value=\"" + iSRUserIdRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "\"");
                if (iSRUserIdRS/*DONE:review if type conversion if necessary - was 'Convert.ToInt64'*/ == iSRUserId/*DONE:review if type conversion if necessary - was 'Convert.ToInt64'*/)
                {
                    Response.Write(" selected ");
                }
                Response.Write(">" + rs.Fields["FirstName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + " " + rs.Fields["LastName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/);
                rs.MoveNext();
            }
            rs = rs.NextRecordset();
            Response.Write("</select></td>");
        }
        ///blnShowAllUsers:True
    }
    else
    {
        //*****Branch Filter*****
        Response.Write("<td align=right width=10><select name=\"cboBranch\" class=\"f\" onchange=\"frmTRG.submit();\">");
        Response.Write("<option value=\"%%%\">" + (string)GetLocalResourceObject("rkFilter_AllBranches"));
        while(rs.EOF == false)
        {
            sBranchNoRS = rs.Fields["BranchNo"].Value.As<string>();
            Response.Write("<option value=\"" + sBranchNoRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "\"");
            if (sBranchNoRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == sBranchNo)
            {
                Response.Write(" selected ");
            }
            Response.Write(">" + sBranchNoRS/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " - " + rs.Fields["BranchName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/);
            rs.MoveNext();
        }
        rs = rs.NextRecordset();
        Response.Write("</select></td>");
    }
    Response.Write("</tr>");
    Response.Write("</table>");
    Response.Write("</form>");
    Response.Write("</div>");
    //***********************************Header*******************************************************************
    showCancelled = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.ShowStatus.Cancel");
    Response.Write("<table class=\"tbl\" width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"2\" style=\"border-top:1px solid #cccccc;border-left:1px solid #cccccc;border-right:1px solid #cccccc;\">");
    Response.Write("<tr id=\"rshl\" class=\"thc\" height=20>");
    Response.Write("<td id=rshl width=100>&nbsp;");
        //[<IAranda. 20080606>. PSQuoter.]
    if (iRptType/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ == 1)
    {
        Response.Write((string)GetLocalResourceObject("rkColumnText_BranchName"));
    }
    else
    {
        Response.Write("Owner");
    }
    Response.Write("</td>");
    Response.Write("<td id=rshc width=100>"+(string)GetLocalResourceObject("rkHeaderText_Quoted")+"</td>");

        //if (showCancelled <> "2") then
        //rw "<table width=""700"" border=""0"" cellspacing=""1"" cellpadding=""2"" class=tbl style=""border-top:1px solid #cccccc;border-left:1px solid #cccccc;border-right:1px solid #cccccc;"">"
        //rw "<tr id=""rsh"" bgcolor=""darkslategray"" style=""color: #ffffff;"" height=20>"
        //rw "<td id=rshl width=100>&nbsp;"	'[<IAranda. 20080606>. PSQuoter.]
        //If cint(iRptType) = 1 then rw "Branch Name" Else rw "Sales Rep"
        //'	rw "</td>"
        //rw "<td id=rshc width=100>Quoted</td>"
        //'	rw "<td id=rshc width=100>Open</td>"
        //rw "<td id=rshc width=100>Submitted</td>"
        //'	rw "<td id=rshc width=100>Accepted</td>"
        //rw "<td id=rshc width=100>Rejected</td>"
        //rw "<td id=rshc width=100>Close Rate</td>"	'[<IAranda. 20080606>. PSQuoter (CloseRate).]
        //'	rw "</tr>"
        //rw "<tr><td colspan=7 height=2 bgcolor=#cccccc></td></tr>"
        //else
        //rw "<table width=""800"" border=""0"" cellspacing=""1"" cellpadding=""2"" class=tbl style=""border-top:1px solid #cccccc;border-left:1px solid #cccccc;border-right:1px solid #cccccc;"">"
        //'	rw "<tr id=""rsh"" bgcolor=""darkslategray"" style=""color: #ffffff;"" height=20>"
        //rw "<td id=rshl width=100>&nbsp;"	'[<IAranda. 20080606>. PSQuoter.]
        //If cint(iRptType) = 1 then rw "Branch Name" Else rw "Sales Rep"
        //rw "</td>"
        //'	rw "<td id=rshc width=100>Quoted</td>"
        //rw "<td id=rshc width=100>Open</td>"
        //rw "<td id=rshc width=100>Submitted</td>"
        //rw "<td id=rshc width=100>Accepted</td>"
        //rw "<td id=rshc width=100>Rejected</td>"
        //rw "<td id=rshc width=100>Cancelled</td>"
        //rw "<td id=rshc width=100>Close Rate</td>"	'[<IAranda. 20080606>. PSQuoter (CloseRate).]
        //rw "</tr>"
        //rw "<tr><td colspan=7 height=2 bgcolor=#cccccc></td></tr>"
        //end if

     var iQuoteTotalItems = new Dictionary<int, double?>();
    iQuoteTotalItems[qs_Open] = 0;
    iQuoteTotalItems[qs_Submitted] = 0;
    iQuoteTotalItems[qs_Won] = 0;
    iQuoteTotalItems[qs_Lost] = 0;
    iQuoteTotalItems[qs_Cancelled] = 0;
    var fQuoteTotalItems = new Dictionary<int, double?>();
    fQuoteTotalItems[qs_Open] = 0;
    fQuoteTotalItems[qs_Submitted] = 0;
    fQuoteTotalItems[qs_Won] = 0;
    fQuoteTotalItems[qs_Lost] = 0;
    fQuoteTotalItems[qs_Cancelled] = 0;
    var amountItems = new Dictionary<int, double?>();
    var quoteCountItems = new Dictionary<int, double?>();
    var quoteKeys = new Dictionary<int, int>();
    quoteKeys[qs_Open] = qs_Open;
    quoteKeys[qs_Submitted] = qs_Submitted;
    quoteKeys[qs_Won] = qs_Won;
    quoteKeys[qs_Lost] = qs_Lost;
    quoteKeys[qs_Cancelled] = qs_Cancelled;

    if (rs.EOF)
    {
        if (!showCancelled)
        {
            Response.Write("<tr><td colspan=8 height=30 class=\"searchresult\" style=\"font-size:12px\">&nbsp;"+(string)GetLocalResourceObject("rkMsg_NoDataFound1")+"</td></tr>");
        }
        else
        {
            Response.Write("<tr><td colspan=9 height=30 class=\"searchresult\" style=\"font-size:12px\">&nbsp;"+(string)GetLocalResourceObject("rkMsg_NoDataFound2")+"</td></tr>");
        }
    }
    else
    {
        var headerItems = new Dictionary<int, int>();
        intStatusCount = 0;
        int quoteStatus = 0;
        while(!(rs.EOF))
        {
            quoteStatus = rs.Fields["QuoteStatusId"].Value.AsInt();

            quoteStatusItems.Add(quoteStatus, rs.Fields["QuoteStatus"].Value.As<string>());

                if (quoteStatus != qs_Cancelled || showCancelled)
                {
                    Response.Write("<td id=rshc width=100>" + quoteStatusItems[quoteStatus] + "</td>");
                }

            intStatusCount = intStatusCount + 1;
            rs.MoveNext();
        }
        
        /*Print out the 'No Deal' column header*/        
       // Response.Write("<td id=rshc width=100>" + quoteStatusItems[quoteStatus] + "</td>"); //lulu
        
    }

    
    Response.Write("<td id=rshc width=100>"+(string)GetLocalResourceObject("rkColumnText_CloseRate")+"</td>");
    Response.Write("</tr>");
    //if (showCancelled <> "2") then
    //rw "<tr><td colspan=7 height=2 bgcolor=#cccccc></td></tr>"
    //else
    //rw "<tr><td colspan=8 height=2 bgcolor=#cccccc></td></tr>"
    //end if
    rs = rs.NextRecordset();
        //*****************************Details********************************************************************************
    while(!(rs.EOF))
    { 
        iCount = 0;
        if (iRptType/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ == 1)
        {
            sBranchNo = rs.Fields["BranchNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
            sBranchName = rs.Fields["BranchName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
            strDisplay = sBranchName + " - " + rs.Fields["BranchNo"].Value.As<string>() /*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;           
        }
        else
        {
            iSRUserId = rs.Fields["SalesRepUserId"].Value.As<int?>();
            sSRName = rs.Fields["SRName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
            strDisplay = rs.Fields["SRName"/*DONE:convert to data field name instead of index*/].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
        }
        if(sBranchName == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
        {
            sBranchName = "";
        }
        if(sSRName == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
        {
            sSRName = "";
        }
        sURLParams = this.CreateUrl("modules/quote/workflow/QuoteWorkflow_Drill.aspx", normalizeForAppending:true) + "RptType=" + iRptType + "&QuoteYear=" + iYear + "&QuoteMonth=" + iMonth + "&BranchNo=" + Server.UrlEncode(sBranchNo) + "&BranchName=" + Server.UrlEncode(sBranchName) + "&SRUserId=" + iSRUserId + "&SRName=" + Server.UrlEncode(sSRName) + "&Division=" + Server.UrlEncode(sDivision);
        //IAranda.

        iQuoted = rs.Fields["Quoted"].Value.As<int?>();
        
        quoteCountItems[qs_Open] = rs.Fields["OpenQuote"].Value.As<int?>();

        quoteCountItems[qs_Submitted] = rs.Fields["Submitted"].Value.As<int?>();
        
        quoteCountItems[qs_Won] = rs.Fields["Accepted"].Value.As<int?>();

        quoteCountItems[qs_Lost] = rs.Fields["Rejected"].Value.As<int?>();
        
        quoteCountItems[qs_Cancelled] = rs.Fields["Cancelled"].Value.As<int?>();

            //Rajesh Shaw Apr 8th 2009
        if ((CloseRateCalculation/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ == "1"))
        {
            //<CODE_TAG_105263>R.Z
            iRejected = rs.Fields["Rejected"].Value.As<int?>();
            iAccepted = rs.Fields["Accepted"].Value.As<int?>();
            if (iRejected == null) iRejected = 0;
            if (iAccepted == null) iAccepted = 0;
            //</CODE_TAG_105263>
            intTotal = iRejected + iAccepted;
            if (intTotal == 0)
            {
                intTotal = 1;
            }
            //fCloseRate = (iAccepted/*DONE:review if type conversion if necessary - was 'Convert.ToDouble'*/ / intTotal) * 100.0;
            fCloseRate = (Convert.ToDouble(iAccepted)/*DONE:review if type conversion if necessary - was 'Convert.ToDouble'*/ / Convert.ToDouble(intTotal)) * 100.0;  //<CODE_TAG_105263>R.Z
        }
        else
        {
            fCloseRate = rs.Fields["CloseRate"].Value.As<double?>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
        //[<IAranda. 20080606>. PSQuoter (CloseRate).]
        }
        //[<IAranda. 20080606>. PSQuoter (DollarTotals). START]

        fQuoted_Dollar = rs.Fields["SumQuoted"].Value.As<double?>();

        amountItems[qs_Open] = rs.Fields["SumOpen"].Value.As<double?>();

        amountItems[qs_Submitted] = rs.Fields["SumSubmitted"].Value.As<double?>();
        
        amountItems[qs_Won] = rs.Fields["SumAccepted"].Value.As<double?>();

        amountItems[qs_Lost] = rs.Fields["SumRejected"].Value.As<double?>();

        amountItems[qs_Cancelled] = rs.Fields["SumCancelled"].Value.As<double?>();
        //[<IAranda. 20080606>. PSQuoter (DollarTotals). END]

        if (showCancelled)
        {
            Response.Write("<tr><td  colspan=9 height=0.5 bgcolor=\"#cccccc\" style=\"padding-top:0px;\"></td></tr>");
        }
        else
        {
            Response.Write("<tr><td  colspan=8 height=0.5 bgcolor=\"#cccccc\" style=\"padding-top:0px;\"></td></tr>");
        }
        Response.Write("<tr class=\"t11\" ><td id=\"rslfl\" width=\"180px\">" + strDisplay + "</td>");
        
        Response.Write("<td id=\"" + getBGColor(ref iCount) + "\">");
        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(fQuoted_Dollar, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault) */
        //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=0&QuoteStatus=Quoted>" + iQuoted + "<br/>" + Util.FormatCurrency(fQuoted_Dollar.As<string>()) + "</a>");
        //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=0&QuoteStatus=Quoted>" + iQuoted + "<br/>" + Util.FormatCurrency(fQuoted_Dollar) + "</a>");
        //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=0&QuoteStatus=Quoted>" + iQuoted + "<br/>" + (String.Format("{0:n2}", Math.Round(rs.Fields["SumQuoted"].Value.As<decimal>(), 2))).Replace(",", ".") + "</a>");
        Response.Write("<a href=" + sURLParams + "&QuoteStatusId=0&QuoteStatus=Quoted>" + iQuoted + "<br/>" + Util.FormatCurrency(fQuoted_Dollar) + "</a>");
        Response.Write("</td>");

        foreach(var entry in quoteStatusItems)
        {
            if ((quoteStatusItems[entry.Key].AsString() != qs_Cancelled.AsString()) || showCancelled)
                {
                //if (!showCancelled){
                    Response.Write("<td id=\"" + getBGColor(ref iCount) + "\">");
                        if(quoteCountItems[entry.Key]!=0)
                        {
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(amountItems[entry.Key], 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)*/
                            Response.Write("<a href=" + sURLParams + "&QuoteStatusId=" + quoteKeys[entry.Key] + "&QuoteStatus=" + quoteStatusItems[entry.Key] + ">" + quoteCountItems[entry.Key] + "<br/>" + Util.FormatCurrency(amountItems[entry.Key]) + "</a>");
                        }
                        Response.Write("</td>");
                        //[<IAranda. 20080606>. PSQuoter (DollarTotals).]
                   }
          }

        //[<IAranda. 20080606>. PSQuoter (CloseRate). START]
        Response.Write("<td id=\"" + getBGColor(ref iCount) + "\">");
        if (fCloseRate != 0.0)
        {
            /*NOTE: Manual Fixup - removed Strings.FormatNumber(fCloseRate, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)*/
            //Response.Write("<a>" + Util.FormatCurrency(fQuoted_Dollar) + "</a>");
            //<CODE_TAG_101651>
            //Response.Write("<a>" + Util.NumberFormat( fCloseRate,2,null,null,null,true) + "</a>"); //chris 2013.3.12
            Response.Write("<a>" + Util.NumberFormat( fCloseRate,2,null,null,null,true) + "%</a>"); 
            ////<CODE_TAG_101651>
        }
        Response.Write("</td>");
        //[<IAranda. 20080606>. PSQuoter (CloseRate). END]
        Response.Write("</tr>");
        
        iQuoted_Total = iQuoted_Total + iQuoted;

        iQuoteTotalItems[qs_Open] = iQuoteTotalItems[qs_Open] + quoteCountItems[qs_Open];
        
        //iSubmitted_Total = iSubmitted_Total + iSubmitted;
        iQuoteTotalItems[qs_Submitted] = iQuoteTotalItems[qs_Submitted] + quoteCountItems[qs_Submitted];
        
        iQuoteTotalItems[qs_Won] = iQuoteTotalItems[qs_Won] + quoteCountItems[qs_Won];

        iQuoteTotalItems[qs_Lost] = iQuoteTotalItems[qs_Lost] + quoteCountItems[qs_Lost];
        
        iQuoteTotalItems[qs_Cancelled] = iQuoteTotalItems[qs_Cancelled] + quoteCountItems[qs_Cancelled];
        
        //[<IAranda. 20080606>. PSQuoter (CloseRate). START]
        fCloseRate_Total = fCloseRate_Total + fCloseRate;
        iRows = iRows + 1;
        //[<IAranda. 20080606>. PSQuoter (CloseRate). END]

        //[<IAranda. 20080606>. PSQuoter (DollarTotals). START]
        fQuoted_Dollar_Tot = fQuoted_Dollar_Tot + fQuoted_Dollar;
        
        fQuoteTotalItems[qs_Open] = fQuoteTotalItems[qs_Open] + amountItems[qs_Open];
        
        fQuoteTotalItems[qs_Submitted] = fQuoteTotalItems[qs_Submitted] + amountItems[qs_Submitted];
        
        fQuoteTotalItems[qs_Won] = fQuoteTotalItems[qs_Won] + amountItems[qs_Won];
        
        fQuoteTotalItems[qs_Lost] = fQuoteTotalItems[qs_Lost] + amountItems[qs_Lost];
        
        fQuoteTotalItems[qs_Cancelled] = fQuoteTotalItems[qs_Cancelled] + amountItems[qs_Cancelled];

        //[<IAranda. 20080606>. PSQuoter (DollarTotals). END]
        rs.MoveNext();
    }
    //********************************************Grand Total**************************************************
    if (showCancelled)
        Response.Write("<tr><td colspan=9 height=1 bgcolor=\"#cccccc\" style=\"padding-top:0px;\"></td></tr>");
    else
    {
        Response.Write("<tr><td colspan=8 height=1 bgcolor=\"#cccccc\" style=\"padding-top:0px;\"></td></tr>");
    }

    Response.Write("<tr class=\"thgtc\">");
    Response.Write("<td id=rshl>"+(string)GetLocalResourceObject("rkHeaderText_GrandTotal")+"</td>");
    //[<IAranda. 20080606>. PSQuoter]
    sURLParams = this.CreateUrl("modules/quote/workflow/QuoteWorkflow_Drill.aspx", normalizeForAppending:true) + "RptType=" + iRptType + "&QuoteYear=" + iYear + "&QuoteMonth=" + iMonth + "&BranchNo=" + Server.UrlEncode(BranchNoGrandTotal) + "&BranchName=" + "&SRUserId=" + SRidGrandTotal + "&Division=" + Server.UrlEncode(sDivision);
    Response.Write("<td id=rshc>");
    if ((iQuoted_Total + iQuoted) != 0)
    {
        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(fQuoted_Dollar_Tot, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)*/
        Response.Write("<a href=" + sURLParams + "&QuoteStatusId=0&QuoteStatus=Quoted>" + iQuoted_Total + "<br/>" + Util.FormatCurrency(fQuoted_Dollar_Tot) + "</a>");
    }
    //[<IAranda. 20080606>. PSQuoter (DollarTotals).]
    Response.Write("</td>");

   foreach(var entry in quoteStatusItems)
   {
        Response.Write("<td id=rshc>");
        if (showCancelled || iQuoteTotalItems[entry.Key] != 0){
                //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=" + quoteKeys[entry.Key] + "&QuoteStatus=" + quoteStatusItems[entry.Key] + ">" + iQuoteTotalItems[entry.Key] + "<br/>" + Strings.FormatCurrency(fQuoteTotalItems[entry.Key], 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault) + "</a>");
                //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=" + quoteKeys[entry.Key] + "&QuoteStatus=" + quoteStatusItems[entry.Key] + ">" + iQuoteTotalItems[entry.Key] + "<br/>" + String.Format("{0:c}", fQuoteTotalItems[entry.Key]) + "</a>");
            //Response.Write("<a href=" + sURLParams + "&QuoteStatusId=" + quoteKeys[entry.Key] + "&QuoteStatus=" + quoteStatusItems[entry.Key] + ">" + iQuoteTotalItems[entry.Key] + "<br/>" + Util.FormatCurrency(fQuoteTotalItems[entry.Key].As<string>()) + "</a>");
            Response.Write("<a href=" + sURLParams + "&QuoteStatusId=" + quoteKeys[entry.Key] + "&QuoteStatus=" + quoteStatusItems[entry.Key] + ">" + iQuoteTotalItems[entry.Key] + "<br/>" + Util.FormatCurrency(fQuoteTotalItems[entry.Key].As<double?>()) + "</a>");
        }
         Response.Write("</td>");
   }
 

    //[<IAranda. 20080606>. PSQuoter (CloseRate). START]
    Response.Write("<td id=rshc>");
    if ((iQuoteTotalItems[qs_Submitted]/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ > 0) || (iQuoteTotalItems[qs_Won]/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ > 0) || (iQuoteTotalItems[qs_Cancelled]/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ > 0))
    {
        iTotalClosedQuotes = 0;
        if ((CloseRateCalculation/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ == "1"))
        {
            iTotalClosedQuotes = (iQuoteTotalItems[qs_Won] + iQuoteTotalItems[qs_Lost]).As<int>();
            
        }
        else
        {
            iTotalClosedQuotes = ((iQuoteTotalItems[qs_Submitted] + iQuoteTotalItems[qs_Won] + iQuoteTotalItems[qs_Lost])).As<int>();
        }
        if (iTotalClosedQuotes == 0)
        {
            Response.Write("&nbsp;");
        }
        else
        {
            /*NOTE: Manual Fixup - removed Strings.FormatNumber((iQuoteTotalItems[qs_Won] / iTotalClosedQuotes) 100.0, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)*/
            Response.Write("<a>" + Util.NumberFormat((iQuoteTotalItems[qs_Won] / iTotalClosedQuotes) * 100.0, 2, null, null, null, true) + " %</a>");
        }
    }
    Response.Write("</td>");
    //[<IAranda. 20080606>. PSQuoter (CloseRate). END]
    Response.Write("</tr>");
    if (showCancelled)        
        Response.Write("<tr><td colspan=9 height=1 bgcolor=#cccccc style=\"padding-top:0px;\"></td></tr>");
    else
        Response.Write("<tr><td colspan=8 height=1 bgcolor=#cccccc style=\"padding-top:0px;\"></td></tr>");
           
    Response.Write("</table>");
    Response.Write("</div>");
    rs.Close();
    rs = null;
    Util.CleanUp(cmd: cmd);
%>
<script language="C#" runat="server">

    int? iYear = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iSRUserId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string sBranchNo = null;/*DONE:review - check if it's using correct type*/
    string BranchNoGrandTotal = null;/*DONE:review - check if it's using correct type*/
    int? SRidGrandTotal = null;/*DONE:review - check if it's using correct type*/
    int? iRptType = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iMonth = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/

    ADODB.Recordset rs = null;
    int c = 0;/*DONE:review - check if it's using correct type*/
    string/*DONE:replace 'object' with proper type*/ showAdmin = null;
    int? iSRUserIdRS = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    string/*DONE:replace 'object' with proper type*/ sBranchNoRS = null;
    bool showCancelled;
    int iCount = 0;/*DONE:review - check if it's using correct type*/
    string sBranchName = null;/*DONE:review - check if it's using correct type*/
    string strDisplay = null;/*DONE:review - check if it's using correct type*/
    string sSRName = null;/*DONE:review - check if it's using correct type*/
    string sURLParams = null;/*DONE:review - check if it's using correct type*/
    int? iQuoted = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? iOpenQuote = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? iSubmitted = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? iAccepted = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? iRejected = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? iCancelled = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int? intTotal = 0;/*DONE:review - check if it's using correct type*/
    double? fCloseRate = 0;
    double?/*DONE:replace 'object' with proper type*/ fQuoted_Dollar = null;

    int i = 0;/*DONE:review - check if it's using correct type*/
    int? iQuoted_Total = 0;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
   
    double? fCloseRate_Total = 0;
    double?/*DONE:replace 'object' with proper type*/ fQuoted_Dollar_Tot = 0;
    
    int? iRows = 0;/*DONE:review - check if it's using correct type*/
    int intStatusCount = 0;/*DONE:review - check if it's using correct type*/

    string CloseRateCalculation = null;/*DONE:review if it's right type - was 'object'*/
    //<BEGIN-fxiao, 2010-01-29::Update QuoteStatusId value>
    string/*DONE:replace 'object' with proper type*/[] arrQuoteStatusDesc = null;
    bool blnShowAllUsers = false;
    int iTotalClosedQuotes = 0;/*DONE:review - check if it's using correct type*/
    string sDivRS = null;
    List<Tuple<string, int>> list1=null;
    Dictionary<int, double> d1 = null;
    Dictionary<int, string> quoteStatusItems = new Dictionary<int, string>();
    Dictionary<int, double?> totalAmounts = new Dictionary<int, double?>();
    string sDivision = null; /*NOTE: Manual Fixup - added sDivision*/
    ADODB.CommandClass cmd = null;  /*NOTE: Manual Fixup - added cmd*/
    
    //*******************************************************************
    string getBGColor(ref int iCount) 
    {
        string getBGColor = null;/*DONE:review - check if it's using correct type*/
        if (iCount % 2 == 1)
        {
            getBGColor = "rscfl";
        }
        else
        {
            getBGColor = "rsc";
        }
        iCount = iCount + 1;
        return getBGColor;
    }

</script>
</asp:Content>