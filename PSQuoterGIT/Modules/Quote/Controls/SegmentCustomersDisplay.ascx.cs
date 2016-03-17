using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using X.Extensions;
using Helpers;

public partial class Modules_Quote_Controls_SegmentCustomerDisplay : UcSegmentCustomerDisplay
{
    protected string CATAPICustomerNo="";
    public override void Render()
    {

        DataSet ds = DAL.Quote.QuoteGetSegmentCustomer(SegmentId);

        if (ds.Tables[0].Rows.Count == 0)
            return;
        DataRow drCurrentSegment = ds.Tables[0].Rows[0];

        string segmentCustomer1No = "";
        string segmentCustomer2No = "";
        string segmentCustomer3No = "";
        double totalParts = drCurrentSegment["partFlatRateAmount"].AsDouble();
        double totalLabor = drCurrentSegment["laborFlatRateAmount"].AsDouble();
        double totalMisc = drCurrentSegment["miscFlatRateAmount"].AsDouble();
        double headerCustomerTotal = 0;
        double segmentCustomer1Total = 0;
        double segmentCustomer2Total = 0;
        double segmentCustomer3Total = 0;
        double tempDouble = 0;
        double tempPercent = 0;
        int showCustomerCount = 0;
        // <CODE_TAG_101750>
        int SegmentQty = drCurrentSegment["SegmentQty"].AsInt();

        if (drCurrentSegment["partsPercent"].AsDouble(0) == 100 && drCurrentSegment["partsCustomerNo"].ToString().Trim() != "")
            CATAPICustomerNo = drCurrentSegment["partsCustomerNo"].ToString().Trim();
        else
            CATAPICustomerNo = drCurrentSegment["HeaderCustomerNo"].ToString().Trim();

        string partFlatRateIndDesc = "";
        if (drCurrentSegment["partFlatRateInd"].ToString() == "E") partFlatRateIndDesc = Consts.EstimateFlag;
        if (drCurrentSegment["partFlatRateInd"].ToString() == "F") partFlatRateIndDesc = Consts.FlatRateFlag;

        string laborFlatRateIndDesc = "";
        if (drCurrentSegment["laborFlatRateInd"].ToString() == "E") laborFlatRateIndDesc = Consts.EstimateFlag;
        if (drCurrentSegment["laborFlatRateInd"].ToString() == "F") laborFlatRateIndDesc = Consts.FlatRateFlag;

        string miscFlatRateIndDesc = "";
        if (drCurrentSegment["miscFlatRateInd"].ToString() == "E") miscFlatRateIndDesc = Consts.EstimateFlag;
        if (drCurrentSegment["miscFlatRateInd"].ToString() == "F") miscFlatRateIndDesc = Consts.FlatRateFlag;





        if (drCurrentSegment["partsCustomerNo"].ToString() != "")
            segmentCustomer1No = drCurrentSegment["partsCustomerNo"].ToString();
        if (drCurrentSegment["laborCustomerNo"].ToString() != "" && drCurrentSegment["laborCustomerNo"].ToString() != segmentCustomer1No)
        {
            if (segmentCustomer1No == "")
                segmentCustomer1No = drCurrentSegment["laborCustomerNo"].ToString();
            else
                segmentCustomer2No = drCurrentSegment["laborCustomerNo"].ToString();
        }
        if (drCurrentSegment["miscCustomerNo"].ToString() != "" && drCurrentSegment["miscCustomerNo"].ToString() != segmentCustomer1No && drCurrentSegment["MiscCustomerNo"].ToString() != segmentCustomer2No)
        {
            if (segmentCustomer1No == "")
                segmentCustomer1No = drCurrentSegment["miscCustomerNo"].ToString();
            else
            {
                if (segmentCustomer2No == "")
                    segmentCustomer2No = drCurrentSegment["miscCustomerNo"].ToString();
                else
                    segmentCustomer3No = drCurrentSegment["miscCustomerNo"].ToString();
            }
        }


        //Header customer
        //parts



        lblHeaderCustomer.Text = drCurrentSegment["HeaderCustomerNo"].ToString() + " - " + drCurrentSegment["HeaderCustomerName"].ToString();
            //  Response.Write(lblHeaderCustomer.Text); Response.End();
            if (drCurrentSegment["partsCustomerNo"].ToString() == "")
            {
                lblHeaderCustomerPartsPercent.Text = "100%";
                lblHeaderCustomerPartsInd.Text = partFlatRateIndDesc;
                lblHeaderCustomerPartsTotal.Text = Util.NumberFormat(totalParts, 2, null, null, null, true);
                //headerCustomerTotal += totalParts;
                headerCustomerTotal += Math.Round(totalParts, 2, MidpointRounding.AwayFromZero);  //<Ticket 33900>
            }
            else
            {
                tempPercent = 1 - drCurrentSegment["partsPercent"].AsDouble() / 100;
                tempDouble = totalParts * tempPercent;
                //headerCustomerTotal += tempDouble;
                headerCustomerTotal += Math.Round(tempDouble, 2, MidpointRounding.AwayFromZero);//<Ticket 33900>
                lblHeaderCustomerPartsPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblHeaderCustomerPartsInd.Text = partFlatRateIndDesc;
                lblHeaderCustomerPartsTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);

            }

            //labor
            if (drCurrentSegment["laborCustomerNo"].ToString() == "")
            {
                lblHeaderCustomerLaborPercent.Text = "100%";
                lblHeaderCustomerLaborInd.Text = laborFlatRateIndDesc;
                lblHeaderCustomerLaborTotal.Text = Util.NumberFormat(totalLabor, 2, null, null, null, true);
                //headerCustomerTotal += totalLabor;
                headerCustomerTotal += Math.Round(totalLabor, 2, MidpointRounding.AwayFromZero); //<Ticket 33900>
            }
            else
            {
                tempPercent = 1 - drCurrentSegment["laborPercent"].AsDouble() / 100;
                tempDouble = totalLabor * tempPercent;
                //headerCustomerTotal += tempDouble;
                headerCustomerTotal += Math.Round(tempDouble, 2, MidpointRounding.AwayFromZero); //<Ticket 33900>
                lblHeaderCustomerLaborPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblHeaderCustomerLaborInd.Text = laborFlatRateIndDesc;
                lblHeaderCustomerLaborTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }
            //Misc
            if (drCurrentSegment["miscCustomerNo"].ToString() == "")
            {
                lblHeaderCustomerMiscPercent.Text = "100%";
                lblHeaderCustomerMiscInd.Text = miscFlatRateIndDesc;
                lblHeaderCustomerMiscTotal.Text = Util.NumberFormat(totalMisc, 2, null, null, null, true);
                //headerCustomerTotal += totalMisc;
                headerCustomerTotal += Math.Round(totalMisc, 2, MidpointRounding.AwayFromZero); //<Ticket 33900>
            }
            else
            {
                tempPercent = 1 - drCurrentSegment["miscPercent"].AsDouble() / 100;
                tempDouble = totalMisc * tempPercent;
                headerCustomerTotal += tempDouble;
                headerCustomerTotal += Math.Round(tempDouble, 2, MidpointRounding.AwayFromZero); //<Ticket 33900>
                lblHeaderCustomerMiscPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblHeaderCustomerMiscInd.Text = miscFlatRateIndDesc;
                lblHeaderCustomerMiscTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }
            //header total
            lblHeaderCustomerTotal.Text = Util.NumberFormat(headerCustomerTotal, 2, null, null, null, true);
            // <CODE_TAG_101750>
            //lblHeaderCustomerSegmentTotal.Text = Util.NumberFormat(headerCustomerTotal * SegmentQty, 2, null, null, null, true);
            //lblHeaderCustomerSegmentTotal.Text = Util.NumberFormat( headerCustomerTotal * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032> //LLL //Changed for <Ticket 33900>
            lblHeaderCustomerSegmentTotal.Text = Util.NumberFormat( Math.Round(headerCustomerTotal,2) * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032> //LLL //Changed for <Ticket 33900>
       
        //segment Customer 1
        if (segmentCustomer1No == "")
        {
            trSegmentCustomer1.Visible = false;
        }
        else
        {
            //parts
            if (drCurrentSegment["partsCustomerNo"].ToString() == segmentCustomer1No)
            {
                lblSegmentCustomer1.Text = segmentCustomer1No + " - " + drCurrentSegment["partsCustomerName"].ToString();
                tempPercent = drCurrentSegment["partsPercent"].AsDouble() / 100;
                tempDouble = totalParts * tempPercent;
                segmentCustomer1Total += tempDouble;
                lblSegmentCustomer1PartsPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer1PartsInd.Text = partFlatRateIndDesc;
                lblSegmentCustomer1PartsTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //labor
            if (drCurrentSegment["laborCustomerNo"].ToString() == segmentCustomer1No)
            {
                lblSegmentCustomer1.Text = segmentCustomer1No + " - " + drCurrentSegment["laborCustomerName"].ToString();
                tempPercent = drCurrentSegment["laborPercent"].AsDouble() / 100;
                tempDouble = totalLabor * tempPercent;
                segmentCustomer1Total += tempDouble;
                lblSegmentCustomer1LaborPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer1LaborInd.Text = laborFlatRateIndDesc;
                lblSegmentCustomer1LaborTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //Misc
            if (drCurrentSegment["miscCustomerNo"].ToString() == segmentCustomer1No)
            {
                lblSegmentCustomer1.Text = segmentCustomer1No + " - " + drCurrentSegment["miscCustomerName"].ToString();
                tempPercent = drCurrentSegment["miscPercent"].AsDouble() / 100;
                tempDouble = totalMisc * tempPercent;
                segmentCustomer1Total += tempDouble;
                lblSegmentCustomer1MiscPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer1MiscInd.Text = miscFlatRateIndDesc;
                lblSegmentCustomer1MiscTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //segment customer1 total
            lblSegmentCustomer1Total.Text = Util.NumberFormat(segmentCustomer1Total, 2, null, null, null, true);
            // <CODE_TAG_101750>
            //lblSegmentCustomer1SegmentTotal.Text = Util.NumberFormat(segmentCustomer1Total * SegmentQty, 2, null, null, null, true);
            //lblSegmentCustomer1SegmentTotal.Text = Util.NumberFormat(segmentCustomer1Total * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032> //LLL
            lblSegmentCustomer1SegmentTotal.Text = Util.NumberFormat(Math.Round(segmentCustomer1Total, 2, MidpointRounding.AwayFromZero) * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032> //LLL //<Ticket 33900>

        }


        //segment Customer 2
        if (segmentCustomer2No == "")
        {
            trSegmentCustomer2.Visible = false;
        }
        else
        {

            //parts
            if (drCurrentSegment["partsCustomerNo"].ToString() == segmentCustomer2No)
            {
                lblSegmentCustomer2.Text = segmentCustomer2No + " - " + drCurrentSegment["partsCustomerName"].ToString();
                tempPercent = drCurrentSegment["partsPercent"].AsDouble() / 100;
                tempDouble = totalParts * tempPercent;
                segmentCustomer2Total += tempDouble;
                lblSegmentCustomer2PartsPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer2PartsInd.Text = partFlatRateIndDesc;
                lblSegmentCustomer2PartsTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //labor
            if (drCurrentSegment["laborCustomerNo"].ToString() == segmentCustomer2No)
            {
                lblSegmentCustomer2.Text = segmentCustomer2No + " - " + drCurrentSegment["laborCustomerName"].ToString();
                tempPercent = drCurrentSegment["laborPercent"].AsDouble() / 100;
                tempDouble = totalLabor * tempPercent;
                segmentCustomer2Total += tempDouble;
                lblSegmentCustomer2LaborPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer2LaborInd.Text = laborFlatRateIndDesc;
                lblSegmentCustomer2LaborTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //Misc
            if (drCurrentSegment["miscCustomerNo"].ToString() == segmentCustomer2No)
            {
                lblSegmentCustomer2.Text = segmentCustomer1No + " - " + drCurrentSegment["miscCustomerName"].ToString();
                tempPercent = drCurrentSegment["miscPercent"].AsDouble() / 100;
                tempDouble = totalMisc * tempPercent;
                segmentCustomer2Total += tempDouble;
                lblSegmentCustomer2MiscPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer2MiscInd.Text = miscFlatRateIndDesc;
                lblSegmentCustomer2MiscTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //segment customer2 total
            lblSegmentCustomer2Total.Text = Util.NumberFormat(segmentCustomer2Total, 2, null, null, null, true);
            // <CODE_TAG_101750>
            //lblSegmentCustomer2SegmentTotal.Text = Util.NumberFormat(segmentCustomer2Total * SegmentQty, 2, null, null, null, true);
            //lblSegmentCustomer2SegmentTotal.Text = Util.NumberFormat(segmentCustomer2Total * SegmentQty, 2, null, null, null, true); //<CODE_TAG_102032> //LLL
            lblSegmentCustomer2SegmentTotal.Text = Util.NumberFormat( Math.Round(segmentCustomer2Total,2,MidpointRounding.AwayFromZero) * SegmentQty, 2, null, null, null, true); //<CODE_TAG_102032> //LLL//<Ticket 33900>
        }



        //segment Customer 3
        if (segmentCustomer3No == "")
        {
            trSegmentCustomer3.Visible = false;
        }
        else
        {
            //parts
            if (drCurrentSegment["partsCustomerNo"].ToString() == segmentCustomer3No)
            {
                lblSegmentCustomer3.Text = segmentCustomer3No + " - " + drCurrentSegment["partsCustomerName"].ToString();
                tempPercent = drCurrentSegment["partsPercent"].AsDouble() / 100;
                tempDouble = totalParts * tempPercent;
                segmentCustomer3Total += tempDouble;
                lblSegmentCustomer3PartsPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer3PartsInd.Text = partFlatRateIndDesc;
                lblSegmentCustomer3PartsTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //labor
            if (drCurrentSegment["laborCustomerNo"].ToString() == segmentCustomer3No)
            {
                lblSegmentCustomer3.Text = segmentCustomer3No + " - " + drCurrentSegment["laborCustomerName"].ToString();
                tempPercent = drCurrentSegment["laborPercent"].AsDouble() / 100;
                tempDouble = totalLabor * tempPercent;
                segmentCustomer3Total += tempDouble;
                lblSegmentCustomer3LaborPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer3LaborInd.Text = laborFlatRateIndDesc;
                lblSegmentCustomer3LaborTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //Misc
            if (drCurrentSegment["miscCustomerNo"].ToString() == segmentCustomer3No)
            {
                lblSegmentCustomer3.Text = segmentCustomer3No + " - " + drCurrentSegment["miscCustomerName"].ToString();
                tempPercent = drCurrentSegment["miscPercent"].AsDouble() / 100;
                tempDouble = totalMisc * tempPercent;
                segmentCustomer3Total += tempDouble;
                lblSegmentCustomer3MiscPercent.Text = Util.NumberFormat(tempPercent * 100, 0, null, null, null, true) + "%";
                lblSegmentCustomer3MiscInd.Text = miscFlatRateIndDesc;
                lblSegmentCustomer3MiscTotal.Text = Util.NumberFormat(tempDouble, 2, null, null, null, true);
            }

            //segment customer3 total
            //lblSegmentCustomer3Total.Text = Util.NumberFormat(segmentCustomer1Total, 2, null, null, null, true);
            lblSegmentCustomer3Total.Text = Util.NumberFormat(segmentCustomer3Total, 2, null, null, null, true);  //<Ticket 33900>
            // <CODE_TAG_101750>
            //lblSegmentCustomer3SegmentTotal.Text = Util.NumberFormat(segmentCustomer1Total * SegmentQty, 2, null, null, null, true);
            //lblSegmentCustomer3SegmentTotal.Text = Util.NumberFormat(segmentCustomer1Total * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032>  //LLL
            lblSegmentCustomer3SegmentTotal.Text = Util.NumberFormat( Math.Round( segmentCustomer3Total,2, MidpointRounding.AwayFromZero) * SegmentQty, 2, null, null, null, true);//<CODE_TAG_102032>  //LLL //<Ticket 33900>

        }

        lblPartsTotalInd.Text = partFlatRateIndDesc;
        //rounding process for <Ticket 33900>
        //re-pick up totalParts from textbox instead of value from db, because the when rounding process and segment qty process, it makes rounding accumulation total issues. for  instance Estamate Parts 345.21,  2 custmer with 50%,  itwill be 172.61, totally will 345.22 instead of 345.21,, if there is  SegQty = 10, make total issues
        totalParts = ((string.IsNullOrEmpty(lblHeaderCustomerPartsTotal.Text)) ? 0 : Convert.ToDouble(lblHeaderCustomerPartsTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer1PartsTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer1PartsTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer2PartsTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer2PartsTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer3PartsTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer3PartsTotal.Text));
        totalParts = Math.Round(totalParts, 2, MidpointRounding.AwayFromZero);

        totalLabor = ((string.IsNullOrEmpty(lblHeaderCustomerLaborTotal.Text)) ? 0 : Convert.ToDouble(lblHeaderCustomerLaborTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer1LaborTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer1LaborTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer2LaborTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer2LaborTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer3LaborTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer3LaborTotal.Text));
        totalLabor = Math.Round(totalLabor, 2, MidpointRounding.AwayFromZero);

        totalMisc = ((string.IsNullOrEmpty(lblHeaderCustomerMiscTotal.Text)) ? 0 : Convert.ToDouble(lblHeaderCustomerMiscTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer1MiscTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer1MiscTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer2MiscTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer2MiscTotal.Text))
                    + ((string.IsNullOrEmpty(lblSegmentCustomer3MiscTotal.Text)) ? 0 : Convert.ToDouble(lblSegmentCustomer3MiscTotal.Text));
        totalMisc = Math.Round(totalMisc, 2, MidpointRounding.AwayFromZero);

        
        //</Ticket 33900>
        lblPartsTotal.Text = Util.NumberFormat(totalParts, 2, null, null, null, true);
        lblLaborTotalInd.Text = laborFlatRateIndDesc;
        lblLaborTotal.Text = Util.NumberFormat(totalLabor, 2, null, null, null, true);
        lblMiscTotalInd.Text = miscFlatRateIndDesc;
        lblMiscTotal.Text = Util.NumberFormat(totalMisc, 2, null, null, null, true);
        lblGrandTotal.Text = Util.NumberFormat(totalParts + totalLabor + totalMisc, 2, null, null, null, true);
        //lblGrandSegmentTotal.Text = Util.NumberFormat((totalParts + totalLabor + totalMisc)*SegmentQty, 2, null, null, null, true);
        lblGrandSegmentTotal.Text = Util.NumberFormat((totalParts + totalLabor + totalMisc) * SegmentQty, 2, null, null, null, true); //<CODE_TAG_102032>//LLL

        if (drCurrentSegment["totalFlatRateInd"].ToString() == "F")
        {
            lblGrandTotal.Text = Util.NumberFormat(drCurrentSegment["totalFlatRateAmount"].AsDouble(0), 2, null, null, null, true);
            lblGrandSegmentTotal.Text = Util.NumberFormat(drCurrentSegment["totalFlatRateAmount"].AsDouble(0) * SegmentQty, 2, null, null, null, true);
            //lblGrandSegmentTotal.Text = Util.NumberFormat(drCurrentSegment["totalFlatRateAmount"].AsDouble(0), 2, null, null, null, true);//<CODE_TAG_102032>
        }
        else
        {
            lblGrandTotal.Text = Util.NumberFormat(totalParts + totalLabor + totalMisc, 2, null, null, null, true);
            lblGrandSegmentTotal.Text = Util.NumberFormat((totalParts + totalLabor + totalMisc)*SegmentQty, 2, null, null, null, true);
            //lblGrandSegmentTotal.Text = Util.NumberFormat((totalParts + totalLabor + totalMisc), 2, null, null, null, true);//<CODE_TAG_102032>
        }
        txtGrandTotal.Text = lblGrandTotal.Text;
        //txtGrandSegmentTotal.Text = lblGrandSegmentTotal.Text;
        lblGrandTotalVariance.Text = "Variance: " + Util.NumberFormat(drCurrentSegment["totalFlatRateAmount"].AsDouble(0) - (totalParts + totalLabor + totalMisc), 2, null, null, null, true);



        showCustomerCount = 0;
        if (headerCustomerTotal > 0) showCustomerCount++;
        if (segmentCustomer1Total > 0) showCustomerCount++;
        if (segmentCustomer2Total > 0) showCustomerCount++;
        if (segmentCustomer3Total > 0) showCustomerCount++;

        //Victor 2013.4.30
        //if (showCustomerCount == 1 && SegmentEdit) 
        if ((showCustomerCount == 1 || (segmentCustomer1No == "" && segmentCustomer2No == "" && segmentCustomer3No == "")) && SegmentEdit)
        {
            if (headerCustomerTotal == 0) trSegmentCustomerHeader.Visible = false;
            if (drCurrentSegment["totalFlatRateInd"].ToString() == "F")
            {
                lstTotalFlatRate.SelectedValue = "F";
                lblGrandTotal.Style.Add("display", "none");
                //lblGrandSegmentTotal.Style.Add("display", "none");
            }
            else
            {
                lstTotalFlatRate.SelectedValue = "N";
                txtGrandTotal.Style.Add("display", "none");
            //    txtGrandSegmentTotal.Style.Add("display", "none");
            }
        }
        else
        {
            if (drCurrentSegment["totalFlatRateInd"].ToString() == "F")
            {
                lblGrandTotalInd.Text = "FLAT RATE ALL";
                lblGrandSegmentTotalInd.Text = "FLAT RATE ALL";
            }
            else
            {
                lblGrandTotalInd.Text = "Calculated";
                lblGrandSegmentTotalInd.Text = "Calculated";
            }
            lstTotalFlatRate.Visible = false;
            txtGrandTotal.Visible = false;
            //txtGrandSegmentTotal.Visible = false;
        }

        
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.FlatRateAll.Show"))
        {
            lstTotalFlatRate.Visible = false;
            lblGrandTotalVariance.Visible = false;
            lblGrandTotalInd.Visible = false;
            lblGrandSegmentTotalInd.Visible = false;
            txtGrandTotal.Visible = false;
            //txtGrandSegmentTotal.Visible = false;
            lblGrandTotal.Style.Remove("display");
            lblGrandSegmentTotal.Style.Remove("display");
        }

       
        if (SegmentEdit)
        {
            btnSegmentCustomerEdit.Visible = true;
        }
        else
        {
            btnSegmentCustomerEdit.Visible = false;
        }
    }



}

