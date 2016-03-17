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
    public class Misc
    {
       public int ItemId { get; set; }
        public double Quantity { get; set; }
        public string ItemNo { get; set; }
        public string Description { get; set; }
        public double UnitSellPrice { get; set; }
        public double UnitCostPrice { get; set; }
        public double UnitPercentRate { get; set; }
        public double UnitPrice { get; set; }
        public double Discount { get; set; }
        //<CODE_TAG_101694>
        public double UnitDiscPrice { get { return Math.Round(UnitPrice * (1 - Discount / 100), 2); } }
        public double DiscountAmount { get { return UnitPrice * Quantity - ExtendedPrice ; } }
        //public double ExtendedPrice { get { return Quantity * UnitPrice * (1 - Discount / 100); } }
        public double ExtendedPrice { get { return Quantity * UnitDiscPrice; } }
        //</CODE_TAG_101694>
        public IdentityInfo  EnterUser { get; set; }
        public DateTime  EnterDate { get; set; }
        public IdentityInfo  ChangeUser { get; set; }
        public DateTime  ChangeDate { get; set; }
        public int SortOrder { get; set; }
        public int Lock { get; set; }
        public int UnitPriceLock { get; set; }
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
        public bool IsUnitPriceLocked
        {
            get
            {
                if (UnitPriceLock == 2)
                    return true;
                else
                    return false;
            }
        }

        public Misc()
        {
            Quantity = 1;//<CODE_TAG_102266>
        }

      public Misc( DataRow dr)
        {
            ItemId = dr["ItemId"].AsInt();
            ItemNo = dr["ItemNo"].ToString();
            Quantity = dr["Quantity"].AsDouble();
            Description = dr["Description"].ToString();
            UnitSellPrice = dr["UnitSellPrice"].AsDouble();
            UnitCostPrice = dr["UnitCostPrice"].AsDouble();
            UnitPercentRate = dr["UnitPercentRate"].AsDouble();
            UnitPrice = dr["UnitPrice"].AsDouble();
            Discount = dr["Discount"].AsDouble();
            Lock = dr["Lock"].AsInt(1);
            UnitPriceLock = dr["UnitPriceLock"].AsInt(1);
            SortOrder = dr["SortOrder"].AsInt();
        }
    }


    public class MiscUtil
    {
        public static string GetReadonlyHtml(List<Misc> allMisc, string flatRateInd, double flatRateAmount)
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }
            StringBuilder sb = new StringBuilder();
            double totalExtPrice = 0;
            //<CODE_TAG_103590>
            string miscDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Misc.Discount.Heading"].ToString();
            //</CODE_TAG_103590>
            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(3); //<CODE_TAG_101986>
            sb.Append("<table><tr>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
            {
                //Header
                sb.Append("<tr>");


                /*sb.Append("<th style='width:20%'>Charge Code <br/> (MCC-MC-ST-CC)</th>");
                sb.Append("<th style='width:30%'>Description</th>");
                sb.Append("<th style='width:5%' class='tAr'>Qty</th>");
                sb.Append("<th style='width:9%' class='tAr'>Unit Cost</th>");
                sb.Append("<th style='width:5%' class='tAr'>Markup %</th>");
                sb.Append("<th style='width:9%' class='tAr'>Unit Sell</th>");
                sb.Append("<th style='width:10%' class='tAr'>Unit Price</th>");
                sb.Append("<th style='width:2%' class='tAc'><img src='../../Library/images/lock.png' /></th>");
                sb.Append("<th style='width:10%' class='tAr'>Ext Price</th>");
                */


                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "ChargeCode":
                            sb.Append("<th style='width:20%'>Charge Code <br/> (MCC-MC-ST-CC)</th>");
                            break;
                        case "Description":
                            sb.Append("<th style='width:30%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th style='width:5%' class='tAr'>Qty</th>");
                            break;
                        case "UnitCost":
                            sb.Append("<th style='width:9%' class='tAr'>Unit Cost</th>");
                            break;
                        case "Markup":
                            //sb.Append("<th style='width:5%' class='tAr'>Markup %</th>");
                            //<CODE_TAG_103590>
                            if (!string.IsNullOrEmpty(miscDiscountHeading))
                                sb.Append("<th style='width:5%' class='tAr'>" + miscDiscountHeading + "(%)</th>");
                            else
                                sb.Append("<th style='width:5%' class='tAr'>Markup %</th>");
                            //</CODE_TAG_103590>
                            break;
                        case "UnitSell":
                            sb.Append("<th style='width:9%' class='tAr'>Unit Sell</th>");
                            break;
                        case "UnitPrice":
                            sb.Append("<th style='width:10%' class='tAr'>Unit Price</th>");
                            break;
                        case "Lock":
                            sb.Append("<th style='width:2%' class='tAc'><img src='../../Library/images/lock.png' /></th>");
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th style='width:10%' class='tAr'>Ext Price</th>");
                            break;
                        default:
                            break;

                    }
                }
                //</CODE_TAG_101986>
                sb.Append("</tr>");
                //Items
                foreach (Misc m in allMisc)
                {
                    sb.Append("<tr>");



                    /*sb.Append("<td>" + m.ItemNo + "</td>");
                    sb.Append("<td>" + m.Description + "</td>");
                    sb.Append("<td class='tAr'>" + m.Quantity + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitCostPrice, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPercentRate * 100, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitSellPrice, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "</td>");
                    sb.Append("<td class='tAc'>" + ((m.IsUnitPriceLocked) ? "<img src='../../Library/images/check.gif' />" : "") + "</td>");
                    sb.Append("<td class='tAr'>" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "</td>");*/

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                sb.Append("<td>" + m.ItemNo + "</td>");
                                break;
                            case "Description":
                                sb.Append("<td>" + m.Description + "</td>");
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAr'>" + m.Quantity + "</td>");
                                break;
                            case "UnitCost":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitCostPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "Markup":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPercentRate * 100, 2, null, null, null, null) + "</td>");
                                break;
                            case "UnitSell":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitSellPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "UnitPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "Lock":
                                sb.Append("<td class='tAc'>" + ((m.IsUnitPriceLocked) ? "<img src='../../Library/images/check.gif' />" : "") + "</td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "</td>");
                                break;
                            default:
                                break;

                        }
                    }
                    //</CODE_TAG_101986>
                    sb.Append("</tr>");
                    totalExtPrice += m.ExtendedPrice;
                }

            }
            else
            {
                //Header
                sb.Append("<tr>");

                /*sb.Append("<th style='width:10%'>Item No</th>");
                sb.Append("<th style='width:40%'>Description</th>");
                sb.Append("<th class='tAr' style='width:5%'>Qty</th>");
                sb.Append("<th style='width:5%'></th>");
                sb.Append("<th style='width:5%'></th>");
                sb.Append("<th class='tAr' style='width:10%'>Unit Price</th>");
                sb.Append("<th class='tAr' style='width:10%'>Discount(%)</th>");
                sb.Append("<th class='tAr' style='width:10%'>Disc Price</th>");
                sb.Append("<th class='tAr' style='width:10%'>Ext Price</th>");*/

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
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
                            sb.Append("<th style='width:5%'></th>");
                            sb.Append("<th style='width:5%'></th>");
                            break;
                        case "UnitPrice":
                            sb.Append("<th style='width:10%' class='tAr'>Unit Price</th>");
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
                foreach (Misc m in allMisc)
                {
                    sb.Append("<tr>");
                    /*sb.Append("<td>" + m.ItemNo + "</td>");
                     sb.Append("<td>" + m.Description + "</td>");
                     sb.Append("<td class='tAr'>" + m.Quantity + "</td>");
                     sb.Append("<td></td>");
                     sb.Append("<td></td>");
                     sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "</td>");
                     sb.Append("<td class='tAr'>" + Util.NumberFormat(m.Discount, 2, null, null, null, null) + "</td>");
                     sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                     sb.Append("<td class='tAr'>" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "</td>");*/

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                sb.Append("<td>" + m.ItemNo + "</td>");
                                break;
                            case "Description":
                                sb.Append("<td>" + m.Description + "</td>");
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAr'>" + m.Quantity + "</td>");
                                sb.Append("<td></td>");
                                sb.Append("<td></td>");
                                break;
                            case "UnitPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "Discount":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.Discount, 2, null, null, null, null) + "</td>");
                                break;
                            case "DiscPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "</td>");
                                break;
                            default:
                                break;

                        }
                    }
                    //</CODE_TAG_101986>
                    sb.Append("</tr>");
                    totalExtPrice += m.ExtendedPrice;
                }
            }

            //line 1
            sb.Append("<tr>");
            sb.Append("<td class='tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' colspan='8'>" + ((flatRateInd == "N") ? "MISC TOTAL:" : "CALCULATED TOTAL:") + "</td>");
            sb.Append("<td class='tAr tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' >" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "</td>");
            sb.Append("</tr>");

            if (flatRateInd != "N")
            {
                //line 2
                sb.Append("<tr>");
                string flatRateDesc = "";
                if (flatRateInd == "E") flatRateDesc = "ESTIMATE";
                if (flatRateInd == "F") flatRateDesc = "FLAT RATE";
                sb.Append("<td class=' tSb  highLight' colspan='3'>MISC TOTAL: &nbsp;&nbsp;&nbsp;&nbsp;  " + flatRateDesc + " </td>");


                sb.Append("<td class='tAr tSb highLight' colspan='2'>Variance:</td>");
                sb.Append("<td class='tAr tSb highLight' >" +
                          Util.NumberFormat(flatRateAmount - totalExtPrice, 2, null, null, null, true) + "</td>");
                sb.Append("<td class='tAr tSb highLight'  colspan='2'></td>");
                sb.Append("<td class='tAr tSb highLight'  >" + Util.NumberFormat(flatRateAmount, 2, null, null, null, true) +
                          ((flatRateInd == "Y") ? "F" : "") + "</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");

            return sb.ToString();
        }

        public static string GetEditHtml(List<Misc> allMisc, string flatRateInd, double flatRateAmountInput, bool autoCalculate)
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }
            StringBuilder sb = new StringBuilder();
            double totalExtPrice = 0;
            double totalQty = 0;
            double totalMiscAmount = 0;
            //<CODE_TAG_103590>
            string miscDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Misc.Discount.Heading"].ToString();
            //</CODE_TAG_103590>
            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(3); //<CODE_TAG_101986>

            sb.Append("<table>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
            {
                //Header
                sb.Append("<tr>");



                sb.Append("<th class='tAc' style='width:2%'></th>");



                /*sb.Append("<th class='tAc' style='width:14%'>Charge Code <br/>(MCC-MC-ST-CC)</th>");
                sb.Append("<th class='tAc' style='width:30%'>Description</th>");
                sb.Append("<th class='tAc' style='width:5%'>Qty</th>");
                sb.Append("<th class='tAc' style='width:8%'>Unit Cost</th>");
                sb.Append("<th class='tAc' style='width:5%'>Markup%</th>");
                sb.Append("<th class='tAc' style='width:8%'>Unit Price</th>");
                sb.Append("<th class='tAc' style='width:8%'>Sell Price</th>");
                sb.Append("<th class='tAc' style='width:2%'><img src='../../Library/images/lock.png' /></th>");
                sb.Append("<th class='tAc' style='width:8%'>Ext Price</th>");*/

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "ChargeCode":
                            sb.Append("<th class='tAc' style='width:14%'>Charge Code <br/>(MCC-MC-ST-CC)</th>");
                            break;
                        case "Description":
                            sb.Append("<th class='tAc' style='width:30%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th class='tAc' style='width:5%'>Qty</th>");
                            break;
                        case "UnitCost":
                            sb.Append("<th class='tAc' style='width:8%'>Unit Cost</th>");
                            break;
                        case "Markup":
                            //sb.Append("<th class='tAc' style='width:5%'>Markup%</th>");
                            //<CODE_TAG_103590>
                            if (!string.IsNullOrEmpty(miscDiscountHeading))
                                sb.Append("<th class='tAc' style='width:5%'>" + miscDiscountHeading + "(%)</th>");
                            else
                                sb.Append("<th class='tAc' style='width:5%'>Markup%</th>");
                            //</CODE_TAG_103590>
                            break;
                        case "UnitPrice":
                            sb.Append("<th class='tAc' style='width:8%'>Unit Price</th>");
                            break;
                        case "UnitSell":
                            sb.Append("<th class='tAc' style='width:8%'>Sell Price</th>");
                            break;
                        case "Lock":
                            sb.Append("<th class='tAc' style='width:2%'><img src='../../Library/images/lock.png' /></th>");
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th class='tAc' style='width:8%'>Ext Price</th>");
                            break;
                        default:
                            break;

                    }
                }
                //</CODE_TAG_101986>

                sb.Append("<th style='width:10%'><input type='Hidden' id='hdnMiscCount' name='hdnMiscCount'  value='" + allMisc.Count + "'  /> <input type='Hidden' id='hdnXMLMisc' name='hdnXMLMisc'  value=''  /></th>");
                sb.Append("</tr>");
                //Items
                int itemId = 0;
                
                foreach (Misc m in allMisc)
                {
                    itemId++;
                    sb.Append("<tr>");
                    if (m.IsLocked)
                        sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                    else
                        sb.Append("<td></td>");
                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode);\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "")  + "' " + ((m.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>");
                    /*//<CODE_TAG_101832>
                    sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + itemId + "' name='hidMiscItemIdFromDb" + itemId + "' Value='" + m.ItemId + "' /><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode);\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "") + "' " + ((m.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>");
                    //</CODE_TAG_101832>
                    sb.Append("<td>&nbsp;&nbsp;<input type='text' id='txtMiscDescription" + itemId + "' name='txtMiscDescription" + itemId + "' class='w90p' style='display:' value='" + m.Description + "' /></td>");
                    sb.Append("<td class='tAc'><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscUnitCostPrice" + itemId + "' name='txtMiscUnitCostPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitCostPrice, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                    sb.Append("<td><input type='text' id='txtMiscUnitPercentRate" + itemId + "' name='txtMiscUnitPercentRate" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPercentRate * 100, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                    sb.Append("<td><input type='text' id='txtMiscUnitSellPrice" + itemId + "' name='txtMiscUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly'  /></td>");
                    sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "'  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td class='tAc'><input type='checkbox' ID='chkUnitPriceLock" + itemId + "' name='chkUnitPriceLock" + itemId + "' " + ((m.IsUnitPriceLocked) ? "checked='checked'" : "") + " /> </td>");
                    sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    */

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":
                                //<CODE_TAG_101832>
                                //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + itemId + "' name='hidMiscItemIdFromDb" + itemId + "' Value='" + m.ItemId + "' /><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode);\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "") + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>");
                                //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + itemId + "' name='hidMiscItemIdFromDb" + itemId + "' Value='" + m.ItemId + "' /><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode);\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "") + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode, null,null,'Y' ); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>"); //<CODE_TAG_105100>
                                sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + itemId + "' name='hidMiscItemIdFromDb" + itemId + "' Value='" + m.ItemId + "' /><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode,null, null, 'Y');\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "") + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode, null,null,'Y' ); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>"); //<CODE_TAG_105100> lwang
                                //</CODE_TAG_101832>
                                break;
                            case "Description":
                                sb.Append("<td>&nbsp;&nbsp;<input type='text' id='txtMiscDescription" + itemId + "' name='txtMiscDescription" + itemId + "' class='w90p' style='display:' value='" + m.Description + "' /></td>");
                                break;
                            case "Quantity":
                                sb.Append("<td class='tAc'><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                break;
                            case "UnitCost":
                                sb.Append("<td><input type='text' id='txtMiscUnitCostPrice" + itemId + "' name='txtMiscUnitCostPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitCostPrice, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                                break;
                            case "Markup":
                                sb.Append("<td><input type='text' id='txtMiscUnitPercentRate" + itemId + "' name='txtMiscUnitPercentRate" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPercentRate * 100, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                                break;
                            case "UnitPrice":
                                sb.Append("<td><input type='text' id='txtMiscUnitSellPrice" + itemId + "' name='txtMiscUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1'  /></td>");
                                break;
                            case "UnitSell":
                                //sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "'  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "'  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc','UnitPrice');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>"); //<CODE_TAG_102284>
                                break;
                            case "Lock":
                                sb.Append("<td class='tAc'><input type='checkbox' ID='chkUnitPriceLock" + itemId + "' name='chkUnitPriceLock" + itemId + "' " + ((m.IsUnitPriceLocked) ? "checked='checked'" : "") + " /> </td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                break;
                            default:
                                break;

                        }
                    }
                    //</CODE_TAG_101986>
                    sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Misc');\" " + ((m.IsLocked) ? "style='display:none'" : "") + " /> ");
                    sb.Append("<input type='hidden' id='hdnMiscLock" + itemId + "' name='hdnMiscLock" + itemId + "' value='" + m.Lock + "'  /> </td>");
                    sb.Append("</tr>");
                    totalExtPrice += m.ExtendedPrice;
                    totalQty += m.Quantity; 
                }
            }
            else
            {

                //Header
                sb.Append("<tr>");



                sb.Append("<th class='tAc' style='width:2%'></th>");
                /*sb.Append("<th class='tAc' style='width:10%'>Item No</th>");
                sb.Append("<th class='tAc' style='width:20%'>Description</th>");
                sb.Append("<th class='tAc' style='width:8%'>Qty</th>");
                sb.Append("<th class='tAc' style='width:10%'>Unit Price</th>");
                sb.Append("<th class='tAc' style='width:10%'>Discount(%)</th>");
                sb.Append("<th class='tAc' style='width:10%'>Disc Price</th>");
                sb.Append("<th class='tAc' style='width:20%'>Ext Price</th>");*/

                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        /*case "Lock":
                            sb.Append("<th class='tAc' style='width:2%'></th>");
                            break;*/

                        case "ChargeCode":
                            sb.Append("<th class='tAc' style='width:10%'>Item No</th>");
                            break;
                        case "Description":
                            sb.Append("<th class='tAc' style='width:20%'>Description</th>");
                            break;
                        case "Quantity":
                            sb.Append("<th class='tAc' style='width:8%'>Qty</th>");
                            break;

                        case "UnitPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Unit Price</th>");
                            break;
                        case "Discount":
                            sb.Append("<th class='tAc' style='width:10%'>Discount(%)</th>");
                            break;
                        case "DiscPrice":
                            sb.Append("<th class='tAc' style='width:10%'>Disc Price</th>");
                            break;
                        case "ExtendedPrice":
                            sb.Append("<th class='tAc' style='width:20%'>Ext Price</th>");
                            break;
                        default:
                            break;

                    }
                }
                //</CODE_TAG_101986>

                sb.Append("<th style='width:10%'><input type='Hidden' id='hdnMiscCount' name='hdnMiscCount'  value='" + allMisc.Count + "'  /></th>");
                sb.Append("</tr>");
                //Items
                int itemId = 0;
                foreach (Misc m in allMisc)
                {

                    itemId++;



                    sb.Append("<tr>");
                    if (m.IsLocked)
                        sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                    else
                        sb.Append("<td></td>");
                    /*sb.Append("<td><input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.ItemNo + "' onkeypress='detailDataChanged= true;' " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscDescription" + itemId + "' name='txtMiscDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.Description + "' " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscDiscount" + itemId + "' name='txtMiscDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtMiscDiscPrice" + itemId + "' name='txtMiscDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                    */

                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            /*case "Lock":
                                if (m.IsLocked)
                                    sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                                else
                                    sb.Append("<td></td>");
                                break;*/

                            case "ChargeCode":
                                sb.Append("<td><input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.ItemNo + "' onkeypress='detailDataChanged= true;' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1'" : "") + " /></td>");
                                break;
                            case "Description":
                                sb.Append("<td><input type='text' id='txtMiscDescription" + itemId + "' name='txtMiscDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.Description + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                break;
                            case "Quantity":
                                sb.Append("<td><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                break;

                            case "UnitPrice":
                                //sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc', 'UnitPrice');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>"); //<CODE_TAG_102284>
                                break;
                            case "Discount":
                                sb.Append("<td><input type='text' id='txtMiscDiscount" + itemId + "' name='txtMiscDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                break;
                            case "DiscPrice":
                                sb.Append("<td><input type='text' id='txtMiscDiscPrice" + itemId + "' name='txtMiscDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                break;
                            case "ExtendedPrice":
                                sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                break;
                            default:
                                break;

                        }
                    }
                    //</CODE_TAG_101986>

                    sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Misc');\" " + ((m.IsLocked) ? "style='display:none'" : "") + " /> ");
                    sb.Append("<input type='hidden' id='hdnMiscLock" + itemId + "' name='hdnMiscLock" + itemId + "' value='" + m.Lock + "'  /> </td>");
                    sb.Append("</tr>");
                    totalExtPrice += m.ExtendedPrice;
                    totalQty += m.Quantity; 
                }
            }

            //line 1 
            if (autoCalculate)
            {
                if (totalExtPrice != 0)   //<CODE_TAG_104217> pulling in misc eatimate amount
                    flatRateAmountInput = totalExtPrice;
            }
            if (flatRateInd == "N")
            {
                //line 1
                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td  class='tSb highLight' " + ((AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode")) ? "colspan='2'" : "colspan='2'") + " >MISC TOTAL &nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<select id='lstMiscFlatRate' name='lstMiscFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Misc\");' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >Flat Rate</option>");
                sb.Append("</select>");
                sb.Append("</td>");

                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalQty, 0, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='tAr highLight'></td>");
                sb.Append("<td class='tAr highLight'></td>");
                sb.Append("<td class='tAr highLight'></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
                {
                    sb.Append("<td class='tAr highLight'></td>");
                    sb.Append("<td class='tAr highLight'></td>");
                }
                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='highLight'><img src='../../Library/Images/plus_icon.png'  onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\",\"Misc\"); ' />  <input type='hidden' id='hdnTotalMisc' name='hdnTotalMisc' value='" + flatRateAmountInput + "' /></td>");


                sb.Append("</tr>");
            }
            else
            {
                //line 1
                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td class='tSb' " + ((AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode")) ? "colspan='2'" : "colspan='2'") + " >CALCULATED TOTAL</td>");
                sb.Append("<td class='tAr'>" + totalQty + "&nbsp;</td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
                {
                    sb.Append("<td colspan=''></td>");
                    sb.Append("<td colspan=''></td>");
                }
                sb.Append("<td class='tAr'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td><img src='../../Library/Images/plus_icon.png' onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\",\"Misc\"); ' /> <input type='hidden' id='hdnTotalMisc' name='hdnTotalMisc' value='" + flatRateAmountInput + "' /> </td>");
                sb.Append("</tr>");

                //line 2


                sb.Append("<tr>");
                sb.Append("<td></td>");
                sb.Append("<td class='tSb highLight' " + ((AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode")) ? "colspan='2'" : "colspan='2'") + " >MISC TOTAL  &nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<select id='lstMiscFlatRate' name='lstMiscFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Misc\");' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >Flat Rate</option>");
                sb.Append("</select>");
                sb.Append("</td>");

                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='tAr highLight'></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
                {
                    sb.Append("<td class='tAr highLight'></td>");
                    sb.Append("<td class='tAr highLight'></td>");
                }
                sb.Append("<td class='highLight'>Variance:" + Util.NumberFormat(flatRateAmountInput - totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='tAr highLight'><input type='text'  style='width:100px' id='txtMiscFlatRateAmount' name='txtMiscFlatRateAmount'  value='" + Util.NumberFormat(flatRateAmountInput, 2, null, null, null, true) + "'  class='tAr w90p' onkeypress='lockMiscTotal();' onblur='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Misc\");' / ></td>");   //<CODE_TAG_101914> 
                sb.Append("<td class='highLight'><input type='checkbox' ID='chkMiscAutoCalculate' name='chkMiscAutoCalculate' " + ((!autoCalculate) ? "checked='checked'" : "") + "    onclick='  detailDataChanged= true; SegmentDetailAjaxHandler(0,\"\",\"Misc\"); ' />Lock Total </td>");

                sb.Append("</tr>");

            }


            sb.Append("</table>");
            return sb.ToString();
        }
        public static double GetExtPriceTotal(List<Misc> allMisc)
        {
            double rt = 0;
            foreach (Misc m in allMisc)
            {
                rt += m.ExtendedPrice;
            }
            return rt;
        }
    }
}

