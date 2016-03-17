using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Data;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;
using Helpers;

public partial class Modules_Quote_Controls_Financials : System.Web.UI.UserControl
{
    protected int rowIdx;

    DataTable dtCustomerFinancial;

    int QuoteId = 0;
    int Revision = 0;
    string CustomerNo = "";
    bool CanModify = false;
    bool PageEdit = false;
    bool ShowFinancialItemAmtWhenNotApplicable = false; //<CODE_TAG_104523>

    protected void Page_Load(object sender, EventArgs e)
    {
        rowIdx = 0;
        if (Request.QueryString["PageEdit"].AsInt(0) == 1 && AppContext.Current.User.Operation.CreateQuote)
            PageEdit = true;
        //<CODE_TAG_104523>
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.FinancialItemAmount.ShowNumberWhenNotApplicable"))
            ShowFinancialItemAmtWhenNotApplicable = true;
        //</CODE_TAG_104523>
    }

    public void Bind(int quoteId, int revision, string customerNo)
    {
        DataSet dsFinancials;
        QuoteId = quoteId;
        Revision = revision;
        CustomerNo = customerNo;

        dsFinancials = DAL.Quote.Quote_Revision_Financials_Get(quoteId, revision, customerNo);

        dtCustomerFinancial = dsFinancials.Tables[1];

        CanModify = HttpContext.Current.Items["Global_CanModifyQuote"].AsInt(0) == 2;
        CanModify = CanModify && PageEdit;


        rptFinancials.DataSource = dsFinancials.Tables[0];
        rptFinancials.DataBind();
    }

    protected void rptFinancials_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        switch (e.Item.ItemType)
        {
            case ListItemType.Item:
            case ListItemType.AlternatingItem:
                DataRowView dr;
                dr = (DataRowView)e.Item.DataItem;

                Label itemDisplayName;
                Label itemPercent;
                Label itemAmount;
                TextBox tbxItemAmount; //<CODE_TAG_104119>
                string rowStyle;
                HtmlTableRow itemRow;

                bool bTotalLine = false;
                string defaultTotalLineClass = "reportHeader";
                string defaultNonTotalLineClass = "rd";
                string defaultNonTotalLineAltClass = "rl";

                CheckBox chkNotApplicable;
                Label lblNotApplicableChangeInfo;

                bTotalLine = dr["FinancialItemId"].IsNullOrWhiteSpace() ? true : false;

                rowStyle = dr["RowStyle"].ToString();

                if (bTotalLine)
                {
                    if (rowStyle.IsNullOrWhiteSpace())
                    {
                        rowStyle = defaultTotalLineClass;
                    }
                    rowIdx = 0;
                }
                else
                {
                    rowIdx++;
                    if (rowStyle.IsNullOrWhiteSpace())
                    {
                        rowStyle = (rowIdx % 2 == 0) ? defaultNonTotalLineClass : defaultNonTotalLineAltClass;
                    }
                }

                itemRow = (HtmlTableRow)e.Item.FindControl("itemRow");
                itemRow.Attributes.Add("class", rowStyle);

                itemDisplayName = (Label)e.Item.FindControl("lblFinancialsItemName");
                itemPercent = (Label)e.Item.FindControl("lblFinancialsItemPercent");
                itemAmount = (Label)e.Item.FindControl("lblFinancialsItemAmount");
                //<CODE_TAG_104119>
                tbxItemAmount = (TextBox)e.Item.FindControl("tbxFinancialsItemAmount");
                int FinancialItemAmtEditable = 0;
                if (dr["FinancialItemAmtEditable"] != DBNull.Value)
                    FinancialItemAmtEditable = Convert.ToInt32(dr["FinancialItemAmtEditable"]);
                if (FinancialItemAmtEditable == 2 && PageEdit)
                {
                    itemAmount.Visible = false;
                    tbxItemAmount.Visible = true;
                }
                else
                {
                    itemAmount.Visible = true;
                    tbxItemAmount.Visible = false;
                }
                //</CODE_TAG_104119>
                itemDisplayName.Text = dr["FinancialItemDisplayName"].ToString();

                if (dr["FinancialItemPercent"].IsNullOrWhiteSpace())
                {
                    if (!bTotalLine)
                    {
                        itemPercent.Text = "-";
                    }
                }
                else
                {
                    itemPercent.Text = Util.NumberFormat(dr["FinancialItemPercent"].AsDouble(0.00), 2, -2, -2, -2, true) + "%";
                }

                //itemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true); //commont out for <CODE_TAG_104523>

                tbxItemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true); //<CODE_TAG_104119>
                chkNotApplicable = e.Item.FindControl("chkNotApplicable") as CheckBox;
                lblNotApplicableChangeInfo = e.Item.FindControl("lblNotApplicableChangeInfo") as Label;
                chkNotApplicable.Attributes.Add("FinancialItemid", dr["FinancialItemId"].ToString());

                //<CODE_TAG_104119>
                tbxItemAmount.Attributes.Add("FinancialItemid", dr["FinancialItemId"].ToString());
                chkNotApplicable.Attributes.Add("onclick", "chkNotApplicableSelectChanged(this)");
                //</CODE_TAG_104119>


                if (dr["NotApplicableEnable"].ToString() == "2")
                {
                    if (dr["IncludeIndicator"].AsInt() == 1)
                    {
                        chkNotApplicable.Checked = true;
                        //<CODE_TAG_104119>
                        // tbxItemAmount.ReadOnly = true;
                        //tbxItemAmount.Text = "0.01";
                        //itemAmount.Text = "0.00";
                        //</CODE_TAG_104119>
                    }
                    else
                    {
                        chkNotApplicable.Checked = false;
                        // tbxItemAmount.ReadOnly = false; //<CODE_TAG_104119>
                    }

                    lblNotApplicableChangeInfo.Text = "Updated by " + dr["firstName"] + " " + dr["lastName"] + " on " + Util.DateFormat(dr["ChangeDate"].AsDateTime());
                    if (CanModify)
                    {
                        chkNotApplicable.Enabled = true;
                    }
                    else
                    {
                        chkNotApplicable.Enabled = false;
                    }

                    if (dr["Editable"].ToString() != "2")
                    {
                        chkNotApplicable.Enabled = false;
                        lblNotApplicableChangeInfo.Text = "";
                    }
                }
                else
                {
                    chkNotApplicable.Visible = false;
                    lblNotApplicableChangeInfo.Visible = false;
                }



                //<CODE_TAG_104523>

                if (ShowFinancialItemAmtWhenNotApplicable)
                {
                    itemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true);
                }
                else
                {
                    tbxItemAmount.Visible = true;
                    itemAmount.Visible = true;
                    if (chkNotApplicable.Checked)
                    {


                        itemAmount.Text = "0.00";
                        tbxItemAmount.Style["display"] = "none";
                        itemAmount.Style["display"] = "";
                    }
                    else
                    {
                        //if (chkNotApplicable.Enabled)
                        if (chkNotApplicable.Visible)
                        {
                            //tbxItemAmount.Visible = true;
                            //itemAmount.Visible = true;
                            tbxItemAmount.Style["display"] = "";
                            itemAmount.Style["display"] = "none";
                            //itemAmount.Text = "0.00";
                            if (!CanModify)
                            {
                                itemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true);
                                tbxItemAmount.Style["display"] = "none";
                                itemAmount.Style["display"] = "";
                            }
                            else
                            { 
                                itemAmount.Text = "0.00";
                                tbxItemAmount.Style["display"] = "";
                                itemAmount.Style["display"] = "none";
                            }

                        }
                        else
                        {
                            tbxItemAmount.Style["display"] = "none";
                            itemAmount.Style["display"] = "";
                            itemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true);
                        }


                        //itemAmount.Text = Util.NumberFormat(dr["FinancialItemAmount"].AsDouble(0.00), 2, -2, -2, -2, true);
                    }
                }

                //</CODE_TAG_104523>
                break;
            default:
                break;
        }
    }

    public void Save(int quoteId, int revision, string customerNo)
    {
        CheckBox chk;
        for (int i = 0; i < rptFinancials.Items.Count; i++)
        {
            chk = rptFinancials.Items[i].FindControl("chkNotApplicable") as CheckBox;

            if (chk != null && chk.Visible)
            {
                //int itemId = chk.Attributes["FinancialItemid"].AsInt();
                //DAL.Quote.Quote_Save_CustomerFinancialItem(quoteId, revision, customerNo, itemId, (chk.Checked)?1:2);

                //<CODE_TAG_104119>
                int itemId;
                TextBox tbx;
                tbx = rptFinancials.Items[i].FindControl("tbxFinancialsItemAmount") as TextBox;
                if (tbx != null && tbx.Visible)
                {
                    itemId = tbx.Attributes["FinancialItemid"].AsInt();
                    decimal? financialItemAmtByManual;
                    financialItemAmtByManual = Convert.ToDecimal(tbx.Text);

                    //if (chk.Checked) financialItemAmtByManual = 0;
                    DAL.Quote.Quote_Save_CustomerFinancialItem(quoteId, revision, customerNo, itemId, (chk.Checked) ? 1 : 2, financialItemAmtByManual);
                }
                else
                {
                    itemId = chk.Attributes["FinancialItemid"].AsInt();
                    DAL.Quote.Quote_Save_CustomerFinancialItem(quoteId, revision, customerNo, itemId, (chk.Checked) ? 1 : 2);
                }
                //</CODE_TAG_104119>
            }


        }
    }
}

