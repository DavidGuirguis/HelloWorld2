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
    string sModel = null;
    string sJobCode = null;
    string sCompCode = null;
    string sDesc = null;
    string sOperation = null;
    string strError = null;
    string strMsgTitle = null;
    string strPageTitle = null;
    int? iStartRecord = null;
    int? iPageSize = null;
    int? iAdminCheck = null;
    double? iAvgWOTotal = 0;
    double? iTRGHours = null;
    double? iAvgWOHours = 0;
    string sGUIS = null;
    string sFamilyTypeS = null;
    string sModelS = null;
    string sJobCodeS = null;
    string sJobCodeDescS = null;
    string sCompCodeS = null;
    string sCompCodeDescS = null;
    int? iSearchS = null;
    int? iNoOfWOSegmentsS = null;
    int iNoOfWOSegments = 0;
    int? iBranchIdS = null;
    int? iRecordCount = null;
    string sColour = null;
    int iCounter = 0;
    string sWO = null;
    string sSeg = null;
    string strURLPath = null;
    string strLinkText = null;
    string strLinkUrl = null;
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    string sCUNO = null;
    string sCUNM = null;
    string scolspan = null;
    
    ModuleTitle = (string) GetLocalResourceObject("rkModuleTitle_Work_Order_Details");
    cmd = new ADODB.CommandClass();
    sModel = Request.QueryString["Model"];
    sJobCode = Request.QueryString["Job"];
    sCompCode = Request.QueryString["Comp"];
    sDesc = Request.QueryString["Desc"];
    scolspan = "14";
    //*******************************Update Work Order******************************************************************
    sOperation = Request.Form["hdnOperation"];
    if (!sOperation.IsNullOrWhiteSpace())
    {
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "TRG_Edit_ExcludeWO";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd.Parameters.Append(cmd.CreateParameter("WONo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, (Request.Form["hdnWONo"] ?? String.Empty).Trim()));
        cmd.Parameters.Append(cmd.CreateParameter("SegmentNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, (Request.Form["hdnSegNo"] ?? String.Empty).Trim()));
        cmd.Parameters.Append(cmd.CreateParameter("Operation", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, sOperation));
        cmd.Parameters.Append(cmd.CreateParameter("EnterUserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
        cmd.Execute();
        cmd.Parameters.Clear();
        
    }
    //*************************************************************************************************************************
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_WODetails";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();

    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }

    iPageSize = Request.Form["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 10;
    }

    cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sModel));
    cmd.Parameters.Append(cmd.CreateParameter("JobCode", ADODB.DataTypeEnum.adVarWChar,ADODB.ParameterDirectionEnum.adParamInput, 3, sJobCode));
    cmd.Parameters.Append(cmd.CreateParameter("ComponentCode", ADODB.DataTypeEnum.adVarWChar,ADODB.ParameterDirectionEnum.adParamInput, 4, sCompCode));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 0, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
    cmd.CommandTimeout = 20000;
    rs = new Recordset();
    rs = cmd.Execute();
    iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>();
    rs = rs.NextRecordset();
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\">");
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
   
    Response.Write("</table>");
    if (rs.EOF)
    {
        Response.Write("<span class=\"t12\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</span>");
        Response.End();
    }

    iAvgWOTotal = rs.Fields["AvgWOTotal"].Value.As<double?>();

    if (iAvgWOTotal.IsNullOrWhiteSpace())
    {
        iAvgWOTotal = 0;
    }

    iTRGHours = rs.Fields["LaborHours"].Value.As<double?>();
    iAvgWOHours = rs.Fields["AvgWOLabourHours"].Value.As<double?>();
    
    if (iAvgWOHours== null)
    {
        iAvgWOHours = 0;
    }

    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
    Response.Write("<tr class=\"t11\">");
    Response.Write("<td class=\"t11 tSb\" width=\"110\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
    Response.Write("<td width=400>" + sModel.HtmlEncode() + "</td>");
    Response.Write("<td class=\"t11 tSb\" width=90>"+(string) GetLocalResourceObject("rkHeader_No_of_WO_Seg")+"</td>");
    Response.Write("<td>" + rs.Fields["NoOfWOSegments"].Value.As<String>().HtmlEncode() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job_Code")+"</td>");
    Response.Write("<td>" + sJobCode.HtmlEncode() + "</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_Avg_WO_Total")+"</td>");
    Response.Write("<td>" + Util.NumberFormat(iAvgWOTotal, 2, null, null, null).HtmlEncode() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Component_Code")+"</td>");
    Response.Write("<td>" + sCompCode.HtmlEncode() + "</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_TRG_Hours")+"</td>");
    Response.Write("<td>" + iTRGHours.HtmlEncode() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\" valign=top>");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
    Response.Write("<td >" + sDesc.HtmlEncode() + "</td>"); /*NOTE: Manual Fixup - removed .HtmlEncode()*/
    
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_Avg_WO_Hours")+"</td>");
    Response.Write("<td>" + Util.NumberFormat(iAvgWOHours, 2, null, null, null).HtmlEncode() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\">");
    //*****Back to Search button**************************************************
    sFamilyTypeS = Request.QueryString["FamilyType"];
    sModelS = Request.QueryString["ModelS"];
    sJobCodeS = Request.QueryString["JobS"];
    sJobCodeDescS = Request.QueryString["JobCodeDesc"];
    sCompCodeS = Request.QueryString["CompS"];
    sCompCodeDescS = Request.QueryString["CompCodeDesc"];
    iSearchS = Request.QueryString["Operation"].As<int?>();
    iNoOfWOSegmentsS = Request.QueryString["NoOfWOSegments"].As<int?>();
    if (iNoOfWOSegments.IsNullOrWhiteSpace())
    {
        iNoOfWOSegments = -1;
    }
    iBranchIdS = Request.QueryString["BranchId"].As<int?>();
    Response.Write("<td colspan=2>");%>
    <a href="<%=this.CreateUrl("modules/trg_search/WO_Summary.aspx", normalizeForAppending: true) + "&Model=" + sModelS + "&Job=" + sJobCodeS + "&Comp=" + sCompCodeS + "&FamilyType=" + sFamilyTypeS + "&Operation=" + iSearchS + "&NoOfWOSegments=" + iNoOfWOSegmentsS + "&BranchId=" + iBranchIdS + "&JobCodeDesc=" + sJobCodeDescS + "&CompCodeDesc=" + sCompCodeDescS%>"><%=(string) GetLocalResourceObject("rkLinkBack_To_Search")%></a></td>
    <%Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkHeader_Variance")+"</td>");
    Response.Write("<td><font color=\"red\">" + Util.NumberFormat(iTRGHours - iAvgWOHours, 2, null, null, null) + "</font></td>");
    Response.Write("</tr>");
    Response.Write("</table>");
    rs = rs.NextRecordset();
    iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    rs = rs.NextRecordset();
    if (rs.EOF)
    {
        Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
    }
    else
    {
        Response.Write("<tr height=\"20\" id=\"rsh\" class=\"thc t11b\">");
        if (iAdminCheck == 1)
        {
            Response.Write("<td width=10></td>");
        }

        Response.Write("<td align=\"middle\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_WO_No")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Segment_No")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Customer_No")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Customer_Name")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_S_N")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Service_Meter")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Invoice_Date")+"</td>");
        Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Lbr_Hours")+"</td>");
        Response.Write("</tr>");
        sColour = "white";
        iCounter = 0;

        while(!(rs.EOF))
        {
            iCounter = iCounter + 1;
            sWO = rs.Fields["WONo"].Value.As<string>();
            sSeg = rs.Fields["WOSegmentNo"].Value.As<string>();
            sCUNO = rs.Fields["CustomerNo"].Value.As<string>();
            sCUNM = rs.Fields["CustomerName"].Value.As<string>();
            Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=\"" + sColour + "\">");
            if (iAdminCheck == 1)
            {
                Response.Write("<td width=10><button class=\"btn\" type=\"button\" onclick=\"UpdateWO(1,'" + sWO + "','" + sSeg + "');\">" + (string)GetLocalResourceObject("rkLink_Exclude") + "</button></td>");
            }

            Response.Write("<td align=\"middle\">" + "<a href=\"javascript:void(0);\"  style=\"cursor:hand\"  onclick=\"WO('" + sWO + "','" + sCUNO + "','" + Server.UrlEncode(sCUNM) + "');\">" + sWO + "</a></td>");
            Response.Write("<td align=\"middle\">" + sSeg.HtmlEncode() + "</td>");
            Response.Write("<td>" + sCUNO.HtmlEncode() + "</td>");
            Response.Write("<td>" + sCUNM.HtmlEncode() + "</td>");
            Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<String>().HtmlEncode() + "</td>");
            Response.Write("<td>" + Util.FormatServiceMeter(rs.Fields["ServiceMeter"].Value.As<double?>(), rs.Fields["HourMileIndicator"].Value.As<String>(),null) + "</td>");
            Response.Write("<td align=\"middle\">" + Util.DateFormat(rs.Fields["InvoiceDate"].Value.As<DateTime?>()).HtmlEncode() + "</td>");
            Response.Write("<td align=\"right\">" + Util.NumberFormat(rs.Fields["TotalLaborHours"].Value.As<double?>(), 2, null, null, null).HtmlEncode() + "</td>");
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
       
        Response.Write("<tr><td style =\"nowrap\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td></tr>");
       
    }
    Response.Write("</table><br>");
    //****************************************Work Orders Excluded********************************************************
    rs = rs.NextRecordset();
    if (rs.EOF == false)
    {
        Response.Write("<span class=\"t14 tSb\"><font color=red>"+(string) GetLocalResourceObject("ekRptHeader_EXCLUDED_WORK_ORDERS")+"</font></span>");
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
        Response.Write("<tr height=\"20\" id=\"rsh\" class=\"thc t11b\">");
        Response.Write("<td width=10></td>");
        Response.Write("<td align=\"middle\">&nbsp;"+(string)GetLocalResourceObject("rkHeader_WO_No").HtmlEncode()+"</td>");
        Response.Write("<td align=\"middle\">" + (string)GetLocalResourceObject("rkHeader_Segment_No").HtmlEncode() + "</td>");
        Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Customer_No").HtmlEncode() + "</td>");
        Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Customer_Name").HtmlEncode() + "</td>");
        Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_S_N").HtmlEncode() + "</td>");
        Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Service_Meter").HtmlEncode() + "</td>");
        Response.Write("<td align=\"middle\">" + (string)GetLocalResourceObject("rkHeader_Invoice_Date").HtmlEncode() + "</td>");
        Response.Write("<td align=\"middle\">" + (string)GetLocalResourceObject("rkHeader_Lbr_Hours").HtmlEncode() + "</td>");
        Response.Write("</tr>");
        sColour = "white";
        iCounter = 0;
        while(!(rs.EOF))
        {
            iCounter = iCounter + 1;
            sWO = rs.Fields["WONo"].Value.As<string>();
            sSeg = rs.Fields["WOSegmentNo"].Value.As<string>();
            sCUNO = rs.Fields["CustomerNo"].Value.As<string>();
            sCUNM = rs.Fields["CustomerName"].Value.As<string>();

            Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=\"" + sColour + "\">");
         

            Response.Write("<td width=10><button class=\"btn\" type=\"button\" onclick=\"UpdateWO(2,'" + sWO + "','" + sSeg + "');\">" + (string)GetLocalResourceObject("rkHeader_Include") + "</button></td>");
   
            Response.Write("<td  style=\"cursor:hand;\" align=\"middle\"><a href=\"javascript:void(0);\" onclick=\"WO('" + sWO + "','" + sCUNO + "','" + Server.UrlEncode(sCUNM) + "');\">" + sWO + "</a></td>");
            Response.Write("<td align=\"middle\">" + sSeg + "</td>");
            Response.Write("<td>" + sCUNO.HtmlEncode() + "</td>");
            Response.Write("<td>" + sCUNM.HtmlEncode() + "</td>");
            Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<string>().HtmlEncode() + "</td>");
            Response.Write("<td>" + Util.FormatServiceMeter(rs.Fields["ServiceMeter"].Value.As<double?>(), rs.Fields["HourMileIndicator"].Value.As<string>(),null) + "</td>");
            Response.Write("<td align=\"middle\">" + Util.DateFormat(rs.Fields["InvoiceDate"].Value.As<DateTime?>()) + "</td>");
            Response.Write("<td align=\"right\">" + Util.NumberFormat(rs.Fields["TotalLaborHours"].Value.As<double?>(), 2, null, null, null) + "</td>");
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
        Response.Write("</table><br>");
    }
    rs.Close();
   
    Util.CleanUp(cmd);
  
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"0\">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("<input type=\"hidden\" name=\"hdnWONo\">");
    Response.Write("<input type=\"hidden\" name=\"hdnSegNo\">");
    Response.Write("</form>");
%>
<script language=javascript>
<%
    if (!strError.IsNullOrWhiteSpace())
    {
%>
	dispMsg("<%= strError %>", "<%= strLinkText %>", "<%= strLinkUrl %>", "<%= strMsgTitle %>", "<%= strPageTitle %>")
<%
    }
%>

function WO(sWO,sCUNO,sCUNM){
	//var sURL = "<%= this.CreateUrl("/library/sharedmodules/equipment/workorder/wo_drill.aspx", normalizeForAppending:true )%>WONo=" + sWO + "&CUNO=" + sCUNO + "&CUNM=" + sCUNM;
    var sURL = "<%= this.CreateUrl("/CustomerSearch/modules/account/equipment/workorder/WO_Drill.aspx", normalizeForAppending:true )%>LM=1&DV=G&CustomerNumber=7040100&CustomerName=HQE+EQUIPMENT+%26+SUPPLY++++++&SystemId=1&WONo=0119310";
	window.open(sURL,"WO","scrollbars=yes,resizable=yes,menubar=yes,toolbar=yes,height=550,width=900,left=0,top=0")	;
}

function UpdateWO(i,sWONo,sSegNo){
	frmTRG.hdnOperation.value = i;
	frmTRG.hdnWONo.value = sWONo;
	frmTRG.hdnSegNo.value = sSegNo;
	frmTRG.submit();
	
}

function Search(){
	frmTRG.submit();
}

</script>
</asp:Content>
