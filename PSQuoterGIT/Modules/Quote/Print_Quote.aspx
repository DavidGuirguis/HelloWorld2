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
<!--#include file="inc_Quote.aspx"-->
<!--#include file="inc_QuotePrint.aspx"-->
<%
    rs = GetPrintData();
    sType = rs.Fields["Type"].Value.As<String>();
    iNewCompDate = rs.Fields["NewCompletionDate"].Value.As<DateTime?>();
    sSRFaxNo = rs.Fields["SRFaxNo"].Value.As<String>();
    sTaxCode = rs.Fields["TaxCode1"].Value.As<String>();
    iDBSROCount = rs.Fields["DBSROCount"].Value.As<int?>();
    //BEGIN. <CODE_TAG_100877>  Ticket#7867  03/28/2011 kshao
    //sBranchAddress = rs("BranchAddress")
    sBranchAddress1 = rs.Fields["BranchAddress1"].Value.As<String>();
    sBranchAddress2 = rs.Fields["BranchAddress2"].Value.As<String>();
    //END.   //<CODE_TAG_100877>
    sBranchPhone = rs.Fields["BranchPhone"].Value.As<String>();
    //======================================QUOTE HEADER================================================
    sDivision = rs.Fields["division"].Value.As<String>();
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"98%\">");
    Response.Write("<tr>");
    Response.Write("<td align=\"" + rs.Fields["LogoAlign"].Value.As<String>() + "\" colspan=\"1\"><img src=\"" + GetQuoteLogoUrl(sDivision, rs.Fields["LogoFileExtension"].Value.As<String>()) + "\"></td>"); 
    Response.Write("<td class=\"t14 tSb\" align=\"right\">" + sBranchAddress1 + "<br>" + sBranchAddress2 + "<br>" + sBranchPhone + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr>");
    Response.Write("<td align=\"middle\" colspan=\"2\">&nbsp;</td>");
    Response.Write("</tr>");
    if (sType == "A")
    {
        Response.Write("<tr><td height=\"1px\"colspan=\"2\"></td></tr>");
        Response.Write("<tr>");
        Response.Write("<td class=\"t36 tSb\" height=\"60px\" valign=\"top\" align=\"middle\" colspan=\"2\">"+(string) GetLocalResourceObject("rkLbl_ADDITIONAL_REPAIR_NOTIFICATION")+"</td>");
        Response.Write("</tr>");
        colspan = "1";
    }
    else
    {
        colspan = "2";
    }
    Response.Write("<tr valign=\"top\">");
    Response.Write("<td class=\"t14 tSb\">" + rs.Fields["CustomerName"].Value.As<String>() + "</td>");
    if (sType == "Q")
    {
        if (iInternal == "1")
        {
            Response.Write("<td class=\"t24 tSb\" rowspan=\"3\" align=\"right\" nowrap>");
            Response.Write("Service Dept. Copy");
        }
        else
        {
            Response.Write("<td rowspan=\"3\" align=\"right\" nowrap>");
            Response.Write("<span style=\"font-family: arial, tahoma, helvetica; font-size: 48px; font-weight: bold;\">"+ rs.Fields["PrintHeaderText"].Value.As<String>() + "</span>");
            //[<IAranda 20080915> PrintConfig.]
            strHeaderText = rs.Fields["PrintHeaderText"].Value.As<String>();
        }
        Response.Write("</td>");
    }
    else
    {
        Response.Write("<td nowrap align=\"right\" class=\"t14 tSb\"><u>"+String.Format((string) GetLocalResourceObject("FAX_BACK_ASAP_TO"), sSRFaxNo) + "</u></td>");
    }
    Response.Write("</tr>");
    Response.Write("<tr class=\"t14 tSb\">");
    if (!rs.Fields["Address1"].Value.As<String>().IsNullOrWhiteSpace())
    {
        sAddress = rs.Fields["Address1"].Value.As<String>() + "<br>";
    }
    if (!rs.Fields["Address2"].Value.As<String>().IsNullOrWhiteSpace())
    {
        sAddress = sAddress + rs.Fields["Address2"].Value.As<String>();
    }
    if (!rs.Fields["Address3"].Value.As<String>().IsNullOrWhiteSpace())
    {
        sAddress = sAddress + "<br>" + rs.Fields["Address3"].Value.As<String>();
    }
    //sAddress = rs("Address1") & " " & rs("Address2") & " " & rs("Address3")
    Response.Write("<td>" + sAddress + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t14 tSb\">");
    sCity = rs.Fields["CityState"].Value.As<String>();
    sPostal = rs.Fields["ZipCode"].Value.As<String>();
    if (!sPostal.IsNullOrWhiteSpace())
    {
        sCity = sCity + ", " + sPostal;
    }
    Response.Write("<td>" + sCity + "</td>");
    Response.Write("</tr>");
    Response.Write("</table>");
    //======================================QUOTE HEADER DETAILS=========================================
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" border=\"1\" width=\"98%\" bgcolor=\"1px solid #000000;\">");
    Response.Write("<tr class=\"t11 tSb\" bgColor=\"lightgrey\" align=\"middle\">");
    Response.Write("<td width=\"100\">"+(string) GetLocalResourceObject("rkFrmLbl_CUSTOMER_NO")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_CONTACT")+"</td>");
    Response.Write("<td width=\"110\">"+(string) GetLocalResourceObject("rkFrmLbl_PHONE_NO")+"</td>");
    if (SRFaxNoLabel.IsNullOrWhiteSpace())
    {
        Response.Write("<td width=\"110\">"+(string) GetLocalResourceObject("rkFrmLbl_FAX_NO")+"</td>");
    }
    else
    {
        Response.Write("<td width=\"200\">" + SRFaxNoLabel + "</td>");
    }
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_EMAIL")+"</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\" bgcolor=\"#ffffff\" align=\"middle\">");
    Response.Write("<td>" + rs.Fields["CustomerNo"].Value.As<String>() + "</td>");
    Response.Write("<td nowrap>" + rs.Fields["ContactName"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["PhoneNo"].Value.As<String>() + "</td>");
    if (SRFaxNoLabel.IsNullOrWhiteSpace())
    {
        Response.Write("<td>" + rs.Fields["FaxNo"].Value.As<String>() + "</td>");
    }
    else
    {
        Response.Write("<td>" + rs.Fields["SRFaxNo"].Value.As<String>() + "</td>");
    }
    Response.Write("<td>" + rs.Fields["Email"].Value.As<String>() + "</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11 tSb\" bgColor=\"lightgrey\" align=\"middle\">");
    Response.Write("<td class=\"upper\">" + String.Format((string) GetLocalResourceObject("rkLbl__NO"), rs.Fields["PrintHeaderText"].Value.As<String>())+ "</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_P_O__NO")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_Date")+"</td>");
    Response.Write("<td colspan=\"" + colspan + "\">"+(string) GetLocalResourceObject("rkLbl_WORK_ORDER_NO")+"</td>");
    if (sType == "A")
    {
        Response.Write("<td nowrap>"+(string) GetLocalResourceObject("rkLbl_ORIGINAL_QUOTE_NO")+"</td>");
    }
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\" bgcolor=\"#ffffff\" align=\"middle\">");
    Response.Write("<td>" + rs.Fields["QuoteNo"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["PurchaseOrderNo"].Value.As<String>() + "</td>");
    Response.Write("<td>" + Util.DateFormat(rs.Fields["QuoteDate"].Value.As<DateTime?>()) + "</td>");
    Response.Write("<td colspan=\"" + colspan + "\">" + rs.Fields["WorkOrderNo"].Value.As<String>() + "</td>");
    if (sType == "A")
    {
        Response.Write("<td>" + rs.Fields["OriginalQuoteNo"].Value.As<String>() + "</td>");
    }
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11 tSb\" bgColor=\"lightgrey\" align=\"middle\">");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLabel_MAKE")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLabel_MODEL")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_SERIAL_NO")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_UNIT_NO")+"</td>");
    Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_HOURS")+"</td>");
    Response.Write("</tr>");
    Response.Write("<tr class=\"t11\" bgcolor=\"#ffffff\" align=\"middle\">");
    Response.Write("<td>" + rs.Fields["Make"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["Model"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["UnitNo"].Value.As<String>() + "</td>");
    Response.Write("<td>" + rs.Fields["Hours"].Value.As<String>() + "</td>");
    Response.Write("</tr>");
    Response.Write("</table><br>");
                                                                          Response.End();
    iQuoteTotal = rs.Fields["QuoteTotal"].Value.As<int?>();
    iEnvCharge = rs.Fields["EnvironmentalCharge"].Value.As<double?>();
    iGSTRate = rs.Fields["GSTRate"].Value.As<int?>();
    iPSTRate = rs.Fields["PSTRate"].Value.As<int?>();
    iEstRepTime = rs.Fields["EstimatedRepairTime"].Value.As<int?>();
    sSalesRep = rs.Fields["SRFName"].Value.As<String>() + " " + rs.Fields["SRLName"].Value.As<String>();
    sSalesRepPhoneNo = rs.Fields["SRPhoneNo"].Value.As<String>();
    sBranchPhone = rs.Fields["BranchPhone"].Value.As<String>();
    if ((!sBranchPhone.IsNullOrWhiteSpace()))
    {
        if (!sSalesRepPhoneNo.IsNullOrWhiteSpace())
        {
            if ((ShowSRPhoneAsExt == 2))
            {
                sSalesRepPhoneNo = sBranchPhone + " Ext: " + sSalesRepPhoneNo;
            }
        }
        else
        {
            sSalesRepPhoneNo = sBranchPhone;
            
        }
    }
    rs.MoveNext();
    if (sType == "A")
    {
        //******************************************Additional Repair Header*********************************************
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
        Response.Write("<tr class=\"t12\">");
        Response.Write("<td colspan=\"5\">");
        Response.Write((string) GetLocalResourceObject("rkMsg_We_are_due_to_complete_your_repair_soon"));
        Response.Write("</td>");
        Response.Write("</tr>");
        if (!iNewCompDate.IsNullOrWhiteSpace())
        {
            Response.Write("<tr class=\"t12\">");
            Response.Write("<td>"+ String.Format((string) GetLocalResourceObject("rkLbl_New_estimated_completion_date"), Util.DateFormat(iNewCompDate)) + "</u></td>");
            Response.Write("</tr>");
        }
        Response.Write("</table><br>");
    }
    rs = rs.NextRecordset();
    iTotalSegments = rs.Fields["TotalSegments"].Value.As<int?>();
    blnShowUnitPriceSeperately = (rs.Fields["ShowUnitPriceSeperately"].Value.As<Double>() == 2.0);
    //GT20091217 add a new configkey to ShowUnitPriceSeperately
    blnShowUnitPriceColumnOnly = (rs.Fields["ShowUnitPriceColumnOnly"].Value.As<Double>() == 2.0);
    //<CODE_TAG_100780> 12/29/2010 yhua </CODE_TAG_100780>
    rs = rs.NextRecordset();
    //******************************************Segments***********************************************************
    iCounter = 1;
    while(iCounter <= iTotalSegments)
    {
        //******************************************Segment Header*************************************************
        sSegmentNo = rs.Fields["SegmentNo"].Value.As<string>();
        iDBSROId = rs.Fields["DBSRepairOptionId"].Value.As<int?>();
        sDesc = null;
        //<CODE_TAG_100941>
        blnShowDiscountColumnWithoutDiscount = rs.Fields["ShowDiscountColumnWithoutDiscount"].Value.As<String>();
        blnSegmentHasDiscountParts = rs.Fields["SegmentHasDiscountParts"].Value.As<String>();
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
        Response.Write("<tr><td colspan=\"5\" height=\"2\" style=\"border-top:2px solid #000000;padding:0;\"></td></tr>");
        Response.Write("<tr valign=\"top\">");
        Response.Write("<td class=\"t11 tSb\" width=\"100\">"+ String.Format((string) GetLocalResourceObject("rkLbl_SEGMENT"),sSegmentNo ) + "</td>");
        Response.Write("<td class=\"t11 tSb\" width=\"570\">");
        
     
       
        if (iDBSROId != 0 && iInternal == "1")
        {
            sModCode = rs.Fields["ModifierCode"].Value.As<String>();
            sQtyCode = rs.Fields["QuantityCode"].Value.As<String>();
            sJLCode = rs.Fields["JobLocationCode"].Value.As<String>();
            sDesc = sDesc + "<table width=\"100%\" cellspacing=0 cellpadding=0>";
            sDesc = sDesc + "<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkLbl_JOB_CODE")+"</td><td>" + rs.Fields["JobCode"].Value.As<String>() + "</td></tr>";
            sDesc = sDesc + "<tr class=\"t11\"><td width=110>"+(string) GetLocalResourceObject("rkLbl_COMPONENT_CODE")+"</td><td>" + rs.Fields["ComponentCode"].Value.As<String>() + "</td></tr>";
            if (!sModCode.IsNullOrWhiteSpace())
            {
                sDesc = sDesc + "<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkLbl_MODIFIER_CODE")+"</td><td>" + sModCode + "</td></tr>";
            }
            if (!sQtyCode.IsNullOrWhiteSpace())
            {
                sDesc = sDesc + "<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkLbl_QUANTITY_CODE")+"</td><td>" + sQtyCode + "</td></tr>";
            }
            if (!sJLCode.IsNullOrWhiteSpace())
            {
                sDesc = sDesc + "<tr class=\"t11\"><td>"+(string) GetLocalResourceObject("rkLbl_JOB_LOCATION_CODE")+"</td><td>" + sJLCode + "</td></tr>";
            }
            sDesc = sDesc + "</table>";
        }
        sDesc = sDesc + rs.Fields["SegmentExternalNotes"].Value.As<String>();
        if (!sDesc.IsNullOrWhiteSpace())
        {
            /*NOTE: Manual Fixup - removed Strings.Replace(sDesc, Convert.ToString((char)(13)), "<BR>", 1 , -1, CompareMethod.Binary)).Trim()*/
            Response.Write(sDesc.Replace("\r", "<BR>").Trim());
        }
        if (iInternal == "1")
        {
            sHdnDesc = rs.Fields["SegmentInternalNotes"].Value.As<String>();
            if (!sHdnDesc.IsNullOrWhiteSpace())
            {
                /*NOTE: Manual Fixup - removed Strings.Replace(rs.Fields["HiddenDescription"].Value.As<String>(), Convert.ToString((char)(13)), "<BR>", 1 , -1, CompareMethod.Binary)*/
                sHdnDesc = rs.Fields["SegmentInternalNotes"].Value.As<string>().Replace("\r", "<BR>");
            }
            if (!sHdnDesc.IsNullOrWhiteSpace())
            {
                Response.Write("<BR><BR>" + sHdnDesc);
            }
        }
        Response.Write("</td>");
        if (iDBSROId != 0 || iDetail == "0")
        {
            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(rs.Fields["SegmentTotal"].Value*/
            Response.Write("<td width=\"100\" align=\"right\" class=\"t11\">" + Util.FormatCurrency(rs.Fields["SegmentTotal"].Value.As<double?>()) + "</td>");
        }
        Response.Write("</tr>");
        Response.Write("</table>");
            //******************************************Segment Details*************************************************
        if (iDetail == "1")
        {
            //If iDBSROId = 0 or (iDBSROId <> 0 and iInternal = 1) then 'Don't show detail if customer version of DBS Repair Option	'[<IAranda 20080828> PrintingIssues] Allows to print detail.
            Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
            Response.Write("<tr height=\"15\"></tr>");
            Response.Write("<tr class=\"t11 tSb\" valign=\"bottom\">");
            NumOfColumns = 0;
                //**************************************Header********************************************************
            if (iRepair == "1")
            {
                //[<IAranda 20080923> PrintingIssues] Allows to print detail.	Was --> iInternal = 1 and (iRepair = 1)
                Response.Write("<td align=\"middle\" width=\"25\"><u>"+(string) GetLocalResourceObject("rkListItem_Job_Code")+"</u></td>");
                Response.Write("<td align=\"middle\" width=\"25\"><u>"+(string) GetLocalResourceObject("rkListItem_Comp_Code")+"</u></td>");
                Response.Write("<td align=\"middle\" width=\"25\"><u>"+(string) GetLocalResourceObject("rkListItem_Mod_Code")+"</u></td>");
                Response.Write("<td align=\"middle\" width=\"45\"><u>"+(string) GetLocalResourceObject("rkListItem_Job_Loc_Code")+"</u></td>");
                Response.Write("<td align=\"middle\" width=\"25\"><u>"+(string) GetLocalResourceObject("rkListItem_Qty_Code")+"</u></td>");
                NumOfColumns = NumOfColumns + 5;
            }
            else
            {
                //<CODE_TAG_101242>
                //Response.Write("<td></td>");
                Response.Write("<td width=\"50\"></td>");
                ////<CODE_TAG_101242>
                NumOfColumns = NumOfColumns + 1;
            }
            Response.Write("<td align=\"middle\"><u>"+(string) GetLocalResourceObject("rkListItem_Qty")+"</u></td>");
            Response.Write("<td nowrap><u>"+(string) GetLocalResourceObject("rkListItem_Item_No")+"</u></td>");
            Response.Write("<td width=\"200\"><u>"+(string) GetLocalResourceObject("rkListItem_Description")+"</u></td>");
            NumOfColumns = NumOfColumns + 3;
                //<CODE_TAG_100298>
                //Internal details
            if (blnShowInternalDetails)
            {
                Response.Write("<td width=\"25\" align=\"right\"><u>"+(string) GetLocalResourceObject("rkListItem_Part_Price")+"</u></td>");
                Response.Write("<td width=\"25\" align=\"right\"><u>"+(string) GetLocalResourceObject("rkListItem_Disc")+"</u></td>");
                NumOfColumns = NumOfColumns + 2;
            }
                //</CODE_TAG_100298>
            if (blnShowUnitPriceSeperately)
            {
                //GT20091217 add a new configkey to ShowUnitPriceSeperately
                Response.Write("<td width=\"100\" align=\"right\"><u>"+(string) GetLocalResourceObject("rkListItem_Unit_Price")+"</u></td>");
                    //<CODE_TAG_100941>
                if (blnShowDiscountColumnWithoutDiscount != "1" || blnSegmentHasDiscountParts != "1")
                {
                   Response.Write("<td width=\"100\" align=\"right\"><u>" + String.Format((string) GetLocalResourceObject("rkListItem_Price"),strDiscLabel) + "</u></td>");
                     NumOfColumns = NumOfColumns + 2;
                 }
                 else
                 {
                    NumOfColumns = NumOfColumns + 1;
                 }
                //</CODE_TAG_100941>
            }
            else
            {
                    //<CODE_TAG_100780> 12/29/2010 yhua
                if (blnShowUnitPriceColumnOnly)
                {
                    Response.Write("<td width=\"100\" align=\"right\"><u>"+(string) GetLocalResourceObject("rkListItem_Unit_Price")+"</u></td>");
                }
                else
                {
                    Response.Write("<td width=\"100\" align=\"right\"><u>"+ String.Format((string) GetLocalResourceObject("rkLbl_Unit_Price"), strDiscLabel)+"</u></td>");
                }
                //</CODE_TAG_100780>
                NumOfColumns = NumOfColumns + 1;
            }
            Response.Write("<td width=\"80\" align=\"right\"><u>"+(string) GetLocalResourceObject("rkListItem_Ext_Price")+"</u></td>");
            NumOfColumns = NumOfColumns + 1;
            Response.Write("</tr>");
            //************************************Details*********************************************************
            iTotal = 0;
            iSegTotal = 0;
            rs.MoveNext();
            rs = rs.NextRecordset();
            while(!(rs.EOF))
            {
                sCategory = rs.Fields["CategoryName"].Value.AsString();
                if (sCategoryOLD != sCategory || sCategoryOLD.IsNullOrWhiteSpace())
                {
                    if (!sCategoryOLD.IsNullOrWhiteSpace())
                    {
                        Response.Write("<tr class=\"t11 tSb\">");
                        Response.Write("<td colspan=\"" + (NumOfColumns - 1).As<string>() + "\" align=\"right\">"+(string) GetLocalResourceObject("rkLbl_Total"));
                        if(sCategoryOLD == null)
                        {
                            Response.Write(sCategory);
                        }
                        else
                        {
                            Response.Write(sCategoryOLD);
                        }
                        Response.Write("</td>");
                        iTotal = (iTotal.IsNullOrWhiteSpace() || iTotal.IsNullOrWhiteSpace() ?  0 :  iTotal);
                        //[<IAranda 20080923> Fixes]
                        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(iTotal, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                        Response.Write("<td align=\"right\">" + Util.FormatCurrency(iTotal) + "</td>");
                        Response.Write("</tr>");
                        Response.Write("<tr height=\"" + NumOfColumns + "px\"><td></td></tr>");
                    }
                    Response.Write("<tr class=\"t11 tSb\">");
                    Response.Write("<td colspan=\"" + NumOfColumns + "\">" + sCategory  + "</td>");
                    Response.Write("</tr>");
                    Response.Write("<tr><td colspan=\"" + NumOfColumns + "\" style=\"border-top:2px solid #000000;padding:0;\"></td></tr>");
                    iSegTotal = iSegTotal + iTotal;
                    iTotal = 0;
                }
                iExtPrice = ((rs.Fields["ExtendedPrice"].Value.As<string>().IsNullOrWhiteSpace() || rs.Fields["ExtendedPrice"].Value.As<String>() == "null")  ?  0 :  rs.Fields["ExtendedPrice"].Value.As<int?>());
                //[<IAranda 20080923> Fixes]
                iTotal = iTotal + iExtPrice;
                if (iDBSROId == 0)
                {
                    iROId = rs.Fields["RepairOptionId"].Value.As<int?>();
                }
                    //If iInternal = 1 and iRepair = 1 and iJob = 1 then	'[<IAranda 20080923> PrintingIssues] Allows to print detail.
                if (iRepair == "1" && iJob == "1")
                {
                    if (iROId != iROIdOLD || iROId.IsNullOrWhiteSpace() || iROIdOLD.IsNullOrWhiteSpace())
                    {
                        Response.Write("<tr><td colspan=\"" + NumOfColumns + "\" height=\"1px\" ></td></tr>");
                        Response.Write("<tr valign=\"top\">");
                        if (iJob == "1" && sCategory.Left(1) == "L")
                        {
                            x = "t11b";
                        }
                        else
                        {
                            x = "t11";
                        }
                        Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["RJobCode"].Value.As<String>() + "</td>");
                        Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["RCompCode"].Value.As<String>() + "</td>");
                        Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["RModifierCode"].Value.As<String>() + "</td>");
                        Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["RJobLocationCode"].Value.As<String>() + "</td>");
                        Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["RQuantityCode"].Value.As<String>() + "</td>");
                            //Config to show/hide Labor Rate
                        if (iInternal == "0" && HideLaborRate == 2 && sCategory.Left(1) == "L")
                        {
                            Response.Write("<td class=\"" + x + "\" align=\"middle\"></td>");
                        }
                        else
                        {
                            Response.Write("<td class=\"" + x + "\" align=\"middle\">" + rs.Fields["Quantity"].Value.As<String>() + "</td>");
                        }
                        Response.Write("<td class=\"" + x + "\">" + rs.Fields["ItemNo"].Value.As<String>() + "</td>");
                            //Config to show product description as "CORE" for a Core line item
                        if (showCoreDescription == "2")
                        {
                            if ((sCategory.Left(1) == "P" && (((rs.Fields["SOS"].Value.As<string>()).IsNullOrWhiteSpace() || (rs.Fields["SOS"].Value.As<String>()).Trim().IsNullOrWhiteSpace()) && ((rs.Fields["Description"].Value.As<String>()).Trim()).ToUpper() != "PARTS TOTAL")))
                            {
                                Response.Write("<td class=\"" + x + "\">" + (string) GetLocalResourceObject("rkLbl_CORE") + "</td>");
                            }
                            else
                            {
                                Response.Write("<td class=\"" + x + "\">" + rs.Fields["Description"].Value.As<String>() + "</td>");
                            }
                        }
                        else
                        {
                            Response.Write("<td class=\"" + x + "\">" + rs.Fields["Description"].Value.As<String>() + "</td>");
                        }
                            //<CODE_TAG_100298>
                            //Internal details
                        if (blnShowInternalDetails)
                        {
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(rs.Fields["UnitPrice"].Value, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                            Response.Write("<td class=\"" + x + "\" align=\"right\">" + Util.FormatCurrency(rs.Fields["UnitPrice"].Value.As<double?>()) + "</td>");
                            Response.Write("<td class=\"" + x + "\" align=\"right\">" + Util.NumberFormat(rs.Fields["Discount"].Value.As<double?>(), 2, null, -1, null, true) + "%</td>");
                        }
                            //</CODE_TAG_100298>
                            //[<IAranda 20080923> Fixes] START
                            //Config to show/hide Labor Rate
                        if (iInternal ==  "0" && HideLaborRate == 2 && sCategory.Left(1) == "L")
                        {
                            Response.Write("<td class=\"t11\" align=\"right\" colspan=\"" + (blnShowUnitPriceSeperately ?  2 :  1).As<string>() + "\"></td>");
                        }
                        else if( blnShowUnitPriceSeperately)
                        {
                            //GT20091217 add a new configkey to ShowUnitPriceSeperately
                            sAux = rs.Fields["UnitPrice"].Value.As<String>();
                            sAux = ((sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace()) ?  "0" :  sAux);
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                            Response.Write("<td class=\"t11\" align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                            sAux = rs.Fields["DiscPrice"].Value.As<String>();
                            sAux = ((sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace()) ?  "0" :  sAux);
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                            Response.Write("<td class=\"t11\" align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                        }
                        else
                        {
                            sAux = rs.Fields["DiscPrice"].Value.As<String>();
                            sAux = ((sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace()) ?  "0" :  sAux);
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                            Response.Write("<td class=\"t11\" align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                        }
                        sAux = iExtPrice.ToString();
                        if (sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace())
                        {
                            sAux = "0";
                        }
                        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                        Response.Write("<td class=\"t11\" align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                        //[<IAranda 20080923> Fixes] END
                        Response.Write("</tr>");
                    }
                    if (iDBSROId == 0)
                    {
                        Response.Write("<tr class=\"t11\" valign=\"top\">");
                        Response.Write("<td align=\"middle\">" + rs.Fields["JJobCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["JCompCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["JModifierCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["JJobLocationCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["JQuantityCode"].Value.As<String>() + "</td>");
                        Response.Write("<td></td>");
                        Response.Write("<td></td>");
                        Response.Write("<td>" + rs.Fields["JJobCodeDesc"].Value.As<String>() + " " + rs.Fields["JComponentCodeDesc"].Value.As<String>() + " " + rs.Fields["JModifierDesc"].Value.As<String>() + " " + rs.Fields["JJobLocationDesc"].Value.As<String>() + " " + rs.Fields["JQuantityDesc"].Value.As<String>() + "</td>");
                        Response.Write("</tr>");
                    }
                    iROIdOLD = iROId;
                }
                else
                {
                    Response.Write("<tr class=\"t11\" valign=\"top\">");
                        //If iInternal = 1 and iRepair = 1 and iJob = 0 then		'[<IAranda 20080923> PrintingIssues] Allows to print detail.
                    if (iRepair == "1" && iJob == "0")
                    {
                        Response.Write("<td align=\"middle\">" + rs.Fields["RJobCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["RCompCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["RModifierCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["RJobLocationCode"].Value.As<String>() + "</td>");
                        Response.Write("<td align=\"middle\">" + rs.Fields["RQuantityCode"].Value.As<String>() + "</td>");
                    }
                    else
                    {
                        Response.Write("<td width=\"50\"></td>");
                    }
                        //Config to show/hide Labor Rate
                    if (iInternal == "0" && HideLaborRate == 2 && sCategory.Left(1) == "L")
                    {
                        Response.Write("<td align=\"middle\"></td>");
                    }
                    else
                    {
                        Response.Write("<td align=\"middle\">" + rs.Fields["Quantity"].Value.As<String>() + "</td>");
                    }
                    Response.Write("<td>" + rs.Fields["ItemNo"].Value.As<String>() + "</td>");
                    if (showCoreDescription == "2")
                    {
                        if ((sCategory.Left(1) == "P" && (((rs.Fields["SOS"].Value).IsNullOrWhiteSpace() || (rs.Fields["SOS"].Value.As<String>()).Trim().IsNullOrWhiteSpace()) && ((rs.Fields["Description"].Value.As<String>()).Trim()).ToUpper() != "PARTS TOTAL")))
                        {
                            Response.Write("<td>"+(string) GetLocalResourceObject("rkLbl_CORE")+"</td>");
                        }
                        else
                        {
                            Response.Write("<td>" + rs.Fields["Description"].Value.As<String>() + "</td>");
                        }
                    }
                    else
                    {
                        Response.Write("<td>" + rs.Fields["Description"].Value.As<String>() + "</td>");
                    }
                        //[<IAranda 20080923> Fixes] START
                        //Config to show/hide Labor Rate
                    if (iInternal == "0" && HideLaborRate == 2 && sCategory.Left(1) == "L")
                    {
                            //<CODE_TAG_100941>
                        if (HideLaborRate != 1 || blnSegmentHasDiscountParts != "1")
                        {
                            Response.Write("<td align=\"right\" colspan=\"" + (blnShowUnitPriceSeperately ?  2 :  1).As<string>() + "\">&nbsp;</td>");
                        }
                        else
                        {
                            Response.Write("<td align=\"right\" colspan=\"1\">&nbsp;</td>");
                        }
                        //</CODE_TAG_100941>
                    }
                    else if( blnShowUnitPriceSeperately)
                    {
                        //GT20091217 add a new configkey to ShowUnitPriceSeperately
                        sAux = rs.Fields["UnitPrice"].Value.As<String>();
                        if (sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace())
                        {
                            sAux = "0";
                        }
                        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                        Response.Write("<td align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                            //<CODE_TAG_100941
                        if (blnShowDiscountColumnWithoutDiscount != "1" || blnSegmentHasDiscountParts != "1")
                        {
                            sAux = rs.Fields["DiscPrice"].Value.As<String>();
                            if (sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace())
                            {
                                sAux = "0";
                            }
                            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                            Response.Write("<td align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                        }
                    }
                    else
                    {
                        sAux = rs.Fields["DiscPrice"].Value.As<String>();
                        if (sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace())
                        {
                            sAux = "0";
                        }
                        /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                        Response.Write("<td align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                    }
                    sAux = iExtPrice.ToString();
                    if (sAux.IsNullOrWhiteSpace() || sAux == "null" || sAux.IsNullOrWhiteSpace())
                    {
                        sAux = "0";
                    }
                    /*NOTE: Manual Fixup - removed Strings.FormatCurrency(sAux, 2, TriState.False, TriState.True, TriState.UseDefault)*/
                    Response.Write("<td align=\"right\">" + Util.FormatCurrency(sAux.As<double?>()) + "</td>");
                    //[<IAranda 20080923> Fixes] END
                    Response.Write("</tr>");
                    Response.Write("<tr><td colspan=\"" + NumOfColumns + "\" style=\"border-top:2px solid #000000;padding:0;\"></td></tr>");
                }
                sCategoryOLD = sCategory;
                rs.MoveNext();
            }
            //End If	'[<IAranda 20080828> PrintingIssues] Allows to print detail.
            Response.Write("<tr class=\"t11 tSb\">");
            /*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/
            Response.Write("<td colspan=\"" + (NumOfColumns - 1).As<string>() + "\" align=\"right\">"+ String.Format((string) GetLocalResourceObject("rkLbl_Total_Cat"), sCategoryOLD) + "</td>");
            iTotal = (iTotal.IsNullOrWhiteSpace() || iTotal.IsNullOrWhiteSpace() ?  0 :  iTotal);
            //[<IAranda 20080923> Fixes]
            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(iTotal, 2, TriState.False, TriState.True, TriState.UseDefault)*/
            Response.Write("<td align=\"right\">" + Util.FormatCurrency(iTotal.As<double?>()) + "</td>");
            Response.Write("</tr>");
            Response.Write("<tr height=\"" + NumOfColumns + "px\"></tr>");
            //rw "<tr><td colspan=""7"" height=""1"" bgcolor=""#000000""></td></tr>"
            iSegTotal = iSegTotal + iTotal;
            Response.Write("<tr class=\"t11 tSb\">");
            Response.Write("<td colspan=\"" + /*DONE:review data type conversion - convert to proper type or Convert.Toxxx call is redundant (need to be removed in such case)*/(NumOfColumns - 1).As<string>() + "\" align=\"right\">"+ String.Format((string) GetLocalResourceObject("rkLbl_Segment_Total"), sSegmentNo)+"</td>");
            iSegTotal = (iSegTotal.IsNullOrWhiteSpace() || iSegTotal.IsNullOrWhiteSpace() ?  0 :  iSegTotal);
            //[<IAranda 20080923> Fixes]
            /*NOTE: Manual Fixup - removed Strings.FormatCurrency(iSegTotal, 2, TriState.False, TriState.True, TriState.UseDefault)*/
            Response.Write("<td align=\"right\">" + Util.FormatCurrency(iSegTotal.As<double?>()) + "</td>");
            Response.Write("</tr>");
            Response.Write("</table><br>");
            sCategoryOLD = null;
        //Else
        //Set rs = rs.NextRecordset
        //End If
        }
        rs = rs.NextRecordset();
        //[<IAranda. 20080604>. PSQuoter Changes. Removed]
        iCounter = iCounter + 1;
    }
    //======================================QUOTE TOTAL================================================
    iQuoteTotal = iQuoteTotal + 0;
        //iQuoteTotal = iQuoteTotal + iEnvCharge
    if (iGSTRate.IsNullOrWhiteSpace() || iGSTRate.IsNullOrWhiteSpace())
    {
        iGSTTotal = 0;
    }
    else
    {
        iGSTTotal = 0;
    //iGSTTotal = iQuoteTotal * (iGSTRate / 100)
    }
    if (iPSTRate.IsNullOrWhiteSpace() || iPSTRate.IsNullOrWhiteSpace())
    {
        iPSTTotal = 0;
    }
    else
    {
        iPSTTotal = 0;
    //iPSTTotal = iQuoteTotal * (iPSTRate / 100)
    }
    Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
    Response.Write("<tr><td style=\"border-top:2px solid #000000;padding:0;\" colspan=\"10\"></td></tr>");
    //[<IAranda. 20080604>. PSQuoter Changes. START]
    Response.Write("<tr class=\"t11 tSb\">");
   
    Response.Write("<td colspan=\"8\" align=\"right\"></td>");
    
    Response.Write("<td class=\"upper\" colspan=\"1\" align=\"right\">"+ String.Format((string) GetLocalResourceObject("rkTOTAL"), strHeaderText ) + "</td>");
    
    /*NOTE: Manual Fixup - removed Strings.FormatCurrency(iQuoteTotal + 0 + 0, 2, TriState.False, TriState.True, TriState.UseDefault)*/
    Response.Write("<td align=\"right\">" + Util.FormatCurrency(iQuoteTotal + 0 + 0.As<double?>()) + "</td>");
    //rw "<td align=""right"">" & FormatCurrency(iQuoteTotal + iGSTTotal + iPSTTotal,2,,-1) & "</td>"
    Response.Write("</tr>");
    Response.Write("<tr><td style=\"border-top:2px solid #000000;padding:0;\" colspan=\"10\"></td></tr>");
    //[<IAranda. 20080604>. PSQuoter Changes. END]
    Response.Write("<tr>");
    Response.Write("<td class=\"t11 tSi tSb\" colspan=\"10\">");
        //[<IAranda. 20080604>. PSQuoter Changes. START]
    if (sType == "Q")
    {
        Response.Write("<br><ul>");
            //Set rs = rs.NextRecordset
        while(!(rs.EOF))
        {
            Response.Write("<li>" + rs.Fields["TermCond"].Value.As<String>() + "</li>");
            rs.MoveNext();
        }
        Response.Write("</ul><br>");
    }
    //[<IAranda. 20080604>. PSQuoter Changes. END]
    Response.Write("</td>");
    
    Response.Write("</tr>");
        
        //Show disclaimers
    if (blnShowDisclaimers)
    {
        rs = rs.NextRecordset();
        Response.Write("<tr><td colspan=\"10\" class=\"t\" style=\"padding-bottom:5px;padding-top:2px;\">" + rs.Fields["Disclaimers"].Value.As<String>().HtmlEncode() + "</td></tr>");
    }
    //</CODE_TAG_100278>
    Response.Write("<tr><td style=\"border-top:2px solid #000000;padding:0;\" colspan=\"10\"></td></tr>");
    Response.Write("</table>");
        //======================================QUOTE FOOTER================================================
    if (sType == "Q" || sType == "A")
    {
        //[<IAranda 20080828> PrintingIssues]
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
        Response.Write("<tr class=\"t11 tSi tSb\">");
        Response.Write("<td width=\"150\">"+(string) GetLocalResourceObject("rkFrmLbl_ESTIMATED_REPAIR_TIME")+"</td>");
        Response.Write("<td width=\"100\" style=\"border-bottom:1px solid #000000;\">" + iEstRepTime + "</td>");
        Response.Write("<td width=\"100\">&nbsp;"+(string) GetLocalResourceObject("rkLbl_from_start_date")+"</td>");
        Response.Write("</tr>");
        if (iInternal == "0")
        {
           
            Response.Write("<tr class=\"t11 tSi tSb\">");
            Response.Write("<td colspan=\"4\">");
            if (!rs.BOF && !rs.EOF)
            {
                rs.MoveNext();
            }
            rs = rs.NextRecordset();
            if (!rs.BOF && !rs.EOF)
            {
                strAcknowledgeMessage = rs.Fields["QuoteAcknowledgeMessage"].Value.As<String>();
            }
                //Fallback message
            if (strAcknowledgeMessage.IsNullOrWhiteSpace())
            {
                strAcknowledgeMessage = (string) GetLocalResourceObject("rkAcknowledgmentMessage");
            }
            Response.Write("\"" + strAcknowledgeMessage + "\".<br />");
            //</CODE_TAG_100494>
            Response.Write("</td>");
            Response.Write("</tr>");
            Response.Write("<tr class=\"t11 tSi tSb\"   >");
            Response.Write("<td colspan=\"4\" style=\"padding-top:10px;padding-bottom:15px\" >");
            Response.Write((string) GetLocalResourceObject("rkRptLbl_Issued_PO")+"___________________, "+(string) GetLocalResourceObject("rkRptLbl_Authorized_Name")+" __________________________"+(string) GetLocalResourceObject("rkLbl_Please_Print")+"<br />");
            Response.Write("</td></tr>");
            Response.Write("<tr class=\"t11 tSi tSb\">");
            Response.Write("<td colspan=\"3\"  style=\"padding-bottom:15px\" >");
            Response.Write((string) GetLocalResourceObject("rkLbl_Date")+"___/___/____"+"("+(string) GetLocalResourceObject("rkShortForDay_dd")+","+(string) GetLocalResourceObject("rkShortForMonth_mm")+","+(string) GetLocalResourceObject("rkShortForYear_yy")+"). ");
            Response.Write("</td>");
            Response.Write("</tr>");
        }
        else
        {
            Response.Write("<tr class=\"t11\">");
            Response.Write("<td colspan=\"3\">");
            Response.Write("</td>");
            Response.Write("</tr>");
        }
        Response.Write("<tr class=\"t11\">");
        Response.Write("<td colspan=\"3\" nowrap>");
        if (!sSalesRepPhoneNo.IsNullOrWhiteSpace())
        {
            Response.Write(String.Format((string) GetLocalResourceObject("rkMsg_Any_questions__Please_call"), sSalesRep, sSalesRepPhoneNo));
        }
        if (!sSRFaxNo.IsNullOrWhiteSpace())
        {
            if (SRFaxNoLabel.IsNullOrWhiteSpace())
            {
                Response.Write(String.Format((string) GetLocalResourceObject("rkLbl_Fax_number"), sSRFaxNo));
            }
        }
        Response.Write("</td>");
        if (iInternal == "0")
        {
            Response.Write("<td width=\"320\" align=\"middle\" style=\"border-top:1px solid #000000;\">"+(string) GetLocalResourceObject("rkLbl_Signature")+"</td>");
        }
        else
        {
            Response.Write("<td width=\"320\"></td>");
        }
        Response.Write("</tr>");
        Response.Write("<tr><td colspan=\"4\" height=\"2px\"></td></tr>");
        Response.Write("</table>");
    }
    else
    {
        Response.Write("<table cellspacing=\"1\" cellpadding=\"2\" width=\"98%\">");
        Response.Write("<tr class=\"t12\">");
        Response.Write("<td align=\"middle\">"+String.Format((string) GetLocalResourceObject("rkMsg_For_any_additional_information__please_call_"),sSalesRep, sSalesRepPhoneNo )+"</td>");
        Response.Write("</tr>");
        Response.Write("<tr><td height=\"2px\"></td></tr>");
        Response.Write("</table>");
    }
    //rs.Close
   
    rs = null;
    Util.CleanUp( cmd);
   
    Response.Write("<script>window.print();</script>");
%>
<script language="C#" runat="server">

   
    DateTime? iNewCompDate = null;
    string sSRFaxNo = null;
    string sTaxCode = null;
    int? iDBSROCount = null;
    string sBranchAddress1 = null;
    string sBranchAddress2 = null;
    string sBranchPhone = null;
    string colspan = null;
    string strHeaderText = null;
    string sAddress = null;
    string sCity = null;
    string sPostal = null;
    int? iQuoteTotal = 0;
    double? iEnvCharge = null;
    int? iGSTRate = null;
    int? iPSTRate = null;
    int? iEstRepTime = null;
    string sSalesRep = null;
    string sSalesRepPhoneNo = null;
    int? iTotalSegments = null;
    int iCounter = 0;
    string sSegmentNo = null;
    int? iDBSROId = null;
    string sDesc = null;
    string blnShowDiscountColumnWithoutDiscount = null;
    string blnSegmentHasDiscountParts = null;
    string sModCode = null;
    string sQtyCode = null;
    string sJLCode = null;
    string sHdnDesc = null;
    int? iTotal = null;
    int? iSegTotal = null;
    string sCategory = null;
    string sCategoryOLD = null;
    int? iExtPrice = 0;
    int? iROId = null;
    int? iROIdOLD = null;
    int iGSTTotal = 0;
    int iPSTTotal = 0;
    ADODB.Recordset rs = null;
    string sAux = null;
    int NumOfColumns = 0;
    //<CODE_TAG_100494>Add acknowledge message
    string strAcknowledgeMessage = null;
    string x;
    //[<IAranda 20080923> Fixes] START
   

</script>
</asp:Content>
