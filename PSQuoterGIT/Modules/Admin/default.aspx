<%@ Page Language="c#" Inherits="UI.Abstracts.Pages.ReportViewPage" MasterPageFile="~/library/masterPages/_base.master"
    IsLegacyPage="true" %>
<%@ Import Namespace="ADODB" %>
<%@ Import Namespace="Microsoft.VisualBasic" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" runat="Server">
    <%
        //Flags
        blnRBACEnabled = AppContext.Current.User.RoleBasedAuthEnabled;
        blnCanAddNew = !blnRBACEnabled;
        blnCanDelete = !blnRBACEnabled;
        
        ModuleTitle = (blnRBACEnabled ? (string) GetLocalResourceObject("rkModTitle_Branch_Customization") : (string) GetLocalResourceObject("rkModTitle_User_Administration"));

        //*******************************************************************************************************************
        strOperation = Request.Form["hdnOperation"];
        if (!strOperation.IsNullOrWhiteSpace())
        {
            if (strOperation == "Delete")
            {
                oCmd = new ADODB.CommandClass();
                oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
                oCmd.CommandText = "TRG_Delete_User";
                oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
                iUserId = Request.Form["hdnUserId"].As<int?>();
                oCmd.Parameters.Append(oCmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iUserId));
                oCmd.Parameters.Append(oCmd.CreateParameter("EnterUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, 0));
                oCmd.Parameters.Append(oCmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
                oCmd.Execute();

                Util.CleanUp(oCmd);
            }
        }
        //*******************************************************************************************************************
        oCmd = new ADODB.CommandClass();
        oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        oCmd.CommandText = "TRG_List_Users";
        oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        oCmd.Parameters.Append(oCmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
        oCmd.Parameters.Append(oCmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
        rs = new Recordset();
        rs = oCmd.Execute();
        iCheck = rs.Fields["AdminCheck"].Value.As<int?>();
        Response.Write("<form method=\"post\" action id=\"frmTRG\">");
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"800\" style=\"border: 1px solid #cccccc; background: #efefef;\">");

        if (iCheck == 0)
        {
            Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">&nbsp;"+(string) GetLocalResourceObject("rkMsg_You_do_not_have_access_to_this_page")+"</font></td></tr>");
        }
        else
        {
            rs = rs.NextRecordset();
            Response.Write("<tr height=\"20\" class=\"thc\" id=\"rshl\" >");
            Response.Write("<td align=\"left\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_User")+"</td>");
            Response.Write("<td align=\"left\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_LoginName")+"</td>");
            if (blnRBACEnabled)
            {
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Branches")+"</td>");
            }
            else
            {
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Create_Quotes")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_WO_Reports")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Delete_Quotes")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Manage_Users")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Setup_RO_Models")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Exclude_WO")+"</td>");
                Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Access_TRG")+"</td>");
                Response.Write("<td>Create WO</td>");
                ///RBAC disabled
            }
            Response.Write("<td align=\"right\" width=\"50\">");
            if (blnCanAddNew)
            {
                Response.Write("<a href=\"javascript:void(0);\" onclick=\"AddEdit('0');\">"+(string) GetLocalResourceObject("rkLink_Add_New")+"</a>");
            }
            Response.Write("</td>");
            Response.Write("</tr>");
            x = 0;

            if (rs.EOF || rs.BOF)
            {
                Response.Write("<tr><td colspan=\"10\" class=\"rl\">"+(string) GetLocalResourceObject("rkMsg_There_is_no_data_available")+"</td></tr>");
            }
            else
            {
                while (!(rs.EOF))
                {
                    iUserId = rs.Fields["UserId"].Value.As<int?>();
                    Response.Write("<tr " + Util.RowClass(x) + " id=\"rsc\">");
                    Response.Write("<td align=\"left\">" + rs.Fields["FirstName"].Value.As<String>() + " " + rs.Fields["LastName"].Value.As<String>() + "</td>");
                    Response.Write("<td align=\"left\">" + rs.Fields["LoginName"].Value.As<String>() + "</td>");
                    if (blnRBACEnabled)
                    {
                        Response.Write("<td align=\"left\">" + rs.Fields["AssignedBranches"].Value.As<String>() + "</td>");
                        ///RBAC enabled
                    }
                    else
                    {
                        Response.Write("<td>" + YesNo(rs.Fields["CreateQuotes"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["WOReports"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["DeleteQuotes"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["Admin"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["RepairOptions"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["WODetails"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["TRG"].Value.As<int>()) + "</td>");
                        Response.Write("<td>" + YesNo(rs.Fields["CreateWO"].Value.As<int>()) + "</td>");
                        ///RBAC disabled
                    }
                    Response.Write("<td width=\"30px\">");



                   // Response.Write(blnCanDelete );
                   // Response.End();
                    Response.Write("<a href=\"javascript:void(0);\" onclick=\"AddEdit('" + iUserId + "');\">" + (string)GetLocalResourceObject("rkLink_Edit") + "</a>&nbsp;&nbsp;&nbsp;&nbsp;");
                    if (blnCanDelete)
                    {
                        Response.Write("<a href=\"javascript:void(0);\" onclick=\"Delete('" + iUserId + "');\">"+(string) GetLocalResourceObject("rkLink_Delete")+"</a>");
                    }
                    Response.Write("</td>");
                    Response.Write("</tr>");
                    x = x + 1;
                    rs.MoveNext();
                }
            }
        }
        Response.Write("</table>");

        Util.CleanUp(oCmd);

        Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"0\">");
        Response.Write("<input type=\"hidden\" name=\"hdnUserId\" value=\"0\">");
        Response.Write("</form>");
    %>
<script language=javascript>
function AddEdit(iUserId){
	window.open("<%=this.CreateUrl("modules/admin/AddEdit_User.aspx", normalizeForAppending:true)%>UserId=" + iUserId,"Opener1","scrollbars=yes,menubar=no,resizable=yes,toolbar=no,height=500,width=450,left=50,top=50")
}


<%
if (blnCanDelete)
{
%>
       function Delete(iUserId)
       {
	      var iConfirm = confirm("<%=(string) GetLocalResourceObject("rkMsg_Are_you_sure_you_want_to_delete_this_user")%>")

	      if (iConfirm == 1)
          {
		     frmTRG.hdnOperation.value = "Delete";
		     frmTRG.hdnUserId.value = iUserId;
		     frmTRG.submit();
	      }
       }
<%
}
%>

    </script>
    <script language="C#" runat="server">

        int? iUserId = null;
        int? iCheck = null;
        ADODB.Command oCmd = null;
        ADODB.Recordset rs = null;
        string strOperation = null;
        bool blnRBACEnabled = false;
        bool blnCanAddNew = false;
        bool blnCanDelete = false;
        int x;



        string YesNo(int sValue)
        {
            string YesNo = null;
            if (sValue == 0)
            {
                YesNo = (string) GetLocalResourceObject("rkLbl_No");
            }
            else
            {
                YesNo = (string) GetLocalResourceObject("rkLbl_Yes");
            }
            return YesNo;
        }

    </script>
</asp:Content>
