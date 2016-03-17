using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entities;
using System.Data;
using X.Web.UI.WebControls;
using X.Web;
using X.Extensions;
using X.Web.Extensions;
using MenuItem = X.Web.Entities.MenuItem;
using MenuItemGroup = X.Web.Entities.MenuItemGroup;
using Helpers;
using System.Collections.Specialized;

public partial class Modules_Quote_Controls_QuoteHeader : System.Web.UI.UserControl
{
    protected MenuItem menu = new MenuItem(isRoot: true);

    protected int QuoteId;
    protected int Revision;
    protected int PageMode;
    protected int CustomerCount;
    protected DataRow drHeader;
    protected IEnumerable<DataRow> drRevisions;
    protected string QuoteNo;
    protected string WorkorderNo = "";
    protected int SVLTicketId = 0;
	protected string SVLTicketStatus = "";
	protected int AutoCreateTicket = 0;
    protected string WorkorderStatus = "";
    protected bool bShowSalesRep = true;
    protected string ErrorMessage = "";
    protected string DBSCustomer = "0";
    protected string SegmentHasProspectCust = "0";
	protected string SegmentHasBlankJobCode = "0";
	protected string SegmentHasBlankComponentCode = "0";
    protected string CustomerNo = "";
    protected bool CanModify = false;
    protected int RevisionCount = 0;
    protected int SMUCheck = 2;
    protected int CostCentreCheck = 2;
    //<CODE_TAG_106869>R.Z
    public bool SegmentEditLockedByRevisionUpdate  //readonly property
    {
        get
        {
            if (hdnSegmentEditLockedByRevisionUpdate.Value == "Y")
                return true;
            else
                return false;

        }
    }
    //</CODE_TAG_106869>
    IDictionary<string, IEnumerable<DataRow>> RowsSet;

    protected void Page_Load(object sender, EventArgs e)
    {
        QuoteId = Request.QueryString["QuoteId"].AsInt();
        Revision = Request.QueryString["Revision"].AsInt();
        bShowSalesRep = AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show");
        AutoCreateTicket = (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ServiceLink") && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.AutoCreateTicket")) ? 2 : 0;
    }

    public void Bind(int pageMode, IDictionary<string, IEnumerable<DataRow>> rowsSet)
    {
        RowsSet = rowsSet;
        drHeader = RowsSet["QuoteHeader"].FirstOrDefault();
        drRevisions = RowsSet["QuoteRevision"];
        RevisionCount = drRevisions.Count();
        PageMode = pageMode;

        //Revision
        var tabStrip = new TabStrip("tabRevision", TabStripMethod.Url);
        tabStrip.PaddingLeft = 0;
        tabStrip.LeftShoulder = "Revisions:";
        tabStrip.Attributes["leftshoulder-class"] = "RevisionTabLeftShoulder";

        string selectedRevisionValue = "";

        foreach (DataRow dr in drRevisions)
        {
            tabStrip.Add(dr["Revision"].ToString() + " - " + dr["RevisionStatus"].ToString(), dr["Revision"].ToString()).NavigateUrl = "Quote_Summary.aspx" + "?QuoteID=" + QuoteId.ToString() + "&Revision=" + dr["Revision"].ToString() + "&pageMode=2";

            if (dr["CurrentRevision"].ToString() == "2")
            {
                selectedRevisionValue = dr["Revision"].ToString();
                WorkorderNo = dr["wono"].ToString();
                WorkorderStatus = dr["WOStatus"].ToString();

                SVLTicketId = dr["TicketId"].AsInt(0);
				SVLTicketStatus = dr["TicketStatus"].ToString();
            }
        }

        tabStrip.SelectedValue = selectedRevisionValue;
        litRevision.Text = tabStrip.GetHtml();

        // 
        BindData();

        //Group
        tabStrip = new TabStrip("tabGroup", TabStripMethod.Url);
        tabStrip.Add("Summary", "Summary", "1").NavigateUrl = "Quote_Summary.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString();
        tabStrip.Add("Segments", "Segments", "2").NavigateUrl = "Quote_Segment.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString();
        tabStrip.Add("Documents", "Documents", "3").NavigateUrl = "Quote_Document.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString();
        //tabStrip.AddSpacer(100);


        if (WorkorderNo != "")
        {
            tabStrip.Add("WorkOrder-" + WorkorderNo + "(" + WorkorderStatus + ")", "WorkOrder", "4").NavigateUrl = "Quote_WorkOrder.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString();
        }

        // if (TicketId > 0)
            //tabStrip.Add("Ticket-" + TicketId.ToString(), "Ticket", "5").NavigateUrl = "Quote_Ticket.aspx?QuoteId=" + QuoteId.ToString() + "&Revision=" + Revision.ToString();    

        tabStrip.SelectedValue = PageMode.ToString();
        litGroupTabs.Text = tabStrip.GetHtml();

        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Print.Show"))
            divPrint.Visible = false;

    }

    public void BindData()
    {
        if (drHeader != null)
        {
            QuoteNo = drHeader["QuoteNo"].ToString();

            lblQuoteNo.Text = drHeader["QuoteNo"].ToString();
            lblStatus.Text = drHeader["QuoteStatus"].ToString();
            lblQuoteType.Text = drHeader["QuoteTypeDesc"].ToString();
            if (bShowSalesRep)
            {
                lblSalesrep.Text = drHeader["SalesRepFName"].ToString() + " " + drHeader["SalesRepLName"].ToString();
            }
            lblCreator.Text = String.Format("{0} {1}", drHeader["CreatorFirstName"], drHeader["CreatorLastName"]);
            lblBranch.Text = drHeader["branchName"].ToString();
            lblEstimatedByName.Text = drHeader["EstimatedByName"].ToString();
            lblDescription.Text = drHeader["QuoteDescription"].ToString();
            lblQuoteStageType.Text = drHeader["QuoteStageType"].ToString();       //< CODE_TAG_105235 > lwang
            lblCustomer.Text = drHeader["CustomerNo"].ToString() + " - " + drHeader["CustomerName"].ToString();
            if (drHeader["CustomerNo"].ToString().StartsWith("$"))
                DBSCustomer = "0";
            else
                DBSCustomer = "2";
            //<CODE_TAG_104784> //load loyalty indicator
            int intCatLoyaltyId = 0;
            intCatLoyaltyId = drHeader["CustomerLoyaltyIndicator"].AsInt();
            int intCallId = 0;
            if (intCatLoyaltyId > 0)
            {
                LoadLoyaltyIndicator(intCatLoyaltyId, intCallId);
            }
            //</CODE_TAG_104784>

            lblDivision.Text = drHeader["Division"].ToString();
            lblContact.Text = drHeader["ContactName"].ToString();
            lblPhoneNo.Text = drHeader["PhoneNo"].ToString();
            lblPONo.Text = drHeader["PurchaseOrderNo"].ToString();

            hdnCustomerNo.Value = drHeader["CustomerNo"].ToString().Trim();
            CustomerNo = drHeader["CustomerNo"].ToString().Trim();
            hdnBranchNo.Value = drHeader["BranchNo"].ToString().Trim();
            hdnDivision.Value = drHeader["Division"].ToString().Trim();

            lblMake.Text = drHeader["Make"].ToString() + " - " + drHeader["ManufacturerCodeDescription"].ToString();
            lblSerialNo.Text = drHeader["SerialNo"].ToString();
            lblModel.Text = drHeader["Model"].ToString();
            hdnModel.Value = drHeader["Model"].ToString();
            lblUnitNo.Text = drHeader["UnitNo"].ToString();
            lblCab.Text = drHeader["CabTypeCode"].ToString() + " - " + drHeader["CabTypeDesc"].ToString();
            if (drHeader["SMULastRead"].IsDateTime())
            {
                lblSMU.Text = Util.FormatServiceMeter(drHeader["SMU"].As<Double?>(),
                                                      drHeader["SMUIndicatorDesc"].AsString(),
                                                      drHeader["SMULastRead"].AsDateTime());
            }
            else
            {
                lblSMU.Text = Util.FormatServiceMeter(drHeader["SMU"].As<Double?>(),
                                                      drHeader["SMUIndicatorDesc"].AsString(),
                                                      null);
            }
            imgbtnMailTo.Visible = !drHeader["email"].ToString().IsNullOrWhiteSpace();
            if (imgbtnMailTo.Visible)
            {
                imgbtnMailTo.OnClientClick = "window.location='mailto:" + drHeader["email"] + "';return false;";
                imgbtnMailTo.ToolTip = String.Format("email to {0}: {1}", drHeader["ContactName"], drHeader["email"]);
                hdnEmail.Value = drHeader["email"].ToString().Trim();   //TICKET 23348
            }
            hdnFax.Value = drHeader["SalesRepFaxNo"].ToString().Trim(); //<CODE_TAG_103401>
            lblOppNo.Text = drHeader["OppNo"].ToString();
            lblEsDelivery.Text = DateTimeHelper.MonthName(drHeader["DeliveryMonth"].ToString().AsInt(), false) + " " + drHeader["DeliveryYear"].ToString();
            if (drHeader["ProbabilityOfClosing"].ToString() == "1")
                lblProbabilityOfClosing.Text = "Low";
            if (drHeader["ProbabilityOfClosing"].ToString() == "2")
                lblProbabilityOfClosing.Text = "Medium";
            if (drHeader["ProbabilityOfClosing"].ToString() == "4")
                lblProbabilityOfClosing.Text = "High";

            lblQuoeType.Text = drHeader["OppTypeDesc"].ToString();
            lblCommodity.Text = drHeader["CommodityCategoryName"].ToString();
            lblSource.Text = drHeader["OppSourceDesc"].ToString();

            if (drHeader["PromiseDate"].IsDateTime())
            {
                lblPromiseDate.Text = Util.DateFormat(Convert.ToDateTime(drHeader["PromiseDate"]));
            }

            if (drHeader["UnittoArriveDate"].IsDateTime())
            {
                lblUnittoArriveDate.Text = Util.DateFormat(Convert.ToDateTime(drHeader["UnittoArriveDate"]));
            }

            lblPlannedIndicator.Text = drHeader["PlannedIndicatorDesc"].AsString();
            lblUrgencyIndicator.Text = drHeader["UrgencyIndicatorDesc"].AsString();
            lblJobControlCode.Text = drHeader["JobControlCode"].AsString();
            lblEstimatedRepairTime.Text = drHeader["EstimatedRepairTime"].AsString();
            lblComments.Text = (drHeader["Comments"].AsString() != null) ? StringUtils.ConvertCarriageReturnToBR(drHeader["Comments"].AsString()) : "<br />";// <CODE_TAG_101731>
            SegmentHasProspectCust = drHeader["SegmentHasProspectCust"].ToString();
			SegmentHasBlankJobCode = drHeader["SegmentHasBlankJobCode"].ToString();
			SegmentHasBlankComponentCode = drHeader["SegmentHasBlankComponentCode"].ToString();
            CustomerCount = drHeader["CustomerCount"].AsInt(0);
            CanModify = drHeader["CanModify"].AsInt(0) == 2;
            // if (drHeader["CustomerCount"].AsInt(0) == 1)
            //     divInternalPDF.Visible = true;
            // else
            //     divInternalPDF.Visible = false;

            //SMUcheck
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Header.SMU.LastTimeValue.Display") && drHeader["SMU"].AsDouble(0) > 0) //<CODE_TAG_103408> 
            {
                if (drHeader["lasttimeSMUValue"].AsDouble(0) > drHeader["SMU"].AsDouble(0)) SMUCheck = 0;
                if (drHeader["lasttimeSMUIndicator"].AsString("") != "" && drHeader["lasttimeSMUIndicator"].AsString("") != drHeader["SMUIndicatorId"].AsString("") && drHeader["SMUIndicatorId"].AsString("") != "") SMUCheck = 0;
                if (drHeader["lasttimeSMUDate"].IsDateTime() && drHeader["SMULastRead"].IsDateTime())
                {
                    if (drHeader["lasttimeSMUDate"].AsDateTime() > drHeader["SMULastRead"].AsDateTime()) SMUCheck = 0;
                }

            }

            if (AppContext.Current.AppSettings.IsTrue("psQuoter.ERPAPI.Segment.CostCentreCode.Required"))
                CostCentreCheck = drHeader["CostCentreCheck"].AsInt(2);
        }


        // get current revision statusId
        int currentRevisionStatusId = 1;
        int currentRevisionLockUpdateWO = 1;
        foreach (DataRow dr in drRevisions)
        {
            if (dr["CurrentRevision"].ToString() == "2")
            {
                currentRevisionStatusId = dr["RevisionStatusId"].AsInt();
                currentRevisionLockUpdateWO = dr["LockUpdateWO"].AsInt(1);
            }
        }



        var menuItemGroup1 = new MenuItemGroup(new[] {
            new MenuItem{Text = "Edit Quote Header", ToolTip = "Edit Quote Header" , NavigateUrl="javascript:editHeader();" }
        });

        // <CODE_TAG_101746>
        if (AppContext.Current.User.Operation.DeleteQuote || CanModify && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.ModifyCanDelete"))
        //if (AppContext.Current.User.Operation.DeleteQuote )// </CODE_TAG_101746>
        {
            MenuItem deleteQuoteItem = new MenuItem { Text = "Delete Quote", ToolTip = "Delete Quote" };
            deleteQuoteItem.Attributes["onclick"] = "deleteQuote();";
            menuItemGroup1.Add(deleteQuoteItem);
        }
        menuItemGroup1.Text = "Quote Tasks";
        menu.Groups.Add(menuItemGroup1);

        var menuItemGroup2 = new MenuItemGroup();
        if (drHeader["QuoteStatusId"].ToString() != "1")
            menuItemGroup2.Add(new MenuItem { Text = "Open", ToolTip = "Open", NavigateUrl = "javascript:changeQuoteStatusToOpen(1,'" + "Open" + "');" });
        if (drHeader["QuoteStatusId"].ToString() != "2")
            menuItemGroup2.Add(new MenuItem { Text = "Submitted", ToolTip = "Submitted", NavigateUrl = "javascript:changeQuoteStatusToOpen(2,'" + "Submitted" + "');" });
        if (drHeader["QuoteStatusId"].ToString() != "4")
            menuItemGroup2.Add(new MenuItem { Text = "Won", ToolTip = "Won", NavigateUrl = "javascript:changeQuoteStatusToClose(4,'" + "Won" + "');" });
        if (drHeader["QuoteStatusId"].ToString() != "8")
            menuItemGroup2.Add(new MenuItem { Text = "Lost", ToolTip = "Lost", NavigateUrl = "javascript:changeQuoteStatusToClose(8,'" + "Lost" + "');" });
        if (drHeader["QuoteStatusId"].ToString() != "16")
            menuItemGroup2.Add(new MenuItem { Text = "No Deal", ToolTip = "No Deal", NavigateUrl = "javascript:changeQuoteStatusToClose(16,'" + "No Deal" + "');" });
        menuItemGroup2.Text = "Edit Quote Status";
        if (drHeader["QuoteStatusId"].ToString() != "4") menu.Groups.Add(menuItemGroup2);

        //var menuItemGroup3 = new MenuItemGroup(new[] {
        //    new MenuItem{Text = "Change Status to " +  ((currentRevisionStatusId == 1)?"Completed" : "In Progress"   ) , ToolTip = "change Revision status" , NavigateUrl="javascript:changeRevisionStatus("+ ((currentRevisionStatusId == 1)? "2" : "1")  +");" }, 
        //    new MenuItem{Text = "Copy To New Revision", ToolTip = "Copy To New Revision" , NavigateUrl="javascript:copyToNewRevision();" }, 
        //    new MenuItem{Text = "Copy To New Quote", ToolTip = "Copy To New Quote", NavigateUrl = "javascript:copyToNewQuote();" }
        //}) ;
        var menuItemGroup3 = new MenuItemGroup();
        if (drHeader["QuoteStatusId"].AsInt() != 4)
            menuItemGroup3.Add(new MenuItem { Text = "Change Status to " + ((currentRevisionStatusId == 1) ? "Completed" : "In Progress"), ToolTip = "change Revision status", NavigateUrl = "javascript:changeRevisionStatus(" + ((currentRevisionStatusId == 1) ? "2" : "1") + ");" });
        menuItemGroup3.Add(new MenuItem { Text = "Copy To New Revision", ToolTip = "Copy To New Revision", NavigateUrl = "javascript:copyToNewRevision();" });
        menuItemGroup3.Add(new MenuItem { Text = "Copy To New Quote", ToolTip = "Copy To New Quote", NavigateUrl = "javascript:copyToNewQuote();" });


        if (drRevisions.Count() > 1)
        {
            MenuItem deleteRevisionItem = new MenuItem { Text = "Delete Revision", ToolTip = "Delete Revision" };
            deleteRevisionItem.Attributes["onclick"] = "deleteRevision();";
            menuItemGroup3.Add(deleteRevisionItem);
        }


        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ServiceLink"))
        {
            if (SVLTicketId == 0 && currentRevisionStatusId == 8 && (drHeader["QuoteStatusId"].AsInt() & AppContext.Current.AppSettings["psQuoter.Quote.WO.CreatedByQuoteStatus"].AsInt()) > 0 && (AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO)) //<CODE_TAG_103384> 
            {
                menuItemGroup3.Add(new MenuItem { Text = "Create Ticket", ToolTip = "Create Ticket", NavigateUrl = "javascript:createTicket();" });
            }
            // if (TicketId != 0 && (AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO))
            // {
                // menuItemGroup3.Add(new MenuItem { Text = "Update Ticket", ToolTip = "Update Ticket", NavigateUrl = "javascript:updateTicket();" });
                // menuItemGroup3.Add(new MenuItem { Text = "Delete Ticket", ToolTip = "Delete Ticket", NavigateUrl = "javascript:deleteTicket();" });
            // }
        }
        else
        {

            if (WorkorderNo == "" && currentRevisionStatusId == 8 && (drHeader["QuoteStatusId"].AsInt() & AppContext.Current.AppSettings["psQuoter.Quote.WO.CreatedByQuoteStatus"].AsInt()) > 0 && (AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO)) //<CODE_TAG_103384> 
            {
                menuItemGroup3.Add(new MenuItem { Text = AppContext.Current.AppSettings["psQuoter.Quote.Header.ContextMenu.Label.CreatePreWorkOrder"], ToolTip = AppContext.Current.AppSettings["psQuoter.Quote.Header.ContextMenu.Label.CreatePreWorkOrder"], NavigateUrl = "javascript:createWorkorder();" });
            }
            // <CODE_TAG_103384> start
            if (WorkorderNo == "" && (currentRevisionStatusId == 8 || AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowLinkWO.AnyStatus")) && (AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO) && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowLinkWO"))
            {
                menuItemGroup3.Add(new MenuItem { Text = "Link Workorder", ToolTip = "Link WorkOrder", NavigateUrl = "javascript:linkWorkorder();" });
            }
            //<CODE_TAG_103384> end
            if (WorkorderNo != "" && (AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO) && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowLinkWOToNewRevision"))
            {
                menuItemGroup3.Add(new MenuItem { Text = "Link Workorder To New Revision", ToolTip = "Link WorkOrder to New Revision", NavigateUrl = "javascript:linkWorkorderToNewRevision();" });
            }
            //<CODE_TAG_103366> start
            if (WorkorderNo != "" && ((AppContext.Current.User.Operation.RoleId.AsInt() & AppContext.Current.AppSettings["psQuoter.Quote.WO.UnLinkWOPrivilege"].AsInt()) > 0))
            {
                menuItemGroup3.Add(new MenuItem { Text = "Unlink Workorder", ToolTip = "Unlink to WorkOrder", NavigateUrl = "javascript:unlinkWorkorder();" });
            }
            //<CODE_TAG_103366> end
        }
        menuItemGroup3.Text = "Current Revision Tasks";
        menu.Groups.Add(menuItemGroup3);



        if (WorkorderNo != "" && WorkorderStatus == "E")
        {
            var menuItemGroup4 = new MenuItemGroup();
            if ((AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO) && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowUpdateWO"))
                menuItemGroup4.Add(new MenuItem { Text = "Update Workorder", ToolTip = "Update Workorder", NavigateUrl = "javascript:updateWorkorder();" });

            if (AppContext.Current.User.Operation.Admin && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowDeleteWO"))
                menuItemGroup4.Add(new MenuItem { Text = "Delete Workorder", ToolTip = "Delete Workorder", NavigateUrl = "javascript:deleteWorkorder();" });

            menuItemGroup4.Text = "Workorder";

            if (menuItemGroup4.Count > 0)
                menu.Groups.Add(menuItemGroup4);
        }


        if (WorkorderNo != "" && WorkorderStatus == "O" && currentRevisionLockUpdateWO != 2)
        {
            var menuItemGroup4 = new MenuItemGroup();
            if ((AppContext.Current.User.Operation.Admin || AppContext.Current.User.Operation.CreateWO) && AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.WO.ShowUpdateWO"))
                menuItemGroup4.Add(new MenuItem { Text = "Update Workorder", ToolTip = "Update Workorder", NavigateUrl = "javascript:updateWorkorder();" });

            menuItemGroup4.Text = "Workorder";

            if (menuItemGroup4.Count > 0)
                menu.Groups.Add(menuItemGroup4);

            hdnSegmentEditLockedByRevisionUpdate.Value = "N";//<CODE_TAG_106869>R.Z
        }
        //<CODE_TAG_106869>R.Z
        else
        {
            //segmentEditLockedByRevisionUpdate = true;
            hdnSegmentEditLockedByRevisionUpdate.Value = "Y";
        }
        //</CODE_TAG_106869>

        menu.Text = "Common Tasks";



    }

    protected void btnPostback_Click(object sender, EventArgs e)
    {
        int rt = 0;
        int newRevision;
        NameValueCollection objNewValueCollection =
            HttpUtility.ParseQueryString(Request.QueryString.ToString());
        string operation = getPostbackParameters("operation").ToUpper();
        switch (operation)
        {
            case "CHANGESTATUS":
                int statusId = getPostbackParameters("statusId").AsInt();
				int createTicket = getPostbackParameters("CreateTicket").AsInt();
                DAL.Quote.QuoteStatusChange(QuoteId, Revision, statusId, createTicket);
                //    objNewValueCollection.Set("Revision", Revision.ToString());
                break;

            case "COPYREVISION":
                newRevision = 0;
                DAL.Quote.CopyRevision(QuoteId, Revision, out newRevision);
                //objNewValueCollection.Set("Revision", newRevision.ToString());
                Response.Redirect("~/modules/Quote/quote_Segment.aspx?QuoteId=" + QuoteId + "&Revision=" + newRevision + "&segmentEdit=1");
                break;
            case "COPYQUOTE":
                int newQuoteId = 0;
                DAL.Quote.CopyQuote(QuoteId, Revision, out newQuoteId);

                Response.Redirect("~/modules/Quote/quote_Segment.aspx?QuoteId=" + newQuoteId + "&Revision=1&segmentEdit=1");
                break;

            case "DELETEREVISION":
                int latestRevision = 0;
                DAL.Quote.DeleteRevision(QuoteId, Revision, out latestRevision);
                objNewValueCollection.Set("Revision", latestRevision.ToString());
                objNewValueCollection.Set("SegmentId", "");
                break;
            case "CHANGEREVISIONSTATUS":
                int revisionStatusId = getPostbackParameters("statusId").AsInt();
                DAL.Quote.ChangeRevisionStatus(QuoteId, Revision, revisionStatusId);
                break;
            case "CREATEWORKORDER":
                DAL.Quote.CreateWorkorder(QuoteId, Revision);
                break;
            case "LINKWORKORDER":
                string wono = getPostbackParameters("wono").AsString("");
                DAL.Quote.LinkWorkorder(QuoteId, Revision, wono);
                break;
            case "OPENWORKORDER":
                DAL.Quote.OpenWorkorder(QuoteId, Revision);
                break;
            case "UPDATEWORKORDER":
                rt = DAL.Quote.UpdateWorkorder(QuoteId, Revision);
                if (rt != 0)
                {
                    switch (rt)
                    {
                        case 410:
                            ErrorMessage = "The referenced work order is not Estimated, Cannot update DBS work order.";
                            break;
                        //<CODE_TAG_104820>
                        case 412:
                            ErrorMessage = "The Work order in PSQuoter and DBS are currently out of sync, and to try again later";
                            break;
                        //</CODE_TAG_104820>
                        default:
                            ErrorMessage = "System error, Cannot update DBS work order.";
                            break;
                    }

                    return;
                }
                break;
            case "DELETEWORKORDER":
                rt = DAL.Quote.DeleteWorkorder(QuoteId, Revision);
                if (rt != 0)
                {
                    switch (rt)
                    {
                        case 410:
                            ErrorMessage = "The referenced work order is not Estimated, Cannot delete DBS work order.";
                            break;
                        default:
                            ErrorMessage = "System error, Cannot delete DBS work order.";
                            break;
                    }

                    return;
                }
                break;
            case "LINKWOTONEWREVISION":
                newRevision = 0;
                DAL.Quote.LinkWOToNewRevision(QuoteId, Revision, out newRevision);
                Response.Redirect("~/modules/Quote/quote_Segment.aspx?QuoteId=" + QuoteId + "&Revision=" + newRevision + "&segmentEdit=1");
                break;
            //<CODE_TAG_103366> start
            case "UNLINKWORKORDER":
                DAL.Quote.UnlinkWorkorder(QuoteId, Revision);
                Response.Redirect("~/modules/Quote/quote_Segment.aspx?QuoteId=" + QuoteId + "&Revision=1&tabGroup=1");
                break;
            //<CODE_TAG_103366> end            
            case "CREATETICKET":
                DAL.Quote.CreateTicket(QuoteId, Revision);
                break;
            case "UPDATETICKET":
                DAL.Quote.UpdateTicket(QuoteId, Revision);
                break;
            case "DELETETICKET":
                DAL.Quote.DeleteTicket(QuoteId, Revision);
                break;

            default:
                break;
        }
        Response.Redirect(Request.Url.AbsolutePath + "?" + objNewValueCollection.ToString());


    }

    private string getPostbackParameters(string key)
    {
        string rt = "";
        string[] parameters = hdnPostbackOperation.Value.Split("&");
        foreach (string str in parameters)
        {
            if (str.StartsWith(key))
                rt = str.Substring(key.Length + 1);
        }

        return rt;
    }

    //<CODE_TAG_104784>
    //load loyalty indicator
    private void LoadLoyaltyIndicator(int intCatLoyaltyId, int intCallID)
    {
        this.lblCustomerLoyaltyIndicator.Visible = true;
        string loyaltyUrl = "http://apps.toromontcat.com/CSM/Modules/StartSurvey.aspx?CallId=" + intCatLoyaltyId + "&ReadOnly=1&FromSaleSLink=1";
        //loyaltyUrl = "http://kapur/PSQuoter/modules/Quote/quote_Summary.aspx?QuoteId=9367&Revision=1";
        //intCatLoyaltyId = 4;
        string aLink = "";
        switch (intCatLoyaltyId)
        {
            case 1:
                lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Red;
                //lblCustomerLoyaltyIndicator.Text = "At Risk ";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > At Risk </a>";
                lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            case 2:
                lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Orange;
                //lblCustomerLoyaltyIndicator.Text = "Vulnerable";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Vulnerable </a>";
                lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            case 4:
                lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Green;
                lblCustomerLoyaltyIndicator.Text = "Loyal ";
                aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Loyal </a>";
                lblCustomerLoyaltyIndicator.Text = aLink;
                break;
            //case 8://no color
            default:
                lblCustomerLoyaltyIndicator.BackColor = System.Drawing.Color.Transparent;
                lblCustomerLoyaltyIndicator.Text = "";
                break;

        }

    }
    //</CODE_TAG_104784>


}

