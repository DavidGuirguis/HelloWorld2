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

public partial class Modules_Quote_Controls_PrintConfig: System.Web.UI.UserControl
{
    int quoteId = 0;
    int revision = 1;

    protected void Page_Load(object sender, EventArgs e)
    {
        quoteId = Request.QueryString["QuoteId"].AsInt(0);
        revision = Request.QueryString["revision"].AsInt(1);
        if (quoteId == 0)
            btnBack.Visible = false;
        if (!IsPostBack)
        {
            BindData();
            if (quoteId == 0)
            {
                btnSave.Visible = false;
                btnDealershipConfig.Visible = false;
                btnUserConfig.Visible = false;
            }
        }
    }

    public void BindData()
    {
       

        DataSet ds = DAL.Quote.Quote_Get_PrintConfig(quoteId );
        IDictionary<string, IEnumerable<DataRow>> rowsSet = ds.ToDictionary() ;


        repCustomerSegment.DataSource = rowsSet["CustomerSegmentConfig"];
        repCustomerSegment.DataBind();

        var customerParts = from myRow in rowsSet["CustomerSegmentDetailConfig"] 
                      where myRow.Field<System.Int16 >("categoryId")  == 1
                      select myRow ;
        repCustomerParts.DataSource = customerParts;
        repCustomerParts.DataBind() ;

        var customerLabor = from myRow in rowsSet["CustomerSegmentDetailConfig"]
                            where myRow.Field<System.Int16>("categoryId") == 2
                            select myRow;
        repCustomerLabor.DataSource = customerLabor;
        repCustomerLabor.DataBind();

        var customerMisc = from myRow in rowsSet["CustomerSegmentDetailConfig"]
                            where myRow.Field<System.Int16>("categoryId") == 3
                            select myRow;
        repCustomerMisc.DataSource = customerMisc;
        repCustomerMisc.DataBind();




        repInternalSegment.DataSource = rowsSet["InternalSegmentConfig"];
        repInternalSegment.DataBind();

        var internalParts = from myRow in rowsSet["InternalSegmentDetailConfig"]
                            where myRow.Field<System.Int16>("categoryId") == 1
                            select myRow;
        repInternalParts.DataSource = internalParts;
        repInternalParts.DataBind();

        var internalLabor = from myRow in rowsSet["InternalSegmentDetailConfig"]
                            where myRow.Field<System.Int16>("categoryId") == 2
                            select myRow;
        repInternalLabor.DataSource = internalLabor;
        repInternalLabor.DataBind();

        var internalMisc = from myRow in rowsSet["InternalSegmentDetailConfig"]
                           where myRow.Field<System.Int16>("categoryId") == 3
                           select myRow;
        repInternalMisc.DataSource = internalMisc;
        repInternalMisc.DataBind();

        if (rowsSet.ContainsKey("SegmentDetail"))
        {
            divCustomerSegment.Visible = true;
            DataRow drSegmentDetail = rowsSet["SegmentDetail"].FirstOrDefault();
            if (drSegmentDetail["CustomerPrintHideSegmentDetail"].ToString() == "2")
                rdoCustomerSegmentHide.Checked = true;
            else
                rdoCustomerSegmentShow.Checked = true;


            if (drSegmentDetail["InternalPrintHideSegmentDetail"].ToString() == "2")
                rdoInternalSegmentHide.Checked = true;
            else
                rdoInternalSegmentShow.Checked = true; 

        }
        else
        {
            divCustomerSegment.Visible = false;
            divInternalSegment.Visible = false;
        }
    }

    public void SaveData()
    {
        int customerPrintHideSegmentDetail = 0;
        int internalPrintHideSegmentDetail = 0;

        if (quoteId > 0)
        {
            if (rdoCustomerSegmentHide.Checked) customerPrintHideSegmentDetail = 2;
            if (rdoInternalSegmentHide.Checked) internalPrintHideSegmentDetail = 2;
        }
        DAL.Quote.Quote_Save_PrintConfig(quoteId, hidRtValue.Value, customerPrintHideSegmentDetail, internalPrintHideSegmentDetail);



    }

    protected void repSegment_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Label tempLabel;
        HiddenField tempHiddenField;
        Literal tempLiteral;
        CheckBox tempCheckBox;
        DataRow dr;
        switch (e.Item.ItemType)
        {
            case ListItemType.Item:
            case ListItemType.AlternatingItem:
                dr = (DataRow)e.Item.DataItem;
                tempLabel = (Label)e.Item.FindControl("lblDisplayName");
                tempLabel.Text = dr["DisplayName"].ToString();

                tempHiddenField = (HiddenField)e.Item.FindControl("hidColumnId");
                tempHiddenField.Value = dr["configId"].ToString();

                tempHiddenField = (HiddenField)e.Item.FindControl("hidColumnName");
                tempHiddenField.Value = dr["ConfigKey"].ToString().HtmlEncode( );

                

                tempLiteral = (Literal)e.Item.FindControl("litLiId");
                tempLiteral.Text = dr["configId"].ToString();

                tempLiteral = (Literal)e.Item.FindControl("litGroupType");
                tempLiteral.Text = dr["groupType"].ToString();


                tempCheckBox = (CheckBox)e.Item.FindControl("chkDisplay");
                if (dr["configValue"].AsInt(0) == 2)
                    tempCheckBox.Checked = true;
                else
                    tempCheckBox.Checked = false;

                break;
        }
    }

    protected void repDetail_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Label tempLabel;
        HiddenField tempHiddenField;
        CheckBox tempCheckBox;
        Literal tempLiteral;
        DataRow dr;
        switch (e.Item.ItemType)
        {
            case ListItemType.Item:
            case ListItemType.AlternatingItem:
                dr = (DataRow)e.Item.DataItem;
                tempLabel = (Label)e.Item.FindControl("lblDisplayName");
                tempLabel.Text = dr["DisplayName"].ToString();

                tempHiddenField = (HiddenField)e.Item.FindControl("hidColumnId");
                tempHiddenField.Value = dr["ColumnId"].ToString();

                tempLiteral = (Literal)e.Item.FindControl("litLiId");
                tempLiteral.Text = dr["ColumnId"].ToString();

                tempHiddenField = (HiddenField)e.Item.FindControl("hidColumnName");
                tempHiddenField.Value = dr["ColumnName"].ToString().HtmlEncode();


                tempCheckBox = (CheckBox)e.Item.FindControl("chkDisplay");
                if (dr["Show"].AsInt(1) == 2)
                    tempCheckBox.Checked = true;
                else
                    tempCheckBox.Checked = false;


                break;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveData();
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("Quote_Document.aspx?quoteId=" + quoteId + "&Revision=" + revision);
    }

    protected void btnDealershipConfig_Click(object sender, EventArgs e)
    {
        DAL.Quote.Quote_Save_PrintConfig_Reset(quoteId, 1);
        BindData();
    }

    protected void btnUserConfig_Click(object sender, EventArgs e)
    {
        DAL.Quote.Quote_Save_PrintConfig_Reset(quoteId, 0);
        BindData();
    }
}