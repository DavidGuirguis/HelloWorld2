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
using Repositories;
using ObjectExtensions = X.Extensions.ObjectExtensions;
using Helpers;
using System.Text;//<CODE_TAG_101936>

public partial class quoteAddNew : UI.Abstracts.Pages.ReportViewPage  
{
    int quoteId = 0;
    protected bool IsNewQuote = true; 
    DataSet dsQuoteHeader;
    IDictionary<string, IEnumerable<DataRow>> RowsSet;
    string spiltChar1 = ((char)5).ToString();
    string spiltChar2 = "|";
    protected bool bShowSalesRep = true;
    protected bool bHasOpportunity_Default = true;
    protected int iNewOrExistingOpportunity_Default;
    protected string DBSROId = "";   //<CODE_TAG_104228>
    protected string DBSROPId = "";  //<CODE_TAG_104228>
    protected string sType = "";
    protected string DBSROSelectedGroup = "";
    protected string CopyFrom = "";
    protected string WONO = "";
    protected string QuoteNo = "";
    protected string SegmentNo = "";


    protected double PartsAmount = 0;
    protected double LaborAmount = 0;
    protected double MiscAmount = 0;
    protected double LaborHours = 0;

    protected string Make="";
    protected string SerialNo="";
    protected string Model="";
    protected string JobCode="";
    protected string ComponentCode="";
    protected string ModifierCode="";
    protected string BusinessGroupCode="";
    protected string QuantityCode="";
    protected string WorkApplicationCode="";
    protected string BranchCode="";
    protected string StageTypeCode = "";// <CODE_TAG_105235> lwang
    protected string CostCentreCode="";
    protected string CabTypeCode="";
    protected string ShopField="";
    protected string JobLocationCode="";
    protected string strOwnersList = "";
    protected string RedirectURL = "";
    protected string RefreshParent = "";
    protected string CreateFromOppNo = "";
    protected string CostCentreCodeList = ""; //<CODE_TAG_101936>
    protected int AppointmentId = 0;
    protected string DefaultDivision = ""; // <CODE_TAG_102194>
    protected string strIsLoginUserSalesRep = ""; //<CODE_TAG_103528>

    protected void Page_Load(object sender, EventArgs e)
    {

        quoteId = Convert.ToInt32(Request.QueryString["QuoteId"]);
        hidRefreshParent.Value = "";
        bShowSalesRep = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show");
        //bHasOpportunity_Default = AppContext.Current.AppSettings.IsTrue("psQuoter.NewQuote.Opportunity.YesOrNo.Default");
        //<CODE_TAG_104092>
        CreateFromOppNo = Request.QueryString["OppNo"].AsString("").Trim();
        if (string.IsNullOrEmpty(CreateFromOppNo))
            bHasOpportunity_Default = AppContext.Current.AppSettings.IsTrue("psQuoter.NewQuote.Opportunity.YesOrNo.Default");
        else
            bHasOpportunity_Default = true;
        //</CODE_TAG_104092>

        iNewOrExistingOpportunity_Default = X.CType.ToInt32(AppContext.Current.AppSettings["psQuoter.NewQuote.Opportunity.NewOrExisting.Default"], 1);
        CopyFrom = Request.QueryString["copyfrom"].AsString("");
        WONO = Request.QueryString["WONO"].AsString("");
        QuoteNo = Request.QueryString["QuoteNo"].AsString("");
        SegmentNo = Request.QueryString["SegmentNo"].AsString("");

        DBSROId = Request.QueryString["DBSROId"].AsString("").Trim();   //<CODE_TAG_104228>
        DBSROPId = Request.QueryString["DBSROPId"].AsString("").Trim(); //<CODE_TAG_104228>
        sType = Request.QueryString["SType"].AsString("").Trim(); //<CODE_TAG_104228>
        DBSROSelectedGroup = Request.QueryString["DBSROSelectedGroup"].AsString(""); 

        PartsAmount = Request.QueryString["PartsAmount"].AsDouble(0);
        LaborAmount = Request.QueryString["LaborAmount"].AsDouble(0);
        MiscAmount = Request.QueryString["MiscAmount"].AsDouble(0);
        LaborHours = Request.QueryString["LaborHours"].AsDouble(0);


        Make=Request.QueryString["make"].AsString("").Trim();
        SerialNo = Request.QueryString["serialNo"].AsString("").Trim();
        Model = Request.QueryString["model"].AsString("").Trim();
        JobCode = Request.QueryString["jobCode"].AsString("").Trim();
        ComponentCode = Request.QueryString["componentCode"].AsString("").Trim();
        ModifierCode = Request.QueryString["modifierCode"].AsString("").Trim();
        BusinessGroupCode = Request.QueryString["businessGroupCode"].AsString("").Trim();
        QuantityCode = Request.QueryString["quantityCode"].AsString("").Trim();
        WorkApplicationCode = Request.QueryString["workApplicationCode"].AsString("").Trim();
        BranchCode = Request.QueryString["branchCode"].AsString("").Trim();
        StageTypeCode = Request.QueryString["stageType"].AsString("").Trim();  // <CODE_TAG_105235> lwang
        CostCentreCode = Request.QueryString["costCentreCode"].AsString("").Trim();
        CabTypeCode = Request.QueryString["cabTypeCode"].AsString("").Trim();
        ShopField = Request.QueryString["shopField"].AsString("").Trim();
        JobLocationCode = Request.QueryString["jobLocationCode"].AsString("").Trim();

        AppointmentId = Request.QueryString["ApptId"].AsInt(0);

        //CreateFromOppNo = Request.QueryString["OppNo"].AsString("").Trim(); //comment out for <CODE_TAG_104092>

        hdnCreateFromOppNo.Value = "";

        if (quoteId > 0)
            IsNewQuote = false;
        //if (!IsPostBack)
        //    bindData();

        if (!Page.IsPostBack)//<CODE_TAG_103416>
        {
            bindData();
            //<CODE_TAG_102109>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.EstDeliveryDate.Today"))
            {
                lstEstDeliveryYear.SelectedValue = DateTime.Today.Year.ToString();
                lstEstDeliveryMonth.SelectedValue = DateTime.Today.Month.ToString();
            }
            //</CODE_TAG_102109>
        }
    
    }

    private void bindData()
    {
        dsQuoteHeader = DAL.Quote.QuoteHeaderGet(quoteId, 1 , AppointmentId);
        RowsSet = dsQuoteHeader.ToDictionary();

        DataRow drQuoteHeader = null;
        if (RowsSet.ContainsKey("QuoteHeader"))
            drQuoteHeader = RowsSet["QuoteHeader"].FirstOrDefault();

        // Has Opportunity
        rdbtnOpportunity.SelectedValue = bHasOpportunity_Default ? "2" : "1";
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.Mandatory")) rdbtnOpportunity.Visible = false;  // <CODE_TAG_105370> lwang

        // New Or Existing Opportunity
        //iNewOrExistingOpportunity_Default
        rdbtnNewOrExistingOpportunity.SelectedValue = iNewOrExistingOpportunity_Default.ToString();

       

        //Quote Type
        lstQuoteType.Items.Add("");
        foreach (DataRow dr in RowsSet["QuoteType"])
        {
            lstQuoteType.Items.Add(new ListItem(dr["QuoteTypeDesc"].ToString(), dr["QuoteTypeId"].ToString()));
        }
        lstQuoteType.SelectedValue = AppContext.Current.AppSettings["psQuote.NewQuote.DefaultQuoteTypeId"];
        
        //Planned Indicator
        lstPlannedIndicator.Items.Add("");
        foreach (DataRow dr in RowsSet["PlannedIndicator"])
        {
            lstPlannedIndicator.Items.Add(new ListItem(dr["PlannedIndicatorDesc"].ToString(), dr["PlannedIndicatorId"].ToString()));
        }

        //Urgency Indicator
        lstUrgencyIndicator.Items.Add("");
        foreach (DataRow dr in RowsSet["UrgencyIndicator"])
        {
            lstUrgencyIndicator.Items.Add(new ListItem(dr["UrgencyIndicatorDesc"].ToString(), dr["UrgencyIndicatorId"].ToString()));
        }

        //SMU Indicator
        lstSMUIndicator.Items.Add("");
        foreach (DataRow dr in RowsSet["SMUIndicator"])
        {
            lstSMUIndicator.Items.Add(new ListItem(dr["SMUIndicatorDesc"].ToString(), dr["SMUIndicatorId"].ToString()));
        }


        //Branch
        lstBranch.Items.Add("");
        foreach (DataRow dr in RowsSet["Branch"])
        {
            lstBranch.Items.Add(new ListItem(dr["branchNo"].ToString() + "-" + dr["BranchName"].ToString(), dr["BranchNo"].ToString()));
        }

        lstBranch.SelectedValue = BranchCode;

        // <CODE_TAG_105235> lwang
        //Satge
        lstQuoteStageType.Items.Add("");
        foreach (DataRow dr in RowsSet["StageType"])
        {
            lstQuoteStageType.Items.Add(new ListItem(dr["QuoteStageType"].ToString(), dr["QuoteStageTypeCode"].ToString()));
        }

        lstQuoteStageType.SelectedValue = StageTypeCode;

        string strStageType = "";
        foreach (DataRow dr in RowsSet["PSQuoterStageType"])
        {
            if (strStageType != "")
                strStageType += spiltChar1;
            strStageType += dr["Division"].ToString() + "|" + dr["StageTypeCode"].ToString() ;
        }
        hidStageType.Value = strStageType;
           
        // </CODE_TAG_105235> lwang

        //Division
        lstDivision.Items.Add("");
        if (RowsSet.ContainsKey("Division"))
        {
            foreach (DataRow dr in RowsSet["Division"])
            {
                lstDivision.Items.Add(new ListItem(dr["division"].ToString() + " - " + dr["divisionName"].ToString(), dr["Division"].ToString()));
            }
        }


        //Make
        lstMake.Items.Add("");
        if (RowsSet.ContainsKey("Manufacturer"))
        {
            foreach (DataRow dr in RowsSet["Manufacturer"])
            {
                lstMake.Items.Add(new ListItem(dr["ManufacturerCode"].ToString() + " - " + dr["ManufacturerCodeDescription"].ToString(), dr["ManufacturerCode"].ToString().Trim()));  //<CODE_TAG_104589>
            }
                lstMake.SelectedValue = Make;
        }

        txtSerialNo.Text = SerialNo;
        txtModel.Text = Model;


        // Creator
        lblSalesRep.Text = String.Format("{0} {1}", AppContext.Current.User.LogonUser.FirstName, AppContext.Current.User.LogonUser.LastName);

        // App users
        lstSalesRep.Items.Add("");
        foreach (DataRow dr in RowsSet["AppUsers"]) 
        {
            lstSalesRep.Items.Add(new ListItem(String.Format("{0} {1}", dr["FirstName"].ToString(), dr["lastName"].ToString()), dr["UserId"].ToString()));
        }

        lstSalesRep.SelectedValue = AppContext.Current.User.LogonUser.UserID.ToString(); 

        if (RowsSet.ContainsKey("CurrentUser"))
        {
            DataRow drUser = RowsSet["CurrentUser"].FirstOrDefault();
            lstBranch.SelectedValue = drUser["DefaultBranchNo"].ToString().Trim();
            BranchCode = drUser["DefaultBranchNo"].ToString().Trim();
            txtSalesrepFax.Text = drUser["DefaultFaxNo"].ToString();
            txtSalesrepPhone.Text = drUser["DefaultPhoneNo"].ToString();
            txtSalesrepCellPhone.Text = drUser["defaultCellPhoneNo"].ToString();
            DefaultDivision = drUser["DefaultDivision"].ToString();// <CODE_TAG_102194>
            strIsLoginUserSalesRep = drUser["IsLoginUserSalesRep"].ToString();//<CODE_TAG_103528>
        }

        //cab type Code  <CODE_TAG_101768>
        lstCabTypeCode.Items.Clear();
        lstCabTypeCode.Items.Add("");
        IEnumerable<DataRow> drCableTypeCodes = RowsSet["CableTypeCode"];
        if (drCableTypeCodes != null)
        {
            foreach (DataRow dr in drCableTypeCodes)
            {
                lstCabTypeCode.Items.Add(new ListItem(dr["CabTypeCode"].ToString().Trim() + "-" + dr["CabTypeDesc"].ToString(), dr["CabTypeCode"].ToString().Trim()));
            }

        }
        //  </CODE_TAG_101768>


        //Influencer
        string currentDivision = "";
        if (drQuoteHeader != null)
            currentDivision = drQuoteHeader["Division"].ToString();


        lstContact.Items.Add("");
        string strInfluencerList = "";
        if (RowsSet.ContainsKey("Influencer"))
        {
            foreach (DataRow dr in RowsSet["Influencer"])
            {
                if (dr["division"].ToString() == currentDivision )
                    lstContact.Items.Add(new ListItem(dr["InfluencerName"].ToString(), dr["Division"].ToString() + "-" + dr["InfluencerId"].ToString() + "-" + dr["InfluencerType"].ToString() + "-" + dr["InfluencerName"].ToString().Replace("-", "&#45;")));
            
            if (strInfluencerList != "")
                strInfluencerList += spiltChar1;

            strInfluencerList += dr["Division"].ToString() + "-" + dr["InfluencerId"].ToString() + "-" + dr["InfluencerType"].ToString() + "-" + dr["InfluencerName"].ToString().Replace("-", "&#45;") + "-" + dr["phoneNumber"].ToString();
            }
        }
        hdnInfList.Value = strInfluencerList; 

        //Opp Type
        lstOppType.Items.Add("");
        foreach (DataRow dr in RowsSet["OppType"])
        {
            lstOppType.Items.Add(new ListItem(dr["QuoteTypeId"].ToString(), dr["OppTypeId"].ToString()));
        }

        int currentOppTypeId = 0;
        if (drQuoteHeader != null)
            currentOppTypeId = drQuoteHeader["OppTypeId"].AsInt();
        string strCommodityList = "";

        // Commodity
        lstCommodity.Items.Add("");
        foreach (DataRow dr in RowsSet["Commodity"])
        {
            if ((currentOppTypeId & dr["bmOpportunityTypeId"].AsInt()) > 0)
               lstCommodity.Items.Add(new ListItem(dr["CommodityCategoryName"].ToString(), dr["CommodityCategoryId"].ToString()));
            
            if (strCommodityList != "")
                strCommodityList += spiltChar1;
            strCommodityList += dr["bmOpportunityTypeId"].ToString() + "|" + dr["CommodityCategoryId"].ToString() + "|" + dr["CommodityCategoryName"].ToString();
        }
        hdnCommodityList.Value = strCommodityList;
        
        //<CODE_TAG_105426> lwang
        //Delivery Year
        lstEstDeliveryYear.Items.Add("");
        foreach (DataRow dr in RowsSet["DeliveryYear"])
        {
            lstEstDeliveryYear.Items.Add(new ListItem(dr["Year"].ToString(), dr["Year"].ToString()));
        }
        //</CODE_TAG_105426> lwang
        //Source
        int OppSourceId = 0;
        if (drQuoteHeader != null)
        {
            OppSourceId = drQuoteHeader["OppSourceId"].AsInt();
        }
        lstSource.Items.Add("");
        foreach (DataRow dr in RowsSet["Opp.Add.Source"])
        {
            lstSource.Items.Add(new ListItem(dr["OppSourceDesc"].ToString(), dr["OppSourceId"].ToString()));
        }

        //Campaign
        string strCampaignList = "";
        lstCampaign.Items.Add("");
        if (RowsSet.ContainsKey("Opp.Add.Campaign"))
        {
            foreach (DataRow dr in RowsSet["Opp.Add.Campaign"])
            {
                if (strCampaignList != "") strCampaignList += spiltChar1;
                strCampaignList += dr["CampaignId"].ToString() + spiltChar2 + dr["CampaignName"].ToString() + spiltChar2 + dr["OppTypeId"].ToString() + spiltChar2 + dr["division"].ToString();
                if (OppSourceId == 1)
                {
                    lstCampaign.Items.Add(new ListItem(dr["campaignName"].ToString(), dr["CampaignId"].ToString()));
                }
            }
        }
        hdnCampaignList.Value = strCampaignList;

        //new opp default value
        string strOppDefaultValue = "";
        if (RowsSet.ContainsKey("OppDefaultValue"))
        {
            foreach (DataRow dr in RowsSet["OppDefaultValue"])
            {
                if (strOppDefaultValue != "") strOppDefaultValue += spiltChar1;
                strOppDefaultValue += dr["QuoteTypeId"].ToString() + spiltChar2 + dr["OppTypeId"].ToString() + spiltChar2 + dr["DefaultOppStageId"].ToString() + spiltChar2 + dr["DefaultOppSourceId"].ToString() + spiltChar2 + dr["DefaultOppProbabilityOfClosing"].ToString();
            }
        }
        hdnNewOppDefaultValue.Value = strOppDefaultValue;

        //Owners
        if (RowsSet.ContainsKey("AppUsers"))
        {
            foreach (DataRow dr in RowsSet["AppUsers"])
            {
                if (strOwnersList != "") strOwnersList += spiltChar1;
                strOwnersList += dr["UserId"].ToString() + spiltChar2 + dr["DefaultPhoneNo"].ToString() + spiltChar2 + dr["DefaultCellPhoneNo"].ToString() + spiltChar2 + dr["DefaultFaxNo"].ToString();
            }
        }

        //Header

        //Prefill data
        if (RowsSet.ContainsKey("Appointment"))
        {
            DataRow drAppointment = RowsSet["Appointment"].FirstOrDefault();
            txtPO.Text = drAppointment["PurchaseOrderNo"].ToString();

            txtModel.Text = drAppointment["Model"].ToString();
            txtSerialNo.Text = drAppointment["SerialNo"].ToString();
            txtUnitNo.Text = drAppointment["UnitNo"].ToString();
            txtSMU.Text = drAppointment["Hours"].ToString();
            lstSMUIndicator.SelectedValue = "1";
            txtDescription.Text = drAppointment["Problem"].ToString();

            if (txtModel.Text.Trim() == "")
                txtModel.Text = drAppointment["ModelNumber"].ToString();

            if (txtUnitNo.Text.Trim() == "")
                txtUnitNo.Text = drAppointment["EquipmentNumber"].ToString();

           

            for(int i = 0; i< lstMake.Items.Count ; i++)
            {
                if (lstMake.Items[i].Value == drAppointment["Make"].ToString().Trim())
                {
                    lstMake.SelectedValue = drAppointment["Make"].ToString().Trim();
                }
            }

            
            lblCustomer.Text = drAppointment["CustomerNo"].ToString() + " - " + drAppointment["CustomerName"].ToString();
            hidCustomerNo.Value = drAppointment["CustomerNo"].ToString();
            hidCustomerName.Value = drAppointment["CustomerName"].ToString();



            if (RowsSet.ContainsKey("AppointmentDivision"))
            {
                lstDivision.Items.Clear();
                lstDivision.Items.Add("");
                foreach (DataRow dr in RowsSet["AppointmentDivision"])
                {
                    lstDivision.Items.Add(new ListItem(dr["division"].ToString() + " - " + dr["divisionName"].ToString(), dr["Division"].ToString()));
                }

                lstDivision.SelectedValue = drAppointment["AppointmentDivision"].ToString();
            }


            if (RowsSet.ContainsKey("AppointmentInfluencer"))
            {
                strInfluencerList = "";
                lstContact.Items.Clear();
                lstContact.Items.Add("");
                foreach (DataRow dr in RowsSet["AppointmentInfluencer"])
                {
                   if (dr["division"].ToString() == drAppointment["appointmentDivision"] )
                        lstContact.Items.Add(new ListItem(dr["InfluencerName"].ToString(), dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim()));

                    if (strInfluencerList != "")
                        strInfluencerList += spiltChar1;

                    strInfluencerList += dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim() + "-" + dr["phoneNumber"].ToString().Trim() + "-" + dr["fax"].ToString().Trim() + "-" + dr["email"].ToString().Trim() + "-";
                }

                hdnInfList.Value = strInfluencerList; 
                foreach (ListItem l in lstContact.Items)
                {
                    if (l.Value == drAppointment["AppointmentDivision"].ToString().Trim() + "-" + drAppointment["InfluencerId"].ToString().Trim() + "-" + drAppointment["InfluencerType"].ToString().Trim() + "-" + drAppointment["ContactName"].ToString().Trim())
                        l.Selected = true;
                }
            }

        }


        //<CODE_TAG_101936>
        CostCentreCodeList += ",&nbsp;";
        char spiltChar = (char)5;
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in RowsSet["CostCentreCode"])
        {
            sb.Append(spiltChar.ToString());
            sb.Append(dr["CostCentreCode"].ToString().Replace(",","") + "|" + dr["CostCentreName"].ToString().Replace(",","") + "|" + Server.HtmlEncode(dr["BranchNo"].ToString()));
        }
        CostCentreCodeList += sb.ToString();
        //lstBranch.SelectedValue = BranchCode; //<CODE_TAG_102194>
        //</CODE_TAG_101936>
        hdnCreateFromOppNo.Value = CreateFromOppNo;


    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int newQuoteId = 0;
        string newQuoteNo = "";
        int influencerId = 0;
        string influencerType = "";
        string influencerName = "";

        //System.Threading.Thread.Sleep(5000);


        if (!chkNewContact.Checked)
        {
            if (hidSelectContact.Value.Contains("-"))
            {
                string[] arrStr = hidSelectContact.Value.Split("-");

                influencerId = arrStr[1].AsInt();
                influencerType = arrStr[2];
                influencerName = arrStr[3].Replace("&#45;", "-");
            }
        }
        //<CODE_TAG_101936>
        //if (hdnNewSegmentSourceType.Value == "4") //standard Job
        //{
        //    string[] arrStr = hdnNewSegmentData.Value.Split(",");
        //    hdnNewSegmentData.Value = arrStr[0];
        //    DBSROId = arrStr[1].AsInt();
        //    DBSROPId = arrStr[2].AsInt();
        //    DBSROSelectedGroup = arrStr[3].AsString(""); 
        //$("[id*=txtStandardJobSegmentNo]").val() + "," +  $("[id*=hidStandardJobROId]").val() + "," + $("[id*=hidStandardJobROPId]").val()+ "," + $("[id*=hidStandardJobSelectedGroup]").val();
        //}
        //</CODE_TAG_101936>

        DAL.Quote.QuoteAdd(
                                      lstSalesRep.SelectedValue.AsInt(AppContext.Current.User.LogonUser.UserID),
                                      lstBranch.SelectedValue.Trim(),
                                      txtSalesrepPhone.Text.Trim(),
                                      txtSalesrepCellPhone.Text.Trim(), 
                                      txtSalesrepFax.Text.Trim(), 
                                      txtDescription.Text.Trim(),
                                      hidCustomerNo.Value,
                                      hidCustomerName.Value,
                                      hidDivision.Value ,
                                      influencerId,
                                      influencerType,
                                      (chkNewContact.Checked) ? txtContact.Text.Trim() : influencerName,
                                      (chkNewContact.Checked) ? "Y" : "N",
                                      txtPhoneNo.Text.Trim().Replace("&#45;", "-"),
                                      txtFax.Text.Trim(),
                                      txtEmail.Text.Trim(),
                                      lstMake.SelectedValue, 
                                      txtModel.Text.Trim(),
                                      txtSerialNo.Text.Trim(),
                                      txtUnitNo.Text.Trim(),
                                      txtStockNo.Text.Trim(),
                                      txtSMU.Text.As<Double?>(),
                                      lstEstDeliveryYear.SelectedValue.AsInt(0),
                                      lstEstDeliveryMonth.SelectedValue.AsInt(0),
                                      (rdoLow.Checked) ? 1 : ((rdoMedium.Checked) ? 2 : 4),
                                      hidSelectedCommodityId.Value.AsInt(0),  // lstCommodity.SelectedValue.AsInt(0),   <CODE_TAG_101544>
                                      lstSource.SelectedValue.AsInt(0),
                                      hdnOppNo.Value.AsInt(0),
                                      //lstCampaign.SelectedValue.AsInt(0),
                                      hdnlstCampaignSelected.Value.AsInt(0), //<CODE_TAG_103933>
                                      txtPromiseDate.Text.AsNullIfWhiteSpace(),
                                      txtUnittoArriveDate.Text.AsNullIfWhiteSpace(),
                                      lstPlannedIndicator.SelectedValue.AsInt(),
                                      lstUrgencyIndicator.SelectedValue.AsInt(),
                                      lstSMUIndicator.SelectedValue.AsInt(),
                                      ((txtSMU.Text.AsDouble(0) > 0 && txtSMULastRead.Text== "") ? DateTime.Now.ToString("yyyy-MM-dd") : txtSMULastRead.Text.AsNullIfWhiteSpace()),
                                      lstQuoteType.SelectedValue.AsInt(),
                                      rdbtnOpportunity.SelectedValue.AsInt(),
                                      rdbtnNewOrExistingOpportunity.SelectedValue.AsInt(),
                                      hdnNewSegmentSourceType.Value.AsInt( ),
                                      hdnNewSegmentData.Value,
                                      DBSROId,
                                      DBSROPId,
                                      sType,
                                      DBSROSelectedGroup,
                                      txtJobControlCode.Text.Trim( ),
                                      txtEstimatedRepairTime.Text.Trim( ),
                                      hidWONO.Value.Trim( ),
                                      txtPO.Text.Trim( ) ,
                                      txtEstimatedByName.Text.Trim(),
                                      AppointmentId,
                                      hidCopyNotes.Value.AsInt(1),
                                      out newQuoteId,
                                      out newQuoteNo,
                                      Server.HtmlEncode(txtComents.Text.Trim()), //<CODE_TAG_101731>
                                      lstCabTypeCode.SelectedValue.Trim()
                                      , lstQuoteStageType.SelectedValue.ToString() // <CODE_TAG_105235> lwang
                );


        //Response.Redirect("Quote_Segment.aspx?QuoteId=" + newQuoteId + "&Revision=1&segmentEdit=1");
        RedirectURL = "Quote_Segment.aspx?QuoteId=" + newQuoteId + "&Revision=1&segmentEdit=1";
        if (AppointmentId > 0)
            RefreshParent = "2";
        QuoteNo = newQuoteNo;

        //<CODE_TAG_103629>
        string strRedirectUrlAbosolute = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + Page.ResolveUrl("Quote_Segment.aspx") + "?QuoteId=" + newQuoteId + "&Revision=1&segmentEdit=1";
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.NewQuote.EmailSendToOwner"))
        {
            int quoteCreatorId = AppContext.Current.User.LogonUser.UserID;
            int quoteOwnerId = lstSalesRep.SelectedValue.AsInt();
            //if (quoteCreatorId == quoteOwnerId)  // for testing
            if (quoteCreatorId != quoteOwnerId)
            {
                //EmailProccess(lstSalesRep.SelectedValue, quoteCreatorId, QuoteNo, strRedirectUrlAbosolute, txtDescription.Text.Trim(), hidCustomerName.Value, hidCustomerNo.Value, (chkNewContact.Checked) ? txtContact.Text.Trim() : influencerName,  //for testing
                EmailProccess( quoteOwnerId, QuoteNo, strRedirectUrlAbosolute, txtDescription.Text.Trim(), hidCustomerName.Value, hidCustomerNo.Value, (chkNewContact.Checked) ? txtContact.Text.Trim() : influencerName,
                    txtPhoneNo.Text.Trim(), txtModel.Text.Trim(), txtSerialNo.Text.Trim());
            }
        }
        //</CODE_TAG_103629>
    }

    private void Page_PreRender(object sender, System.EventArgs e)
    {
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Header.SMU.LastTimeValue.Display"))
        {
            lblLastSMUValueTitle.Visible = false;
            lblLastSMUValue.Visible = false; 
        }
    }

    //<CODE_TAG_103629>
    //private void EmailProccess(string sTo, string sCc, string sBcc, string sFrom, string sSubject, string sBody, string sAlert)
    //private void EmailProccess(string ownerNo, int QuoteOwnerId, string quoteNo, string strRedirectUrlAbosolute, string quoteDescription, string customerName, string customerNumber, string contactName, string contactPhone, string model, string SerialNo) //for testing
    private void EmailProccess( int QuoteOwnerId, string quoteNo, string strRedirectUrlAbosolute, string quoteDescription, string customerName, string customerNumber, string contactName, string contactPhone, string model, string SerialNo)
    {
        //get quote owner's email address
        //int intQuoteOwnerId = Convert.ToInt32(ownerNo);
        string sTo = "";
        if (QuoteOwnerId >= 0)
        {
            sTo = DAL.Quote.GetSelectedQuoteOwnerEmail(QuoteOwnerId);
        }

        //get creator's email address
        string sFrom = "";
        string sSubject = "";
        customerName = customerName.Trim();
        sSubject = "Estimate Assigned -" + customerName + " - " + quoteDescription;

        string sBody = "";
        sBody = "Click on quote number to open estimate in Parts and Service Quoter<br><br>";
        sBody += "Estimate Number: <a href='" + strRedirectUrlAbosolute + "'>" + QuoteNo + "</a><br> <br>";
        sBody += "Estimate Description: " + quoteDescription + "<br><br>";
        sBody += "Customer Number: " + customerNumber + "<br><br>";
        sBody += "Customer Name: " + customerName + "<br><br>";
        sBody += "Contact Name: " + contactName + "<br><br>";
        sBody += "Contact Telephone Number: " + contactPhone + "<br><br>";
        sBody += "Model: " + model + "<br><br>";
        sBody += "Serial Number: " + SerialNo + "<br><br>";

        //sFrom = DAL.Quote.GetSelectedQuoteOwnerEmail(QuoteCreatorId);

        Helpers.Util.SendEmail(sTo, sSubject, sBody);


    }
    //</CODE_TAG_103629>
}


