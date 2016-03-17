using AppContext = Canam.AppContext;
using System;
using System.Data;
using X.Extensions;
using System.Text;
using System.Collections.Generic;
using Helpers;
using System.Web;

namespace Entities
{
    public class Labor
    {
        public int ItemId { get; set; }
        public double Quantity { get; set; }
        public string ItemNo { get; set; }
        public string Description { get; set; }
        public string Shift { get; set; }
        public double UnitSellPrice { get; set; } //from dic, just a refen
        public double UnitPrice { get; set; }     //user can input
        public double Discount { get; set; }
        //<CODE_TAG_101694>
        public double UnitDiscPrice 
        { 
            //get { return Math.Round(UnitPrice * (1 - Discount / 100),2) ; } 
            get
            {
            //<CODE_TAG_103590>
                string laborDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Labor.Discount.Heading"].ToString();
                if (!string.IsNullOrEmpty(laborDiscountHeading))
                    return Math.Round(UnitPrice * (1 + Discount / 100), 2);
                else
                    return Math.Round(UnitPrice * (1 - Discount / 100),2) ;
                //</CODE_TAG_103590>
            }
        }
        public double DiscountAmount  { get {  return UnitPrice * Quantity - ExtendedPrice; } }
        //public double ExtendedPrice { get { return Quantity * UnitPrice * (1 - Discount / 100); } }
        public double ExtendedPrice   { get { return Quantity * UnitDiscPrice; }  }
        //</CODE_TAG_101694>
        public IdentityInfo  EnterUser { get; set; }
        public DateTime  EnterDate { get; set; }
        public IdentityInfo  ChangeUser { get; set; }
        public DateTime  ChangeDate { get; set; }
        public int SortOrder { get; set; }
        public int Lock { get; set; }
        public bool IsLocked
        {
            get
            {
                if (Lock == 2)
                    return true;
                else
                    return false;
            }
        }
        public Labor()
        {
            Quantity = 1;//<CODE_TAG_102266>
        }
        public Labor( DataRow dr)
        {
            ItemId = dr["ItemId"].AsInt();
            Quantity = dr["Quantity"].AsDouble();
            ItemNo = dr["ItemNo"].ToString();
            Description = dr["Description"].ToString();
            Shift = dr["shift"].ToString();
            UnitSellPrice = dr["UnitSellPrice"].AsDouble();
            UnitPrice = dr["UnitPrice"].AsDouble();
            Discount = dr["Discount"].AsDouble();
            Lock = dr["Lock"].AsInt(1);
            SortOrder = dr["SortOrder"].AsInt();
        }
    }

    public class LaborUtil
    {
        //public static string GetReadonlyHtml(List<Labor> allLabor, string flatRateInd, double flatRateAmount)  
        public static string GetReadonlyHtml(List<Labor> allLabor, string flatRateInd, double flatRateAmount, double flatRateQtyInput)//<CODE_TAG_103464>
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }
            StringBuilder sb = new StringBuilder();
            double totalExtPrice = 0;
            //<CODE_TAG_103590>
            string laborDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Labor.Discount.Heading"].ToString();
            //</CODE_TAG_103590>
            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(2); //<CODE_TAG_101986>
            sb.Append("<table>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode") )
            {
                //Header
                sb.Append("<tr>");

                
                /*sb.Append("<th style='width:20%'>Charge Code (LCC-LC-ST-CC)</th>");
                sb.Append("<th style='width:30%'>Description</th>");
                sb.Append("<th style='width:5%' class='tAr'>Qty</th>");
                sb.Append("<th style='width:5%' class='tAr'></th>");
                sb.Append("<th style='width:5%' >Rate Type</th>");
                sb.Append("<th style='width:5%' class='tAr'>Sell Price</th>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                    sb.Append("<th style='width:10%' class='tAr'>Discount</th>");
                else
                    sb.Append("<th style='width:10%' ></th>");
                sb.Append("<th style='width:5%' ></th>");
                sb.Append("<th style='width:15%' class='tAr'>Ext Price</th>");*/

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "ChargeCode":
                            sb.Append("<th style='width:20%'>Charge Code (LCC-LC-ST-CC)</th>");
                            break;
                        case "Description":
                            sb.Append("<th style='width:30%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th style='width:5%' class='tAr'>Qty</th>");
                            sb.Append("<th style='width:5%' class='tAr'></th>");
                            break;
                        case "RateType":
                            sb.Append("<th style='width:5%' >Rate Type</th>");
                            break;
                        case "SellPrice":
                            sb.Append("<th style='width:5%' class='tAr'>Sell Price</th>");
                            break;

                        case "Discount":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                            
                            //sb.Append("<th style='width:10%' class='tAr'>Discount</th>");
                            //<CODE_TAG_103590>
                            {
                                if (!string.IsNullOrEmpty(laborDiscountHeading))
                                    sb.Append("<th style='width:10%' class='tAr'>" + laborDiscountHeading + "(%)</th>");
                                else
                                    sb.Append("<th style='width:10%' class='tAr'>Discount</th>");
                            }
                            //<CODE_TAG_103590>
                            else
                            {
                                sb.Append("<th style='width:10%' ></th>");
                            }
                            sb.Append("<th style='width:5%' ></th>");
                            break;
                        case "ExtendedPrice":
                            //sb.Append("<th style='width:15%' class='tAr'>Ext Price</th>");
                            sb.Append("<th style='width:15%' class='tAr'>Ext Price");//<CODE_TAG_102284>
                            break;
                        default:
                            break;
                    }
                }
                //<CODE_TAG_102284>
                sb.Append("<input type='Hidden' id='hdnLaborCount' name='hdnLaborCount'  value='" + allLabor.Count + "'  />");
                sb.Append("</th>");//</CODE_TAG_102284>
                //</CODE_TAG_101986> 

                sb.Append("</tr>");
                //Items
                foreach (Labor l in allLabor)
                {
                    sb.Append("<tr>");


                    /*sb.Append("<td>" + l.ItemNo + "</td>");
                    sb.Append("<td>" + l.Description + "</td>"); 
                    sb.Append("<td class='tAr'>" + l.Quantity + "</td>");
                    sb.Append("<td></td>");
                    sb.Append("<td>" + ((l.Shift == "CRTR")?"Regular": ((l.Shift == "COTR") ? "Overtime":"Premium") )   + "</td>"); 
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "</td>");
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                        sb.Append("<td class='tAr'>" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "</td>");
                    else
                        sb.Append("<td></td>");
                    sb.Append("<td></td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "</td>");*/

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                sb.Append("<td>" + l.ItemNo + "</td>");
                                break;
                            case "Description":
                                sb.Append("<td>" + l.Description + "</td>");
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAr'>" + l.Quantity + "</td>");
                                sb.Append("<td></td>");
                                break;
                            case "RateType":
                                sb.Append("<td>" + ((l.Shift == "CRTR") ? "Regular" : ((l.Shift == "COTR") ? "Overtime" : "Premium")) + "</td>");
                                break;
                            case "SellPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "</td>");
                                break;

                            case "Discount":
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "</td>");
                                else
                                    sb.Append("<td></td>");
                                sb.Append("<td></td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "</td>");
                                break;
                            default:
                                break;
                        }
                    }
                    //</CODE_TAG_101986> 

                    sb.Append("</tr>");

                    totalExtPrice += l.ExtendedPrice;
                }
            }
            else
            {
                //Header
                sb.Append("<tr>");



                /*sb.Append("<th style='width:10%'>Item No</th>");
                sb.Append("<th style='width:40%'>Description</th>");
                sb.Append("<th class='tAr' style='width:5%'>Qty</th>");
                sb.Append("<th class='tAr' style='width:5%'></th>");
                sb.Append("<th class='tAr' style='width:5%'></th>");
                sb.Append("<th class='tAr' style='width:10%'>Unit Price</th>");
                sb.Append("<th class='tAr' style='width:10%'>Discount(%)</th>");
                sb.Append("<th class='tAr' style='width:10%'>Disc Price</th>");
                sb.Append("<th class='tAr' style='width:10%'>Ext Price</th>");
                */
                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "ChargeCode":
                            sb.Append("<th style='width:10%'>Item No</th>");
                            break;
                        case "Description":
                            sb.Append("<th style='width:40%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th class='tAr' style='width:5%'>Qty</th>");
                            sb.Append("<th class='tAr' style='width:5%'></th>");
                            sb.Append("<th class='tAr' style='width:5%'></th>");
                            break;

                        case "UnitPrice":
                            sb.Append("<th class='tAr' style='width:10%'>Unit Price</th>");
                            break;
                        case "Discount":
                            sb.Append("<th class='tAr' style='width:10%'>Discount(%)</th>");
                            break;
                        case "DiscPrice":
                            sb.Append("<th class='tAr' style='width:10%'>Disc Price</th>");
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th class='tAr' style='width:10%'>Ext Price</th>");
                            break;
                        default:
                            break;
                    }
                }
                //</CODE_TAG_101986> 
                sb.Append("</tr>");
                //Items
                foreach (Labor l in allLabor)
                {
                    sb.Append("<tr>");

 

                    /*sb.Append("<td>" + l.ItemNo + "</td>");
                    sb.Append("<td>" + l.Description + "</td>");
                    sb.Append("<td class='tAr'>" + l.Quantity + "</td>");
                    sb.Append("<td class='tAr'></td>");
                    sb.Append("<td class='tAr'></td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "</td>");*/

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                sb.Append("<td>" + l.ItemNo + "</td>");
                                break;
                            case "Description":
                                sb.Append("<td>" + l.Description + "</td>");
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAr'>" + l.Quantity + "</td>");
                                sb.Append("<td class='tAr'></td>");
                                sb.Append("<td class='tAr'></td>");
                                break;

                            case "UnitPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "Discount":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "</td>");
                                break;
                            case "DiscPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "</td>");
                                break;
                            default:
                                break;
                        }
                    }
                    //</CODE_TAG_101986>

                    sb.Append("</tr>");

                    totalExtPrice += l.ExtendedPrice;
                }

            }

            //line 1
            sb.Append("<tr>");
            sb.Append("<td class='tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' colspan='8'>" + ((flatRateInd == "N") ? "LABOR TOTAL:" : "CALCULATED TOTAL:") + "</td>");
            sb.Append("<td class='tAr tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' >" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "</td>");
            sb.Append("</tr>");

            if (flatRateInd != "N")
            {
                //line 2
                sb.Append("<tr>");
                string flatRateDesc = "";
                if (flatRateInd == "E") flatRateDesc = "ESTIMATE";
                if (flatRateInd == "F") flatRateDesc = "FLAT RATE";
                //sb.Append("<td class=' tSb  highLight' colspan='3'>LABOR TOTAL: &nbsp;&nbsp;&nbsp;&nbsp;  " + flatRateDesc + " </td>");
                sb.Append("<td class=' tSb  highLight' colspan='2'>LABOR TOTAL: &nbsp;&nbsp;&nbsp;&nbsp;  " + flatRateDesc + " </td>");//<CODE_TAG_103464>
                sb.Append("<td class=' tAr  highLight'>" + flatRateQtyInput + "</td>");//<CODE_TAG_103464>
                sb.Append("<td class='tAr tSb  highLight' colspan='2'>Variance:</td>");
                sb.Append("<td class='tAr tSb  highLight' >" +
                          Util.NumberFormat(flatRateAmount - totalExtPrice, 2, null, null, null, true) + "</td>");

                sb.Append("<td class='tAr tSb  highLight' colspan='2' ></td>");
                sb.Append("<td class='tAr tSb  highLight' >" + Util.NumberFormat(flatRateAmount, 2, null, null, null, true) +
                          ((flatRateInd == "Y") ? "F" : "") + "</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");
            return sb.ToString();
        }

        public static string GetEditHtml(List<Labor> allLabor, string flatRateInd, double flatRateAmountInput, double flatRateQtyInput, bool autoCalculate)
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }
            StringBuilder sb = new StringBuilder();
            double totalExtPrice = 0;
            double totalQty = 0;
            double totalLaborAmount = 0;
            //<CODE_TAG_103590>
            string laborDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Labor.Discount.Heading"].ToString();
            //</CODE_TAG_103590>
            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(2); //<CODE_TAG_101986>
            sb.Append("<table>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode"))
            {
                //Header
                sb.Append("<tr>");
                sb.Append("<th class='tAc' style='width:2%'></th>");
 
                /*sb.Append("<th class='tAc' style='width:30%'>Charge Code (LCC-LC-ST-CC)</th>");
                sb.Append("<th class='tAc' style='width:8%'>Qty</th>");
                sb.Append("<th class='tAc' style='width:10%'>Rate Type</th>");
                sb.Append("<th class='tAc' style='width:10%'>Unit Price</th>");
                sb.Append("<th class='tAc' style='width:10%'>Sell Price</th>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                    sb.Append("<th class='tAc' style='width:10%'>Discount</th>");
                sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");*/

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "ChargeCode":
                            //sb.Append("<th class='tAc' style='width:30%'>Charge Code (LCC-LC-ST-CC)</th>");
                            
                            //<CODE_TAG_102111>
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                sb.Append("<th class='tAc' style='width:16%'>Charge Code<br/> (LCC-LC-ST-CC)</th>");
                            else
                                sb.Append("<th class='tAc' style='width:30%'>Charge Code (LCC-LC-ST-CC)</th>");
                            //</CODE_TAG_102111>
                            break;
                        case "Description":
                            //<CODE_TAG_102111>
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                sb.Append("<th class='tAc' style='width:14%'>Description</th>");
                            else
                            { 
                                //do nothing (no description collumn display)
                            }
                            //</CODE_TAG_102111>
                            break;
                        case "Quantity":
                            sb.Append("<th class='tAc' style='width:8%'>Qty</th>");
                            break;
                        case "RateType":
                            sb.Append("<th class='tAc' style='width:10%'>Rate Type</th>");
                            break;
                        case "UnitPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Unit Price</th>");
                            break;
                        case "SellPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Sell Price</th>");
                            break;

                        case "Discount":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                            //sb.Append("<th class='tAc' style='width:10%'>Discount</th>");
                            {//<CODE_TAG_103590>
                                if (!string.IsNullOrEmpty(laborDiscountHeading))
                                { sb.Append("<th class='tAc' style='width:10%'>" + laborDiscountHeading + "(%)</th>"); }
                                else
                                { sb.Append("<th class='tAc' style='width:10%'>Discount</th>"); }
                                
                            }//<CODE_TAG_103590>
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");
                            break;
                        default:
                            break;
                    }
                }
                //</CODE_TAG_101986>

                sb.Append("<th style='width:10%'><input type='Hidden' id='hdnLaborCount' name='hdnLaborCount'  value='" + allLabor.Count + "'  /><input type='Hidden' id='hdnXMLLabor' name='hdnXMLLabor'  value=''  /></th>");

                sb.Append("</tr>");
                //Items
                int itemId = 0;
                foreach (Labor l in allLabor)
                {
                    itemId++;
                    sb.Append("<tr>");
                    if (l.IsLocked)
                        sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                    else
                        sb.Append("<td></td>");
                     
                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.ItemNo + ((l.ItemNo.IsNullOrEmpty()) ? "" : "-") + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");// comment out for <CODE_TAG_101832>
                    /*//<CODE_TAG_101832>
                    sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                    //</CODE_TAG_101832>
                    sb.Append("<input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' readonly='readonly' value='" + l.Description + "' style='display:none' /></td>");
                    sb.Append("<td class='tAr'><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td class='tAc'><select id='lstLaborShift" + itemId + "' name='lstLaborShift" + itemId + "' onchange='setupLaborChargeCode(" + itemId + ");' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  > <option value='CRTR' " + ((l.Shift == "CRTR") ? "selected='selected'" : "") + " >Regular</option> <option value='COTR' " + ((l.Shift == "COTR") ? "selected='selected'" : "") + ">Overtime</option> <option value='CPTR' " + ((l.Shift == "CPTR") ? "selected='selected'" : "") + ">Premium</option>    </select>  </td>");
                    sb.Append("<td><input type='text' id='txtLaborUnitSellPrice" + itemId + "' name='txtLaborUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                        sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");*/


                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                //<CODE_TAG_101832>
                                //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                                //</CODE_TAG_101832>
                                //<CODE_TAG_102111>
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                {
                                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode,null,null,'Y');\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> "); //<CODE_TAG_105100>
                                    sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode, null,null,'Y');\" class='w90p' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode,null,null,'Y');\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> "); //<CODE_TAG_105100> lwang
                                }
                                else
                                {
                                    //<CODE_TAG_101832>
                                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode,null,null,'Y');\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> "); //<CODE_TAG_105100>
                                    sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode, null, null, 'Y');\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode,null,null,'Y');\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> "); //<CODE_TAG_105100> lwang
                                    //</CODE_TAG_101832>
                                }
                                //</CODE_TAG_102111>
                                break;
                            case "Description":
                                //<CODE_TAG_102111>
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                {
                                    sb.Append("<td>&nbsp;&nbsp;<input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p'  value='" + l.Description + "'  /></td>");
                                }
                                else
                                {
                                    sb.Append("<input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' readonly='readonly' value='" + l.Description + "' style='display:none' /></td>");
                                }
                                //<CODE_TAG_102111>
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAr'><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                break;
                            case "RateType":
                                sb.Append("<td class='tAc'><select id='lstLaborShift" + itemId + "' name='lstLaborShift" + itemId + "' onchange='setupLaborChargeCode(" + itemId + ");' " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  > <option value='CRTR' " + ((l.Shift == "CRTR") ? "selected='selected'" : "") + " >Regular</option> <option value='COTR' " + ((l.Shift == "COTR") ? "selected='selected'" : "") + ">Overtime</option> <option value='CPTR' " + ((l.Shift == "CPTR") ? "selected='selected'" : "") + ">Premium</option>    </select>  </td>");
                                break;

                            case "UnitPrice":
                                sb.Append("<td><input type='text' id='txtLaborUnitSellPrice" + itemId + "' name='txtLaborUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                break;
                            case "SellPrice":
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor','UnitPrice');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");//<CODE_TAG_102284>
                                break;
                            case "Discount":
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                                    sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                break;
                            default:
                                break;
                        }
                    }
                    //</CODE_TAG_101986>

                    sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Labor');\" " + ((l.IsLocked) ? "style='display:none'" : "") + " />");
                    sb.Append("<input type='hidden' id='hdnLaborLock" + itemId + "' name='hdnLaborLock" + itemId + "' value='" + l.Lock + "'  /> </td>");
                    sb.Append("</tr>");
                    totalExtPrice += l.ExtendedPrice;
                    totalQty += l.Quantity; 
                }
            }
            else
            {

                //Header
                sb.Append("<tr>");

                sb.Append("<th class='tAc' style='width:2%'></th>");


                /*sb.Append("<th class='tAc' style='width:10%'>Item No</th>");
                sb.Append("<th class='tAc' style='width:40%'>Description</th>");
                sb.Append("<th class='tAc' style='width:5%'>Qty</th>");
                sb.Append("<th class='tAc' style='width:8%'>Unit Price</th>");
                sb.Append("<th class='tAc' style='width:5%'>Discount(%)</th>");
                sb.Append("<th class='tAc' style='width:10%'>Disc Price</th>");
                sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");
                */

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                {
                    switch (dr["ColumnName"].ToString())
                    {

                        case "ChargeCode":
                            sb.Append("<th class='tAc' style='width:10%'>Item No</th>");
                            break;
                        case "Description":
                            sb.Append("<th class='tAc' style='width:40%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th class='tAc' style='width:5%'>Qty</th>");
                            break;
 
                        case "UnitPrice":
                            sb.Append("<th class='tAc' style='width:8%'>Unit Price</th>");
                            break;
 
                        case "Discount":
                            //sb.Append("<th class='tAc' style='width:5%'>Discount(%)</th>");
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                            {//<CODE_TAG_103590>
                                if (!string.IsNullOrEmpty(laborDiscountHeading))
                                { sb.Append("<th class='tAc' style='width:5%'>" + laborDiscountHeading + "(%)</th>"); }
                                else
                                { sb.Append("<th class='tAc' style='width:5%'>Discount</th>"); }
                                
                            }//<CODE_TAG_103590>
                            break;
                        case "DiscPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Disc Price</th>");
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");
                            break;
                        default:
                            break;
                    }
                }
                //</CODE_TAG_101986>

                sb.Append("<th style='width:10%'><input type='Hidden' id='hdnLaborCount' name='hdnLaborCount'  value='" + allLabor.Count + "'  /></th>");
                sb.Append("</tr>");
                //Items
                int itemId = 0;
                foreach (Labor l in allLabor)
                {
                    itemId++;
                    sb.Append("<tr>");
                    if (l.IsLocked)
                        sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                    else
                        sb.Append("<td></td>");



                    /*sb.Append("<td><input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtLaborDiscPrice" + itemId + "' name='txtLaborDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    */

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {

                            case "ChargeCode":
                                sb.Append("<td><input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                break;
                            case "Description":
                                sb.Append("<td><input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                break;
                            case "Quantity":
                                sb.Append("<td><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                break;

                            case "UnitPrice":
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor','UnitPrice');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>"); //<CODE_TAG_102284>
                                break;

                            case "Discount":
                                sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                break;
                            case "DiscPrice":
                                sb.Append("<td><input type='text' id='txtLaborDiscPrice" + itemId + "' name='txtLaborDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                break;
                            default:
                                break;
                        }
                    }
                    //</CODE_TAG_101986>

                    sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Labor');\" " + ((l.IsLocked) ? "style='display:none'" : "") + " /> ");
                    sb.Append("<input type='hidden' id='hdnLaborLock" + itemId + "' name='hdnLaborLock" + itemId + "' value='" + l.Lock + "'  /> </td>");
                    sb.Append("</tr>");
                    totalExtPrice += l.ExtendedPrice;
                    totalQty += l.Quantity; 
                }
            }

            //line 1 
            if (autoCalculate)
            {
                flatRateAmountInput = totalExtPrice;
                flatRateQtyInput = totalQty;
            }
            if (flatRateInd == "N")
            {
                //line 1
                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td " + ( (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode")) ?"" : "colspan='2'" )    +  "  class='tSb highLight' >LABOR TOTAL  &nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<select id='lstLaborFlatRate' name='lstLaborFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Labor\");' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >Flat Rate</option>");
                sb.Append("</select>");
                sb.Append("</td>");
                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalQty, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                    sb.Append("<td class='highLight'></td>");
				sb.Append("<td class='highLight'></td>");	
                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='highLight'><img src='../../Library/Images/plus_icon.png'  onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\",\"Labor\"); ' />  <input type='hidden' id='hdnTotalLabor' name='hdnTotalLabor' value='" + flatRateAmountInput + "' /></td>");


                sb.Append("</tr>");
            }
            else
            {
                //line 1
                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td " + ((AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode")) ? "colspan='2'" : "colspan='3'") + "  class='tSb'>CALCULATED TOTAL</td>");
                sb.Append("<td class='tAr'>" + totalQty + "&nbsp;</td>");
                //sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                {
                    //sb.Append("<td colspan=''></td>");
                    //<CODE_TAG_102111>
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                        sb.Append("<td colspan='2'></td>");
                    else
                        sb.Append("<td colspan=''></td>");
                    //</CODE_TAG_102111>
                }
                sb.Append("<td class='tAr'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td><img src='../../Library/Images/plus_icon.png'  onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\",\"Labor\"); ' /> <input type='hidden' id='hdnTotalLabor' name='hdnTotalLabor' value='" + flatRateAmountInput + "' /> </td>");
                sb.Append("</tr>");

                //line 2


                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td " + ((AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode")) ? "" : "colspan='2'") + "  class='tSb highLight'>LABOR TOTAL &nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<select id='lstLaborFlatRate' name='lstLaborFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Labor\");' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >Flat Rate</option>");
                sb.Append("</select>");
                sb.Append("</td>");

                sb.Append("<td class='highLight'></td>");
                //sb.Append("<td class='tAr highLight'><input type='text' id='txtLaborFlatRateQty' name='txtLaborFlatRateQty'  value='" + flatRateQtyInput + "'  class='tAr w90p'  / ></td>");
                //sb.Append("<td class='tAr highLight'><input type='text' id='txtLaborFlatRateQty' name='txtLaborFlatRateQty'  value='" + flatRateQtyInput + "'  class='tAr w90p'  numberCheck='true' / ></td>");//<CODE_TAG_104932>
                //<CODE_TAG_105018>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.laborFlatRateQty.Hide"))
                {
                    sb.Append("<td class='tAr highLight'><input type='text' id='txtLaborFlatRateQty' name='txtLaborFlatRateQty'  value='" + flatRateQtyInput + "'  class='tAr w90p'  numberCheck='true' style='display:none' / ></td>");//<CODE_TAG_104932>
                }
                else
                {
                    sb.Append("<td class='tAr highLight'><input type='text' id='txtLaborFlatRateQty' name='txtLaborFlatRateQty'  value='" + flatRateQtyInput + "'  class='tAr w90p'  numberCheck='true' / ></td>");//<CODE_TAG_104932>
                }
                //</CODE_TAG_105018>
                sb.Append("<td class='tAr highLight' colspan=''></td>");
                sb.Append("<td class='tAr highLight' colspan=''></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))
                {
                    //sb.Append("<td class='tAr highLight' colspan=''></td>");
                    //<CODE_TAG_102111>
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                        sb.Append("<td class='tAr highLight' colspan=''></td>");
                    else
                        sb.Append("<td class='tAr highLight' colspan=''></td>");
                    //</CODE_TAG_102111>
                }
                sb.Append("<td class='highLight'>Variance:" + Util.NumberFormat(flatRateAmountInput - totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");

                sb.Append("<td class='tAr highLight'><input type='text' id='txtLaborFlatRateAmount' name='txtLaborFlatRateAmount'  value='" + Util.NumberFormat(flatRateAmountInput, 2, null, null, null, true) + "'  class='tAr w90p' onkeypress='lockLaborTotal();' onblur='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Labor\");' / ></td>");
                sb.Append("<td class='highLight'><input type='checkbox' ID='chkLaborAutoCalculate' name='chkLaborAutoCalculate' " + ((!autoCalculate) ? "checked='checked'" : "") + "    onclick='  detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Labor\"); ' />Lock Total</td>");

                sb.Append("</tr>");

            }

            sb.Append("</table>");




            return sb.ToString();
        }
        public static double GetExtPriceTotal(List<Labor> allLabor)
        {
            double rt = 0;
            foreach (Labor  l in allLabor)
            {
                rt += l.ExtendedPrice;
            }
            return rt;
        }
    }
}

