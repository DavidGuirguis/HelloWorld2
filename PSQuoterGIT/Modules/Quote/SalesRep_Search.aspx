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
    string sFName = null;/*DONE:review if it's right type - was 'object'*/
    string sLName = null;/*DONE:review if it's right type - was 'object'*/
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    string strOperation = null;/*DONE:review if it's right type - was 'object'*/
    string strError = null;/*DONE:review if it's right type - was 'object'*/
    int? intReturnValue = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
    int x = 0;/*DONE:review - check if it's using correct type*/
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_QuoteUsers";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/;
    rs = new Recordset();
    rs = cmd.Execute();
    Response.Write("<form method=\"post\" action name=\"frmTRG\" id=\"frmTRG\" onkeyup=\"SubmitForm();\">");
    Response.Write("<table border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<tr height=\"22\" class=\"thc t11b\">");
    Response.Write("<td>&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_FirstName")+"</td>");
    Response.Write("<td>&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_LastName")+"</td>");
    Response.Write("<td></td>");
    Response.Write("</tr>");

    if (rs.EOF == false)
    {
        x = 0;
        while(!(rs.EOF))
        {
            sFName = rs.Fields["FirstName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type*/;
            sLName = rs.Fields["LastName"].Value.As<string>()/*DONE:review data type conversion - convert to proper type*/;
            Response.Write("<tr " + Util.RowClass(x) + ">");
            Response.Write("<td>" + sFName/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "</td>");
            Response.Write("<td>" + sLName/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "</td>");
%>
				
    	<td width="40">
            <input type="button" value="<%= (string)GetLocalResourceObject("rkHeaderText_Add")%>" onclick="AddSR('<%= rs.Fields["UserId"].Value.As<int?>()/*DONE:review data type conversion - convert to proper type*/ %>','<%= Server.HtmlEncode(sFName) %>','<%= Server.HtmlEncode(sLName) %>','<%= Server.HtmlEncode(rs.Fields["OfficePhone"].Value.As<string>()) %>');"/>
    	</td>
<%
            Response.Write("</tr>");
            rs.MoveNext();
            x = x + 1;
        }
    }
    Response.Write("</table>");
    Response.Write("<br>");
    rs.Close();

    rs = null;
    Util.CleanUp(cmd: cmd);

    /*NOTE: Stray </table> in Safari: Response.Write("</table>")*/
    Response.Write("</form>");
%>
<script language="javascript"><!--

function AddSR(iUserId, sFName, sLName, sPhoneNo){
	window.opener.document.all["hdnSRUserId"].value = iUserId;
	window.opener.document.all["txtSalesRep"].value = sFName + ' ' + sLName;
    window.opener.document.all["txtSRPhoneNo"].value = sPhoneNo;

	window.close();
	window.opener.document.all["txtWorkOrderNo"].focus();
	window.opener.document["frmTRG"].getElementById("txtWorkOrderNo").focus();
	window.parent.document.frmTRG.txtWorkOrderNo.focus();
}
//-->
</script>
</asp:Content>
