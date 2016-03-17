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

public partial class Modules_Quote_Controls_Labor: System.Web.UI.UserControl
{
    protected bool SegmentEdit = false;
    public int IsRepriceRequired = 1;//1:no 2:required //!<CODE_TAG_101832>
    public int hasPendingLabor = 0; //0:no 2:yes //<CODE_TAG_104809>

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["SegmentEdit"].AsInt(0) == 1 && AppContext.Current.User.Operation.CreateQuote)
            SegmentEdit = true;
    }
    public void Bind(List<Labor> listlabor, string laborFlatRateInd, double laborFlatRateAmount, double laborFlatRateQty, bool autoLaborCalculate, bool SegmentEditble)  
    {

        if (SegmentEditble)
        {
            //TODO, get total hours from DB
            litLaborList.Text = LaborUtil.GetEditHtml(listlabor, laborFlatRateInd, laborFlatRateAmount, laborFlatRateQty, autoLaborCalculate);
        }
        else
        {
            //litLaborList.Text = LaborUtil.GetReadonlyHtml(listlabor, laborFlatRateInd, laborFlatRateAmount);
            litLaborList.Text = LaborUtil.GetReadonlyHtml(listlabor, laborFlatRateInd, laborFlatRateAmount, laborFlatRateQty);//<CODE_TAG_103464>
        }
    }

   
}

