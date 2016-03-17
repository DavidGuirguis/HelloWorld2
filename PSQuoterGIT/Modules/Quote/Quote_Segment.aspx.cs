using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;
using MenuItem = X.Web.Entities.MenuItem;
using MenuItemGroup = X.Web.Entities.MenuItemGroup;
using Helpers;
using System.Text;

public partial class Modules_Quote_Segment : UI.Abstracts.Pages.ReportViewPage  
{
    protected int QuoteId;
    protected int Revision;
    protected int PageMode = 2;
    protected int SegmentId;
    protected int DefaultSegmentId;
    protected string JobCodeList="";
    protected string ComponentCodeList = "";
    protected string ModifierCodeList = "";
    protected string LaborChargeCodeList = "";
    protected string MiscChargeCodeList = "";
    protected string CostCentreCodeList = "";
    protected string RefreshParts = "0";
    protected string SourceTypeId = "";
    protected string SourceSegmentId = "";
    protected string SourceWONO = "";
    protected string SourceSegmentNo = "";
    protected string SourceROId = "";
    protected string SourceROPId = "";
    protected string SourceSelectedGroup = "";
    protected int DetailCountExternalNotes = 0;
    protected int DetailCountInstructions = 0;
    protected int DetailCountParts = 0;
    protected int DetailCountLabor = 0;
    protected int DetailCountMisc = 0;
    protected int HasPendingLabor = 0;
    protected int HasPendingMisc = 0;
    protected int IsRepriceRequired = 1; //1:no 2:required //!<CODE_TAG_101832>
    //<CODE_TAG_104809>
    protected int hasPendingLabor = 0;
    protected int hasPendingMisc = 0;
    //</CODE_TAG_104809>
    protected int SegmentCount = 0;
    protected bool CanModify = false;

    protected bool SegmentEdit = false;
    protected bool RenderPage = true;
    DataSet dsQuote;
    IDictionary<string, IEnumerable<DataRow>> RowsSet;
    protected MenuItem leftMenuSmall = new MenuItem(isRoot: true);
    protected MenuItem leftMenuLarge = new MenuItem(isRoot: true);

    protected int SegmentQty = 1;
    protected float StdHours = 0; //<CODE_TAG_101936>

    //<CODE_TAG_102032>
    protected string WOSegmentQty = "1";
    protected int intWOSegmentQty = 1;
    //</CODE_TAG_102032>

    //<CODE_TAG_103339>
    protected string multiLineNote = string.Empty;  //for multiple line external notes 
    protected string mlutiLineNote_Internal = string.Empty;
    protected string multilineInstruction = string.Empty;
    //protected bool ExteranlNoteOnly = true;
    protected bool ExteranlNoteOnly = (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.InternalNotesTogglableShow"))? true: false;
    //</CODE_TAG_103339>

    int QuoteStatusId = 0;//<CODE_TAG_105379>R.Z
    protected string curSegmentBranchNo = ""; //<CODE_TAG_102235>

    protected int LaborRepricing = 0;  //<CODE_TAG_105318> lwang 

    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Quote";
        QuoteId = Request.QueryString["QuoteId"].AsInt();
        Revision = Request.QueryString["Revision"].AsInt();
        DefaultSegmentId = DAL.Quote.Quote_Get_LastSegmentId(QuoteId, Revision);

        SegmentId = Request.QueryString["SegmentId"].AsInt(DefaultSegmentId);
       
        if (SegmentId == 0)
            SegmentId = DefaultSegmentId;

    }

    protected void btnSegmentSave_Click(object sender, EventArgs e)
    {
        string partFlatRateInd = Request.Form["lstPartFlatRate"];
        double partFlatRateAmountInput = Request.Form["txtPartFlatRateAmount"].AsString("0").Replace(",", "").AsDouble();
        double partExtAmount = 0;

        string laborFlatRateInd = Request.Form["lstLaborFlatRate"];
        double laborFlatRateAmountInput = Request.Form["txtLaborFlatRateAmount"].AsString("0").Replace(",", "").AsDouble();
        double laborFlatRateQtyInput = Request.Form["txtLaborFlatRateQty"].AsString("0").Replace(",", "").AsDouble();
        double laborExtAmount = 0;
        double laborExtQty = 0;

        string miscFlatRateInd = Request.Form["lstMiscFlatRate"];
        double miscFlatRateAmountInput = Request.Form["txtMiscFlatRateAmount"].AsString("0").Replace(",", "").AsDouble();
        double miscExtAmount = 0;

        string totalFlatRateInd = ""; // lstTotalFlatRate.SelectedValue;
        //double totalFlatRateAmountInput = txtTotalFlatRateAmount.Text.Replace(",", "").AsDouble();
        double totalExtAmount = 0;
        //<Ticket 34043>
        //rounding
        partFlatRateAmountInput = Math.Round(partFlatRateAmountInput, 2, MidpointRounding.AwayFromZero);
        laborFlatRateAmountInput = Math.Round(laborFlatRateAmountInput, 2, MidpointRounding.AwayFromZero);
        miscFlatRateAmountInput = Math.Round(miscFlatRateAmountInput, 2, MidpointRounding.AwayFromZero);
        //</Ticket 34043>

        //save Parts
        DAL.Quote.DeleteAllPart(SegmentId);

        int partsCount = Request.Form["hdnPartsCount"].AsInt();
        
        Part curPart;
        for (int i = 1; i <= partsCount; i++)
        {
            curPart =new Part()
            {
                ItemId = i,
                SOS = Request.Form["txtPartSOS" + i.ToString()].Trim(),
                PartNo = Request.Form["txtPartNo" + i.ToString()].Trim(),
                Quantity = Request.Form["txtPartQuantity" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                Description = Request.Form["txtPartDescription" + i.ToString()],
                UnitSellPrice = Request.Form["txtPartUnitSellPrice" + i.ToString()].AsString("").Replace(",","").AsDouble(0),
                UnitDiscPrice = Request.Form["txtPartUnitDiscPrice" + i.ToString()].AsString("").Replace(",","").AsDouble(0),
                NetSellPrice = Request.Form["txtPartNetSellPrice" + i.ToString()].AsString("").Replace(",","").AsDouble(0),
                UnitPrice = Request.Form["txtPartUnitPrice" + i.ToString()].AsString("").Replace(",","").AsDouble(0),
                Discount = Request.Form["txtPartDiscount" + i.ToString()].AsString("").Replace(",","").AsDouble(0),
                CoreItemId = Request.Form["txtPartCoreItemId" + i.ToString()].AsString("").Replace(",","").AsInt(),
                UnitWeight = Request.Form["txtPartUnitWeight" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                AvailableQty = Request.Form["txtPartAvailableQty" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                QtyOnhand = Request.Form["hdnQtyOnhand" + i.ToString()].AsString("").Replace(",", "").AsInt(),
                Lock = Request.Form["hdnPartLock" + i.ToString()].AsInt()
            };
            if (!curPart.IsCorePart)
            {
                double corePartPrice = 0;
                double coreDiscount = 0;// <CODE_TAG_104131> 
                if (curPart.HasCorePart)
                {
                    corePartPrice = Request.Form["txtPartUnitPrice" + curPart.CoreItemId.ToString()].AsString("").Replace(",", "").AsDouble(0);
                    coreDiscount = Request.Form["txtPartDiscount" + curPart.CoreItemId.ToString()].AsString("").Replace(",", "").AsDouble(0); // <CODE_TAG_104131> 
                }


                int boCount = Request.Form["hdnBoCount" + i.ToString()].AsInt();
                for (int j = 0; j < boCount; j++)
                {
                    BackOrder bo = new BackOrder();
                    bo.BoFacCode = Request.Form["hdnBoFacCode" + i + "_" + j].Trim();
                    bo.BoFacName = Request.Form["hdnBoFacName" + i + "_" + j].Trim();
                    bo.BoFacType = Request.Form["hdnBoFacType" + i + "_" + j].Trim();
                    bo.BoQty = Request.Form["hdnBoQty" + i + "_" + j].AsInt();

                    if (curPart.BackOrders == null)
                        curPart.BackOrders = new List<BackOrder>();
                    curPart.BackOrders.Add(bo);
                }

                string strBackorders = "";
                if (curPart.BackOrders != null)
                {
                    strBackorders = "<BackOrders>";
                    foreach (BackOrder bo in curPart.BackOrders)
                    {
                        strBackorders += "<backorder>";
                        strBackorders += "<BoFacCode>" + bo.BoFacCode + "</BoFacCode>";
                        strBackorders += "<BoFacName>" + Server.HtmlEncode(bo.BoFacName) + "</BoFacName>";
                        strBackorders += "<BoFacType>" + Server.HtmlEncode(bo.BoFacType) + "</BoFacType>";
                        strBackorders += "<BoQty>" + bo.BoQty + "</BoQty>";
                        strBackorders += "</backorder>";
                    }

                    strBackorders += "</BackOrders>";
                }
                /*if (curPart.PartNo.Trim() != "")
                {

                    DAL.Quote.AddPart(
                        SegmentId,
                        curPart.SOS,
                        curPart.PartNo,
                        curPart.Quantity,
                        curPart.QtyOnhand,
                        curPart.AvailableQty,
                        curPart.UnitWeight,
                        curPart.Description,
                        curPart.UnitSellPrice,
                        curPart.UnitDiscPrice,
                        curPart.NetSellPrice,
                        curPart.UnitPrice, //UnitPrice,
                        curPart.ExtendedPrice,
                        0,
                        curPart.Discount,
                        corePartPrice,
                        curPart.Lock,
                        i,
                        strBackorders
                        );
                }*/
                // <CODE_TAG_102277>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.PartNoEmptyAllowed"))
                {
                    //if (curPart.Description.Trim() != "")
                    if (curPart.Description.Trim() != "" || curPart.PartNo.Trim() != "")    //<CODE_TAG_105340> lwang
                    {

                        DAL.Quote.AddPart(
                            SegmentId,
                            curPart.SOS,
                            curPart.PartNo,
                            curPart.Quantity,
                            curPart.QtyOnhand,
                            curPart.AvailableQty,
                            curPart.UnitWeight,
                            curPart.Description,
                            curPart.UnitSellPrice,
                            curPart.UnitDiscPrice,
                            curPart.NetSellPrice,
                            curPart.UnitPrice, //UnitPrice,
                            curPart.ExtendedPrice,
                            0,
                            curPart.Discount,
                            corePartPrice,
                            curPart.Lock,
                            i,
                            strBackorders
                            , coreDiscount //<CODE_TAG_104131> 
                            );
                    }
                }
                else
                {
                    if (curPart.PartNo.Trim() != "")
                    {

                        DAL.Quote.AddPart(
                            SegmentId,
                            curPart.SOS,
                            curPart.PartNo,
                            curPart.Quantity,
                            curPart.QtyOnhand,
                            curPart.AvailableQty,
                            curPart.UnitWeight,
                            curPart.Description,
                            curPart.UnitSellPrice,
                            curPart.UnitDiscPrice,
                            curPart.NetSellPrice,
                            curPart.UnitPrice, //UnitPrice,
                            curPart.ExtendedPrice,
                            0,
                            curPart.Discount,
                            corePartPrice,
                            curPart.Lock,
                            i,
                            strBackorders
                            , coreDiscount //<CODE_TAG_104131>
                            );
                    }
                }
                // </CODE_TAG_102277>
            }

            /*if (curPart.PartNo.Trim() != "")
                partExtAmount += curPart.ExtendedPrice;*/
            // <CODE_TAG_102277>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.PartNoEmptyAllowed"))
            {
                if (curPart.PartNo.Trim() != "" || curPart.Description.Trim() != "")
                //partExtAmount += curPart.ExtendedPrice;
                    partExtAmount += Math.Round(curPart.ExtendedPrice, 2, MidpointRounding.AwayFromZero);  //<Ticket 34043>
            }
            else
            {
                if (curPart.PartNo.Trim() != "")
                    //partExtAmount += curPart.ExtendedPrice;
                    partExtAmount += Math.Round(curPart.ExtendedPrice, 2, MidpointRounding.AwayFromZero); //<Ticket 34043>
            }
            // </CODE_TAG_102277>
        }


        //save Labor
        DAL.Quote.DeleteAllLabor(SegmentId);

        int laborCount = Request.Form["hdnLaborCount"].AsInt();
        Labor curLabor;
        for (int i = 1; i <= laborCount; i++)
        {
            curLabor = new Labor()
            {
                ItemId = i,
                ItemNo = (Request.Form.AllKeys.Contains("hidLaborChargeCode" + i.ToString())) ?Request.Form["hidLaborChargeCode" + i.ToString()].Trim() : Request.Form["txtLaborItemNo" + i.ToString()].Trim(),
                Quantity = Request.Form["txtLaborQuantity" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                Description = Request.Form["txtLaborDescription" + i.ToString()],
                Shift = (Request.Form.AllKeys.Contains("lstLaborShift" + i.ToString())) ? Request.Form["lstLaborShift" + i.ToString()].Trim() : "",
                UnitPrice = Request.Form["txtLaborUnitPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                Discount = Request.Form["txtLaborDiscount" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                Lock = Request.Form["hdnLaborLock" + i.ToString()].AsInt()
            };
            if ( !(curLabor.ItemNo.Trim() == "" && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode"))  )
            {
                DAL.Quote.AddLabor(
                    SegmentId,
                    curLabor.ItemNo,
                    curLabor.Quantity,
                    curLabor.Description,
                    curLabor.Shift,
                    curLabor.UnitPrice,
                    curLabor.Discount,
                    curLabor.ExtendedPrice,
                    curLabor.Lock,
                    i
                    );
            
                //laborExtAmount += curLabor.ExtendedPrice;
                laborExtAmount += Math.Round(curLabor.ExtendedPrice, 2, MidpointRounding.AwayFromZero); //<Ticket 34043>
                laborExtQty += curLabor.Quantity;
            }
        }
        //save Misc
        DAL.Quote.DeleteAllMisc(SegmentId);

        int miscCount = Request.Form["hdnMiscCount"].AsInt();
        Misc curMisc;
        for (int i = 1; i <= miscCount; i++)
        {
            curMisc = new Misc()
            {
                ItemId = i,
                ItemNo = (Request.Form.AllKeys.Contains("hidMiscChargeCode" + i.ToString())) ? Request.Form["hidMiscChargeCode" + i.ToString()].Trim() :Request.Form["txtMiscItemNo" + i.ToString()].Trim(),
                Quantity = Request.Form["txtMiscQuantity" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                Description = Request.Form["txtMiscDescription" + i.ToString()],
                UnitPrice = Request.Form["txtMiscUnitPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                UnitCostPrice = Request.Form["txtMiscUnitCostPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                UnitSellPrice = Request.Form["txtMiscUnitSellPrice" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                UnitPercentRate = Request.Form["txtMiscUnitPercentRate" + i.ToString()].AsString("").Replace(",", "").AsDouble(0) / 100,
                Discount = Request.Form["txtMiscDiscount" + i.ToString()].AsString("").Replace(",", "").AsDouble(),
                Lock = Request.Form["hdnMiscLock" + i.ToString()].AsInt(),
                UnitPriceLock = (Request.Form["chkUnitPriceLock" + i.ToString()].AsString("") == "on") ? 2 : 1
            };
            if ( ! (curMisc.ItemNo.Trim() == "" && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode")) )
            {
                DAL.Quote.AddMisc(
                    SegmentId,
                    curMisc.ItemNo,
                    curMisc.Quantity,
                    curMisc.Description,
                    curMisc.UnitPrice,
                    curMisc.UnitCostPrice,
                    curMisc.UnitPercentRate,
                    curMisc.UnitSellPrice,
                    curMisc.Discount,
                    curMisc.ExtendedPrice,
                    curMisc.Lock,
                    curMisc.UnitPriceLock ,
                    i
                    );
            
             //miscExtAmount += curMisc.ExtendedPrice;
                miscExtAmount += Math.Round(curMisc.ExtendedPrice, 2, MidpointRounding.AwayFromZero); //<Ticket 34043>
            }

        }
        /*
        if (partFlatRateInd == "E" && laborFlatRateInd == "E" && miscFlatRateInd == "E") totalFlatRateInd = "E";
        if (partFlatRateInd == "F" && laborFlatRateInd == "F" && miscFlatRateInd == "F") totalFlatRateInd = "F";
        */
        totalFlatRateInd="";  
        
        totalExtAmount += (partFlatRateInd != "N") ? partFlatRateAmountInput : partExtAmount;
        totalExtAmount += (laborFlatRateInd != "N") ? laborFlatRateAmountInput : laborExtAmount;
        totalExtAmount += (miscFlatRateInd != "N") ? miscFlatRateAmountInput : miscExtAmount;
        

        
        bool autoPartsCalculate = Request.Form["chkPartsAutoCalculate"].AsString("") != "on";
        bool autoLaborCalculate = Request.Form["chkLaborAutoCalculate"].AsString("") != "on";
        bool autoMiscCalculate = Request.Form["chkMiscAutoCalculate"].AsString("") != "on";

        totalFlatRateInd = hidTotalFlatRateInd.Value;
        if (totalFlatRateInd == "F")
            totalExtAmount = hidTxtGrandTotal.Value.Replace(",","").AsDouble(0);

        SegmentQty = int.TryParse(txtSegmentQty.Text.Trim(), out SegmentQty) ? SegmentQty : 1;
        StdHours = float.TryParse(txtStdHours.Text.Trim(), out StdHours) ? StdHours : 0; //<CODE_TAG_101936>
        DAL.Quote.QuoteSgementEdit(SegmentId,
                                 txtSegmentNo.Text.Trim(),
                                 0,
                                 hidJobCode.Value,
                                 hidComponentCode.Value,
                                 hidModifierCode.Value,
                                 lstBusinessGroupCode.SelectedValue,
                                 lstQuantityCode.SelectedValue,
                                 lstWorkApplicationCode.SelectedValue,
                                 lstStoreCode.SelectedValue,
                                 hidCostCentreCode.Value, //   lstCostCenterCode.SelectedValue,
                                 lstCabTypeCode.SelectedValue,
                                 lstShopFieldCode.SelectedValue,
                                 lstJobLocationCode.SelectedValue,
                                 partFlatRateInd,
                                 (partFlatRateInd != "N")? partFlatRateAmountInput: partExtAmount ,
                                 (autoPartsCalculate)? 2: 0,
                                 laborFlatRateInd,
                                 (laborFlatRateInd != "N")? laborFlatRateAmountInput: laborExtAmount ,
                                 (laborFlatRateInd != "N")? laborFlatRateQtyInput: laborExtQty ,
                                 (autoLaborCalculate) ? 2 : 0,
                                 miscFlatRateInd,
                                 (miscFlatRateInd != "N") ? miscFlatRateAmountInput : miscExtAmount,
                                 (autoMiscCalculate) ? 2 : 0,
                                 totalFlatRateInd,
                                 totalExtAmount,
                                 SegmentQty,
                                 StdHours //<CODE_TAG_101936>
                                 //"",  // hidPartsCustomerNo.Value , //TODO
                                 //0, //txtPartsPercent.Text.AsDouble(0), //TODO
                                 //"", //hidLaborCustomerNo.Value , //TODO
                                 //0, //txtLaborPercent.Text.AsDouble(0),//TODO
                                 //"", //hidMiscCustomerNo.Value , //TODO
                                 //0 //txtMiscPercent.Text.AsDouble(0) //TODO
                                 );


        //save Notes
        //<CODE_TAG_103339>
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
            SaveNotes_SingleLineMode();
        else
            SaveNotes_MultiLineMode();
        //<CODE_TAG_103339>


         //Save Summary
        //use App Config Key to check if = 2 before runing script
         if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Summary.Show"))
         {

            DAL.Quote.SaveCategorySummarySettings(SegmentId, 0, txtPartsSummary.Text, ckbShowPartsDetail.Checked, ckbShowPartsSummary.Checked);
            DAL.Quote.SaveCategorySummarySettings(SegmentId, 1, txtLaborSummary.Text, ckbShowLaborDetail.Checked, ckbShowLaborSummary.Checked);
            DAL.Quote.SaveCategorySummarySettings(SegmentId, 2, txtMiscSummary.Text,  ckbShowMiscDetail.Checked,  ckbShowMiscSummary.Checked);    
            //1 for each of the three section parts, labor, misc
         }

        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("SegmentEdit", normalizeForAppending: true);

        //Response.Redirect(urlBase + "&SegmentEdit=0");
        //<CODE_TAG_105379>R.Z
        QuoteStatusId = DAL.Quote.QuoteGetQuoteStatusId(QuoteId);
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.EditModeWhenQuoteIsOpen") && QuoteStatusId == 1)  //Qutoe is open, redirect to edit mode
            Response.Redirect(urlBase + "&SegmentEdit=1");
        else
            Response.Redirect(urlBase + "&SegmentEdit=0");
        //</CODE_TAG_105379>
    }
    //<CODE_TAG_103339>
    private void SaveNotes_SingleLineMode()
    {
        DAL.Quote.DeleteAllNotes(SegmentId);
        string strExternalNotes = hidExternalNotes.Value;
        string strExternalNotesMasterIndicators = hidExternalNotesMasterIndicators.Value;

        while (strExternalNotes.EndsWith(((char)5).ToString()))
        {
            strExternalNotes = strExternalNotes.Substring(0, strExternalNotes.Length - 1);
        }

        string[] externalNotes = strExternalNotes.Split((char)5);
        string[] externalNotesMasterIndicators = strExternalNotesMasterIndicators.Split((char)5);
        int sort = 1;

        if (externalNotes.Length == 1 && externalNotes[0].Trim() == "")
            externalNotes = null;

        if (externalNotes != null)
        {
            for (int i = 0; i < externalNotes.Length; i++)
            {
                //DAL.Quote.AddNote(SegmentId, 1, externalNotes[i].Trim(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort);
                //DAL.Quote.AddNote(SegmentId, 1, externalNotes[i].Trim().HtmlEncode(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort); //<CODE_TAG_103922>
                DAL.Quote.AddNote(SegmentId, 1, externalNotes[i].Trim().HtmlDecode(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort); //<CODE_TAG_103922>
                sort++;
            }
        }

        string strInstructions = hidInstructions.Value;
        while (strInstructions.EndsWith(((char)5).ToString()))
        {
            strInstructions = strInstructions.Substring(0, strInstructions.Length - 1);
        }
        string[] instructions = strInstructions.Split((char)5);
        sort = 1;

        if (instructions.Length == 1 && instructions[0].Trim() == "")
            instructions = null;

        if (instructions != null)
        {
            foreach (string str in instructions)
            {
                //DAL.Quote.AddNote(SegmentId, 2, str, "E", sort); // E for MasterIndicator
                //DAL.Quote.AddNote(SegmentId, 2, str.HtmlEncode(), "E", sort); // E for MasterIndicator //<CODE_TAG_103922>
                DAL.Quote.AddNote(SegmentId, 2, str.HtmlDecode(), "E", sort); // E for MasterIndicator //<CODE_TAG_103922>
                sort++;
            }
        }
    }
    //</CODE_TAG_103339>
    //<CODE_TAG_103339>
    private void SaveNotes_MultiLineMode()
    {

        string strExternalNotesNotes = Request.Form["txtExternalNotesNotes"];//customer (external) notes 
        string strInstructionsNotes = Request.Form["txtInstructionsNotes"];
        string strExteranlNotesNotesINotes = Request.Form["txtExternalNotesINotes"]; //internal notes
        string strInputCbxMultiLineNoteTypeSelected = Request.Form["inputCbxMultiLineNoteTypeSelected"];
        //bool isInternalNotesSameAsExternal = false;

        if (strInputCbxMultiLineNoteTypeSelected != null)
        {
            //isInternalNotesSameAsExternal = (strInputCbxMultiLineNoteTypeSelected.ToUpper() == "ON") ? true : false;
            if (strInputCbxMultiLineNoteTypeSelected.ToUpper() == "ON")
            {
                strExteranlNotesNotesINotes = "";
            }

        }
        else
        {
            //isInternalNotesSameAsExternal = false;
        }


        if (string.IsNullOrEmpty(strExternalNotesNotes)) strExternalNotesNotes = string.Empty;
        if (string.IsNullOrEmpty(strInstructionsNotes)) strInstructionsNotes = string.Empty;
        if (string.IsNullOrEmpty(strExteranlNotesNotesINotes)) strExteranlNotesNotesINotes = string.Empty;

        //DAL.Quote.Quote_Save_MultiLineNotesAndInstruction(SegmentId, strExternalNotesNotes.HtmlEncode(), strExteranlNotesNotesINotes.HtmlEncode(), strInstructionsNotes.HtmlEncode());  //<CODE_TAG_105824>
        DAL.Quote.Quote_Save_MultiLineNotesAndInstruction(SegmentId, strExternalNotesNotes.HtmlDecode(), strExteranlNotesNotesINotes.HtmlDecode(), strInstructionsNotes.HtmlDecode());  //<CODE_TAG_105824>
    }
    //</CODE_TAG_103339>
    protected void btnSegmentDelete_Click(object sender, EventArgs e)
    {
        RenderPage = false;
        DAL.Quote.DeleteSegment(SegmentId);
        Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?QuoteId=" + QuoteId + "&Revision=" + Revision);
    }

    protected void btnChangeSegment_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string strSegmentId = btn.Attributes["SegmentId"]; 
        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("SegmentId", normalizeForAppending: true);

        Response.Redirect(urlBase + "&SegmentId=" + strSegmentId);
    }

    protected void btnSegmentEdit_Click(object sender, EventArgs e)
    {
        //<CODE_TAG_106869>R.Z
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Revision.Segment.EditableAfterPushToDBS") && quoteHeader.SegmentEditLockedByRevisionUpdate)
        {
            string message = "The current quote revision is not editable.  To edit, create a new revision.";

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("<script type = 'text/javascript'>");
            sb.Append("window.onload=function(){");
            sb.Append("alert('");
            sb.Append(message);
            sb.Append("')};");
            sb.Append("</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", sb.ToString());

            return;
        }
        //</CODE_TAG_106869>
        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("SegmentEdit", normalizeForAppending: true);

        Response.Redirect(urlBase + "&SegmentEdit=1");
    }
    
    protected void btnSegmentCancel_Click(object sender, EventArgs e)
    {
        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage( "SegmentEdit", normalizeForAppending: true);
        Response.Redirect(urlBase + "&SegmentEdit=0");
    }

    private void Page_PreRender(object sender, System.EventArgs e)
    {
      
        List<Part> listParts = new List<Part>();
        List<Labor> listLabor = new List<Labor>();
        List<Misc> listMisc = new List<Misc>();
        DataRow drHeader = null;


        if (Request.QueryString["SegmentEdit"].AsInt(0) == 1 &&  AppContext.Current.User.Operation.CreateQuote)
            SegmentEdit = true;
        //<CODE_TAG_105379>R.Z
        QuoteStatusId = DAL.Quote.QuoteGetQuoteStatusId(QuoteId);
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.EditModeWhenQuoteIsOpen") && QuoteStatusId == 1)  //Qutoe is open, redirect to edit mode
            SegmentEdit = true;
        //</CODE_TAG_105379>

        //<CODE_TAG_105318> lwang 
        LaborRepricing = DAL.Quote.QuoteGetSegmentLaborRepricing(QuoteId, SegmentId);
        if (LaborRepricing > 0)
        {
            SegmentEdit = true;
        }
        //</CODE_TAG_105318> lwang 

        if (!RenderPage)
            return;
        dsQuote = DAL.Quote.QuoteDetailGet(QuoteId, Revision, PageMode, SegmentId, SegmentEdit);
        RowsSet = dsQuote.ToDictionary();


        if (RowsSet.ContainsKey("QuoteHeader"))
        {
            drHeader = RowsSet["QuoteHeader"].FirstOrDefault();
            HttpContext.Current.Items.Add("Global_CanModifyQuote", drHeader["CanModify"].AsInt());
            CanModify = drHeader["CanModify"].AsInt(0) == 2;
            SegmentEdit = SegmentEdit && CanModify;
        }

        

        //Header
        quoteHeader.Bind(PageMode, RowsSet);
        
        //Left Menu for segments
        IEnumerable<DataRow> drSegments = RowsSet["QuoteSegments"];
        SegmentCount = RowsSet["QuoteSegments"].Count();

        //Large
        var leftMenuGroup = new MenuItemGroup();
        var menuItem = new MenuItem{};
        foreach (DataRow dr in drSegments)
        {
            leftMenuGroup.Add(new MenuItem
                                  {
                                      Text =
                                          String.Format(
                                              "{0} {1} {2}",
                                              dr["SegmentNo"],
                                              "-",
                                              String.Format("{0} {1}", dr["JobCodeDesc"], dr["ComponentCodeDesc"]).HtmlEncode()
                                              ),
                                      EncodeText = false,
                                      NavigateUrl =
                                          "Quote_Segment.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" +
                                          Revision.ToString() + "&SegmentId=" + dr["QuoteSegmentId"].ToString(),
                                      Selected = (dr["QuoteSegmentId"].AsInt() == SegmentId) ? true : false
                                  });
            hdnSegmentNoList.Value += dr["QuoteSegmentId"] + "|" + dr["SegmentNo"] + ",";//<CODE_TAG_103934>
        }
         if (CanModify ) //  AppContext.Current.User.Operation.CreateQuote)
             menuItem = new MenuItem {Text = "Add New Segment"};
        menuItem.Attributes.CssStyle["color"] = "#00659c";
        menuItem.Attributes.Add("onclick", "newSegment_onClick();");

        leftMenuGroup.Add(menuItem);
        leftMenuLarge.Groups.Add(leftMenuGroup);
        //small
        leftMenuGroup = new MenuItemGroup();
        foreach (DataRow dr in drSegments)
        {
            leftMenuGroup.Add(new MenuItem { Text = dr["SegmentNo"].ToString(), NavigateUrl = "Quote_Segment.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString() + "&SegmentId=" + dr["QuoteSegmentId"].ToString(), Selected = (dr["QuoteSegmentId"].AsInt() == SegmentId) ? true : false });
        }
        if (CanModify )  //(AppContext.Current.User.Operation.CreateQuote)
            menuItem = new MenuItem { Text = "New" };
        menuItem.Attributes.CssStyle["color"] = "#00659c";
        menuItem.Attributes.Add("onclick", "newSegment_onClick();");
        leftMenuGroup.Add(menuItem);
        leftMenuSmall.Groups.Add(leftMenuGroup);


        DataRow drCurrentSegment = RowsSet["CurentSegment"].FirstOrDefault();
        RefreshParts = drCurrentSegment["RefreshPartsFlg"].ToString();
        SourceTypeId = drCurrentSegment["SourceTypeId"].ToString();
        SourceSegmentId = drCurrentSegment["SourceSegmentId"].ToString();
        SourceWONO = drCurrentSegment["SourceWONO"].ToString();
        SourceSegmentNo = drCurrentSegment["SourceSegmentNo"].ToString();
        SourceROId = drCurrentSegment["SourceROId"].ToString();
        SourceROPId = drCurrentSegment["SourceROPId"].ToString();
        SourceSelectedGroup = drCurrentSegment["SourceSelectedGroup"].ToString();
        //<CODE_TAG_101832>
        IsRepriceRequired = drCurrentSegment["IsRepriceRequired"].AsInt(1);
        if (CanModify && (IsRepriceRequired == 2))
            SegmentEdit = true;
        //</CODE_TAG_101832>
        //<CODE_TAG_104809>
        hasPendingLabor = drCurrentSegment["hasPendingLabor"].AsInt(1);
        hasPendingMisc = drCurrentSegment["hasPendingMisc"].AsInt(1);
        //</CODE_TAG_104809>
        if (SegmentEdit)
        {
            HasPendingLabor = drCurrentSegment["HasPendingLabor"].AsInt(0);
            HasPendingMisc = drCurrentSegment["HasPendingMisc"].AsInt(0);
            //<CODE_TAG_101832>
           
            this.ucLabor.IsRepriceRequired = IsRepriceRequired;
            this.ucMisc.IsRepriceRequired = IsRepriceRequired;
            //</CODE_TAG_101832>
            //<CODE_TAG_104809>
            this.ucLabor.hasPendingLabor = hasPendingLabor;
            this.ucMisc.hasPendingMisc = hasPendingMisc;
            //</CODE_TAG_104809>
            //<CODE_TAG_102235>
            if (!string.IsNullOrEmpty(drCurrentSegment["BranchCode"].ToString()))
            {
                curSegmentBranchNo = drCurrentSegment["BranchCode"].ToString().Trim();
                ucParts.CurrentBranchCode = curSegmentBranchNo;
            }
            
            //</CODE_TAG_102235>
        }
        ////<CODE_TAG_101832>
        //IsRepriceRequired = drCurrentSegment["IsRepriceRequired"].AsInt(1);
        //this.ucLabor.IsRepriceRequired = IsRepriceRequired;
        //this.ucMisc.IsRepriceRequired = IsRepriceRequired;
        ////</CODE_TAG_101832>
        

        if (RefreshParts == "2" &&  CanModify)
            SegmentEdit = true;
        if (! CanModify )
            RefreshParts = "0";
        //Previous next button


        bool findCurrentSegment = false;
        int previousSegmentId = 0, nextSegmentId = 0, tempPreviousSegmentId = 0, curSegmentId=0;
        
        foreach (DataRow dr in drSegments)
        {
            curSegmentId = dr["QuoteSegmentId"].AsInt();

            if (findCurrentSegment && nextSegmentId == 0)
                nextSegmentId = curSegmentId;

            if (curSegmentId == SegmentId)
            {
                findCurrentSegment = true;
                previousSegmentId = tempPreviousSegmentId;
            }
            tempPreviousSegmentId = curSegmentId;
        }
        
        if (previousSegmentId == 0)
        {
            btnPrevisouSegmentReadonly.Visible = false;
            btnPrevisouSegmentEdit.Visible = false;
        }
        else
        {
            btnPrevisouSegmentReadonly.Attributes.Add("segmentId", previousSegmentId.ToString());
            btnPrevisouSegmentEdit.Attributes.Add("segmentId", previousSegmentId.ToString());
         
        }

        if (nextSegmentId == 0)
        {
            btnNextSegmentReadonly.Visible = false;
            btnNextSegmentEdit.Visible = false;
        }
        else
        {
            btnNextSegmentReadonly.Attributes.Add("segmentId", nextSegmentId.ToString());
            btnNextSegmentEdit.Attributes.Add("segmentId", nextSegmentId.ToString());
        }
        
        if (!IsPostBack)
            {
                //Parts
                if (RowsSet.ContainsKey("Parts"))
                {
                    int itemId = 1;
                    foreach (DataRow dr in RowsSet["Parts"])
                    {
                        Part curPart = new Part(itemId, dr);
                        if (RowsSet.ContainsKey("PartsAvailability"))
                        {
                            foreach (DataRow drBo in RowsSet["PartsAvailability"])
                            {
                                if (drBo["PartItemId"].ToString() == dr["ItemId"].ToString())
                                {
                                    BackOrder bo = new BackOrder();
                                    bo.BoFacCode = drBo["BoFacCode"].ToString();
                                    bo.BoFacName = drBo["BoFacName"].ToString();
                                    bo.BoFacType = drBo["BoFacType"].ToString();
                                    bo.BoQty = drBo["BoQty"].AsInt(0);

                                    if (curPart.BackOrders == null)
                                        curPart.BackOrders = new List<BackOrder>();
                                    curPart.BackOrders.Add(bo);
                                }
                            }

                        }



                        listParts.Add(curPart);
                        itemId++;
                    }
                }
                ucParts.Bind(listParts, drCurrentSegment["partFlatRateInd"].ToString(), drCurrentSegment["partFlatRateAmount"].AsDouble(), drCurrentSegment["autoPartsCalculate"].AsInt(0) == 2, SegmentEdit);
                if (listParts != null) DetailCountParts = listParts.Count;

                //Labor
                if (RowsSet.ContainsKey("Labor"))
                {
                    foreach (DataRow dr in RowsSet["Labor"])
                    {
                        listLabor.Add(new Labor(dr));
                    }
                }
                ucLabor.Bind(listLabor, drCurrentSegment["laborFlatRateInd"].ToString(), drCurrentSegment["laborFlatRateAmount"].AsDouble(), drCurrentSegment["laborFlatRateQty"].AsDouble(), drCurrentSegment["autoLaborCalculate"].AsInt(0) == 2, SegmentEdit);
                if (listLabor != null) DetailCountLabor = listLabor.Count;

                //Misc
                if (RowsSet.ContainsKey("Misc"))
                {
                    foreach (DataRow dr in RowsSet["Misc"])
                    {
                        listMisc.Add(new Misc(dr));
                    }
                }
                ucMisc.Bind(listMisc, drCurrentSegment["miscFlatRateInd"].ToString(), drCurrentSegment["miscFlatRateAmount"].AsDouble(), drCurrentSegment["autoMiscCalculate"].AsInt(0) == 2, SegmentEdit);
                if (listMisc != null) DetailCountMisc = listMisc.Count;
                //Notes
                IEnumerable<DataRow> rsExternalNotes = null;
                IEnumerable<DataRow> rsInstructions = null;
                /*if (RowsSet.ContainsKey("ExternalNotes"))
                {
                    rsExternalNotes = RowsSet["ExternalNotes"];
                    DetailCountExternalNotes = rsExternalNotes.Count(); 
                }*/
                //<CODE_TAG_103339>
                if (RowsSet.ContainsKey("ExternalNotes"))
                {
                    rsExternalNotes = RowsSet["ExternalNotes"];
                    if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                    {
                        
                        DetailCountExternalNotes = rsExternalNotes.Count();
                    }
                    else
                    {
                        //DataRow noteRow = rsExternalNotes[0];
                        //multiLineNote = noteRow["Notes"].AsString();
                        if (rsExternalNotes != null && rsExternalNotes.Count() > 0)
                        {
                            foreach (DataRow row in rsExternalNotes)
                            {
                                multiLineNote = row["Notes"].AsString();
                                mlutiLineNote_Internal = row["Notes_Internal"].AsString();
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.InternalNotesTogglableShow"))
                                {
                                    ExteranlNoteOnly = (string.IsNullOrEmpty(mlutiLineNote_Internal)) ? true : false;
                                }
                                else
                                {
                                    ExteranlNoteOnly = false;
                                }
                            }
                        }
                        
                    }
                }
                
                //</CODE_TAG_103339>
                /*if (RowsSet.ContainsKey("Instructions"))
                {
                    rsInstructions = RowsSet["Instructions"];
                    DetailCountInstructions = rsInstructions.Count();
                }*/
                //ucNotes.Bind("ExternalNotes", rsExternalNotes, 25, SegmentEdit);
                //<CODE_TAG_103339>
                if (RowsSet.ContainsKey("Instructions"))
                {
                    rsInstructions = RowsSet["Instructions"];
                    if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                    {
                        DetailCountInstructions = rsInstructions.Count();
                    }
                    else
                    {
                        if (rsInstructions != null && rsInstructions.Count() > 0)
                        {
                            foreach (DataRow row in rsInstructions)
                            {
                                multilineInstruction = row["Notes"].AsString();
                            }
                        }
                    }
                }
                //</CODE_TAG_103339>
                //<CODE_TAG_103339>
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                {
                    ucNotes.Bind("ExternalNotes", rsExternalNotes, 25, SegmentEdit);
                }
                else
                {
                    //to do
                    if (!ExteranlNoteOnly)
                        multiLineNote += "~" + mlutiLineNote_Internal;
                    ucNotes.Bind("ExternalNotes", multiLineNote, SegmentEdit, ExteranlNoteOnly);
                    
                }
                //</CODE_TAG_103339>
                //ucInstructions.Bind("Instructions", rsInstructions, 5, SegmentEdit);
                //<CODE_TAG_103339>
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                {
                    ucInstructions.Bind("Instructions", rsInstructions, 5, SegmentEdit);
                }
                else
                { 
                    //to do
                    ucInstructions.Bind("Instructions", multilineInstruction, SegmentEdit);
                }
                //</CODE_TAG_103339>


                
        }


        //PN
        if (SegmentEdit)
        {
            bindEditData(drCurrentSegment);
            divSegmentEdit.Visible = true;
            divSegmentReadonly.Visible = false;
            btnBottomSave.Visible = true;
            btnBottomCancel.Visible = true;

            ckbShowPartsDetail.Enabled = true;
            ckbShowPartsSummary.Enabled = true;
            txtPartsSummary.Enabled = true;

            ckbShowLaborDetail.Enabled = true;
            ckbShowLaborSummary.Enabled = true;
            txtLaborSummary.Enabled = true;

            ckbShowMiscDetail.Enabled = true;
            ckbShowMiscSummary.Enabled = true;
            txtMiscSummary.Enabled = true;
        }
        else
        {
            bindReadonlyData(drCurrentSegment);
            divSegmentEdit.Visible = false;
            divSegmentReadonly.Visible = true;
            btnBottomSave.Visible = false;
            btnBottomCancel.Visible = false;

            ckbShowPartsDetail.Enabled = false;
            ckbShowPartsSummary.Enabled = false;
            txtPartsSummary.Enabled = false;

            ckbShowLaborDetail.Enabled = false;
            ckbShowLaborSummary.Enabled = false;
            txtLaborSummary.Enabled = false;

            ckbShowMiscDetail.Enabled = false;
            ckbShowMiscSummary.Enabled = false;
            txtMiscSummary.Enabled = false;
        }

        ucSegmentCustomers.SegmentId = SegmentId;
        ucSegmentCustomers.SegmentEdit = SegmentEdit;
        ucSegmentCustomers.Render();

        //PN
        if (RowsSet.ContainsKey("SegmentCategory"))
        {

            foreach (DataRow dr in RowsSet["SegmentCategory"])
            {
                switch (dr["CategoryId"].AsInt())
                {
                    case 0:
                        if (dr["ShowDetailFlag"].AsInt() == 2) ckbShowPartsDetail.Checked = true;
                        else ckbShowPartsDetail.Checked = false;

                        if (dr["ShowSummaryFlag"].AsInt() == 2)
                        {
                            ckbShowPartsSummary.Checked = true;
                            txtPartsSummary.Attributes["style"] = "";
                        }
                        else ckbShowPartsSummary.Checked = false;
                        
                        txtPartsSummary.Text = dr["Note"].ToString();
                        break;
                    case 1:
                        if (dr["ShowDetailFlag"].AsInt() == 2) ckbShowLaborDetail.Checked = true;
                        else ckbShowLaborDetail.Checked = false;

                        if (dr["ShowSummaryFlag"].AsInt() == 2)
                        {
                            ckbShowLaborSummary.Checked = true;
                            txtLaborSummary.Attributes["style"] = "";
                        }
                        else ckbShowLaborSummary.Checked = false;

                        txtLaborSummary.Text = dr["Note"].ToString();
                        break;
                    case 2:
                        if (dr["ShowDetailFlag"].AsInt() == 2) ckbShowMiscDetail.Checked = true;
                        else ckbShowMiscDetail.Checked = false;

                        if (dr["ShowSummaryFlag"].AsInt() == 2)
                        {
                            ckbShowMiscSummary.Checked = true;
                            txtMiscSummary.Attributes["style"] = "";
                        }
                        else ckbShowMiscSummary.Checked = false;

                        txtMiscSummary.Text = dr["Note"].ToString();
                        break;

                }
                    

            }
            

        }
    }
   
    private void bindEditData(DataRow drCurrentSegment)
    {

        StringBuilder sb;

        if (SegmentCount < 2)
            btnDelete.Visible = false;

        char spiltChar = (char)5;
        txtSegmentNo.Text = drCurrentSegment["SegmentNo"].ToString();
        if (drCurrentSegment["SegmentNoPreviousVersion"].ToString() != "")
          lblSegmentNoPreviousVersionEdit.Text = "Old SegmentNo:  " +  drCurrentSegment["SegmentNoPreviousVersion"].ToString();

        //txtSegmentDescription.Text = drCurrentSegment["Description"].ToString();

        //JobCode
        IEnumerable<DataRow> drJobCodes = RowsSet["JobCode"];
        //JobCodeList += ",&nbsp;"; 
        JobCodeList += "~&nbsp;"; // <CODE_TAG_103329>
        if (drJobCodes != null)
        {
            sb =  new StringBuilder();
            foreach (DataRow dr in drJobCodes)
            {
                sb.Append(spiltChar.ToString());
                //sb.Append(dr["jobCode"].ToString() + "," + dr["jobCode"].ToString() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString()));
                sb.Append(dr["jobCode"].ToString() + "~" + dr["jobCode"].ToString() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString()));// <CODE_TAG_103329>
            }
            JobCodeList += sb.ToString();

            if (!drCurrentSegment["jobCode"].IsNullOrWhiteSpace())
            {
                txtJobCode.Text = drCurrentSegment["jobCode"].ToString() + "-" + drCurrentSegment["JobCodeDesc"].ToString();
                txtOnlyJobCode.Text = drCurrentSegment["jobCode"].ToString();
            }
            hidJobCode.Value = drCurrentSegment["jobCode"].ToString();
        }

        //ComponentCode
        IEnumerable<DataRow> drComponentCodes = RowsSet["ComponentCode"];
        //ComponentCodeList += ",&nbsp;";
        ComponentCodeList += "~&nbsp;";//<CODE_TAG_103329>
        if (drComponentCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drComponentCodes)
            {
                sb.Append(spiltChar.ToString());
                //sb.Append(dr["ComponentCode"].ToString() + "," + dr["ComponentCode"].ToString() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString()));
                sb.Append(dr["ComponentCode"].ToString() + "~" + dr["ComponentCode"].ToString() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString())); //<CODE_TAG_103329>
            }
            ComponentCodeList += sb.ToString();

            if (!drCurrentSegment["ComponentCode"].IsNullOrWhiteSpace())
            {
                txtComponentCode.Text = drCurrentSegment["ComponentCode"].ToString() + "-" + drCurrentSegment["ComponentCodeDesc"].ToString();
                txtOnlyComponentCode.Text = drCurrentSegment["ComponentCode"].ToString();
            }
            hidComponentCode.Value = drCurrentSegment["ComponentCode"].ToString();
        }

        //ModifierCode

        IEnumerable<DataRow> drModifierCodes = RowsSet["ModifierCode"];
        ModifierCodeList += ",&nbsp;";
        if (drModifierCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drModifierCodes)
            {
                sb.Append(spiltChar.ToString());
                sb.Append(dr["ModifierCode"].ToString() + "," + dr["ModifierCode"].ToString() + "-" + Server.HtmlEncode(dr["ModifierDesc"].ToString()));
            }
            ModifierCodeList += sb.ToString();

            if (!drCurrentSegment["ModifierCode"].IsNullOrWhiteSpace() || !drCurrentSegment["ModifierDesc"].IsNullOrWhiteSpace())
            {
                txtModifierCode.Text = drCurrentSegment["ModifierCode"].ToString() + "-" +
                                       drCurrentSegment["ModifierDesc"].ToString();

                txtOnlyModifierCode.Text  = drCurrentSegment["ModifierCode"].ToString();
            }
            hidModifierCode.Value = drCurrentSegment["ModifierCode"].ToString();
        }

        //BusinessCode
        lstBusinessGroupCode.Items.Clear();
        lstBusinessGroupCode.Items.Add("");
        IEnumerable<DataRow> drBusinessGroupCodes = RowsSet["BusinessGroupCode"];
        if (drBusinessGroupCodes != null)
        {
            foreach (DataRow dr in drBusinessGroupCodes)
            {
                lstBusinessGroupCode.Items.Add(new ListItem(dr["BusinessGroupCode"].ToString() + "-" + dr["BusinessGroupDesc"].ToString(), dr["BusinessGroupCode"].ToString()));
            }
            lstBusinessGroupCode.SelectedValue = drCurrentSegment["BusinessGroupCode"].ToString().Trim();
        }


        //Quantity Code
        lstQuantityCode.Items.Add("");
        IEnumerable<DataRow> drQuantityCodes = RowsSet["QuantityCode"];
        if (drQuantityCodes != null)
        {
            foreach (DataRow dr in drQuantityCodes)
            {
                lstQuantityCode.Items.Add(new ListItem(dr["QuantityCode"].ToString() + "-" + dr["QuantityDesc"].ToString(), dr["QuantityCode"].ToString()));
            }
            lstQuantityCode.SelectedValue = drCurrentSegment["QuantityCode"].ToString();
        }

        //WorkApplicationCode
        lstWorkApplicationCode.Items.Add("");
        if (RowsSet.ContainsKey("WorkApplicationCode"))
        {
            IEnumerable<DataRow> drWorkApplicationCodes = RowsSet["WorkApplicationCode"];
            if (drWorkApplicationCodes != null)
            {
                foreach (DataRow dr in drWorkApplicationCodes)
                {
                    lstWorkApplicationCode.Items.Add(new ListItem(dr["WorkApplicationCode"].ToString() + "-" + dr["WorkApplicationDesc"].ToString(), dr["WorkApplicationCode"].ToString()));
                }
                lstWorkApplicationCode.SelectedValue = drCurrentSegment["WorkApplicationCode"].ToString();
            }
        }

        //Store Code
        lstStoreCode.Items.Clear();
        lstStoreCode.Items.Add("");
        IEnumerable<DataRow> drStoreCodes = RowsSet["StoreCode"];
        if (drStoreCodes != null)
        {
            foreach (DataRow dr in drStoreCodes)
            {
                lstStoreCode.Items.Add(new ListItem(dr["BranchCode"].ToString() + "-" + dr["BranchName"].ToString(), dr["BranchCode"].ToString()));
            }
            lstStoreCode.SelectedValue = drCurrentSegment["BranchCode"].ToString();
        }

        //Cost Centre Code
        /*
        lstCostCenterCode.Items.Clear();
        lstCostCenterCode.Items.Add("");
        if (RowsSet.ContainsKey("CostCentreCode"))
        {
            IEnumerable<DataRow> drCostCenterCodes = RowsSet["CostCentreCode"];
            if (drCostCenterCodes != null)
            {
                foreach (DataRow dr in drCostCenterCodes)
                {
                    lstCostCenterCode.Items.Add(new ListItem(dr["costCentreCode"].ToString() + "-" + dr["CostCentreName"].ToString(), dr["costCentreCode"].ToString()));
                }
                lstCostCenterCode.SelectedValue = drCurrentSegment["costCentreCode"].ToString();
            }
        }

        */

        if (RowsSet.ContainsKey("CostCentreCode"))
        {
            IEnumerable<DataRow> drCostCenterCodes = RowsSet["CostCentreCode"];
            if (drCostCenterCodes != null)
            {
                CostCentreCodeList += ",&nbsp;";
                sb = new StringBuilder();
                foreach (DataRow dr in drCostCenterCodes)
                {
                   sb.Append(spiltChar.ToString());
                   sb.Append(dr["CostCentreCode"].ToString() + "|" + dr["CostCentreName"].ToString() + "|" + Server.HtmlEncode(dr["BranchNo"].ToString()));
                }
                CostCentreCodeList += sb.ToString();

                hidCostCentreCode.Value = drCurrentSegment["costCentreCode"].ToString();
            }
        }





        //cab type Code
        lstCabTypeCode.Items.Clear();
        lstCabTypeCode.Items.Add("");
        IEnumerable<DataRow> drCableTypeCodes = RowsSet["CableTypeCode"];
        if (drCableTypeCodes != null)
        {
            foreach (DataRow dr in drCableTypeCodes)
            {
                lstCabTypeCode.Items.Add(new ListItem(dr["CabTypeCode"].ToString().Trim() + "-" + dr["CabTypeDesc"].ToString(), dr["CabTypeCode"].ToString().Trim()));
            }
            lstCabTypeCode.SelectedValue = drCurrentSegment["CabTypeCode"].ToString();
        }


        //Shop Field
        lstShopFieldCode.Items.Clear();
        lstShopFieldCode.Items.Add("");
        lstShopFieldCode.Items.Add(new ListItem("Shop", "Shop"));
        lstShopFieldCode.Items.Add(new ListItem("Field", "Field"));
        lstShopFieldCode.SelectedValue = drCurrentSegment["shopField"].ToString().Trim();

        //Job Location Code
        lstJobLocationCode.Items.Clear();
        lstJobLocationCode.Items.Add("");
        IEnumerable<DataRow> drJobLocationCodes = RowsSet["JobLocationCode"];
        if (drJobLocationCodes != null)
        {
            foreach (DataRow dr in drJobLocationCodes)
            {
                lstJobLocationCode.Items.Add(new ListItem(dr["JobLocationCode"].ToString() + "-" + dr["JobLocationDesc"].ToString(), dr["JobLocationCode"].ToString()));
            }
            lstJobLocationCode.SelectedValue = drCurrentSegment["JobLocationCode"].ToString();
        }


        //total
        //lstTotalFlatRate.SelectedValue = drCurrentSegment["totalFlatRateInd"].ToString();
        //txtTotalFlatRateAmount.Text = Util.NumberFormat(drCurrentSegment["totalFlatRateAmount"].AsDouble(), 2, null, null, null, true);


        //Labor Charge Code
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode") && RowsSet.ContainsKey("LaborChargeCode"))
        {
            IEnumerable<DataRow> drLaborChargeCodes = RowsSet["LaborChargeCode"];
            if (drLaborChargeCodes != null)
            {
                foreach (DataRow dr in drLaborChargeCodes)
                {
                    if (LaborChargeCodeList != "") LaborChargeCodeList += spiltChar.ToString();
                    LaborChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + Server.HtmlEncode(dr["chargeCodeDesc"].ToString()) + "," + dr["CRTR"].ToString() + "," + dr["COTR"].ToString() + "," + dr["CPTR"].ToString() + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); // <CODE_TAG_101452> 
                }
            }
        }
        

        //Misc Charge Code
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode") && RowsSet.ContainsKey("MiscChargeCode"))
        {
            IEnumerable<DataRow> drMiscChargeCodes = RowsSet["MiscChargeCode"];
            if (drMiscChargeCodes != null)
            {
                foreach (DataRow dr in drMiscChargeCodes)
                {
                    if (MiscChargeCodeList != "") MiscChargeCodeList += spiltChar.ToString();
                    MiscChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + Server.HtmlEncode(dr["chargeCodeDesc"].ToString()) + "," + dr["UnitPrice"].ToString() + "," + dr["UnitCost"].ToString() + "," + dr["percentRate"].ToString() + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); // <CODE_TAG_101452> 
                }
            }
        }

        txtSegmentQty.Text = drCurrentSegment["SegmentQty"].ToString();
        txtStdHours.Text = drCurrentSegment["StdHours"].ToString(); //<CODE_TAG_101936>
        //lblPartsCustomer.Text = drCurrentSegment["PartsCustomerNo"].ToString() + " - " + drCurrentSegment["PartsCustomerName"].ToString();
        //if (lblPartsCustomer.Text.Trim() == "-") lblPartsCustomer.Text = "";
        //hidPartsCustomerNo.Value = drCurrentSegment["PartsCustomerNo"].ToString().Trim();
        //txtPartsPercent.Text = drCurrentSegment["PartsPercent"].ToString();

        //lblLaborCustomer.Text = drCurrentSegment["LaborCustomerNo"].ToString() + " - " + drCurrentSegment["LaborCustomerName"].ToString();
        //if (lblLaborCustomer.Text.Trim() == "-") lblLaborCustomer.Text = "";
        //hidLaborCustomerNo.Value = drCurrentSegment["LaborCustomerNo"].ToString().Trim();
        //txtLaborPercent.Text = drCurrentSegment["LaborPercent"].ToString();

        //lblMiscCustomer.Text = drCurrentSegment["MiscCustomerNo"].ToString() + " - " + drCurrentSegment["MiscCustomerName"].ToString();
        //if (lblMiscCustomer.Text.Trim() == "-") lblMiscCustomer.Text = "";
        //hidMiscCustomerNo.Value = drCurrentSegment["MiscCustomerNo"].ToString().Trim();
        //txtMiscPercent.Text = drCurrentSegment["MiscPercent"].ToString(); 

    }
   
    private void bindReadonlyData(DataRow drCurrentSegment)
    {
        char spiltChar = (char)5;
        lblSegmentNo.Text = drCurrentSegment["SegmentNo"].ToString();
        if (drCurrentSegment["SegmentNoPreviousVersion"].ToString() != "")
            lblSegmentNoPreviousVersionReadonly.Text = "Old SegmentNo:  " + drCurrentSegment["SegmentNoPreviousVersion"].ToString();

        //lblSegmentDescription.Text = drCurrentSegment["Description"].ToString();

        lblJobCode.Text = (drCurrentSegment["jobCode"].ToString() == "") ? "" : drCurrentSegment["jobCode"].ToString() + "-" + drCurrentSegment["JobCodeDesc"].ToString();
        lblComponentCode.Text = (drCurrentSegment["ComponentCode"].ToString() == "") ? "" : drCurrentSegment["ComponentCode"].ToString() + "-" + drCurrentSegment["ComponentCodeDesc"].ToString();
        lblModifierCode.Text = (drCurrentSegment["ModifierCode"].ToString() == "") ? "" : drCurrentSegment["ModifierCode"].ToString() + "-" + drCurrentSegment["ModifierDesc"].ToString();
        lblBusinessCode.Text = (drCurrentSegment["BusinessGroupCode"].ToString() == "") ? "" : drCurrentSegment["BusinessGroupCode"].ToString() + "-" + drCurrentSegment["BusinessGroupDesc"].ToString();
        lblQuantityCode.Text = (drCurrentSegment["QuantityCode"].ToString() == "") ? "" : drCurrentSegment["QuantityCode"].ToString() + "-" + drCurrentSegment["QuantityDesc"].ToString();
        lblWorkApplicationCode.Text = (drCurrentSegment["WorkApplicationCode"].ToString() == "") ? "" : drCurrentSegment["WorkApplicationCode"].ToString() + "-" + drCurrentSegment["WorkApplicationDesc"].ToString();
        lblStoreCode.Text = (drCurrentSegment["BranchCode"].ToString() == "") ? "" : drCurrentSegment["BranchCode"].ToString() + "-" + drCurrentSegment["BranchName"].ToString();
        lblCostCenterCode.Text = (drCurrentSegment["costCentreCode"].ToString() == "") ? "" : drCurrentSegment["costCentreCode"].ToString() + "-" + drCurrentSegment["CostCentreName"].ToString();
        lblCabTypeCode.Text = (drCurrentSegment["CabTypeCode"].ToString() == "") ? "" : drCurrentSegment["CabTypeCode"].ToString() + "-" + drCurrentSegment["CabTypeDesc"].ToString();
        lblShopField.Text = drCurrentSegment["shopField"].ToString();
        lblJobLocation.Text = (drCurrentSegment["JobLocationCode"].ToString() == "") ? "" : drCurrentSegment["JobLocationCode"].ToString() + "-" + drCurrentSegment["JobLocationDesc"].ToString();

        // <CODE_TAG_101750>
        lblSegmentQty.Text = (drCurrentSegment["SegmentQty"].ToString() == "") ? "1" : drCurrentSegment["SegmentQty"].ToString();
        lblStdHours.Text = (drCurrentSegment["StdHours"].ToString() == "") ? "0" : drCurrentSegment["StdHours"].ToString(); //<CODE_TAG_101936>

        //<CODE_TAG_102032>
        intWOSegmentQty = (drCurrentSegment["WOSegmentQty"].AsInt() == 0) ? 1 : drCurrentSegment["WOSegmentQty"].AsInt();
         WOSegmentQty = intWOSegmentQty.ToString();
        //</CODE_TAG_102032>

        //lblPartsCustomerReadonly.Text = drCurrentSegment["PartsCustomerNo"].ToString() + " - " + drCurrentSegment["PartsCustomerName"].ToString();
        //if (lblPartsCustomerReadonly.Text.Trim() == "-") lblPartsCustomerReadonly.Text = "";
        //lblPartsPercent.Text = drCurrentSegment["PartsPercent"].ToString();

        //lblLaborCustomerReadonly.Text = drCurrentSegment["LaborCustomerNo"].ToString() + " - " + drCurrentSegment["LaborCustomerName"].ToString();
        //if (lblLaborCustomerReadonly.Text.Trim() == "-") lblLaborCustomerReadonly.Text = "";
        //lblLaborPercent.Text = drCurrentSegment["LaborPercent"].ToString();

        //lblMiscCustomerReadonly.Text = drCurrentSegment["MiscCustomerNo"].ToString() + " - " + drCurrentSegment["MiscCustomerName"].ToString();
        //if (lblMiscCustomerReadonly.Text.Trim() == "-") lblMiscCustomerReadonly.Text = "";
        //lblMiscPercent.Text = drCurrentSegment["MiscPercent"].ToString();

        if  (!CanModify)  // (!AppContext.Current.User.Operation.CreateQuote)
            btnEdit.Visible = false;

    }

    //<CODE_TAG_103600>
    protected void btnImportFromDBSPartsDoc_Click(object sender, EventArgs e)
    {

        string docNoData;
        docNoData = hdnSelectedDocNos.Value.Trim();
        string errMsg = "";
        int intSegmentId = Convert.ToInt32(Request.QueryString["segmentId"]);
        //<CODE_TAG_103874>
        if (intSegmentId == 0)
            intSegmentId = this.SegmentId;
        //</CODE_TAG_103874>
        DAL.Quote.ImportPartsFromDBSPartDocuments(intSegmentId, docNoData);

        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("SegmentEdit", normalizeForAppending: true);
        string url = urlBase + "&SegmentEdit=1";
        Response.Redirect(url);

    }


    //</CODE_TAG_103600>
}

