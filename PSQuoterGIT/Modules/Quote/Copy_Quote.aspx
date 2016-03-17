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
<!--#include file="../search/inc_search.aspx"-->
<!--#include file="inc_quote.aspx"-->
<%  
    int? iStartRecord = null;
    int? iPageSize = null;
   
    string sQuoteNo = null;
    int? iField = null;
    int? iOperator = null;
    string sKeyword = null;
    string sOperation = null;
    int? iQuoteId = 0;
    string disabled = null;
    string ot2 = null;
    string ot0 = null;
    string ot1 = null;
    string strLinkText = null;
    string strLinkUrl = null;
    ADODB.Command cmd = null;
    ADODB.Parameter objParam = null;
    ADODB.Recordset rs = null;
    string autoGenQuoteNo = null;
    bool blnShowAllQuotes = false;
    string SearchDivision = null;
    //<CODE_TAG_100886>
    ////<CODE_TAG_100886>
    sQuoteNo = Request.Form["txtQuoteNo"].AsString();
    iField = Request.Form["cboSField"].As<int?>();
    iOperator = Request.Form["cboSOperator"].As<int?>();
    sKeyword = (Request.Form["txtSKeyword"] ?? String.Empty).Trim();
    sOperation = Request.Form["hdnOperation"];
    ModuleTitle = (string) GetLocalResourceObject("rkModuleTitle_Copy_Quote");

   
    iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }
    iPageSize = (Request.Form["RecordNo"]).As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 10;
    }

    if (sOperation == "Copy")
    {
        CopyQuote(Request.Form["hdnQuoteId"], sQuoteNo);
    }
    Response.Write("<form method=\"post\" action id=\"frmTRG\" onkeyup=\"SubmitForm();\">");
    if (iQuoteId == 0 && !AppContext.Current.User.Operation.CreateQuote)
    {
        Response.Write("<table class=\"tbl\" cellspacing=\"0\" cellpadding=\"2\" border=\"0\" width=\"650\">");
        Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_You_do_not_have_access_to_create_a_Quote")+"</font></td></tr>");
        Response.Write("</table>");
    }
    else
    {
        Response.Write("<input type=\"hidden\" name=\"hdnOperation\">");
        Response.Write("<input type=\"hidden\" name=\"hdnQuoteId\">");
        Response.Write("<table class=\"tbl\" cellspacing=\"0\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc;\">");
        Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
        Response.Write("<td colspan=\"4\" class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkFrmHeader_Copy_Quote")+"</td>");
        Response.Write("<td colspan=\"2\" class=\"t11 tSb\" align=\"right\">");
        Response.Write("</td>");
        Response.Write("</tr>");
        Response.Write("</table>");
        //--- SKrishnamurthy - 11/06/08 -- Auto Generate Quote No - Begin
        autoGenQuoteNo = ""; //CType.ToString(AppContext.Current.AppSettings["psQuoter.QuoteNo.AutoGenerate"], "");
        if (autoGenQuoteNo == "2")
        {
            disabled = "disabled";
        }
        else
        {
            disabled = "";
        }
        Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
        Response.Write("<tr class=\"t11 tSb\">");
        Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_New_Quote_No")+"</td>");
        Response.Write("<td><input " + disabled + " name=\"txtQuoteNo\" class=\"f w100\" maxlength=\"20\" tabindex=\"1\" value=\"" + sQuoteNo + "\"></td>");
        Response.Write("</tr>");
        Response.Write("</table>");
        Response.Write("<table class=\"tbl\" cellspacing=\"0\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc;\">");
        Response.Write("<tr height=\"20\"  id=\"rshl\" class=\"thc\" >");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkFrmHeader_Search_for_Existing_Quote")+"</td>");
        Response.Write("</tr>");
        Response.Write("</table>");
        Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\" width=\"60\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Look_for")+"&nbsp;</td>");
        Response.Write("<td width=\"100\"><select name=\"cboSField\" class=\"f\">");
        //<CODE_TAG_100705>Wrap into a method
        //<CODE_TAG_100886>

        ////<CODE_TAG_100886>
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.TRG_Get_SearchFilters";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc; 
        cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt,  ADODB.ParameterDirectionEnum.adParamInput, 0,  AppContext.Current.BusinessEntityId));
        cmd.Parameters.Append(cmd.CreateParameter("ViewXUID", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
        rs = new Recordset();
        rs = cmd.Execute();
        blnShowAllQuotes = BitMaskBoolean.IsTrue(rs.Fields["ShowAllQuotesInd"].Value);
        WriteSearchOptions(blnShowAllQuotes, iField.AsString());
        //</CODE_TAG_100705>
        Response.Write("</select></td>");
        Response.Write("<td class=\"t11 tSb\" width=\"25\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_that")+"&nbsp;</td>");
        switch (iOperator) {
            case 2:
                ot2 = "selected";
                break;
            case 0:
                ot0 = "selected";
                break;
            case 1:
                ot1 = "selected";
                break;
        }
        Response.Write("<td width=\"75\"><select name=\"cboSOperator\" class=\"f w100\">");
        Response.Write("<option " + ot2 + " value=\"2\">"+(string) GetLocalResourceObject("rkDrpDownValue_contains"));
        Response.Write("<option " + ot0 + " value=\"0\">"+(string) GetLocalResourceObject("rkDrpDownValue_equals"));
        Response.Write("<option " + ot1 + " value=\"1\">"+(string) GetLocalResourceObject("rkDrpDownValue_starts_with"));
        Response.Write("</select></td>");
        Response.Write("<td width=\"100\"><input name=\"txtSKeyword\" class=\"f w100\" value=\"" + sKeyword + "\" maxlength=50>");
        Response.Write("</td>");
        Response.Write("<td><button class=\"btn\" type=\"button\" style=\"cursor:pointer;\" onclick=\"Search();\">"+(string) GetLocalResourceObject("rkBtn_Search")+"</button>");
        Response.Write("</tr>");
        //Response.Write("<tr height=\"15\"></tr>");
        Response.Write("<tr class=\"t11 tSb\"></tr>");
        Response.Write("</table>");

       
        if (sOperation == "Search")
        {
            SearchDivision = "%";
            //<CODE_TAG_100705>Wrap results into a method
            SearchQuotes(searchLoc_CopyQuote, iField.AsString(), sKeyword, iOperator.ToString(), SearchDivision);
            //</CODE_TAG_100705>
        }

        if (iRecordCount > 0)
        {
            Response.Write("<table class=\"tbl\" cellspacing=\"0\" cellpadding=\"2\" border=\"0\" style=\"border:none\" width=\"100%\" >");

            //HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId")
            //Response.Write("<tr><td style=\"nowrap\" align=\"right\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td></tr>");
            Response.Write("</table>");
        }
                
    }

  
    
%>
<script language="javascript">
<%
    if (!strError.IsNullOrWhiteSpace())
    {
%>
	dispMsg("<%= strError %>", "<%= strLinkText %>", "<%= strLinkUrl %>", "<%= strMsgTitle %>", "<%= strPageTitle %>")
<%
    }
    if (AppContext.Current.User.Operation.CreateQuote && autoGenQuoteNo != "2")
    {
%>
	frmTRG.txtQuoteNo.focus();
<%
    }
%>

function Search(){
	frmTRG.hdnOperation.value = "Search";
	frmTRG.submit();
}

function Sort(sSortField){
	if (frmTRG.hdnSortField.value == sSortField && frmTRG.hdnSortDirection.value == "asc"){
		frmTRG.hdnSortDirection.value = "desc";
	}
	else {
		frmTRG.hdnSortDirection.value = "asc";
	}
		
	frmTRG.hdnSortField.value = sSortField;
	frmTRG.hdnOperation.value = "Search";
	frmTRG.submit();
	
}

function Copy(iQuoteId){
	if (frmTRG.txtQuoteNo.value == "" && "<%= autoGenQuoteNo %>" != "2"){
		alert ("<%=GetLocalResourceObject("rkMsg_You_must_enter_a_New_Quote_No").JavaScriptStringEncode()%>");
		frmTRG.txtQuoteNo.focus();
	}
	else {
		frmTRG.hdnQuoteId.value = iQuoteId;
		frmTRG.hdnOperation.value = "Copy"
		frmTRG.submit();
		
	}
}

function SubmitForm(){
	var i = window.event.keyCode;
	if (i == 13){
		Search()
	}

}
</script>
</form>
</asp:Content>
