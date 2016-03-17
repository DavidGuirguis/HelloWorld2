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


public partial class Modules_Quote_Document : UI.Abstracts.Pages.ReportViewPage  
{
    protected int QuoteId;
    protected int Revision;
    protected int PageMode = 3;
    protected int SegmentId;
    protected string strCurrentEditFileId = "";
    protected bool CanModify = false;

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
 
    protected void btnEdit_Click(object sender, EventArgs e)
    {
        Button btnEdit = (Button)sender;
        strCurrentEditFileId = btnEdit.Attributes["fileID"];
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        int fileId = btn.Attributes["fileId"].AsInt();
        Button tempButton;

        for (int i = 0; i < repDocuments.Items.Count; i++)
        {
            tempButton = (Button)repDocuments.Items[i].FindControl("btnSave");
            if (tempButton != null)
            {
                if (tempButton.Attributes["fileId"].AsInt() == fileId)
                {
                    TextBox tempTextBox = (TextBox)repDocuments.Items[i].FindControl("txtDescription");
                    string fileDescription = tempTextBox.Text.Trim();
                    DAL.Quote.QuoteDocumentEdit(fileId, fileDescription);
                }
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        Button btnEdit = (Button)sender;
        int fileId = btnEdit.Attributes["fileID"].AsInt();
        DAL.Quote.QuoteDocumentDelete(fileId);

    }

    protected void btnfpUpload_Click(object sender, EventArgs e)
    {
        if (fuDocument.HasFile)
        {
            string fileName =  Path.GetFileName(fuDocument.FileName);
            byte[] byteFile = fuDocument.FileBytes;
            long fileSize = fuDocument.FileBytes.Length;
            DAL.Quote.QuoteDocumentAddNew(QuoteId, Revision,  byteFile, fileName, fileSize,  txtDescription.Text.Trim());

        }
    }

    private void Page_PreRender(object sender, System.EventArgs e)
    {
        DataSet dsCustomer = DAL.Quote.Quote_Get_PrintCustomer(QuoteId, Revision);
        repCustomers.DataSource = dsCustomer.Tables[0];
        repCustomers.DataBind();
        
        dsQuote = DAL.Quote.QuoteDetailGet(QuoteId, Revision, PageMode, SegmentId,false);
        RowsSet = dsQuote.ToDictionary();


        if (RowsSet.ContainsKey("QuoteHeader"))
        {
            DataRow drHeader = RowsSet["QuoteHeader"].FirstOrDefault();
            HttpContext.Current.Items.Add("Global_CanModifyQuote", drHeader["CanModify"].AsInt());
            CanModify = drHeader["CanModify"].AsInt(0) == 2;
        }
        

        //Header
        quoteHeader.Bind(PageMode, RowsSet );
        if (RowsSet.ContainsKey("QuoteDocument"))
        {
            repDocuments.DataSource = RowsSet["QuoteDocument"];
            repDocuments.DataBind();
        }else
        {
            repDocuments.DataSource = null;
            repDocuments.DataBind();
        }
        if ( ! CanModify) // ! AppContext.Current.User.Operation.CreateQuote)
            btnfpNew.Visible = false;
    }

    protected void repDocuments_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRow dr;
        TextBox tempTextBox;
        Label tempLabel;
        Button tempButtonEdit, tempButtonDelete, tempButtonSave, tempButtonCancel;
        //LinkButton tempLinkbutton;

        switch (e.Item.ItemType)
        {
            case ListItemType.Item:
            case ListItemType.AlternatingItem:

                dr = (DataRow)e.Item.DataItem;

                tempLabel = (Label)e.Item.FindControl("lblDescription");
                tempTextBox = (TextBox)e.Item.FindControl("txtDescription");
                tempButtonEdit = (Button)e.Item.FindControl("btnEdit");
                tempButtonDelete = (Button)e.Item.FindControl("btnDelete");
                tempButtonSave = (Button)e.Item.FindControl("btnSave");
                tempButtonCancel = (Button)e.Item.FindControl("btnCancel");

                if (dr["imageId"].ToString() == strCurrentEditFileId)
                {
                    tempTextBox.Visible = true;
                    tempLabel.Visible = false;
                    tempButtonEdit.Visible = false;
                    tempButtonDelete.Visible = false;
                    tempButtonSave.Visible = true;
                    tempButtonCancel.Visible = true;
                }
                else
                {
                    tempTextBox.Visible = false;
                    tempLabel.Visible = true;
                    tempButtonEdit.Visible = true;
                    tempButtonDelete.Visible = true;
                    tempButtonSave.Visible = false;
                    tempButtonCancel.Visible = false;
                }


                tempButtonEdit.Attributes["fileID"] = dr["imageId"].ToString();
                tempButtonDelete.Attributes["fileID"] = dr["imageId"].ToString();
                tempButtonSave.Attributes["fileID"] = dr["imageId"].ToString();
                tempButtonCancel.Attributes["fileID"] = dr["imageId"].ToString();

                break;
        }
    }

    protected void btnFileDownload_Click(Object sender, EventArgs e)
    {
        int fileId = hdnDownloadFileId.Value.AsInt();

        DataSet ds = DAL.Quote.QuoteDocumentGet(fileId);
        if (ds.Tables[0].Rows.Count > 0)
        {
            DataRow dr = ds.Tables[0].Rows[0];
            byte[] fileData = (byte[])dr["FileImage"];
            string fileName = dr["FileName"].ToString();
            string fileExtName = Path.GetExtension(fileName).Replace(".", "");
            Response.ClearContent();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.ContentType = ReturnExtension(fileExtName);
            BinaryWriter bw = new BinaryWriter(Response.OutputStream);
            bw.Write(fileData);
            bw.Close();
            Response.End();
        }
    }

    private string ReturnExtension(string fileExtension)
    {
        switch (fileExtension)
        {
            case ".htm":
            case ".html":
            case ".log":
                return "text/HTML";
            case ".txt":
                return "text/plain";
            case ".doc":
                return "application/ms-word";
            case ".tiff":
            case ".tif":
                return "image/tiff";
            case ".asf":
                return "video/x-ms-asf";
            case ".avi":
                return "video/avi";
            case ".zip":
                return "application/zip";
            case ".xls":
            case ".csv":
                return "application/vnd.ms-excel";
            case ".gif":
                return "image/gif";
            case ".jpg":
            case "jpeg":
                return "image/jpeg";
            case ".bmp":
                return "image/bmp";
            case ".wav":
                return "audio/wav";
            case ".mp3":
                return "audio/mpeg3";
            case ".mpg":
            case "mpeg":
                return "video/mpeg";
            case ".rtf":
                return "application/rtf";
            case ".asp":
                return "text/asp";
            case ".pdf":
                return "application/pdf";
            case ".fdf":
                return "application/vnd.fdf";
            case ".ppt":
                return "application/mspowerpoint";
            case ".dwg":
                return "image/vnd.dwg";
            case ".msg":
                return "application/msoutlook";
            case ".xml":
            case ".sdxl":
                return "application/xml";
            case ".xdp":
                return "application/vnd.adobe.xdp+xml";
            default:
                return "application/octet-stream";
        }
    }
    protected void linkPrintConfig_Click(object sender, EventArgs e)
    {
        Response.Redirect("Quote_Document_printConfig.aspx?quoteId=" + QuoteId + "&Revision=" + Revision);
    }
}

