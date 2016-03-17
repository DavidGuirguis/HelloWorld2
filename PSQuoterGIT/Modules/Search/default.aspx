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
<!--#include file="inc_search.aspx"-->
<%
    string sKeyword = null;
    ADODB.Recordset rs = null;
    string SearchDivision = null;
    int? iColSpan = null;
   
    ModuleTitle = (string) GetLocalResourceObject("rkModuleTitle_Search__Quote");

    sKeyword = Request.QueryString["keyword"];
    if (sKeyword.IsNullOrWhiteSpace())
    {
        sKeyword = null;
    }
    i = Request.QueryString["F"];
    KeywordType = Request.QueryString["KeywordType"];
    SearchDivision = CType.ToString(Request.QueryString["SearchDivision"], "%");
    Response.Write("<form method=\"post\" name=\"frmTRG\">");
    //<CODE_TAG_100705>Wrap search quotes into a method
    SearchQuotes(searchLoc_SearchBar, KeywordType, sKeyword, Request.QueryString["OperatorType"], SearchDivision);
    //</CODE_TAG_100705>
    //Response.Write("</table><br>");
    
    Response.Write("</form>");
%>
<script language=javascript>

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

</script>
</asp:Content>
