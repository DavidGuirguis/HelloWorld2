using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Net.Mime;

public partial class PDFEmailGen : UI.Abstracts.Pages.Plain//   Popup 
{
    
  protected void Page_Load(object sender, EventArgs e)
    {
        if (!(Page.IsPostBack))
        {
            CreatePDF();
        }
    }

    protected void CreatePDF()
    {

        string iEmail = Request.QueryString["SendEmail"];
        string sQuoteNo = Request.QueryString["QuoteNo"];
        string sQuoteFN = Request.QueryString["sQuoteFN"];
        string curCustomerName = Request.QueryString["curCustomerName"];
        string xmlFilePath = Server.MapPath("/") + "PDFGenDocs\\" + sQuoteFN + "_xml.txt";
        string xmlText = "";

        TextReader tr = new StreamReader(xmlFilePath);

        while (tr.Peek() != -1)
        {
            xmlText = xmlText + tr.ReadLine();
        }
        tr.Close();

        redcloud.WSPDF pdfGeneratorClient = new redcloud.WSPDF();
        pdfGeneratorClient.Credentials = System.Net.CredentialCache.DefaultCredentials;
        byte[] pdfOutput = pdfGeneratorClient.PDFFileByXML(Server.MapPath("~/Library/xml/xsl/Quote.xsl"), xmlText);

        FileStream fs;
        string filePath = Server.MapPath("/") + "PDFGenDocs\\" + sQuoteFN + ".pdf";
        fs = File.Create(filePath);
        fs.Write(pdfOutput, 0, pdfOutput.Length);

        if (iEmail == "1")
        {
            //hlPDF.NavigateUrl = filePath; //Server.MapPath("/") + "PDFGenDocs\\" + sQuoteFN + ".pdf";
            hlPDF.NavigateUrl = "/PDFGenDocs/" + sQuoteFN + ".pdf";
            hlPDF.Text = "<img src='../../library/images/btnPDF.gif' border='0' alt='View PDF file' align='absmiddle'  /> " + sQuoteFN + ".pdf";

            tbTo.Text = Request.QueryString["sToEmail"];
            //tbSubject.Text = "Quote: " + sQuoteFN;
            tbSubject.Text = string.Format(AppContext.Current.AppSettings["psQuoter.Document.Email.Subject"], sQuoteNo, curCustomerName);

          

        }
        else
        {
            phForm.Visible = false;
            
            Response.Write("<embed src='/PDFGenDocs/" + sQuoteFN + ".pdf' width=\"100%\" height=\"100%\" ></embed>");
            Response.Write("<noembed>Please install Acrobat add-on</noembed>");
        }

        fs.Flush();
        fs.Close();

        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Document.Email.SendToCurrentUser") && iEmail == "1")
        {
            tbTo.Text = AppContext.Current.User.LogonUser.EMail;

             SendEmail();

        }
    }

protected void BtnSend(object sender, EventArgs e)
{
    SendEmail();
}


    protected void SendEmail()
{

    phResult.Visible = true;
    phForm.Visible = false;

    string strFirstName = "";
    string strLastName = "";
    string sToEmail = "";
    string sCcEmail = "";
    string sFromEmail = "";
    string sQuoteNo = "";
    string sPdf = "";
    string sQuoteFN = "";
    string sSubject = "";

    sQuoteNo = Request.QueryString["QuoteNo"];
    sQuoteFN = Request.QueryString["sQuoteFN"];

    sPdf = hlPDF.NavigateUrl;

    strFirstName = Request.QueryString["strFirstName"];
    sToEmail = tbTo.Text.Trim();
    sFromEmail = Request.QueryString["sFromEmail"];
    sSubject = tbSubject.Text.Trim();
    try
    {
        SendEmailAttachment(strFirstName, sFromEmail, tbTo.Text.Trim(), tbCC.Text.Trim(), sSubject, tbBody.Text.Trim(), sPdf);

        Response.Write("<table>");
        Response.Write("<tr><td><img src=\"../../library/images/SendEmail.gif\"></td><td>Your email has been sent.</td></tr>");
        Response.Write("<tr><td align=\"center\" colspan=\"2\"><button onclick=\"window_close()\">Close Window</button></td></tr>");
        Response.Write("</table>");

    }
    catch(Exception e)
    {
        Response.Write("<table>");
        Response.Write("<tr><td><img src=\"../../library/images/Error.png\"></td><td>Failed to send PDF file test.</td></tr>");
        
        Response.Write("<tr><td align=\"center\" colspan=\"2\"><button onclick=\"window_close()\">Close Window</button></td></tr>");
        Response.Write("</table>");
    }

}

protected void SendEmailAttachment(string sFromName, string sFromEmail, string sToEmail, string sCcEmail, string sSubject, string sMessage, string sAttachments)
{

    string sTo = sToEmail.Trim();
    string sCc = sCcEmail.Trim();
    string [] aAttachments;
    char [] separator = new char[1];
    separator[0] = ',';
    int i = 0;
    string sFileName = "";
    int iPos = 0;

    if (sTo != "")
    {
        string mailFrom ;

        if (AppContext.Current.AppSettings["psQuoter.Document.Email.From.Source"].Trim() == "2")
            mailFrom = System.Configuration.ConfigurationManager.AppSettings["mail.from"];
        else
            mailFrom = sFromEmail;
       
       
        MailMessage mail = new MailMessage( mailFrom, sToEmail);

        mail.Subject = sSubject;
        
        if (sCc!="")
        {
            mail.CC.Add(sCc);
        }

        mail.Body = sMessage;

        aAttachments = sAttachments.Split(separator[0]);

        if (aAttachments.Length >= 1)
        {
            for (i = 0; i < aAttachments.Length;i++ )
            {
                sAttachments = aAttachments[i].Trim();
                sFileName =  sAttachments.Replace("/", "\\");
                iPos = sFileName.IndexOf("\\");

                if (iPos != 0)
                {
                    sFileName = sFileName.Substring(0, iPos);
                }

                //attachments
                if (sAttachments!="")
                {
                    //Attachment attachPDF = new Attachment("/PDFGenDocs/" + Request.QueryString["sQuoteFN"] + ".pdf", MediaTypeNames.Application.Pdf);
                    Attachment attachPDF = new Attachment(Server.MapPath("/") + "PDFGenDocs\\" + Request.QueryString["sQuoteFN"] + ".pdf", MediaTypeNames.Application.Pdf);
                    mail.Attachments.Add(attachPDF);
                }
            }
        }

        //send the email
        System.Net.Mail.SmtpClient msgClient = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"]);
        msgClient.Send(mail);
        msgClient = null;

    }

}






}

