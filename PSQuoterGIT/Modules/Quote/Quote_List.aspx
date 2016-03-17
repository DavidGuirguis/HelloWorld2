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

<%  // <CODE_TAG_104576>
    if (AppContext.Current.AppSettings.IsTrue("psQuoter.QuoteList.OwnerList.Default.All"))
        selOwnerId = CType.ToString(Request.QueryString["OwnerId"], "%");
    else  // </CODE_TAG_104576>
        selOwnerId = CType.ToString(Request.QueryString["OwnerId"], "");   //<CODE_TAG_103347> 
    if (selOwnerId == null || selOwnerId == "") selOwnerId= CType.ToString(WebContext.User.IdentityEx.UserID,"%"); //<CODE_TAG_103347> 
    selSalesRepUserId = CType.ToString(Request.QueryString["SalesRepUserId"], "%");
    selDivision = CType.ToString(Request.QueryString["Division"], "%");
    selPeriodId = CType.ToInt32(Request.QueryString["PeriodId"], 3);
    status = CType.ToInt32(Request.QueryString["status"], 31);
    //lastChange /* 1 - in one month, 3 - in three months, 6 - last 6 months, -1 - current year, -2 - in last year ...*/;
    //If selPeriodId = "" then selPeriodId = "3"
    /*DONE: review logic in ASP - was 'String.Compare(selPeriodId, "0") > 0'*/
    if (selPeriodId > 0)
    {
        //in months
        LastChangeDate_From = DateTime.Now.AddMonths((-1 * selPeriodId.As<int>())); /*NOTE: Manual Fixup - removed DateAndTime.DateAdd("m", (-1.0 * selPeriodId.As<double>()), DateTime.Now)*/
        LastChangeDate_To = DateTime.Now.AddYears(1);  /*NOTE: Manual Fixup - removed DateAndTime.DateAdd("y", 1.0, DateTime.Now)*/
    }
    else
    {
        /*DONE:review if type conversion if necessary - was 'Convert.ToDouble'*/
        selYear = selPeriodId.As<double>() + DateTime.Now.Year + 1;
        LastChangeDate_From = DateTime.Parse("January 1," + selYear); /*NOTE: Manual Fixup - changed from Convert.ToDateTime("January 1," + selYear) to DateTime.Parse*/
        LastChangeDate_To = DateTime.Parse("January 1," + (selYear + 1.0).As<string>());
    }
    ModuleTitle = (string)GetLocalResourceObject("rkModuleTitle");
    Response.Write("<form method=\"post\" name=\"frmTRG\">");
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();   /*NOTE: Manual Fixup - removed ActiveConnection.ConnectionString = cnn*/

    cmd.ActiveConnection.CursorLocation = ADODB.CursorLocationEnum.adUseClient;
    cmd.CommandText = "dbo.Quote_List";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    //<CODE_TAG_100278>
    //Improve exporting to Excel: Changed to send params via URL
    sSortField = Request.QueryString["SortField"];
    sSortDirection = Request.QueryString["SortDirection"];
    iStartRecord = Request.QueryString["StartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        iStartRecord = 1;
    }
    iPageSize = Request.QueryString["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        iPageSize = 50;
    }
    if (sSortField.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        sSortField = "QuoteDate";
    }
    if (sSortDirection.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        sSortDirection = "desc";
    }
    //</CODE_TAG_100278>
    cmd.Parameters.Append(cmd.CreateParameter("userID", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 60, sSortField));
    cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sSortDirection));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntity.BusinessEntityId /*NOTE: Manual Fixup - removed DefaultBusinessEntityId*/));
    cmd.Parameters.Append(cmd.CreateParameter("OwnerId", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, selOwnerId)); //<CODE_TAG_103347>
    cmd.Parameters.Append(cmd.CreateParameter("SalesRepUserId", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, selSalesRepUserId));
    cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, selDivision));
    cmd.Parameters.Append(cmd.CreateParameter("QuoteStatusId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, status));
    cmd.Parameters.Append(cmd.CreateParameter("LastChangeDate_From", ADODB.DataTypeEnum.adDBTimeStamp, ADODB.ParameterDirectionEnum.adParamInput, 0, LastChangeDate_From));
    cmd.Parameters.Append(cmd.CreateParameter("LastChangeDate_To", ADODB.DataTypeEnum.adDBTimeStamp, ADODB.ParameterDirectionEnum.adParamInput, 0, LastChangeDate_To));
    //<BEGIN-fxiao, 2010-01-19::Gets a flag indicating whether to show all quotes>
    cmd.Parameters.Append(cmd.CreateParameter("ShowAllQuotesInd", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamOutput, 0, null));
    rs = new ADODB.Recordset();
    rs = cmd.Execute();
    blnShowAllQuotes = BitMaskBoolean.IsTrue(cmd.Parameters["ShowAllQuotesInd"].Value.As<int?>());
%>
<div class="filters">

<table border="0" cellpadding="2" cellspacing="1" style="MARGIN-BOTTOM:5px">
		<tr id="rshl"><%
        //</END-fxiao, 2010-01-19>
    if (blnShowAllQuotes)
    {
        //<CODE_TAG_103347> Start 
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.QuoteList.ShowOwnerList"))
        {%>
	        <td id="owner"><asp:Localize ID="Localize01" meta:resourcekey="rkLabelText_Owner" runat="server">Owner</asp:Localize>:&nbsp;</td>
		        <td><%
            WriteOwner(rs);
            rs = rs.NextRecordset();
            %>
            </td><%
        }%>
        <%--<CODE_TAG_103347> end--%>
        <td id="Td2"><asp:Localize ID="Localize02" meta:resourcekey="rkLabelText_Creator" runat="server">Creator</asp:Localize>:&nbsp;</td>
		<td><%
        //<fxiao, 2010-01-19::Checks flag to show rep filter />
        WriteSalesRep(rs);
        rs = rs.NextRecordset();
%>
</td><%
    }
%>
		     <td><asp:Localize meta:resourcekey="rkLabelText_Division" runat="server">Division:</asp:Localize>&nbsp;</td>
		     <td><%
    ///Rep filter
    WriteDivision(rs);
    rs = rs.NextRecordset();
%>
</td>					
		     <td id="Td1"><asp:Localize meta:resourcekey="rkLabelText_LastChanged" runat="server">Last Changed:</asp:Localize>&nbsp;</td>
		     <td><%
    WritePeriod();
%>
</td>
		     <td></td>					
		</tr>
		<tr id="rshl">
			<td><asp:Localize meta:resourcekey="rkLabelText_Status" runat="server">Status:</asp:Localize>&nbsp;</td>
			<td colspan="5" style="FONT-WEIGHT:normal">
<%
    WriteStatus(ref rs);
    rs = rs.NextRecordset();
%>
			 </td>
			 <td>
                <input type="button" class="imgBtn" alt="<%= (string)GetLocalResourceObject("rkToolTip_Filter")%>" onclick="RunFilter();return false;" value="<%= (string)GetLocalResourceObject("rkButtonText_Filter")%>" />
			</td>
		</tr>
	</table>
</div>
<%
    quoteStatusEditable = AppContext.Current.AppSettings.IsTrue("psQuoter.QuoteList.QuoteStatusEditable"); //<CODE_TAG_105545>R.Z
    ShowUnitNo = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowUnitNo"].As<int?>();
    ShowWorkOrderNo = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowWorkOrderNo"].As<int?>();
    ShowAcceptedDate = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowAcceptedDate"].As<int?>();
    ShowQuoteTotal = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowQuoteTotal"].As<int?>();
    var ShowEstimatedBy = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowEstimatedBy"].As<int?>(); //<CODE_TAG_103628>
    //<CODE_TAG_104115>R.Z
    var ShowpsDaysBeforeSubmitted = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowDaysBeforeSubmitted"].As<int?>(); 
    if (ShowpsDaysBeforeSubmitted.IsNullOrWhiteSpace()) ShowpsDaysBeforeSubmitted = 2;
    //</CODE_TAG_104115>
    if (ShowUnitNo.IsNullOrWhiteSpace())
    {
        ShowUnitNo = 2;
    }
        //default is show (2)
    if (ShowWorkOrderNo/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        ShowWorkOrderNo = 1;
    }
        //default is hide (1)
    if (ShowAcceptedDate/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        ShowAcceptedDate = 1;
    }
        //default is hide (1)
    if (ShowQuoteTotal/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        ShowQuoteTotal = 1;
    }
    
    ShowDeliveryDate = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowDeliveryDate"].As<int?>();
    ShowDaysOutstanding = AppContext.Current.AppSettings["psQuoter.QuoteList.ShowDaysOutstanding"].As<int?>();
    
    if (ShowDeliveryDate/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        ShowDeliveryDate = 1;
    }
        //default is hide (1)
        /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
        /*DONE:review logic - was '== ""'*/
    if (ShowDaysOutstanding.IsNullOrWhiteSpace())
    {
        ShowDaysOutstanding = 1;
    }
    //default is hide (1)
    //</CODE_TAG_100338>
    iRecordCount = rs.Fields["RecordCount"].Value.As<int?>()/*DONE:review data type conversion - convert to proper type*/;
    rs = rs.NextRecordset();
    Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;\">");
        //[<IAranda. 20080604>. PSQuoter (QuoteListRange). START]
    if (i == 1)
    {
        Response.Write("<tr><td class=\"t11 tSb\" colspan=\"8\">" + String.Format((string)GetLocalResourceObject("rkMsg_QuotesCreatedInNumberOfDays"), rs.Fields["QListRange"].Value.As<string>()) + "</td></tr>");
    }
    rs = rs.NextRecordset();
    //[<IAranda. 20080604>. PSQuoter (QuoteListRange). END]
    //rw "<tr height=""20"" id=""rsh"" bgcolor=""darkslategray"" style=""color: #ffffff;"">"
    Response.Write("<tr height=\"20\" class=\"reportHeader\" >");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;<a href=# onclick=\"Sort('QuoteNo');\" >"+(string)GetLocalResourceObject("rkTableText_QuoteNo")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Status');\" >"+(string)GetLocalResourceObject("rkTableText_Status")+"</a></td>");
    //<CODE_TAG_105545>R.Z
    if (quoteStatusEditable)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap align=\"right\"><a href=# onclick=\"Sort('');\" ></a></td>");
    }
    //</CODE_TAG_105545>
    Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Division');\">"+(string)GetLocalResourceObject("rkTableText_Div")+"</a></td>");
    //Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Type');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkTableText_Type")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap align=\"middle\"><a href=# onclick=\"Sort('QuoteDate');\">"+(string)GetLocalResourceObject("rkTableText_QuoteDate")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('CustomerNo');\">"+(string)GetLocalResourceObject("rkTableText_Customer")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('QuoteDescription');\">"+(string)GetLocalResourceObject("rkTableText_Description")+"</a></td>");
    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show"))
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('SalesRepLName');\">Owner</a></td>");
    //Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('SalesRepFName');\">Creator</a></td>");
    //<CODE_TAG_103628>
    //Show EstimatedBy 
    if ( ShowEstimatedBy==2 )
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('EstimatedByName');\" >" + "Estimated By" + "</a></td>");
    }
    //</CODE_TAG_103628>
    Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('enterlastName');\">Creator</a></td>");
    Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('Make');\" >"+(string)GetLocalResourceObject("rkTableText_Make")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('Model');\" >"+(string)GetLocalResourceObject("rkTableText_Model")+"</a></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('SerialNo');\" >"+(string)GetLocalResourceObject("rkTableText_SerialNo")+"</a></td>");
        //<CODE_TAG_100266>
    if (ShowUnitNo == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('UnitNo');\" >"+(string)GetLocalResourceObject("rkTableText_UnitNo")+"</a></td>");
    //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
    }
    if (ShowWorkOrderNo /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('WorkOrderNo');\" >"+(string)GetLocalResourceObject("rkTableText_WorkOrderNo")+"</a></td>");
    }
    /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
    if (ShowAcceptedDate == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('AcceptedDate');\" >"+(string)GetLocalResourceObject("rkTableText_AcceptedDate")+"</a></td>");
    }
        //<CODE_TAG_100338>
    
    /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
    if (ShowDeliveryDate == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('DeliveryDate');\" >"+(string)GetLocalResourceObject("rkTableText_EstDeliveryDate")+"</a></td>");
    }


    //<CODE_TAG_104115>
    if (ShowpsDaysBeforeSubmitted == 2)
    { 
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('NumOfDays');\" >" + "Days<br/> Before Submitted" + "</a></td>");
    }
    //</CODE_TAG_104115>
    /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
    if (ShowDaysOutstanding == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('DaysOutstanding');\" >"+(string)GetLocalResourceObject("rkTableText_DaysOutstanding")+"</a></td>");
    }
        //</CODE_TAG_100338>
    if (ShowQuoteTotal /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2)
    {
        Response.Write("<td class=\"t11 tSb\" nowrap align=\"right\"><a href=# onclick=\"Sort('QuoteTotal');\" >"+(string)GetLocalResourceObject("rkTableText_QuoteTotal")+"</a></td>");
    }
    //</CODE_TAG_100266>

    
    Response.Write("</tr>");
    if (rs.EOF)
    {
        Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">"+(string)GetLocalResourceObject("rkMsg_NoInformationFound")+"</font></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        //Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>"); //for desc
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td>");
        Response.Write("<td class=\"t11 tSb\"></td></tr>");
    }
    else
    {
        sColour = "white";
        dsQuoteStatusList = DAL.Quote.Code_Quote_Status_List();  //<CODE_TAG_105545>R.Z
        while(!(rs.EOF))
        {
            //sType = rs.Fields["Type"].Value.As<string>(); /*NOTE: Manual Fixup - changed to string*/
            //*****If only one record*****
            //If cint(iRecordCount) = 1 then Response.Redirect "default.aspx?SID=" & Server.URLEncode(strSID) & "&MP=" & Server.URLEncode("modules/quote/quote.aspx") & "&QuoteId=" & rs("QuoteId") & "&Type=" & sType
            Response.Write("<tr valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");
            Response.Write("<td nowrap><a href=\"" + this.CreateUrl("modules/quote/quote_Summary.aspx", normalizeForAppending: true) + "QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Revision=" + rs.Fields["Revision"].Value.As<int>() + "\">" + rs.Fields["QuoteNo"].Value.As<string>() + "</td>");
            //Response.Write("<td id=\"rsc\">" + rs.Fields["Status"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            //<CODE_TAG_105545>R.Z
            if (quoteStatusEditable)
            {
                int quoteStatusId = 0;
                quoteStatusId = rs.Fields["QuoteStatusId"].Value.As<int>();
                string strStatusDropdownList = GetQuoteStatusDropdownList(rs.Fields["QuoteId"].Value.As<int>(), quoteStatusId, dsQuoteStatusList);
                string spanStatus = "<span id='spanSatus" + rs.Fields["QuoteId"].Value.As<string>() + "'" + @">" + rs.Fields["Status"].Value.As<string>() + "</span>";
                //Response.Write("<td id=\"rsc\">" + rs.Fields["Status"].Value.As<string>() + strStatusDropdownList + "</td>");
                Response.Write("<td id=\"rsc\">" + spanStatus + strStatusDropdownList + "</td>");
            }
            else
            {
                Response.Write("<td id=\"rsc\">" + rs.Fields["Status"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            }
            //</CODE_TAG_105545>
            //<CODE_TAG_105545>R.Z
            if (quoteStatusEditable)
            {
                string strStyle = " style=\"display:none;\"";
                //string strStyle = " style=\"display:;\"";
                //string alinkEdit = "<a id=\"Edit" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + @">[Edit]</a>";
                string alinkEdit = "<a id=\"Edit" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + "onClick=\"EditRow('" + rs.Fields["QuoteId"].Value.As<string>() + "');\"" + @">[Edit]</a>";
                //string alinkUpdate = "<a id=\"Update" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + @">[Update]</a>";
                string alinkUpdate = "<a id=\"Update" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + "onClick=\"UpdateRow('" + rs.Fields["QuoteId"].Value.As<string>() + "');\"" + @">[Update]</a>";
                //string alinkCancel = "<a id=\"Cancel" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + @">[Cancel]</a>";
                //string alinkCancel = "<a id=\"Cancel" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + "onClick=\"CancelRowEdit();\"" + @" >Cancel</a>";  
                //string alinkCancel = "<a id=\"Cancel" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + "onClick=\"CancelRowEdit('"+ "a" + "');\"" + @" >Cancel</a>";  
                string alinkCancel = "<a id=\"Cancel" + rs.Fields["QuoteId"].Value.As<string>() + "\"" + strStyle + "onClick=\"CancelRowEdit('" + rs.Fields["QuoteId"].Value.As<string>() + "');\"" + @" >[Cancel]</a>";  
                
                
                string alink = alinkEdit + alinkUpdate + alinkCancel;
                Response.Write("<td nowrap id=\"rsr\">" + alink + "</td>");
            }
            //</CODE_TAG_105545>
            Response.Write("<td id=\"rsc\">" + rs.Fields["Division"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            //Response.Write("<td id=\"rsc\">" + sType + "</td>");
            Response.Write("<td nowrap id=\"rsc\">" + Util.DateFormat(rs.Fields["QuoteDate"].Value.As<DateTime?>()) + "</td>");
            Response.Write("<td>" + rs.Fields["CustomerNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + " - " + rs.Fields["CustomerName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["QuoteDescription"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show"))
                Response.Write("<td>" + rs.Fields["SalesRepLName"].Value.As<string>() + ", " + rs.Fields["SalesRepFName"].Value.As<string>() + "</td>");
            //<CODE_TAG_103628>
            //Show EstimatedBy 
            if ( ShowEstimatedBy==2 )
            {
                Response.Write("<td nowrap id=\"rsc\">" + rs.Fields["EstimatedByName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            }
            //</CODE_TAG_103628>
            Response.Write("<td>" + rs.Fields["enterLastName"].Value.As<string>() + ", " + rs.Fields["enterFirstName"].Value.As<string>()); // /*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "&nbsp;" + rs.Fields["SalesRepLName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["Make"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["Model"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
                //<CODE_TAG_100266>
            if (ShowUnitNo == 2)
            {
                Response.Write("<td>" + rs.Fields["UnitNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
            }
            if (ShowWorkOrderNo /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2)
            {
                Response.Write("<td nowrap>" + rs.Fields["WorkOrderNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            }
            /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
            if (ShowAcceptedDate == 2)
            {
                Response.Write("<td nowrap>" + Util.DateFormat(rs.Fields["AcceptedDate"].Value.As<DateTime?>()) + "</td>");
            }
                //<CODE_TAG_100338>
                /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
            if (ShowDeliveryDate == 2)
            {
                if (!rs.Fields["DeliveryDate"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
                {
                    Response.Write("<td nowrap>" + DateTimeHelper.MonthName(rs.Fields["DeliveryDate"].Value.As<DateTime>().Month, abbreviate:true) /*NOTE: Manual Fixup - changed from VB .MonthName */ + ", " + rs.Fields["DeliveryDate"].Value.As<DateTime>().Year + "</td>");
                }
                else
                {
                    Response.Write("<td nowrap>&nbsp;</td>");
                }
            }
            
            //<CODE_TAG_104115>
            if (ShowpsDaysBeforeSubmitted == 2)
            { 
                Response.Write("<td nowrap id=\"rsc\">" + rs.Fields["NumOfDays"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            }
            //</CODE_TAG_104115>

            /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
            if (ShowDaysOutstanding == 2)
            {
                Response.Write("<td nowrap id=\"rsc\">" + rs.Fields["DaysOutstanding"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td>");
            }
                //</CODE_TAG_100338>
            if (ShowQuoteTotal/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2)
            {
                /*NOTE: Manual Fixup - changed to double?*/
                Response.Write("<td nowrap id=\"rsr\">" + Helpers.Util.NumberFormat(rs.Fields["QuoteTotal"].Value.As<double?>(), 2, null, null, null, true) + "</td>");
            }
            //</CODE_TAG_100266>

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
        
    //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
    }
    rs.Close();
    rs = null;
    Util.CleanUp(cmd: cmd, rs: rs);
    Response.Write("</table>");
        //<CODE_TAG_100278>
        //Improve exporting to Excel

    /*DONE:review if type conversion if necessary - was 'Convert.ToBoolean'*/
    /*NOTE: Manual Fixup - changed to '> 0'*/
    if (iRecordCount > 0)
    {
        Response.Write("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"right\">");
        Response.Write("<tr><td style=\"nowrap\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null) );
        Response.Write("</table>");
    }
    
    //</CODE_TAG_100278>
    Response.Write("</form>");
%>
<script language=javascript><!--
function Sort(sSortField){
	document.location.href = "<%=this.StripKeysFromCurrentPage("sortfield,sortdirection", true)/*DONE:review whether param 'normalizeForAppending' should be true, if yes '&' right after the var needs to be removed*/+ "SortDirection=" + Server.UrlEncode((sSortDirection.ToLower() == "asc" ?  "desc" :  "asc")) %>&SortField=" + encodeURIComponent(sSortField);
    
}

function Search(){
	frmTRG.submit();
}

    function RunFilter()	
    {
	    var strUrl;

	    strUrl = "<%=this.CreateUrl("modules/quote/quote_list.aspx", normalizeForAppending: true)%>" + getFilterUrlParams();
	    document.location.href = strUrl;
    }
    //<CODE_TAG_105545>R.Z
    function CancelRowEdit(quoteId) {
        //alert("currently cancel the line edit");
        $("#ddlQuoteStatus" + quoteId).hide();
        $("#Cancel" + quoteId).hide();
        $("#Update" + quoteId).hide();
        $("#Edit" + quoteId).show();
        $("#spanSatus" + quoteId).show();
    }
    function EditRow(quoteId) {
        //alert(465);
        $("#ddlQuoteStatus" + quoteId).show();
        $("#Cancel" + quoteId).show();
        $("#Update" + quoteId).show();
        $("#Edit" + quoteId).hide();
        $("#spanSatus" + quoteId).hide();
        //spanSatus700
        //alert($("spanSatus700").val());
    }
    function DdlQuoteStatusSelect(quoteId) {
        //alert("the selected value is: " + $("#ddlQuoteStatus" + quoteId).val());

    }
    function UpdateRow(quoteId) {
        //alert("updating.....");
        //alert("the selected value is: " + $("#ddlQuoteStatus" + quoteId).val());
        var quoteStatusId = $("#ddlQuoteStatus" + quoteId).val();
        var op = "UpdateQuoteStatus";
        var createTicket = 0;
        var userId;

        AjaxHandler(quoteId, op, quoteStatusId, createTicket);

        $("#ddlQuoteStatus" + quoteId).hide();
        $("#Cancel" + quoteId).hide();
        $("#Update" + quoteId).hide();
        $("#Edit" + quoteId).show();
        $("#spanSatus" + quoteId).show();
        //alert($("#ddlQuoteStatus" + quoteId + " option:selected").text());
        //alert($("#ddlQuoteStatus" + quoteId + " option:selected").text().substring(0, 1));
        var spanSatusNewValue = $("#ddlQuoteStatus" + quoteId + " option:selected").text().substring(0, 1);
        $("#spanSatus" + quoteId).text(spanSatusNewValue);


    }
    function AjaxHandler(quoteId, op, quoteStatusId, createTicket, userId) {
        //alert("QuoteAjaxHandler.ashx?QuoteId=" + quoteId + "&op=" + op + "&QuoteStatusId=" + quoteStatusId + "&CreateTicket=" + createTicket);
        var request = $.ajax({
            url: "QuoteAjaxHandler.ashx?QuoteId=" + quoteId + "&op=" + op + "&QuoteStatusId=" + quoteStatusId + "&CreateTicket=" + createTicket,
            type: "POST",
            //data: serializedData,
            cache: false,
            async: false,
            beforeSend: function () {
                // displayWaitingIcon(source)
                
            },
            complete: function () {
                //$("#spanLaborWaitting").hide();
                
            },
            success: function (htmlContent) {
                /*var currentFocusedControlId = typeof (document.activeElement) == "undefined" ? "" : document.activeElement.id;
                var rtOp = htmlContent.substr(0, 1);  // R: Replace   A: Alert   P: Popup
                htmlContent = htmlContent.substr(2);
  

                if (rtOp == "P") {
                    switch (source) {
                        case "Labor":

                            break;
                        case "Misc":

                            break;
                        default:
                    }
                }*/
                

            },
            error: function () { callBacking = false; }


        });
        
    }
 
    

    //</CODE_TAG_105545>
	function getFilterUrlParams()	
	{
        var objOwner = document.getElementById("filterOwner");	//<CODE_TAG_103347> 	
        var objSalesRep = document.getElementById("filterSalesRep");
		var objDivision = document.getElementById("filterDivision");
		var objPeriod = document.getElementById("filterPeriod");

		var sUrl = "";
        // <CODE_TAG_103347> Start
		if (objOwner != null ) 
		{
			if (objOwner.value.length > 0)	sUrl=sUrl + "&OwnerId=" + objOwner.value;
		}
        // <CODE_TAG_103347> end	
		if (objSalesRep != null ) 
		{
			if (objSalesRep.value.length > 0)	sUrl=sUrl + "&SalesRepUserId=" + objSalesRep.value;
		}	

		if (objDivision != null) 
		{
			if (objDivision.value.length > 0)	sUrl=sUrl + "&Division=" + escape(objDivision.value);
		}	
	
		if (objPeriod != null ) 
		{
			if (objPeriod.value.length > 0)	sUrl=sUrl + "&PeriodId=" + objPeriod.value;
		}	
						
		var status = 0;
	    var objCurrentStatus = document.getElementsByName("chkCurrentStatus");
	    for(var i=0; i<objCurrentStatus.length; i++)
	    {
		    if(objCurrentStatus[i].checked) 
		    {	
			    status = status + parseInt(objCurrentStatus[i].value);
		    }
	    }
 	    var objHistoryStatus = document.getElementsByName("chkHistoryStatus");
	    for(var i=0; i<objHistoryStatus.length; i++)
	    {
		    if(objHistoryStatus[i].checked) 
		    {	
			    status = status + parseInt(objHistoryStatus[i].value);
		    }
	    }

	    sUrl = sUrl + "&Status=" + status;
	    
		return sUrl.substring(1, sUrl.length);
	}
	
	function checkQuoteStatus(source) 
	{
	    var objAllStatus = document.getElementsByName("chkAllStatus");
	    var objCurrentStatus = document.getElementsByName("chkCurrentStatus");
	    var objHistoryStatus = document.getElementsByName("chkHistoryStatus");

		var bChecked = false;

		if(source.name == "chkAllStatus") {
			bChecked	= source.checked;

			for(var i=0; i<objCurrentStatus.length; i++)
				objCurrentStatus[i].checked = bChecked;

			for(var i=0; i<objHistoryStatus.length; i++)
				objHistoryStatus[i].checked = bChecked;
		}
		else {
			var bAllChecked = true;
		
			for(var i=0; i<objCurrentStatus.length; i++)
				if(!objCurrentStatus[i].checked) {
					bAllChecked = false;
					break;
				}
			
			for(var i=0; i<objHistoryStatus.length; i++)
				if(!objHistoryStatus[i].checked) {
					bAllChecked = false;
					break;
				}
			
			objAllStatus[0].checked = bAllChecked;
		}
	}
//-->
</script>
<script language="C#" runat="server">
    //<CODE_TAG_105545>R.Z
    bool quoteStatusEditable;
    
    protected string GetQuoteStatusDropdownList( int quoteId ,int quoteStatusId, System.Data.DataSet ds)
    {
        StringBuilder sb = new StringBuilder();
        //System.Data.DataRow dr; 
        int statusId = 0;
        string quoteStatus = "";
        //sb.Append(@"<select > ");
        //sb.Append(@"<select id=\"ddlQuoteStatus" + quoteStatusId.ToString() + "\"" + @"> ");
        //sb.Append(@"<select id='ddlQuoteStatus" + quoteId.ToString() + "'" + "quoteStatusId='" + quoteStatusId.ToString() + "'" + " quoteId='" + quoteId.ToString() + "' " + @"> ");
        sb.Append(@"<select id='ddlQuoteStatus" + quoteId.ToString() + "'" + "quoteStatusId='" + quoteStatusId.ToString() + "'" + " quoteId='" + quoteId.ToString() + "' " + "style='display:none;'" + @"> ");
        //sb.Append("<option value='0'>--</option>");
        foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
        {
            statusId = Convert.ToInt32(dr["QuoteStatusId"]);
            quoteStatus = dr["QuoteStatus"].ToString();
            if (quoteStatusId == statusId)
            {
                //sb.Append("<option selected  value=\"" + quoteStatus + "\"" + @">" + quoteStatus + @"</option>");
                sb.Append("<option selected  value='" + statusId.ToString() + "'" + "onClick='DdlQuoteStatusSelect(" + quoteId.ToString() + ");'" + @">" + quoteStatus + @"</option>");
            }
            else
            {
                //sb.Append("<option  value=\"" + quoteStatus + "\"" + @">" + quoteStatus + @"</option>");
                sb.Append("<option   value='" + statusId.ToString() + "'" + "onClick='DdlQuoteStatusSelect(" + quoteId.ToString() + ");'" + @">" + quoteStatus + @"</option>");
            }
        }
        sb.Append(@"</select> ");
        return sb.ToString();
        
    }
    System.Data.DataSet dsQuoteStatusList = new System.Data.DataSet();
    //dsQuoteStatusList = DAL.Quote.Quote_Get_RevisionSegmentsTotal();
    //</CODE_TAG_105545>
    string sSortField = null;/*DONE:review - check if it's using correct type*/
    string sSortDirection = null;/*DONE:review - check if it's using correct type*/
    int? iStartRecord = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iPageSize = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iRecordCount = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int i = 0;/*DONE:review - check if it's using correct type*/
    string sColour = null;/*DONE:review - check if it's using correct type*/
    string /*NOTE: Manual Fixup - changed to string*/ sType = null;
    string strURLPath = null;/*DONE:review if it's right type - was 'object'*/
    ADODB.CommandClass cmd = null;
    ADODB.Recordset rs = null;
    string strOperation = null;/*DONE:review if it's right type - was 'object'*/
    string selOwnerId = null;
    string selSalesRepUserId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string selDivision = null;/*DONE:review - check if it's using correct type*/
    int? selPeriodId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int status = 0;/*NOTE: Manual Fixup - changed from string to int*/
    DateTime LastChangeDate_From;
    DateTime LastChangeDate_To;
    //in particular year
    double selYear = 0;
    bool blnShowAllQuotes = false;
    //<CODE_TAG_100266>
    int?/*NOTE: Manual Fixup - changed to int?*/ ShowUnitNo = null;
    int?/*NOTE: Manual Fixup - changed to int?*/ ShowWorkOrderNo = null;
    int? ShowAcceptedDate = null;/*NOTE: Changed from DateTime? to int?*/
    int?/*NOTE: Manual Fixup - changed to int?*/ ShowQuoteTotal = null;
    //default is hide (1)
    //</CODE_TAG_100266>
    //<CODE_TAG_100338>
    int? ShowDeliveryDate = null;/*NOTE: Manual Fixup - changed from DateTime? to int?*/
    int? ShowDaysOutstanding = null; /*NOTE: Manual Fixup - changed from object to int?*/
    // <CODE_TAG_103347> Start    
    // Owner
    void WriteOwner(ADODB.Recordset/*DONE:review if this var is for recordset*/oRs) 
    {
        Response.Write("<select class=\"f\" name=\"filterOwner\"  id=\"filterOwner\" onChange=\"RunFilter();return false;\">");
        Response.Write("<option value=\"%\"");

        if ((CType.ToString(selOwnerId, String.Empty)).Trim() == selOwnerId)
        {
            Response.Write(" selected ");
        }
        Response.Write(" >" + (string)GetLocalResourceObject("rkHeaderText_All4") + "</option>");
        while(!oRs.EOF)
        {
            Response.Write("<option ");
            /*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/
            if ((oRs.Fields["OwnerId"].Value.As<string>()) == (selOwnerId))
            {
                Response.Write(" selected ");
            }
            Response.Write(" value=\"" + oRs.Fields["OwnerId"].Value.As<string>()  + "\">" + oRs.Fields["OwnerLastName"].Value.As<string>() + ", " + oRs.Fields["OwnerFirstName"].Value.As<string>() + "</option>");
            oRs.MoveNext();
        }
        Response.Write("</select>");
    }
    // <CODE_TAG_103347> end

    //List of SalesRep
    void WriteSalesRep(ADODB.Recordset/*DONE:review if this var is for recordset*/oRs) 
    {
        Response.Write("<select class=\"f\" name=\"filterSalesRep\"  id=\"filterSalesRep\" onChange=\"RunFilter();return false;\">");
        Response.Write("<option value=\"%\"");
        //if ((selSalesRepUserId ?? String.Empty).Trim() == "%")
        if ((CType.ToString(selSalesRepUserId, String.Empty)).Trim() == "%")
        {
            Response.Write(" selected ");
        }
        Response.Write(" >" + (string)GetLocalResourceObject("rkHeaderText_All3") + "</option>");
        while(!oRs.EOF)/*DONE:review - check if it's a 'NOT' logic*/
        {
            Response.Write("<option ");
            /*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/
            if ((oRs.Fields["SalesRepUserId"].Value.As<string>()) == (selSalesRepUserId))
            {
                Response.Write(" selected ");
            }
            Response.Write(" value=\"" + oRs.Fields["SalesRepUserId"].Value.As<string>()  + "\">" + oRs.Fields["SalesRepLastName"].Value.As<string>() + ", " + oRs.Fields["SalesRepFirstName"].Value.As<string>() + "</option>");
            oRs.MoveNext();
        }
        Response.Write("</select>");
    }

    //List of Division
    void WriteDivision(ADODB.Recordset/*DONE:review if this var is for recordset*/oRs) 
    {
        Response.Write("<select class=\"f\" name=\"filterDivision\"  id=\"filterDivision\" onChange=\"RunFilter();return false;\">");
        Response.Write("<option value=\"%\"");
        if ((selDivision ?? String.Empty).Trim() == "%")
        {
            Response.Write(" selected ");
        }
        Response.Write(" >"+(string)GetLocalResourceObject("rkHeaderText_All2"));
        while(!oRs.EOF)/*DONE:review - check if it's a 'NOT' logic*/
        {
            Response.Write("<option ");
            if ((oRs.Fields["Division"].Value.As<string>()).Trim() == (selDivision ?? String.Empty).Trim())
            {
                Response.Write(" selected ");
            }
            Response.Write(" value=\"" + oRs.Fields["Division"].Value.As<string>() + "\">" + oRs.Fields["DivisionName"].Value.As<string>() + " " + (string)GetLocalResourceObject("rkDropDownText_Division") + " (" + oRs.Fields["Division"].Value.As<string>() + ")" + "</option>");
            oRs.MoveNext();
        }
        Response.Write("</select>");
    }

    //List of Last Changed Period
    void WritePeriod() 
    {
        Response.Write("<select class=\"f\" name=\"filterPeriod\"  id=\"filterPeriod\" onChange=\"RunFilter();return false;\">");
        Response.Write("<option value=\"1\"");
        if (selPeriodId == 1)
        {
            Response.Write(" selected ");
        }
        Response.Write(">"+(string)GetLocalResourceObject("rkDropDownText_WithinOneMonth")+"</option>");
        Response.Write("<option value=\"3\"");
        if (selPeriodId == 3)
        {
            Response.Write(" selected ");
        }
        Response.Write(">"+(string)GetLocalResourceObject("rkDropDownText_WithinThreeMonths")+"</option>");
        Response.Write("<option value=\"6\"");
        if (selPeriodId == 6)
        {
            Response.Write(" selected ");
        }
        Response.Write(">"+(string)GetLocalResourceObject("rkDropDownText_WithinSixMonths")+"</option>");
        Response.Write("<option value=\"\"");
        //If trim(selPeriodId) = "" Then .Write " selected "
        Response.Write(">---------------------</option>");
        for(i = DateTime.Now.Year; i >= 2005; i += -1)
        {
            Response.Write("<option ");
            /*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
            if (selPeriodId == (i - DateTime.Now.Year - 1))
            {
                Response.Write(" selected ");
            }
            
            Response.Write(" value=\"" + (i - DateTime.Now.Year - 1).As<string>() + "\">In " + i/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "</option>");
        }
        Response.Write("</select>");
    }

    //Status Checkbox
    void WriteStatus(ref ADODB.Recordset/*DONE:review if this var is for recordset*/oRs) 
    {
        Response.Write("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">");
        Response.Write("<tr id=\"rsl\">");
        Response.Write("<td width=\"9%\">");
        Response.Write("<input type=checkbox name=\"chkAllStatus\" value=\"\"  onclick=\"javascript:checkQuoteStatus(this);\"");
        
        if (status == 31)
        {
            Response.Write(" checked ");
        }
        Response.Write(">");
        Response.Write("&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_All")+"</td>");
        Response.Write("<td width=\"43%\">");
        Response.Write("<fieldset><legend>"+(string)GetLocalResourceObject("rkHeaderText_Current")+"</legend>");
        while(!oRs.EOF)/*DONE:review - check if it's a 'NOT' logic*/
        {
            Response.Write("<input type=checkbox name=\"chkCurrentStatus\" value=\"" + oRs.Fields["QuoteStatusId"].Value.As<int>() + "\"  onclick=\"javascript:checkQuoteStatus(this);\"");
            
            if ((status & (oRs.Fields["QuoteStatusId"].Value.As<int?>())) > 0)
            {
                Response.Write(" checked ");
            }
            Response.Write(" >" + oRs.Fields["QuoteStatus"].Value.As<string>() + "&nbsp;&nbsp;");
            oRs.MoveNext();
        }
        oRs = oRs.NextRecordset();
        Response.Write("</fieldset>");
        Response.Write("</td>");
        Response.Write("<td width=\"1%\"><img src=\"../../library/images/spacer.gif\" border=\"0\" width=\"1\"></td>");
        Response.Write("<td width=\"43%\">");
        Response.Write("<fieldset><legend>"+(string)GetLocalResourceObject("rkHeaderText_History")+"</legend>");
        while(!oRs.EOF)/*DONE:review - check if it's a 'NOT' logic*/
        {
            Response.Write("<input type=checkbox name=\"chkHistoryStatus\" id=\"chkHistoryStatus\" value=\"" + (oRs.Fields["QuoteStatusId"].Value.As<int?>()) /*NOTE: Manual Fixup - changed to oRs.Fields["QuoteStatusId"].Value.As<int?>()*/ + "\"  onclick=\"javascript:checkQuoteStatus(this);\"");
            
            if ((status & (oRs.Fields["QuoteStatusId"].Value.As<int>())) > 0)
            {
                Response.Write(" checked ");
            }
            Response.Write(" >" + oRs.Fields["QuoteStatus"].Value.As<string>()/*NOTE: Manual Fixup - changed to ["QuoteStatus"].Value.As<string>()*/ + "&nbsp;&nbsp;");
            oRs.MoveNext();
        }
        Response.Write("</fieldset>");
        Response.Write("</td>");
        Response.Write("<td align=\"right\"></td>");
        Response.Write("</tr>");
        Response.Write("</table>");
    }

</script>
    
</asp:Content>
