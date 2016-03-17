<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.Popup" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">

<%
    string sKeyword = null;/*DONE:review - check if it's using correct type*/
    int? iSearchField = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iOperator = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string targetCoreField = null;/*DONE:review - check if it's using correct type*/
    string targetQuoteTotal = null;/*DONE:review - check if it's using correct type*/
    string targetSegTotal = null;/*DONE:review - check if it's using correct type*/
    string sSortField = null;/*DONE:review - check if it's using correct type*/
    string sSortDirection = null;/*DONE:review - check if it's using correct type*/
    int? iStartRecord = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iPageSize = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iRecordCount = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int?/*DONE:replace 'object' with proper type*/ showCorePrice = null;
    string SOSDesc = null;/*DONE:review - check if it's using correct type*/
    string corePrice = null;/*DONE:review - check if it's using correct type*/

    ADODB.Command cmd = null;

    ADODB.Recordset rs = null;
    int?/*DONE:replace 'object' with proper type*/ CATPriceShow = null;

    string strOperation = null;/*DONE:review if it's right type - was 'object'*/
    string strError = null;/*DONE:review if it's right type - was 'object'*/
    int? intReturnValue = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int x = 0;/*DONE:review - check if it's using correct type*/
    string partNo = null;/*DONE:review - check if it's using correct type*/
    string partDescription = null;/*DONE:review - check if it's using correct type*/
    string targetPartField = null;/*DONE:review - check if it's using correct type*/
    string strURLPath = null;/*DONE:review - check if it's using correct type*/
    string sequence = null;/*DONE:review - check if it's using correct type*/
    string targetDescField = null;/*DONE:review - check if it's using correct type*/
    string targetCostField = null;/*DONE:review - check if it's using correct type*/
    string targetSOSField = null;/*DONE:review - check if it's using correct type*/
    string targetQtyField = null;/*DONE:review - check if it's using correct type*/
    string unitPrice = null;/*DONE:review - check if it's using correct type*/
    string targetExtPriceField = null;/*DONE:review - check if it's using correct type*/
    string targetDiscountField = null;/*DONE:review - check if it's using correct type*/
    ADODB.Recordset/*DONE:review if this var is for recordset*/rsSOS = null;
    string sSOSDesc = null;/*DONE:review - check if it's using correct type*/
    string prevKeyWord = null;/*DONE:review - check if it's using correct type*/
    string prevOperator = null;/*DONE:review - check if it's using correct type*/
    
    CATPriceShow = CType.ToInt32(AppContext.Current.AppSettings["psQuoter.PartPrice.CAT.Show"].As<int?>(), 2);

	string IsBulkPartsImport = Request.QueryString["IsBulkPartsImport"].As<string>("0");		//<CODE_TAG_103467> Dav
	string ItemID = Request.QueryString["ItemID"].As<string>("0");		//<CODE_TAG_103467> Dav

    sKeyword = (Request.Form["txtKeyword"].As<string>() ?? String.Empty).Trim();
    iSearchField = Request.Form["cboSearchField"].As<int?>();
    iOperator = Request.Form["cboOperatorField"].As<int?>();
    //Get Previous Search Parameters
    prevKeyWord = (Request.Form["hdnKeyWord"].As<string>() ?? String.Empty).Trim();
    prevOperator = (Request.Form["hdnOperator"].As<string>() ?? String.Empty).Trim();
    if ((!sKeyword.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/))
    {
        if (((sKeyword != prevKeyWord) || (iOperator != prevOperator.As<int?>())))
        {
            sSOSDesc = "";
        }
        else
        {
            sSOSDesc = Request.Form["cboSOSField"].As<string>();
            if ((sSOSDesc == "All"))
            {
                sSOSDesc = "";
            }
        }
    }

    
    string qPartNo, qSOSDesc;
    //ispostback  does not work.
    if (sKeyword.IsNullOrWhiteSpace() && prevKeyWord.IsNullOrWhiteSpace() )
    {
        qPartNo = Request.QueryString["partNo"].AsString("");
        qSOSDesc = Request.QueryString["sosDesc"].AsString("");

        if (qPartNo != "")
            sKeyword = qPartNo;

       // if (qSOSDesc != "")
        sSOSDesc = qSOSDesc;


        iSearchField = 1;
    }

    
    
    if (iOperator.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
        iOperator = 2;
    }
    targetPartField = Request.QueryString["targetPartField"].As<string>();
    if ((targetPartField.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/))
    {
        targetPartField = (Request.Form["targetPartField"].As<string>() ?? String.Empty).Trim();
    }
    
    /*NOTE: Manual Fixup - removed Strings.Replace(targetPartField, "txtItemNo", "", 1 , -1, CompareMethod.Binary)*/
    sequence = targetPartField.Replace("txtItemNo", "");

    targetDescField = "txtDesc" + sequence;
    targetCostField = "txtUnitPrice" + sequence;
    targetCoreField = "txtCorePrice" + sequence;
    targetSOSField = "txtSOS" + sequence;
    targetQtyField = "txtQty" + sequence;
    targetExtPriceField = "txtExtPrice" + sequence;
    targetDiscountField = "txtDiscount" + sequence;
    targetQuoteTotal = "txtQuoteTotal";
    targetSegTotal = "txtSegTotal";
    if (!sKeyword.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
    {
        //<CODE_TAG_100582>
        if ((sKeyword.IndexOf("-") != -1))
        {
            sKeyword = sKeyword.Replace("-", "");
        }
        //</CODE_TAG_100582>
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "TRG_List_Parts";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/;
        sSortField = Request.Form["hdnSortField"].As<string>();
        sSortDirection = Request.Form["hdnSortDirection"].As<string>();
        iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();

        if (iStartRecord.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            iStartRecord = 1;
        }
      //  iPageSize = (Request.QueryString["RecordNo"]).As<int?>();
       //<CODE_TAG_101930>
         if (Request.Form["RecordNo"].As<int?>() != null)
            {
                iPageSize = Request.Form["RecordNo"].As<int>();
            }
            else
            {
                iPageSize = Request.QueryString["RecordNo"].As<int>();
            }
         //</CODE_TAG_101930>
        if (iPageSize.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            iPageSize = 20;
        }

        if (sSortField.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sSortField = "PartNo";
        }
        if (sSortDirection.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sSortDirection = "asc";
        }

        cmd.Parameters.Append(cmd.CreateParameter("SearchField", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 0, iSearchField));
        cmd.Parameters.Append(cmd.CreateParameter("Operator", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 0, iOperator));
        cmd.Parameters.Append(cmd.CreateParameter("Keyword", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 20, sKeyword));
        cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 60, sSortField));
        cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 4, sSortDirection));
        cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 0, iStartRecord));
        cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 0, iPageSize));
        cmd.Parameters.Append(cmd.CreateParameter("SOSDesc", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/, 50, sSOSDesc));
        rs = new Recordset();
        rs = cmd.Execute();
        iRecordCount = rs.Fields["RecordCount"].Value.As<int?>() /*DONE:review data type conversion - convert to proper type*/;
        rs = rs.NextRecordset();
    }
    //Get Config Value for Showing Core Price
    showCorePrice = CType.ToInt32(AppContext.Current.AppSettings["psQuoter.Quote.AddCorePrice"].As<int?>(), 2);
    Response.Write("<form method=\"post\" action id=\"frmTRG\" >");
    Response.Write("<input type=\"hidden\" name=\"targetPartField\" value=" + targetPartField + "/>");
    Response.Write("<input type=\"hidden\" name=\"hdnKeyWord\" value=\"" + sKeyword + "\" />");
    Response.Write("<input type=\"hidden\" name=\"hdnOperator\" value=\"" + iOperator + "\" />");
    
	//<CODE_TAG_103467> Dav
	//Response.Write("<table border=\"0\" width=\"700\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
	Response.Write("<table border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
	//</CODE_TAG_103467> Dav

    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string)GetLocalResourceObject("rkLabel_LookFor")+"&nbsp;&nbsp;</td>");
    Response.Write("<td><select accesskey=\"a\" class=\"f\" name=\"cboSearchField\" id=\"cboSearchField\">");   
    Response.Write("<option value=\"1\"");
 
    if (iSearchField == 1)
    {
        Response.Write(" selected");
    }
 
    Response.Write(">" + (string)GetLocalResourceObject("rkDropDown_PartNo"));
    Response.Write("<option value=\"2\"");
 
    if (iSearchField == 2)
    {
        Response.Write(" selected");
    }
 
    Response.Write(">" + (string)GetLocalResourceObject("rkDropDown_Description"));
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string)GetLocalResourceObject("rkLabel_that")+"&nbsp;</td>");
    Response.Write("<td><select accesskey=\"b\" class=\"f\" name=\"cboOperatorField\" id=\"cboOperatorField\">"); /*NOTE: Manual Fixup - changed class from 'f w125' to 'f'*/
    Response.Write("<option value=\"2\""); 
 
    if (iOperator == 2)
    {
        Response.Write(" selected");
    }
 
    Response.Write(">" + (string)GetLocalResourceObject("rkDropDown_Contains"));
    Response.Write("<option value=\"1\"");
 
    if (iOperator == 1)
    {
        Response.Write(" selected");
    }
 
    Response.Write(">" + (string)GetLocalResourceObject("rkDropDown_StartsWith"));
    Response.Write("<option value=\"0\"");
 
    if (iOperator == 0)
    {
        Response.Write(" selected");
    }
 
    Response.Write(">" + (string)GetLocalResourceObject("rkDropDown_Equals"));
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("<td><input name=\"txtKeyword\" maxlength=\"20\" class=\"f w200\" value=\"" + sKeyword + "\"></td>");
 
   // if ((iRecordCount/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ > 0))
   if (!sKeyword.IsNullOrWhiteSpace())
    {
        if (!((rs.BOF && rs.EOF)))
        {
            Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_SOS")+"&nbsp;&nbsp;</td>");
            Response.Write("<td><select accesskey=\"c\" onchange=\"SOSChanged();\"class=\"f\" name=\"cboSOSField\" id=\"cboSOSField\">");
            Response.Write("<option value=\"All\">" + (string)GetLocalResourceObject("rkDropDown_All"));
            while(!((rs.EOF)))
            {
                Response.Write("<option value=\"" + rs.Fields["SOSDesc"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "\"");
                if (sSOSDesc == rs.Fields["SOSDesc"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/)
                {
                    Response.Write(" selected");
                }
                Response.Write(">" + rs.Fields["SOSDesc"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/);
                rs.MoveNext();
            }
            Response.Write("</select>");
            Response.Write("</td>");
        }
        rs = rs.NextRecordset();
    }
   
    Response.Write("<td align=\"right\"><button type=\"button\" id=\"btnSearch\" name=\"btnSearch\" onclick=\"Search();\">"+(string)GetLocalResourceObject("rkButtonText_Search")+"</button></td>");
    Response.Write("</tr>");
    Response.Write("</table>");
    Response.Write("<br />");

    if (!sKeyword.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
    {
		//<CODE_TAG_103467> Dav
        //Response.Write("<table border=\"0\" width=\"790\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
		Response.Write("<table border=\"0\" width=\"100%\" id=\"tblResult\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
		//</CODE_TAG_103467> Dav

        Response.Write("<tr>");
        Response.Write("<td width=\"150\" class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkHeaderText_SOS2")+"</td>");
        Response.Write("<td width=\"150\" class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkHeaderText_PartNo")+"</td>");
        Response.Write("<td width=\"300\" class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkHeaderText_Description")+"</td>");
        if ((CATPriceShow/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 1))
        {
            Response.Write("<td width=\"100\" class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkHeaderText_UnitCost")+"</td>");
            if ((showCorePrice/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2))
            {
                Response.Write("<td width=\"100\" class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkHeaderText_CorePrice")+"</td>");
            }
        }
        
        Response.Write("<td width=\"100\" class=\"t11 tSb\" align=\"center\">"+(string)GetLocalResourceObject("rkHeaderText_Action")+"</td>");
        Response.Write("</tr>");
 
        if (rs.EOF)
        {
         Response.Write("<tr><td class=\"t11 tSb\">&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_NoPartsFound")+"</td>");
         Response.Write("<td class=\"t11 tSb\">&nbsp;</td>");
         Response.Write("<td class=\"t11 tSb\">&nbsp;</td>");
         Response.Write("<td class=\"t11 tSb\">&nbsp;</td></tr>");
        }
        else
        {
            x = 0;
            while(!(rs.EOF))
            {
                partNo = (rs.Fields["PartNo"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/).Trim();
                if(rs.Fields["Description"].Value.As<string>() == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
                {
                    partDescription = "";
                }
                else
                {
                    partDescription = (rs.Fields["Description"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/).Trim();
                }
                if(rs.Fields["SOSDesc"].Value.As<string>() == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
                {
                    SOSDesc = "";
                }
                else
                {
                    SOSDesc = (rs.Fields["SOSDesc"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/).Trim();
                }
                if(rs.Fields["UnitCost"].Value.As<double?>() == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
                {
                    unitPrice = "";
                }
                else
                {
                    /*NOTE: Manual Fixup - removed Strings.FormatNumber(rs.Fields["UnitCost"].Value.As<double?>(), 2, TriState.False, TriState.False, TriState.UseDefault)*/
                    unitPrice = CType.ToString(rs.Fields["UnitCost"].Value.As<double?>(), "0.00");
                }
                if(rs.Fields["CorePrice"].Value.As<double?>() == null)/*DONE:review - was 'Convert.IsDBNull/*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
                {
                    corePrice = "";
                }
                else
                {
                    /*NOTE: Manual Fixup - removed Strings.FormatNumber(rs.Fields["CorePrice"].Value.As<double?>(), 2, TriState.False, TriState.False, TriState.UseDefault)*/
                    corePrice = CType.ToString(rs.Fields["CorePrice"].Value.As<double?>(), "0.00");
                }
                Response.Write("<tr " + Util.RowClass(x) + ">");
                Response.Write("<td width=\"150\">" + SOSDesc + " (" + rs.Fields["SOS"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + ")</td>");
                Response.Write("<td width=\"100\">" + partNo + "</td>");
                Response.Write("<td width=\"240\">" + partDescription + "</td>");
 
                if ((CATPriceShow/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 1))
                {
                    Response.Write("<td width=\"100\">" + unitPrice + "</td>");
                    if ((showCorePrice/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ == 2))
                    {
                        Response.Write("<td width=\"100\">" + corePrice + "</td>");
                    }
                }
 
                Response.Write("<td width=\"100\" align=\"right\"><a href=\"Javascript:SelectPart('" + Server.HtmlEncode(partNo.Replace("'", "\\'")) + "','" + Server.HtmlEncode(partDescription.Replace("'", "\\'")) + "','" + unitPrice + "','" + corePrice + "','" + rs.Fields["SOS"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "')\"" + ">"+(string)GetLocalResourceObject("rkHeaderText_Add")+"</a></td>");
                Response.Write("</tr>");
                rs.MoveNext();
                x = x + 1;
            }
 
            //scolspan = "6";
            strURLPath = "";
            Response.Write("<tr class=\"t11\"><td colspan=\"3\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td><td>&nbsp;</td></tr>");
            
            //<CODE_TAG_100278>New param - httpMethod</CODE_TAG_100278>
 
        }
        Response.Write("</table>");
        rs.Close();
        rs = null;
        Util.CleanUp(cmd: cmd);
    }
    Response.Write("<input type=\"hidden\" name=\"hdnSortField\" value=" + sSortField + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnSortDirection\" value=" + sSortDirection + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("</form>");
%>

<script language="javascript">

frmTRG.txtKeyword.focus();

function Search(){
	if (frmTRG.txtKeyword.value == ""){
        alert ("<%= GetLocalResourceObject("rkMSG_EnterKeywordToSearch").JavaScriptStringEncode() %>");
		frmTRG.txtKeyWord.focus();
	}
	else {
		frmTRG.submit();
	}
}

function SOSChanged() {
	 frmTRG.submit();
}

function SubmitForm(){
	var i = window.event.keyCode;
	if (i == 13){
		Search()
	}
}


function SelectPart(partNo,description,cost,core,sos) {			

	//<CODE_TAG_103467> Dav
	//parent.AddCATPrice(partNo,description,sos,'< %= sequence %>');

	$j("#bottomContainer").html("");
	$j("#topContainer").html("");
	if(<%= IsBulkPartsImport%> == "1"){		
		parent.updatePart(<%= ItemID%>,partNo,sos);
	}
	else{
		parent.AddCATPrice(partNo,description,sos,'<%= sequence %>');
	}
	//</CODE_TAG_103467> Dav

	parent.closePartSearch() ;

 //var quoteTotal = window.opener.document.getElementById("<%= targetQuoteTotal %>").value;
 //var segTotal = window.opener.document.getElementById("<%= targetSegTotal %>").value;
 
 //var re = /,/gi;
		
 //quoteTotal = quoteTotal.replace(re,"");
 //segTotal = segTotal.replace(re,"");

 //if (isNaN(quoteTotal)) { quoteTotal = 0; }
 //if (isNaN(segTotal)) { segTotal = 0; }

 /*
// Rajesh Shaw Oct 2009 Check if CAT API option is selected
if (<%= CATPriceShow %> == 2)
{
	window.opener.AddCATPrice(partNo,description,sos,'<%= sequence %>');
	window.close();
}
else
{
		if (window.opener && !window.opener.closed)
		{
		    window.opener.document.getElementById("<%= targetPartField %>").value =  partNo;
		    window.opener.document.getElementById("<%= targetDescField %>").value =  description;
		    window.opener.document.getElementById("<%= targetCostField %>").value =  cost;
		    window.opener.document.getElementById("<%= targetSOSField %>").value =  sos;
		    
		    var re = /,/gi;
			cost = cost.replace(re,"");
			
		    if (!isNaN(cost))
		    {
				window.opener.document.getElementById("<%= targetExtPriceField %>").value = parseFloat(cost) * 1;
				window.opener.document.getElementById("<%= targetQuoteTotal %>").value = parseFloat(parseFloat(quoteTotal) + (parseFloat(cost) * 1)).toFixed(2);
				window.opener.document.getElementById("<%= targetSegTotal %>").value = parseFloat(parseFloat(segTotal) + (parseFloat(cost) * 1)).toFixed(2);
		    }
		    
		    window.opener.document.getElementById("<%= targetDiscountField %>").value = "0";
		    window.opener.document.getElementById("<%= targetQtyField %>").value = "1";
		    
		    if (core != '' && <%= showCorePrice %> == '2')
		    {
		      
		      addCoreDetail(partNo,description,core);
		      var re = /,/gi;
			  core = core.replace(re,"");
		      window.opener.document.getElementById("<%= targetQuoteTotal %>").value = parseFloat(parseFloat(quoteTotal) + (parseFloat(cost) * 1) + (parseFloat(core) * 1)).toFixed(2);
			  window.opener.document.getElementById("<%= targetSegTotal %>").value = parseFloat(parseFloat(segTotal) + (parseFloat(cost) * 1) + (parseFloat(core) * 1)).toFixed(2);
		    }
   
		   	window.close();
   	}
     	else {
            alert ("<%= GetLocalResourceObject("rkMSG_ParentWindowDoesNotExist").JavaScriptStringEncode() %>>");
        }

        }
        */
}


</script>
</asp:Content>
