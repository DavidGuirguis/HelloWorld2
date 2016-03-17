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
using System.Text;

public partial class quoteSegmentSearch : UI.Abstracts.Pages.Plain
{
    protected int SegmentId= 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        SegmentId = Request.QueryString["SegmentId"].AsInt(0); 
        if (!Page.IsPostBack)
        {
            var ds = DAL.Quote.QuoteGetSegmentCustomer(SegmentId);
          
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                lblPartsCustomer.Text = dr["partsCustomerNo"].ToString() + " - " + dr["partsCustomerName"].ToString();
                hidPartsCustomerNo.Value = dr["partsCustomerNo"].ToString();
                txtPartsPercent.Text = dr["partsPercent"].ToString();

                lblLaborCustomer.Text = dr["laborCustomerNo"].ToString() + " - " + dr["laborCustomerName"].ToString();
                hidLaborCustomerNo.Value = dr["laborCustomerNo"].ToString();
                txtLaborPercent.Text = dr["laborPercent"].ToString();

                lblMiscCustomer.Text = dr["miscCustomerNo"].ToString() + " - " + dr["miscCustomerName"].ToString();
                hidMiscCustomerNo.Value = dr["miscCustomerNo"].ToString();
                txtMiscPercent.Text = dr["miscPercent"].ToString();

             //   Response.Write(txtPartsPercent.Text); Response.End();
            }

        }

    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
      // Response.Write(hidPartsCustomerNo.Value.Length); Response.End();
        DAL.Quote.EditSegmentCustomer(  SegmentId,
                                        hidPartsCustomerNo.Value,
                                        txtPartsPercent.Text.AsDouble(0),
                                        hidLaborCustomerNo.Value,
                                        txtLaborPercent.Text.AsDouble(0),
                                        hidMiscCustomerNo.Value,
                                        txtMiscPercent.Text.AsDouble(0)
                                      );
        hidRefreshParent.Value = "1";
    }
}
