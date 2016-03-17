using AppContext = Canam.AppContext;
using System;
using System.Data;
using X.Extensions;
using System.Text;
using System.Collections.Generic;
using Helpers;
using DTO;
using CATPAI;
using System.Web;

namespace Entities
{
    public class BackOrder
    {
        public int BoQty;
        public string BoFacCode;
        public string BoFacName;
        public string BoFacType;
    }

    public class Part
    {
        public int ItemId { get; set; }
        public double Quantity { get; set; }
        public string SOS { get; set; }
        public string PartNo { get; set; }
        public string Description { get; set; }
        public double UnitDiscPrice { get; set; }
        public double UnitSellPrice { get; set; }
        public double NetSellPrice { get; set; }
        public double UnitPrice { get; set; }
        public double Discount { get; set; }
        public double? UnitWeight { get; set; }
        public int AvailableQty { get; set; }
        public bool AvailabilityMultiLocation
        {
            get
            {
                bool rt = false;
                if (QtyOnhand > 0)
                {
                    if (BackOrders != null)
                        rt = true;
                }
                else
                {
                    if (BackOrders != null && BackOrders.Count > 1)
                        rt = true;
                }
                return rt;
            }
        }
        public string AvailabilityLocation
        {
            get
            {
                string rt = "In Store";

                if (AvailabilityMultiLocation)
                    rt = "MULTI LOCATION";
                else
                {
                    if (QtyOnhand == 0 && BackOrders != null)
                    {
                        if (BackOrders[0].BoFacName.IsNullOrWhiteSpace())
                            rt = BackOrders[0].BoFacCode;
                        else
                            rt = BackOrders[0].BoFacName;
                     }

                    if (QtyOnhand == 0 && BackOrders == null)
                        rt = "";
                }
                return rt;
            }
        }
        public int QtyOnhand { get; set; }
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
        public List<BackOrder> BackOrders;

        public double DiscountPrice 
        { 
            get 
            {
                 if (IsDiscountMarkup)
                     return Math.Round(UnitPrice * (1 + Discount / 100), 2); //<CODE_TAG_101694>
                 else
                     return Math.Round(UnitPrice * (1 - Discount / 100), 2); //<CODE_TAG_101694>
                    

            } 
        }
        public bool IsDiscountMarkup
        {
            get { return (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup")); }
        }
        private double extendedPriceField;
        public double ExtendedPrice 
        { 
            get 
            {
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.CorePartExtPriceZero") && IsCorePart)
                {
                    return 0;
                }
                else
                {
                    return DiscountPrice * Quantity;    
                }
                
                //if (IsDiscountMarkup)
                //    return Quantity * UnitPrice * (1 + Discount / 100) ;    
                //else
                //    return Quantity * UnitPrice * (1 - Discount /100) ;    
            }
        }
        public int RepairOptionId { get; set; }
        public int UpdateStatus { get; set; }
        public int CoreItemId { get; set; }
        public int SortOrder { get; set; }
        public bool IsCorePart
        {
            get
            {
                if (CoreItemId == ItemId && CoreItemId != 0)
                    return true;
                else
                    return false;
            }
        }
        public bool HasCorePart
        {
            get
            {
                if (CoreItemId != ItemId && CoreItemId > 0)
                    return true;
                else
                    return false;
            }
        }

        public Part()
        {
            CoreItemId = 0;
            SOS = AppContext.Current.AppSettings["psQuoter.Quote.SOS.Default"].ToString();// <CODE_TAG_101758>
            Quantity = 1; //<CODE_TAG_101775>//<CODE_TAG_102266>
        }
        public Part(int itemId, DataRow dr)
        {
            int dbItemId, dbCoreItemId;

            ItemId = itemId;
            Quantity = dr["Quantity"].AsInt();
            QtyOnhand = dr["QtyOnhand"].AsInt(0);
            AvailableQty = dr["AvailableQty"].AsInt(0);
            UnitWeight = dr["UnitWeight"].AsDouble();
            SOS = dr["SOS"].ToString();
            PartNo = dr["PartNo"].ToString();
            Description = dr["Description"].ToString();
            UnitSellPrice = dr["UnitSellPrice"].AsDouble();
            UnitDiscPrice = dr["UnitDiscPrice"].AsDouble();
            NetSellPrice = dr["NetSellPrice"].AsDouble();
            UnitPrice = dr["UnitPrice"].AsDouble();
            Discount = dr["Discount"].AsDouble();
            //ExtendedPrice = dr["ExtendedPrice"].AsDouble();
            RepairOptionId = dr["RepairOptionId"].AsInt();
            Lock = dr["Lock"].AsInt();
            dbItemId = dr["ItemId"].AsInt();
            dbCoreItemId = dr["CoreItemId"].AsInt();
            if (dbCoreItemId > 0)
            {
                if (dbCoreItemId == dbItemId)
                    CoreItemId = itemId;        //core part
                else
                    CoreItemId = itemId + 1;    //main part
            }
            else
            {
                CoreItemId = 0;                 //Normal part
            }
            
            SortOrder = dr["SortOrder"].AsInt();
        }
        public Part(int itemId, JSONObject p)
        {
            ItemId = itemId;
            SOS = p.Dictionary["SOS"].String;
            PartNo = p.Dictionary["PARTNO"].String;
            Quantity = p.Dictionary["PARTQTY"].String.AsInt();
            AvailableQty = p.Dictionary["AvailableQty"].String.AsInt();
            QtyOnhand = p.Dictionary["QtyOnhand"].String.AsInt();
            UnitWeight = p.Dictionary["UnitWeight"].String.AsDouble();
            Description = p.Dictionary["DESC"].String;
            UnitSellPrice = p.Dictionary["UNITSELL"].String.AsDouble(0);
            UnitDiscPrice = p.Dictionary["UNITDISC"].String.AsDouble(0);
            NetSellPrice = p.Dictionary["NETSELL"].String.AsDouble(0);

            //UnitPrice = p.Dictionary["UNITSELL"].String.AsDouble(0);
            //UnitPrice = p.Dictionary["NETSELL"].String.AsDouble(0); //<Ticket 19000>
            //<CODE_TAG_102215> Victor20130920
            UnitPrice = p.Dictionary["UNITSELL"].String.AsDouble(0) - p.Dictionary["UNITDISC"].String.AsDouble(0); //<Ticket 19000>
            //</CODE_TAG_102215>
            
            //<CODE_TAG_104427> Dav
            //Discount = 0;
            Discount = p.Dictionary["DISCOUNT"].String.AsDouble(0);
            //</CODE_TAG_104427> Dav

            int BoCount = p.Dictionary["BoCount"].String.AsInt();
            for (int i = 0; i < BoCount; i++)
            {
                BackOrder bo = new BackOrder();
                bo.BoFacCode = p.Dictionary["BoFacCode" + i].String;
                bo.BoFacName = p.Dictionary["BoFacName" + i].String;
                bo.BoFacType = p.Dictionary["BoFacType" + i].String;
                bo.BoQty = p.Dictionary["BoQty" + i].String.AsInt();

                if (BackOrders == null)
                    BackOrders = new List<BackOrder>();
                BackOrders.Add(bo);
            }

        }
    }


    public class PartUtil
    {
        public static string GetReadonlyHtml(List<Part> allParts, string flatRateInd, double flatRateAmount)
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }
            StringBuilder sb = new StringBuilder();
            double totalExtPrice = 0;
            bool isMarkupDiscount = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup");
            //<CODE_TAG_103590>
            string partDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.Discount.Heading"].ToString();
            //</CODE_TAG_103590>

            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(1); //<CODE_TAG_101986>

            sb.Append("<table>");
            sb.Append("<tr>");
            sb.Append("<th  style='width:2%'></th>");
            /*sb.Append("<th  style='width:5%'>SOS</th>");
            sb.Append("<th  style='width:13%'>Part No</th>");
            sb.Append("<th  style='width:30%'>Description</th>");
            sb.Append("<th  style='width:5%'  class='tAr'>Qty</th>");
            sb.Append("<th  style='width:10%' class='tAr'>Quantity  <br/>Available</th>");
            sb.Append("<th  style='width:1%'  class='tAr'></th>");
            sb.Append("<th  style='width:10%'>Availability</th>");

            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) sb.Append("<th  style='width:5%'  class='tAr'>Unit Sell</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) sb.Append("<th  style='width:5%' class='tAr'>Unit Disc</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) sb.Append("<th  style='width:5%' class='tAr'>Net Sell</th>");
            sb.Append("<th  style='width:5%' class='tAr'>Unit Price</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:5%' class='tAr'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:10%' class='tAr'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");
            sb.Append("<th  style='width:15%' class='tAr'>Est Weight <br/> (LBS) &nbsp;&nbsp;&nbsp;&nbsp;</th>");
            sb.Append("<th  style='width:5%' class='tAr'>Ext Price</th>");*/

            //Header
            //<CODE_TAG_101986>
            foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Parts
            {
                switch (dr["ColumnName"].ToString())
                {
                    case "SOS":
                        sb.Append("<th  style='width:5%'>SOS</th>");
                        break;
                    case "PartNo":
                        sb.Append("<th  style='width:13%'>Part No</th>");
                        break;
                    case "Description":
                        sb.Append("<th  style='width:30%'>Description</th>");
                        break;
                    case "Quantity":
                        sb.Append("<th  style='width:5%'  class='tAr'>Qty</th>");
                        break;
                    case "QtyOnhand":
                        sb.Append("<th  style='width:10%' class='tAr'>Quantity  <br/>Available</th>");
                        break;
                    case "ItemId":
                        sb.Append("<th  style='width:1%'  class='tAr'></th>");
                        break;
                    case "Availability":
                        sb.Append("<th  style='width:10%'>Availability</th>");
                        break;
                    case "UnitSellPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) sb.Append("<th  style='width:5%'  class='tAr'>Unit Sell</th>");
                        break;
                    case "UnitDiscPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) sb.Append("<th  style='width:5%' class='tAr'>Unit Disc</th>");
                        break;
                    case "NetSellPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) sb.Append("<th  style='width:5%' class='tAr'>Net Sell</th>");
                        break;
                    case "UnitPrice":
                        sb.Append("<th  style='width:5%' class='tAr'>Unit Price</th>");
                        break;
                    case "Discount":
                        //if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:5%' class='tAr'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");
                        //<CODE_TAG_103590>
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                        {

                            if (!string.IsNullOrEmpty(partDiscountHeading))
                                sb.Append("<th  style='width:5%' class='tAr'>" + partDiscountHeading + "(%)</th>");
                            else
                                sb.Append("<th  style='width:5%' class='tAr'>" + ((isMarkupDiscount) ? "Markup(%).." : "Discount(%)") + "</th>");
                        }
                        //</CODE_TAG_103590>
                        break;
                    case "DiscountPrice":
                        //if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:10%' class='tAr'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");
                        //<CODE_TAG_103590>
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                        {
                            if (!string.IsNullOrEmpty(partDiscountHeading))
                                sb.Append("<th  style='width:10%' class='tAr'>" + partDiscountHeading + "</th>");
                            else
                                sb.Append("<th  style='width:10%' class='tAr'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");
                        }
                        //</CODE_TAG_103590>
                        break;
                    case "UnitWeight":
                        sb.Append("<th  style='width:15%' class='tAr'>Est Weight <br/> (LBS) &nbsp;&nbsp;&nbsp;&nbsp;</th>");
                        break;
                    case "ExtendedPrice":
                        sb.Append("<th  style='width:5%' class='tAr'>Ext Price</th>");
                        break;
                    default:
                        break;
                }
            }
            //</CODE_TAG_101986>
            sb.Append("</tr>");
           
            //Items
            foreach (Part p in allParts)
            {
                
                sb.Append("<tr " + ((p.ItemId % 2 == 0) ? "class='alterRow'" : "") + ">");
                if (p.IsCorePart)
                    sb.Append("<td>core</td>");
                else
                    sb.Append("<td></td>");

                /*sb.Append("<td>" + p.SOS  + "</td>");
                sb.Append("<td>" + p.PartNo + "</td>");
                //<CODE_TAG_101761>
                if (!AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"].IsNullOrEmpty()  &&  p.IsCorePart)
                {
                    sb.Append("<td>" + AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"]  + "</td>");
                }
                else
                {
                    sb.Append("<td>" + p.Description + "</td>");
                }
                //</CODE_TAG_101761>

                sb.Append("<td class='tAr'>" + p.Quantity + "</td>");
                sb.Append("<td class='tAr'>" + p.AvailableQty +"</td>");
                sb.Append("<td class='tAr'>");
                if (p.AvailabilityMultiLocation)
                    sb.Append("<span style='cursor:pointer' id='spanShowHideAvaility" + p.ItemId + "'  onclick='spanShowHideAvaility_click(" + p.ItemId + ")'>+</span> ");
                else
                    sb.Append("&nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("</td >");
                sb.Append( "<td >" + p.AvailabilityLocation + "</td>");

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitSellPrice, 2, null, null, null, null) + "</td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "</td>");
                 sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "</td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "</td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "</td>");
                sb.Append("<td class='tAr'>" + p.UnitWeight + "</td>");
                sb.Append("<td class='tAr'>" + Util.NumberFormat(p.ExtendedPrice, 2, null, null, null, null) + "</td>");
                */
                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows)
                {
                    switch (dr["columnName"].ToString())
                    {
                        case "SOS":
                            sb.Append("<td>" + p.SOS + "</td>");
                            break;
                        case "PartNo":
                            sb.Append("<td>" + p.PartNo + "</td>");
                            break;
                        case "Description":
                            //<CODE_TAG_101761>
                            if (!AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"].IsNullOrEmpty() && p.IsCorePart)
                            {
                                sb.Append("<td>" + AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"] + "</td>");
                            }
                            else
                            {
                                sb.Append("<td>" + p.Description + "</td>");
                            }
                            //</CODE_TAG_101761>
                            break;
                        case "Quantity":
                            sb.Append("<td class='tAr'>" + p.Quantity + "</td>");
                            break;
                        case "QtyOnhand":
                            sb.Append("<td class='tAr'>" + p.AvailableQty + "</td>");
                            break;
                        case "ItemId":
                            sb.Append("<td class='tAr'>");
                            if (p.AvailabilityMultiLocation)
                                sb.Append("<span style='cursor:pointer' id='spanShowHideAvaility" + p.ItemId + "'  onclick='spanShowHideAvaility_click(" + p.ItemId + ")'>+</span> ");
                            else
                                sb.Append("&nbsp;&nbsp;&nbsp;&nbsp;");
                            sb.Append("</td >");
                            break;
                        case "Availability":
                            sb.Append("<td >" + p.AvailabilityLocation + "</td>");
                            break;
                        case "UnitSellPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitSellPrice, 2, null, null, null, null) + "</td>");
                            break;
                        case "UnitDiscPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "</td>");
                            break;
                        case "NetSellPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) sb.Append("<td class='tAr'>" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "</td>");
                            break;
                        case "UnitPrice":
                            sb.Append("<td class='tAr'>" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "</td>");
                            break;
                        case "Discount":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "</td>");
                            break;
                        case "DiscountPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                                sb.Append("<td class='tAr'>" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "</td>");
                            break;
                        case "UnitWeight":
                            //sb.Append("<td class='tAr'>" + p.UnitWeight + "</td>");
                            sb.Append("<td class='tAr'>" + p.UnitWeight * p.Quantity + "</td>");  //<CODE_TAG_104122>
                            break;
                        case "ExtendedPrice":
                            sb.Append("<td class='tAr'>" + Util.NumberFormat(p.ExtendedPrice, 2, null, null, null, null) + "</td>");
                            break;
                        default:
                            break;
                    }
                }
                //</CODE_TAG_101986>
                sb.Append("</tr>");

                if (p.AvailabilityMultiLocation)
                {
                    //sb.Append("<tr id='trPartsAvaility" + p.ItemId + "'  style='display:none' " + ((p.ItemId % 2 == 0) ? "class='alterRow'" : "") + "  >  ");
                    //sb.Append("<td colspan='6'></td>");
                    //sb.Append("<td colspan='6'> ");
                    //<CODE_TAG_101986>
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows)
                    {
                        if (dr["columnName"].ToString() == "Availability" && dr["Availability"].ToString() == "2")
                        {
                                string colspan = dr["DisplayOrder"].ToString();
                                sb.Append("<td colspan='" + colspan + "'></td>");
                                sb.Append("<td colspan='" + colspan + "'> ");
                        }
                    }
                    //</CODE_TAG_101986>
                    sb.Append("<input type='hidden' id='hdnShowAvaility" + p.ItemId + "' name='hdnShowAvaility" + p.ItemId + "' value='0'  />");
                    sb.Append("<table cellspacing='0' cellpadding='0'  style='width:200px;  margin-left:-50px'>");

                    if (p.QtyOnhand > 0)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class='tAr'> " + p.QtyOnhand + " </td>");
                        sb.Append("<td>&nbsp;&nbsp;&nbsp;In Store </td>");
                        sb.Append("</tr>");
                    }

                    foreach (BackOrder bo in p.BackOrders)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td style='width:50px' class='tAr'> " + bo.BoQty + " </td>");
                        sb.Append("<td style='width:150px'>&nbsp;&nbsp;&nbsp;");
                        sb.Append(bo.BoFacCode + ((bo.BoFacName.IsNullOrWhiteSpace()) ? "" : "-" + bo.BoFacName));
                        sb.Append("</td>");
                        sb.Append("</tr>");
                    }
                    sb.Append("</table>");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                }
                totalExtPrice += p.ExtendedPrice; 
            }

            var hideColumnsCount = 0;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) hideColumnsCount += 2; 
 

            //line 1
            sb.Append("<tr>");
            sb.Append("<td class=' tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' colspan='" + (15 - hideColumnsCount) + "'>" + ((flatRateInd == "N") ? "PARTS TOTAL:" : "CALCULATED TOTAL:") + "</td>");
            sb.Append("<td class='tAr tSb " + ((flatRateInd == "N") ? "highLight" : "") + "' >" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "</td>");
            sb.Append("</tr>");

            if (flatRateInd != "N")
            {
                //line 2
                sb.Append("<tr>");
                string flatRateDesc = "";
                if (flatRateInd == "E") flatRateDesc = "ESTIMATE";
                if (flatRateInd == "F") flatRateDesc = "FLAT RATE";

                sb.Append("<td class=' tSb  highLight' colspan='3'>PARTS TOTAL: &nbsp;&nbsp;&nbsp;&nbsp;  " + flatRateDesc + " </td>");

                sb.Append("<td class='tAr tSb  highLight' colspan='" + (9 - hideColumnsCount) + "'>Variance:</td>");
                sb.Append("<td class='tAr tSb  highLight' >" +
                          Util.NumberFormat(flatRateAmount - totalExtPrice, 2, null, null, null, true) + "</td>");

                sb.Append("<td class='tAr tSb  highLight' colspan='2'></td>");
                sb.Append("<td class='tAr tSb  highLight' >" + Util.NumberFormat(flatRateAmount, 2, null, null, null, true) +
                          ((flatRateInd == "Y") ? "F" : "") + "</td>");
                sb.Append("</tr>");

            }
            sb.Append("</table>");

            return sb.ToString();
        }

        public static string GetEditHtml(List<Part> allParts, string flatRateInd, double flatRateAmountInput, bool autoCalculate)
        {
            if (flatRateInd == "")
            {
                flatRateInd = AppContext.Current.AppSettings["psQuoter.Quote.Segments.FlatRateorEstimate.Options.DefaultSelected"];
            }

            double totalExtPrice = 0;
            double totalPartAmount = 0;
            double totalQty = 0;
            bool isMarkupDiscount = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup");
            //<CODE_TAG_103590>
            string partDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.Discount.Heading"].ToString();
            //</CODE_TAG_103590>
            StringBuilder sb = new StringBuilder();

            DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(1); //<CODE_TAG_101986>

            //Header
            sb.Append("<table>");

            if (allParts.Count > 0)
            {
                sb.Append("<tr>");
                sb.Append("<th colspan='50' class='tAc'>");
                sb.Append("<input type='button' ID='btnRefreAllAvailability' value='Refresh Availability' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(0,'RefreshAllPartsAvailability');\" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<input type='button' ID='btnRefreAllPriceAndAvailability' value='Refresh Price And Availability' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(0,'RefreshAllPartsPriceAndAvailability');\" />&nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append("<input type='button' ID='btnRefreAllPrice' value='Refresh Price' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(0,'RefreshAllPartsPrice');\" />");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.ApplyToAll"))//<CODE_TAG_105845> lwang
                    sb.Append("&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' ID='btnUpdatePercent' value='Update %' onclick=\"detailDataChanged= true; ApplyPartsDiscount();\" />");     //<CODE_TAG_105845> lwang
                sb.Append("</th>");
                sb.Append("</tr>");
            }


            sb.Append("<tr>");
            sb.Append("<th class='tAr' style='width:2%'></th>");

           /* sb.Append("<th class='tAc' style='width:3%'>SOS</th>");
            sb.Append("<th class='tAc' style='width:10%'>Part No</th>");
            sb.Append("<th class='tAc' style='width:25%'>Description</th>");
            sb.Append("<th class='tAc' style='width:6%'>Qty</th>");
            sb.Append("<th class='tAr' style='width:7%'>Quantity <br/> Available</th>");
            sb.Append("<th class='tAc' style='width:10%'>Availability</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                sb.Append("<th class='tAc' style='width:10%'>Unit Sell</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show"))
                sb.Append("<th class='tAc' style='width:7%'>Unit Disc</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show"))
                sb.Append("<th class='tAc' style='width:7%'>Net Sell</th>");
            
            sb.Append("<th class='tAc' style='width:7%'>Unit Price</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                sb.Append("<th class='tAc' style='width:7%'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                sb.Append("<th class='tAc' style='width:7%'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");

            sb.Append("<th class='tAr' style='width:10%'>Est Weight <br/> (LBS) &nbsp;&nbsp;&nbsp;</th>");
            sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");
            sb.Append("<th style='width:10%'><input type='button' ID='btnImportXML' value='Import SIS File' onclick='importXML(); return false;' />");
            */
            //<CODE_TAG_101986>
            foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows)
            {
                switch (dr["columnName"].ToString())
                {
                    case "SOS":
                        sb.Append("<th class='tAc' style='width:3%'>SOS</th>");
                        break;
                    case "PartNo":
                        sb.Append("<th class='tAc' style='width:10%'>Part No</th>");
                        break;
                    case "Description":
                        sb.Append("<th class='tAc' style='width:25%'>Description</th>");
                        break;

                    case "Quantity":
                        sb.Append("<th class='tAc' style='width:6%'>Qty</th>");
                        break;
                    case "QtyOnhand":
                        sb.Append("<th class='tAr' style='width:7%'>Quantity <br/> Available</th>");
                        break;

                    case "ItemId":
                        //no such column in edit mode
                        break;
                    case "Availability":
                        sb.Append("<th class='tAc' style='width:10%'>Availability</th>");
                        break;

                    case "UnitSellPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                            sb.Append("<th class='tAc' style='width:10%'>Unit Sell</th>");
                        break;
                    case "UnitDiscPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show"))  //<Ticket 42786>   
                            sb.Append("<th class='tAc' style='width:7%'>Unit Disc</th>");
                        break;

                    case "NetSellPrice":
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show"))
                            sb.Append("<th class='tAc' style='width:7%'>Net Sell</th>");
                        break;
                    case "UnitPrice":
                        sb.Append("<th class='tAc' style='width:7%'>Unit Price</th>");
                        break;
                    case "Discount":
                        //if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:5%' class='tAr'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");
                        //<CODE_TAG_103590>
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                        { 
                            if (!string.IsNullOrEmpty(partDiscountHeading))
                                sb.Append("<th  style='width:5%' class='tAr'>" + partDiscountHeading + "(%)</th>");
                            else
                                sb.Append("<th  style='width:5%' class='tAr'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");

                        }
                        //</CODE_TAG_103590>
                        break;
                    case "DiscountPrice":
                        //if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) sb.Append("<th  style='width:10%' class='tAr'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");
                        //<CODE_TAG_103590>
                        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                        {
                            if (!string.IsNullOrEmpty(partDiscountHeading))
                                sb.Append("<th  style='width:10%' class='tAr'>" + partDiscountHeading + "</th>");
                            else
                                sb.Append("<th  style='width:10%' class='tAr'>" + ((isMarkupDiscount) ? "Markup Price" : "Discount Price") + "</th>");
                        }
                        //</CODE_TAG_103590>
                        break;
                    case "UnitWeight":
                        sb.Append("<th class='tAr' style='width:10%'>Est Weight <br/> (LBS) &nbsp;&nbsp;&nbsp;</th>");
                        break;
                    case "ExtendedPrice":
                        sb.Append("<th class='tAc' style='width:10%'>Ext Price</th>");
                        break;
                    case "ImportSOSFile":
                        /*sb.Append("<th style='width:10%'><input type='button' ID='btnImportXML' value='Import SIS File' onclick='importXML(); return false;' />");
						sb.Append("<input type='button' ID='btnImportBulkParts' value='Import Bulk Parts' onclick='importBulkParts(); return false;' />");		//<CODE_TAG_103467> Dav
                        //string strImportDBSPartDocumentHandler = "ImportDBSPartDocument('ImportDBSDocumentParts')";
                        sb.Append("<input type='button' ID='btnImportDBSPartDocument' value='Import DBS Document Parts' onclick='ImportDBSDocumentParts(); return false;' />");//<CODE_TAG_103600>
                        */
                        //<CODE_TAG_103633>//Note: click event is not support in IE8
                        sb.Append("<th style='width:10%'>");
                        //sb.Append("<span id='spnImportPanel'  ><select id='ddlSelectImportLst' onchange='ddlSelectImportLst_onchange();' style='background-color: #5d5d5d; color:white' class='ui-button ui-widget ui-state-default ui-corner-all'><option>Parts Import Selection</option>");
                        sb.Append("<span id='spnImportPanel'  ><select id='ddlSelectImportLst' onchange='ddlSelectImportLst_onchange();' style='background-color: #5d5d5d; color:white' class='ui-button ui-widget ui-state-default ui-corner-all'><option value='00' >Parts Import Selection</option>");//<CODE_TAG_104904>
                        sb.Append("<option value='importXML'  style='background-color: #5d5d5d; fore-color:white'>Import SIS File</option>");
                        sb.Append("<option value='importBulkParts' style='background-color: #5d5d5d; fore-color:white'>Import Bulk Parts</option>");//<CODE_TAG_103467> Dav
                        sb.Append("<option value='ImportDBSDocumentParts' style='background-color: #5d5d5d; fore-color:white' >Import DBS Parts Document</option>");//<CODE_TAG_103600>
                        sb.Append("</select><span>");
                        //</CODE_TAG_103633>
                        break;
                    default:
                        break;

                }
            }
            //</CODE_TAG_101986>

            sb.Append("<input type='Hidden' id='hdnXMLParts' name='hdnXMLParts'  value=''  />");
            sb.Append("<input type='Hidden' id='hdnPartsCount' name='hdnPartsCount'  value='" + allParts.Count + "'  /> </th>");
            sb.Append("</tr>");
            //Items
            int itemId = 0;
            foreach (Part p in allParts)
            {
                itemId++;
                sb.Append("<tr>");
                if (p.IsCorePart)
                {
                    sb.Append("<td>CORE</td>");
                }
                else
                {
                    if (p.IsLocked)
                        sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                    else
                        sb.Append("<td><img src='../../Library/images/magnifier.gif' onclick='partSearch(" + itemId + ");' class='imgBtn' /></td>");
                }
                //<CODE_TAG_101986>
                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows)
                {
                    switch (dr["columnName"].ToString())
                    {
                        case "SOS":
                            if (p.IsCorePart)
                                sb.Append("<td><input type='text'  id='txtPartSOS" + itemId + "' name='txtPartSOS" + itemId + "' class='w90p' value='" + p.SOS + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly' tabindex = -1 " : "") + "  /></td>");//<CODE_TAG_102173> let tab skip readonly txtbox
                            else
                                //sb.Append("<td><input type='text' id='txtPartSOS" + itemId + "' name='txtPartSOS" + itemId + "' class='w90p' value='" + p.SOS + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + "  /></td>");
                                //sb.Append("<td><input type='text' maxLength='3'  id='txtPartSOS" + itemId + "' name='txtPartSOS" + itemId + "' class='w90p' value='" + p.SOS + "' onkeypress='detailDataChanged= true; ToNextField(" + itemId +"); '   onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + "  /></td>");//<CODE_TAG_103532>
                                sb.Append("<td><input type='text' maxLength='3'  id='txtPartSOS" + itemId + "' name='txtPartSOS" + itemId + "' class='w90p' value='" + p.SOS + "' onkeyup='detailDataChanged= true; ToNextField(" + itemId + "); '   onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + "  /></td>");//<CODE_TAG_103532>

                            break;
                        case "PartNo":
                            if (p.IsCorePart)
                                sb.Append("<td><input type='text' maxlength='20' id='txtPartNo" + itemId + "' name='txtPartNo" + itemId + "' class='w90p' value='" + p.PartNo + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + " , \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'  tabindex = -1" : "") + " /></td>"); //<CODE_TAG_102173>
                            else
                                sb.Append("<td><input type='text' maxlength='20' id='txtPartNo" + itemId + "' name='txtPartNo" + itemId + "' class='w90p' value='" + p.PartNo + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + " , \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                            break;
                        case "Description":
                            //<CODE_TAG_101761>
                            if (!AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"].IsNullOrEmpty() && p.IsCorePart)
                            {
                                //sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + "CORE" + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                //sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"] + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"] + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'  tabindex = -1 " : "") + " /></td>");

                            }
                            else
                            {
                                sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + p.Description + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'  tabindex = -1 " : "") + " /></td>");
                            }
                            //</CODE_TAG_101761>
                            break;
                        case "Quantity":
                            //sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p tAr numbersOnly' value='" + p.Quantity + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"CALCULATE\",\"\",\"Quantity\");' " + (((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled")) || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                            //<CODE_TAG_101929>
                            //sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p tAr numbersOnly' value='" + p.Quantity + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\",\"\",\"Quantity\");' " + (((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled")) || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                            //</CODE_TAG_101929>

                            //<CODE_TAG_103438>
                            if (p.IsCorePart)
                            {
                                sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p  tAr numbersOnly' value='" + p.Quantity + "'  readonly='readonly' " + " /></td>");
                            }
                            else
                            {
                                sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p  tAr numbersOnly' value='" + p.Quantity + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\",\"\",\"Quantity\");' " + (((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled")) || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");//<CODE_TAG_101929>
                            }
                            //</CODE_TAG_103438>
                            break;
                        case "QtyOnhand":
                            sb.Append("<td class='tAr'>" + p.AvailableQty + "&nbsp;&nbsp;<input type='text' id='txtPartAvailableQty" + itemId + "' name='txtPartAvailableQty" + itemId + "' class='w90p tAr' value='" + p.AvailableQty + "' style='display:none' readonly='readonly'  tabindex = -1 /></td>");
                            break;
                        case "ItemId":
                            break;
                        case "Availability":
                            sb.Append("<td class='noWrap'> ");
                            if (p.AvailabilityMultiLocation)
                                sb.Append("<span style='cursor:pointer' id='spanShowHideAvaility" + itemId + "'  onclick='spanShowHideAvaility_click(" + itemId + ")'>+</span> ");
                            else
                                sb.Append("&nbsp;&nbsp;&nbsp;&nbsp;");
                            sb.Append(p.AvailabilityLocation + "<input type='text' id='txtPartAvaility" + itemId + "' name='txtPartAvaility" + itemId + "' class='w80p' value='" + p.AvailabilityLocation + "' style='display:none' readonly='readonly'  tabindex = -1 /></td>");
                            break;
                        case "UnitSellPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                                //sb.Append("<td><input type='text' id='txtPartUnitSellPrice" + itemId + "' name='txtPartUnitSellPrice" + itemId + "' class='w90p tAr numbersOnly' value='" + Util.NumberFormat(p.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                sb.Append("<td><input type='text' id='txtPartUnitSellPrice" + itemId + "' name='txtPartUnitSellPrice" + itemId + "' class='w90p tAr numbersOnly' value='" + Util.NumberFormat(p.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");                                
                                 
                            break;
                        case "UnitDiscPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show"))
                                //sb.Append("<td><input type='text' id='txtPartUnitDiscPrice" + itemId + "' name='txtPartUnitDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                sb.Append("<td><input type='text' id='txtPartUnitDiscPrice" + itemId + "' name='txtPartUnitDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly'  tabindex='-1'  /></td>"); 
                            break;
                        case "NetSellPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show"))
                                //sb.Append("<td><input type='text' id='txtPartNetSellPrice" + itemId + "' name='txtPartNetSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                sb.Append("<td><input type='text' id='txtPartNetSellPrice" + itemId + "' name='txtPartNetSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "' readonly='readonly'   tabindex='-1'  /></td>");
                            break;
                        case "UnitPrice":
                            //sb.Append("<td><input type='text' id='txtPartUnitPrice" + itemId + "' name='txtPartUnitPrice" + itemId + "' class='w90p tAr'  value='" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "' " + (AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.UnitPrice.Editable") ? "" : "readonly='readonly'") + " onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"CALCULATE\",\"\",\"UnitPrice\");' /></td>");
                            sb.Append("<td><input type='text' id='txtPartUnitPrice" + itemId + "' name='txtPartUnitPrice" + itemId + "' class='w90p tAr'  value='" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "' " + (AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.UnitPrice.Editable") ? "" : "readonly='readonly'") + " onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"CALCULATE\",\"\",\"UnitPrice\",\"" + ((p.IsCorePart) ? "2" : "1") + "\");' /></td>"); //<CODE_TAG_102268>
                            break;
                        case "Discount":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                            //sb.Append("<td><input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");                     
                            //<CODE_TAG_105120>    
                            //sb.Append("<td><input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");                            
                            {
                                if (!string.IsNullOrEmpty(partDiscountHeading) || !isMarkupDiscount || isMarkupDiscount && !AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup.PositiveOnly"))
                                    sb.Append("<td><input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                else
                                    sb.Append("<td><input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true; return allowOnlyNumber(event);' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                            }
                            //</CODE_TAG_105120>
                            break;
                        case "DiscountPrice":
                            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                                //sb.Append("<td><input type='text' id='txtPartDiscPrice" + itemId + "' name='txtPartDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                sb.Append("<td><input type='text' id='txtPartDiscPrice" + itemId + "' name='txtPartDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1'   /></td>");
                            break;
                        case "UnitWeight":
                            //sb.Append("<td class='tAr'>" + p.UnitWeight + "&nbsp;&nbsp;<input type='text' id='txtPartUnitWeight" + itemId + "' name='txtPartUnitWeight" + itemId + "' class='w90p tAr' value='" + p.UnitWeight + "' style='display:none' readonly='readonly' /></td>");
                            sb.Append("<td class='tAr'>" + p.UnitWeight * p.Quantity + "&nbsp;&nbsp;<input type='text' id='txtPartUnitWeight" + itemId + "' name='txtPartUnitWeight" + itemId + "' class='w90p tAr' value='" + p.UnitWeight + "' style='display:none' readonly='readonly' /></td>");//<CODE_TAG_104122>
                            break;
                        case "ExtendedPrice":
                            sb.Append("<td class='tAr'><span >" + Util.NumberFormat(p.ExtendedPrice, 2, null, null, null, null) + "</span></td>");
                            break;
                        case "ImportSOSFile":
                            if ((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Delete.Show")) || p.IsLocked)
                                sb.Append("<td>");
                            else
                                sb.Append("<td><img src='../../Library/Images/icon_x.gif' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE');\" /> ");
                            break;


                    }
                }
                //</CODE_TAG_101986>

                /*
                sb.Append("<td><input type='text' id='txtPartSOS" + itemId + "' name='txtPartSOS" + itemId + "' class='w90p' value='" + p.SOS + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + "  /></td>");
                sb.Append("<td><input type='text' id='txtPartNo" + itemId + "' name='txtPartNo" + itemId + "' class='w90p' value='" + p.PartNo + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + " , \"REFRESHCATPRICE\");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                //<CODE_TAG_101761>
                if (!AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"].IsNullOrEmpty() && p.IsCorePart)
                {
                    //sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + "CORE" + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.CorePartDescription"] + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                    
                }
                else
                {
                    sb.Append("<td><input type='text' id='txtPartDescription" + itemId + "' name='txtPartDescription" + itemId + "' class='w90p' value='" + p.Description + "' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                }
                //</CODE_TAG_101761>
                //sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p tAr numbersOnly' value='" + p.Quantity + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"CALCULATE\",\"\",\"Quantity\");' " + (((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled")) || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                //<CODE_TAG_101929>
                sb.Append("<td class='tAr'><input type='text' id='txtPartQuantity" + itemId + "' name='txtPartQuantity" + itemId + "' class='w90p tAr numbersOnly' value='" + p.Quantity + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"REFRESHCATPRICE\",\"\",\"Quantity\");' " + (((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled")) || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                //</CODE_TAG_101929>
                sb.Append("<td class='tAr'>" + p.AvailableQty + "&nbsp;&nbsp;<input type='text' id='txtPartAvailableQty" + itemId + "' name='txtPartAvailableQty" + itemId + "' class='w90p tAr' value='" + p.AvailableQty + "' style='display:none' readonly='readonly' /></td>");
                sb.Append("<td class='noWrap'> " );
                if (p.AvailabilityMultiLocation)
                    sb.Append("<span style='cursor:pointer' id='spanShowHideAvaility" + itemId + "'  onclick='spanShowHideAvaility_click(" + itemId + ")'>+</span> ");
                else
                    sb.Append("&nbsp;&nbsp;&nbsp;&nbsp;");
                sb.Append(p.AvailabilityLocation + "<input type='text' id='txtPartAvaility" + itemId + "' name='txtPartAvaility" + itemId + "' class='w80p' value='" + p.AvailabilityLocation + "' style='display:none' readonly='readonly' /></td>");


                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                    sb.Append("<td><input type='text' id='txtPartUnitSellPrice" + itemId + "' name='txtPartUnitSellPrice" + itemId + "' class='w90p tAr numbersOnly' value='" + Util.NumberFormat(p.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) 
                    sb.Append("<td><input type='text' id='txtPartUnitDiscPrice" + itemId + "' name='txtPartUnitDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show"))  
                    sb.Append("<td><input type='text' id='txtPartNetSellPrice" + itemId + "' name='txtPartNetSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");


                sb.Append("<td><input type='text' id='txtPartUnitPrice" + itemId + "' name='txtPartUnitPrice" + itemId + "' class='w90p tAr'  value='" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "' " + (AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.UnitPrice.Editable") ? "" : "readonly='readonly'") + " onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ", \"CALCULATE\",\"\",\"UnitPrice\");' /></td>");
                
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) 
                    sb.Append("<td><input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart || p.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) 
                    sb.Append("<td><input type='text' id='txtPartDiscPrice" + itemId + "' name='txtPartDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");

                sb.Append("<td class='tAr'>" + p.UnitWeight + "&nbsp;&nbsp;<input type='text' id='txtPartUnitWeight" + itemId + "' name='txtPartUnitWeight" + itemId + "' class='w90p tAr' value='" + p.UnitWeight + "' style='display:none' readonly='readonly' /></td>");
                sb.Append("<td class='tAr'><span >"+ Util.NumberFormat(p.ExtendedPrice, 2, null, null, null, null) + "</span></td>");
                if ((p.IsCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Delete.Show")) || p.IsLocked)
                    sb.Append("<td>");
                else
                    sb.Append("<td><img src='../../Library/Images/icon_x.gif' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE');\" /> ");

                */
               
                sb.Append("<input type='hidden' id='txtPartCoreItemId" + itemId + "' name='txtPartCoreItemId" + itemId + "' value='" + p.CoreItemId + "'  />");
                sb.Append("<input type='hidden' id='hdnBoCount" + itemId + "' name='hdnBoCount" + itemId + "' value='" + ((p.BackOrders == null) ? "0" : p.BackOrders.Count.ToString()) + "'  />");
                sb.Append("<input type='hidden' id='hdnQtyOnhand" + itemId + "' name='hdnQtyOnhand" + itemId + "' value='" + p.QtyOnhand + "'  />");
                sb.Append("<input type='hidden' id='hdnPartLock" + itemId + "' name='hdnPartLock" + itemId + "' value='" + p.Lock + "'  />");

                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                    sb.Append("<input type='text' id='txtPartUnitSellPrice" + itemId + "' name='txtPartUnitSellPrice" + itemId + "' class='w90p tAr' style='display:none' value='" + Util.NumberFormat(p.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;'  />");
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) 
                    sb.Append("<input type='text' id='txtPartUnitDiscPrice" + itemId + "' name='txtPartUnitDiscPrice" + itemId + "' class='w90p tAr' style='display:none' value='" + Util.NumberFormat(p.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' />");
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) 
                    sb.Append("<input type='text' id='txtPartNetSellPrice" + itemId + "' name='txtPartNetSellPrice" + itemId + "' class='w90p tAr' style='display:none' value='" + Util.NumberFormat(p.NetSellPrice, 2, null, null, null, null) + "' readonly='readonly' />");
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) 
                    sb.Append("<input type='text' id='txtPartDiscount" + itemId + "' name='txtPartDiscount" + itemId + "' class='w90p tAr' style='display:none' value='" + Util.NumberFormat(p.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + itemId + ");' " + ((p.IsCorePart) ? "readonly='readonly'" : "") + " />");
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) 
                    sb.Append("<input type='text' id='txtPartDiscPrice" + itemId + "' name='txtPartDiscPrice" + itemId + "' class='w90p tAr' style='display:none' value='" + Util.NumberFormat(p.DiscountPrice, 2, null, null, null, null) + "' readonly='readonly' />");


                sb.Append("</td>");
                sb.Append("</tr>");

                if (p.BackOrders != null) //   p.AvailabilityMultiLocation)
                {
                    sb.Append("<tr id='trPartsAvaility" + itemId + "'  style='display:none'> ");
                    sb.Append("<td colspan='6'></td>");
                    sb.Append("<td colspan='6'> ");
                    
                    sb.Append("<input type='hidden' id='hdnShowAvaility" + itemId + "' name='hdnShowAvaility" + itemId + "' value='0'  />");
                    sb.Append("<table cellspacing='0' cellpadding='0' style='width:200px; margin-left:-50px'>");

                    if (p.QtyOnhand > 0)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td class='tAr'> " + p.QtyOnhand + " &nbsp;&nbsp;</td>");
                        sb.Append("<td>&nbsp;&nbsp;&nbsp;In Store </td>");
                        sb.Append("</tr>");
                    }

                    int i = 0;
                    foreach (BackOrder bo in p.BackOrders)
                    {

                        sb.Append("<tr>");
                        sb.Append("<td class='tAr' style='width:50px' > " + bo.BoQty + " &nbsp;&nbsp;</td>");
                        sb.Append("<td style='width:150px'>&nbsp;&nbsp;&nbsp;");
                        sb.Append(bo.BoFacCode + ((bo.BoFacName.IsNullOrWhiteSpace()) ? "" : "-" + bo.BoFacName));
                        sb.Append("<input type='hidden' id='hdnBoFacCode" + itemId + "_" + i + "' name='hdnBoFacCode" + itemId + "_" + i + "' value='" + bo.BoFacCode + "'  />");
                        sb.Append("<input type='hidden' id='hdnBoFacName" + itemId + "_" + i + "' name='hdnBoFacName" + itemId + "_" + i + "' value='" + bo.BoFacName + "'  />");
                        sb.Append("<input type='hidden' id='hdnBoFacType" + itemId + "_" + i + "' name='hdnBoFacType" + itemId + "_" + i + "' value='" + bo.BoFacType + "'  />");
                        sb.Append("<input type='hidden' id='hdnBoQty" + itemId + "_" + i + "' name='hdnBoQty" + itemId + "_" + i + "' value='" + bo.BoQty + "'  />");
                        sb.Append("</td>");
                        sb.Append("</tr>");
                        i++;
                    }
                    sb.Append("</table>");
                    sb.Append("</td>");
                    sb.Append("</tr>");
                }
                totalExtPrice += p.ExtendedPrice;
                totalQty += p.Quantity; 
            }

            var hideColumnsCount = 0;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) hideColumnsCount++;
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) hideColumnsCount += 2;

            if (autoCalculate)
                flatRateAmountInput = totalExtPrice;

            if (flatRateInd == "N")
            {
                //line 1
                sb.Append("<tr>");
                sb.Append("<td class='tSb highLight'></td>");
                sb.Append("<td class='tSb highLight' colspan='2'>PARTS TOTAL</td>");
                sb.Append("<td class='highLight tSb'><select id='lstPartFlatRate' name='lstPartFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0);' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >FlatRate</option>");
                sb.Append("</select>");
                sb.Append("</td>");
                //sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalQty, 0, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='highLight' colspan='" + (6 - hideColumnsCount) + "'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");


                sb.Append("<td class='tAr highLight'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td class='highLight'><img src='../../Library/Images/plus_icon.png'   onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\"); tabindex=\"-1\" ' />  <input type='hidden' id='hdnTotalParts' name='hdnTotalParts' value='" + flatRateAmountInput + "' /></td>");

                sb.Append("</tr>");
            }
            else
            {
                
                //line 1
                sb.Append("<tr>");
                sb.Append("<td class='tSb'></td>");
                sb.Append("<td class='tSb' colspan='3'>CALCULATED TOTAL</td>");
                sb.Append("<td class='tAr'>" + totalQty + "&nbsp;</td>");
                sb.Append("<td colspan='" + (6 - hideColumnsCount) + "'></td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td colspan=''></td>");
                sb.Append("<td class='tAr'>" + Util.NumberFormat(totalExtPrice, 2, null, null, null, true) + "&nbsp;</td>");
                sb.Append("<td><img src='../../Library/Images/plus_icon.png'  onclick='detailDataChanged= true; SegmentDetailAjaxHandler(0,\"ADD\");  tabindex=\"-1\" ' /> <input type='hidden' id='hdnTotalParts' name='hdnTotalParts' value='" + flatRateAmountInput + "' /> </td>");
                sb.Append("</tr>");

                //line 2
                sb.Append("<tr>");
                sb.Append("<td class='tSb'></td>");
                sb.Append("<td class='tSb highLight' colspan='2'>PARTS TOTAL</td>");
                sb.Append("<td class='highLight tSb' ><select id='lstPartFlatRate' name='lstPartFlatRate' onchange='detailDataChanged= true; SegmentDetailAjaxHandler(0);' >");
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segments.FlatRateorEstimate.Options.No.Show"))
                {
                    sb.Append("<option value='N' " + ((flatRateInd == "N") ? "selected" : "") + " >Calculated</option>");
                }
                sb.Append("<option value='E' " + ((flatRateInd == "E") ? "selected" : "") + " >Estimate</option>");
                sb.Append("<option value='F' " + ((flatRateInd == "F") ? "selected" : "") + " >FlatRate</option>");
                sb.Append("</select>");
                sb.Append("</td>");
                //sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='highLight'></td>");
                sb.Append("<td class='tAr highLight'></td>");
                sb.Append("<td class='highLight' colspan='" + (6 - hideColumnsCount) + "'>Variance:" + Util.NumberFormat(flatRateAmountInput - totalExtPrice, 2, null, null, null, true) + "</td>");
                sb.Append("<td class='tAr highLight'><input style='width:100px' type='text' id='txtPartFlatRateAmount' name='txtPartFlatRateAmount'  value='" + Util.NumberFormat(flatRateAmountInput, 2, null, null, null, true) + "'   class='tAr w90p' onkeypress='lockPartsTotal();' onblur='detailDataChanged= true; SegmentDetailAjaxHandler(0);' / ></td>"); //<CODE_TAG_101914> 
                sb.Append("<td class='highLight'><input type='checkbox' ID='chkPartsAutoCalculate' name='chkPartsAutoCalculate' " + ((!autoCalculate) ? "checked='checked'" : "") + "    onclick='  detailDataChanged= true; SegmentDetailAjaxHandler(0); ' />Lock Total </td>");
                sb.Append("</tr>");
            }
              
            sb.Append("</table>");

            return sb.ToString();
        }
       
        public static string BuildPartJsonData(PartPrice pp)
        {//<CODE_TAG_103468> here use string builder instead of string to improve the performance
            //string strData;
            
            StringBuilder sb = new StringBuilder();
            sb.Append("{\"SOS\":\"" + HttpContext.Current.Server.HtmlEncode(pp.Sos) + "\",");
            sb.Append("\"PARTNO\":\"" + HttpContext.Current.Server.HtmlEncode(pp.PartNo.Trim()) + "\",");
            //sb.Append("\"DESC\":\"" + HttpContext.Current.Server.HtmlEncode(pp.PartDesc) + "\","); //<CODE_TAG_105221> lwang
            sb.Append("\"DESC\":\"" + HttpContext.Current.Server.HtmlEncode(pp.PartDesc.Replace("\"", "&#34;")) + "\","); //<CODE_TAG_105221> lwang
            sb.Append("\"PARTQTY\":\"" + pp.Qty + "\",");
            sb.Append("\"AvailableQty\":\"" + pp.AvailableQty + "\",");
            sb.Append("\"QtyOnhand\":\"" + pp.QtyOnhand + "\",");
            sb.Append("\"UnitWeight\":\"" + pp.UnitWeight + "\",");
            /*
            if (pp.UnitSell.HasValue)
                strData += "\"UNITSELL\":\"" + pp.UnitSell.Value.ToString("0.00") + "\",";
            else
                strData += "\"UNITSELL\":\"0.00\","; //NF
            if (pp.UnitDisc.HasValue)
                strData += "\"UNITDISC\":\"" + pp.UnitDisc.Value.ToString("0.00") + "\",";
            else
                strData += "\"UNITDISC\":\"0.00\","; //NF
            if (pp.UnitNet.HasValue)
            {
                strData += "\"NETSELL\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",";
                strData += "\"UNITPRICE\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",";
                strData += "\"DISCOUNT\":\"0.00\",";
                strData += "\"DISCPRICE\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",";
                strData += "\"EXTPRICE\":\"" + (pp.UnitNet.Value * pp.Qty).ToString("0.00") + "\",";
            }
            else
            {
                strData += "\"NETSELL\":\"0.00\","; //NF
                strData += "\"UNITPRICE\":\"0.00\",";
                strData += "\"DISCOUNT\":\"0.00\",";
                strData += "\"DISCPRICE\":\"0.00\",";
                strData += "\"EXTPRICE\":\"0.00\",";
            }
            */
            //<CODE_TAG_102215> Victor20130930
            if (pp.UnitSell.HasValue)
            {
                sb.Append("\"UNITSELL\":\"" + pp.UnitSell.Value.ToString("0.00") + "\",");
                sb.Append("\"UNITPRICE\":\"" + (pp.UnitSell.Value - pp.UnitDisc.Value).ToString("0.00") + "\",");
                sb.Append("\"DISCPRICE\":\"" + (pp.UnitSell.Value - pp.UnitDisc.Value).ToString("0.00") + "\",");
                sb.Append("\"EXTPRICE\":\"" + ((pp.UnitSell.Value - pp.UnitDisc.Value) * pp.Qty).ToString("0.00") + "\",");
                //<CODE_TAG_104427> Dav
                //sb.Append("\"DISCOUNT\":\"0.00\",");
                sb.Append("\"DISCOUNT\":\"" + pp.Discount.ToString("0.00") + "\",");
                //</CODE_TAG_104427> Dav
            }
            else
            {
                sb.Append("\"UNITSELL\":\"0.00\","); //NF
                sb.Append("\"UNITPRICE\":\"0.00\",");
                sb.Append("\"DISCPRICE\":\"0.00\",");
                sb.Append("\"EXTPRICE\":\"0.00\",");
                sb.Append("\"DISCOUNT\":\"0.00\",");
            }
            if (pp.UnitDisc.HasValue)
                sb.Append("\"UNITDISC\":\"" + pp.UnitDisc.Value.ToString("0.00") + "\",");
            else
                sb.Append("\"UNITDISC\":\"0.00\","); //NF
            if (pp.UnitNet.HasValue)
            {
                sb.Append("\"NETSELL\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",");
                //strData += "\"UNITPRICE\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",";
                //strData += "\"DISCOUNT\":\"0.00\",";
                //strData += "\"DISCPRICE\":\"" + pp.UnitNet.Value.ToString("0.00") + "\",";
                //strData += "\"EXTPRICE\":\"" + (pp.UnitNet.Value * pp.Qty).ToString("0.00") + "\",";
            }
            else
            {
                sb.Append("\"NETSELL\":\"0.00\","); //NF
                //strData += "\"UNITPRICE\":\"0.00\",";
                //strData += "\"DISCOUNT\":\"0.00\",";
                //strData += "\"DISCPRICE\":\"0.00\",";
                //strData += "\"EXTPRICE\":\"0.00\",";
            }

            //</CODE_TAG_102215>

            if (pp.CoreExtdSell.HasValue)
                //strData += "\"COREPRICE\":\"" + pp.CoreExtdSell.Value.ToString("0.00") + "\",";
                sb.Append("\"COREPRICE\":\"" + pp.CoreUnitSell.Value.ToString("0.00") + "\","); //<Ticket 32390> //<CODE_TAG_104423>
            else
                sb.Append("\"COREPRICE\":\"0.00\",");



            int i = 0;
            if (pp.BackOrders != null)
            {
                foreach (BoInfo bo in pp.BackOrders)
                {
                    sb.Append("\"BoFacCode" + i.ToString() + "\":\"" + bo.BoFacCode + "\",");
                    sb.Append("\"BoFacName" + i.ToString() + "\":\"" + bo.BoFacName + "\",");
                    sb.Append("\"BoFacType" + i.ToString() + "\":\"" + bo.BoFacType + "\",");
                    sb.Append("\"BoQty" + i.ToString() + "\":\"" + bo.BoQty + "\",");
                    i++;
                }
            }
            sb.Append("\"BoCount\":\"" + ((pp.BackOrders == null) ? "0" : pp.BackOrders.Count.ToString()) + "\"");
            sb.Append("}");
            //return strData;
            return sb.ToString();
        }

        public static double GetExtPriceTotal(List<Part> allParts)
        {
            double rt = 0;
            foreach (Part p in allParts)
            {
                rt += p.ExtendedPrice;
            }
            return rt;
        }

    }

}

