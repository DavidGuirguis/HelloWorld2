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

public partial class ImportBulkParts : UI.Abstracts.Pages.Plain
{
    //<CODE_TAG_104427> Dav
    public bool isShowDiscount = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show");
    public bool isMarkupDiscount = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup"); 
    public string partDiscountHeading = AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.Discount.Heading"].ToString();
    //</CODE_TAG_104427> Dav

    string curPartNo = "";
    int curPartIndex = 0;
    int segmentId = 0;
    int globalIndex = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        if (!Page.IsPostBack)
        {
            btnImport.Visible = false;
            btnClose.Visible = false;

			btnImport2.Visible = false;
			btnClose2.Visible = false;
        }
    }

	protected void btnNext_Click(object sender, EventArgs e)
    {
		/* Original File
		<PARTSLIST VERSIONNUMBER="SISXML1.0">
			<HEADER>
				<SERIALNO>2DS</SERIALNO>
				<ORDERID>b190jst2DS</ORDERID>
				<WORKORDER />
				<SEGMENT />
				<JOBCODE />
				<USERID>b190jst</USERID>
				<ADDITIONALNOTES />
			</HEADER>
			<PARTS>
				<PART>
					<PARTNO>3B-8489</PARTNO>
					<PARTNAME>FITTING-GREASE (IDLER-FRONT)</PARTNAME>
					<MODIFIER> (IDLER-FRONT)</MODIFIER>
					<QUANTITY>8</QUANTITY>
					<GROUPNO>190-5313</GROUPNO>
					<GROUPNAME>IDLER GP-FRONT</GROUPNAME>
					<USERNOTE />
					<PARENTAGE>0</PARENTAGE>
					<REFERENCENO>1</REFERENCENO>
					<PARTNOTE />
					<SMCSCODE>4159</SMCSCODE>
					<TYPE>AA</TYPE>
				</PART>
			</PARTS>
		 </PARTSLIST>
		 */

		/*********************************************************************************************/
		/* Manually created File
		<PARTSLIST VERSIONNUMBER="SISXML1.0">
			<PARTS>
				<PART>
					<SOS>000</SOS>
					<PARTNO>3B-8489</PARTNO>
					<PARTNAME></PARTNAME>
					<QUANTITY>8</QUANTITY>
				</PART>
			</PARTS>
		 </PARTSLIST>
		 */

		string strXML = "";
		strXML += @"<PARTSLIST VERSIONNUMBER=""SISXML1.0""><PARTS>";

		for (int i = 1; i <= hidRowsCount.Value.As<int>(); i++)
		{
			if(Request.Form["txtPartNo" + i.ToString()].Trim() != "")
                //<CODE_TAG_104427> Dav
                //strXML += "<PART><SOS><![CDATA[" + Request.Form["txtSOS" + i.ToString()].Trim() + "]]></SOS><PARTNO><![CDATA[" + Request.Form["txtPartNo" + i.ToString()].Trim() + "]]></PARTNO><PARTNAME><![CDATA[]]></PARTNAME><QUANTITY><![CDATA[" + Request.Form["txtQty" + i.ToString()].Trim() + "]]></QUANTITY></PART>";
                strXML += "<PART><SOS><![CDATA[" + Request.Form["txtSOS" + i.ToString()].Trim() + "]]></SOS><PARTNO><![CDATA[" + Request.Form["txtPartNo" + i.ToString()].Trim() + "]]></PARTNO><PARTNAME><![CDATA[]]></PARTNAME><QUANTITY><![CDATA[" + Request.Form["txtQty" + i.ToString()].Trim() + "]]></QUANTITY><DISCOUNT><![CDATA[" + Request.Form["txtPartDiscount" + i.ToString()].Trim() + "]]></DISCOUNT></PART>";
                //</CODE_TAG_104427> Dav
		}
		
		strXML += "</PARTS></PARTSLIST>";
		displayParts(strXML);
    }

	private void displayParts(string strXML)
	{
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
				PartIdentifier p = new PartIdentifier();
				p.PartNo = part["PARTNO"].InnerText.ToUpper();
				if (part["SOS"] != null)
					p.SOS = part["SOS"].InnerText.ToUpper();
				else
					p.SOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper();
				int.TryParse(part["QUANTITY"].InnerText, out tempInt);
				p.Qty = tempInt;
				PartIdentifiers.Add(p);

				FilePart fp = new FilePart();
                //<CODE_TAG_104427> Dav
				//fp.SOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper();

                if (part["SOS"] != null)
                    fp.SOS = part["SOS"].InnerText.ToUpper();
                else
                    fp.SOS = AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper();
                //</CODE_TAG_104427> Dav
				fp.PARTNO = part["PARTNO"].InnerText;
				int.TryParse(part["QUANTITY"].InnerText, out tempInt);
				fp.Qty = tempInt;
				fp.Desc = part["PARTNAME"].InnerText;
                fp.Discount = part["DISCOUNT"].InnerText.As<double>(0);           //<CODE_TAG_104427> Dav
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
							//!if (fp1.PARTNO == pp.PartNo && fp1.SOS == pp.Sos )
                            if (fp1.PARTNO.ToUpper() == pp.PartNo.ToUpper() && fp1.SOS.ToUpper() == pp.Sos.ToUpper() && partPricesIndex == filePartsIndex)  // modified here to fix bug caused by multiple same part No in the XML file
							// </CODE_TAG_101704>
							{
								pp.Qty = fp1.Qty;
                                pp.Discount = fp1.Discount;     //<CODE_TAG_104427> Dav

								foreach (PartPrice ReplacementPP in pp.Replacements)
								{
									ReplacementPP.Qty = ReplacementPP.Qty; // *fp1.Qty;
                                    ReplacementPP.Discount = pp.Discount;     //<CODE_TAG_104427> Dav
								}
								foreach (PartPrice AlterPP in pp.Alternates)
								{
									AlterPP.Qty = pp.Qty; // fp1.Qty;  // here
                                    AlterPP.Discount = pp.Discount;     //<CODE_TAG_104427> Dav
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
                PartPrice pp = new PartPrice(part["PARTNO"].InnerText, "", "");
                pp.Sos = "000";
                int tempInt = 0;
                pp.PartNo = part["PARTNO"].InnerText.ToUpper();
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

		//lblWaitingScript.Text = "<script type=\"text/javascript\">$(\"#div_Waiting\").hide();</script>";
		if (partPrices_Validated.Count == 0 && partPrices_Replacements.Count == 0 && partPrices_Alternates.Count == 0)
		{
			lblErrorMessage.Text = "No valid parts to be imported.";
			btnImport.Visible = false;
			btnClose.Visible = false;

			btnImport2.Visible = false;
			btnClose2.Visible = false;
		}
		else
		{
			btnImport.Visible = true;
			btnClose.Visible = true;

			btnImport2.Visible = true;
			btnClose2.Visible = true;
		}
	}

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
                tempLiteral.Text = "<input type='radio' checked partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "'  name='" + curPartNo + globalIndex.ToString() + "' onclick='setSelectedPart(this);' value='0' />";
                curPartIndex = 0;


                rptParts_Detail = e.Item.FindControl("rptParts_Detail") as Repeater;
                if (pp.ReplacementsFound)
                    rptParts_Detail.DataSource = pp.Replacements;
                else
                    rptParts_Detail.DataSource = pp.Alternates;
                rptParts_Detail.DataBind();

                globalIndex ++;
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
                tempLiteral.Text = "<input type='radio' name='" + curPartNo + globalIndex .ToString()+ "' partData='" + HttpContext.Current.Server.HtmlEncode(PartUtil.BuildPartJsonData(pp)) + "' onclick='setSelectedPart(this);' value='" + curPartIndex + "' />";

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

}

public class FilePart
{
    public string SOS { get; set; }
    public string PARTNO { get; set; }
    public int Qty { get; set; }
    public string Desc { get; set; }
    public double Discount { get; set; }        //<CODE_TAG_104427> Dav
}

