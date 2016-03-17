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


public partial class Modules_Quote_Document : UI.Abstracts.Pages.ReportViewPage  
{
    protected int QuoteId;
    protected int Revision;
    protected int PageMode = 3;
    protected int SegmentId;
    protected string strCurrentEditFileId = "";
    
    DataSet dsQuote, dsDocuments;
    IDictionary<string, IEnumerable<DataRow>> RowsSet, DocumentRowsSet;

    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Quote";
        QuoteId = Request.QueryString["QuoteId"].AsInt();
        Revision = Request.QueryString["Revision"].AsInt();
        SegmentId = Request.QueryString["SegmentId"].AsInt();
        
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
    }

}