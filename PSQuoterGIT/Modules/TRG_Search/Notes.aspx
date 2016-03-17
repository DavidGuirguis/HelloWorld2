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
    int? iRepairOptionId = null;
    int? iJobOperationId = null;
    ADODB.Command cmd = null;
    ADODB.Connection cnn = null;
    ADODB.Recordset rs = null;
    string strOperation = null;
    iRepairOptionId = Request.QueryString["RepairOptionId"].As<int?>();
    iJobOperationId = Request.QueryString["JobOperationId"].As<int?>();
    if (iRepairOptionId.IsNullOrWhiteSpace())
    {
        iRepairOptionId = 0;
    }
    if (iJobOperationId.IsNullOrWhiteSpace())
    {
        iJobOperationId = 0;
    }
    
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_Notes";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.Parameters.Append(cmd.CreateParameter("RepairOptionId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iRepairOptionId));
    cmd.Parameters.Append(cmd.CreateParameter("JobOperationId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iJobOperationId));
    rs = new Recordset();
    rs = cmd.Execute();
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"360\">");
    if (iJobOperationId == 0)
    {
        //*******************************************Notes**********************************************************
        Response.Write("<tr style=\"border: 1px solid #cccccc; background: #dcdcdc;\" class=\"t11 tSb\">");
        Response.Write("<td>"+(string)GetLocalResourceObject("rkHeaderText_Notes")+"</td>");
        Response.Write("</tr>");
        while(!(rs.EOF))
        {
            Response.Write("<tr class=\"t11\"><td>" + rs.Fields["Description"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td></tr>");
            rs.MoveNext();
        }
        Response.Write("<tr height=\"15\"><td>&nbsp;</td></tr>");
        rs = rs.NextRecordset();
    }
    //*******************************************AdditionalNotes**************************************************
    Response.Write("<tr style=\"border: 1px solid #cccccc; background: #dcdcdc;\" class=\"t11 tSb\">");
    Response.Write("<td>"+(string)GetLocalResourceObject("rkHeaderText_AdditionalNotes")+"</td>");
    Response.Write("</tr>");
    while(!(rs.EOF))
    {
        Response.Write("<tr class=\"t11\"><td>" + rs.Fields["AddnlNote"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/ + "</td></tr>");
        rs.MoveNext();
    }
    Response.Write("<tr height=\"15\"><td>&nbsp;</td></tr>");
    Response.Write("</table>");
    rs.Close();
    //cnn.Close();
    rs = null;
    Util.CleanUp(cmd: cmd);
    //cnn = null;
%>
</asp:Content>
