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
    
    string PageMode = Request.QueryString["PageMode"].AsString("");
    string Indicator= Request.QueryString["Ind"].AsString("");  //<CODE_TAG_104228>
    string TT = Request.QueryString["TT"].AsString("");
    string sFR = null;
    //<CODE_TAG_104228> start
    string iModel = Request.QueryString["Model"].AsString("");
    string iProductBaseIdentifier = Request.QueryString["ProductBaseIdentifier"].AsString("");
    string iSerialNo = Request.QueryString["SerialNo"].AsString("");
    string iJobCode = Request.QueryString["JobCode"].AsString("");
    string iComponentCode = Request.QueryString["ComponentCode"].AsString("");
    string iModifierCode = Request.QueryString["ModifierCode"].AsString("");
    string iQuantityCode = Request.QueryString["QuantityCode"].AsString("");
    string iJoblocationCode = Request.QueryString["JoblocationCode"].AsString("");
    int? inDBSROId = null;
    int? inRepairOptionPricingID = null;
    //<CODE_TAG_104228> end

    ModuleTitle = (string) GetLocalResourceObject("rkModTitle_Repair_Option_Details"); 
    
    if (0 == String.Compare(TemplateName, "Popup", StringComparison.InvariantCultureIgnoreCase))
    {
        sMode = "Add";
        scolspan = "13";
    }
    else
    {
        scolspan = "12";
    }
    iQuoteId = Request.QueryString["QuoteId"].As<int?>();
    iDBSRepairOptionId = Request.QueryString["ROId"].AsString(); //<CODE_TAG_104228>
    sStoreNo = Request.QueryString["StoreNo"].AsString();
    sBusinessGroup = Request.QueryString["BusinessGroup"].AsString();
    iRepairOptionPricingID = Request.QueryString["ROPID"].AsString(); //<CODE_TAG_104228>
    strOperation = Request.Form["hdnOperation"];
    sShopFieldCode = Request.QueryString["SFC"];
    sFR = Request.QueryString["SFR"].AsString("");
    //<CODE_TAG_103823>
    string sGrpPartNO = Request.QueryString["GrpPartNO"].AsString("");
    if (string.IsNullOrEmpty(sGrpPartNO))
        sGrpPartNO ="%";
    //</CODE_TAG_103823>
    if (!strOperation.IsNullOrWhiteSpace())
    {
            //===============================================================================================================
        if (strOperation == "Add")
        {
           
            cmd = new ADODB.CommandClass();
            //==================================Add Segment================================================'
            cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
            cmd.CommandText = "dbo.TRG_Add_QuoteSegment";
            cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
            sSegmentNo = (Request.Form["txtSegNo"] ?? String.Empty).Trim();
            sSegDesc = (Request.Form["hdnSegDesc"] ?? String.Empty).Trim();
            sSegDescHdn = (Request.Form["hdnSegDescHidden"] ?? String.Empty).Trim();
            cmd.Parameters.Append(cmd.CreateParameter("ReturnValue", ADODB.DataTypeEnum.adInteger,  ADODB.ParameterDirectionEnum.adParamReturnValue, 0, 0));
            cmd.Parameters.Append(cmd.CreateParameter("QuoteId", ADODB.DataTypeEnum.adInteger,  ADODB.ParameterDirectionEnum.adParamInput, 0, iQuoteId));
            cmd.Parameters.Append(cmd.CreateParameter("SegmentNo", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, 5, sSegmentNo));
            cmd.Parameters.Append(cmd.CreateParameter("Description", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, 3000, sSegDesc.Left(3000)));
            cmd.Parameters.Append(cmd.CreateParameter("HiddenDescription", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, 2000, sSegDescHdn.Left(2000)));
            cmd.Parameters.Append(cmd.CreateParameter("DBSRepairOptionId", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, 100, iDBSRepairOptionId));           //<CODE_TAG_104228>
            cmd.Parameters.Append(cmd.CreateParameter("RepairOptionPricingID", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, 100, iRepairOptionPricingID));   //<CODE_TAG_104228>
            cmd.Parameters.Append(cmd.CreateParameter("StoreNo", ADODB.DataTypeEnum.adWChar,  ADODB.ParameterDirectionEnum.adParamInput, 2, sStoreNo));
            cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger,  ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
            cmd.Parameters.Append(cmd.CreateParameter("QuoteSegmentId", ADODB.DataTypeEnum.adInteger,  ADODB.ParameterDirectionEnum.adParamOutput, 0, 0));
            cmd.Parameters.Append(cmd.CreateParameter("GroupPartNo", ADODB.DataTypeEnum.adVarWChar,  ADODB.ParameterDirectionEnum.adParamInput, -1, Request.Form["hdnSelectedGrpPart"]));
            cmd.Parameters.Append(cmd.CreateParameter("BusinessGroup", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 150, Request.QueryString["BusinessGroup"]));
            cmd.Execute();
            iQuoteSegmentId = cmd.Parameters["QuoteSegmentId"].Value.As<int?>();
           
            //If duplicate segment number
            iRV = cmd.Parameters["ReturnValue"].Value.As<int?>();
            cmd.Parameters.Clear();
            if (iRV == 1)
            {
                strError = String.Format((string) GetLocalResourceObject("rkErrMsg_already_exists"), sSegmentNo);
                strMsgTitle = (string) GetLocalResourceObject("rkErrMsg_Cannot_Add_Segment");
                strPageTitle = (string) GetLocalResourceObject("rkErrPgTitle_Add_New_Error");
            }
            else
            {
                Response.Write("<script language=\"javascript\">if(opener) opener.location.href = '" + this.CreateUrl("modules/quote/quote_addNew.aspx", normalizeForAppending: true) + "LMENU=ON&QuoteId=" + iQuoteId + "&Type=" + sType + "&CategoryId=" + iCategoryId + "&QuoteSegmentId=" + iQuoteSegmentId + "'; window.close();</script>");
            }
        }
    }
   
    //*************************************************************************************************************************
   
    cmd = new ADODB.CommandClass();
    cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmd.CommandText = "TRG_Get_RepairOptionDetails_List";   //<CODE_TAG_104228>
    cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmd.CommandTimeout = 120;
    cmd.Parameters.Append(cmd.CreateParameter("Indicator", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, Indicator));  //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("DBSRepairOptionId", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1000, iDBSRepairOptionId));   //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("StoreNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 2, sStoreNo));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessGroup", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, sBusinessGroup));
    cmd.Parameters.Append(cmd.CreateParameter("ShopFieldCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sShopFieldCode));
    //<fxiao, 2010-02-03::Merge v2 changes />
    cmd.Parameters.Append(cmd.CreateParameter("RepairOptionPricingID", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1000, iRepairOptionPricingID));   //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
    cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iStartRecord));
    cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, iPageSize));
    cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntity.BusinessEntityId));
    //<CODE_TAG_104228>
    cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 50, iModel ));   
    cmd.Parameters.Append(cmd.CreateParameter("ProductBaseIdentifier", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, iProductBaseIdentifier));
    cmd.Parameters.Append(cmd.CreateParameter("SerialNo", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, iSerialNo));
    cmd.Parameters.Append(cmd.CreateParameter("JobCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, iJobCode));
    cmd.Parameters.Append(cmd.CreateParameter("ComponentCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, iComponentCode));
    cmd.Parameters.Append(cmd.CreateParameter("ModifierCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, iModifierCode));
    cmd.Parameters.Append(cmd.CreateParameter("QuantityCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, iQuantityCode));
    cmd.Parameters.Append(cmd.CreateParameter("JoblocationCode", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 3, iJoblocationCode));
    cmd.Parameters.Append(cmd.CreateParameter("FlatRateEx", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sFR));
    //<CODE_TAG_104228>
    rs = new Recordset();
    rs = cmd.Execute();
    iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>();
    rs = rs.NextRecordset();
    
    
    
    //*************************************************************************************************************************
    Response.Write("<form method=\"post\" action id=\"frmTRG\">");
  Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
  
  if (AppContext.Current.User.Operation.CreateQuote)
  {
      if (sMode == "Add")
      {
          Response.Write("<tr>");
          Response.Write("<td align=right class=\"t11 tSb\" width=175>"+(string) GetLocalResourceObject("rkLbl_Enter_Segment_No_to_create")+"</td>");
          Response.Write("<td align=right width=50><input name=\"txtSegNo\" class=\"f w50\" maxlength=5 /></td>");
          Response.Write("<td align=right width=40><a href=\"javascript:void(0);\" onclick=\"AddToQuote();\">" + (string)GetLocalResourceObject("rkLink_Add_To_Quote") + "</a></td>"); 
          
          //>%<a href="javascript:void(0);" onclick="AddToQuote();"><%=(string) GetLocalResourceObject("rkLink_Add_To_Quote")>%</a>%< 
          //Response.Write("</td>");
          Response.Write("</tr>");
      }
      else
      {
          if (PageMode == "AddSegments")
          {
          //Response.Write("<tr><td align=\"right\"><a href=\"javascript:void(0);\" onClick=\"AddSegments();return false;\" >Add</a></td></tr>");
          //<Code_Tag_101936>
	      Response.Write("<tr>");
	      Response.Write("<td align=\"left\" class=\"t11 tSb\"><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></td>");
	      Response.Write("<td align=\"right\" class=\"t11 tSb\"><input class=\"f btn\" type=\"button\" value=\"Add\" onClick=\"AddSegments(); return false;\"  ></td>");
           //   Response.Write("<tr><td align=\"right\"><a href=\"javascript:void(0);\" onClick=\"AddSegments();return false;\" >Add</a></td></tr>");
 	      Response.Write("</tr>");
          //</Code_Tag_101936>
         }
          else
          {
          //Response.Write("<tr><td align=\"right\"><a href=\"javascript:void(0);\" onClick=\"checkGroupPartNoSelection();return false;\" >" + (string)GetLocalResourceObject("rkLink_Create_a_Quote") + "</a></td></tr>");
          //<Code_Tag_101936>
	      Response.Write("<tr>");
	      Response.Write("<td align=\"left\" class=\"t11 tSb\"><input class=\"f btn\" type=\"button\" value=\"Back\" onClick=\"window.history.back();\"  ></td>");
              Response.Write("<td align=\"right\"><a href=\"javascript:void(0);\" onClick=\"checkGroupPartNoSelection();return false;\" >" + (string)GetLocalResourceObject("rkLink_Create_a_Quote") + "</a></td>");
	      Response.Write("</tr>");
          //</Code_Tag_101936>
          }
      }
  }
  ///blnCreateQuote
  //Response.Write("</tr>");
  Response.Write("</table>");
   Response.Write("<input type=\"hidden\" name=\"hdnOperation\" />");
  Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
  if (rs.EOF)
  {
      Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
  }
  else
  {
      Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
      if (sFR != "")
      {
          Response.Write("<td>&nbsp;Flat Rate Exchange</td>");
      }
      else
      {
          Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Model") + "</td>");
          Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Begin_S_N") + "</td>");
          Response.Write("<td>&nbsp;" + (string)GetLocalResourceObject("rkHeader_End_S_N") + "</td>");
      }
      Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Job")+"</td>");
      Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Comp")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Modifier")+"</td>");
      Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Qty")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Labor_Hours")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Parts_Amt")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Labor_Amt")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkLbl_Misc_Amt")+"</td>");
      Response.Write("<td align=\"middle\">"+(string) GetLocalResourceObject("rkHeader_Total_Amt")+"</td>");
      Response.Write("<td align=\"middle\" width=75>"+(string) GetLocalResourceObject("rkHeader_Features_and_Benefits")+"</td>");
      //<CODE_TAG_104228> start
      if (Indicator == "M") 
      Response.Write("<td align=\"middle\" width=50>Select All<input id=\"SelectAll\" name=\"SelectAll\" type=\"checkbox\" title=\"Check/Uncheck All\" checked=\"check\" onclick=\"toggleSelectSegment();\" /></td>");
      //<CODE_TAG_104228> end
      Response.Write("</tr>");
       while(!(rs.EOF))  //<CODE_TAG_104228>
       {                 //<CODE_TAG_104228>
          iCounter = iCounter + 1;
          sModel = rs.Fields["Model"].Value.AsString();
          sJobCode = rs.Fields["JobCode"].Value.AsString();
          sCompCode = rs.Fields["ComponentCode"].Value.AsString();
          sModifierCode = rs.Fields["ModifierCode"].Value.AsString();
          sModifierDesc = rs.Fields["ModifierDesc"].Value.AsString();
          sQuantityCode = rs.Fields["QuantityCode"].Value.AsString();
          sQuantityDesc = rs.Fields["QuantityDesc"].Value.AsString();
          sJobLocationCode = rs.Fields["JobLocationCode"].Value.AsString();
          sDesc = rs.Fields["JobCodeDesc"].Value.As<String>() + " " + rs.Fields["ComponentCodeDesc"].Value.As<String>() + " " + rs.Fields["ModifierDesc"].Value.As<String>() + " " + rs.Fields["JobLocationDesc"].Value.As<String>();
          iLabourHours = 0;
          inDBSROId = rs.Fields["DBSRepairOptionId"].Value.As<int?>();   //<CODE_TAG_104228> 
          inRepairOptionPricingID = rs.Fields["RepairOptionPricingID"].Value.As<int?>();  //<CODE_TAG_104228>
          //int.TryParse(rs.Fields["FRPriceHours"].ToString(), out iLabourHours);
          iLabourHours = rs.Fields["FRPriceHours"].Value.As<Double>(0);
          if (iLabourHours.IsNullOrWhiteSpace())
          {
              iLabourHours = 0;
          }
          iPartsAmount = rs.Fields["PartsStdDollarAmount"].Value.As<Double>();
      
          if (iPartsAmount.IsNullOrWhiteSpace())
          {
              iPartsAmount = 0.0;
          }
          iLabourAmount = rs.Fields["LabourStdDollarAmount"].Value.As<Double>();
          if (iLabourAmount.IsNullOrWhiteSpace())
          {
              iLabourAmount = 0.0;
          }
          iMiscAmount = rs.Fields["MiscStdDollarAmount"].Value.As<Double>();
          if (iMiscAmount.IsNullOrWhiteSpace())
          {
              iMiscAmount = 0.0;
          }
          iTotalAmount = iPartsAmount + iLabourAmount + iMiscAmount;
          sFeaturesFile = rs.Fields["FeaturesAndBenefits"].Value.AsString();
      
          //==========================================Repair Option Row==============================================
          Response.Write("<tr valign=\"top\" class=\"t11\"  bgColor=" + sColour + ">");
          if (sFR != "")
          {
              Response.Write("<td width=\"50\">" + rs.Fields["flatRateExchangeCode"].Value.As<String>() + "</td>");
          }
          else
          {
              Response.Write("<td width=\"50\">" + sModel + "</td>");
              Response.Write("<td width=\"50\">" + rs.Fields["SerialNoBegin"].Value.As<String>() + "</td>");
              Response.Write("<td width=\"50\">" + rs.Fields["SerialNoEnd"].Value.As<String>() + "</td>");
          }
          Response.Write("<td width=\"25\">" + sJobCode + "</td>");
          Response.Write("<td width=\"40\">" + sCompCode + "</td>");
          Response.Write("<td width=\"50\" align=\"middle\" title=\"" + sModifierDesc + "\">" + sModifierCode + "</td>");
          Response.Write("<td><span id=spnDesc" + iCounter + ">" + sDesc + "</span></td>");
          Response.Write("<td width=\"25\" align=\"middle\" title=\"" + sQuantityDesc + "\">" + sQuantityCode + "</td>");
          Response.Write("<td width=\"40\" align=\"middle\">" + Strings.FormatNumber(iLabourHours, 2, TriState.False, TriState.True, TriState.UseDefault) + "</td>");
          Response.Write("<td width=\"50\" align=\"right\">" + Strings.FormatNumber(iPartsAmount, 2, TriState.False, TriState.True, TriState.UseDefault) + "</td>");
          Response.Write("<td width=\"50\" align=\"right\">" + Strings.FormatNumber(iLabourAmount, 2, TriState.False, TriState.True, TriState.UseDefault) + "</td>");
          Response.Write("<td width=\"50\" align=\"right\">" + Strings.FormatNumber(iMiscAmount, 2, TriState.False, TriState.True, TriState.UseDefault) + "</td>");
          Response.Write("<td width=\"50\" align=\"right\">" + Strings.FormatNumber(iTotalAmount, 2, TriState.False, TriState.True, TriState.UseDefault) + "</td>");
          if (sFeaturesFile.IsNullOrWhiteSpace() == false)
          {
              Response.Write("<td align=middle><a href=\"javascript:void(0);\" onclick=\"ViewFile();\">"+(string) GetLocalResourceObject("rkLink_View_File")+"</a></td>");
          }
          //<CODE_TAG_104228> start  
          else Response.Write("<td></td>");
          if (Indicator == "M")
          {
                Response.Write("<td class=\"stGroupCheckTD\" align=middle><input type=\"checkbox\"  checked=\"checked\" name=\"addCheck\" value=\"" + inDBSROId + "," + inRepairOptionPricingID + "," + "%" + "," + Indicator +"\" ><input type=\"hidden\" name=\"stGroup\" value=\"%\"></td>"); 
          }  
          //<CODE_TAG_104228> end  
          Response.Write("</tr>");
          rs.MoveNext();  
      }
  }
  Response.Write("</table><br>");
    rs = rs.NextRecordset();
    
    
    //***************************************Internal Notes***************************************/
   Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
   Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
   Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkLbl_Internal_Notes")+"</td></tr>");
   if (rs.EOF == false)
   {
       while(!(rs.EOF))
       {
           sIntNotes = sIntNotes + rs.Fields["JobDescription"].Value.As<String>() + " ";
           rs.MoveNext();
       }
       Response.Write("<tr class=\"t11\"><td>" + sIntNotes + "</td></tr>");
   }
   else
   {
       Response.Write("<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkMsg_No_internal_notes_found")+"</td></tr>");
   }
   Response.Write("</table><br>");
    rs = rs.NextRecordset();
    
    //***************************************External Notes***************************************/
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
    Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
    Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_External_Notes")+"</td></tr>");
    if (rs.EOF == false)
    {
        while(!(rs.EOF))
        {
            sExtNotes = sExtNotes + rs.Fields["JobDescription"].Value.As<String>() + " ";
            rs.MoveNext();
        }
        Response.Write("<tr class=\"t11\"><td>" + sExtNotes + "</td></tr>");
    }
    else
    {
        Response.Write("<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkMsg_No_external_notes_found")+"</td></tr>");
    }
    Response.Write("</table><br>");
    rs = rs.NextRecordset();
    blnGroupPartNoMultiSelection = AppContext.Current.AppSettings.IsTrue("psQuoter.RepairOption.GroupPartNo.MultiSelection.Enabled");
    sGroupPartNoPrev = "";
    x = 0;
    iGroupCount = 0;
    
    //Multi selection check boxes
    if (blnGroupPartNoMultiSelection)
    {
        Response.Write("<div class=\"t11\" id=\"groupPartsTogglerWrapper\">");
        Response.Write("<input type=\"checkbox\" checked=\"true\" id=\"lnkGroupPartsToggler\" onclick=\"clickGroupPartsToggler(this)\" /><label for=\"lnkGroupPartsToggler\">"+(string) GetLocalResourceObject("rkLbl_Check_Uncheck_All_Group_Parts")+"</label>");
        Response.Write("</div>");
    }
   Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\">");
   WriteGroupPartHeader();
   while(!(rs.EOF))
   {
         
       ////if (sGroupPartNoPrev != rs.Fields["GroupPartNo"].Value.As<String>())
       if (sGroupPartNoPrev != rs.Fields["GroupNo"].Value.As<String>())
       {
           ////sGroupPartNoPrev = rs.Fields["GroupPartNo"].Value.As<String>();
           sGroupPartNoPrev = rs.Fields["GroupNo"].Value.As<String>();
           Response.Write("<tr " + Util.RowClass(1) + "><td colspan=\"5\" style=\"font-weight:bold;\">");
           //Response.Write("<input type=\"" + (blnGroupPartNoMultiSelection ? "checkbox" : "radio") + "\" id=\"" + sGroupPartNoPrev + "\"" + (blnGroupPartNoMultiSelection ? " checked=\"true\"" : "") + " name=\"GrpPartNo\" onclick=\"clickGroupPartNo(this)\"/>" + (string)GetLocalResourceObject("rkLbl_Group_Part_No") + rs.Fields["GroupPartNo"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SN: " 
		   //       + rs.Fields["BaseSerialNoBegin"].Value.As<String>() + "&nbsp;&nbsp;" + "-" + "&nbsp;&nbsp;" + rs.Fields["BaseSerialNoEnd"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: " + rs.Fields["RBOMStatusCode"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Arrangement No: " + rs.Fields["RBOMArrangmentNo"].Value.As<String>() + "</td><tr/>");
           //<CODE_TAG_103823>
           bool cbxVal= false;
           string scurentGroupPartNo = rs.Fields["GroupPartNo"].Value.As<String>();
           if (sGrpPartNO != "%")
           {
                string[] arrGroupPart = sGrpPartNO.Split(';');

                
                for (int i = 0; i < arrGroupPart.Length; i++)
                {
                    if (scurentGroupPartNo == arrGroupPart[i])
                        cbxVal = true;
                }
            }
            else
            {
                cbxVal = true; 
            }
           Response.Write("<input type=\"" + ( (blnGroupPartNoMultiSelection) ? "checkbox" : "radio") + "\" id=\"" + sGroupPartNoPrev + "\"" + ( (blnGroupPartNoMultiSelection && cbxVal) ? " checked=\"true\"" : "") + " name=\"GrpPartNo\" value=\"" + rs.Fields["HeaderSeqNo"].Value.As<String>()  + "\" onclick=\"clickGroupPartNo(this)\"/>" + (string)GetLocalResourceObject("rkLbl_Group_Part_No") + rs.Fields["GroupPartNo"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SN: " 
		          + rs.Fields["BaseSerialNoBegin"].Value.As<String>() + "&nbsp;&nbsp;" + "-" + "&nbsp;&nbsp;" + rs.Fields["BaseSerialNoEnd"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: " + rs.Fields["RBOMStatusCode"].Value.As<String>() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Arrangement No: " + rs.Fields["RBOMArrangmentNo"].Value.As<String>() + "</td><tr/>");
            cbxVal = false;
           //</CODE_TAG_103823>
           x = 0;
           iGroupCount = iGroupCount + 1;
       }
       Response.Write("<tr " + Util.RowClass(x) + ">");
       Response.Write("<td>" + rs.Fields["SOS"].Value.As<String>() + "</td>");
       Response.Write("<td>" + rs.Fields["PartNo"].Value.As<String>() + "</td>");
       Response.Write("<td>" + rs.Fields["Description"].Value.As<String>() + "</td>");
       Response.Write("<td align=\"right\">" + rs.Fields["dealerUsuagepercent"].Value.As<String>() + "</td>"); //<CODE_TAG_105070>
       Response.Write("<td align=\"right\">" + rs.Fields["CATOrderQty"].Value.As<String>() + "</td>");
       Response.Write("<td align=\"center\">" + rs.Fields["RCMNDInd"].Value.As<String>() + "</td>");
       Response.Write("</tr>");
       x = x + 1;
       rs.MoveNext();
   }
   Response.Write("</table>");
    
    Response.Write("<input type=\"hidden\" name=\"hdnSelectedGrpPart\" />");
    Response.Write("<input type=\"hidden\" name=\"hdnSegDesc\" value=\"" + (sDesc ?? String.Empty).Trim() + (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.RepairOption.Description.BringExternalNotes", true) ?  (".  " + sExtNotes) : "") + "\" />");
    Response.Write("<input type=\"hidden\" name=\"hdnSegDescHidden\" value=\"" + (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.RepairOption.HiddenDescription.BringInternalNotes", true) ? sExtNotes : "") + "\" />");
    Response.Write("<input type=\"hidden\" name=\"hdnIndicator\" value=\""+ Indicator + "\"/>");   //<CODE_TAG_104228>
    Response.Write("</form>");
    rs.Close();
   
    rs = null;
    Util.CleanUp(cmd);
   
    Response.Write("<br>");
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

    var groupPartNoList = document.getElementsByName("GrpPartNo");
    var groupPartsToggler = document.getElementById("lnkGroupPartsToggler");
    var indicator = document.getElementsByName("hdnIndicator")[0].value;   //<CODE_TAG_104228>
    var DBSRepairOptionId="";   //<CODE_TAG_104228>
    var RepairOptionPricingID="";  //<CODE_TAG_104228>
    if(groupPartNoList.length == 1) {
        groupPartNoList[0].style.display = "none";}
    if(groupPartsToggler && groupPartNoList.length < 2) {
        document.getElementById("groupPartsTogglerWrapper").style.display = "none";
    }

    function clickGroupPartNo(element) {
        if(groupPartsToggler == null) return;
    
        var selectedItemCount = 0;
        for(var i=0; i<groupPartNoList.length; i++){
            if(groupPartNoList[i].checked) {
                selectedItemCount++;
            }
        }
    
        groupPartsToggler.checked = selectedItemCount == groupPartNoList.length;
    }

    function clickGroupPartsToggler(element) {
        var selected = element.checked;
    
        for(var i=0; i<groupPartNoList.length; i++)
            groupPartNoList[i].checked = selected;
    }

    //'[<IAranda 20080919> RepOptGrpPart.] START.
    function checkGroupPartNoSelection()
    {
        var sSelectedGroup;
        sSelectedGroup = "";
        sSelectedGroup = Trim(getGrpPrtNoList());
    
        if(groupPartNoList.length > 0 && sSelectedGroup == "") 
            return false;
        //<CODE_TAG_104228> start
        if (indicator=="M")
        {
            var sSelect = document.getElementsByName("addCheck");
            for (i = 0; i < sSelect.length; i++) {
                if (sSelect[i].checked) {                
                    DBSRepairOptionId = DBSRepairOptionId + sSelect[i].value.split(",")[0]+ ",";
                    RepairOptionPricingID = RepairOptionPricingID + sSelect[i].value.split(",")[1] + ",";                
                }
            }
            if (DBSRepairOptionId=="" && RepairOptionPricingID=="") {alert("Please select segment");        return false;}
            else
            {
                DBSRepairOptionId = DBSRepairOptionId.substring(0,DBSRepairOptionId.length-1 );
                RepairOptionPricingID = RepairOptionPricingID.substring(0,RepairOptionPricingID.length-1 );
                window.location.href = "<%=this.CreateUrl("modules/Quote/Quote_addnew.aspx", normalizeForAppending: true)%>LMENU=ON&Type=Q&SType=M&DBSROId=" + encodeURIComponent(DBSRepairOptionId) + "&StoreNo=<%= Server.UrlEncode(sStoreNo) %>&DBSROSelectedGroup=" + encodeURIComponent(sSelectedGroup) + "&DBSROPId=" + RepairOptionPricingID  ;
            return true;
        }
    } //<CODE_TAG_104228> end
    window.location.href = "<%=this.CreateUrl("modules/Quote/Quote_addnew.aspx", normalizeForAppending: true)%>LMENU=ON&Type=Q&SType=S&DBSROId=<%= iDBSRepairOptionId %>&StoreNo=<%= Server.UrlEncode(sStoreNo) %>&DBSROSelectedGroup=" + encodeURIComponent(sSelectedGroup) + "&DBSROPId=<%= iRepairOptionPricingID %>" ;
    return true;
}

function AddSegments()
{
    var sSelectedGroup;
    sSelectedGroup = "";
    sSelectedGroup = Trim(getGrpPrtNoList());
    
    if(groupPartNoList.length > 0 && sSelectedGroup == "") 
        return false;

    var fcaller = parent.frames['iFrameNewSegment'];
    if (fcaller.setupWOSegmentNo){
        if (indicator=="M")
        {
            var sSelect = document.getElementsByName("addCheck");
            for (i = 0; i < sSelect.length; i++)
                //<CODE_TAG_104228> start
            {
                if (sSelect[i].checked) {                
                    DBSRepairOptionId = DBSRepairOptionId + sSelect[i].value.split(",")[0]+ ",";
                    RepairOptionPricingID = RepairOptionPricingID + sSelect[i].value.split(",")[1] + ",";                
                }
            }
            if (DBSRepairOptionId=="" && RepairOptionPricingID=="") {alert("Please select segment");        return false;}
            else
            {
                DBSRepairOptionId = DBSRepairOptionId.substring(0,DBSRepairOptionId.length-1 );
                RepairOptionPricingID = RepairOptionPricingID.substring(0,RepairOptionPricingID.length-1 );
                //fcaller.setupStandardJob(DBSRepairOptionId, RepairOptionPricingID, sSelectedGroup, indicator);
                fcaller.setupStandardJob(DBSRepairOptionId, RepairOptionPricingID, sSelectedGroup, null, indicator); //R.Z & L.W changed for<CODE_TAG_104228> and <CODE_TAG_104406>
            }            
        }
        else   //<CODE_TAG_104228> end
            //fcaller.setupStandardJob(<%= iDBSRepairOptionId %>, <%= iRepairOptionPricingID %>, sSelectedGroup, indicator);}
            fcaller.setupStandardJob(<%= iDBSRepairOptionId %>, <%= iRepairOptionPricingID %>, sSelectedGroup, null, indicator);} //R.Z & L.W changed for<CODE_TAG_104228> and <CODE_TAG_104406>
    parent.closeStandardJobSearch();
}

function getGrpPrtNoList()
{
    var i,sSelectedGroup;
    var arrSelectedGroupNos = [];
    
    sSelectedGroup = "";

    for(i=0;i <= groupPartNoList.length-1; i++)
    {
        if(groupPartNoList[i].checked) arrSelectedGroupNos.push(groupPartNoList[i].value);
    }
    
    if(arrSelectedGroupNos.length == 0)
    {
        sSelectedGroup = "";	
		
        if(groupPartNoList.length > 1) 
            alert("<%=GetLocalResourceObject("rkMsg_Please_select_a_Group_Part_No").JavaScriptStringEncode()%>");
		else if(groupPartNoList.length == 1){
		    sSelectedGroup = groupPartNoList[0].value;
		}
    }
    else
    {
        sSelectedGroup = arrSelectedGroupNos.join(";");
    }	

   // if (sSelectedGroup == "") sSelectedGroup = "%";
    return sSelectedGroup;
}

function AddToQuote(){
    if (frmTRG.txtSegNo.value == ""){
        alert("<%=GetLocalResourceObject("rkMsg_You_must_enter_a_segment_number").JavaScriptStringEncode()%>");
	    frmTRG.txtSegNo.focus();
	}
	else {
	    var sGroupPartNo = getGrpPrtNoList();
	    
	    if(groupPartNoList.length > 0 && Trim(sGroupPartNo).IsNullOrWhiteSpace()) return;	    
	    frmTRG.hdnSelectedGrpPart.value = sGroupPartNo;		
	    frmTRG.hdnOperation.value = "Add";
	    frmTRG.submit();
        
	    setTimeout(function(){
	    }, 0
        )
	}
}

function ViewFile(){
    f = "modules/RepairOption/FeaturesAndBenefits/" + "<%= sFeaturesFile %>";
    window.open(f,"FAB","scrollbars=yes,menubar=no,toolbar=no,height=600,width=900,left=0,top=50");
}

</script>
<script language="C#" runat="server">

    int x;
    string scolspan;
    string sMode = null;
    int? iQuoteId = null;
    string iDBSRepairOptionId = null;  //<CODE_TAG_104228>
    string sStoreNo = null;
    string sBusinessGroup = null;
    string iRepairOptionPricingID = null;   //<CODE_TAG_104228>
    string sShopFieldCode = null;
    string sSegmentNo = null;
    string sSegDesc = null;
    string sSegDescHdn = null;
    int? iQuoteSegmentId = null;
    int? iRV = null;
    string strError = null;
    string strMsgTitle = null;
    string strPageTitle = null;
    string sType = null;
    int? iCategoryId = null;
    int? iStartRecord = null;
    int? iPageSize = null;
    int? iAdminCheck = null;
    int iCounter = 0;
    string sModel = null;
    string sJobCode = null;
    string sCompCode = null;
    string sModifierCode = null;
    string sModifierDesc = null;
    string sQuantityCode = null;
    string sQuantityDesc = null;
    string sJobLocationCode = null;
    string sDesc = null;
    double iLabourHours = 0;
    double iPartsAmount = 0.0;
    double iLabourAmount = 0.0;
    double iMiscAmount = 0.0;
    double iTotalAmount = 0.0;
    string sFeaturesFile = null;
    string sColour = null;
    string sIntNotes = null;
    string sExtNotes = null;
    string strLinkText = null;
    string strLinkUrl = null;
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    string strOperation = null;
    
    //****************************************BOM***************************************/
    string sGroupPartNoPrev = null;
    int iGroupCount = 0;
    bool blnGroupPartNoMultiSelection = false;
  
    
    
    string WriteGroupPartHeader() 
    {
        Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\">");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_SOS")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Part_No")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Description")+"</td>");
        Response.Write("<td>&nbsp; Usage%</td>");//<CODE_TAG_105070>
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Order_Qty")+"</td>");
        Response.Write("<td>&nbsp;Recommended</td>");
        Response.Write("</tr>");
        return null;
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
    //<CODE_TAG_104228> start
    function toggleSelectSegment() {
        var boolSelect = document.getElementById('SelectAll').checked;
        $('input[type=checkbox]').each(function () {
            if (boolSelect == true )  $(this).attr('checked', 'checked');
            else $(this).removeAttr('checked');            
        });             
    }
    //<CODE_TAG_104228>  end


    </script>
</asp:Content>