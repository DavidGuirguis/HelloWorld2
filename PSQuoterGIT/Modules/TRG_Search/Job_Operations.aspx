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
    int? iRepairOptionId = null;
    int? iBranchId = null;
    int? iRLabourHours = null;
    string [] aJobOperationId = null;
    string sJobOperationId = null;
    int R = 0;
    int? iJobOperationId = null;
    int? iJLabourHours = null;
    int? iAdminCheck = null;
    double? iRate = null;
    double? iRAndIRate = 0.0;
    double? iLbrHours = 0.0;
    double? iCost = 0;
    string sColour = null;
    int iCounter = 0;
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
    string sMode = null;
    string sRQuantity = null;
    ADODB.Command cmd = null;
    object objParam = null;
    ADODB.Recordset rs = null;
    string strOperation = null; 
    
    iRepairOptionId = Request.QueryString["ROId"].As<int?>();
    iBranchId = Request.QueryString["BranchId"].As<int?>();
    if (iBranchId.IsNullOrWhiteSpace())
    {
        iBranchId = 10;
    }
    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Job_Operations_For_TRG");
  
    strOperation = Request.Form["hdnOperation"];
    if (!strOperation.IsNullOrWhiteSpace())
    {
        //================================Update Repair Options=======================================================
        if (strOperation == "Edit")
        {
            cmd = new ADODB.CommandClass();
            cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
            cmd.CommandText = "TRG_Edit_RepairOption";
            cmd.CommandType =  ADODB.CommandTypeEnum.adCmdStoredProc;
            iRLabourHours = (Request.Form["txtRHours"] ?? String.Empty).Trim().As<int?>();
            if (iRLabourHours.IsNullOrWhiteSpace())
            {
                iRLabourHours = 0;
            }
            cmd.Parameters.Append(cmd.CreateParameter("RepairOptionId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iRepairOptionId));
            cmd.Parameters.Append(cmd.CreateParameter("LabourHours", ADODB.DataTypeEnum.adDouble, ADODB.ParameterDirectionEnum.adParamInput, 8, iRLabourHours));
            cmd.Execute();
            cmd.Parameters.Clear();
            
                //================================Update Job Operations=======================================================
                cmd = new ADODB.CommandClass();
                cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
                cmd.CommandText = "TRG_Edit_JobOperation";
                cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
                sJobOperationId = Request.Form["hdnJobOperationId"].As<string>();
                aJobOperationId = Strings.Split(sJobOperationId, ",");
                for(R = 0; R < aJobOperationId.Length; R += 1)
                {
                    iJobOperationId = aJobOperationId[R].Trim().As<int?>();
                    iJLabourHours = (Request.Form["txtJHours" + iJobOperationId] ?? String.Empty).Trim().As<int?>();
                    if (iJLabourHours.IsNullOrWhiteSpace())
                    {
                        iJLabourHours = 0;
                    }
                    cmd.Parameters.Append(cmd.CreateParameter("JobOperationId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iJobOperationId));
                    cmd.Parameters.Append(cmd.CreateParameter("LabourHours", ADODB.DataTypeEnum.adDouble, ADODB.ParameterDirectionEnum.adParamInput, 8, iJLabourHours));
                    cmd.Execute();
                    cmd.Parameters.Clear();
                   
                }
            
            Util.CleanUp(cmd);
        }
    }
    //===============================================================================================================
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_JobOperation";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.Parameters.Append(cmd.CreateParameter("RepairOptionId", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 4, iRepairOptionId));
    cmd.Parameters.Append(cmd.CreateParameter("BranchId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 2, iBranchId));
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
    rs = cmd.Execute();
    iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>();
    rs = rs.NextRecordset();
    iRate = rs.Fields["SVLRate"].Value.As<double?>();
    iRAndIRate = rs.Fields["RAndIRate"].Value.As<double?>();
    rs = rs.NextRecordset();
    //******************************************Header********************************************************************
    Response.Write("<form name=\"frmTRG\" method=\"post\">");
   
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\" width=\"110\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
    Response.Write("<td class=\"t11\">" + rs.Fields["Model"].Value.As<string>() + "</td>");
    Response.Write("<td class=\"t11 tSb\" width=\"110\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Quantity")+"</td>");
    Response.Write("<td class=\"t11\">" + rs.Fields["Quantity"].Value.As<string>() + "</td>");
    Response.Write("</tr>");

    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job_Code")+"</td>");
    Response.Write("<td class=\"t11\">" + rs.Fields["JobCode"].Value.As<string>() + "</td>");
    Response.Write("<td class=\"t11 tSb\" width=\"110\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Hours")+"</td>");

    iLbrHours = rs.Fields["LaborHours"].Value.As<double?>();
    Response.Write("<td class=\"t11\">");
    if (iAdminCheck == 1)
    {
        Response.Write("<input class=\"f w50\" name=\"txtRHours\" value=\"" + iLbrHours + "\" style=\"text-align:right;\" />");
    }
    else
    {
        Response.Write(iLbrHours);
    }
    Response.Write("</td>");
    Response.Write("</tr>");
    
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Component_Code")+"</td>");
    Response.Write("<td class=\"t11\">" + rs.Fields["CompCode"].Value.As<String>() + "</td>");
    Response.Write("<td class=\"t11 tSb\" width=\"110\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Sell")+"</td>");
    if (rs.Fields["JobCode"].Value.As<String>() == "010")
    {
        iCost = iLbrHours * iRAndIRate;
    }
    else
    {
        iCost = iLbrHours * iRate;
    }
    if (iCost.IsNullOrWhiteSpace())
    {
        iCost = 0.0;
    }
    Response.Write("<td class=\"t11\">" + Util.NumberFormat(iCost, 2, null, null, null) /*NOTE: Manual Fixup - removed Strings.FormatNumber(iCost, 2, TriState.True, TriState.True)*/ + "</td>");
    Response.Write("</tr>");

    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Modifier_Code")+"</td>");
    Response.Write("<td class=\"t11\">" + rs.Fields["ModifierCode"].Value.As<string>() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
    Response.Write("<td class=\"t11\" colspan=\"3\">" + rs.Fields["JobDesc"].Value.As<string>() + " " + rs.Fields["CompDesc"].Value.As<string>() + " " + rs.Fields["ModifierDesc"].Value.As<string>() + " " + rs.Fields["LocationDesc"].Value.As<string>() + " " + rs.Fields["QuantityDesc"].Value.As<string>() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr valign=\"top\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Notes")+"</td>");
    Response.Write("<td class=\"t11\" colspan=\"3\">" + rs.Fields["Notes"].Value.As<string>() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr valign=\"top\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Additional_Notes")+"</td>");
    Response.Write("<td class=\"t11\" colspan=\"3\">" + rs.Fields["AddNotes"].Value.As<string>() + "</td>");
    Response.Write("</tr>");
    if (iAdminCheck == 1)
    {
        Response.Write("<tr><td><button class=\"btn\" type=\"button\" onclick=\"Save();\">"+(string) GetLocalResourceObject("rkbtn_Save")+"</button></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>");
    }
    Response.Write("</table><br>");
    //*****************************************************************************************************************
    rs = rs.NextRecordset();
    if (iAdminCheck == 1)
    {
        Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"0\" style=\"border:none\"  border=\"0\" width=\"100%\">");
    }
    else
    {
        Response.Write("<table class=\"tbl\" style=\"border:none\"  cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    }
    if (rs.EOF)
    {
        Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
    }
    else
    {
        Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\" >");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Hours")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Sell")+"</td>");
        Response.Write("</tr>");
        sColour = "white";
        iCounter = 0;
        while(!(rs.EOF))
        {
            iCounter = iCounter + 1;
            iLbrHours = rs.Fields["LaborHours"].Value.As<double?>();
            iNotes = rs.Fields["Notes"].Value.As<int?>();
            sRJobCode = rs.Fields["JobCode"].Value.As<string>();
            sRCompCode = rs.Fields["CompCode"].Value.As<string>();
            sRModifierCode = rs.Fields["ModifierCode"].Value.As<string>();
            sRModifierDesc = rs.Fields["ModifierDesc"].Value.As<string>();
            sRQuantityCode = rs.Fields["QuantityCode"].Value.As<string>();
            sRQuantityDesc = rs.Fields["QuantityDesc"].Value.As<string>();
            sRJobLocationCode = rs.Fields["JobLocationCode"].Value.As<string>();
            sRDesc = rs.Fields["JobDesc"].Value.As<string>() + " " + rs.Fields["CompDesc"].Value.As<string>() + " " + rs.Fields["ModifierDesc"].Value.As<string>() + " " + rs.Fields["LocationDesc"].Value.As<string>() + " " + sRQuantityDesc;
            sRepairOption = sRJobCode + sRCompCode;
            
            if (sRJobCode == "010")
            {
                iCost = iLbrHours * iRAndIRate;
            }
            else
            {
                iCost = iLbrHours * iRate;
            }
            if (iCost.IsNullOrWhiteSpace())
            {
                iCost = 0.0;
            }
            
            //==========================================Job Operation Row==============================================
            iJobOperationId = rs.Fields["JobOperationId"].Value.As<int?>();
            Response.Write("<tr class=\"t11\"  bgColor=" + sColour + ">");
            if (sMode == "Add")
            {
                Response.Write("<td><input type=\"checkbox\" name=\"chkInclude\" id=chkInclude" + iCounter + "></td>");
            }
            Response.Write("<td width=\"25\"><span id=spnJob" + iCounter + ">" + sRJobCode + "</span></td>");
            Response.Write("<td width=\"40\"><span id=spnComp" + iCounter + ">" + sRCompCode + "</span></td>");
            Response.Write("<td width=\"50\" align=\"middle\" title=\"" + sRModifierDesc + "\">" + sRModifierCode + "</td>");
            Response.Write("<td><span id=spnDesc" + iCounter + ">" + sRDesc + "</span></td>");
            Response.Write("<td width=\"25\" align=\"middle\" title=\"" + sRQuantityDesc + "\"><span id=spnQty" + iCounter + ">" + sRQuantityCode + "</span></td>");
            Response.Write("<td width=\"40\" align=\"middle\">");
            
            if (iAdminCheck == 1)
            {
                Response.Write("<input class=\"f w50\" name=\"txtJHours" + iJobOperationId + "\" id=\"txtJHours" + iCounter + "\" value=\"" + iLbrHours + "\" style=\"text-align:right;\">");
            }
            else
            {
                Response.Write(iLbrHours);
            }
            
            Response.Write("</td>");
            Response.Write("<td width=\"50\" align=\"right\"><span id=spnCost" + iCounter + ">" + Util.NumberFormat(iCost, 2, null, null, null) /*NOTE: Manual Fixup - removed Strings.FormatNumber(iCost, 2, TriState.True, TriState.True)*/ + "</span></td>");
            Response.Write("<td width=\"10\" bgColor=\"white\">");
            Response.Write("<input type=\"hidden\" name=\"hdnQty" + iCounter + "\" value=\"" + sRQuantity + "\" />");
            Response.Write("<input type=\"hidden\" name=\"hdnMod" + iCounter + "\" value=\"" + sRModifierCode + "\" />");
            Response.Write("<input type=\"hidden\" name=\"hdnJobLoc" + iCounter + "\" value=\"" + sRJobLocationCode + "\" />");
            Response.Write("<input type=\"hidden\" name=\"hdnJobOperationId\" value=\"" + iJobOperationId + "\" />");
            if (iNotes > 0)
            {
                Response.Write("<img src=\"library/images/btnAttachNote.gif\" title=\"Notes\" onclick=\"ViewNotes('" + rs.Fields["Id"].Value.As<String>() + "');\">");
            }
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
    Util.CleanUp(cmd);
    Response.Write("</table><br>");
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\">");
    Response.Write("</form>");
%>
<script language=javascript>

function ViewNotes(iJobOperationId)
{
	window.open('<%=this.CreateUrl("modules/trg_search/Notes.aspx")%>&TT=Popup&JobOperationId=' + iJobOperationId,"Opener1","scrollbars=yes,menubar=no,toolbar=no,height=300,width=400,left=100,top=200")
}


function Save(){
	var x = 0
	for(q=1; q <= "<%=iCounter%>"; q++){			
		x = x + parseInt(document.all["txtJHours" + q].value);
	}
	
	var i = true
	if (x != document.all["txtRHours"].value){
		i = confirm("<%=GetLocalResourceObject("rkMsg_Do_you_want_to_continue").JavaScriptStringEncode()%>");
	}
	
	if (i){
		frmTRG.hdnOperation.value = "Edit";
		frmTRG.submit();
		
	}
}


</script>
</asp:Content>
