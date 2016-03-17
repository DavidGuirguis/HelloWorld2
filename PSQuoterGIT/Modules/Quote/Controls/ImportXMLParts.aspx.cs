using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using DTO;
using CATPAI;
using Entities;
using X.Extensions;
using System.Data;

public partial class ImportXMLFileParts : UI.Abstracts.Pages.Plain
{
    string curPartNo = "";
    int curPartIndex = 0;
    int segmentId = 0;
    int globalIndex = 0; //<Ticket 48408>
    bool dealerUsuagePercentApplyToPart = false; //<CODE_TAG_105542>R.Z
    protected void Page_Load(object sender, EventArgs e)
    {
        dealerUsuagePercentApplyToPart = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.StandardJob.Parts.DealerUsuagePercentApplyToPart"); //<CODE_TAG_105542>R.Z
        lblErrorMessage.Text = "";
        if (!Page.IsPostBack)
        {
            btnImport.Visible = false;
            btnClose.Visible = false;

            segmentId = Request.QueryString["segmentId"].AsInt(0);
            if (segmentId > 0)
            {
                fuXML.Visible = false;
                btnUpload.Visible = false;
                uploadSegmentPendingParts();
            }
        }
    }

    private void uploadSegmentPendingParts()
    {
        string strXML = DAL.Quote.QuoteGetSegmentPendingParts(segmentId);
        displayParts(strXML);
        ////<Ticket 51393>R.Z
        //string strXML_InvalidParts = DAL.Quote.QuoteGetSegmentPendingInvalidParts(segmentId);
        //displayInvalidatedParts(strXML_InvalidParts);
        ////</Ticket 51393>

    }
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        try
        {
             int filelength = fuXML.FileBytes.Length;  
            byte[] buffer = new byte[filelength];
            fuXML.FileContent.Read(buffer, 0, filelength);
            System.Text.ASCIIEncoding enc = new System.Text.ASCIIEncoding();
            string strXML = enc.GetString(buffer);
            displayParts(strXML);
        }
        catch (Exception ex)
        {
            lblErrorMessage.Text = "Cannot import this file, Please try it again.";
            rptParts_Validated.Visible = false;
            rptParts_Replacements.Visible = false;
            rptParts_Alternates.Visible = false;
            rptParts_Exceptions.Visible = false; 
            //lblErrorMessage.Text = ex.Message;
            btnImport.Visible = false;
            btnClose.Visible = false;
        }
    }
    //<Ticket 51393>R.Z
    /*private void displayInvalidatedParts(string strXML)
    {
        if (strXML.IsNullOrEmpty()) 
            return;
        XmlDocument xdoc = new XmlDocument();
        xdoc.LoadXml(strXML);
        XmlElement xmlRoot = xdoc.DocumentElement;
        XmlNodeList parts = xmlRoot.SelectNodes("PARTS/PART");
        List<FilePart> partPrices_Invalidated = new List<FilePart>();
        int tempInt;
        double tempDbl;
        foreach (XmlNode part in parts)
        {
            FilePart fp = new FilePart();
            if (part["SOS"] != null)
            {
                fp.SOS = part["SOS"].InnerText.ToUpper();
            }
            fp.PARTNO = part["PARTNO"].InnerText.ToUpper();
            int.TryParse(part["QUANTITY"].InnerText, out tempInt);
            fp.Qty = tempInt;
            fp.Desc = part["PARTNAME"].InnerText;
            double.TryParse(part["UNITPRICE"].InnerText, out tempDbl);
            fp.UnitPrice = tempDbl;
            partPrices_Invalidated.Add(fp);
        }
        rptParts_Invalidated.DataSource = partPrices_Invalidated;
        rptParts_Invalidated.DataBind();
 
    }*/
    //</Ticket 51393>
    private void displayParts(string strXML)
    {
        //<CODE_TAG_105831>R.Z 
        string defaultSOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper();
        if (string.IsNullOrEmpty(defaultSOS))
            defaultSOS = "000";
        //</CODE_TAG_105831>
        if (strXML.IsNullOrEmpty())
        {
            lblErrorMessage.Text = "XML parts parameter is Empty";
            return;
        }
        string division = Request.QueryString["division"];
        string customerNo = Request.QueryString["customerNo"];
        string branchNo = Request.QueryString["branchNo"];
        string CATPriceShow = "1";

            XmlDocument xdoc = new XmlDocument();
            xdoc.LoadXml(strXML);
            XmlElement xmlRoot = xdoc.DocumentElement;
            XmlNodeList parts = xmlRoot.SelectNodes("PARTS/PART");


            //Generate List
            List<PartIdentifier> PartIdentifiers = new List<PartIdentifier>();
            List<FilePart> fileParts = new List<FilePart>();
            List<PartPrice> partPrices = new List<PartPrice>();
            List<PartPrice> partPrices_Validated = new List<PartPrice>();
            List<PartPrice> partPrices_Replacements = new List<PartPrice>();
            List<PartPrice> partPrices_Alternates = new List<PartPrice>();
            List<PartPrice> partPrices_Exceptions = new List<PartPrice>();

            int batch_Count = 0;
            int total_Records = parts.Count;
            int current_Records = 0;

            foreach (XmlNode part in parts)
            {
                if (CATPriceShow == "1")
                {
                     int tempInt = 0;
                    double tempDbl = 0.00; //<CODE_TAG_105542>R.Z
                    PartIdentifier p;
                    p = new PartIdentifier();
                    p.PartNo = part["PARTNO"].InnerText.ToUpper( );
                    if (part["SOS"] != null)
                    {
                        p.SOS = part["SOS"].InnerText.ToUpper();
                        //<CODE_TAG_103594>
                        if (string.IsNullOrEmpty(p.SOS))
                            p.SOS = "000";
                        //</CODE_TAG_103594>
                    }
                    else
                    {
                        //p.SOS = "000";
                        //p.SOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper(); //<CODE_TAG_102100>
                        p.SOS = defaultSOS;  //<CODE_TAG_105831>R.Z 
                    }
                    int.TryParse(part["QUANTITY"].InnerText, out tempInt);
                    //<CODE_TAG_105542>R.Z
                    double dealerUsuagePercent= 0.00;
                    if (part["DEALERUSUAGEPERCENT"] != null)
                    {
                        double.TryParse(part["DEALERUSUAGEPERCENT"].InnerText, out tempDbl);
                        dealerUsuagePercent = tempDbl;
                    }
                    //</CODE_TAG_105542>
                    p.Qty = tempInt;
                    PartIdentifiers.Add(p);

                   
                    FilePart fp = new FilePart();
                    //fp.SOS = "000";
                    //fp.SOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper(); //<CODE_TAG_102100>
                    //<CODE_TAG_105831>R.Z 
                    if (part["SOS"] != null)
                    {
                        fp.SOS = part["SOS"].InnerText.ToUpper();
                        if (string.IsNullOrEmpty(fp.SOS))
                            fp.SOS = defaultSOS;
                    }
                    else
                    {
                        fp.SOS = defaultSOS;
                    }
                    //</CODE_TAG_105831>
                    fp.PARTNO = part["PARTNO"].InnerText;
                    int.TryParse(part["QUANTITY"].InnerText, out tempInt);
                    fp.Qty = tempInt;
                    fp.Desc = part["PARTNAME"].InnerText;
                    //<CODE_TAG_105542>R.Z
                    if (dealerUsuagePercentApplyToPart != null && dealerUsuagePercent != 0.00)
                    {
                        if ( dealerUsuagePercentApplyToPart && dealerUsuagePercent < 1 && dealerUsuagePercent > 0)
                        {
                            //fp.Desc = ((!string.IsNullOrEmpty(fp.Desc)) ? fp.Desc : "").TrimEnd() + " - DALER PERCENTAGE APPLIED";
                            fp.Desc = ((!string.IsNullOrEmpty(fp.Desc)) ? fp.Desc : "").TrimEnd() + " - REPLACEMENT " + (dealerUsuagePercent * 100).ToString() + "%";
                            fp.Discount = dealerUsuagePercent * 100.00;
                        }
                    }
                    //</CODE_TAG_105542>
                    fileParts.Add(fp);
                    batch_Count++;
                    current_Records++;
                    if (batch_Count == 20 || current_Records >= total_Records)
                    {
                        //Get cat Price
                        partPrices = PartPriceProxy.GetPartPrice(division, customerNo, branchNo, PartIdentifiers);

                        ////Update Qty 
                        int partPricesIndex = 0;  // <CODE_TAG_101704>
                        foreach (PartPrice pp in partPrices)
                        {
                            // <CODE_TAG_101704>
                            partPricesIndex++;   
                            int filePartsIndex = 0;
                            // </CODE_TAG_101704>
                            foreach (FilePart fp1 in fileParts)
                            {
                                // <CODE_TAG_101704>
                                filePartsIndex++;
                                //!if (fp1.PARTNO == pp.PartNo && fp1.SOS == pp.Sos )  // here
                                if (fp1.PARTNO == pp.PartNo && fp1.SOS == pp.Sos && partPricesIndex == filePartsIndex)  // modified here to fix bug caused by multiple same part No in the XML file
                                // </CODE_TAG_101704>
                                {
                                    pp.Qty = fp1.Qty;
                                    pp.Discount = fp1.Discount; //<CODE_TAG_105542>R.Z

                                   // if (!pp.Valid)
                                    {
                                        pp.PartDesc = fp1.Desc;
                                    }

                                    foreach (PartPrice ReplacementPP in pp.Replacements)
                                    {
                                        ReplacementPP.Qty = ReplacementPP.Qty; // *fp1.Qty; 
                                    }
                                    foreach (PartPrice AlterPP in pp.Alternates)
                                    {
                                        AlterPP.Qty = pp.Qty; // fp1.Qty;  // here
                                    }

                                }
                            }
                        }


                        foreach (PartPrice pp in partPrices)
                        {
                            if (pp.ReplacementsFound)
                            {
                                partPrices_Replacements.Add(pp);
                            }
                            else
                            {
                                if (pp.AlternatesFound)
                                {
                                    partPrices_Alternates.Add(pp);
                                }
                                else
                                {
                                    if (!pp.Valid)
                                    {
                                        partPrices_Exceptions.Add(pp);
                                    }
                                    else
                                    {
                                        partPrices_Validated.Add(pp);
                                    }
                                }
                            }
                        }//end foreach put them into category

                        PartIdentifiers = new List<PartIdentifier>();
                        partPrices = new List<PartPrice>();
                        batch_Count = 0;
                    }// end if batch_count = 20
                }
                else  //CATPriceShow != "1"
                {
                    PartPrice pp = new PartPrice(part["PARTNO"].InnerText,"","");
                    pp.Sos = "000";
                    int tempInt = 0;
                    pp.PartNo = part["PARTNO"].InnerText.ToUpper( );
                    int.TryParse(part["QUANTITY"].InnerText, out tempInt);
                    pp.Qty = tempInt;
                    pp.PartDesc = part["PARTNAME"].InnerText;
                    partPrices_Validated.Add(pp);
                }

            }

            //display 
            if (partPrices_Validated.Count > 0)
            {
                rptParts_Validated.Visible = true;
                rptParts_Validated.DataSource = partPrices_Validated;
                rptParts_Validated.DataBind();
            }
            else
            {
                rptParts_Validated.Visible = false;
            }

            if (partPrices_Replacements.Count > 0)
            {
                rptParts_Replacements.Visible = true;
                rptParts_Replacements.DataSource = partPrices_Replacements;
                rptParts_Replacements.DataBind();
            }
            else
            {
                rptParts_Replacements.Visible = false;
            }

            if (partPrices_Alternates.Count > 0)
            {
                rptParts_Alternates.Visible = true;
                rptParts_Alternates.DataSource = partPrices_Alternates;
                rptParts_Alternates.DataBind();
            }
            else
            {
                rptParts_Alternates.Visible = false;
            }

            if (partPrices_Exceptions.Count > 0)
            {
                rptParts_Exceptions.Visible = true;
                rptParts_Exceptions.DataSource = partPrices_Exceptions;
                rptParts_Exceptions.DataBind();
            }
            else
            {
                rptParts_Exceptions.Visible = false;
            }

            if (partPrices_Validated.Count == 0 && partPrices_Replacements.Count == 0 && partPrices_Alternates.Count == 0)
            {
                lblErrorMessage.Text = "Cannot import this file, Please try it again.";
                btnImport.Visible = false;
                btnClose.Visible = false;
            }
            else
            {
                btnImport.Visible = true;
                btnClose.Visible = true;
            }

        
    }
    ////<Ticket 51393>
    protected void rptParts_Invalidated_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

    //    FilePart fp;
    //    Label tempLabel;
    //    switch (e.Item.ItemType)
    //    {
    //        case ListItemType.AlternatingItem:
    //        case ListItemType.Item:
    //            fp = e.Item.DataItem as FilePart;
    //            tempLabel = e.Item.FindControl("lblSOS") as Label;
    //            tempLabel.Text = fp.SOS;

    //            tempLabel = e.Item.FindControl("lblPartNo") as Label;
    //            tempLabel.Text = fp.PARTNO;

    //            tempLabel = e.Item.FindControl("lblDesc") as Label;
    //            tempLabel.Text = fp.Desc;

    //            tempLabel = e.Item.FindControl("lblQty") as Label;
    //            tempLabel.Text = fp.Qty.ToString();

    //            tempLabel = e.Item.FindControl("lblUnitPrice") as Label;
    //            tempLabel.Text = fp.UnitPrice.ToString();
    //            break;
    //    }
    }
    ////</Ticket 51393>
    protected void rptParts_Validated_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        HiddenField hidPartPrice;
        string strData;
        switch (e.Item.ItemType)
        {
            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblSOS") as Label;
                tempLabel.Text = pp.Sos;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblDesc") as Label;
                tempLabel.Text = pp.PartDesc;

                tempLabel = e.Item.FindControl("lblUnitSell") as Label;
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = pp.UnitSell.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitDisc") as Label;
                if (pp.UnitDisc.HasValue)
                    tempLabel.Text = pp.UnitDisc.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblNetSell") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitPrice") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblQty") as Label;
                tempLabel.Text = pp.Qty.ToString();


                tempLabel = e.Item.FindControl("lblCore") as Label;
                if (pp.CoreExtdSell > 0)
                    tempLabel.Text = "Y";

                hidPartPrice = e.Item.FindControl("hidPartPrice") as HiddenField;
                hidPartPrice.Value = PartUtil.BuildPartJsonData(pp);

                break;

        }
    }

    protected void rptParts_Replacement_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        HiddenField hidPartPrice;
        string strData;
        Repeater rptParts_Detail;
        Literal tempLiteral;
        switch (e.Item.ItemType)
        {
            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblSOS") as Label;
                tempLabel.Text = pp.Sos;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblDesc") as Label;
                tempLabel.Text = pp.PartDesc;

                tempLabel = e.Item.FindControl("lblUnitSell") as Label;
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = pp.UnitSell.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitDisc") as Label;
                if (pp.UnitDisc.HasValue)
                    tempLabel.Text = pp.UnitDisc.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblNetSell") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitPrice") as Label;
                
                //if (pp.UnitNet.HasValue)
                    //tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                //<CODE_TAG_102215> Victor20130930
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = (pp.UnitSell.Value - pp.UnitDisc.Value).ToString("0.00");
                else
                    tempLabel.Text = "0.00";
                //</CODE_TAG_102215>
                tempLabel = e.Item.FindControl("lblQty") as Label;
                tempLabel.Text = pp.Qty.ToString();

                tempLabel = e.Item.FindControl("lblCore") as Label;
                if (pp.CoreExtdSell > 0)
                    tempLabel.Text = "Y";

                curPartNo = pp.PartNo;
                tempLiteral = e.Item.FindControl("litRadioPart") as Literal;
                tempLiteral.Text = "<input type='radio'  partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "'  name='" + curPartNo + "' onclick=\"setReplacementSelectedPart('" + curPartNo + "', 0);\" value='0' />";
                curPartIndex = 0;

                rptParts_Detail = e.Item.FindControl("rptParts_Detail") as Repeater;
                if (pp.ReplacementsFound)
                    rptParts_Detail.DataSource = pp.Replacements;
                else
                    rptParts_Detail.DataSource = pp.Alternates;
                rptParts_Detail.DataBind();
                break;
        }
    }

    protected void rptParts_Replacement_Detail_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        HiddenField hidPartPrice;
        string strData;
        Literal tempLiteral;
        switch (e.Item.ItemType)
        {
            case ListItemType.Header:
                tempLiteral = e.Item.FindControl("litRadioPart") as Literal;
                tempLiteral.Text = "<input type='radio' partData='' name='" + curPartNo + "' checked='true'  onclick=\"setReplacementSelectedPart('" + curPartNo + "', 1);\" value='1' />";
                break;

            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblSOS") as Label;
                tempLabel.Text = pp.Sos;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblDesc") as Label;
                tempLabel.Text = pp.PartDesc;

                tempLabel = e.Item.FindControl("lblUnitSell") as Label;
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = pp.UnitSell.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitDisc") as Label;
                if (pp.UnitDisc.HasValue)
                    tempLabel.Text = pp.UnitDisc.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblNetSell") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitPrice") as Label;

                //if (pp.UnitNet.HasValue)
                //    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                //<CODE_TAG_102215> Victor20130930
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = (pp.UnitSell.Value - pp.UnitDisc.Value).ToString();
                else
                    tempLabel.Text = "0.00";
                //</CODE_TAG_102215>
                tempLabel = e.Item.FindControl("lblQty") as Label;
                tempLabel.Text = pp.Qty.ToString();

                tempLabel = e.Item.FindControl("lblCore") as Label;
                if (pp.CoreExtdSell > 0)
                    tempLabel.Text = "Y";

                tempLabel = e.Item.FindControl("lblIndirect") as Label;
                if (pp.FactoryFlag == "RPLCAT")
                    tempLabel.Text = "Indirect Replacement Contact Dealer";


                tempLiteral = e.Item.FindControl("litCheckboxPart") as Literal;
                curPartIndex++;
                tempLiteral.Text = "<input type='checkbox' " + ((pp.FactoryFlag == "RPLCAT") ? " indirectFlag='Y' " : "checked='true'  indirectFlag='N' ") + "   name='chk_" + curPartNo + "_" + curPartIndex + "' partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "' value='" + curPartIndex + "' />";

                break;

        }
    }

    protected void rptParts_Alter_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        HiddenField hidPartPrice;
        string strData;
        Repeater rptParts_Detail;
        Literal tempLiteral;
        switch (e.Item.ItemType)
        {
            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblSOS") as Label;
                tempLabel.Text = pp.Sos;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblDesc") as Label;
                tempLabel.Text = pp.PartDesc;

                tempLabel = e.Item.FindControl("lblUnitSell") as Label;
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = pp.UnitSell.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitDisc") as Label;
                if (pp.UnitDisc.HasValue)
                    tempLabel.Text = pp.UnitDisc.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblNetSell") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitPrice") as Label;
                
                //if (pp.UnitNet.HasValue)
                //    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                //<CODE_TAG_102215> Victor20130930
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = (pp.UnitSell.Value - pp.UnitDisc.Value).ToString("0.00");

                else
                    tempLabel.Text = "0.00";
                //<CODE_TAG_102215>
                tempLabel = e.Item.FindControl("lblQty") as Label;
                    tempLabel.Text = pp.Qty.ToString();

                tempLabel = e.Item.FindControl("lblCore") as Label;
                if (pp.CoreExtdSell > 0)
                    tempLabel.Text = "Y";

                curPartNo = pp.PartNo;
                tempLiteral = e.Item.FindControl("litRadioPart") as Literal;
                tempLiteral.Text = "<input type='radio' checked partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "'  name='" + curPartNo + globalIndex.ToString() + "' onclick='setSelectedPart(this);' value='0' />"; //<Ticket 48408>
                curPartIndex = 0;

                
                rptParts_Detail = e.Item.FindControl("rptParts_Detail") as Repeater;
                if (pp.ReplacementsFound)
                    rptParts_Detail.DataSource = pp.Replacements;
                else
                    rptParts_Detail.DataSource = pp.Alternates;
                rptParts_Detail.DataBind();

                globalIndex ++;//<Ticket 48408>
                break;
        }
    }

    protected void rptParts_Alter_Detail_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        HiddenField hidPartPrice;
        string strData;
        Literal tempLiteral;
        switch (e.Item.ItemType)
        {
            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblSOS") as Label;
                tempLabel.Text = pp.Sos;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblDesc") as Label;
                tempLabel.Text = pp.PartDesc;

                tempLabel = e.Item.FindControl("lblUnitSell") as Label;
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = pp.UnitSell.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitDisc") as Label;
                if (pp.UnitDisc.HasValue)
                    tempLabel.Text = pp.UnitDisc.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblNetSell") as Label;
                if (pp.UnitNet.HasValue)
                    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                else
                    tempLabel.Text = "0.00";

                tempLabel = e.Item.FindControl("lblUnitPrice") as Label;
                //if (pp.UnitNet.HasValue)
                //    tempLabel.Text = pp.UnitNet.Value.ToString("0.00");
                //<CODE_TAG_102215> Victor20130930
                if (pp.UnitSell.HasValue)
                    tempLabel.Text = (pp.UnitSell.Value - pp.UnitDisc.Value).ToString("0.00");

                else
                    tempLabel.Text = "0.00";
                //</CODE_TAG_102215>
                tempLabel = e.Item.FindControl("lblQty") as Label;
                    tempLabel.Text = pp.Qty.ToString();


                tempLabel = e.Item.FindControl("lblCore") as Label;
                if (pp.CoreExtdSell > 0)
                    tempLabel.Text = "Y";

                tempLiteral = e.Item.FindControl("litRadioPart") as Literal;
                curPartIndex++;
                tempLiteral.Text = "<input type='radio' name='" + curPartNo + globalIndex .ToString()+ "' partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "' onclick='setSelectedPart(this);' value='" + curPartIndex + "' />"; //<Ticket 48408>

                break;

        }
    }

    protected void rptParts_Exceptions_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        PartPrice pp;
        Label tempLabel;
        string strData;
        Literal tempLiteral;
        switch (e.Item.ItemType)
        {
            case ListItemType.AlternatingItem:
            case ListItemType.Item:
                pp = e.Item.DataItem as PartPrice;

                tempLabel = e.Item.FindControl("lblPartNo") as Label;
                tempLabel.Text = pp.PartNo;

                tempLabel = e.Item.FindControl("lblMsg") as Label;
                tempLabel.Text = pp.ErrorMessage;

                tempLiteral = e.Item.FindControl("litCheckPart") as Literal;
                tempLiteral.Text = "<input type='checkbox' name='" + pp.PartNo + "' partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "' />";

                break;
        }
    }
    ////<Ticket 51393>R.Z
    protected void btnImport_Click(object sender, EventArgs e)
    {
    //    string invalidPartImportInd = this.hdnInvalidPartImportInd.Value;
    //    segmentId = Request.QueryString["segmentId"].AsInt(0);
    //    //DAL.Quote.MyWatcher_Add("L724 in ImportXMLParts", invalidPartImportInd);
    //    //DAL.Quote.MyWatcher_Add("L726 segmentId in ImportXMLParts", segmentId.ToString());
    }
    ////<Ticket 51393>
}

public class FilePart
{
    public string SOS { get; set; }
    public string PARTNO { get; set; }
    public int Qty { get; set; }
    public string Desc { get; set; }
    //public double? UnitPrice { get; set; } //<Ticket 51393>R.Z
    public double Discount { get; set; }//<CODE_TAG_105542>R.Z //to hold discount price from XML 
}

