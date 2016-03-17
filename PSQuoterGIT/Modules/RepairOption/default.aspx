<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.ReportViewPage" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server" >

<%
    string sMode = null;
    string sFamilyType = null;
    string sJobCode = null;
    string sJobCodeDesc = null;
    string sCompCode = null;
    string sCompCodeDesc = null;
    int? iQuoteId = null;
    string sStoreNo = null;
    string sSNBegin = null;
    string sModel = null;
    string sFamily = null;
    int? iStartRecord = null;
    int? iPageSize = null;
    int? iAdminCheck = null;
    int? iRecordCount = null;
    int? mRecordCount = null;   //<CODE_TAG_104228>
    string sType= null;
    string sColour = null;
    int iCounter = 0;
    int? iDBSROId = null;
    string iDBSROIds = "";     //<CODE_TAG_104228>
    int? iRepairOptionPricingID = null;
    string iRepairOptionPricingIDs = null;  //<CODE_TAG_104228>
    string sModifierCode = null;
    string sModifierDesc = null;
    string sQuantityCode = null;
    string sQuantityDesc = null;
    string sBusinessgroupCode = null;
    string sBusinessgroupDesc = null;
        
    string sJobLocationCode = null;
    string sDesc = null;
    double? iLabourHours = 0;
    double? iPartsAmount = 0;
    double? iLabourAmount = 0;
    double? iMiscAmount = 0;
    double? iTotalAmount = 0;
    string strURLPath = null;
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    string sWorkApplicationCode = null;
    string sWorkApplicationCodeDesc = null;
    bool blnWorkApplicationCodesShow = false;
    string sShopFieldCode = null;
    string sBusinessGroup = null;
    string sFR = null;
    
    string scolspan = null;
    string TT = Request.QueryString["TT"].AsString("");
    string PageMode = Request.QueryString["PageMode"].AsString("");
    string sBusinessGroupDesc = "";
    string sCabType = "";
	string sFilterJobCode ="";    //<CODE_TAG_104228>
	string sFilterComponentCode = "";   //<CODE_TAG_104228>
    //<Code_Tag_101936>
    //****************************************BOM***************************************/
    string sGroupPartNoPrev = null;
    int iGroupCount = 0;
    bool blnGroupPartNoMultiSelection = false;
    //</Code_Tag_101936>
    if (0 == String.Compare(TemplateName, "Popup", StringComparison.InvariantCultureIgnoreCase))
    {
        sMode = "Add";
        scolspan = "14";
    }
    else
    {
        scolspan = "13";
    }
    sFamilyType = (Request.Form["cboFamilyType"]);
    sModel = (Request.Form["txtModel"] ?? String.Empty).Trim();
    if (sModel.IsNullOrWhiteSpace())
    {
        sModel = Request.QueryString["Model"].As<string>();
    }
    
    sJobCode = (Request.Form["txtJobCode"] ?? String.Empty);
    sJobCodeDesc = (Request.Form["txtJobCodeDesc"] ?? String.Empty);
    sCompCode = (Request.Form["txtCompCode"] ?? String.Empty);
    sCompCodeDesc = (Request.Form["txtCompCodeDesc"] ?? String.Empty);
    //iSearch		= Request.Form("hdnOperation")
    iQuoteId = Request.QueryString["QuoteId"].As<int?>();
    //sStoreNo		= Request.Form("cboStore")
    sStoreNo = Request.QueryString["StoreNo"];
    sSNBegin = Request.QueryString["SNBegin"];
    sFR = Request.QueryString["SFR"].AsString("");
    sType = Request.QueryString["SType"].AsString("");
    //GT20091217 add WorkApplicationCodes filter
    sWorkApplicationCode = (Request.QueryString["WorkAppCode"] ?? String.Empty);
    if (sWorkApplicationCode.IsNullOrWhiteSpace())
    {
        sWorkApplicationCode = "%";
    }
    //hidWorkApplicationCodeSelected.Value = sWorkApplicationCode; //<CODE_TAG_103916>
    sWorkApplicationCodeDesc = (Request.Form["txtCompCodeDesc"] ?? String.Empty);
    sFilterJobCode = Request.QueryString["JobCode"].As<string>("");   //<CODE_TAG_104228>
	sFilterComponentCode = Request.QueryString["ComponentCode"].As<string>("");   //<CODE_TAG_104228>
    //*************************************************************************************************************************
    
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "dbo.TRG_List_RepairOptions";
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
    iPageSize = Request.Form["RecordNo"].As<int?>();
    if (iPageSize.IsNullOrWhiteSpace())
    {
        iPageSize = 50;
    }
    
    sBusinessGroup = Request.QueryString["BGroup"];
    if (sBusinessGroup.IsNullOrWhiteSpace())
    {
        sBusinessGroup = "";
    }
   
    cmd.Parameters.Append(cmd.CreateParameter("SerialNoBegin", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sSNBegin));
    cmd.Parameters.Append(cmd.CreateParameter("StoreNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, sStoreNo)); 
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessGroup", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sBusinessGroup));
    cmd.Parameters.Append(cmd.CreateParameter("WorkApplicationCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sWorkApplicationCode));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntity.BusinessEntityId));
    cmd.Parameters.Append(cmd.CreateParameter("FlateRateExchangeCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sFR));
    cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sModel));            //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("JobCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 6, sFilterJobCode));      //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("ComponentCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 8, sFilterComponentCode));    //<CODE_TAG_104228>
    
    
    rs = new Recordset();
    rs = cmd.Execute();
    iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>(); 
    sWorkApplicationCodeDesc = rs.Fields["WorkApplicationCodeDesc"].Value.As<String>();
    blnWorkApplicationCodesShow = (CType.ToInt32(rs.Fields["WorkApplicationCodesShow"].Value.As<string>(), 0) == 2);
    sBusinessGroupDesc = rs.Fields["businessGroupDesc"].Value.As<String>() + "(" + rs.Fields["businessGroupCode"].Value.As<String>() + ")";
    if (sBusinessGroupDesc == "()") sBusinessGroupDesc = "";
    
    rs = rs.NextRecordset();
    //<CODE_TAG_104228> start
	string strCombJobCode = "",strJobCode, strJobCodeDesc;
		strCombJobCode = "<select class=\"f \" tabindex=\"1\" name=\"cboJobCode\" id=\"cboJobCode\" >";
        strCombJobCode += "<option value=\"\">&nbsp;</option>";
        while (!(rs.EOF))
        {
            strJobCode = rs.Fields["JobCode"].Value.As<string>();
			strJobCodeDesc = rs.Fields["JobCodeDesc"].Value.As<string>();

            if (strJobCode == sFilterJobCode)
                strCombJobCode += "<option value=\"" + strJobCode + "\" selected>" + strJobCode + " - "+ strJobCodeDesc + "</option>";
            else
                strCombJobCode += "<option value=\"" + strJobCode + "\">" + strJobCode + " - "+ strJobCodeDesc + "</option>" ;
            rs.MoveNext();
        }
         strCombJobCode += "</select>";
		rs = rs.NextRecordset();
		
		string strCombComponentCode = "",strComponentCode, strComponentCodeDesc;
		strCombComponentCode = "<select class=\"f \" tabindex=\"1\" name=\"cboComponentCode\" id=\"cboComponentCode\" >";
        strCombComponentCode += "<option value=\"\">&nbsp;</option>";
        while (!(rs.EOF))
        {
            strComponentCode = rs.Fields["ComponentCode"].Value.As<string>();
			strComponentCodeDesc = rs.Fields["ComponentCodeDesc"].Value.As<string>();

            if (strComponentCode == sFilterComponentCode)
                strCombComponentCode += "<option value=\"" + strComponentCode + "\" selected>" + strComponentCode + " - "+ strComponentCodeDesc + "</option>";
            else
                strCombComponentCode += "<option value=\"" + strComponentCode + "\">" + strComponentCode + " - "+ strComponentCodeDesc + "</option>" ;
            rs.MoveNext();
        }
         strCombComponentCode += "</select>";
		rs = rs.NextRecordset();
	//<CODE_TAG_104228> end
	
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\" onkeyup=\"SubmitForm();\">");
  
    //**************************************************************************************************************************
    iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
    rs = rs.NextRecordset();
    //<CODE_TAG_104228> start
    //ModuleTitle = String.Format((string)GetLocalResourceObject("rkModuleTitle"), Util.IsLoopableRecordset(rs) ? rs.Fields["Model"].Value.As<string>() : null);
    ModuleTitle = String.Format((string)GetLocalResourceObject("rkModuleTitle"), Util.IsLoopableRecordset(rs) ? sModel : null);

    if (! rs.EOF)
    //{
    //    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    //    Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string)GetLocalResourceObject("rkHeaderText_NoInfoFound")+"</font></td></tr>");
    //    Response.Write("</table>");
    //}
    //else
    //<CODE_TAG_104228> end
    {
        //***************************Header*********************************************************************************
        
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
        Response.Write("<tr class=\"t11\">");
        if (sFR == "")
        {
            Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_Model")+"</td>");
            Response.Write("<td>" + rs.Fields["Model"].Value.As<string>() + "</td>");
        }
        else
        {
            Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;Flate Rate Exchange</td>");
            Response.Write("<td>" + sFR + "</td>");
        }
		Response.Write("<td></td><td style='text-align:right'><input class=\"f btn\" type=\"button\" value=\"Model Search\" onClick=\"btnModelClick();\"  ></td>");   //<CODE_TAG_104228>
		
        Response.Write("</tr>");
        Response.Write("<tr class=\"t11\">");
        if (sFR == "")
        {
            Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_SerialNoBegin")+"</td>");
            Response.Write("<td>" + rs.Fields["SerialNoBegin"].Value.As<string>() + "</td>");
        }
        else
        {
            Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;</td>");
            Response.Write("<td></td>");
        }
        Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_BusinessGroup") + "</td>");
        //Response.Write("<td>" + (sBusinessGroup.DefaultIfNullOrWhiteSpace(String.Empty).Replace("%", "").IsNullOrWhiteSpace() ? (string)GetLocalResourceObject("rkHeaderText_BusinessGroup_All") : sBusinessGroupDesc) + "</td>");
        Response.Write("<td>" + (sBusinessGroup.DefaultIfNullOrWhiteSpace(String.Empty).Replace("%", "").IsNullOrWhiteSpace() ? (string)GetLocalResourceObject("rkHeaderText_BusinessGroup_All") : sBusinessGroupDesc) + "<input id='stBusinessGroup' type='hidden' value='" + sBusinessGroup + "' />" + "</td>");  //<CODE_TAG_103916>
     
        Response.Write("</tr>");
        Response.Write("<tr class=\"t11\">");
        if (sFR == "")
        {
            Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_SerialNoEnd") + "</td>");
            Response.Write("<td>" + rs.Fields["SerialNoEnd"].Value.As<string>() + "</td>");
        }
        else
        {
            Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;</td>");
            Response.Write("<td></td>");
        }
        if (blnWorkApplicationCodesShow)
        {
            Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_WorkApplicationCode") + "</td>");
            //Response.Write("<td>" + sWorkApplicationCodeDesc + "</td>");
            Response.Write("<td>" + sWorkApplicationCodeDesc + "<input type='hidden' id='stAppCode' value='" + sWorkApplicationCode + "'>"+ "</td>");//<CODE_TAG_103916> 
        }
        Response.Write("</tr>");
        //<CODE_TAG_104228> start
		Response.Write("<tr>");
		Response.Write("<td  class=\"t11 tSb\">Job Code</td>");
		Response.Write("<td>");
		Response.Write(strCombJobCode);
		Response.Write("</td>");
		Response.Write("<td  class=\"t11 tSb\">Component Code</td>");
		Response.Write("<td>");
		Response.Write(strCombComponentCode);
		
		Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;<input class=\"f btn\" type=\"button\" value=\"OK\" onClick=\"btnOkClick(this.form);\"  >");
		Response.Write("</td>");
		Response.Write("</tr>");
        //<CODE_TAG_104228> end
        Response.Write("</table>");
        Response.Write("<div>Segments:</div>");   //<CODE_TAG_104228>
        Response.Write("<table width=\"100%\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" >");
        
        //***************************Details*********************************************************************************
        Response.Write("<tr height=\"20\" class=\"thc\" >");  //id=\"rshl\" class=\"thc\"
        //<CODE_TAG_104228> add width
        Response.Write("<td align=\"left\" class=\"t11 tSb\" style=\"width:20px\"><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></td>");//<Code_Tag_101936>
        Response.Write("<td style=\"width:20px\">&nbsp;</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_Job")+"</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_Comp") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">" + (string)GetLocalResourceObject("rkHeaderText_Modifier") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_Description") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">Job Location</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">Cab Type</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">Work Application</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">Business Group</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">Shop/Field</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:50px\">" + (string)GetLocalResourceObject("rkHeaderText_Qty") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:70px\">" + (string)GetLocalResourceObject("rkHeaderText_LaborHours") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:70px\">" + (string)GetLocalResourceObject("rkHeaderText_PartsAmt") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:70px\">" + (string)GetLocalResourceObject("rkHeaderText_LaborAmt") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:70px\">" + (string)GetLocalResourceObject("rkHeaderText_MiscAmt") + "</td>");
        Response.Write("<td class=\"t11 tSb\" style=\"width:70px\">" + (string)GetLocalResourceObject("rkHeaderText_TotalAmt") + "</td>");
        
        if (PageMode == "AddSegments" && iRecordCount> 0)  
            Response.Write("<td class=\"t11 tSb\" style=\"width:50px\"><input class=\"f btn\" type=\"button\" value=\"Add\" onClick=\"AddSegments(this.form);\"  ></td>");//<Code_Tag_101936>
        
        Response.Write("</tr>");
		if (PageMode == "AddSegments")
		{
			Response.Write("</table>");
			Response.Write("<div style='width: 100%; height:370px; overflow-y: scroll;'>");
            Response.Write("<table style='width: 100%;'>"); //By V.W
		}
        //<CODE_TAG_104228> end
        sColour = "white";
        iCounter = 0;
        var xcounter = 0;//<Code_Tag_101936>
        blnGroupPartNoMultiSelection = AppContext.Current.AppSettings.IsTrue("psQuoter.RepairOption.GroupPartNo.MultiSelection.Enabled");//<Code_Tag_101936>
        while(!(rs.EOF))
        {
            //<Code_Tag_101936>
            if (iDBSROId == rs.Fields["DBSRepairOptionId"].Value.As<int?>() && iRepairOptionPricingID == rs.Fields["RepairOptionPricingID"].Value.As<int?>())
            {
                
                xcounter = xcounter + 1;
                sGroupPartNoPrev = rs.Fields["GroupPartNo"].Value.As<String>();
                
                Response.Write("<tr class=\"subRow\">");
                Response.Write("<td></td><td colspan=\"16\">");
                Response.Write("<table width=\"100%\" cellspacing=\"0\" cellpadding=\"1\" style=\"font-size:0.9em; background-color:#FFF;\" >");
                Response.Write("<colgroup>");
                Response.Write("<col style=\"width:300px\" />");
                Response.Write("<col style=\"width:300px\" />");
                Response.Write("<col style=\"width:100px\" />");
                Response.Write("<col style=\"width:100px\" />");
                Response.Write("<col style=\"width:200px\" />");
                Response.Write("<col style=\"width:50px\" />");
                Response.Write("</colgroup>");
                Response.Write("<tr height=\"15\" >");
                
                Response.Write("<td>Group Part No: " + rs.Fields["GroupPartNo"].Value.As<String>() + " (" + rs.Fields["Identifier"].Value.As<String>() + ")"   + "</td><td>SN: " + rs.Fields["PartGroupSerialNoBegin"].Value.As<String>() + " - " + rs.Fields["PartGroupSerialNoEnd"].Value.As<String>() + "</td><td>Type: " + rs.Fields["RBOMTypeInd"].Value.As<String>() + "</td><td>Status: " + rs.Fields["RBOMStatusCode"].Value.As<String>() + "</td><td>Arrangement No: " + rs.Fields["RBOMArrangmentNo"].Value.As<String>() + "</td>");
                //Response.Write("<td><input type=\"checkbox\" name=\"GrpPartNo" + iCounter + "\" onclick=\"clickGroupPartNo(this)\" value=\"" + rs.Fields["HeaderSeqNo"].Value.As<String>() + "\"/></td>");
                Response.Write("<td><input type=\"checkbox\" name=\"GrpPartNo" + iCounter + "\" onclick=\"clickGroupPartNo(this)\" value=\"" + rs.Fields["GroupPartNo"].Value.As<String>() + "\"/></td>");  //<CODE_TAG_101936>R.Z
                Response.Write("<tr/></table>");
                Response.Write("</td>");
                Response.Write("</tr>");
            }
            else
            {
                
                xcounter = 0;//</Code_Tag_101936>
                iCounter = iCounter + 1;
                iDBSROId = rs.Fields["DBSRepairOptionId"].Value.As<int?>();
                iRepairOptionPricingID = rs.Fields["RepairOptionPricingID"].Value.As<int?>(); 
                sModel = rs.Fields["Model"].Value.As<string>();
                sJobCode = rs.Fields["JobCode"].Value.As<string>();
                sCompCode = rs.Fields["ComponentCode"].Value.As<string>();
                sModifierCode = rs.Fields["ModifierCode"].Value.As<string>();
                sModifierDesc = rs.Fields["ModifierDesc"].Value.As<string>();
                sQuantityCode = rs.Fields["QuantityCode"].Value.As<string>();
                sQuantityDesc = rs.Fields["QuantityDesc"].Value.As<string>(); 
                sJobLocationCode = rs.Fields["JobLocationCode"].Value.As<string>();
                sDesc = rs.Fields["JobCodeDesc"].Value.As<string>() + " " + rs.Fields["ComponentCodeDesc"].Value.As<string>() + " " + rs.Fields["ModifierDesc"].Value.As<string>() + " " + rs.Fields["JobLocationDesc"].Value.As<string>() + " " + sQuantityDesc;
                sShopFieldCode = rs.Fields["ShopFieldCode"].Value.As<string>();

                sCabType = rs.Fields["CabType"].Value.As<string>();
                sWorkApplicationCode = rs.Fields["WorkApplicationCode"].Value.As<string>();
            
                //<fxiao, 2010-02-03::Merge v2 changes />
                iLabourHours = rs.Fields["FRPriceHours"].Value.As<double?>();

                sBusinessgroupCode = rs.Fields["BusinessGroup"].Value.As<string>();
                sBusinessgroupDesc = rs.Fields["BusinessGroupDesc"].Value.As<string>(); 
            
                if (iLabourHours.IsNullOrWhiteSpace())
                {
                    iLabourHours = 0;
                }
                iPartsAmount = rs.Fields["PartsStdDollarAmount"].Value.As<double?>();
                if (iPartsAmount.IsNullOrWhiteSpace())
                {
                    iPartsAmount = 0;
                }
                iLabourAmount = rs.Fields["LabourStdDollarAmount"].Value.As<double?>();
                if (iLabourAmount.IsNullOrWhiteSpace())
                {
                    iLabourAmount = 0;
                }
                iMiscAmount = rs.Fields["MiscStdDollarAmount"].Value.As<double?>();
                if (iMiscAmount.IsNullOrWhiteSpace())
                {
                    iMiscAmount = 0;
                }
                iTotalAmount = iPartsAmount + iLabourAmount + iMiscAmount;
            
                //==========================================Repair Option Row==============================================
                Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=" + sColour + ">");

                //Response.Write("<td width=\"50\">");

                if (sMode == "Add")
                {
                    Response.Write("<td width=\"20px\">");   //<CODE_TAG_104228>
                    Response.Write("<input class=\"f btn\" type=\"button\" value=\"View\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "GUI=OFF&Mode=Add&ROId=" + iDBSROId + "&QuoteId=" + iQuoteId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&sFR=" + Server.UrlEncode(sFR)  + "'\" /></td>");
                }
                else
                {   
                    //Response.Write("<td width=\"50\">");
                    //Response.Write("<input class=\"f btn\" type=\"button\" value=\"View\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&ROId=" + iDBSROId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR)  + "'\" ></td>");
                    //<Code_Tag_101936>
                    Response.Write("<td width=\"20px\">");   //<CODE_TAG_104228>
                    //Response.Write("<img src=\"../../library/images/magnifier.gif\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&ROId=" + iDBSROId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR)  + "'\" class=\"imgBtn\"></td>");
                    //<CODE_TAG_103823>
                    //Response.Write("<img src=\"../../library/images/magnifier.gif\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&ROId=" + iDBSROId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR)  + "'\" class=\"imgBtn\"><input class=\"hidGrpPartNo\" name='hidGrpPartNo" +  iCounter+ "' type=\"hidden\"></td>"); 
                    string repairOptionDetailPageUrl = this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&IND=S&ROId=" + iDBSROId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR);    //<CODE_TAG_104228>
                    Response.Write("<img src=\"../../library/images/magnifier.gif\" onClick=\"getRepariOptionDetailPageUrl(" +  iCounter+ ");\" class=\"imgBtn\"><input class=\"hidGrpPartNo\" id='hidGrpPartNo" +  iCounter+ "' name='hidGrpPartNo" +  iCounter+ "' type=\"hidden\" detailPageUrl = \"" + repairOptionDetailPageUrl +"\"></td>"); 
                    //</CODE_TAG_103823>                    
                 //   Response.Write("<input class=\"f btn\" type=\"button\" value=\"View\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&ROId=" + iDBSROId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR)  + "'\" ></td>");
                }
                
                if (!rs.Fields["GroupPartNo"].Value.As<String>().IsNullOrWhiteSpace())
                {
                    Response.Write("<td width=\"20px\">*P*<br/>");   //<CODE_TAG_104228>
                    Response.Write("<a href=\"javascript:void(0)\" onclick=\"showPartGroup(this)\">(+)</a>");
                    Response.Write("<a href=\"javascript:void(0)\" onclick=\"hidePartGroup(this)\" style=\"display:none\">(-)</a></td>");
                }
                else
                {
                    Response.Write("<td width=\"20px\"></td>");//</Code_Tag_101936>//<CODE_TAG_104228>
                }
                //<CODE_TAG_104228> add width 
                Response.Write("<td style=\"width:50px\" >" + sJobCode + "</td>");
                Response.Write("<td style=\"width:50px\" >" + sCompCode + "</td>");
                Response.Write("<td style=\"width:50px\" title=\"" + sModifierDesc + "\">" + sModifierCode + "</td>");
                Response.Write("<td style=\"width:\">"+ sDesc + "</td>");

                Response.Write("<td style=\"width:50px\">" + sJobLocationCode + "</td>");
                Response.Write("<td style=\"width:50px\">" + sCabType + "</td>");
                Response.Write("<td style=\"width:50px\">" + sWorkApplicationCode + "</td>");
            
                if (sBusinessgroupCode.IsNullOrWhiteSpace())
                    Response.Write("<td style=\"width:50px\"></td>");
                else
                    Response.Write("<td style=\"width:50px\">" + sBusinessgroupDesc + " (" + sBusinessgroupCode + ")" + "</td>");
                Response.Write("<td style=\"width:50px\">" + sShopFieldCode + "</td>"); 
                Response.Write("<td style=\"width:50px\" title=\"" + sQuantityDesc + "\">" + sQuantityCode + "</td>");
                Response.Write("<td style=\"width:70px\">" + Util.NumberFormat(iLabourHours, 2, null, null, null) + "</td>"); /*NOTE: Manual Fixup - removed Strings.FormatNumber(iLabourHours, 1, TriState.False, TriState.True, TriState.UseDefault)*/
                Response.Write("<td style=\"width:70px\">" + Util.NumberFormat(iPartsAmount, 2, null, null, null) + "</td>"); /*NOTE: Manual Fixup - removed Strings.FormatNumber(iPartsAmount, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                Response.Write("<td style=\"width:70px\">" + Util.NumberFormat(iLabourAmount, 2, null, null, null) + "</td>"); /*NOTE: Manual Fixup - removed Strings.FormatNumber(iLabourAmount, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                Response.Write("<td style=\"width:70px\">" + Util.NumberFormat(iMiscAmount, 2, null, null, null) + "</td>");  /*NOTE: Manual Fixup - removed Strings.FormatNumber(iMiscAmount, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                Response.Write("<td style=\"width:70px\">" + Util.NumberFormat(iTotalAmount, 2, null, null, null) + "</td>");  /*NOTE: Manual Fixup - removed Strings.FormatNumber(iTotalAmount, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                //<CODE_TAG_104228> end
           
                if (PageMode == "AddSegments")
                    //Response.Write("<td ><input class=\"f btn\" type=\"button\" value=\"Add\" onClick=\"AddSegments(" + iDBSROId + "," + iRepairOptionPricingID + ");\"  ></td>"); 
                    Response.Write("<td class=\"stGroupCheckTD\" style=\"width:10px\"><input type=\"checkbox\" onclick=\"selectPartGroup(this)\" name=\"addCheck\" value=\"" + iDBSROId + "," + iRepairOptionPricingID + "," + "%" + ", " + sType + "\" ><input type=\"hidden\" name=\"stGroup\" value=\"\"></td>"); //<Code_Tag_101936>//<CODE_TAG_104228>  //remove % by victor wang

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
                //<Code_Tag_101936>
                if (!rs.Fields["GroupPartNo"].Value.As<String>().IsNullOrWhiteSpace())
                {
                    
                    xcounter = xcounter + 1;
                    sGroupPartNoPrev = rs.Fields["GroupPartNo"].Value.As<String>();
                    Response.Write("<tr class=\"subRow\">");
                    Response.Write("<td></td><td colspan=\"16\">");
                    Response.Write("<table width=\"100%\" cellspacing=\"0\" cellpadding=\"1\" style=\"font-size:0.9em; background-color:#FFF; \" >");
                    Response.Write("<colgroup>");
                    Response.Write("<col style=\"width:300px\" />");
                    Response.Write("<col style=\"width:300px\" />");
                    Response.Write("<col style=\"width:100px\" />");
                    Response.Write("<col style=\"width:100px\" />");
                    Response.Write("<col style=\"width:200px\" />");
                    Response.Write("<col style=\"width:50px\" />");
                    Response.Write("</colgroup>");
                    Response.Write("<tr height=\"15\">");
                    
                    Response.Write("<td>Group Part No: " + rs.Fields["GroupPartNo"].Value.As<String>()  + " (" + rs.Fields["Identifier"].Value.As<String>() + ")"  + "</td><td>SN: " + rs.Fields["PartGroupSerialNoBegin"].Value.As<String>() + " - " + rs.Fields["PartGroupSerialNoEnd"].Value.As<String>() + "</td><td>Type: " + rs.Fields["RBOMTypeInd"].Value.As<String>() + "</td><td>Status: " + rs.Fields["RBOMStatusCode"].Value.As<String>() + "</td><td>Arrangement No: " + rs.Fields["RBOMArrangmentNo"].Value.As<String>() + "</td>");
                    //Response.Write("<td><input type=\"checkbox\" name=\"GrpPartNo" + iCounter + "\" onclick=\"clickGroupPartNo(this)\" value=\"" + rs.Fields["HeaderSeqNo"].Value.As<String>() + "\"/></td>");
                    Response.Write("<td><input type=\"checkbox\" name=\"GrpPartNo" + iCounter + "\" onclick=\"clickGroupPartNo(this)\" value=\"" + rs.Fields["GroupPartNo"].Value.As<String>() + "\"/></td>");  //<CODE_TAG_101936>
                    Response.Write("<tr/></table>");
                    Response.Write("</td>");
                    Response.Write("</tr>");
                }

            }//</Code_Tag_101936>
            rs.MoveNext();
        }
     
        //HtmlHelper.Pager(iStartRecord.As<int>(), iPageSize.As<int>(), iRecordCount.As<int>(), strURLPath, System.Web.Mvc.FormMethod.Get, null, scolspan);
        HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Get, "hdnStartRecordId");
        //<CODE_TAG_104228> start
        if (PageMode == "AddSegments")
            Response.Write("<tr height=\"20\" class=\"thc\" ><td><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></td><td colspan=\"16\" class=\"t11 tSb\"></td><td><input class=\"f btn\" type=\"button\" value=\"Add\" onClick=\"AddSegments(this.form);\"  ></td></tr>");
    
        
    }
    Response.Write("</table>");
    rs = rs.NextRecordset();
    mRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
    rs = rs.NextRecordset();

    if (rs.EOF && iRecordCount ==0)
    {
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
        Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string)GetLocalResourceObject("rkHeaderText_NoInfoFound")+"</font></td></tr>");
        Response.Write("</table>");
    }
    else if (!rs.EOF) 
    {
        //***************************Header*********************************************************************************
        if (iRecordCount ==0)
        {
            Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"border: 1px solid #cccccc; background: #efefef;\">");
            Response.Write("<tr class=\"t11\">");
            if (sFR == "")
            {
                Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_Model")+"</td>");
                Response.Write("<td>" + rs.Fields["Model"].Value.As<string>() + "</td>");
            }
            else
            {
                Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;Flate Rate Exchange</td>");
                Response.Write("<td>" + sFR + "</td>");
            }
            Response.Write("</tr>");
            Response.Write("<tr class=\"t11\">");
            if (sFR == "")
            {
                Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_SerialNoBegin")+"</td>");
                Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<string>() + "</td>");
            }
            else
            {
                Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;</td>");
                Response.Write("<td></td>");
            }
            Response.Write("<td class=\"t11 tSb\" width=\"10%\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_BusinessGroup") + "</td>");
            Response.Write("<td>" + (sBusinessGroup.DefaultIfNullOrWhiteSpace(String.Empty).Replace("%", "").IsNullOrWhiteSpace() ? (string)GetLocalResourceObject("rkHeaderText_BusinessGroup_All") : sBusinessGroupDesc) + "<input id='stBusinessGroup' type='hidden' value='" + sBusinessGroup + "' />" + "</td>");  //<CODE_TAG_103916>
     
            Response.Write("</tr>");
            Response.Write("<tr class=\"t11\">");
            if (sFR == "")
            {
                Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_SerialNoEnd") + "</td>");
                Response.Write("<td></td>");
            }
            else
            {
                Response.Write("<td class=\"t11 tSb\" width=\"75\">&nbsp;</td>");
                Response.Write("<td></td>");
            }
            if (blnWorkApplicationCodesShow)
            {
                Response.Write("<td class=\"t11 tSb\" nowrap>&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_WorkApplicationCode") + "</td>");
                //Response.Write("<td>" + sWorkApplicationCodeDesc + "</td>");
                Response.Write("<td>" + sWorkApplicationCodeDesc + "<input type='hidden' id='stAppCode' value='" + sWorkApplicationCode + "'>"+ "</td>");//<CODE_TAG_103916> 
            }
            Response.Write("</tr>");
            Response.Write("</table>");
        }

		string premodel="", preproductBaseIdentifier="", preserialNo="", prejobCode="", precomponentCode="", premodifierCode="", prequantityCode="", prejoblocationCode="", prebusinessGroup="", presegmentBusinessGroup="";
		string curmodel="", curproductBaseIdentifier="", curserialNo="", curjobCode="", curcomponentCode="", curmodifierCode="", curquantityCode="", curjoblocationCode="", curbusinessGroup="", cursegmentBusinessGroup="";
		bool sameGroup = false, sameBusinessGroup = false;
		string desc;
		int rowSpan;


        Response.Write("<div>Multi-Segments:</div>");
        Response.Write("<table Class='tbl' width=\"100%\" cellspacing=\"1\" cellpadding=\"2\" border=\"0\" >");
        
        //***************************Details*********************************************************************************
        Response.Write("<tr class=\"thc\" >");  //id=\"rshl\" class=\"thc\"
        
        Response.Write("<th align=\"left\" class=\"thc\" rowspan='2'><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></th>");//<Code_Tag_101936>
        Response.Write("<th class=\"thc\" rowspan='2'>&nbsp;"+(string)GetLocalResourceObject("rkHeaderText_Job")+"</th>");
        Response.Write("<th class=\"thc\" rowspan='2'>&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_Comp") + "</th>");
        Response.Write("<th class=\"thc\" rowspan='2'>&nbsp;" + (string)GetLocalResourceObject("rkHeaderText_Description") + "</th>");
        Response.Write("<td class=\"thc\" align=\"middle\" colspan='9'>&nbsp;Segment</td>");
        if (PageMode == "AddSegments")
            Response.Write("<td class=\"t11 tSb\" colspan='2' align=\"middle\"><input class=\"f btn\" type=\"button\" value=\"Add\" onClick=\"AddSegments(this.form);\"  ></td>");//<Code_Tag_101936>      
        //Response.Write("<th class=\"thc\" rowspan='2'></th>");
        Response.Write("</tr>");
        Response.Write("<tr class=\"thc\" >");
        Response.Write("<th class=\"thc\">Business<br/> Group</th>");

        Response.Write("<th class=\"thc\">Job</th>");
        Response.Write("<th class=\"thc\">Comp</th>");
        Response.Write("<th class=\"thc\">Descirption</th> ");
        Response.Write("<th class=\"thc\">" + (string)GetLocalResourceObject("rkHeaderText_LaborHours") + "</th>");
        Response.Write("<th class=\"thc\">" + (string)GetLocalResourceObject("rkHeaderText_PartsAmt") + "</th>");
        Response.Write("<th class=\"thc\">" + (string)GetLocalResourceObject("rkHeaderText_LaborAmt") + "</th>");
        Response.Write("<th class=\"thc\">" + (string)GetLocalResourceObject("rkHeaderText_MiscAmt") + "</th>");
        Response.Write("<th class=\"thc\">" + (string)GetLocalResourceObject("rkHeaderText_TotalAmt") + "</th>");
        if (PageMode == "AddSegments")
        {
            Response.Write("<th class=\"thc\">" + "Group Select" + "</th>");
            Response.Write("<th class=\"thc\">" + "Segment Select" + "</th>");
        }
        Response.Write("</tr>");
        sColour = "white";
        iCounter = 0;
        int iGroup = 0;
        var xcounter = 0;//<Code_Tag_101936>
        blnGroupPartNoMultiSelection = AppContext.Current.AppSettings.IsTrue("psQuoter.RepairOption.GroupPartNo.MultiSelection.Enabled");//<Code_Tag_101936>
        while(!(rs.EOF))
        {
					curmodel = rs.Fields["model"].Value.As<string>();
					curproductBaseIdentifier= rs.Fields["productBaseIdentifier"].Value.As<string>();
					curserialNo= rs.Fields["serialNo"].Value.As<string>();
					curjobCode= rs.Fields["jobcode"].Value.As<string>();
					curcomponentCode= rs.Fields["componentCode"].Value.As<string>();
					curmodifierCode= rs.Fields["modifierCode"].Value.As<string>();
					curquantityCode= rs.Fields["quantityCode"].Value.As<string>();
					curjoblocationCode= rs.Fields["joblocationCode"].Value.As<string>();
					cursegmentBusinessGroup = rs.Fields["segmentBusinessGroup"].Value.As<string>();
                    iDBSROIds = rs.Fields["MultiSegmentJobIds"].Value.As<string>().Trim();
                    iRepairOptionPricingIDs = rs.Fields["RepairOptionPricingIDs"].Value.As<string>().Trim();
                    iDBSROId = rs.Fields["MultiSegmentJobId"].Value.As<int?>();
                    iRepairOptionPricingID = rs.Fields["RepairOptionPricingID"].Value.As<int?>();
					if (premodel == curmodel && preproductBaseIdentifier ==curproductBaseIdentifier && preserialNo ==curserialNo &&  prejobCode == curjobCode && precomponentCode== curcomponentCode && premodifierCode ==curmodifierCode &&  prequantityCode == curquantityCode &&  prejoblocationCode == curjoblocationCode)
						sameGroup = true;
					else
						sameGroup = false;

					int idx1 = 0;
					int idx2 = 0;
					string sClass1 = "";
					string sClass2 = "";

					if (!sameGroup)
					{
						idx2 = idx1;
						sClass1 = (idx1 % 2 == 0) ? "rd" : "rl";
						Response.Write("<tr class=\"" + sClass1 + "\">");
					}
					else
					{
						idx2++;
						sClass2 = (idx2 % 2 == 0) ? "rd" : "rl";
						Response.Write("<tr class=\"" + sClass2 + "\">");
					}

					rowSpan = rs.Fields["GroupRowsCount"].Value.As<int>();//getGroupRowsCount(dataOptions_Multi, curmodel, curproductBaseIdentifier, curserialNo, curjobCode, curcomponentCode, curmodifierCode, curquantityCode, curjoblocationCode);
                    int rowSpanG = rowSpan;
					if (!sameGroup)
					{
                        iGroup = 0;
                        iCounter = iCounter + 1;
                        if (sMode == "Add")
                        {
                            Response.Write("<td rowspan='" + rowSpan +">");
                            Response.Write("<input class=\"f btn\" type=\"button\" value=\"View\" onClick=\"document.location.href='" + this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "GUI=OFF&Mode=Add&ROId=" + iDBSROIds + "&ROPID=" + iRepairOptionPricingIDs + "&QuoteId=" + iQuoteId + "&StoreNo=" + Server.UrlEncode(sStoreNo) + "&BusinessGroup=" + Server.UrlEncode(sBusinessGroup) + "&ROPID=" + iRepairOptionPricingID + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&sFR=" + Server.UrlEncode(sFR)  + "'\" /></td>");
                        }
                        else
                        {   
                            string repairOptionDetailPageUrl = this.CreateUrl("modules/RepairOption/RepairOption_Details.aspx", normalizeForAppending: true) + "LMENU=OFF&IND=M&ROId=" + iDBSROIds + "&ROPID=" + iRepairOptionPricingIDs  + "&SFC=" + Server.UrlEncode(sShopFieldCode) + "&Model=" + Server.UrlEncode(curmodel) + "&ProductBaseIdentifier=" + Server.UrlEncode(curproductBaseIdentifier) + "&SerialNo=" + Server.UrlEncode(curserialNo) + "&JobCode=" + Server.UrlEncode(curjobCode) + "&ComponentCode=" + Server.UrlEncode(curcomponentCode) + "&JoblocationCode=" + Server.UrlEncode(curjoblocationCode) + "&ModifierCode=" + Server.UrlEncode(curmodifierCode) + "&QuantityCode=" + Server.UrlEncode(curquantityCode) + "&TT=" + TT + "&PageMode=" + PageMode  + "&sFR=" + Server.UrlEncode(sFR);                               
                            Response.Write("<td rowspan='" + rowSpan +"'>");
                            Response.Write("<img src=\"../../library/images/magnifier.gif\" onClick=\"getMultiRepariOptionDetailPageUrl(" +  iCounter+ ");\" class=\"imgBtn\"><input class=\"hidMultiGrpPartNo\" id='hidMultiGrpPartNo" +  iCounter+ "' name='hidMultiGrpPartNo" +  iCounter+ "' type=\"hidden\" detailPageUrl = \"" + repairOptionDetailPageUrl +"\"></td>"); 
                        }

						idx1++;
						//rowSpan = rs.Fields["GroupRowsCount"].Value.As<int>();//getGroupRowsCount(dataOptions_Multi, curmodel, curproductBaseIdentifier, curserialNo, curjobCode, curcomponentCode, curmodifierCode, curquantityCode, curjoblocationCode);
						Response.Write("<td rowspan='" + rowSpan +"' valign='top'>" +  curjobCode + "</td>");
						Response.Write("<td rowspan='" + rowSpan +"' valign='top'>" +  curcomponentCode + "</td>");
					
						desc = rs.Fields["JobCodeDesc"].Value.As<string>()+ " " + rs.Fields["ComponentCodeDesc"].Value.As<string>()+ " " + rs.Fields["ModifierCodeDesc"].Value.As<string>()+ " " + rs.Fields["QuantityCodeDesc"].Value.As<string>()+ " " + rs.Fields["JobLocationCodeDesc"].Value.As<string>();
						Response.Write("<td rowspan='" + rowSpan +"' valign='top'>" +  desc.Trim()  + "</td>");
					}
                    else iGroup++;

				   
					if (premodel == curmodel && preproductBaseIdentifier ==curproductBaseIdentifier && preserialNo ==curserialNo &&  prejobCode == curjobCode && precomponentCode== curcomponentCode && premodifierCode ==curmodifierCode &&  prequantityCode == curquantityCode &&  prejoblocationCode == curjoblocationCode && presegmentBusinessGroup == cursegmentBusinessGroup)
						sameBusinessGroup = true;
					else
						sameBusinessGroup = false;


					if (!sameBusinessGroup)
					{
						rowSpan = rs.Fields["SegmentBusinessGroupRowsCount"].Value.As<int>();//getSegmentBusinessGroupRowsCount(dataOptions_Multi, curmodel, curproductBaseIdentifier, curserialNo, curjobCode, curcomponentCode, curmodifierCode, curquantityCode, curjoblocationCode, cursegmentBusinessGroup);
						Response.Write("<td rowspan='" + rowSpan +"' valign='top'>" +  rs.Fields["SegmentBusinessGroup"].Value.As<string>() + ((rs.Fields["SegmentBusinessGroupDesc"].Value.As<string>() == "" )? "" : "-" + rs.Fields["SegmentBusinessGroupDesc"].Value.As<string>())  + "</td>");  //Code Change Request <CODE_TAG_101752> 
					
					}

					Response.Write("<td>" +  rs.Fields["SegmentJobCode"].Value.As<string>()  + "</td>");
					Response.Write("<td>" +  rs.Fields["SegmentComponentCode"].Value.As<string>()  + "</td>");
					desc = rs.Fields["SegmentJobCodeDesc"].Value.As<string>()+ " " + rs.Fields["SegmentComponentCodeDesc"].Value.As<string>()+ " " + rs.Fields["SegmentModifierCodeDesc"].Value.As<string>()+ " " + rs.Fields["SegmentQuantityCodeDesc"].Value.As<string>()+ " " + rs.Fields["SegmentJobLocationCodeDesc"].Value.As<string>();
					Response.Write("<td>" +  desc.Trim()  + "</td>");
					Response.Write("<td style='text-align:right'>" +  Util.NumberFormat(rs.Fields["FRPriceHours"].Value.As<double?>(), 2, null, null, null)   + "</td>");
					Response.Write("<td style='text-align:right'>" +  Util.NumberFormat(rs.Fields["PartsStdDollarAmount"].Value.As<double?>(), 2, null, null, null)  + "</td>");
					Response.Write("<td style='text-align:right'>" +  Util.NumberFormat(rs.Fields["LabourStdDollarAmount"].Value.As<double?>(), 2, null, null, null)  + "</td>");
					Response.Write("<td style='text-align:right'>" +  Util.NumberFormat(rs.Fields["MiscStdDollarAmount"].Value.As<double?>(), 2, null, null, null)  + "</td>");
					Response.Write("<td style='text-align:right'>" +  Util.NumberFormat(rs.Fields["totalDollarAmount"].Value.As<double?>(), 2, null, null, null) + "</td>");
                    if (PageMode == "AddSegments")
					{
                        if  (!sameGroup)  Response.Write("<td rowspan='" + rowSpanG +"' class=\"stGroupCheckTD\" align=\"middle\"><input type=\"checkbox\" onclick=\"selectPartGroup(this)\" id =\"addCheckGroup_" + iCounter +  "\" value=\"" + iDBSROIds + "," + iRepairOptionPricingIDs + "," + "%" + "," + "M" +"\" ><input type=\"hidden\" name=\"stGroup\" value=\"%\"></td>"); //<Code_Tag_101936>
                        Response.Write("<td class=\"stGroupCheckTD\" align=\"middle\"><input type=\"checkbox\" onclick=\"selectPartGroup(this)\" name=\"addCheck\" id =\"addCheckGroup_" + iCounter + "_" + iGroup + "\" value=\"" + iDBSROId + "," + iRepairOptionPricingID + "," + "%" + "," + "M" + "\" ><input type=\"hidden\" name=\"stGroup\" value=\"%\"></td>"); //<Code_Tag_101936>
                    }
					Response.Write("</tr>" );

					premodel = curmodel;
					preproductBaseIdentifier = curproductBaseIdentifier;
					preserialNo = curserialNo;
					prejobCode = curjobCode;
					precomponentCode = curcomponentCode;
					premodifierCode = curmodifierCode;
					prequantityCode = curquantityCode;
					prejoblocationCode = curjoblocationCode;
					presegmentBusinessGroup= cursegmentBusinessGroup;
            rs.MoveNext();
        }
     
        HtmlHelper.Pager(iStartRecord.As<int>(), mRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Get, "hdnStartRecordId");
    //<Code_Tag_101936>
    if (PageMode == "AddSegments")
        Response.Write("<tr height=\"20\" class=\"thc\" ><td><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></td><td colspan=\"12\" class=\"t11 tSb\"></td><td colspan=\"2\" align=\"middle\"><input class=\"f btn\"  type=\"button\" value=\"Add\" onClick=\"AddSegments(this.form);\"  ></td></tr>");
    //</Code_Tag_101936>        
    }
    //<CODE_TAG_104228> end
    rs.Close();

    rs = null;
    Util.CleanUp(cmd: cmd);
    	if (PageMode == "AddSegments")
		Response.Write("</table></div><br>");  //<CODE_TAG_104228>
	else
    Response.Write("</table><br>");
    Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"1\">");
    Response.Write("<input type=\"hidden\" name=\"hdnCheck\" value=\"0\">");
    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("</form>");



%>
<script type="text/javascript" language="javascript">
    //<Code_Tag_101936>
    $(document).ready(function () {
        $('tr.subRow').hide();
    }); //</Code_Tag_101936>

    function Search() {
        var iCancel = 0;

        if (iCancel != 1) {
            frmTRG.hdnOperation.value = 1;
            frmTRG.submit();
        }
    }

    function SubmitForm() {
        var i = window.event.keyCode;
        if (i == 13) {
            Search()
        }

    }
    function AddSegments(iDBSROId, iRepairOptionPricingID) {
        var fcaller = parent.frames['iFrameNewSegment'];
        //if (fcaller.setupWOSegmentNo) fcaller.setupStandardJob(iDBSROId, iRepairOptionPricingID, '%');
        //<CODE_TAG_104667>
        if (fcaller.setupWOSegmentNo) {
            fcaller.setupStandardJob(iDBSROId, iRepairOptionPricingID, '%');
        }
        else {
            if (fcaller.contentWindow.setupWOSegmentNo)
                fcaller.contentWindow.setupStandardJob(iDBSROId, iRepairOptionPricingID, '%');
        }
        //</CODE_TAG_104667>
        parent.closeStandardJobSearch();
    }
    //<CODE_TAG_104228> start
    function btnOkClick() {
        var url = "<%= this.StripKeysFromCurrentPage("JobCode,ComponentCode", normalizeForAppending: true) %>";
        url += "&JobCode=" + $("#cboJobCode").val() + "&ComponentCode=" + $("#cboComponentCode").val()
        document.location.href = url;

    }
    function btnModelClick() {
        var url = "RepairOptions_ByModel.aspx?TT=<%= TT%>&PageMode=<%=PageMode%>&Model=<%= sModel%>";
    document.location.href = url;
}
//<CODE_TAG_104228> end
//<Code_Tag_101936>
function AddSegments(frm) {
    //var cb =  //<CODE_TAG_104228> start
    if (parent.createNewSJSegment) {
        var sj = [],
        checks = $('[name=addCheck]'),
        partGroups = $('[name=stGroup]');

        for (i = 0; i < checks.length; i++) {
            if (checks[i].checked) {
                sj.push({ roid: checks[i].value.split(",")[0], pid: +checks[i].value.split(",")[1], group: partGroups[i].value });
            }
        }
        parent.createNewSJSegment(sj);

    }
    else { //<CODE_TAG_104228>end
        var iDBSROId = new Array();
        var iRepairOptionPricingID = new Array();
        var selectedGroup = new Array();
        var sTypeGroup = new Array();
        var stAppCode = $("#stAppCode").val(); //<CODE_TAG_103916>

        /*for (i = 0; i < frm.addCheck.length; i++) {
            if (frm.addCheck[i].checked) {
                //message = message + frm.Music[i].value + "\n"
                iDBSROId.push(frm.addCheck[i].value.split(",")[0]);
                iRepairOptionPricingID.push(frm.addCheck[i].value.split(",")[1]);
                selectedGroup.push(frm.stGroup[i].value);
                sTypeGroup.push(frm.addCheck[i].value.split(",")[3]);
            }
        }*/
        //<CODE_TAG_104875>
        if (frm.addCheck.length == undefined) {
            if (frm.addCheck.checked) {
                //alert(frm.addCheck.value);
                iDBSROId.push(frm.addCheck.value.split(",")[0]);
                iRepairOptionPricingID.push(frm.addCheck.value.split(",")[1]);
                selectedGroup.push(frm.stGroup.value);
                sTypeGroup.push(frm.addCheck.value.split(",")[3]);
            }
        }
        else {
            for (i = 0; i < frm.addCheck.length; i++) {
                if (frm.addCheck[i].checked) {
                    //message = message + frm.Music[i].value + "\n"
                    iDBSROId.push(frm.addCheck[i].value.split(",")[0]);
                    iRepairOptionPricingID.push(frm.addCheck[i].value.split(",")[1]);
                    selectedGroup.push(frm.stGroup[i].value);
                    sTypeGroup.push(frm.addCheck[i].value.split(",")[3]);
                }
            }
        }
        //</CODE_TAG_104875>

        var fcaller = parent.frames['iFrameNewSegment'];
        //if (fcaller.setupWOSegmentNo) fcaller.setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup);
        if (fcaller.setupWOSegmentNo) {
            fcaller.setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup, stAppCode, sTypeGroup); //<CODE_TAG_103916> 
            //fcaller.setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup, stAppCode, "S"); //R.Z & L.W changed for<CODE_TAG_104228> and <CODE_TAG_104406>
        }
        else {
            if (fcaller.contentWindow.setupWOSegmentNo)
                fcaller.contentWindow.setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup, stAppCode, sTypeGroup); //<CODE_TAG_103916> 
        }
        parent.closeStandardJobSearch();
    }
}
function selectPartGroup(element) {
    var b = $(element).parents('tr.t11');
    var a = $(b[0]).nextUntil('tr.t11');
    //<CODE_TAG_104228> start
    var name = $(element).attr("id");
    var sameLevelName;
    var level = 0;
    if (name != undefined) {
        level = (name.match(/_/g) || []).length;
        if (level == 1) name = name + "_";
        if (level == 2) {
            var n1 = name.indexOf("_");
            var n2 = name.indexOf("_", n1 + 1);
            name = name.substring(0, n2);
            sameLevelName = name + "_";
        }
    }
    if ($(element).is(':checked')) {
        //$(a).children().children().children().children().children().children().attr('checked', true);
        //$(element).next('input[name="stGroup"]').val("%");
        //$(element).next('input[name="stGroup"]').val($("#stBusinessGroup").val()); //<CODE_TAG_103916>
        $(a).show();
        // by victor wang
        if (level === 0 && $(a).find('[type="checkbox"]').length === 1) {
            var partGroup = $(a).find('[type="checkbox"]');
            $(partGroup).attr('checked', 'checked');
            $(element).next('input[name="stGroup"]').val($(partGroup).val());
        }


        if (level == 1)
            $("input[id*='" + name + "']").each(function () { $(this).attr('checked', 'checked'); });
        if (level == 2) {
            var bool = true;
            $("input[id*='" + sameLevelName + "']").each(function () { bool = bool && ($(this).prop('checked')) });
            if (bool)
                $("input[id*='" + name + "']").each(function () { $(this).attr('checked', 'checked'); });
        }

    }
    else {
        //$(a).children().children().children().children().children().children().attr('checked', false);
        $(a).hide();
        //by Victor Wang
        if (level === 0)
            $(a).find('[type="checkbox"]').removeAttr('checked');
        if (level == 1) ////Group UnSelect
            $("input[id*='" + name + "']").each(function () { $(this).removeAttr('checked');; });
        if (level == 2) ////Group UnSelect
            $("input[id='" + name + "']").each(function () { $(this).removeAttr('checked');; });
        //<CODE_TAG_104228> end
    }

}
function showPartGroup(element) {

    var b = $(element).parents('tr.t11');
    var a = $(b[0]).nextUntil('tr.t11');
    if (a != null) {
        $(a).show();
        $(element).hide();
        $(element).next().show();
    }
}
function hidePartGroup(element) {

    var b = $(element).parents('tr.t11');
    var a = $(b[0]).nextUntil('tr.t11');
    if (a != null) {
        $(a).hide();
        $(element).hide();
        $(element).prev().show();
    }

}
function clickGroupPartNo(element) {

    var groupname = $(element).prop("name");
    var groupPartNoList = $('input[name="' + $(element).prop("name") + '"]');
    var stGroup = "";
    var countcheck = 0;
    for (var i = 0; i < groupPartNoList.length; i++) {
        if (groupPartNoList[i].checked) {
            countcheck++;
            if ((i == 0) || (stGroup == "")) {
                stGroup = groupPartNoList[i].value;
            }
            else {
                stGroup = stGroup + ";" + groupPartNoList[i].value;
            }
        }
    }

    //if (countcheck == (groupPartNoList.length))
    //{ stGroup = "%"; }

    var b = $(element).parents('tr.subRow');
    var a = $(b[0]).prevAll('tr.t11').children("td.stGroupCheckTD").children('input[name="stGroup"]');
    var mainCheckBox = $(b[0]).prevAll('tr.t11').children("td.stGroupCheckTD").children('input[name="addCheck"]');

    $(a[0]).val(stGroup);
    if (countcheck == 0)
    { $(mainCheckBox[0]).attr('checked', false); }
    else
    { $(mainCheckBox[0]).attr('checked', true); }

    //<CODE_TAG_103823>
    //assgn the grpPartNo value to the hidden field hidGrpPartNo
    $("[name=" + element.name.replace("GrpPartNo", "hidGrpPartNo") + "]").val(stGroup);
    //</CODE_TAG_103823>
    //alert($(a).val())
}
//<CODE_TAG_103823>
function getRepariOptionDetailPageUrl(rowNum) {
    var url = $("#hidGrpPartNo" + rowNum).attr("detailPageUrl");
    //url = url + "&GrpPartNO=" + $("#hidGrpPartNo" + rowNum).val();
    url = url + "&GrpPartNO=" + encodeURIComponent($("#hidGrpPartNo" + rowNum).val());  //get the group part No info
    document.location.href = url;
    //alert(rowNum);
}
//</CODE_TAG_103823>
function getMultiRepariOptionDetailPageUrl(rowNum) {
    var url = $("#hidMultiGrpPartNo" + rowNum).attr("detailPageUrl");
    document.location.href = url;
    //alert(rowNum);
}


</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        if (/iPhone|iPod|iPad/.test(navigator.userAgent))
            $('#wrapper').css({
                'overflow-y': 'scroll',
                'overflow-x': 'hidden',
                '-webkit-overflow-scrolling': 'touch',
                height: $(parent.document.getElementById("divStandardJobSearch")).height(),
                width: $(parent.document.getElementById("divStandardJobSearch")).width()
            });
    });
    //</Code_Tag_101936>
    </script>
</asp:Content>