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
    int? iSearch = null;
    int? iVariance = null;
    int? iStartRecord = null;
    int? iPageSize = null;
    int? iRecordCount = null;
    string sColour = null;
    int iCounter = 0;
    string sModel = null;
    double? iLbrHours = 0;
    int? iNotes = null;
    string sRJobCode = null;
    string sRCompCode = null;
    string sRModifierCode = null;
    string sRModifierDesc = null;
    string sRQuantityCode = null;
    string sRQuantityDesc = null;
    string sRJobLocationCode = null;
    string sRDesc = null;
    string sRepairOption = null;
    string sRQuantity = null;
    double? iAvgLbrHours = 0;
    int? iROId = null;
    int? iRAndIRate = 0;
    int iCost = 0;
    int? iRate = 0;
    string sMode = null;
    int x;
    string scolspan;
    int iBranchId = 0;
   
    
    ADODB.Command cmd = null;
  
    ADODB.Recordset rs = null;

    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_TRG_WO_Variance");
    iSearch = Request.Form["hdnOperation"].As<int?>();
    /*NOTE: Manual Fixup - removed (Request.Form["txtVariance"] ?? String.Empty).As<int?>()*/
    iVariance = Request.Form["txtVariance"].As<int?>();

    if (iVariance.IsNullOrWhiteSpace())
    {
        iVariance = 100;
    }
    scolspan = "12";
    
    //*************************************************************************************************************************
    if (iSearch == 1)
    {
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "TRG_List_TRGWOVarianceSearch";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();

        if (iStartRecord.IsNullOrWhiteSpace())
        {
            iStartRecord = 1;
        }
        iPageSize = (Request.Form["RecordNo"]).As<int?>();
        if (iPageSize.IsNullOrWhiteSpace())
        {
            iPageSize = 50;
        }
        cmd.Parameters.Append(cmd.CreateParameter("Variance", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iVariance));
        cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iStartRecord));
        cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iPageSize));
        cmd.CommandTimeout = 20000;
        rs = new Recordset();
        rs = cmd.Execute();
    }
    //*******************************Header*********************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\" onkeyup=\"SubmitForm();\">");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    Response.Write("</table>");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\" width=75>"+(string) GetLocalResourceObject("rkLbl_Variance")+"</td>");
    Response.Write("<td><input name=\"txtVariance\" class=\"f w75\" value=\"" + iVariance + "\" maxlength=\"10\" tabindex=\"4\"></td>");
    Response.Write("</tr>");
    Response.Write("<tr><td colspan=\"2\">");
    Response.Write("<button type=\"button\" class=\"btn\" onclick=\"Search();\">&nbsp;"+(string) GetLocalResourceObject("rkLink_Search")+"</button>");
    Response.Write("</td></tr>");
    Response.Write("</table>");
    
    //*******************************Search Results********************************************************************
    if (iSearch == 1)
    {
        iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
        rs = rs.NextRecordset();
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
        if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
        }
        else
        {
            Response.Write("<tr height=\"20\" id=\"rsh\" class=\"thc t11b\">");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_TRG_br_Hours")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_TRG_br_Sell")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_No_of_br_WO_Seg")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Avg_WO_Hours")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Avg_WO_br_Sell")+"</td>");
            Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Variance")+"</td>");
            Response.Write("</tr>");
            sColour = "white";
            iCounter = 0;
            while(!(rs.EOF))
            {
                iCounter = iCounter + 1;
                sModel = rs.Fields["Model"].Value.As<string>();
                iLbrHours = rs.Fields["LaborHours"].Value.As<double?>();

                if (iLbrHours.IsNullOrWhiteSpace())
                {
                    iLbrHours = 0;
                }
                iNotes = rs.Fields["Notes"].Value.As<int?>();
                sRJobCode = rs.Fields["RJobCode"].Value.As<string>();
                sRCompCode = rs.Fields["RCompCode"].Value.As<string>();
                sRModifierCode = rs.Fields["RModifierCode"].Value.As<string>();
                sRModifierDesc = rs.Fields["RModifierDesc"].Value.As<string>();
                sRQuantityCode = rs.Fields["RQuantityCode"].Value.As<string>();
                sRQuantityDesc = rs.Fields["RQuantityDesc"].Value.As<string>();
                sRJobLocationCode = rs.Fields["RJobLocationCode"].Value.As<string>();
                sRDesc = rs.Fields["RJobDesc"].Value.As<string>() + " " + rs.Fields["RCompDesc"].Value.As<string>() + " " + rs.Fields["RModifierDesc"].Value.As<string>() + " " + rs.Fields["RLocationDesc"].Value.As<string>();
                sRepairOption = sRJobCode + sRCompCode;
                sRQuantity = rs.Fields["Quantity"].Value.As<string>();
                iAvgLbrHours = rs.Fields["AvgLbrHours"].Value.As<double?>();
              
                if(iAvgLbrHours == null)
                {
                    x = 0;
                }
                else
                {
                    x = 1;
                }

                iROId = rs.Fields["RepairOptionId"].Value.As<int?>();

                if (iAvgLbrHours.IsNullOrWhiteSpace())
                {
                    iAvgLbrHours = 0;
                }

                if (sRJobCode == "010")
                {
                    iCost = (int) (iLbrHours * iRAndIRate);
                }
                else
                {
                    iCost = (int) (iLbrHours * iRate);
                }

                if (iCost.IsNullOrWhiteSpace())
                {
                    iCost = 0;
                }
                
                //==========================================Repair Option Row==============================================
                
                Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=" + sColour + ">");
                if (sMode == "Add")
                {
                    Response.Write("<td width=5><input type=\"checkbox\" name=\"chkInclude\" id=chkInclude" + iCounter + "></td>");
                    Response.Write("<td width=\"50\">"); %>
                    <a href="<%=this.CreateUrl("modules/trg_search/job_operations.aspx", normalizeForAppending: true) + "ROId=" + iROId%>"></a>
             <% }
                else
                {
                    Response.Write("<td width=\"50\">");%>
                   <a href="<%=this.CreateUrl("modules/trg_search/job_operations.aspx", normalizeForAppending: true) + "ROId=" + iROId%>"></a>
              <%}
                Response.Write(sModel+ "</td>");
                Response.Write("<td width=\"25\">" + sRJobCode + "</td>");
                Response.Write("<td width=\"40\">" + sRCompCode + "</td>");
                Response.Write("<td width=\"50\" align=\"middle\" title=\"" + sRModifierDesc + "\">" + sRModifierCode + "</td>");
                Response.Write("<td><span id=spnDesc" + iCounter + ">" + sRDesc + "</span></td>");
                Response.Write("<td width=\"25\" align=\"middle\" title=\"" + sRQuantityDesc + "\">" + sRQuantityCode + "</td>");
                if (x == 1)
                {
                    Response.Write("<td width=\"40\" align=\"middle\">" + Util.NumberFormat(iLbrHours, 1, null, null, null) + "</td>");
                    Response.Write("<td width=\"50\" align=\"right\"><span id=spnCost" + iCounter + ">" + Util.NumberFormat(iCost, 2, null, null, null) + "</span></td>");
                    Response.Write("<td width=\"50\" align=\"middle\">" + rs.Fields["TotalWOSeg"].Value.As<string>() + "</td>");
                    Response.Write("<td width=\"50\" align=\"middle\">");
                    
                    %>
                    
                    <a href='<%= this.CreateUrl("modules/TRG_Search/WO_Details.aspx", normalizeForAppending:true) + "Model=" + Server.UrlEncode(sModel) + "&Job=" + Server.UrlEncode(sRJobCode) + "&Comp=" + Server.UrlEncode(sRCompCode) + "&Desc=" + Server.UrlEncode(sRDesc) %>' >
                 <% 
                    Response.Write(Util.NumberFormat(iAvgLbrHours, 1, null, null, null)+ "</a></td>");
                    Response.Write("<td width=\"75\" align=\"right\">" + Util.NumberFormat(rs.Fields["AvgWOTotal"].Value.As<double?>(), 2, null, null, null) + "</td>");
                    Response.Write("<td width=\"50\" align=\"middle\"><font color=\"red\">" + Util.NumberFormat(iLbrHours - iAvgLbrHours, 2, null, null, null) + "</font></td>");
                }
                else
                {
                    Response.Write("<td width=\"40\" align=\"middle\">" + Util.NumberFormat(iLbrHours, 1, null, null, null) + "</td>");
                    Response.Write("<td width=\"50\" align=\"right\"><span id=spnCost" + iCounter + ">" + Util.NumberFormat(iCost, 2, null, null, null) + "</span></td>");
                    Response.Write("<td width=\"50\" align=\"middle\"></td>");
                    Response.Write("<td width=\"50\" align=\"middle\"></td>");
                    Response.Write("<td width=\"75\" align=\"middle\"></td>");
                    Response.Write("<td width=\"50\" align=\"middle\"></td>");
                }
                Response.Write("<td width=\"10\" bgColor=" + sColour + ">");
                Response.Write("<input type=\"hidden\" name=\"hdnQty" + iCounter + "\" value=\"" + sRQuantity + "\">");
                Response.Write("<input type=\"hidden\" name=\"hdnMod" + iCounter + "\" value=\"" + sRModifierCode + "\">");
                Response.Write("<input type=\"hidden\" name=\"hdnJobLoc" + iCounter + "\" value=\"" + sRJobLocationCode + "\">");
                Response.Write("<input type=\"hidden\" name=\"hdnRepairOptionId" + iCounter + "\" value=\"" + iROId + "\">");
                if (iNotes > 0)
                {%>
                    <button class="btn" type="button" onclick="ViewNotes('<%=rs.Fields["RepairOptionId"].Value.As<string>()%>');" ><asp:Localize meta:resourcekey="rkButtonText_Notes" runat="server">Notes</asp:Localize></button>
               <% }
                
                Response.Write("</td>");
                Response.Write("</tr>");
                //==========================================================================================================
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
         
           
        }
        rs.Close();
        Util.CleanUp(cmd: cmd);
      
        Response.Write("</table><br>");
        if (iRecordCount > 0)
        {
            Response.Write("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"middle\">");

            Response.Write("<tr><td>" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td></tr>");
            Response.Write("</table>");
        }
    }
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"0\">");
    Response.Write("<input type=\"hidden\" name=\"hdnCheck\" value=\"0\">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("</form>");
%>


<script language="javascript">
frmTRG.txtVariance.focus();

function Search(){
	var iCancel = 0
	
	if (frmTRG.txtVariance.value == 0 || frmTRG.txtVariance.value == "")
    {
		alert("<%=GetLocalResourceObject("rkMsg_You_must_enter_a_Variance_to_search_for").JavaScriptStringEncode()%>")
		frmTRG.txtVariance.focus();
		iCancel = 1
	}

	if (iCancel != 1){
		frmTRG.hdnOperation.value = 1
		frmTRG.submit();
		
	}
}

function ViewNotes(iRepairOptionId){
	window.open('<%=this.CreateUrl("modules/trg_search/Notes.aspx", normalizeForAppending:true )%>RepairOptionId=' + iRepairOptionId,"Opener1","scrollbars=yes,menubar=no,toolbar=no,height=300,width=400,left=100,top=200")
}

function SubmitForm(){
	var i = window.event.keyCode;
	if (i == 13){
		Search()
	}

}
</script>
</asp:Content>
