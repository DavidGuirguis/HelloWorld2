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
    string sColour = null;
    int iCounter = 0;
    string sJobCode = null;
    string sCompCode = null;
    string sModifierCode = null;
    string sQtyCode = null;
    string sJobLocCode = null;
    string sSortDirection = null;
    string strURLPath = null;
    int? iRecordCount = null;

    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Exceptions");
    
   
    int? iPageSize = Request.QueryString["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 10;
    }
    
    
    int?  iStartRecord = Request.QueryString["StartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }
    
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_Exceptions";
    cmd.CommandType =  ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iPageSize));
   
    rs = new Recordset();
    rs = cmd.Execute();
    Response.Write("<form method=\"post\" action= name=\"frmTRG\">");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border-collapse:separate;border-spacing:1px;\">");
  
    Response.Write("<tr height=\"20\" id=\"rsh\" class=\"thc\">");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Records")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\" >&nbsp;"+(string) GetLocalResourceObject("rkHeader_Family")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
    Response.Write("</tr>");

    iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();

    rs = rs.NextRecordset();
    
    
    if (rs.EOF)
    {
        Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
    }
    else
    {
        sColour = "white";
        iCounter = 0;
        while(!(rs.EOF))
        {
            iCounter = iCounter + 1;
            sJobCode = rs.Fields["JobCode"].Value.As<string>();
            sCompCode = rs.Fields["CompCode"].Value.As<string>();
            sModifierCode = rs.Fields["ModifierCode"].Value.As<string>();
            sQtyCode = rs.Fields["QuantityCode"].Value.As<string>();
            sJobLocCode = rs.Fields["JobLocationCode"].Value.As<string>();
            Response.Write("<tr valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");%>
            <td width="40" align="middle"><a href=<%=this.CreateUrl("modules/trg_search/Exception_Details.aspx", normalizeForAppending: true) + "EId=" + rs.Fields["EquipmentId"].Value.As<int?>() + "&JobCode=" + sJobCode + "&CompCode=" + sCompCode + "&Modifier=" + sModifierCode + "&Qty=" + sQtyCode + "&JobLocation=" + sJobLocCode + ">" + rs.Fields["Total"].Value.As<int?>()%></a></td>
           <%
            Response.Write("<td id=\"rsc\">" + rs.Fields["Family"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["Model"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + sJobCode + "</td>");
            Response.Write("<td id=\"rsc\">" + sCompCode + "</td>");
            Response.Write("<td id=\"rsc\" title=\"" + rs.Fields["ModifierDesc"].Value.As<String>() + "\">" + sModifierCode + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["Description"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\" title=\"" + rs.Fields["QtyDesc"].Value.As<String>() + "\">" + sQtyCode + "</td>");
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
        Response.Write("<tr>");
        Response.Write("<td bgColor=" + sColour + " class=\"t11 tSb\" colspan=\"8\" align=\"right\">" + iCounter + "&nbsp;"+(string) GetLocalResourceObject("rkLbl_record"));
        if (iCounter != 1)
        {
            Response.Write("s");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
    }
    Response.Write("</table><br>");
   

   
    if (iRecordCount > 0)
    {
        Response.Write("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"middle\">");

        Response.Write("<tr><td>" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null) + "</td></tr>");
        Response.Write("</table>");
    }
    
  
    Response.Write("</form>");
    rs.Close();
    Util.CleanUp(cmd);
    
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

</script>
</asp:Content>
