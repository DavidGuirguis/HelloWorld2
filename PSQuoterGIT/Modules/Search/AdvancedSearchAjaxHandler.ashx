<%@ WebHandler Language="C#" Class="AdvancedSearchAjaxHandler" %>

using System;
using AppContext = Canam.AppContext;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Entities;
using X.Extensions;
using CATPAI;
using DTO;
using System.Text;
using Helpers;
using System.Data;


public class AdvancedSearchAjaxHandler : IHttpHandler
{
    IDictionary<string, IEnumerable<DataRow>> rowsSet;
    char spiltChar = (char)5;
    string sjSortField="";
    string sjSortDirection = "";
    string woSortField = "";
    string woSortDirection = "";
    string quoteSortField = "";
    string quoteSortDirection = "";
    int includeZero = 0;
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string custNo = context.Request.QueryString["custNo"].AsString("");   //<CODE_TAG_103354>
        string make = context.Request.QueryString["make"].AsString("");
        string serialNo = context.Request.QueryString["serialNo"].AsString("");
        string model = context.Request.QueryString["model"].AsString("");
        string jobCode = context.Request.QueryString["jobCode"].AsString("");
        string jobDesc = context.Request.QueryString["jobDesc"].AsString(""); //<CODE_TAG_103410>
        string componentCode = context.Request.QueryString["componentCode"].AsString("");
        string componentDesc = context.Request.QueryString["componentDesc"].AsString("");  //<CODE_TAG_103410>
        string modifierCode = context.Request.QueryString["modifierCode"].AsString("");
        string modifierDesc = context.Request.QueryString["modifierDesc"].AsString("");  //<CODE_TAG_103410>
        string businessGroupCode = context.Request.QueryString["businessGroupCode"].AsString("");
        string quantityCode = context.Request.QueryString["quantityCode"].AsString("");
        string workApplicationCode = context.Request.QueryString["workApplicationCode"].AsString("");
        string branchCode = context.Request.QueryString["branchCode"].AsString("");
        string costCentreCode = context.Request.QueryString["costCentreCode"].AsString("");
        string originator = context.Request.QueryString["originator"].AsString("");
        string owner = context.Request.QueryString["owner"].AsString("");
        string manager = context.Request.QueryString["manager"].AsString("");
        string cabTypecde = context.Request.QueryString["cabTypecde"].AsString("");
        string shopField = context.Request.QueryString["shopField"].AsString("");
        string jobLocationCode = context.Request.QueryString["jobLocationCode"].AsString("");
        string limitType = context.Request.QueryString["limitType"].AsString("");
            
        int limitRecords = context.Request.QueryString["limitRecords"].AsInt(100);
        int querySection = context.Request.QueryString["refreshSection"].AsInt(7);   // 1:standard jobs  2:workorder  4: Quote  7: all
        DateTime? fromDate = context.Request.QueryString["fromDate"].As<DateTime?>();
        DateTime? toDate = context.Request.QueryString["toDate"].As<DateTime?>();
        includeZero = context.Request.QueryString["IncludeZero"].AsInt(0);
        
        sjSortField = context.Request.QueryString["sjSortField"].AsString("jobcode");
        sjSortDirection = context.Request.QueryString["sjSortDirection"].AsString("ASC");
        woSortField = context.Request.QueryString["woSortField"].AsString("wono");
        woSortDirection = context.Request.QueryString["woSortDirection"].AsString("ASC");
        quoteSortField = context.Request.QueryString["quoteSortField"].AsString("QuoteNo");
        quoteSortDirection = context.Request.QueryString["quoteSortDirection"].AsString("ASC");

        string rtHtml = "";
        string rtOp = "R";
        DataSet ds = DAL.Quote.Quote_Get_AdvancedSearch(custNo,         //<CODE_TAG_103354>
                                                        make,
                                                        serialNo,
                                                        model,
                                                        jobCode,
                                                        jobDesc,  //<CODE_TAG_103410>
                                                        componentCode,
                                                        componentDesc,  //<CODE_TAG_103410>
                                                        modifierCode,
                                                        modifierDesc,  //<CODE_TAG_103410>
                                                        businessGroupCode,
                                                        quantityCode,
                                                        workApplicationCode,
                                                        branchCode,
                                                        costCentreCode,
                                                        cabTypecde,
                                                        shopField,
                                                        jobLocationCode,
                                                        fromDate,
                                                        toDate,
                                                        originator,
                                                        owner,
                                                        manager, 
                                                        limitRecords,
                                                        limitType,
                                                        querySection,
                                                        sjSortField,
                                                        sjSortDirection,
                                                        woSortField,
                                                        woSortDirection,
                                                        quoteSortField,
                                                        quoteSortDirection
                                                        );

        rowsSet = ds.ToDictionary();

        rtHtml += getStandardJobHtml() + spiltChar ;
        rtHtml += getWOHtml() + spiltChar ;
        rtHtml += getQuoteSegmentHtml();
        
        context.Response.Write(rtOp + "," + rtHtml);


    }

    private string getStandardJobHtml()
    {
        string rt = "";
        string sColour = "white";
        if (rowsSet.ContainsKey("StandardJobs"))
        {
            rt += "<table class='tbl' cellspacing='1' cellpadding='2' width='100%'>";
            rt += "<tr class='reportHeader' >";
            rt += "<td></td>";
            rt += "<td style='white-space:nowrap'><a href='javascript:sortResult(\"SJ\", \"ModelFRExchange\")'>Model/FRExchange</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"SerialNo\")'>Serial No</a></td>";
            
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"Desc\")'>Description</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"JobCode\")'>Job Code</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"ComponentCode\")'>Component Code</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"ModifierCode\")'>Modifier</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"BusinessGroup\")'>Business Group</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"WorkApplicationCode\")'>Work Application</a></td>";
            rt += "<td><a href='javascript:sortResult(\"SJ\", \"QuantityCode\")'>Qty</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"SJ\", \"LaborHours\")'>Labor Hours</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"SJ\", \"PartsAmount\")'>Parts Amt</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"SJ\", \"laborAmount\")'>Labor Amt</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"SJ\", \"miscAmount\")'>Misc Amt</a></td>";
            rt += "<td class='tAr'>";
            rt += "<input type='hidden' id='hidSJSortField' value='" + sjSortField + "' />";
            rt += "<input type='hidden' id='hidSJSortDirection' value='" + sjSortDirection + "' />";
            rt += "<a  href='javascript:sortResult(\"SJ\", \"TotalAmount\")'>Total Amt</a></td>";
            rt += "</tr>";
            foreach (DataRow dr in rowsSet["StandardJobs"])
            {

                rt += "<tr bgColor=" + sColour + ">";
                rt += "<td><a href='javascript:createSJSeg(\"" + dr["DBSRepairOptionId"].ToString() + "\",\"" + dr["RepairOptionPricingID"].ToString() + "\")'>New Quote</a></td>";

                rt += "<td>" + dr["ModelFRExchange"].ToString().Trim()  + "</td>";
                rt += "<td>" + ((dr["SerialNo"].ToString().Trim() == "-")? "" : dr["SerialNo"].ToString() )+ "</td>";
                rt += "<td>" + dr["jobCodeDesc"].ToString() + " " + dr["componentCodeDesc"].ToString() + "</td>";
                rt += "<td>" + dr["jobcode"].ToString() + "</td>";
                rt += "<td>" + dr["componentCode"].ToString() + "</td>";
                rt += "<td>" + dr["ModifierCode"].ToString() + "</td>";
                rt += "<td>" + dr["businessgroup"].ToString() + "</td>";
                rt += "<td>" + dr["workApplicationCode"].ToString() + "</td>";
                rt += "<td>" + dr["QuanityCode"].ToString() + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["LaborHours"].AsDouble(),2,-2,-2,-2,false)    + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["PartsAmount"].AsDouble(),2,-2,-2,-2,false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["laborAmount"].AsDouble(),2,-2,-2,-2,false)+ "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["MiscAmount"].AsDouble(),2,-2,-2,-2,false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["TotalAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "</tr>";
                if (sColour == "white")
                    sColour = "#efefef";
                else
                    sColour = "white";
            }

            rt += "</table>";
        }
        else
        {
            rt += "<table><tr><td>Serial Number or Model must be chosen at least 3 characters for Standard Jobs search</td></tr></table>";
        }
        
        return rt;
    }



    private string getWOHtml()
    {
        string rt = "";
        string sColour = "white";
        if (rowsSet.ContainsKey("WorkOrder"))
        {
            rt += "<table class='tbl' cellspacing='1' cellpadding='2' width='100%'>";
            rt += "<tr class='reportHeader' >";
            rt += "<td></td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"wono\")'> WO No </a> </td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"segmentNo\")'>Segment No </a></td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"CustomerNo\")'>Customer No </a></td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"CustomerName\")'>Customer Name</a></td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"SerialNo\")'>S/N</a></td>";
            rt += "<td> <a href='javascript:sortResult(\"WO\", \"InvoiceDate\")'>Invoice Date</a></td>";
            rt += "<td class='tAr'> <a href='javascript:sortResult(\"WO\", \"laborHours\")'>Labor Hours</a></td>";
            rt += "<td class='tAr'> <a href='javascript:sortResult(\"WO\", \"PartsAmount\")'>Parts Amount </a></td>";
            rt += "<td class='tAr'> <a href='javascript:sortResult(\"WO\", \"LaborAmount\")'>Labor Amount</a></td>";
            rt += "<td class='tAr'> <a href='javascript:sortResult(\"WO\", \"MiscAmount\")'>Misc Amount</a></td>";
            rt += "<td class='tAr'> <a href='javascript:sortResult(\"WO\", \"TotalAmount\")'>Total Amount</a></td>";
            rt += "<td>";
            rt += "<input type='hidden' id='hidWOSortField' value='" + woSortField  + "' />";
            rt += "<input type='hidden' id='hidWOSortDirection' value='" + woSortDirection + "' />";
            rt += "</td>";
            rt += "</tr>";
            foreach (DataRow dr in rowsSet["workOrder"])
            {

                rt += "<tr bgColor=" + sColour + ">";
                rt += "<td><a href='javascript:createWOSeg(\"" + dr["wono"].ToString().Trim() + "\" , \"" + dr["segmentNo"].ToString().Trim( ) + "\"    )'>New Quote</a></td>";
                rt += "<td><a href='javascript:popWO(\"" + dr["wono"].ToString() + "\")' >" + dr["wono"].ToString() + " </a></td>";
                rt += "<td>" + dr["segmentNo"].ToString() + "</td>";
                rt += "<td>" + dr["CustomerNo"].ToString() + "</td>";
                rt += "<td>" + dr["CustomerName"].ToString() + "</td>";
                rt += "<td>" + dr["SerialNo"].ToString() + "</td>";
                rt += "<td>" + Util.DateFormat(dr["InvoiceDate"].As<DateTime?>()) + "</td>";
                rt += "<td class='tAr'>" +  Util.NumberFormat(dr["LaborHours"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["PartsAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["LaborAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["MiscAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["TotalAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td>" ;
                rt += "<input type='checkbox' " + ((includeZero == 0 && dr["TotalAmount"].AsDouble() == 0) ? "" : "checked='checked' " ) + " onclick='calculateWOSummary();' LaborHours='" + dr["LaborHours"].AsDouble(0) + "' PartsAmount='" + dr["PartsAmount"].AsDouble(0) + "' LaborAmount='" + dr["LaborAmount"].AsDouble(0) + "' MiscAmount='" + dr["MiscAmount"].AsDouble(0) + "' TotalAmount='" + dr["TotalAmount"].AsDouble(0) + "'>";
                rt += "</td>";
                rt += "</tr>";
                if (sColour == "white")
                    sColour = "#efefef";
                else
                    sColour = "white";

            }

            rt += "</table>";
        }
        else
        {
            rt += "<table><tr><td>No Matches Found.</td></tr></table>";
        }
        return rt;
    }



    private string getQuoteSegmentHtml()
    {
        string rt = "";
        string sColour = "white";
        if (rowsSet.ContainsKey("QuoteSegment"))
        {
            rt += "<table class='tbl' cellspacing='1' cellpadding='2' border=\"0\" width='100%'>";
            rt += "<tr class='reportHeader'  >";
            rt += "<td></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"QuoteNo\")'>Quote No</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"Revision\")'>Revision</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"SegmentNo\")'>Segment No</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"CustomerNo\")'>Customer No</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"CustomerName\")'>Customer Name..</a></td>";
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))//<CODE_TAG_101767>
            {
                rt += "<td><a href='javascript:sortResult(\"Quote\", \"QuoteDescription\")'>Quote Description</a></td>";//<CODE_TAG_101767>
            }//</CODE_TAG_101767>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"BranchName\")'>Branch</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"CostCenter\")'>Cost Center</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"QuoteStatus\")'>Status</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"Division\")'>Division</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"ProbabilityOfClosing\")'>Probability Of Closing</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"SalesRep\")'>Owner</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"Creator\")'>Creator</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"WorkOrderNo\")'>Work Order Number</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"Make\")'>Make</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"Model\")'>Model</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"UrgencyIndicator\")'>Urgency Indicator</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"JobCode\")'>Job Code</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"ComponentCode\")'>Component Code</a></td>";//<CODE_TAG_104104>
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"AcceptedDate\")'>Accepted Date</a></td>";//<CODE_TAG_104104>            
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"DeliveryDate\")'>Est. Delivery Date</a></td>";//<CODE_TAG_104104> 
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"DaysOutstanding\")'>Days Outstanding</a></td>";//<CODE_TAG_104104> 
            //rt += "<td><a href='javascript:sortResult(\"Quote\", \"SalesRep\")'>Sales Rep</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"SerialNo\")'>S/N</a></td>";
            rt += "<td><a href='javascript:sortResult(\"Quote\", \"QuoteDate\")'>Quote Date</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"Quote\", \"LaborHours\")'>Labor Hours</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"Quote\", \"PartsAmount\")'>Parts Amount</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"Quote\", \"LaborAmount\")'>Labor Amount</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"Quote\", \"MiscAmount\")'>Misc Amount</a></td>";
            rt += "<td class='tAr'><a href='javascript:sortResult(\"Quote\", \"totalAmount\")'>Total Amount</a></td>";
            rt += "<td>";
            rt += "<input type='hidden' id='hidQuoteSortField' value='" + quoteSortField  + "' />";
            rt += "<input type='hidden' id='hidQuoteSortDirection' value='" + quoteSortDirection + "' />";
            rt += "</td>";
            rt += "</tr>";
            foreach (DataRow dr in rowsSet["QuoteSegment"])
            {

                rt += "<tr bgColor=" + sColour + ">";
                rt += "<td><a href='javascript:createQuoteSeg(\"" + dr["quoteNo"].ToString() + "\" , \"" + dr["segmentNo"].ToString() + "\")'>New Quote</a></td>";
                rt += "<td><a href='../quote/quote_Summary.aspx?QuoteId=" + dr["QuoteId"].ToString()  + "&Revision=" + dr["Revision"].ToString()  + "'>"  + dr["quoteNo"].ToString() + " </a></td>";
                rt += "<td>" + dr["Revision"].ToString() + "</td>";
                rt += "<td>" + dr["segmentNo"].ToString() + "</td>";
                rt += "<td>" + dr["CustomerNo"].ToString() + "</td>";
                rt += "<td>" + dr["CustomerName"].ToString() + "</td>";
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))//<CODE_TAG_101767>
                {
                    rt += "<td>" + (dr["QuoteDescription"] != System.DBNull.Value ? dr["QuoteDescription"].ToString() : string.Empty) + "</td>";
                }//</CODE_TAG_101767>
                rt += "<td>" + (dr["BranchName"] != System.DBNull.Value ? dr["BranchName"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["CostCenter"] != System.DBNull.Value ? dr["CostCenter"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["QuoteStatus"] != System.DBNull.Value ? dr["QuoteStatus"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["Division"] != System.DBNull.Value ? dr["Division"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["ProbabilityOfClosing"] != System.DBNull.Value ? dr["ProbabilityOfClosing"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["SalesRep"] != System.DBNull.Value ? dr["SalesRep"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["Creator"] != System.DBNull.Value ? dr["Creator"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["WorkOrderNo"] != System.DBNull.Value ? dr["WorkOrderNo"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["Make"] != System.DBNull.Value ? dr["Make"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["Model"] != System.DBNull.Value ? dr["Model"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["UrgencyIndicator"] != System.DBNull.Value ? dr["UrgencyIndicator"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["JobCode"] != System.DBNull.Value ? dr["JobCode"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["ComponentCode"] != System.DBNull.Value ? dr["ComponentCode"].ToString() : string.Empty) + "</td>";
                rt += "<td>" + (dr["AcceptedDate"] != System.DBNull.Value ? Util.DateFormat(dr["AcceptedDate"].As<DateTime?>()) : string.Empty) + "</td>";
                rt += "<td>" + (dr["DeliveryDate"].As<DateTime>() != Convert.ToDateTime("1900-01-01") ? Util.DateFormat(dr["DeliveryDate"].As<DateTime?>()) : string.Empty) + "</td>";
                rt += "<td>" + (dr["DaysOutstanding"] != System.DBNull.Value ? dr["DaysOutstanding"].ToString() : string.Empty) + "</td>";                
                //rt += "<td>" + dr["salesRep"].ToString() + "</td>";
                rt += "<td>" + dr["SerialNo"].ToString() + "</td>";
                rt += "<td>" + Util.DateFormat(dr["quoteDate"].As<DateTime?>()) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["LaborHours"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["PartsAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["LaborAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["MiscAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td class='tAr'>" + Util.NumberFormat(dr["totalAmount"].AsDouble(), 2, -2, -2, -2, false) + "</td>";
                rt += "<td>";
                rt += "<input type='checkbox' " + ((includeZero == 0 && dr["TotalAmount"].AsDouble() == 0) ? "" : "checked='checked' ") + " onclick='calculateQuoteSummary();' LaborHours='" + dr["LaborHours"].AsDouble(0) + "' PartsAmount='" + dr["PartsAmount"].AsDouble(0) + "' LaborAmount='" + dr["LaborAmount"].AsDouble(0) + "' MiscAmount='" + dr["MiscAmount"].AsDouble(0) + "' TotalAmount='" + dr["TotalAmount"].AsDouble(0) + "' >";
                rt += "</td>";

                rt += "</tr>";
                if (sColour == "white")
                    sColour = "#efefef";
                else
                    sColour = "white";

            }

            rt += "</table>";
        }
        else
        {
            rt += "<table><tr><td>No Matches Found.</td></tr></table>";
        }
        return rt;
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}

