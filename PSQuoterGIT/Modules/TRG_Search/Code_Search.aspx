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
    string sCode = null;
    int? iTRG = null;
    string sSortField = null;
    string sSortDirection = null;
    string sField = null;
    string sKeyword = null;
    string sColumn1 = null;
    string sColumn2 = null;
    string sColumn3 = null;
    string o1 = null;
    string o2 = null;
    string o3 = null;
    string o4 = null;
    string o5 = null;
    string o6 = null;
    string o7 = null;
    string o8 = null;
    string o9 = null;
    string o10 = null;
    string sColour = null;
    int iCounter = 0;
    string sField1 = null;
  
    ADODB.Command cmd = null;
   
    ADODB.Recordset rs = null;

    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Code_Lookup");
    sCode = Request.Form["cboField"].As<string>();
    iTRG = Request.QueryString["TRG"].As<int?>();
    sSortField = Request.Form["hdnSortField"];
    sSortDirection = Request.Form["hdnSortDirection"];
    sField = Request.Form["cboField"];
    sKeyword = (Request.Form["txtKeyword"] ?? String.Empty).Trim();
    if (sSortField.IsNullOrWhiteSpace())
    {
        sSortField = "Code";
    }
    if (sSortDirection.IsNullOrWhiteSpace())
    {
        sSortDirection = "asc";
    }
    Response.Write("<form method=\"post\" name=\"frmTRG\">");
    if (!sCode.IsNullOrWhiteSpace())
    {
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "TRG_List_CodeSearch";
        cmd.CommandType =  ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd.Parameters.Append(cmd.CreateParameter("Code", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, sCode));
        cmd.Parameters.Append(cmd.CreateParameter("Value", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 75, sKeyword));
        cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 60, sSortField));
        cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sSortDirection));
        rs = new Recordset();
        rs = cmd.Execute();
        //*********************************************************************************************************************
        switch (sCode) {
            case "J":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Job_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "C":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Comp_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "D":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Modifier_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = (string) GetLocalResourceObject("rkColumn_Category_Code");
                break;
            case "Q":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Quantity_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "L":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Job_Location_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "B":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Business_Group_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "T":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Cat_Type_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "W":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Work_Application_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            case "F":
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Manufacturer_Code");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Description");
                sColumn3 = null;
                break;
            default:
                //M
                sColumn1 = (string) GetLocalResourceObject("rkColumn_Model");
                sColumn2 = (string) GetLocalResourceObject("rkColumn_Family_Code");
                sColumn3 = (string) GetLocalResourceObject("rkColumn_Family_Name");
                break;
        }
    }
    //************************************************Searchbar************************************************************
    if (iTRG != 1)
    {
        ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Job_and_Component_Lookup");
    }
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"background: #efefef;\">");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td width=\"60\" class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl_Look_for")+"</td>");
    Response.Write("<td width=\"130\">");
    if (sField.IsNullOrWhiteSpace())
    {
        sField = "M";
    }
    switch (sField) {
        case "M":
            o1 = " selected ";
            break;
        case "J":
            o2 = " selected ";
            break;
        case "C":
            o3 = " selected ";
            break;
        case "D":
            o4 = " selected ";
            break;
        case "Q":
            o5 = " selected ";
            break;
        case "L":
            o6 = " selected ";
            break;
        case "B":
            o7 = " selected ";
            break;
        case "T":
            o8 = " selected ";
            break;
        case "W":
            o9 = " selected ";
            break;
        case "F":
            o10 = " selected ";
            break;
    }
    Response.Write("<select name=\"cboField\" class=\"f w150\">");
    Response.Write("<option value=\"B\"" + o7 + ">"+(string) GetLocalResourceObject("rkHeader_Business_Group_Codes"));
    Response.Write("<option value=\"T\"" + o8 + ">"+(string) GetLocalResourceObject("rkHeader_Cab_Type_Codes"));
    Response.Write("<option value=\"C\"" + o3 + ">"+(string) GetLocalResourceObject("rkHeader_Component_Codes"));
    Response.Write("<option value=\"J\"" + o2 + ">"+(string) GetLocalResourceObject("rkHeader_Job_Codes"));
    Response.Write("<option value=\"L\"" + o6 + ">"+(string) GetLocalResourceObject("rkHeader_Job_Location_Codes"));
    Response.Write("<option value=\"F\"" + o10 + ">"+(string) GetLocalResourceObject("rkHeader_Manufacturer_Codes"));
    Response.Write("<option value=\"M\"" + o1 + ">"+(string) GetLocalResourceObject("rkHeader_Models_and_Families"));
    Response.Write("<option value=\"D\"" + o4 + ">"+(string) GetLocalResourceObject("rkHeader_Modifier_Codes"));
    Response.Write("<option value=\"Q\"" + o5 + ">"+(string) GetLocalResourceObject("rkHeader_Quantity_Codes"));
    Response.Write("<option value=\"W\"" + o9 + ">"+(string) GetLocalResourceObject("rkHeader_Work_Application_Codes"));
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("<td class=\"t11 tSb\" width=\"75\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl_that_contain")+"</td>");
    Response.Write("<td width=\"210\"><input name=\"txtKeyword\" maxlength=\"75\" class=\"f w200\" value=\"" + sKeyword + "\" title=\""+(string) GetLocalResourceObject("rkToolTip_To_show_all__leave_this_field_blank")+"\"></td>");
    %>
    
     <td><a href="javascript:void(0);" onclick="Search();"><%=(string) GetLocalResourceObject("rkLink_Search")%></a></td>

    
    <%
    Response.Write("</tr>");
    Response.Write("</table>");
    if (!sCode.IsNullOrWhiteSpace())
    {
        //*******************************************************************************************************************
        Response.Write("<table cellspacing=\"10\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border-collapse:separate;border-spacing:1px;\">");
        Response.Write("<tr><td>&nbsp;</td></tr>");
      
        Response.Write("<tr class=\"thc t11b\" height=\"20\" id=\"rsh\">");
        Response.Write("<td align=\"left\" nowrap width=\"135\" onclick=\"Sort('Code');\" style=\"cursor: pointer;\">&nbsp;" + sColumn1 + "</td>");
        Response.Write("<td align=\"left\" nowrap onclick=\"Sort('Description');\" style=\"cursor: pointer;\">&nbsp;" + sColumn2 + "</td>");
        if (!sColumn3.IsNullOrWhiteSpace())
        {
            Response.Write("<td align=\"left\" nowrap onclick=\"Sort('ExtDescription');\" style=\"cursor: pointer;\">&nbsp;" + sColumn3 + "</td>");
        }
        Response.Write("</tr>");
      
        //*********************************************************************************************************************
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
                sField1 = rs.Fields["Code"].Value.As<string>();
                Response.Write("<tr id=\"rsc\" valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");
                Response.Write("<td align=\"left\">");
                if (iTRG == 1 && (sCode == "M" || sCode == "J" || sCode == "C"))
                {
                    Response.Write("<a href=\"#\" onclick=\"Add('" + rs.Fields["Code"].Value.As<string>() + "');\">");
                }
                Response.Write(sField1 + "</a></td>");
                Response.Write("<td align=\"left\">" + rs.Fields["Description"].Value.As<string>() + "</td>");
                if (!sColumn3.IsNullOrWhiteSpace())
                {
                    Response.Write("<td align=\"left\" >" + rs.Fields["ExtDescription"].Value.As<string>() + "</td>");
                }
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
        rs.Close();
      
        rs = null;
        Util.CleanUp(cmd);
       
    }

    Response.Write("<tr><td>");
    Response.Write("<input type=\"hidden\" name=\"hdnSortField\" value=" + sSortField + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnSortDirection\" value=" + sSortDirection + ">");
    Response.Write("</td></tr>");
    Response.Write("</table>");
%>
<script language=javascript>
frmTRG.txtKeyword.focus();

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

function Add(x){
	var sCode = "<%= sCode %>"
	
	if (sCode == "M"){
		window.opener.frmTRG.txtModel.value = x;
	}
	else if (sCode == "J"){
		window.opener.frmTRG.txtJobCode.value = x;
	}
	else if (sCode == "C"){
		window.opener.frmTRG.txtCompCode.value = x;
	}
	window.close();
}


</script>
</asp:Content>
