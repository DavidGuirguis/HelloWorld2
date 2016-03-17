<%@ WebHandler Language="C#" Class="SegmentDetailAjaxHandler" %>

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


// R: Replace
// A: Alert
// P: Popup to choice
// E: Exec javascript code

public class SegmentDetailAjaxHandler : IHttpHandler
{
    string customerNo = "";
    string branchNo = "";
    string division = "";

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            context.Response.ContentType = "text/plain";
            string operation = context.Request.QueryString["OP"].ToUpper();
            string source = context.Request.QueryString["source"].ToUpper();
            string field = context.Request.QueryString["field"].ToUpper();
            int currentitemId = context.Request.QueryString["ItemID"].AsInt();
            int laborItemsCount = 0;
            
            customerNo = context.Request.QueryString["CustomerNo"];
            branchNo = context.Request.QueryString["branchNo"];
            division = context.Request.QueryString["division"];
            string rtOp = "R";
            string rtHtml = "";

            
            switch (source)
            {
				//<CODE_TAG_103467> Dav: check the SOS and Part No if we can find it in DB
				case "BULKPARTS":
					string PartNo = context.Request.QueryString["PartNo"].Trim();
					string SOS = context.Request.QueryString["SOS"].Trim();
					string itemId = context.Request.QueryString["itemId"].Trim();
					rtOp = "U," + SOS;
					rtHtml = "";
					
					DataSet dsLocalPart = DAL.Quote.QuoteListPartForCheck(SOS, PartNo);

					if (dsLocalPart.Tables[0].Rows.Count > 1 || dsLocalPart.Tables[0].Rows.Count == 0)
					{
						string sosDesc = "";
						if (dsLocalPart.Tables[1].Rows.Count == 1)
						{
							sosDesc = dsLocalPart.Tables[1].Rows[0]["sosdesc"].As<string>("").Trim();
							//SOS = dsLocalPart.Tables[1].Rows[0]["sos"].As<string>("").Trim();
						}

						rtOp = "E,"+SOS;
						rtHtml = "partSearch(" + currentitemId + ",'" + SOS + "','" + PartNo + "','" + sosDesc + "' );";
					}
					else if (dsLocalPart.Tables[0].Rows.Count == 1 && SOS == "")
					{
						SOS = dsLocalPart.Tables[0].Rows[0]["SOS"].As<string>("").Trim();
						rtOp = "U," + SOS;
						rtHtml = "";
					}
                    break;
				//</CODE_TAG_103467> Dav	
                case "LABOR":
                    laborItemsCount = context.Request.Form["hdnLaborCount"].AsInt();
                    string laborFlatRateInd = context.Request.Form["lstLaborFlatRate"];
                    bool autoLaborCalculate = context.Request.Form["chkLaborAutoCalculate"].AsString("") != "on";
                    double laborFlatRateAmountInput = context.Request.Form["txtLaborFlatRateAmount"].As("0").Replace(",", "").AsDouble();
                    double laborFlatRateQtyInput = context.Request.Form["txtLaborFlatRateQty"].As("0").Replace(",", "").AsDouble();
                    if (laborFlatRateInd == "N")
                        autoLaborCalculate = true;
                    List<Labor> allLabor = new List<Labor>();
                    for (int i = 1; i <= laborItemsCount; i++)
                    {
                        allLabor.Add(new Labor()
                        {

                            ////ItemId = i,//comment out for <CODE_TAG_101832>
                            ItemId = context.Request.Form["hidLaborItemIdFromDb" + i.ToString()].AsInt(),//<CODE_TAG_101832>
                             ItemNo = (context.Request.Form.AllKeys.Contains("hidLaborChargeCode" + i.ToString())) ? context.Request.Form["hidLaborChargeCode" + i.ToString()].Trim() : context.Request.Form["txtLaborItemNo" + i.ToString()].Trim(),
                            Quantity = context.Request.Form["txtLaborQuantity" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            //Description = context.Request.Form["txtLaborDescription" + i.ToString()],
                            Description = context.Request.Form["txtLaborDescription" + i.ToString()].ToString().Replace("'","&#39;"),  //<CODE_TAG_105636>R.Z
                            Shift = (context.Request.Form.AllKeys.Contains("lstLaborShift" + i.ToString())) ? context.Request.Form["lstLaborShift" + i.ToString()].Trim() : "",
                            UnitSellPrice = context.Request.Form["txtLaborUnitSellPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            UnitPrice = context.Request.Form["txtLaborUnitPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            Discount = context.Request.Form["txtLaborDiscount" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
 
                        
                        });
                    }
                    switch (operation)
                    {
                        case "CALCULATE":
                            break;

                        case "ADD":
                            allLabor.Add(new Labor());
                            break;

                        case "DELETE":
                            allLabor.RemoveAt(currentitemId - 1);
                            break;

                        case "IMPORTXML":
                            JSONObject AllXMLLabor = JSONObject.CreateFromString(context.Request.Form["hdnXMLLabor"]);
                            List<JSONObject> XMLLabor = AllXMLLabor.Dictionary["data"].Array.ToList<JSONObject>();
                            laborItemsCount = allLabor.Count;

                            foreach (JSONObject l in XMLLabor)
                            {
                                laborItemsCount++;
                                allLabor.Add(new Labor()
                                {
                                    ItemId = laborItemsCount,
                                    ItemNo = l.Dictionary["chargeCode"].String,
                                    Quantity = l.Dictionary["qty"].String.Replace(",", "").AsDouble(),
                                    Description = l.Dictionary["desc"].String,
                                    Shift = l.Dictionary["shift"].String,
                                    UnitSellPrice = l.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(),
                                    UnitPrice = l.Dictionary["unitPrice"].String.Replace(",", "").AsDouble(),
                                    Discount = l.Dictionary["discount"].String.Replace(",", "").AsDouble(),
                                    Lock = 0
                                });
                            }  
                            break;
                        //<CODE_TAG_101832>     
                       case "REPRICE":
                            
                            //JSONObject AllXMLLabor = JSONObject.CreateFromString(context.Request.Form["hdnXMLLabor"]);
                            JSONObject repriceRequiredLabors = JSONObject.CreateFromString(context.Request.Form["hdnXMLLabor"]);
                            //List<JSONObject> XMLLabor = AllXMLLabor.Dictionary["data"].Array.ToList<JSONObject>();
                            List<JSONObject> XMLRepriceRequiredLabors = repriceRequiredLabors.Dictionary["data"].Array.ToList<JSONObject>();
                            laborItemsCount = allLabor.Count;

 
                            /*foreach (JSONObject newLabor in XMLRepriceRequiredLabors)
                            {//foreach begin
                                int i= 0;
                                foreach (Labor oldLabor in allLabor)
                                {
                                    i++;

                                    if (newLabor.Dictionary["newLaborItemId"].String.AsInt(0) == oldLabor.ItemId)
                                    //if (newLabor.Dictionary["hidItemId" + i.ToString().Trim() ].AsInt(0) == oldLabor.ItemId)
                                    {
                                        oldLabor.ItemNo = newLabor.Dictionary["chargeCode"].String;
                                        oldLabor.Quantity = newLabor.Dictionary["qty"].String.AsDouble();
                                        oldLabor.Description = newLabor.Dictionary["desc"].String;
                                        ////oldLabor.Shift = newLabor.Dictionary["shift"].String;
                                        
                                        oldLabor.UnitSellPrice = newLabor.Dictionary["unitSellPrice"].String.AsDouble();
                                        oldLabor.UnitPrice = newLabor.Dictionary["unitPrice"].String.AsDouble();
                                        oldLabor.Discount = newLabor.Dictionary["discount"].String.AsDouble();

                                        ////oldLabor.Lock = 0; 

                                        
                                    }

                                }

                            } //foreach end */

                            //<CODE_TAG_103584>
                            int foundLabor1 = 0;


                            foreach (JSONObject newLabor in XMLRepriceRequiredLabors)
                            {
                                //int i = 0;
                                foreach (Labor oldLabor in allLabor)
                                {
                                    //i++;
                                    if (newLabor.Dictionary["newLaborItemId"].String.AsInt(0) == oldLabor.ItemId)
                                    {

                                        oldLabor.ItemNo = newLabor.Dictionary["chargeCode"].String;
                                        oldLabor.Quantity = newLabor.Dictionary["qty"].String.AsDouble();

                                        oldLabor.Description = newLabor.Dictionary["desc"].String;


                                        //oldLabor.Shift = newLabor.Dictionary["shift"].String;

                                        oldLabor.UnitSellPrice = newLabor.Dictionary["unitSellPrice"].String.AsDouble();

                                        oldLabor.UnitPrice = newLabor.Dictionary["unitPrice"].String.AsDouble();
                                        oldLabor.Discount = newLabor.Dictionary["discount"].String.AsDouble();

                                        //oldLabor.Lock = 0; 
                                        foundLabor1 = 2;

                                    }

                                }

                                if (foundLabor1 != 2)
                                {
                                    allLabor.Add(new Labor()
                                    {
                                        //ItemId = laborItemsCount,
                                        ItemNo = newLabor.Dictionary["chargeCode"].String,
                                        Quantity = newLabor.Dictionary["qty"].String.Replace(",", "").AsDouble(),
                                        Description = newLabor.Dictionary["desc"].String,
                                        //UnitCostPrice = newLabor.Dictionary["unitCostPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitSellPrice = newLabor.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(0),
                                        //UnitPercentRate = newLabor.Dictionary["pct"].String.Replace(",", "").AsDouble(0) / 100,
                                        Discount = newLabor.Dictionary["discount"].String.AsDouble()
                                        //Lock = 0


                                    });

                                    //foundLabor1 = 0;
                                }

                                foundLabor1 = 0;
                            }



                            //</CODE_TAG_103584>
                            

                            break;
                        //<CODE_TAG_101832>


                    }

                    if (rtHtml == "")
                        rtHtml = LaborUtil.GetEditHtml(allLabor, laborFlatRateInd, laborFlatRateAmountInput, laborFlatRateQtyInput, autoLaborCalculate);

                    break;

                case "MISC":
                    int miscItemsCount = context.Request.Form["hdnMiscCount"].AsInt();
                    string miscFlatRateInd = context.Request.Form["lstMiscFlatRate"];
                    bool autoMiscCalculate = context.Request.Form["chkMiscAutoCalculate"].AsString("") != "on";
                    double miscFlatRateAmountInput = context.Request.Form["txtMiscFlatRateAmount"].AsString("0").Replace(",", "").AsDouble();
                    if (miscFlatRateInd == "N")
                        autoMiscCalculate = true;
                    List<Misc> allMisc = new List<Misc>();
                    for (int i = 1; i <= miscItemsCount; i++)
                    {
                        allMisc.Add(new Misc()
                        {
                            //ItemId = i,//comment out for <CODE_TAG_101832>
                            ItemId = context.Request.Form["hidMiscItemIdFromDb" + i.ToString()].AsInt(),//<CODE_TAG_101832>
                            ItemNo = (context.Request.Form.AllKeys.Contains("hidMiscChargeCode" + i.ToString())) ? context.Request.Form["hidMiscChargeCode" + i.ToString()].Trim() : context.Request.Form["txtMiscItemNo" + i.ToString()].Trim(),
                            Quantity = context.Request.Form["txtMiscQuantity" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            //Description = context.Request.Form["txtMiscDescription" + i.ToString()],
                            Description = context.Request.Form["txtMiscDescription" + i.ToString()].ToString().Replace("'","&#39;"),  //<CODE_TAG_105636>R.Z
                            UnitPercentRate = context.Request.Form["txtMiscUnitPercentRate" + i.ToString()].AsString("").Replace(",", "").AsDouble(0)/100,
                            UnitCostPrice = context.Request.Form["txtMiscUnitCostPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            UnitSellPrice = context.Request.Form["txtMiscUnitSellPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            UnitPrice = context.Request.Form["txtMiscUnitPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            Discount = context.Request.Form["txtMiscDiscount" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                            Lock = context.Request.Form["hdnMiscLock" + i.ToString()].AsInt(),
                            UnitPriceLock = (context.Request.Form["chkUnitPriceLock" + i.ToString()].AsString("") == "on") ? 2 : 1
                        });
                    }
                    switch (operation)
                    {
                        case "CALCULATE":
                            break;

                        case "ADD":
                            allMisc.Add(new Misc());
                            break;

                        case "DELETE":
                            allMisc.RemoveAt(currentitemId - 1);
                            break;
                        case "CALCULATEUNITPRICE":
                            Misc curMisc = allMisc[currentitemId - 1];
                            //<CODE_TAG_103316>
                            //if (curMisc.UnitPercentRate != 0) //!! Victor Erlich Oct 16, 2013 for toromont
                            //if (curMisc.UnitPercentRate != 0  && curMisc.UnitCostPrice!= 0) //!! Victor Erlich Oct 16, 2013 for toromont //<CODE_TAG_103808>
							if (curMisc.UnitCostPrice!= 0) // Victor Wang 2015-4-9 
                                curMisc.UnitSellPrice = curMisc.UnitCostPrice * (curMisc.UnitPercentRate + 1);
                            //</CODE_TAG_103316>
                            //if (!curMisc.IsUnitPriceLocked)
                            if (!curMisc.IsUnitPriceLocked && curMisc.UnitCostPrice!= 0)  //<CODE_TAG_103808>
                            {
                                curMisc.UnitPrice = curMisc.UnitSellPrice;
                            }
                            break;

                        case "IMPORTXML":
                            JSONObject AllXMLMisc = JSONObject.CreateFromString(context.Request.Form["hdnXMLMisc"]);
                            List<JSONObject> XMLMisc = AllXMLMisc.Dictionary["data"].Array.ToList<JSONObject>();
                            miscItemsCount = allMisc.Count;

                            foreach (JSONObject m in XMLMisc)
                            {
                                miscItemsCount++;

                                /*allMisc.Add(new Misc()
                                {
                                    ItemId = miscItemsCount,
                                    ItemNo = m.Dictionary["chargeCode"].String,
                                    Quantity = m.Dictionary["qty"].String.Replace(",", "").AsDouble(),
                                    Description = m.Dictionary["desc"].String,
                                    UnitCostPrice = m.Dictionary["unitCostPrice"].String.Replace(",", "").AsDouble(0),
                                    UnitSellPrice = m.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(0),
                                    UnitPrice = m.Dictionary["unitPrice"].String.Replace(",", "").AsDouble(0),
                                    UnitPercentRate = m.Dictionary["pct"].String.Replace(",", "").AsDouble(0) / 100,
                                    Lock = 0
                                });*/

                                //<CODE_TAG_103584>
                                int foundMisc = 0;
                                foreach (var misc in  allMisc )
                                {
                                    //if (m.DBid == misc.dbId)
                                    //if (m.newMiscItemId == misc.ItemId)
                                    if (m.Dictionary["newMiscItemId"].AsInt() == misc.ItemId)
                                    {
                                      //misc = m;
                                        misc.ItemNo = m.Dictionary["chargeCode"].String;
                                        misc.Quantity = m.Dictionary["qty"].String.Replace(",", "").AsDouble();
                                        misc.Description = m.Dictionary["desc"].String;
                                        misc.UnitCostPrice = m.Dictionary["unitCostPrice"].String.Replace(",", "").AsDouble(0);
                                        misc.UnitSellPrice = m.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(0);
                                        misc.UnitPrice = m.Dictionary["unitPrice"].String.Replace(",", "").AsDouble(0);
                                        misc.UnitPercentRate = m.Dictionary["pct"].String.Replace(",", "").AsDouble(0) / 100;
                                        foundMisc = 2;
                                    }  
                                }

                                if (foundMisc != 2)
                                {
                                    allMisc.Add(new Misc()
                                    {
                                        ItemId = miscItemsCount,
                                        ItemNo = m.Dictionary["chargeCode"].String,
                                        Quantity = m.Dictionary["qty"].String.Replace(",", "").AsDouble(),
                                        Description = m.Dictionary["desc"].String,
                                        UnitCostPrice = m.Dictionary["unitCostPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitSellPrice = m.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitPrice = m.Dictionary["unitPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitPercentRate = m.Dictionary["pct"].String.Replace(",", "").AsDouble(0)/100,
                                        Lock = 0
                                    });
                                }
                                //</CODE_TAG_103584>
                            }
                            break;

                        //<CODE_TAG_101832>     
                        case "REPRICE":

                            //JSONObject AllXMLLabor = JSONObject.CreateFromString(context.Request.Form["hdnXMLLabor"]);
                            JSONObject repriceRequiredMiscs = JSONObject.CreateFromString(context.Request.Form["hdnXMLMisc"]);
                            //List<JSONObject> XMLLabor = AllXMLLabor.Dictionary["data"].Array.ToList<JSONObject>();
                            List<JSONObject> XMLRepriceRequiredMiscs = repriceRequiredMiscs.Dictionary["data"].Array.ToList<JSONObject>();
                            miscItemsCount = allMisc.Count;


                            /*foreach (JSONObject newMisc in XMLRepriceRequiredMiscs)
                            {
                                foreach (Misc oldMisc in allMisc)
                                {
                                    if (newMisc.Dictionary["newMiscItemId"].String.AsInt(0) == oldMisc.ItemId)
                                    {
                                        oldMisc.ItemNo = newMisc.Dictionary["chargeCode"].String;
                                        oldMisc.Quantity = newMisc.Dictionary["qty"].String.AsDouble();

                                        oldMisc.Description = newMisc.Dictionary["desc"].String;
                                        //oldMisc.Shift = newLabor.Dictionary["Shift"].String;
                                        oldMisc.UnitCostPrice = newMisc.Dictionary["unitCostPrice"].String.AsDouble();
                                        oldMisc.UnitSellPrice = newMisc.Dictionary["unitSellPrice"].String.AsDouble();
                                        oldMisc.UnitPrice = newMisc.Dictionary["unitPrice"].String.AsDouble();
                                        //oldMisc.Discount = newLabor.Dictionary["Discount"].AsDouble();
                                        oldMisc.UnitPercentRate = newMisc.Dictionary["pct"].String.AsDouble();
                                        //oldMisc.Lock = 0;

                                    }

                                }

                            }*/
                            //<CODE_TAG_103584>
                            int foundMisc1 = 0;
                            foreach (JSONObject newMisc in XMLRepriceRequiredMiscs)
                            {
                                foreach (Misc oldMisc in allMisc)
                                {
                                    if (newMisc.Dictionary["newMiscItemId"].String.AsInt(0) == oldMisc.ItemId)
                                    {
                                        oldMisc.ItemNo = newMisc.Dictionary["chargeCode"].String;
                                        oldMisc.Quantity = newMisc.Dictionary["qty"].String.AsDouble();

                                        oldMisc.Description = newMisc.Dictionary["desc"].String;
                                        //oldMisc.Shift = newLabor.Dictionary["Shift"].String;
                                        oldMisc.UnitCostPrice = newMisc.Dictionary["unitCostPrice"].String.AsDouble();
                                        oldMisc.UnitSellPrice = newMisc.Dictionary["unitSellPrice"].String.AsDouble();
                                        oldMisc.UnitPrice = newMisc.Dictionary["unitPrice"].String.AsDouble();
                                        //oldMisc.Discount = newLabor.Dictionary["Discount"].AsDouble();
                                        oldMisc.UnitPercentRate = newMisc.Dictionary["pct"].String.AsDouble();
                                        //oldMisc.Lock = 0;
                                        foundMisc1 = 2;
                                    }


                                }
                                if (foundMisc1 != 2)
                                {
                                    allMisc.Add(new Misc()
                                    {
                                        //ItemId = miscItemsCount,
                                        ItemNo = newMisc.Dictionary["chargeCode"].String,
                                        Quantity = newMisc.Dictionary["qty"].String.Replace(",", "").AsDouble(),
                                        Description = newMisc.Dictionary["desc"].String,
                                        UnitCostPrice = newMisc.Dictionary["unitCostPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitSellPrice = newMisc.Dictionary["unitSellPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitPrice = newMisc.Dictionary["unitPrice"].String.Replace(",", "").AsDouble(0),
                                        UnitPercentRate = newMisc.Dictionary["pct"].String.Replace(",", "").AsDouble(0) / 100,
                                        Lock = 0
                                    });

                                    foundMisc1 = 0;
                                }

                            }


                            //</CODE_TAG_103584>
                            break;
                        //<CODE_TAG_101832>
                    }

                    if (rtHtml == "")
                        rtHtml = MiscUtil.GetEditHtml(allMisc, miscFlatRateInd, miscFlatRateAmountInput, autoMiscCalculate);

                    break;

                default:

                    string errorCode = "";
                    string errorMessage = "";

                    int partItemsCount = context.Request.Form["hdnPartsCount"].AsInt();
                    Part currentPart;
                    List<Part> allParts = new List<Part>();
                    string partFlatRateInd = context.Request.Form["lstPartFlatRate"];
                    double partFlatRateAmountInput = context.Request.Form["txtPartFlatRateAmount"].AsString("0").Replace(",", "").AsDouble(0);
                    bool autoPartsCalculate = context.Request.Form["chkPartsAutoCalculate"].AsString("") != "on";
                    if (partFlatRateInd == "N")
                        autoPartsCalculate = true;
                    for (int i = 1; i <= partItemsCount; i++)
                    {
                        Part p = new Part()
                         {
                             ItemId = i,
                             SOS = context.Request.Form["txtPartSOS" + i.ToString()].Trim(),
                             PartNo = context.Request.Form["txtPartNo" + i.ToString()].Trim().ToUpper(),
                             Quantity = context.Request.Form["txtPartQuantity" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                             //Description = context.Request.Form["txtPartDescription" + i.ToString()],
                             Description = context.Request.Form["txtPartDescription" + i.ToString()].ToString().Replace("'","&#39;"),  //<CODE_TAG_105636>R.Z
                             UnitSellPrice = context.Request.Form["txtPartUnitSellPrice" + i.ToString()].Replace(",", "").AsDouble(),
                             UnitDiscPrice = context.Request.Form["txtPartUnitDiscPrice" + i.ToString()].Replace(",", "").AsDouble(),
                             NetSellPrice = context.Request.Form["txtPartNetSellPrice" + i.ToString()].Replace(",", "").AsDouble(),
                             UnitPrice = context.Request.Form["txtPartUnitPrice" + i.ToString()].Replace(",", "").AsDouble(),
                             Discount = context.Request.Form["txtPartDiscount" + i.ToString()].Replace(",", "").AsDouble(),
                             CoreItemId = context.Request.Form["txtPartCoreItemId" + i.ToString()].AsInt(),
                             UnitWeight = context.Request.Form["txtPartUnitWeight" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                             AvailableQty = context.Request.Form["txtPartAvailableQty" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                             QtyOnhand = context.Request.Form["hdnQtyOnhand" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                             Lock = context.Request.Form["hdnPartLock" + i.ToString()].AsInt()
                         };

                        int boCount = context.Request.Form["hdnBoCount" + i.ToString()].AsInt();
                        for (int j = 0; j < boCount; j++)
                        {
                            BackOrder bo = new BackOrder();
                            bo.BoFacCode = context.Request.Form["hdnBoFacCode" + i + "_" + j].Trim();
                            bo.BoFacName = context.Request.Form["hdnBoFacName" + i + "_" + j].Trim();
                            bo.BoFacType = context.Request.Form["hdnBoFacType" + i + "_" + j].Trim();
                            bo.BoQty = context.Request.Form["hdnBoQty" + i + "_" + j].AsInt();

                            if (p.BackOrders == null)
                                p.BackOrders = new List<BackOrder>();
                            p.BackOrders.Add(bo);
                        }


                        allParts.Add(p);

                    }
                    switch (operation)
                    {
                        case "REFRESHCATPRICE":

                            currentPart = allParts[currentitemId - 1];

                            //check the SOS and Part No if we can find it in DB
                            //<CODE_TAG_102277>
                            if (currentPart.PartNo != "" && !currentPart.IsCorePart ) 
                            {
                            //<CODE_TAG_102277>
                                DataSet dsPart = DAL.Quote.QuoteListPartForCheck(currentPart.SOS, currentPart.PartNo);
                            
                                if (dsPart.Tables[0].Rows.Count == 1)
                                {
                                    DataRow drPart = dsPart.Tables[0].Rows[0];
                                    currentPart.SOS = drPart["SOS"].ToString();
                                    currentPart.PartNo = drPart["PartNo"].ToString();
                              
                                    //get data
                                    List<PartPrice> partPriceList = PartPriceProxy.GetPartPrice(division, customerNo, branchNo, new PartIdentifier { PartNo = currentPart.PartNo, SOS = currentPart.SOS, Qty = currentPart.Quantity.AsInt() }); //2M5656,  2753581

                                    if (partPriceList.Count > 0)
                                    {
                                        if (partPriceList[0].ErrorCode != "")
                                        {
                                            rtOp = "A";
                                            //rtHtml = "Could not get part:" + currentPart.PartNo + " SOS:" + currentPart.SOS + " Price, detail message: " + partPriceList[0].ErrorMessage;
                                            rtHtml = "Could not get part : " + currentPart.PartNo.Trim() + "\n\rSOS : " + currentPart.SOS.Trim() + "\n\rError detail : " + partPriceList[0].ErrorMessage; //<Ticket 26962>
                                        }
                                        else
                                        {
                                            if ((partPriceList[0].ReplacementsFound || partPriceList[0].AlternatesFound) && field != "QUANTITY")
                                            {
                                                rtOp = "P";

                                                rtHtml = GetChoicePartsHtml(currentitemId, partPriceList[0]);
                                            }
                                            else
                                            {
                                                if (currentPart.HasCorePart)
                                                    allParts.RemoveAt(allParts[currentitemId - 1].CoreItemId - 1);

                                                currentPart.Description = partPriceList[0].PartDesc;
                                                currentPart.UnitSellPrice = partPriceList[0].UnitSell.Value;
                                                currentPart.UnitDiscPrice = partPriceList[0].UnitDisc.Value;
                                                currentPart.NetSellPrice = partPriceList[0].UnitNet.Value;
                                            
                                                //currentPart.UnitPrice = partPriceList[0].UnitNet.Value;
                                                currentPart.UnitPrice = partPriceList[0].UnitSell.Value - partPriceList[0].UnitDisc.Value; //<CODE_TAG_102215> Victor20130920

                                                currentPart.UnitWeight = partPriceList[0].UnitWeight;
                                                currentPart.AvailableQty = partPriceList[0].AvailableQty;
                                                currentPart.QtyOnhand = partPriceList[0].QtyOnhand;
                                                currentPart.BackOrders = null;
                                                BackOrder bo;
                                                if (partPriceList[0].BackOrders != null)
                                                {
                                                    foreach (BoInfo b in partPriceList[0].BackOrders)
                                                    {
                                                        bo = new BackOrder() { BoFacCode = b.BoFacCode, BoFacName = b.BoFacName, BoFacType = b.BoFacType, BoQty = b.BoQty };
                                                        if (currentPart.BackOrders == null)
                                                            currentPart.BackOrders = new List<BackOrder>();
                                                        currentPart.BackOrders.Add(bo);
                                                    }
                                                }
                                                //<CODE_TAG_101775>
                                               // if (currentPart.Quantity == 0)
                                               //     currentPart.Quantity = 1;
                                                //</CODE_TAG_101775>
                                                if (partPriceList[0].CoreUnitSell != 0)
                                                {
                                                    var corePart = new Part();
                                                    {
                                                        corePart.ItemId = currentPart.ItemId + 1;
                                                        corePart.SOS = currentPart.SOS;
                                                        corePart.PartNo = currentPart.PartNo;
                                                        corePart.Quantity = currentPart.Quantity;
                                                        corePart.Description = currentPart.Description;
                                                        corePart.UnitPrice = partPriceList[0].CoreUnitSell.Value;
                                                        corePart.UnitSellPrice = partPriceList[0].CoreUnitSell.Value;
                                                        corePart.NetSellPrice = partPriceList[0].CoreUnitSell.Value;
                                                        corePart.CoreItemId = corePart.ItemId;
                                                        corePart.UnitWeight = 0;
                                                        corePart.AvailableQty = 0;
                                                    }
                                                    allParts.Insert(corePart.ItemId - 1, corePart);
                                                    //<CODE_TAG_103442>
                                                    /*for (int i = corePart.ItemId; i < allParts.Count; i++)
                                                    {
                                                        allParts[i].ItemId++;
                                                        if (allParts[i].HasCorePart)
                                                            allParts[i].CoreItemId++;
                                                    }*/
                                                    //</CODE_TAG_103442>
                                                    currentPart.CoreItemId = corePart.ItemId;


                                                }
                                                else
                                                {
                                                    currentPart.CoreItemId = 0;
                                                }

                                            }
                                        }
                                    }
                                    else
                                    {
                                        rtOp = "A";
                                        rtHtml = "Could not get part " + currentPart.PartNo + " SOS:" + currentPart.SOS + " Price, Unexpected server error occurred, Please try again later.";
                                    }

                                } // only one part by check
                                else
                                {
                                    string sosDesc = "";
                                    if (dsPart.Tables[1].Rows.Count == 1)
                                        sosDesc = dsPart.Tables[1].Rows[0]["sosdesc"].ToString();

                                    rtOp = "E";
                                    rtHtml = "partSearch(" + currentitemId + ",'" + currentPart.SOS + "','" + currentPart.PartNo + "','" + sosDesc + "' );";
                                }
                            
                            }//<CODE_TAG_102277>
                            
                            break;

                        case "UPDATEPART":
                            JSONObject AllSelectedParts = JSONObject.CreateFromString(context.Request.Form["hdnXMLParts"]);
                            List<JSONObject> SelectedParts = AllSelectedParts.Dictionary["data"].Array.ToList<JSONObject>();
                            if (SelectedParts.Count > 0)
                            {
                                var currentSelectedId = 0;

                                foreach (JSONObject p in SelectedParts)
                                {
                                    if (currentSelectedId == 0)
                                    {
                                        if (allParts[currentitemId - 1].HasCorePart)
                                            allParts.RemoveAt(allParts[currentitemId - 1].CoreItemId - 1);

                                        allParts[currentitemId - 1] = new Part(currentitemId, p);
                                        currentSelectedId = currentitemId - 1 + 1;
                                    }
                                    else
                                    {
                                        InsertPart(ref allParts, p, currentSelectedId);
                                        currentSelectedId = currentSelectedId + 1;
                                    }

                                    if (p.Dictionary["COREPRICE"].String.AsDouble() != 0)
                                    {
                                        var mainPart = allParts[currentSelectedId - 1];
                                        var corePart = new Part();
                                        corePart.ItemId = currentSelectedId + 1;
                                        corePart.SOS = mainPart.SOS;
                                        corePart.PartNo = mainPart.PartNo;
                                        corePart.Quantity = mainPart.Quantity;
                                        corePart.Description = mainPart.Description;
                                        corePart.UnitPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                        corePart.UnitSellPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                        corePart.NetSellPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                        corePart.CoreItemId = corePart.ItemId;
                                        corePart.UnitWeight = 0;
                                        corePart.AvailableQty = 0;
                                        mainPart.CoreItemId = corePart.ItemId;

                                        InsertPart(ref allParts, corePart, currentSelectedId);
                                        currentSelectedId++;
                                    }
                                }
                            }

                            break;

                        case "CALCULATE":
                            if (currentitemId < 1) break;
                            currentPart = allParts[currentitemId - 1];
                            if (currentPart.HasCorePart && !AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.CorePart.Qty.Enabled"))
                            {
                                int corePartItemId = currentPart.CoreItemId;
                                allParts[corePartItemId - 1].Quantity = currentPart.Quantity;
                            }
                            break;

                        case "ADD":
                            allParts.Add(new Part());
                            break;

                        case "DELETE":
                        //<CODE_TAG_103313> 
                            //Delete a core part, need to update main part.
                            if (allParts[currentitemId - 1].IsCorePart)
                            {
                                foreach (Part p in allParts)
                                {
                                    if (p.ItemId != currentitemId && p.CoreItemId == currentitemId )
                                    {
                                        p.CoreItemId = 0;   
                                    }
                                }
                            }
                            // delete a main part, need to delete core part first.

                            int deleteCount = 1;
                            if (allParts[currentitemId - 1].HasCorePart)
                            {
                                allParts.RemoveAt(allParts[currentitemId - 1].CoreItemId - 1);
                                deleteCount ++;
                            }
                            
                            allParts.RemoveAt(currentitemId - 1);
                            
                            //Need update corepart point
                            foreach (Part p in allParts)
                            {
                                if (p.ItemId  >= currentitemId)
                                {
                                    p.ItemId-= deleteCount;
                                    if (p.HasCorePart && p.CoreItemId >= currentitemId) p.CoreItemId-=deleteCount;
                                }
                            }
                            //</CODE_TAG_103313> 
                             
                            
                            break;

                        case "IMPORTXML":
                            JSONObject AllXMLParts = JSONObject.CreateFromString(context.Request.Form["hdnXMLParts"]);
                            List<JSONObject> XMLParts = AllXMLParts.Dictionary["data"].Array.ToList<JSONObject>();

                            foreach (JSONObject p in XMLParts)
                            {
                                partItemsCount++;
                                allParts.Add(new Part(partItemsCount, p));

                                if (p.Dictionary["COREPRICE"].String.AsDouble() > 0)
                                {
                                    currentPart = allParts[allParts.Count - 1];
                                    var corePart = new Part();
                                    corePart.ItemId = currentPart.ItemId + 1;
                                    corePart.SOS = currentPart.SOS;
                                    corePart.PartNo = currentPart.PartNo;
                                    corePart.Quantity = currentPart.Quantity;
                                    corePart.Description = currentPart.Description;
                                    corePart.UnitPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                    corePart.UnitSellPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                    corePart.NetSellPrice = p.Dictionary["COREPRICE"].String.AsDouble(0);
                                    corePart.CoreItemId = corePart.ItemId;
                                    corePart.UnitWeight = 0;
                                    corePart.AvailableQty = 0;
                                    currentPart.CoreItemId = corePart.ItemId;

                                    partItemsCount++;
                                    allParts.Add(corePart);
                                }
                            }
                            break;

                        case "REFRESHALLPARTSAVAILABILITY":
                            allParts = refreshAllParts(allParts, 1, out errorCode, out errorMessage);
                            break;

                        case "REFRESHALLPARTSPRICE":
                            allParts = refreshAllParts(allParts, 2, out errorCode, out errorMessage);
                            break;

                        case "REFRESHALLPARTSPRICEANDAVAILABILITY":
                            allParts = refreshAllParts(allParts, 3, out errorCode, out errorMessage);
                            break;
                        //<CODE_TAG_105845> lwang
                        case "REFRESHALLPARTSDISCOUNT":
                            if (allParts.Count < 1) break;
                            Double partDiscount = context.Request.QueryString["PartsDiscount"].AsDouble();
                            foreach (Part p in allParts)
                            {
                                p.Discount = partDiscount;
                            }
                            break;
                        //</CODE_TAG_105845> lwang
                        default:
                            break;
                    }

                    if (errorCode != "")
                    {
                        rtOp = "A";
                        rtHtml = "Could not get parts Price, Error Code:" + errorCode + ", Error Message:" + errorMessage;
                    }

                    if (rtHtml == "")
                        rtHtml = PartUtil.GetEditHtml(allParts, partFlatRateInd, partFlatRateAmountInput, autoPartsCalculate);
                    
                    break;

            }
            context.Response.Write(rtOp + "," + rtHtml);
        }
        catch (Exception ex)
        {
            context.Response.Write("A" + "," + "Couldnot handle it, detail message: " + ex.ToString());
        }

    }

    private void InsertPart(ref List<Part> allParts, JSONObject p, int currentitemId)
    {
        allParts.Insert(currentitemId, new Part(currentitemId + 1, p));
    }

    private void InsertPart(ref List<Part> allParts, Part p, int currentitemId)
    {
        allParts.Insert(currentitemId, p);
    }

    private string GetChoicePartsHtml(int itemId, PartPrice part)
    {
        var sClass = "";

        //Header
        StringBuilder sbHtml = new StringBuilder();
        sbHtml.Append("<table width='100%' cellpadding=2 cellspacing=1 border-spacing='2px'>");
        sbHtml.Append("<tr>");
        sbHtml.Append("<td colspan='5'> Current Part: </td>");
        sbHtml.Append("</tr>");
        // current Part

        sbHtml.Append("<tr class='reportHeader'>");
        sbHtml.Append("<td>SOS</td>");
        sbHtml.Append("<td>Part No</td>");
        sbHtml.Append("<td>Description</td>");
        sbHtml.Append("<td class='tAc'>Unit Sell</td>");
        sbHtml.Append("<td class='tAc'>Unit Disc</td>");
        sbHtml.Append("<td class='tAc'>Net Sell</td>");
        sbHtml.Append("<td class='tAc'>Unit Price</td>");
        if (part.ReplacementsFound)
        {
            sbHtml.Append("<td></td>");
            sbHtml.Append("<td></td>");
        }
        sbHtml.Append("<td class='tAc'>Core</td>");
        sbHtml.Append("<td></td>");
        sbHtml.Append("</tr>");

        sbHtml.Append("<tr class='rl'>");
        sbHtml.Append("<td>" + part.Sos + "</td>");
        sbHtml.Append("<td>" + part.PartNo + "</td>");
        sbHtml.Append("<td>" + part.PartDesc + "</td>");
        sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.UnitSell, 2, null, null, null, null) + "</td>");
        sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.UnitDisc, 2, null, null, null, null) + "</td>");
        sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.UnitNet, 2, null, null, null, null) + "</td>");
        sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.UnitSell - part.UnitDisc, 2, null, null, null, null) + "</td>"); //<CODE_TAG_102215> Victor20130920
        if (part.ReplacementsFound)
        {
            sbHtml.Append("<td></td>");
            sbHtml.Append("<td></td>");
        }
        if (part.CoreUnitSell > 0)
            sbHtml.Append("<td class='tAc'>Y</td>");
        else
            sbHtml.Append("<td></td>");

        sbHtml.Append("<td><input type='radio'  name='priceChoiceItem' id='priceChoiceItem_Current' value='0' itemId='" + itemId + "' partData='" + PartUtil.BuildPartJsonData(part) + "' onclick='popReplacePartSelect(0);' " + ((part.ReplacementsFound) ? "" : "checked='true'") + "  /></td>");


        sbHtml.Append("</tr>");



        if (part.ReplacementsFound)
        {
            //Replacement Parts        
            sbHtml.Append("<tr>");
            sbHtml.Append("<td colspan='5'> Replacement Parts: </td>");
            sbHtml.Append("</tr>");
            sbHtml.Append("<tr class='reportHeader'>");
            sbHtml.Append("<td>SOS</td>");
            sbHtml.Append("<td>Part No</td>");
            sbHtml.Append("<td>Description</td>");
            sbHtml.Append("<td class='tAc'>Unit Sell</td>");
            sbHtml.Append("<td class='tAc'>Unit Disc</td>");
            sbHtml.Append("<td class='tAc'>Net Sell</td>");
            sbHtml.Append("<td class='tAc'>Unit Price</td>");
            sbHtml.Append("<td class='tAc'>Qty</td>");
            sbHtml.Append("<td class='tAc'>Availability</td>");
            sbHtml.Append("<td class='tAc'>Core</td>");
            if (part.Replacements.Length > 0)
                sbHtml.Append("<td>" + "<input type='radio' name='priceChoiceItem' id='priceChoiceItem_Replace' value='1' onclick='popReplacePartSelect(1);' checked='true' /></td>");
            else
                sbHtml.Append("<td></td>");

            sbHtml.Append("</tr>");


            var itemchecked = "";
            var indirectFlag = "";

            if (part.Replacements.Length == 0)
            {
                sbHtml.Append("<tr><td colspan='10'>Replacement parts found, but there are no details available.</td></tr>");
            }
            else
            {
                for (var i = 0; i < part.Replacements.Length; i++)
                {
                    sClass = (i % 2 == 0) ? "rl" : "rd";
                    sbHtml.Append("<tr class='" + sClass + "'>");
                    sbHtml.Append("<td>" + part.Replacements[i].Sos + "</td>");
                    sbHtml.Append("<td>" + part.Replacements[i].PartNo + "</td>");
                    sbHtml.Append("<td>" + part.Replacements[i].PartDesc + "</td>");
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Replacements[i].UnitSell, 2, null, null, null, null) + "</td>");   //TODO Config 
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Replacements[i].UnitDisc, 2, null, null, null, null) + "</td>");   //TODO Config
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Replacements[i].UnitNet, 2, null, null, null, null) + "</td>");   //TODO Config
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Replacements[i].UnitSell - part.Replacements[i].UnitDisc , 2, null, null, null, null) + "</td>");  //<CODE_TAG_102215>  Victor20130920  //<CODE_TAG_101756> //Victor 20130619
                    sbHtml.Append("<td class='tAr'>" + part.Replacements[i].Qty + "</td>");
                    if (part.Replacements[i].FactoryFlag == "RPLCAT")
                    {
                        indirectFlag = "Y";
                        itemchecked = "";
                        sbHtml.Append("<td nowrap='nowrap'>Indirect Replacement Contact Dealer</td>");
                    }
                    else
                    {
                        indirectFlag = "N";
                        itemchecked = "checked='true'";
                        sbHtml.Append("<td></td>");
                    }
                    if (part.CoreUnitSell > 0)
                        sbHtml.Append("<td class='tAc'>Y</td>");
                    else
                        sbHtml.Append("<td></td>");
                    sbHtml.Append("<td><input id='chkReplace_" + i + "' indirectFlag='" + indirectFlag + "'  value='' partData='" + PartUtil.BuildPartJsonData(part.Replacements[i]) + "' " + itemchecked + "   type='checkbox' /></td>");
                    sbHtml.Append("</tr>");

                }
            }
        }
        //Alter Part
        if (part.AlternatesFound)
        {
            //Alter Parts        
            sbHtml.Append("<tr>");
            sbHtml.Append("<td colspan='5'> Alternate Parts: </td>");
            sbHtml.Append("</tr>");
            sbHtml.Append("<tr class='reportHeader'>");
            sbHtml.Append("<td>SOS</td>");
            sbHtml.Append("<td>Part No</td>");
            sbHtml.Append("<td>Description</td>");
            sbHtml.Append("<td class='tAc'>Unit Sell</td>");
            sbHtml.Append("<td class='tAc'>Unit Disc</td>");
            sbHtml.Append("<td class='tAc'>Net Sell</td>");
            sbHtml.Append("<td class='tAc'>Unit Price</td>");
            sbHtml.Append("<td class='tAc'>Core</td>");
            sbHtml.Append("<td></td>");
            sbHtml.Append("</tr>");

            if (part.Alternates.Length == 0)
            {
                sbHtml.Append("<tr><td colspan='10'>Alternate parts found, but there are no details available.</td></tr>");
            }
            else
            {
                for (var i = 0; i < part.Alternates.Length; i++)
                {
                    sClass = (i % 2 == 0) ? "rl" : "rd";
                    sbHtml.Append("<tr class='" + sClass + "'>");
                    sbHtml.Append("<td>" + part.Alternates[i].Sos + "</td>");
                    sbHtml.Append("<td>" + part.Alternates[i].PartNo + "</td>");
                    sbHtml.Append("<td>" + part.Alternates[i].PartDesc + "</td>");
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Alternates[i].UnitSell, 2, null, null, null, null) + "</td>");
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Alternates[i].UnitDisc, 2, null, null, null, null) + "</td>");
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Alternates[i].UnitNet, 2, null, null, null, null) + "</td>");
                    sbHtml.Append("<td class='tAr'>" + Util.NumberFormat(part.Alternates[i].UnitSell - part.Alternates[i].UnitDisc , 2, null, null, null, null) + "</td>"); //<CODE_TAG_102215> Victor20130920 //<CODE_TAG_101756> Victor 2013-06-19
                    if (part.CoreUnitSell > 0)
                        sbHtml.Append("<td class='tAc'>Y</td>");
                    else
                        sbHtml.Append("<td></td>");
                    sbHtml.Append("<td > <input type='radio' name='priceChoiceItem' id='priceChoiceItem_Alter" + i.ToString() + "' partData='" + PartUtil.BuildPartJsonData(part.Alternates[i]) + "' /></td>");
                    sbHtml.Append("</tr>");

                }
            }
        }

        //Footer
        sbHtml.Append("</table>");
        return sbHtml.ToString();
    }

    // refreshType :  1-Availability 2-price 3-Availability and price
    private List<Part> refreshAllParts(List<Part> allParts, int refreshType, out string errorCode, out string errorMessage)
    {
        int batch_Count = 0;
        int offset = 0;
        List<PartPrice> partPrices = new List<PartPrice>();
        errorCode = "";
        errorMessage = ""; 
        List<PartIdentifier> PartIdentifiers = new List<PartIdentifier>();
        for (int i = 0; i < allParts.Count; i++)
        {
            PartIdentifier p = new PartIdentifier();
            if (allParts[i].PartNo.Trim() != "")
            {
                p.PartNo = allParts[i].PartNo;

                if (allParts[i].SOS.IsNullOrWhiteSpace())
                {   p.SOS = AppContext.Current.AppSettings["psQuoter.Quote.SOS.Default"];}
                else
                {   p.SOS = allParts[i].SOS; }

                p.Qty = allParts[i].Quantity.AsInt();
                if (p.Qty < 0) p.Qty = Math.Abs(p.Qty); //<CODE_TAG_103396>
                PartIdentifiers.Add(p);

            }
            batch_Count++;
            
            if (batch_Count >= 20 || i + 1 >= allParts.Count)
            {
                partPrices = PartPriceProxy.GetPartPrice(division, customerNo, branchNo, PartIdentifiers);
                int j = 0;

                foreach (PartPrice pp in partPrices)
                {

                    while (allParts[j + offset].PartNo.Trim() == "" && (j + offset) < allParts.Count)
                    {
                        j++;
                    }
                   
                    
                    if (!pp.ErrorCode.IsNullOrWhiteSpace())
                    {
                        if (partPrices.Count != PartIdentifiers.Count)
                        {
                            errorCode = pp.ErrorCode;
                            errorMessage = pp.ErrorMessage;
                        }
                        
                    }
                    else
                    {
                        if (!allParts[j + offset].IsCorePart)
                        {
                            if (allParts[j + offset].IsLocked)
                            {
                                j++;
                                continue;
                            }
                            
                            if (refreshType == 2 || refreshType == 3)
                            {
                                allParts[j + offset].UnitSellPrice = pp.UnitSell.GetValueOrDefault();
                                
                                allParts[j + offset].UnitPrice = pp.UnitSell.GetValueOrDefault() -  pp.UnitDisc.GetValueOrDefault();   //pp.UnitNet.GetValueOrDefault();//<CODE_TAG_102215> Victor20130920
                                allParts[j + offset].UnitDiscPrice = pp.UnitDisc.GetValueOrDefault();
                                allParts[j + offset].NetSellPrice = pp.UnitNet.GetValueOrDefault();
                                allParts[j + offset].UnitWeight = pp.UnitWeight;

                                if (allParts[j + offset].HasCorePart)
                                {
                                    var coreItemId = allParts[j + offset].CoreItemId;
                                    allParts[coreItemId - 1].UnitSellPrice = pp.CoreUnitSell.GetValueOrDefault();
                                    allParts[coreItemId - 1].UnitPrice = pp.CoreUnitSell.GetValueOrDefault();
                                    //allParts[coreItemId - 1].UnitDiscPrice = pp.CoreUnitSell.GetValueOrDefault();
                                    allParts[coreItemId - 1].UnitDiscPrice = pp.UnitDisc.GetValueOrDefault();  //<CODE_TAG_104000>
                                    allParts[coreItemId - 1].NetSellPrice = pp.CoreUnitSell.GetValueOrDefault();
                                    
                                }

                            }
                            if (refreshType == 1 || refreshType == 3)
                            {
                                allParts[j + offset].QtyOnhand = pp.QtyOnhand;
                                allParts[j + offset].AvailableQty = pp.AvailableQty;
                                allParts[j + offset].BackOrders = null;
                                BackOrder bo;
                                if (pp.BackOrders != null)
                                {
                                    foreach (BoInfo b in pp.BackOrders)
                                    {
                                        bo = new BackOrder() { BoFacCode = b.BoFacCode, BoFacName = b.BoFacName, BoFacType = b.BoFacType, BoQty = b.BoQty };
                                        if (allParts[j + offset].BackOrders == null)
                                            allParts[j + offset].BackOrders = new List<BackOrder>();
                                        allParts[j + offset].BackOrders.Add(bo);
                                    }
                                }
                            }
                        }


                    }
                    j++;
                }
                PartIdentifiers = new List<PartIdentifier>();
                batch_Count = 0;
                offset = i + 1;
            }
        }

        return allParts;

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}

