<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.ReportViewPage" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<%@ Import Namespace="System.Web.Services.Description" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
<%
    string sGUI = null; 
    string sMode = null; 
    string sFamilyType = null; 
    string sModel = null; 
    string sJobCode = null; 
    string sJobCodeDesc = null; 
    string sCompCode = null; 
    string sCompCodeDesc = null; 
    int? iSearch = null; 
    int? iNoOfWOSegments = null; 
    int? iShowAll = null; 
    string[] aBranchRateId = null; 
    string strBranchRateId = null;
    double? iBranchId = null; 
    double? iRate = null; 
    string sFamily = null; 
    int? iStartRecord = null; 
    int? iPageSize = null; 
    int? iAdminCheck = null; 
    int? iBranchIdRS = null; 
    string sCodeRS = null;
    int c = 0; 
    ADODB.Command oCmd = null;
    double? iRAndIRate = null; 
    int? iRecordCount = null; 
    string ShowTRGWOSummary = null;
    string sColour = null; 
    int iCounter = 0; 
    double? iLbrHours =null; 
    int? iNotes = null; 
    string sRJobCode = null; 
    string sRCompCode = null; 
    string sRModifierCode = null; 
    string sRModifierDesc = null; 
    string sRQuantityCode = null; 
    string sRQuantityDesc = null; 
    string sRJobLocationCode = null; 
    string sRDesc = null; 
    string sRQuantity = null;
    double? iAvgLbrHours= null; 
    int? iROId = null; 
    double? iCost = 0; 
    
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    ADODB.Recordset oRsEmailRecipients = null;
    string ToName = null; 
    string ToEmail = null; 
    sGUI = Request.QueryString["GUI"];
    string scolspan;
    int x;
    
    if (sGUI == "OFF")
    {
        sMode = "Add";
        scolspan = "13";
    }
    else
    {
        scolspan = "12";
    }
    sFamilyType = (Request.Form["cboFamilyType"]);
    sModel = (Request.Form["txtModel"] ?? String.Empty);
    sJobCode = (Request.Form["txtJobCode"] ?? String.Empty);
    sJobCodeDesc = (Request.Form["txtJobCodeDesc"] ?? String.Empty);
    sCompCode = (Request.Form["txtCompCode"] ?? String.Empty);
    sCompCodeDesc = (Request.Form["txtCompCodeDesc"] ?? String.Empty);
    iSearch = Request.Form["hdnOperation"].As<int?>();
    iNoOfWOSegments = Request.Form["cboWOFilter"].As<int?>();
    
    if (iNoOfWOSegments.IsNullOrWhiteSpace())
    {
        iNoOfWOSegments = -1;
    }
    iShowAll = Request.Form["cboShowAll"].As<int?>();
    if (iShowAll.IsNullOrWhiteSpace())
    {
        iShowAll = 1;
    }

    if (iSearch == 1)
    {
        strBranchRateId = Request.Form["cboRate"].As<string>();
        aBranchRateId = strBranchRateId.Split(",");  /*NOTE: Manual Fixup - removed Strings.Split(strBranchRateId, ",", -1, CompareMethod.Binary)*/
        iBranchId = aBranchRateId[0].As<double?>();
        iRate = aBranchRateId[1].As<double?>();
    }
    else
    {
        iBranchId = 0.0;
    }
    
    if (iSearch != 1 && !(Request.QueryString["BranchId"].IsNullOrWhiteSpace())) /*NOTE: Manual Fixup - removed !String.IsNullOrWhiteSpace(Request.QueryString["BranchId"])*/
    {
        sFamilyType = Request.QueryString["FamilyType"];
        if (sFamilyType.IsNullOrWhiteSpace())
        {
            sFamilyType = "0";
        }
        sModel = Request.QueryString["Model"];
        sJobCode = Request.QueryString["Job"];
        sJobCodeDesc = Request.QueryString["JobCodeDesc"];
        sCompCode = Request.QueryString["Comp"];
        sCompCodeDesc = Request.QueryString["CompCodeDesc"];
        iSearch = Request.QueryString["Operation"].As<int?>();
        if (iSearch.IsNullOrWhiteSpace())
        {
            iSearch = 0;
        }
        iNoOfWOSegments = Request.QueryString["NoOfWOSegments"].As<int?>();
        if (iNoOfWOSegments.IsNullOrWhiteSpace())
        {
            iNoOfWOSegments = -1;
        }
        iBranchId = Request.QueryString["BranchId"].As<double?>();
    }

    ModuleTitle = (string) GetLocalResourceObject("rkModuleTitle_TRG_Search");
    
    //*************************************************************************************************************************

    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_List_WOSummary";
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;


    if (sFamilyType == "0")
    {
        sFamily = "%";
    }
    else
    {
        sFamily = sFamilyType;
    }
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
    cmd.Parameters.Append(cmd.CreateParameter("FamilyCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, sFamily));
    cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sModel));
    cmd.Parameters.Append(cmd.CreateParameter("JobCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, sJobCode));
    cmd.Parameters.Append(cmd.CreateParameter("JobCodeDesc", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 25, sJobCodeDesc));
    cmd.Parameters.Append(cmd.CreateParameter("ComponentCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sCompCode));
    cmd.Parameters.Append(cmd.CreateParameter("ComponentCodeDesc", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 25, sCompCodeDesc));
    cmd.Parameters.Append(cmd.CreateParameter("BranchId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 4, iBranchId));
    cmd.Parameters.Append(cmd.CreateParameter("NoOfWOSegments", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 2, iNoOfWOSegments));
    cmd.Parameters.Append(cmd.CreateParameter("Search", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iSearch));
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("ShowAll", ADODB.DataTypeEnum.adTinyInt, ADODB.ParameterDirectionEnum.adParamInput, 1, iShowAll));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntity.BusinessEntityId));
    cmd.CommandTimeout = 20000;
    rs = new Recordset();
    rs = cmd.Execute();
    iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>();
    rs = rs.NextRecordset();
    if (iAdminCheck == 0)
    {
        scolspan = (scolspan.As<int>() - 4).As<string>();
    }
    
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\" onkeyup=\"SubmitForm();\">");
    Response.Write("<div class=\"filters\">");
    Response.Write("<table border=\"0\" cellpadding=\"2\" cellspacing=\"1\" width=\"100%\"  style=\"MARGIN-BOTTOM:5px\">");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Select_Rate")+"</td>");
    Response.Write("<td colspan=\"3\">");
    Response.Write("<select class=\"f\" tabindex=\"1\" name=\"cboRate\" id=\"cboRate\">");
    Response.Write("<option value=\"0\">&nbsp;</option>");
    
    while (!(rs.EOF))
    {
        iBranchIdRS = rs.Fields["BranchId"].Value.As<int?>();
        if (iBranchId == iBranchIdRS)
        {
            Response.Write("<option value=" + rs.Fields["BranchId"].Value.As<string>() + "," +
                           rs.Fields["SVLRate"].Value.As<string>() + " selected>" +
                           rs.Fields["Branch"].Value.As<string>());
        }
        else
        {
            Response.Write("<option value=" + rs.Fields["BranchId"].Value.As<string>() + "," +
                           rs.Fields["SVLRate"].Value.As<string>() + ">" + rs.Fields["Branch"].Value.As<string>());
        }
        rs.MoveNext();
    }
    
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("</tr>");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Family_Type")+"</td>");
    Response.Write("<td>");
    Response.Write("<select id=\"cboFamilyType\" name=\"cboFamilyType\" class=\"f\" tabindex=\"3\">");
    Response.Write("<option value=\"0\">&nbsp;</option>");
    rs = rs.NextRecordset();
    
    while (!(rs.EOF))
    {
        sCodeRS = rs.Fields["strCode"].Value.AsString();
        if (sCodeRS == sFamilyType)
        {
            Response.Write("<option selected  value=" + sCodeRS + " >" + rs.Fields["strName"].Value.As<string>());
        }
        else
        {
            Response.Write("<option value=" + sCodeRS + ">" + rs.Fields["strName"].Value.As<string>());
        }
        rs.MoveNext();
    }
    
    Response.Write("</select>");
    Response.Write("</td>");
    Response.Write("<td class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkLbl_Model")+"</td>");
    Response.Write("<td><input id=\"txtModel\" name=\"txtModel\" class=\"f w75\" value=\"" + sModel + "\" maxlength=\"10\" tabindex=\"4\"></td>");
    Response.Write("</tr>");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_Repair_Job_Code")+"</td>");
    Response.Write("<td><input id=\"txtJobCode\" name=\"txtJobCode\" class=\"f w50\" value=\"" + sJobCode + "\" maxlength=\"3\" tabindex=\"5\"></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>"+(string) GetLocalResourceObject("rkLbl_Repair_Job_Code_Description")+"</td>");
    Response.Write("<td><input id=\"txtJobCodeDesc\" name=\"txtJobCodeDesc\" class=\"f w200\" value=\"" + sJobCodeDesc + "\" maxlength=25 tabindex=\"6\"></td>");
    Response.Write("</tr>");
    Response.Write("<tr height=\"22\">");
    Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string) GetLocalResourceObject("rkLbl_Repair_Comp_Code")+"</td>");
    Response.Write("<td><input name=\"txtCompCode\" class=\"f w50\" value=\"" + sCompCode + "\" maxlength=\"4\" tabindex=\"7\"></td>");
    Response.Write("<td class=\"t11 tSb\" nowrap>"+(string) GetLocalResourceObject("rkLbl_Repair_Comp_Code_Description")+"</td>");
    Response.Write("<td><input name=\"txtCompCodeDesc\" class=\"f w200\" value=\"" + sCompCodeDesc + "\" maxlength=25 tabindex=\"8\"></td>");
    Response.Write("</tr>");
    Response.Write("<tr><td colspan=\"2\">");%>

    <button type="button" class="btn" href="javascript:void(0);" onclick="Search();"><%=(string) GetLocalResourceObject("rkLink_Search")%></button>

    <%Response.Write("</td><td align=right colspan=\"3\">");%> 
     
    <a href="javascript:void(0);" onclick="Lookup('A');"><%=(string) GetLocalResourceObject("rkLbl_Code_Lookup")%></a>&nbsp;&nbsp;|
    <a href="javascript:void(0);" onclick="Exceptions();"><%=(string) GetLocalResourceObject("rkLbl_Exceptions")%></a>&nbsp;&nbsp;|
  
  
  <script language="javascript">


      function Search() {
        
          var iCancel = 0

          if (frmTRG.cboRate.value == 0) {
              alert("<%=GetLocalResourceObject("rkMsg_You_must_select_a_Shop_Rate").JavaScriptStringEncode()%>")
              frmTRG.cboRate.focus();
              iCancel = 1
          }

          else if (frmTRG.cboFamilyType.value == 0 && frmTRG.txtModel.value == "") {
              alert("<%=GetLocalResourceObject("rkMsg_You_must_choose_a_Family_Type").JavaScriptStringEncode()%>")
              frmTRG.cboFamilyType.focus();
              iCancel = 1
          }

          if (iCancel != 1) {
              frmTRG.hdnOperation.value = 1
              frmTRG.submit();
          }
      }


      function Lookup(x)
      {
	     window.open("<%= this.CreateUrl("modules/trg_search/Code_Search.aspx", normalizeForAppending:true)%>TRG=1&Code=" + x,"Opener1","scrollbars=yes,menubar=no,resizable=yes,toolbar=no,height=450,width=600,left=50,top=50");
     }


     function Exceptions(){
	    window.open("<%= this.CreateUrl("modules/trg_search/Exceptions.aspx")%>","Opener1","scrollbars=yes,menubar=no,resizable=yes,toolbar=no,height=500,width=900,left=50,top=50");
    }

</script>
     
   <% if (iAdminCheck == 1)
    {
        Response.Write("&nbsp;<a href=\"javascript:void(0);\" onclick=\"TRGWOVariance();\" style=\"cursor:pointer;\">"+(string) GetLocalResourceObject("rkLink_TRG_WO_Variance")+"</a>");
    }

    Response.Write("</td></tr>");
    Response.Write("<tr>");
    Response.Write("<td colspan=2 class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkLbl_Show")+"&nbsp;");
    Response.Write("<select name=\"cboShowAll\" class=\"f\">");
    Response.Write("<option value=0");
    if (iShowAll == 0)
    {
        Response.Write(" selected");
    }
    Response.Write(">"+(string) GetLocalResourceObject("rkLbl_TRGs_only"));
    Response.Write("<option value=1");
    if (iShowAll == 1)
    {
        Response.Write(" selected");
    }
    Response.Write(">"+(string) GetLocalResourceObject("rkDrpDown_All"));
    Response.Write("</select></td>");
    Response.Write("</tr>");
    Response.Write("<tr>");
    Response.Write("<td colspan=2 class=\"t11 tSb\">"+(string) GetLocalResourceObject("rkLbl_Minimum_Work_Order_Segments_"));
    Response.Write("<select name=\"cboWOFilter\" id=\"cboWOFilter\" class=\"f\">");
    Response.Write("<option value=-1>" + (string) GetLocalResourceObject("rkDrpDownValue_Any") + "</option>");
    c = 0;
    while (c <= 25)
    {
        if (iNoOfWOSegments == c)
        {
            Response.Write("<option value=" + c + " selected>" + c);
        }
        else
        {
            Response.Write("<option value=" + c + ">" + c);
        }
        c = c + 1;
    }
    Response.Write("</select></td>");
    oCmd = new ADODB.CommandClass();
    oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    oCmd.CommandText = "Admin_EmailRecipients_List";
    oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    oRsEmailRecipients = oCmd.Execute();
    if (!(oRsEmailRecipients.EOF))
    {
        ToName = "";
        ToEmail = "";
        while (!(oRsEmailRecipients.EOF))
        {
            ToEmail = ToEmail + oRsEmailRecipients.Fields["email"].Value.As<string>() + ";";
            ToName = ToName + oRsEmailRecipients.Fields["firstname"].Value.As<string>() + " " +
                     oRsEmailRecipients.Fields["lastname"].Value.As<string>() + ", ";
            oRsEmailRecipients.MoveNext();
        }
        Response.Write("<td colspan=3 class=\"t11 tSb\" align=right  style=\"display:none\">"+(string) GetLocalResourceObject("rkLbl_Contact_if_you_have_any_questions")+"<a href=\"mailto:" +
                       ToEmail.Substring(0, ToEmail.Length - 1) + "?Subject=PSQuoter - TRG Search\">" +
                       ToName.Substring(0, ToName.Length - 2) + "</a></td></tr>");
    }

    Response.Write("</table>");
    Response.Write("</div>");
    if (iSearch == 1)
    {
        rs = rs.NextRecordset();
        if(!rs.EOF)
        {
            iRAndIRate = rs.Fields["RAndIRate"].Value.As<double?>();
        }
        Response.Write("<table class=\"tbl\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;\">");
        rs = rs.NextRecordset();
        iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
        rs = rs.NextRecordset();

        if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t11 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
        }
        else
        {
            if (sMode == "Add")
            {
                Response.Write("<tr>");
                Response.Write("<td colspan=\"14\">");
                Response.Write("<button type=\"button\" id=\"addSelection\" name=\"addSelection\" onclick=\"AddSelection();\">"+(string)GetLocalResourceObject("rkButtonText_AddSelection")+"</button>");
                Response.Write("</td>");
                Response.Write("</tr>");
            }
            Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\" >");
            if (sMode == "Add")
            {
                Response.Write("<td width=\"7\">");
                Response.Write("<button id=\"checkAll\" name=\"checkAll\" onclick=\"CheckAll();\">"+(string)GetLocalResourceObject("rkButtonText_CheckAll")+"</button>");
                Response.Write("</td>");
            }
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Model")+"</td>");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
            Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
            Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
            Response.Write("<td width=\"20px\">&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
            Response.Write("<td align=middle>"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
            Response.Write("<td align=right>"+(string) GetLocalResourceObject("rkHeader_TRG_br_Hours")+"</td>");
            Response.Write("<td align=right>"+(string) GetLocalResourceObject("rkHeader_TRG_br_Sell")+"</td>");
        
            ShowTRGWOSummary = AppContext.Current.AppSettings["psQuoter.ShowTRGWOSummary.All"];
            if (iAdminCheck == 1 || (ShowTRGWOSummary == "2" && AppContext.Current.User.Operation.CreateQuote))
            {
                Response.Write("<td align=middle>"+(string) GetLocalResourceObject("rkHeader_No_of_br_WO_Seg")+"</td>");
                Response.Write("<td align=right>"+(string) GetLocalResourceObject("rkHeader_Avg_WO_Hours")+"</td>");
                Response.Write("<td align=right>"+(string) GetLocalResourceObject("rkHeader_Avg_WO_br_Sell")+"</td>");
                Response.Write("<td align=right >"+(string) GetLocalResourceObject("rkHeader_Variance")+"</td>");
                Response.Write("<td align=right >" + "&nbsp;" + "</td>");
            }
            Response.Write("</tr>");
            sColour = "white";
            iCounter = 0;
            while (!(rs.EOF))
            {
                iCounter = iCounter + 1;
                sModel = rs.Fields["Model"].Value.As<string>();

                iLbrHours = rs.Fields["LaborHours"].Value.As<double?>();
                if (iLbrHours.IsNullOrWhiteSpace())
                {
                    iLbrHours = 0.0;
                }
                iNotes = rs.Fields["Notes"].Value.As<int?>();
                sRJobCode = rs.Fields["RJobCode"].Value.As<string>();
                sRCompCode = rs.Fields["RCompCode"].Value.As<string>();
                sRModifierCode = rs.Fields["RModifierCode"].Value.As<string>();
                sRModifierDesc = rs.Fields["RModifierDesc"].Value.As<string>();
                sRQuantityCode = rs.Fields["RQuantityCode"].Value.As<string>();
                sRQuantityDesc = rs.Fields["RQuantityDesc"].Value.As<string>();
                sRJobLocationCode = rs.Fields["RJobLocationCode"].Value.As<string>();
                sRDesc = rs.Fields["RJobDesc"].Value.As<string>() + " " + rs.Fields["RCompDesc"].Value.As<string>() +
                         " " + rs.Fields["RModifierDesc"].Value.As<string>() + " " +
                         rs.Fields["RLocationDesc"].Value.As<string>() + " " + sRQuantityDesc;
                sRQuantity = rs.Fields["Quantity"].Value.As<string>();
                iAvgLbrHours = rs.Fields["AvgLbrHours"].Value.As<double>();
               
                if (iAvgLbrHours == null)
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
                    iAvgLbrHours = 0.0;
                }
                
                if (sRJobCode == "010")
                {
                    iCost =  iLbrHours * iRAndIRate;  
                }
                else
                {
                    iCost = iLbrHours * iRate;
                }
                if (iCost.IsNullOrWhiteSpace())
                {
                    iCost = 0.0;
                }
                
                //==========================================Repair Option Row==============================================
                Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=" + sColour + ">");
                if (sMode == "Add")
                {
                    Response.Write("<td width=5><input type=\"checkbox\" name=\"chkInclude\" id=chkInclude" + iCounter + "></td>");
                    Response.Write("<td width=\"50\">"); %>
                   <a href='<%=this.CreateUrl("modules/trg_search/job_operations.aspx", normalizeForAppending: true) + "ROId=" + iROId + "&BranchId=" + iBranchId%>'>
                <%
                }
                else
                {
                    Response.Write("<td width=\"50\">");%>
                    <a href='<%= this.CreateUrl("modules/trg_search/job_operations.aspx", normalizeForAppending: true) + "ROId=" + iROId + "&BranchId=" + iBranchId %>'>
               
               <% }
                Response.Write(sModel + "</a></td>");
                Response.Write("<td width=25>" + sRJobCode + "</td>");
                Response.Write("<td width=40>" + sRCompCode + "</td>");
                Response.Write("<td width=50 align=middle title=\"" + sRModifierDesc + "\">" + sRModifierCode + "</td>");
                Response.Write("<td><span id=spnDesc" + iCounter + ">" + sRDesc + "</span></td>");
                Response.Write("<td width=25 align=middle title=\"" + sRQuantityDesc + "\">" + sRQuantityCode + "</td>");
                if (x == 1)
                {
                    Response.Write("<td width=40 align=right>" + Util.NumberFormat(iLbrHours, 1, -1 , -1, null) +"</td>");        /*NOTE: Manual Fixup - removed Strings.FormatNumber(iLbrHours, 1, TriState.True,TriState.True,TriState.UseDefault)*/
                    Response.Write("<td width=50 align=right><span id=spnCost" + iCounter + ">" + Util.NumberFormat(iCost, 2, -1, -1, null) +"</span></td>");   /*NOTE: Manual Fixup - removed Strings.FormatNumber(iCost, 2, TriState.True,TriState.True,TriState.UseDefault)*/
                    if (iAdminCheck == 1 || (ShowTRGWOSummary == "2" && AppContext.Current.User.Operation.CreateQuote))
                    {
                        Response.Write("<td width=50 align=middle>" + rs.Fields["TotalWOSeg"].Value.As<string>() +
                                       "</td>");%>
                       <td width=50 align="right">
                        <a href='<%= this.CreateUrl("modules/TRG_Search/WO_Details.aspx", normalizeForAppending:true) + "Model=" + Server.UrlEncode(sModel) + "&Job=" + Server.UrlEncode(sRJobCode) + "&Comp=" + Server.UrlEncode(sRCompCode) + "&Desc=" + Server.UrlEncode(sRDesc) + "&FamilyType=" + Server.UrlEncode(sFamilyType) + "&ModelS=" + Server.UrlEncode(sModel) + "&JobS=" + Server.UrlEncode(sJobCode) + "&CompS=" + Server.UrlEncode(sCompCode) + "&Operation=" + iSearch + "&NoOfWOSegments=" + iNoOfWOSegments + "&BranchId=" + iBranchId + "&JobCodeDesc=" + Server.UrlEncode(sJobCodeDesc) + "&CompCodeDesc=" + Server.UrlEncode(sCompCodeDesc) %>' >  <%= Util.NumberFormat(iAvgLbrHours, 1) %></a>
                          </td>
                      
                       <%
                        Response.Write("<td width=75 align=right>" + Util.NumberFormat(rs.Fields["AvgWOTotal"].Value.As<double?>(), 2, -1, -1, null) + "</td>");   /*NOTE: Manual Fixup - removed Strings.FormatNumber(rs.Fields["AvgWOTotal"].Value, 2, TriState.True, TriState.True)*/
                        Response.Write("<td width=50 align=right><font color=\"red\">" + Util.NumberFormat(iLbrHours - iAvgLbrHours, 2, -1, -1, null) + "</font></td>");      /*NOTE: Manual Fixup - removed Strings.FormatNumber(iLbrHours.AsDouble() - iAvgLbrHours, 2, TriState.True, TriState.True)*/
                    }
                }
                else
                {
                    Response.Write("<td width=40 align=middle>" + Util.NumberFormat(iLbrHours, 1, -1, -1, null) + "</td>");      /*NOTE: Manual Fixup - removed Strings.FormatNumber(iLbrHours, 1, TriState.True, TriState.True)*/
                    Response.Write("<td width=50 align=middle><span id=spnCost" + iCounter + ">" + Util.NumberFormat(iCost, 2, -1, -1, null) + "</span></td>"); /*NOTE: Manual Fixup - removed Strings.FormatNumber(iCost, 2, TriState.True, TriState.True)*/
                    
                    if (iAdminCheck == 1 || (ShowTRGWOSummary == "2" && AppContext.Current.User.Operation.CreateQuote))
                    {
                        Response.Write("<td width=50 align=middle></td>");
                        Response.Write("<td width=50 align=middle></td>");
                        Response.Write("<td width=75 align=middle></td>");
                        Response.Write("<td width=50 align=middle></td>");
                    }
                }
                Response.Write("<td align=\"middle\" width=\"1\"  bgColor=" + sColour + ">");
                Response.Write("<input type=hidden name=\"hdnQty" + iCounter + "\" value=\"" + sRQuantity + "\">");
                Response.Write("<input type=hidden name=\"hdnMod" + iCounter + "\" value=\"" + sRModifierCode + "\">");
                Response.Write("<input type=hidden name=\"hdnJobLoc" + iCounter + "\" value=\"" + sRJobLocationCode + "\">");
                Response.Write("<input type=hidden name=\"hdnRepairOptionId" + iCounter + "\" value=\"" + iROId + "\">");
                if (iNotes > 0)
                {
                    Response.Write("<button type=\"button\" class=\"btn\" onclick=\"ViewNotes('" + rs.Fields["RepairOptionId"].Value.As<string>() + "');\">"+(string) GetLocalResourceObject("rkBtn_Notes")+"</button>");
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
          
            
            //Response.Write("</table>");
        }
        rs.Close();

        rs = null;
        Util.CleanUp(cmd: cmd);
        Response.Write("</table><br>");
    }

      if (iRecordCount > 0)
      {
         Response.Write("<table border=\"0\"  cellpadding=\"0\" cellspacing=\"0\" align=\"middle\">");
         //Response.Write("<tr><td style=\"nowrap\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</tr></td>");
         Response.Write("<tr><td style=\"nowrap\">" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td></tr>");
         Response.Write("</table>");
      }
                           
      Response.Write("<input type=hidden id=\"hdnOperation\" name=\"hdnOperation\" value=\"0\" />");
      Response.Write("<input type=hidden id=\"hdnCheck\" name=\"hdnCheck\" value=\"0\" />");
      Response.Write("<input type=hidden id=\"hdnStartRecordId\" name=\"hdnStartRecordId\" />");
      Response.Write("</form>");
%>


<script language="javascript">
frmTRG.cboRate.focus();


function ViewNotes(iRepairOptionId){
	window.open("<%=this.CreateUrl("modules/trg_search/Notes.aspx", normalizeForAppending:true)%>RepairOptionId=" + iRepairOptionId,"Opener1","scrollbars=yes,menubar=no,toolbar=no,height=300,width=400,left=100,top=200")
}

function CheckAll(){
	var iItemCounter = "<%=iCounter%>"

	if (document.all["hdnCheck"].value == 0){
		for(q=1; q <= iItemCounter; q++){
			document.all["chkInclude" + q].checked = true;
			document.all["hdnCheck"].value = 1;
		}
	}
	else {
		for(q=1; q <= iItemCounter; q++){
			document.all["chkInclude" + q].checked = false;
			document.all["hdnCheck"].value = 0;
		}
	}
}

function addFileInput(){
	var odivFile = window.opener.document.all["divFiles"];
	var curNum = parseInt(odivFile.value);

   
		
		eval("window.opener.document.all['spanFile" + (++curNum) + "'].innerHTML = '" 
			+ "<table cellspacing=0 cellpadding=0 border=0 width=\"500\"><tr>" 
			+ "<td><input type=\"text\" id=\"txtQtyNew\" name=\"txtQtyNew" + curNum + "\" onkeypress=\"return isNumberInput(event)\" class=\"f w50\" onchange=\"ExtPriceNew(" + curNum + ")\"  style=text-align:center;></td>"
			+ "<td><input type=\"text\" onfocus=\"addFileInput()\" name=\"txtItemNoNew" + curNum + "\" class=\"f w75\" maxlength=20></td>" 
  

				
			+ "<td><input type=\"text\" id=\"txtDescNew\" name=\"txtDescNew" + curNum + "\" class=\"f w450\" maxlength=200></td>"				
			+ "<td><input type=\"text\" id=\"txtUnitPriceNew\" name=\"txtUnitPriceNew" + curNum + "\" onkeypress=\"return isDecimalInput(this,event)\" onchange=\"ExtPriceNew(" + curNum + ")\" class=\"f w75\" style=text-align:right></td>"
			+ "<td><input type=\"text\" class=\"f w75\" id=\"txtDiscountNew\" name=\"txtDiscountNew" + curNum + "\"  onchange=\"DiscountNew(" + curNum + ")\" onkeypress=\"return isDecimalInput(this,event)\"  style=text-align:right></td>"
			+ "<td><input type=\"text\" id=\"txtExtPriceNew\" name=\"txtExtPriceNew" + curNum + "\" class=\"f w75\" disabled style=text-align:right></td>"
			+ "<input type=\"hidden\" id=\"hdnCounterNew\" + curNum name=\"hdnCounterNew\" value=" + curNum + ">"
			+ "<input type=\"hidden\" id=\"hdnRepairOptionIdNew\" name=\"hdnRepairOptionIdNew" + curNum + "\">"	
			+ "</tr></table><span id=spanFile" + (curNum + 1) + "></span>'");		
		
	      odivFile.value = curNum;
}

function AddSelection() {
	var iCounter = "<%=iCounter%>"
	
	for(q=1; q <= iCounter; q++){
		if (document.all["chkInclude" + q].checked == true){
			var odivFile = window.opener.document.all["divFiles"];
			var curNum = parseInt(odivFile.value);
			var sDesc = document.all["spnDesc" + q].innerHTML;
			var iUnitPrice = document.all["spnCost" + q].innerHTML;
			var iQty = document.all["hdnQty" + q].value;
			var iROId = document.all["hdnRepairOptionId" + q].value;
			var re = /,/gi;

			sDesc = sDesc.replace("&nbsp;"," ");
			sDesc = sDesc.replace("&amp;","&");
		
			iUnitPrice = iUnitPrice.replace(re,"");
			
			
			window.opener.document.all["txtQtyNew" + curNum].value = iQty;
			window.opener.document.all["txtDescNew" + curNum].value = sDesc;
			window.opener.document.all["txtUnitPriceNew" + curNum].value = iUnitPrice;
			window.opener.document.all["txtExtPriceNew" + curNum].value = iUnitPrice * iQty;		
			window.opener.document.all["hdnRepairOptionIdNew" + curNum].value = iROId;
			
			addFileInput()	
		}
	}
	
	window.close();
}

function SubmitForm(){
	var i = window.event.keyCode;
	if (i == 13){
		Search()
	}

}

function TRGWOVariance(){
	document.location.href ="<%=this.CreateUrl("modules/trg_search/TRGWO_Variance.aspx")%>";
}

</script>
</asp:Content>
