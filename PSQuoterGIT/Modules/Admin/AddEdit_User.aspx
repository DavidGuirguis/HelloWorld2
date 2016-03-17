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
    ADODB.CommandClass oCmd = null;
    ADODB.Recordset oRs = null;

    blnRBACEnabled = (AppContext.Current.User.RoleBasedAuthEnabled).As<bool>();
    
     oCmd = new ADODB.CommandClass();
     oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    
    iUserId = CType.ToInt32(Request.QueryString["UserId"], 0);
    if (!String.IsNullOrWhiteSpace(Request.Form["hdnUserId"]))
    {
        iUserId = CType.ToInt32(Request.Form["hdnUserId"], 0);
    }
    //*******************************************************************************************************************
    strOperation = Request.Form["hdnOperation"];
    if (!strOperation.IsNullOrWhiteSpace())
    {
        blnSuccess = false;
            
        if (blnRBACEnabled)
        {
            //RBAC enabled
            blnSuccess = AssignBranches(iUserId.AsString());
        }
        else if( strOperation == "Edit")
        {
            //RBAC disabled
            
            oCmd = new ADODB.CommandClass();
            oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
            oCmd.CommandText = "dbo.TRG_Edit_User";
            oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
            iCreate = 0;
            iWO = 0;
            iDeleteQuotes = 0;
            iAdmin = 0;
            iRepairOptions = 0;
            iWODetails = 0;
            iTRG = 0;
            if (Request.Form["chkCreate"] == "on")
            {
                iCreate = 1;
            }
            if (Request.Form["chkWO"] == "on")
            {
                iWO = 1;
            }
            if (Request.Form["chkDeleteQuotes"] == "on")
            {
                iDeleteQuotes = 1;
            }
            if (Request.Form["chkAdmin"] == "on")
            {
                iAdmin = 1;
            }
            if (Request.Form["chkRepairOptions"] == "on")
            {
                iRepairOptions = 1;
            }
            if (Request.Form["chkWODetails"] == "on")
            {
                iWODetails = 1;
            }
            if (Request.Form["chkTRG"] == "on")
            {
                iTRG = 1;
            }
            if (Request.Form["chkCreateWO"] == "on")
            {
                iCreateWO = 1;
            }
            
            sLogin = Request.Form["hdnLoginName"];
            
            oCmd.Parameters.Append(oCmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iUserId));
            oCmd.Parameters.Append(oCmd.CreateParameter("LoginName", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 30, (sLogin ?? String.Empty).Trim()));
            oCmd.Parameters.Append(oCmd.CreateParameter("CreateQuotes", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iCreate));
            oCmd.Parameters.Append(oCmd.CreateParameter("WOReports", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iWO));
            oCmd.Parameters.Append(oCmd.CreateParameter("DeleteQuotes", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iDeleteQuotes));
            oCmd.Parameters.Append(oCmd.CreateParameter("Admin", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iAdmin));
            oCmd.Parameters.Append(oCmd.CreateParameter("RepairOptions", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iRepairOptions));
            oCmd.Parameters.Append(oCmd.CreateParameter("WODetails", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iWODetails));
            oCmd.Parameters.Append(oCmd.CreateParameter("TRGAccess", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iTRG));
            oCmd.Parameters.Append(oCmd.CreateParameter("CreateWO", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iCreateWO));
            oCmd.Parameters.Append(oCmd.CreateParameter("NewUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, 0));
            oCmd.Parameters.Append(oCmd.CreateParameter("EnterUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
            oCmd.Parameters.Append(oCmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId ));//DefaultBusinessEntityId
            oCmd.Execute();
            iNewUserId = oCmd.Parameters["NewUserId"].Value.As<int?>();
            
            if (iNewUserId != 0)
            {
                iUserId = iNewUserId;
            }
            
            //**********************************************************************************************************
            blnSuccess = true;
                   
                if (iCreate == 1)
                {
                    blnSuccess = AssignBranches(iUserId.As<string>());
                }
           
           Util.CleanUp(cmd);
        }
       
           
        if (blnSuccess)
        {
%>
<script language="javascript" type="text/javascript">
            window.opener.document.location.reload(true)
            window.close();
        </script><%
        }
        else if(!strError.IsNullOrEmpty())
        {
            //Show error details
            Response.Write("<div style=\"color:red;\">" + strMsgTitle + ": " + strError + "</div>");
        }
   
    }
    //*******************************************************************************************************************
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_Get_User";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iUserId));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));//DefaultBusinessEntityId
    rs = new Recordset();
    rs = cmd.Execute();
    if (iUserId != 0)
    {
        sUserName = rs.Fields["FirstName"].Value.As<string>() + " " + rs.Fields["LastName"].Value.As<string>();
        sLoginName = rs.Fields["LoginName"].Value.As<string>();
        iCreate = rs.Fields["CreateQuotes"].Value.As<int?>();
        iWO = rs.Fields["WOReports"].Value.As<int?>();
        iDeleteQuotes = rs.Fields["DeleteQuotes"].Value.As<int?>();
        iAdmin = rs.Fields["Admin"].Value.As<int?>();
        iRepairOptions = rs.Fields["RepairOptions"].Value.As<int?>();
        iWODetails = rs.Fields["WODetails"].Value.As<int?>();
        sUserId = rs.Fields["UserId"].Value.As<int?>();
        iTRG = rs.Fields["TRG"].Value.As<int?>();
        iCreateWO = rs.Fields["CreateWO"].Value.As<int?>();
        rs = rs.NextRecordset();
    }
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" id=\"frmTRG\">");
    Response.Write("<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"400\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
   
    Response.Write("<tr height=\"20\" class=\"thc\" id=\"rshl\" >");
    Response.Write("<td  class=\"t11 tSb\" nowrap align=\"left\">&nbsp;&nbsp;"+(string) GetLocalResourceObject("rkLbl_User_Information")+"</td>");
    Response.Write("<td align=\"right\">"); %>

    <button type="button" class="btn" onclick="Save();"><asp:Localize meta:resourcekey="litLink_Save" runat="server">Save</asp:Localize></button>
   
    <%
    Response.Write("</td>");
    Response.Write("</tr>");
    Response.Write("</table>");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"0\" border=\"0\" width=\"400\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    //***********************************************User Name*****************************************************************
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\" width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_User")+"</td>");
    Response.Write("<td class=\"t11\" width=\"300\" align=\"left\">");
    if (iUserId == 0)
    {
        Response.Write("<a href=\"javascript:void(0);\"  onclick=\"UserSearch();\">" + (string)GetLocalResourceObject("rkbtn_Search") + "");
    }
  
    Response.Write("<span id=\"lblUser\"><b>" + sUserName + "</b></span>");
    Response.Write("</td>");
    Response.Write("</tr>");
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_LoginName")+"</td>");
    Response.Write("<td class=\"t11\" align=\"left\"><span id=\"lblLogin\">" + sLoginName + "</span></td>");
    Response.Write("</tr>");
    if (!blnRBACEnabled)
    {
        //***********************************************Quotes*****************************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Create_Quotes")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkCreate\" type=\"checkbox\" value=\"on\" ");
        if (iCreate != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************WO Reports*****************************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_WO_Reports")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkWO\" type=\"checkbox\" value=\"on\" ");
        if (iWO != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Delete_Quotes")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkDeleteQuotes\" type=\"checkbox\" value=\"on\" ");
        if (iDeleteQuotes != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************Admin*****************************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Manage_Users")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkAdmin\" type=\"checkbox\" value=\"on\" ");
        if (iAdmin != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************Setup RO MOdels******************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Setup_RO_Models")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkRepairOptions\" type=\"checkbox\" value=\"on\" ");
        if (iRepairOptions != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************WorkOrder Details*********************************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Exclude_WO")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkWODetails\" type=\"checkbox\" value=\"on\" ");
        if (iWODetails != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************Access TRG***********************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Access_TRG")+"</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkTRG\" type=\"checkbox\" value=\"on\" ");
        if (iTRG != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
        //***********************************************Create WO***********************************************************
        Response.Write("<tr>");
        Response.Write("<td class=\"t11 tSb\">&nbsp;Create WO</td>");
        Response.Write("<td class=\"t11\">");
        Response.Write("<input name=\"chkCreateWO\" type=\"checkbox\" value=\"on\" ");
        if (iCreateWO != 0)
        {
            Response.Write("checked>");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
    }
    ///RBAC disabled
    Response.Write("</table>");
    //***********************************************Branches*****************************************************************
    Response.Write("<table  class=\"tbl\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"400\" style=\"border: 1px solid #cccccc; background: white;\">");
    Response.Write("<tr height=\"20\" class=\"thc\" id=\"rshl\" >");
    Response.Write("<td  class=\"t11 tSb\" nowrap colspan=\"2\" align=\"left\">&nbsp;&nbsp;"+(string) GetLocalResourceObject("rkLbl_Branches")+"</td>");
    Response.Write("</tr>");
    while(!(rs.EOF))
    {
        sBranchNo = rs.Fields["BranchNo"].Value.As<String>();
        Response.Write("<tr>");
        Response.Write("<td width=\"25\">");
        Response.Write("<input type=\"checkbox\" name=\"chkBranch\"  id=\"chkBranch\" value=\"" + sBranchNo + "\"");
        if (iUserId != 0)
        {
            if ((rs.Fields["Checked"].Value).IsNullOrWhiteSpace() == false)
            {
                Response.Write(" checked ");
            }
        }
        Response.Write(" onclick=\"frmTRG.hdnCheck.value=1;\"></td>");
        Response.Write("<td class=\"t11\">" + sBranchNo + " - " + rs.Fields["BranchName"].Value.As<string>() + "</td>");
        Response.Write("</tr>");
        rs.MoveNext();
    }
    Response.Write("</table><br>");
    //***********************************************Footer*****************************************************************
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"\">");
    Response.Write("<input type=\"hidden\" name=\"hdnCheck\" value=\"1\">");
    Response.Write("<input type=\"hidden\" name=\"hdnLoginName\">");
    Response.Write("<input type=\"hidden\" name=\"hdnUserId\" value=\"" + sUserId + "\">");
    Response.Write("</form>");
    rs.Close();
   
    rs = null;
    Util.CleanUp(cmd);
    
%>
<script language=javascript>
function Save(){

    //var mycheckboxs = document.getElementById("chkBranch");
    var mycheckboxs = frmTRG.chkBranch;
    var txt="false";
    for (i=0;i<mycheckboxs.length;++ i)
        {
                if (mycheckboxs[i].checked) {txt="true";}
	}
    if (txt=="false")
        {
		alert("<%=(string) GetLocalResourceObject("rkMsg_You_must_select_a_user_with_at_least_one_branch")%>");
	}
	else 
        {
		frmTRG.hdnOperation.value = "Edit";
		frmTRG.submit();
		
	}
}

function UserSearch(){
	window.open('<%=this.CreateUrl("modules/admin/User_search.aspx")%>',"opener","scrollbars=yes,menubar=no,toolbar=no,height=300,width=550,left=25,top=25,,resizable=yes")
}

</script><script language="C#" runat="server">

    string sBranch;     
    string [] aBranch = null;
    int R = 0;
    int? iUserId = null;
    int? iCreate = null;
    int? iWO = null;
    int? iDeleteQuotes = null;
    int? iAdmin = null;
    int? iRepairOptions = null;
    int? iWODetails = null;
    int? iTRG = null;
    int? iCreateWO = null;
    string sLogin = null;
    int? iNewUserId = null;
    string sUserName = null;
    string sLoginName = null;
    int? sUserId = null;
    string sBranchNo = null;
    object DBCnnString = null;
    ADODB.Command cmd = null;
    object objParam = null;
    ADODB.Recordset rs = null;
    string strOperation = null;
    string strError = null;
    string strMsgTitle = null;
    string strPageTitle = null;
    bool blnRBACEnabled = false;
    bool blnSuccess = false;
    
    bool AssignBranches(string iUserId) 
    {
        bool AssignBranches = false;
        ADODB.Command cmd = null;
        bool blnSuccess = false;
        blnSuccess = true;
        sBranch = Request.Form["chkBranch"];
        /*NOTE: Manual Fixup - removed Strings.Split(sBranch, ",")*/
        aBranch = sBranch.Split(",", emptyArrayIfNullOrEmpty:true);
        strMsgTitle = (string) GetLocalResourceObject("rkMsg_Cannot_Update_User_Branches");
        strPageTitle = (string) GetLocalResourceObject("rkErrPageTitle_Update_Error");
        if (Information.UBound((Array)aBranch, 1) < 0)
        {
            strError = (string) GetLocalResourceObject("rkMsg_Missing_branches");
            AssignBranches = false;
            return AssignBranches;
        }
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.TRG_Delete_UserBranches";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iUserId));
        cmd.Execute();
        //**********************************************************************************************************
        cmd.Parameters.Clear();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.TRG_Add_UserBranches";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        for(R = Information.LBound(aBranch); R <= Information.UBound(aBranch); R ++)
        {
            /*NOTE: Manual Fixup - removed (Convert.ToString(aBranch[R])).Trim()*/
            sBranchNo = aBranch[R];
            cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iUserId));
            cmd.Parameters.Append(cmd.CreateParameter("BranchNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sBranchNo));
            cmd.Execute();
            cmd.Parameters.Clear();
        }
       
        AssignBranches = blnSuccess;
        return AssignBranches;
    }

</script>
</asp:Content>
