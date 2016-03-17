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
    int? iNew = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int? iSearchField = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    int Id = 0;/*DONE:review - check if it's using correct type*/
    string sFName = null;/*DONE:review if it's right type - was 'object'*/
    string sLName = null;/*DONE:review if it's right type - was 'object'*/
    string sLoginName = null;/*DONE:review if it's right type - was 'object'*/
    int? sUserID = null;
    int x = 0;/*DONE:review - check if it's using correct type*/
   

    ADODB.CommandClass oCmd = null;
    ADODB.Recordset oRs = null;
    
    oCmd = new ADODB.CommandClass();
    oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    sKeyword = (Request.Form["txtKeyword"] ?? String.Empty).Trim();
    iNew = Request.QueryString["New"].As<int?>();
    if (!sKeyword.IsNullOrWhiteSpace())
    {
        oCmd = new ADODB.CommandClass();
        oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        oCmd.CommandText = "TRG_List_UserSearch";
        oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        iSearchField = Request.Form["cboSearchField"].As<int?>();
        oCmd.Parameters.Append(oCmd.CreateParameter("SearchField", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iSearchField));
        oCmd.Parameters.Append(oCmd.CreateParameter("SearchValue", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 50, sKeyword));
        oRs = new Recordset();
        oRs = oCmd.Execute();
    }
    Response.Write("<form method=\"post\" action id=\"frmTRG\">");
    Response.Write("<div style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<table height=\"50\" cellpadding=\"4\" cellspacing=\"0\" border=\"0\">");
    Response.Write("<tr><td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkLbl_Look_for")+"&nbsp;&nbsp;</td>");
    Response.Write("<td><select accesskey=\"a\" class=\"f\" name=\"cboSearchField\" id=\"cboSearchField\">");
    Response.Write("<option value=\"1\" ");
    if (iSearchField == 1)
    {
        Response.Write(" selected");
    }
    Response.Write(">"+(string) GetLocalResourceObject("rkLbl_First_Name"));
    Response.Write("<option value=\"2\" ");
    if (iSearchField == 2)
    {
        Response.Write(" selected");
    }
    Response.Write(">"+(string) GetLocalResourceObject("rkLbl_Last_Name"));
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkLbl_that_contains")+"&nbsp;&nbsp;</td>");
    Response.Write("<td><input name=\"txtKeyword\" maxlength=\"50\" class=\"f w200\" value=\"" + sKeyword + "\"></td>");
    Response.Write("</tr>");
    Response.Write("<tr><td colspan=\"3\"></td>");
    Response.Write("<td align=\"right\">"); %>
     <a href="javascript:void(0);" onclick="Search();"><asp:Localize meta:resourcekey="litLink_Search" runat="server">Search</asp:Localize></a>
    <%
    Response.Write("</td></tr>");
    Response.Write("</table>");
    Response.Write("</div>");
    Response.Write("<br><br>");
    Response.Write("<table class=\"tbl\" border=\"0\" style=\"border:1px solid #cccccc;\" width=\"100%\">");
    Response.Write("<tr height=\"22\" id=\"rsh\" class=\"t11 tSb\">");
    Response.Write("<td nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl1_First_Name")+"</td>");
    Response.Write("<td nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl1_Last_Name")+"</td>");
    Response.Write("<td nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl_Login_Name")+"</td>");
    if (sKeyword.IsNullOrWhiteSpace())
    {
        Response.Write("</tr>");
    }
    else
    {
        Response.Write("<td id=\"rsh\"></td></tr>");
        if (oRs.EOF)
        {
            Response.Write("<tr><td colspan =\"4\" class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkMsg_No_Employees_found")+"</td></tr>");
        }
        else
        {
            x = 0;
            while(!(oRs.EOF))
            {
                Id = x;
                sFName = oRs.Fields["FirstName"].Value.As<string>();
                sLName = oRs.Fields["LastName"].Value.As<string>();
                sLoginName = oRs.Fields["LoginName"].Value.As<string>();
                sUserID = oRs.Fields["UserId"].Value.As<int?>();
                Response.Write("<tr " + Util.RowClass(x) + ">");
                Response.Write("<td>" + sFName + "</td>");
                Response.Write("<td>" + sLName + "</td>");
                Response.Write("<td>" + sLoginName + "</td>");
                //rw "<td>" & sUserID & "</td>"
                Response.Write("<td width=40><button type= \"button\" class = \"btn\" onclick=\"Add('" + Id + "', '" + oRs.Fields["UserId"].Value.As<string>() + "')\";>"+(string) GetLocalResourceObject("rkBtn_Text_Add")+"</button>");
                Response.Write("<input type=hidden name=\"hdnFName" + Id + "\"value=\"" + sFName + "\">");
                Response.Write("<input type=hidden name=\"hdnLName" + Id + "\" value=\"" + sLName + "\">");
                Response.Write("<input type=hidden name=\"hdnLoginName" + Id + "\" value=\"" + oRs.Fields["LoginName"].Value.As<string>() + "\">");
                Response.Write("<input type=hidden name=\"hdnUserId" + Id + "\" value=\"" + oRs.Fields["UserId"].Value.As<string>() + "\">");
                Response.Write("</td></tr>");
                oRs.MoveNext();
                x = x + 1;
            }
        }
        oRs.Close();
      
       Util.CleanUp(oCmd);
       
    }
    Response.Write("</table>");
    Response.Write("</form>");
%>
<script language="javascript">

frmTRG.txtKeyword.focus();

function Add(id, userid) {
	//<CODE_TAG_103543> Dav
	if (window.parent.curUserFinder != null) {
		window.parent.curUserFinder.setUser(userid, document.all["hdnFName" + id].value + " " + document.all["hdnLName" + id].value)
		return;
	}
	//</CODE_TAG_103543> Dav

	window.opener.document.all["lblUser"].innerHTML = document.all["hdnFName" + id].value + ' ' + document.all["hdnLName" + id].value;
	window.opener.document.all["lblLogin"].innerHTML = document.all["hdnLoginName" + id].value;
	window.opener.document.all["hdnLoginName"].value = document.all["hdnLoginName" + id].value;
	window.opener.document.all["hdnUserId"].value = userid;
	window.close();		
}

function Search(){
	if (frmTRG.txtKeyword.value == ""){
		alert("<%=(string) GetLocalResourceObject("rkMsg_You_must_enter_a_Keyword_to_search_for")%>")
		frmTRG.txtKeyword.focus();
	}
	else {
		frmTRG.submit()
		
	}
}


</script>
</asp:Content>
