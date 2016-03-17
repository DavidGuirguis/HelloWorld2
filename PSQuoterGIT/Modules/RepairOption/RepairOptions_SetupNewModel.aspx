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
   
    int x;
    string sSNBegin = null;
    string sSNEnd = null;
    int I = 0;
    int? iAdminCheck = null;
    string sColour = null;
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    string sModel = null;
    string sOperation = null;
   
    cmd = new ADODB.CommandClass();
  
    //*************************************************************************************************************************

    ModuleTitle = (string) GetLocalResourceObject("rkModuleTitle_Repair_Option_Setup_New_Model");
    
    sOperation = Request.Form["hdnOperation"];
    if (sOperation == "Add" || sOperation == "Delete")
    {
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        if (sOperation == "Add")
        {
            cmd.CommandText = "TRG_Add_RepairOptionModel";
            cmd.Parameters.Append(cmd.CreateParameter("RV", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamReturnValue, 1, 0));
        }
        else
        {
            cmd.CommandText = "TRG_Delete_RepairOptionModel";
        }
        
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        sModel = (Request.Form["hdnModel"] ?? String.Empty).Trim();
        sSNBegin = (Request.Form["hdnSNBegin"] ?? String.Empty).Trim();
        sSNEnd = (Request.Form["hdnSNEnd"] ?? String.Empty).Trim();
        cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sModel));
        cmd.Parameters.Append(cmd.CreateParameter("SerialNoBegin", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sSNBegin));
        cmd.Parameters.Append(cmd.CreateParameter("SerialNoEnd", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sSNEnd));
        
        if (sOperation == "Add")
        {
            cmd.Parameters.Append(cmd.CreateParameter("EnterUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
        }
        
        cmd.Execute();
        Util.CleanUp(cmd);
       
    }
   
    //*************************************************************************************************************************
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_RepairOptions_SetupNewModel";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    sModel = (Request.Form["txtModel"] ?? String.Empty).Trim();
    if (sModel.IsNullOrWhiteSpace())
    {
        sModel = null;
    }
    cmd.Parameters.Clear();
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum. adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sModel));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntity.BusinessEntityId));
    rs = cmd.Execute();
   
    rs = rs.NextRecordset();
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\">");
    
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\" width=60>&nbsp;"+(string) GetLocalResourceObject("rkLabel_Model")+"</td>");
    Response.Write("<td width=\"100\"><input name=\"txtModel\" class=\"f\" maxlength=10 value=\"" + sModel + "\"></td>");
    Response.Write("<td><a href=\"javascript:void(0);\" onclick=\"Search();\">"+(string) GetLocalResourceObject("rkBtnText_Search")+"</a></td>");
    Response.Write("</tr>");
    Response.Write("</table>");
    //**************************************************************************************************************************
    if (sModel.IsNullOrWhiteSpace() == false)
    {
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"450\">");
        if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
        }
        else
        {
            Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
            Response.Write("<td width=\"50\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Make")+"</td>");
            Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
            Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Begin_S_N")+"</td>");
            Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_End_S_N")+"</td>");
            Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Base_S_N")+"</td>");
            Response.Write("<td></td>");
            Response.Write("</tr>");
            sColour = "white";
            x = 1;
            while(!(rs.EOF))
            {
                Response.Write("<tr valign=\"top\" bgColor=\"" + sColour + "\" class=\"t11\">");
                Response.Write("<td>" + rs.Fields["EquipManufCode"].Value.As<string>() + "</td>");
                Response.Write("<td><span id=\"lblModel" + x + "\">" + rs.Fields["Model"].Value.As<string>() + "</span></td>");
                Response.Write("<td><span id=\"lblSNBegin" + x + "\">" + rs.Fields["SerialNoBegin"].Value.As<string>() + "</span></td>");
                Response.Write("<td><span id=\"lblSNEnd" + x + "\">" + rs.Fields["SerialNoEnd"].Value.As<string>() + "</span></td>");
                Response.Write("<td>" + rs.Fields["BaseSerialNo"].Value.As<string>() + "</td>");
                Response.Write("<td>");
                if (rs.Fields["DBSRepairOptionId"].Value.As<int?>() == 0)
                {
                    /*NOTE: Manual Fixup - removed <img src=\"library/images/btnAdd.gif\" class=\"img\" onclick=\"AddDelModel(" + x + ",'Add');\">"*/
                    Response.Write("<button type=\"button\" onclick=\"AddDelModel(" + x + ", 'Add');\">Add</button>");
                }
                else
                {
                    /*NOTE: Manual Fixup - removed <img src=\"library/images/btnDelete.gif\" class=\"img\" onclick=\"AddDelModel(" + x + ",'Delete');>*/
                    Response.Write("<button type=\"button\" onclick=\"AddDelModel(" + x + ", 'Delete');\">Delete</button>");
                    //[<IAranda. 20080623> DeleteRO.]
                }
                Response.Write("</td>");
                Response.Write("</tr>");
                if (sColour == "white")
                {
                    sColour = "#efefef";
                }
                else
                {
                    sColour = "white";
                }
                x = x + 1;
                rs.MoveNext();
            }
        }
        Response.Write("</table><br>");
        rs.Close();
        Util.CleanUp(cmd);
       
    }
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"1\">");
    Response.Write("<input type=\"hidden\" name=\"hdnCheck\" value=\"0\">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("<input type=\"hidden\" name=\"hdnModel\">");
    Response.Write("<input type=\"hidden\" name=\"hdnSNBegin\">");
    Response.Write("<input type=\"hidden\" name=\"hdnSNEnd\">");
    Response.Write("</form>");
%>
<script language="javascript">
frmTRG.txtModel.focus();

function Search(){
	if (frmTRG.txtModel.value == ""){
		alert("<%=GetLocalResourceObject("rkMsg_You_must_enter_a_Model_to_search_for").JavaScriptStringEncode()%>")
		frmTRG.txtModel.focus();
		return false;
	}

	frmTRG.hdnOperation.value = 1
	frmTRG.submit();
}


function AddDelModel(x,sOperation){
	document.all["hdnModel"].value = document.all["lblModel" + x].innerText;
	document.all["hdnSNBegin"].value = document.all["lblSNBegin" + x].innerText;
	document.all["hdnSNEnd"].value = document.all["lblSNEnd" + x].innerText;
	
	frmTRG.hdnOperation.value = sOperation;
	frmTRG.submit();
}

</script>

</asp:Content>
