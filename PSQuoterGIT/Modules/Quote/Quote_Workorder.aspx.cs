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
using X.Web.UI.WebControls;
using Entities;
using System.IO;
using System.Configuration; //<CODE_TAG_103717>


public partial class Modules_Quote_Workorder : UI.Abstracts.Pages.ReportViewPage  
{
    protected int QuoteId;
    protected int Revision;
    protected int PageMode = 4;
    protected int SegmentId;
    protected string strCurrentEditFileId = "";
    protected int SystemId= 1;
    protected string WOno = "";
    protected string WOUrl = string.Empty; //<CODE_TAG_101885>
   

    DataSet dsQuote, dsDocuments;
    IDictionary<string, IEnumerable<DataRow>> RowsSet, DocumentRowsSet;

    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Quote";
        QuoteId = Request.QueryString["QuoteId"].AsInt();
        Revision = Request.QueryString["Revision"].AsInt();
        SegmentId = Request.QueryString["SegmentId"].AsInt();

        SystemId = AppContext.Current.SystemId ;
        //<CODE_TAG_101885>
        if (AppContext.Current.AppSettings["psQuoter.Quote.WO.Page.Source"] == "EquipmentLink") //to toronmont points
        {
            WOUrl = "AppLink/EquipmentLink/Modules/equipment/workorder/wo_drill.aspx?TT=iframe&WONO=" + WOno;
        }
        else //to default url
        {
            WOUrl = "Library/SharedModules/equipment/workorder/wo_drill.asp?TT=iframe&WONO=" + WOno;
            
        }
        //</CODE_TAG_101885>
        if (!IsPostBack)
        {
        }
    }
 
    private void Page_PreRender(object sender, System.EventArgs e)
    {
        dsQuote = DAL.Quote.QuoteDetailGet(QuoteId, Revision, PageMode, SegmentId,false);
        RowsSet = dsQuote.ToDictionary();

        //Header
        quoteHeader.Bind(PageMode, RowsSet );

        foreach (DataRow dr in RowsSet["QuoteRevision"])
        {
            if (dr["CurrentRevision"].AsInt(0) == 2)
                WOno = dr["WONO"].ToString();
        }
        WOUrl = ConfigurationManager.AppSettings["url.siteRootPath"] + WOUrl + WOno;//<CODE_TAG_103717>
        
    }

}

