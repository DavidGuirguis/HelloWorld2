using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Entities;
using X.Extensions;
using System.Data;
using X.Web.Extensions;
using Helpers;

public partial class ImportXMLDetails : UI.Abstracts.Pages.Plain
{
    int segmentId = 0;
    int globalIndex = 0;
    protected int HasLaborDetail = 1;
    protected int HasMiscDetail = 1;
    protected string LaborChargeCodeList = "";
    protected string MiscChargeCodeList = "";
    DataSet ds;
    IDictionary<string, IEnumerable<DataRow>> RowsSet, DocumentRowsSet;
    char spiltChar = (char)5;
    protected void Page_Load(object sender, EventArgs e)
    {

        segmentId = Request.QueryString["SegmentId"].AsInt(0);

        //ds = DAL.Quote.QuoteGetSegmentPendingDetails(segmentId);
        //<CODE_TAG_101832>
        string strIsRepriceRequired = Request.QueryString["IsRepriceRequired"].AsString();
        if (strIsRepriceRequired=="2")
            ds = DAL.Quote.QuoteGetSegmentRepriceRequiredList(segmentId);
        else
            ds = DAL.Quote.QuoteGetSegmentPendingDetails(segmentId);
        
        //</CODE_TAG_101832>

        RowsSet = ds.ToDictionary();

        if (RowsSet.ContainsKey("LaborChargeCode"))
        {
            foreach (DataRow dr in RowsSet["LaborChargeCode"])
            {
                if (LaborChargeCodeList != "") LaborChargeCodeList += spiltChar.ToString();
                LaborChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + Server.HtmlEncode(dr["chargeCodeDesc"].ToString()) + "," + Util.NumberFormat(dr["CRTR"].AsDouble(0), 2, null, null, null, true) + "," + Util.NumberFormat(dr["COTR"].AsDouble(0), 2, null, null, null, true) + "," + Util.NumberFormat(dr["CPTR"].AsDouble(0), 2, null, null, null, true) + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString(); 
            }
        }



        
        if (RowsSet.ContainsKey("MiscChargeCode"))
        {
            foreach (DataRow dr in RowsSet["MiscChargeCode"])
            {
                if (MiscChargeCodeList != "") MiscChargeCodeList += spiltChar.ToString();
                MiscChargeCodeList += dr["ChargeCode"].ToString() + "," + dr["ChargeCode"].ToString() + "-" + Server.HtmlEncode(dr["chargeCodeDesc"].ToString()) + "," + Util.NumberFormat(dr["unitPrice"].AsDouble(0), 2, null, null, null, true) + "," + Util.NumberFormat(dr["unitCost"].AsDouble(0), 2, null, null, null, true) + "," + dr["StoreNo"].ToString() + "," + dr["CSCC"].ToString() + "," + dr["percentRate"].ToString(); 
            }
        }


        if (RowsSet.ContainsKey("Labor"))
        {
            HasLaborDetail = 2;
            rptLabor.DataSource = RowsSet["Labor"];
            rptLabor.DataBind();
        }

        
        if (RowsSet.ContainsKey("Misc"))
        {
            HasMiscDetail = 2;
            rptMisc.DataSource = RowsSet["Misc"];
            rptMisc.DataBind();
        }

        hdnChargeCodeDisplay.Value = AppContext.Current.AppSettings["psQuoter.Quote.ChargeCodeDisplay"].AsString("");  //0: display ChargeCode-CustomerClassCode-StoreNo-CostCenterCode (default) 1: ChargeCodeOnly    <CODE_TAG_105100>  lwang


    }

    


}


