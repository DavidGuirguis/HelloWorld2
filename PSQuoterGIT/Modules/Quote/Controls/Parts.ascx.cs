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

public partial class Modules_Quote_Controls_Parts: System.Web.UI.UserControl
{
    protected bool SegmentEdit = false;
    public string CurrentBranchCode = "";//<CODE_TAG_102235>
    protected void Page_Load(object sender, EventArgs e)
    {
        TextBox tempTextBox;
        HiddenField tempHiddenField;
        int itemId = 0 ;
        string sos ="";
        string partNo ="";
        int quantity= 1;
        string description="";
        double unitPrice = 0;
        double discount = 0;
        
        if (Request.QueryString["SegmentEdit"].AsInt(0) == 1 &&  AppContext.Current.User.Operation.CreateQuote)
            SegmentEdit = true;
    }
    public void Bind(List<Part> listParts, string partFlatRateInd, double partFlatRateAmount, bool autoPartsCalculate, bool SegmentEditble)  
    {
        if (SegmentEditble)
        {
           litPartsList.Text = PartUtil.GetEditHtml(listParts, partFlatRateInd, partFlatRateAmount, autoPartsCalculate);
 
        }
        else
        {
            litPartsList.Text = PartUtil.GetReadonlyHtml(listParts, partFlatRateInd, partFlatRateAmount);
            
        }
    }
}

