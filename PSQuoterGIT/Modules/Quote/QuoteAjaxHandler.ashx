<%@ WebHandler Language="C#" Class="QuoteAjaxHandler" %>

using System;
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
using X.Web.Extensions;

// R: Replace
// A: Alert
// P: Popup to choice

public class QuoteAjaxHandler : IHttpHandler
{
    string spiltChar1 = ((char)5).ToString();
    string spiltChar2 = "|";
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string operation = context.Request.QueryString["OP"].ToUpper();
        DataSet ds;
        string rtHtml = "";
        string itemId;
        double unitPrice, unitSellPrice, qty, extPrice, unitCostPrice, unitPercentRate;
        int SegmentId, QuoteID;
        string STN1, CSCC, LaborChargeCodeList, MiscChargeCodeList;

        switch (operation )
        {
            case "LABOURCHARGECODE":
                SegmentId = context.Request.QueryString["SegmentId"].AsInt();
                QuoteID = context.Request.QueryString["QuoteId"].AsInt();
                STN1 = context.Request.QueryString["STN1"];
                CSCC = context.Request.QueryString["CSCC"];
                LaborChargeCodeList = "";
                ds = DAL.Quote.QuoteGetUniqueLabourChargeCode(SegmentId, QuoteID, STN1, CSCC);

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (LaborChargeCodeList != "") LaborChargeCodeList += spiltChar1;
                    LaborChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + (dr["chargeCodeDesc"].ToString()) + "," + dr["CRTR"].ToString() + "," + dr["COTR"].ToString() + "," + dr["CPTR"].ToString() + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); // <CODE_TAG_101452> 
                }
                 
                rtHtml = LaborChargeCodeList;
                break;
            case "MISCCHARGECODE":
                SegmentId = context.Request.QueryString["SegmentId"].AsInt();
                QuoteID = context.Request.QueryString["QuoteId"].AsInt();
                STN1 = context.Request.QueryString["STN1"];
                CSCC = context.Request.QueryString["CSCC"];
                MiscChargeCodeList = "";
                ds = DAL.Quote.QuoteGetUniqueMiscChargeCode(SegmentId, QuoteID, STN1, CSCC);

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (MiscChargeCodeList != "") MiscChargeCodeList += spiltChar1;
                    //MiscChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + (dr["chargeCodeDesc"].ToString()) + "," + dr["UnitCost"].ToString() + "," + dr["UnitPrice"].ToString() + "," + dr["PercentRate"].ToString() + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); // <CODE_TAG_101452> 
                    MiscChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + (dr["chargeCodeDesc"].ToString().Replace("," , "&#44;")) + "," + dr["UnitCost"].ToString() + "," + dr["UnitPrice"].ToString() + "," + dr["PercentRate"].ToString() + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); // <CODE_TAG_101452><Ticket 28762> 
                }
                 
                rtHtml = MiscChargeCodeList;
                break;
            case "OPPLIST":
                string customerNo = context.Request.QueryString["cuno"];
                string division = context.Request.QueryString["division"];
                int quoteTypeId = context.Request.QueryString["QuoteTypeId"].AsInt( );

                ds = DAL.Quote.QuoteGetAviliableOppList(customerNo, division, quoteTypeId);
                var oppList = "";
                
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (oppList != "") oppList += spiltChar1;
                    oppList += dr["OppNo"].ToString() + spiltChar2 + dr["DeliveryYear"].ToString() + spiltChar2 + dr["DeliveryMonth"].ToString() + spiltChar2 + dr["CommodityCategoryId"].ToString() + spiltChar2 + dr["OppSourceId"].ToString() + spiltChar2 + dr["OppTypeId"].ToString() + spiltChar2 +  dr["oppdescription"].ToString().JavaScriptStringEncode() ;
                }

                rtHtml = oppList;
                
                break;
            case "PENDINGLABORCALCUALTE":
                itemId = context.Request.QueryString["ItemId"];
                unitPrice = context.Request.Form["txtLaborUnitPrice" + itemId].AsDouble(0);
                unitSellPrice = context.Request.Form["txtLaborUnitSellPrice" + itemId].AsDouble(0);
                qty = context.Request.Form["txtLaborQty" + itemId].AsDouble(0);
                string shift = context.Request.Form["lstLaborShift" + itemId];
                double discount = context.Request.Form["txtLaborDiscount" + itemId].AsDouble(0);
                extPrice = qty * unitPrice * (1- discount/100);
                rtHtml = "R," + Util.NumberFormat(extPrice, 2, null, null, null, null);
                break;
                
            case "PENDINGMISCCALCUALTE":
                itemId = context.Request.QueryString["ItemId"];
                unitPrice = context.Request.Form["txtMiscUnitPrice" + itemId].AsDouble(0);
                unitCostPrice = context.Request.Form["txtMiscUnitCostPrice" + itemId].AsDouble(0);
                unitSellPrice = context.Request.Form["txtMiscUnitSellPrice" + itemId].AsDouble(0);
                unitPercentRate = context.Request.Form["txtMiscUnitPercentRate" + itemId].AsDouble(0);
                qty = context.Request.Form["txtMiscQty" + itemId].AsDouble(0);
                extPrice = qty * unitPrice;
                rtHtml = "R," + Util.NumberFormat(extPrice, 2, null, null, null, null);
                break;

            case "PENDINGMISCUNITPRICE":
                itemId = context.Request.QueryString["ItemId"];
                unitPrice = context.Request.Form["txtMiscUnitPrice" + itemId].AsDouble(0);
                unitCostPrice = context.Request.Form["txtMiscUnitCostPrice" + itemId].AsDouble(0);
                unitSellPrice = context.Request.Form["txtMiscUnitSellPrice" + itemId].AsDouble(0);
                unitPercentRate = context.Request.Form["txtMiscUnitPercentRate" + itemId].AsDouble(0);
                qty = context.Request.Form["txtMiscQty" + itemId].AsDouble(0);

                unitPrice = unitCostPrice * (1 + unitPercentRate / 100);
                extPrice = qty * unitPrice;
                rtHtml = "R," + Util.NumberFormat(unitPrice, 2, null, null, null, null) + spiltChar1 + Util.NumberFormat(extPrice, 2, null, null, null, null);
                break;

            //<CODE_TAG_105545>R.Z
            case "UPDATEQUOTESTATUS":
                int quoteId = Convert.ToInt32(context.Request.QueryString["QuoteId"]);
                int quoteStatusId = Convert.ToInt32(context.Request.QueryString["QuoteStatusId"]);
                int createTicket =  Convert.ToInt32(context.Request.QueryString["CreateTicket"]);
                DAL.Quote.UpdateQuoteStatusFromQuoteList(quoteId, quoteStatusId, createTicket);
                rtHtml = "OK";
                break;
            //</CODE_TAG_105545>
            default:
                break;
        }
        
        context.Response.Write(rtHtml);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}