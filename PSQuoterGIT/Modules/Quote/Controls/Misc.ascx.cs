using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CATPAI;
using DTO;
using X;
using X.Extensions;
using X.Web.Extensions;
using X.Web.UI.WebControls;
using Entities;

public partial class Modules_Quote_Controls_Misc: System.Web.UI.UserControl
{
    protected bool SegmentEdit = false;
    public int IsRepriceRequired = 1;//1:no 2:required //!<CODE_TAG_101832>
    public int hasPendingMisc = 0; //0:no 2:yes //<CODE_TAG_104809>
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["SegmentEdit"].AsInt(0) == 1 && AppContext.Current.User.Operation.CreateQuote)
            SegmentEdit = true;
    }
    public void Bind(List<Misc> listMisc, string miscFlatRateInd, double miscFlatRateAmount, bool autoMiscCalculate, bool SegmentEditble)  
    {
        if (SegmentEditble)
        {
            litMiscList.Text = MiscUtil.GetEditHtml(listMisc, miscFlatRateInd, miscFlatRateAmount, autoMiscCalculate);
        }
        else
        {
            litMiscList.Text = MiscUtil.GetReadonlyHtml(listMisc, miscFlatRateInd, miscFlatRateAmount);
        }
    }

   
}

