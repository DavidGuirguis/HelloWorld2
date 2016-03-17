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
using System.Data;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;
using System.Text;//<CODE_TAG_101936>

public partial class quoteHeaderEdit : UI.Abstracts.Pages.Plain
{
    protected int QuoteId = 0;
    protected int Revision = 0;
    protected int NewSegmentId = 0;
    protected string Mode = "ExistQuote";
    protected int SegmentNoStartIdx;
    protected string DBSROId = "";   //<CODE_TAG_104228>
    protected string DBSROPId = "";  //<CODE_TAG_104228>
    protected string DBSROSelectedGroup = "";
    protected string CopyFrom = "";
    protected string BranchNo = "";//<CODE_TAG_101936>
    protected string CostCentreCodeList = "";//<CODE_TAG_101936>
    protected string sType = "";
    protected bool sourceFromWO = false;//<CODE_TAG_104495>
    protected bool ChargeCodeEnabled = true; //<CODE_TAG_105504>

    protected void Page_Load(object sender, EventArgs e)
    {
        QuoteId = Convert.ToInt32(Request.QueryString["QuoteId"]);
        Revision = Convert.ToInt16(Request.QueryString["Revision"]);
        if (Request.QueryString["Mode"] == "NewQuote")
            Mode = "NewQuote";
        hidRefreshParent.Value = "";
        DBSROId = Request.QueryString["DBSROId"].AsString("");   //<CODE_TAG_104228>
        DBSROPId = Request.QueryString["DBSROPId"].AsString(""); //<CODE_TAG_104228>         
        DBSROSelectedGroup = Request.QueryString["DBSROSelectedGroup"].AsString("%");  
        CopyFrom = Request.QueryString["copyfrom"].AsString("");
        sType = Request.QueryString["SType"].AsString("");
        BranchNo = Request.QueryString["branchNo"].AsString("");//<CODE_TAG_101936>
        if (Page.IsPostBack)
        {
            CopyFrom = "";
        }
        else
        {
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Quote.Notes.Copy"))
                chkQuote_CopyNotes.Checked = true;

            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.WO.Notes.Copy"))
                chkWorkOrder_CopyNotes.Checked = true;

            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.StandardJob.Notes.Copy"))
                chkStandardJob_CopyNotes.Checked = true;
        }
        //<CODE_TAG_105504>
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show")
                 && !AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
        {//when the delaer no use charge code, then no show Cost center coloumn when Add New Segment From Standard Job
            ChargeCodeEnabled = false;
        }
        //</CODE_TAG_105504>

    }

    protected string AddSegmentsErrorCheck(int rt, string errMsg)
    {
        string errorMsg = "";

        switch (rt)
        {
            case -1: // Duplicate
                errorMsg = "duplicate segment number(s): " + errMsg;
                break;
            case -2: // Empty
                errorMsg = "segment number can't be blank";
                break;
            default: // No Error
                errorMsg = "";
                break;
        }
        
        return errorMsg;

    }
   
    protected void btnOK_Manual_Click(object sender, EventArgs e)
    {
        var ErrMsg = "";
        
        if (txtManualSegmentNo.Text.Trim() == "")
        {
            lblManualErrorMessage.Text = AddSegmentsErrorCheck(-2, ErrMsg);
        }
        else
        {
            int rt = DAL.Quote.AddSegmentFromManual(QuoteId, Revision,  hidNewSegmentData.Value.Trim(),// txtManualSegmentNo.Text.Trim(),
                                                       out NewSegmentId, out ErrMsg);

            lblManualErrorMessage.Text = AddSegmentsErrorCheck(rt, ErrMsg);

            if (rt == 0)
            {
                hidRefreshParent.Value = "1";
            }
        }
        
        
    }

    protected void btnOK_CopyFromQuote_Click(object sender, EventArgs e)
    {
        var ErrMsg = "";

        int rt = DAL.Quote.AddSegmentFromQuote(QuoteId, Revision, hidNewSegmentData.Value.Trim(), (chkQuote_CopyNotes.Checked)?2:1,  out ErrMsg);

        lblCopyFromQuoteErrorMessage.Text = AddSegmentsErrorCheck(rt, ErrMsg);

        if (rt == 0)
        {
            hidRefreshParent.Value = "1";
        }
    }
    
    protected void btnOK_CopyFromWorkorder_Click(object sender, EventArgs e)
    {
        var ErrMsg = "";

        int rt = DAL.Quote.AddSegmentFromWorkorder(QuoteId, Revision, hidNewSegmentData.Value.Trim(), (chkWorkOrder_CopyNotes.Checked)?2:1,  out ErrMsg);

        lblCopyFromWorkOrderErrorMessage.Text = AddSegmentsErrorCheck(rt, ErrMsg);

        if (rt == 0)
        {
            hidRefreshParent.Value = "1";
        }
    }
    
    protected void btnOK_CopyFromStandardJob_Click(object sender, EventArgs e)
    {
        var ErrMsg = "";

        string sType = hidStandardJobSType.Value;
        int rt = DAL.Quote.AddSegmentFromStandardJob(QuoteId, Revision, hidNewSegmentData.Value.Trim(), (chkStandardJob_CopyNotes.Checked) ? 2 : 1, sType, out ErrMsg); //<CODE_TAG_101936>

        lblStandardJobErrorMessage.Text = AddSegmentsErrorCheck(rt, ErrMsg);
        
        if (rt == 0)
        {
            hidRefreshParent.Value = "1";
        }
    }

    protected void btnWOGetData_Click(object sender, EventArgs e)
    {
        DataSet ds = DAL.Quote.QuoteGetWOSegmentsByIds(hidWOSegmentIds.Value.Trim());

        if (BranchNo != "")
        { loadCostCenterCode(ds); }
        sourceFromWO = true;//<CODE_TAG_104495>
        repWOSegmentList.DataSource = ds.Tables[0];
        repWOSegmentList.DataBind(); 

    }

    protected void btnQuoteGetData_Click(object sender, EventArgs e)
    {
        DataSet ds = DAL.Quote.QuoteGetSegmentsByIds(hidQuoteSegmentIds.Value.Trim());

        if (BranchNo != "")
        { loadCostCenterCode(ds); }

        repQuoteSegmentList.DataSource = ds.Tables[0];
        repQuoteSegmentList.DataBind();

    }
    //<CODE_TAG_101936>
    protected void repSegmentsList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        string CostCenterCode = hidCostCenterCode.Value;
        string Branch = hidCurrBranch.Value;
        char spiltChar = (char)5;

        
        try
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //<CODE_TAG_104495>
                string selectedCostCenterCode = null;
                DataRow dr = (e.Item.DataItem as DataRowView).Row;
                if (sourceFromWO)
                {
                    selectedCostCenterCode = dr["CostControlCode"].ToString();
                }
                else
                    selectedCostCenterCode = "";
                //</CODE_TAG_104495>

                TextBox txtQuoteSegNo = (TextBox)e.Item.FindControl("txtQuoteSegNo");
                //txtQuoteSegNo.Text = e.Item.ItemIndex.ToString("##00");
                //<CODE_TAG_104495>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.SegmentNoFromSource") && sourceFromWO)  //from Existing Quote, Work Order
                    txtQuoteSegNo.Text = dr["SegmentNo"].ToString();
                else
                { 
                    //txtQuoteSegNo.Text = e.Item.ItemIndex.ToString("##00");
                    //<CODE_TAG_104513>
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.SegmentNoWithZeroBased"))
                        txtQuoteSegNo.Text = (e.Item.ItemIndex).ToString("##00");
                    else
                        txtQuoteSegNo.Text = (e.Item.ItemIndex + 1).ToString("##00");
                    //</CODE_TAG_104513>
                }
                //</CODE_TAG_104495>

                DropDownList lstCostCenterCode = (DropDownList)e.Item.FindControl("lstCostCenterCode");
                lstCostCenterCode.Items.Add(new ListItem("", ""));

                foreach (String i in CostCenterCode.Split(","))
                {

                    if (i.ToString().Trim() == "" || i.ToString().Trim().Contains("nbsp;")) { }
                    else
                    {
                        //txtStandardJobSegmentNo.Text = txtStandardJobSegmentNo.Text + i;
                        if (i.Split("|")[2].ToString() == Branch)
                        {
                            lstCostCenterCode.Items.Add(new ListItem(i.Split("|")[0].ToString() + "-" + i.Split("|")[1].ToString(), i.Split("|")[0].ToString()));

                        }
                    }
                }
                //<CODE_TAG_104495>
                //assigned the selected cost center code
                if (sourceFromWO && (!string.IsNullOrEmpty(selectedCostCenterCode)))
                    lstCostCenterCode.SelectedValue = selectedCostCenterCode;
                //</CODE_TAG_104495>
            }

        }
        catch (Exception ex)
        {
            lblStandardJobErrorMessage.Text = ex.ToString();
        }    
    }
    
    protected void btnStandardJobGetData_Click(object sender, EventArgs e)
    {
        //int ROId = hidStandardJobROId.Value.AsInt();
        //int ROPId = hidStandardJobROPId.Value.AsInt();
        string ROId = hidStandardJobROId.Value;
        string ROPId = hidStandardJobROPId.Value;
        string stGroup = hidStandardJobSelectedGroup.Value;
        string sType = hidStandardJobSType.Value;


        loadRepStandardJobList(ROId, ROPId,sType); //<CODE_TAG_103749>
    }

    //<CODE_TAG_103749>
    private void loadRepStandardJobList(string ROId, string ROPId,string SType)
    {
        DataSet ds = DAL.Quote.Quote_Get_StandardJobListInfo(ROId, ROPId, SType);
        //Load CostCenter
        if (BranchNo != "")
        { loadCostCenterCode(ds); }
        repStandardJobSegmentsList.DataSource = ds.Tables[0];
        repStandardJobSegmentsList.DataBind();

        divStandardJobSegmentsList.Visible = true;
    }
    //</CODE_TAG_103749>
    protected void loadCostCenterCode(DataSet ds)
    {
        CostCentreCodeList += ",&nbsp;";
        string spiltChar = ",";
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in ds.Tables[1].Rows)
        {
            sb.Append(spiltChar.ToString());
            sb.Append(dr["CostCentreCode"].ToString().Replace(",", "") + "|" + dr["CostCentreName"].ToString().Replace(",", "") + "|" + Server.HtmlEncode(dr["BranchNo"].ToString()));
        }
        CostCentreCodeList += sb.ToString();

        hidCostCenterCode.Value = CostCentreCodeList;
        hidCurrBranch.Value = BranchNo;
        //lstBranch.SelectedValue = BranchCode; 

    }
    //</CODE_TAG_101936>
    private void Page_PreRender(object sender, System.EventArgs e)
    {
        if (rdoManual.Checked)
        {
            divManual.Style.Add("display","");
            divQuote.Style.Add("display", "none");
            divWorkorder.Style.Add("display", "none");
            divStandardJob.Style.Add("display", "none");
            divDBSPartDocuments.Style.Add("display", "none");//<CODE_TAG_103560>
        }

        if (rdoQuote.Checked)
        {
            divManual.Style.Add("display", "none");
            divQuote.Style.Add("display", "");
            divWorkorder.Style.Add("display", "none");
            divStandardJob.Style.Add("display", "none");
            divDBSPartDocuments.Style.Add("display", "none");//<CODE_TAG_103560>
        }

        if (rdoWorkorder.Checked)
        {
            divManual.Style.Add("display", "none");
            divQuote.Style.Add("display", "none");
            divWorkorder.Style.Add("display","");
            divStandardJob.Style.Add("display", "none");
            divDBSPartDocuments.Style.Add("display", "none");//<CODE_TAG_103560>
        }

        if (rdoStandardJob.Checked)
        {
            divManual.Style.Add("display", "none");
            divQuote.Style.Add("display", "none");
            divWorkorder.Style.Add("display", "none");
            divStandardJob.Style.Add("display", "");
            divDBSPartDocuments.Style.Add("display", "none");//<CODE_TAG_103560>
        }

        //<CODE_TAG_103560>
        if (rdoDBSPartDocuments.Checked)
        {
            divManual.Style.Add("display", "none");
            divQuote.Style.Add("display", "none");
            divWorkorder.Style.Add("display", "none");
            divStandardJob.Style.Add("display", "none");
            divDBSPartDocuments.Style.Add("display", "");
        }
        //</CODE_TAG_103560>


        if (Mode == "NewQuote")
        {
            btnOK_Manual.Visible = false;
            btnOK_CopyFromQuote.Visible = false;
            btnOK_CopyFromWorkorder.Visible = false;
            btnOK_CopyFromStandardJob.Visible = false;
            btnOK_CopyFromDBSPartDocuments.Visible = false;//<CODE_TAG_103973>
        }


        if (DBSROId != "")  //<CODE_TAG_104228>
        {
            //comment out for <CODE_TAG_101936>
            //DataSet ds = DAL.Quote.Quote_Get_StandardJobInfo(DBSROId, DBSROPId); 
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //    DataRow dr = ds.Tables[0].Rows[0];
            //    lblStandardJobModel.Text  = dr["Model"].ToString();
            //    if (!dr["JobCode"].ToString().IsNullOrWhiteSpace() || !dr["JobCodeDesc"].ToString().IsNullOrWhiteSpace())
            //    {
            //        lblStandardJobJobCode.Text = dr["JobCode"].ToString() + "-" + dr["JobCodeDesc"].ToString();
            //    }
            //    if (!dr["ComponentCode"].ToString().IsNullOrWhiteSpace() || !dr["ComponentCodeDesc"].ToString().IsNullOrWhiteSpace())
            //    {
            //        lblStandardJobComponentCode.Text = dr["ComponentCode"].ToString() + "-" +
            //                                           dr["ComponentCodeDesc"].ToString();
            //    }
            //    if (!dr["ModifierCode"].ToString().IsNullOrWhiteSpace() || !dr["ModifierDesc"].ToString().IsNullOrWhiteSpace())
            //    {
            //        lblStandardJobModifer.Text = dr["ModifierCode"].ToString() + "-" + dr["ModifierDesc"].ToString();
            //    }
            //    if (!dr["QuantityCode"].ToString().IsNullOrWhiteSpace() || !dr["QuantityDesc"].ToString().IsNullOrWhiteSpace())
            //    {
            //        lblStandardJobQty.Text = dr["QuantityCode"].ToString() + "-" + dr["QuantityDesc"].ToString();
            //    }
            //    lblStandardJobLaborHours.Text = Helpers.Util.NumberFormat(dr["FRPriceHours"].AsDouble(0.00), 2, -1, -1, -1, true);
                
            //    var iPartsStandardAmount = dr["PartsStdDollarAmount"].AsDouble(0.00);
            //    var iLaborStandardAmount = dr["LabourStdDollarAmount"].AsDouble(0.00);
            //    var iMiscStandardAmount = dr["MiscStdDollarAmount"].AsDouble(0.00);
            //    var iTotalStandardAmount = iPartsStandardAmount + iLaborStandardAmount + iMiscStandardAmount;

            //    lblPartsStandardAmount.Text = Helpers.Util.NumberFormat(iPartsStandardAmount, 2, -1, -1, -1, true);
            //    lblLaborStandardAmount.Text = Helpers.Util.NumberFormat(iLaborStandardAmount, 2, -1, -1, -1, true);
            //    lblMiscStandardAmount.Text = Helpers.Util.NumberFormat(iMiscStandardAmount, 2, -1, -1, -1, true);
            //    lblTotalStandardAmount.Text = Helpers.Util.NumberFormat(iTotalStandardAmount, 2, -1, -1, -1, true);
            //    lblFeaturesAndBenefits.Text = dr["FeaturesAndBenefits"].ToString();
            //}
            // comment out for </CODE_TAG_101936>
            rdoManual.Visible = false;
            rdoQuote.Visible = false;
            rdoWorkorder.Visible = false;
            rdoStandardJob.Checked = true;
            rdoDBSPartDocuments.Visible = false; //<CODE_TAG_103749>

            divManual.Style.Add("display", "none");
            divQuote.Style.Add("display", "none");
            divWorkorder.Style.Add("display", "none");
            divStandardJob.Style.Add("display", "");

            divStandardJobSegmentsList.Visible = true;
            //comment out for <CODE_TAG_101936> (un-comment as <CODE_TAG_103836>)
            hidStandardJobROId.Value = DBSROId.ToString();
            hidStandardJobROPId.Value = DBSROPId.ToString();
            hidStandardJobSelectedGroup.Value = DBSROSelectedGroup;
            hidStandardJobSType.Value = sType;
            //comment out for </CODE_TAG_101936>

            //<CODE_TAG_103749>
            if (DBSROPId != "")   //<CODE_TAG_104228>
            {
                this.loadRepStandardJobList(DBSROId.ToString(), DBSROPId.ToString(), sType.ToString());
            }
            //</CODE_TAG_103749>
        }

        if (CopyFrom == "WOAVG" || CopyFrom == "QuoteAVG")
        {
            string jobCode = Request.QueryString["jobCode"].AsString("").Trim();
            string componentCode = Request.QueryString["componentCode"].AsString("").Trim();
            string modifierCode = Request.QueryString["modifierCode"].AsString("").Trim();
            string businessGroupCode = Request.QueryString["businessGroupCode"].AsString("").Trim();
            string quantityCode = Request.QueryString["quantityCode"].AsString("").Trim();
            string branchCode = Request.QueryString["branchCode"].AsString("").Trim();
            string costCentreCode = Request.QueryString["costCentreCode"].AsString("").Trim();
            string shopField = Request.QueryString["shopField"].AsString("").Trim();


            DataSet dsSMCS = DAL.Quote.QuoteGetSMCSCode(jobCode,
                                                        componentCode,
                                                        modifierCode,
                                                        businessGroupCode,
                                                        quantityCode,
                                                        branchCode,
                                                        costCentreCode);
            if (dsSMCS.Tables[0].Rows.Count > 0)
            {
                DataRow dr = dsSMCS.Tables[0].Rows[0];
                if (jobCode != "")
                    lblManualJobCode.Text = jobCode + "-" + dr["jobCodeDesc"].ToString();
                if (componentCode != "")
                    lblManualComponentCode.Text = componentCode + "-" + dr["componentCodeDesc"].ToString();
                if (modifierCode != "")
                    lblManualModifierCode.Text = modifierCode + "-" + dr["modifierDesc"].ToString();
                if (businessGroupCode != "")
                    lblManualBusinessGroupCode.Text = businessGroupCode + "-" + dr["businessGroupDesc"].ToString();
                if (quantityCode != "")
                    lblManualQuanityCode.Text = quantityCode + "-" + dr["quantityDesc"].ToString();
                if (branchCode != "")
                    lblManualBranchCode.Text = branchCode + "-" + dr["branchName"].ToString();
                if (costCentreCode != "")
                    lblManualCostCentreCode.Text = costCentreCode + "-" + dr["CostCentreName"].ToString();

            }

            if (shopField.ToUpper() == "S") lblManualShopField.Text = "Shop";
            if (shopField.ToUpper() == "F") lblManualShopField.Text = "Field";

            lblManualAvgParts.Text = Helpers.Util.FormatCurrency(Request.QueryString["partsAmount"].AsDouble(0));
            lblManualAvgLabor.Text = Helpers.Util.FormatCurrency(Request.QueryString["laborAmount"].AsDouble(0));
            lblManualAvgMisc.Text = Helpers.Util.FormatCurrency(Request.QueryString["miscAmount"].AsDouble(0));
            lblManualAvgHours.Text = Helpers.Util.NumberFormat(Request.QueryString["laborHours"].AsDouble(0), 2, null, null, null, false);

            hidManualData.Value = "";
            hidManualData.Value += "<jobCode>" + jobCode + "</jobCode>";
            hidManualData.Value += "<componentCode>" + componentCode + "</componentCode>";
            hidManualData.Value += "<modifierCode>" + modifierCode + "</modifierCode>";
            hidManualData.Value += "<businessGroupCode>" + businessGroupCode + "</businessGroupCode>";
            hidManualData.Value += "<quantityCode>" + quantityCode + "</quantityCode>";
            hidManualData.Value += "<branchCode>" + branchCode + "</branchCode>";
            hidManualData.Value += "<costCentreCode>" + costCentreCode + "</costCentreCode>";
            hidManualData.Value += "<shopField>" + shopField + "</shopField>";
            hidManualData.Value += "<partsAmount>" + Request.QueryString["partsAmount"].AsString("0") + "</partsAmount>";
            hidManualData.Value += "<laborAmount>" + Request.QueryString["laborAmount"].AsString("0") + "</laborAmount>";
            hidManualData.Value += "<miscAmount>" + Request.QueryString["miscAmount"].AsString("0") + "</miscAmount>";
            hidManualData.Value += "<laborHours>" + Request.QueryString["laborHours"].AsString("0") + "</laborHours>";

            txtManualSegmentNo.Text = "01"; 

            tableNewSegmentManualDetails.Visible = true;
        }

    }
    //<CODE_TAG_103560>
    protected void btnDBSPartDocumentsGetData_Click(object sender, EventArgs e)
    {
        DataSet ds = DAL.Quote.QuoteGetDBSPartDocumentListByIds(hidDBSPartDocumentIds.Value.Trim());
        if (ds != null && ds.Tables.Count > 0  && ds.Tables[0].Rows.Count>0)
        {
            repDBSPartDocumentList.DataSource = ds.Tables[0];
            repDBSPartDocumentList.DataBind();
            divDBSPartDocumentList.Visible = true;
        }
    }
    
    
    protected void repDBSPartDocumentList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                TextBox txtQuoteSegNo = (TextBox)e.Item.FindControl("txtQuoteSegNo");
                //txtQuoteSegNo.Text = e.Item.ItemIndex.ToString("##00");
                //<CODE_TAG_104513>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.SegmentNoWithZeroBased"))
                    txtQuoteSegNo.Text = (e.Item.ItemIndex).ToString("##00");
                else
                    txtQuoteSegNo.Text = (e.Item.ItemIndex + 1).ToString("##00");
                //</CODE_TAG_104513>
            }


        }
        catch (Exception ex)
        {
            lblDBSPartDocumentsErrorMessage.Text = ex.ToString();
        }
    }

    protected void btnOK_CopyFromDBSPartDocuments_Click(object sender, EventArgs e)
    {
        var ErrMsg = "";
        int rt = DAL.Quote.AddSegmentFromDBSPartDocuments(QuoteId, Revision, hidNewSegmentData.Value.Trim(), out ErrMsg);

        lblDBSPartDocumentsErrorMessage.Text = AddSegmentsErrorCheck(rt, ErrMsg);

        if (rt == 0)
        {
            hidRefreshParent.Value = "1";
        }
    }
    //</CODE_TAG_103560>


 
}

