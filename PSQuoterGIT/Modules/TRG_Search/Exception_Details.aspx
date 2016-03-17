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
    int? iEquipmentId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
    string sJobCode = null;/*DONE:review - check if it's using correct type*/
    string sCompCode = null;/*DONE:review - check if it's using correct type*/
    string sModifier = null;/*DONE:review - check if it's using correct type*/
    string sQty = null;/*DONE:review - check if it's using correct type*/
    string sJobLocation = null;/*DONE:review - check if it's using correct type*/
    string sColour = null;/*DONE:review - check if it's using correct type*/
    int iCounter = 0;/*DONE:review - check if it's using correct type*/
    ADODB.Command cmd = null;
    ADODB.Parameter objParam = null;
    ADODB.Recordset rs = null;
    iEquipmentId = Request.QueryString["EId"].As<int?>();
    sJobCode = Request.QueryString["JobCode"];
    sCompCode = Request.QueryString["CompCode"];
    sModifier = Request.QueryString["Modifier"];
    sQty = Request.QueryString["Qty"];
    sJobLocation = Request.QueryString["JobLocation"];


    int? iPageSize = Request.QueryString["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 10;
    }


    int? iStartRecord = Request.QueryString["StartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }
    
    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Exception_Details");
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_Exception_Details";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    objParam = cmd.CreateParameter("EquipmentId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iEquipmentId);
    cmd.Parameters.Append(objParam);
    objParam = cmd.CreateParameter("JobCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sJobCode);
    cmd.Parameters.Append(objParam);
    objParam = cmd.CreateParameter("CompCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sCompCode);
    cmd.Parameters.Append(objParam);
    objParam = cmd.CreateParameter("ModifierCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sModifier);
    cmd.Parameters.Append(objParam);
    objParam = cmd.CreateParameter("QuantityCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sQty);
    cmd.Parameters.Append(objParam);
    objParam = cmd.CreateParameter("JobLocationCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sJobLocation);
    cmd.Parameters.Append(objParam);
    rs = new Recordset();
    rs = cmd.Execute();

    //int? iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();

    //rs = rs.NextRecordset();
    
    
    Response.Write("<form method=\"post\" action= name=\"frmTRG\">");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" style=\"border-collapse:separate;border-spacing:1px;\" >");
   
    Response.Write("<tr height=\"20\" id=\"rsh\" class=\"thc\">");
    Response.Write("<td class=\"t11 tSb\" align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job_Location")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Work_Application_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job_Condition_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Cab_Type_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Arrangement_No")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Group_No")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_First_Interval")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Next_Interval")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Quantity")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Note_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Addnl_Note")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Business_G_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_CC_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeaderStore_Code")+"</td>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeaderStore_Downtime")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeaderStore_Labor_Hours")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeaderStore_Arrangement_Number_Description")+"</td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeaderStore_Arrangement_Number_Source_Of_Supply")+"</td>");
    Response.Write("</tr>");
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
            Response.Write("<tr valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");
            Response.Write("<td id=\"rsc\">" + rs.Fields["JobCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["CompCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["ModifierCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["QuantityCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["JobLocationCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["WorkApplicationCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["JobConditionCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["CabTypeCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["ArrangementNo"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["GroupNo"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["FirstInterval"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["NextInterval"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["Quantity"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["NoteCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["AddnlNote"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["BusinessGCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["CCCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["StoreCode"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["Downtime"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["LaborHours"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["ArrangementNumberDescription"].Value.As<String>() + "</td>");
            Response.Write("<td id=\"rsc\">" + rs.Fields["ArrangementNumberSourceOfSupply"].Value.As<String>() + "</td>");
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
        Response.Write("<td bgColor=" + sColour + " class=\"t11 tSb\" colspan=\"5\">" + String.Format((string) GetLocalResourceObject("rkLbl_record"), iCounter));
        if (iCounter != 1)
        {
            Response.Write("s");
        }
        Response.Write("</td>");
        Response.Write("</tr>");
    }
    Response.Write("</table>");

    //Pagination
    //if (iRecordCount > 0)
    //{
    //    Response.Write("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" align=\"middle\">");

    //    Response.Write(HtmlHelper.Pager(iStartRecord.As<int>(), iPageSize.As<int>(), iRecordCount.As<int>(), strURLPath));
    //    Response.Write("</table>");
    //}
    
    
    Response.Write("</form>");
    rs.Close();
    Util.CleanUp(cmd);
   
%>
</asp:Content>
