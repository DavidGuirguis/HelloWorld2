<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.PrintPage" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "nce.scripting" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "System.Web" %>
<%@ Import Namespace = "System.Xml" %>
<%@ Import Namespace = "System.IO" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
<!--#include file="inc_quote.aspx"-->
<!--#include file="inc_QuotePrint.aspx"-->
<%

    rs = GetPrintData();
    
    f = new StringBuilder();
    
    //======================================XML Header================================================
    f.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");

    f.AppendLine("<root xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");

    //======================================Parameter Section================================================
    f.AppendLine("<Parameter>");
    f.AppendLine("<iQuoteId>" + iQuoteId + "</iQuoteId>");
    f.AppendLine("<iInternal>" + iInternal + "</iInternal>");
    f.AppendLine("<iRepair>" + iRepair + "</iRepair>");
    f.AppendLine("<iJob>" + iJob + "</iJob>");
    f.AppendLine("<iDetail>" + iDetail + "</iDetail>");
    f.AppendLine("</Parameter>");
    //======================================Parameter Section================================================

    //======================================Configuration Section================================================
    f.AppendLine("<Configuration>");
    f.AppendLine("<SegmentDetails>");
    while (!rs.EOF)
    {
        f.Append("<" + rs.Fields["ConfigKey"].Value.As<string>() + ">");
        f.Append(rs.Fields["ConfigValue"].Value.As<string>());
        f.Append("</" + rs.Fields["ConfigKey"].Value.As<string>() + ">");

        rs.MoveNext();
    }
    f.AppendLine("</SegmentDetails>");

    rs = rs.NextRecordset();

    f.AppendLine("<SegmentDetailColumns>");

    string parts_TotalColumns;
    string labor_TotalColumns;
    string misc_TotalColumns;

    parts_TotalColumns = rs.Fields["Parts_TotalColumns"].Value.As<string>();
    labor_TotalColumns = rs.Fields["Labor_TotalColumns"].Value.As<string>();
    misc_TotalColumns = rs.Fields["Misc_TotalColumns"].Value.As<string>();

    rs = rs.NextRecordset();

    f.AppendLine("<Parts TotalColumns=\"" + parts_TotalColumns + "\">");
    f.AppendLine("<Columns>");
    while (!rs.EOF)
    {
        f.Append("<Column ");
        f.Append("Name=\"" + rs.Fields["DisplayName"].Value.As<string>() + "\" ");
        f.Append("DataField=\"" + rs.Fields["DataField"].Value.As<string>() + "\" ");
        f.Append("Colspan=\"" + rs.Fields["Colspan"].Value.As<string>() + "\" ");
        f.Append("Align=\"" + rs.Fields["Align"].Value.As<string>() + "\" ");
        f.Append("/>");
        rs.MoveNext();
    }
    f.AppendLine("</Columns>");
    f.AppendLine("</Parts>");
    
    rs = rs.NextRecordset();

    f.AppendLine("<Labor TotalColumns=\"" + labor_TotalColumns + "\">");
    f.AppendLine("<Columns>");
    while (!rs.EOF)
    {
        f.Append("<Column ");
        f.Append("Name=\"" + rs.Fields["DisplayName"].Value.As<string>() + "\" ");
        f.Append("DataField=\"" + rs.Fields["DataField"].Value.As<string>() + "\" ");
        f.Append("Colspan=\"" + rs.Fields["Colspan"].Value.As<string>() + "\" ");
        f.Append("Align=\"" + rs.Fields["Align"].Value.As<string>() + "\" ");
        f.Append("/>");
        rs.MoveNext();
    }
    f.AppendLine("</Columns>");
    f.AppendLine("</Labor>");

    rs = rs.NextRecordset();

    f.AppendLine("<Misc TotalColumns=\"" + misc_TotalColumns + "\">");
    f.AppendLine("<Columns>");
    while (!rs.EOF)
    {
        f.Append("<Column ");
        f.Append("Name=\"" + rs.Fields["DisplayName"].Value.As<string>() + "\" ");
        f.Append("DataField=\"" + rs.Fields["DataField"].Value.As<string>() + "\" ");
        f.Append("Colspan=\"" + rs.Fields["Colspan"].Value.As<string>() + "\" ");
        f.Append("Align=\"" + rs.Fields["Align"].Value.As<string>() + "\" ");
        f.Append("/>");
        rs.MoveNext();
    }
    f.AppendLine("</Columns>");
    f.AppendLine("</Misc>");

    f.AppendLine("</SegmentDetailColumns>");
    f.AppendLine("</Configuration>");
    //======================================Configuration Section================================================

    rs = rs.NextRecordset();
    sSRFaxNo = rs.Fields["SRFaxNo"].Value.As<string>();
    strFirstName = rs.Fields["SRFName"].Value.As<string>();
    strLastName = rs.Fields["SRLName"].Value.As<string>();
    sToEmail = rs.Fields["Email"].Value.As<string>();
    sFromEmail = rs.Fields["SREmail"].Value.As<string>();
    sSalesRepPhoneNo = rs.Fields["SRPhoneNo"].Value.As<string>();
    sSalesRepCellPhoneNo = rs.Fields["SRCellPhoneNo"].Value.As<string>();
    sBranchPhone = rs.Fields["BranchPhone"].Value.As<string>();
    /*
    if ((!sBranchPhone.IsNullOrWhiteSpace()))
    {
        if ((!sSalesRepPhoneNo.IsNullOrWhiteSpace()))
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
    */

    f.AppendLine("<Label>");
    f.AppendLine("<QuoteDetail>");
    f.AppendLine("<Disc>" + FormatXml(strDiscLabel) + "</Disc>");
    f.AppendLine("</QuoteDetail>");
    f.AppendLine("</Label>");
    //======================================Header Title================================================
    f.AppendLine("<Header>");
    f.AppendLine("<Title>Parts &amp; Service Quoter</Title>");
    f.AppendLine("</Header>");
    //======================================Quoter Header================================================
    sDivision = rs.Fields["division"].Value.As<String>();
    f.AppendLine("<QuoteHeader>");
    f.AppendLine("<logoUrl>" + Server.MapPath(GetQuoteLogoUrl(sDivision,  rs.Fields["BranchNo"].Value.As<String>(),   rs.Fields["LogoFileExtension"].Value.As<String>())) + "</logoUrl>");
    f.AppendLine("<logoAlign>" + rs.Fields["LogoAlign"].Value.As<string>() + "</logoAlign>");
    f.AppendLine("<headerText>" + rs.Fields["PrintHeaderText"].Value.As<string>() + "</headerText>");
    f.AppendLine("<Table>");
    f.AppendLine("<QuoteNo>" + FormatXml(rs.Fields["QuoteNo"].Value.As<string>()) + "</QuoteNo>");
    f.AppendLine("<Revision>" + FormatXml(iRevision.As<string>()) + "</Revision>");
    f.AppendLine("<CustomerNo>" + FormatXml(rs.Fields["CustomerNo"].Value.As<string>()) + "</CustomerNo>");
    f.AppendLine("<PurchaseOrderNo>" + FormatXml(rs.Fields["PurchaseOrderNo"].Value.As<string>()) + "</PurchaseOrderNo>");
    f.AppendLine("<QuoteDate>" + Util.DateFormat(FormatXml(rs.Fields["QuoteDate"].Value.As<string>()).As<DateTime?>()) + "</QuoteDate>");
    f.AppendLine("<Make>" + FormatXml(rs.Fields["Make"].Value.As<string>()) + "</Make>");
    f.AppendLine("<Model>" + FormatXml(rs.Fields["Model"].Value.As<string>()) + "</Model>");
    f.AppendLine("<SerialNo>" + FormatXml(rs.Fields["SerialNo"].Value.As<string>()) + "</SerialNo>");
    f.AppendLine("<UnitNo>" + FormatXml(rs.Fields["UnitNo"].Value.As<string>()) + "</UnitNo>");
    f.AppendLine("<SMU>" + FormatXml(rs.Fields["SMU"].Value.As<string>()) + "</SMU>");
    f.AppendLine("<SMUIndicatorCode>" + FormatXml(rs.Fields["SMUIndicatorCode"].Value.As<string>()) + "</SMUIndicatorCode>");
    f.AppendLine("<SMUIndicatorDesc>" + FormatXml(rs.Fields["SMUIndicatorDesc"].Value.As<string>("").ToUpper( ) ) + "</SMUIndicatorDesc>");
    f.AppendLine("<WorkOrderNo>" + FormatXml(rs.Fields["WorkOrderNo"].Value.As<string>()) + "</WorkOrderNo>");
    f.AppendLine("<QuoteTotal>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["QuoteTotal"].Value.As<string>())).As<double>()) + "</QuoteTotal>");   
    f.AppendLine("<EstimatedRepairTime>" + FormatXml(rs.Fields["EstimatedRepairTime"].Value.As<string>()) + "</EstimatedRepairTime>");
    f.AppendLine("<SRFName>" + FormatXml(rs.Fields["SRFName"].Value.As<string>()) + "</SRFName>");
    f.AppendLine("<SRLName>" + FormatXml(rs.Fields["SRLName"].Value.As<string>()) + "</SRLName>");
    f.AppendLine("<sBranchPhone>" + FormatXml(sBranchPhone) + "</sBranchPhone>");
    f.AppendLine("<SRPhoneNo>" + FormatXml(sSalesRepPhoneNo) + "</SRPhoneNo>");
    f.AppendLine("<SRCellPhoneNo>" + FormatXml(sSalesRepCellPhoneNo) + "</SRCellPhoneNo>");
    f.AppendLine("<SRFaxNo>" + FormatXml(rs.Fields["SRFaxNo"].Value.As<String>()) + "</SRFaxNo>");
    f.AppendLine("<SRFaxNoLabel>" + FormatXml(SRFaxNoLabel) + "</SRFaxNoLabel>");
    f.AppendLine("<CustomerName>" + FormatXml(rs.Fields["CustomerName"].Value.As<string>()) + "</CustomerName>");
    f.AppendLine("<ContactName>" + FormatXml(rs.Fields["ContactName"].Value.As<string>()) + "</ContactName>");
    f.AppendLine("<PhoneNo>" + FormatXml(rs.Fields["PhoneNo"].Value.As<string>()) + "</PhoneNo>");
    f.AppendLine("<CreatorFirstName>" + FormatXml(rs.Fields["CreatorFirstName"].Value.As<string>()) + "</CreatorFirstName>");
    f.AppendLine("<CreatorLastName>" + FormatXml(rs.Fields["CreatorLastName"].Value.As<string>()) + "</CreatorLastName>");

    f.AppendLine("<CurCustomerNo>" + FormatXml(rs.Fields["CurCustomerNo"].Value.As<string>()) + "</CurCustomerNo>");
    f.AppendLine("<CurCustomerName>" + FormatXml(rs.Fields["CurCustomerName"].Value.As<string>()) + "</CurCustomerName>");
    curCustomerName = rs.Fields["CurCustomerName"].Value.As<string>();
    f.AppendLine("<CurAddress1>" + FormatXml(rs.Fields["CurAddress1"].Value.As<string>()) + "</CurAddress1>");
    f.AppendLine("<CurAddress2>" + FormatXml(rs.Fields["CurAddress2"].Value.As<string>()) + "</CurAddress2>");
    f.AppendLine("<CurAddress3>" + FormatXml(rs.Fields["CurAddress3"].Value.As<string>()) + "</CurAddress3>");
    f.AppendLine("<CurCityState>" + FormatXml(rs.Fields["CurCityState"].Value.As<string>()) + "</CurCityState>");
    f.AppendLine("<CurZipCode>" + FormatXml(rs.Fields["CurZipCode"].Value.As<string>()) + "</CurZipCode>");
    f.AppendLine("<HeaderCustomer>" + (( rs.Fields["CustomerNo"].Value.As<string>().Trim() == rs.Fields["CurCustomerNo"].Value.As<string>("").Trim()  )? "2" : "0"    ) + "</HeaderCustomer>");


    f.AppendLine("<bWatermark>" + FormatXml(rs.Fields["bWatermark"].Value.As<string>()) + "</bWatermark>");
    if(rs.Fields["bWatermark"].Value.As<string>() == "2"){
        f.AppendLine("<WatermarkUrl>" + Server.MapPath(GetQuoteWatermarkUrl(sDivision, rs.Fields["Watermark_FileName"].Value.As<String>(), rs.Fields["Watermark_FileExtName"].Value.As<String>())) + "</WatermarkUrl>");
    }
        
    if (SRFaxNoLabel.IsNullOrWhiteSpace())
    {
        f.AppendLine("<FaxNo>" + FormatXml(rs.Fields["FaxNo"].Value.As<string>()) + "</FaxNo>");
    }
    else
    {
        f.AppendLine("<FaxNo>" + FormatXml(rs.Fields["SRFaxNo"].Value.As<string>()) + "</FaxNo>");
    }
    f.AppendLine("<Email>" + FormatXml(rs.Fields["Email"].Value.As<string>()) + "</Email>");
    f.AppendLine("<Address1>" + FormatXml((rs.Fields["Address1"].Value.As<string>())) + "</Address1>");
    f.AppendLine("<Address2>" + FormatXml((rs.Fields["Address2"].Value.As<string>())) + "</Address2>");
    f.AppendLine("<Address3>" + FormatXml((rs.Fields["Address3"].Value.As<string>())) + "</Address3>");
    f.AppendLine("<CityState>" + FormatXml(rs.Fields["CityState"].Value.As<string>()) + "</CityState>");
    f.AppendLine("<ZipCode>" + FormatXml(rs.Fields["ZipCode"].Value.As<string>()) + "</ZipCode>");

    f.AppendLine("<HideSegmentDetail>" + FormatXml(rs.Fields["HideSegmentDetail"].Value.As<string>("")) + "</HideSegmentDetail>");
    
    f.AppendLine("<FaxLabel>" + strFaxLabel + "</FaxLabel>");
    f.AppendLine("<ExternalNotes>" + rs.Fields["ExternalNotes"].Value.ToString() + "</ExternalNotes>");
    f.AppendLine("<InternalNotes>" + rs.Fields["InternalNotes"].Value.ToString() + "</InternalNotes>");
    f.AppendLine("<BranchAddress1>" + FormatXml(rs.Fields["BranchAddress1"].Value.As<string>()) + "</BranchAddress1>");
    f.AppendLine("<BranchAddress2>" + FormatXml(rs.Fields["BranchAddress2"].Value.As<string>()) + "</BranchAddress2>");
    f.AppendLine("<BranchName>" + FormatXml(rs.Fields["BranchName"].Value.As<string>()) + "</BranchName>");
    f.AppendLine("<BranchNo>" + rs.Fields["BranchNo"].Value.ToString() + "</BranchNo>");
    f.AppendLine("</Table>");
    f.AppendLine("</QuoteHeader>");
    f.AppendLine("<QuoteFooter>");
    f.AppendLine("<DisplayFooter>" + rs.Fields["DisplayFooter"].Value.As<string>() + "</DisplayFooter>");
    f.AppendLine("</QuoteFooter>");
    iQuoteTotal = rs.Fields["QuoteTotal"].Value.As<double?>() ;
    iEstRepTime = rs.Fields["EstimatedRepairTime"].Value.As<string>() ;
    sSalesRep = rs.Fields["SRFName"].Value.As<string>() + " " + rs.Fields["SRLName"].Value.As<string>();
    sSalesRepPhoneNo = rs.Fields["SRPhoneNo"].Value.As<string>();
    rs.MoveNext();


    rs = rs.NextRecordset();
    iTotalSegments = rs.Fields["TotalSegments"].Value.As<int?>();
    blnShowUnitPriceSeperately = (rs.Fields["ShowUnitPriceSeperately"].Value.As<int?>() == 2.0);
    blnShowUnitPriceColumnOnly = (rs.Fields["ShowUnitPriceColumnOnly"].Value.As<int?>() == 2.0);
    rs = rs.NextRecordset();
    iCounter = 1;
    //======================================Quoter Detail================================================
    f.Append("<QuoteDetail");
    f.Append(" ShowUnitPriceSeperately=\"" + (blnShowUnitPriceSeperately ?  "2" :  "0").As<string>() + "\"");
    f.Append(" ShowUnitPriceColumnOnly=\"" +(blnShowUnitPriceColumnOnly ?  "2" :  "0").As<string>() + "\"");
    f.Append(">");
    while(iCounter <= iTotalSegments)
    {
        sSegmentNo = rs.Fields["SegmentNo"].Value.As<string>();
        sDiscountColumnShow = 1;
        if (rs.Fields["ShowDiscountColumnWithoutDiscount"].Value.As<int?>() != 1 || rs.Fields["SegmentHasDiscountParts"].Value.As<int?>() != 1)
        {
            sDiscountColumnShow = 2;
        }
        sDesc = null;
        //******************************************Segments***********************************************************
        f.AppendLine("<Segment>");
        f.AppendLine("<SegmentNo>" + FormatXml(rs.Fields["SegmentNo"].Value.As<String>()) + "</SegmentNo>");
        f.AppendLine("<SegmentExternalNotes>" + rs.Fields["SegmentExternalNotes"].Value.ToString() + "</SegmentExternalNotes>");
        f.AppendLine("<SegmentInternalNotes>" + rs.Fields["SegmentInternalNotes"].Value.ToString() + "</SegmentInternalNotes>");
        f.AppendLine("<HiddenDescription></HiddenDescription>");
        f.AppendLine("<SegmentTotal>" + Util.FormatCurrency(rs.Fields["SegmentTotal"].Value.As<double>()) + "</SegmentTotal>");
        f.AppendLine("<JobCode>" + FormatXml(rs.Fields["JobCode"].Value.As<string>()) + "</JobCode>");
        f.AppendLine("<ComponentCode>" + FormatXml(rs.Fields["ComponentCode"].Value.As<string>()) + "</ComponentCode>");
        f.AppendLine("<ModifierCode>" + FormatXml(rs.Fields["ModifierCode"].Value.As<string>()) + "</ModifierCode>");
        f.AppendLine("<QuantityCode>" + FormatXml(rs.Fields["QuantityCode"].Value.As<string>()) + "</QuantityCode>");
        f.AppendLine("<JobLocationCode>" + FormatXml(rs.Fields["JobLocationCode"].Value.As<string>()) + "</JobLocationCode>");
        f.AppendLine("<ComponentCodeDesc>" + FormatXml(rs.Fields["ComponentCodeDesc"].Value.As<string>()) + "</ComponentCodeDesc>");
        f.AppendLine("<JobCodeDesc>" + FormatXml(rs.Fields["JobCodeDesc"].Value.As<string>()) + "</JobCodeDesc>");
        f.AppendLine("<DiscountColumnShow>" + sDiscountColumnShow + "</DiscountColumnShow>");
        f.AppendLine("<Parts_FlatRateIndicator_DisplayText>" + FormatXml(rs.Fields["Parts_FlatRateIndicator_DisplayText"].Value.As<string>()) + "</Parts_FlatRateIndicator_DisplayText>");
        f.AppendLine("<Labor_FlatRateIndicator_DisplayText>" + FormatXml(rs.Fields["Labor_FlatRateIndicator_DisplayText"].Value.As<string>()) + "</Labor_FlatRateIndicator_DisplayText>");
        f.AppendLine("<Misc_FlatRateIndicator_DisplayText>" + FormatXml(rs.Fields["Misc_FlatRateIndicator_DisplayText"].Value.As<string>()) + "</Misc_FlatRateIndicator_DisplayText>");
        f.AppendLine("<PartsTotal>" + Util.FormatCurrency(rs.Fields["PartsTotal"].Value.As<double>()) + "</PartsTotal>");
        f.AppendLine("<PartsLockedTotal>" + Util.FormatCurrency(rs.Fields["PartsLockedTotal"].Value.As<double>()) + "</PartsLockedTotal>");
        f.AppendLine("<LaborTotal>" + Util.FormatCurrency(rs.Fields["LaborTotal"].Value.As<double>()) + "</LaborTotal>");
        f.AppendLine("<LaborLockedTotal>" + Util.FormatCurrency(rs.Fields["LaborLockedTotal"].Value.As<double>()) + "</LaborLockedTotal>");
        f.AppendLine("<MiscTotal>" + Util.FormatCurrency(rs.Fields["MiscTotal"].Value.As<double>()) + "</MiscTotal>");
        f.AppendLine("<MiscLockedTotal>" + Util.FormatCurrency(rs.Fields["MiscLockedTotal"].Value.As<double>()) + "</MiscLockedTotal>");

        f.AppendLine("<PartsDiscountTotal>" + Util.FormatCurrency(rs.Fields["PartsDiscountTotal"].Value.As<double>()) + "</PartsDiscountTotal>");
        f.AppendLine("<LaborDiscountTotal>" + Util.FormatCurrency(rs.Fields["LaborDiscountTotal"].Value.As<double>()) + "</LaborDiscountTotal>");
        f.AppendLine("<MiscDiscountTotal>" + Util.FormatCurrency(rs.Fields["MiscDiscountTotal"].Value.As<double>()) + "</MiscDiscountTotal>");
        f.AppendLine("<PartsLockedDiscountTotal>" + Util.FormatCurrency(rs.Fields["PartsLockedDiscountTotal"].Value.As<double>()) + "</PartsLockedDiscountTotal>");
        f.AppendLine("<LaborLockedDiscountTotal>" + Util.FormatCurrency(rs.Fields["LaborLockedDiscountTotal"].Value.As<double>()) + "</LaborLockedDiscountTotal>");
        f.AppendLine("<MiscLockedDiscountTotal>" + Util.FormatCurrency(rs.Fields["MiscLockedDiscountTotal"].Value.As<double>()) + "</MiscLockedDiscountTotal>");
        f.AppendLine("<AllCustomerPartsTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerPartsTotal"].Value.As<double>()) + "</AllCustomerPartsTotal>");
        f.AppendLine("<AllCustomerLaborTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerLaborTotal"].Value.As<double>()) + "</AllCustomerLaborTotal>");
        f.AppendLine("<AllCustomerMiscTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerMiscTotal"].Value.As<double>()) + "</AllCustomerMiscTotal>");
        f.AppendLine("<AllCustomerPartsLockedTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerPartsLockedTotal"].Value.As<double>()) + "</AllCustomerPartsLockedTotal>");
        f.AppendLine("<AllCustomerLaborLockedTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerLaborLockedTotal"].Value.As<double>()) + "</AllCustomerLaborLockedTotal>");
        f.AppendLine("<AllCustomerMiscLockedTotal>" + Util.FormatCurrency(rs.Fields["AllCustomerMiscLockedTotal"].Value.As<double>()) + "</AllCustomerMiscLockedTotal>");
        f.AppendLine("<PartsPercent>" + FormatXml(rs.Fields["PartsPercent"].Value.As<string>()) + "</PartsPercent>");
        f.AppendLine("<LaborPercent>" + FormatXml(rs.Fields["LaborPercent"].Value.As<string>()) + "</LaborPercent>");
        f.AppendLine("<MiscPercent>" + FormatXml(rs.Fields["MiscPercent"].Value.As<string>()) + "</MiscPercent>");
        f.AppendLine("<PartsDiscountPercent>" + FormatXml(rs.Fields["PartsDiscountPercent"].Value.As<string>()) + "</PartsDiscountPercent>");
        f.AppendLine("<LaborDiscountPercent>" + FormatXml(rs.Fields["LaborDiscountPercent"].Value.As<string>()) + "</LaborDiscountPercent>");
        f.AppendLine("<MiscDiscountPercent>" + FormatXml(rs.Fields["MiscDiscountPercent"].Value.As<string>()) + "</MiscDiscountPercent>");


        //******************************************Segment Details*************************************************
            iTotal = 0.0;
            rs.MoveNext();
            rs = rs.NextRecordset();
            //Parts
            f.AppendLine("<Parts>");
            iTotal = 0;
            while(!(rs.EOF))
            {
                iExtPrice = numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double?>();
                iTotal = iTotal + iExtPrice.As<double>();
                f.AppendLine("<Detail>");
                f.AppendLine("<Sos>" + FormatXml(rs.Fields["Sos"].Value.As<string>()) + "</Sos>");
                f.AppendLine("<PartNo>" + FormatXml(rs.Fields["PartNo"].Value.As<string>()) + "</PartNo>");
                f.AppendLine("<Quantity>" + FormatXml(rs.Fields["Quantity"].Value.As<string>()) + "</Quantity>");
                f.AppendLine("<Description>" + FormatXml(rs.Fields["Description"].Value.As<string>()) + "</Description>");
                f.AppendLine("<UnitSellPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitSellPrice"].Value.As<string>())).As<double>() ) + "</UnitSellPrice>");  
                f.AppendLine("<UnitPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitPrice"].Value.As<string>())).As<double>() ) + "</UnitPrice>");  
                f.AppendLine("<Discount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["Discount"].Value.As<string>())).As<double>() ) + "</Discount>");  
                f.AppendLine("<DiscountAmount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["DiscountAmount"].Value.As<string>())).As<double>() ) + "</DiscountAmount>");  
                f.AppendLine("<UnitDiscPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitDiscPrice"].Value.As<string>())).As<double>() ) + "</UnitDiscPrice>"); 
                f.AppendLine("<ExtendedPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double>()) + "</ExtendedPrice>"); 
                f.AppendLine("<IsCorePart>" + FormatXml(rs.Fields["IsCorePart"].Value.As<string>()) + "</IsCorePart>");
               
                f.AppendLine("</Detail>");
                rs.MoveNext();
            }
            f.AppendLine("<iTotal>" + Util.FormatCurrency(numXml(FormatXml(iTotal.As<string>())).As<double?>()) + "</iTotal>"); 
            f.AppendLine("</Parts>");
             rs = rs.NextRecordset();

            //labor
            f.AppendLine("<Labor>");
            iTotal = 0;
            while(!(rs.EOF))
            {
                iExtPrice = numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double?>();
                iTotal = iTotal + iExtPrice.As<double>();
                f.AppendLine("<Detail>");
                f.AppendLine("<ItemNo>" + FormatXml(rs.Fields["ItemNo"].Value.As<string>()) + "</ItemNo>");
                f.AppendLine("<Quantity>" + FormatXml(rs.Fields["Quantity"].Value.As<string>()) + "</Quantity>");
                f.AppendLine("<Description>" + FormatXml(rs.Fields["Description"].Value.As<string>()) + "</Description>");
                f.AppendLine("<UnitPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitPrice"].Value.As<string>())).As<double>() ) + "</UnitPrice>");  
                f.AppendLine("<Discount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["Discount"].Value.As<string>())).As<double>() ) + "</Discount>");  
                f.AppendLine("<DiscountAmount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["DiscountAmount"].Value.As<string>())).As<double>() ) + "</DiscountAmount>");  
                f.AppendLine("<UnitDiscPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitDiscPrice"].Value.As<string>())).As<double>() ) + "</UnitDiscPrice>");  
                f.AppendLine("<ExtendedPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double>()) + "</ExtendedPrice>"); 
                f.AppendLine("</Detail>");
                rs.MoveNext();
            }
            f.AppendLine("<iTotal>" + Util.FormatCurrency(numXml(FormatXml(iTotal.As<string>())).As<double?>()) + "</iTotal>"); 
            f.AppendLine("</Labor>");
            rs = rs.NextRecordset();

            //misc
            f.AppendLine("<Misc>");
            iTotal = 0;
            while(!(rs.EOF))
            {
                iExtPrice = numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double?>();
                iTotal = iTotal + iExtPrice.As<double>();
                f.AppendLine("<Detail>");
                f.AppendLine("<ItemNo>" + FormatXml(rs.Fields["ItemNo"].Value.As<string>()) + "</ItemNo>");
                f.AppendLine("<Quantity>" + FormatXml(rs.Fields["Quantity"].Value.As<string>()) + "</Quantity>");
                f.AppendLine("<Description>" + FormatXml(rs.Fields["Description"].Value.As<string>()) + "</Description>");
                f.AppendLine("<UnitPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitPrice"].Value.As<string>())).As<double>() ) + "</UnitPrice>");  
                f.AppendLine("<Discount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["Discount"].Value.As<string>())).As<double>() ) + "</Discount>");  
                f.AppendLine("<DiscountAmount>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["DiscountAmount"].Value.As<string>())).As<double>() ) + "</DiscountAmount>");  
                f.AppendLine("<UnitDiscPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["UnitDiscPrice"].Value.As<string>())).As<double>() ) + "</UnitDiscPrice>");  
                f.AppendLine("<ExtendedPrice>" + Util.FormatCurrency(numXml(FormatXml(rs.Fields["ExtendedPrice"].Value.As<string>())).As<double>()) + "</ExtendedPrice>"); 
                f.AppendLine("</Detail>");
                rs.MoveNext();
            }
            f.AppendLine("<iTotal>" + Util.FormatCurrency(numXml(FormatXml(iTotal.As<string>())).As<double?>()) + "</iTotal>"); 
            f.AppendLine("</Misc>");


            f.AppendLine("</Segment>");


       
        rs = rs.NextRecordset();
        iCounter = iCounter + 1;
    }

    f.AppendLine("</QuoteDetail>");
    
    f.AppendLine("<QuoteTotalByCustomer>" + Util.NumberFormat(rs.Fields["quoteTotalByCustomer"].Value.AsDouble(0.00),2,-2,-2,-2,true).ToString() + "</QuoteTotalByCustomer>"); 

    rs = rs.NextRecordset();

    // Financials Section (begin)
    var bShowFinancials = true;
    bShowFinancials = (bShowFinancials && (!rs.EOF));

    if(bShowFinancials)
    {
        f.AppendLine("<Financials>");
    }
    while(!rs.EOF)
    {
        f.AppendLine("<Item>");
        f.AppendLine("<ItemName>" + rs.Fields["FinancialItemDisplayName"].Value.As<string>() + "</ItemName>");
        if(rs.Fields["FinancialItemPercent"].Value.As<string>("") == "")
        {
            f.AppendLine("<Percent></Percent>");
        }else
        {
            f.AppendLine("<Percent>" + Util.NumberFormat(rs.Fields["FinancialItemPercent"].Value.AsDouble(0.00),2,-2,-2,-2,true).ToString() + " %</Percent>");
        }
        if(rs.Fields["FinancialItemAmount"].Value.As<string>("") == "")
        {
            f.AppendLine("<Amount></Amount>");
        }else
        {
            f.AppendLine("<Amount>" + Util.NumberFormat( rs.Fields["FinancialItemAmount"].Value.AsDouble(0.00),2,-2,-2,-2,true).ToString() + "</Amount>");
        }
        f.AppendLine("<ItemStyle>" + rs.Fields["RowStyle"].Value.As<string>() + "</ItemStyle>");
        f.AppendLine("<ItemId>" + rs.Fields["FinancialItemId"].Value.As<string>() + "</ItemId>");
        f.AppendLine("</Item>");

        rs.MoveNext();
    }

    if(bShowFinancials)
    {
        f.AppendLine("</Financials>");
    }

    rs = rs.NextRecordset();
    while(!(rs.EOF))
    {
        
        f.AppendLine("<TermCond>" + FormatXml(rs.Fields["TermCond"].Value.As<string>()) + "</TermCond>");
        rs.MoveNext();
    }
        //Show disclaimers
    if (blnShowDisclaimers)
    {
        rs = rs.NextRecordset();
        if (!rs.Fields["Disclaimers"].Value.As<string>().IsNullOrEmpty())
        {
            f.Append("<Disclaimers>");
            f.Append(FormatXmlParagraph(rs.Fields["Disclaimers"].Value.As<string>()));
            f.Append("</Disclaimers>");
        }
    }

    if (Util.IsLoopableRecordset(rs))
    {
        rs.MoveNext();
    }
    rs = rs.NextRecordset();

    if (Util.IsLoopableRecordset(rs))
    {
        strAcknowledgeMessage = rs.Fields["QuoteAcknowledgeMessage"].Value.As<string>();
    }
    if (!strAcknowledgeMessage.IsNullOrWhiteSpace())
    {
        f.AppendLine("<AcknowledgeMessage>" + FormatXml(strAcknowledgeMessage) + "</AcknowledgeMessage>");
    }
    
    f.AppendLine("</root>");

   // Response.Write( f.ToString());
   // Response.End() ;
    sQuoteNo = Request.QueryString["QuoteNo"];
    string sQuoteFN = "PSQuoter_" + sQuoteNo.Replace("\\","_").Replace("/","_") + "_" + DateTime.Now.ToString("yyMMddHHmmssfff");

    string xmlFilePath = Server.MapPath("/") + "PDFGenDocs\\" + sQuoteFN + "_xml.txt";
    TextWriter tw = new StreamWriter(xmlFilePath);
    tw.WriteLine(f.ToString());
    tw.Close();
    curCustomerName = Server.UrlEncode(curCustomerName );

    if (iEmail == "1")
    {
        Response.Redirect("PDFEmailGen.aspx?SendEmail=1&QuoteNo=" + sQuoteNo+"&sToEmail="+sToEmail+"&sQuoteFN=" + sQuoteFN + "&CurCustomerName=" + curCustomerName + "&sFromEmail=" + Server.UrlEncode(sFromEmail) );
        
    }
    else
    {
        Response.Redirect("PDFEmailGen.aspx?SendEmail=0&QuoteNo=" + sQuoteNo+"&sToEmail="+sToEmail+"&sQuoteFN=" + sQuoteFN + "&CurCustomerName=" + curCustomerName + "&sFromEmail=" + Server.UrlEncode(sFromEmail) );   
    }

    rs = null;
    Util.CleanUp(cmd: cmd);
%>
<script language="C#" runat="server">
    string curCustomerName = "";
    string sSRFaxNo = null;
    string sTaxCode = null;
    string  sToEmail = null;
    string  sFromEmail = null;
    string sSalesRepPhoneNo = null;
    string sSalesRepCellPhoneNo = null;
    string  sBranchPhone = null;
    string fnXml = null;
    double? iQuoteTotal = null;
    string iEstRepTime = null;
    string sSalesRep = null;
    int? iTotalSegments = null;
    int iCounter = 0;
    string sSegmentNo = null;
    int sDiscountColumnShow = 0;
    string sDesc = null;
    double iTotal = 0;
    string sCategory = null;
    string sCategoryOLD = null;
    double? iExtPrice = null;

    ADODB.Recordset rs = null;
    Guid? GUID = null;
    //======================================Generate XML File================================================
    StringBuilder f = null;

    string strAcknowledgeMessage = null;
    string strFirstName = null;
    string strLastName = null;
    string ReplaceSpecChar(string str) 
    {
        if(str == null)
        {
            str = "";
        }
        str = str.Replace("/", "_");
        str = str.Replace("\\", "_");
        str = str.Replace("|", "_");
        str = str.Replace("\"", "_");
        str = str.Replace("?", "_");
        str = str.Replace("<", "_");
        str = str.Replace(">", "_");
        str = str.Replace("*", "_");
        return str;
    }

    string FormatXml(string str) 
    {
        if(str == null)
        {
            str = "";
        }
        
        str = str.Replace("&", "&amp;");
        str = str.Replace("<", "&lt;");
        str = str.Replace(">", "&gt;");
        str = str.Replace("'", "&apos;");

        return str;
    }

    string numXml(string str) 
    {
        if (str.IsNullOrWhiteSpace())
        {
            str = "0.00";
        }
        return str;
    }

    string FormatXmlParagraph(string strData) 
    {
        string FormatXmlParagraph = null;
        string[] arrLines = null;
        int Idx = 0;
        string strXml = null;
        if (strData.IsNullOrWhiteSpace()) 
        {
            FormatXmlParagraph = "";
            return FormatXmlParagraph;
        }
        if (strData.IndexOf("\r\n") != -1)  
        {
            arrLines = strData.Split(new String[]{"\r\n"}, StringSplitOptions.RemoveEmptyEntries);  
        }
        else if( strData.IndexOf("\n") != -1)
        {
            //Line Feed
            arrLines = strData.Split(new String[]{"\n"}, StringSplitOptions.RemoveEmptyEntries);  
        }
        else
        {
            //Carry
            arrLines = strData.Split(new String[]{"\r"}, StringSplitOptions.RemoveEmptyEntries);
        }

        for(Idx = 0; Idx < arrLines.Count(); Idx += 1) 
        {
            strXml = strXml + "<para>" + FormatXml(arrLines[Idx]) + "</para>";
        }
        FormatXmlParagraph = strXml;
        return FormatXmlParagraph;
    }

</script>
</asp:Content>
