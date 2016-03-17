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
using Helpers;


using MenuItem = X.Web.Entities.MenuItem;
using MenuItemGroup = X.Web.Entities.MenuItemGroup;

public partial class Modules_Quote_Summary : UI.Abstracts.Pages.ReportViewPage   
{
    protected int QuoteId;
    protected int Revision;
    protected int PageMode = 1;
    protected int SegmentId;
    DataSet dsQuote;
    DataSet dsSegment;
    protected double SegmentsTotal;
    protected string CustomerNo="";
    protected bool RenderNotes = true;

    IDictionary<string, IEnumerable<DataRow>> RowsSet;
    IDictionary<string, IEnumerable<DataRow>> SegmentRowsSet;

    protected MenuItem menu = new MenuItem(isRoot: true);
    private double totalPartsFlatRateAmount = 0;
    private double totalLaborFlatRateAmount = 0;
    private double totalMiscFlatRateAmount = 0;
    private double totalTotalFlatRateAmount = 0;
    private double totalSegTotalFlatRateAmount = 0;
    protected bool CanModify = false;

    protected bool PageEdit = false;
    //<CODE_TAG_103379>
    protected string multiLineNote = string.Empty;  //for multiple line external notes 
    protected string mlutiLineNote_Internal = string.Empty;
    protected string multilineInstruction = string.Empty;
    protected bool ExteranlNoteOnly = (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.InternalNotesTogglableShow")) ? true : false;
    //</CODE_TAG_103379>
    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Quote";

        QuoteId = Request.QueryString["QuoteId"].AsInt();
        Revision = Request.QueryString["Revision"].AsInt();
        SegmentId = Request.QueryString["SegmentId"].AsInt();
        if ( lstCustomer.SelectedValue == "")
            CustomerNo = Request.QueryString["CustomerNo"].AsString("");

        if (Request.QueryString["PageEdit"].AsInt(0) == 1 && AppContext.Current.User.Operation.CreateQuote)
            PageEdit = true;
         
    }

    private void Page_PreRender(object sender, System.EventArgs e)
    {
        dsQuote = DAL.Quote.QuoteDetailGet(QuoteId, Revision, PageMode, SegmentId, false);
        RowsSet = dsQuote.ToDictionary();

        if (RowsSet.ContainsKey("QuoteHeader"))
        {
            DataRow drHeader = RowsSet["QuoteHeader"].FirstOrDefault();
            HttpContext.Current.Items.Add("Global_CanModifyQuote", drHeader["CanModify"].AsInt(0));
            PageEdit = PageEdit && drHeader["CanModify"].AsInt(0) == 2;
        }
        
        //Header
        quoteHeader.Bind(PageMode, RowsSet);

        dsSegment = DAL.Quote.Quote_Get_SegmentFinancials(QuoteId, Revision, lstCustomer.SelectedValue);
        SegmentRowsSet = dsSegment.ToDictionary();

        string selectedCustomerNo = lstCustomer.SelectedValue;
        if (CustomerNo != "")
            selectedCustomerNo = CustomerNo;

        if (selectedCustomerNo.IsNullOrWhiteSpace()) selectedCustomerNo = "";
        if (SegmentRowsSet["Customers"].Count() < 2)
        {
            DataRow dr =  SegmentRowsSet["Customers"].FirstOrDefault();
            if (dr != null)
                lblCustomer.Text = dr["CustomerNo"].ToString() + " - " + dr["CustomerName"].ToString();
            lstCustomer.Visible = false;
        }
        else
        {
            lstCustomer.Items.Clear();
            lstCustomer.Items.Add(new ListItem("All", ""));
            foreach (DataRow dr in SegmentRowsSet["Customers"])
            {
                lstCustomer.Items.Add(new ListItem( dr["CustomerNo"].ToString() + " - " + dr["CustomerName"].ToString(), dr["CustomerNo"].ToString()));
            }
            lstCustomer.SelectedValue = selectedCustomerNo;

            if (selectedCustomerNo == "")
                ucFinancials.Visible = false;

        }

        repSegments.DataSource = SegmentRowsSet["segmentFinancials"];
        repSegments.DataBind();


        foreach (DataRow dr in RowsSet["QuoteRevision"])
        {
            if (dr["Revision"].AsInt() == Revision)
            {
                //lblQuoteCurrentRevisionStatus.Text = dr["RevisionStatus"].ToString();
                lblQuoteCurrentRevisionUpdateInfo.Text = "Last Updated By " + dr["FirstName"].ToString() + " " + dr["LastName"] + " on " + Util.DateFormat(dr["ChangeDate"].AsDateTime());
            }
        }

        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.Show"))
        {
            ucFinancials.Visible = true;
            ucFinancials.Bind(QuoteId, Revision, lstCustomer.SelectedValue);
        }
        else
        {
            ucFinancials.Visible = false;
        }


        if (selectedCustomerNo == "" && SegmentRowsSet["Customers"].Count() > 1)
            ucFinancials.Visible = false;

        ////Notes
        //if (RenderNotes)
        //{
            IEnumerable<DataRow> rsExternalNotes = null;
            IEnumerable<DataRow> rsInstructions = null;    
            /*if (RowsSet.ContainsKey("ExternalNotes"))
            {
                rsExternalNotes = RowsSet["ExternalNotes"];
                hidExternalNotesCount.Value  = rsExternalNotes.Count().ToString();
            }*/
            //<CODE_TAG_103379>
            if (RowsSet.ContainsKey("ExternalNotes"))
            {
                rsExternalNotes = RowsSet["ExternalNotes"];
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                {
                    hidExternalNotesCount.Value = rsExternalNotes.Count().ToString();
                }
                else
                {
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
            //</CODE_TAG_103379>
            /*if (RowsSet.ContainsKey("Instructions"))
            {
               rsInstructions = RowsSet["Instructions"];
               hidInstructionsCount.Value = rsInstructions.Count().ToString();
            }*/
            //<CODE_TAG_103379>
            if (RowsSet.ContainsKey("Instructions"))
            {
                rsInstructions = RowsSet["Instructions"];
                if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
                {
                    hidInstructionsCount.Value = rsInstructions.Count().ToString();
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
            //<CODE_TAG_103379>
            //ucNotes.Bind("ExternalNotes", rsExternalNotes, 25, PageEdit);
            //<CODE_TAG_103379>
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
            {
                ucNotes.Bind("ExternalNotes", rsExternalNotes, 25, PageEdit);
            }
            else
            { 
                //to do
                if (!ExteranlNoteOnly)
                { multiLineNote += "~" + mlutiLineNote_Internal; }
                ucNotes.Bind("ExternalNotes", multiLineNote, PageEdit, ExteranlNoteOnly);
            }
            //</CODE_TAG_103379>
            //ucInstructions.Bind("Instructions", rsInstructions, 5, PageEdit);
            //<CODE_TAG_103379>
            if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
            {
                ucInstructions.Bind("Instructions", rsInstructions, 5, PageEdit);
            }
            else
            { 
                //to do
                
                ucInstructions.Bind("Instructions", multilineInstruction, PageEdit);
            }
        //}
        //else
        //{
        //    ucNotes.BindEditingNotes("ExternalNotes", hidExternalNotes.Value, 25);
        //    ucInstructions.BindEditingNotes("Instructions", hidInstructions.Value, 10);
        //}
       

        if (PageEdit)
        {
            btnEdit.Visible = false;
            btnSave.Visible = true;
            btnCancel.Visible = true;
            hdnInptBtnSaveShowInd.Value = "2"; //Display //<CODE_TAG_104119> 
        }
        else
        {
            btnEdit.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = false;
            hdnInptBtnSaveShowInd.Value = "1"; //Display //<CODE_TAG_104119>
        }
       
    }

    protected void repSegments_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Label tempLabel;
        PlaceHolder plhSegmentNo;
        LinkButton lbtnSegmentNo;
        DataRow dr;
        switch (e.Item.ItemType)
        {
            case ListItemType.Item:
            case ListItemType.AlternatingItem:
                dr = (DataRow)e.Item.DataItem;

                plhSegmentNo = (PlaceHolder)e.Item.FindControl("plhSegmentNo");
                lbtnSegmentNo = new LinkButton();
                lbtnSegmentNo.Text = dr["SegmentNo"].ToString();
                lbtnSegmentNo.PostBackUrl = "~/modules/Quote/Quote_Segment.aspx?QuoteId=" + QuoteId + "&Revision=" + Revision + "&SegmentId=" + dr["QuoteSegmentId"].ToString();
                plhSegmentNo.Controls.Add(lbtnSegmentNo);

                tempLabel = (Label)e.Item.FindControl("lblJobCode");
                tempLabel.Text = dr["JobCode"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblComponentCode");
                tempLabel.Text = dr["ComponentCode"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblJobCodeDesc");
                tempLabel.Text = dr["JobCodeDesc"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblComponentCodeDesc");
                tempLabel.Text = dr["ComponentCodeDesc"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblPartsFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(dr["partsAmount"].AsDouble(), 2, null, null, null, null);

                tempLabel = (Label)e.Item.FindControl("lblPartsFlatRateInd");
                tempLabel.Text = (dr["partFlatRateInd"].ToString() == "N" || dr["partsAmount"].AsDouble() == 0 ) ? "" : dr["partFlatRateInd"].ToString();


                tempLabel = (Label)e.Item.FindControl("lblLaborFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(dr["laborAmount"].AsDouble(), 2, null, null, null, null);

                tempLabel = (Label)e.Item.FindControl("lblLaborFlatRateInd");
                tempLabel.Text = (dr["laborFlatRateInd"].ToString() == "N" || dr["laborAmount"].AsDouble() == 0) ? "" : dr["laborFlatRateInd"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblMiscFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(dr["miscAmount"].AsDouble(), 2, null, null, null, null);

                tempLabel = (Label)e.Item.FindControl("lblMiscFlatRateInd");
                tempLabel.Text = (dr["miscFlatRateInd"].ToString() == "N" || dr["miscAmount"].AsDouble() == 0) ? "" : dr["miscFlatRateInd"].ToString();

                tempLabel = (Label)e.Item.FindControl("lblTotalFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(dr["totalAmount"].AsDouble(), 2, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblTotalFlatRateInd");

                tempLabel = (Label)e.Item.FindControl("lblSegQty");
                tempLabel.Text = Util.NumberFormat(dr["SegmentQty"].AsInt(), 0, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblSegTotalFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(dr["SegmentExtTotal"].AsDouble(), 2, null, null, null, true);


                totalPartsFlatRateAmount += dr["partsAmount"].AsDouble();
                totalLaborFlatRateAmount += dr["laborAmount"].AsDouble();
                totalMiscFlatRateAmount += dr["miscAmount"].AsDouble();
                totalTotalFlatRateAmount += dr["totalAmount"].AsDouble();
                totalSegTotalFlatRateAmount += dr["SegmentExtTotal"].AsDouble();
                break;

            case ListItemType.Footer:
                tempLabel = (Label)e.Item.FindControl("lblTotalPartsFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(totalPartsFlatRateAmount, 2, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblTotalLaborFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(totalLaborFlatRateAmount, 2, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblTotalMiscFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(totalMiscFlatRateAmount, 2, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblTotalTotalFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(totalTotalFlatRateAmount, 2, null, null, null, true);

                tempLabel = (Label)e.Item.FindControl("lblTotalSegTotalFlatRateAmount");
                tempLabel.Text = Util.NumberFormat(totalSegTotalFlatRateAmount, 2, null, null, null, true);

                //tempLabel = (Label)e.Item.FindControl("lblTotalSegTotalFlatRateAmount");
                //tempLabel.Text = Util.NumberFormat(totalSegTotalFlatRateAmount, 2, null, null, null, true);
                break;
        }
    }

    protected void lstCustomer_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        CustomerNo = "";
    }

    protected void btnPageSave_Click(object sender, EventArgs e)
    {
        //save Notes
        //<CODE_TAG_103379>
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))
            SaveNotes_SingleLineMode();
        else
            SaveNotes_MultiLineMode();
        //<CODE_TAG_103379>

        //<CODE_TAG_103404>
        //Save Quote Revision Financials Summary
        ucFinancials.Save(QuoteId, Revision, CustomerNo);
        //</CODE_TAG_103404>

        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("PageEdit,CustomerNo", normalizeForAppending: true);



        Response.Redirect(urlBase + "&PageEdit=0" + ((lstCustomer.SelectedValue == "") ? "" : "&CustomerNo=" + lstCustomer.SelectedValue));
    }

   
    //<CODE_TAG_103379>
    private void SaveNotes_MultiLineMode()
    {
        //int intSegmentId = Request.QueryString["QuoteId"].AsInt();
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
        //DAL.Quote.Quote_Save_QuoteLevelMultiLineNotesAndInstruction(QuoteId, Revision, strExternalNotesNotes.HtmlEncode(), strExteranlNotesNotesINotes.HtmlEncode(), strInstructionsNotes.HtmlEncode()); //<CODE_TAG_105824>
        DAL.Quote.Quote_Save_QuoteLevelMultiLineNotesAndInstruction(QuoteId, Revision, strExternalNotesNotes.HtmlDecode(), strExteranlNotesNotesINotes.HtmlDecode(), strInstructionsNotes.HtmlDecode()); //<CODE_TAG_105824>

    }
    //</CODE_TAG_103379>
    //<CODE_TAG_103379>
    private void SaveNotes_SingleLineMode()
    {
        DAL.Quote.DeleteAllHeaderNotes(QuoteId, Revision);
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
                //DAL.Quote.AddHeaderNote(QuoteId, Revision, 1, externalNotes[i].Trim(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort);
                //DAL.Quote.AddHeaderNote(QuoteId, Revision, 1, externalNotes[i].Trim().HtmlEncode(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort);//<CODE_TAG_103922>
                DAL.Quote.AddHeaderNote(QuoteId, Revision, 1, externalNotes[i].Trim().HtmlDecode(), (externalNotesMasterIndicators[i] == "") ? "E" : externalNotesMasterIndicators[i], sort);//<CODE_TAG_103922>
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
                //DAL.Quote.AddHeaderNote(QuoteId, Revision, 2, str, "E", sort); //E for mastrIndicator
                //DAL.Quote.AddHeaderNote(QuoteId, Revision, 2, str.HtmlEncode(), "E", sort); //E for mastrIndicator //<CODE_TAG_103922>
                DAL.Quote.AddHeaderNote(QuoteId, Revision, 2, str.HtmlDecode(), "E", sort); //E for mastrIndicator //<CODE_TAG_103922>
                sort++;
            }
        }
        if (lstCustomer.SelectedValue != "" && lstCustomer.Visible)
            ucFinancials.Save(QuoteId, Revision, lstCustomer.SelectedValue);
        else
        {
            if (ucFinancials.Visible)
                ucFinancials.Save(QuoteId, Revision, "");
        }
    }
  //<CODE_TAG_103379>
    protected void btnPageEdit_Click(object sender, EventArgs e)
    {

        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("PageEdit,CustomerNo", normalizeForAppending: true);

        Response.Redirect(urlBase + "&PageEdit=1" + ((lstCustomer.SelectedValue == "") ? "" : "&CustomerNo=" + lstCustomer.SelectedValue));
    }

    protected void btnPageCancel_Click(object sender, EventArgs e)
    {
        var currentPage = global::X.Web.WebContext.Current.Page;
        var urlBase = currentPage.StripKeysFromCurrentPage("PageEdit,CustomerNo", normalizeForAppending: true);
        Response.Redirect(urlBase + "&PageEdit=0" + ((lstCustomer.SelectedValue == "") ? "" : "&CustomerNo=" + lstCustomer.SelectedValue));
    }

    //<CODE_TAG_105318> lwang 
    protected void btnLaborRepricing_Click(object sender, EventArgs e)
    {
        DAL.Quote.Quote_Segment_Labor_Repriceing(QuoteId, Revision);
    }
    //</CODE_TAG_105318> lwang 

}

