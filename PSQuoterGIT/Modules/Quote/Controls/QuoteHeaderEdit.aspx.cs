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
using Helpers;
using ObjectExtensions = X.Extensions.ObjectExtensions;

public partial class quoteHeaderEdit : UI.Abstracts.Pages.Plain
{
    int quoteId = 0;
    int revision = 0;
    protected bool IsNewQuote = true; 
    DataSet dsQuoteHeader;
    IDictionary<string, IEnumerable<DataRow>> RowsSet;
    string spiltChar1 = ((char)5).ToString();
    string spiltChar2 = "|";
    protected bool bShowSalesRep = true;
    protected string SegmentHasProspectCust = "0";
    protected string strOwnersList = "";
    protected string strIsLoginUserSalesRep = ""; //<CODE_TAG_103528>
    protected string strLstCampaignSelected = "";//<CODE_TAG_103933>

    protected void Page_Load(object sender, EventArgs e)
    {

        quoteId = Convert.ToInt32(Request.QueryString["QuoteId"]);
        revision = Convert.ToInt16(Request.QueryString["Revision"]);
        hidRefreshParent.Value = "";
        bShowSalesRep = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show");
        if (quoteId > 0)
            IsNewQuote = false;

        if (!IsPostBack)
            bindData();

    }
 
    private void bindData()
    {
        dsQuoteHeader = DAL.Quote.QuoteHeaderGet(quoteId, revision);
        RowsSet = dsQuoteHeader.ToDictionary();

        DataRow drQuoteHeader = null;
        
        if (RowsSet.ContainsKey("QuoteHeader"))
            drQuoteHeader = RowsSet["QuoteHeader"].FirstOrDefault();
        //<CODE_TAG_103528>
        DataRow drCurrentUser = null;
        if (RowsSet.ContainsKey("CurrentUser"))
            drCurrentUser = RowsSet["CurrentUser"].FirstOrDefault();
        if (drCurrentUser != null)
            strIsLoginUserSalesRep = drCurrentUser["IsLoginUserSalesRep"].ToString();
        //</CODE_TAG_103528>
        //Status
        lstQuoteStatus.Items.Add(""); 
        foreach (DataRow dr in RowsSet["QuoteStatus"])
        {
            lstQuoteStatus.Items.Add(new ListItem(dr["QuoteStatus"].ToString(), dr["QuoteStatusId"].ToString()));
        }

        //Quote Type
        foreach (DataRow dr in RowsSet["QuoteType"])
        {
            lstQuoteType.Items.Add(new ListItem(dr["QuoteTypeDesc"].ToString(), dr["QuoteTypeId"].ToString()));
        }

        //Sales rep
        //if (bShowSalesRep){
        //    lstSalesRep.Items.Add("");
        //    foreach (DataRow dr in RowsSet["SalesRep"])
        //    {
        //        lstSalesRep.Items.Add(new ListItem(dr["firstName"].ToString() + " " + dr["Lastname"].ToString(),
        //                                           dr["xuid"].ToString()));
        //    }
        //}


        // App users
        lstSalesRep.Items.Add("");
        foreach (DataRow dr in RowsSet["AppUsers"])
        {
            lstSalesRep.Items.Add(new ListItem(String.Format("{0} {1}", dr["FirstName"].ToString(), dr["lastName"].ToString()), dr["UserId"].ToString()));
        }

    

        //Branch
        lstBranch.Items.Add("");
        foreach (DataRow dr in RowsSet["Branch"])
        {
            lstBranch.Items.Add(new ListItem(dr["branchNo"].ToString() + "-" + dr["BranchName"].ToString(), dr["BranchNo"].ToString()));
        }

        // <CODE_TAG_105235> lwang
        //Satge
        lstQuoteStageType.Items.Add("");
        foreach (DataRow dr in RowsSet["StageType"])
        {
            lstQuoteStageType.Items.Add(new ListItem(dr["QuoteStageType"].ToString(), dr["QuoteStageTypeCode"].ToString()));
        }

        string strStageType = "";
        foreach (DataRow dr in RowsSet["PSQuoterStageType"])
        {
            if (strStageType != "")
                strStageType += spiltChar1;
            strStageType += dr["Division"].ToString() + "|" + dr["StageTypeCode"].ToString();
        }
        hidStageType.Value = strStageType;

        // <CODE_TAG_105235> lwang

        //Estimated By
        txtEstimatedByName.Text = drQuoteHeader["EstimatedByName"].ToString();


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
        
        //Division
        lstDivision.Items.Add("");
        if (RowsSet.ContainsKey("Division"))
        {
            foreach (DataRow dr in RowsSet["Division"])
            {
                //lstDivision.Items.Add(new ListItem(dr["division"].ToString() + " - " + dr["divisionName"].ToString(), dr["Division"].ToString()));
                //<CODE_TAG_104784>
                ListItem item = new ListItem(dr["division"].ToString() + " - " + dr["divisionName"].ToString(), dr["Division"].ToString());
                item.Attributes["CustomerLoyaltyIndicator"] = dr["CustomerLoyaltyIndicator"].ToString();
                lstDivision.Items.Add(item);
                //</CODE_TAG_104784>
            }
        }

        //Make
        lstMake.Items.Add("");
        if (RowsSet.ContainsKey("Manufacturer"))
        {
            foreach (DataRow dr in RowsSet["Manufacturer"])
            {
                lstMake.Items.Add(new ListItem(dr["ManufacturerCode"].ToString() + " - " + dr["ManufacturerCodeDescription"].ToString(), dr["ManufacturerCode"].ToString().Trim())); //<CODE_TAG_104589>
            }
        }

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
                if (dr["division"].ToString() == currentDivision)
                    lstContact.Items.Add(new ListItem(dr["InfluencerName"].ToString(), dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim().Replace("-", "&#45;")));
            
            if (strInfluencerList != "")
                strInfluencerList += spiltChar1;

            //strInfluencerList += dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim().Replace("-","&#45;") + "-" + dr["phoneNumber"].ToString().Trim() + "-" + dr["fax"].ToString().Trim() + "-" + dr["email"].ToString().Trim() + "-";
            strInfluencerList += dr["Division"].ToString().Trim() + "-" + dr["InfluencerId"].ToString().Trim() + "-" + dr["InfluencerType"].ToString().Trim() + "-" + dr["InfluencerName"].ToString().Trim().Replace("-", "&#45;") + "-" + dr["phoneNumber"].ToString().Trim().Replace("-", "&#45;") + "-" + dr["fax"].ToString().Trim().Replace("-", "&#45;") + "-" + dr["email"].ToString().Trim().Replace("-", "&#45;") + "-"; //<CODE_TAG_102270>
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


        //Owners
        if (RowsSet.ContainsKey("AppUsers"))
        {
            foreach (DataRow dr in RowsSet["AppUsers"])
            {
                if (strOwnersList != "") strOwnersList += spiltChar1;
                strOwnersList += dr["UserId"].ToString() + spiltChar2 + dr["DefaultPhoneNo"].ToString() + spiltChar2 + dr["DefaultCellPhoneNo"].ToString() + spiltChar2 + dr["DefaultFaxNo"].ToString();
            }
        }

        //Reason
        int quoteStatusId = 1;
        int currentStageId = 4;
        string oppStatusDesc = "";
        if (drQuoteHeader != null)
        {
            quoteStatusId = drQuoteHeader["quoteStatusId"].AsInt();
            switch (quoteStatusId)
            {
                case 1:
                    oppStatusDesc = "Development";
                    currentStageId = 4;
                    break;
                case 2:
                    oppStatusDesc = "Proposal";
                    currentStageId = 8;
                    break;
                case 4:
                    oppStatusDesc = "Won";
                    currentStageId = 16;
                    break;
                case 8:
                    oppStatusDesc = "Lost";
                    currentStageId = 32;
                    break;
                case 16:
                    oppStatusDesc = "No Deal";
                    currentStageId = 64;
                    break;
                default:
                    oppStatusDesc = "Development";
                    currentStageId = 4;
                    break;
            }
        }
        string strReasonList = "";
        lstOppReason.Items.Add("");
        foreach (DataRow dr in RowsSet["OppReason"])
        {
            if (strReasonList != "") strReasonList += spiltChar1;
            strReasonList += dr["ReasonId"].ToString() + spiltChar2 + dr["ReasonName"].ToString() + spiltChar2 + dr["stageId"] + spiltChar2 + dr["CommentRequired"].ToString();

            if (quoteStatusId == 8 || quoteStatusId == 16)
            {
                // Ticket 11488 show be bitwise and instead of ==
                //if (currentStageId == dr["stageId"].AsInt())
                if ((currentStageId & dr["stageId"].AsInt()) > 0)
                {
                    lstOppReason.Items.Add(new ListItem(dr["ReasonName"].ToString(), dr["ReasonId"].ToString()));
                }
            }
        }
        hdnOppReasonList.Value = strReasonList;

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

        }
        

        //Header
        if (drQuoteHeader != null)
        {
            lblQuoteNo.Text = drQuoteHeader["QuoteNo"].ToString();
            lstQuoteStatus.SelectedValue = drQuoteHeader["QuoteStatusId"].ToString();
            lstQuoteType.SelectedValue = drQuoteHeader["QuoteTypeId"].ToString();
            lstSalesRep.SelectedValue = drQuoteHeader["SalesRepUserId"].ToString();
            //lblCreator.Text = String.Format("{0} {1}", drQuoteHeader["CreatorFirstName"], drQuoteHeader["CreatorLastName"]);
            lblSalesRep.Text = drQuoteHeader["SalesRepFName"].ToString() + " " + drQuoteHeader["SalesRepLName"].ToString();
            lstBranch.SelectedValue = drQuoteHeader["BranchNo"].ToString();
            lstQuoteStageType.SelectedValue = drQuoteHeader["QuoteStageTypeCode"].ToString().Trim();     //<CODE_TAG_105235> lwang
            txtDescription.Text = drQuoteHeader["QuoteDescription"].ToString();
            lblCustomer.Text = drQuoteHeader["CustomerNo"].ToString() + " - " + drQuoteHeader["CustomerName"].ToString();
            hidCustomerNo.Value = drQuoteHeader["CustomerNo"].ToString();
            hidCustomerName.Value = drQuoteHeader["CustomerName"].ToString();
            //<CODE_TAG_104784> //load loyalty indicator
            int intCatLoyaltyId = 0;
            intCatLoyaltyId = drQuoteHeader["CustomerLoyaltyIndicator"].AsInt();
            int intCallId = 0;
            intCallId = drQuoteHeader["CallId"].AsInt();
            if (intCatLoyaltyId > 0)
            {
                LoadLoyaltyIndicator(intCatLoyaltyId, intCallId);
            }
            //<CODE_TAG_104784>
            lstDivision.SelectedValue = drQuoteHeader["Division"].ToString();
            lstMake.SelectedValue = drQuoteHeader["Make"].ToString();
            lstCabTypeCode.SelectedValue = drQuoteHeader["CabTypeCode"].ToString().Trim();
            if (drQuoteHeader["PromiseDate"].IsDateTime())
            {
                txtPromiseDate.Text =
                    drQuoteHeader["PromiseDate"].AsDateTime().ToString("MMM d, yyyy");
            }
            //<CODE_TAG_103674>
            if (drQuoteHeader["PrintQuoteDate"].IsDateTime())
            {
                txtPrintQuoteDate.Text =
                    drQuoteHeader["PrintQuoteDate"].AsDateTime().ToString("MMM d, yyyy");
            }
            //</CODE_TAG_103674>
            if (drQuoteHeader["UnittoArriveDate"].IsDateTime())
            {
                txtUnittoArriveDate.Text =
                    drQuoteHeader["UnittoArriveDate"].AsDateTime().ToString("MMM d, yyyy");
            }
            if (drQuoteHeader["SMULastRead"].IsDateTime())
            {
                txtSMULastRead.Text =
                    drQuoteHeader["SMULastRead"].AsDateTime().ToString("MMM d, yyyy");
            }
            lstPlannedIndicator.SelectedValue = drQuoteHeader["PlannedIndicatorId"].ToString();
            lstSMUIndicator.SelectedValue = drQuoteHeader["SMUIndicatorId"].ToString();
            lstUrgencyIndicator.SelectedValue = drQuoteHeader["UrgencyIndicatorId"].ToString();

            if (drQuoteHeader["NewContactFlag"].ToString() != "Y")
            {
                foreach (ListItem l in lstContact.Items)
                {
                    if (l.Value == drQuoteHeader["Division"].ToString().Trim() + "-" + drQuoteHeader["InfluencerId"].ToString().Trim() + "-" + drQuoteHeader["InfluencerType"].ToString().Trim() + "-" + drQuoteHeader["ContactName"].ToString().Trim().Replace("-", "&#45;"))
                        l.Selected = true;
                }
                
                txtContact.Style.Add("display", "none");
                chkNewContact.Checked = false;
            }
            else
            {
                txtContact.Text = drQuoteHeader["contactName"].ToString();
                lstContact.Style.Add("display", "none");
                chkNewContact.Checked = true;
            }
            txtPhoneNo.Text = drQuoteHeader["PhoneNo"].ToString();
            txtFax.Text = drQuoteHeader["FaxNo"].ToString();
            txtPO.Text = drQuoteHeader["PurchaseOrderNo"].ToString();
            txtEmail.Text = drQuoteHeader["Email"].ToString(); 
            
            //txtMake.Text = drQuoteHeader["Make"].ToString();
            txtSerialNo.Text = drQuoteHeader["SerialNo"].ToString(); 
            txtModel.Text = drQuoteHeader["Model"].ToString();
            txtUnitNo.Text = drQuoteHeader["UnitNo"].ToString();
            txtStockNo.Text = drQuoteHeader["StockNumber"].ToString(); 
            txtSMU.Text = drQuoteHeader["SMU"].ToString();

            lblOppNo.Text = drQuoteHeader["OppNo"].ToString();
            hdnOppNo.Value = drQuoteHeader["OppNo"].ToString(); 
            lstEstDeliveryMonth.SelectedValue = drQuoteHeader["DeliveryMonth"].ToString(); 
            lstEstDeliveryYear.SelectedValue = drQuoteHeader["DeliveryYear"].ToString();
            if (drQuoteHeader["ProbabilityOfClosing"].ToString() == "1")
                rdoLow.Checked = true;
            if (drQuoteHeader["ProbabilityOfClosing"].ToString() == "2")
                rdoMedium.Checked = true;
            if (drQuoteHeader["ProbabilityOfClosing"].ToString() == "4")
                rdoHigh.Checked = true;

            lstOppType.SelectedValue = drQuoteHeader["OppTypeId"].ToString();
            lstCommodity.SelectedValue = drQuoteHeader["CommodityCategoryId"].ToString();
            lstSource.SelectedValue = drQuoteHeader["OppSourceId"].ToString();
            txtJobControlCode.Text = drQuoteHeader["JobControlCode"].ToString();
            txtEstimatedRepairTime.Text = drQuoteHeader["EstimatedRepairTime"].ToString();
            txtSalesrepPhone.Text = drQuoteHeader["SalesRepPhoneNo"].ToString();
            txtSalesrepCellPhone.Text = drQuoteHeader["SalesRepCellPhoneNo"].ToString();
            txtSalesrepFax.Text = drQuoteHeader["SalesRepFaxNo"].ToString(); 
            if (OppSourceId == 1)
            {
                lstCampaign.SelectedValue = drQuoteHeader["CampaignId"].ToString();
                strLstCampaignSelected = lstCampaign.SelectedValue; //<CODE_TAG_103933>
            }
            else
            {
                lstCampaign.Style.Add("display", "none");
            }

            if (quoteStatusId == 4 || quoteStatusId == 8 || quoteStatusId == 16)
            {
                lblOppStatus.Text = oppStatusDesc;
                txtOppComment.Text = drQuoteHeader["OppComment"].ToString();
                if (quoteStatusId == 4)
                {
                    lblOppReasonTitle.Style.Add("display", "none");
                    lstOppReason.Style.Add("display", "none");
                }
                else
                {
                    lstOppReason.SelectedValue = drQuoteHeader["ReasonId"].ToString(); 
                    lblOppReasonTitle.Style.Add("display", "");
                    lstOppReason.Style.Add("display", "");
                }

                trOppMore.Style.Add("display", "");
            }
            else
            {
                trOppMore.Style.Add("display", "none");
            }
            SegmentHasProspectCust = drQuoteHeader["SegmentHasProspectCust"].ToString();


            if (drQuoteHeader["OppNo"].ToString() != "")
            {
                rdobtnOpportunityYes.Checked = true;
                rdobtnOpportunityYes.Visible = false;
                rdobtnOpportunityNo.Visible = false;
                rdbtnNewOrExistingOpportunity.Visible = false;
                tblNoOpportunity.Visible = false;
                rdbtnNewOrExistingOpportunity.SelectedValue = "2";
            }
            else
            {
                // <CODE_TAG_105370> lwang
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.Mandatory"))
                {
                    rdobtnOpportunityYes.Checked = true;
                    rdobtnOpportunityYes.Visible = false;
                    rdobtnOpportunityNo.Visible = false;                    
                    tblNoOpportunity.Visible = false;
                    rdbtnNewOrExistingOpportunity.SelectedValue = "1";
                }
                else
                {
                    // </CODE_TAG_105370> lwang
                    rdobtnOpportunityNo.Checked = true;
                    tblHasOpportunity.Style.Add("display", "none");
                    rdbtnNewOrExistingOpportunity.SelectedValue = "1";
                } // <CODE_TAG_105370> lwang
            }            

            //last time SMU
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Header.SMU.LastTimeValue.Display"))
            {
                lblLastSMUValueTitle.Visible = false;
                lblLastSMUValue.Visible = false;
            }
            else
            {
                if (drQuoteHeader["lasttimeSMUDate"].IsDateTime())
                {
                    lblLastSMUValue.Text = Util.FormatServiceMeter(drQuoteHeader["lasttimeSMUValue"].As<Double?>(),
                                                          drQuoteHeader["lasttimeSMUIndicatorDesc"].AsString(),
                                                          drQuoteHeader["lasttimeSMUDate"].AsDateTime());

                    DateTime tempDate = drQuoteHeader["lasttimeSMUDate"].AsDateTime();
                    hidLastTimeSMUDate.Value = tempDate.ToString("yyyy-MM-dd");
                    
                }
                else
                {
                    lblLastSMUValue.Text = Util.FormatServiceMeter(drQuoteHeader["lasttimeSMUValue"].As<Double?>(),
                                                          drQuoteHeader["lasttimeSMUIndicatorDesc"].AsString(),
                                                          null);
                    hidLastTimeSMUDate.Value = "";
                }
                hidLastTimeSMUValue.Value = drQuoteHeader["lasttimeSMUValue"].ToString();
                hidLastTimeSMUIndicator.Value = drQuoteHeader["lasttimeSMUIndicator"].ToString();
            }
            
            //<CODE_TAG_101731>
            //comments
            txtComents.Text = (drQuoteHeader["Comments"].AsString() != null) ? Server.HtmlDecode(drQuoteHeader["Comments"].AsString()) : "";
            //</CODE_TAG_101731>


            if (drQuoteHeader["QuoteStatusId"].ToString() == "4") lstQuoteStatus.Enabled = false;  //By V.W
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //<CODE_TAG_103703>
        int QuoteOwnerId_Old = 0;
        int QuoteOwnerId_Current = 0;
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Owner.SendEmailWhenChangeOwner"))
        {
            QuoteOwnerId_Old = getQuoteOwner(quoteId);
            QuoteOwnerId_Current = lstSalesRep.SelectedValue.AsInt();
        }
        //</CODE_TAG_103703>
        int influencerId = 0;
        string influencerType = "";
        string influencerName = "";
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
        if (IsNewQuote)
        {

        }
        else
        {
            DateTime? t = new DateTime();
            t = txtSMULastRead.Text.AsDateTime(); 



            DAL.Quote.QuoteHeaderEdit(quoteId,
                                        revision,
                                      lblQuoteNo.Text.Trim(),
                                      lstQuoteStatus.SelectedValue.AsInt(),
                                      bShowSalesRep ? lstSalesRep.SelectedValue.AsInt() : ObjectExtensions.AsInt(null),
                                      lstBranch.SelectedValue.Trim(),
                                      txtDescription.Text.Trim(),
                                      hidCustomerNo.Value,
                                      hidCustomerName.Value,
                                      hidDivision.Value,
                                      influencerId,
                                      influencerType,
                                      (chkNewContact.Checked) ? txtContact.Text.Trim() : influencerName,
                                      (chkNewContact.Checked) ? "Y" : "N",
                                      txtPhoneNo.Text.Trim().Replace("&#45;", "-"),
                                      txtFax.Text.Trim(),
                                      txtEmail.Text.Trim(),
                                      txtPO.Text.Trim(),
                                      lstMake.SelectedValue, // txtMake.Text.Trim(),
                                      txtModel.Text.Trim(),
                                      txtSerialNo.Text.Trim(),
                                      txtUnitNo.Text.Trim(),
                                      txtStockNo.Text.Trim(),
                                      txtSMU.Text.As<Double?>(),
                                      lstEstDeliveryYear.SelectedValue.AsInt(0),
                                      lstEstDeliveryMonth.SelectedValue.AsInt(0),
                                      (rdoLow.Checked) ? 1 : ((rdoMedium.Checked) ? 2 : 4),
                                      hidSelectedCommodityId.Value.AsInt(0), //lstCommodity.SelectedValue.AsInt(0),  <CODE_TAG_101544>
                                      lstSource.SelectedValue.AsInt(0),
                                      hdnOppNo.Value.AsInt(0),
                                      //lstCampaign.SelectedValue.AsInt(0),
                                      hdnlstCampaignSelected.Value.AsInt(0), //<CODE_TAG_103933>
                                      lstOppReason.SelectedValue.AsInt(0),
                                      txtOppComment.Text.Trim(),
                                      txtPromiseDate.Text.AsNullIfWhiteSpace(),
                                      txtUnittoArriveDate.Text.AsNullIfWhiteSpace(),
                                      lstPlannedIndicator.SelectedValue.AsInt(),
                                      lstUrgencyIndicator.SelectedValue.AsInt(),
                                      lstSMUIndicator.SelectedValue.AsInt(),
                                      txtSMULastRead.Text.AsNullIfWhiteSpace(),
                                      lstQuoteType.SelectedValue.AsInt(),
                                      (rdobtnOpportunityYes.Checked) ? 2 : 1,
                                      rdbtnNewOrExistingOpportunity.SelectedValue.AsInt(),
                                      txtJobControlCode.Text.Trim(),
                                      txtEstimatedRepairTime.Text.Trim(),
                                      txtSalesrepPhone.Text.Trim(),
                                      txtSalesrepCellPhone.Text.Trim(),
                                      txtSalesrepFax.Text.Trim(),
                                      txtEstimatedByName.Text.Trim(),
                                      Server.HtmlEncode(txtComents.Text.Trim()),//<CODE_TAG_101731> 
                                      lstCabTypeCode.SelectedValue
                                      , txtPrintQuoteDate.Text.AsNullIfWhiteSpace() //<CODE_TAG_103674>
                                      , lstQuoteStageType.SelectedValue.Trim()  //<CODE_TAG_105235> lwang
                );
        hidRefreshParent.Value = "1";
        }

        //<CODE_TAG_103703>
        //Send email when owner is changed
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Owner.SendEmailWhenChangeOwner"))
        {
            //if (QuoteOwnerId_Current == QuoteOwnerId_Old) //!!for testing
            if (QuoteOwnerId_Current != QuoteOwnerId_Old)
            {
                string strQuoteAbosolute = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + Page.ResolveUrl("Quote_Segment.aspx").Replace("/Controls", "") + "?QuoteId=" + quoteId + "&Revision=" + revision + "&segmentEdit=1";
                EmailProccess(lstSalesRep.SelectedValue, lstSalesRep.SelectedValue.AsInt(), lblQuoteNo.Text.Trim(), strQuoteAbosolute, txtDescription.Text.Trim(), hidCustomerName.Value, hidCustomerNo.Value, (chkNewContact.Checked) ? txtContact.Text.Trim() : influencerName,
                    txtPhoneNo.Text.Trim(), txtModel.Text.Trim(), txtSerialNo.Text.Trim());
            }

        }
        //</CODE_TAG_103703>
 
    }

    //<CODE_TAG_103703>
    private int getQuoteOwner(int quoteId)
    {
        int retVal = 0;
        retVal = DAL.Quote.GetQuoteOwnerId(quoteId);
        return retVal;
    }
    
    //private void EmailProccess(string sTo, string sCc, string sBcc, string sFrom, string sSubject, string sBody, string sAlert)
    private void EmailProccess(string ownerNo, int QuoteOwnerId, string quoteNo, string strRedirectUrlAbosolute, string quoteDescription, string customerName, string customerNumber, string contactName, string contactPhone, string model, string SerialNo)
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
        sBody += "Estimate Number: <a href='" + strRedirectUrlAbosolute + "'>" + lblQuoteNo.Text.Trim() + "</a><br> <br>";
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
    

    //</CODE_TAG_103703>
    //<CODE_TAG_104784>
    //load loyalty indicator
    private void LoadLoyaltyIndicator(int intCatLoyaltyId, int intCallID)
    {
        //this.lblCustomerLoyaltyIndicator.Visible = true;
        string loyaltyUrl = "http://apps.toromontcat.com/CSM/Modules/StartSurvey.aspx?CallId=" + intCatLoyaltyId + "&ReadOnly=1&FromSaleSLink=1";
        string aLink = "<a style='color:white' target='_blank' href='";
        //intCatLoyaltyId = 4;
        switch (intCatLoyaltyId)
        {
            case 1:
               // lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Red;
                //lblCustomerLoyaltyIndicator.Text = "At Risk ";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > At Risk </a>";
               // lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            case 2:
              //  lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Orange;
                //lblCustomerLoyaltyIndicator.Text = "Vulnerable";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Vulnerable </a>";
               // lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            case 4:
                //lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Green;
                //lblCustomerLoyaltyIndicator.Text = "Loyal ";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Loyal </a>";
               // lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            case 8://no color
                break;

        }

    }
    //</CODE_TAG_104784>
}

